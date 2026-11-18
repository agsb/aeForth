/* 
;---------------------------------------------------------------------- 
; Copyright (c) 2026, Alvaro Gomes Sobral Barcellos 
; All rights reserved. 
; 
; Redistribution and use in source and binary forms, with or without 
; modification, are permitted provided that the following conditions 
; are met: 
; 
; 1. Redistributions of source code must retain the above copyright 
;    notice, this list of conditions and the following disclaimer. 
; 
; 2. Redistributions in binary form must reproduce the above copyright 
;    notice, this list of conditions and the following disclaimer in 
;    the documentation and/or other materials provided with the 
;    distribution. 
; 
; THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 
; "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT 
; LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS 
; FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE 
; COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, 
; INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, 
; BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES 
; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER 
; CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT 
; LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN 
; ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
; POSSIBILITY OF SUCH DAMAGE. 
;---------------------------------------------------------------------- 
*/ 
 
/* 
Copyright 2026 Alvaro Gomes Sobral Barcellos 
 
This program is free software: you can redistribute it and/or modify 
it under the terms of the GNU General Public License as published by 
the Free Software Foundation, either version 2 of the License, or 
(at your option) any later version. 
 
This program is distributed in the hope that it will be useful, 
but WITHOUT ANY WARRANTY; without even the implied warranty of 
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the 
GNU General Public License for more details. 
 
You should have received a copy of the GNU General Public License 
along with this program.  If not, see <http://www.gnu.org/licenses/>. 
*/ 
 
\ --------------------------------------------------------------------- 
  AEFORTH2 compiled words 
\ --------------------------------------------------------------------- 
\ 
\  controls backwards 
\ 
\  controls forwards 
\ 
\  controls forward and backward 
\ 
\  cases, mind the data stack deep while compiling 
\ 
\  control loops 
\ 
\  counts up to limit 
\ 
\  counts down to zero 
\ 

\ --------------------------------------------------------------------- 
\ boot, init, turnkey 
 
: TURNKEY 
    INTERPRET 
    ; 
 
\ --------------------------------------------------------------------- 
\ constants 
 
\ ( -- 0 )   ( 0 )  
: 0 
    $ 0 
    ; 
 
\ ( -- 1 )  ( 1 ); 
: 1 
    $ 1 
    ; 
 
\ ( -- 2 )  ( 2  ); 
: 2 
    $ 2  
    ; 
 
\ ( -- 10 )  ( 10 ); 
: 10 
    $ 10 
    ; 
 
\ --------------------------------------------------------------------- 
 
\ ( w -- f )  ( 0= ) 
: 0= 
    0 =
    ; 
 
\ ( w -- f )  ( 0< ) 
: 0< 
    0 < 
    ; 
 
\ ( w -- f )  ( 0> ) 
: 0> 
    0 SWAP <
    ; 
 
\ --------------------------------------------------------------------- 
 
\ ( -- w )  ( LIT ) 
: LIT 
    DOCON 
    ; 
 
\ ( -- a )  ( HERE ) 
: HERE 
    HEAP @ 
    ; 
 
\ ( u -- )  ( ALLOT ) 
: ALLOT 
    HERE + HEAP !
    ; 
 
\ ( c -- )  ( C, ) compile a char 
: C,
    HERE C! 1 ALLOT 
    ; 
 
\ ( w -- )  ( , ) compile a word 
: ,
    HERE ! CELL ALLOT 
    ; 
 
\ ( w1 -- w2 )  ( ALIGNED ) align a address to CELLS 
: ALIGNED 
    CELL 1 - >R R@ + R> INVERSE + 
    ; 
 
\ ( w1 -- w2  )  ( ALIGN ) align to CELLS 
: ALIGN 
    HERE ALIGNED HEAP ! 
    ; 
 
\ ( --  )  ( IMMEDIATE ) makes LATEST defined word IMMEDIATE 
: IMMEDIATE 
    LATEST @ CELL + DUP @ NAN OR SWAP ! 
    ; 
 
\ ( a -- a F  )  ( IMMEDIATE? ) verify if a word is a immediate  
: IMMEDIATE? 
    CELL + @ NAN AND 0# 
    ; 
 
