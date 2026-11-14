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
#
# aeForth with MITC, 
#
# Using 
#        Minimal Indirect Thread Code
#        ip, sp, rp, tos, in dedicated registers
#	 usr, nib in dedicated register
#        nos, trd, fth as generic registers
#        hash of words in uppercase
#        no buffer input.
#
# a0, a2, a3, a4, a5, a7 used in ecalls
#
# s0, s1, a0, a2, a3, a4, a5 used in 16 bits opcodes
#
#----------------------------------------------------------------------
#
# define register aliases
#
# -st -nd -rd -th 

# forth top of stack, reserved, for easy
#define tos a0

# forth second on stack, not reserved
#define nos a1

# forth third on stack, not reserved
#define trd a2

# forth fourth on stack, not reserved
#define fth a3

#----------------------------------------------------------------------

# forth parameter stack pointer, reserved
#define spt s0

# forth return stack pointer, reserved
#define rpt s1

# forth instruction pointer, reserved
#define ipt s2

#----------------------------------------------------------------------

# forth start of user area variables
#define usr s3

# forth start of compiled dictionary
#define nib s4 

#----------------------------------------------------------------------

# the t0, t1, t2 are used to count forth word executions

#----------------------------------------------------------------------
# generics alias

#----------------------------------------------------------------------
# max size of dictionary 64k CELLS, depends on host machine

.equ RAM_LIMIT, 0x40000

#----------------------------------------------------------------------

# essential

.equ FALSE, 0x00000000

.equ TRUE,  0xFFFFFFFF

.equ NAN,   0x80000000

# sizeof a CELL

.equ CELL, 4    

# flag for words 

.equ IMMEDIATE, NAN

# states

.equ COMPILE, 0	# wise

.equ EXECUTE, 1

# usefull

.equ BL,  32    # word delimiter is blank space, first valid ascii

.equ QU,  34    # string delimiter is double quote, quotation mark

.equ TL, 127    # delete ascii character

# highlander, immediate flag, unique NaN

# -2147483648
.equ FLAG_IMM, 0x80000000

# +2147483647
.equ MASK_IMM, 0x7FFFFFFF

#----------------------------------------------------------------------

# order in user parameter stack

#----------------------------------------------------------------------

# void start
.equ VOID, 0 

# data stack index
.equ SPTR, 1 

# return stack index
.equ RPTR, 2 

# last link cell in heap dictionary linked list
.equ LAST, 3 

# next free cell in heap dictionary, aka dp
.equ HEAP, 4 

# last heap
.equ PIKE, 5 

# state flag
.equ STAT, 6 

# base radix for numbers, for future use
.equ BASE, 7 

#----------------------------------------------------------------------

# allow more cells for extras scratch

.equ params, 32

# user variables

.equ usr_size, params * CELL

#----------------------------------------------------------------------

# label 9999 must be exclusive :)
# ht_ header, with link and hash
# xt_ native code or list of references
#
.macro def_word label:req hash:req flag=0x0 
ht_\label:
    .word 9999b - 8
    .word (\hash | \flag)
9999:
xt_\label:
.endm

#
# gcc handles big long jumps by relaxation :)
#

# primitives resumes to next
.macro end_primitive
    j next
.endm

# compiled resumes to unnest
.macro end_compose
    j xt_exit
.endm

#----------------------------------------------------------------------

#
# Moore says the 22 deep are infinite :)
# use round-robin stacks of 32 deep, or 2^n
# the stack must start at a multiple of it as 1*10000000
# magics by -1 * 32 * CELL == NOT(32*CELL)
#

.equ stacks, 32

# data stack

.equ sp_size, stacks * CELL

# return stack

.equ rp_size, stacks * CELL

# moves backwards

.equ stack_deep, (-1 * stacks * CELL) 

# generic push into memory
.macro push rg ps 
        addi \ps, \ps, -1 * CELL
	# round robin stack
        andi \ps, \ps, stack_deep
        sw \rg, 0 (\ps)
