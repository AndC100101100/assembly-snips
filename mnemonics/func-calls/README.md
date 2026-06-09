# Functions and calls

based on the funccalls.asm file

do as always, assemble, link and then add a breakpoint in gdb at the `_start` label.

once we move in, we can: 
```bash
(gdb) disas _start 
Dump of assembler code for function _start:
=> 0x0804903e <+0>:     call   0x8049000 <print>
   0x08049043 <+5>:     push   0x5
   0x08049045 <+7>:     call   0x8049020 <printparam>
   0x0804904a <+12>:    mov    ebx,0x0
   0x0804904f <+17>:    mov    eax,0x1
   0x08049054 <+22>:    int    0x80
End of assembler dump.
```
here we see two functions that do the same, one of them simply receives a parameter

nothing much here, moving on to the next instruction, we can go to the print label. Call is similar to jmp as it allows us to jump to a label, but it is only meant to be used with functions that end with the `ret` instruction.


once in the print label, we can run `disas print`, where we will see the first three instructions, all needed to do the function setup.
> every function should have its own area on the stack for local variables, in assembly we are in charge of creating it at the start of every function and remove it at the end of every function.

we need to recall our usual registers, like `ebp` which points to the bottom of the stack frame, while `esp` points to the top.

```bash
(gdb) nexti
0x08049000 in print ()
(gdb) .
Undefined command: ".".  Try "help".
(gdb) 
Undefined command: ".".  Try "help".
(gdb) disas print
Dump of assembler code for function print:
=> 0x08049000 <+0>:     push   ebp
   0x08049001 <+1>:     mov    ebp,esp
   0x08049003 <+3>:     sub    esp,0x0
   0x08049006 <+6>:     mov    edx,0xd
   0x0804900b <+11>:    mov    ecx,0x804a000
   0x08049010 <+16>:    mov    ebx,0x1
   0x08049015 <+21>:    mov    eax,0x4
   0x0804901a <+26>:    int    0x80
   0x0804901c <+28>:    mov    esp,ebp
   0x0804901e <+30>:    pop    ebp
   0x0804901f <+31>:    ret    
End of assembler dump.
(gdb) info registers
eax            0x0                 0
ecx            0x0                 0
edx            0x0                 0
ebx            0x0                 0
esp            0xffcc80bc          0xffcc80bc
ebp            0x0                 0x0
esi            0x0                 0
edi            0x0                 0
eip            0x8049000           0x8049000 <print>
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
we can se the values stored in our said registers


---
the next instructions will run the `push ebp` which will save the base pointer to the stack. another inistruction run we have have moved the value of `esp` into `ebp`. We essentially made the old top of the stack become the new bottom of the stack, giving us a new area of the stack for our function:
```bash
(gdb) nexti
0x08049001 in print ()
(gdb) nexti
0x08049003 in print ()
(gdb) info registers
eax            0x0                 0
ecx            0x0                 0
edx            0x0                 0
ebx            0x0                 0
esp            0xffcc80b8          0xffcc80b8
ebp            0xffcc80b8          0xffcc80b8
esi            0x0                 0
edi            0x0                 0
eip            0x8049003           0x8049003 <print+3>
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
we have a `sub esp, 0` instruction the literally does nothing. it is meant to create space in the stack but we do not need it because in this function we never need to push anything to the stack itself. If we did need some room on the stack, we would need to subtract enough room for variables here.

this is just there to show how one would do it if making room on the stack for local variables is needed.

