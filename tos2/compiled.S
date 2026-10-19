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
; BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES, 
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

# ( -- w ) ;# ( LIT )
def_native "lit" hash_LIT
	.word docon
	.word exit

# ( -- a ) ;# ( HERE )
def_native "here" hash_HERE
	.word heap, fetch
	.word exit

# ( u -- ) ;# ( ALLOT )
def_native "allot" hash_ALLOT
	.word here, plus, heap, store
	.word exit

# ( w -- ) ;# ( COMMA )
def_native "comma" hash_COMMA
	.word here, store, cell, allot
	.word exit

# ( -- a ) ;# ( BEGIN )
def_native "begin" hash_BEGIN
	.word here
	.word exit

# ( a -- ) ;# ( BACK )
def_native "back" hash_BACK
	.word here, minus, comma
	.word exit

# ( a -- ) ;# ( AGAIN )
def_native "again" hash_AGAIN
	.word lit, branch, comma, back
	.word exit

# ( a -- ) ;# ( UNTIL )
def_native "until" hash_UNTIL
	.word lit, zbranch, comma, back
	.word exit

# ( a -- a ) ;# ( ENDIF )
def_native "endif" hash_ENDIF
	.word here, over, minus, swap, store
	.word exit

# ( -- a ) ;# ( MARK )
def_native "mark" hash_MARK
	.word here, nil, comma
	.word exit

# ( -- a ) ;# ( AFT )
def_native "aft" hash_AAFT
	.word here
	.word exit

# ( -- ) ;# ( IF )
def_native "if" hash_IF
	.word lit, zbranch, comma, mark
	.word exit

# ( -- ) ;# ( ELSE )
def_native "else" hash_ELSE
	.word lit, branch, comma, mark, swap, endif
	.word exit

# ( -- ) ;# ( THEN )
def_native "then" hash_THEN
	.word endif
	.word exit

# ( -- ) ;# ( WHILE )
def_native "while" hash_WHILE
	.word lit, zbranch, comma, mark
	.word exit

# ( -- ) ;# ( REPEAT )
def_native "repeat" hash_REPEAT
	.word swap, lit, branch, comma, back, endif
	.word exit

# ( w1 w2 -- ; -- w2 w1 ) ;# ( DO )
def_native "do" hash_DO
	.word lit, swap, comma, 
	.word here 
	.word lit, tor, comma 
	.word lit, tor, comma
	.word exit

# ( -- ; w2 w1 -- w2 w1 ) ;# ( LOOP )
def_native "loop" hash_LOOP
	.word lit, rto, comma
	.word lit, lit, comma 
	.word lit, 1, comma
	.word lit, plus, comma
	.word lit, rto, comma
	.word lit, over, comma
	.word lit, over, comma
	.word lit, equ, comma
	.word lit, zbranch, comma
	.word here, minus, comma
	.word lit, drop, comma
	.word lit, drop, comma
	.word exit

# ( -- w1 ; w2 w1 -- w2 w1 ) ;# ( I )
def_native "i" hash_I
	.word lit, rat, comma
	.word exit

# ( -- w3 ; w4 w3 w2 w1 -- w4 w3 w2 w1 ) ;# ( J )
def_native "j" hash_J
   	.word lit, rto, comma
   	.word lit, rto, comma
   	.word lit, rat, comma
	.word lit, swap, comma
   	.word lit, tor, comma
	.word lit, swap, comma
   	.word lit, tor, comma
	.word exit

# ( -- ; w2 w1 -- ) ;# ( LEAVE )
def_native "leave" hash_LEAVE
   	.word lit, rto, comma
	.word lit, drop, comma
   	.word lit, rto, comma
	.word lit, drop, comma
	.word exit
	
# ( w -- ; -- w ) ;# ( FOR )
def_native "for" hash_FOR
	.word here 
	.word lit, tor, comma 
	.word exit

# ( -- ; w -- w ) ;# ( NEXT )
def_native "next" hash_NEXT
	.word lit, rto, comma
	.word lit, 1, comma
	.word lit, minus, comma
	.word lit, dup, comma
	.word lit, gbranch, comma
	.word here, minus, comma
	.word lit, drop, comma
	.word exit

# ( -- ) #; ( : ) aka figforth semicolon
def_native "colon" hash_COLON
	# save here, panic if semis not follow elsewhere
	.word heap, fetch, pike, store
	# stat is 'compile' == 1
	.word one, state, store
	# make a header
	.word header
	.word exit

# ( -- ) #; ( ; ) aka figforth semicolon, is IMMEDIATE
def_native "semis" hash_SEMIS 
	# load last, panic if colon not lead elsewhere
	.word pike, fetch, last, store
	# stat is 'execute' == 0
	.word nil, state, store
	# make a footer
	.word lit, exit, comma
	.word exit

# ( -- ) #; ( HEADER ) makes a header with next word
def_native "header" hash_HEADER
	.word last, fetch, comma
	.word token, comma
	.word exit

# classic djb2 hash algorithm, with XOR, adapted from cdb_hash
# ( c w -- w ) #; ( DJB2 )
def_native "djb2" hash_DJB2
	.word dup, dup, plus, 
	.word dup, plus, dup, plus, 
	.word dup, plus, dup, plus, 
	.word plus, xor
	.exit

# crude token consumes a word between spaces
# return the hash of a token 
# ( -- h ) #; ( TOKEN )
def_native "token" hash_TOKEN
	# skip spaces
	.word lit, BL
	.word begin, key, over, over, equ, inverse, until
	# prepare
	.word lit, 5381, tor
	# scan spaces and do hash
	.word begin
	.word rto, djb2, tor
	.word key, over, over, equ
	.word inverse, until
	.word drop, drop
        # clear hash high bit
	.word nan, inverse, rto, and
	.word exit

# ( h -- h ) #; ( FIND )
def_native "find" hash_FIND
	.word latest 
	# find the hash
	.word begin, over, over 
	.word cell, plus, fetch, equ 
	.word while, fetch, repeat
	# discard hash, keep last link
	.word zzzz 
	.word cell, plus, dup, fetch, nan, and 
	.word if, lit, 1, else, lit, -1, then
	.word then
	.word exit



#----------------------------------------------------------------------