\ ( --  )  ( LITERAL ) compiles the value at top of stack 
: LITERAL 
    LIT LIT , ,
    ; IMMEDIATE
 
\ ( --  )  ( [ ) change to EXECUTE mode
: [ 
    FALSE STATE ! 
    ; IMMEDIATE
 
\ ( --  )  ( ] ) change to COMPILE mode
: ] 
    TRUE STATE ! 
    ; 
 
    
\ USE NOT CLEAR COULD BE: BEGIN WHILE REPEAT 
 
\ ( --  )  ( RECURSE ) compiles the word been compiled 
: RECURSE 
    \ there is no return, 
    LIT R> , 
    \ compile to self
    PIKE @ 
    \ take the xt
    CELL + CELL + 
    \ could cause dead loops 
    , 
    ; 
 
\ --------------------------------------------------------------------- 
 
\ ( -- ) ( CODE ), starts native code, ZZZZ 
: CODE 
  	\ enable ASM vocabulary 
	NOOP
    ; 
 
\ ( -- ) ( END-CODE ), ends native code, ZZZZ 
: END-CODE 
  	\ disable ASM vocabulary 
	NOOP
    ; 
 
\ ( -- ) ( ;CODE ), does a native call ZZZZ 
: ;CODE 
	NOOP
    ; 
 
\ ( w -- ) ( :CODE ), does a native call ZZZZ 
: ;CODE 
    R> BEHAVE 
    ; 
 
\ ( w -- )  ( CODE; ), does a native return ZZZZ 
\  in RISCV 8067 is jalr zero, 0 (ra) 
: CODE; 
    $ 8067 ,  
    ; 
 
\ --------------------------------------------------------------------- 
  
\  remember 0x0 is FALSE, ever 
  
 
\ ( -- a )  ( BEGIN ), mark a backward offset 
: BEGIN 
    HERE 
    ; IMMEDIATE
 
\ ( -- )  ( BACK ), goes backward 
: BACK 
    HERE - , 
    ; IMMEDIATE
 
\ ( a -- )  ( AGAIN ) goes back always 
: AGAIN 
    LIT BRANCH , 
    BACK 
    ; IMMEDIATE
 
\ ( a -- )  ( UNTIL ) goes back, when TOS is zero 
: UNTIL 
    LIT ZBRANCH , 
    BACK 
    ; IMMEDIATE
 
  strange word 
\ ( a -- )  ( WHILST ) goes back, when TOS greater than zero 
: WHILST 
    LIT GBRANCH , 
    BACK 
    ; IMMEDIATE
    ; 
 
\ --------------------------------------------------------------------- 
 
\ ( -- a )  ( MARK ) mark a forward offset 
: MARK 
    HERE 0 , 
    ; IMMEDIATE
 
\ ( -- )  ( ENDIF ) resolves a forwad branch 
: ENDIF 
    HERE OVER - SWAP ! 
    ; IMMEDIATE
 
\ ( -- a  )  ( AHEAD ) goes forward
: AHEAD 
    LIT BRANCH , 
    MARK 
    ; IMMEDIATE
 
\ ( --  )  ( IF ) goes forward when TOS = 0
: IF 
    LIT ZBRANCH , 
    MARK 
    ; IMMEDIATE
 
\ strange word 
\ ( --  )  ( UNTO ) goes forward when TOS > 0
: UNTO 
    LIT GBRANCH , 
    MARK 
    ; IMMEDIATE
 
\ ( --  )  ( ELSE ) resolves a IF
: ELSE 
    LIT BRANCH , 
    MARK SWAP ENDIF 
    ; IMMEDIATE
 
\ ( --  )  ( THEN ) ends a IF
: THEN 
    ENDIF 
    ; IMMEDIATE
 
\ --------------------------------------------------------------------- 
 
\ ( --  )  ( WHILE ) goes forward, when TOS is zero
: WHILE 
    LIT ZBRANCH , 
    MARK SWAP 
    ; IMMEDIATE
 
