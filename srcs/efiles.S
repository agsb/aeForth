/*

__WORD IN PROGRESS__


from https://github.com/agsb/ff/blob/master/ff-arm.s

ARM Register usage:

  TOS: r0
  SP:  r13
  RP:  r14
  AP:  r12
  W:   r11
 
	scratch r1, r2 

  ldr r0, [r1], #4

	r0 = [r1]
	r1 = r1 + #4

** the standard modern POSIX layout (asm-generic) **

Syscall Name	RISC-V Syscall Number (a7), Key Arguments (a0, a1, a2, a3)
openat	56	a0 = Dir FD (-100 for current dir), a1 = Path string, a2 = Flags, a3 = Mode
read	63	a0 = File Descriptor, a1 = Buffer address, a2 = Count
write	64	a0 = File Descriptor, a1 = Buffer address, a2 = Count
close	57	a0 = File Descriptor
exit	93	a0 = Status code

syscal id in a7, result in a0

** maybe use a0 as tos in aeforth, or what return the value **
	
EXAMPLE:

_start:
# OPEN / CREATE FILE using openat (Syscall 56)
# ( cstr flags mode -- fd )
fsopen:				
    li a0, -100                 # AT_FDCWD: look in current working directory
    la a1, filename             # Address of filename string
    li a2, 0101                 # Flags: O_WRONLY (01) | O_CREAT (0100) octal
    li a3, 0644                 # Mode: Permissions (rw-r--r--)
    addi sp, sp, 2 * CELL
    li a7, 56                   # openat syscall number
    ecall                       # Call Linux Kernel -> returns File Descriptor in a0
    
# CLOSE FILE using close (Syscall 57)
# ( fd -- n )
fsclose:			
    mv a0, tos                  # Pass File Descriptor to close
    li a7, 57                   # close syscall number
    ecall                       # Call Linux Kernel

# WRITE TO FILE using write (Syscall 64)
# ( a n fd -- n2 )
fswrite:		
    mv a0, tos                  # Pass saved File Descriptor
    la a1, 0 (spt)              # Address of text buffer
    li a2, 4 (spt)              # Buffer length in bytes
    addi sp, sp, 2 * CELL
    li a7, 64                   # write syscall number
    ecall                       # Call Linux Kernel -> returns bytes written in a0

# READ FROM FILE using read (Syscall 63)
# ( a n fd -- n2 )
fsread:				
    mv a0, tos          # fd file descriptor
    la a1, 0 (spt)      # Pointer to the destination buffer
    li a2, 4 (spt)      # Maximum number of bytes to read
    addi sp, sp, 2 * CELL
    li a7, 63           # Syscall ID: sys_read
    ecall               # Call the Linux kernel

# SEEK FROM FILE (Syscall 62)
# Example: Seek to 1024 bytes from the beginning of the file (SEEK_SET)
# ( pos fd -- n )
fsseek:
    li a0, tos        # fd file descriptor)
    li a1, 0 (spt)    # offset = 1024 bytes
    li a2, 4 (spt)    # whence = 0 (SEEK_SET)
    addi sp, sp, 2 * CELL
    li a7, 62         # Syscall number for lseek
    ecall             # Invoke Linux Kernel 

# CHANGE DIRECTORY using (Syscall 49)
fschdir:
    la a0, target_dir
    li a7, 49
    ecall

# GET ACTUAL DIRECTORY using (Syscall 17)
fsgetdir:
    la a0, buffer
    la a1, len
    addi sp, sp, 2 * CELL
    li a7, 17
    ecall

# ( a1 -- a2 )
mmap:                           
  li a7, #90	# old_mmap
  ecall
  ret

# Check return value in a0 (0 means success)
# Exit or continue execution from here...

*/

  li a7, 56	# sys_open
  mv a2, tos	# mode 
  lw a1, 0(sp)	# flags
  lw a0, 4(sp)	# name
  addi sp, sp, 2 * CELL
  ecall
  ret

  li a7, #6	# sys_close
  ecall
  ret

  li a7, #3	# sys_read
  lw a2, 0(sp)	#size
  lw a1, 4(sp)	# buff
  addi sp, sp, 2 * CELL
  ecall
  ret

  li a7, #4	# sys_write
  lw a2, 0(sp)	# size
  lw a1, 4(sp)	# buff
  addi sp, sp, 2 * CELL
  ecall
  ret

  li a7, #19	# sys_lseek
  mv a2, #0	# SEEK_SET
  lw a1, 4(sp)
  addi sp, sp, 1 * CELL
  ecall
  ret


