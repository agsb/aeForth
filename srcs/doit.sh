#!/usr/bin/bash

# crude script

make clean

make

qemu-riscv32 main.elf \
 -display none -bios none -serial mon:stdio -smp 1 -machine virt

