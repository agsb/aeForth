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
#   	praise 1/9967
#
# Using 
#        Minimal Indirect Thread Code
#        ip, sp, rp, tos, in dedicated registers
#        usr, nib in dedicated register
#        nos, trd, fth as generic registers
#        hash of words in uppercase
#        no buffer input.
#
#---------------------------------------------------------------------
#
#	about hash:
#
# 	loads a valid sequence of ascii from input stream, 
# 	does a crude digest a word, 
# 	does not handle EOF or errors, wipes all controls.
#	any word must be between spaces
#
#----------------------------------------------------------------------
#
# RISCV ABI reserves a0, a1, a2, a3, a4, a5, a6, a7 for ecalls
#
# a0, a1, a2, a3, a7 used in getc putc exit init ecalls
#
# s0, s1, a0, a1, a2, a3, a4, a5 used in 16 bits opcodes
#
# a6 is never used in ecalls :)
#
# NOTE: 
# How ecall ABI Works:
#
# FreeRTOS-MPU RISC-V, t0 is the call number, a6 is never used.
# Linux systems, a7 is the call number, a6 is never used.
#
# Using Linux ABI for easy
#
#----------------------------------------------------------------------
#
# define register aliases  -st -nd -rd -th 
#
# abusing of "callee" registers :)

#----------------------------------------------------------------------
# those are used in _init _getc _putc _exit ecalls
# What are the ordinal numbers 1st, 2nd, 3rd, and 4th?

# forth parameter stack pointer, reserved
#define spt s0

# forth return stack pointer, reserved
#define rpt s1

# forth top of stack, reserved, for easy
#define tos a0

# forth second on stack, not reserved
#define nos a1

# forth third on stack, not reserved
#define trd a2

# forth fourth on stack, not reserved
#define fth a3

# forth user array pointer, reserved
#define usr a4

# forth instruction pointer, reserved
#define ipt a5

# never overwrited in ecalls
#define nth a6

# always overwrited in ecalls
#define tmp a7

# forth start of compiled dictionary, reserved
#define nib s2

# one deep save/load ra
#define rax s3

#----------------------------------------------------------------------
# used to count forth word executions

# s4, s5, s6, s7, s8 free

#define cn0 s9

#define cn1 s10

#define cn2 s11

#----------------------------------------------------------------------

#----------------------------------------------------------------------
# generics alias

#----------------------------------------------------------------------

# essential

.equ FALSE, 0x00000000

.equ TRUE,  0xFFFFFFFF

.equ NAN,   0x80000000

# sizeof a CELL

.equ CELL, 4    

# flag for words 

.equ IMMEDIATE, NAN

# not wise, but standart states

.equ COMPILE, TRUE  

.equ EXECUTE, FALSE

# usefull

.equ BL,  32    # word delimiter is blank space, first valid ascii

.equ QU,  34    # string delimiter is double quote, quotation mark

.equ DEL, 127   # delete ascii character

# highlander, immediate flag, unique NaN

# -2147483648
.equ FLAG_IMM, 0x80000000

# +2147483647
.equ MASK_IMM, 0x7FFFFFFF

#----------------------------------------------------------------------

# order in user parameter stack

#----------------------------------------------------------------------

# void start (user array address)
.equ VOID, 0 

# data stack 0 index
.equ SPTR, 1 

# return stack 0 index
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

# allow more (32 - 8) 24 cells for extras 

.equ params, 32

# user variables array

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
.macro end_compiled
    j xt_exit
.endm

#----------------------------------------------------------------------

#
# Moore says the 22 deep are infinite :)
# aeForth use round-robin stacks of 32 deep, (or chose a 2^N)
# the stack must start at a multiple of it 
# and magics by == NOT(DEEP*CELL)
# for 32 * 4 is 128 as 0xFFFFFF7F
#

# moves backwards

.equ stacks, 32

.equ stack_deep, (0xFFFFFF7F) 

# data stack

.equ sp_size, stacks * CELL

# return stack

.equ rp_size, stacks * CELL

#----------------------------------------------------------------------

.macro spushs
	addi sp, sp, -32
	sw tos, 0 (sp) 
	sw nos, 4 (sp) 
	sw trd, 8 (sp) 
	sw fth, 12 (sp) 
	sw nth, 16 (sp) 
	sw tmp, 20 (sp) 
.endm

.macro spulls
	lw tos, 0  (sp) 
	lw nos, 4  (sp) 
	lw trd, 8  (sp) 
	lw fth, 12 (sp) 
	lw nth, 16 (sp) 
	lw tmp, 20 (sp) 
	addi sp, sp, +32
.endm

.macro spush reg
	addi sp, sp, -4
	sw \reg, 0 (sp)
.endm

.macro spull reg
	lw \reg, 0 (sp)
	addi sp, sp, +4
