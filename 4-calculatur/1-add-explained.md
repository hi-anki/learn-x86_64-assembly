# Add Two Numbers

1. We have kept the buffer size to be 2. Why?
  + When we type 9 and press enter, the terminal sends [0x39, 0x0a] as the input.
  + 0x39 is the hexdecimal representation of the ASCII literal 9.
  + 0x0a is the ASCII representation of Line Feed (`LF`). Line Feed or newline character (`\n`) is what that is passed once we press `ENTER`. It is how the input is finalised and submitted.
  + This is the reason why we need to reserve 2-bytes. One for the input and the other for its finalization.

2. We are subtracting '0' from the input of numbers. Why?
  - When we read user input, it is stored in raw-bytes, which is their ASCII value (in hexadecimal representation).
  - Suppose we entered 5. It would be stored as 0x35, because 5 is equal to 35 in base-16. 0x represents that it is hex.
  - But we have entered 5, not 35. This would cause problems in how arithmetics would deal with it.
  - Therefore, subtracting 30 from a digit would convert it into integer.

  - Why we have used '0' and not literal 0?
    - It would do nothing, because it is an immediate.
    - '0' on the other hand is an ASCII character so it will get stored as 0x30, the same as our input number and then we subtract it from 0x35 to get 0x05.
    - Where 0x05 is just a binary number, 00000101

2. What is the `movzx` mnemonic?
   - It stands for "move with zero extend".
   - It means, move a smaller value in a large register and set the upper bits to zero.

    - Our numbers are composed of 1 byte only. But the registers we are using can hold up to 64-bits or 8 bytes.
    - Therefore, the rest of the bits have to be zero.
    - Doing `mov rbx, byte ptr [num1]` is risky because you get the 8-bit value but the rest might be garbage.
    - `movzx` ensures there is no chance of garbage value in the upper bits.

3. `add rbx, rcx` is equalivalent to `rbx = rbx + rcx`. This way, we have lost the original value in rbx, which is our first number.
4. Also, this is only applicable for single digit integers and single digit results. What about others?