# Common Terminologies In An Assembly Program

1. **Mnemonic:** The actual CPU operation.

2. **Operand:** The values passed to the mnemonic, which could be a register, intermediate or a memory location.

3. **Instruction:** Something the CPU can execute. It includes both the mnemonic and the operands.

4. **Immediate**: An immediate is a constant value, like `4`.

5. **Label:** A name given to a particular memory address in the code. 
   + It is made up of letters, digits and underscore. 
   + A label must start with a letter or underscore.
   + A label must end with a colon.
   + It holds meaning for the assembler (`GAS`, in our case), not the CPU. The assembler replaces the labels with virtual addresses or offsets.

6. **Directive (or Pseudo-Instruction):** Instructions defined for the assembler program, not the CPU. 
   + They begin with a period (`.`).
   + Ex: `.section` creates a section within the program.

7. **Section:** The code is divided into multiple sections to organise the memory layout.

8. **Comment:** Anything after a semi-colon (;) or hash (#) is ignored by the assembler and is a note for the programmer itself.

9. **Keyword:** In high-level languages, keywords are reserved words (like if, for, while). In assembly, the idea of keywords basically overlaps with mnemonics and directives.

10. **Symbol:** This is the most conflicting one, so lets skip it, for the time being.

## Memory/Pointer Dereferencing

It refers to obtaining the actual value stored at a memory location.

It is done by `[]`.

For example, if a memory location like 100000 stores a number, such as 45, dereferencing the memory location would give 45, like this, `[100000] = 45`

## Type Specifier

Type specifiers are used to explicitly tell the assembler what size of data we're working with when the accessing memory.

They ensure that the assembler knows how much data to read or write, especially when dealing with different data types or sizes.

Common type specifiers include:
  1. `byte ptr`: load only 1-byte from the memory address.
  2. `word ptr`: load a word or 2-bytes (in x86_64) from the memory address.
  3. `dword ptr`: load a double word or 4-bytes from the memory address.
  4. `qword ptr`: load a quad word or 8-bytes from the memory address.

They are particularly important (actually necessary) when working with memory operands and dereferncing pointers because x86_64 architecture can handle different sizes of data (like bytes, words, double words, etc).

Also, there exist separate operations, which are optimized for a particular data type, like `movq`, which moves a quad-word value.

# Anatomy Of An Assembly Program

## 1. Section

Sections define how the memory layout would be prepared. Common sections include:

  1. `.text`, for code or instructions.
  2. `.data`, for initialized.
  3. `.bss`, for uninitialized, where bss stands for "Block Started by Symbol".
     - It refers to a label (symbol) that marks the start of a block of uninitialized data in memory.
     - It helps in reducing the size of the object files by leaving a note for the system to allocate x bytes at runtime for this block and zero-initialize them.
  4. `.rodata`, for read-only.

## 2. Registers (As Operands)

You might have seen some old lectures of assembly where someone might be using ax, bx, cx, dx like registers, or eax, ebx, ecx, edx and the most recent ones might be using rax, rsi, rdi etc....

We know that x86 architecture emerged from 8086 processor, which was a 16-bit processor. The two letterd registers we see belongs to the 16-bit architecture.
  - These 16-bit registers also have smaller ones. They are sized 8-bits each.
  - They are called high and low. For example, `ax` has `al` and `ah`.

Intel extended them to 32-bit architecture. This increased the register width and now all the registers from the previous 16-bit architecture got prefixed by an e. So, ax become eax, bx become ebx and so on. `e` stands for extended.

AMD extended it further to 64-bit architecture. The register width increased again and we get new registers prefixed with r, while retaining the existing ones. So, ax become rax, bx become rbx and so on. Along with this, we have got 8 new general purpose registers from r8-r15.

The newer systems are also backward compatible. This means that x86_32 still supports x86 registers, x86_64 still supports x86 and x86_32.
  - Or, in simple terms, we can address each pair of bits.
  - `rax` is refers to complete 64-bits, `eax` refers to 32-bits, `ax` refers to 16-bits, `ah` refers to high 8-15 bits and `al` refers to 0-7 bits of the same register.
  - [This is hard to explain in words, so here is a visual diagram](https://miro.medium.com/v2/resize:fit:1100/format:webp/1*PSTOKsqSfpKLxrFEr2BY2Q.png).

[A complete GPR list](https://www.google.com/imgres?q=x86%2064%20rax%20register%20anatomy&imgurl=https%3A%2F%2Fwww.researchgate.net%2Fpublication%2F342043300%2Ffigure%2Ftbl1%2FAS%3A900496000827404%401591706385889%2FThe-sixteen-x86-64-general-purpose-registers-and-their-sub-registers.png&imgrefurl=https%3A%2F%2Fwww.researchgate.net%2Ffigure%2FThe-sixteen-x86-64-general-purpose-registers-and-their-sub-registers_tbl1_342043300&docid=xbGBS-ISu9YcPM&tbnid=iHb1hi27pi33ZM&vet=12ahUKEwjtu8-Zo4yNAxW7XmwGHfwTDG4QM3oECFoQAA..i&w=565&h=466&hcb=2&ved=2ahUKEwjtu8-Zo4yNAxW7XmwGHfwTDG4QM3oECFoQAA)

+ When we use rax, we are using the complete 64-bit register.
+ When we use eax, we are using the lower 32-bits of the rax register.
+ When we use ax, we are using the lower 16-bits of the rax register.
+ When we use al, we are using the lowest 8-bits of the rax register, 0-7.
+ When we use ah, we are using the 8-bits after al, 8-15.

## 3. Data Addressing Modes

1. Immediate Mode.
   + The simples method.
   + Here, the data to access is embedded in the instruction itself.
   + Example: `mov eax, 5 ; Move the value 5 into EAX register`

2. Register Addressing Mode.
   + The instruction contains a register to access, rather than a memory location.

3. Direct Addressing Mode.
   + The instruction contains the reference to the memory address to access.
   + Example: `mov eax, [some_address]  ; Move data from memory at some_address into EAX`

4. Indexed Addressing Mode.
   + The instruction contains a memory address to access, and also specifies an index register to offset that address.
   + Example: `mov eax, [ebx + 4]  ; Move data from the address in EBX + 4 into EAX`

5. Indirect Addressing Mode.
   + The instruction contains a register that contains a pointer to where the data should be accessed.
   + Example: `mov eax, [ebx]  ; Move data from the address in EBX into EAX`

6. Base Pointer Addressing Mode.
   + This is similar to indirect addressing, but you also include a number called the offset to add to the register's value before using it for lookup.

## System Calls (or Syscalls)

There will be times when we'd require to interact with the operating system, like printing to the screen, reading user input, or managing files. This is done via system calls (or interrupts, in older systems).

----

Always leave an empty line at end. This gracefully marks the end of assembly code. Otherwise, you'll get a warning by the assembler.