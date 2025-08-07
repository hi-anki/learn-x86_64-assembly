# Enviornment Setup

To run assembly, you need an assembler and a linker.

While the choice of linker is pretty straightforward, assembler is a chaos.

There are various assemblers like GNU Assembler (as), Netwide Assembler (nasm), Microsoft Macro Assembler (masm), Flat Assembler (fasm) and the list goes on. Without chaos, we would go with GNU Assembler. Although it was designed with AT&T x86 assembly syntax, but it supports intel as well.

For linker, we would use GNU Linker (ld).

Both `as` and `ld` are a part of binutils, which can be installed by doing
```bash
sudo apt install binutils
```

A Linux distribution is preferred.

As far as an IDE is concerned, I prefer VS Code.