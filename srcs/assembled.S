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
 
#---------------------------------------------------------------------- 
.section .text
.p2align 2, 0x0

#---------------------------------------------------------------------- 
# 
# this is the forth heart beat, Minimum Indirect Thread Code 
# 
# nib is the address after last native code primitive word 
#
# beats counts executions 
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
	addi ipt, ipt, CELL

# this is the tipping point, above nib only lives compiled words 
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
	push ipt rpt 
 
move: 
.ifdef beats
	addi t2, t2, 1
.endif
	mv ipt, nos 
	j next 
 
#---------------------------------------------------------------------- 
# changes ip 
 
# ( -- ) #; ( EXIT ) 
.equ hash_EXIT, 0x7C7CC745 #; ( EXIT ) 
def_word "exit" hash_EXIT 
	j unnest 
 
# ( -- ) #; ( BRANCH ) 
.equ hash_BRANCH, 0x1E6C4191 #; ( BRANCH ) 
def_word "branch" hash_BRANCH 
branch: 
	lw nos, 0 (ipt) 
	add ipt, ipt, nos 
        j next 
 
# ( w -- ) #; ( ZBRANCH ) equal than zero 
.equ hash_ZBRANCH, 0x7D28616B #; ( ZBRANCH ) 
def_word "zbranch" hash_ZBRANCH 
	mv nos, tos 
	pull tos spt 
	beq nos, zero, branch 
	addi ipt, ipt, CELL 
        j next 
 
# ( w -- ) #; ( GBRANCH ) greater than zero 
.equ hash_GBRANCH, 0x689E2DB6 #; ( GBRANCH ) 
def_word "gbranch" hash_GBRANCH 
	mv nos, tos 
	pull tos spt 
	blt zero, nos, branch 
	addi ipt, ipt, CELL 
        j next 
 
# ( -- w ) #; ( DOCON ), also is LIT 
.equ hash_DOCON, 0x0C67F9AC #; ( DOCON ) 
def_word "docon" hash_DOCON 
	push tos spt 
	lw tos, 0 (ipt) 
	addi ipt, ipt, CELL 
        j next 
 
# ( -- w ) #; ( DOVAR ) 
.equ hash_DOVAR, 0x0C682A6B #; ( DOVAR ) 
def_word "dovar" hash_DOVAR 
	push tos spt 
	mv tos, ipt 
	addi ipt, ipt, CELL 
        j next 
 
#---------------------------------------------------------------------- 
# moves return stack 
 
# ( w -- ; -- w ) #; ( >R ) 
.equ hash_TOR, 0x0B88004C #; ( >R ) 
def_word "tor" hash_TOR 
	push tos rpt 
	pull tos spt 
        j next 
 
# ( -- w ; w -- ) #; ( R> ) 
.equ hash_RTO, 0x0B8804AC #; ( R> ) 
def_word "rto" hash_RTO 
	push tos spt 
	pull tos rpt 
        j next 
 
# ( -- w ; w -- w ) #; ( R@ ) 
.equ hash_RAT, 0x0B880702 #; ( R@ ) 
def_word "rat" hash_RAT 
	push tos spt 
	lw tos, 0 (rpt) 
        j next 
 
#---------------------------------------------------------------------- 
# moves pointers 

# ( -- rpt ) #; ( RP@ ) 
.equ hash_RPAT, 0x7C88A9B2 #; ( RP@ ) 
def_word "rpat" hash_RPAT 
	push tos spt 
	mv tos, rpt 
        j next 
 
# ( -- spt ) #; ( SP@ ) 
.equ hash_SPAT, 0x7C8A4E93 #; ( SP@ ) 
def_word "spat" hash_SPAT 
	push tos spt 
	mv tos, spt 
        j next 
 
# ( rpt -- ) #; ( RP! ) 
.equ hash_RPTO, 0x7C88ABDC #; ( RP! ) 
def_word "rpto" hash_RPTO 
	mv rpt, tos 
	pull tos spt 
        j next 
 
# ( spt -- ) #; ( SP! ) 
.equ hash_SPTO, 0x7C8A507D #; ( SP! ) 
def_word "spto" hash_SPTO 
	mv spt, tos 
	pull tos spt 
        j next 
 
#---------------------------------------------------------------------- 
# moves data stack 
 
# ( w -- ) #; ( DROP ) 
.equ hash_DROP, 0x7C7F5C2C #; ( DROP ) 
def_word "drop" hash_DROP 
	pull tos spt 
        j next 
 
# ( w -- w w ) #; ( DUP ) 
.equ hash_DUP, 0x0B87BC84 #; ( DUP ) 
def_word "dup" hash_DUP 
	push tos spt 
        j next 
 
# ( w1 w2 -- w1 w2 w1 ) #; ( OVER ) 
.equ hash_OVER, 0x7C84398B #; ( OVER ) 
def_word "over" hash_OVER 
	push tos spt 
	lw tos, CELL (spt) 
        j next 
 
