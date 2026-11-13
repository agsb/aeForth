# The Minimal Indirect Thread Code (M.I.T.C.)

_still a Stub_

## What is MITC

Forth is a virtual machine that uses stack operations, pushing and popping, and jumps to execute routines on a real CPU.

Forth employs two types of "words": primitives words, implemented in native machine code and containing no references to other words, and compiled words, which consist of a sequence of references (spots) to other words. 

*Minimal Indirect Threaded Code* is an alternative to the classic *Indirect Threaded Code*, it saves space in the dictionary and allows for faster execution of Forth words.

## What is Indirect Thread

Moore once writed **" : NEXT IP )+ W MOV W )+ ) JMP ; "**, for a PDP-11 Forth.

A jump using the indirect deferred addressing mode of PDP-11, **" JMP @(W)+ "** is really a "indirect load and increment" then an "indirect jump", with use a hidden register.

That old PDP-11 code translates actually to **" W = (IP)++ ; V = (W)++; JMP (V) ; "**. 

The magic of this code snippet lies in the fact that it allows for the chaining of multiple references (spots), until  spot directly to an executable native machine code.

Only primitive words, with native machine code, are actually executed by the real CPU.

The term "indirect" actually causes some confusion. All CPUs calls "jump to memory address content of a register" as indirect jump and "jump to an absolute address" as direct jump. 

Look for complete explanation of [Forth Thread Code](https://www.bradrodriguez.com/papers/moving1.htm).

##  Reference

Using as reference a RISC-V-based CPU, with one cycle per instruction and five registers: PC - program counter), IP - Instruction Pointer, RP - Return Stack Pointer, W -Work register, and V - Reference register. 

Using () to indicate the register holds a memory address where the value is, and ++ or -- to indicate increment or decrement by one address unit.

## Classic ITC, aka Fig-Forth, 1980

The Fig-Forth routines *docol* and *semis* are called *enter* and *exit* in many Forths, and *nest* and *unnest* in eForth. The PDP-11 native instructions are translated to generic virtual intructions. 

.macro  *next*

    # pull W from instruction pointer

    W = (IP) ;

    IP++ ;
    
    # magic emulate of Auto-increment Deferred # PC = @(W)++ 

    V = (W) ;

    W++ ;

    PC = (V) ;
.endm

( enter aka nest )
*docol*: 

    # push IP into return stack

    RP-- ;

    (RP) = IP ;

    # Move the pointer to the next cell; 

    IP = W ;

    # macro next

    next ;

( exit aka unnest )
*semis*:

    # pull IP from return stack
    
    IP = (RP) ;
    
    RP++ ;
    
    # macro next 
    
    next ;

Both word types, primitive or compiled, could be at anywhere in dictionary. 

The primitives have machine native code inside. The first spot points to following native code and last spot copy the code of *next*. A primitive word could update IP. The words DOVAR, DOCON and BRANCH update IP. 

        primitive: spot code Next ;

The compiled word have a list of references (spots) to words. It first spot points to *docol*, followed by a list of spots and last spot points to *semis*. A compiled words could do any use with IP 

        compiled: docol spot spot ... spot semis ; 

Usually *next* is a macro at end of *docol* and *semis* but it could replaced by a jump to a routine *next*.

The register W contains the reference (spot) of word been executed and IP a reference to the follow one.


## The M.I.T.C. 

MITC uses same operations of the Classic ITC, plus one comparison.

The main idea of M.I.T.C is to reorder and group the code pieces on *docol*, *semis* and *next* 
into one routine, as an unique internal inner interpreter, a "heart beat". Without macros at words. 

This allow better account and responses to interrupts and events, eliminate the indirect pointer at start of words,
and ends all words with a jump or a spot. The references (spots) are pushed and pulled at return stack and only jumps at primitive words.

By place all primitive words bellow a memory reference and all compiled words above, 
then an unique test is used to decides if jump of push.

That memory reference could be placed into register V or loaded before each comparasion.

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

Pick: # branch conditional
     
        IF (V < W) PC = Nest

Jump: # indirect jump

        PC = (W) 

Nest: # push IP into RP

        RP--
        
        (RP) = IP

Move: # chain it

        IP =  W 

        PC = Next

## M.I.T.C. version 2.0

All primitive words must ends with **jump** *Next*. All compiled words must ends with *Unnest*.

The IP is **really** used as a instruction pointer and must be preserved.

Does not push or pull IP for primitive words. 

The branches uses the value of IP as reference for offsets. 

The >R R@ R> direct use the top of return stack, because the return reference is at IP. 

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

In classic model, a Next starts every word and always jumps to address at address in first spot, if is *docol*, it push the next spot and repeats until reach an execute code. Every word does two jumps. The Next code takes 5 cycles, then each *docol* takes 3 cycles + 5 cycles, each *semis* takes 2 cycles + 5 cycles.

In version 1, 
