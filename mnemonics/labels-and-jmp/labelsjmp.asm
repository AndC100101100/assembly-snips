SECTION .data
message     db      'Hello World!', 0Ah
 
SECTION .text
global  _start
 
_start:
    mov     eax, 5
 
loop:
    push    eax
    mov     edx, 13         ; String length
    mov     ecx, message    ; String to be written
    mov     ebx, 1          ; File descriptor to write to (stdout)
    mov     eax, 4          ; System call number (sys_write)
    int     80h             ; System call: sys_write(13, message, stdout);

    pop     eax
    sub     eax, 1
    jnz     loop
 
    mov     ebx, 0          ; return 0 (no errors)
    mov     eax, 1          ; System call number (sys_exit)
    int     80h             ; System call: sys_exit(0);
