/*
#---------------------------------------------------------------------
 
  Copyright 2025 Alvaro Gomes Sobral Barcellos <@agsb>
 
  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 2 of the License, or
  (at your option) any later version.
 
  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
  GNU General Public License for more details.
 
  You should have received a copy of the GNU General Public License
  along with this program. If not, see <http://www.gnu.org/licenses/>.

#----------------------------------------------------------------------
*/

#---------------------------------------------------------------------
# linux ecall stuff, 29/07/2025, vide:
# https://github.com/riscv-software-src/riscv-pk/blob/master/pk/syscall.h
# https://gpages.juszkiewicz.com.pl/syscalls-table/syscalls.html

.equ _ZERO,      0
.equ _ONE,       1

.equ _STDIN,     0
.equ _STDOUT,    1

.equ _GETC,     63
.equ _PUTC,     64
.equ _EXIT,     93
.equ _TICK,	153

.equ _SBRK,     45
.equ _FCNT,     55
.equ _MMAP,     192

#---------------------------------------------------------------------
#
# Note: system ecalls do not use ra 
#

.macro esave
	addi sp, sp, -16
	sw a0, 0(sp)
	sw a1, 4(sp)
	sw a2, 8(sp)
	sw a7, 12(sp)
.endm

.macro eload
	lw a0, 0(sp)
	lw a1, 4(sp)
	lw a2, 8(sp)
	lw a7, 12(sp)
	addi sp, sp, 16
.endm

#---------------------------------------------------------------------

# Note: _char is elsewhere

#---------------------------------------------------------------------
.section .text

# load system call for exit
_exit:
	# TOS is a0
        # li a0, _ZERO
        li a7, _EXIT
        ecall

# load system call for init
_init:
	# doing nothing by now        
        ret

# linux ecall times ticks
_tick:
	mv a0, zero
	li a7, _TICK
	ecall

	mv tos, a0

	ret

# linux ecall for getc
_getc:
        la a1, _char

        li a0, _STDIN
        li a2, _ONE
        li a7, _GETC

        ecall

        lb tos, 0 (a1)

        # EOF?
        # beq a0, zero, _exit

.equ echoo, 1

.ifndef echoo

        ret

.endif

# linux ecall for putc
_putc:
        la a1, _char

        sb tos, 0 (a1)

        li a0, _STDOUT
        li a2, _ONE
        li a7, _PUTC

        ecall

	mv tos, a0

        ret

#---------------------------------------------------------------------

