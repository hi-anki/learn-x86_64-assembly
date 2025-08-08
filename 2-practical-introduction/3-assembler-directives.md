# ISA v/s Assembler

There are multiple assemblers in the market. GNU assembler, netwide assembler, fish assembler, microsoft assembler and so on....

Assembler has to do one thing. Translate human readable assembly instructions into corresponding machine opcodes which the CPU can understand and execute directly.

A CPUs instruction set architecture defines its capabilities. It conceptualises everything that the CPU can do.

Assemblers are the programs that decides how the programmers will interact with the CPU.

Take this, there are handfull of firms that research on semiconductor chips, but there are relatively many who does the manufacturing. ISA is that research while assemblers are the manufacturers. Each manufacturer (assembler) has the freedom to manufacture in its own way.

# Assembly-Time vs Run-Time

Assembler directives mean nothing to the CPU. They exist to streamline deveopment. The asembler resolves into machine understandable things while assembling the code. This is called assembly-time managment.

There are things that are consistent across all the assemblers because the CPU directly understand them. These are runtime managed things.

For example, `.section` is an assembler directive, while `lea` operation is a CPU understood operation, purely defined in the ISA itself.