# General Introduction to Assembly
+ Assembly is the closest we can get to the CPU while still understanding what's going on. It is just one step above machine code.
+ What distinguishes assembly from other programming languages is that **every CPU architecture** (like x86, ARM, MIPS, RISC-V) has its **own assembly language**. For example, x86 has x86 assembly, ARM has ARM assembly, and so on.
+ Why are there different flavors of assembly?
  + Because of the **Instruction Set Architecture (ISA)**. Each CPU has its own set of instructions and design, which means each needs its own corresponding assembly language.

# Architectural History
+ The x86 CPU architecture refers to a family of processors — 8086, 80186, 80286, 80386, 80486 — originally developed by **Intel Corporation**, starting in **1978**.
+ The x86 ISA is a **Intel proprietary**, but other companies (notably **AMD**) were **licensed** to create compatible CPUs.
+ All these processors share the same **Instruction Set Architecture (ISA)** and are collectively known as **x86**.
+ The original **8086** was a **16-bit** processor. Intel extended this to **32-bit**, known as **IA-32** (or x86_32). Then in **2003**, AMD extended the architecture to **64-bit**, releasing **AMD64**. Intel later adopted the same ISA, calling their version **Intel 64** — both are **functionally identical**.
+ Since Intel designed the architecture, they also defined the original assembly syntax for it — known as **Intel syntax**. This style is widely used in **Microsoft** development tools and the **Windows** ecosystem.

# Origins of AT&T Syntax
+ In contrast, **AT&T**, through **Bell Labs**, created **Unix** in **1969**, originally for **PDP-7** machines, and it was initially written in assembly. By **1973**, Unix was rewritten in **C**, making it portable.
+ In **1978**, Intel introduced the x86 architecture, which eventually became popular on personal computers.
+ In **1983**, the **GNU Project** was launched to create a **free, Unix-like operating system**. It needed a new assembler and adopted a **new assembly syntax** for x86 that was more consistent and easier to parse than Intel’s.
+ This new syntax, although created by GNU, was based on conventions from Unix systems — and since **Unix was synonymous with AT&T**, this style became known as **AT&T syntax**.
+ When **Linux** was created in **1991**, it relied heavily on GNU tools like **GCC** and **GAS**, which used AT&T syntax. As a result, **AT&T syntax became the standard in the Linux ecosystem**.

# Difference Between Assembly And Other Languages (C, Python.....)

## 1. Core Purpose
+ High level languages abstracts the core functionality. Their core purpose is to provide the programmer with ease of usability. 
+ Assembly, on the other hand, is completely explicit -- there's no abstraction. Everything here is open and the programmer has to write every single instruction themselves.
+ This exposes the reality that even a simple "Hello, World!" program requires multiple low-level steps before it can actually run.

## 2. Platform Dependency
+ We are used to download python for our windows, linux or mac machine and start coding. We don't have to worry about how CPU will understand our hand writing. 
+ But assembly doesn't work like that. It is **architecture-dependent**.
+ Assembly written for x86 will not work on ARM.

## 3. Control >> Convenience
+ Assembly gives you **maximum control**, at the cost of **convenience**. What is convenience?
+ **Pretty and verbose named variables**? Not in assembly. You work directly with CPU registers — that's all you have.
+ **Data types**? Assembly doesn't care. Everything is just bytes. It’s up to *you* to interpret whether a value is a number, a character, a emoji, or something else.
+ **Control flow**? Nothing is built in. You implement it using jump instructions.
+ **Loops**? You write the jump logic manually — there are no `for` or `while` keywords.
+ **I/O**. Use direct syscalls. No dedicated printf and scanf.
+ **Data Structures**? **Functions**? **D I Y. DO.IT.YOURSELF**

You have got every raw material, and building anything is your responsibility.

# Important Note
Assembly is neither complex nor hard. 

The problem with assembly is that it is hard at first, because there is no clear starting point.

Once you start, you find everything deeply linked. You go about learning one thing and end up learning something else.

Assembly is vast. It is not a collection of concepts. Every concept itself is collection of sub-concepts. And this itself is recursive.

Every concept would be linked to something else. And that's how you obtain assembly.

Every concept here is a fractal. Therefore, enjoy it. Don't try to force learn it.

In this journey, concepts would be gradually introduced. But no one concept would be finished all at once. Because this is not possible, at least for me.

You have to leave the methodology you have created internally while learning high-level languages. Because that's not how assembly operates.

The path to progressive learning can never be left behind. If you do, I don't know if you will be able to go very far in it. That's the road to burnout.

I have found these 2 rules to be extremely applicable.
1. Don’t try to learn everything at once. Why?
   + The more you will dive in, the more it will increase its depth.
2. Avoid the urge to see everything there is to learn. Why?
   + It's huge and complicated.

Both of these lead to overwhelm and burnout.

Learn progressively. Visit one concept multiple times with a new charm every single time, and keep the interest and love for assembly alive.