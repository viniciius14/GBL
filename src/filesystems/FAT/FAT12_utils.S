%ifndef __FAT12_UTILS_S
%define __FAT12_UTILS_S

; Find a file in a FAT filesystem
; Inputs:
;   DS:SI = pointer to 11-byte filename
; Outputs:
;   AX = starting cluster in the data section
; Assumptions:
;   Direction flag is cleared
;   DL = Drive Number
FAT_find_file:
; Load the File Allocation Table into memory
    mov ax, [BPB_RsvdSecCnt]    ; ax = File Allocation Table region start sector
    mov cl, [BPB_FATSz16]       ; cl = Sectors per FAT
    mov bx, FAT_BUFFER          ; es:bx = Write destination
    call BIOS_read

; Find the Root Directory on the disk - only for FAT12 and FAT16
    xor dx, dx
    mov ax, [BPB_RootEntCnt]    ; Count of directory entries in the Root Directory
    mov bx, DIR_ENTRY_SIZE      ; 32 bytes per entry
    mul bx                      ; ax = BPB_RootEntCnt * 32 BYTE
    add ax, [BPB_BytsPerSec]    ; Add the number of bytes per sector (for rounding up purposes later)
    dec ax                      ; ax = (BPB_RootEntCnt * 32 BYTE) + BPB_BytsPerSec -1
    mov bx, [BPB_BytsPerSec]
    div bx                      ; ax = ((BPB_RootEntCnt * 32 BYTE) + BPB_BytsPerSec -1) / BPB_BytsPerSec => Root Directory size
    push ax                     ; Save Root Directory size (in number of sectors)

    xor bx, bx
    mov ax, [BPB_FATSz16]       ; Sectors per FAT
    mov bl, [BPB_NumFATs]       ; Number of FATs
    mul bx                      ; ax = (BPB_NumFATs * BPB_FATSz16) => FAT Region Size
    add ax, [BPB_RsvdSecCnt]    ; ax += ReservedSectorCount => Root Directory start location (For FAT12 & FAT16)

; Load the Root Directory into memory
    pop cx                      ; Save Root Directory size (in number of sectors)
    mov bx, ROOT_DIR_BUFFER
    call BIOS_read

; Find the file in the root directory
    mov di, ROOT_DIR_BUFFER
    mov ax, 1                   ; counter for number of entries checked
.search_file:
    mov cx, FILE_NAME_SIZE
    push di                     ; cmpsb modifies DI so save it
    repe cmpsb                  ; Compares byte at address DS:SI with byte at address ES:DI and sets the status flags accordingly
    pop di
    je .get_start_cluster

    add di, DIR_ENTRY_SIZE      ; move to next directory entry
    inc ax                      ; another entry has been checked
    cmp ax, [BPB_RootEntCnt]    ; keep looping until all entries checked
    jl .search_file

    jmp failure                 ; in case all entries are exhausted and the file isn't found

.get_start_cluster:
    mov ax, [di + CLUSTER_LOW_OFFSET]
    ret


; Inputs:
;   AX = starting cluster number
;   ES:BX = memory address to load file
; Assumptions:
;   FAT has been loaded into RAM at FAT_BUFFER
FAT_load_chain:
;
; sub ax, 2
; mov [currentCluster], ax
;
;loop:
; Read cluster into memory
    xor cx, cx                  ; clear out cx
    mov cl, [BPB_SecPerClus]
    mul cx                      ; ax = cluster number * BPB_SecPerClus => starting sector number
    add ax, [dataRegionSector]  ; ax += dataRegionSector => actual starting sector address (LBA)
    ; ! replace dataRegionSector in the future
    mov dl, [BS_DrvNum]
    call BIOS_read

; Get Cluster Offset into the File Allocation Table
; FAT12 entries are 12-bit values packed together so every 2 clusters take up 3 bytes, meaning:
;   - If cluster number is even: use low 12 bits
;   - If odd: use high 12 bits (shifted right 4)
    push bx                     ; store the pointer for later
    mov ax, [currentCluster]
    add ax, 2                   ; add 2 to take into account the reserved entries
    mov bx, 3
    mul bx                      ; ax = currentCluster * 3
    mov bx, 2
    div bx                      ; ax = (currentCluster * 3) / 2 => File Allocation Table offset
    add ax, FAT_BUFFER          ; ax = 0x500 + Cluster Offset in bytes
    mov di, ax
    mov ax, [di]                ; read 2 bytes from File Allocation Table offset
    test dx, dx                 ; check division remainder
    jnz .odd                    ; if remainder != 0, jump

.even:
    and ax, 0x0FFF
    jmp .after

.odd:
    shr ax, 4

.after:
; Check current cluster EOF
    cmp word ax, FAT_EOF        ; Check the current cluster for EOF
    jae .chain_end              ; if greater than or equal

; Move to next cluster in the chain
    sub ax, 2                 ; subtract the reserved entries again
    mov [currentCluster], ax

; Update mem address pointed to by ES:BX
    mov ax, [BPB_BytsPerSec]
    xor cx, cx
    mov cl, [BPB_SecPerClus]
    mul cx                      ; ax = bytes per cluster
    pop bx                      ; restore the pointer
    add bx, ax                  ; offset the memory pointer by bytes per cluster (since we read an entire cluster)
    mov ax, [currentCluster]    ; Set starting cluster number for next call

    jmp FAT_load_chain

.chain_end:
    pop bx                      ; level the stack
    ret

%endif
