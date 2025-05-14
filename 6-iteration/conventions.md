# Conventions

Most prominently, we are concerned with syscalls and function calls. So far, we have only seen syscalls.

In life, we follow conventions for addressing people:
  - The person who teaches at a university is called a professor. And that's why we use, "Hello, Professor. Good morning."
  - The humans who gave birth to you are called "Mother" and "Father". Their parents are called "Grandfather" and "Grandmother".
  - In professional settings, we have bosses, managers, and colleagues — each with its own rules for how you interact. Colleagues might be addressed by name, close ones by nickname, and your manager more formally, like "Sir" or "Ma'am".

We follow these **conventions** so everyone understands roles and expectations.

Similarly, in the world of binary programs, we follow calling conventions.

If there's any such convention in assembly for Linux x86_64, it is known as the **System V AMD64 ABI**.

---

## System V AMD64 ABI

The **System V ABI (Application Binary Interface)** is a standardized agreement that defines:

  - How functions pass arguments and return values
  - Which registers must be preserved and by whom
  - Stack alignment and layout
  - How system calls are made
  - ... and more advanced things we can skip for now

It's the contract between your assembly code, the OS, and C libraries. Everyone plays by these rules.

In linux x86_64, there are two calling conventions we are mostly concerned about.
  1. Function Call Convention
  2. System Call (syscall) Convention

---

## Function Call Convention (System V)

We can directly call C library functions from assembly. To do that correctly, we must know how **arguments are passed** to those functions.

This is the register order for the **first six arguments**:

| Argument # | Register |
|------------|----------|
| 1st        | RDI      |
| 2nd        | RSI      |
| 3rd        | RDX      |
| 4th        | RCX      |
| 5th        | R8       |
| 6th        | R9       |

### Caller vs Callee

- **Caller**: The function (or code) that *calls* another function.
- **Callee**: The function that is *called*.

In simpler terms, the caller is you (the programmer), and the callee is the function you're calling.

In any call, certain registers must be preserved, no matter what. But **who** does the preserving?

The ABI splits the responsibility like this:

| Register              | Saved by | Meaning |
|-----------------------|----------|---------|
| `RBX`, `RBP`, `R12–R15` | Callee   | Callee must preserve these. If it changes them, it must restore them before returning. |
| `RAX`, `RCX`, `RDX`, `RSI`, `RDI`, `R8–R11` | Caller | Caller must save these if it wants to keep their values after the function call. |

---

## System Call Convention (Linux x86_64)

Syscalls (like `write`, `read`, `exit`) use a **different** register layout to pass arguments:

| Argument # | Register |
|------------|----------|
| syscall #  | RAX      |
| 1st        | RDI      |
| 2nd        | RSI      |
| 3rd        | RDX      |
| 4th        | R10      |
| 5th        | R8       |
| 6th        | R9       |

> 🧠 **Wait, why R10 instead of RCX for the 4th syscall argument?**

Because **RCX and R11 get clobbered (overwritten) by the `syscall` instruction itself**:

- `RCX` is used to store the return address (RIP) before the syscall.
- `R11` is used to store the original RFLAGS.
- After the syscall returns, both are overwritten and unreliable.

> 🧠 **What about RBX? Why isn't it used at all in syscalls?**

- It's a **callee-saved** register in function calls, but syscall doesn't require saving anything.

So:
- `RCX` and `R11` are clobbered during a syscall.
- `RBX` is free to use, but you must preserve it yourself if you're mixing in function calls