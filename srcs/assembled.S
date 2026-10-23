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
 
#---------------------------------------------------------------------- 
.section .text
.p2align 2, 0x0

#---------------------------------------------------------------------- 
# 
# this is the forth heart beat, Minimum Indirect Thread Code 
# 
# nib is the address after last native code primitive word 
# 
# aka EXIT 
unnest: 
	pull ipt rpt 
 
# aka NEXT 
next: 
.ifdef beats
	addi t0, t0, 1
.endif
	# no round-robin limit
	lw nos, 0 (ipt)
	addi ipt, ipt,CELL
 
pick: 
	bge nos, nib, nest 
 
jump: 
.ifdef beats
	addi t1, t1, 1
.endif
	jalr ra, 0 (nos) 
	j next 
 
# aka DOCOL 
nest: 
.ifdef beats
	addi t2, t2, 1
.endif
	push ipt rpt 
 
move: 
	mv ipt, nos 
	j next 
 
#---------------------------------------------------------------------- 
 
# ( -- ) #; ( EXIT ) 
def_word "exit" hash_EXIT 
	j unnest 
 
# ( -- ) #; ( BRANCH ) 
def_word "branch" hash_BRANCH 
branch: 
	lw nos, 0 (ipt) 
	add ipt, ipt, nos 
end_word 
 
# ( w -- ) #; ( ZBRANCH ) equal than zero 
def_word "zbranch" hash_ZBRANCH 
	mv nos, tos 
	pull tos spt 
	beq nos, zero, branch 
	addi ipt, ipt, CELL 
end_word 
 
# ( w -- ) #; ( GBRANCH ) greater than zero 
def_word "gbranch" hash_GBRANCH 
	mv nos, tos 
	pull tos spt 
	bgt nos, zero, branch 
	addi ipt, ipt, CELL 
end_word 
 
# ( -- w ) #; ( DOCON ), also is LIT 
def_word "docon" hash_DOCON 
	push tos spt 
	lw tos, 0 (ipt) 
	addi ipt, ipt, CELL 
end_word 
 
# ( -- w ) #; ( DOVAR ) 
def_word "dovar" hash_DOVAR 
	push tos spt 
	mv tos, ipt 
	addi ipt, ipt, CELL 
end_word 
 
#---------------------------------------------------------------------- 
 
# ( w -- ; -- w ) #; ( >R ) 
def_word "tor" hash_TOR 
	push tos rpt 
	pull tos spt 
end_word 
 
# ( -- w ; w -- ) #; ( R> ) 
def_word "rto" hash_RTO 
	push tos spt 
	pull tos rpt 
end_word 
 
# ( -- w ; w -- w ) #; ( R@ ) 
def_word "rat" hash_RAT 
	push tos spt 
	lw tos, 0 (rpt) 
end_word 
 
# ( -- rpt ) #; ( RP@ ) 
def_word "rpat" hash_RPAT 
	push tos spt 
	mv tos, rpt 
end_word 
 
# ( -- spt ) #; ( SP@ ) 
def_word "spat" hash_SPAT 
	push tos spt 
	mv tos, spt 
end_word 
 
# ( rpt -- ) #; ( RP! ) 
def_word "rpto" hash_RPTO 
	mv rpt, tos 
	pull tos spt 
end_word 
 
# ( spt -- ) #; ( SP! ) 
def_word "spto" hash_SPTO 
	mv spt, tos 
	pull tos spt 
end_word 
 
# ( w -- ) #; ( DROP ) 
def_word "drop" hash_DROP 
	pull tos spt 
end_word 
 
# ( w -- w w ) #; ( DUP ) 
def_word "dup" hash_DUP 
	push tos spt 
end_word 
 
# ( w1 w2 -- w1 w2 w1 ) #; ( OVER ) 
def_word "over" hash_OVER 
	push tos spt 
	lw tos, CELL (spt) 
end_word 
 
# ( w1 w2  -- w2 w1 ) #; ( SWAP ) 
def_word "swap" hash_SWAP 
	lw nos, 0 (spt) 
	sw tos, 0 (spt) 
	mv tos, nos 
end_word 
 
# ( w1 w2 W3 -- w3 w1 w2 ) #; ( ROT ) 
def_word "rot" hash_ROT 
	lw nos, 0 (spt) 
	lw trd, 4 (spt) 
	sw trd, 0 (spt) 
	sw tos, 4 (spt) 
	mv tos, nos 
