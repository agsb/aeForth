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

20/10/2026

**Moore says the 22 deep are almost infinite**

- using round-robin stacks with 32 levels deep, (or any 2^n);

- rework all high level words into compiled forth code.

16/10/2026

Complete rewrite;
    
- using SP, RP, IP and TOS in registers;

- using auto link macro chain for dictionary;

- split sources into:
    main, with defines, equates, macros, includes;
    assembled, primitive words that do not call words, with native code;
    compiled, composed words that call words, with forth code;
    ecalls, with system (linux) dependent words.

07/05/2026

    Rewrite using MilliForth-Riscv as reference

    Maybe:

    Sp, Rp, Ip, Up, Tos are registers

    using TOS to minimize push and pull.

    Stacks accessed direct by registers

    pull:
        lw tos, 0 (spt)
        addi spt, spt, +1 * CELL
    
    push:
        addi spt, spt, -1 * CELL
        sw tos, 0 (spt)

    copy:
        mv snd, tos 

12/04/2026

    First commit, using as reference MilliForth-Riscv


