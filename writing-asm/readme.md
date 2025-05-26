# Writing Assembly Programs

Even after knowing so many things, I still fear writing assembly programs. It has not become my second nature.

Therefore, I am here to dissolve that problem.

**The Goal:** To attain fluency in writing assembly programs and remove the visual fatigue of seeing large binaries. This would directly help me in my reverse engineering journey.

Here is a table to structure the contrast b/w writing programs in a high-level program and assembly.

| Concept      | Python                      | Assembly                                               |
| ------------ | --------------------------- | ------------------------------------------------------ |
| Variable     | `x = 5`                     | Space in memory or register, manually allocated        |
| Function     | `def func()`                | Label + manual stack handling                          |
| Control Flow | `if`, `for`                 | Jumps and comparisons (`jmp`, `cmp`, `je`, `jl`, etc.) |
| Memory       | Automatic                   | Manual: registers, stack, heap                         |
| Data types   | High-level (int, list, str) | Just bytes, interpretation is yours                    |
| I/O          | `print("hi")`               | Syscalls or libc routines                              |
| Errors       | Exceptions                  | Undefined behavior / segfault                          |

At minimum, there are three sections in an assembly program,
  1. `.bss`: for uninitialised data (reading inputs from terminal)
  2. `.data`: for initialised data
  3. `.text`: code

Next, we have syscalls. There are minutiae differences in the same syscall, depending upon the context. Here are some of those that I need to take care of:

```asm
# Read syscall, taking user input

.section .bss
  buffer: .skip bytes

.section .text
  mov rax, 0
  mov rdi, 0
  lea rsi, buffer
  mov rdx, bytes
  syscall
```
----
```asm
# Write syscall with initialised data ----- Method 1

.section .data
  buffer: .ascii "Hello, World!\n"
  len_buff: . - buffer

.section .text
  mov rax, 1
  mov rdi, 1
  mov rsi, offset buffer
  mov rdx, len_buff
```
----
```asm
# Write syscall with initialised/uninitialised data ----- Method 2

.section .data
  buffer: .ascii "Hello, World!\n"
  len_buff: . - buffer

.section .text
  # logic to calculate the actual buffer length filled and put it in rdx
  mov rsi, rdi          # where rdi holds the pointer to the start of the data in the buffer  
  lea rdx, buffer + (bytes - 1)
  sub rdx, rdi

  mov rax, 1
  mov rdi, 1
  syscall
```
----