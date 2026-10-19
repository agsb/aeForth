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

#
# aeForth with MITC, 
#
# Using 
# 	Minimal Indirect Thread Code
#	ip, sp, rp, tos, in dedicated registers
#	nos, trd, fth as generic registers
#	words in uppercase
#
# s0, s1, a0, a2, a3, a7 used in ecalls
#
# s0, s1, a0, a2, a3, a4, a5 used in 16 bits opcodes
#
#
#----------------------------------------------------------------------
#
# define register aliases
#
# -st -nd -rd -th 

# forth parameter stack pointer, reserved
#define sp s0

# forth return stack pointer, reserved
#define rp s1

# forth instruction pointer, reserved
#define ip a3

# forth top of stack, reserved, for easy
#define tos a4

# forth second on stack, not reserved
#define nos a5

# forth third on stack, not reserved
#define trd a6

# a0, a1, a2, a7 used as scratch, preserved inside ecalls

# fixed memory pointers

#define usr s2

#define ran s3

#define nib s4 

#----------------------------------------------------------------------
# generics alias

#----------------------------------------------------------------------
# max size of dictionary 64k CELLS, depends on host machine

.equ RAM_LIMIT, 0x40000

# as FORTH 1983

.equ FALSE, 0

.equ TRUE, -1

# states

.equ EXECUTE, 0

.equ COMPILE, 1

# usefull

.equ CELL, 4    # sizeof a CELL

.equ BL,  32    # word delimiter is blank space

.equ QU,  34    # string delimiter is double quote, quotation mark

# highlander, immediate flag, unique NaN

# -2147483648
.equ FLAG_IMM, 0x80000000

# +2147483647
.equ MASK_IMM, 0x7FFFFFFF

# user parameter stack sp rp last heap state base

# data stack index
.equ SPTR, 0 * CELL

# return stack index
.equ RPTR, 1 * CELL

# last link cell in heap dictionary linked list
.equ LAST, 2 * CELL

# next free cell in heap dictionary, aka dp
.equ HEAP, 3 * CELL

# last heap
.equ PIKE, 4 * CELL

# state flag
.equ STAT, 5 * CELL

# base radix for numbers, for future use
.equ BASE, 6 * CELL

# temporary scratch as array of CELLS
.equ TEMP, 7 * CELL

# allow some cells for extras

.equ params, 16

#----------------------------------------------------------------------

.align 2

# label 9999 must be exclusive :)
# ht_ header, with link and hash
# xt_ native code or list of references
#
.macro def_native label hash 
ht_\label:
    .word 9999b - 8
    .word \hash
9999:
xt_\label:
.endm

# gcc handles big long jumps by relaxation :)
.macro end_native
    j next
.endm

# generic push into memory
.macro push rg ps 
 	addi \ps, \ps, -1 * CELL
	sw \rg, 0 (\ps)
.endm

# generic pull from memory
.macro pull rg ps
	lw \rg, 0 (\ps)
 	addi \ps, \ps, 1 * CELL
.endm

#----------------------------------------------------------------------

.equ FALSE, 0x00000000
.equ TRUE,  0xFFFFFFFF
.equ NAN,   0x80000000
.equ CELL,  0x04

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
# A fake header start of dictionary linked list
	.word FALSE
	.word TRUE
9999:

#----------------------------------------------------------------------

#include "assembled.S"

#---------------------------------------------------------------------
9999:
.set def_native_last, 9999b
#---------------------------------------------------------------------

#include "compiled.S"

#---------------------------------------------------------------------
9999:
.set def_compiled_last, 9999b
#---------------------------------------------------------------------

