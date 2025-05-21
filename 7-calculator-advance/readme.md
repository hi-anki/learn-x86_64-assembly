# Advancing In Arithemetics

Now that we are equipped with the knowledge of control flow, jump statements, iteration and INT && ASCII conversion routines, now we can hop on making our calculator.

Note that we might still incur problems, which is how assembly works basically, but will stand strong and make it work.

Lets do this.

# Map the Surface

Since this is going to be a little big, its good to establish an understanding of what I have to do.

1. Take two numbers (signed integers) from user-input (read syscall)
2. Take an operator (+, -, /, *) from user-input.
3. Convert the numbers from ASCII to literal integers.
4. Perform appropriate arithmetic operation based on the operator input.
5. Transform the result from INT to ASCII.
6. Display.
7. Expand further to (exponent (**), square-root) etc....

# Register Usage Table

Until resgister usage becomes a second nature, it is best to always keep a table that keeps a track of how I am using the registers.

One more thing I noticed in this capstone project and want to highlight is that register usage can be classified into multiple kinds, depending on the scope of the program.
1. **Syscall Context:** When it comes to syscall, `rax, rdi, rsi, and rdx` are used. And these are caller-saved.
2. **General Context:** This includes all the things I am doing within the program, that involves registers. This can be further classified into two.
   1. **Fixed Context:** Here, once the register is set, it must be left like that. It mustn't be reused anywhere, so that the context it is storing must remain preserved. 
   2. **Relative Context:** Here, the register is just like a movement container. Once the task is finished, it can be resued.

In the context of this capston project, I am observing a chaotic situation where I feel kinda short on registers, because right now I am treating them as variables, because of my current mental models. It will take tiem to align with assembly. Anyways, this tabular attempt is to make a note of how and where I am using a register, so that I can establish an understanding about which registers to touch later and which not.

**Fixed Context**

| Register | Used As |
| -------- | ------- |
| r8       | Sign-bit of num1 |
| r10      | Sign-bit of num2 |
| rsi      | Pointer to labelled buffer |
| rcx      | Int(num1) |
| r11      | Int(num2) |
| r12      | Computed Result |
| r13      | Sign-bit of result |

**Relative Context**

| Register | Used As |
| -------- | ------- |
| r9       | Load individual characters from the number sequence |
| rbx      | Divisor |

To find if the MSB is signed or not, we can use `js` and `jns` operations.
  - js: when msb is 1, when result is -ve
  - jns: when msb is 0, when result is +ve or 0

# Time Taken To Complete :: <3 Hours
# Time Taken To Learn Everything Used Here :: 18+ Days