we run all the instructions until we print our message 
```bash
(gdb) nexti
0x08049006 in print ()
(gdb) nexti
0x0804900b in print ()
(gdb) nexti
0x08049010 in print ()
(gdb) nexti
0x08049015 in print ()
(gdb) nexti
0x0804901a in print ()
(gdb) nexti
Hello World!
0x0804901c in print ()
(gdb) disas print
Dump of assembler code for function print:
   0x08049000 <+0>:     push   ebp
   0x08049001 <+1>:     mov    ebp,esp
   0x08049003 <+3>:     sub    esp,0x0
   0x08049006 <+6>:     mov    edx,0xd
   0x0804900b <+11>:    mov    ecx,0x804a000
   0x08049010 <+16>:    mov    ebx,0x1
   0x08049015 <+21>:    mov    eax,0x4
   0x0804901a <+26>:    int    0x80
=> 0x0804901c <+28>:    mov    esp,ebp
   0x0804901e <+30>:    pop    ebp
   0x0804901f <+31>:    ret    
End of assembler dump.
```
this is the func cleanup, were we need to put `esb` and `ebp` back to how they were before we called the func so we can `ret` to the calling function.
```bash
(gdb) nexti
0x0804901e in print ()
(gdb) info registers
eax            0xd                 13
ecx            0x804a000           134520832
edx            0xd                 13
ebx            0x1                 1
esp            0xffcc80b8          0xffcc80b8
ebp            0xffcc80b8          0xffcc80b8
esi            0x0                 0
edi            0x0                 0
eip            0x804901e           0x804901e <print+30>
eflags         0x286               [ PF SF IF ]
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
in the next instruction we can, the value of esp is the value of ebp. This may not look to do anything for us because we never allocated any space on the stack in the first place with our sub, but if we had, this would set esp back to what it was originally when we called the function.

he next step is `pop ebp`, so run it with `nexti`. Recall in our function setup we pushed `ebp` onto the stack. Well, now we can pop it back off into `ebp` to recover the previous value of `ebp`.
```bash
(gdb) nexti
0x0804901f in print ()
(gdb) info registers
eax            0xd                 13
ecx            0x804a000           134520832
edx            0xd                 13
ebx            0x1                 1
esp            0xffcc80bc          0xffcc80bc
ebp            0x0                 0x0
esi            0x0                 0
edi            0x0                 0
eip            0x804901f           0x804901f <print+31>
eflags         0x286               [ PF SF IF ]
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
0x08049043 in _start ()
(gdb) info registers
eax            0xd                 13
ecx            0x804a000           134520832
edx            0xd                 13
ebx            0x1                 1
esp            0xffcc80c0          0xffcc80c0
ebp            0x0                 0x0
esi            0x0                 0
edi            0x0                 0
eip            0x8049043           0x8049043 <_start+5>
eflags         0x286               [ PF SF IF ]
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

We're going to push 5 onto the stack to only print the Hello part of Hello World!.
```bash
gdb) nexti 
0x08049045 in _start ()
(gdb) nexti
0x08049020 in printparam ()
(gdb) nexti
0x08049021 in printparam ()
(gdb) nexti
0x08049023 in printparam ()
(gdb) nexti
0x08049026 in printparam ()
(gdb) nexti
0x08049029 in printparam ()
(gdb) nexti
0x0804902e in printparam ()
(gdb) nexti
0x08049033 in printparam ()
(gdb) nexti
0x08049038 in printparam ()
(gdb) nexti
Hello0x0804903a in printparam ()
(gdb) 
```
finally:
```bash
(gdb) nexti
0x0804904a in _start ()
(gdb) disas print param
A syntax error in expression, near `param'.
(gdb) disas printparam
Dump of assembler code for function printparam:
   0x08049020 <+0>:     push   ebp
   0x08049021 <+1>:     mov    ebp,esp
   0x08049023 <+3>:     sub    esp,0x0
   0x08049026 <+6>:     mov    edx,DWORD PTR [ebp+0x8]
   0x08049029 <+9>:     mov    ecx,0x804a000
   0x0804902e <+14>:    mov    ebx,0x1
   0x08049033 <+19>:    mov    eax,0x4
   0x08049038 <+24>:    int    0x80
   0x0804903a <+26>:    mov    esp,ebp
   0x0804903c <+28>:    pop    ebp
   0x0804903d <+29>:    ret    
End of assembler dump.
```
