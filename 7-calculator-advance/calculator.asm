.intel_syntax noprefix

.section .data
  welcome: .ascii "Welcome To x86_64 Assembly Calculator\n"
  wel_len = . - welcome

  op1: .ascii "Enter num1: "
  op2: .ascii "Enter num2: "
  op_len = . - op2

  operator: .ascii "Enter the operator: "
  oper_len = . - operator

  res_add: .ascii "Num1 + Num2 = "
  res_sub: .ascii "Num1 - Num2 = "
  res_mul: .ascii "Num1 * Num2 = "
  res_div: .ascii "Num1 / Num2 = "
  res_len = . - res_div

  terminate: .ascii "Come back soon...\n"
  ter_len = . - terminate

.section .bss
  num1_buffer: .skip 20
  num2_buffer: .skip 20
  oper_buffer: .skip 2
  res_buffer:  .skip 20

.section .text
.global _start

_start:
  # Display welcome message
  mov rax, 1
  mov rdi, 1
  mov rsi, offset welcome
  mov rdx, wel_len
  syscall

read_numbers:
  mov rax, 1
  mov rdi, 1
  mov rsi, offset op1
  mov rdx, op_len
  syscall

  mov rax, 0
  mov rdi, 0
  lea rsi, num1_buffer
  mov rdx, 20
  syscall

  mov rax, 1
  mov rdi, 1
  mov rsi, offset op2
  mov rdx, op_len
  syscall

  mov rax, 0
  mov rdi, 0
  lea rsi, num2_buffer
  mov rdx, 20
  syscall

read_operator:
  mov rax, 1
  mov rdi, 1
  mov rsi, offset operator
  mov rdx, oper_len
  syscall

  mov rax, 0
  mov rdi, 0
  lea rsi, oper_buffer
  mov rdx, 2

n1_ascii_to_int_conversion:
  lea rsi, num1_buffer
  xor rcx, rcx
  xor r8, r8                              # sign-bit (0 for + && 1 for -)
  xor r9, r9                              # load individual characters from the number

n1_check_sign:
  mov r9b, byte ptr [rsi]
  cmp r9b, '-'
  je n1_set_neg
  cmp r9b, '+'
  je n1_check_plus
  jmp n1_ascii_parser

n1_set_neg:
  mov r8b, 1
  inc rsi
  jmp n1_ascii_parser

n1_check_plus:
  inc rsi
  jmp n1_ascii_parser

n1_ascii_parser:
  xor r9, r9
  movzx r9, byt ptr [rsi]
  cmp r9b, 10                             # 10 = LF
  je n1_store_result

  sub r9, '0'
  imul rcx, rcx, 10
  add rcx, r9

  inc rsi
  jmp n1_manage_sign

n1_manage_sign:
  xor r11, r11
  cmp r8b, 0
  je plus
  neg rcx
  mov r11, rcx
  jmp n2_ascii_to_int_conversion

n1_plus:
  mov r11, rcx
  jmp n2_ascii_to_int_conversion

n2_ascii_to_int_conversion:
  xor rsi, rsi
  lea rsi, num2_buffer
  xor rcx, rcx
  xor r8, r8                              # sign-bit (0 for + && 1 for -)
  xor r9, r9                              # load individual characters from the number

n2_check_sign:
  mov r9b, byte ptr [rsi]
  cmp r9b, '-'
  je n2_set_neg
  cmp r9b, '+'
  je n2_check_plus
  jmp n2_ascii_parser

n2_set_neg:
  mov r8b, 1
  inc rsi
  jmp n2_ascii_parser

n2_check_plus:
  inc rsi
  jmp n2_ascii_parser

n2_ascii_parser:
  xor r9, r9
  movzx r9, byt ptr [rsi]
  cmp r9b, 10                             # 10 = LF
  je n2_store_result

  sub r9, '0'
  imul rcx, rcx, 10
  add rcx, r9

  inc rsi
  jmp n2_store_result

n2_manage_sign:
  xor r12, r12
  cmp r8b, 0
  je plus
  neg rcx
  mov r12, rcx
  jmp arithmetic

n2_plus:
  mov r12, rcx
  jmp arithmetic

arithmetic:
  cmp byte ptr [oper_buffer], '+'
  # Will continue from here tomorrow!