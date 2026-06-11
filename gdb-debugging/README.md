# debugging

we have our `password.c file which we will use to test out GDB.

we are going to assume not being aware of the actual source code, and will only interact with the binary itself

```bash
gcc -g -m32 -o password password.c
```

## interacting with the binary
first thing will be to check what type of binary we are working with using `file`:
```bash
f2a973fc834b@d463e370b2cb:/labs/Linux-gdb-Lab1$ file password
password: ELF 32-bit LSB pie executable, Intel 80386, version 1 (SYSV), dynamically linked, interpreter /lib/ld-linux.so.2, BuildID[sha1]=79f1e9b4cfee2094a506a2cb093be0e24734d6af, for GNU/Linux 3.2.0, with debug_info, not stripped
```
as always, we are working with a 32 bit binary

we can start working and viewing this binary with GDB:
```bash
f2a973fc834b@d463e370b2cb:/labs/Linux-gdb-Lab1$ gdb ./password
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
Reading symbols from ./password...
(gdb) info func
All defined functions:

File password.c:
4:      int main();

Non-debugging symbols:
0x00001000  _init
0x00001040  strcmp@plt
0x00001050  __libc_start_main@plt
0x00001060  fgets@plt
0x00001070  __stack_chk_fail@plt
0x00001080  puts@plt
0x00001090  __cxa_finalize@plt
0x000010a0  _start
0x000010d0  __x86.get_pc_thunk.bx
0x000010e0  deregister_tm_clones
0x00001120  register_tm_clones
0x00001170  __do_global_dtors_aux
0x000011c0  frame_dummy
--Type <RET> for more, q to quit, c to continue without paging--
```
there are already a few functions that call our attention like fgests and strcmp and puts.
we can see the have these `@plt`, meaning these are loaded dynamically when the program starts and are not in the binary.

next up we can start our dissasemble:
```bash
(gdb) disas main
Dump of assembler code for function main:
   0x000011cd <+0>:     lea    ecx,[esp+0x4]
   0x000011d1 <+4>:     and    esp,0xfffffff0
   0x000011d4 <+7>:     push   DWORD PTR [ecx-0x4]
   0x000011d7 <+10>:    push   ebp
   0x000011d8 <+11>:    mov    ebp,esp
   0x000011da <+13>:    push   ebx
   0x000011db <+14>:    push   ecx
   0x000011dc <+15>:    sub    esp,0xa0
   0x000011e2 <+21>:    call   0x10d0 <__x86.get_pc_thunk.bx>
   0x000011e7 <+26>:    add    ebx,0x2de1
   0x000011ed <+32>:    mov    eax,gs:0x14
   0x000011f3 <+38>:    mov    DWORD PTR [ebp-0xc],eax
   0x000011f6 <+41>:    xor    eax,eax
   0x000011f8 <+43>:    lea    eax,[ebx-0x1fc0]
   0x000011fe <+49>:    mov    DWORD PTR [ebp-0xa8],eax
   0x00001204 <+55>:    sub    esp,0xc
   0x00001207 <+58>:    lea    eax,[ebx-0x1fae]
   0x0000120d <+64>:    push   eax
--Type <RET> for more, q to quit, c to continue without paging--
   0x0000120e <+65>:    call   0x1080 <puts@plt>
   0x00001213 <+70>:    add    esp,0x10
   0x00001216 <+73>:    mov    eax,DWORD PTR [ebx+0x2c]
   0x0000121c <+79>:    mov    eax,DWORD PTR [eax]
   0x0000121e <+81>:    sub    esp,0x4
   0x00001221 <+84>:    push   eax
   0x00001222 <+85>:    push   0x95
   0x00001227 <+90>:    lea    eax,[ebp-0xa3]
   0x0000122d <+96>:    push   eax
   0x0000122e <+97>:    call   0x1060 <fgets@plt>
   0x00001233 <+102>:   add    esp,0x10
   0x00001236 <+105>:   sub    esp,0x8
   0x00001239 <+108>:   push   DWORD PTR [ebp-0xa8]
   0x0000123f <+114>:   lea    eax,[ebp-0xa3]
   0x00001245 <+120>:   push   eax
   0x00001246 <+121>:   call   0x1040 <strcmp@plt>
   0x0000124b <+126>:   add    esp,0x10
   0x0000124e <+129>:   test   eax,eax
   0x00001250 <+131>:   jne    0x1266 <main+153>
