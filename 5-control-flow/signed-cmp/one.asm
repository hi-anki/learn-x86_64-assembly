.intel_syntax noprefix
.section .text
.global _start

_start:
    mov eax, -4
    mov ebx, 2

    cmp eax, ebx      # -4 < 2?
    jm less_than      # jump if signed less

    mov eax, 60       # syscall: exit
    mov edi, 11       # exit code for "not less"
    syscall

less_than:
    mov eax, 60       # syscall: exit
    mov edi, 22       # exit code for "less"
    syscall
