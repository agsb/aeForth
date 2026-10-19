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
;---------------------------------------------------------------------
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
# AEFORTH2 assembly code for RISCV
#----------------------------------------------------------------------

# DJB2 hash for UPPERCASE Forth words inside ( )

# changes ip
.equ hash_EXIT, 0x7C7CC745 #; ( EXIT ) 
.equ hash_BRANCH, 0x1E6C4191 #; ( BRANCH ) 
.equ hash_ZBRANCH, 0x7D28616B #; ( ZBRANCH ) 
.equ hash_GBRANCH, 0x689E2DB6 #; ( GBRANCH )
.equ hash_DOVAR, 0x0C682A6B #; ( DOVAR )
.equ hash_DOCON, 0x0C67F9AC #; ( DOCON )

# moves pointers
.equ hash_RPAT, 0x7C88A9B2 #; ( RP@ ) 
.equ hash_SPAT, 0x7C8A4E93 #; ( SP@ ) 
.equ hash_RPTO, 0x7C88ABDC #; ( RP! ) 
.equ hash_SPTO, 0x7C8A507D #; ( SP! ) 

# moves return stack
.equ hash_TOR, 0x0B88004C #; ( >R ) 
.equ hash_RTO, 0x0B8804AC #; ( R> ) 
.equ hash_RAT, 0x0B880702 #; ( R@ ) 

# moves data stack
.equ hash_DROP, 0x7C7F5C2C #; ( DROP ) 
.equ hash_DUP, 0x0B87BC84 #; ( DUP ) 
.equ hash_OVER, 0x7C84398B #; ( OVER ) 
.equ hash_SWAP, 0x7C8A3910 #; ( SWAP ) 
.equ hash_ROT, 0x0B8807CC #; ( ROT )

# memory
.equ hash_FETCH, 0x0C3E96F9 #; ( @ ) 
.equ hash_STORE, 0x0DD22B7A #; ( ! ) 
.equ hash_CFETCH, 0x2376B3FA #; ( C@ ) 
.equ hash_CSTORE, 0x252B26F9 #; ( C! ) 

# arithmetic
.equ hash_PLUS, 0x7C8A057F #; ( + ) 
.equ hash_MINUS, 0x0002B588 #; ( - )
.equ hash_BYMUL, 0x005972C2 #; ( M* )
.equ hash_BYMOD, 0x7C4D1C6C #; ( /MOD )

# logics
.equ hash_AND, 0x0B87B72E #; ( AND ) 
.equ hash_ORR, 0x0B87E22A #; ( OR ) 
.equ hash_XOR, 0x0B883040 #; ( XOR ) 
.equ hash_LSHIFT, 0x2C5784C9 #; ( LSHIFT )
.equ hash_RSHIFT, 0x416E6B97 #; ( RSHIFT )
.equ hash_INVERSE, 0x2D6AA2B5 #; ( INVERSE )
.equ hash_NEGATE, 0x26B37A79 #; ( NEGATE )

# comparation
.equ hash_EQU, 0x0002B598  #; ( = )
.equ hash_LESS, 0x0002B599 #; ( < ) 
.equ hash_ULESS, 0x005973CC #; (U< ) 
.equ hash_GTZERO, 0x0059680B #; ( 0> )
.equ hash_GREATHER, 0x2D802BBF #; ( > )

# address
.equ hash_ALIGN, 0x0C531CC8 #; ( ALIGN )
.equ hash_EXECUTE, 0x69224E1A #; ( EXECUTE )
.equ hash_PERFORM, 0x15EEB854 #; ( PERFORM )

# constants
.equ hash_TRUE, 0x7C879BF3 #; ( TRUE )
.equ hash_FALSE, 0x0C3C6778 #; ( FALSE )
.equ hash_NAN, 0x0B87D404 #; ( NAN )
.equ hash_CELL, 0x7C81B0A3 #; ( CELL )
.equ hash_NIL, 0x0002B595 #; ( 0 )
.equ hash_ONE, 0x0002B594 #; ( 1 )
.equ hash_TWO, 0x0002B597 #; ( 2 )

