# Arrays

Arrays are just continuous block of memory, nothing special.
  - There is nothing like int_array, char_array, or even dynamic arrays we see in dynamically-typed languages like Python and JavaScript.
  - And just as with everything in asm, it is the programmer's job to give meaning to these continuous memory location **as an array**.

An array can be declared both as a static variable (in `.data`) or a dynamic variable, which is readed from input (`.bss`).

C-like convention is followed in assembly as well, while declaring an array. We have to define what kind of element-size we are dealing with. Is this array bit-sized or something in other size.

## Statically Defined Arrays

To create and declare an array on-the-spot, like we do this in C:
```c
int arr = {1, 2, 3, 4};
```

We use the following syntax:
```asm
.section .data
  array1: .byte 1, 2, 3, 4
  array2: .long 10, 20, 30, 40
  array3: .quad 100, 200, 300, 400
```
> Here, array1 is a byte-sized array, meaning, every element in array1 is of 1-byte.
> array2 is a 32-bit or 4-byte array.
> array3 is a 64-bit or 8-byte array.

You can notice the pattern. In C, we create arrays like this:

```c
void main(){
  char gen = {'M', 'F'};
  int marks = {4, 5};
  float cgpa = {4.2, 6.4};
  double height = {1.7213, 1.8012}    // in meters
  // and so one
}
```
> In C, we mention the type not the size. But the type is also associated to a size.
> A char is 1-byte, therefore, it is a byte-sized array.
> An int is 2-byte on 64-bit, so 2-byte array.
> A float is 4-byte on 64-bit, so 4-byte array.
> And double is 8-byte, so 8-byte array.

### Element Size Table

| Type  | GAS Directive | Size (bytes) | MOV instruction   |
| ----- | ------------- | ------------ | ----------------- |
| byte  | `.byte`       | 1            | `mov al, [addr]`  |
| word  | `.word`       | 2            | `mov ax, [addr]`  |
| dword | `.long`       | 4            | `mov eax, [addr]` |
| qword | `.quad`       | 8            | `mov rax, [addr]` |

----

Before we go about uninitialised arrays, lets understand and clarify certain things.

First, we will understand [scopes](./scope.md).

Next we will introduce [symbols and the difference b/w labels and symbols](./symbols.md).

Now we are ready to understand uninitialised array definition.

## Uninitialised Arrays

GAS provides three ways to do this:
  1. `.skip`
  2. `.comm`
  3. `.lcomm`

```asm
.section .bss
  buff1: .skip 40
  .lcomm buff2, 40
  .comm buff3, 40
```
> All are same, except the difference that we have read in scopes and symbols. But right now, all of them are just the same thing.

All the 3 declarations are a pointer to a 40-bytes of zeroed memory.
  - It can be treated as a byte-sized array, where we can store 40 distinct elements of 1 byte each.
  - It can be treated as a word-sized array, where we can store 20 distinct elements of 2 bytes each.
  - It can be treated as a dword-sized array, where we can store 10 distinct elements of 4 bytes each.
  - And it can be treated as a qword-sized array, where we can store 5 distinct elements of 8 bytes each.

Therefore, interpretation matters in case of uninitialised array.

## Accessing Individual Elements

Since it's all about continuous memory blocks, the memory address of any element can be obtained via a standard formula, which is:

```
Address of i'th element = base_address + (i * element_size) 
```
> Here, base address is the memory location at which the first element in the array is stored.
> i denotes the position of element we want to see.

Before we go about accessing elements, I want to know why every language follows 0-based indexing. Why the first element is at 0, not 1?

### 0-based Indexing Rule

We write `arr[i]` to access the ith element. But `arr[i]` is just a high-level construct, because we don't use [] like that at low-level. So what does `arr[i]` resolves to?

`arr[i]` is same as `(arr + i*size)`

Even in C, internally, arr is just a pointer to the first item in the array.

If we want to access the first element through pointer dereferncing directly, it should be `*(arr)`, right? Because `arr` is already pointing at the first element. Lets test this with 0-based indexing and 1-based indexing.
  + In 0-based indexing, first element is at 0-th position. So to obtain the first element, we have to write: `*(arr + 0*4)`, which gives us `*(arr)`, which is what we wanted.
  + In 1-based indexing, first element is at 1-th position. So to obtain the first element, we have to write: `*(arr + 1*4)`, which gives us `*(arr + 4)`, which is same as `[arr++]`. Is this what we wanted? NO.

This proves that 0-based indexing is not just a design decision, but a logical decision as well.

Take this:
```asm
.section .data
  arr: .byte 1, 2, 3, 4
```

Let's assume the array starts at 1000.
  - The first thing we need to do is to load the effective address of arr into rsi.
    ```asm
    lea rsi, arr
    ```
  - Now we can dereference rsi to obtain the elements. Checkout [static-array.asm](./static-array.asm) and tweak `mov rdi, [arr + 3]` from 0-3.
