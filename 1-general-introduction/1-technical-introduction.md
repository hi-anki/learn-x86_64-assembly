# Learning Assembly

Learning assembly is not similar to learning yet another programming language. There are no high-level constructs. There is CPU, memory and ASM instructions.

We can learn CPU architecture and memory individually, but that would be too boring.

But a hybrid approach would work.

Lets be honest, assembly does requires the knowledge of CPU and memory, which I don't have. But I can acquire it as it is required.

Lets get going.

# CPU

The CPU reads instructions from the memory *one at a time* and executes them. This is known as the **fetch-execute** cycle.

The core elements of the CPU includes:
  + **Program Counter**, holds the memory address of the next instruction to be executed.
  + **Instruction Decoder**, figures out what the instruction means. This includes what process needs to take place and what memory locations are going to be involved in this process.
  + **Data bus**, fetches the memory locations to be used in the calculation. It is the connection between the CPU and memory.
  + **General-purpose registers**, the high-speed memory locations inside the processor itself, that does the actual execution.
  + **Arithmetic and logic unit**, the data and the decoded instruction is passed here for further processing. Here the instruction is actually executed. After the results of the computation have been calculated, the results are then placed on the data bus and sent to the appropriate location in memory or in a register, as specified by the instruction.

## Fetch-Execute Cycle

1. **Fetch** – Read the instruction from memory (address held in instruction pointer).
2. **Decode** – Understand what the instruction means.
3. **Execute** – Perform the operation (move data, add, compare, etc).
4. **Store** – Write the result (often into a register or memory).
5. **Repeat** – Move to the next instruction.

And this happens billions of times.

# Memory (RAM)

Imagine a room inside of a bank, full of personal-lockers. All of these lockers exhibit some properties, like:
  1. Same size and color,
  2. Same capacity,
  3. Same access mechanism, and
  4. An addressing system to uniquely identify them.

The locker can contain anything, but what identifies them commonly is **valuables**. A person can keep gold and silver items in their locker while another person can keep the photos of their family. Items are different but both of them identifies as a valuable.

Similarly, memory is a huge collection of boxes, which have common properties, like: 
  1. They have fixed capacity of 1 byte (or 8-bits), and
  2. Each box is identified by a unique number, called the **memory address**.

Just as the bank locker can't identify if it is a jwellery or a photo, everything is identified as a valuable, memory also contains numbers only. The interpretation of these numbers make them a literal digit, an alphabet, or an emoji.

The length of the address also depends on the architecture. But as a definition, memory address is 1 word long.

# Registers

In addition to the memory on the outside of the processor, the processor itself has some special, high-speed memory locations called registers.

The primary purpose of a register is to hold data that the CPU is actively working on. Just like the desk has a pen-holder which holds necessary pens like black and blue ball pens, a correction pen, a ruler, pencil, and rubber etc.... but it doesn't contain the whole stationary. We have cupboards for that.

Since registers are high-speed and are located within the processor itself, they are limited in number, for various valid reasons.

Most information is stored in main memory, brought in to the registers [,for processing], and then put back into memory when the processing is completed.

Just like memory, registers hold bits. It’s up to you to interpret them correctly (as numbers, characters, addresses, etc.)

Mainly there are two types of registers:
  1. **General Purpose Registers**, this is where the main action happens. Addition, subtraction, multiplication, comparisions, and other operations generally use general-purpose registers for processing. They are expansive and are very less in number. There are 16 GPRs in x86_64 architecture.
  2. **Special Purpose Registers**, they have very specific purposes.

The size or the width of the register depends on the architecture.

"Word" is the fundamental unit of CPU. Just like m/s is for velocity.
  + The word is the size of the registers in a particular CPU architecture.
  + For example: 32-bit systems has a word size of 32-bits or 4-bytes.
  + Word size is the size of the data that the CPU works with.
  + It's the number of bits the CPU processes at once as a single "unit" or "word".