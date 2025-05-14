[global print_string_32]

%include "common.S"

section .text

; Inputs:
;   - DS:SI = pointer to string
;   - EBX = location on screen where to print the string
print_string_32:
    mov edi, VIDEO_MEMORY
    add edi, ebx

.print_char:
    lodsb
    cmp al, 0
    je .done

    mov ah, WHITE_ON_BLACK
    mov [edi], ax
    add edi, 2

    jmp .print_char

.done:
    ret

