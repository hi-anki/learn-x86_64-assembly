.intel_syntax noprefix

.section .data
  input_str: .asciz "123"

.section .text
  .global _start

  _start:
    lea rsi, input_str
    xor rbx, rbx

  parse_loop:
    movzx rcx, byte ptr [rsi]

    # test rcx, rcx
    cmp rcx, 0
    je parse_done

    sub rcx, '0'
    imul rbx, rbx, 10
    add rbx, rcx

    inc rsi
    jmp parse_loop

  parse_done:
    mov rax, 60
    mov rdi, rbx
    syscall
