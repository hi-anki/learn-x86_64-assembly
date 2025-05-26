.intel_syntax noprefix
.global _start

.section .bss
  res_buff: .skip 2

.section .text
sum:
  push rbp
  mov rbp, rsp

  # a = rdi, b = rsi, c = rdx ; as per System V ABI
  mov rax, rdi
  add rax, rsi
  add rax, rdx

  pop rbp                   # restore the base pointer
  ret

_start:
  mov rdi, 1
  mov rsi, 2
  mov rdx, 3
  call sum

  add rax, '0'
  mov [res_buff], rax

  mov rax, 1
  mov rdi, 1
  lea rsi, res_buff
  mov rdx, 1
  syscall

  mov rax, 60
  xor rdi, rdi
  syscall
