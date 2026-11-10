# The Minimal Indirect Thread Code (M.I.T.C.)

_still a Stub_

## macros

        pull R1, R2 is R1 = (R2) ; R2 = R2 + CELL
        push R1, P2 is R2 = R2 - CELL ; (R2) = R1
        move R1, R2 is R1 = R2
        jump (R1) is PC = (R1)
        bgtu R1, R2, Label is if R1 > R2 then jump Label

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

The registers IP and W does not need be preserved 

## The M.I.T.C. 

Groups all primitive words bellow a memory reference V.

No need of *Enter* at start of every word.

Does at least two jumps less than Classic.

## M.I.T.C. version 1.0

All primitive words must ends with **jump** *Unnest*.

All compiled words must ends with *Unnest*

The register IP is pushed or pulled at ever word, it does not need be preserved inside words

The next instruction to be executed is always at top of return stack

The branches uses the value at top of return stack as reference of offsets.

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

All primitive words are bellow reference V and must ends with **jump** *Next*.

All compiled words are over reference V and must ends with *Unnest*.

No push or pull of IP within primitive words, the register IP must be preserved.

The branches uses the value of IP as reference for offsets

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



