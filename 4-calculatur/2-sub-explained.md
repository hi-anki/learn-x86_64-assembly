# Subtract Two Numbers

We have copied the entire `add` program and simply replaced the `add` mnemonic with `sub`. However, the program does not work as expected — even though it assembles and links without errors.

Let's see why!

We know that a `write` syscall uses the following signature:
```
write(fd = rdi, buffer = rsi, buffer_len = rdx)
```

The `rsi` register is expected to contain a **pointer** to a memory buffer, not the value to be printed itself.

In the `add` version, we had: `mov rsi, rbx`

  - This mistakenly put the **numeric result itself** into `rsi`, rather than a pointer to where the result is stored in the memory. 
  - As a result, the syscall attempted to read memory at the address equal to the result value — which is invalid or unpredictable.

The correct version is:
```
mov rsi, rsp
mov [rsp], bl
```

  - This explicitly writes the result byte to the stack (`rsp`), and then points `rsi` to that valid memory address, as expected by `write`.

So why did `mov rsi, rbx` appear to work in the addition program?

  - The answer is: **undefined behavior**. We were lucky.