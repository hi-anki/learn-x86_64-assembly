# Introduction To Instructions

An instruction is an atomic operation that tells the CPU what to do.

## Anatomy Of An Instruction

```asm
mnemonic destination, source
```

Mnemonic is the actual CPU operation. Destination and source are the operands it is generally performed on.

Example:
```asm
mov rax, 1
```

Means, move 1 into `rax` register. It also aligns with the mathematical asignment of values, `a = 4`, assign 4 to a.

## Common Operations

There are hundreds of instructions in assembly. But the core instructions are as follows.

| Category             | Purpose                                         | Common Instructions                      |
| -------------------- | ----------------------------------------------- | ---------------------------------------- |
| **Data Movement**    | Moving data between registers/memory/immediates | `mov`, `lea`, `xchg`                     |
| **Arithmetic**       | Math operations                                 | `add`, `sub`, `mul`, `div`, `inc`, `dec` |
| **Logic/Bitwise**    | Logical or bit manipulation                     | `and`, `or`, `xor`, `not`, `shl`, `shr`  |
| **Control Flow**     | Changing execution path (loops, ifs, etc)       | `jmp`, `je`, `jne`, `call`, `ret`        |
| **Comparison/Test**  | Set CPU flags based on results                  | `cmp`, `test`                            |
| **Stack Operations** | Pushing/popping values                          | `push`, `pop`                            |
| **System/Interrupt** | Interacting with the OS or hardware             | `syscall`, `int`                         |

# CPU Flags

CPU flags are binary indicators (either 0 or 1) that reflect the outcome of certain operations or hold special status information. They're part of the processor's status register, which is used by instructions like `cmp` (compare) and `test`.

When an instruction modifies the flags, other instructions can check the state of these flags to make decisions, like jumping to different parts of code based on conditions.

Example:

| Flag | Description |
| ---- | ----------- |
| **ZF** (Zero Flag) | Set to 1 if the result of an operation is zero; otherwise, it’s 0. |
| **SF** (Sign Flag) | Set to 1 if the result of an operation is negative (the most significant bit of the result is 1). |

These flags are automatically set by many instructions and are and used in conditional jumps.

There are many flags but we need not to cover them right now.

# Common Instructions

## `mov` Instruction

In smple words, it is assignment operator (`=`) in assembly.

Syntax:
```asm
mov destination, source
```

Mathemtically, it is `destination = source`.

Most commonly, these operands are registers like rax, rsi etc.... But there are other options as well.

1. `mov rax, rsi` <=> `rsi = rax`.
2. `mov rax, [rsi]`: dereference the value in rsi and put it into rax.
3. `mov [rsi], rax`: dereference the value in rsi and store what's inside rax in there.

**Note: `mov` is actually about copying data from one place to other. Not 'move' in literal meaning.**

## `cmp` Instruction

It comapres two values by subtracting them, later deciding what might be the case.

In languages like python, we can do something like this: `a = (4 > 2)` and `a` will contain the result. However, that's not the case here.

Syntax:
```asm
cmp a, b
``` 

which evaluates as `a - b`.

When we do `cmp 4, 2`, cmp does `4-2`, and the result is 2. This result is not stored. Instead, certain CPU flags are changed on the basis of the result. If the result is:
  + `0`, ZERO FLAG (`ZF`) flag is set to 1, from 0.
  + `non-zero`, remains unchanged.
  + `>0`, SIGN FLAG (`SF`) remains unchanged. It is 0 by default, complying with +ve result.
  + `<0`, SIGN FLAG (`SF`) is set to 1.

Jump statements use these flags to decide what to do next.

## Jump Instructions

Jump instructions change the flow of execution. Instead of executing the next line, they send the CPU to another part of the code based on some condition.

They are the `if-else` of assembly.

There are two types of jumps, unconditional and conditional.

An unconditional jump always goes to some label, no matter what. `jmp some_label` is an unconditional jump.

A conditional jump is based on the flags set by `cmp`.

Some conditional jumps include:

| Mnemonic | Meaning                | Triggered When...     |
| -------- | -----------------------| --------------------- |
| `je`     | Jump if Equal (==)     | Zero Flag (ZF = 1)    |
| `jne`    | Jump if Not Equal (!=) | Zero Flag (ZF = 0)    |
| `jl`     | Jump if Less Than (<)  | Sign Flag (SF ≠ OF)\* |
| `jg`     | Jump if Greater (>)    | ZF = 0 and SF = OF    |
| `jle`    | Jump if less than equal to (<=)    |
| `jge`    | Jump if greater than equal to  (>=) |

Syntax: 

```
jump_instruction label_to_jump_to
```

What is a label?
  - A future topic.
