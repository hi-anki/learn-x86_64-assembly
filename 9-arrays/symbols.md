# Symbols

A symbol is a name that represents an address or value in your program.

Labels, static data variables, functions, constants, and everything that represents a pointer to a memory location or an immediate/constant value is a symbol.

Remember in labels, we had that analogy that all variables [in high-level languages] are basically sub set of labels [in assembly]. Every variable is a label, but not every label is a variable.

But a label is a sub set of a symbol. A symbol is like a broad classification, which covers everything that points to a memory location.

## Golbal Uninitialised Symbol

Global scope means that the symbol is available to the linker and can be used outside of the file as well.

It is declared using `.comm`

```asm
.section .bss
  .comm symbol, length, alignment
```
> Alignment is optional, which defaults to 4-bytes

Example:
```asm
.section .bss
  .comm buff, 100
```
> A 100 bytes buffer

## Local Uninitialised Symbol

Local scope means access in the current file only.

It is declared using `.lcomm`

```asm
.section .bss
  .lcomm symbol, length
```

Example:
```asm
.section .bss
  .lcomm buff, 100
```

## But where is the difference?

I am a human, you are human. We have differences, but what identifies us, "we are humans".

We also have sea animals.

We also have land animals.

We have carnivores.

We have omnivores.

We have animals who can fly.

We have animals who can swim.

We have animals who can walk.

But unifies all of these species? They are animals.

A laptop is a computer, a mobile is a computer, a desktop is also a computer, a keypad phone is also a computer, a kiosk machine is also a computer and a vending machine is also a computer. They all are different, but they all are just on thing, computer.

Have a look at this program: 

```asm
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

```
> `welcome_msg` is a label, but, it is also a data symbol that marks a memory location.
>
> We know `wel_len` as a assembly-time computed constant. And yes, it is a constant symbol.
>
> We have `factorial`, which is again a label. But formally, it is a code symbol.
>
> `base_case` and `done` are local labels, or local symbols. They are scope to the containing function/procedure.

The difference is that a label is just a sub set of what a symbol can represent to.

## A Note

"comm" just stands for common. It just represents a common symbol. That's it.