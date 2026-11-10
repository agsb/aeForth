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
 
#---------------------------------------------------------------------- 
# AEFORTH2 pre-compiled words 
#---------------------------------------------------------------------- 
 

# controls backwards

.equ hash_BEGIN, 0x0C8280A2 #; ( BEGIN ) 
.equ hash_MARK, 0x7C80BAB0 #; ( MARK ) 

.equ hash_AGAIN, 0x0C5078E5 #; ( AGAIN ) 
.equ hash_UNTIL, 0x0D2F54CF #; ( UNTIL ) 
.equ hash_WHILST, 0x40B17B78 #; ( WHILST )

# controls forwards

.equ hash_BACK, 0x7C8023EE #; ( BACK ) 
.equ hash_ENDIF, 0x0C0E10C5 #; ( ENDIF ) 

.equ hash_AHEAD, 0x0C555E0C #; ( AHEAD )
.equ hash_IF, 0x0059732A #; ( IF ) 
.equ hash_UNTO, 0x7C855025 #; ( UNTO )

.equ hash_ELSE, 0x7C7C971A #; ( ELSE ) 
.equ hash_THEN, 0x7C87E6F2 #; ( THEN ) 

# controls forward and backward

.equ hash_WHILE, 0x0D98C5BA #; ( WHILE ) 
.equ hash_REPEAT, 0x42188BB2 #; ( REPEAT ) 
.equ hash_AFT, 0x0B87B636 #; ( AFT )

# cases, mind the data stack deep while compiling

.equ hash_CASE, 0x7C81C251 #; ( CASE )
.equ hash_OF, 0x0059736C #; ( OF )
.equ hash_ENDOF, 0x0DD0C22E #; ( END-OF )
.equ hash_ENDCASE, 0x4507B893 #; ( END-CASE )

# control loops

# counts up to limit
.equ hash_DO, 0x0059724E #; ( DO ) 
.equ hash_LOOP, 0x7C836539 #; ( LOOP ) 
.equ hash_PLOOP, 0x06344572 #; ( +LOOP )
.equ hash_I, 0x0002B5EC #; ( I ) 
.equ hash_J, 0x0002B5EF #; ( J ) 
.equ hash_LEAVE, 0x0CF13D9E #; ( LEAVE ) 

# counts down to zero
.equ hash_FOR, 0x0B87B3DE #; ( FOR ) 
.equ hash_NEXT, 0x7C826702 #; ( NEXT ) 

.equ hash_ISNAME, 0x05BEEF42 #; ( :ISNAME )
.equ hash_NONAME, 0x7C2B3679 #; ( :NONAME )

.equ hash_COLON, 0x0002B59F #; ( : ) 
.equ hash_SEMIS, 0x0002B59E #; ( ; ) 
.equ hash_DJB2, 0x7C7F393B #; ( DJB2 ) 
.equ hash_HASH, 0x7C8590B7 #; ( HASH )
.equ hash_SEEK, 0x7C8A759D #; ( SEEK )

.equ hash_TICK, 0x0002B582 #; ( ' ) 
.equ hash_POSTPONE, 0x7A137C29 #; ( POSTPONE ) 

.equ hash_PAGE, 0x7C89F136 #; ( PAGE ) 
.equ hash_LINE, 0x7C833C8B #; ( LINE ) 
.equ hash_WORD, 0x7C888E6B #; ( WORD )
.equ hash_FIND, 0x7C7E13C0 #; ( FIND ) 

.equ hash_QUIT, 0x7C86F95C #; ( QUIT ) 
.equ hash_INTERPRET, 0x217106B2 #; ( INTERPRET )

.equ hash_SCANK, 0x0DDC5111 #; ( SCANK )
.equ hash_SKIPK, 0x0DE08FCF #; ( SKIPK )
.equ hash_BSLASH, 0x0002B5F9 #; ( \ )
.equ hash_LPAREM, 0x0002B58D #; ( ( )

.equ hash_CREATE, 0x24DC0181 #; ( CREATE )
.equ hash_DOES, 0x0C6804C6 #; ( DOES> )
.equ hash_BUILDS, 0x1DF52960 #; ( BUILDS )
.equ hash_VARIABLE, 0x31F82EE3 #; ( VARIABLE )
.equ hash_CONSTANT, 0x33CC827B #; ( CONSTANT )
.equ hash_BUFFER, 0x1DF37CE5 #; ( BUFFER )
.equ hash_ARRAY, 0x0C587A5C #; ( ARRAY )

.equ hash_VALUE, 0x0D5DEAAE #; ( VALUE )
.equ hash_TO, 0x0059745E #; ( TO )
.equ hash_DEFER, 0x0C605B35 #; ( DEFER )
.equ hash_IS, 0x0059733F #; ( IS )

