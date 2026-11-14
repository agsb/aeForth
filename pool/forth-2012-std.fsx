
\ https://forth-standard.org/standard/implement

\ --------------------------------------------------------------------- 
: QUIT
   ( empty the return stack and set the input source to the user input device )
   POSTPONE [
     REFILL
   WHILE
     ['] INTERPRET CATCH
     CASE
      0 OF STATE @ 0= IF ." OK" THEN CR ENDOF
     -1 OF ( Aborted ) ENDOF
     -2 OF ( display message from ABORT" ) ENDOF
     ( default ) DUP ." Exception # " .
     ENDCASE
   REPEAT BYE
;

: ACTION-OF
   STATE @ IF
     POSTPONE ['] POSTPONE DEFER@
   ELSE
     ' DEFER@
   THEN ; IMMEDIATE


: DEFER ( "name" -- )
   CREATE ['] ABORT ,
   DOES> ( ... -- ... )
   @ EXECUTE ;

: DEFER! ( xt2 xt1 -- )
   >BODY ! ;

: DEFER@ ( xt1 -- xt2 )
   >BODY @ ;

: HOLDS ( addr u -- )
   BEGIN DUP 
   WHILE 1- 2DUP + C@ HOLD 
   REPEAT 2DROP ;

: IS
   STATE @ IF
     POSTPONE ['] POSTPONE DEFER!
   ELSE
     ' DEFER!
   THEN ; IMMEDIATE


: isspace? ( c -- f )
   BL 1+ U< ;

: isnotspace? ( c -- f )
   isspace? 0= ;

: xt-skip ( addr1 n1 xt -- addr2 n2 )
   \ skip all characters satisfying xt ( c -- f )
   >R
   BEGIN
     DUP
   WHILE
     OVER C@ R@ EXECUTE
   WHILE
     1 /STRING
   REPEAT THEN
   R> DROP ;

: parse-name ( "name" -- c-addr u )
   SOURCE >IN @ /STRING
   ['] isspace? xt-skip OVER >R
   ['] isnotspace? xt-skip ( end-word restlen r: start-word )
   2DUP 1 MIN + SOURCE DROP - >IN !
   DROP R> TUCK - ;

\ E.10 The optional Exception word set

VARIABLE HANDLER 0 HANDLER ! \ last exception handler

: CATCH ( xt -- exception# | 0 \ return addr on stack
   SP@ >R             ( xt )       \ save data stack pointer
   HANDLER @ >R       ( xt )       \ and previous handler
   RP@ HANDLER !      ( xt )       \ set current handler
   EXECUTE            ( )          \ execute returns if no THROW
   R> HANDLER !       ( )          \ restore previous handler
   R> DROP            ( )          \ discard saved stack ptr
    0                 ( 0 )        \ normal completion
;

: THROW ( ??? exception# -- ??? exception# )
    ?DUP IF          ( exc# )     \ 0 THROW is no-op
      HANDLER @ RP!   ( exc# )     \ restore prev return stack
      R> HANDLER !    ( exc# )     \ restore prev handler
      R> SWAP >R      ( saved-sp ) \ exc# on return stack
      SP! DROP R>     ( exc# )     \ restore stack
      \ Return to the caller of CATCH because return
      \ stack is restored to the state that existed
      \ when CATCH began execution
    THEN
;

: ABORT -1 THROW ;

\ E.12 The optional Facility word set

: +FIELD  \ n <"name"> -- ; Exec: addr -- 'addr
   CREATE OVER , +
   DOES> @ +
;

: BEGIN-STRUCTURE  \ -- addr 0 ; -- size
   CREATE
     HERE 0 0 ,    \ mark stack, lay dummy
   DOES> @         \ -- rec-len
;

: END-STRUCTURE  \ addr n --
   SWAP ! ;      \ set len 

\ E.14 The optional File-Access word set

: INCLUDE ( i*x "name" -- j*x )
   PARSE-NAME INCLUDED ;

: REQUIRE ( i*x "name" -- i*x )
   PARSE-NAME REQUIRED ;

\ E.18 The optional Locals word set

: LOCALS| ( "name...name |" -- )
   BEGIN
   BL WORD COUNT OVER C@
   [CHAR] | - OVER 1 - OR WHILE
   (LOCAL)
   REPEAT 2DROP 0 0 (LOCAL)
; IMMEDIATE

12345 CONSTANT undefined-value

: match-or-end? ( c-addr1 u1 c-addr2 u2 -- f )
   2 PICK 0= >R COMPARE 0= R> OR ;

: scan-args
   \ 0 c-addr1 u1 -- c-addr1 u1 ... c-addrn un n c-addrn+1 un+1
   BEGIN
     2DUP S" |" match-or-end? 0= WHILE
     2DUP S" --" match-or-end? 0= WHILE
     2DUP S" :}" match-or-end? 0= WHILE
     ROT 1+ PARSE-NAME
   AGAIN THEN THEN THEN ;

: scan-locals
   \ n c-addr1 u1 -- c-addr1 u1 ... c-addrn un n c-addrn+1 un+1
   2DUP S" |" COMPARE 0= 0= IF
     EXIT
   THEN
   2DROP PARSE-NAME
   BEGIN
     2DUP S" --" match-or-end? 0= WHILE
     2DUP S" :}" match-or-end? 0= WHILE
     ROT 1+ PARSE-NAME
     POSTPONE undefined-value
   AGAIN THEN THEN ;

: scan-end ( c-addr1 u1 -- c-addr2 u2 )
   BEGIN
     2DUP S" :}" match-or-end? 0= WHILE
     2DROP PARSE-NAME
   REPEAT ;

: define-locals ( c-addr1 u1 ... c-addrn un n -- )
   0 ?DO
     (LOCAL)
   LOOP
   0 0 (LOCAL) ;

: {: ( -- )
   0 PARSE-NAME
   scan-args scan-locals scan-end
   2DROP define-locals
; IMMEDIATE


\ --------------------------------------------------------------------- 

: [DEFINED] BL WORD FIND NIP 0<> ; IMMEDIATE

: [ELSE] ( -- )
    1 BEGIN                                          \ level
       BEGIN BL WORD COUNT DUP WHILE                  \ level adr len
         2DUP S" [IF]" COMPARE 0= IF                  \ level adr len
             2DROP 1+                                 \ level'
          ELSE                                        \ level adr len
            2DUP S" [ELSE]" COMPARE 0= IF             \ level adr len
                2DROP 1- DUP IF 1+ THEN               \ level'
            ELSE                                      \ level adr len
                S" [THEN]" COMPARE 0= IF              \ level
                   1-                                 \ level'
               THEN
             THEN
          THEN ?DUP 0= IF EXIT THEN                   \ level'
       REPEAT 2DROP                                   \ level
   REFILL 0= UNTIL                                   \ level
    DROP
; IMMEDIATE

: [IF] ( flag -- )
   0= IF POSTPONE [ELSE] THEN
; IMMEDIATE

: [THEN] ( -- ) ; IMMEDIATE

: [UNDEFINED] BL WORD FIND NIP 0= ; IMMEDIATE


\ --------------------------------------------------------------------- 

E.16.6.1.1647
GET-ORDER
Here is a very simple search order implementation:

VARIABLE #order

CREATE context 16 ( wordlists ) CELLS ALLOT

: GET-ORDER ( -- wid1 ... widn n )
   #order @ 0 ?DO
     #order @ I - 1- CELLS context + @
   LOOP
   #order @
;
E.16.6.1.2197
SET-ORDER
This is the complement of E.16.6.1.1647 GET-ORDER.

: SET-ORDER ( wid1 ... widn n -0 )
   DUP -1 = IF
     DROP <push system default word lists and n>
   THEN
   DUP #order !
   0 ?DO I CELLS context + ! LOOP
;


: ALSO ( -- )
   GET-ORDER OVER SWAP 1+ SET-ORDER
;


: (wordlist) ( wid "<name>" – ; )
   CREATE ,
   DOES>
     @ >R
     GET-ORDER NIP
     R> SWAP SET-ORDER
;

\ FORTH-WORDLIST (wordlist) FORTH

: ONLY ( -- ) -1 SET-ORDER ;

: PREVIOUS ( -- ) GET-ORDER NIP 1- SET-ORDER ;


\ --------------------------------------------------------------------- 
\ google GEMINI

\ We need a pointer to track our position in the hold buffer.
\ Pictured numeric output builds the string from right to left.
VARIABLE HLD

\ Create a small buffer for the formatted string (typically 32 to 64 bytes is plenty).
CREATE HOLD-BUF 64 ALLOT
HERE CONSTANT HOLD-BUF-END

\ <#  ( -- )
\ Initializes the conversion process by setting the pointer to the end of the buffer.
: <# ( -- )
    HOLD-BUF-END HLD ! ;

\ HOLD ( char -- )
\ Decrements the pointer and inserts a raw character into the buffer.
: HOLD ( char -- )
    -1 HLD +! HLD @ C! ;

\ # ( ud1 -- ud2 )
\ Converts the lowest digit of a double-cell unsigned number based on BASE.
\ Divides ud1 by BASE, leaves the remainder (the digit) to put in HOLD,
\ and leaves the quotient ud2 on the stack for the next step.
: # ( ud1 -- ud2 )
    BASE @ UD/MOD ( rem-num quot-ud )
    ROT           ( quot-ud rem-num )
    DUP 9 > IF 
        7 +       ( adjust for hex digits A-F if necessary )
    THEN
    [CHAR] 0 + HOLD ;

\ #S ( ud1 -- ud2 )
\ Converts all remaining digits. It always executes at least once.
: #S ( ud1 -- ud2 )
    BEGIN
        #
        2DUP OR 0= ( check if double-cell quotient is 0 )
    UNTIL ;

\ SIGN ( n -- )
\ If the single-cell flag on top of the stack is negative, adds a '-' to the buffer.
: SIGN ( n -- )
    0< IF [CHAR] - HOLD THEN ;

\ #> ( ud -- c-addr u )
\ Finalizes the text generation. Drops the remaining 0 double-cell quotient
\ and returns the start address of the string and its length.
: #> ( ud -- c-addr u )
    2DROP              \ drop the leftover double-cell 0
    HLD @              \ start address of the formatted string
    HOLD-BUF-END HLD @ - \ calculate length

#---------------------------------------------------------------------- 

: # 
	BASE @ M/MOD ROT 9 OVER < IF 7 + THEN 30 + HOLD ;

: #> 
	DROP DROP HLD @ PAD OVER - ;

: <#	
	PAD HLD ! ;

: #S
	BEGIN # OVER OVER OR 0= UNTIL ;

: (.")
	R> COUNT OVER OVER + EVEN >R TYPE ;

: (;CODE)
	R> LATEST PFA CFA ! ;

: ;CODE
	?CSP COMPILE (;CODE) [COMPILE] [
	ASSEMBLER ; IMMEDIATE

: (NUMBER)
	BEGIN 1+ DUP >R C@ BASE @ DIGIT
	WHILE SWAP BASE @ U* DROP ROT BASE @ U* D+ DPL @ 1+
	IF 1 DPL +1 ENDIF R>
	REPEAT R>;

#---------------------------------------------------------------------- 

FIND ?DUP 
IF                                     ( xt +-1 )
   STATE @ 
   IF                                     ( xt +-1 )
     0> IF EXECUTE ELSE COMPILE, THEN   ( ??? )
   ELSE                                            ( xt +-1 )
     DROP EXECUTE                                ( ??? )
   THEN
ELSE                                              ( c-addr )
   ( whatever you do for an undefined word )
THEN
... 

VARIABLE HANDLER 0 HANDLER ! \ last exception handler

def_word "catch" hash_CATCH

: CATCH ( xt -- exception# | 0 \ return addr on stack
   SP@ >R             ( xt )       \ save data stack pointer
   HANDLER @ >R       ( xt )       \ and previous handler
   RP@ HANDLER !      ( xt )       \ set current handler
   EXECUTE            ( )          \ execute returns if no THROW
   R> HANDLER !       ( )          \ restore previous handler
   R> DROP            ( )          \ discard saved stack ptr
    0                 ( 0 )        \ normal completion
;

: THROW ( ??? exception# -- ??? exception# )
    ?DUP IF          ( exc# )     \ 0 THROW is no-op
      HANDLER @ RP!   ( exc# )     \ restore prev return stack
      R> HANDLER !    ( exc# )     \ restore prev handler
      R> SWAP >R      ( saved-sp ) \ exc# on return stack
      SP! DROP R>     ( exc# )     \ restore stack
      \ Return to the caller of CATCH because return
      \ stack is restored to the state that existed
       \ when CATCH began execution
    THEN
;


#---------------------------------------------------------------------- 

# : 2NIP 2SWAP 2DROP ;
# : 2TUCK 2SWAP 2OVER ;

