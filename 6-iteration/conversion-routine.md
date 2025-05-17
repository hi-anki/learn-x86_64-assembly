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

## Task 2: Integer To String Routine

### High-level Overview

+ **Step 1**: We need to obtain individual digits from the number.
+ **Step 2**: Add '0' to each of them.
+ **Step 3**: Form the original digit by combining the individual digits obtained.

----

Let's do this.

We have received the resultant number as 123.

**Step 1**: Allocate a buffer to hold the result of the conversion.
  - A 64-bit register can hold up to ~18q unsigned values, which comprises of 20 digits. And we need ony byte for the null-character. So 21 digits as all you need. But here we know that it is going to be 3-bytes long + 1 for \0. So lets allocate 5 bytes.

**Step 2**: Repeatedly divide the number by 10 to obtain individual digits.
  - Iteration 1, 123/10, remained = 3
  - Iteration 2, 12/10, remained = 2
  - Iteration 3, 1/10, remained = 1
  - **Note: The digits are in opposite positions.**

**Step 3**: Add '0' to every digit.

**Step 4**: Since the digits are in opposite order, we have 2 choices.
  1. Store the digits from the end of buffer backwards, then reverse the pointer at the end.
  2. Store the digits in same order, and reverse the string before printing.

**Step 5**: Add a null-character, `0x00` in the end.

To prevent the confusion of registers, lets define which register we are using for what purpose.
  - `rax`, to store the integer number (or dividend).
    - We are chosing rax because we have to perform division and `div` operation by default divides the value in the accumulator pair.
  - `rcx`, to store the divisor, which is 10, always.
  - `dl`, to access the remainder, as it is stored in rdx.

## Problem!

Checkout the code [here](conversion-routine-2-doesnt-work.asm).

This code is functionally incorrect. That means it shouldn't work?
  - That's not the case.
  - Either it will not work at all, or it will work just as fine.

But, if it is working, how it is bad?
  - The simeples answer is undefined behavior.
  - But this answer is like saying "Oh, its an exception in organic chemistry!"
  - If you go about understanding, you'll find the perfect reasoning behind it.
  - While I am not an expert. I am just like you. But I will not stop here. I will explain you the why behind this undefined behaviour.
  - But this is going to be a long journey. It took me several hours, spanned across 2 days to fully comprehend the problem and write this explanation. It still might not be correct, but this is all that I have found on my own.
  - Lets debug this.

----

# Debugging The Code

We will start with basic debugging.

Debugging is basically the process of finding and fixing errors in softwares.

There are standard programs like `gdb`, but we are not going to use them.

We are going to start with some manual work and then we will build upon it.

## Step 1, Isolate The Potential Source Of The Problem

The first step in debugging any piece of code is to isolate the potential problem.

You might say that "the problem is not always clear. And sometimes, it is the problem we are trying to find, before we can search for a solution."

Absolutely right. I think it's not clear yet. Let's first set our objectives.

**Goal**: *Identify the regions in code, where the problem might exist*.

A piece of code can be easily flagged as "harmless" or "potential" on the basis of two things. These are familiarity and context.
  - I never did anything meaningful in any high-level programming language, therefore, I am not sure about how much context matters in them, but here it is inevitable.
  - So familiarity is basically the part of code which never changes or remains always like "that way" only.
  - For example, to make a `write` syscall, we always have to set rax and rdi with 1. What changes is how rsi and rdi are set. But you'll never ever in any circumstance notice a different value in rax and rdi making for a `write` syscall. And that is familiarity in action.
  - Now comes the context. As of now, if you don't now this, you aren't learning assembly.
  - Context is the setting in which a particular action will work. Two actions, completely different, might still do the same thing, but the context is what that differentiates them.
  - For example, recently we have learned about calling conventions.
    - There we have read about how syscall expects registers to be aligned when it comes to passing arguments to the syscall.
    - For some valid reasons, we know that rcx can't be used to hold any value in a syscall. Because it gets clobbered or overwritted. But rcx is valid in a function call.
    - Here, where is rcx used matters more than how it is used. Because that will solely define if it will do what it is supposed to do.
  - We can easily find the context in which we are in, and then we can try to match if the way we are trying to achieve it aligns with context or not.
    - For example, `offset` is an assembler directive and works only with GAS, "assembler choice" is the context here. If you assemble it with masm, it might not work. And this becomes a potential for debugging.
    - The same `offset` directive is an assembly-time thing. It can load static or global data defined in data section. But if you used it to load something thats defined in bss section, you are welcoming an undefined behavior. And here, "time" becomes the context.

Lets isolate the problem.
  - The `_start` and `convert_loop` labels seems to be correct, because we have write the same thing before as well.
  - Also, the undefined behavior (depending on your case) also shows that they are working fine.
  - The whole problem lies within the `done` label.
  - `done`, although is basically a write syscall, but it can be divided b/w setting up the arguments (rsi and rdx) and setting up rax and rdi.
  - If you notice, we always set rax and rdi to 1 in a `write` syscall. Therefore, we can flag it harmless.
  - That means, the problem is somewhere around these 3 lines:
    ```asm
    mov rsi, rdi
    mov rdx, result_buffer + 4
    sub rdx, rdi
    ```
  - Great. The first step to debugging is accomplished.

