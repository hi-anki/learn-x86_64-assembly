# The Problem

Now I know about if-else and for-while in assembly. But there were some problems that I have faced when I was writing that cpastone project.

Jump statements don't work exactly like if-else. They don't have context, basically.

There were times when I seriously questioned, "why jump statements only work well with forward movement?"
  - Because if I came from a label and I want to jump back exactly where I came from, I can't do that.
  - Jumps are absolute. Once I jump, conditionally or unconditionally, I will go at the start of the label.
  - While this is the intended fucntionality when it comes to non-tangled code, but when the code is deeply tangled, and each label is calling others, it is so hard to maintain that "backward-ness". I still fully can't articulate what I am trying to say, and I genuinely need a high-level C example, to convey what I am trying to say. But I still don't have any.

And this gave rise to another problem. Violation of DRY.
  - I have repeated same code multiple times because I just don't know how to resuse code.
  - Just look at parsers. I have to parse two numbers, exact same functionality, except the container registers for storing the result changed.
  - But I can't reuse what I have written for num1. I have to write it separately for num2.
  - And just assume how much the code size will go up, for absolutely no reason, if I just though of implementing a calculator which can tak any number of arguments, both for numbers and operations.

Also, if I just want to add more functionality, for example -:
  - Factorials,
  - Exponentiation,
  - LCM,
  - HCF,
  - and so on....

No problem. I can do that. But I can imagine my code to be a junk of labels and jumps. The reusability thing lacks a lot here. Also, I don't know how to manage registers yet.

So, what's the solution?

Loosely, when I call a function in C:
  - The arguments are passed (on stack or in registers)
  - The return address is stored (where to resume after function finishes)
  - The function allocates space for local variables
  - The function does its job
  - The result is returned (in a register)
  - The original context is restored, and control returns.

In assembly, as I know already, I have to do this by myself.

Let's introduce it.

# Introducing Procedures

Everything problem mentioned above can be roughly equated with "**unstructured code**".

This problem is solved by procedures.

## What Exactly Is A Procedure?

A procedure is a named, reusable block of code that performs a specific task, can accept input (arguments), and can return a result — while managing control flow and memory context safely.

It’s exactly what functions are in high-level languages like C, and Python.

## But How Is It Different Than A Label?

| Label               | Procedure                          |
| ------------------- | ---------------------------------- |
| No return mechanism | Always returns to caller (`ret`)   |
| No argument passing | Receives arguments in registers    |
| No structure        | Has prologue and epilogue          |
| Not reusable safely | Designed for reuse across codebase |
| Breaks DRY          | Enables abstraction and reuse      |

Basically, a procedure is a label with discipline.

A procedure is a labeled code block with a disciplined calling and returning structure.

Procedures solve the biggest problem in labels, which is, lack of context.

## Anatomy Of A Procedure

A procedure is composed of four core components:
  1. Procedure Header (the label + interface)
  2. Prologue (entry setup)
  3. Body (the actual logic)
  4. Epilogue (cleanup and return)

### 1. Procedure Header

This is simply **the label**, but, with a purpose.

A procedure (label) isn't jumped, it's called.

### 2. Prologue

Prologue is about setting up those things which makes a label different than a procedure.

The most important thing here is reserving the base pointer, the instruction I have come from.

### 3. Body

Here I will write the actual code, just like a label.

### 4. Epilogue

A label just jumps to the next thing forward, but a procedure has a context from where did he came. Therefore, it must return to that context.

And as with every return, it is important to cleanup anything being messed up, return anything (if required), so that the instructions can execute properly.
----

With all these, it seems like a procedure is what that gives assembly the kind of structure I see in high-level languages like C and python, where I can actually control the flow of the execution, not just partially.

And this a high-level overview of a procedure's liefcycle.

# Stack && Stack Frame

## What Is A Stack?

A stack is a data structure that operates on Last-In, First-Out (LIFO) principle. I know this already from my basic data structures knowledge.

But when we talk about stack in context of memory, it is not just an abstract idea, implemented on software level.

We're referring to a dedicated, reserved region of memory that behaves like a stack — at the hardware level.

The top of the stack is always accessed via "stack pointer register" (or `rsp`).

Stack pointer movement is *word-aligned*. It means that memory addresses used are in multiple of 8.

Stack grows downwards while heap grows upward.

### Memory Layout

Low Memory
+------------------------+
| Text (code)            |
| Data (globals)         |
| Heap (malloc) ↑        |
|                        |
|   (free space)         |
|                        |
| Stack (grows down) ↓   |
+------------------------+
High Memory

From the analogy of a "stack of plates," I know that a stack of plates grows upwards, for logical reasons. Then why the stack grows downwards?

From my previous knowledge of stack and heap, heap is used for dynamic memory allocation, which I will learn later.

If stack were grown upwards, at some point, it might meet heap, and that can cause undefined problems (collison).

Growing stack downwards avoids a whole class of problem which might arise.

## What Is A Stack Frame?

