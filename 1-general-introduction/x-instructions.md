# Instructions In Assembly

+ An instruction in assembly is a single operation that tells the CPU what to do.

+ Every instruction is made up of three items, the mnemonic (the actual CPU operation) and two operands.
  ```asm
  mnemonic destination, source
  ```
  This is intel's syntax for an instruction. AT&T reverses the source and destination order.

+ Ex, `mov rax, 1`. Means, move 1 into rax register. It also aligns with the mathematical asignment of values, `a = 4`, assign 4 to a.

+ There are hundreds of instructions in assembly. But the core instructions, that are most commonly used, includes the following.

| Category             | Purpose                                         | Common Instructions                      |
| -------------------- | ----------------------------------------------- | ---------------------------------------- |
| **Data Movement**    | Moving data between registers/memory/immediates | `mov`, `lea`, `xchg`                     |
| **Arithmetic**       | Math operations                                 | `add`, `sub`, `mul`, `div`, `inc`, `dec` |
| **Logic/Bitwise**    | Logical or bit manipulation                     | `and`, `or`, `xor`, `not`, `shl`, `shr`  |
| **Control Flow**     | Changing execution path (loops, ifs, etc)       | `jmp`, `je`, `jne`, `call`, `ret`        |
| **Comparison/Test**  | Set CPU flags based on results                  | `cmp`, `test`                            |
| **Stack Operations** | Pushing/popping values                          | `push`, `pop`                            |
| **System/Interrupt** | Interacting with the OS or hardware             | `syscall`, `int`                         |

To fully understand how some instructions work — especially comparisons and jumps — we need to understand CPU flags.

# CPU Flags

+ CPU flags are binary indicators (either 0 or 1) that reflect the outcome of certain operations or hold special status information. They're part of the processor's status register, which is used by instructions like cmp (compare) and test.

+ When an instruction modifies the flags, other instructions can check the state of these flags to make decisions, like jumping to different parts of code based on conditions.

+ Example: 

  | Flag | Description |
  | ---- | ----------- |
  | **ZF** (Zero Flag) | Set to 1 if the result of an operation is zero; otherwise, it’s 0. |
  | **SF** (Sign Flag) | Set to 1 if the result of an operation is negative (the most significant bit of the result is 1). |

+ These flags are automatically set by many instructions and are and used in conditional jumps.

There are tons of flags but we need not to cover them all right now.