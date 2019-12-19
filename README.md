# Fuchsia Rust SDK

A minimal out-of-the-box Fuchsia SDK for Rust (without complex GN!).

Build and test your Rust programs on Fuchsia OS (Zircon Kernel) right now!!

## Quick start

Dependencies:

* Linux or macOS
* QEMU
* Rust toolchain

Before you start:

```sh
rustup target add x86_64-fuchsia aarch64-fuchsia
```

Build and run:

```sh
# for x86_64
make build  # build Rust project
make run    # run Zircon on QEMU

# for aarch64
make buildarm
make runarm
```

Test your programs:

```sh
...
[00005.462] 01919:01974> vc: Successfully attached to display 1
[00005.474] 01919:01974> vc: new input device /dev/class/input/002
# you need to press Enter here
$ hello
Hello, Zircon!!!
$ 
```

## What's inside the box

We use prebuilt objects from [Fuchsia-VM-20190715](https://fuchsia-china.com/fuchsia-virtual-machine-download/).

### UEFI Bootloader

| Description            | Path                                                 | Source Path                                  |
| ---------------------- | ---------------------------------------------------- | -------------------------------------------- |
| UEFI firmware for QEMU | [prebuilt/OVMF.fd](prebuilt/OVMF.fd)                 | https://www.kraxel.org/repos/jenkins/edk2/   |
| Zircon UEFI Bootloader | [esp/efi/boot/bootx64.efi](esp/efi/boot/bootx64.efi) | out/default.zircon/efi-x64-clang/bootx64.efi |

The bootloader will look for a ZBI-format image (`esp/zircon.bin`) containing kernel and bootfs.

### BootFS and ZBI image

| Description             | Path                                                         | Source Path                             |
| ----------------------- | ------------------------------------------------------------ | --------------------------------------- |
| Zircon and BootFS image | [prebuilt/legacy-image-x64.zbi](prebuilt/legacy-image-x64.zbi) | out/default.zircon/legacy-image-x64.zbi |
| ZBI CLI tool            | [tools/Linux/zbi](tools/Linux/zbi)                           | out/default.zircon/tools/zbi            |

We use `zbi` CLI tool to append all files in `bootfs` dir, to the BOOTFS section of the prebuilt image `legacy-image-x64.zbi`, then put the result to `esp/zircon.bin`.

### User libs

Rust programs for Fuchsia need to link the following libraries:

| Path                                                         | Source Path                                                  |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| [prebuilt/ulib](prebuilt/ulib)/{Scrt1.o, libc.so, libzircon.so} | out/default/sdk/exported/zircon_sysroot/arch/x64/sysroot/lib/* |
| [prebuilt/ulib/libfdio.so](prebuilt/ulib/libfdio.so)         | out/default.zircon/user-x64-clang.shlib/obj/system/ulib/fdio/libfdio.so |
| [prebuilt/ulib/libunwind.so](prebuilt/ulib/libunwind.so)     | prebuilt/third_party/clang/linux-x64/lib/x86_64-unknown-fuchsia/c++/libunwind.so |

## Acknowledgement

Thanks to [@PanQL](https://github.com/PanQL) for the help and deep analysis of Fuchsia project.
