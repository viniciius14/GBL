%ifndef __PRINT_STRING_S
%define __PRINT_STRING_S

[global BIOS_print]
; Prints a string to the screen
; Inputs:
;   - DS:SI = pointer to string
;
BIOS_print:
    ; save registers we will modify
    pusha
    ; push si
    ; push ax
    ; push bx
    ; push ds

.loop:
    lodsb               ; loads next character in al
    or al, al           ; verify if next character is null?
    jz .done

    mov ah, 0x0E        ; call bios interrupt
    mov bh, 0           ; set page number to 0
    int 0x10
    jmp .loop

.done:
    popa
    ; pop ds
    ; pop bx
    ; pop ax
    ; pop si
    ret

%endif
