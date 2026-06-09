# labels and jmp
A jump is used to jump to a label in your code to start execution from there. It is a key instruction type in creating loops.

as always:

```bash


nasm -f elf labelsjmp.asm

ld -m elf_i386 labelsjmp.o -o labelsjmp

gdb ./labelsjmp

break *_start

run
```
---
first lets look at the code in start with `disas _start`:

```bash
(gdb) disas _start
Dump of assembler code for function _start:
=> 0x08049000 <+0>:     mov    eax,0x5
End of assembler dump.
(gdb) 
```
there is only one instruction.


this happens because the rest of the code is in loop, so we to do `disas loop` to see the rest:
```bash
(gdb) disas loop
Dump of assembler code for function loop:
   0x08049005 <+0>:     push   eax
   0x08049006 <+1>:     mov    edx,0xd
   0x0804900b <+6>:     mov    ecx,0x804a000
   0x08049010 <+11>:    mov    ebx,0x1
   0x08049015 <+16>:    mov    eax,0x4
   0x0804901a <+21>:    int    0x80
   0x0804901c <+23>:    pop    eax
   0x0804901d <+24>:    sub    eax,0x1
   0x08049020 <+27>:    jne    0x8049005 <loop>
   0x08049022 <+29>:    mov    ebx,0x0
   0x08049027 <+34>:    mov    eax,0x1
   0x0804902c <+39>:    int    0x80
End of assembler dump.
```

we can run the first instruction and see that `eax` is now 5, which is in this case, the counter of our loop:
```bash
(gdb) nexti
0x08049005 in loop ()
(gdb) info registers 
eax            0x5                 5
ecx            0x0                 0
edx            0x0                 0
ebx            0x0                 0
esp            0xff8d56d0          0xff8d56d0
ebp            0x0                 0x0
esi            0x0                 0
edi            0x0                 0
eip            0x8049005           0x8049005 <loop>
eflags         0x202               [ IF ]
cs             0x23                35
ss             0x2b                43
ds             0x2b                43
es             0x2b                43
fs             0x0                 0
gs             0x0                 0
k0             0x0                 0
k1             0x0                 0
k2             0x0                 0
k3             0x0                 0
k4             0x0                 0
k5             0x0                 0
k6             0x0                 0
k7             0x0                 0
(gdb) 
```
we run the next instruction and move into our loop label so we start pusing the value of eax onto the stack, and check the stack with `x/x $esp`. 
```bash
(gdb) nexti
0x08049006 in loop ()
(gdb) x/x $esp
0xff8d56cc:     0x00000005
```
> in this case we push `eax` onto the stack because we need the use the eax register for our sys_write system call. we need to temporarily store the value un `eax` on the stack so we do not overwrite it/
after the syscall, we pop the value back off the stack and into `eax`

the next instructions instructions set up the sys_write syscall so we can just run through them and we should see the first `Hello World!` be printed;
```bash
(gdb) nexti
0x08049006 in loop ()
(gdb) nexti
0x0804900b in loop ()
(gdb) nexti
0x08049010 in loop ()
(gdb) nexti
0x08049015 in loop ()
(gdb) nexti
0x0804901a in loop ()
(gdb) nexti
Hello World!
0x0804901c in loop ()
```
---
with that, the syscall is over and we can recover the loop counter from the stack by poping it back into eax, which should be back to 5:
```bash

(gdb) nexti
0x0804901d in loop ()
(gdb) info registers
eax            0x5                 5
ecx            0x804a000           134520832
edx            0xd                 13
ebx            0x1                 1
esp            0xff989520          0xff989520
ebp            0x0                 0x0
esi            0x0                 0
edi            0x0                 0
eip            0x804901d           0x804901d <loop+24>
eflags         0x202               [ IF ]
cs             0x23                35
ss             0x2b                43
ds             0x2b                43
es             0x2b                43
fs             0x0                 0
gs             0x0                 0
k0             0x0                 0
k1             0x0                 0
k2             0x0                 0
k3             0x0                 0
k4             0x0                 0
k5             0x0                 0
k6             0x0                 0
k7             0x0                 0
(gdb) 
```

the next instruction should substract eax to 4:
```bash
(gdb) nexti
0x08049020 in loop ()
(gdb) info registers
eax            0x4                 4
ecx            0x804a000           134520832
edx            0xd                 13
ebx            0x1                 1
esp            0xff989520          0xff989520
ebp            0x0                 0x0
esi            0x0                 0
edi            0x0                 0
eip            0x8049020           0x8049020 <loop+27>
eflags         0x202               [ IF ]
cs             0x23                35
ss             0x2b                43
ds             0x2b                43
es             0x2b                43
fs             0x0                 0
gs             0x0                 0
k0             0x0                 0
k1             0x0                 0
k2             0x0                 0
k3             0x0                 0
k4             0x0                 0
k5             0x0                 0
k6             0x0                 0
k7             0x0                 0
```

---
we now have the `jnz loop`. this is the jump if not zero type of jump, and the destination to jump to is the loop label.

> it is checking if the result of the previous instruction was a zero. If it wasn't, then we're jumping back to the loop label. Since the previous result was a 4 and not a 0, we should be going back to the loop.
```bash
(gdb) nexti
0x08049005 in loop ()
(gdb) disas loop
Dump of assembler code for function loop:
=> 0x08049005 <+0>:     push   eax
   0x08049006 <+1>:     mov    edx,0xd
   0x0804900b <+6>:     mov    ecx,0x804a000
   0x08049010 <+11>:    mov    ebx,0x1
   0x08049015 <+16>:    mov    eax,0x4
   0x0804901a <+21>:    int    0x80
   0x0804901c <+23>:    pop    eax
   0x0804901d <+24>:    sub    eax,0x1
   0x08049020 <+27>:    jne    0x8049005 <loop>
   0x08049022 <+29>:    mov    ebx,0x0
   0x08049027 <+34>:    mov    eax,0x1
   0x0804902c <+39>:    int    0x80
End of assembler dump.
(gdb) 
```
we are back to the start of the loop, which was `push eax`

we can then repeat the process of pushing the counter onto the stack to perserve it, to then verify that there is a 4 on the stack:
```bash
(gdb) nexti
0x08049006 in loop ()
(gdb) x/x $esp
0xff98951c:     0x00000004
```

and we can you just go through the rest of the loop this way