end_word 
 
# ( a -- w ) #; ( @ ) 
def_word "fetch" hash_FETCH 
	lw tos, 0 (tos) 
end_word 
 
# ( w a -- ) #; ( ! ) 
def_word "store" hash_STORE 
	pull nos spt 
	sw nos, 0 (tos) 
	pull tos spt 
end_word 
 
# ( a -- c ) #; ( C@ ) 
def_word "cfetch" hash_CFETCH 
	lb tos, 0 (tos) 
end_word 
 
# ( c a -- ) #; ( C! ) 
def_word "cstore" hash_CSTORE 
	pull nos spt 
	sb nos, 0 (tos) 
	pull tos spt 
end_word 
 
# ( w1 w2 -- w3 ) #; ( + ) 
def_word "plus" hash_PLUS 
	pull nos spt 
	add tos, nos, tos 
end_word 
 
# ( w1 w2 -- w3 ) #; ( - ) 
def_word "minus" hash_MINUS 
	pull nos spt 
	add tos, nos, tos 
end_word 
 
# ( w1 w2 -- w3 w4 ) multiply, double result 
def_word "bymul", hash_BYMUL 
    	pull nos spt 
    	mulh trd, tos, nos 
    	mul nos, tos, nos 
push2: 
    	push nos spt 
    	mv tos, trd 
end_word 
 
# ( w1 w2 -- w3 w4 ) divide, reminder and quontient 
def_word "bymod", hash_BYMOD 
    	pull nos spt 
    	beqz nos, by_zero 
    	div trd, tos, nos 
    	rem nos, tos, nos 
    	j push2 
 
# ( w1 w2 -- w3 ) #; ( AND ) 
def_word "and" hash_AND 
	pull nos spt 
	and tos, nos, tos 
end_word 
 
# ( w1 w2 -- w3 ) #; ( OR ) 
def_word "or" hash_ORR 
	pull nos spt 
	or tos, nos, tos 
end_word 
 
# ( w1 w2 -- w3 ) #; ( XOR ) 
def_word "xor" hash_XOR 
	pull nos spt 
	xor tos, nos, tos 
end_word 
 
# ( w1 w2 -- w1<<w2 ) #; ( LSHIFT ) shift left some bits 
def_word "lshift", hash_LSHIFT 
         pull nos spt 
         sll tos, nos, tos 
end_word 
 
# ( w1 w2 -- w1>>w2 ) #; ( RSHIFT ) shift right some bits 
def_word "rshift", hash_RSHIFT 
         pull nos spt 
         srl tos, nos, tos 
end_word 
 
# ( w1 -- w2 ) #; ( ALIGN ) align to cell, word is 4 bytes 
def_word "align", hash_ALIGN 
        addi tos, tos,  (CELL-1) 
        andi tos, tos, ~(CELL-1) 
end_word 
 
# ( w1 -- w2 ) #; ( INVERSE) 
def_word "inverse", hash_INVERSE 
        # xori fst, fst, -1 
        not tos, tos 
end_word 
 
# ( w1 -- w2 ) #; ( NEGATE ), arithmetic inverse 
def_word "negate", hash_NEGATE 
        # sub fst, zero, fst 
        neg tos, tos 
end_word 
 
# ( w1 -- ; -- w2 ) #; ( EXECUTE ), 
def_word "execute", hash_EXECUTE 
        # sub fst, zero, fst 
        push tos rpt 
	pull tos spt 
end_word 
 
# ( w -- ) #; #; ( PERFORM ), does a native jump 
def_word "perform", hash_PERFORM 
	mv nos, tos 
	pull tos spt 
        jalr ra, 0 (nos) 
end_word 
 
#--------------------------------------------------------------------- 
 
# ( w1 w2 -- T|F ) #; ( = ) 
def_word "equ" hash_EQU 
    	pull nos spt 
	beq tos, nos, istrue 
	j isfalse 
end_word 
 
# ( w1 w2 -- T|F ) #; ( < ) w1 < w2 
def_word "less" hash_LESS 
    pull nos spt 
	blt nos, tos, istrue 
	j isfalse 
end_word 
 
# ( u1 u2 -- T|F ) #; ( U< ) u1 < u2 
def_word "uless" hash_ULESS 
    	pull nos spt 
	bltu nos, tos, istrue 
	j isfalse 
end_word 
 
