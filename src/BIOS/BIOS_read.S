%ifndef __BIOS_READ_S
%define __BIOS_READ_S

; Use BIOS INT13h to read sectors from disk into RAM
; Inputs:
;   - AX = LBA address
;   - CL = number of sectors to read (up to 127)
;   - DL = drive number
;   - ES:BX = memory address where to store read data
BIOS_read:
    push ax                 ; save registers we will modify
    push bx
    push cx
    push dx
    push di
    push cx                 ; temporarily save CL (number of sectors to read)
    call lba_to_chs         ; compute CHS
    pop ax                  ; AL = number of sectors to read
    mov ah, 0x2
    mov di, 3               ; retry count

.retry:
    pusha                   ; save all registers, we don't know what bios modifies
    stc                     ; set carry flag, some BIOS'es don't set it
    int 13h                 ; carry flag cleared = success
    jnc .done               ; jump if carry not set (read was successful)

    popa
    call BIOS_disk_reset
    dec di
    test di, di
    jnz .retry

.fail:
    jmp failure

.done:
    popa
    pop di
    pop dx
    pop cx
    pop bx
    pop ax                  ; restore registers modified
    ret


; Converts an LBA address to a CHS address
; Inputs:
;   - AL = LBA address
; Outputs:
;   - CX [bits 0-5] = sector number
;   - CX [bits 6-15] = cylinder
;   - DH = head
;
lba_to_chs:
    push ax
    push dx

    xor dx, dx                          ; dx = 0
    div word [BPB_SecPerTrk]            ; ax = LBA / SectorsPerTrack
                                        ; dx = LBA % SectorsPerTrack
    inc dx                              ; dx = (LBA % SectorsPerTrack + 1) = sector
    mov cx, dx                          ; cx = sector

    xor dx, dx                          ; dx = 0
    div word [BPB_NumHeads]             ; ax = (LBA / SectorsPerTrack) / Heads = cylinder
                                        ; dx = (LBA / SectorsPerTrack) % Heads = head
    mov dh, dl                          ; dh = head
    mov ch, al                          ; ch = cylinder (lower 8 bits)
    shl ah, 6
    or cl, ah                           ; put upper 2 bits of cylinder in CL

    pop ax
    mov dl, al                          ; restore DL
    pop ax
    ret

%endif
