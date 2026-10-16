# Why Use Tos

Comparing the RISCV code for use dedicated registers

The pointers IP, SP, RP are better keeped in dedicated registers 
    but what about TOS and NOS ?

In next table, consider registers T and N as dedicated and A and B as temporary,
the indice is number of operations for a common used word.

## What

| word | no | TOS | TOS and NOS | action | 
| --- | --- | --- | --- | --- |
| drop | 1 | 2 | 3 | ( w -- ) |
| dup  | 3 | 2 | 3 | ( w -- w w ) |
| over | 3 | 4 | 5 | (w1 w2 -- w1 w2 w1 ) |
| swap | 4 | 3 | 3 | ( w1 w2 -- w2 w1 ) |
|  |  |  |  |  | 
| @ | 3 | 1 | 1 | ( w1 -- w2 ) |
| ! | 4 | 3 | 3 | ( w1 w2 -- ) |
|  |  |  |  |  | 
| >R | 4 | 4 | 5 | ( w -- ; -- w ) |
| R> | 4 | 4 | 5 | ( -- w ; w -- ) |
| R@ | 3 | 3 | 4 | ( -- w ; w -- w ) 
|  |  |  |  |  | 
| test | 3 | 4 | 5 | test and drop the value at top of stack, (beqz, bltz, etc) |
| one  | 3 | 1 | 1 | one parameter operations, (negate, inverse, etc) |
| two  | 5 | 3 | 3 | two parameter operations (and, shift, plus, etc) |
|  |  |  |  |  | 
| total | 40 | 32 | 40 | |

Overall use a dedicated register as TOS is the better option

## How

    sp++ is addi sp, sp, +4; 
    sp-- is addi sp, sp, -4;
    pull is lw R, 0 (P); sp++;
    push is sp--; sw R, 0 (P);
   
to do a DROP;

    1. sp++; 
    2. lw T, 0(sp); sp++; 
    3. mv T, N; lw N, 0(sp); sp++; 
 
to do a DUP;

    1. lw A, 0(sp); sp--; sw A, 0(sp);
    2. sp--; sw T, 0(sp);
    3. sp--; sw N, 0(sp); mv N, T;
 
to do a OVER

    1. lw A, 4(sp); sp--; sw A, 0(sp);
    2. lw A, 0(sp); sp--; sw T, 0(sp); mv T, A;
    3. sp--; sw N, 0(sp); mv A, N; mv N, T; mv T, A;

to do a SWAP

    1.lw A, 0(sp); lw B, 4(sp); sw B, 0(sp); sw A, 4(sp) 
    2.lw A, 0(sp); sw T, 0(sp); mv T, A;
    3.mv A, N; mv N, T; mv T, A;

to do a @

    1. lw A, 0(sp); lw A, 0(A); sw A, 0(sp);
    2. lw T, 0(T);
    3. lw T, 0(T);

to do a !

    1. lw A, 0(sp); sp++; lw B, 0(sp); sp++; sw B, 0(A);
    2. lw A, 0(sp); sp++; sw A, 0(T); lw T, 0 (sp); sp++;
    3. sw N, 0(T); lw T, 0(sp); sp++; lw N, 0(sp); sp++;

to do a >R

    1. lw A, 0(sp); sp++; rp--; sw A, 0(rp);
    2. rp--; sw T, 0(rp); lw T, 0(sp); sp++;
    3. rp--; sw T, 0(rp); mv T, N; lw N, 0(sp); sp++;

to do a R>

    1. lw A, 0(rp); rp++; sp--; sw A, 0(sp);
    2. sp--; sw T 0(sp); lw T, 0(rp); rp++; 
    3. sp--; sw N, 0(sp); mv N, T; lw T, 0(rp); rp++;

to do a R@

    1. lw A, 0(rp); sp--; sw A, 0(sp);
    2. sp--; sw T, 0(sp); lw T, 0(rp);  
    3. sp--; sw N, 0(sp); mv N, T; lw N, 0(rp); 
    
to do a top of stack test 

    1. lw A, 0(sp); sp++; test(A); 
    2. mv A, T; lw T, 0(sp); sp++; test(A);
    3. mv A, T; mv T, N; lw N, 0(sp); sp++; test(A);

to do any operation with one parameter

    1. lw A, 0(sp); oper(A); sw A, 0(sp);
    2. oper(T);
    3. oper(T);

to do any operation with two parameters

    1. lw A, 0(sp); sp++; lw B, 0(sp); (oper) A, A, B; sw A, 0(sp);
    2. lw A, 0(sp); sp++; (oper) T, T, A;
    3. (oper) T, T, N; lw N, 0(sp); sp++;

## Snipts

