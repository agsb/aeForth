# Changes

    The aeForth uses Minimal Indirect Thread Code 
    and DJB2 hashes instead flag-size-name-pads. 

    In FigForth, ;S is called semis and ; is called semicolon, 
        but in Milliforth, ;S is exit and ; is semis. 

    Using eforth glossary as dictionary reference

## Details

    Gcc ELF Riscv cross compiler with -march=rv32gc -mabi=ilp32

    All hashs are 31 bits, high bit reserved for flag IMMEDIATE


## Todo
    
    __The "first hash bug", was just a debug error__ 
            but no :(: it is a real bug.

## WIP

    Include the eforth dictionary for expansion

## Done

07/05/2026

    rewrite using MilliForth-Riscv as reference

    Sp, Rp, Ip, Up, Tos are registers

    using TOS to minimize push and pull.

    Stacks accessed direct by registers

    pull:
        lw tos, 0 (spt)
        addi spt, spt, CELL
    
    push:
        addi spt, spt, -1 * CELL
        sw tos, 0 (spt)

    copy:
        mv snd, tos 

12/04/2026

    First commit, using as reference MilliForth-Riscv


