---
description: >-
  This article explores Executable & Linkable File Format (popularly known as
  ELF) and the lifecycle of processes in Linux
layout:
  title:
    visible: true
  description:
    visible: true
  tableOfContents:
    visible: true
  outline:
    visible: true
  pagination:
    visible: false
---

# Understanding ELF And Processes In Linux

The article is structured into three parts.

1. How the source code is compiled into an executable file?
2. What is an executable?
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

which we can compile using GNU C Compiler or `gcc` with the following command:

```bash
gcc hello.c -o hello_executable
```

On running it, we get the desired output.

```bash
./hello_executable

Hello, World!
```

This simple process involves a lot of complexity, which is hidden under abstractions. The first thing we need to do is to remove this abstraction and understand what happens under the hood.

A source code becomes an executable file after following 4 steps. These are:

1. Preprocessing
2. Compilation
3. Assembling
4. Linking

Lets dive into each.

### Preprocessing

Every C code at least includes this one line, `#include <stdio.h>`, where `#include` is a preprocessing directive.

These directives are needed to be processed (or extended) before we can move any further.

This preprocessing is carried out using `gcc -E hello.c -o hello.i` .

The file obtained here is an intermediate file with `.i` extension, which is a raw-c file with all the preprocessing directives resolved into actual references.

**Note:** If you look at `hello.i` and `stdio.h` simultaneously, you will find that it is not exactly copied. It is because the header file itself has got various macros. And the extension is based on those macros.

### Compilation

The intermediate C code is compiled into assembly instructions, which is the closest we can get to CPU yet retaining some readability.

The flavor of assembly (Intel or AT\&T) depends upon the assembler program used to compile the source code. For example,

* If `as` is used, it generates AT\&T assembly by default. Although it can be configured to generate Intel assembly as well. `as` is an assembler by the GNU foundation. Same is observed with `gcc`, which stands for **GNU C Compiler**.
* If `nasm` (netwide assembler) is used, it generates Intel assembly.

The architecture specific things (x86 and x86\_64) are taken care by the assembler itself.

To compile intermediate C code into assembly code, we can run the following command:

```c
gcc -S hello.i -o hello.s
```

### Assembling

The assembly code is converted into object code, or machine code. This is the actual code which gets executed on the CPU.

The object code can be obtained as:

```bash
gcc -c hello.s -o hello.o
# OR
as hello.s -o hello.o
```

Here, the assembly instructions are translated into binary opcodes (operation codes).

The file obtained in this step is an object file with `.o` extension.

* Object files are strict in their structure. They follow a format known as _Executable File Format_, popularly known as ELF.
* But this object file is not an executable yet. It needs to be linked.

### Linking

To give an object code execution power, we need to link it with specific libraries.

The question which is worth asking is why an object code is not directly executable? Why linking is required when the object is already prepared?

* In the above program, we are using a function called `printf()` for printing `Hello, World!` to the output. Where is that function coming from? Ah, the header file?
* Yes. Where does the header file come from? `glibc`?
* Yes. Where is `glibc`? Somewhere on the OS? Yeah.
* You can see that it is not very straightforward. The object code has unresolved reference and until this problem is solved, how will you have executable power? _And we will see these unresolved references very soon._
* In simplest terms, _linking is the process of laying down the ground work for the executable to work. As we will find that this is not actually the last step, later._

Linking can be static or dynamic. Both the options have their specific use cases.

* For example, dynamic linking is the default linking that compilers use. Why? _We will learn that soon._

And now we have our executable.

