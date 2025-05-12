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

**Note: The `cmp` operation doesn't store the result anywhere. It manipulates the CPU flags based on the comparision.**

Common conditional jumps include:

| Instruction   | Meaning              | High Level Construct | Triggered by Flags |
| ------------- | -------------------- | -------------------- | ------------------ |
| `je` / `jz`   | Jump if equal / zero | ==                   | Zero Flag set      |
| `jne` / `jnz` | Jump if not equal    | !=                   | Zero Flag clear    |
| `jg`          | Jump if greater      | >                    | Signed greater     |
| `jl`          | Jump if less         | <                    | Signed less        |
| `ja`          | Jump if above        |                      | Unsigned greater   |
| `jb`          | Jump if below        |                      | Unsigned less      |

### 3. Jump, Jump, But Where Does It Jump?

Jump statements jump to labels.

So far, we have used labels as named locations to contain static and global values, or, for runtime buffers. This is where the conflict of labels being variables stems.

But today, even the last seed of it will be destroyed.

We know that a label is a named memory location. That's it. Labels are also used in the text section, where they act as named locations in code, not just memory. This is the distinction that separates them from variables.