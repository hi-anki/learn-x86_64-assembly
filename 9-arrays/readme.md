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

Before we go about uninitialised arrays, lets understand and clarify certain things.

First, we will understand [scopes](./scope.md).

Next we will introduce [symbols and the difference b/w labels and symbols](./symbols.md).