[bits 16]

[global A20_line]

[extern BIOS_print]
%include "macros.S"

section .text

A20_line:
    call check_A20
    ; The BIOS might've already set the A20 line
    cmp ax, 1
    jne .done

    mov si, A20_STATUS_ON
    call BIOS_print

    ret
.done:
    mov si, A20_STATUS_OFF
    call BIOS_print

    ret

; Inputs
;   - NONE
; Outputs:
;   - ax = 0 if the a20 line is disabled
;   - ax = 1 if the a20 line is enabled
;
check_A20:
    xor ax, ax
    mov es, ax
    not ax                  ; ax = 0xFFFF
    mov ds, ax              ; ds = 0xFFFF
    mov di, 0x0500
    mov si, 0x0510

    ; Save the values at our memory locations
    mov al, byte [es:di]    ; al = [0:0x500]
    push ax

    mov al, byte [ds:si]    ; al = [0xFFFF:0x510]
    push ax

    ; Check if wrap around is happening
    mov byte [es:di], 0x00  ; [0:0x500] = 0
    mov byte [ds:si], 0xFF  ; [0xFFFF:0x510] = 0xFF
    cmp byte [es:di], 0xFF

    ; Restore original values
    pop ax
    mov byte [ds:si], al
    pop ax
    mov byte [es:di], al

    mov ax, 0
    je .check_A20_exit

    mov ax, 1
.check_A20_exit:
    ret


section .rodata
A20_STATUS_ON:  db "A20 line is enabled", 0
A20_STATUS_OFF: db "A20 line is disabled", 0
MSG_TEMP: db "THIS IS MY MEGA LONG STRING TO CHECK STAGE 1 FUNCTIONALITY FOR FAT 12 BECAUSE NOTHING WANTS TO WORK ON THIS DAMN PROJECT!!!!!!!!!!!!", 0