# variables
.equ hash_SPZ, 0x0B881196 #; ( SP0 )
.equ hash_RPZ, 0x0B880557 #; ( RP0 )
.equ hash_STAT, 0x0DD1F032 #; ( STATE )
.equ hash_HEAP, 0x00597251 #; ( DP )
.equ hash_LAST, 0x2ADAAFBE #; ( LATEST )
.equ hash_PIKE, 0x7C8A12B2 #; ( PIKE )
.equ hash_BASE, 0x7C8025F0 #; ( BASE )

# dictionary
.equ hash_COLON, 0x0002B59F #; ( : )
.equ hash_SEMIS, 0x0002B59E #; ( ; )
#.equ hash_NAMET, 0x07669CB8 #; ( :NAME )

# system ecalls
.equ hash_BYE, 0x0B87C61B #; ( BYE )
.equ hash_KEY, 0x0B87F112 #; ( KEY )
.equ hash_EMIT, 0x7C7C87D0 #; ( EMIT )

# ---------------------------------------------------------
# A fake header as end of dictionary linked list
	.word FALSE
	.word TRUE
9999:

#----------------------------------------------------------------------

# ( -- ) #; ( EXIT ) 
def_native "exit" hash_EXIT 
#
# aka EXIT
unnest:
	pull ip rp
next:
	pull nos ip
pick:
	bge nos, nib, nest
jump:
	jalr ra, 0 (nos)
	j next
# aka DOCOL
nest:
	push ip rp 
move:
	mv ip, nos
	j next

# ( -- ) #; ( BRANCH )
def_native "branch" hash_BRANCH 
branch:
	lw nos, 0 (ip)
	add ip, ip, nos
end_native

# ( w -- ) #; ( ZBRANCH )
def_native "zbranch" hash_ZBRANCH 
	mv nos, tos
	pull tos sp
	beqz nos, branch
	addi ip, ip, CELL
end_native

# ( w -- ) #; ( GBRANCH )
def_native "gbranch" hash_GBRANCH 
	mv nos, tos
	pull tos sp
	bgt nos, zero, branch
	addi ip, ip, CELL
end_native

# ( -- w ) #; ( DOCON ), also is LIT
def_native "docon" hash_DOCON
	push tos sp
	lw tos, 0 (ip)
	addi ip, ip, CELL
end_native

# ( -- w ) #; ( DOVAR )
def_native "dovar" hash_DOVAR 
	push tos sp
	mv tos, ip
	addi ip, ip, CELL
end_native

#----------------------------------------------------------------------

# ( w -- ; -- w ) #; ( >R )
def_native "tor" hash_TOR 
	push tos rp 
	pull tos sp
end_native

# ( -- w ; w -- ) #; ( R> )
def_native "rto" hash_RTO 
	push tos sp
	pull tos rp
end_native

# ( -- w ; w -- w ) #; ( R@ )
def_native "rat" hash_RAT 
	push tos sp
	lw tos, 0 (rp)
end_native

# ( -- rp ) #; ( RP@ )
def_native "rpat" hash_RPAT 
	push tos sp
	mv tos, rp
end_native

# ( -- sp ) #; ( SP@ )
def_native "spat" hash_SPAT 
	push tos sp
	mv tos, sp
end_native

# ( rp -- ) #; ( RP! )
def_native "rpto" hash_RPTO 
	mv rp, tos
	pull tos sp
end_native

# ( sp -- ) #; ( SP! )
def_native "spto" hash_SPTO 
	mv sp, tos
	pull tos sp
end_native

# ( w -- ) #; ( DROP )
def_native "drop" hash_DROP 
	pull tos sp
end_native