.endm

.macro putchr
	spushs	
        call _putc
	spulls
.endm

.macro putch cc
	spushs
        li tos, \cc
        call _putc
	spulls
.endm

#----------------------------------------------------------------------
# Nothing here, void.

.section .rodata
.p2align 4, 0x0

the_ok:
.ascii " OK\n"

the_miss:
 .asciz " undefined word\n"

the_st:
.ascii "aeForth 0.63 2026/11\n"

#include "throwmsg.S"

#----------------------------------------------------------------------
# Nothing here, void.

.section .data
.p2align 4, 0x0

#----------------------------------------------------------------------
# There is no spoon.

.section .bss
.p2align 4, 0x0

#----------------------------------------------------------------------
# Note:
#
# statics + user_size + sp_size + rp_size must be less than 2024 bytes
# because code uses addi (+12bits) to setup offset address

# for use of round robin, stacks must be bytes aligned to deep * CELL
# (deep)*(CELL) is 32 * 4, 128 which is masked by 1*101111111 
#
.option push
.option norelax 

#----------------------------------------------------------------------
# common user structure and some spare space, 32 x CELL, 128 bytes
_us0:
.p2align 7, 0x0
.skip usr_size

#----------------------------------------------------------------------
# data stack grows backward, bottom, 32 x CELL, 128 bytes
.p2align 7, 0x0
.skip sp_size
_sp0:

#----------------------------------------------------------------------
# return stack grows backward, bottom, 32 x CELL, 128 bytes
.p2align 7, 0x0
.skip rp_size
_rp0:

.option pop

#----------------------------------------------------------------------
# now the main forth dictionary

#----------------------------------------------------------------------
# use for free allocation, static messages, etc 

_char: # a tiny buffer of 4 bytes for getc putc use
.word FALSE
        
#----------------------------------------------------------------------
# Note:
# max size of dictionary 64k CELLS, depends on host machine
# on ESP32 is 4 MMU pages of 64k bytes
.equ RAM_LIMIT, 0x40000

# at start of memory
h_where:
.skip RAM_LIMIT - ( h_where - _us0 )
# to end of memory
h_there:

#----------------------------------------------------------------------
.section .text
.p2align 2, 0x0

#----------------------------------------------------------------------
.globl _start

_start:

#----------------------------------------------------------------------
# adapted from milliForth-RISCV

# go ! go ! go !
main:

# do any system initializations

        call _init

#----------------------------------------------------------------------
# do what need be only once

setup:

# load constant pointer address of user array

        la usr, _us0

# load end of assembled dictionary

        la nib, h_last

.ifdef beats
        # beat, count next executions
        li cn0, 0

        # tick, count primitive executions
        li cn1, 0

        # tack, count compiled executions
        li cn2, 0
.endif

# using tos just could be any, no RVC 

# hold us0
        la tos, _us0
        sw tos, VOID * CELL (usr) 

# hold sp0
        la tos, _sp0
        sw tos, SPTR * CELL (usr) 

# hold rp0
        la tos, _rp0
        sw tos, RPTR * CELL (usr) 

# last on link list of dictionary, aka latest in .text
        la tos, h_last
        sw tos, LAST * CELL (usr) 

# next free cell on heap, aka DP, aka heap in .bss
        la tos, h_where
        sw tos, HEAP * CELL (usr) 

# last free cell on heap before compile
        la tos, h_where
        sw tos, PIKE * CELL (usr) 

# base radix for numbers, aka BASE, defaults to 16
        li tos, 0x10
        sw tos, BASE * CELL (usr) 

abort:
# reset data stack
        lw tos, SPTR * CELL (usr)  
        mv spt, tos

quit:
# reset return stack
        lw tos, RPTR * CELL (usr) 
        mv rpt, tos

# clean TOS

        mv tos, zero

mode:
# state of forth, aka STATE

        # EXECUTE is 0
        sw tos, STAT * CELL (usr) 

#----------------------------------------------------------------------

#----------------------------------------------------------------------
# Outer Loop Interpreter
# 
# run baby ! run baby !
warp:
        mv t0, tos

	putch '{'
 
100:
        call hash

        call seek

# missed a word ?
miss:

	bne tos, zero, eval

	putch '?'

	mv tos, fth

	call tohex

	la tos, the_miss

	call _puts

	# check if compiling and move PIKE to HEAP
        lw nos, STAT * CELL (usr)

        # EXECUTE is FALSE
        beqz nos, 200
        lw nos, PIKE * CELL (usr)
        sw nos, HEAP * CELL (usr)
200:
	j 100b
	
#---------------------------------------------------------------------
# Eval What Do ( xt -- )
eval:
        # what to do ?

        # executing ? if state == 0

        lw trd, STAT * CELL (usr)

	li tmp, EXECUTE

        beq trd, tmp, execute

        # immediate ? if flag in tmp

        lw tmp, -1 * CELL (tos)
	
	srl tmp, tmp, 31

	bne tmp, zero, execute

