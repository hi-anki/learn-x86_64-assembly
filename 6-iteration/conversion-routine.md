# Integer And ASCII Conversion Conflict In Arithmetics

## What Is The Problem?

We want to perform arithmetic on numbers, but the user input is in ASCII characters (e.g., '3' is 0x33), not the literal numeric value 3. 

## Why This Problem Exists?

I have pressed on 3, not '3' or 0x33. The why I am getting this?

There are not just numbers, but characters (like alphabets), special characters (like $), sentences (stream of characters), and special characters we can't see like ENTER, which represents newline character.

But we know that computer don't understand these. These are for us. We give meaning to them.

In unsigned and signed conflict, saw that the same binary stream of 0s and 1s can represent a +ve number and -ve number. But this is assigned by us, governed by us. Computer does what we tell it to do. It inherently can't distinguish.

When we take input from the terminal, having multiple type identifications is just inefficient. There is no structured way to have a proper solution.
  - A string can contain everything. What will you identify it as?
  - When you type 9, you have to press ENTER to send it. Will that ENTER magically disappear?

This is the reason why console inputs are always treated as raw-bytes. And these raw-bytes are represented in ASCII-format. Not the only format, but the most accepted one.

This problem exists to compensate for the communication gap between humans and CPUs.

## The Solution?

Convert b/w ASCII and integer representations as required.

## The Possible Solutions?

Before jumping to solutions, its important to reinforce one statement.

Everything is fine, as long as the context is justified.

Each solution to a problem in assembly is good until the context is strictly-kept in mind. Once you are out, you are on your own.

Lets understand the possible solutions and *the contexts in which they are possible*.

### 1. Digit-By-Digit Handling

Simplest Method!
  - You read a single character, like '3',
  - subtract '0' to get 3,
  - do the math,
  - add '0'
  - print.

**Context**: Good for simple demonstrations. Very basic I/O routines.

**Tradeoffs**: No scaling possible. Not very practical

### 2. Proper Routine For Conversion

A full-size routine,
  - that takes a stream of integers,
  - parses it to integer, and
  - reparses the result into a stream of integers.

**Context**: Full practicality.

**Tradeoffs**: None. But if you fear complexity, then yes, a little complex to write.

### 3. Raw Binary Dealings

No conversion, full efficiency.

**Context**: Internal calculations that need no user interaction. Performance-critical logic.

**Tradeoffs**: Not user-friendly.

----

Clearly, solution #2 seems to be the right fit for most of the general-purpose programming.

But we will definitely implement solution #3 as well. For now, here is solution #2.

# Conversion Routine

This whole routine can be divided into 2 tasks. Lets assume we have input 123.

  - **Task 1**: Convert "123" to 123.
  - Do your arithmetic.
  - **Task 2**: Convert the integer result to string result.

Fundamentally, we are going to do exactly the same thing we did so far.
  - Subtracting '0' from the input.
  - Adding '0' to the result.

What is going to change is we are going to loop this process for every single digit.

## Task 1: String To Integer Routine

### High-level Overview

+ **Step 1**: We need to obtain individual digits from the stream of digits.
+ **Step 2**: Subtract '0' from each digit.
+ **Step 3**: Form the original digit by combining the individual digits obtained.

----

Now, let's do this.

We have taken the user input and we have received "123".

Also, we have chosen rbx to store the number. Make rbx 0.

+ **Step 1**: Iterate through each character in the input.
+ **Step 2**: Subtract '0' from each digit to get the actual digit.
+ **Step 3**: Multiply the register (rbx) by 10 each time to obtain the weight.
+ **Step 4**: Add the result of each iteration to the register (rbx) to obtain the actual number.

Why to multiply by 10?
  - If you want to obtain 123 from individual 1, 2 and 3, how will you do that, mathematically?
  - Recall number system. Each position has a weight attached to it. The weight for any position can be calculated by raising the index to the power of base.
  - By this definition, 123 = 1*(10^2) + 2*(10^1) + 3*(10^0)
  - We get, 100 + 20 + 3 = 123.

  - In first iteration, we'll get 1. Multiply `rbx` by 10, we get 0. Add 1 to `rbx`. Final value in `rbx`, 1.
  - In second iteration, we'll get 2. Multiply `rbx` by 10, we get 10. Add 2 to `rbx`. Final value in `rbx`, 12.
  - In third iteration, we'll get 3. Multiply `rbx` by 10, we get 120. Add 3 to `rbx`. Final value in `rbx`, 123.
  - Done.

Here is the conversion routine:
```asm
.intel_syntax noprefix

.section .data
  input_str: .asciz "123"

.section .text
  .global _start

  _start:
    lea rsi, input_str
    xor rbx, rbx

  parse_loop:
    movzx rcx, byte ptr [rsi]

    # test rcx, rcx
    cmp rcx, 0
    je parse_done

    sub rcx, '0'
    imul rbx, rbx, 10
    add rbx, rcx

    inc rsi
    jmp parse_loop

  parse_done:
    mov rax, 60
    mov rdi, rbx
    syscall

```

  - Most of the things are familiar here, except `test rcx, rcx`.
  - Also, why we are using null terminated string (`.asciz`) and not new-line ended string?

`test rcx, rcx` checks if the current character is 0. If it is, it sets the "Zero Flag" and rcx remains unchanged.
  - By the way, `cmp rcx, 0` does the same thing.
  - But test is preferred over cmp when it comes to checking zero-ness. The simplest answer is, it is a little more efficient.
  - Just like doing `xor rdi, rdi` in a exit syscall is more efficient than moving a literal 0 in rdi, test is for checking the presence of zero-ness.

Now about \n and \0.
  - Strings inherently have no length.
  - This is the reason why we pass the length of the buffer in syscalls involving strings.
  - Either we should manage the length ourselves, or we outsource it.
  - Managing length is not a big task until scaling comes into picture. When you will be managing 10 separate strings, you'll understand the hustle of managing 10 pointers and 10 lengths.
  - Outsourcing helps here. If we can add something to mark the end of the string, we need not to worry about lengths anymore. We just have to iterate till that character and we done.
  - If you notice, `\n` is a valid character. We use it to "separate lines". Also, it is used to finalise the input, "marking the end of the input" not marking the end of the string itself.
  - Suppose you entered "abcd\npqrs" and press ENTER. If you relied on `\n` for ending a string, `pqr` would get discarded.
  - That is why we use null-terminated strings whenever it is about logic.
  - The null-character, or `\0` is not someone would actually use or the system would inject on key-press. It has no real use. And that is why it is suitable for marking the end of a string.

Task 1 completed.