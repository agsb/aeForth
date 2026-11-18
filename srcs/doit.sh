#!/usr/bin/bash

# crude script

make clean

make

echo "QEMU init"

# system and application
QEMU=qemu-system-riscv64

# single application
QEMU=qemu-riscv32

${QEMU} test.elf \
 -g 1234 \
 -display none -bios none -serial mon:stdio -smp 1 -machine virt

echo "QEMU exit"
