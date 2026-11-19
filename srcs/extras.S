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

/*

__WORDS :) IN PROGRESS__

** STILL NOT FOR USE **

from https://github.com/agsb/ff/blob/master/ff-arm.s

https://github.com/scotws/RISC-V-tests/blob/master/docs/riscv_linux_system_calls.md

** the standard modern POSIX layout (asm-generic) **

tos is a0
syscal id in a7, 
result in a0, a1
all names must end with zero.

*/

#----------------------------------------------------------------------

# MAKE DIR (Syscall 34)
# ( flags name mode -- f )
fs_mkdir:				
        # mv a0, tos              # -100, for AT_FDCWD: look in current working directory
        lw a1, 0 (spt)          # Address of name string
        lw a2, 4 (spt) 		# 493, for 0755 mode
        li a7, 34               # syscall number
        ecall                   # -> returns File Descriptor in a0
        ret
        
# REMOVE DIR (Syscall 35)
# ( flags name mode -- f )
fs_rmdir:				
        # mv a0, tos              # -100, for AT_FDCWD: look in current working directory
        lw a1, 0 (spt)          # Address of name string
        lw a2, 4 (spt) 		# 512, for AT_REMOVEDIR 0x200
        li a7, 35               # syscall number
        ecall                   # -> returns File Descriptor in a0
        ret
        
# GET DIR (Syscall 17)
# ( n name -- f )
fs_cwdir:				
        # mv a0, tos              # buffer
        lw a1, 0 (spt)          # buffer size
        li a7, 17               # syscall number
        ecall                   # -> returns File Descriptor in a0
        ret
        
# CHANGE DIR (Syscall 49)
# ( flags name mode -- f )
fs_chdir:				
        # mv a0, tos              # buffer
        li a7, 49               # syscall number
        ecall                   # Call Linux Kernel -> returns File Descriptor in a0
	ret

# LIST DIR (Syscall 61)
# ( size buffer fd -- f )
fs_lsdir:				
        # mv a0, tos              # file descritor
        lw a1, 0 (spt)          # buffer
        lw a2, 4 (spt) 		# buffer size
        li a7, 61               # syscall number
        ecall                   # Call Linux Kernel -> returns File Descriptor in a0
	ret
        
#----------------------------------------------------------------------

# CREATE FILE using unlinkat (Syscall 35)
# ( flags name mode -- fd )
fs_create:				
        # mv a0, tos              # -100, for AT_FDCWD: look in current working directory
        lw a1, 0 (spt)          # Address of filename string
        lw a2, 4 (spt) 		# 578, for O_CREAT (64) | O _RDWR (2) | O_TRUNC (512)
        lw a3, 8 (spt)		# 420, for 0644 Mode: Permissions (rw-------)
        li a7, 56               # openat syscall number
        ecall                   # Call Linux Kernel -> returns File Descriptor in a0
	ret

# DELETE FILE using unlinkat (Syscall 35)
# ( flags name mode -- fd )
fs_erase:				
        # mv a0, tos              # -100, for AT_FDCWD: look in current working directory
        lw a1, 0 (spt)          # Address of filename string
        lw a2, 4 (spt) 		# 0, for delete a common file 
        li a7, 35               # unlinkat syscall number
        ecall                   # Call Linux Kernel -> returns File Descriptor in a0
	ret

# FCNTL FILE (Syscall 25)
# Example: Seek to 1024 bytes from the beginning of the file (SEEK_SET)
# ( pos fd -- n )
fs_fcntl:
        # mv a0, tos        	# fd file descriptor)
        lw a1, 0 (spt)    	# operation
        lw a2, 4 (spt)    	# arguments
        li a7, 25         	# Syscall number 
        ecall            	# Invoke Linux Kernel 
	ret

#----------------------------------------------------------------------

# ( arg cmd fd -- w ) #; ( FD_ERASE )
.equ hash_FDERASE, 0x405941D8 #; ( FD_ERASE ) 
def_word "fileerase" hash_FDERASE
        j next

# ( cname n mode fd -- w ) #; ( FD_CREATE )
.equ hash_FDCREATE, 0x3D82507C #; ( FD_CREATE ) 
def_word "filecreate" hash_FDCREATE
        j next

