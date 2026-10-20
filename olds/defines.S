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

# AEFORTH version 0.8 for RISCV 32 bits 

#---------------------------------------------------------------------
# max size of dictionary 64k CELLS  
# depends on host machine

.equ RAM_LIMIT, 0x40000

#---------------------------------------------------------------------
# generics alias 

# as FORTH 1983

.equ FALSE, 0

.equ TRUE, -1

# states

.equ EXECUTE, 0

.equ COMPILE, 1

.equ POSTPONE, 2

# usefull

.equ ONE, 1

.equ TWO, 2

.equ CELL, 4

.equ BL, 32    # blank space

.equ QU, 34    # double quote

# highlander, immediate flag, unique NaN 

# -2147483648
.equ FLAG_IMM, 0x80000000

# +2147483647
.equ MASK_IMM, 0x7FFFFFFF

# Moore uses 22 deep stacks

.equ stacks, 36 

# data stack

.equ sp_size, stacks * CELL

# return stack  

.equ rp_size, stacks * CELL

#---------------------------------------------------------------------
# the order must be preserved, same in source. 

# user structure of internal Forth variables

# this version uses direct access R, S, I, U, in registers.S

# state flag
.equ STAT, 0 * CELL

# last link cell in heap dictionary linked list
.equ LAST, 1 * CELL

# next free cell in heap dictionary, aka dp
.equ HEAP, 2 * CELL

# last heap while compiling
.equ PEEK, 3 * CELL

# last free cell for heap dictionary  
.equ CEIL, 4 * CELL

# base for number conversion  
.equ BASE, 5 * CELL

# scratch temporary 

.equ HEAD, 6 * CELL

.equ TAIL, 7 * CELL

# user parameter stack: sp rp last heap state base
# internal: faux head tail beat tick tack
# temporay: temp1, temp2, temp3, temp4

.equ params, 8

# user stack

.equ user_size, params * CELL

#---------------------------------------------------------------------
# flags for compiler options

# enable echo
# .equ echoo, YES

# .equ extras, YES

# .equ primitives, YES

# .equ tools, YES

# enable clean if try compile a missed word 
# .equ missme, YES

# enable native POSTPONE (STATE=2) 
# .equ postpone, YES


