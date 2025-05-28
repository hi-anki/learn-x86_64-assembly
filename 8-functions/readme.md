# The Problem

Now I know about if-else and for-while in assembly. But there were some problems that I have faced when I was writing that capstone project.

Jump statements don't work exactly like if-else. They don't have any return context. They are completely **forward-only**.

If want to jump back to the exact instruction I came from, I can't do that. Jumps are absolute. Once I jump, conditionally or unconditionally, I will find myself at the start of the label.

Since there is no backward movement, code once written can't be used again. When multiple registers are needed, I need to write that same code and just change the register part. This leads to the violation of DRY. I have to write the same parser code two times because of this.

If I want to add more functionality, for example -:
  - Factorials,
  - Exponentiation,
  - LCM,
  - HCF,

I can only imagine the junk there will be.

So, what's the solution?

Loosely, when I call a function in C:
  - The arguments are passed (on stack or in registers)
  - The return address is stored (where to resume after function finishes)
  - The function allocates space for local variables
  - The function does its job
  - The result is returned (in a register)
  - The original context is restored, and control returns.

In assembly, as I know already, I have to do this by myself.

# Introducing Procedures

In simple words, just a label, but with return context.

A procedure is a named, reusable block of code that performs a specific task, can accept input (arguments), and can return a result — while managing control flow and memory context safely.

It is exactly what functions are in high-level languages like C, and Python.

## But How Is It Different Than A Label?

| Label               | Procedure                              |
| ------------------- | -------------------------------------- |
| No return mechanism | Always returns to caller (`ret`)       |
| No argument passing | Receives arguments in registers        |
| No structure        | Has prologue and epilogue              |
| Not reusable safely | Designed for reuse across the codebase |
| Breaks DRY          | Enables abstraction and reuse          |

Basically, a procedure is a disciplined label.

Procedures solve the biggest problem in labels, which is, lack of context.

## Anatomy Of A Procedure

A procedure is composed of four core components:
  1. Procedure Header (label)
  2. Prologue (entry setup)
  3. Body (the actual logic)
  4. Epilogue (cleanup and return)

### 1. Procedure Header

This is simply **the label**, but, with a purpose.

A procedure (label) isn't jumped, it's called. That's another notable difference.

### 2. Prologue

Prologue is about setting up those things which makes a label different than a procedure.

It is about setting up the stack frame for the procedure. It includes:
  1. Saving the old base pointer.
  2. Creation of new base pointer.

### 3. Body

The code body, just like a label.

### 4. Epilogue

A procedure is called, therefore, it must return where it was called from. Also, the stack frame must be cleared after the use is completed.

This is the job of epilogue.
  1. Restore the base pointer
  2. Go back to the return address

This a high-level overview of a procedure's liefcycle.

# Stack

A stack is a data structure that operates on **Last-In, First-Out (LIFO)** principle.

But when we talk about stack in context of memory, it is not just an abstract idea, implemented on software level.

We're referring to a dedicated, reserved region in the memory, that behaves like a stack — at the hardware level.

The top of the stack is always accessed via the "stack pointer register" (or `rsp`).

Stack pointer movement is *word-aligned*. It means that memory addresses used are in multiple of 8.

Word in terms of CPU refers to the width of registers, which, in x86_64 is 64-bits. 

But in case of assembly, it is a little different.

| Term      | Size    |            |
| --------- | ------- | ---------- |
| **byte**  | 8 bits  |            |
| **word**  | 16 bits | or 2 bytes |
| **dword** | 32 bits | or 4 bytes |
| **qword** | 64 bits | or 8 bytes |

## Stack Frame

A stack frame is a well-defined chunk of the stack that belongs to a single procedure call. It's like a workspace that's created when a procedure starts and is destroyed when it finishes.

When a procedure is called, a stack frame is created to hold:
  - The return address
  - The previous base pointer (rbp)
  - Space for local variables
  - Possibly saved callee-saved registers

# Pointer Registers

Registers whose canonical use is to store pointer to memory locations.

They can be used for general purpose but when I am doing something that involves **System V ABI's calling conventions**, it is important to use them for what they are meant for, in the convention.

