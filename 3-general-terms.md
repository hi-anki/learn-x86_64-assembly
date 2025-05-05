# Terminology Used By An Assembly Program
1. **Mnemonic:** The operation's name that the CPU is going to perform.
2. **Operand:** The values passed to the operation to act on. Could be a register, intermediate or memory.
3. **Instruction:** An operation that the CPU can execute. It includes the mnemonic and the operands.
4. **Label:** A name given to a particular memory address in the asm code. 
   + It is made letters, digits and underscore. 
   + A label must start with a letter or underscore.
   + A label must end with a colon.
   + It holds meaning for the assembler program, not the CPU.
5. **Directive (or Pseudo-Instruction):** Instructions for the assembler program, not the machine. 
   + They begin with a period.
   + Ex: `.section` creates section within the program.
6. **Section:** The code is divided into multiple sections to organise the memory layout.
7. **Comment:** Anything after a semi-colon (;) is ignored by the assembler and is meant for the programmer itself to understand what is happening.
8. **Keyword:** In high-level languages, keywords are reserved words (like if, for, while). In assembly, the idea of keywords overlaps with mnemonics and directives.
9. **Symbol:** Any names representing an address — typically labels or variable names. These are resolved by the assembler/linker.

# Anatomy Of An Assembly Program
## 1. Section
+ Every assembly program has sections that define where the code, data, and other resources will be stored. The ones that are used the most include:
  1. `.text` -- this is where the code or the instructions go.
  2. `.data` -- this is where the initialized data go.
  3. `.bss` -- this is where the uninitialized data go. In case you want to know what bss stands for, it is "Block Started by Symbol".
  4. `.rodata` -- this is where the read only data go.

+ These sections help the assembler organize your program. They also tell the linker how to arrange memory when the program runs.
+ And remember, sections are also assembler directives.

## 2. Registers (As Operands)
+ You might have already seen multiple lectures of assembly on YouTube where someone might be using ax, bx, cx, dx like registers, some other migh be using eax, ebx, ecx, edx and some other (the most recent ones) might be using rax, rsi, rdi etc....
+ We know from the architectural history that x86 architecture emerged from 8086 processor, which was a 16-bit processor. The two letterd registers we see belongs to the 16-bit architecture.
+ Then Intel extended them to form x86_32 family, which was based on 32-bit architecture. This increased the register width and now all the registers from the previous 16-bit architecture got prefixed by an e. So, ax become eax bx  become ebx and so on.
+ Then AMD extended it further to AMD64 (or x86_64), which was based on 64-bit architecture. The register width increased again and we get new registers prefixed with r, while retaining the existing ones. So, ax become rax, bx become rbx and so on. Along with this, we have got 8 new general purpose registers from r8-r15.
+ The newer systems are also backward compatible. This means that x86_32 still supports x86 registers, x86_64 still supports x86 and x86_32.
+ An important thing to understand here is that eax is not a new register. It is an extended version of it. The eax will still contain ax. And this is true for r prefixed registers as well. [This is hard to explain in words, so here is a visual diagram](https://miro.medium.com/v2/resize:fit:1100/format:webp/1*PSTOKsqSfpKLxrFEr2BY2Q.png).
+ [Refer to to this image for a simple register list](https://www.google.com/imgres?q=x86%2064%20rax%20register%20anatomy&imgurl=https%3A%2F%2Fwww.researchgate.net%2Fpublication%2F342043300%2Ffigure%2Ftbl1%2FAS%3A900496000827404%401591706385889%2FThe-sixteen-x86-64-general-purpose-registers-and-their-sub-registers.png&imgrefurl=https%3A%2F%2Fwww.researchgate.net%2Ffigure%2FThe-sixteen-x86-64-general-purpose-registers-and-their-sub-registers_tbl1_342043300&docid=xbGBS-ISu9YcPM&tbnid=iHb1hi27pi33ZM&vet=12ahUKEwjtu8-Zo4yNAxW7XmwGHfwTDG4QM3oECFoQAA..i&w=565&h=466&hcb=2&ved=2ahUKEwjtu8-Zo4yNAxW7XmwGHfwTDG4QM3oECFoQAA)

+ When we use rax, we are using the complete 64-bit register.
+ When we use eax, we are using the lower 32-bits of the rax register.
+ When we use ax, we are using the lower 16-bits of the rax register.
+ When we use al, we are using the lowest 8-bits of the rax register, 0-7.
+ When we use ah, we using the 8-bits after al, 8-15.

## 3. Data Addressing Modes
1. Immediate Mode.
   + The simples method.
   + Here, the data to access is embedded in the instruction itself.
   + Example: `mov eax, 5  ; Move the value 5 into EAX register`
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
   + This is similar to indirect addressing, but you also include a number called the offset to add to the register’s value before using it for lookup.

## System Calls (or Syscalls)
+ Often there will be times when we'll require to interact with the operating system for things like printing to the screen, reading user input, or managing files. This is done via system calls (or interrupts, in older systems).