# ( u1 u2 -- T|F ) #; ( 0> ) u1 > u2 
def_word "greather" hash_GREATHER 
    	pull nos spt 
	blt tos, nos, istrue 
	j isfalse 
end_word 
 
#--------------------------------------------------------------------- 
# constants 
 
# ( -- 0xFFFFFFFF ) #; ( TRUE ) 
def_word "true" hash_TRUE 
	push tos spt 
istrue: 
	addi tos, zero, TRUE 
end_word 
 
# ( -- 0x00000000 ) #; ( FALSE ) 
def_word "false" hash_TRUE 
	push tos spt 
isfalse: 
	addi tos, zero, FALSE	 
end_word 
 
# ( -- 0x80000000 ) #; ( NAN ) #; return error and flag IMMEDIATE 
def_word "nan" hash_NAN 
by_erro: 
by_zero: 
by_under: 
by_over: 
	push tos spt 
	lui tos, 0x8000 
end_word 
 
# ( -- 0) #; ( 0 ) #; 
def_word "nil" hash_NIL 
	push tos spt 
	lui tos, 0x0 
end_word 
 
# ( -- 1) #; ( 1 ) #; 
def_word "one" hash_ONE 
	push tos spt 
	lui tos, 0x1 
end_word 
 
# ( -- 2) #; ( 2 ) #; 
def_word "two" hash_TWO 
	push tos spt 
	lui tos, 0x2 
end_word 
 
# ( -- 4) #; ( CELL ) #; sizeof a CELL, usualy 32 bits 
def_word "cell" hash_CELL 
	push tos spt 
	lui tos, 0x4 
end_word 
 
#--------------------------------------------------------------------- 
# variables 
 
# ( -- rp0 ) #; ( RPZ ) 
def_word "rp0" hash_RPZ 
	push tos spt 
	lw tos, RPTR ( usr ) 
end_word 
 
# ( -- sp0 ) #; ( SPZ ) 
def_word "sp0" hash_SPZ 
	push tos spt 
	lw tos, SPTR ( usr ) 
end_word 
 
# ( -- state ) #; ( STATE ) 
def_word "state" hash_STAT 
	push tos spt 
	lw tos, STAT ( usr ) 
end_word 
 
# ( -- last ) #; ( LATEST ) 
def_word "latest" hash_LAST 
	push tos spt 
	lw tos, LAST ( usr ) 
end_word 
 
# ( -- heap ) #; ( DP ) 
def_word "heap" hash_HEAP 
	push tos spt 
	lw tos, HEAP ( usr ) 
end_word 
 
# ( -- pike ) #; ( PIKE ) 
def_word "pike" hash_PIKE 
	push tos spt 
	lw tos, PIKE ( usr ) 
end_word 
 
# ( -- base ) #; ( BASE ) 
def_word "base" hash_BASE 
	push tos spt 
	lw tos, BASE ( usr ) 
end_word 
 
#--------------------------------------------------------------------- 
 
#include "ecalls.S" 
 
# ( -- ) #; ( BYE ) 
def_word "bye" hash_BYE 
	call _exit 
end_word 
 
# ( -- c ) #; ( KEY ) 
def_word "key" hash_KEY 
	push tos spt 
	call _getc 
end_word 
 
# ( c -- ) #; ( EMIT ) 
def_word "emit" hash_EMIT 
	call _putc 
	pull tos spt 
end_word 
 
#--------------------------------------------------------------------- 
# counts forth heart beats
# t0 counts next executed, t1 counts primitives, t2 counts compiled
#
.ifdef beats

.equ hash_>BEATS, 0x6BC0B39A #; ( >BEATS )
.equ hash_BEATS>, 0x1CCFA27A #; ( BEATS> )
.equ hash_ZBEATS, 0x554440FE #; ( ZBEATS )

# ( t2 t1 t0 -- ) #; ( BASE ) 
def_word "tobeats" hash_TOBEATS 
	mv t0, tos
	pull tos spt
	mv t1, tos
	pull tos spt
	mv t2, tos
	pull tos spt
end_word

# ( -- t2 t1 t0 ) #; ( BASE ) 
def_word "beatsto" hash_BEATSTO 
	push tos spt
	mv tos, t2
	push tos spt
	mv tos, t1
	push tos spt
	mv tos, t2
end_word

# ( -- ) #; ( BEATSASE ) 
def_word "zbeats" hash_ZBEATS
	mv t0, zero
	mv t1, zero
	mv t2, zero
end_word

.endif


#--------------------------------------------------------------------- 