| Register   | Use Case                     | Canonical Use-Case                               |
| ---------- | ---------------------------- | ------------------------------------------------ |
| `rsi`      | Source Index Register        | Pointer to the source                            |
| `rdi`      | Destination Index Register   | Pointer to the destination                       |
| `rsp`      | Stack Pointer Register       | Pointer to the top of the stack (volatile)       |
| `rbp`      | Base Pointer Register        | Pointer to the bottom of the stack frame (fixed) |
| `rip`      | Instruction Pointer Register | Pointer to the next instruction                  |

`rsi` points to the start of the memory buffer which is being used in the current memory operation.

I have used `rdi` for storing file descriptors. If I recall, a file descriptor is basically the destination of the syscall. For example -
  - A `write` syscall, which is used to write to the terminal, uses 1 as file descriptor. Here, 1 reflects the console as destination of the operation.
  - A `read` syscall, which is used to take read input from the terminal, uses 0 as file descriptor. Here, 0 reflects the console which is the point where the input would be taken from.

`rsp` is the stack pointer. It is meant for storing the top of the stack.
  - Remember having `top` pointer in C, when I was writing simple stack implementation using arrays? `rsi` is the same thing.

Constant `push` and `pop` operations makes `rsp` volatile to store the base of the stack, which is the first thing in the stack. Assume the base as the first element in an array, which is meant to mimic a stack.
  - Remember doing `top++`? Initially, top was at -1. Doing `++` makes it move to the next byte (1, 2, 4, 8; depending on the data type).
  - Now `rsi` is meant to store the `top`. It has nothing to do with the bottom. Even `rsi` don't know it is storing the top of a stack. It is just storing a memory address.
  - What if `rsi` is decremented so much that it passed the stack frame? There is no guardrails, because there is no need for them. Memory is flat.
  - How will I know I have reached the bottom of the stack?
  - There has to be something, that is fixed to the bottom of the stack, beyond which, the stack frame is no more.
  - This gives birth to `rbp`, which is the base pointer of the stack.
  - Take this, `rbp` stores the bottom of the current stack frame, while `rsp` stores the top of the current stack frame.
  - They both are relative to the current stack frame.

- `rip`, on the other hand, is the global instruction pointer.
  - It stores the pointer to the next instruction to be executed, regardless of being inside a label or a function. It is always active.
  - It is read-only, for obvious reasons.

# Memory Layout And Stack Mgmt

```
Low Memory
+------------------------+
| Text (code)            |
| Data (globals)         |
| Heap                   |
|                        |
|   (free space)         |
|                        |
| Stack                  |
+------------------------+
High Memory
```

From the analogy of a "stack of plates," I know that a stack of plates grows upwards, for logical reasons. But stack in memory grows downwards, why? To answer this, lets understand stack management.

## Sample Code - `square(n)`

```asm
.intel_syntax noprefix

.section .text
.global _start

square:
  push rbp
  mov rbp, rsp
  mov rax, rdi
  imul rax, rdi

  mov rsp, rbp
  pop rbp
  ret

_start:
  mov rdi, 5  
  call square 
  mov rdi, rax
  mov rax, 60 
  syscall

```

## Memory Layout Assumptions

```
Lower Memory
----x---x----

0000
0008
0016
0024
.
.
.
.
0976
0984
0992
1000

----x---x----
Higher Memory
```

The stack grows downwards, from higher memory address to lower memory address. This means, the top is at 1000 and it would grow towards 0000.

```
Lower Memory
----x---x----

0000        <-- The Lowest rsp Can Go
0008
0016
0024
.
.
.
.
0976
0984
0992
1000        <-- Top Of The Stack (rsp)

----x---x----
Higher Memory
```

## Meaning Of `push` And `pop`

`push`:
  - Subtracts rsi, word-aligned, i.e `rsp--` or `sub rsp, 8`, to make space for the value to be put on the stack.
  - Dereference rsi and put the value at that location, i.e `[rsi] = imm/reg` or `mov [rsi], imm/reg`

`pop reg`:
  - Dereference rsi and move whatever there is to `reg`.
  - Move (or add) rsi, word-aligned, i.e `rsp++` or `add rsp, 8`

## Map The Procedure With Prologue And Epilogue