But how you come so sure about isolating it the right way?
  - Great question and must be answered.
  - If you notice, rdi has been manipulated a lot inside the `_start` and the `conver_loop` labels. It is highly probable that `rdi` has been mishandled.
  - Line 2 in the above snippet is fundamentally wrong. And the reason boils down to assembly-time and runtime aspects. I'll explain it later. But this line is not right at all.
  - Lets assume that line 2 is correct. It is highly posible that the subtraction operation is not carried out the right way. Or, it is not the right fit for what we are trying to achieve, calculating the length of the buffer.
  - These are enough reasons to mark the above code piece as potential, not harmless.

Now we can move to step 2.

## Step 2, Isolate The Possible Problems

**Progress Status: We have isolated what might be the source of the problem. The problem itself is still not known.**

**Objective:** *Stress test the potential source, obtained in step 1 and try to isolate the problem further.*

Lets look at the `sub` operation.
  - It just subtracts what's inside the resgiters.
  - Does it control what's inside those registers? Precisely NO.
  - Then how can subtraction be the point of failure? Good question!
  - That means, the problem lies in how the registers rsi and rdx are set.

Lets revise what rsi and rdx are meant for, in this context.
  - `rsi` is responsible for holding the memory location which has to be written on the terminal.
  - `rdx` is responsible for holding the length of the buffer that is about to be written.

**Have you wondered why rdx is needed at the first place? When we already have the buffer, why do we have to pass the length of the buffer along side?**
  - Don't worry. By the end of this, you'll have your answer.
  - Just to hint, this is not the actual problem, but this the eventual problem.
  - Sit tight and enjoy the ride.

So now the problem can be either of the two, 
  1. how the registers rsi and rdx are set, or,
  2. the value that is inside these registers.

But what are the basis of your reasoning?
  - You are right to question this.
  - We are already sure that the registers aren't clobbered or wrong all the way. We are setting the right registers.
  - We are setting rsi via rdi. As per the code, rdi must contain the pointer to the start of the buffer. But who guarantees this? I can't. This implies that rsi might not contain the right memory address!
  - When we are setting rdx, we are using the label along with the default byte-length. Then we rely on subtraction operation for calculation of actual buffer length. Is our assumption about rdx pointing to the end of the buffer actually correct? It seems, but "seems" can't verify this.
  - I think this is enough reasoning to prove that our assumption about what could possibly be the problem is right.

Now we can move to step 3.

## Step 3, Stress-Test The Source For The Possible Problems

**Progress Status: We have identified the potential source of the problem and the possible set of problems.**

**Objective:** *Now we have to stress-test the source for these "possible problems".*

How we are going to do that?
  - Since this is not a high-level language, writing printfs is not a solution. Even writing `write` syscalls is not the solution I want to go for. Because it complicates the already complicated code further.
  - But what exactly a `printf` would do in debugging?
    - We would use it to display what our variables actually contain before and after an operation.
    - If it contains the right value, we can shift towards other instructions.
    - But if they contain a value which is wrong, we have intercepted the core issue. Now we have to identify the source of it. Thats' it.
  - That means, we are only concerned about seeing what's in rsi and rdx in different scenarios, which we will talk about later. Right?

  - Every process, when exits, leaves a exit code behind, which defines the status of whether the process was a success or a failure.
    - Remember `return 0` in C, in the main() function. It is meant to tell that the process completed successfully.
  - If you have noticed, we always xor the value in rdi. That's because, 0 denotes a successful completion.
  - If we can put the value in these registers into rdi of the exit syscall, we can see what's in them. Does that make sense?

We are gonna do that using `r8`, because it has no purpose here.

Checkout [cr2-v1.asm](./debug-cr2/cr2-v1.asm).
  - There are two new instructions at line 35 and 44.
    ```asm
    mov r8, rdx         # Line 35
    mov rdi, r8         # Line 44
    ```
  - First of all, we have still kept the xor instruction because I don't want anything garbage in rdi.

Perfect. The playground is set now.

Before doing anything, what we are testing for?
  - We are interested in seeing what does rdx contains after these two operations.

What we are interested to see?
  - Time will tell.

Now, no more talks.

  - If you are assembling using the custom assembler script, use `-ec` flag to get exit code printed on the console.

  - If you are using `as` and `ld` directly, do `echo $?` after running the binary, to get the exit code of the last process.

"We got 0, How? It should had 4, right?" There is more to it.

Since we are going to test it rigorously, lets create a table. Test the binary for all of this points and note the result.

