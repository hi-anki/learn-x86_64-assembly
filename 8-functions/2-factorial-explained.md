# Factorial Program Explanation With Stack Layout

```
1000    <-- Initial top (rsp)
0992    <-- return address (from line 40 or _start)
0984    <-- old rbp (caller: main with rdi = 6)
0976    <-- 6 (push rdi = 6)
0968    <-- return address (from line 19 or factorial label)
0960    <-- old rbp (caller: rdi = 5)
0952    <-- 5 (push rdi = 5)
0944    <-- return address (from line 19 or factorial label)
0936    <-- old rbp (caller: rdi = 4)
0928    <-- 4 (push rdi = 4)
0920    <-- return address (from line 19 or factorial label)
0912    <-- old rbp (caller: rdi = 3)
0904    <-- 3 (push rdi = 3)
0896    <-- return address (from line 19 or factorial label)
0888    <-- old rbp (caller: rdi = 2)
0880    <-- 2 (push rdi = 2)
0872    <-- return address (from line 19 or factorial label)
0864    <-- old rbp (caller: rdi = 1)
0856    <-- 
.
.
.
.
0024
0016
0008
0000
```

After 2 is pushed onto stack, rdi becomes 1.

Then factorial is called once again. But this time, the condition will match and it will go to the base_case label.

There, rax will become 1. Since there is no jump statement, it will directly jump to done. 

Inside done, rbp is moved into rsp. Remember, rbp here is the rbp of the caller which had rdi = 1. This is the current stack frame. Next, rsp is dererefenced and its value is transferred into rbp. rsp is pointing at 0864 or the old rbp of rdi = 1. Now rbp is pointing at rbp of rdi = 2. and after return we are at 2 (0880) The 2 (current rsp points) is popped into rdi and imul is done, which was 1 * 2. Again go to done and repeat the process. That's how we get 6!