```asm
.intel_syntax noprefix

.section .text
.global _start

square:
  push rbp            # prologue start, save old base pointer
  mov rbp, rsp        # establish new base pointer, prologue end

  mov rax, rdi        # copy argument to rax
  imul rax, rdi       # rax = rdi * rdi
  pop rbp             # epilogue
  ret                 # return rax, the default place for for return

_start:
  mov rdi, 15         # argument: n = 15
  call square         # call the procedure, push the return address on stack
  mov rdi, rax        # move result to rdi for exit
  mov rax, 60         # syscall: exit
  syscall

```

## Step 1: Call The Procedure

Calling a procedure does three things:
  1. Set the instruction pointer register (`rip`) to point at `square` label,
  2. Make an unconditional jump to square, and
  3. Push the return address to the stack.

Therefore, the first thing that goes on the stack, or the lowest plate in the stack of plates is the "return address."

## Step 2: Inside Prologue

Here we set up the stack frame for this procedure.

The first thing we do is to push the old base pointer on the stack.
 - This is done to save the base pointer of the caller, which is the second plate on the stack.

Next we have moved rsp into rbp.
  - Our stack has the old base pointer as the second item and this is where the next stack frame is starting.
  - We are saving rsp into rbp so that we can mark the start of the new stack frame from here.
  - This makes `rbp` pointing at the first thing in the stack, and this is our new base pointer, for this particular stack frame.

## Body 

Leave the arithmetic part.

## Step 3: Inside Epilogue

Here we do the cleanup.

First we mov rbp into rsp.
  - This is done to make sure that the stack is now pointing to the second element.

Next we pop rbp. This is important.
  - `rbp` for the current stack frame points to the old base pointer.
  - Popping `rbp` saves the old base pointer in `rbp`.
  - And now the rsi is pointing at the return address, ready to go back to the previous context.

Last, we do the return. `ret` means:
  1. `pop rip`, 
  2. Dereference rsi, store it in rip, and increase rsi.

We are back into the old stack frame, we have made the return to the previous context, what else is left? We have learned functions in assembly.

## Upcoming Conflict

Stack grows downward, but the pointer arithmetic we are doing, to access everything on the top of the stack is using +, not -.
  - `rbp + 8` is giving us the return address.
  - `rbp - 8` is giving us the locals.
  - And `rbp + 16` onwards we get the arguments pushed on the stack.

What the heck is happening!
  - Locals are the values that we push to the stack inside a procedure.
  - Space has to be reserved so that they can be stored and accessed properly.
  - The first 6 function arguments comes in the form of registers, if they exceed, they go on stack, from [rbp + 16] onwards.
  - The problem is how the stack is structured inside the memory vs how we interpert it.
  - "Stack grows downwards" is the biggest problematic statement about stack, in my opinion. It forces me to invert my thinking about stack.

According to memory, stack grows like this:

```
Higher Memory
----x---x----

1000        <-- Top of the stack, rsi
0992        <-- return address
0984        <-- old base pointer
0976        <-- Locals
.
.
.
.
0024
0016
0008
0000

Lower Memory
----x---x----
```

For every push, `rsi--` happens, and for every pop, `rsi++` happens.

Functionally, return address goes first and then goes the old base pointer.

After this comes function arguments and local variables.

The case with function arguments is that if they are less than 7, they go in their individual registers. If they exceed the mark of 6, the rest of the arguments go on the stack, which is functionally below rbp or 0984.

Conceptually we say that word-aligned addition to rbp gives access to arguments, while word-aligned subtraction to rbp gives access to locals.

The problem is they are functionally the same thing. Just their interpretation makes them complicated.

To store locals, you have to reserve space, by subtracting rsp. This is done because if there are more than 6 arguments, they go on stack. And this magic of managing stack happens automatically. So the rsi is pointing at those arguments and not on rbp, which you can reduce and do the thing.

Mathematically,
  - we are still doing [rbp - 8] to access the 7th argument. Because that's where it lives, i.e at 9976.
  - If there is no 7th argument, and there is a local, we are still doing [rbp - 8], because that's where it lives, i.e at 9976.
  - If there was both an argument and a local, the rsp would point at 9976, and subtracting 1 time will make space for a local, and the local would be at 9968.
  - According to pointer arithmetic, addition gives access to arguments while subtraction gives access to locals. This is the thing.
  - Mathematically, we are doing the same thing, subtracting from the offset.