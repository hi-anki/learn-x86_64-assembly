# Multiplication Program

This time, we are introducing yet another method to manage output and display it.

Earlier, we came to know that a simple `mov` operation into `rsi` isn't a good way to do it. So we have used the stack to solve the problem.

Here, we have stored the result to another buffer in the `.bss` section and printed it normally.

Is the stack method not working?
  - It works perfectly. Checkout `5-multiply.s`

We know that accumulator pair gets the result. Here, rax must contain it because it doesn't exceed rdx, which is true as well. The question is, why we have used `al` in the ASCII conversion?
  - We are using unsigned integers of 1 byte only. The result is also limited to 1-byte only.
  - Using a whole 64-bit register to form the conversion is both meaningless and risky as the upper bits might get corrupted.
  - Since the result is isolated perfectly in `al`, we have used that.

And we are transferring the result from al to bl so that it doesn't get overide by next syscall. Perfect