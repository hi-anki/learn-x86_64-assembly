# Assembler Directives

+ We have written the hello-world program and understand it now. Let's introduce some quirks in that same program, to understand some things which might frustrate us in the future but never ever reveal what is actually frustrating.
+ All the comments are removed for clarity.

+ New code:
  ```asm
  .intel_syntax noprefix

  .section .data

  msg: .ascii "Hello, world!\n"
  len equ . - msg                         # changed from  len = . - msg

  .section .text

  .global _start

  _start:
      mov rax, 1         
      mov rdi, 1         
      mov rsi, offset msg
      mov rdx, len       
      syscall            

      # Exit syscall
      mov rax, 60
      xor rdi, rdi
      syscall
  ```

+ Here I have changed the `len` part. `=` is replaced with `equ`.
+ Assembling this code would result in: 
  ```
  hello-world2.asm:6: Error: no such instruction: 'len equ . - msg'
  ```

+ The problem? `equ` is not recognised by GAS, which we are using to assemble our code. Why? Because, it is a directive found in nasm assembler. GAS has `=`.
+ And we have reached to another conflict. Lets resolve this. Lets go to theory once again.

## ISA vs Assembler

+ In simple words, ISA defines the capabilities of the CPU. It conceptualises everything that the CPU can do.
+ While assemblers are the ones that decide how we as the programmers will interact with the CPU. A tool that translates human-readable assembly code into machine code the CPU understands.

+ Take this, there are very few firms that research on semiconductor chips, but there are relatively many who does the manufacturing. ISA is that research while assemblers are the manufacturers. Each manufacturer (assembler) has the freedom to manufacture in its own way.
+ Or take this, you asked your friend to do something and he said, "be assured". I will do it anyhow but your work will be done. That friend is what the assembler is. Each friend has its own way of doing it.

Different assemblers exist for the same ISA — e.g., GAS, NASM, FASM. Each has its own syntax, quirks, and directives.

## Assembly-Time vs Run-Time

There are two types of operations in assembly programming:

| Type          | Handled By | Examples                |
| ------------- | ---------- | ----------------------- |
| Assembly-time | Assembler  | `.section`, `=`, `equ`  |
| Run-time      | CPU        | `mov`, `syscall`, `add` |

+ Assembly-time operations exist only when the code is being converted to machine code.
+ Run-time operations are actually executed on the CPU.

# Why This Matter
+ It was important to clear this so we don't get stuck in here in the future and start questioning our efforts.
+ Different tutorials might use different assembler, thus using different assembling directives. The underlying idea remains the same.

+ These assembly-time things will differ with every assembler.

+ SO what we are doing here?
  + We are understanding how the high-level instructions are translated to the CPU.
  + The mechanism may differ but not the translated object code.
  + The goal is to learn what is consistent, what doesn't change. Once that is achieved, it will itself open the doors to understand what is inconsistent, on the fly, with no extra efforts.

+ I hope we have achieved the goal to establish the understanding that the assembler is not an NPC (non playing character). It actively influence almost everything.
+ Now we'll not be confused if someone else uses some other directive.
+ Now we'll not go into existential crisis if we don't know a certain directive.