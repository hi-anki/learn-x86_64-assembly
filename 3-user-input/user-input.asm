.intel_syntax noprefix

.section .bss
  buffer: .skip 100

.section .text
  .global _start

  _start:
  # Step 1: Take user-input
    mov rax, 0                  # sys_read
    mov rdi, 0                  # stdin
    lea rsi, buffer             # buffer to read into
    mov rdx, 100                # bytes to read
    syscall

  # Step 2: Display the input
    mov rdx, rax                # number of bytes read (from previous syscall)
    mov rax, 1                  # sys_write
    mov rdi, 1                  # stdout
    lea rsi, buffer             # buffer to write from
    syscall

  # Exit
    mov rax, 60         # sys_exit
    xor rdi, rdi        # status 0
    syscall
