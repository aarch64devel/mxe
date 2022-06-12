# MXE (M cross environment) - for ARM64 Windows development (UNDER CONSTRUCTION - DO NOT USE YET)

This is a modified version of MXE that comes with fixed scripts and sources that way Windows on ARM64 can have development for it. 

MXE (M cross environment) is a GNU Makefile that compiles a cross
compiler and cross compiles many free libraries such as SDL and
Qt. Thus, it provides a nice cross compiling environment for
various target platforms, which:

  * is designed to run on any Unix system
  * is easy to adapt and to extend
  * builds many free libraries in addition to the cross compiler
  * can also build just a subset of the packages, and automatically builds their dependencies
  * downloads all needed packages and verifies them by their checksums
  * is able to update the version numbers of all packages automatically
  * directly uses source packages, thus ensuring the whole build mechanism is transparent
  * allows inter-package and intra-package parallel builds whenever possible
  * bundles [ccache](https://ccache.samba.org) to speed up repeated builds
  * integrates well with autotools, cmake, qmake, and hand-written makefiles.
  
## Supported Toolchains

  * Runtime: Clang disguised as MinGW-w64
  * Host Triplets:
    - `aarch64-w64-mingw32`
    
This version of MXE is meant for specifically WoA64 porting only, so some packages will not build properly (Especially being that MinGW in this repo is NOT GCC. It is Clang). For ARMv7 development, head over to [the armdevvel development repos](https://github.com/armdevvel/mxe) 

## Setting up

To use this for ARM development easily, first clone this repository to your home directory on any Linux system. [Be sure you have the dependencies installed from the site already](https://mxe.cc). Then, download a zip of the current release of LLVM-MinGW (preferably from [here](https://github.com/aarch64devel/llvm-mingw/releases)). CD to the MXE folder. Make a directory in the MXE directory called "usr". If you're new to this stuff, /usr is not related to /home/user/youruser/mxe, so don't worry about Linux confusing these. Extract LLVM-MinGW to the usr folder of MXE. Make sure you see aarch64-w64-mingw32, bin, lib, and include in the MXE "usr" folder. You should see something like this.

![MXEs usr folder](images/mxeusr3.png?raw=true)

Once done, you can run a make command to build all known working WoA libraries. CD back to the root dir of MXE and run the following.

`make libpng cmake tiff jpeg ccache lame libxml++ libxml2 libyaml libzip libwebp libusb1 zlib yasm dbus pcre boost icu4c`

(or if you want to just set it up in one command and already have the Linux dependencies installed, just run this long command (lol) --

-- `cd ~ && git clone https://github.com/aarch64devel/mxe --depth=1 arm64mxe && cd arm64mxe && mkdir usr && cd usr && wget https://github.com/aarch64devel/llvm-mingw/releases/download/14.0/aarch64-only-llvm-mingw-linux-x86_64.tar.xz && tar -xf aarch64-only-llvm-mingw-linux-x86_64.tar.xz && cd .. && make libpng cmake tiff jpeg ccache lame libxml++ libxml2 libyaml libzip libwebp libusb1 zlib yasm dbus pcre boost icu4c && echo $'\n' >> ~/.bashrc && echo "export PATH=/home/$USER/arm64mxe/usr/bin"':$PATH' >> ~/.bashrc` )

(or, if you would rather use a script, you can use the sh script included for Ubuntu! -- 

-- `wget https://raw.githubusercontent.com/aarch64devel/mxe/master/mxe-ubuntu-install.sh && sh ./mxe-ubuntu-install.sh` )

You should be good to go now! Go have fun with your heart's desires building what you can/please. If there's issues, never be afraid to ask for help by opening an issue.

## Building (configuring) with each build system

  * autoconfigure:
    - use `./configure --host=aarch64-w64-mingw32 --prefix=/home/youruser/arm64mxe/usr/aarch64-w64-mingw32`
  * meson: 
    - use included cross.txt and use as so - `meson --cross-file=/home/youruser/arm64mxe/cross.txt --prefix /home/youruser/arm64mxe/usr/aarch64-w64-mingw32/ builddir`
  * CMake:
    - use `aarch64-w64-mingw32-cmake` provided by MXE
  * normal make:
    - for projects that still use this way for some reason, use `make CC=aarch64-w64-mingw32-gcc CXX=aarch64-w64-mingw32-g++ LD=aarch64-w64-mignw32-ld AR=aarch64-w64-mingw32-ar AS=aarch64-w64-mingw32-as`
  * MXE:
    - this stays the same, but instead of a host triplet being i686-w64-mingw32 or x86_64-w64-mingw32, you use aarch64-w64-mingw32. basically, run `make MXE_TARGETS="aarch64-w64-mingw32" package`

## Things you should probably know

When you build applications and run them on Windows on ARM (32 or 64), you'll need the UCRT files. It may be included, but some OSes (such as RT8.1) do not have it. For the ARM32 UCRT DLLs, you can snatch them [here](resources/PooCRT.tar.xz).
	
## FAQ

Q: Will this work on WSL?  \
A: Yes! I would *recommend* using Ubuntu 20.04 for this repo if you're using WSL.

Q: Do I need to have a specific distro? \
A: Nope! This is meant for any distro just like the normal MXE, this repo just comes with patches and extras for ARM development.

Q: What if I have trouble with a package while building for ARM64? \
A: You can open an issue here, or try to fix it yourself if you wanted to. This repo is in it's early stages so response will be slow but we'll try and respond ASAP!

Q: What if I have more questions?? \
A: As said, don't be afraid to open an issue for help. If the question is a good one, we will put it here that way more people do not have to dig through issues for help.

Q: So what libraries don't work? (ARM question) \
A: A good chunk - primarily SDL1 (no aarch64 support)/ SDL2 (NEON issue), GTK, libgcrypt (reason unknown atm) and a considerable more

Q: So what libraries DO work? (ARM question) \
A: List of 12/06/2022 - glib, libsigc++, libxml2, libxml+, libgpg_error, bzip2, ccache, dbus, expat, gettext, jpeg, lame, libffi, libiconv, libpng, libsamplerate, libwebp, pcre, tiff, xz, zlib, cmake, icu4c / Others potentially work but have so far not been tested
	
# Original README

## MXE (M cross environment)

[![License][license-badge]][license-page]

[license-page]: LICENSE.md
[license-badge]: https://img.shields.io/badge/License-MIT-brightgreen.svg

[![Async Chat (Trial))](https://img.shields.io/badge/zulip-join_chat-brightgreen.svg)](https://mxe.zulipchat.com/)

MXE (M cross environment) is a GNU Makefile that compiles a cross
compiler and cross compiles many free libraries such as SDL and
Qt. Thus, it provides a nice cross compiling environment for
various target platforms, which:

  * is designed to run on any Unix system
  * is easy to adapt and to extend
  * builds many free libraries in addition to the cross compiler
  * can also build just a subset of the packages, and automatically builds their dependencies
  * downloads all needed packages and verifies them by their checksums
  * is able to update the version numbers of all packages automatically
  * directly uses source packages, thus ensuring the whole build mechanism is transparent
  * allows inter-package and intra-package parallel builds whenever possible
  * bundles [ccache](https://ccache.samba.org) to speed up repeated builds
  * integrates well with autotools, cmake, qmake, and hand-written makefiles.
  * has been in continuous development since 2007 and is used by several projects

## Supported Toolchains

  * Runtime: MinGW-w64
  * Host Triplets:
    - `i686-w64-mingw32`
    - `x86_64-w64-mingw32`
  * Packages:
    - static
    - shared
  * GCC Threading Libraries (`winpthreads` is always available):
    - [posix](https://github.com/mxe/mxe/pull/958) [(default)](https://github.com/mxe/mxe/issues/2258)
    - win32 (supported by limited amount packages)
  * GCC Exception Handling:
    - Default
      - i686: sjlj
      - x86_64: seh
    - [Alternatives (experimental)](https://github.com/mxe/mxe/pull/1664)
      - i686: dw2
      - x86_64: sjlj

Please see [mxe.cc](https://mxe.cc/) for further information and package support matrix.

## Shared Library Notes
There are several approaches to recursively finding DLL dependencies (alphabetical list):
  * [go script](https://github.com/desertbit/gml/blob/master/cmd/gml-copy-dlls/main.go)
  * [pe-util](https://github.com/gsauthof/pe-util) packaged with [mxe](https://github.com/mxe/mxe/blob/master/src/pe-util.mk)
  * [python script](https://github.com/mxe/mxe/blob/master/tools/copydlldeps.py)
  * [shell script](https://github.com/mxe/mxe/blob/master/tools/copydlldeps.md)
