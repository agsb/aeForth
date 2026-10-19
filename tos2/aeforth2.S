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
.macro def_word label hash 
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
# essential
#
.equ FALSE, 0x00000000
.equ TRUE,  0xFFFFFFFF
.equ NAN,   0x80000000

# ---------------------------------------------------------
# A fake header start of dictionary linked list
#
	.word FALSE
	.word TRUE
9999:

#----------------------------------------------------------------------

#include "assembled.S"

#---------------------------------------------------------------------
9999:
.set assembled_last, 9999b
#---------------------------------------------------------------------

#include "compiled.S"

#---------------------------------------------------------------------
9999:
.set compiled_last, 9999b
#---------------------------------------------------------------------

