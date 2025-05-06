# x86 Syntax Problem
+ We already know that x86 CPU's can be programmed in two syntaxes, Intel and AT&T.
+ Lets look at hello-world programs written in both of these.
+ This one is Intel:
  ```asm
  section .data
    msg db "Hello, world!", 10   ; 10 is newline '\n'
    len equ $ - msg              ; length of the message

  section .text
      global _start

  _start:
      mov rax, 1       ; syscall number for write
      mov rdi, 1       ; file descriptor 1 = stdout
      mov rsi, msg     ; pointer to the message
      mov rdx, len     ; message length
      syscall          ; make the system call

      mov rax, 60      ; syscall number for exit
      xor rdi, rdi     ; exit code 0
      syscall
  ```
+ To assemble: `nasm -elf64 -o hello.o hello.asm`
+ To link: `ld -o hello hello.o`

+ This one is AT&T:
  ```
  .section .data
  msg:     .ascii  "Hello, world!\n"
  len = . - msg

  .section .text
  .globl _start
  _start:
      mov     $1, %rax        # syscall number for write (1)
      mov     $1, %rdi        # file descriptor (stdout)
      lea     msg(%rip), %rsi # address of the message
      mov     $len, %rdx      # length of message
      syscall                 # make the system call

      mov     $60, %rax       # syscall number for exit (60)
      xor     %rdi, %rdi      # exit code 0
      syscall
  ```
+ To assemble: `as -o hello.o hello.asm`
+ To link: `ld -o hello hello.o`

+ Easily, we can spot some questions.
+ We were told that `section` is a directive and should start a period. But intel doesn't seem to follow this. Why?
+ AT&T has got these weird `$` and `%`, why? 
  + Intel came first and ideally if it worked, there is no need for these?
  + But ones who have created the AT&T syntax are also not fool. If they created it, there would be some reason?
  + The source and destination orders are different. But that can be a design philosophy, so leave that.
  + Why we have used different assemblers but same linker?

+ Lets answer these one by one.

+ Question 1: Why we have used different assemblers but same linker?
  + We know that intel created x86 assembly. So as the assembler, which is nasm, fasm etc....
  + These were strictly intel based. Because there exist no other syntax.
  + After some years, GNU Project came into existence. With that came the AT&T syntax.
  + Assembly is one, but the syntaxes differed now. And for that reason, another assembler was required that can understand the AT&T syntax. That's how GNU Assembler (or GAS or `as`) was born. This became the part of GNU toolchain. Since we are on GNU linux, we are using `as` to assemble the AT&T syntax.

  + Consider assemblers as IDEs. We have VS Code, Cursor, Windsurf, Jet Brains, Sublime Text and so on. They offer different experience but does that change the code we write? No.

  + Linking, on the other hand, is a post-assembly process and follows standard object file formats like ELF (Linux), COFF (Windows), or Mach-O (macOS).
  + All these assemblers create a file that is ready to be linked. There is no syntax problem. All syntaxes once assembled become one entity, and that's why there is no need for different linkers.
  + There is no problem in using different linkers. We have others like `lld`, `gold` etc. But there is no need for that.

+ Question 2: If that's the case, we can assemble AT&T syntax with `nasm` and intel with `as`?
  + GAS (or `as`) was designed to support many architectures. It was designed to be flexible. That's why intel syntax can also be assembled using `as`.
  + `nasm` on the other hand was strictly designed for intel-based ecosystem.
  + This is the reason why `as` can assemble any syntax but `nasm` and other assemblers in intel-family are restricted to intel-only.

  + Consider this, a TV is strictly designed to enjoy visuals. It can't make calls. While mobile phones were designed to facilitate calling but eventually expanded to allow enjoying visuals as well.
  + `nasm` here is a TV while `as` is a mobile phone.

+ Question 3: `$` and `%`
  + This thing again boils down to how assembly and assemblers are structured. Assembly is a concept and assemblers implement it. That's the easiest way to tell it.
    + Assembly language is a human-readable form of machine instructions defined by a CPU's Instruction Set Architecture (ISA).
    + The actual syntax used to write those instructions in source files is up to the assembler — the program that reads your text and turns it into machine code.
  + The AT&T syntax assembles using `as`, and these `$` and `%` are meaningful for the compiler, not assembly itself.
  + We already know that memory store raw-bytes. Meaning, numbers only. But these can be anything. This creates two things.
    + It gives freedom to manipulate it in anyway. There are no strict rules. The Programmer creates them.
    + Freedom, if not regulated by discipline, can lead to damnnation. And `$` and `%` tries to solve this exactly. A % prefixed before a register strictly means a register. A $ prefixed before a number makes it a literal digit. No prefix means a memory address. No more assumptions.

# Conclusion
Use GAS (as) because it's portable, well-integrated with the GNU toolchain, and supports many architectures and syntaxes. It works nearly everywhere Linux is.

Stick to Intel syntax because it's clearer and more intuitive, especially for newcomers. The assignment-like order (mov dst, src) matches what most programmers expect, and it avoids extra visual clutter like $ and %.