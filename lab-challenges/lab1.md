# lab1

i will eventually do a write up but, i did this on my own, reading through the func and registers:
```bash
e742505c2524@3e451ff53af6:/labs/Linux-gdb-Lab2$ gdb ./lab
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
Reading symbols from ./lab...
(No debugging symbols found in ./lab)
(gdb) break *main
Breakpoint 1 at 0x6f0
(gdb) r
Starting program: /opt/labs/Linux-gdb-Lab2/lab 
warning: Error disabling address space randomization: Operation not permitted
[Thread debugging using libthread_db enabled]
Using host libthread_db library "/lib/x86_64-linux-gnu/libthread_db.so.1".

Breakpoint 1, 0x5661e6f0 in main ()
(gdb) info reg
eax            0x5661e6f0          1449256688
ecx            0x5cf7c7cb          1559742411
edx            0xff924a00          -7190016
ebx            0xf7efc000          -135282688
esp            0xff9249dc          0xff9249dc
ebp            0xf7f4b020          0xf7f4b020 <_rtld_global>
esi            0xff924a94          -7189868
edi            0xf7f4ab80          -134960256
eip            0x5661e6f0          0x5661e6f0 <main>
eflags         0x246               [ PF ZF IF ]
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
(gdb) info func
All defined functions:

Non-debugging symbols:
0x5661e440  _init
0x5661e480  strcmp@plt
0x5661e490  printf@plt
0x5661e4a0  fgets@plt
0x5661e4b0  __stack_chk_fail@plt
0x5661e4c0  strlen@plt
0x5661e4d0  __libc_start_main@plt
0x5661e4e0  __cxa_finalize@plt
0x5661e4e8  __gmon_start__@plt
0x5661e4f0  _start
0x5661e530  __x86.get_pc_thunk.bx
0x5661e540  deregister_tm_clones
0x5661e580  register_tm_clones
0x5661e5d0  __do_global_dtors_aux
0x5661e620  frame_dummy
0x5661e629  __x86.get_pc_thunk.dx
0x5661e62d  string_reverse
0x5661e6c7  string_compare
0x5661e6f0  main
0x5661e7bd  __x86.get_pc_thunk.ax
0x5661e7d0  __libc_csu_init
0x5661e830  __libc_csu_fini
0x5661e840  __stack_chk_fail_local
0x5661e854  _fini
0xf7f15050  _dl_catch_exception@plt
0xf7f15060  _dl_signal_exception@plt
0xf7f15070  _dl_signal_error@plt
--Type <RET> for more, q to quit, c to continue without paging--cQuit
(gdb) break *0x5661e6c7
Breakpoint 2 at 0x5661e6c7
(gdb) c
Continuing.
Please enter the password
:> hello

Breakpoint 2, 0x5661e6c7 in string_compare ()
(gdb) info reg
eax            0xff924958          -7190184
ecx            0x18                24
edx            0x6c                108
ebx            0x5661ffc4          1449263044
esp            0xff92492c          0xff92492c
ebp            0xff9249c8          0xff9249c8
esi            0xff924a94          -7189868
edi            0xf7f4ab80          -134960256
eip            0x5661e6c7          0x5661e6c7 <string_compare>
eflags         0x292               [ AF SF IF ]
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
(gdb) info func
All defined functions:

Non-debugging symbols:
0x5661e440  _init
0x5661e480  strcmp@plt
0x5661e490  printf@plt
0x5661e4a0  fgets@plt
0x5661e4b0  __stack_chk_fail@plt
0x5661e4c0  strlen@plt
0x5661e4d0  __libc_start_main@plt
0x5661e4e0  __cxa_finalize@plt
0x5661e4e8  __gmon_start__@plt
0x5661e4f0  _start
0x5661e530  __x86.get_pc_thunk.bx
0x5661e540  deregister_tm_clones
0x5661e580  register_tm_clones
0x5661e5d0  __do_global_dtors_aux
0x5661e620  frame_dummy
0x5661e629  __x86.get_pc_thunk.dx
0x5661e62d  string_reverse
0x5661e6c7  string_compare
0x5661e6f0  main
0x5661e7bd  __x86.get_pc_thunk.ax
0x5661e7d0  __libc_csu_init
0x5661e830  __libc_csu_fini
0x5661e840  __stack_chk_fail_local
0x5661e854  _fini
0xf7f15050  _dl_catch_exception@plt
0xf7f15060  _dl_signal_exception@plt
0xf7f15070  _dl_signal_error@plt
--Type <RET> for more, q to quit, c to continue without paging--Quit
(gdb) disas string_compare
Dump of assembler code for function string_compare:
=> 0x5661e6c7 <+0>:     push   ebp
   0x5661e6c8 <+1>:     mov    ebp,esp
   0x5661e6ca <+3>:     push   ebx
   0x5661e6cb <+4>:     sub    esp,0x4
   0x5661e6ce <+7>:     call   0x5661e7bd <__x86.get_pc_thunk.ax>
   0x5661e6d3 <+12>:    add    eax,0x18f1
   0x5661e6d8 <+17>:    sub    esp,0x8
   0x5661e6db <+20>:    push   DWORD PTR [ebp+0xc]
   0x5661e6de <+23>:    push   DWORD PTR [ebp+0x8]
   0x5661e6e1 <+26>:    mov    ebx,eax
   0x5661e6e3 <+28>:    call   0x5661e480 <strcmp@plt>
   0x5661e6e8 <+33>:    add    esp,0x10
   0x5661e6eb <+36>:    mov    ebx,DWORD PTR [ebp-0x4]
   0x5661e6ee <+39>:    leave  
   0x5661e6ef <+40>:    ret    
End of assembler dump.
(gdb) break *0x5661e480
Breakpoint 3 at 0x5661e480
(gdb) c
Continuing.

Breakpoint 3, 0x5661e480 in strcmp@plt ()
(gdb) si
0xf7e641d0 in ?? () from /lib32/libc.so.6
(gdb) x/3w $esp
0xff92490c:     1449256680      -7190184        1449257105
(gdb) x/5w $esp
0xff92490c:     1449256680      -7190184        1449257105      -7190181
0xff92491c:     1449256659
(gdb) x/s 1449256680
0x5661e6e8 <string_compare+33>: "\203\304\020\213]\374\311\303\215L$\004\203\344\360\377q\374U\211\345SQ\203\304\200\350)\376\377\377\201\303\275\030"
(gdb) x/8w $esp
0xff92490c:     U"\x5661e6e8\xff924958\x5661e891\xff92495b\x5661e6d3\xff924a94\x5661ffc4\xff9249c8\x5661e775\xff924958\x5661e891\xf7efc620\x5661e707"
0xff924944:     U""
0xff924948:     U""
0xff92494c:     U"\xff924a94"
0xff924954:     U""
0xff924958:     U"\x6c6c6f0a\xf7006865\xf7f12560\xffffffff\x5661e034\xf7f146d0\xf7f4b608\t\xff9249dc\xff924af0"
0xff924984:     U""
0xff924988:     U"\x1000000\t\xf7f12560"
(gdb) x/s x5661e6e8 
No symbol table is loaded.  Use the "file" command.
(gdb) x/s 0x5661e891
0x5661e891:     "\nc&Cnz5B^@0"
(gdb) Quit
(gdb) x/s 1449257105
0x5661e891:     "\nc&Cnz5B^@0"
(gdb) 
```
then:
```bash
>python -c "print ('c&Cnz5B^@0'[::-1])"
0@^B5znC&c
```
and:

```bash
$ ./lab
Please enter the password
:> 0@^B5znC&c
You WIN!
```


