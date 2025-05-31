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

### A Curiosity Question
What if the magnitude of the operands themselves exceed the 64-bit mark?
  - In that case, you have to do the work manually.
  - That's why libraries like GMP, which stands for "GNU Multiple Precision Arithmetic Library" exist.

  - But realistically, we don't have to go there.
  - 64-bits can represent approximately **~18 quintillion** unsigned integers. And **~9 quintillion** signed integers.

## Division

In multiplication, RAX was default as the first argument, at least in unsigned multiplication. You can change that in signed multiplication thou. And the result goes in the accumulator pair or RDX:RAX

Division follows a different methodology.

First, lets clarify division terminology as it has been a long time using them.
  + Diviend, the numerator, or the number that is getting divided.
  + Divisor, the denominator, or the number that is dividing the dividend.
  + Quotient, the result, or integer result without any floating point decimals for exactness.
  + Remainder, the value which didn't got divided.

The dividend here is defaulted to the accumulator pair (RDX:RAX). This implies that division is implicitly considered twice the word-size, in assembly. For example, Division on a 64-bit CPU will use 128-bit long dividend.

The divisor is a 64-bit operand. It can be a register or a memory location.

The quotient goes into RAX while the remainder goes into RDX.

Reference Table:

| Operand Size | Dividend Location | Quotient Location | Remainder Location |
| ------------ | ----------------- | ----------------- | ------------------ |
| 8-bit        | `AX`              | `AL`              | `AH`               |
| 16-bit       | `DX:AX`           | `AX`              | `DX`               |
| 32-bit       | `EDX:EAX`         | `EAX`             | `EDX`              |
| 64-bit       | `RDX:RAX`         | `RAX`             | `RDX`              |

### Zero Extension

It is the process of zeroing the upper bits of a register before division to avoid garbage values ruining the result.

It is done by xoring the register.
```
xor rdx, rdx
```

### Unsigned Division (`div`)

`div` divides the value stored in the accumulator pair, by the operand. 
  - And the same logic is applied here.
  - Lower bits of dividend in RAX and higher bits in RDX.

Therefore, to set the dividend (numerator), we have to set the `rax` register.

Remember how many unsigned combinations can 4-byte (or 32-bits) contain? 
  - It is 4.29b+
  - It is ~18+ quintillion for 64-bits.
  - This is enough for regular mathematics.

Therefore, set rax and xor rdx. Simple

To divide, we write:
```
div dr_reg
```

Example:
```s
mov rax, 10
xor rdx, rdx
div 2
```
> Done.

Meaning, `div rcx` means divide RDX:RAX by RCX.

### Sign Extension

Before we can do signed division, we need to understand sign-extension.

We have performed type conversion in high level languages.
  - We wite float besides an int and the integer value magically becomes a float value.
  - Here, the magnitude doesn't changes, the container size changes. Earlier it was 4-bit, now 8-bit. The value still remains the same. Meaning, upper bits are added to it somehow.

  - Generally, we convert smaller values into larger holdings. Why?
  - Because this operation is readily possible. As a small thing can easily fit inside a larger container. But the reverse might not be true.

But machines don't understand types. They understand bit-size.

Converting an int from float on 64-bit CPU in C means we are transforming a 4-bit value to an 8-bit value.

Now comes the problem! If this transformation is not done properly, the actual value will be lost. And this problem is only with signed digits because they have the sign bit (MSB) set in them.

Solution? **Sign Extension**.

In simplest terms, is the correct process of transforming a smaller value into a larger value, which ensures that the integrity of the value is not lost.

Accurately, sign extension is the process of copying the sign bit of a smaller signed value into the higher bits of a larger register or value.

Now how it is done?

| Mnemonic | Meaning                                   | Sign-extends from | To        | Used Before             |
| -------- | ----------------------------------------- | ----------------- | --------- | ----------------------- |
| `cwd`    | Convert Word to Doubleword, sign-extended | `AX`              | `DX:AX`   | 16-bit `idiv`           |
| `cdq`    | Convert Double to Quadword, sign-extended | `EAX`             | `EDX:EAX` | 32-bit `idiv`           |
| `cqo`    | Convert Quad to Octoword, sign-extended   | `RAX`             | `RDX:RAX` | 64-bit `idiv`           |

These are all one-operand instructions — they read from the lower register and sign-extend into the upper half of the dividend pair.

### Signed Division (`idiv`)

Syntax:
```asm
idiv reg
idiv mem
```
> idiv means full (signed) integer divide

If either the dividend or the divisor is negative, idiv handles the sign.

### And Finally, The Almighty, Division Error

If the quotient exceedes the 64-bit mark or you decided to divide by zero, you are gonna greeted with a `divide error exception`

There’s no CF or OF to catch this — it's a full exception, so you must manage operands carefully.

To divide very large numbers and get larger quotients, you must write a "*multi-precision division routine*", example: GMP.

# Burning Question

Great. We have done very basic arithmetics now.

But our programs lack the capability to act as standalone calculators.
  - They don't support multi-digit inputs and multi-digit outputs.
  - They don't support any interactivity by asking the user to input the operation (+, -, /, *......)

Yes. They do lack these capabilities. And that's how it is.

Again, I have to reinforce this so that it get embedded in our psyche that assembly is not a high-level language. There are no built-in constructs.
  - What was normal in high level languages, is definitely not normal in assembly.
  - Moving progressively is the mantra.

To answer the question, we need the knowledge of control flow and iteration, to give our program such capability.

And this is precisely the next thing we are going to do.

But one thing to keep in mind, we are definitely going to learn control flow and iteration, but that's not the only thing we will learn. That's how assembly is. We will learn a ton of other things as well.

Brace yourself — it’s about to get wild.