# must uses for argument

# compiling
compile:
	
        call comma

	mv tos, t0

        j warp

# executing
execute:

        # could be a move instead of la  
        la ipt, _warp

	mv nos, tos

	mv tos, t0

        j pick

_warp:
        .word warp

#---------------------------------------------------------------------
# Hash a Word from input stream ( -- hash )
# hash function classic djb2 hash algorithm with XOR
# magic djb2 numbers
.equ DJB2, 5381
.equ SFHT, 5
hash:
        # saves

        spush ra

        # prepare space

        li nth, BL

        # default djb2 hash

        lui fth, %hi(DJB2)

        addi fth, fth, %lo(DJB2)

        # skip spaces and controls, not handle EOF or error
100:
	# uses tos, nos, trd, tmp
        call _getc

        ble tos, nth, 100b

        # djb2 hash function
200:
        mv nos, fth

        slli fth, fth, SFHT

        add fth, fth, nos

        xor fth, fth, tos

        # scan spaces and controls, not handle EOF or error
300:
	# uses tos, nos, trd, tmp
        call _getc
	
        li nth, BL

	# less than space ?
        blt tos, nth, 300b

	# more than space ?
        blt nth, tos, 200b

        # clear hash high bit
400:
        slli fth, fth, 1

        srli fth, fth, 1

	# return hash
	mv tos, fth

        spull ra

        ret

#----------------------------------------------------------------------
# Seek a Hash ( hash -- xt | 0x0 )
seek:
        # saves 

        spush ra

        # prepare
        
	mv fth, tos

        lw tos, LAST * CELL (usr)

 100:
        # verify end of dictionary

        beqz tos, 200

        # backward linked list

        mv nos, tos

        # keep next link

        lw tos, 0 (nos)

        # take the hash

        addi nos, nos, CELL

        lw trd, 0 (nos)

        # mask the FLAG  

        slli trd, trd, 1

        srli trd, trd, 1

        # compare trd == hash

        bne trd, fth, 100b
        
        # found ! point to code or to list, aka xt

        addi tos, nos, CELL

200:
        # loads

        spull ra

        ret

#---------------------------------------------------------------------
# Comma ( xt -- xt )
# input: tos with the xt
# output: tos with the xt
comma:
        lw nos, HEAP * CELL (usr)

        sw tos, 0 (nos)

        addi nos, nos, CELL

        sw nos, HEAP * CELL (usr)

        ret
        
#---------------------------------------------------------------------

#======================================================================
# 
# this is the forth heart beat, Minimum Indirect Thread Code 
# 
# nib is the address after "last native machine code" primitive word 
#
# beats counts executions 
#
# using round robin return stack, with 32 * 4 bytes
#
#---------------------------------------------------------------------- 
# aka EXIT
unnest: 

	putch 'U'
	
        lw ipt, 0 (rpt)
        addi rpt, rpt, CELL
	andi rpt, rpt, stack_deep 
        j next 

#---------------------------------------------------------------------- 
# aka DOCOL 
nest: 
.ifdef beats
        addi cn2, cn2, 1
.endif

	putch 'N' 

        addi rpt, rpt, -1*CELL
	andi rpt, rpt, stack_deep 
	sw ipt, 0 (rpt)
move: 
        mv ipt, nos 
 
#---------------------------------------------------------------------- 
# aka NEXT 
next: 
.ifdef beats
        addi cn0, cn0, 1
.endif

	putch 'X' 

        # no round-robin limit
        lw nos, 0 (ipt)
        addi ipt, ipt, CELL
	
#---------------------------------------------------------------------- 
# this is the tipping point, above nib only compiled words 
# when (nos > nib) goto nest
pick: 
        bge nos, nib, nest 
 
#---------------------------------------------------------------------- 
# then jump to a primitive word
jump: 
.ifdef beats
        addi cn1, cn1, 1
.endif
        jalr ra, 0 (nos) 
 
#======================================================================
#---------------------------------------------------------------------
# A fake header at end of dictionary linked list
#
_linked:
        .word FALSE
        .word TRUE

9999:

#----------------------------------------------------------------------i
# only native machine code, no compiled words

# primitives
#include "assembled.S"

#---------------------------------------------------------------------
# minimal system I/O init, getc, putc, bye
#include "ecalls.S"

# minimal system file open, close, read, write, seek
#include "efiles.S"

#---------------------------------------------------------------------

.set h_last, 9999b - 8

#---------------------------------------------------------------------
9999:
        .word FALSE
        .word TRUE

.set h_heap, 9999b
#---------------------------------------------------------------------

_end_of_code:
.end

