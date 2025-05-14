# Iteration, Loops......

Lets do this fast so that we can see those arithmetic rules we are learning so far in action.

There are no for, while, or do-while constructs in assembly. But you can build all of them using:

  - Labels,
  - `cmp` for comparing,
  - Conditional jumps after comparisons,
  - Registers as counters or iterators, and
  - inc / dec / add / sub to change loop variables

It is going to be fun and interesting.

## Scopes

High level languages have local and global scopes. Local scope is available within a block of code, like a function. And a globally scoped variable is accessible across the file.

Every assembler has its way to make labels scoped. Right now, all labels we have written so far were globally scoped. To make a label locally scope, prefix it with a period (`.`). Simple.

Now it is the time to make some loops.

## An Iteration

Lets remember what an iteration or a loop is.

It is a construct through which we can repeat tasks *n* number of times.

To do this,
  1. we need to separate those tasks (loop body),
  2. we have to define how many times we have to repeat them (number of iterations),
  3. what is the condition on which repeatition will end, or how the loop will come to an end (break condition),
  4. a marker to denote repeatitions (count variable).

A simple for loop in C looks like:

```c
for (int i = 0; i < 5; i++){
  // loop body
}
```

> Here, i is that counter variable and i++ is the marker of repeatitions.
> i < 5 is the break condition.
> `int i = 0; i < 5;` together defines the numbe rof iterations.
> And we have the loop body for defining the tasks.

## Enough, Assembly Now!

A basic loop structure in assembly looks like this ->

```asm
start_loop:
  # loop body
  jmp start_loop
```
> This is similar to a while True loop, which is an infinite loop.

Lets practice man. Enough of theory.

## Print "Hello, World!\n" 5 times

The program is written now, but it works like an infinite loop.

```asm
.intel_syntax noprefix

.section .data
  msg: .ascii "Hello, World!\n"
  len = . - msg

.section .text
  .global _start

  _start:
    # counter variable
    mov rcx, 0

    .loop_start:
      # break condition
      cmp rcx, 5

      # _if rdi becomes 5, exit
      je exit

      # _if lesser than 5, then print
      mov rax, 1
      mov rdi, 1
      mov rsi, offset msg
      mov rdx, len
      syscall

      inc rcx
      jmp .loop_start

    exit:
      mov rax, 60
      xor rdi, rdi
      syscall

```

I get it that we have used rdx because rax, rdi and rsi were already employed. I tried rcx and it also didn't worked. Why?

And when I used a completely random register, like r8, it worked. Then I also remembered about rbx and it also worked. Why and how?

The answer is conventions. Lets come [here](./conventions.md)