# ( w -- w w ) #; ( DUP )
def_native "dup" hash_DUP 
	push tos sp
end_native

# ( w1 w2 -- w1 w2 w1 ) #; ( OVER )
def_native "over" hash_OVER 
	push tos sp
	lw tos, CELL (sp)
end_native

# ( w1 w2  -- w2 w1 ) #; ( SWAP )
def_native "swap" hash_SWAP 
	lw nos, 0 (sp)
	sw tos, 0 (sp)
	mv tos, nos
end_native

# ( w1 w2 W3 -- w3 w1 w2 ) #; ( ROT )
def_native "rot" hash_ROT 
	lw nos, 0 (sp)
	lw trd, 4 (sp)
	sw trd, 0 (sp)
	sw tos, 4 (sp)
	mv tos, nos
end_native

# ( a -- w ) #; ( @ )
def_native "fetch" hash_FETCH 
	lw tos, 0 (tos)
end_native

# ( w a -- ) #; ( ! )
def_native "store" hash_STORE 
	pull nos sp
	sw nos, 0 (tos)
	pull tos sp
end_native

# ( a -- c ) #; ( C@ ) 
def_native "cfetch" hash_CFETCH 
	lb tos, 0 (tos)
end_native

# ( c a -- ) #; ( C! )
def_native "cstore" hash_CSTORE 
	pull nos sp
	sb nos, 0 (tos)
	pull tos sp
end_native

# ( w1 w2 -- w3 ) #; ( + ) 
def_native "plus" hash_PLUS 
	pull nos sp
	add tos, nos, tos
end_native

# ( w1 w2 -- w3 ) #; ( - )
def_native "minus" hash_MINUS 
	pull nos sp
	add tos, nos, tos
end_native

# ( w1 w2 -- w3 w4 ) multiply, double result
def_native "bymul", hash_BYMUL
    	pull nos sp
    	mulh trd, tos, nos
    	mul nos, tos, nos
push2:
    	push nos sp
    	mv tos, trd
end_native

# ( w1 w2 -- w3 w4 ) divide, reminder and quontient
def_native "bymod", hash_BYMOD
    	pull nos sp
    	beqz nos, by_zero
    	div trd, tos, nos
    	rem nos, tos, nos
    	j push2

# ( w1 w2 -- w3 ) #; ( AND )
def_native "and" hash_AND 
	pull nos sp
	and tos, nos, tos
end_native

# ( w1 w2 -- w3 ) #; ( OR )
def_native "or" hash_ORR 
	pull nos sp
	or tos, nos, tos
end_native

# ( w1 w2 -- w3 ) #; ( XOR ) 
def_native "xor" hash_XOR 
	pull nos sp
	xor tos, nos, tos
end_native

# ( w1 w2 -- w1<<w2 ) #; ( LSHIFT ) shift left some bits
def_native "lshift", hash_LSHIFT
         pull nos sp
         sll tos, nos, tos
end_native

# ( w1 w2 -- w1>>w2 ) #; ( RSHIFT ) shift right some bits
def_native "rshift", hash_RSHIFT
         pull nos sp
         srl tos, nos, tos
end_native

# ( w1 -- w2 ) #; ( ALIGN ) align to cell, word is 4 bytes
def_native "align", hash_ALIGN
        addi tos, tos,  (CELL-1)
        andi tos, tos, ~(CELL-1)
end_native

# ( w1 -- w2 ) #; ( INVERSE) 
def_native "inverse", hash_INVERSE
        # xori fst, fst, -1
        not tos, tos
end_native

# ( w1 -- w2 ) #; ( NEGATE ), arithmetic inverse
def_native "negate", hash_NEGATE
        # sub fst, zero, fst
        neg tos, tos
end_native

# ( w1 -- ; -- w2 ) #; ( EXECUTE ), 
def_native "execute", hash_EXECUTE
        # sub fst, zero, fst
        push tos rp
	pull tos sp 
end_native

