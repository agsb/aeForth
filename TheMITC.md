# The Minimal Indirect Thread Code (M.I.T.C.)

_still a Stub_

## What is MITC

Forth is a virtual machine that uses stack operations, pushing and popping, and jumps to execute routines on a physical CPU.

Forth employs two types of "words": primitives—implemented in native machine code and containing no references to other words, and compiled words, which consist of a sequence of references to other words. Only primitive words are actually executed by the host CPU.

*Minimal Indirect Threaded Code* is an alternative to the classic *Indirect Threaded Code*, it saves space in the dictionary and allows for faster execution of Forth words.

## Explain

Considering a RISC-V-based CPU, with one cycle per instruction and four registers: IP (Instruction Pointer), RP (Return Stack Pointer), W (Work scratch register), and V (Reference address register)—along with macros:

pull R1, R2 ( 2 cycles )

        R1 = (R2) ; R2 = R2 + CELL ;
        
push R1, P2  ( 2 cycles )

        R2 = R2 - CELL ; (R2) = R1 ;
        
move R1, R2  ( 1 cycle )
        
        R1 = R2 ;
        
jump (R1) ( 1 cycle )

        PC = (R1) ;
        
bgtu R1, R2, Label ( 1 cycle )

        if R1 > R2 then jump Label ;
        
## Classic ITC, aka Fig-Forth

.macro  Next

        pull W, IP 	\ 2 cycles ; 
        jump (W) 	\ 1 cycle ;
.endm

( docol aka nest )
Enter:  
        
        push IP, RP 	\ 2 cycles ;
        move IP, W 	\ 1 cycle ;
        Next ;		\ 3 cycles ;

( semis aka unnest )
Exit:   
        
        pull IP, RP 	\ 2 cycles ;
        Next ;		\ 3 cycles ;

Both word types, primitive or compiled, could be at anywhere in dictionary. Does not need register V. 

All words ends with *Next*. The primitives have machine native code.

	primitive: code Next

The compiled word inits with *docol* and exits with *semis*. The spot is a reference address to a word. 

	compiled: docol spot spot ... spot semis

Usually Next is a macro at very end of all words. Some Forths uses a jump to Next.

The register W contains the spot of word been executed and IP the follow one.

## The M.I.T.C. 

The main idea of M.I.T.C is reorder the code pieces on docol (Enter), semis (Exit) and Next, 
	to not need *docol* at start of every word and only do one jump at ends.

Uses same 6 instructions of the Classic ITC plus one instruction for comparison.

It does jumps only into primitive words else the references (spots) are pushed and pulled at return stack.

Place all primitive words bellow a memory reference (at register V), and all compiled words above. 

A unique test ( 1 cycle ) to decides if jump of push. 

For all compiled words does at two jumps less ( -2 cycles ) than Classic.

The register V could be loaded with reference address before and preserved, 
        or before each comparasion ( + 1 cycle ).

## M.I.T.C. version 1.0

All primitive words must ends with **jump** *Unnest*.

All compiled words must ends with *Unnest*

Does not jumps to compiled words.

Similar to Classic:

The register IP is pushed and pulled at every word then does not need be preserved.

The following instruction to be executed is always at top of return stack.

The branches uses the value at top of return stack as reference of offsets.

The >R R@ R> must use the cell bellow the top of return stack, to preserve the return reference at top.

### Code version 1.0

Unnest:

        pull IP, RP ;

Next:
 
        pull W, IP ;

Nest:

        push IP, RP ;

Pick:

        bgtu W, V, Move ;

Jump:

        jump (W) ;

Move:

        move IP, W ;
        jump Next


## M.I.T.C. version 2.0

All primitive words must ends with **jump** *Next*.

All compiled words must ends with *Unnest*.

Does not jumps to compiled words.

The IP is **really** used as a instruction pointer and must be preserved.

Does not need push or pull IP for primitive words. Less 4 instructions cycles.

The branches uses the value of IP as reference for offsets. Less 2 instructions cycles

The >R R@ R> direct use the top of return stack, because the return reference is at IP. Less 2 instructions cycles.

### code 2.0

Unnest:

      pull IP, RP ;

Next:

      pull W, IP ;

Pick: 

      bgtu W, V, Move ;

Jump:

      jump (W) ;

Nest:

      push IP, RP ;

Move:

      move IP, W ;
      jump Next ;



