# Registers

Registers are fast, low-level storage locations in the CPU. While x86_64 offers 16 general-purpose registers, their usage is often guided by conventions rather than absolute freedom.

Though they're called "general-purpose," their actual usage depends on the **context** — especially the calling convention being followed. So while any register can technically hold any data, their roles are usually defined by system-level agreements.

This convention-driven behavior may seem complex at first, but it's something you’ll internalize naturally as you write more assembly.

---

## General-Purpose Registers in x86_64

| Register | Purpose / Convention                  |
| -------- | ------------------------------------- |
| `rax`    | Accumulator; return values, syscall # |
| `rbx`    | Base register; often callee-saved     |
| `rcx`    | Counter for loops, shifts             |
| `rdx`    | Data register; I/O, syscall args      |
| `rsi`    | Source index; memory ops, args        |
| `rdi`    | Destination index; memory ops, args   |
| `rbp`    | Base pointer; stack frame reference   |
| `rsp`    | Stack pointer; top of the stack       |
| `r8`     | 5th syscall argument                  |
| `r9`     | 6th syscall argument                  |
| `r10`    | 4th syscall argument                  |
| `r11`    | Temporary scratch for syscall         |
| `r12`–`r15` | Callee-saved; general-purpose      |

---

## Register Usage and System Calls

In Linux (x86_64), the most common calling convention is **System V AMD64 ABI**. It defines how functions and system calls exchange data — by assigning specific roles to specific registers.

### Syscall Register Convention (System V ABI)

| Argument      | Register | Description        |
| ------------- | -------- | ------------------ |
| Syscall #     | `rax`    | Identifier         |
| Argument 1    | `rdi`    | First parameter     |
| Argument 2    | `rsi`    | Second parameter    |
| Argument 3    | `rdx`    | Third parameter     |
| Argument 4    | `r10`    | Fourth parameter    |
| Argument 5    | `r8`     | Fifth parameter     |
| Argument 6    | `r9`     | Sixth parameter     |

To successfully invoke a system call, your data must be placed in these specific registers. Otherwise, the kernel will not interpret your request correctly.

---

## Final Thought

Don't worry about memorizing all of this right now. These conventions will become second nature as you write and debug real programs.