# A Practical Introduction To x86_64 Intel Assembly Through *Hello, World!*

Understanding a programming language starts with understanding the most commonly used terms in a simple program written in that language. For example, you write a hello world in C, and it exposes you to some concepts, like pre-processing directives, functions, entrypoint function, strings and probably return statement.

Therefore, we are going to start with the same ritual, writing our "Hello, World!"

The aim of this program is to expose us to the terminologies used in a simple assembly program.

And that's how you write ["Hello, World!"](./hello-world.asm), in assembly:
```asm
.intel_syntax noprefix
.global _start

.section .data
  msg: .ascii "Hello, world!\n"
  len = . - msg

.section .text

_start:
  mov rax, 1
  mov rdi, 1
  mov rsi, offset msg
  mov rdx, len
  syscall

  mov rax, 60
  xor rdi, rdi
  syscall

```

Now we are equipped to dive into assembly.

## 1. Assembler Directives

`.intel_syntax noprefix`, `.global`, `.section`, `.data`, `.text`, all of these are assembler directives.

An assembler directive is an instruction which is meant for the assembler, not the CPU.