| Test Point  | Exit Code        |
| ----------  | ---------------- |
| result      | 123Exit Code: 0  |
| result + 0  | 123Exit Code: 0  |
| result + 1  | 123Exit Code: 49 |
| result + 2  | 123Exit Code: 50 |
| result + 3  | 123Exit Code: 51 |
| result + 4  | Exit Code: 0     |
| result + 5  | Exit Code: 0     |
| result + 20 | Exit Code: 0     |

> Strange!

Lets probe for rsi. Checkout [cr2-v2.asm](./debug-cr2/cr2-v2.asm)

Execute the binary and check the exit code.

"1"? What is 1?

Even if you add multiple `inc rdi` before the `jmp done` instruction, you will get 1,2,3,4..... no matter how far you will go.

On the contrary, if you add multiple decrement statements, instead of increment, the values will get wrapper to 255 and go below it.

Assuming that 1 represents pointer to the 1st byte in the ascii stream, rdx should represent the last one. And when subtraction occurs, we get the desired length of the buffer. Just as we though.
  - But the table above tells a different story.
  - This clearly signifies that this operation, `mov rdx, result_buffer + 4` is incorrect.
  - According to this statement, rdx must now hold the pointer to the end of the buffer. And rdi is already holding the start of the buffer. So subtraction will do its job next.
  - The problem is that this is not the right way to load the address of a buffer.

You might ask, how I know this is not the right way to store the address? In many scenarios in the above table, 123 got displayed.
  - If you are indicating that rdi is pointing to a wrong memory location, and this is causing the problem, lets test this assumption as well.
  - Let's manually hard-code 3 in rdx. If 123 is dispayed, and 0 as exit code, this proves that this is not the problem.
  - Run the binary.
  - You got 123?
  - Still not satisfied? Run the binary with rdx as 2 and 1. Got only 2 and 1?
  - This proves that rsi is set right.

Now, it is certain that the problem is with how rdx is being set.

If you notice the exit codes in the table, you will find that we get 0 for 1st two points, which are basically the same.
  - But we shouldn't have 0. Why?
  - That 0 represents that nothing is even passed in rdx. How?
  - If you notice above, the loop is exited only when there is no more digit in accumulator or rax. Repeated division has already zeroed rax.
  - Run [cr2-v4.asm](./debug-cr2/cr2-v4.asm). Still got 0?
  - This is where the undefined behavior was stemming from.

Okay. The story is clear now. We know that the `mov rdx, result_buffer + 4` instruction is wrong. This gave birth to an undefined behavior. But why it is wrong?
  - The move instruction is meant for moving values. That's it.
  - When you write an immediate like 45, it is directly placed in the register/memory-location.
  - When you pass a memory location, that memory location is stored in the register.
  - If you pass a dereferenced memory location to a register, it will access the value at the location and put it in the register.
  - `result_buffer` refers to a memory location. Adding 4 to it means we want to access the the 5th-byte from the `result_buffer` offset. Nothing is wrong in this.
  - Absolutely.

The devil is in the details.
  - We already know about assembly-time and runtime contexts.
  - When we label a memory, it is just an assembly-time constant, or more specifically, a symbol.
  - A symbol gets resolved to a virtual address. It is not necessary that at runtime, the same location is alloted to the buffer.
  - Therefore, it is important to retreive the effective address of the labelled memory. The address which is assigned to it at runtime. At runtime, CPU is the king. Assembler can't do anything.
  - The assembler resolves anything that is could to a proper memory location, before it is actually ran.
  - So as with `mov rdx, result_buffer + 4`. rdx is perfectly assigned the 5th-byte here.
  - But the problem is, you don't know where it will be allotted in memory. But here we are using it. So assembler assigns it a virtual address. But there is no guarantee that it would get resolved.

## Solution?

Just replace mov with lea. And we are good to go. That's it. That's our solution.

`lea`, which stands for **load effecive address**, is a CPU instruction that computes an address and stores it at a memory location, without actually accessing the memory.

```asm
lea dest_reg, memory_computation
```
**Note: [] do dereferencing but when it comes to lea, they don't.**

Also,
```
mov rdi, offset label

lea rdi, [rel label]
```
> are the same things, except that offset is an assembler directive and does things on assembly-time while lea does things on runtime.

# Conclusion

A big writeup, just to say, "replace mov with lea".

You know how easy it is to say, "replace mov with lea". But it is immensely hard to justify why.

Each time I look at this problem, a new question arises in my mind.

The first time when I had this, I even went into linker maps to understand why this code is messed up. But in the 2nd run, when I am writing this, I found that it is not really required.
  - It definitely explains the more fundamental thing that labels are just named memory locations.
  - Even if a label's bounds are logically ended, and if you still continued to access the memory, no one's gonna stop you. No one is help responsible for this job, except you, the programmer.
  - And linker map showed this exactly.
  - It proved why bounds are specially imposed. They don't exist, because there is no reason for them to exist.
  - But I think that's a story we should keep for the next time.

I have tried my best. I might still be wrong at some place. And if a senior and more experienced person is reading this, feel free to correct me.