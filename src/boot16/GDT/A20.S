[bits 16]


; TODO: In the future lets split boot16 into 2 separate bins, one will be in the first sector
; and the other will be like a header for stage2 that will setup the GDT and A20 line before jumping to stage2 properly

section .text

; Inputs:
;   - NONE
; Outputs:
;   - Enables the A20 line.
;     If it isn't possible to do so the bootloader will throw a "Critical Error"
;
A20_line:
; The BIOS might've already set the A20 line
    ; call A20_status

    ; cmp ax, 1
    ; je .A20_enabled

.A20_disabled:
; fast A20 gate (only supported from the IBM PS/2 onwards)
    in al, 0x92
    or al, 2
    out 0x92, al

; check if it was successful
    ; call A20_status

    ; cmp ax, 1
    ; je .A20_enabled

; in case we couldn't enable the A20 gate
    ; jmp failure

.A20_enabled:
    ; mov si, MSG_A20
    ; call BIOS_print

    ret


; Inputs:
;   - NONE
; Outputs:
;   - ax = 0 if the a20 line is disabled
;   - ax = 1 if the a20 line is enabled
;
; A20_status:
;     push ds
;     push es

;     xor ax, ax
;     mov es, ax
;     not ax                  ; ax = 0xFFFF
;     mov ds, ax              ; ds = 0xFFFF
;     mov di, 0x0500
;     mov si, 0x0510

; ; Save the values at our memory locations
;     mov al, byte [es:di]    ; al = [0:0x500]
;     push ax

;     mov al, byte [ds:si]    ; al = [0xFFFF:0x510]
;     push ax

; ; Check if wrap around is happening
;     mov byte [es:di], 0x00  ; [0:0x500] = 0
;     mov byte [ds:si], 0xFF  ; [0xFFFF:0x510] = 0xFF
;     cmp byte [es:di], 0xFF

; ; Restore original values
;     pop ax
;     mov byte [ds:si], al
;     pop ax
;     mov byte [es:di], al

;     pop es
;     pop ds

;     mov ax, 0
;     je .check_A20_exit

;     mov ax, 1

; .check_A20_exit:
;     ret


; section .rodata
; MSG_A20:  db "A20 line enabled.", 0
