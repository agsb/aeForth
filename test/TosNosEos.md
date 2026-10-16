# Why Use Tos

Comparing the RISCV code for use dedicated registers

The pointers IP; SP; RP are keeped in registers; 
    but what about TOS and NOS ?

Consider registers T and N as dedicated and A and B as temporary;
in cases of: 
    1. no TOS and no NOS  
    2. a TOS and no NOS 
    3. a TOS and a NOS 

## what

| word | no | TOS | TOS and NOS | action | 
| --- | --- | --- | --- | --- |
| drop | 1 / 0  | 2 / 1 | 3 / 2 | ( w -- ) |
| dup  | 3 / 1 | 2 / 0 | 3 / 1 | ( w -- w w ) |
| over | 3 / 0 | 4 / 1 | 5 / 2 | (w1 w2 -- w1 w2 w1 ) |
| swap | 4 / 1 | 3 / 0 | 3 / 0 | ( w1 w2 -- w2 w1 ) |
|  |  |  |  |  | 
| >R | 4 / 0 | 4 / 0 | 5 / 1 | ( w -- ; -- w ) |
| R> | 4 / 0 | 4 / 0 | 5 / 1 | ( -- w ; w -- ) |
| R@ | 3 / 0 | 3 / 0 | 4 / 1 | ( -- w ; w -- w ) 
|  |  |  |  |  | 
| test | 3 / 0 | 4 / 1 | 5 / 2 | test value at top of stack |
| one  | 3 / 2 | 1 / 0 | 1 / 0| one parameter operations |
| two  | 5 / 2 | 3 / 0 | 3 / 0| two parameter operations |
|  |  |  |  |  | 
|  |  |  |  |  |    
## How do

    sp++ is addi sp, sp, +4; 
    sp-- is addi sp, sp, -4;
   
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

