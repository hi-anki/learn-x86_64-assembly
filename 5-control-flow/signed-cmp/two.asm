.intel_syntax noprefix

.section .text
  .global _start

  _start:
    mov al, 41
    cmp al, 8

    jl lesser
    jg greater

  lesser:
    mov rax, 60
    mov rdi, 10
    syscall

  greater:
    mov rax, 60
    mov rdi, 20
    syscall