\ ( --  )  ( REPEAT ) goes backward to begin 
: REPEAT 
    LIT BRANCH , 
    BACK ENDIF 
    ; IMMEDIATE 
 
\ ( -- a  )  ( AFT ) goes forward, AFTER 
: AFT 
    DROP 
    LIT BRANCH , 
    MARK HERE SWAP 
    ; IMMEDIATE 
 
\ --------------------------------------------------------------------- 
 
\ ( w1 w2 -- ; -- w2 w1  )  ( DO ) makes a count up 
\  limit index DO 
    HERE 
    LIT >R , 
    LIT >R , 
    ; IMMEDIATE 
 

: do_pass 
    \ counter 
    LIT R> , 
    LIT + , 
    LIT OVER , 
    LIT OVER , 
    LIT EQU , 
    LIT ZBRANCH , 
    HERE - , 
    ; IMMEDIATE
 
: do_drops 
    LIT DROP , 
    LIT DROP , 
    ; IMMEDIATE
 
\ ( -- ; w2 w1 -- w2 w1  )  ( LOOP ) 
: LOOP
    \  limit 
    LIT R> , 
    \  increment by 1 
    LIT 1 , 
    \  do 
    do_pass 
    ; IMMEDIATE
 
\ ( w -- ; w2 w1 -- w2 w1  )  ( +LOOP ) 
: +LOOP
    \  limit 
    LIT R> , 
    \  increment by value 
    LIT SWAP , 
    \  do 
     DO_PASS 
    ; IMMEDIATE 
 
\ ( -- w1 ; w2 w1 -- w2 w1  )  ( I ) 
: I
    LIT R@ , 
    ; IMMEDIAT
 
\ ( -- w3 ; w4 w3 w2 w1 -- w4 w3 w2 w1  )  ( J ) 
    LIT R> , 
    LIT R> , 
    LIT R@ , 
 
    LIT SWAP , 
    LIT >R , 
    LIT SWAP , 
    LIT >R , 
    ; IMMEDIATE
 
\ ( -- ; w2 w1 --  )  ( LEAVE ) 
    LIT R> , 
    LIT R> , 
    DO_DROPS 
    ; IMMEDIATE
 
\ --------------------------------------------------------------------- 
 
\ ( w -- ; -- w  )  ( FOR ) make a count down to zero 
    HERE 
    LIT >R , 
    ; IMMEDIATE
 
\ ( -- ; w -- w  )  ( NEXT ) 
    LIT R> , 
    LIT 1 , 
    LIT - , 
    LIT DUP , 
    LIT GBRANCH , 
    LIT DROP , 
    ; IMMEDIATE
 
\ --------------------------------------------------------------------- 
\  note: each case place a reference into data stack ! 
\  better order most used options and define a new word as 
\
\  : case-wherever- ( w -- )
\     \ most frequent first
\     DUP 0 EQU IF ... ; THEN 
\     DUP 1 EQU IF ... ; THEN 
\     DUP 2 EQU IF ... ; THEN 
\     DUP 3 EQU IF ... ; THEN 
\     \ default
\     DROP ... ; ; 
  
 
\ ( --  )  ( CASE ) 
: CASE
    0 
    ; 
 
: OF
    1 + >R 
    LIT OVER , 
    LIT EQU , 
    LIT ZBRANCH , 
    HERE 0 , 
    DROP R> 
    ; 
 
: END-OF
    LIT BRANCH , 
    HERE 0 , 
    SWAP DUP HERE 
    SWAP - SWAP ! 
    ; 
 
: END_CASE
    LIT DROP , 
    DUP 0 EQU 
    IF DROP ; 
    THEN 0 
    DO DUP 
    HERE SWAP - SWAP ! 
    LOOP 
    ; 
 
\ --------------------------------------------------------------------- 
 
\ ( --  )  ( :ISNAME ) makes a header 
    LATEST @ , 
    HASH , 
    ; 
 
\ ( --  )  ( :NONAME ) makes a content 
    HERE LBRACK 
    ; 
 
