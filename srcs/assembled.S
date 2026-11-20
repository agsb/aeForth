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
# words that update ip 
 
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
# moves stack pointers 

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
	lw trd, CELL (spt) 
	sw trd, 0 (spt) 
	sw tos, CELL (spt) 
	mv tos, nos 
        j next 
 
#---------------------------------------------------------------------- 
# access memory 

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
    	pull trd spt 
    	mul nos, trd, tos 
    	mulh tos, trd, tos
    	push nos spt 
        j next 
 
# ( w1 w2 -- w3 w4 ) divide w1 / w2, reminder and quontient 
.equ hash_BYMOD, 0x7C4D1C6C #; ( /MOD ) 
def_word "bymod", hash_BYMOD 
    	beqz tos, by_zero 
    	pull trd spt 
    	rem nos, trd, tos 
    	div tos, trd, tos 
    	push nos spt 
        j next 
 
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

#--------------------------------------------------------------------- 

# comparation 

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
# all errors 
by_zero: 	# division by zero
by_over: 	# stack overflow
by_under: 	# stack underflow
by_error: 	# return error
	push tos spt 
        lui tos, %hi(FLAG_IMM)
        j next 
 
# ( -- 1 ) #; ( CHAR ) #; ASCII sizeof a CHAR, usualy 8 bits 
.equ hash_CHAR, 0x7C81EE9D #; ( CHAR ) 
def_word "char" hash_CHAR
	push tos spt 
	li tos, 1
        j next 
 
# ( w -- w ) #; ( CHAR ) #; sized to CHAR 
.equ hash_CHARS, 0x0CBFC26E #; ( CHARS ) 
def_word "chars" hash_CHARS
	slli tos, tos, 0
        j next 
 
# ( -- 4 ) #; ( CELL ) #; sizeof a CELL, usualy 32 bits 
.equ hash_CELL, 0x7C81B0A3 #; ( CELL ) 
def_word "cell" hash_CELL 
	push tos spt 
	li tos, 4 
        j next 
 
# ( u -- u*4 ) #; ( CELLS ) #; sized to CELL
.equ hash_CELLS, 0x0CB7C550 #; ( CELLS )
def_word "cells" hash_CELLS
	slli tos, tos, 2 
        j next 
 
# -------------------------------------------------------------------- 
# variables 
 

# ( w -- usr[w] )  ( USER ) start of user array 
.equ hash_USER, 0x7C84F154 #; ( USER )
def_word "user" hash_USER 
	push tos spt
	mv tos, usr
	j next

# the first cell (0) at user array is reserved
 
# ( -- sp0 )  ( SP0 ) base of data stack 
.equ hash_SP0, 0x0B881196 #; ( SP0 )
def_word "sp0" hash_SP0 
	push tos spt
	mv tos, usr
	addi tos, tos, SPTR * CELL
	j next
 
# ( -- rp0 )  ( RP0 ) base of data stack 
.equ hash_RP0, 0x0B880557 #; ( RP0 )
def_word "rp0" hash_RP0 
	push tos spt
	mv tos, usr
	addi tos, tos, RPTR * CELL
	j next
 
# ( -- pike )  ( PIKE ) last DP before compile 
.equ hash_PIKE, 0x7C8A12B2 #; ( PIKE )
def_word "pike" hash_PIKE 
	push tos spt
	mv tos, usr
	addi tos, tos, PIKE * CELL
	j next
 
# ( -- latest )  ( LATEST ) last word in linked list 
.equ hash_LATEST, 0x2ADAAFBE #; ( LATEST )
def_word "latest" hash_LATEST 
	push tos spt
	mv tos, usr
	addi tos, tos, LAST * CELL
	j next
 
# ( -- heap )  ( DP ) next free cellin heap
.equ hash_DP, 0x00597251 #; ( DP )
def_word "heap" hash_DP
	push tos spt
	mv tos, usr
	addi tos, tos, HEAP * CELL
	j next
 
# ( -- state )  ( STATE ) indicate the state of forth 
.equ hash_STATE, 0x0DD1F032 #; ( STATE )
def_word "state" hash_STATE 
	push tos spt
	mv tos, usr
	addi tos, tos, STAT * CELL
	j next
 
