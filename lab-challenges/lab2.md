# no writeup but maybe 
```bash
e742505c2524@3e451ff53af6:/labs/Linux-gdb-Lab2$ gdb ./lab2
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
Reading symbols from ./lab2...
(No debugging symbols found in ./lab2)
(gdb) r
Starting program: /opt/labs/Linux-gdb-Lab2/lab2 
warning: Error disabling address space randomization: Operation not permitted
[Thread debugging using libthread_db enabled]
Using host libthread_db library "/lib/x86_64-linux-gnu/libthread_db.so.1".
Please enter the password:
a
Fail!
[Inferior 1 (process 237) exited normally]
(gdb) info file
Symbols from "/opt/labs/Linux-gdb-Lab2/lab2".
Local exec file:
        `/opt/labs/Linux-gdb-Lab2/lab2', file type elf32-i386.
        Entry point: 0x5662d080
        0x5662c194 - 0x5662c1a7 is .interp
        0x5662c1a8 - 0x5662c1c8 is .note.ABI-tag
        0x5662c1c8 - 0x5662c1ec is .note.gnu.build-id
        0x5662c1ec - 0x5662c20c is .gnu.hash
        0x5662c20c - 0x5662c2cc is .dynsym
        0x5662c2cc - 0x5662c395 is .dynstr
        0x5662c396 - 0x5662c3ae is .gnu.version
        0x5662c3b0 - 0x5662c3f0 is .gnu.version_r
        0x5662c3f0 - 0x5662c438 is .rel.dyn
        0x5662c438 - 0x5662c460 is .rel.plt
        0x5662d000 - 0x5662d020 is .init
        0x5662d020 - 0x5662d080 is .plt
        0x5662d080 - 0x5662d314 is .text
        0x5662d314 - 0x5662d328 is .fini
        0x5662e000 - 0x5662e037 is .rodata
--Type <RET> for more, q to quit, c to continue without paging--Quit
(gdb) break *0x5662d080
Breakpoint 1 at 0x5662d080
(gdb) r
Starting program: /opt/labs/Linux-gdb-Lab2/lab2 
warning: Error disabling address space randomization: Operation not permitted
Warning:
Cannot insert breakpoint 1.
Cannot access memory at address 0x5662d080

(gdb) delete 1
break fgets
run
(gdb) delete 1
No breakpoint number 1.
(gdb) break fgets
Breakpoint 2 at 0x565f8040
(gdb) r
The program being debugged has been started already.
Start it from the beginning? (y or n) y
Starting program: /opt/labs/Linux-gdb-Lab2/lab2 
warning: Error disabling address space randomization: Operation not permitted
[Thread debugging using libthread_db enabled]
Using host libthread_db library "/lib/x86_64-linux-gnu/libthread_db.so.1".
Please enter the password:

Breakpoint 2, 0xf7d2cce8 in fgets () from /lib32/libc.so.6
(gdb) info proc mapping
process 241
Mapped address spaces:

        Start Addr   End Addr       Size     Offset  Perms   objfile
        0x56585000 0x56586000     0x1000        0x0  r--p   /opt/labs/Linux-gdb-Lab2/lab2
        0x56586000 0x56587000     0x1000     0x1000  r-xp   /opt/labs/Linux-gdb-Lab
(gdb) disas 0x56586080, 0x56586314
Dump of assembler code from 0x56586080 to 0x56586314:
   0x56586080:  xor    ebp,ebp
   0x56586082:  pop    esi
   0x56586083:  mov    ecx,esp
   0x56586085:  and    esp,0xfffffff0
   0x56586088:  push   eax
   0x56586089:  push   esp
   0x5658608a:  push   edx
   0x5658608b:  call   0x565860b2
   0x56586090:  add    ebx,0x2f70
   0x56586096:  lea    eax,[ebx-0x2d10]
   0x5658609c:  push   eax
   0x5658609d:  lea    eax,[ebx-0x2d70]
   0x565860a3:  push   eax
   0x565860a4:  push   ecx
   0x565860a5:  push   esi
   0x565860a6:  push   DWORD PTR [ebx-0x8]
   0x565860ac:  call   0x56586070 <__libc_start_main@plt>
   0x565860b1:  hlt    