\ ( --  )  ( : ) aka figforth semicolon 
      SAVE HERE, PANIC IF SEMIS NOT FOLLOW ELSEWHERE 
    HEAP @ PIKE ! 
      STAT IS COMPILE 
    LITERAL COMPILE STATE ! 
      MAKE A HEADER 
    ISNAME 
    ; 
 
\ ( --  )  ( ; ) aka figforth semicolon, is IMMEDIATE 
      LOAD LAST, PANIC IF COLON NOT LEAD ELSEWHERE 
    PIKE @ LATEST ! 
      STATE IS EXECUTE 
    LITERAL EXECUTE STATE ! 
      MAKE A FOOTER 
    LIT ; , 
    ; 
 
  classic djb2 hash algorithm, with XOR, adapted from cdb_hash 
\ ( c w -- w  )  ( DJB2 ) 
    DUP DUP + 
    DUP + DUP + 
    DUP + DUP + 
    + XOR 
    ; 
 
  crude token consumes a unlimited between spaces 
  return the hash of a token word 
\ ( -- h  )  ( ) 
      SKIP SPACES 
    LITERAL BL 
    BEGIN 
    KEY OVER OVER EQU INVERSE 
    UNTIL 
      PREPARE DJB2 CONSTANT, ADAPTED FROM CDB_HASH 
    LITERAL 5381 >R 
      SCAN SPACES AND DO HASH 
    BEGIN 
    R> DJB2 >R 
    KEY OVER OVER EQU 
    INVERSE UNTIL 
    DROP DROP 
      CLEAR HASH HIGH BIT 
    R> LITERAL MASK_IMM AND 
    ; 
 
\ ( h -- a | 0  )  ( SEEK ) 0 is not found 
    LATEST 
      FIND THE HASH 
    BEGIN 
    @ DUP 
      MISSED ? 
    WHILE 
      TAKE THE HASH 
    OVER OVER 
    CELL + @ 
      MASK IMMEDIATE FLAG 
    LITERAL MASK_IMM AND EQU 
      FOUND ? 
    WHILE 
      NOT FOUND 
    REPEAT 
    THEN 
      LEAVE ONLY THE RESULT 
    SWAP DROP 
    ; 
 
\ ( -- xt  )  ( ' ) tick, return the xt of a 
    HASH SEEK DUP 
    IF CELL + CELL + 
    ELSE DROP ABORT 
    THEN 
    ; 
 
\ ( --  )  ( POSTP1 ) compile the xt of a 
    TICK , 
    ; 
 
\ ( --  )  ( INTERPRET ) 
    BEGIN 
    \   found and eval ? 
    HASH SEEK DUP IF 
    \   found 
    IMMEDIATEQ STATE @ INVERSE OR 
        IF EXECUTE ELSE COMPILE THEN 
	\   still not numbers, use $ and hexadecimal 
         ABORT 
    ELSE 
	\   still not numbers, use $ and hexadecimal 
	    ABORT 
	THEN 
      NEXT WORD 
    AGAIN 
    ; 
 
\ --------------------------------------------------------------------- 
 
  those must be compiled 
 
: EXECUTE 
\ ( w1 -- ; -- w2  )  ( EXECUTE ), execute a in Forth 
    >R 
    ; 
 
: COMPILE 
    , 
    ; 
 
  defined by GForth-0.0 
: PERFORM 
    @ EXECUTE 
    ; 
 
\ --------------------------------------------------------------------- 
 
: SPACE 
    LITERAL BL EMIT 
    ; 
 
\ ( u --  )  emits u spaces 
: SPACES 
    BEGIN DUP 
    WHILE SPACE EMIT 
    1 - 
    REPEAT DROP 
    ; 
 
\ ( a u --  )  emits u characters from address a, 
  return next aligned address 
: TYPE 
    BEGIN DUP 
    WHILE >R 
    DUP C@ EMIT 
    1 + R> 
    1 - 
    REPEAT DROP 
    1 + 
    ; 
 
  :nonames :) 
 
\ ( a -- F) )  valid ascii character ? space to tilde 
dot_ascii: 
    DUP 
    LITERAL BL SWAP LESS IF 
    LITERAL DEL LESS IF 
    TRUE ; 
    THEN THEN FALSE 
    ; 
 
