[global print_string_32]

section .text
; Print example, to delete later
VIDEO_MEMORY equ 0xB8000
WHITE_ON_BLACK equ 0x0F

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