#.equ hash_DIGIT, 0x0C62B132 #; ( DIGIT )
.equ hash_TODIGIT, 0x6C6CCCEC #; ( >DIGIT ) 
.equ hash_TONUMBER, 0x58D73858 #; ( >NUMBER ) 

#---------------------------------------------------------------------- 

.equ hash_NIL, 0x0002B595 #; ( 0 ) 
# ( -- 0) #; ( 0 ) #; 
def_word "nil" hash_NIL 
	push tos spt 
	lui tos, 0x0 
        j next 
 
.equ hash_ONE, 0x0002B594 #; ( 1 ) 
# ( -- 1) #; ( 1 ) #; 
def_word "one" hash_ONE 
	push tos spt 
	lui tos, 1 
        j next 
 
.equ hash_TWO, 0x0002B597 #; ( 2 ) 
# ( -- 2) #; ( 2 ) #; 
def_word "two" hash_TWO 
	push tos spt 
	lui tos, 2 
        j next 

.equ hash_TEN, 0x00596824 #; ( 10 )
# ( -- 10) #; ( 10 ) #; 
def_word "ten" hash_TEN
	push tos spt 
	lui tos, 10 
        j next 
 
#---------------------------------------------------------------------- 

.equ hash_ZEQU, 0x00596808 #; ( 0= )
# ( w -- f ) #; ( 0= )
def_word "zequ" hash_ZEQU
	.word xt_lit, 0
	.word xt_equ
	.word xt_exit

.equ hash_ZLESS, 0x00596809 #; ( 0< )
# ( w -- f ) #; ( 0< )
def_word "zless" hash_ZLESS
	.word xt_lit, 0
	.word xt_less
	.word xt_exit

.equ hash_ZMORE, 0x0059680B #; ( 0> )
# ( w -- f ) #; ( 0> )
def_word "zmore" hash_ZMORE
	.word xt_lit, 0
	.word xt_swap
	.word xt_less
	.word xt_exit

#---------------------------------------------------------------------- 
 
# ( -- w ) ;# ( LIT ) 
.equ hash_LIT, 0x0B87DB14 #; ( LIT ) 
def_word "lit" hash_LIT 
	.word xt_docon 
	.word xt_exit 
 
# ( -- a ) ;# ( HERE ) 
.equ hash_HERE, 0x7C857F9F #; ( HERE ) 
def_word "here" hash_HERE 
	.word xt_heap, xt_fetch 
	.word xt_exit 
 
# ( u -- ) ;# ( ALLOT ) 
.equ hash_ALLOT, 0x0C53195F #; ( ALLOT ) 
def_word "allot" hash_ALLOT 
	.word xt_here, xt_plus, xt_heap, xt_store 
	.word xt_exit 
 
# ( w -- ) ;# ( COMMA ) 
.equ hash_COMMA, 0x0002B589 #; ( , ) 
def_word "comma" hash_COMMA 
	.word xt_here, xt_store, xt_cell, xt_allot 
	.word xt_exit 
 
# ( -- ) #; ( LITERAL )  
.equ hash_LITERAL, 0x738774CE #; ( LITERAL )
def_word "literal" hash_LITERAL
	.word xt_lit, xt_lit, xt_comma, xt_comma
	.word xt_exit

# ( -- ) #; ( [ )  
.equ hash_LBRACK, 0x0002B5FE #; ( [ )
def_word "lbrack" hash_LBRACK IMMEDIATE
	.word xt_lit, EXECUTE, xt_state, xt_store
	.word xt_exit

# ( -- ) #; ( ] )  
.equ hash_RBRACK, 0x0002B5F8 #; ( ] )
def_word "rbrack" hash_RBRACK
	.word xt_lit, COMPILE, xt_state, xt_store
	.word xt_exit

# ( -- ) #; ( IMMEDIATE ) makes a word immediate 
.equ hash_IMMEDIATE, 0x236DE614 #; ( IMMEDIATE )
def_word "immediate" hash_IMMEDIATE
	.word xt_latest, xt_fetch, xt_cell, xt_plus
	.word xt_dup, xt_fetch, xt_nan, xt_orr, xt_swap, xt_store
	.word xt_exit 

# ( a -- a F ) #; ( IMMEDIATE? ) is a word immediate ?
.equ hash_IMMEDIATEQ, 0x112AA8AB #; ( IMMEDIATE? )
def_word "immediateq" hash_IMMEDIATEQ
	.word xt_cell, xt_plus, xt_fetch
	.word xt_lit, FLAG_IMM, xt_and
	.word xt_exit 
 
