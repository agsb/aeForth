# The Minimal Indirect Thread Code (M.I.T.C.)

_still a Stub_

## What is MITC

Forth is a virtual machine that uses stack operations, pushing and popping, and jumps to execute routines on a real CPU.

Forth employs two types of "words": primitives words, implemented in native machine code and containing no references to other words, and compiled words, which consist of a sequence of references (spots) to other words. Only primitive words are actually executed by the real CPU.

*Minimal Indirect Threaded Code* is an alternative to the classic *Indirect Threaded Code*, it saves space in the dictionary and allows for faster execution of Forth words.

## Explain

Using a RISC-V-based CPU, with one cycle per instruction and four registers: IP (Instruction Pointer), RP (Return Stack Pointer), W (Work scratch register), and V (Reference address register), along with macros:

.macro pull R1, R2 ( 2 cycles )

        R1 = (R2) ; R2 = R2 + CELL ;
.endmacro

.macro push R1, P2  ( 2 cycles )

        R2 = R2 - CELL ; (R2) = R1 ;
.endmacro
        
.macro move R1, R2  ( 1 cycle )
        
        R1 = R2 ;
.endmacro
        
.macro jump R1 ( 1 cycle )

        PC = (R1) ;
.endmacro
        
.macro less R1, R2 ( 1 cycle )
	
		bgtu R1, R2, Label ( 1 cycle )
.endmacro

        
## Classic ITC, aka Fig-Forth, 1980

Translated from PDP-11 instructions, (Docol and Semis are called nest and unnest in eForth) 

.macro  Next

        pull W, IP 		\ 2 cycles ; 
        jump (W) 		\ 1 cycle ;
.endm

( Enter aka nest )
Docol:  
        
        push IP, RP 	\ 2 cycles ;
        move IP, W 		\ 1 cycle ;
        Next ;		\ 3 cycles ;

( Exit aka unnest )
Semis:   
        
        pull IP, RP 	\ 2 cycles ;
        Next ;		\ 3 cycles ;

Both word types, primitive or compiled, could be at anywhere in dictionary. 

All words ends with *Next*. The primitives have machine native code.

	primitive: code Next

The compiled word inits with *Docol* and exits with *Semis*. The spot is a reference address to a word. 

	compiled: Docol spot spot ... spot Semis

Usually Next is a macro at very end of all words. Some Forth uses a jump to a routine Next.

The register W contains the reference (spot) of word been executed and IP the follow one.

The words LIT, DOVAR, DOCON and BRANCH changes IP.

## The M.I.T.C. 

MITC uses same six macros of the Classic ITC plus one macro for comparison.

The main idea of M.I.T.C is to reorder and group the code pieces on Docol (nest), Semis (unnest) and Next 
into one piece, as an unique internal inner interpreter, a "heart beat".

This allow better account and responses to interrupts and events, eliminate use *Docol* at start of words,
	and do a jump at end of words, and No macros.

MITC does jumps only at primitive words and the references (spots) are pushed and pulled at return stack.

By place all primitive words bellow a memory reference and all compiled words above then 
	an unique test to decides if jump of push. (plus 1 cycle) 

The register V could be loaded with reference address before and preserved, 
        or before each comparasion (plus 1 cycle).

For all compiled words does at two jumps less than Classic. (less 2 cycles)

## M.I.T.C. version 1.0

All primitive words must ends with **jump** *Unnest*. All compiled words must ends with *Unnest*

The register IP is pushed and pulled at every word then does not need be preserved.

The following instruction to be executed is always at top of return stack.

The branches uses the value at top of return stack as reference of offsets.

The >R R@ R> uses the cell bellow the top of return stack, to preserve the return reference at top.

### Code version 1.0

Unnest:

        pull IP, RP ;

Next:
 
        pull W, IP ;

Nest:

        push IP, RP ;

Pick:

        less W, V, Move ;

Jump:

        jump (W) ;

Move:

        move IP, W ;
		
        jump Next

## M.I.T.C. version 2.0

All primitive words must ends with **jump** *Next*. All compiled words must ends with *Unnest*.

The IP is **really** used as a instruction pointer and must be preserved.

Does not push or pull IP for primitive words. (less 4 instructions cycles)

The branches uses the value of IP as reference for offsets. (less 2 instructions cycles)

The >R R@ R> direct use the top of return stack, because the return reference is at IP. (less 2 instructions cycles)

### code 2.0

Unnest:

      pull IP, RP ;

Next:

      pull W, IP ;

Pick: 

      less W, V, Move ;

Jump:

      jump (W) ;

Nest:

      push IP, RP ;

Move:

      move IP, W ;
      jump Next ;



