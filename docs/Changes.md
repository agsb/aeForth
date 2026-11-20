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

20/11/2026

    Size or Speed ? Using macros or functions for stack operations ?

    Use macros allow a compact definition of operations and 
    variable parameters, basic only need define one pull and one push
    and each uses 3 operations and 3 cycles. All code is inline.

    Use functions needs define one for each argument and operation,
    a push_tos_spt, a pull_tos_spt, a push_nos_spt, a push_nos_spt,
    a push_tos_dpt, a pull_tos_rpt, and each uses 4 operations and 
    4 cycles, including the call and return.

    For 66 uses of push and pull: the inline code is 198 opcodes 
    long and takes 198 cycles; the functions code is 90 lines long
    (6 * 4 + 66 * 1) opcodes long and takes 330 (66 * 4) cycles,  


18/11/2026

    Start merge the "outer and inner" interpreter from milli-forth
    into aeforth2.S and all primitives into assemble.S

    Unlike millForth, version (2) uses SP, RP, IP, TOS in registers.
    
    Split system words in:

        done, ecalls for init, getc, putc, exit 

        skel, efiles for open, close, read, write, seek

        skel, extras for create, erase, fcntl, directory and memory

    the ecalls provide support for emulate a dummy terminal   

    the efiles provide support for emulate a tape/disk inside a file   
    
16/11/2026

    The aeForth could be a turnkey for ESP32 RISCV, bellow FreeRTOS.

    In ESP32 esp_rom*.h uses standart ABI. caller must save
    ra, t0–t6, and a0–a7, but sp and s0–s11 are preserved.

    Assume full 32 bit code, using

    
    | register | use | remarks |
    | -- | -- | -- |
    | s0 | sp | data stack pointer |
    | s1 | rp | return stack pointer |
    | s2 | ip | instruction stack pointer |
    | s3 | usr | user array pointer |
    | s4 | nib | first compiled pointer, only on MITC, reserved |

    | register | use | remarks |
    | -- | -- | -- |
    | s5 | cn0 | counter of nexts |
    | s6 | cn1 | counter of jumps |
    | s7 | cn2 | counter of nests |
    | s8 | rax | to save ra before rom call |


    | register | use | remarks |
    | -- | -- | -- |
    | a0 | TOS | reserved, first  on data stack, fst | 
    | a1 | NOS | scrath second on data stack, snd | 
    | a2 | TRD | scrath third  on data stack, trd | 
    | a3 | FTH | scrath fourth on data stack, fth | 

13/11/2026

    Discovered that GForth-0.2 have defined : PERFORM @ EXECUTE ;
    then changing name of 'my PERFORM to BEHAVE.

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


