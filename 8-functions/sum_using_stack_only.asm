.intel_syntax noprefix
.global _start

.section .bss
  res_buff: .skip 2

.section .text

sum:
  push rbp
  mov rbp, rsp

  mov eax, dword ptr [rbp + 16]
  add eax, dword ptr [rbp + 24]
  add eax, dword ptr [rbp + 32]

  pop rbp
  ret

_start:
  push 1
  push 2
  push 4

  call sum

  add eax, '0'
  mov [res_buff], eax

  mov rax, 1
  mov rdi, 1 
  lea rsi, res_buff
  mov rdx, 1
  syscall

  mov rax, 60
  xor rdx, rdx
  syscall