--Type <RET> for more, q to quit, c to continue without paging--break strcmp
   0x565860b2:  mov    ebx,DWORD PTR [esp]
   0x565860b5:  ret    
   0x565860b6:  xchg   ax,ax
   0x565860b8:  xchg   ax,ax
   0x565860ba:  xchg   ax,ax
   0x565860bc:  xchg   ax,ax
   0x565860be:  xchg   ax,ax
   0x565860c0:  mov    ebx,DWORD PTR [esp]
   0x565860c3:  ret    
   0x565860c4:  xchg   ax,ax
   0x565860c6:  xchg   ax,ax
   0x565860c8:  xchg   ax,ax
   0x565860ca:  xchg   ax,ax
   0x565860cc:  xchg   ax,ax
   0x565860ce:  xchg   ax,ax
   0x565860d0:  call   0x565861b9
   0x565860d5:  add    edx,0x2f2b
   0x565860db:  lea    ecx,[edx+0x28]
   0x565860e1:  lea    eax,[edx+0x28]
--Type <RET> for more, q to quit, c to continue without paging--
   0x565860e7:  cmp    eax,ecx
   0x565860e9:  je     0x56586108
   0x565860eb:  mov    eax,DWORD PTR [edx-0x18]
   0x565860f1:  test   eax,eax
   0x565860f3:  je     0x56586108
   0x565860f5:  push   ebp
   0x565860f6:  mov    ebp,esp
   0x565860f8:  sub    esp,0x14
   0x565860fb:  push   ecx
   0x565860fc:  call   eax
   0x565860fe:  add    esp,0x10
   0x56586101:  leave  
   0x56586102:  ret    
   0x56586103:  lea    esi,[esi+eiz*1+0x0]
   0x56586107:  nop
   0x56586108:  ret    
   0x56586109:  lea    esi,[esi+eiz*1+0x0]
   0x56586110:  call   0x565861b9
   0x56586115:  add    edx,0x2eeb
--Type <RET> for more, q to quit, c to continue without paging--
   0x5658611b:  push   ebp
   0x5658611c:  mov    ebp,esp
   0x5658611e:  push   ebx
   0x5658611f:  lea    ecx,[edx+0x28]
   0x56586125:  lea    eax,[edx+0x28]
   0x5658612b:  sub    esp,0x4
   0x5658612e:  sub    eax,ecx
   0x56586130:  sar    eax,0x2
   0x56586133:  mov    ebx,eax
   0x56586135:  shr    ebx,0x1f
   0x56586138:  add    eax,ebx
   0x5658613a:  sar    eax,1
   0x5658613c:  je     0x56586152
   0x5658613e:  mov    edx,DWORD PTR [edx-0x4]
   0x56586144:  test   edx,edx
   0x56586146:  je     0x56586152
   0x56586148:  sub    esp,0x8
   0x5658614b:  push   eax
   0x5658614c:  push   ecx
--Type <RET> for more, q to quit, c to continue without paging--
   0x5658614d:  call   edx
   0x5658614f:  add    esp,0x10
   0x56586152:  mov    ebx,DWORD PTR [ebp-0x4]
   0x56586155:  leave  
   0x56586156:  ret    
   0x56586157:  lea    esi,[esi+eiz*1+0x0]
   0x5658615e:  xchg   ax,ax
   0x56586160:  endbr32 
   0x56586164:  push   ebp
   0x56586165:  mov    ebp,esp
   0x56586167:  push   ebx
   0x56586168:  call   0x565860c0
   0x5658616d:  add    ebx,0x2e93
   0x56586173:  sub    esp,0x4
   0x56586176:  cmp    BYTE PTR [ebx+0x28],0x0
   0x5658617d:  jne    0x565861a7
   0x5658617f:  mov    eax,DWORD PTR [ebx-0x14]
   0x56586185:  test   eax,eax
   0x56586187:  je     0x5658619b