# ( w1 w2  -- w2 w1 ) #; ( SWAP ) 
.equ hash_SWAP, 0x7C8A3910 #; ( SWAP ) 
def_word "swap" hash_SWAP 
	lw nos, 0 (spt) 
	sw tos, 0 (spt) 
	mv tos, nos 
        j next 
 
# ( w1 w2 W3 -- w3 w1 w2 ) #; ( ROT ) 
.equ hash_ROT, 0x0B8807CC #; ( ROT ) 
def_word "rot" hash_ROT 
	lw nos, 0 (spt) 
	lw trd, 4 (spt) 
	sw trd, 0 (spt) 
	sw tos, 4 (spt) 
	mv tos, nos 
        j next 
 
#---------------------------------------------------------------------- 
# memory 

# ( a -- w ) #; ( @ ) 
.equ hash_FETCH, 0x0C3E96F9 #; ( @ ) 
def_word "fetch" hash_FETCH 
	lw tos, 0 (tos) 
        j next 
 
# ( w a -- ) #; ( ! ) 
.equ hash_STORE, 0x0DD22B7A #; ( ! ) 
def_word "store" hash_STORE 
	pull nos spt 
	sw nos, 0 (tos) 
	pull tos spt 
        j next 
 
# ( a -- c ) #; ( C@ ) 
.equ hash_CFETCH, 0x2376B3FA #; ( C@ ) 
def_word "cfetch" hash_CFETCH 
	lb tos, 0 (tos) 
        j next 
 
# ( c a -- ) #; ( C! ) 
.equ hash_CSTORE, 0x252B26F9 #; ( C! ) 
def_word "cstore" hash_CSTORE 
	pull nos spt 
	sb nos, 0 (tos) 
	pull tos spt 
        j next 
 
#---------------------------------------------------------------------- 
# arithmetic 
 
# ( w1 w2 -- w3 ) #; ( + ) addiction w1 + w2
.equ hash_PLUS, 0x7C8A057F #; ( + ) 
def_word "plus" hash_PLUS 
	pull nos spt 
	add tos, nos, tos 
        j next 
 
# ( w1 w2 -- w3 ) #; ( - ) subtract w1 - w2
.equ hash_MINUS, 0x0002B588 #; ( - ) 
def_word "minus" hash_MINUS 
	pull nos spt 
	sub tos, nos, tos 
        j next 
 
# ( w1 w2 -- w3 w4 ) multiply w1 * w2, double result 
.equ hash_BYMUL, 0x005972C2 #; ( M* ) 
def_word "bymul", hash_BYMUL 
    	pull nos spt 
    	mulh trd, nos, tos 
    	mul nos, nos, tos
push2: 
    	push nos spt 
    	mv tos, trd 
        j next 
 
# ( w1 w2 -- w3 w4 ) divide w1 / w2, reminder and quontient 
.equ hash_BYMOD, 0x7C4D1C6C #; ( /MOD ) 
def_word "bymod", hash_BYMOD 
    	beqz tos, by_zero 
    	pull nos spt 
    	div trd, nos, tos 
    	rem nos, nos, tos 
    	j push2 
 
#---------------------------------------------------------------------- 
# logics 

# ( w1 w2 -- w3 ) #; ( AND ) w1 AND w2 
.equ hash_AND, 0x0B87B72E #; ( AND ) 
def_word "and" hash_AND 
	pull nos spt 
	and tos, nos, tos 
        j next 
 
# ( w1 w2 -- w3 ) #; ( OR ) w1 OR w2
.equ hash_ORR, 0x0B87E22A #; ( OR ) 
def_word "orr" hash_ORR 
	pull nos spt 
	or tos, nos, tos 
        j next 
 
# ( w1 w2 -- w3 ) #; ( XOR ) w1 XOR w2
.equ hash_XOR, 0x0B883040 #; ( XOR ) 
def_word "xor" hash_XOR 
	pull nos spt 
	xor tos, nos, tos 
        j next 
 
# ( w1 -- w2 ) #; ( INVERSE) w1
.equ hash_INVERSE, 0x2D6AA2B5 #; ( INVERSE ) 
def_word "inverse", hash_INVERSE 
        # xori fst, fst, -1 
        not tos, tos 
        j next 
 
# ( w1 -- w2 ) #; ( NEGATE ), arithmetic inverse 
.equ hash_NEGATE, 0x26B37A79 #; ( NEGATE ) 
def_word "negate", hash_NEGATE 
        # sub fst, zero, fst 
        neg tos, tos 
        j next 
 
# ( w1 w2 -- w1<<w2 ) #; ( LSHIFT ) w1 << W2 shift left some bits 
.equ hash_LSHIFT, 0x2C5784C9 #; ( LSHIFT ) 
def_word "lshift", hash_LSHIFT 
         pull nos spt 
         sll tos, nos, tos 
        j next 
 