# ( -- base )  ( BASE ) indicate the radix for numbers 
.equ hash_BASE, 0x7C8025F0 #; ( BASE )
def_word "base" hash_BASE 
	push tos spt
	mv tos, usr
	addi tos, tos, HEAP * CELL
	j next
 
#---------------------------------------------------------------------
# minimal system ecalls 

# ( return -- ) #; ( BYE )
.equ hash_BYE, 0x0B87C61B #; ( BYE ) 
def_word "bye" hash_BYE
	call _exit
	j next

# ( -- c ) #; ( KEY )
.equ hash_KEY, 0x0B87F112 #; ( KEY ) 
def_word "key" hash_KEY
	push tos spt
	call _getc
	j next

# ( c -- ) #; ( EMIT )
.equ hash_EMIT, 0x7C7C87D0 #; ( EMIT ) 
def_word "emit" hash_EMIT
	call _putc
	pull tos spt
	j next

# ( -- w ) #; ( TIMES ) return clock ticks
.equ hash_TIMES, 0x0D841FA3 #; ( TIMES )
def_word "ticks" hash_TIMES
	push tos spt
	call _tick
	j next


#--------------------------------------------------------------------- 

# from milliforth-sector

#----------------------------------------------------------------------

# ( 0 -- FALSE) | ( n -- TRUE), not zero at top ?
.equ hash_NILQ, 0x00596816 #; ( 0# )
def_word "nilq", hash_NILQ
        beqz tos, isfalse
        j istrue

# ( w1 w2 -- w), NOT(w1 AND w2)
.equ hash_NAND, 0x7C8254C0 #; ( NAND )
def_word "nand" hash_NAND
    	pull nos spt 
        and tos, tos, nos
	not tos, tos
	j next

# ( -- usr ) #; ( U@ ) pointer to user array 
.equ hash_UAT, 0x005973B0 #; ( U@ )
def_word "douse" hash_UAT 
	push tos spt 
	mv tos, usr 
        j next 

# ( -- ) #; ( : ) colon for hash and seek
.equ hash_COLON, 0x0002B59F #; ( : )
def_word "colon" hash_COLON
# save here, panic if semis not follow elsewhere

        lw nos, HEAP * CELL (usr)

        sw nos, PIKE * CELL (usr)

# stat is 'compile' == 1

        li nos, COMPILE
        sw nos, STAT * CELL (usr)

# make a header

header:

# copy last into (here)

        lw nos, LAST * CELL (usr)
        call comma

# get a hash of the next token

        call hash

# copy hash into (here)

        mv nos, fth

docomma:

        call comma

        j next

# ( -- ) #; ( ; ) semis for hash and seek
.equ hash_SEMIS, 0x0002B59E #; ( ; )
# update last, panic if colon not lead elsewhere
def_word "semis" hash_SEMIS

        lw nos, PIKE * CELL (usr)
        sw nos, LAST * CELL (usr)

# stat is 'execute' == 0

        li nos, EXECUTE
        sw nos, STAT * CELL (usr)

# compound words must ends with exit

        la nos, xt_exit
        j docomma

# ( -- ) #; ( ', ) like postpone 
.equ hash_DONUT, 0x005965EE #; ( ', )
def_word "donut" hash_DONUT
	call hash
	call seek
	beqz nos, miss 
	call comma
        j next 

# code a ASCII $0-9A-F to value, hexadecimal
.equ hash_dollar, 0x0002B581 #; ( $ )
# (  -- w ) #; ( $ ) 
def_word "dollar" hash_dollar
	push tos spt
	call tonumber
	j next

# code a 32-bit value into $0-9A-F ASCII, hexadecimal
# ( w -- ) #; ( . ) 
.equ hash_DOT, 0x0002B58B #; ( . )
def_word "dot" hash_DOT
	call numberto
	pull tos spt
	j next

# DUP 0 SWAP LESS ? 
# ( w -- ) #; ( GBRANCH ) greater than zero 
.equ hash_GBRANCH, 0x689E2DB6 #; ( GBRANCH ) 
def_word "gbranch" hash_GBRANCH 
	mv nos, tos 
	pull tos spt 
	blt zero, nos, branch 
	addi ipt, ipt, CELL 
        j next 
 
