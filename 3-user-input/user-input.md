# Reading Input From The User

1. `.bss` section refers to uninitialisied data. Here, reading from stdin is uninitialisied because it will be done on runtime. Therefore, rather putting it in data section, we put it into `.bss` because data expects statically defined values.

2. `buffer` is a user-defined label which is reserving number of bytes for the stdin.
3. `.skip` is a GAS directive used to reserve uninitialized space by skipping N-bytes.

4. Put read syscall in rax, which is 0.
5. Set the file descriptor to 0, for stdin in rdi (arg 1).
6. Load effective address of the buffer, where we will read, in rsi (arg 2).
7. Set rdx with the number of bytes to read (arg 3).
8. Invoke the syscall, read from console.

With that in mind, read syscall would look like: `read(fd, buffer, bytes)

8. Now, put the write syscall in rax, which is 1.
9. Set the file descriptor to 1, for stdout in rdi (arg 1).
10. Load the buffer to write from in rsi. We haven't used `offset` here because it works on assembly-time. `lea` on the the other hand is a CPU instruction.
11. Set the number of bytes to write, in rdx. This is the most interesting and learnable part here.
    + We are not using 100 or buffer directly because it was the complete buffer length that could be read from stdin.
    + Meaning, stdin was prepared to read 100 bytes but it is not necessary that the user will enter 100 bytes completely. It might enter less.
    + In that case, it will fail. But because we are using rax, therefore, it will not.
    + How? read syscall will return the number of bytes read from stdin. We know return value by convention goes into rax (it's callee-managed). rax has the effective number of bytes, which we need.
12. Invoke the syscall, print to console.

13. Exit syscall.

# `lea` Instruction

+ This is something new here. Lets learn.
+ It stands for "load effective address".
+ It computes the address of a memory operand and loads it into a register — but it does not access the value at that memory address.
+ It is like, "take the address of buffer, and store that in rsi."
+ It is used when you want to pass a pointer to the data, not the data itself.

# But, Here Is A Problem

+ This will only print the first character or the first byte in the buffer. Lets test this.
+ Now the reason behind this is rax is being over-written.

+ After the read syscall is completed, it returned the effective bytes in rax.
+ But we have set rax to 1 for write syscall. And that's how we have lost the effective number of bytes in the buffer.
+ Solution? Move the instruction `mov rdx, rax` to just above the instruction where we are setting up rax for the write syscall. Like this:
  ```asm
  mov rdx, rax
  mov rax, 1
  .
  .
  ```

+ Now it will work perfect.

brit / ame