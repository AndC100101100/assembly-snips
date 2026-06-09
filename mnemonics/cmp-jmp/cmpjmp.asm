SECTION .data
 
SECTION .text
global  _start
 
_start:
 
    jmp     main

equal:

    mov     eax, 12
    mov     ebx, 6
    cmp     eax, ebx
    jne     notequal

main:

    mov     eax, 10
    cmp     eax, 10
    je      equal

notequal:

    mov     eax, 7
    jmp     exit

exit:

    mov     ebx, 0          ; return 0 (no errors)
    mov     eax, 1          ; System call number (sys_exit)
    int     80h             ; System call: sys_exit(0);
