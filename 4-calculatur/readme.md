# Arithmetic Instructions

## Addition (`add`)

```asm
add rbx, rcx
```
It is same as `rbx = rbx + rcx`

## Subtraction

```asm
sub rbx, rcx
```
It is same as `rbx = rbx - rcx`

## Multiplication

Since computer treats numbers differently, we have two multiplication mnemonics. They are `mul` and `imul`.

`mul` is for unsigned integers and `imul` is for signed integers.

### Mechanics Of Multiplication

By default, the first operand in multiplication is fixed to the **accumulator** register. On 64-bit, `rax` is the accumulator, but since multiplication can go really deep, lets introduce others as well.

| Architecture | Accumulator | Bits Representing |
| ------------ | ----------- | ----------------- |
| 8-bit        | AL          | lower 8-bits      |
| 16-bit       | AX          | lower 16-bits     |
| 32-bit       | EAX         | lower 32-bits     |
| 64-bit       | RAX         | full  64-bits     |

The next operand can be any other register or a memory location.

The corresponding operand must also be of the same size, be it a memory location or a register.

Okay, we have done the multiplication. Where is the result?
  - The result goes in the accumulator pair.
  - We are working on 64-bit systems, so lets talk about that.
  - When you multiply two 64-bit integers, the result can be, at maximum, only 128-bits long. And this is simple maths.
    - For example, 99 is the biggest two digit number. Multiply it with another 99. We can't go any bigger with two digit numbers. Result is 9801. N, or the number of digits is 2, 2*2 = 4. And the result is not longer than 4 digits.
  - But the registers we have are only 64-bits long. Where would the rest of the 64-bits will go? This is what an accumulator pair is.
  - The lower 64-bits of the result will go into RAX, while the upper 64-bits of the result RDX.
  - So, by definition, an *accumulator pair* is a set of two registers used together to hold a wider result than a single register can hold — typically used in multiplication or division.

The result always goes into accumulator pair in case of `mul` or unsigned multiplication. Signed multiplication has a different story.

----

A combined list of architectures, accumulators and accumulator pairs:

| Architecture | Accumulator | Bits Representing | Accumulator Pair |
| ------------ | ----------- | ----------------- | ---------------- |
| 8-bit        | AL          | lower 8-bits      | AX (AH:AL)       |
| 16-bit       | AX          | lower 16-bits     | DX:AX            |
| 32-bit       | EAX         | lower 32-bits     | EDX:EAX          |
| 64-bit       | RAX         | full  64-bits     | RDX:RAX          |

### Unsigned Multiplication: `mul` 

By default, it takes only one operand, as the other one is already fixed to RAX. And that can be another register or a memory location.

Syntax:
```
mul reg
mul mem
```
> RAX * operand -> Result: RDX:RAX

Example:
```
mov rax, 5
mov rbx, 4
mul rbx
```
> means multiply rax with rbx.

### Signed Multiplication: `imul`

Form 1: One operand
```
imul reg
imul mem
```
> RAX * operand -> Result: RDX:RAX

Form 2: Two operands
```asm
imul reg, reg
imul reg, mem
```
> reg = reg * operand

Form 3: Three operands
```asm
imul reg, reg, immediate
imul reg, mem, immediate
```
> reg = operand * immediate

In forms 2 and 3, the result goes in the register mentioned as the first operand.

Here comes the problem. If the **result > 64-bit**, what will happen? The bits from the upper half or everything after 64th bit will be truncated.

### Conclusion

| Instruction | Number Of Operands | Result Location |
| ----------- | ------------------ | --------------- |
| `mul`       | only 1-operand     | RDX:RAX         |
| `imul`      | 1-operand          | RDX:RAX         |
| `imul`      | 2-operand          | reg             |
| `imul`      | 3-operand          | reg             |

### Setting CPU Flags

Now multiplication is done and results have been obtained. It must be finished? Not really!

How we will know if the result was greater than 64-bit?
  - Why we need to know that?
  - If we always tried to display RDX, and if there was nothing in it, there will be some undefined behaviour! Therefore, to optimize `mul` and single-operand `imul` operations, knowing when the result is overflowed is necessary.
  - If we have performed a 2,3-operand `imul` operation, and the result overflowed, we'll basically never know that. Therefore, the optimize 2,3-operand `imul` operations, we need to know if overflow occurred or not.

And again, CPU flags come to our rescue.

CF stands for **Carry Flag**. It is set if there was an overflow in unsigned math.
OF stands for **Overflow Flag**. It is set if there was an overflow in signed math.

| Instruction | Number Of Operands | Result Overflowed |
| ----------- | ------------------ | ----------------- |
| `mul`       | only 1-operand     | CF = 1            |
| `imul`      | 1-operand          | OF = 1            |
| `imul`      | 2-operand          | OF = 1            |
| `imul`      | 3-operand          | OF = 1            |

Note: Both CF and OF flags are set together but context matters.

### A Silly Question

Why the accumulator pair is written like RDX:RAX?

Because that's how positions are assigned in the number system.

We have learned in elementary school that we start from right hand and go towards left hand counting place like ones, tens, hundreds, thousands, ten thousands and so on.....

Recently, we have seen binary representation of numbers and we know that the MSB lies in the left side, which represents the highest value a bit can hold in that combination.

This makes it clear that upper bits are written left hand side while the lower bits are written on the right hand side. This explains why it is RDX:RAX and not RAX:RDX