A stack frame is a well-defined chunk of the stack that belongs to a single procedure call. It’s like a workspace that's created when a procedure starts and is destroyed when it finishes.

When a procedure is called, a stack frame is created to hold:
  - The return address
  - The previous base pointer (rbp)
  - Space for local variables
  - Possibly saved callee-saved registers

# Pointer Registers

I want to cover this topic as a separate thing because this item is confusing if I don't understand it well.

What are pointer registers?
  - The registers whose canonical use is to store pointer to memory locations.
  - They can be used as general purpose registers but when I am doing something that involves **System V ABI's calling conventions**, it is important to use them for what they are meant for in the convention.

Here is a table that maps this information clearly,

| Register   | Role / Use Case              | Canonical Use-Case                    |
| ---------- | ---------------------------- | ------------------------------------- |
| `rsi`      | Source Index Register        | Stores the pointer to the source memory address |
| `rdi`      | Destination Index Register   | Stores the pointer to the destination memory address |
| `rsp`      | Stack Pointer Register       | Stores the pointer to the top of the current stack (volatile) |
| `rbp`      | Base Pointer Register        | Stores the pointer to the base or first item in the current stack frame (fixed) |
| `rip`      | Instruction Pointer Register | Stores the pointer to the next instruction to be executed |

- I have already used `rsi` in pointing to the memory buffer to be displayed. It's job is to point to the start of the memory buffer which is beign used in the current memory operation.

- I have used `rdi` for storing file descriptors. If I recall, a file descriptor is basically the destination of the syscall. For example -
  - A `write` syscall, which is used to write to the terminal, uses 1 as file descriptor. Here, 1 reflects the console as destination of the operation.
  - A `read` syscall, which is used to take read input from the terminal, uses 0 as file descriptor. Here, 0 reflects the console which is the point where the input would be taken from.

- `rsp` is the stack pointer. It is meant for storing the top of the stack.
  - Remember having `top` pointer in C, when I was writing simple stack implementation using arrays? `rsi` is the same thing.

- Constant `push` and `pop` operations makes `rsp` volatile to store the base of the stack, which is the first thing in the stack. Assume the base as the first argument in an array, which is meant to mimic a stack.
  - But why do I even need it?
  - Remember doing `top++`? Initially, top was at 0. Doing `++` makes it move to the next byte (1, 2, 4, 8; depending on the data type).
  - But `top` initially pointed at 0.
  - Now `rsi` is meant to store the `top`. It has nothing to do with the bottom. Even `rsi` don't know it is storing the top of a stack. It is just storing a memory address.
  - What if rsi is decremented so much that it passed the stack frame? There is no guardrails, because there is no need for them. Memory is flat.
  - How will I know I have reached `stack underflow`?
  - There has to be something, that is fixed to the bottom of the stack, beyond which, the stack frame is no more.
  - This gives birth to `rbp`, which is the base pointer of the stack.
  - Take this, `rbp` stores the bottom of the current stack frame, while `rsp` stores the top of the current stack frame.
  - They both are relative to the current stack frame.

- `rip`, on the other hand, is the global instruction pointer.
  - It stores the pointer to the next instruction to be executed, regardless of being inside a label or a function. It is always active.
  - It is read-only for obvious reasons. And I have common-sense to not question it.

It's time to get practical and put my understanding in one thread.

# Understanding Procedures AND Stack Mgmt

Take this example of calculating the square of a number,

```asm
.intel_syntax noprefix

.section .text
.global _start

_start:
  mov rdi, 5          # argument: n = 5
  call square         # call the procedure
  mov rdi, rax        # move result to rdi for exit
  mov rax, 60         # syscall: exit
  syscall

square:
  push rbp            # prologue start
  mov rbp, rsp
  mov rax, rdi        # copy argument to rax
  imul rax, rdi       # rax = rdi * rdi

  mov rsp, rbp        # epilogue
  pop rbp
  ret

```

This is the memory layout:

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

The stack grows downwards, from higher memory address to lower memory address, meaning, the top of the stack would be at 1000 and it would grow towards 0000.

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
0976        <-- locals
0984        <-- old base pointer
0992        <-- return address
1000        <-- Top Of The Stack (rsp)

----x---x----
Higher Memory
```

How this exact frame gets set up automatically? That's the question we are going to figure out now.

Before moving further, what does a push and pop operation actually do, figuring that out before will save lot of hours.

`push`:
  - Subtracts rsi, word-aligned, i.e `rsp--` or `sub rsp, 8`
  - Dereference rsi and put the value at that location, i.e `[rsi] = imm/reg` or `mov [rsi], imm/reg`

`pop reg`:
  - Dereference rsi and move whatever there is to `reg`.
  - Move (or add) rsi, word-aligned, i.e `rsp++` or `add rsp, 8`

Lets go back.

Referrring to the old squaring program we have written, 

```asm
.intel_syntax noprefix

.section .text
.global _start

