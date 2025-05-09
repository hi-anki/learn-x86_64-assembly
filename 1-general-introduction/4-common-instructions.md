# Introduction To Common Instructions

We'll stick to what we know about instructions so far, that every instruction is too deep and learning everything about them all at once is a bad idea.

Lets start with our first instruction, `mov`.

## `mov` Instruction

In smple words, just as we had assignment operator (`=`) in high level languages like python, we have `mov` in assembly.

`mov` takes two operands, destination and source. And put the source in destionation.

The syntax for using mov in intel is: `mov destination, source` and it is equal to `destination = source`.

Most commonly, these operands are registers like rax, rsi etc.... But there are other options as well.

1. `mov rax, rsi`: store what's in rsi to rax.
2. `mov rax, [rsi]`: rsi holds a pointer to a location, go there, get the value and put it into rax.
3. `mov [rsi], rax`: rsi holds a pointer to a location, go there, and store what's inside rax in there.

## `cmp` Instruction

In simple words, compare instruction comapres two values by subtracting them, later deciding what might be the case.

In languages like python, we can do something like this: `a = (4 > 2)` and `a` will contain the result. However, that's not the case here.

Syntax: `cmp a, b` where `a-b` is done.

When we do `cmp 4, 2`, cmp does `4-2`, and the result is 2.
  + This result is not stored anywhere. Instead, certain CPU flags are changed on the basis of this.
  + If the result comes out to zero, it sets ZF to 1 (Zero Flag = 1, was 0 before).
  + If the result comes out non-zero, it remains unchanged.
  + If the result comes out +ve, SF remains unchanged to o (Sign Flag is 0 by default, complying with +ve result)
  + If the result comes out -ve, SF is set to 1.

After these CPU flags are changed, we can use jump statements to decide the result. Because we are not concerned with `4-2=2`, we are concerned with what's greater and lesser, depending on what we are up to.
  + Jump statements are used to jump on conclusion based on certain CPU flags.

Now some jump instructions for controlling the flow of the program.

## Jump Instructions

Jump instructions change the flow of execution. Instead of running the next line, they send the CPU to another part of the code based on some condition.

They are like if-else in assembly.

There are two types of jumps, unconditional and conditional.
  + An unconditional jump always goes to some label, no matter what. `jmp some_label` is an unconditional jump.
  + A conditional jump is based on the flags set by `cmp`.

    | Mnemonic | High-Level Equivalent | Meaning                       | Triggered When...     |
    | -------- | --------------------- | ----------------------------- | --------------------- |
    | `je`     | ==                    | Jump if Equal                 | Zero Flag (ZF = 1)    |
    | `jne`    | !=                    | Jump if Not Equal             | Zero Flag (ZF = 0)    |
    | `jl`     | <                     | Jump if Less Than             | Sign Flag (SF ≠ OF)\* |
    | `jg`     | >                     | Jump if Greater               | ZF = 0 and SF = OF    |
    | `jle`    | <=                    | Jump if less than equal to    |
    | `jge`    | >=                    | Jump if greater than equal to |

Syntax: `jump_instruction label_to_jump_to`