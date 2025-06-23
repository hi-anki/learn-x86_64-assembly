---
description: This article explores ELF binaries and the lifecycle of processes in Linux
---

# Understanding ELF And Processes In Linux

The article is structured into three parts.

1. How the source code is compiled into an executable file?
2. What is an executable? This is where we will understand about ELF.
3. What is the lifecycle of a process in Linux?



## The Journey Of A Source Code To An Executable

&#x20;This is a simple C program:

```c
// hello.c
#include <stdio.h>

void main(){
    printf("Hello, World!");
    return 0;
}
```

Which we can compile using GNU C Compiler or `gcc` with the following command:

```bash
gcc hello.c -o hello_exe
```

On running it, we get the desired output.

```bash
./exe

Hello, World!
```

This seemingly simple process involves a lot of complexity, which is hidden under abstractions.

### The Four Hidden Steps

The source code becomes an executable file after following 4 steps, namely:

1. Preprocessing
2. Compilation
3. Assembling
4. Linking

#### Preprocessing

Every C code at least includes this one line, `#include <stdio.h>`, where `#include` is a preprocessing directive.

These directives are needed to be processed before we move any further.

This preprocessing is carried out using `gcc -E hello.c -o hello.i` .

The file obtained here is an intermediate file with a `.i` extension, which is a raw-c file with all the preprocessing directives resolved into actual references.

#### Compilation

The intermediate code is compiled into assembly instructions, which is the closest we can get to CPU yet retaining some readability.

The flavor of assembly (Intel or AT\&T) depends upon the assembler program used to compile the source code. For example,

* If `as` is used, it generates AT\&T assembly by default. Although it can be configured to generate Intel assembly as well. `as` is an assembler by the GNU foundation.
* If `nasm` is used, it generates Intel assembly.

The architecture specific things (x86 and x86\_64) are taken care by the assembler itself.

To compile intermediate C code into assembly code, we can run the following command:

```c
gcc -S hello.i -o hello.s
```

#### Assembling

The assembly code is converted into object code, or machine code. This is the actual code which gets executed on the CPU.

This can be done by executing the following command:

```bash
gcc -c hello.s -o hello.o

# OR

as hello.s -o hello.o
```

Here, the assembly instructions are translated into binary opcodes.

The file obtained in this step is a file with `.o` extension, which is knows as an object file. Object files are strict in their structure. They follow a format known as _Executable File Format_ or, popularly known as ELF.

But this object file is not an executable yet.

#### Linking

To give an object code execution power, we need to link it with specific libraries.

Linking can be static or dynamic. Both the options have their merits and demerits, which we will understand very soon.