```
her we have some good ol assembly asnd we can se the following call `call   0x1080 <puts@plt>`. This is the function that prints to the screen.

we can also see `call   0x1060 <fgets@plt>` which is where we retrieve our user input

finally we have the  ` call   0x1040 <strcmp@plt>` which is what will be in charge of comparing the two strings and identify if they match.

we can a nice gdb trick to get a look at how our source code could look like by running `l 1,18`, we can ask GDB to show us the code. which is easy knowing we built this one:
```shell
(gdb) l 1,18
1       #include <stdio.h>
2       #include <string.h>
3
4       int main() {
5           char *password = "ThisIsMyPassword\n";
6           char input[151];
7
8           puts("Please enter the password:");
9           fgets(input, 149, stdin);
10
11          if (strcmp(input, password) == 0) {
12              puts("Success!");
13          } else {
14              puts("Fail!");
15          }
16
17          return(0);
18      }
(gdb) 
```

knowing this we can add breakpoints in specific places like, line 11, and the run the program to hit this breakpoint:
```shell
(gdb) break 11
Breakpoint 1 at 0x1236: file password.c, line 11.
(gdb) r
Starting program: /opt/labs/Linux-gdb-Lab1/password 
warning: Error disabling address space randomization: Operation not permitted
[Thread debugging using libthread_db enabled]
Using host libthread_db library "/lib/x86_64-linux-gnu/libthread_db.so.1".
Please enter the password:
password

Breakpoint 1, main () at password.c:11
11          if (strcmp(input, password) == 0) {
(gdb) 
```
this code breakpoint translated to the actual location in memory, which means we can now examine memory  and enumerate registers:
```bash
(gdb) info reg  
eax            0xfff03695          -1034603
ecx            0x57a465b9          1470391737
edx            0xf7f219c0          -135128640
ebx            0x56600fc8          1449136072
esp            0xfff03690          0xfff03690
ebp            0xfff03738          0xfff03738
esi            0xfff03804          -1034236
edi            0xf7f6eb80          -134812800
eip            0x565fe236          0x565fe236 <main+105>
eflags         0x286               [ PF SF IF ]
cs             0x23                35
ss             0x2b                43
ds             0x2b                43
es             0x2b                43
fs             0x0                 0
gs             0x63                99
k0             0x0                 0
k1             0x0                 0
k2             0x0                 0
k3             0x0                 0
k4             0x0                 0
k5             0x0                 0
k6             0x0                 0
k7             0x0                 0
```

form here we will grab the assembly instructions from where we are and see where we landed in the program, we will get 10 instructions from the address of EIP:
```bash
(gdb) x/10i $eip
=> 0x565fe236 <main+105>:       sub    esp,0x8
   0x565fe239 <main+108>:       push   DWORD PTR [ebp-0xa8]
   0x565fe23f <main+114>:       lea    eax,[ebp-0xa3]
   0x565fe245 <main+120>:       push   eax
   0x565fe246 <main+121>:       call   0x565fe040 <strcmp@plt>
   0x565fe24b <main+126>:       add    esp,0x10
   0x565fe24e <main+129>:       test   eax,eax
   0x565fe250 <main+131>:       jne    0x565fe266 <main+153>
   0x565fe252 <main+133>:       sub    esp,0xc
   0x565fe255 <main+136>:       lea    eax,[ebx-0x1f93]
(gdb)        
```

we landed before our strcmp, we want to hop in it so that we can see de passwords to be compared.
from the past instructions, if we look at the line referencing `strcmp` there is a memory address to its lef which we are going to use to add a breakpoint:
```bash
(gdb) break *0x565fe040
Breakpoint 2 at 0x565fe040
(gdb) c
Continuing.

Breakpoint 2, 0x565fe040 in strcmp@plt ()
(gdb) 
```

as we land on the breakpoint in strcmp, we now `step into` this function:
```
(gdb) si
0xf7e881d0 in ?? () from /lib32/libc.so.6
```

## getting the loot
we are obviously traversing this to grab  from memory where the strings are stored. They are stored in the stack as we are in a function that compares two things.

To be mroe exact, they will be on the stack at `+4` and `+8`

we are going to print out the three top words of hex standing at the top of the stack, which we know is the ESP register:
```bash
(gdb) x/3w $esp
0xfff0367c:     0x565fe24b      0xfff03695      0x565ff008
```

from the second hex value and on we can use `x/s <address>` to print them as a string:
```bash
(gdb) x/s 0x565fe24b
0x565fe24b <main+126>:  "\203\304\020\205\300u\024\203\354\f\215\203m\340\377\377P\350\037\376\377\377\203\304\020\353\022\203\354\f\215\203v\340\377\377P\350\v\376\377\377\203\304\020\270"
(gdb) x/s 0xfff03695
0xfff03695:     "password\n"
(gdb) x/s 0x565ff008
0x565ff008:     "ThisIsMyPassword\n"
```

we have basically reversed a binary to understand its full functionality.



