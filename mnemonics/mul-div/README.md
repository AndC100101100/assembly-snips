# mul and div
> mul and div always use the eax register as the source, and the result of the instruction is also always stored in eax.

we will Compile and run the code with GDB and set a breakpoint at the entry point:
```bash
nasm -f elf muldiv.asm

ld -m elf_i386 muldiv.o -o output

gdb ./muldiv

break *_start

run
```
---
we need to load a source value int `eax`, as it mul and div uses it to store the source and result of our operation. This assembly uses 4, so run `nexti` and check the registers:
```bash
(gdb) break *_start
Breakpoint 1 at 0x8049000
(gdb) run
Starting program: /home/81fcc100d040/output 
warning: Error disabling address space randomization: Operation not permitted

Breakpoint 1, 0x08049000 in _start ()
(gdb) nexti
0x08049005 in _start ()
(gdb) info registers
eax            0x4                 4
ecx            0x0                 0
edx            0x0                 0
ebx            0x0                 0
esp            0xffd657d0          0xffd657d0
ebp            0x0                 0x0
esi            0x0                 0
edi            0x0                 0
eip            0x8049005           0x8049005 <_start+5>
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
```

for mul and dive we cannot use immediate vals to do the operations. we need to load a value into a register and then multiply or divide by the register in question. In this case we stored 2 in `ebx`:
```bash
(gdb) nexti
0x0804900a in _start ()
(gdb) info registers
eax            0x4                 4
ecx            0x0                 0
edx            0x0                 0
ebx            0x2                 2
esp            0xffd657d0          0xffd657d0
ebp            0x0                 0x0
esi            0x0                 0
edi            0x0                 0
eip            0x804900a           0x804900a <_start+10>
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

the next instruction is the multiplication of 4*2 and its result should be saved into `eax`
```bash
(gdb) nexti 
0x0804900c in _start ()
(gdb) info registers
eax            0x8                 8
ecx            0x0                 0
edx            0x0                 0
ebx            0x2                 2
esp            0xffd657d0          0xffd657d0
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
(gdb) 
```

we then divide by 4 through the same process of placing 4 into ebx:
```bash
(gdb) nexti 
0x08049011 in _start ()
(gdb) info registers
eax            0x8                 8
ecx            0x0                 0
edx            0x0                 0
ebx            0x4                 4
esp            0xffd657d0          0xffd657d0
ebp            0x0                 0x0
esi            0x0                 0
edi            0x0                 0
eip            0x8049011           0x8049011 <_start+17>
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
and divide:
```bash
(gdb) nexti 
0x08049013 in _start ()
(gdb) info registers
eax            0x2                 2
ecx            0x0                 0
edx            0x0                 0
ebx            0x4                 4
esp            0xffd657d0          0xffd657d0
ebp            0x0                 0x0
esi            0x0                 0
edi            0x0                 0
eip            0x8049013           0x8049013 <_start+19>
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