# ( -- ) #; ( RECURSE ) compiles the word been compiled 
.equ hash_RECURSE, 0x06761000 #; ( RECURSE )
def_word "recurse" hash_RECURSE IMMEDIATE
	# there is no return, 
	.word xt_lit, xt_rto, xt_comma
	# compile to self, could cause dead loops
	.word xt_pike, xt_fetch
	.word xt_cell, xt_plus, xt_cell, xt_plus
	.word xt_comma
	.word xt_exit 

#---------------------------------------------------------------------- 

# ( -- ) #; #; ( CODE ), starts native code, ZZZZ 
# enable ASM vocabulary
.equ hash_DOCODE, 0x7C81D9A8 #; ( CODE )
def_word "docode" hash_DOCODE 
	.word xt_exit 

# ( -- ) #; #; ( END-CODE ), ends native code, ZZZZ 
.equ hash_ENDCODE, 0x4507E16A #; ( END-CODE )
# disable ASM vocabulary
def_word "endcode" hash_ENDCODE 
	.word xt_exit 

# ( w -- ) #; #; ( :CODE ), does a native call 
.equ hash_TOCODE, 0x075D9A73 #; ( ;CODE )
def_word "tocode" hash_TOCODE 
	.word xt_rto, xt_perform
	.word xt_exit 

# ( w -- ) #; #; ( CODE; ), does a native return 
# in RISCV ret is jalr zero, 0 (ra) 
.equ hash_CODETO, 0x0CBD0E93 #; ( CODE; )
.equ RET, 0x00008067
def_word "codeto" hash_CODETO 
	.word xt_lit, RET, xt_comma
	.word xt_exit 

#---------------------------------------------------------------------- 
#
# remember 0x0 is FALSE, ever  
#
# ( -- a ) ;# ( BEGIN ) mark a backward offset
def_word "begin" hash_BEGIN IMMEDIATE 
	.word xt_here 
	.word xt_exit 
 
# ( -- ) ;# ( BACK ) goes backward 
def_word "back" hash_BACK IMMEDIATE 
	.word xt_here, xt_minus, xt_comma 
	.word xt_exit 
 
# ( a -- ) ;# ( AGAIN ) goes back always
def_word "again" hash_AGAIN IMMEDIATE 
	.word xt_lit, xt_branch, xt_comma
	.word xt_back 
	.word xt_exit 
 
# ( a -- ) ;# ( UNTIL ) goes back, when TOS is zero
def_word "until" hash_UNTIL IMMEDIATE 
	.word xt_lit, xt_zbranch, xt_comma
	.word xt_back 
	.word xt_exit 
 
# strange word
# ( a -- ) ;# ( WHILST ) goes back, when TOS greater than zero
def_word "whilst" hash_WHILST IMMEDIATE 
	.word xt_lit, xt_gbranch, xt_comma
	.word xt_back 
	.word xt_exit 

#---------------------------------------------------------------------- 

# ( -- a ) ;# ( MARK ) mark a forward offset
def_word "mark" hash_MARK IMMEDIATE 
	.word xt_here, xt_nil, xt_comma 
	.word xt_exit 

# ( -- ) ;# ( ENDIF ) 
def_word "endif" hash_ENDIF IMMEDIATE 
	.word xt_here, xt_over, xt_minus, xt_swap, xt_store 
	.word xt_exit 
 
# ( -- a ) ;# ( AHEAD ) 
def_word "ahead" hash_AHEAD IMMEDIATE 
	.word xt_lit, xt_branch, xt_comma
	.word xt_mark 
	.word xt_exit 
 
# ( -- ) ;# ( IF ) 
def_word "if" hash_IF IMMEDIATE 
	.word xt_lit, xt_zbranch, xt_comma
	.word xt_mark 
	.word xt_exit 
 
# strange word
# ( -- ) ;# ( UNTO ) 
def_word "unto" hash_UNTO IMMEDIATE 
	.word xt_lit, xt_gbranch, xt_comma
	.word xt_mark 
	.word xt_exit 
 
# ( -- ) ;# ( ELSE ) 
def_word "else" hash_ELSE IMMEDIATE 
	.word xt_lit, xt_branch, xt_comma
	.word xt_mark
	.word xt_swap
	.word xt_endif 
	.word xt_exit 
 
# ( -- ) ;# ( THEN ) 
def_word "then" hash_THEN IMMEDIATE 
	.word xt_endif
	.word xt_exit 
 
#---------------------------------------------------------------------- 

# ( -- ) ;# ( WHILE ) goes forward, when TOS is zero 
def_word "while" hash_WHILE IMMEDIATE 
	.word xt_lit, xt_zbranch, xt_comma
	.word xt_mark, xt_swap 
	.word xt_exit 
 
