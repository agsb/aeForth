#!/usr/bin/bash

# crude script

make clean

make

echo "\n QEMU init \n"

# system and application
QEMU=qemu-system-riscv64

# single application
QEMU=qemu-riscv32

${QEMU} test.elf \
 -display none -bios none -serial mon:stdio -smp 1 -machine virt \

# -g 1234 \

echo "\n QEMU exit \n"
