SECTION .data
 
SECTION .text
global  _start
 
_start:
 
    push    1
    push    2
    push    3
    push    4

    pop     eax
    pop     ebx
    pop     ecx
    pop     edx

    push    eax
    push    ebx
    push    ecx
    push    edx

    mov     ebx, 0          ; return 0 (no errors)
    mov     eax, 1          ; System call number (sys_exit)
    int     80h             ; System call: sys_exit(0);
