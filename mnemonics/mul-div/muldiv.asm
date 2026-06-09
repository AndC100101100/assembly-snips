SECTION .data
 
SECTION .text
global  _start
 
_start:
 
    mov     eax, 4
    mov     ebx, 2
    mul     ebx
    mov     ebx, 4
    div     ebx

    mov     ebx, 0          ; return 0 (no errors)
    mov     eax, 1          ; System call number (sys_exit)
    int     80h             ; System call: sys_exit(0);
