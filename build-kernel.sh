#!/bin/bash

# this uses the GCC 9 toolchain
# main toolchain:
# https://github.com/kdrag0n/aarch64-elf-gcc.git
# for 32bit cross-compiling:
# https://github.com/kdrag0n/arm-eabi-gcc.git
# when building under WSL make sure the distro uses WSL 2

# Update submodules
git submodule update --recursive --init

export KBUILD_BUILD_USER="user"
export KBUILD_BUILD_HOST="build"
export ARCH="arm64"
export SUBARCH="arm64"
export TRIPLET="aarch64-none-elf-"
export TRIPLET_ARM32="arm-none-eabi-"
export CROSS_COMPILE="$(pwd)/compiler/gcc-arm-10.2-2020.11-x86_64-aarch64-none-elf/bin/$TRIPLET"
export CROSS_COMPILE_ARM32="$(pwd)/compiler/gcc-arm-none-eabi-10-2020-q4-major-x86_64-linux/gcc-arm-none-eabi-10-2020-q4-major/bin/$TRIPLET_ARM32"
export KBUILD_OUTPUT="$(pwd)/out"
export KBUILD_BUILD_USER="user"
export KBUILD_BUILD_HOST="build"

echo
echo "Cleanup output dir"
echo

rm -rf out
make clean && make mrproper
mkdir -p out

echo
echo "Build kernel"
echo

#Make config
make O=out ARCH=arm64 nb1_defconfig

#Build kernel
make -j$(nproc --all) O=out \
    ARCH=arm64 \
    LOCALVERSION=-gcc
