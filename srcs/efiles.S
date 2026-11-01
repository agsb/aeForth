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

.section .data
filename:   .asciz "output.txt"
text_to_wr: .asciz "Hello from RISC-V Linux!\n"
.equ len, . - text_to_wr         # Calculate length of the string dynamically

.section .text
.global _start

_start:
    # OPEN / CREATE FILE using openat (Syscall 56)
    li a7, 56                   # openat syscall number
    li a0, -100                 # AT_FDCWD: look in current working directory
    la a1, filename             # Address of filename string
    li a2, 0101                 # Flags: O_WRONLY (01) | O_CREAT (0100) octal
    li a3, 0644                 # Mode: Permissions (rw-r--r--)
    ecall                       # Call Linux Kernel -> returns File Descriptor in a0
    
    # CLOSE FILE using close (Syscall 57)
    li a7, 57                   # close syscall number
    mv a0, s0                   # Pass File Descriptor to close
    ecall                       # Call Linux Kernel

    # WRITE TO FILE using write (Syscall 64)
    li a7, 64                   # write syscall number
    mv a0, s0                   # Pass saved File Descriptor
    la a1, text_to_wr           # Address of text buffer
    li a2, len                  # Buffer length in bytes
    ecall                       # Call Linux Kernel -> returns bytes written in a0

    # READ FROM FILE using read (Syscall 63)
    li a7, 63           # Syscall ID: sys_read
    mv a0, s0           # Arg 1: The file descriptor we saved in s0
    la a1, buffer       # Arg 2: Pointer to the destination buffer
    li a2, len          # Arg 3: Maximum number of bytes to read
    ecall               # Call the Linux kernel

    # EXIT PROGRAM using exit (Syscall 93)
    li a7, 93                   # exit syscall number
    li a0, 0                    # Status code 0 (Success)
    ecall                       # Terminate program

    # CHANGE DIRECTORY using (Syscall 49)
    li a7, 49
    la a0, target_dir
    ecall

    # GET ACTUAL DIRECTORY using (Syscall 17)
    li a7, 17
    la a0, buffer
    la a1, len
    ecall

    # Check return value in a0 (0 means success)
    # Exit or continue execution from here...

*/

# ( cstr flags mode -- fd )
fsopen:				
  mv a2, tos	# mode 
  lw a1, 0(sp)	# flags
  lw a0, 4(sp)	# name
  addi sp, sp, 2 * CELL
  li a7, #5	# sys_open
  ecall
  ret

# ( fd -- n )
fsclose:			
  li a7, #6	# sys_close
  ecall
  ret

# ( a n fd -- n2 )
fsread:				
  lw a2, 0(sp)	#size
  lw a1, 4(sp)	# buff
  addi sp, sp, 2 * CELL
  li a7, #3	# sys_read
  ecall
  ret

# ( a n fd -- n2 )
fswrite:		
  lw a2, 0(sp)	# size
  lw a1, 4(sp)	# buff
  addi sp, sp, 2 * CELL
  li a7, #4	# sys_write
  ecall
  ret

# ( pos fd -- n )
fsseek:
  lw a1, 4(sp)
  addi sp, sp, 1 * CELL
  mv a2, #0	# SEEK_SET
  li a7, #19	# sys_lseek
  ecall
  ret

# ( a1 -- a2 )
mmap:                           
  li a7, #90	# old_mmap
  ecall
  ret


