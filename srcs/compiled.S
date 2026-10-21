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
 
.equ hash_LIT, 0x0B87DB14 #; ( LIT ) 
.equ hash_HERE, 0x7C857F9F #; ( HERE ) 
.equ hash_ALLOT, 0x0C53195F #; ( ALLOT ) 
.equ hash_COMMA, 0x0002B589 #; ( , ) 
.equ hash_TICK, 0x0002B582 #; ( ' ) 

.equ hash_BEGIN, 0x0C8280A2 #; ( BEGIN ) 
.equ hash_BACK, 0x7C8023EE #; ( BACK ) 
.equ hash_AGAIN, 0x0C5078E5 #; ( AGAIN ) 
.equ hash_UNTIL, 0x0D2F54CF #; ( UNTIL ) 
.equ hash_STILL, 0x0DD20F2B #; ( STILL )
.equ hash_ENDIF, 0x0C0E10C5 #; ( ENDIF ) 
.equ hash_MARK, 0x7C80BAB0 #; ( MARK ) 
.equ hash_AFT, 0x0B87B636 #; ( AFT ) 
.equ hash_IF, 0x0059732A #; ( IF ) 
.equ hash_ELSE, 0x7C7C971A #; ( ELSE ) 
.equ hash_THEN, 0x7C87E6F2 #; ( THEN ) 
.equ hash_WHILE, 0x0D98C5BA #; ( WHILE ) 
.equ hash_REPEAT, 0x42188BB2 #; ( REPEAT ) 
.equ hash_CASE, 0x7C81C251 #; ( CASE )
.equ hash_OF, 0x0059736C #; ( OF )
.equ hash_ENDOF, 0x0DD0C22E #; ( END-OF )
.equ hash_ENDCASE, 0x4507B893 #; ( END-CASE )

.equ hash_DO, 0x0059724E #; ( DO ) 
.equ hash_LOOP, 0x7C836539 #; ( LOOP ) 
.equ hash_PLOOP, 0x06344572 #; ( +LOOP )
.equ hash_I, 0x0002B5EC #; ( I ) 
.equ hash_J, 0x0002B5EF #; ( J ) 
.equ hash_LEAVE, 0x0CF13D9E #; ( LEAVE ) 
.equ hash_FOR, 0x0B87B3DE #; ( FOR ) 
.equ hash_NEXT, 0x7C826702 #; ( NEXT ) 

.equ hash_COLON, 0x0002B59F #; ( : ) 
.equ hash_SEMIS, 0x0002B59E #; ( ; ) 
.equ hash_HEADER, 0x33DCB49A #; ( HEADER ) 
.equ hash_DJB2, 0x7C7F393B #; ( DJB2 ) 
.equ hash_TOKEN, 0x0D8960FE #; ( TOKEN ) 
.equ hash_WORD, 0x7C888E6B #; ( WORD )
.equ hash_HASH, 0x7C8590B7 #; ( HASH )
.equ hash_FIND, 0x7C7E13C0 #; ( FIND ) 
.equ hash_POSTPONE, 0x7A137C29 #; ( POSTPONE ) 
.equ hash_ABORT, 0x0C4FFEAF #; ( ABORT )

.equ hash_LBRACK, 0x0002B5FE #; ( [ )
.equ hash_RBRACK, 0x0002B5F8 #; ( ] )
.equ hash_ISNAME, 0x05BEEF42 #; ( :ISNAME )
.equ hash_NONAME, 0x7C2B3679 #; ( :NONAME )
.equ hash_IMMEDIATE, 0x236DE614 #; ( IMMEDIATE )
.equ hash_RECURSE, 0x06761000 #; ( RECURSE )

.equ hash_SCANK, 0x0DDC5111 #; ( SCANK )
.equ hash_SKIPK, 0x0DE08FCF #; ( SKIPK )

.equ hash_VALUE, 0x0D5DEAAE #; ( VALUE )
.equ hash_TO, 0x0059745E #; ( TO )
.equ hash_DEFER, 0x0C605B35 #; ( DEFER )
.equ hash_IS, 0x0059733F #; ( IS )

