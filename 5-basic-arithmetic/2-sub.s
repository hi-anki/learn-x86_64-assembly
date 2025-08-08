# Take 2 numbers and one operator as input from the user and compute the result

.intel_syntax noprefix

.section .bss
  num1: .skip 2
  num2: .skip 2

.section .data
  welcome_msg: .ascii "Welcome To x86_64 Calculator\n"
  w_len = . - welcome_msg

  op_msg_1: .ascii "Enter number 1: "
  op_len = . - op_msg_1
  op_msg_2: .ascii "Enter number 2: "

  res: .ascii "Num1 - Num2 = "
  res_len = . - res

.section .text
  .global _start

  _start:
  # Step 1: Print the welcome message
    mov rax, 1
    mov rdi, 1
    mov rsi, offset welcome_msg
    mov rdx, w_len
    syscall

  # Step 2: Ask for first number
    mov rax, 1
    mov rdi, 1
    mov rsi, offset op_msg_1
    mov rdx, op_len
    syscall

  # Step 3: Take user input
    mov rax, 0
    mov rdi, 0
    lea rsi, num1
    mov rdx, 2
    syscall

  # Step 4: Ask for second number
    mov rax, 1
    mov rdi, 1
    mov rsi, offset op_msg_2
    mov rdx, op_len
    syscall

  # Step 5: Take user input
    mov rax, 0
    mov rdi, 0
    lea rsi, num2
    mov rdx, 2
    syscall

  # Step 6: Convert from ASCII to Integer
    movzx rbx, byte ptr [num1]
    sub rbx, '0'
    movzx rcx, byte ptr [num2]
    sub rcx, '0'

  # Step 7: Subtraction
    sub rbx, rcx        # rbx = rbx - rcx

  # Step 8: Convert the result from Integer to ASCII
    add rbx, '0'

  # Step 9: Display result msg
    mov rax, 1
    mov rdi, 1
    mov rsi, offset res
    mov rdx, res_len
    syscall

  # Step 10: Display resultant digit
    mov rax, 1
    mov rdi, 1
    push rbx
    mov rsi, rsp
    mov rdx, 1
    syscall

  # Exit
    mov rax, 60
    xor rdi, rdi
    syscall
