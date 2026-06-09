# mnemonics and gdb

for mov.asm in this same directory. we will be using GDB to analyze two ways of using the `mov` instruction. 

using the output binary we get after assembling and linking.

```bash
gdb ./output
```
inside of gdb, we set a breakpoint at the start of the program, before excecuting the first instruction, `break *_start` and then we `run`:
```bash
f457a7b9323e@78f9105a82ef:~$ gdb ./output
GNU gdb (Ubuntu 12.1-0ubuntu1~22.04.2) 12.1
Copyright (C) 2022 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.
Type "show copying" and "show warranty" for details.
This GDB was configured as "x86_64-linux-gnu".
Type "show configuration" for configuration details.
For bug reporting instructions, please see:
<https://www.gnu.org/software/gdb/bugs/>.
Find the GDB manual and other documentation resources online at:
    <http://www.gnu.org/software/gdb/documentation/>.

For help, type "help".
Type "apropos word" to search for commands related to "word"...
Reading symbols from ./output...
(No debugging symbols found in ./output)
(gdb) break *_start
Breakpoint 1 at 0x8049000
(gdb) run
Starting program: /home/f457a7b9323e/output 
warning: Error disabling address space randomization: Operation not permitted

Breakpoint 1, 0x08049000 in _start ()
(gdb) 
```
we can see where we are in the code by typing `disas _start`, this allows us to see that code with an arrow to see what the next instruction would be:
```bash
(gdb) disas _start
Dump of assembler code for function _start:
=> 0x08049000 <+0>:     mov    edx,0xd
   0x08049005 <+5>:     mov    eax,edx
   0x08049007 <+7>:     mov    ebx,0x0
   0x0804900c <+12>:    mov    eax,0x1
   0x08049011 <+17>:    int    0x80
End of assembler dump.
(gdb) 
```

in the ouput we case see the first instructions being `mov edx,0xd`, where `0xd` is our hex value for 13.

we can check the state of the registers with `info registers`:
```bash
(gdb) info registers 
eax            0x0                 0
ecx            0x0                 0
edx            0x0                 0
ebx            0x0                 0
esp            0xffd8a400          0xffd8a400
ebp            0x0                 0x0
esi            0x0                 0
edi            0x0                 0
eip            0x8049000           0x8049000 <_start>
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

at this point in execution we can see that our `edx` reguster is still 0, as this is before we execute.

We can run the next instruction with `nexti`, and recheck where we are again with `disas _start`:
```bash
(gdb) nexti
0x08049005 in _start ()
(gdb) disas _start
Dump of assembler code for function _start:
   0x08049000 <+0>:     mov    edx,0xd
=> 0x08049005 <+5>:     mov    eax,edx
   0x08049007 <+7>:     mov    ebx,0x0
   0x0804900c <+12>:    mov    eax,0x1
   0x08049011 <+17>:    int    0x80
End of assembler dump.
```

we can now now recheck our `edx` register again and we should see edx bow holding the value 13, but `eax` is still 0:
```bash
(gdb) info registers
eax            0x0                 0
ecx            0x0                 0
edx            0xd                 13
ebx            0x0                 0
esp            0xffd8a400          0xffd8a400
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
k5             0x0                 0
k6             0x0                 0
k7             0x0                 0
```

to finish it off, we will step into the next instruction again, and recheck `disas _start` and our registers to see that `eax` is now 13 because of our `mov eax,edx`
```bash
(gdb) nexti
0x08049007 in _start ()
(gdb) disas _start
Dump of assembler code for function _start:
   0x08049000 <+0>:     mov    edx,0xd
   0x08049005 <+5>:     mov    eax,edx
=> 0x08049007 <+7>:     mov    ebx,0x0
   0x0804900c <+12>:    mov    eax,0x1
   0x08049011 <+17>:    int    0x80
End of assembler dump.
(gdb) info registers
eax            0xd                 13
ecx            0x0                 0
edx            0xd                 13
ebx            0x0                 0
esp            0xffd8a400          0xffd8a400
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
