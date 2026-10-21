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
#         Minimal Indirect Thread Code
#        ip, sp, rp, tos, in dedicated registers
#        nos, trd, fth as generic registers
#        hash of words in uppercase
#        no buffer input.
#
# s0, s1, a0, a2, a3, a7 used in ecalls
#
# s0, s1, a0, a2, a3, a4, a5 used in 16 bits opcodes
#
#----------------------------------------------------------------------
#
# define register aliases
#
# -st -nd -rd -th 

# forth parameter stack pointer, reserved
#define spt s0

# forth return stack pointer, reserved
#define rpt s1

# forth instruction pointer, reserved
#define ipt a3

# forth top of stack, reserved, for easy
#define tos a4

# forth second on stack, not reserved
#define nos a5

# forth third on stack, not reserved, not for reduced opcodes
#define trd a6

# forth fourth on stack, not reserved, not for reduced opcodes
#define fth a7

# a0, a1, a2, a7 used as scratch, preserved inside ecalls

# fixed memory pointers, for offset and compares

#define usr s2

#define nib s3 

#----------------------------------------------------------------------
# generics alias

#----------------------------------------------------------------------
# max size of dictionary 64k CELLS, depends on host machine

.equ RAM_LIMIT, 0x40000

#----------------------------------------------------------------------

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

# user parameter stack: void sp0 rp0 last heap pike state base temp(8)

# void start
.equ VOID, 0 * CELL

# data stack index
.equ SPTR, 1 * CELL

# return stack index
.equ RPTR, 2 * CELL

# last link cell in heap dictionary linked list
.equ LAST, 3 * CELL

# next free cell in heap dictionary, aka dp
.equ HEAP, 4 * CELL

# last heap
.equ PIKE, 5 * CELL

# state flag
.equ STAT, 6 * CELL

# base radix for numbers, for future use
.equ BASE, 7 * CELL

# allow some 8 cells for extras scratch

.equ params, 16

# user variables

.equ usr_size, params * CELL

# Moore uses 22 deep stacks, aeForth uses 32 in round-robin

.equ stacks, 32

# data stack

.equ sp_size, stacks * CELL

# return stack

.equ rp_size, stacks * CELL

#----------------------------------------------------------------------
# essential
#
.equ FALSE, 0x00000000
.equ TRUE,  0xFFFFFFFF
.equ NAN,   0x80000000

.equ IMMEDIATE, NAN

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

# gcc handles big long jumps by relaxation :)
#
.macro end_word
    j next
.endm

#----------------------------------------------------------------------

#
# Moore says the 22 deep are infinite :)
# use round-robin stacks of 32 deep, or 2^n
# magics by -1 * 32 * CELL == NOT(32*CELL)
# the stack must start at a multiple of it as 1*10000000, how ?
#
.equ stack_deep, (-1 * stacks * CELL) 

# generic push into memory
.macro push rg ps 
         addi \ps, \ps, -1 * CELL
        andi \ps, \ps, stack_deep
        sw \rg, 0 (\ps)
.endm

# generic pull from memory
.macro pull rg ps
        lw \rg, 0 (\ps)
         addi \ps, \ps, +1 * CELL
        andi \ps, \ps, stack_deep
.endm

#----------------------------------------------------------------------
# Nothing here, void.
.section .data
.p2align 4, 0x0

# There is no spoon.

#----------------------------------------------------------------------
# but always in RAM :)
.section .bss

# common align
.p2align 4, 0x0

# common user structure and dictionary
_user:
.skip usr_size

# for use of round robin, stacks must be 128 bytes align,(deep)*(CELL)

.option push
.option norelax 

# data stack grows backward, bottom
.p2align 7, 0x0
.skip sp_size
_sp0:

# return stack grows backward, bottom
.p2align 7, 0x0
.skip rp_size
_rp0:

.option pop

# common align
.p2align 4, 0x0

#----------------------------------------------------------------------
# NOTE:
# user_size + sp_size + rp_size must be less than 2024 bytes
# because code uses addi (+12bits) to setup offset address
#----------------------------------------------------------------------

# user dictionary
.word 0x0

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

_start:

#----------------------------------------------------------------------
# go ! go ! go !
main:

# do any system initializations

        call _init

#----------------------------------------------------------------------
# do what need be only once

cold:
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

warm:
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

#---------------------------------------------------------------------
abort:
# reset data stack

        lw tos, SPTR (usr) 
        mv spt, tos

#---------------------------------------------------------------------
quit:
# reset return stack

        lw tos, RPTR (usr)
        mv rpt, tos

        ret 

#---------------------------------------------------------------------
# A fake header start of dictionary linked list
#
        .word FALSE
        .word TRUE
9999:

#include "assembled.S"

#---------------------------------------------------------------------
9999:
.set assembled_last, 9999b
#---------------------------------------------------------------------

#include "compiled.S"

#---------------------------------------------------------------------
.set compiled_last, 9999b - 8
#---------------------------------------------------------------------

.end

.ifdef XXX
#---------------------------------------------------------------------
.equ hash_RESET, 0x0DA3B330 #; ( RESET )
def_word "reset" hash_RESET

        call main
        
# state of forth, aka STATE

        lui tos, EXECUTE
        sw tos, STAT (usr)

        # zzzz must be the interpreter zzzz

        la ipt, compiled_last

        j next

#----------------------------------------------------------------------
.endif
