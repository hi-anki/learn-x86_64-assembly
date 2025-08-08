# Add Two Single Digit Numbers

Why single digit?
  - We are not ready for multiple digits yet.

We have kept the buffer size 2, why?
  - When we type 9 and press enter, the terminal sends [0x39, 0x0a] as the input.
  - `0x39` is the hexdecimal representation of ASCII literal 9.
  - `0x0a` is the hexdecimal representation of non-printable ASCII character Line Feed (`LF`). Line Feed or newline character (`\n`) is what pressing `ENTER` means. It is how the input is finalised and submitted.
  - This is the reason why we need to reserve 2-bytes. One for the input and the other for its finalization.

We are subtracting '0' from the input numbers, why?
  - When we read user input, it is stored in raw hex-bytes.
  - Suppose we enter 5. It would be stored as 0x35, because 5 is equal to 35 in base-16. 0x represents that it is a hex digit.
  - But we have entered 5, not 35. This would create issue with arithmetic.
  - Therefore, subtracting 30 from a digit would convert it into a proper integer.
  - We are subtracting '0' because '0' is 0x30 in hex.

What is the `movzx` mnemonic?
  - It stands for "move with zero extend".
  - It means, move a smaller value in a large register and set the upper bits to zero.
  - Our numbers are composed of 1 byte (8-bits) only. But the registers we are using can hold up to 64-bits or 8 bytes.
  - Therefore, the rest of the bits have to be zeroed to avoid unforseen problems.
  - Doing `mov rbx, byte ptr [num1]` is risky because you get the 8-bit value but the rest might be garbage, which could change the input number by various degrees.
  - `movzx` ensures there is no chance of garbage value in the upper bits.

`add rbx, rcx` is equalivalent to `rbx = rbx + rcx`. This way, we have lost the original value in rbx, which is our first number.

Also we have to add '0' back to the result to make it printable because the result would be a decimal integer, not a printable ASCII character.

The source index register expects a pointer to the buffer.
  - So far, we have only used labels so we had easily used `lea` on them.
  - Now the result is in `rbx`. And rbx is register, not a memory location. The value it is storing is also an immediate, not a memory location. You can't dereference the register.
  - How rsi is supposed to managed here?
  - We push the value in rbx to stack. Then we move rsp into rsi. rsp is the stack pointer, which points to the top of the stack and its done.

# Limitation

This is only applicable for single digit integers and single digit results.

To solve this problem, we need to understand control flow and iteration.

# Subtraction

Just replace `add` with subtract in line 66.