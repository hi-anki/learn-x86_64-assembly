# Vairables vs. Labels
**Statement**: A label is a name given to a memory location.

**To Prove**: A label is not a variable.

**Proof**: It's complicated. But I will try my best to clarify the differences.

# Similarities
There is a lot that is similar between labels and variables.

1. Both are human-readable names given to memory locations.
2. Both can start with an underscore or alphabets and can contain numbers.
3. The compiler or the assembler resolves them into actual memory addresses.
4. They both are reference to memory locations which contain a piece of data or instruction.
5. Their names themselves can't be changed, but the contents of the memory they refer to can be.

# Difference
+ Variables are strictly meant for storing data.
+ `int num = 4` and `bool res = (4 > 0)`, both the variables point to memory locations which contains static data (which can be changed, obviously).

+ Labels, on the other hand, point to memory locations which can either contain data or instructions. This is the primary difference between the two.
+ A variable is more like a watered down version of a label. You can think of a variable as a more restricted form of a label — it only refers to data.
+ The difference is actually revealed when we need to do control flow. Assembly doesn't have a pretty `if-else` ladder. It uses jump statements to do that. And jump statements utilize labels to do this.

# Conclusion
Just as every square is a rectangle but not every rectangle is a square, every variable fits the basic definition of a label — *a named memory reference* — but not every label is just a variable. Labels can do more.

In essence, labels are more general-purpose and powerful, while variables are a specific case of labeled memory used primarily for storing data.