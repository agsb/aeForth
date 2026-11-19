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

# OPEN / CREATE FILE using openat (Syscall 56)
# ( cstr flags name mode -- fd )
fs_open:				
        lw a0,  0 (spt) # -100, for AT_FDCWD: look in current working directory
        lw a1,  4 (spt) # Address of filename string
        lw a2,  8 (spt)	# 66, for O_CREAT (64) | O_RDWR (2) or 0, for must exist and read_only 
        lw a3, 12 (spt)	# 420, for 0644 Mode: Permissions (rw-------)
        li a7, 56       # openat syscall number
        ecall           # Call Linux Kernel -> returns File Descriptor in a0
	ret

# CLOSE FILE using close (Syscall 57)
# ( fd -- n )
fs_close:			
        lw a0, 0 (spt)  # Pass File Descriptor to close
        li a7, 57       # close syscall number
        ecall           # Call Linux Kernel
	ret

# SEEK FROM FILE (Syscall 62)
# Example: Seek to 1024 bytes from the beginning of the file (SEEK_SET)
# seek_set (0) = start, seek_cur (1) = actual, seek_end (2) = end
# ( pos fd -- n )
fs_seek:
        lw a0, 0 (spt)  # fd file descriptor)
        lw a1, 4 (spt)  # offset = 1024 bytes
        lw a2, 8 (spt)  # whence = 0 (SEEK_SET)
        li a7, 62       # Syscall number for lseek
        ecall           # Invoke Linux Kernel 
	ret

# READ FROM FILE using read (Syscall 63)
# ( u a fd -- n )
fs_read:				
        lw a0, 0 (spt)  # fd file descriptor
        lw a1, 4 (spt)  # Pointer to the destination buffer
        lw a2, 8 (spt)  # Maximum number of bytes to read
        li a7, 63       # Syscall ID: sys_read
        ecall           # Call the Linux kernel
	ret

# WRITE TO FILE using write (Syscall 64)
# ( n a fd -- n2 )
fs_write:		
        lw a0, 0 (spt)  # Pass saved File Descriptor
        lw a1, 4 (spt)  # Address of text buffer
        lw a2, 8 (spt)  # Buffer length in bytes
        li a7, 64       # write syscall number
        ecall           # Call Linux Kernel -> returns bytes written in a0
	ret

#----------------------------------------------------------------------

# those words do not clean the stack, return results in tos (a0)
# minimal file support for emulate a tape/disk inside a file :)  


# ( cname n mode fd -- fd ) #; ( FD_OPEN ), open or create
.equ hash_FDOPEN, 0x19337D2C #; ( FD_OPEN ) 
def_word "fileopen" hash_FDOPEN
	push tos spt
	call fs_open
        j next

# ( fd -- w ) #; ( FD_CLOSE )
.equ hash_FDCLOSE, 0x3FF2400E #; ( FD_CLOSE ) 
def_word "fileclose" hash_FDCLOSE
	push tos spt
	call fs_close
        j next

# ( size buffer fd -- w ) #; ( FD_READ )
.equ hash_FDREAD, 0x192ED68A #; ( FD_READ ) 
def_word "fileread" hash_FDREAD
	push tos spt
	call fs_read
        j next

# ( size buffer fd -- w ) #; ( FD_WRITE )
.equ hash_FDWRITE, 0x3F24DDE5 #; ( FD_WRITE ) 
def_word "filewrite" hash_FDWRITE
	push tos spt
	call fs_write
        j next

# ( whence offset fd -- w ) #; ( FD_SEEK )
# whence=0, offset=0, results in zero position at file 
# whence=1, offset=0, results in actual position at file 
# whence=2, offset=0, results in size of file 
.equ hash_FDSEEK, 0x192D39A0 #; ( FD_SEEK ) 
def_word "fileseek" hash_FDSEEK
	push tos spt
	call fs_seek
        j next

#----------------------------------------------------------------------