# ( w1 w2 -- w1>>w2 ) #; ( RSHIFT ) w1 >> w2 shift right some bits 
.equ hash_RSHIFT, 0x416E6B97 #; ( RSHIFT ) 
def_word "rshift", hash_RSHIFT 
         pull nos spt 
         srl tos, nos, tos 
        j next 

# ( w1 w2 -- w), NOT(w1 AND w2)
.equ hash_NAND, 0x7C8254C0 #; ( NAND )
def_word "nand" hash_NAND
    	pull nos spt 
        and tos, tos, nos
	not tos, tos
	j next

#--------------------------------------------------------------------- 
 
# ( w -- ) #; #; ( PERFORM ), does a native jump 
# at end do: ' jalr zero, 0 (ra) ' to return at j next
# must preserve ra ipt spt rpt tos usr nib 
.equ hash_PERFORM, 0x15EEB854 #; ( PERFORM ) 
def_word "perform", hash_PERFORM 
	mv nos, tos 
	pull tos spt 
        jalr ra, 0 (nos) 
        j next 

/* 

# Using PERFORM, beware of call it with proper setup

entry_point:
# at init of function, preserve those, use 32 for align
        addi sp, sp, -32
        sw ipt, 0(sp)
        sw spt, 4(sp)
        sw rpt, 8(sp)
        sw tos, 12(sp)
        sw usr, 16(sp)
        sw nib, 20(sp)

	~~~~~~~~~~~~~~~~~~~
	~~DO_WHAT_IS_NEED~~
	~~~~~~~~~~~~~~~~~~~

# at quit of function, restore those, use 32 for align
        lw ipt, 0(sp)
        lw spt, 4(sp)
        lw rpt, 8(sp)
        lw tos, 12(sp)
        lw usr, 16(sp)
        lw nib, 20(sp)
        addi sp, sp, 32

# return
	jalr zero, 0 (ra)

*/

#--------------------------------------------------------------------- 

# comparation 

# ( 0 -- FALSE) | ( n -- TRUE), not zero at top ?
.equ hash_NILQ, 0x00596816 #; ( 0# )
def_word "nilq", hash_NILQ
        beqz tos, isfalse
        j istrue

# ( w1 w2 -- T|F ) #; ( = ) 
.equ hash_EQU, 0x0002B598  #; ( = ) 
def_word "equ" hash_EQU 
    	pull nos spt 
	beq tos, nos, istrue 
	j isfalse 
 
# ( w1 w2 -- T|F ) #; ( < ) w1 < w2 
.equ hash_LESS, 0x0002B599 #; ( < ) 
def_word "less" hash_LESS 
    pull nos spt 
	blt nos, tos, istrue 
	j isfalse 
 
# ( u1 u2 -- T|F ) #; ( U< ) u1 < u2 
.equ hash_ULESS, 0x005973CC #; (U< ) 
def_word "uless" hash_ULESS 
    	pull nos spt 
	bltu nos, tos, istrue 
	j isfalse 

#--------------------------------------------------------------------- 
# implementation dependent stuff 

#--------------------------------------------------------------------- 
# constants 
 
# ( -- 0xFFFFFFFF ) #; ( TRUE ) 
.equ hash_TRUE, 0x7C879BF3 #; ( TRUE ) 
def_word "true" hash_TRUE 
	push tos spt 
istrue: 
	addi tos, zero, TRUE 
        j next 
 
# ( -- 0x00000000 ) #; ( FALSE ) 
.equ hash_FALSE, 0x0C3C6778 #; ( FALSE ) 
def_word "false" hash_TRUE 
	push tos spt 
isfalse: 
	addi tos, zero, FALSE	 
        j next 
 
# ( -- 0x80000000 ) #; ( NAN ) #; return error and flag IMMEDIATE 
.equ hash_NAN, 0x0B87D404 #; ( NAN ) 
def_word "nan" hash_NAN 
by_zero: 
by_over: 
by_under: 
by_error: 
	push tos spt 
	lui tos, 0x8000 
        j next 
 
# ( -- 4) #; ( CELL ) #; sizeof a CELL, usualy 32 bits 
.equ hash_CELL, 0x7C81B0A3 #; ( CELL ) 
def_word "cell" hash_CELL 
	push tos spt 
	lui tos, 0x4 
        j next 
 
# ( u -- u*4 ) #; ( CELLS ) #; sized to CELL 
.equ hash_CELLS, 0x0CB7C550 #; ( CELLS )
def_word "cells" hash_CELLS
	sll tos, tos, 0x4 
        j next 
 
#--------------------------------------------------------------------- 

