
\ E.22 The optional Search-Order word set

VARIABLE #order

CREATE context 16 ( wordlists ) CELLS ALLOT

\ E.16.6.1.1647 GET-ORDER
\ Here is a very simple search order implementation:
: GET-ORDER ( -- wid1 ... widn n )
   #order @ 0 ?DO
     #order @ I - 1- CELLS context + @
   LOOP
   #order @
;

\ E.16.6.1.2197 SET-ORDER
\ This is the complement of E.16.6.1.1647 GET-ORDER.
: SET-ORDER ( wid1 ... widn n -0 )
   DUP -1 = IF
     DROP <push system default word lists and n>
   THEN
   DUP #order !
   0 ?DO I CELLS context + ! LOOP
;

\ E.16.6.2.0715 ALSO
: ALSO ( -- ) 
   GET-ORDER OVER SWAP 1+ SET-ORDER ;

\ E.16.6.2.1965 ONLY
: ONLY ( -- ) 
   -1 SET-ORDER ;

\ E.16.6.2.2037 PREVIOUS
: PREVIOUS ( -- ) 
   GET-ORDER NIP 1- SET-ORDER ;

\ E.16.6.1.1180 DEFINITIONS
: DEFINITIONS ( -- )
   GET-ORDER SWAP SET-CURRENT 0 ?DO DROP LOOP ;

\ E.16.6.2.1590 FORTH
: (wordlist) ( wid "<name>" – ; )
   CREATE ,
   DOES>
     @ >R
     GET-ORDER NIP
     R> SWAP SET-ORDER
;

FORTH-WORDLIST (wordlist) FORTH

\ Allocate a cell to hold the pointer to the latest word in the Forth wordlist
VARIABLE FORTH-WL  0 FORTH-WL !

\ E.16.6.1.1595 FORTH_WORDLIST
\ Return the wid (the address of the head pointer)
: FORTH-WORDLIST ( -- wid )
   FORTH-WL ;

\ E.16.6.1.2192 FORTH-WORDLIST
\ Assumes header layout: [ Link (1 cell) | Flags+Len (1 byte) | Name (Len bytes) | XT ... ]
\ Bit $80 in Flags+Len represents the IMMEDIATE flag; mask $1F extracts length.
: SEARCH-WORDLIST ( c-addr u wid -- 0 | xt 1 | xt -1 )
  @                                 \ ( c-addr u link ) Get first header
  BEGIN
    DUP WHILE                       \ Loop while link <> 0
    >R 2DUP R@ CELL+ COUNT          \ ( c-addr u c-addr u name-addr flags+len )
    DUP $1F AND                     \ Mask out flag bits to get actual name length
    ROT = IF                        \ Do lengths match? ( c-addr u c-addr name-addr )
      OVER COMPARE 0= IF            \ Do characters match?
        2DROP                       \ Drop search string
        R@ CELL+ COUNT              \ Get name-addr and flags+len again
        DUP $1F AND +               \ Compute XT address right after name
        SWAP $80 AND IF 1 ELSE -1 THEN
        R> DROP EXIT                \ Clean return stack and return ( xt 1|-1 )
      THEN
    ELSE
      2DROP                         \ Drop mismatched name pointers
    THEN
    R> @                            \ Follow Link Field to previous word
  REPEAT
  DROP 2DROP 0 ;                    \ Not found: clean stack and return 0

\ E.16.6.1.1550 FIND
\ Assuming #order and context are defined as per E.16.6.1.1647 GET-ORDER.
: FIND ( c-addr -- c-addr 0 | xt 1 | xt -1 )
   0                              ( c-addr 0 )
   #order @ 0 ?DO
      OVER COUNT                  ( c-addr 0 c-addr' u )
      I CELLS context + @         ( c-addr 0 c-addr' u wid )
      SEARCH-WORDLIST             ( c-addr 0; 0 | w 1 | q -1 )
      ?DUP IF                     ( c-addr 0; w 1 | w -1 )
             2SWAP 2DROP LEAVE    ( w 1 | w -1 )
         THEN                     ( c-addr 0 )
      LOOP                        ( c-addr 0 | w 1 | w -1 )
   ;

