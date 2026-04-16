# NOTES

 
    Uses cell with 32-bits;
 
    Only IMMEDIATE flag used as $8000, no hide, no compile, no extras;
 
    As ANSI Forth 1983: FALSE is 0 and TRUE is -1 ;
 
    Uses DJB2 Hash instead of size-name-pad in header of words in
        dictionary.

    The header order is LINK, HASH and code or references.
 
    No overflow or underflow stack checks;
 
    No numbers only words (yet);

 ## NO MORE

        TIB (80 bytes) and locals (8 cells) are in sequence; 

        PAD (84 bytes) and PIC (68 bytes) must be allocated if need;
 
## Remarks
 
    This code uses Minimal Indirect Thread Code, aka MITC;
 
    No TOS or ROS registers, all values keeped at stacks;
 
    Words must be between spaces, before and after;
 
    Words are case-sensitivy and less than 32 characters;
 
    No multiuser, no multitask, no checks, not faster;

    IMMEDIATE word only works outside word definition, 
    it always make latest word immediate.
 
    Not using smudge, colon saves HERE into HEAD and 
          semis loads LATEST from HEAD;
 
## For Devs
 
    Chuck Moore uses 64 columns. Be wise, obey the rule of 
        72 characters per line; 
 
    Never mess with two underscore variables;
 
# For stacks
 
    The hardware stack is not used for this Forth;
 
    The hello_world.forth file states that stacks works to allow 
        : dup sp@ @ ; so spt must point to actual TOS;
    
    "when the heap moves forward, the stack moves backward"; 
 
    The stack movement to be:
        push is 'decrease and store'
        pull is 'fetch and increase'
 
    Stacks represented as (standart)
        (w1 w2 w3 -- u1 u2), (w1 w2 w3 -- u1 u2)
        data, return (before -- after), top at left.
        c unsigned 8-bit character, a 32-bit address,
        w signed 32-bit, u unsigned 32-bit,
 
## For RiscV
 
    A 32-bit processor with 32-bit address space and reduced ISA;
 
    There is no automatic pull and push of SP.

    There is no immediate values in comparations.

    Only 12-bits immediate adds.

    No direct memory access, only accessed using a register as pointer.

    No register indexed offset, only immediate offsets (+/- 1024 bytes).

## For Heaps


## For Hash

_"AI uses hash code as word, Humans uses semantics as word"_
     [Liang Ng](https://www.youtube.com/watch?v=sSlM3Mr_9sI)
    
Why not use hashes for words ?

Moore once used size and first three characters of name as words
    in dictionary. Now with 32-bit CPUs the find of a word could be 
    easy, done just one comparation, and the header as: link, hash, code.

To keep safe from colisions, check the hash of token inside colon (:)
    and when exists, block that token.

Also could export a name:hash, to make a list for human reference.
    
The hash over 0x00000000 to 0x7FFFFFFF, reserve -1 to IMMEDIATE flag

_" there is no spoon "_

Going to use DJB2 hash for represent the words at dictionary.
    
## For Numbers

To represent short signed integer numbers is used the high bit 
of the MSB as signal indicator, eg for one byte, 00000001
to 01111111 ( 1 to 127 ) is positive, 00000000 is zero and 11111111 to
10000001 ( -1 to -127 ) is negative, and 10000000 is -128. 

In aeForth, -128 is not a number ( NaN ) and is used to indicate 
numeric errors in conversion, overflow, undeflow, zero division.

Sure it is extended to 4 bytes cells. 

