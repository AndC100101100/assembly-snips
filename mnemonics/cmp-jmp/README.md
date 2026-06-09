# cmp and jmp

as always

```bash
nasm -f elf cmpjmp.asm

ld -m elf_i386 cmpjmp.o -o cmpjmp

gdb ./cmpjmp

break *_start

run
```

we can see the jmp instruction:
```bash
(gdb) disas _start
Dump of assembler code for function _start:
=> 0x08049000 <+0>:     jmp    0x8049010 <main>
End of assembler dump.
```

disas main

The next few instructions will set up a comparison.

Run nexti, and 10 should now be in eax.

Run info registers to check and keep an eye out on the eflags register also. You should see something like ` eflags 0x202 [ IF ]`:

```bash
(gdb) disas main
Dump of assembler code for function main:
=> 0x08049010 <+0>:     mov    eax,0xa
   0x08049015 <+5>:     cmp    eax,0xa
   0x08049018 <+8>:     je     0x8049002 <equal>
End of assembler dump.
(gdb) nexti 
0x08049015 in main ()
(gdb) info registers
eax            0xa                 10
ecx            0x0                 0
edx            0x0                 0
ebx            0x0                 0
esp            0xffd5b490          0xffd5b490
ebp            0x0                 0x0
esi            0x0                 0
edi            0x0                 0
eip            0x8049015           0x8049015 <main+5>
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
we can run the next step and see the next `eflags 0x202 [ IF ]`, as we should have performed the comparison of 10 against 10:
```bash
(gdb) nexti
0x08049018 in main ()
(gdb) info registers
eax            0xa                 10
ecx            0x0                 0
edx            0x0                 0
ebx            0x0                 0
esp            0xffd5b490          0xffd5b490
ebp            0x0                 0x0
esi            0x0                 0
edi            0x0                 0
eip            0x8049018           0x8049018 <main+8>
eflags         0x246               [ PF ZF IF ]
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
That is because cmp checks if the two values are equal by subtracting one from the other and then checking if the result is zero. In this case, 10 - 10 is 0, so the zero flag (ZF) is set in the eflags register and the CPU knows these two values are equal.


---
disas equal

Here we are going to be moving 12 into eax and 6 into ebx and then comparing them.

```bash
(gdb) disas equal
Dump of assembler code for function equal:
=> 0x08049002 <+0>:     mov    eax,0xc
   0x08049007 <+5>:     mov    ebx,0x6
   0x0804900c <+10>:    cmp    eax,ebx
   0x0804900e <+12>:    jne    0x804901a <notequal>
End of assembler dump.
(gdb) nexti 
0x08049007 in equal ()
(gdb) nexti
0x0804900c in equal ()
(gdb) info registers
eax            0xc                 12
ecx            0x0                 0
edx            0x0                 0
ebx            0x6                 6
esp            0xffd5b490          0xffd5b490
ebp            0x0                 0x0
esi            0x0                 0
edi            0x0                 0
eip            0x804900c           0x804900c <equal+10>
eflags         0x246               [ PF ZF IF ]
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

Check eax and ebx and keep an eye on eflags also. For eflags, you should see something like this:

`eflags 0x246 [ PF ZF IF ]`

Notice how eflags no longer has ZF (zero flag) set:

`eflags 0x206 [ PF IF ]`

The two don't match, and so the next instruction, jump not equal (jne), will cause us to jump to the notequal label.

---
disas notequal

Here we just move 7 into eax to prove they were not equal and then we jump to the exit of the program.

```bash
(gdb) nexti
0x0804900e in equal ()
(gdb) disas notequal
Dump of assembler code for function notequal:
   0x0804901a <+0>:     mov    eax,0x7
   0x0804901f <+5>:     jmp    0x8049021 <exit>
End of assembler dump.
(gdb) nexti
0x0804901a in notequal ()
(gdb) info registers
eax            0xc                 12
ecx            0x0                 0
edx            0x0                 0
ebx            0x6                 6
esp            0xffd5b490          0xffd5b490
ebp            0x0                 0x0
esi            0x0                 0
edi            0x0                 0
eip            0x804901a           0x804901a <notequal>
eflags         0x206               [ PF IF ]
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
(gdb) nexti
0x0804901f in notequal ()
(gdb) 
```