.equ hash_CREATE, 0x24DC0181 #; ( CREATE )
.equ hash_DOES, 0x0C6804C6 #; ( DOES> )
.equ hash_BUILDS, 0x1DF52960 #; ( BUILDS )
.equ hash_VARIABLE, 0x31F82EE3 #; ( VARIABLE )
.equ hash_CONSTANT, 0x33CC827B #; ( CONSTANT )
.equ hash_BUFFER, 0x1DF37CE5 #; ( BUFFER )
.equ hash_ARRAY, 0x0C587A5C #; ( ARRAY )

.equ hash_2DUP, 0x7C5447D6 #; ( 2DUP )
.equ hash_2DROP, 0x06DD1C3E #; ( 2DROP )
.equ hash_2SWAP, 0x06D56D02 #; ( 2SWAP )
.equ hash_2OVER, 0x06E00A99 #; ( 2OVER )
.equ hash_2STORE, 0x00596856 #; ( 2! )
.equ hash_2FETCH, 0x00596837 #; ( 2@ )
.equ hash_2TOR, 0x0B86713B #; ( 2>R )
.equ hash_2RTO, 0x0B866CFB #; ( 2R> )
.equ hash_2RAT, 0x0B866C85 #; ( 2R@ )


#---------------------------------------------------------------------- 
 
# ( -- w ) ;# ( LIT ) 
def_word "lit" hash_LIT 
	.word xt_docon 
	.word xt_exit 
 
# ( -- a ) ;# ( HERE ) 
def_word "here" hash_HERE 
	.word xt_heap, xt_fetch 
	.word xt_exit 
 
# ( u -- ) ;# ( ALLOT ) 
def_word "allot" hash_ALLOT 
	.word xt_here, xt_plus, xt_heap, xt_store 
	.word xt_exit 
 
# ( w -- ) ;# ( COMMA ) 
def_word "comma" hash_COMMA 
	.word xt_here, xt_store, xt_cell, xt_allot 
	.word xt_exit 
 
# ( -- ) #; ( [ )  
def_word "lbrack" hash_LBRACK IMMEDIATE
	.word xt_lit, xt_nil, xt_state, xt_store
	.word xt_exit

# ( -- ) #; ( ] )  
def_word "rbrack" hash_RBRACK
	.word xt_lit, xt_one, xt_state, xt_store
	.word xt_exit

#---------------------------------------------------------------------- 
 
# ( -- a ) ;# ( BEGIN ) 
def_word "begin" hash_BEGIN IMMEDIATE 
	.word xt_here 
	.word xt_exit 
 
# ( a -- ) ;# ( BACK ) 
def_word "back" hash_BACK IMMEDIATE 
	.word xt_here, xt_minus, xt_comma 
	.word xt_exit 
 
# ( a -- ) ;# ( AGAIN ) 
def_word "again" hash_AGAIN IMMEDIATE 
	.word xt_lit, xt_branch, xt_comma, xt_back 
	.word xt_exit 
 
# ( a -- ) ;# ( UNTIL ) 
def_word "until" hash_UNTIL IMMEDIATE 
	.word xt_lit, xt_zbranch, xt_comma, xt_back 
	.word xt_exit 
 
# ( a -- ) ;# ( STILL ) 
def_word "still" hash_STILL IMMEDIATE 
	.word xt_lit, xt_gbranch, xt_comma, xt_back 
	.word xt_exit 

# ( a -- a ) ;# ( ENDIF ) 
def_word "endif" hash_ENDIF IMMEDIATE 
	.word xt_here, xt_over, xt_minus, xt_swap, xt_store 
	.word xt_exit 
 
# ( -- a ) ;# ( MARK ) 
def_word "mark" hash_MARK IMMEDIATE 
	.word xt_here, xt_nil, xt_comma 
	.word xt_exit 
 
# ( -- ) ;# ( IF ) 
def_word "if" hash_IF IMMEDIATE 
	.word xt_lit, xt_zbranch, xt_comma, xt_mark 
	.word xt_exit 
 
# ( -- ) ;# ( ELSE ) 
def_word "else" hash_ELSE IMMEDIATE 
	.word xt_lit, xt_branch, xt_comma
	.word xt_mark, xt_swap, xt_endif 
	.word xt_exit 
 
# ( -- a ) ;# ( AFT ) 
def_word "aft" hash_AFT IMMEDIATE 
	.word xt_drop
	.word xt_lit, xt_branch, xt_here, xt_nil, xt_comma
	.word xt_here, xt_swap 
	.word xt_exit 
 
# ( -- ) ;# ( THEN ) 
def_word "then" hash_THEN IMMEDIATE 
	.word xt_endif 
	.word xt_exit 
 
