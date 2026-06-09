# push and pop mnemonics and gbd

based on the pushpop.asm file, we will analyze it with gdb.
```bash
nasm -f elf pushpop.asm

ld -m elf_i386 pushpop.o -o output

gdb ./pushpop
```

first thing is first, we will add a breakpoint at our entry point and run it:
```bash
(gdb) break *_start 
Breakpoint 1 at 0x8049000
(gdb) run
Starting program: /home/ab3b9a07057a/output 
warning: Error disabling address space randomization: Operation not permitted

Breakpoint 1, 0x08049000 in _start ()
(gdb) 

```

after this we are going to hop right into our next instruction with `nexti`. We want to understand how we are working with the stack here, so to be able to examen it we can use `x/x $esp`. 

> `x/x $esp` as a command will examine and display in hex, the value at the esp register. esp is the stack pointer, meaning it points to the top of the stack.

right now we have only pushed one value onto the stack, a 1, and so examining esp is enough:
```bash
(gdb) nexti
0x08049002 in _start ()
(gdb) x/x $esp
0xffb8085c:     0x00000001
(gdb) 
```

from here we are goint to run through the next three instructions by running `nexti` 3 times, which will enter the rest of the values. We will look into the stack again with `x/4x $esp`

> we use `4x` instead of `x` because we want the last four values on the stack.

we should see  `0x4`, `0x3`, `0x2`, and `0x1`, as the stack is a FIFO data structure.
```bash
(gdb) nexti
0x08049004 in _start ()
(gdb) nexti
0x08049006 in _start ()
(gdb) nexti
0x08049008 in _start ()
(gdb) x/4x $esp
0xffb80850:     0x00000004      0x00000003      0x00000002      0x00000001
```

---

A quick check with `disas _start` should place us before the pop instruction:
```bash
(gdb) disas _start
Dump of assembler code for function _start:
   0x08049000 <+0>:     push   0x1
   0x08049002 <+2>:     push   0x2
   0x08049004 <+4>:     push   0x3
   0x08049006 <+6>:     push   0x4
=> 0x08049008 <+8>:     pop    eax
   0x08049009 <+9>:     pop    ebx
   0x0804900a <+10>:    pop    ecx
   0x0804900b <+11>:    pop    edx
   0x0804900c <+12>:    push   eax
   0x0804900d <+13>:    push   ebx
   0x0804900e <+14>:    push   ecx
   0x0804900f <+15>:    push   edx
   0x08049010 <+16>:    mov    ebx,0x0
   0x08049015 <+21>:    mov    eax,0x1
   0x0804901a <+26>:    int    0x80
End of assembler dump.
(gdb) 
```

we can hop onto the next instruction and at this point we should have popped the value off the top of the stack and into eax. we can check the state of the stact with `x/3x $esp`, and also check that 4 actually made it into `eax` with `info registers`:
```bash
(gdb) nexti  
0x08049009 in _start ()
(gdb) x/3x $esp
0xffb80854:     0x00000003      0x00000002      0x00000001
(gdb) info registers
eax            0x4                 4
ecx            0x0                 0
edx            0x0                 0
ebx            0x0                 0
esp            0xffb80854          0xffb80854
ebp            0x0                 0x0
esi            0x0                 0
edi            0x0                 0
eip            0x8049009           0x8049009 <_start+9>
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

if we run `nexti` three more times to run the missing pop instructions we should see our values are not in the stack and have been popped to their correspoding registers(eax: 4, ecx: 2, edx: 1, ebx: 3):
```bash
(gdb) nexti
0x0804900a in _start ()
(gdb) nexti
0x0804900b in _start ()
(gdb) nexti
0x0804900c in _start ()
(gdb) info registers
eax            0x4                 4
ecx            0x2                 2
edx            0x1                 1
ebx            0x3                 3
esp            0xffb80860          0xffb80860
ebp            0x0                 0x0
esi            0x0                 0
edi            0x0                 0
eip            0x804900c           0x804900c <_start+12>
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
the missing four instructions will push the values in the registers back into the stack in the same order they were popped off. meaning if our stack was 4, 3, 2, 1 and was popped in that order, once pushed again it will be 1, 2, 3, 4.

```bash
(gdb) nexti
0x0804900d in _start ()
(gdb) nexti
0x0804900e in _start ()
(gdb) nexti
0x0804900f in _start ()
(gdb) nexti
0x08049010 in _start ()
(gdb) info registers
eax            0x4                 4
ecx            0x2                 2
edx            0x1                 1
ebx            0x3                 3
esp            0xffb80850          0xffb80850
ebp            0x0                 0x0
esi            0x0                 0
edi            0x0                 0
eip            0x8049010           0x8049010 <_start+16>
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
(gdb) x/4x $esp
0xffb80850:     0x00000001      0x00000002      0x00000003      0x00000004
(gdb) 
```

you can see that push did not zero the registers we popped our values into, so they still appear there when we run `info registers`, we would need to zero those out ourselves.
