 \ /* 
 \ ;---------------------------------------------------------------------- 
 \ ; Copyright (c) 2026, Alvaro Gomes Sobral Barcellos 
 \ ; All rights reserved. 
 \ ; 
 
\ ( -- 0 ) ( 0 ); 
: 0 
    $ 0 
    ; 
 
\ ( -- 1 ) ( 1 ); 
: 1 
    $ 1 
    ; 
 
\ ( -- 2 ) ( 2 ) ; 
: 2 
    $ 2  
    ; 
 
\ ( -- 10 ) ( 10 ); 
: 10 
    $ 10 
    ; 
 
\ ( -- w ) ( LIT ) 
: LIT 
    DOCON 
    ; 
 
\ ( -- a ) ( HERE ) 
: HERE 
    HEAP @ 
    ; 
 
\ ( u -- ) ( ALLOT ) 
: ALLOT 
    HERE + HEAP !
    ; 
 
\ ( c -- ) ( C, ) compile a char 
: C,
    HERE C! 1 ALLOT 
    ; 
 
\ ( w -- ) ( , ) compile a word 
: ,
    HERE ! CELL ALLOT 
    ; 
 
\ ( w1 -- w2 ) ( ALIGNED ) align a address to CELLS 
: ALIGNED 
    CELL 1 - >R R@ + R> INVERSE + 
    ; 
 
\ ( w1 -- w2 ) ( ALIGN ) align to CELLS 
: ALIGN 
    HERE ALIGNED HEAP ! 
    ; 
 
\ ( -- ) ( IMMEDIATE ) makes LATEST defined word IMMEDIATE 
: IMMEDIATE 
    LATEST @ CELL + DUP @ NAN OR SWAP ! 
    ; 
 
\ ( a -- a F ) ( IMMEDIATE? ) verify if a word is a immediate  
: IMMEDIATE? 
    CELL + @ NAN AND 0# 
    ; 
 
\ ( -- ) ( LITERAL ) compiles the value at top of stack 
: LITERAL 
    LIT LIT , ,
    ; IMMEDIATE
 
\ ( -- ) ( [ ) change to EXECUTE mode
: [ 
    FALSE STATE ! 
    ; IMMEDIATE
 
\ ( -- ) ( ] ) change to COMPILE mode
: ] 
    TRUE STATE ! 
    ; 
 
