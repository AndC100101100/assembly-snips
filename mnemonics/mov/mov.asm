SECTION .data
 
SECTION .text
global  _start
 
_start:
 
    mov     edx, 13
    mov     eax, edx

    mov     ebx, 0          ; return 0 (no errors)
    mov     eax, 1          ; System call number (sys_exit)
    int     80h             ; System call: sys_exit(0);
