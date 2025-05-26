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
  push rbp            # prologue start, save old base pointer
  mov rbp, rsp        # establish new base pointer, prologue end

  mov rax, rdi        # copy argument to rax
  imul rax, rdi       # rax = rdi * rdi
  pop rbp             # epilogue
  ret                 # return rax, the default place for for return