# ( -- ) ;# ( REPEAT ) goes backward to begin
def_word "repeat" hash_REPEAT IMMEDIATE 
	.word xt_lit, xt_branch, xt_comma
	.word xt_back, xt_endif 
	.word xt_exit 
 
# ( -- a ) ;# ( AFT ) goes forward 
def_word "aft" hash_AFT IMMEDIATE 
	.word xt_drop
	.word xt_lit, xt_branch, xt_comma
	.word xt_mark, xt_here, xt_swap
	.word xt_exit 
 
#---------------------------------------------------------------------- 
 
# ( w1 w2 -- ; -- w2 w1 ) ;# ( DO ) makes a count up
# limit index DO
def_word "do" hash_DO IMMEDIATE 
	.word xt_here 
	.word xt_lit, xt_tor, xt_comma 
	.word xt_lit, xt_tor, xt_comma 
	.word xt_exit 

# as :noname 
do_pass:
	# counter
	.word xt_lit, xt_rto, xt_comma 
	.word xt_lit, xt_plus, xt_comma 
	.word xt_lit, xt_over, xt_comma 
	.word xt_lit, xt_over, xt_comma 
	.word xt_lit, xt_equ, xt_comma 

	.word xt_lit, xt_zbranch, xt_comma 
	.word xt_here, xt_minus, xt_comma 

do_drops:
	.word xt_lit, xt_drop, xt_comma 
	.word xt_lit, xt_drop, xt_comma 
	.word xt_exit 
 
# ( -- ; w2 w1 -- w2 w1 ) ;# ( LOOP ) 
def_word "loop" hash_LOOP IMMEDIATE 
	# limit 
	.word xt_lit, xt_rto, xt_comma 
	# increment
	.word xt_lit, xt_one, xt_comma 
	# do
	.word do_pass
	.word xt_exit

# ( w -- ; w2 w1 -- w2 w1 ) ;# ( +LOOP ) 
def_word "ploop" hash_PLOOP IMMEDIATE 
	# limit 
	.word xt_lit, xt_rto, xt_comma 
	# increment
	.word xt_lit, xt_swap, xt_comma
	# do
	.word do_pass
	.word xt_exit
 
# ( -- w1 ; w2 w1 -- w2 w1 ) ;# ( I ) 
def_word "i" hash_I IMMEDIATE 
	.word xt_lit, xt_rat, xt_comma 
	.word xt_exit 
 
# ( -- w3 ; w4 w3 w2 w1 -- w4 w3 w2 w1 ) ;# ( J ) 
def_word "j" hash_J IMMEDIATE 
 	.word xt_lit, xt_rto, xt_comma 
	.word xt_lit, xt_rto, xt_comma 
	.word xt_lit, xt_rat, xt_comma 

	.word xt_lit, xt_swap, xt_comma 
	.word xt_lit, xt_tor, xt_comma 
	.word xt_lit, xt_swap, xt_comma 
	.word xt_lit, xt_tor, xt_comma 
	.word xt_exit 
 
# ( -- ; w2 w1 -- ) ;# ( LEAVE ) 
def_word "leave" hash_LEAVE IMMEDIATE 
	.word xt_lit, xt_rto, xt_comma 
	.word xt_lit, xt_rto, xt_comma 
	.word do_drops
	.word xt_exit 
	 
#---------------------------------------------------------------------- 

# ( w -- ; -- w ) ;# ( FOR ) make a count down to zero
def_word "for" hash_FOR IMMEDIATE 
	.word xt_lit, 0x0, xt_comma
	.word xt_do
	.word xt_exit 
 
# ( -- ; w -- w ) ;# ( NEXT ) 
def_word "next" hash_NEXT IMMEDIATE 
	.word xt_lit, xt_rto, xt_comma 
	.word xt_lit, xt_one, xt_comma 
	.word xt_lit, xt_minus, xt_comma 

	.word xt_lit, xt_dup, xt_comma 
	.word xt_lit, xt_gbranch, xt_comma 
	.word xt_here, xt_minus, xt_comma 

	.word do_drops
	.word xt_exit 
 
#---------------------------------------------------------------------- 
# note: each case place a reference into data stack !

# ( -- ) #; ( CASE ) 
def_word "case" hash_CASE IMMEDIATE 
	.word xt_nil 
	.word xt_exit 
 
def_word "of" hash_OF IMMEDIATE 
	.word xt_one, xt_plus, xt_tor 
	.word xt_lit, xt_over, xt_comma 
	.word xt_lit, xt_equ, xt_comma 
	.word xt_lit, xt_zbranch, xt_comma 
	.word xt_here, xt_nil, xt_comma 
	.word xt_drop, xt_rto 
	.word xt_exit 
 
