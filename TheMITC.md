# The Minimal Indirect Thread Code (M.I.T.C.)

_still a Stub_

## macros

Considering a RISC-V like CPU with one cycle per instruction, 4 registers as IP instruction pointer, 
        RP return stack pointer, W work scratch, V reference address, and macros:

pull R1, R2 

        R1 = (R2) ; R2 = R2 + CELL ;
        
push R1, P2  

        R2 = R2 - CELL ; (R2) = R1 ;
        
move R1, R2 
        
        R1 = R2 ;
        
jump (R1) 

        PC = (R1) ;
        
bgtu R1, R2, Label

        if R1 > R2 then jump Label ;
        
## Classic ITC, aka Fig-Forth

Enter:
        
        push IP, RP ;
        move IP, W ;
        jump Next ;

Exit:
        
        pull IP, RP ;

Next:

        pull W, IP ; 
        jump (W) ;
      
Every word must start with *Enter*. 

Words primitives ends with *Next* and words compiled ends with *Exit*.

The registers IP and W does not need be preserved, does not need register V. 

## The M.I.T.C. 

Groups all primitive words bellow a memory reference at register V.

Uses same 6 instructions of the Classic plus one for comparison.

Reorder the instructions to not need *Enter* at start of every word.

Only jumps to primitive words, a test decides it, then more 1 instruction cycle.

For all compiled words does at two jumps less than Classic, then less 2 instructions cycles.

## M.I.T.C. version 1.0

All primitive words must ends with **jump** *Unnest*.

All compiled words must ends with *Unnest*

Similar to Classic, the register IP is pushed and pulled at every word then does not need be preserved

The following instruction to be executed is always at top of return stack

The branches uses the value at top of return stack as reference of offsets.

The >R R@ R> must use the cell bellow the top of return stack, to preserve the return reference.

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