# ( -- ) ;# ( WHILE ) 
def_word "while" hash_WHILE IMMEDIATE 
	.word xt_lit, xt_zbranch, xt_comma, xt_mark 
	.word xt_exit 
 
# ( -- ) ;# ( REPEAT ) 
def_word "repeat" hash_REPEAT IMMEDIATE 
	.word xt_swap, xt_lit, xt_branch, xt_comma, xt_back, xt_endif 
	.word xt_exit 
 
#---------------------------------------------------------------------- 
 
# ( w1 w2 -- ; -- w2 w1 ) ;# ( DO ) makes a count up
# limit start DO
def_word "do" hash_DO IMMEDIATE 
	.word xt_here 
	.word xt_lit, xt_tor, xt_comma 
	.word xt_lit, xt_tor, xt_comma 
	.word xt_exit 

# as :noname 
do_pass:
	.word xt_lit, xt_plus, xt_comma 
	.word xt_lit, xt_over, xt_comma 
	.word xt_lit, xt_over, xt_comma 
	.word xt_lit, xt_equ, xt_comma 
	.word xt_lit, xt_zbranch, xt_comma 
	.word xt_here, xt_minus, xt_comma 
	.word xt_lit, xt_drop, xt_comma 
	.word xt_lit, xt_drop, xt_comma 
	.word xt_exit 
 
# ( -- ; w2 w1 -- w2 w1 ) ;# ( LOOP ) 
def_word "loop" hash_LOOP IMMEDIATE 
	# limit 
	.word xt_lit, xt_rto, xt_comma 
	# increment
	.word xt_lit, xt_one, xt_comma 
	# counter
	.word xt_lit, xt_rto, xt_comma 
	# do
	.word do_pass
	.word xt_exit

# ( w -- ; w2 w1 -- w2 w1 ) ;# ( +LOOP ) 
def_word "ploop" hash_LOOP IMMEDIATE 
	# limit 
	.word xt_lit, xt_rto, xt_comma 
	# increment
	.word xt_lit, xt_swap, xt_comma
	# counter
	.word xt_lit, xt_rto, xt_comma 
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
	.word xt_lit, xt_drop, xt_comma 
	.word xt_lit, xt_drop, xt_comma 
	.word xt_exit 
	 
# ( w -- ; -- w ) ;# ( FOR ) make a count down
def_word "for" hash_FOR IMMEDIATE 
	.word xt_here 
	.word xt_lit, xt_tor, xt_comma 
	.word xt_exit 
 
# ( -- ; w -- w ) ;# ( NEXT ) 
def_word "next" hash_NEXT IMMEDIATE 
	.word xt_lit, xt_rto, xt_comma 
	.word xt_lit, xt_one, xt_comma 
	.word xt_lit, xt_minus, xt_comma 
	.word xt_lit, xt_dup, xt_comma 
	.word xt_lit, xt_gbranch, xt_comma 
	.word xt_here, xt_minus, xt_comma 
	.word xt_lit, xt_drop, xt_comma 
	.word xt_exit 
 
#---------------------------------------------------------------------- 
 
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
 
# ( -- ) #; ( : ) aka figforth semicolon 
def_word "colon" hash_COLON 
	# save here, panic if semis not follow elsewhere 
	.word xt_heap, xt_fetch, xt_pike, xt_store 
	# stat is xt_compile == 1 
	.word xt_one, xt_state, xt_store 
	# make a header 
	.word xt_isname 
	.word xt_exit 
 
# ( -- ) #; ( ; ) aka figforth semicolon, is IMMEDIATE 
def_word "semis" hash_SEMIS IMMEDIATE 
	# load last, panic if colon not lead elsewhere 
	.word xt_pike, xt_fetch, xt_latest, xt_store 
	# stat is xt_execute == 0 
	.word xt_nil, xt_state, xt_store 
	# make a footer 
	.word xt_lit, xt_exit, xt_comma 
	.word xt_exit 
 
# crude token consumes a word between spaces 
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
	.word xt_nan, xt_inverse, xt_rto, xt_and 
	.word xt_exit 
 