def_word "endof" hash_ENDOF IMMEDIATE 
        .word xt_lit, xt_branch, xt_comma 
	.word xt_here, xt_nil, xt_comma 
	.word xt_swap, xt_dup, xt_here 
	.word xt_swap, xt_minus, xt_swap, xt_store 
	.word xt_exit 
 
def_word "endcase" hash_ENDCASE IMMEDIATE 
        .word xt_lit, xt_drop, xt_comma 
	.word xt_dup, xt_nil, xt_equ 
	.word xt_if, xt_drop, xt_exit 
	.word xt_then, xt_nil 
	.word xt_do, xt_dup 
	.word xt_here, xt_swap, xt_minus, xt_swap, xt_store 
	.word xt_loop 
	.word xt_exit 
 
#---------------------------------------------------------------------- 
 
# ( -- ) #; ( :ISNAME ) makes a header  
def_word "isname" hash_ISNAME
	.word xt_latest, xt_fetch, xt_comma 
	.word xt_hash, xt_comma 
	.word xt_exit 
 
# ( -- ) #; ( :NONAME ) makes a content 
def_word "noname" hash_NONAME
	.word xt_here, xt_lbrack 
	.word xt_exit 
 
# ( -- ) #; ( : ) aka figforth semicolon 
def_word "colon" hash_COLON 
	# save here, panic if semis not follow elsewhere 
	.word xt_heap, xt_fetch, xt_pike, xt_store 
	# stat is compile
	.word xt_lit, COMPILE, xt_state, xt_store 
	# make a header 
	.word xt_isname 
	.word xt_exit 
 
# ( -- ) #; ( ; ) aka figforth semicolon, is IMMEDIATE 
def_word "semis" hash_SEMIS IMMEDIATE 
	# load last, panic if colon not lead elsewhere 
	.word xt_pike, xt_fetch, xt_latest, xt_store 
	# state is execute 
	.word xt_lit, EXECUTE, xt_state, xt_store 
	# make a footer 
	.word xt_lit, xt_exit, xt_comma 
	.word xt_exit 
 
# classic djb2 hash algorithm, with XOR, adapted from cdb_hash 
# ( c w -- w ) #; ( DJB2 ) 
def_word "djb2" hash_DJB2 
	.word xt_dup, xt_dup, xt_plus 
	.word xt_dup, xt_plus, xt_dup, xt_plus 
	.word xt_dup, xt_plus, xt_dup, xt_plus 
	.word xt_plus, xt_xor 
	.word xt_exit 
 
# crude token consumes a unlimited word between spaces 
# return the hash of a token word
# ( -- h ) #; ( word ) 
def_word "hash" hash_HASH
	# skip spaces 
	.word xt_lit, BL 
	.word xt_begin
	.word xt_key, xt_over, xt_over, xt_equ, xt_inverse
	.word xt_until 
	# prepare djb2 constant, adapted from cdb_hash
	.word xt_lit, 5381, xt_tor 
	# scan spaces and do hash 
	.word xt_begin 
	.word xt_rto, xt_djb2, xt_tor 
	.word xt_key, xt_over, xt_over, xt_equ 
	.word xt_inverse, xt_until 
	.word xt_drop, xt_drop 
        # clear hash high bit 
	.word xt_rto, xt_lit, MASK_IMM, xt_and 
	.word xt_exit 
 
# ( h -- a | 0 ) #; ( SEEK ) 0 is not found 
def_word "seek" hash_SEEK
	.word xt_latest 
	# find the hash 
	.word xt_begin
	.word xt_fetch, xt_dup
	# missed ?
	.word xt_while
	# take the hash
	.word xt_over, xt_over
	.word xt_cell, xt_plus, xt_fetch 
	# mask immediate flag
	.word xt_lit, MASK_IMM, xt_and, xt_equ 
	# found ?
	.word xt_while
	# not found
	.word xt_repeat
	.word xt_then
	# leave only the result
	.word xt_swap, xt_drop 
	.word xt_exit 
 
# ( -- xt ) #; ( ' ) tick, return the xt of a word 
def_word "tick" hash_TICK IMMEDIATE 
	.word xt_hash, xt_seek, xt_dup  
	.word xt_if, xt_cell, xt_plus, xt_cell, xt_plus 
	.word xt_else, xt_drop, xt_abort 
	.word xt_then 
	.word xt_exit 
 
# ( -- ) #; ( POSTPONE ) compile the xt of a word 
def_word "postpone" hash_POSTPONE IMMEDIATE 
	.word xt_tick, xt_comma 
	.word xt_exit 
 
