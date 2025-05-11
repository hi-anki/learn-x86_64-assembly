# Number System Refresher

Primarily we have 4 number systems. They are: binary, octal, decimal and hexadecimal

## Binary Number System

+ It is a base-2 (2^1) system.
+ It contains only 0 and 1. They are called bits.
+ 0 means OFF/FALSE
+ 1 means ON/TRUE
+ Prefixed with `0b`. Ex: `0b00001111`

## Octal Number System

+ It is base-8 (2^3) system.
+ It contains digits between 0-7.
+ It takes 3-bits to be represented.
+ Prefixed with `0o`

## Decimal Number System

+ It is base-10 system.
+ It contains digits between 0-9.

## Hexadecimal Number System

+ It is base-16 (2^4) system.
+ It contains digits between 0-9 and A-F.
+ It takes 4-bits to be represented.
+ Prefixed with `0x`. Ex: `0x35`

## Bit, Byte Havoc
+ Bits include 0, 1.
+ 1 Byte = 8-bits
+ 1 Byte can represent numbers between 0-255. 
+ "Zero" by 00000001 and "One" 255 by 11111111.
+ 2 Bytes can represent numbers between 0-65535.
+ 4 Bytes can represent numbers between 0-4.29b
----

# Types Of Integers

## Unsigned Integers

Simply put, all the positive integers are called unsigned integers. And it includes 0 as well.

More accurately, Unsigned integers are integers that cannot be negative. They start from 0 and go up to the maximum possible value based on the number of bits.

Signed Integers =: Numbers >=0

Since there is no problem for signs (+ and -), they use all of their 8-bits to store the magnitude of the number.

To obtain the unsigned range for n-bits, `[0, 2^n - 1]`

A 8-bit number can range from 0 to 255. Their representation is as follows:
```
0 => 0b00000000
255 => 0b11111111
```

## Signed Integers

Signed integers can be both positive and negative.

They are implemented using two's complement.

The most significant bit (MSB) is used as the sign bit:
  - 0 = positive
  - 1 = negative

A 8-bit number can range from -128 to +127. Their representation is as follows:
```
0 => 0b00000000
+127 => 0b01111111
-128 => 0b10000000
-1 => 0b11111111
```

The standard rule to find the signed range of possible integers in n-bits is: `[(-2)^(n-1), 2^(n-1)-1]`
----

# Representing Negative Integers

In binary number system, + and - holds no meaning. Complements are how we represent negative numbers in binary system.

Complements mathematical transformations of binary numbers, specifically designed for how binary arithmetic works in computers

The most common ones are:
  1. 1's Complement
  2. 2's Complement
----

## Types Of Bits
Primarily, there are two types of bits.
  1. Least Significant Bit (LSB) : It is the rightmost bit in the binary representation of the integer.
     + It is called least because setting this ON or OFF has the least impact on the magnitude of the value.
     + Ex: 15 is represented by 1111 in 4-bits. If you set the last bit (or LSB) to 0, we get 1110, which is 14. The magnitude is lowered by 1 only.
  2. Most Significant Bit (MSB) : It is the leftmost bit in the binary representation of the integer.
     + It is called most because setting this ON or OFF has the largest possible impact on the magnitude of the value.
     + Ex: Take 15 again. If you set the leftmost bit (or MSB) to 0, we get 0111, which is 7. The magnitude is lowered by 8.

## 1's Complement

The value you must add to a number so the result is a string of 1s or the result is the maximum representable value.

To get the 1's complement of a binary number: Flip all bits (change 0s to 1s and 1s to 0s).

Example: 
  - 5 in binary is represented by: `0b00000101`
  - 1's complement of 5 (= -5): `0b11111010`

The problem with 1's complement is that it has two representation of 0.
  - +0 = `0b00000000`
  - -0 = `0b11111111`

  But 0 is one digit. + and - are insignificant for it.

## 2's Complement

Two's complement takes a different approach to manage -ve integers, which ensures that there is no opportunity for 2 representations of zero to exist.

