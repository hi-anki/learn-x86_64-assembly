.intel_syntax noprefix

.section .data

msg: .ascii "Hello, world!\n"
len equ 13    # changed

.section .text

.global _start

_start:
    mov rax, 1          # syscall number for write (1)
    mov rdi, 1          # file descriptor (stdout)
    mov rsi, offset msg # pointer to the buffer to print
    mov rdx, len        # buffer length
    syscall             # invoke kernel

    # Exit syscall
    mov rax, 60         # syscall number for exit (60)
    xor rdi, rdi        # exit code 0
    syscall
