.intel_syntax noprefix

.section .bss
  result_buffer: .skip 5

.section .text
  .global _start

  _start:
    mov rax, 123
    lea rdi, [result_buffer + 4]
    mov byte ptr [rdi], 0
    dec rdi

  convert_loop:
    xor rdx, rdx                      # Set upper bits 0 for first iteration and 0 the remainder since second iteration
    mov rcx, 10
    div rcx

    add dl, '0'
    mov [rdi], dl
    dec rdi

    test rax, rax
    jne convert_loop

    inc rdi
    jmp done

  done:
    mov rsi, rdi
    lea rdx, result_buffer + 4
    sub rdx, rdi
    
    mov rax, 1
    mov rdi, 1
    syscall

  exit: 
    mov rax, 60
    xor rdi, rdi
    syscall