# ( -- ) #; ( INTERPRET )
def_word "interpret" hash_INTERPRET
	.word xt_begin, xt_hash, xt_seek
	# found ?
	.word xt_dup, xt_if
	# eval ?
	.word xt_immediateq, xt_state, xt_fetch, xt_orr
	.word xt_if, xt_execute
	.word xt_else, xt_compile
	.word xt_then 
	.word xt_else
	.word xt_abort
	.word xt_then 
	# next word
	.word xt_again
	.word xt_exit

.equ hash_EXECUTE, 0x69224E1A #; ( EXECUTE )
# ( w1 -- ; -- w2 ) #; ( EXECUTE ), execute a word in Forth
def_word "execute", hash_EXECUTE
	.word xt_tor
	.word xt_exit

.equ hash_COMPILE, 0x2FA52C94 #; ( COMPILE )
def_word "compile" hash_COMPILE
	.word xt_comma
	.word xt_exit

#----------------------------------------------------------------------
.equ hash_PDOTQUOP, 0x7C4F2F48 #; ( (.") )
def_word "pdotquop" hash_PDOTQUOP
	.word xt_rto, xt_begin, xt_dup, xt_fetch
	.word xt_while, xt_dup, xt_fetch, xt_emit, xt_one, xt_plus
	.word xt_repeat, xt_tor
	.word xt_exit

.equ hash_DOTQUO, 0x005966C9 #; ( ." )
def_word "dotquo" hash_DOTQUO
	.word xt_state, xt_fetch, xt_if
	.word xt_lit, xt_pdotquop, xt_comma
	.word xt_lit, xt_space, 
	.word xt_else, xt_type, # zzzzz
	.word xt_exit

#----------------------------------------------------------------------
#
# All numbers are prefixed by a dollar :) $ NNN  
#

.equ hash_HEX, 0x0B87EC90 #; ( HEX )
def_word "number_hex" hash_HEX
	.word xt_lit, 16, xt_base, xt_store
	.word xt_exit

.equ hash_DEC, 0x0B87BA87 #; ( DEC )
def_word "number_dec" hash_DEC
	.word xt_lit, 10, xt_base, xt_store
	.word xt_exit

.equ hash_OCT, 0x0B87E0DD #; ( OCT )
def_word "number_oct" hash_OCT
	.word xt_lit, 8, xt_base, xt_store
	.word xt_exit

.equ hash_BIN, 0x0B87C400 #; ( BIN )
def_word "number_bin" hash_BIN
	.word xt_lit, 2, xt_base, xt_store
	.word xt_exit

#---------------------------------------------------------------------- 
 
# ( -- ) #; ( CREATE ) 
def_word "create" hash_CREATE  
	.word xt_isname
	.word xt_lit, xt_lit, xt_comma
	.word xt_here, xt_cell, xt_plus, xt_cell, xt_plus, xt_comma
	.word xt_lit, xt_exit, xt_comma
	.word xt_lit, xt_exit, xt_comma
	.word xt_exit

# ( -- ) #; ( DOES ) 
def_word "does" hash_DOES 
	.word xt_rto, xt_latest, xt_fetch
	.word xt_cell, xt_plus, xt_cell, xt_plus
	.word xt_cell, xt_plus, xt_cell, xt_plus
	.word xt_store
	.word xt_exit

# ( -- ) #; ( BUILDS ) 
def_word "builds" hash_BUILDS 
	.word xt_create
	.word xt_exit

# ( -- ) #; ( VARIABLE ) 
def_word "variable" hash_VARIABLE 
	.word xt_create, xt_nil, xt_comma
	.word xt_exit

# ( w -- ) #; ( CONSTANT ) 
def_word "constant" hash_CONSTANT 
	.word xt_create, xt_comma
	.word xt_does, xt_fetch
	.word xt_exit

# ( w -- ) #; ( BUFFER ) 
def_word "buffer" hash_BUFFER 
	.word xt_create, xt_allot
	.word xt_exit

# ( w -- ) #; ( ARRAY ) 
def_word "array" hash_ARRAY 
	.word xt_create, xt_allot
	.word xt_does, xt_plus, xt_fetch
	.word xt_exit

#---------------------------------------------------------------------- 

# ( w -- ) #; ( VALUE ) 
def_word "value" hash_VALUE 
	.word xt_constant
	.word xt_exit

# ( w -- ) #; ( TO ) 
def_word "to" hash_TO 
	.word xt_tick 
	.word xt_state, xt_fetch
	.word xt_if, xt_lit, xt_lit, xt_comma
	.word xt_comma 
	.word xt_lit, xt_store, xt_store
	.word xt_else, xt_store
	.word xt_then
	.word xt_exit

#---------------------------------------------------------------------- 

# ( -- ) #; ( DEFER ) 
def_word "defer" hash_DEFER 
	.word xt_isname 
	.word xt_lit, xt_exit, xt_comma
	.word xt_lit, xt_exit, xt_comma
	.word xt_exit

