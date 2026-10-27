# NOTES

    Uses cell with 32-bits;
 
    Only IMMEDIATE flag used as $8000:0000, no hide, no compile, no extras;
 
    As ANSI Forth 1983: FALSE is 0 and TRUE is -1 ;
 
    Uses DJB2 31-bit Hash instead of size-name-pad in header of words in
        dictionary.

    The header order is LINK, HASH and code or references.
 
    Still only hexdecimal numbers, no base radix included;

 ## NO MORE

    No more TIB or PAD. Create if need.

    ~~TIB (80 bytes) and locals (8 cells) are in sequence;~~

    ~~PAD (84 bytes) and PIC (68 bytes) must be allocated if need;~~
 
## Remarks
 
    This code uses Minimal Indirect Thread Code, aka MITC;

    The values of TOS, SP, RP, IP and NIB are in registers;
 
    Words must be between spaces, before and after;
 
    Words of ascii characters, no controls and any size;
 
    Still no multiuser, no multitask, no checks, not faster;

    IMMEDIATE word only works outside word definition, 
    it always make latest word immediate.
 
    Not using smudge, colon saves HERE into PIKE and 
          semis loads LATEST from PIKE;
 
## For Devs
 
    Chuck Moore uses 64 columns. 

    Be wise, obey the rule of 72 characters per line; 
 
    Never mess with two underscore variables;
 
# For stacks
 
    **Moore says that stacks with 22 deep is about infinite.**

    aeForth uses stacks of 32 cells (128 bytes).

    Stacks are round-robin, no overflow or underflow stack checks.
 
    The hardware stack is not used as Forth stack;
 
    "when the heap moves forward, the stack moves backward"; 
 
    The stack movement to be:
        push is 'decrease and store'
        pull is 'fetch and increase'
 
    Stacks represented as (standart)
        (w1 w2 w3 -- u1 u2 ; w1 w2 -- w1 )
        ( data stack ; return stack )
        ( before -- after ), top at right, w2 is over w1.

        c unsigned 8-bit character, 
        a 32-bit address,
        w signed 32-bit, 
        u unsigned 32-bit, 
        f flag TRUE or FALSE, 
        h hash 31-bit value,
        x 32-bit execution address
 
## For RiscV
 
    A 32-bit processor with 32-bit address space and reduced ISA;
 
    There is no automatic pull and push of SP.

    There is no immediate values in comparations.

    Only 12-bits immediate adds.

    No direct memory access, only accessed using a register as pointer.

    No register indexed offset, only immediate offsets (+/- 1024 bytes).

## For Heaps

    Order is variables, stacks, forth, dictionary, heap, end-of-memory

    Heap always grows till end of memory.

## For Hash

_"AI uses hash code as word, Humans uses semantics as word"_
     [Liang Ng](https://www.youtube.com/watch?v=sSlM3Mr_9sI)
    
Going to use DJB2 i31-bit hash for represent the words at dictionary.
    
Why not use hashes for words ?

Moore once used size and first three characters of name as words
    in dictionary. Now with 32-bit CPUs the find of a word could be 
    easy, done just one comparation, and the header as: link, hash, code.

To keep safe from colisions, check the hash of token inside colon (:)
    and when exists, block that token.

Also could export a name:hash, to make a list for human reference.
    
The hash over 0x00000000 to 0x7FFFFFFF, reserve -1 to IMMEDIATE flag

_" there is no spoon "_

## For Numbers

Make the integer range of values simetric to zero.

To represent short signed integer numbers is used the high bit 
of the MSB as signal indicator, eg for one byte, 00000001
to 01111111 ( 1 to 127 ) is positive, 00000000 is zero and 11111111 to
10000001 ( -1 to -127 ) is negative, and 10000000 is -128. 

In aeForth, -128 is not a number ( NaN ) and is used to indicate 
numeric errors in conversion, overflow, undeflow, zero division.

Sure it is extended to 4 bytes cells, then 0x8000:0000 is NaN.

AeForth uses simetric division, as defined in X3.215-1994 ANSI

                     Table 3.4 - Symmetric Division Example
                    Dividend   Divisor   Remainder   Quotient
                    -----------------------------------------
                       10         7          3          1
                      -10         7         -3         -1
                       10        -7          3         -1
                      -10        -7         -3          1
                    -----------------------------------------

## Primitive or Compiled words

Any word the does not call another word is a primitive.

Any word that depends of another word is a compiled word.

Any Forth interprets compiled and only executes primitives.

## Why only TOS ?



