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

from https://github.com/agsb/ff/blob/master/ff-arm.s

https://github.com/scotws/RISC-V-tests/blob/master/docs/riscv_linux_system_calls.md

** the standard modern POSIX layout (asm-generic) **

tos is a0
syscal id in a7, 
result in a0, and a1
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
# OPEN / CREATE FILE using openat (Syscall 56)
# ( cstr flags name mode -- fd )
fs_open:				
        # mv a0, tos              # -100, for AT_FDCWD: look in current working directory
        lw a1, 0 (spt)          # Address of filename string
        lw a2, 4 (spt) 		# 64, for O_CREAT 
        lw a3, 8 (spt)		# 384, for 0600 Mode: Permissions (rw-------)
        li a7, 56               # openat syscall number
        ecall                   # Call Linux Kernel -> returns File Descriptor in a0
	ret
        
# CLOSE FILE using close (Syscall 57)
# ( fd -- n )
fs_close:			
        # mv a0, tos              # Pass File Descriptor to close
        li a7, 57               # close syscall number
        ecall                   # Call Linux Kernel
	ret

# SEEK FROM FILE (Syscall 62)
# Example: Seek to 1024 bytes from the beginning of the file (SEEK_SET)
# ( pos fd -- n )
fs_seek:
        # mv a0, tos        	# fd file descriptor)
        lw a1, 0 (spt)    	# offset = 1024 bytes
        lw a2, 4 (spt)    	# whence = 0 (SEEK_SET)
        li a7, 62         	# Syscall number for lseek
        ecall            	# Invoke Linux Kernel 
	ret

# READ FROM FILE using read (Syscall 63)
# ( u a fd -- n )
fs_read:				
        # mv a0, tos          	# fd file descriptor
        lw a1, 0 (spt)      	# Pointer to the destination buffer
        lw a2, 4 (spt)      	# Maximum number of bytes to read
        li a7, 63           	# Syscall ID: sys_read
        ecall               	# Call the Linux kernel
	ret

# WRITE TO FILE using write (Syscall 64)
# ( n a fd -- n2 )
fs_write:		
        # mv a0, tos              # Pass saved File Descriptor
        lw a1, 0 (spt)          # Address of text buffer
        lw a2, 4 (spt)          # Buffer length in bytes
        li a7, 64               # write syscall number
        ecall                   # Call Linux Kernel -> returns bytes written in a0
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