# ( -- ) #; ( IS ) 
def_word "is" hash_IS 
	.word xt_tick, xt_store
	.word xt_exit

#---------------------------------------------------------------------- 

# ( c -- ) #; ( SKIPK ) skip while equal key 
def_word "skipk" hash_SKIPK
	.word xt_begin, xt_key, xt_over, xt_over, xt_equ
	.word xt_if, xt_drop, xt_false, xt_else, xt_true, xt_then
	.word xt_until 
	.word xt_exit

# ( c -- ) #; ( SCANK ) scan while not equal key
def_word "scank" hash_SCANK
	.word xt_begin, xt_key, xt_over, xt_over, xt_equ, xt_inverse
	.word xt_if, xt_drop, xt_false, xt_else, xt_true, xt_then
	.word xt_until 
	.word xt_exit

# ( -- ) #; ( ( ) scan while not ')
def_word "lparen" hash_LPAREM
	.word xt_lit, ')', xt_scank, xt_drop
	.word xt_exit

# ( -- ) #; ( \ ) scan to new line
def_word "backslash" hash_BSLASH
	.word xt_lit, '\n', xt_scank, xt_drop
	.word xt_exit

#---------------------------------------------------------------------- 
# \ two cells stuff

.equ hash_2DUP, 0x7C5447D6 #; ( 2DUP )
.equ hash_2DROP, 0x06DD1C3E #; ( 2DROP )
.equ hash_2SWAP, 0x06D56D02 #; ( 2SWAP )
.equ hash_2OVER, 0x06E00A99 #; ( 2OVER )

.equ hash_2STORE, 0x00596856 #; ( 2! )
.equ hash_2FETCH, 0x00596837 #; ( 2@ )

.equ hash_2TOR, 0x0B86713B #; ( 2>R )
.equ hash_2RTO, 0x0B866CFB #; ( 2R> )
.equ hash_2RAT, 0x0B866C85 #; ( 2R@ )

.equ hash_2NIP, 0x7C545140 #; ( 2NIP )

.equ hash_2DIV, 0x00596858 #; ( 2/ )
.equ hash_2MUL, 0x0059685D #; ( 2* )

# ( w1 w2 -- w1 w2 w1 w2 ) #; ( 2DUP )
def_word "twodup" hash_2DUP
	.word xt_over, xt_over
	.word xt_exit

# ( w1 w2 -- ) #; ( 2DROP )
def_word "twodrop" hash_2DROP
	.word xt_drop, xt_drop
	.word xt_exit

# ( w1 w2 w3 w4 -- w3 w4 w1 w2 ) #; ( 2DROP )
def_word "twoswap" hash_2SWAP
	.word xt_rot, xt_tor, xt_rot, xt_rto
	.word xt_exit

# ( w1 w2 w3 w4 -- w1 w2 w3 w4 w1 w2 ) #; ( 2OVER )
def_word "twoover" hash_2OVER
        .word xt_tor, xt_over, xt_over, xt_rto
        .word xt_swap, xt_tor, xt_swap, xt_rto
	.word xt_exit

# ( w1 w2 -- u1 u2 ) #; ( 2FETCH )
def_word "twofetch" hash_2FETCH
	.word xt_dup, xt_cell, xt_plus, xt_fetch, xt_swap, xt_fetch
	.word xt_exit

# ( w1 w2 w3 w4 -- ) #; ( 2STORE )
def_word "twostore" hash_2STORE
	.word xt_swap, xt_over, xt_store, xt_cell, xt_plus, xt_store
	.word xt_exit

# ( w1 w2 -- ; -- w2 w1 ) #; ( 2>R )
def_word "twotor" hash_2TOR
	.word xt_swap, xt_tor, xt_tor
	.word xt_exit

# (  -- w1 w2 ; w2 w1 -- ) #; ( 2R> )
def_word "tworto" hash_2RTO
	.word xt_rto, xt_rto, xt_swap
	.word xt_exit

# ( -- w1 w2 ; w2 w1 -- w2 w1 ) #; ( 2R@ )
def_word "tworat" hash_2RAT
	.word xt_rto, xt_rto, xt_twodup, xt_tor, xt_tor, xt_swap
	.word xt_exit

# ( w1 w2 w3 w4 -- w3 w4 ) #; ( 2NIP )
def_word "twonip" hash_2NIP
	.word xt_nip, xt_nip
	.word xt_exit

#---------------------------------------------------------------------- 

# ( w -- w/2 ) #; ( 2/ )
def_word "twodiv" hash_2DIV
	.word xt_lit, 1
	.word xt_rshift
	.word xt_exit

