# System Calls (Syscalls)

A **system call** is the controlled gateway between a user-space program and the kernel. It lets your code request services that require higher privileges — like writing to the screen, reading a file, or exiting the program.

---

## User Mode vs Kernel Mode

The CPU operates in two distinct modes:

- **User Mode**: Restricted environment in which your code runs.
- **Kernel Mode**: Full-access mode where the operating system runs.

Your program cannot directly perform privileged operations. Instead, it uses a **syscall** to request the kernel to perform them on its behalf.

---

## Common Linux Syscalls

Linux supports hundreds of syscalls. Here are a few common ones:

| Purpose            | Syscall | Syscall Number |
| ------------------ | ------- | -------------- |
| Read from a file   | `read`  | 0              |
| Write to a file    | `write` | 1              |
| Open a file        | `open`  | 2              |
| Map memory         | `mmap`  | 9              |
| Exit the program   | `exit`  | 60             |

---

## How a Syscall Works

1. Place the syscall number in the `rax` register.
2. Place the syscall arguments in the appropriate registers:
   - `rdi`, `rsi`, `rdx`, `r10`, `r8`, and `r9`, in that order.
3. Invoke the `syscall` instruction.
4. The CPU switches to kernel mode, executes the request, and returns control (with the result in `rax`).

This is the standard interface between your assembly code and the Linux kernel.
