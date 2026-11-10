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

10/11/2026

    Following Moore in POL, for STATE, COMPILE is now 0, and EXECUTE id now 1. 
	
07/11/2026

    Using style reference as in 
        https://github.com/ForthHub/discussion/issues/73

    No more words using names FIND, WORD, TOKEN, FIND-NAME etc

    Using SEEK for find a hash inside dictionary. HASH and SEEK. 

    Review of **begin while repeat** to allow extra
        multiple **while then**
        as **begin while while ... repeat then**
        while is a **if swap** and repeat is a **again then**
        note to self, its beautiful.

03/11/2026

    Using s0/spt s1/rpt s2/ipt s3/usr s4/nib 

    Using tos/a0 nos/a1 trd/a2 a3 a4 a5 a6 a7 as scratchs

    Using t0, t1, t2 as counters of total, primitive, composed executed words

    NOT using sp 

02/11/2026

    Many ideas from https://github.com/8l/ff/blob/master/ff-arm.s

    focus in expand linux systems ecalls for directories and files

25/10/2026

    bad bad bad day for Brasil.

23/10/2026

Regroup of control words :

	- begin mark back fore (does offsets)
	- again until whilst (goes backward branches)
	- aft while repeat (goes forward branches)
	- if else then ( zbranch to A, ..., branch to B, A, ..., B, ... )

	whilst goes to begin if TOS is greater than zero, as a while to backwards.

Small changes in :
 
	- EXECUTE execute the xt at TOS inside forth inner loop
	- PERFORM execute a native jump to TOS and return to forth inner loop
	- COMPILE, still is comma.

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
    compiled, compound words that call words, with forth code;
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


