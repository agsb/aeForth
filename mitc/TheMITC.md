# The Minimal Indirect Thread Code (M.I.T.C.)

_still a Stub_

## What is MITC

Forth is a virtual machine that uses stack operations, pushing and popping, and jumps to execute routines on a real CPU.

Forth employs two types of "words": primitives words, implemented in native machine code and containing no references to other words, and compiled words, which consist of a sequence of references (spots) to other words. 

The magic of this code lies in the fact that it allows for the chaining of multiple references (spots) of compiled words, until a spot points directly to an executable native machine code. Only primitive words are actually executed by the real CPU.

*Minimal Indirect Threaded Code* is an alternative to the classic *Indirect Threaded Code*, it saves space in the dictionary and allows for faster execution of Forth words.

## What is Indirect Thread

Moore once writes **" : NEXT IP )+ W MOV W )+ ) JMP ; "**, for a PDP-11 Forth.

The PDP-11 Forth assembler **" W )+ ) JMP"** is **" JMP @(W)+ "**, a jump using the indirect **deferred** addressing mode. It is really a _indirect load and increment_ then an _indirect jump_, with use a hidden register, that PDP-11 code translates actually to **" W = (IP)++ ; V = (W)++; JMP (V) ; "**. 

In this sense, the term **"Indirect Thread Code"** is really **"Indirect _Deferred_ Thread Code"**.

The term "indirect" actually causes some confusion. All CPUs calls "jump to memory address content of a register" as indirect jump and "jump to a following absolute address" as direct jump. 

Look for complete explanation of [Forth Thread Code](https://www.bradrodriguez.com/papers/moving1.htm).

##  Reference

The code snippets bellow consider a RISC-V-based CPU as reference, with: 1. one cycle per instruction; 2. at least five registers: PC - Program Counter, IP - Instruction Pointer, RP - Return Stack Pointer, W - Work register, and V - Reference register; 3. A register holds a memory address where is the value, by (); 4. A increment or decrement of a register by one address unit, by ++ and --.

## Classic ITC, aka Fig-Forth, 1980

The Fig-Forth routines *docol* and *semis* are called *enter* and *exit* in many Forths, and *nest* and *unnest* in eForth. The PDP-11 native instructions are translated to generic virtual intructions. 

.macro  *next* ( payload 5 cycles )

    # pull W from instruction pointer

    W = (IP) ;

    IP++ ;
    
    # magic emulate of Indirect Deferred Jump # PC = @(W)++ 

    V = (W) ;

    W++ ;

    PC = (V) ;
.endm

( enter aka nest )
*docol*: ( payload 8 cycles )

    # push IP into return stack

    RP-- ;

    (RP) = IP ;

    # Move the pointer to the next cell; 

    IP = W ;

    # macro next, include code

    next ;

( exit aka unnest )
*semis*: ( payload 7 cycles )

    # pull IP from return stack
    
    IP = (RP) ;
    
    RP++ ;
    
    # macro next, include code
    
    next ;

Both word types, primitive or compiled, could be at anywhere in dictionary. 

Inside primitives, the first spot points to the following native code and the last spot copy the code of *next*. A primitive word could update IP. The words DOVAR, DOCON and BRANCH update IP. 

        primitive: ( payload 5 cycles ) 
            spot_to_code 
            code code ... code 
            macro_next

The compiled word have a list of references (spots) to words. Its first spot points to *docol*, followed by a list of spots and the last spot points to *semis*. A compiled words could do any use with IP 

        compiled: ( payload 15 cycles )
            docol 
            spot 
            ... 
            spot 
            semis 

Both word types are called by a previous *next*. 

Usually *next* is a macro, also at end of *docol* and *semis*, but it could replaced by a jump to a routine *next*.

The register W contains the reference (spot) of word been executed and IP a reference to the follow one.

## The M.I.T.C. 

MITC uses same operations of the Classic ITC, plus one comparison.

The main idea of M.I.T.C is to reorder and group the code pieces on *docol*, *semis* and *next* 
into one routine, as an unique internal inner interpreter, a "heart beat". Without macros at words. 

This allow better account and responses to events and interrupts, eliminate the indirect pointer at start of words,
and ends all words with a jump or a spot. 

By reorder the Forth dictionary, and place all primitive words bellow a memory reference, and all compiled words above, then an unique test is used to decides if jump of push. At primitive words it jumps to code, and in compiled words, the spots are pushed and pulled at return stack.

That memory reference could be placed into a register V or loaded before each comparasion.

### the IP, NOS and TOS 

There are 3 types of primitives:

1. ones that changes IP, as DOCON, DOVAR, BRANCH;
2. ones that changes TOS (Top Of Stack), as @, NEGATE, INVERSE, DROP, >R, R>, R@ (etc)
3. ones that changes TOS and NOS (Next On Stack), as !, +, -, AND, OR, XOR, =, <, DUP, SWAP (etc)   

could also the top of data stack could be at a register T.

## M.I.T.C. version 1.0

All primitive words must ends with **jump** *Unnest*. All compiled words must ends with a spot to *Unnest*

The register IP is pushed and pulled at every word and does not need be preserved.

The following instruction to be executed is always at top of return stack.

The DOVAR, DOCON and BRANCH uses the value at top of return stack.

The >R R@ R> uses the cell bellow the top of return stack, to preserve the return reference at top.

### Code version 1.0

Unnest: # pull IP from RP

        IP = RP

        RP++
                
Next: # pull W from IP

         W = (IP)
        
        IP++

Nest: # push IP into RP

        RP--
        
        (RP) = IP

Move: # chain it

        IP =  W 

Pick: # branch conditional
     
        IF (V < W) PC = Nest

Jump: # indirect jump

        PC = (W) 

## M.I.T.C. version 2.0

All primitive words must ends with **jump** *Next*. All compiled words must ends with *Unnest*.

The IP is **really** used as a instruction pointer and must be preserved or updated.

Does not push or pull IP for primitive words, only for compiled words. 

The branches uses the value of IP as reference for offsets. 

The >R R@ R> direct use the top of return stack, because the return reference is always at IP. 

### Code version 2.0

Nest: # push IP into RP

        RP--
        
        (RP) = IP

Move: # chain it

        IP =  W 
                
Next: # pull W from IP

        W = (IP)
        
        IP++

Pick: # branch conditional
     
        IF (V < W) PC = Nest

Jump: # indirect jump

        PC = (W) 

Unnest: # pull IP from RP

        IP = RP
        
        RP++

        PC = Next

## Rationale

_to review_

In classic model, a *next* starts every word and always jumps to address at address in first spot, if is *docol*, it push the next spot and repeats until reach a primitive code. Every word does two jumps. The *next* code takes 5 cycles, each *docol* takes 3 cycles + 5 cycles, each *semis* takes 2 cycles + 5 cycles.

In version 1, 

In version 2,

