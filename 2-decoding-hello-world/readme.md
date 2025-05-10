# How "Hello, World!" Works?
In most simplest terms, a "Hello, World!" in assembly (on Linux, x86_64) is typically done by making a system call (or syscall) to the kernel to write to the screen. 

On surface level, this involves setting the registers correctly and invoking the syscall. This includes:
  + Putting the "**write**" syscall number in the correct register.
  + Setting up the file descriptor to put the results in the standard output (fd = 1, for stdout).
  + Pointing to the message
  + Giving its length
  + Invoking the syscall

For exactitude, lets dive into it.

## Hello, World!
The assembly code for hello world looks like:
```asm
.intel_syntax noprefix

.section .data
  msg: .ascii "Hello, world!\n"
  len = . - msg

.section .text

.global _start

_start:
  mov rax, 1          # syscall number for write (1)
  mov rdi, 1          # file descriptor (stdout)
  mov rsi, offset msg # pointer to the buffer to print
  mov rdx, len        # buffer length
  syscall             # invoke kernel

  # Exit syscall
  mov rax, 60         # syscall number for exit (60)
  xor rdi, rdi        # exit code 0
  syscall

```

Lets explore this line by line.

## Assembler Directive For Syntax Clarity, Line 1
Since we are writing intel syntax but assembling it through GAS, we need to tell GAS we are writing intel syntax.

We know the reason already. GAS was created with AT&T syntax but it supports intel as well.

`.intel_syntax` tells GAS we are writing in intel syntax.

`.no_prefix` tells GAS to strictly avoid `%` and `$` in instructions.

## Define Data, Line 2
+ I assume everyone already have some experience in programming. Even a simplest program has two things, data and instructions. So as with assembly.
+ But the assembler wants you to keep them at different places. Keep a distinction between data and the instructions.
+ This distinction is created using sections.
+ Remember, sections are assembler directives, not something that the CPU understands. This is for the assembler to maintain clarity in asm code.

+ So, `.section` marks the start of a section.
+ Following it names the section we are going to be writing. Here, it is `.data`, which means we are going to write the data here.
+ The `.data` section contains "global or static variables" defined with "specific values" in the program.

+ A section continues until a new section is defined with the `.section` directive. Therefore, both `msg` and `len` are part of the data section.

+ **Note:** Sections can be user-defined as well. `.data` section is special or reserved by the assembler because it means something. But they are for advance use-cases.

## DATA (Global And Static Variables), Line 3 And 4
```asm
msg: .ascii "Hello, world!\n"
len = . - msg
```

+ `msg:` is a label. It can contain anything "but we are storing a string buffer in it". 
  + What else can it contain? Leave some interesting things for tomorrow.

+ `len` is a assembly-time constant. It calculates and contains the length of the buffer. 
  + It does this using the `.` directive in GAS.
  + The `.` directive represents the current address in memory.
  + Current address is defined as how much the assembler has moved in the memory.
  + When we created a label `msg`, memory started to get occupied. Once that is done, we came onto len.
  + Now, the pointer is just after where the buffer finished. This is what the `.` directive "**in GAS**" represents.
  + And the msg label is a pointer to the start of the "hello world" buffer.
  + Subtracting the two gives us the effective length of the "hello world!" buffer.

+ Data section, finished.

## The Instructions Section
+ `.section .text` marks the start of text section. This section contains the instructions to the CPU. Basically, here goes the actual code.
+ `.global` is used to declare a symbol as globally accessible. Here, globally accessible means accessibility outside of the current file.
+ Again, an assembler directive, allowing a symbol it to be accessed in other files or modules during the linking process.
+ If you removed it, the code will still work. The importance of it comes into picture when there are multiple assembly files. Keep this question for tomorrow.

+ `_start` is the memory location (a label) where the execution starts from. Same as main() in C.
+ Called by the OS. It is the entrypoint.

+ `.global _start` makes `_start` globally accessible.

+ **Note**: `_start` is just another label. But this is what everyone has mutually agreed upon. Thus, assemblers look for it. We can define our own and tell the linker appropriately.

## Now The Instructions, Finally
+ Instructions in intel x86 assembly syntax follows `destination, source` convention. Basically, the normal maths.

+ `mov rax, 1` means move the value 1 inside rax register. Mathematically, it is the same as `rax = 1`.
  + By convention, rax is used to specify the system call number.
  + Here, 1 identifies the "write" system call.

+ `move rdi, 1` means set the file descriptor to 1, which is used for standard output. This ensures that we see "hello world!\n" in the terminal.
  + Value of 1 corresponds to standard output or `stdout`.

+ `mov rsi, offset msg` means set rsi to hold the pointer to the message buffer.
+ `mov rdx, len` means set the length of the buffer in rdx.
+ `syscall`, invoke the syscall.

----
### Understanding The `write` Syscall
```
`write(fd=rdi, buffer=rsi, buffer_len=rdx)`
```

+ The write syscall is used to output data to a file descriptor.
+ The write syscall takes 3 arguments which are passed through registers.

+ **Argument 1**: File descriptor.
  + This defines where to write or where the output would go.
  + It goes in the `rdi` register.
  + 1 is used for `stdout`.
  + 2 is used for `stderr`.

+ **Argument 2**: Pointer to the buffer that contains the data to be written.
  + This defines where is the item that has to be written.
  + This goes in `rsi` register.

+ **Argument 3**: Length of the buffer.
  + This defines the number of bytes to write.
  + This goes in `rdx` register.
----

+ `mov rax, 60` sets the register for the next syscall, which is exit.
+ `xor rdi, rdi` sets rdi to 0 using a bitwise XOR (which is shorter/faster than mov rdi, 0). This sets the exit code to zero.
+ `syscall`, invoke the syscall.

Done. Finally!