# constants
.equ hash_USER, 0x7C84F154 #; ( USER )
# ( -- usr ) #; ( USER ) pointer to user array, milliforth: U@ 
def_word "user" hash_USER 
	push tos spt 
	mv tos, usr 
        j next 

.equ hash_RPZ, 0x0B880557 #; ( RP0 ) 
# ( -- rp0 ) #; ( RPZ ) 
def_word "rp0" hash_RPZ 
	push tos spt 
	lw tos, RPTR  * CELL ( usr ) 
        j next 
 
# ( -- sp0 ) #; ( SPZ ) 
.equ hash_SPZ, 0x0B881196 #; ( SP0 ) 
def_word "sp0" hash_SPZ 
	push tos spt 
	lw tos, SPTR  * CELL ( usr ) 
        j next 
 
#--------------------------------------------------------------------- 
# variables 
 
.equ hash_TEMP, 0x7C87D1E9 #; ( TEMP ) 

# ( -- state ) #; ( STATE ) 
.equ hash_STAT, 0x0DD1F032 #; ( STATE ) 
def_word "state" hash_STAT 
	push tos spt 
	addi tos, usr, STAT * CELL
        j next 
 
# ( -- last ) #; ( LATEST ) 
.equ hash_LAST, 0x2ADAAFBE #; ( LATEST ) 
def_word "latest" hash_LAST 
	push tos spt 
	addi tos, usr, LAST * CELL
        j next 
 
# ( -- heap ) #; ( DP ) 
.equ hash_HEAP, 0x00597251 #; ( DP ) 
def_word "heap" hash_HEAP 
	push tos spt 
	addi tos, usr, HEAP * CELL
        j next 
 
# ( -- base ) #; ( BASE ) 
.equ hash_BASE, 0x7C8025F0 #; ( BASE ) 
def_word "base" hash_BASE 
	push tos spt 
	addi tos, usr, BASE * CELL
        j next 
 
# ( -- pike ) #; ( PIKE ) 
.equ hash_PIKE, 0x7C8A12B2 #; ( PIKE ) 
def_word "pike" hash_PIKE 
	push tos spt 
	addi tos, usr, PIKE * CELL
        j next 
 
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
        j next

# ( -- t2 t1 t0 ) #; ( BASE ) 
def_word "beatsto" hash_BEATSTO 
	push tos spt
	mv tos, t2
	push tos spt
	mv tos, t1
	push tos spt
	mv tos, t2
        j next

# ( -- ) #; ( BEATSASE ) 
def_word "zbeats" hash_ZBEATS
	mv t0, zero
	mv t1, zero
	mv t2, zero
        j next

.endif



#----------------------------------------------------------------------
# code a ASCII $0-9A-Z to value, conform radix of BASE
.equ hash_TONUMBER, 0x0002B581 #; ( $ )
# ( -- w ) #; ( $ ) 
def_word "tonumber" hash_TONUMBER

	push tos spt

	call tonumber

	j next

#----------------------------------------------------------------------
# >number
tonumber:
# safe inside Forth words, direct use getc
# strict to use a0, a1, a2 in getc 
# using a3 a4 a5 as extras for easy

        # clear result

        li a3, 0

        # load space

        li a4, BL

	# load radix 

        lw a5, BASE * CELL (usr)

        # skip spaces
nskip:

        call _getc

	# escape allow controls

        bltu tos, a4, nskip

	# while space

        bleu tos, a4, nskip

# verify ASCII valid digit and convert it

ndigit:

        #; valid digit, 0-9 and A-F
        addi tos, tos, -48
        blt tos, zero, nodigit

        #; 0-9 ?
        li nos, 10
        blt tos, tos, isradix

        #; normalize gap ascii 9 to A
        addi tos, tos, -7

isradix:

        bgt tos, a5, nodigit

isdigit:

        mul a3, a3, a5

        add a3, a3, tos

        # scan spaces
nscan:

        call _getc

	# escape allow controls

        bltu tos, a4, nscan

	# until space

        bne tos, a4, ndigit

resume:

        mv tos, a3

        ret

nodigit:

        mv tos, a5

        ret

#---------------------------------------------------------------------
# code a 32-bit value in 0-9A-Z ASCII, conform radix value
# safe inside Forth words, direct putc
# ( w -- ) #; ( . ) 
.equ hash_DOT, 0x0002B58B #; ( . )
def_word "dot" hash_DOT

	call num2hex

	pull tos spt

	j next

#---------------------------------------------------------------------
# number>
num2hex:

        mv t3, tos

        li t4, 58

        li t5, 32

        # rolls
100:
        beqz t5, 300f

        addi t5, t5, -4

        srl  a3, t3, t5

# mask

        andi a3, a3, 15

        ori  a3, a3, 48

        blt  a3, t4, 200f

        addi a3, a3, 7

200:
        call _putc

        j 100b
300:

        ret

#---------------------------------------------------------------------

