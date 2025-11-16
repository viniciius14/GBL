%ifndef __MACROS_S
%define __MACROS_S

%macro unreachable 0
    cli             ; disable interrupts
    hlt             ; this way CPU can't get out of "halt" state
    jmp $
%endmacro

%macro print_letter 1
    pusha
    mov ah, 0x0e
    mov al, %1
    int 0x10
    popa
%endmacro

%endif
