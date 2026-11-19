
## System Caller 
To invoke a Linux system call on RISC-V (both RV32 and RV64), place the syscall number in register a7 (x17), load arguments into a0–a5 (x10–x15), and execute ecall. The kernel returns the result (or a negative errno value on failure) in a0. [1] (https://github.com/scotws/RISC-V-tests/blob/master/docs/riscv_howto_syscalls.md), [2] (https://asm-editor.specy.app/documentation/risc-v/syscall), [3] (https://shell-storm.org/syscalls/), [4] (https://syscall.sh/riscv64/)

Because Linux on RISC-V uses the generic asm-generic/unistd.h ABI, there are over 300 system calls. You can browse the complete searchable list on syscall.sh. [1] (https://libriscv.no/docs/concepts/syscalls/), [2] (https://syscall.sh/riscv64/)

## Calling Convention Summary

• Syscall Number. a7
• Arguments 1–6. a0, a1, a2, a3, a4, a5 (in order)
• Return Value. a0
• Preserved Registers. All registers except a0 (and temporary/caller-saved registers if crossing C wrappers) remain intact across ecall in raw Linux kernel traps. [1] (https://shell-storm.org/syscalls/), [2] (https://syscall.sh/riscv64/)

## Common RISC-V Linux Syscalls (ecall)

(Note: Legacy calls like open, fork, and stat do not exist on RISC-V Linux; modern *at or clone variants are used instead.)

 |a7 | Syscall | a0 | a1 | a2 | a3 | a4 | a5 | 
 | -- | -- | -- | -- | -- | -- | -- | -- |
 | 17 | getcwd | char \*buf | unsigned long size | — | — | — | — | 
 | 25 | fcntl | unsigned int fd | unsigned int cmd | unsigned long arg | — | — | — | 
 | 29 | ioctl | unsigned int fd | unsigned int cmd | unsigned long arg | — | — | — | 
 | 34 | mkdirat | int dfd | const char \*pathname | umode_t mode | — | — | — | 
 | 35 | unlinkat | int dfd | const char \*pathname | int flag | — | — | — | 
 | 48 | faccessat | int dfd | const char \*filename | int mode | — | — | — | 
 | 49 | chdir | const char \*filename | — | — | — | — | — | 
 | 56 | openat | int dfd (-100 = AT_FDCWD) | const char \*filename | int flags | umode_t mode | — | — | 
 | 57 | close | unsigned int fd | — | — | — | — | — | 
 | 62 | lseek | unsigned int fd | off_t offset | unsigned int whence | — | — | — | 
 | 63 | read | unsigned int fd | char \*buf | size_t count | — | — | — | 
 | 64 | write | unsigned int fd | const char \*buf | size_t count | — | — | — | 
 | 79 | fstatat (newfstatat) | int dfd | const char \*filename | struct stat \*statbuf | int flag | — | — | 
 | 80 | fstat | unsigned int fd | struct stat \*statbuf | — | — | — | — | 
 | 93 | exit | int error_code | — | — | — | — | — | 
 | 94 | exit_group | int error_code | — | — | — | — | — | 
 | 172 | getpid | — | — | — | — | — | — | 
 | 214 | brk | unsigned long brk | — | — | — | — | — | 
 | 215 | munmap | unsigned long addr | size_t len | — | — | — | — | 
 | 220 | clone | unsigned long flags | void \*stack | int \*parent_tid | unsigned long tls | int \*child_tid | — | 
 | 221 | execve | const char \*filename | const char \*const \*argv | const char \*const \*envp | — | — | — | 
 | 222 | mmap | unsigned long addr | unsigned long len | unsigned long prot | unsigned long flags | unsigned long fd | off_t pgoff | 
 | 226 | mprotect | unsigned long start | size_t len | unsigned long prot | — | — | — | 
 | 260 | wait4 | pid_t upid | int \*stat_addr | int options | struct rusage \*ru | — | — | 
 | 278 | getrandom | char \*buf | size_t count | unsigned int flags | — | — | — | 
 | -- | -- | -- | -- | -- | -- | -- | -- |
