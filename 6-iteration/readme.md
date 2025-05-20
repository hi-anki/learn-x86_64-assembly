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

Let's see how does a basic loop structure would look like in assembly.

```asm
_start:
  mov r8, 0                       # Loop Variable

loop_start:
  cmp r8, 10                      # Condition
  jge loop_exit                   # Jump to exit if r8 becomes greater than or equal to 10

  # Loop Body
  # Do Something with r8

  inc r8                          # Increase the value in r8 by 1
  jmp loop_start                  # Jump to the start of the loop

loop_exit:
  mov rax, 60
  xor rdi, rdi
  syscall
```

All of use are coming from high level languages and we have seen `for` and `while` in action. If you are coming from C and Java, you might have also used a `do-while` loop.

On outer-side, these loop structs seems to work differently. And this is kinda how we are taught at the first place. For example -
  - We are taught that `for` loop is generally used in cases where the number of iterations are finite and they are know.
  - On the other hand, `while` loop is used when number of iterations are either finite but not known or they are finite.
  - Our learnings can differ, but one thing is sure that when it was the time to write an infinite loop that just had a single break condition, we all would have preferred a `while` loop. For example:
    ```c
    while true{
      // body

      if (break_condition_met){
        break;
      }
    }
    ```
  - But that same thing can also be done using a for loop.
    ```c
    for (;;){
      // body

      if (break_condition_met){
        break;
      }
    }
    ```
  - Most of the time, we have used increment/decreement operations to increase/change the iteration. And this also kinda matches to the definition of for-loops we had above.
    - But take this, you have to find the number of digits in a number, let's say, 85821. It is simple.
    - Repeatedly divide the digit by 0 and keep counting. Once the quotient becomes 0, we have reached to the answer.
    - And I never dared to write this in a for loop. Because my worldview was always limited to the fact that for-loops mark the change in iteration only by incrementing/decrementing by 1.
    - But when I asked ChatGPT to do it, it gave me the for loop equivalent as well. And that's when I was a little shocked.
      ```c
      int num = 85821;       // Assuming the number to always be non-zero
      int digit_count = 0;
      while true {
        num /= 10;
        digit_count++;

        if (num == 0){
          break;
        }
      }
      ```
      ----
      ```c
      int num = 85821;       // Assuming the number to always be non-zero
      int digit_count = 0;
      for (;;){
        num /= 10;
        digit_count++;

        if (num == 0){
          break;
        }
      }
      ```
    - Again, how you have been taught programming governs your perspective. But this one question made me realised that all the loops are fundamentally the same thing. Just the high level construct differs.

And assembly exposes the underlying functionality preety neatly. You can see yourself that this is how a loop basically looks like. That's it.

Now it's time to do some work.

## The Problem!

Last time, when we did basic arithmetic, we have added '0' to make the result ASCII-compatible. But this time, it can't work as we have multiple digits.

Exactly. Now we are going to solve this problem forever.

[Come here](./conversion-routine/readme.md)

## Now, we are ready to ASCEND!

The time has come to make our fully functional two operands calculator.