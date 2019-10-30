OVMF := prebuilt/OVMF.fd
ZBI := tools/${shell uname}/zbi
ESP := esp
QEMU_ARGS := -m 1G -net none -smp cores=4 -nographic
PROJ ?= hello

.PHONY: build zbi run

# build rust program
build:
	cd ${PROJ} && cargo build --target x86_64-fuchsia
	mkdir -p bootfs/bin
	mv ${PROJ}/target/x86_64-fuchsia/debug/${PROJ} bootfs/bin

# zip BootFS and generate zircon.bin
zbi:
	${ZBI} --compressed=lz4f prebuilt/legacy-image-x64.zbi --replace bootfs -o esp/zircon.bin

# run Zircon on QEMU
run: zbi
	qemu-system-x86_64 \
		-bios ${OVMF} \
		-drive format=raw,file=fat:rw:${ESP} \
		-serial mon:stdio \
		$(QEMU_ARGS)
