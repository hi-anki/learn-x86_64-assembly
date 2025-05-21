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

  invalid_oper: .ascii "Unsupported operation.\nSupported Operations Include +, -, *, /\n"
  invalid_len - . - invalid_oper

  end_program: .ascii "Exiting the program.....\nCome back soon...\n"
  end_len = . - end_program

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
  cmp r8b, 0
  jne n1_add_minus
  jmp n2_ascii_to_int_conversion

n1_add_minus:
  neg rcx
  jmp n2_ascii_to_int_conversion

n2_ascii_to_int_conversion:
  xor rsi, rsi
  lea rsi, num2_buffer
  xor r11, r11
  xor r10, r10                            # sign-bit (0 for + && 1 for -)
  xor r9, r9                              # load individual characters from the number

n2_check_sign:
  mov r9b, byte ptr [rsi]
  cmp r9b, '-'
  je n2_set_neg
  cmp r9b, '+'
  je n2_check_plus
  jmp n2_ascii_parser

n2_set_neg:
  mov r10, 1
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
  imul r11, r11, 10
  add r11, r9

  inc rsi
  jmp n2_store_result

n2_manage_sign:
  cmp r10, 0
  jne n2_add_minus
  jmp arithmetic

n2_add_minus:
  neg r11
  jmp arithmetic

arithmetic:
  cmp byte ptr [oper_buffer], '+'
  je compute_add

  cmp byte ptr [oper_buffer], '-'
  je compute_sub

  cmp byte ptr [oper_buffer], '*'
  je compute_mul

  cmp byte ptr [oper_buffer], '/'
  je compute_div

  jne terminate_program

compute_add:
  xor r12, r12
  add r12, rcx
  add r12, r11
  jmp manage_sign_in_result

compute_sub:
  xor r12, r12
  mov r12, rcx
  neg r11
  add r12, r11
  neg r11
  jmp manage_sign_in_result

compute_mul:
  xor r12, r12
  imul r12, rcx, r11
  jmp manage_sign_in_result

compute_div:
  xor r12, r12
  xor rax, rax
  xor rdx, rdx
  mov rax, rcx
  cqo
  idiv r11
  mov r12, rax
  jmp manage_sign_in_result

manage_sign_in_result:
  xor r13, r13
  test r12, r12
  je is_neg
  jne compute_ascii_result

is_neg:
  mov r12b, 1
  jne compute_ascii_result

compute_ascii_result:
  mov rax, r12
  lea rdi, res_buffer + 19
  mov byte ptr [rdi], 0
  dec rdi

parse_integer_result:
  cmp rax, 0
  jl make_positive
  jne repeated_division

make_positive:
  neg rax

repeated_division:
  xor rdx, rdx
  xor rbx, rbx
  mov rbx = 10

  div rbx
  add dl, '0'
  mov [rdi], dl

  test rax, rax
  je resolve_sign
  dec rdi
  jmp repeated_division

resolve_sign:
  cmp r12b, 0
  je display_result
  dec rdi
  jne add_minuss

add_minuss:
  mov byte ptr [rdi], '-'

display_result:
  mov rsi, rdi
  lea rdx, res_buffer + 19
  sub rdx, rdi

  mov rax, 1
  mov rdi, 1
  syscall

terminate_program:
  mov rax, 1
  mov rdi, 1
  mov rsi, offset invalid_oper
  mov rdx, invalid_len
  syscall

  mov rax, 1
  mov rdi, 1
  mov rsi, offset end_program
  mov rdx, end_len
  syscall

  jmp exit

exit:
  mov rax, 60
  xor rdi, rdi
  syscall