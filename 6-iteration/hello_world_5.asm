.intel_syntax noprefix

.section .data
  msg: .ascii "Hello, World!\n"
  len = . - msg

.section .text
  .global _start

  _start:
    # counter variable
    mov rbx, 0

    .loop_start:
      # break condition
      cmp rbx, 5

      # _if rdi becomes 5, exit
      je exit

      # _if lesser than 5, then print
      mov rax, 1
      mov rdi, 1
      mov rsi, offset msg
      mov rdx, len
      syscall

      inc rbx
      jmp .loop_start

    exit:
      mov rax, 60
      xor rdi, rdi
      syscall