#----------------------------------------------------------------------
# >number
tonumber:
# safe inside Forth words, direct use getc
# strict to use a0, a1, a2 in getc 
# using a3 a4 a5 as extras for easy

	# save ra
	mv a6, ra

        # clear result

        li a3, 0

# must return NaN when error

        lui a4, %hi(FLAG_IMM)

# skip spaces
100:

        call _getc

	# while space or controls

	li nos, BL

        bleu tos, nos, 100b

# verify ASCII valid digit and convert it
200:

        # valid digit, 0-9 and A-Z
        addi tos, tos, -48

        # 0-9 ?
        li nos, 10

	# A-Z ?
        blt tos, nos, 300f

        #; normalize gap ascii 9 to A
        addi tos, tos, -7

300:
	# verify radix
	li nos, 16

        bgt tos, nos, 600f

400:
	# multiply by base 

        slli a3, a3, 4

	# add the value

        add a3, a3, tos

        # mul a3, a3, a5

        # add a3, a3, tos

# scan spaces
500:

        call _getc

	# until space

	li nos, BL

	# less than space ?
        bltu tos, nos, 500b

	# more than space ?
        bltu nos, tos, 200b

# copy value 

	mv a4, a3

600:

        mv tos, a4

	# load ra
	mv ra, a6

        ret

#---------------------------------------------------------------------
# number>	only hexadecimal print
numberto:

	# save ra
	mv a6, ra

        mv a3, tos

        li a4, 58

        li a5, 32

        # rolls
100:
        beqz a5, 300f

        addi a5, a5, -4

        srl  a0, a3, a5

# mask

        andi a0, a0, 15

        ori  a0, a0, 48

        blt  a0, t4, 200f

        addi a0, a0, 7

200:
        call _putc

        j 100b
300:

	# load ra
	mv ra, a6

        ret

#--------------------------------------------------------------------- 
# 13/11/2026, discover that GForth 0.2 define : PERFORM @ EXECUTE ; 
# 
# ( w -- ) #; #; ( BEHAVE ), does a native jump 
# at end do: ' jalr zero, 0 (ra) ' to return at j next
# must preserve ra ipt spt rpt tos usr nib 
.equ hash_BEHAVE, 0x1CD31C18 #; ( BEHAVE )
def_word "behave", hash_BEHAVE
	mv nos, tos 
	pull tos spt 
        jalr ra, 0 (nos) 
        j next 

/* 

# Using BEHAVE, beware of call it with proper setup

entry_point:
# at init of function, preserve those, use 32 for align
        addi sp, sp, -32
        sw ipt, 0(sp)
        sw spt, 4(sp)
        sw rpt, 8(sp)
        sw tos, 12(sp)
        sw usr, 16(sp)
        sw nib, 20(sp)
        sw ra,  24(sp)

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
        lw ra,  24(sp)
        addi sp, sp, 32

# return
	jalr zero, 0 (ra)

*/

#--------------------------------------------------------------------- 
# counts forth heart beatsi on MITC
# t0 counts next executed, t1 counts primitives, t2 counts compiled
#
.ifdef beats

.equ hash_TOBEATS, 0x6BC0B39A #; ( >BEATS )
.equ hash_BEATSTO, 0x1CCFA27A #; ( BEATS> )
.equ hash_ZBEATS,  0x554440FE #; ( ZBEATS )

# ( t2 t1 t0 -- ) #; ( >BEATS ) 
def_word "tobeats" hash_TOBEATS 
	mv cn0, tos
	pull cn1 spt
	pull cn2 spt
	pull tos spt
        j next

# ( -- t2 t1 t0 ) #; ( BEATS> ) 
def_word "beatsto" hash_BEATSTO 
	push tos spt
	push cn2 spt
	push cn1 spt
	mv tos, cn0
        j next

# ( -- ) #; ( 0BEATS ) 
def_word "zbeats" hash_ZBEATS
	mv cn0, zero
	mv cn1, zero
	mv cn2, zero
        j next

.endif

#---------------------------------------------------------------------

