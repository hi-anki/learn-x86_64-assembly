# Take user-input for name and greet.

.intel_syntax noprefix

.section .bss
  name_buffer: .skip 100

.section .data
  input_msg: .ascii "Enter your name: "
  im_len = . - input_msg

  greet_msg: .ascii "Good Afternoon, "
  gm_len = . - greet_msg

  end_exc: .ascii "!\n"
  e_len = . - end_exc

.section .text
  .global _start

  _start:
  # Step 1:  Display input_msg
    mov rax, 1
    mov rdi, 1
    mov rsi, offset input_msg
    mov rdx, im_len
    syscall

  # Step 2: Take user-input
    mov rax, 0
    mov rdi, 0
    lea rsi, name_buffer
    mov rdx, 100
    syscall

  # Step 3: Display greet label
    mov rbx, rax
    mov rax, 1
    mov rdi, 1
    mov rsi, offset greet_msg
    mov rdx, gm_len
    syscall

  # Step 4: Display the name entered by the user
    mov rax, 1
    mov rdi, 1
    lea rsi, name_buffer
    mov rdx, rbx
    syscall

  # Print a closing exclamation mark
    mov rax, 1
    mov rdi, 1
    mov rsi, offset end_exc
    mov rdx, e_len
    syscall

  # Exit
    mov rax, 60
    xor rdi, rdi
    syscall
