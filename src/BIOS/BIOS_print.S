%ifndef __BIOS_PRINT_S
%define __BIOS_PRINT_S

[bits 16]

section .text

[global BIOS_print]

; Prints a string to the screen
; Inputs:
;   - DS:SI = pointer to string
; Outputs:
;   - None
;
BIOS_print:
    pusha

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
    ret

%endif
