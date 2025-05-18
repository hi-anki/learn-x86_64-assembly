# ascii to int
.intel_syntax noprefix

.section .bss
  input_str: .skip 20                       # Reserved 20 bytes to take number input
  result_buffer: .skip 20                   # 64-bit = ~18q combinations = 20 digits long

.section .text
  .global _start

  _start:
  # Read syscall to take input
    mov rax, 0
    mov rdi, 0
    lea rsi, input_str
    mov rdx, 20
    syscall

  # ASCII to INT
    lea rsi, input_str
    xor rbx, rbx

  ascii_to_int_loop:
    movzx rcx, byte ptr [rsi]

    cmp rcx, 10                             # Changed it to 10, which is for LF or \n
    je parse_done

    sub rcx, '0'
    imul rbx, rbx, 10
    add rbx, rcx

    inc rsi
    jmp ascii_to_int_loop

  parse_done:
  # rbx now contains the integer value
  # Now we have to convert INT to ASCII

    mov rax, rbx
    lea rdi, [result_buffer + 19]
    mov byte ptr [rdi], 0
    dec rdi

  int_to_ascii_loop:
    xor rdx, rdx                      # Set upper bits 0 for first iteration and 0 the remainder since second iteration
    mov rcx, 10
    div rcx

    add dl, '0'
    mov [rdi], dl
    dec rdi

    test rax, rax
    jne int_to_ascii_loop

    inc rdi
    jmp display_result

  display_result:
    mov rsi, rdi
    lea rdx, result_buffer + 19
    sub rdx, rdi

    mov rax, 1
    mov rdi, 1
    syscall

  exit: 
    mov rax, 60
    xor rdi, rdi
    syscall
