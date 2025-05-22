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