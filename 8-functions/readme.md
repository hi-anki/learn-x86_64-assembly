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