do_commas:  copy characters 
    LITERAL QU 
    BEGIN KEY 
    DUP WHILE 
    OVER OVER LESS 
    WHILE C, 
    REPEAT 
    C, ALIGN 
    ; 
 
\ ( a -- a  )  emits a asciiz from address a 
  returns next address 
: TYPEZ 
do_typez: 
    BEGIN DUP C@ DUP 
    WHILE EMIT 1 + 
    REPEAT DROP 1 + 
    ; 
 
do_quotes: 
    RTO, DO_TYPEZ >R 
    ; 
 
\ ( "<ccc>" --  )  compiles asciiz and type it at executing 
: ." 
    LITERAL DO_QUOTES ,, DO_COMMAS 
    ; 
 
\ --------------------------------------------------------------------- 
  
\ All numbers are prefixed by a dollar :) $ NNN 
  
\ >number not made, only $ and . for hexadecimals 
  
: HEX 
    $ 16 BASE ! 
    ; 
 
: DEC 
    $ 10 BASE ! 
    ; 
 
: OCT 
    $ 8 BASE ! 
    ; 
 
: BIN 
    $ 2 BASE ! 
    ; 
 
\ --------------------------------------------------------------------- 
 
\ ( --  )  ( CREATE ) 
: CREATE
    ISNAME LIT LIT , 
    HERE CELL + CELL + , 
    LIT EXIT , 
    LIT EXIT , 
    ; IMMEDIATE
 
\ ( --  )  ( DOES> ) 
: DOES>
    R> LATEST @ CELL + CELL + CELL + CELL + ! 
    ; IMMEDIATE
 
\ ( --  )  ( BUILDS ) 
: <BUILDS
    CREATE 
    ; 
 
\ ( --  )  ( VARIABLE ) 
: VARIABLE
    CREATE 0 , 
    ; 
 
\ ( w --  )  ( CONSTANT ) 
: CONSTANT
    CREATE , DOES @ 
    ; 
 
\ ( w --  )  ( BUFFER ) 
: BUFFER
    CREATE ALLOT 
    ; 
 
\ ( w --  )  ( ARRAY ) 
: ARRAY
    CREATE ALLOT 
    DOES + @ 
    ; 
 
\ --------------------------------------------------------------------- 
 
\ ( w --  )  ( VALUE ) 
: VALUE
    CONSTANT 
    ; 
 
\ ( w --  )  ( TO ) 
: TO
    TICK 
    STATE @ 
    IF LIT LIT , 
    , 
    LIT ! ! 
    ELSE ! 
    THEN 
    ; 
 
\ --------------------------------------------------------------------- 
 
\ ( --  )  ( DEFER ) 
: DEFER
    ISNAME 
    LIT ; , 
    LIT ; , 
    ; IMMEDIATE
 
\ ( --  )  ( IS ) 
: IS
    TICK ! 
    ; 
 
\ --------------------------------------------------------------------- 
 
\ ( c --  )  ( SKIPK ) skip while equal key 
: SKIPK
    BEGIN KEY OVER OVER = 
    IF DROP FALSE ELSE TRUE THEN 
    UNTIL 
    ; 
 
\ ( c --  )  ( SCANK ) scan while not equal key 
: SCANK
    BEGIN KEY OVER OVER = INVERSE 
    IF DROP FALSE ELSE TRUE THEN 
    UNTIL 
    ; 
 
