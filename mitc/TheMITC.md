# The Minimal Indirect Thread Code (M.I.T.C.)

_still a Stub_

## What is MITC

Forth is a virtual machine that uses stack operations, pushing and popping, and jumps to execute routines on a real CPU.

Forth employs two types of "words": primitives words, implemented in native machine code and containing no references to other words, and compiled words, which consist of a sequence of references (spots) to other words. 

*Minimal Indirect Threaded Code* is an alternative to the classic *Indirect Threaded Code*, it saves space in the dictionary and allows for faster execution of Forth words.

## What is Indirect Thread

Moore once writes **" : NEXT IP )+ W MOV W )+ ) JMP ; "**, which translates to **" W = (IP)++ ; V = (W)++; JMP (V) ; "**. A jump using the indirect deferred addressing mode of PDP-11, is really two "indirect load and increment" then jump, with use a hidden register. 

The magic of this code snippet lies in the fact that it allows for the chaining of multiple references (spots), until they point directly to an executable code.
Only primitive words, with native machine code, are actually executed by the real CPU.

The term "indirect" actually causes confusion. All CPUs calls "jump to contents of a register" as indirect jump and "jump to a absolute address" as direct jump. 

Look for a great explanation of [Forth Thread Code](https://www.bradrodriguez.com/papers/moving1.htm).

##  Reference

Using as reference a RISC-V-based CPU, with one cycle per instruction and five registers: PC - program counter), IP - Instruction Pointer, RP - Return Stack Pointer, W -Work register, and V - Reference register. Using () to indicate the register holds a memory address where the value is, and ++ or -- to indicate increment or decrement by one address unit.

## Classic ITC, aka Fig-Forth, 1980

Translated from PDP-11 instructions. Fig-Forth *docol* and *semis* are called *enter* and *exit* in many Forths, and *nest* and *unnest* in eForth. 

.macro  Next

	# pull W from instruction pointer
    W = (IP) ;
	IP++ ;
	# magic of Auto-increment Deferred # PC = @(W)++ 
	V = (W) ;
	W++ ;
	PC = (V) ;
.endm

( enter aka nest )
docol: 

	# push IP into return stack
    RP-- ;
	(RP) = IP ;
	# Move the pointer to the next cell; 
	# on the PDP-11, the W++ increment has already been performed during the previous "Next" operation, but on other CPUs, 
	# it must be included here as " W++ ; IP = W ; "
	IP = W ;
	# go next
	Next ;

( exit aka unnest )
semis:

	# pull IP from return stack
   	IP = (RP) ;
	RP++ ;
	# go next
	Next ;

Both word types, primitive or compiled, could be at anywhere in dictionary. All words ends with *next*. 

The primitives have machine native code. The first spot points to code and last spot to *next*.

        primitive: spot code Next ; # Primitive word must reserve IP or could update it

The compiled word have a list of references (spots) to words. It first spot points to *docol* and last spot to *semis*. 

        compiled: docol spot spot ... spot semis ; # Compiled words could reuse IP

Usually Next is a macro at very end of all words. Some Forths uses a jump to a routine Next.

The register W contains the reference (spot) of word been executed and IP to the follow one.

The words DOVAR, DOCON and BRANCH changes IP. (Some Forths call DOCON as DOLIT).

## The M.I.T.C. 

MITC uses same operations of the Classic ITC, plus one comparison.

The main idea of M.I.T.C is to reorder and group the code pieces on *docol*, *semis* and *Next* 
into one routine, as an unique internal inner interpreter, a "heart beat". No macros. 

This allow better account and responses to interrupts and events, eliminate the indirect pointer at start of words,
and ends all words with a jump or a spot. The references (spots) are pushed and pulled at return stack but only jumps at primitive words.

By place all primitive words bellow a memory reference and all compiled words above then 
        an unique test to decides if jump of push.

The register V could be loaded with reference address before and preserved, or before each comparasion.

All compiled words does two jumps less than Classic.

## M.I.T.C. version 1.0

All primitive words must ends with **jump** *Unnest*. All compiled words must ends with *Unnest*

The register IP is pushed and pulled at every word then does not need be preserved.

The following instruction to be executed is always at top of return stack.

The branches uses the value at top of return stack as reference of offsets.

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

Pick: # branch conditional
     
		IF (W < V) PC = Move

Jump: # indirect jump

        PC = (W) 

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

## Rationale

In classic model, a Next starts every word and always jumps to address at address in first spot, if is *docol*, it push the next spot and repeats until reach an execute code. Every word does two jumps. The Next code takes 5 cycles, then each *docol* takes 3 cycles + 5 cycles, each *semis* takes 2 cycles + 5 cycles.

In version 1, 
