.intel_syntax noprefix

.section .bss
  result_buffer: .skip 1

.section .text
  .global _start

  _start:
    mov rax, 123
    lea rdi, [result_buffer + 4]
    mov byte ptr [rdi], 0
    dec rdi

  convert_loop:
    xor rdx, rdx
    mov rcx, 10
    div rcx 

    add dl, '0' 
    mov [rdi], dl
    dec rdi

    test rax, rax
    jne convert_loop

    inc rdi
    jne done

  done:
    mov rsi, rdi
    # mov rdx, result_buffer + 4
    # sub rdx, rdi
    # mov rdx, 3

    mov r8, rax

    mov rax, 1
    mov rdi, 1
    syscall

  exit:
    mov rax, 60
    xor rdi, rdi
    mov rdi, r8
    syscall