# ( arg cmd fd -- w ) #; ( FD_CNTL )
.equ hash_FDCNTL, 0x1935E84D #; ( FD_CNTL ) 
def_word "filecntl" hash_FDCNTL
        j next

#---------------------------------------------------------------------
# memory extras 

#----------------------------------------------------------------------
.equ SYS_MMAP, 222
.equ SYS_UMMAP, 215
.equ SYS_MREMAP, 216

# Constantes do Linux
.equ PROT_READ, 0x1
.equ PROT_WRITE, 0x2
.equ MAP_PRIVATE, 0x02
.equ MAP_ANONYMOUS, 0x20
.equ MREMAP_MAYMOVE, 0x1

# need more info for use
alloc_memory_stub:
mmap:                           
        # mv a0, tos              # a0 = addr: 0 (Let the kernel choose the virtual address destination)
        li a1, 4096             # a1 = length: 4096 bytes (1 page)
        li a2, 3                # a2 = prot: PROT_READ (1) | PROT_WRITE (2) = 3
        li a3, 34               # a3 = flags: MAP_PRIVATE (2) | MAP_ANONYMOUS (32) = 34
        li a4, -1               # a4 = fd: -1 (Required for anonymous memory allocations)
        li a5, 0                # a5 = offset: 0
        li a7, 222              # a7 = syscall number for sys_mmap
        ecall                   #  Returns allocated address pointer or -1 in a0.
	ret

realloc_memory_stub:
mremap:
        # mv a0, tos                         # old_address = endereço que estava em s1
        li a1, 4096                        # old_size = 4096 bytes
        li a2, 8192                        # new_size = 8192 bytes (2 páginas)
        li a3, MREMAP_MAYMOVE              # flags = Permite mover o bloco se necessário
        li a7, SYS_MREMAP                  # Carrega código da syscall mremap (216)
        ecall                              # Executa a chamada do sistema

# need more info for use
free_memory_stub:
unmap:
        # mv a0, tos 		# valid memory pointer address returned by a previous mmap
        li a1, 4096             # a1 = length: must match the exact allocation size (4096 bytes)
        li a7, 215              # a7 = syscall number for sys_munmap
        ecall                   # Returns 0 on success, or -1 in a0
	ret
				        
# Check return value in a0 (0 means success)
# Exit or continue execution from here...

#----------------------------------------------------------------------

# for sake all memomy allocations are in pages of 4k bytes !

.equ hash_ALLOCATE, 0x1D4EF358 #; ( ALLOCATE ) 
.equ hash_FREE, 0x7C7E42B1 #; ( FREE ) 
.equ hash_RESIZE, 0x421A29B7 #; ( RESIZE ) 

def_word "allocate" hash_ALLOCATE
	j next

def_word "free" hash_FREE
	j next

def_word "resize" hash_RESIZE
	j next

#----------------------------------------------------------------------

/*

\ Forth 2012 file set

11.6.1.0080 (
11.6.1.0765 BIN
11.6.1.0900 CLOSE-FILE
11.6.1.1010 CREATE-FILE
11.6.1.1190 DELETE-FILE
11.6.1.1520 FILE-POSITION
11.6.1.1522 FILE-SIZE
11.6.1.1717 INCLUDE-FILE
11.6.1.1718 INCLUDED
11.6.1.1970 OPEN-FILE
11.6.1.2054 R/O
11.6.1.2056 R/W
11.6.1.2080 READ-FILE
11.6.1.2090 READ-LINE
11.6.1.2142 REPOSITION-FILE
11.6.1.2147 RESIZE-FILE
11.6.1.2165 S"
11.6.1.2218 SOURCE-ID
11.6.1.2425 W/O
11.6.1.2480 WRITE-FILE
11.6.1.2485 WRITE-LINE

11.6.2.1524 FILE-STATUS
11.6.2.1560 FLUSH-FILE
11.6.2.1714 INCLUDE
11.6.2.2125 REFILL
11.6.2.2130 RENAME-FILE
11.6.2.2144.10 REQUIRE
11.6.2.2144.50 REQUIRED
11.6.2.2266 S\"

Note: Forth 1994 ANSI have same words

*/


