# Scopes

We know about this already.
  - There is a global scope and a local scope.
  - Local scope is local to a block of code, while global scope is global to the file.
  - But assembly works differently.

Scopes in assembly work differently. Their meaning changes when the context changes.
  - I have mentioned this already that assembly is all about interpretation and context.
  - Interpretation within a context can differ. And once the context is changed, interpretation is bound to change.

Lets classify scopes in two forms:
  1. In-file scope
  2. Out-file scope

## 1. In-File Scope

In-file scope includes rules which are defined inside a particular file only.

Their is local scope and global scope.

Here, global scope means that the label can be used anywhere in the file.

Local scope means that a label is only available to a parent label that it is the descendant of. Example is easier than theoratical explanation here. Lets refer back to the factorial program:

```asm
factorial:
  push rbp
  mov rbp, rsp

  cmp rdi, 1          # if (n <= 1)
  jbe .base_case

  push rdi            # save n
  dec rdi             # n = n - 1
  call factorial      # factorial(n - 1)
  pop rdi             # restore n
  imul rax, rdi       # rax = rax * n
  jmp .done

.base_case:
  mov rax, 1

.done:
  mov rsp, rbp
  pop rbp
  ret
```
> Here, base_case and done are locally scoped to factorial. Because they are prefixed with a period. And the nearest most label [, in backward direction,] which has no period in prefix is factorial. Thus, they are only available to factorial.
>
> On the other hand, factorial is globally scoped, within the file.

## 2. Out-File Scope

Out-File scopes extend their control outside of the file as well.

Here, globally scoped means that a label is avaiable outside of the file as well.
  - It can be referred by other files as well.
  - It might be available to the linker as well.

By default, every label is globally scoped, within their file.
  - That means, a label is in-file scoped.

To make a label out-file scoped, we add the `.global` directive to it. For example, `.global _start`. This makes `_start` available to the linker.

On the other hand, locally scoped here means that the label is available in the file only, which is the same globally scoped in in-file scope.