square:
  push rbp            # prologue start, save old base pointer
  mov rbp, rsp        # establish new base pointer, prologue end

  mov rax, rdi        # copy argument to rax
  imul rax, rdi       # rax = rdi * rdi
  mov rsp, rbp
  pop rbp             # epilogue
  ret                 # return rax, the default place for for return

_start:
  mov rdi, 15         # argument: n = 15
  call square         # call the procedure
  mov rdi, rax        # move result to rdi for exit
  mov rax, 60         # syscall: exit
  syscall

```

the first thing we did was calling the square procedure.
  - It means, "set the instruction pointer register to point at the `square` label and make an unconditional jump to square".
  - Why this? If we never tell the instruction pointer to go to `square`, it will never go there and instead, will exit the program, as specified.
  - That's why the `call` keyword is a shorthand for doing three things:
    1. Push the return address to the stack.
    2. Set the instruction pointer register to the square label, and 
    3. Make an unconditional jump to the label.
  - Therefore, the first thing that goes on the stack, or the lowest plate in the stack of plates is the "return address."

Next comes the label itself, `square`.
  - We have pushed `rbp` to stack. Why?
    - So that we can save the base pointer of the caller.
  - Who is the caller? The program.
  - Why to save the caller's base pointer?
    - Lets revisit the definition of base pointer.
    - A base pointer is a fixed pointer, which marks the start of a stack frame.
    - Among thousands of other processes, that are using stack, our program is just another.
    - The stack pointer is volatile as it moves with push and pop operations, that are happening continuously. Therefore, relying on that is not viable.
    - There is a requirement for a fixed offset, which can act as an anchor in the sea of operations.
    - And `rbp` is that anchor.
    - Our main program relies on rbp so that it knows where it was started. It marks the start of the stack frame, allotted to our asm program.
    - But now we are creating another stack frame with our `square` procedure. Just think about this, how we are going to restore to the main context, or stack for the main program?
    - I hope your answer was "using base pointer." If not, we'll systematically prove it.
  - Therefore, the second thing that goes on the stack, or the second plate in the stack of plates is the "old base pointer."

Now we have moved rsp into rbp.
  - `rsp` is storing the memory reference to the top most thing that is living on the stack.
  - And this is where our new stack frame, the one for the square procedure starts.
  - Now this stack frame must also have its own frame pointer or rbp? Absolutely. And that is why, we are moving rsp into rbp.
  - This makes rbp pointing at the first thing in the stack, which is the old base pointer.
  - The new base pointer points at old base pointer. This might seem odd but later its significance will be proven.

Next, arithmetic. Leave that.

Next we have moved rbp into rsp.
  - This means that rsp now points to rbp, or, the first thing in the stack, which is the old base pointer.
  - Just imagine if we didn't have rbp for this stack frame. There is no straightforward way we can go back to the bottom.

At last, we have popped rbp. Lets understand this.
  - `rbp` for the current stack frame points to the old base pointer.
  - When we do `pop reg`, it means that dereference what rsi is pointing to, store it in `reg`, and increase rsi.
    ```
    mov reg, [rsi]
    inc rsi
    ```
  - Now rsi is pointing at the return address
  - And `ret` does this: `pop rip`, dereference rsi, store it in rip, and increase rsi.
  - Done.

Having rbp pointing to the old base pointer, which was pushed to the stack as the second plate was necessary so that when we pop rsi, we directly move to the return address. And pop the return address to move to the main context.

But it's not over yet. There is a conceptual problem that is left to be tackled.

Stack grows downward, but the pointer arithmetic we are doing, to access everything on the top of the stack is using +, not -.
  - `rbp + 8` is giving us the return address.
  - `rbp - 8` is giving us the locals.
  - And `rbp + 16` onwards we get the arguments pushed on the stack.

What the heck we are actually doing!
  - Locals are the values that we push to the stack inside a procedure.
  - Space has to be reserved so that they can be stored and accessed properly.
  - The first 6 function arguments comes in the form of registers, if it exceeds, goes to the stack, from [rbp + 16] onwards.
  - The whole lies in how the stack is structured inside the memory vs how we interpert it.
  - Stack grows downwards is the biggest problematic statement about stack, in my opinion. It forces me to invert my thinking about stack.

Actually, according to memory, stack grows like this:

```
Higher Memory
----x---x----

1000        <-- Top of the stack, rsi
0992        <-- return address
0984        <-- old base pointer
0976
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

To store locals, you have to reserve space, by subtracting rsp. On the other hand, arguments > 6 are internally managed by stack.

Mathematically,
  - we are still doing [rbp - 8] to access the 7th argument. Because that's where it lives, i.e at 9976.
  - If there is no 7th argument, and there is a local, we are still doing [rbp - 8], because that's where it lives, i.e at 9976.
  - If there was both an argument and a local, the rsp would point at 9976, and subtracting 1 time will make space for a local, and the local would be at 9968.
  - According to pointer arithmetic, addition gives access to arguments while subtraction gives access to locals. This is the thing.
  - Mathematically, we are doing the same thing, subtracting from the offset.