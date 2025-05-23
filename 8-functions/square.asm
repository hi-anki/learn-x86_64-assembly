.intel_syntax noprefix

.section .text
.global _start

_start:
  mov rdi, 15         # argument: n = 15
  call square         # call the procedure
  mov rdi, rax        # move result to rdi for exit
  mov rax, 60         # syscall: exit
  syscall

square:
  push rbp            # prologue start
  mov rbp, rsp
  mov rax, rdi        # copy argument to rax
  imul rax, rdi       # rax = rdi * rdi
  pop rbp             # epilogue
  ret
