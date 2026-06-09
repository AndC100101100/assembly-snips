SECTION .data
 
SECTION .text
global  _start
 
_start:
 
    mov     eax, 4
    mov     ebx, eax
    add     eax, 1
    add     eax, ebx
    sub     eax, 4

    mov     ebx, 0          ; return 0 (no errors)
    mov     eax, 1          ; System call number (sys_exit)
    int     80h             ; System call: sys_exit(0);