# ( w -- w*2 ) #; ( 2* )
def_word "twomul" hash_2MUL
	.word xt_lit, 1
	.word xt_lshift
	.word xt_exit

#---------------------------------------------------------------------- 

.equ hash_BL, 0x0059728B #; ( BL )
def_word "bl" hash_BL
	.word xt_lit, BL
	.word xt_exit

.equ hash_QU, 0x00597421 #; ( QU )
def_word "qu" hash_QU
	.word xt_lit, QU
	.word xt_exit

.equ hash_ON, 0x00597364 #; ( ON )
def_word "on" hash_ON
	.word xt_lit, TRUE
	.word xt_swap, xt_store
	.word xt_exit

.equ hash_OFF, 0x0B87E0AA #; ( OFF )
def_word "off" hash_OFF
	.word xt_lit, FALSE
	.word xt_swap, xt_store
	.word xt_exit

#---------------------------------------------------------------------- 

.equ hash_PLUSTORE, 0x0059676F #; ( +! )
# ( -- ) #; ( +! ) plus and store
def_word "plustore" hash_PLUSTORE
	.word xt_dup, xt_fetch, xt_plus, xt_swap, xt_store
	.word xt_exit

.equ hash_NIP, 0x0B87D312 #; ( NIP )
# ( -- ) #; ( NIP ) 
def_word "nip" hash_NIP
	.word xt_swap, xt_drop
	.word xt_exit

.equ hash_TUCK, 0x7C878D2C #; ( TUCK )
# ( -- ) #; ( TUCK )
def_word "tuck" hash_TUCK
	.word xt_dup, xt_tor, xt_swap, xt_rto
	.word xt_exit

.equ hash_QDUP, 0x7C55FD3B #; ( ?DUP )
# ( w -- w | w w  ) #; ( ?DUP ) 
def_word "qdup" hash_QDUP
	.word xt_dup, xt_if, xt_dup, xt_then
	.word xt_exit

.equ hash_PICK, 0x7C8A13B4 #; ( PICK )
# ( u -- ) #; ( PICK ) 
def_word "pick" hash_PICK
	.word xt_cells, xt_spat, xt_plus, xt_fetch
	.word xt_exit

.equ hash_ROLL, 0x7C890218 #; ( ROLL )
# ( u -- ) #; ( ROLL ) ZZZZ
def_word "roll" hash_ROLL
	.word xt_dup
	.word xt_begin
	.word xt_while, xt_swap, xt_tor
	.word xt_repeat 
	.word xt_begin
	.word xt_while, xt_rto
	.word xt_repeat
	.word xt_exit

#---------------------------------------------------------------------- 
#\ E.10 The optional Exception word set

.equ hash_HANDLER, 0x37B8B03D #; ( HANDLER ) 
def_word "handler" hash_HANDLER
	.word xt_dovar, 0
	.word xt_exit

.equ hash_CATCH, 0x0CB9F7F8 #; ( CATCH ) 
def_word "catch" hash_CATCH
	.word xt_spat, xt_tor
	.word xt_handler, xt_fetch, xt_tor
	.word xt_execute
	.word xt_rto, xt_handler, xt_store
	.word xt_rto, xt_drop
	.word xt_nil
	.word xt_exit

.equ hash_THROW, 0x0D847D13 #; ( THROW )
def_word "throw" hash_THROW
	.word xt_qdup, xt_if
	.word xt_handler, xt_fetch, xt_rpto
	.word xt_rto, xt_handler, xt_store
	.word xt_rto, xt_swap, xt_tor
	.word xt_spto, xt_drop, xt_tor
	.word xt_then
	.word xt_exit
	
.equ hash_ABORT, 0x0C4FFEAF #; ( ABORT ) 
def_word "abort" hash_ABORT
	.word xt_lit, -1, xt_throw
	.word xt_exit

#---------------------------------------------------------------------- 
#\ E.12 The optional Facility word set

.equ hash_PLUSFIELD, 0x4D63F1AC #; ( +FIELD )
def_word "plusfield" hash_PLUSFIELD
	.word xt_create, xt_over, xt_comma, xt_plus
	.word xt_does, xt_fetch, xt_plus
	.word xt_exit

.equ hash_BEGIN_STRUCTURE, 0x2C8D7E9A #; ( BEGIN-STRUCTURE ) 
def_word "begin_structure" hash_BEGIN_STRUCTURE
   	.word xt_create, xt_here, xt_nil, xt_nil, xt_comma
	.word xt_does, xt_fetch
	.word xt_exit

.equ hash_END_STRUCTURE, 0x51515D12 #; ( END-STRUCTURE )
def_word "end_structure" hash_END_STRUCTURE
	.word xt_swap, xt_store
	.word xt_exit

#---------------------------------------------------------------------- 
