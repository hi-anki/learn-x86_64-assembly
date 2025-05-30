.intel_syntax noprefix
.global _start

.section .data
  arr: .byte 11, 22, 33, 44

.section .text
_start:
  lea rsi, arr
  mov rax, 60
  mov rdi, [arr + 3]
  # movzx rdi, byte ptr [arr + 3]
  syscall