--Type <RET> for more, q to quit, c to continue without paging--
   0x56586189:  sub    esp,0xc
   0x5658618c:  push   DWORD PTR [ebx+0x24]
   0x56586192:  call   DWORD PTR [ebx-0x14]
   0x56586198:  add    esp,0x10
   0x5658619b:  call   0x565860d0
   0x565861a0:  mov    BYTE PTR [ebx+0x28],0x1
   0x565861a7:  mov    ebx,DWORD PTR [ebp-0x4]
   0x565861aa:  leave  
   0x565861ab:  ret    
   0x565861ac:  lea    esi,[esi+eiz*1+0x0]
   0x565861b0:  endbr32 
   0x565861b4:  jmp    0x56586110
   0x565861b9:  mov    edx,DWORD PTR [esp]
   0x565861bc:  ret    
   0x565861bd:  lea    ecx,[esp+0x4]
   0x565861c1:  and    esp,0xfffffff0
   0x565861c4:  push   DWORD PTR [ecx-0x4]
   0x565861c7:  push   ebp
   0x565861c8:  mov    ebp,esp
--Type <RET> for more, q to quit, c to continue without paging--
   0x565861ca:  push   ebx
   0x565861cb:  push   ecx
   0x565861cc:  sub    esp,0xa0
   0x565861d2:  call   0x565860c0
   0x565861d7:  add    ebx,0x2e29
   0x565861dd:  mov    eax,gs:0x14
   0x565861e3:  mov    DWORD PTR [ebp-0xc],eax
   0x565861e6:  xor    eax,eax
   0x565861e8:  lea    eax,[ebx-0x1ff8]
   0x565861ee:  mov    DWORD PTR [ebp-0xa8],eax
   0x565861f4:  sub    esp,0xc
   0x565861f7:  lea    eax,[ebx-0x1ff3]
   0x565861fd:  push   eax
   0x565861fe:  call   0x56586060 <puts@plt>
   0x56586203:  add    esp,0x10
   0x56586206:  mov    eax,DWORD PTR [ebx-0xc]
   0x5658620c:  mov    eax,DWORD PTR [eax]
   0x5658620e:  sub    esp,0x4
   0x56586211:  push   eax
--Type <RET> for more, q to quit, c to continue without paging--
   0x56586212:  push   0x95
   0x56586217:  lea    eax,[ebp-0xa3]
   0x5658621d:  push   eax
   0x5658621e:  call   0x56586040 <fgets@plt>
   0x56586223:  add    esp,0x10
   0x56586226:  sub    esp,0x8
   0x56586229:  push   DWORD PTR [ebp-0xa8]
   0x5658622f:  lea    eax,[ebp-0xa3]
   0x56586235:  push   eax
   0x56586236:  call   0x56586030 <strcmp@plt>
   0x5658623b:  add    esp,0x10
   0x5658623e:  test   eax,eax
   0x56586240:  jne    0x56586256
   0x56586242:  sub    esp,0xc
   0x56586245:  lea    eax,[ebx-0x1fd8]
   0x5658624b:  push   eax
   0x5658624c:  call   0x56586060 <puts@plt>
   0x56586251:  add    esp,0x10
   0x56586254:  jmp    0x56586268
--Type <RET> for more, q to quit, c to continue without paging--Quit
(gdb) break *0x56586030
Breakpoint 3 at 0x56586030
(gdb) finish
Run till exit from #0  0xf7d2cce8 in fgets () from /lib32/libc.so.6
as
0x56586223 in ?? ()
(gdb) x/3wx $esp
0xff9b61b0:     0xff9b61c5      0x00000095      0xf7ee2620
(gdb) x/s 0xff9b61c5
0xff9b61c5:     "as\n"
(gdb) x/s 0x00000095
0x95:   <error: Cannot access memory at address 0x95>
(gdb) x/s 0xf7ee2620
0xf7ee2620 <_IO_2_1_stdin_>:    "\210\"\255\373\263\005]V\263\005]V\260\005]V\260\005]V\260\005]V\260\005]V\260\005]V\260\t]V"
(gdb) c
Continuing.

Breakpoint 3, 0x56586030 in strcmp@plt ()
(gdb) x/3wx $esp
0xff9b61ac:     0x5658623b      0xff9b61c5      0x56587008
(gdb) x/s 0xff9b61c5
0xff9b61c5:     "as\n"
(gdb) x/s 0x56587008
0x56587008:     "000\n"

```
lol:
```bash
$ ./lab2
Please enter the password:
000
Success!
```
