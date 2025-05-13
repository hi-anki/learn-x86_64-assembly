.intel_syntax noprefix

.section .text
.global _start

_start:
    mov al, 4           # unsigned 4
    mov bl, 4           # unsigned 4

    cmp al, bl
    je equal

    jmp exit

exit:
    mov rax, 60
    mov rdi, 11         # exit code 11 if exit label is invoked
    syscall

equal:
    mov rax, 60
    mov rdi, 22         # exit code 22 if equal label is invoked
    syscall
