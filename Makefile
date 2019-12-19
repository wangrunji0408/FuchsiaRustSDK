ZBI := tools/${shell uname}/zbi
ESP := esp
QEMU_ARGS := -m 1G -net none -smp cores=4 -nographic
PROJ ?= hello

# workaround for different version of zbi tool on Linux and macOS
ifeq (${shell uname}, Darwin)
	LZ4 := lz4f
else
	LZ4 := lz4
endif

.PHONY: build zbi run zbiarm runarm

# build rust program
build:
	cd ${PROJ} && ARCH=x64 cargo build --target x86_64-fuchsia --release
	mkdir -p bootfs/bin
	mv ${PROJ}/target/x86_64-fuchsia/release/${PROJ} bootfs/bin

buildarm:
	cd ${PROJ} && ARCH=arm64 cargo build --target aarch64-fuchsia --release
	mkdir -p bootfs/bin
	mv ${PROJ}/target/aarch64-fuchsia/release/${PROJ} bootfs/bin

# zip BootFS and generate zircon.bin
zbi:
	${ZBI} --compressed=${LZ4} prebuilt/zbi/legacy-image-x64.zbi --replace bootfs -o esp/zircon.bin

zbiarm:
	${ZBI} --compressed=${LZ4} prebuilt/zbi/legacy-image-arm64.zbi --replace bootfs -o esp/zircon.bin

# run Zircon on QEMU
run: zbi
	qemu-system-x86_64 \
		-bios prebuilt/uefi/X64.fd \
		-drive format=raw,file=fat:rw:${ESP} \
		-serial mon:stdio \
		$(QEMU_ARGS)

runarm: zbiarm
	qemu-system-aarch64 \
		-M virt \
		-cpu cortex-a57 \
		-kernel prebuilt/bootloader/qemu-boot-shim.bin \
		-initrd esp/zircon.bin \
		-serial mon:stdio \
		$(QEMU_ARGS)
