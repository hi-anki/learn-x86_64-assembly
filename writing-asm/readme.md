# Writing Assembly Programs

Even after knowing so many things, I still fear writing assembly programs. It has not become my second nature.

Therefore, I am here to dissolve that problem.

**The Goal:** To attain fluency in writing assembly programs and remove the visual fatigue of seeing large binaries. This would directly help me in my reverse engineering journey.

Here is a table to structure the contrast b/w writing programs in a high-level program and assembly.

| Concept      | Python                      | Assembly                                               |
| ------------ | --------------------------- | ------------------------------------------------------ |
| Variable     | `x = 5`                     | Space in memory or register, manually allocated        |
| Function     | `def func()`                | Label + manual stack handling                          |
| Control Flow | `if`, `for`                 | Jumps and comparisons (`jmp`, `cmp`, `je`, `jl`, etc.) |
| Memory       | Automatic                   | Manual: registers, stack, heap                         |
| Data types   | High-level (int, list, str) | Just bytes, interpretation is yours                    |
| I/O          | `print("hi")`               | Syscalls or libc routines                              |
| Errors       | Exceptions                  | Undefined behavior / segfault                          |

At minimum, there are three sections in an assembly program,
  1. `.bss`: for uninitialised data (reading inputs from terminal)
  2. `.data`: for initialised data
  3. `.text`: code