In 2's complement, the number of possible combinations are divided into two halves.

The lower halve represents +ve integers while the upper halve represents -ve integers. The word "represents" is especially important here because at the end of the day, these are just pair of bits. They don't represent anything. We ourselves assign meaning to them.

So, to get the 2's complement of a number:
  1. Start with the binary representation of the +ve number.
  2. Get 1's complement.
  3. Add 1 (0001) to the result.

Example:
  - 5 in binary is represented by: `0b00000101`
  - 1's complement of 5: `0b11111010`
  - Add 1: `0b11111010` + `0b00000001` = `0b11111011`
  - We get -5 in 2's complement as `0b11111011`
  - (+5) + (-5) = `0b00000101` - `0b11111011` = `0b00000000`, Hence proved!

### But how does this solves the problem?

Lets take an example using 4-bits, because combinations here are not too less, not too more.
  - By default, 4-bits are meant to represent a total of 16 combinations of bits. Meaning, 16 integers in total, or better, **16 unsigned integers**.
  - Total possible combinations = 2^n = 2^4 = 16, where n is the number of bits.
  - These combinations are:
      0000, 0001, 0010, 0011, 0100, 0101, 0110, 0111, 1000, 1001, 1010, 1011, 1100, 1101, 1110, 1111

  - Now 2's complement divides these into two halves. Therefore, both of them will get 8-8 values.
  - The lower halve or the left portion will represent +ve integers while the upper halve or right portion will represent -ve integers.
  - Visually, [0000, 0001, 0010, 0011, 0100, 0101, 0110, 0111] will represent +ve integers and [1000, 1001, 1010, 1011, 1100, 1101, 1110, 1111] will represent equivalent -ve integers.

  - The question is how! Let's look at that.

  - By using the formula mentioned above, we get the possible integers in a 4-bit setting. [(-2)^(4-1), 2^(4-1)-1] = [(-2)^3, (2^3)-1] = [-8, +7]
  - Now mathematically, we know that the possible +ve integers in a 4-bit setting are [0, 7] while the set of -ve integers is [-8, -1]. Both contains 8 combinations in total.
  - And clearly, there seems to have no place for two representations of 0.

  - But how the upper halve will get mapped to the lower halve? Let's see.

  - If you notice the upper halve, you'll find that all the combinations have the most significant bit (MSB) set to 1. And its obvious. To obtains integers from 8-15, you need the 4th bit, or the MSB here, to be 1.
  - But this is not true with the lower halve. Lower halve has MSB set to 0 for all combinations.
  - And this forms the distinction.
  - In 2's complement, all the +ve integers have their "**MOST SIGNIFICANT BIT (MSB)**", set to 0. And the -ve integers have this bit set to 1.
  - To map them, take out the upper halve, and put it in the left of the lower halve. We'll get something like this:

      1000, 1001, 1010, 1011, 1100, 1101, 1110, 1111, 0000, 0001, 0010, 0011, 0100, 0101, 0110, 0111

       -8    -7    -6    -5    -4    -3    -2    -1     0    +1    +2    +3    +4    +5    +6    +7

  - To obtain the -ve representations of 0, we need all the bits to be 0 while the MSB set to 1, right? This brings us to 1000. But this is -8.

  - But this is just visually, isn't it? What about proving it mathemtically? Also, if there is -8, where is +8? Great, let's do that.
    - If you see the grid above, you can note that every -ve equivalent is of the form `-(2^n) + (+ve integer)`
    - Ex: -8 => -(2^4) + (+8) = -16 + 8 = -8 (1000)
    - Ex: -1 => -(2^4) + (+1) = -16 + 1 = -15 (1111)
    - lets do this for 0:
      - -0 => -(2^4) + (+0) = -16 + 0 = -16
      - But 16 as a combination is not possible using 4-bits.
      - I think, this is enough to prove that 2's complement by design has got no room for two representations of zero. And it is more accurate mathematically as well.