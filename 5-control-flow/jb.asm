.intel_syntax noprefix

.section .text
.global _start

_start:
    mov al, 4           # unsigned 4
    mov bl, 8           # unsigned 8

    cmp al, bl
    jb above

    jmp exit

exit:
    mov rax, 60
    mov rdi, 11         # exit code 11 if exit label is invoked
    syscall

below:
    mov rax, 60
    mov rdi, 22         # exit code 22 if below label is invoked
    syscall