\ ( --  )  ( ( ) scan while not ') 
: (
    LITERAL ')' SCANK DROP 
    ; 
 
\ ( --  )  ( \ ) scan to new line 
: \
    LITERAL '\N' SCANK DROP 
    ; 
 
\ --------------------------------------------------------------------- 
\ two cells stuff 
 
 
\ ( w1 w2 -- w1 w2 w1 w2  )  ( 2DUP ) 
: 2DUP 
    OVER OVER 
    ; 
 
\ ( w1 w2 --  )  ( 2DROP ) 
: 2DROP 
    DROP DROP 
    ; 
 
\ ( w1 w2 w3 w4 -- w3 w4 w1 w2  )  ( 2DROP ) 
: 2SWAP 
    ROT >R ROT R> 
    ; 
 
\ ( w1 w2 w3 w4 -- w1 w2 w3 w4 w1 w2  )  ( 2OVER ) 
: 2OVER 
    >R OVER OVER R> 
    SWAP >R SWAP R> 
    ; 
 
\ ( w1 w2 -- u1 u2  )  ( 2@ ) 
: 2@ 
    DUP CELL + @ SWAP @ 
    ; 
 
\ ( w1 w2 w3 w4 --  )  ( 2! ) 
: 2! 
    SWAP OVER ! CELL + ! 
    ; 
 
\ ( w1 w2 -- ; -- w2 w1  )  ( 2>R ) 
: 2>R 
    SWAP >R >R 
    ; 
 
\ (  -- w1 w2 ; w2 w1 --  )  ( 2R> ) 
: 2R> 
    R> R> SWAP 
    ; 
 
\ ( -- w1 w2 ; w2 w1 -- w2 w1  )  ( 2R@ ) 
: 2R@ 
    R> R> 2DUP >R >R SWAP 
    ; 
 
\ ( w1 w2 w3 w4 -- w3 w4  )  ( 2NIP ) 
: 2NIP 
    NIP NIP 
    ; 
 
\ --------------------------------------------------------------------- 
 
\ ( w -- w/2  )  ( 2/ ) 
: 2/ 
    1 RSHIFT 
    ; 
 
\ ( w -- w*2  )  ( 2* ) 
: 2* 
    1 LSHIFT 
    ; 
 
\ --------------------------------------------------------------------- 
 
\ ( -- c ) ( BL ) white space to TOS
: BL 
    $ 32 
    ; 
 
\ ( -- c ) ( QU ) double quotes to TOS
: QU 
    $ 34 
    ; 
 
\ ( a -- ) ( ON ) store TRUE at address
: ON 
    TRUE SWAP ! 
    ; 
 
\ ( a -- ) ( OFF ) store FALSE at address
: OFF 
    FALSE SWAP ! 
    ; 
 
\ --------------------------------------------------------------------- 
 
\ ( a w --  )  ( +! ) plus and store 
: +! 
    DUP @ + SWAP ! 
    ; 
 
\ ( w1 w2 w3 -- w4  ( */ ) w4 = w1 * w2 / w3 
: */ 
    >R BYMUL R> BYMOD DROP
    ;
 
\ ( w1 w2 -- w2  )  ( NIP ) 
: NIP 
    SWAP DROP 
    ; 
 
\ ( w1 w2 -- w2 w1 w2  )  ( TUCK ) 
: TUCK 
    DUP >R SWAP R> 
    ; 
 
\ ( w -- w | w w   )  ( ?DUP ) 
: ?DUP 
    DUP IF DUP THEN 
    ; 
 
: PICK 
\ ( u --  )  ( PICK ) 
    CELLS SP@ + @ 
    ; 
 
\ ( u --  )  ( ROLL ) ZZZZ 
: ROLL 
    DUP 
    BEGIN 
    WHILE SWAP >R 
    REPEAT 
    BEGIN 
    WHILE R> 
    REPEAT 
    ; 
 
\ --------------------------------------------------------------------- 
\ E.10 The optional Exception set 
 
VARIABLE HANDLER

$ 0 HANDLER !

: CATCH 
    SP@ >R 
    HANDLER @ >R 
    EXECUTE 
    R> HANDLER ! 
    R> DROP 
    $ 0 
    ; 
 
: THROW 
    QDUP IF 
    HANDLER @ >R 
    R> HANDLER ! 
    R> SWAP >R 
    SPTO DROP >R 
    THEN 
    ; 
 
: ABORT 
    TRUE THROW 
    ; 
 
\ --------------------------------------------------------------------- 
\ E.12 The optional Facility set 
 
: +FIELD 
    CREATE OVER , + DOES> @ + 
    ; 
 
: BEGIN-STRUCTURE 
    CREATE HERE 0 0 , DOES> @ 
    ; 
 
: END-STRUCTURE 
    SWAP ! 
    ; 
 
\ --------------------------------------------------------------------- 
