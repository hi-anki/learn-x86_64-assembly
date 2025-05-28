.intel_syntax noprefix
.global _start

.section .data
    welcome_msg: .ascii "Welcome To The Factorial Calculator Program In x86_64 ASM\n"
    wel_len = . - welcome_msg

.section .text

factorial:
  push rbp
  mov rbp, rsp

  cmp rdi, 1          # if (n <= 1)
  jbe .base_case

  push rdi            # save n
  dec rdi             # n = n - 1
  call factorial      # factorial(n - 1)
  pop rdi             # restore n
  imul rax, rdi       # rax = rax * n
  jmp .done

.base_case:
  mov rax, 1

.done:
  mov rsp, rbp
  pop rbp
  ret

_start:
  mov rax, 1
  mov rdi, 1
  mov rsi, offset welcome_msg
  mov rdx, wel_len
  syscall

  mov rdi, 6
  call factorial      # result in rax

  mov rdi, rax
  mov rax, 60
  syscall
