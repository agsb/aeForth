# milliForth-RiscV

*"To master riding bicycles you have do ride bicycles"*

started at 12/04/2026

vide [Changes](https://github.com/agsb/aeForth/blob/main/docs/Changes.md) 
and [Notes](https://github.com/agsb/aeForth/blob/main/docs/Notes.md)

This is an implementation of Forth concept for RISCV ISA, 
using [Minimal Indirect Thread Code](https://github.com/agsb/agsb.github.io/blob/main/The_words_in_MTC_Forth.v4.pdf).

No human WORDS. It uses DJB2 hash in headers. 

No Terminal Input Buffer, just an token-to-hash ascii parser.

Only use a IMMEDIATE flag, at MSBit (31) of hash, also is NaN. 

There are a file with more core words to use.

## For use

    **cat t0.f t1.f t2.f - | sh doit.sh | tee output**

    Add a hyphen at end of cat files list to allow terminal I/O
            cat t0.f t1.f t2.f - > sh doit.sh 
            
    Some esoteric bug makes the first word to have hash error.

    The memory management is done by extend the dictionary 
        into .bss, by reserve .skip bytes, defaults to 64k * 4
        no linux calls for memory allocation. (Anyone ?)

## Compiler Options

    compiler suit of RISCV: gcc riscv64-unknown-elf-* -Oz

    which memory map be used and pages size: default GCC
  
    simulator of RISCV: qemu 
    
    the heap and stack: .heap at end of .bss, .stack elsewhere.

    systems calls of core functions: linux ecalls

    system stack pointer: not used by Forth.
    
## ISA

the RISCV is a 4 bytes (32-bit) cell CPU with 32-bit 
    [ISA](https://www.cl.cam.ac.uk/teaching/1617/ECAD+Arch/files/docs/RISCVGreenCardv8-20151013.pdf) 
or 
    [ISA](https://dejazzer.com/coen2710/lectures/RISC-V-Reference-Data-Green-Card.pdf)

The aeForth is a ELF program called by 'elsewhere operational system', 
and use registers r0, ra, sp, s0, s1, a0-a7, t0-t1. 

## Coding

*"qemu -kernel loads the kernel at 0x80000000 and causes each hart (i.e. core of CPU) to jump there."*

For assembler, use [standart Risc-V](https://github.com/riscv-non-isa/riscv-asm-manual) style 
with pre-processor directives eg. #define.

For now, using riscv-unknown-elf-gcc suit with qemu emulator
for a single core minimal footprint Forth thread.  

For now, aeForth must use memory pointers for data stack and return stack, 
because does fetch and store from a special 'user structure', which 
contains the user variables for Forth 
( state, last, heap, sptr, dptr ).

## Colon and Semis

The colon **:** makes a header by:
        1. copy HERE to HEAD
        2. copy LATEST to first cell;
        3. calculate the djb2 hash of the next token;
        4. copy hash to second cell;
        5. change STATE to compile (1);

In compile state, all non immediate words are compiled, 
        and the immediate words are executed. 
    
The semis **;** ends the word by:
        1. place a 'EXIT into last cell
        2. copy HEAD to LATEST
        3. change STATE to execute (0);

if the compilation is interrupted, 
    STATE and LATEST keeps untouched, 
    but HERE changes and some junk was placed and stays into dictionary.
    Could clean that with more some code, to copy HEAD to HERE

When the compilation of a word breaks, the LATEST are keepd in order 
but HERE was advanced with references of words compiled, that junk 
stays lost in heap. 

To clean just copy HEAD to HERE at error or missing.

## internals

This aeForth uses DJB2 hash for dictionary entries.  

## the Language

For Forth language primer see 
[Starting Forth](https://www.forth.com/starting-forth/)

For Forth from inside howto see
[JonasForth](http://git.annexia.org/?p=jonesforth.git;a=blob_plain;f=jonesforth.S;hb=refs/heads/master)

For A Problem Oriented Language see
[POL](https://www.forth.org/POL.pdf)

## References

[^11]: The linux ecall list: https://github.com/riscv-software-src/riscv-pk/blob/master/pk/syscall.h)
[^5]: Forth standart ANSI X3.215-1994: http://www.forth.org/svfig/Win32Forth/DPANS94.txt
[^7]: A minimal thread code for Forth: https://github.com/agsb/immu/blob/main/The_words_in_MTC_Forth.en.pdf
[^8]: Forth: A new way to program: https://adsabs.harvard.edu/full/1974A%26AS...15..497M (Astro. Astrophys. Suppl. 14, 497-511, 1974)

