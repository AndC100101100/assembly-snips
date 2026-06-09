# add and sub mnemonics

we assemble and linke
```bash
nasm -f elf addsub.asm

ld -m elf_i386 addsub.o -o output

gdb ./addsub
```

we add our breakpoint in the entrypoint:
```bash
(gdb) break *_start
Breakpoint 1 at 0x8049000
(gdb) run\
Quit
(gdb) run
Undefined command: "runrun".  Try "help".
(gdb) run
Starting program: /home/6525f4ca8648/output 
warning: Error disabling address space randomization: Operation not permitted

Breakpoint 1, 0x08049000 in _start ()
```
from here run `nexti` twice to setup our registers where `eax` and `ebx` should both have 4 in each.
```bash
(gdb) nexti
0x08049005 in _start ()
(gdb) nexti
0x08049007 in _start ()
(gdb) info registers
eax            0x4                 4
ecx            0x0                 0
edx            0x0                 0
ebx            0x4                 4
esp            0xff841f20          0xff841f20
ebp            0x0                 0x0
esi            0x0                 0
edi            0x0                 0
eip            0x8049007           0x8049007 <_start+7>
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
running the next instruction will run the first `add` instruction, in this case we do `add eax, 1` which should turn `eax`'s value into 5:
```bash
(gdb) nexti
0x0804900a in _start ()
(gdb) info registers
eax            0x5                 5
ecx            0x0                 0
edx            0x0                 0
ebx            0x4                 4
esp            0xff841f20          0xff841f20
ebp            0x0                 0x0
esi            0x0                 0
edi            0x0                 0
eip            0x804900a           0x804900a <_start+10>
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
(gdb) 
```

we can then do `nexti` which adds the value of our two registers with `add eax, ebx` were eax would become 5+4 = 9:
```bash
(gdb) nexti
0x0804900c in _start ()
(gdb) info registers
eax            0x9                 9
ecx            0x0                 0
edx            0x0                 0
ebx            0x4                 4
esp            0xff841f20          0xff841f20
ebp            0x0                 0x0
esi            0x0                 0
edi            0x0                 0
eip            0x804900c           0x804900c <_start+12>
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
```

our final instruction should substract 4 from eax bumping it back down to 5:
```bash
(gdb) nexti
0x0804900f in _start ()
(gdb) info registers
eax            0x5                 5
ecx            0x0                 0
edx            0x0                 0
ebx            0x4                 4
esp            0xff841f20          0xff841f20
ebp            0x0                 0x0
esi            0x0                 0
edi            0x0                 0
eip            0x804900f           0x804900f <_start+15>
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
(gdb) 
```