# ( w -- ) #; #; ( PERFORM ), does a native jump 
def_native "perform", hash_PERFORM
	mv nos, tos
	pull tos sp
        jalr ra, 0 (nos)
end_native

#---------------------------------------------------------------------

# ( w1 w2 -- T|F ) #; ( = ) 
def_native "equ" hash_EQU
    	pull nos sp
	beq tos, nos, istrue
	j isfalse
end_native

# ( w1 w2 -- T|F ) #; ( < ) w1 < w2
def_native "less" hash_LESS 
    pull nos sp
	blt nos, tos, istrue
	j isfalse
end_native

# ( u1 u2 -- T|F ) #; ( U< ) u1 < u2
def_native "uless" hash_ULESS
    	pull nos sp
	bltu nos, tos, istrue
	j isfalse
end_native

# ( u1 u2 -- T|F ) #; ( 0> ) u1 > u2 
def_native "greather" hash_GREATHER
    	pull nos sp
	blt tos, nos, istrue
	j isfalse
end_native

#---------------------------------------------------------------------
# constants

# ( -- 0xFFFFFFFF ) #; ( TRUE ) 
def_native "true" hash_TRUE
	push tos sp
istrue:
	addi tos, zero, TRUE
end_native

# ( -- 0x00000000 ) #; ( FALSE ) 
def_native "false" hash_TRUE
	push tos sp
isfalse:
	addi tos, zero, FALSE	
end_native

# ( -- 0x80000000 ) #; ( NAN ) #; return error and flag IMMEDIATE
def_native "nan" hash_NAN 
by_erro:
by_zero:
by_under:
by_over:
	push tos sp
	lui tos, 0x8000
end_native

# ( -- 0) #; ( 1 ) #;  
def_native "zero" hash_NIL
	push tos sp
	lui tos, 0x0
end_native

# ( -- 1) #; ( 1 ) #;  
def_native "one" hash_ONE
	push tos sp
	lui tos, 0x1
end_native

# ( -- 2) #; ( 1 ) #;  
def_native "two" hash_TWO
	push tos sp
	lui tos, 0x2
end_native

# ( -- 4) #; ( CELL ) #; sizeof a CELL, usualy 32 bits 
def_native "cell" hash_CELL
	push tos sp
	lui tos, 0x4
end_native

#---------------------------------------------------------------------
# variables

# ( -- rp0 ) #; ( RPZ ) 
def_native "rp0" hash_RPZ
	push tos sp
	lw tos, RPTR ( usr )
end_native

# ( -- sp0 ) #; ( SPZ ) 
def_native "sp0" hash_SPZ
	push tos sp
	lw tos, SPTR ( usr )
end_native

# ( -- state ) #; ( STATE ) 
def_native "state" hash_STAT
	push tos sp
	lw tos, STAT ( usr )
end_native

# ( -- last ) #; ( LATEST ) 
def_native "latest" hash_LAST
	push tos sp
	lw tos, LAST ( usr )
end_native

# ( -- heap ) #; ( DP ) 
def_native "heap" hash_HEAP
	push tos sp
	lw tos, HEAP ( usr )
end_native

# ( -- pike ) #; ( PIKE ) 
def_native "pike" hash_PIKE
	push tos sp
	lw tos, PIKE ( usr )
end_native

# ( -- base ) #; ( BASE ) 
def_native "base" hash_BASE
	push tos sp
	lw tos, BASE ( usr )
end_native

#---------------------------------------------------------------------

#include "ecalls.S"

# ( -- ) #; ( BYE )
def_native "bye" hash_BYE
	call _exit
end_native

# ( -- c ) #; ( KEY ) 
def_native "key" hash_KEY
	push tos sp
	call _getc
end_native

# ( c -- ) #; ( EMIT ) 
def_native "emit" hash_EMIT
	call _putc
	pull tos sp
end_native

#---------------------------------------------------------------------

