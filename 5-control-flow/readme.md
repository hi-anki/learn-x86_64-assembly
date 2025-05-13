# Control Flow In Assembly

Control flow helps in breaking the linearity of the execution.

There are no high level constructs like if, else or operators like > and <.

We have jump statements/mnemonics for this.

## The Trio That Rules

As with anything in assembly, there are quirks everywhere. Even if you say there is some assembly in a sea of quirks, that wouldn't be actually wrong **for a beginner**.

There is so much in control flow, but 3 things rule them all.

### 1. Unconditional Jumps

Unconditional jumps, as named, are jumps that are abided by nothing. If they are present, the jump is confirmed to happen.

The `jmp` mnemonic is used for this task.

### 2. Conditional Jumps

A conditional jump, as named, is based on a condition being fulfilled.

To check if a condition is fulfilled or not, you need to compare at least two entities.
  - There is where the `cmp` mnemonic comes into picture.
  - It lets you compare two entities, and obviously, with its own quirks. No one is spared of quirks in assembly.

Based on the criterion meeting or not, the execution jumps.

`cmp` compares two operands by subtracting the second operand from the first operand.

Example:
```asm
cmp op1, op2
```
> implies,  op1 - op2

And there is no meaning in storing the result of subtraction because this is not what we wanted. Therefore, `cmp` sets some CPU flags to 1 based on the condition the result fulfills.

  | **Flag**               | **Set When**                                                                 |
  | ---------------------- | ---------------------------------------------------------------------------- |
  | **ZF (Zero Flag)**     | `op1 == op2` (result is 0)                                                   |
  | **SF (Sign Flag)**     | Result is negative (MSB = 1)                                                 |
  | **CF (Carry Flag)**    | Borrow occurred (i.e., `op1 < op2` in **unsigned** terms)                    |
  | **OF (Overflow Flag)** | Signed overflow occurred (e.g., positive - negative = negative unexpectedly) |

Based on these CPU flags, we make the assumption about the result of comparison. The conditional jumps made assumptions about where to go on the basis of CPU flags only.

Common conditional jumps include:

| **Jump Mnemonic** | **Condition (High-Level Equivalent)** | **Flags Involved (After `cmp`)** | **Description**              |
| ----------------- | ------------------------------------- | -------------------------------- | ---------------------------- |
| `je` / `jz`       | `==` (equal)                          | ZF = 1                           | Jump if equal / zero         |
| `jne` / `jnz`     | `!=` (not equal)                      | ZF = 0                           | Jump if not equal / not zero |
| `jg` / `jnle`     | `>`  (signed)                         | ZF = 0 and SF = OF               | Jump if greater              |
| `jge` / `jnl`     | `>=` (signed)                         | SF = OF                          | Jump if greater or equal     |
| `jl` / `jnge`     | `<`  (signed)                         | SF ≠ OF                          | Jump if less                 |
| `jle` / `jng`     | `<=` (signed)                         | ZF = 1 or SF ≠ OF                | Jump if less or equal        |
| `ja` / `jnbe`     | `>`  (unsigned)                       | CF = 0 and ZF = 0                | Jump if above                |
| `jae` / `jnb`     | `>=` (unsigned)                       | CF = 0                           | Jump if above or equal       |
| `jb` / `jnae`     | `<`  (unsigned)                       | CF = 1                           | Jump if below                |
| `jbe` / `jna`     | `<=` (unsigned)                       | CF = 1 or ZF = 1                 | Jump if below or equal       |
| `jmp`             | unconditional jump                    | *NA*                             | Always jump                  |

**Note:**
  1. Zero Flag (ZF) is set to 1 when the result of comparison is 0 (i.e the operands are equal).
  2. Sign Flag (SF) is set to 1 when the result is negative (i.e MSB = 1)
  3. Overflow Flag (OF) is set to 1 if signed overflow occurs.
  4. Carry Flag (CF) is set to 1 if there is an unsigned borrow.

### 3. Jump, Jump, But Where Does It Jump?

Jump statements jump to labels.

So far, we have used labels as named locations to contain static and global values, or, for runtime buffers. This is where the conflict of labels being variables stems.

But today, even the last seed of it will be destroyed.

We know that a label is a named memory location. That's it. Labels are also used in the text section, where they act as named locations in code, not just memory. This is the distinction that separates them from variables.