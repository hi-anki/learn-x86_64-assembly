# Introducing Computer Architecture

Learning assembly is not similar to learning yet another programming language. There are no high-level constructs. There is CPU, memory and ASM instructions to program them.

To program the CPU, we must know what CPU is.
  - Learning only CPU is a time consuming process. And a boring one.
  - Without it, writing assembly is meaningless. Because we are not here for shallow understanding.

The best thing we can do is to take a hybrid approach.
  - Lets have a starting introduction and then we can build upon that.
  - As we will advance, we are going to face problems. As problems arise, we would look for solutions. And the solution is understanding the part of them which is causing the problem.
  - This is what progressive learning is about.
  - CPU and ASM is vast. Therefore, learning them to solve problems is a better to way to approach them, rather than approaching them for the sake of learn them. That's purpose-less.

Lets get going.

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
  - And this is where we will learn about context and interpretations.

# CPU

CPU or Central Processing Unit, is the physical component that actually executes instructions.

While modern systems are very complex, the role of CPU is quite simple: fetch, decode, and execute instructions stored in memory. And this what a **fetch-execute** cycle is.

The CPU needs to know the instruction to be executed, for this, it has got **Program Counter**, whose purpose is to hold the memory address of the next instruction to be executed.

Now that the CPU has the instruction, it needs to figure-out what this instruction means. For this, the CPU has **instruction decoded**.

In our everyday life, anything we do involves movement. Either we are moving things from one place to another, or we are retreving things from one place so that we can use them somewhere or we ourselves are going to multiple places. **Place** is one the most important thing in our life. And so as with CPU.
  - Every instruction uses some memory locations, where some data is stored which is required in the instruction.
  - To fetch that data from that memory location, what comes handy is the **data bus**. It is the connection between the CPU and memory.

Suppose you have to go to your best friend's house. You have picked up the keys to your bike, the cap, the scarf to protect from heat, and the sun glasses. All these things are stored somewhere in your house.
  - The key is probably on the top of the fridge or in the key-holding area.
  - The sun glasses are at the dressing table.
  - The scarf is in closet.
  - And the cap is on the table.
  - What about the address to your friend's house? Where is that? In your mind.
  - If you don't go mad on me, can I ask why don't you write the address of your friend on a paper and store it your closet?
  - Obviously you are saying, "I am not mad!" Keeping the address in your mind ensures that it is highly accessible.
  - The CPU also has some highly-efficient and rapidly-accessible locations for this exact purpose. They are called **general purpose registers**. The high-speed memory locations inside the processor itself, that takes part in the actual execution.

At last, the **Arithmetic and Logic unit**. The data and the decoded instruction is passed here for further processing. Here the instruction is actually executed. The computed results are then placed on the data bus and sent to the appropriate location in memory or in a register, as specified by the instruction.

And these are the core elements of the CPU.

## Fetch-Execute Cycle

1. **Fetch** – Read the instruction from memory (address held in instruction pointer).
2. **Decode** – Understand what the instruction means.
3. **Execute** – Perform the operation (move data, add, compare, etc).
4. **Store** – Write the result (often into a register or memory).
5. **Repeat** – Move to the next instruction.

And this happens billions of times.

# Registers

In addition to the memory on the outside of the processor, the processor itself has some special, high-speed memory locations called registers.

The primary purpose of a register is to hold the data that the CPU is actively working on. Just like the desk has a pen-holder which holds necessary pens like black and blue ball pens, a correction pen, a ruler, pencil, and rubber etc.... but it doesn't contain the whole stationary. We have cupboards for that.

Since registers are high-speed and are located within the processor itself, they are limited in number, for various valid reasons.

Most information is stored in main memory, brought in to the registers [,for processing], and then put back into memory when the processing is completed.

Just like memory, registers hold bits. It's up to you to interpret them correctly (as numbers, characters, addresses, etc.)

Mainly there are two types of registers:
  1. **General Purpose Registers**, this is where the main action happens. Addition, subtraction, multiplication, comparisions, and other operations generally use general-purpose registers for processing. They are expansive and are very less in number. There are 16 GPRs in x86_64 architecture.
  2. **Special Purpose Registers**, they have very specific purposes.

The size or the width of the register depends on the architecture.

"Word" is the fundamental unit of CPU. Just like m/s is for velocity.
  + The word is the size of the registers in a particular CPU architecture.
  + For example: 32-bit systems has a word size of 32-bits or 4-bytes.
  + Word size is the size of the data that the CPU works with.
  + It's the number of bits the CPU processes at once as a single "unit" or "word".

# Wait, What Is This 32-bit && 64-bit?

We download softwares. If that's a technical software, it is always mentioned whether you are at 32-bit or 64-bit OS. And there are different softwares for both.

Most modern systems are 64-bit.

This 32-bit and 64-bit tells us about how many numbers the CPU is capable of dealing with at once.
  - A 32-bit CPU can work with numbers that are up to 32 bits long.
  - A 64-bit CPU can work with numbers that are up to 64-bits long.

We'll dive into this in future.