# ( h -- h ) #; ( FIND ) 
def_word "find" hash_FIND 
	.word xt_latest 
	# find the hash 
	.word xt_begin, xt_over, xt_over 
	.word xt_cell, xt_plus, xt_fetch, xt_equ 
	.word xt_while, xt_fetch 
	.word xt_dup, xt_if, xt_else, xt_then
	.word xt_repeat 
	# discard hash, keep last link 
	# .word xt_zzzz 
	.word xt_cell, xt_plus, xt_dup, xt_fetch, xt_nan, xt_and 
	.word xt_if, xt_lit, 1, xt_else, xt_lit, -1, xt_then 
	.word xt_then 
	.word xt_exit 
 
# ( -- h ) #; ( ' ) tick, return the xt of a word 
def_word "tick" hash_TICK IMMEDIATE 
	.word xt_hash, xt_find 
	.word xt_if, xt_cell, xt_plus, xt_cell, xt_plus 
	.word xt_else, xt_abort 
	.word xt_then 
	.word xt_exit 
 
# ( -- ) #; ( POSTPONE ) 
def_word "postpone" hash_POSTPONE IMMEDIATE 
	.word xt_tick, xt_comma 
	.word xt_exit 
 
# ( -- ) #; ( :ISNAME ) makes a header with next word 
def_word "isname" hash_ISNAME
	.word xt_latest, xt_fetch, xt_comma 
	.word xt_hash, xt_comma 
	.word xt_exit 
 
# ( -- ) #; ( :NONAME ) makes a header with next word 
def_word "noname" hash_NONAME
	.word xt_here, xt_lbrack 
	.word xt_exit 
 
# ( -- ) #; ( IMMEDIATE ) makes a word immediate 
def_word "immediate" hash_IMMEDIATE
	.word xt_latest, xt_fetch, xt_cell, xt_plus
	.word xt_dup, xt_fetch, xt_nan, xt_or, xt_swap, xt_store
	.word xt_exit 
 
# ( -- ) #; ( RECURSE ) compiles the word been compiled 
def_word "recurse" hash_RECURSE IMMEDIATE
	# drop return
	.word xt_rto
	# compile to self
	.word xt_pike, xt_fetch
	.word xt_cell, xt_plus, xt_cell, xt_plus
	.word xt_comma
	.word xt_exit 
 
# classic djb2 hash algorithm, with XOR, adapted from cdb_hash 
# ( c w -- w ) #; ( DJB2 ) 
def_word "djb2" hash_DJB2 
	.word xt_dup, xt_dup, xt_plus 
	.word xt_dup, xt_plus, xt_dup, xt_plus 
	.word xt_dup, xt_plus, xt_dup, xt_plus 
	.word xt_plus, xt_xor 
	.word xt_exit 
 
# ( -- ) #; ( ABORT ) 
def_word "abort" hash_ABORT  
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

# ( -- ) #; ( SKIPK ) 
def_word "skipk" hash_SKIPK
	.word xt_begin, xt_key, xt_over, xt_minus, xt_nil, xt_equ
	.word xt_until, xt_drop
	.word xt_exit

# ( -- ) #; ( SCANK ) 
def_word "scank" hash_SCANK
	.word xt_begin, xt_key, xt_over, xt_minus, xt_nil, xt_equ
	.word xt_inverse, xt_until, xt_drop
	.word xt_exit

#---------------------------------------------------------------------- 

def_word "twodup" hash_2DUP
	.word xt_over, xt_over
	.word xt_exit

def_word "twodrop" hash_2DROP
	.word xt_drop, xt_drop
	.word xt_exit

def_word "twoswap" hash_2SWAP
	.word xt_rot, xt_tor, xt_rot, xt_rto
	.word xt_exit

def_word "twofetch" hash_2FETCH
	.word xt_dup, xt_cell, xt_plus, xt_fetch, xt_swap, xt_fetch
	.word xt_exit

def_word "twostore" hash_2STORE
	.word xt_swap, xt_over, xt_store, xt_cell, xt_plus, xt_store
	.word xt_exit

def_word "twotor" hash_2TOR
	.word xt_swap, xt_tor, xt_tor
	.word xt_exit

def_word "tworto" hash_2RTO
	.word xt_rto, xt_rto, xt_swap
	.word xt_exit

def_word "tworat" hash_2RAT
	.word xt_rto, xt_rto, xt_twodup, xt_tor, xt_tor, xt_swap
	.word xt_exit


#---------------------------------------------------------------------- 

# : 2NIP 2SWAP 2DROP ;
# : 2TUCK 2SWAP 2OVER ;

