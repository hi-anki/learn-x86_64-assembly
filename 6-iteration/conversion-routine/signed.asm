.intel_syntax noprefix

.section .bss
  input_buffer:  .skip 20
  result_buffer: .skip 20

.section .text
.global _start

_start:
  # Read number
  mov rax, 0
  mov rdi, 0
  lea rsi, input_buffer
  mov rdx, 20
  syscall

  # ASCII to INT
ascii_to_int:
  lea rsi, input_buffer
  xor rcx, rcx
  xor r8, r8
  xor r9, r9

check_sign:
  mov r9b, byte ptr [rsi]
  cmp r9b, '-'
  je set_neg
  cmp r9b, '+'
  je check_plus
  jmp ascii_parser

set_neg:
  mov r8b, 1
  inc rsi
  jmp ascii_parser

check_plus:
  inc rsi
  jmp ascii_parser

ascii_parser:
  xor r9, r9
  movzx r9, byte ptr [rsi]
  cmp r9b, 10                          # 10 = LF
  je int_result

  sub r9, '0'
  imul rcx, rcx, 10
  add rcx, r9

  inc rsi
  jmp ascii_parser

int_result:
  # The number is parsed now and now we have to put the sign, if needed
  cmp r8b, 0
  je int_to_ascii
  neg rcx

  # INT to ASCII
int_to_ascii:
  mov rax, rcx
  lea rdi, result_buffer + 19
  mov byte ptr [rdi], 0
  dec rdi

int_parser:
  cmp rax, 0
  jl make_positive          # If the number is less than 0, convertit to +ve so the digits can be extracted
  jmp repeated_division

make_positive:
  neg rax

repeated_division:
  # mov r12, rax
  # jmp exit
  xor rdx, rdx
  xor rbx, rbx
  mov rbx, 10

  div rbx
  add dl, '0'
  mov [rdi], dl

  test rax, rax
  je resolve_sign
  dec rdi
  jne repeated_division

resolve_sign:
  cmp r8b, 0
  je display
  dec rdi
  jne add_minus

add_minus:
  mov byte ptr [rdi], '-'

display:
  # dec rdi
  mov rsi, rdi
  lea rdx, result_buffer + 19
  sub rdx, rdi

  # mov r12, rdx

  mov rax, 1
  mov rdi, 1
  syscall

exit:
  mov rax, 60
  xor rdi, rdi
  # mov rdi, r12
  syscall
