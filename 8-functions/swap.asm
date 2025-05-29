.intel_syntax noprefix
.global _start

.section .data
  welcome_msg: .ascii "Welcome To Swapper Program In x86_64 Intel ASM\n"
  wel_len = . - welcome_msg

.section .text

swap:
  push rbp
  mov rbp, rsp

  sub rsp, 16
  mov [rsp], rdi
  mov [rsp + 8], rsi

  mov rdi, [rsp + 8]
  mov rsi, [rsp]

  mov rsp, rbp
  pop rbp
  # leave
  ret

_start:
  mov rax, 1
  mov rdi, 1
  mov rsi, offset welcome_msg
  mov rdx, wel_len
  syscall

  mov rdi, 1
  mov rsi, 2
  sub rsp, 8
  call swap

  mov rax, 60
  mov rdi, rsi
  syscall
