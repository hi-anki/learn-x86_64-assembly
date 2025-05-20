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
  | **OF (Overflow Flag)** | Signed overflow occurred.                                                    |

Based on these CPU flags, we make the assumption about the result of comparison. The conditional jumps made assumptions about where to go on the basis of CPU flags only.

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

----

Remember, whenever numbers are involved, there is going to be a conflict of signed and unsigned. My experience says that whenever such a conflict is unavoidable, always start with unsigned integers. The use that knowledge to tackle signed integers. And that's precisely what we are going to be doing.

## Unsigned Comparison

In unsigned comparison, we are only concerned by CF and OF flags. Why?
  1. If both the operands are equal, i.e `op1 == op2`, ZF will be 1.
  2. If `op1 > op2`, ZF will remain to 0.
  3. If `op1 < op2`, CF will be set to 1 and ZF will continue to be 0.
  4. Sign-bit is significant for SF. But we know that unsigned integers uses full 64-bit set to store the magnitude of the value, because there is no concept of -ve integers for them. Not only is this irrelevant, but also risky because if somehow the sign-bit is set, it can drastically change the magnitiude of the value, thus, altering the outcome.

Common Unsigned Jump Mnemonics:

| **Jump** | **High-Level Equivalent** | **Condition**    | **Meaning**            |
| -------- | ------------------------- | ---------------- | ---------------------- |
| `ja`     | `>`                       | CF = 0, ZF = 0   | Jump if Above          |
| `jae`    | `>=`                      | CF = 0, ZF = 1   | Jump if Above or Equal |
| `jb`     | `<`                       | CF = 1           | Jump if Below          |
| `jbe`    | `<=`                      | CF = 1 or ZF = 1 | Jump if Below or Equal |
| `je`     | `==`                      | ZF = 1           | Jump if Equal          |
| `jne`    | `!=`                      | ZF = 0           | Jump if Not Equal      |

## Signed Comparison

Except CF, all the three flags, ZF, OF and SF are significant here.

Common Signed Jump Mnemonics:

| **Mnemonic**  | **High-Level**    | **Flag Logic**           | **Meaning**                 |
| ------------- | ----------------- | ------------------------ | --------------------------- |
| `je` / `jz`   | `a == b`          | `ZF == 1`                | Equal                       |
| `jne` / `jnz` | `a != b`          | `ZF == 0`                | Not equal                   |
| `jg` / `jnle` | `a > b` (signed)  | `ZF == 0` and `SF == OF` | Greater (signed)            |
| `jge` / `jnl` | `a >= b` (signed) | `SF == OF`               | Greater or equal (signed)   |
| `jl` / `jnge` | `a < b` (signed)  | `SF != OF`               | Less than (signed)          |
| `jle` / `jng` | `a <= b` (signed) | `ZF == 1` or `SF != OF`  | Less than or equal (signed) |

Understanding signed comparisons is a cakewalk if you understand SF and OF. Lets make it cakewalk then.

### SF && OF Settlement

SF is set when the result is -ve.

OF is set if there was a signed overflow. This means, the result didn't fit in the signed range so it gor wrapped around.

The whole SF and OF conflict arises from how ranges work.

Lets take al. al is 8-bit wide. Meaning, al can contain a total of 256 combinations. In unsigned range, they are from 0-255. In signed range, they are from [-128, +127] 

Lets do some calculations.

  - 100 + 25 = 125 and 125 is in [-128, +127]. No problem!

  - 100 - 109 = -9 and -9 is in [-128, +127]. No problem again!

  - 20 + 109 = 129 and 129 doesn't comes in [-128, +127]. That's a problem.

  - 127 is represented as 01111111

  - To represent 129, we need 1 extra bit, but that is reserved for -ve numbers. In such a case, 129 will overwrapped to -127.

  - What's the final result of last computation? -127.

  - It is negative so sign flag (SF) must be set to 1.

  - It also overflowed and got wrapped, so overflow (OF) flag must also be 1.

But this is all for the computer. Real mathematics doesn't work like that. 20 + 109 will give "+129" not "-127"

Therefore, SF is set wrong. But OF is set right.

Take another example: -80 - 70 = -150

  - Again, -150 doesn't belong to 8-bit range. Therefore, it will be overwrapped to +105

  - Result = +105

  - SF = 0. OF = 1

  - Again, this is not how normal mathematics would go.

If you notice, in both the cases, OF came to rescue. It ensured that reality must be preserved.

And this is what SF and OF conflict is about. When the result overwraps, the value that came after is treated as the final result, which is mathematically wrong. And this will bring chaos to calculations. OF is set so that this chaos can be managed.

Lets examine some cases:
  - Case 1: Operand 1 is greater than operand 2.
    - 120 - 119 = 1.
    - There is no overflow problem.
    - SF = OF = 0.
  - Case 2: Operand 1 is lesser than operand 2.
    - 119 - 120 = -1
    - SF = 1 because of -ve result. But no overflow so OF remains 0.
  - Case 3: Operand 1 is greater than or equal to operand 2.
    - 120 - 120 = 0 && 120 - 119 = 1
    - Simple. SF = OF = 0
  - Case 4: Operand 1 is less than equal to operand 2.
    - 119 - 120 = -1 && 119 - 119 = 0
    - SF = 1 and OF = 0

If you notice,
  - ZF is not that signifcant in examining extreme cases.
  - SF counts on the final value. This certainly helps but extreme cases still get out of hand.
  - OF especially counts these special (overflow) cases. And that is why it is important.

### Conclusion

| Comparison | Jump  | Flag Logic             |
| ---------- | ----- | ---------------------- |
| `a > b`    | `jg`  | `ZF = 0` and `SF = OF` |
| `a < b`    | `jl`  | `ZF = 0` and `SF ≠ OF` |
| `a >= b`   | `jge` | `ZF = 1` and `SF = OF` |
| `a <= b`   | `jle` | `ZF = 1` and`SF ≠ OF`  |

OF flag becomes a necessity when an arithmetic operation, not just subtraction, leads to results which overflow the range.

----

## Silly Questions Roundup

So far, if you are paying attention, you might notice there are two mnemonics for the same operation. Why?
  - If you notice, `a < b` and `b > a` are fundamentally the same thing. Only they are represented differently.
  - So the answer is simple. To support both perspectives.

Why use different mnemonics for signed and unsigned dealings, when the operation is the same.
  - Nothing is simple for CPU.
  - They use different flags to denote these conditions and that's why condensing them in one mnemonic is not possible.

----

## Future Point Of Confusion

Fundamentally, a `sub` operation and a `cmp` operation are the same.

They both compute `op1 - op2`.

The difference lies in result management.

`sub` stores the result in accumulator, by default. But `cmp` never stores the result.

Both of them change CPU flags, based on the result.

# Important Note

Labels don't have context of where you have left.

If you try to return back to a label which called the current label, the return would be absolute. Meaning, the instruction pointer will point to the start of the label, not where you have left.

Keep control flow in forward direction only, to avoid potential undefined behavior, **for now**.