.endm

# generic pull from memory
.macro pull rg ps
        lw \rg, 0 (\ps)
        addi \ps, \ps, +1 * CELL
	# round robin stack
        andi \ps, \ps, stack_deep
.endm

#----------------------------------------------------------------------
# Nothing here, void.
.section .data
.p2align 4, 0x0


#----------------------------------------------------------------------
# There is no spoon.
.section .bss
.option push
.option norelax 

#----------------------------------------------------------------------
# Note:
#
# for use of round robin, stacks must be bytes aligned to deep * CELL
# (deep)*(CELL) is 32 * 4, 128 which is masked by 1*101111111 
#
# user_size + sp_size + rp_size must be less than 2024 bytes
# because code uses addi (+12bits) to setup offset address

#----------------------------------------------------------------------
# common user structure and some spare space
_user:
.p2align 7, 0x0
.skip usr_size

#----------------------------------------------------------------------
# data stack grows backward, bottom
.p2align 7, 0x0
.skip sp_size
_sp0:

#----------------------------------------------------------------------
# return stack grows backward, bottom
.p2align 7, 0x0
.skip rp_size
_rp0:

.option pop

#----------------------------------------------------------------------
# now the main forth dictionary
# common align
.p2align 4, 0x0

#----------------------------------------------------------------------

# just for sake
.word FALSE

# at start of memory
h_where:
.skip RAM_LIMIT - ( h_where - _user )
# to end of  memory
h_there:

#----------------------------------------------------------------------
.section .text
.p2align 2, 0x0

#----------------------------------------------------------------------
.globl _start

#----------------------------------------------------------------------
# go ! go ! go !
main:

# do any system initializations

        call _init

#----------------------------------------------------------------------
# do what need be only once

# load constant pointer address

        la usr, _user

# load end of assembled dictionary

        la nib, assembled_last

.ifdef beats
        # beat
        li t0, 0

        # tick
        li t1, 0

        # tack
        li t2, 0
.endif


#----------------------------------------------------------------------
# do what need for setup

# hold void
        mv tos, zero
        sw tos, VOID (usr)

# hold sp0
        la tos, _sp0
        sw tos, SPTR (usr)

# hold rp0
        la tos, _rp0
        sw tos, RPTR (usr)

# last on link list of dictionary, aka latest

        la tos, compiled_last
        sw tos, LAST (usr)

# next free cell on heap, aka DP

        la tos, h_where
        sw tos, HEAP (usr)

# last free cell on heap before compile

        la tos, h_where
        sw tos, PIKE (usr)

# base radix for numbers, aka BASE, defaults to 16

        lui tos, 0x10
        sw tos, BASE (usr)

# reset data stack

        lw tos, SPTR (usr) 
        mv spt, tos

# reset return stack

        lw tos, RPTR (usr)
        mv rpt, tos

# state of forth, aka STATE

        lui tos, EXECUTE
        sw tos, STAT (usr)

        ret 

#---------------------------------------------------------------------
# A fake header at end of dictionary linked list
#
_linked:
        .word FALSE
        .word TRUE
9999:

#---------------------------------------------------------------------

.equ hash_RESET, 0x0DA3B330 #; ( RESET )
def_word "reset" hash_RESET
_start:

        call main
        
        la ipt, xt_interpret
	
	j next

#----------------------------------------------------------------------i
	
#----------------------------------------------------------------------i

# primitives
#include "assembled.S"

#---------------------------------------------------------------------
# system getc, putc, bye
#include "ecalls.S"

# system memory, file and directory words
#include "efiles.S"

#---------------------------------------------------------------------
9999:
.set assembled_last, 9999b
#---------------------------------------------------------------------

# composed words
#include "compiled.S"

#---------------------------------------------------------------------
.set compiled_last, 9999b - 8
#---------------------------------------------------------------------

_end_of_code:
#	.word 0
.end

