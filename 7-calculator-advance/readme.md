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