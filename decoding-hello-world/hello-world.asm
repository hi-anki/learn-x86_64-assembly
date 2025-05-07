# GAS assembler by default uses AT&T syntax. This is how we convey it to use the Intel syntax
.intel_syntax noprefix

# marks the start of data section
.section .data

# "msg" is a label marking where the string buffer begins in the memory.
msg:
    .ascii "Hello, world!\n"        # tells the assembler to put ascii version of the characters in the memory
len     = . - msg       # tells the assembler to compute the length of the string (compiele-time operation)

# This is where the instructions or the code goes.
.section .text

# Makes _start globally visible so the linker knows this is where execution begins.
.global _start

# start is the entry point label, like main() in C
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
