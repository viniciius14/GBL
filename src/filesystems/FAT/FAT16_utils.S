%ifndef __FAT16_UTILS_S
%define __FAT16_UTILS_S

; Find a file in a FAT filesystem
; Inputs:
;   SI = pointer to 11-byte filename
; Outputs:
;   AX = starting cluster
; Assumptions:
;   Direction flag is cleared
;   DL = Drive Number
FAT_find_file:
; Find the File Allocation Table on the disk
    mov ax, [BPB_RsvdSecCnt]    ; ax = File Allocation Table region start sector
; Load the File Allocation Table into memory
    ; Since each File Allocation Table is too big to be loaded in it's entirety in FAT16 we'll load it only partially
    ; 0x7C00 - STACK_SIZE (+/- 500 bytes) - FAT_BUFFER(0x500) => 0x6C00 / BPB_BytsPerSec => +/- 54 sectors that we can read
    mov cl, 50                  ; load 50 sectors into memory
    mov bx, FAT_BUFFER          ; es:bx points to destination
    call BIOS_read
; Find the Root Directory on the disk
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
    add ax, [BPB_RsvdSecCnt]    ; ax += ReservedSectorCount => Root Directory start location

; Load the Root Directory into memory
    pop cx                      ; Save Root Directory size (in number of sectors)
    mov dx, [BS_DrvNum]         ; Set back drive number
    mov bx, ROOT_DIR_BUFFER
    call BIOS_read
; Find the file in the root directory
    mov di, ROOT_DIR_BUFFER
    mov ax, 1                   ; counter for number of entries checked

.search_file:
    mov cx, FILE_NAME_SIZE
    push cx
    push di
    push si                     ; cmpsb will modify DI and SI while repe will modify CX, so save them before use
    repe cmpsb                  ; Compares byte at address DS:SI with byte at address ES:DI and sets the status flags accordingly
    pop si
    pop di
    pop cx
    je .get_start_cluster

    add di, DIR_ENTRY_SIZE      ; move to next directory entry
    inc ax                      ; another entry has been checked
    cmp ax, [BPB_RootEntCnt]    ; keep looping until all entries checked
    jl .search_file

    jmp failure                 ; in case all entries are exausted and the file isn't found

.get_start_cluster:
    mov ax, [di + CLUSTER_LOW_OFFSET]
    ret


; Inputs:
;   AX = starting cluster number
;   ES:BX = memory address to load file
; Assumptions
;   FAT has been loaded into RAM at FAT_BUFFER
;   ES = 0
FAT_load_chain:
; Read cluster into memory
    xor cx, cx                  ; clear out cx
    mov cl, [BPB_SecPerClus]
    mul cx                      ; ax = cluster number * BPB_SecPerClus => starting sector number
    add ax, [dataRegionSector]  ; ax += dataRegionSector => actual starting sector address (LBA)
    mov dl, [BS_DrvNum]
; ! replace dataRegionSector in the future
; ! BPB_RsvdSecCnt + (BPB_NumFATs * BPB_FATSz16) + ((BPB_RootEntCnt * 32) + BPB_BytsPerSec - 1) / BPB_BytsPerSec
; ! FAT_DATA_START      equ (0x4 + (0x2 * 0x86) + ((0x200 * 32) + 0x200 - 1) / 0x200)

    call BIOS_read
; Get Cluster Offset into the File Allocation Table
    mov ax, [currentCluster]
    add ax, 2                   ; add 2 to take into account the reserved entries
    xor cx, cx
    mov cl, FAT_ENTRY_SIZE      ; cl = 2
    mul cx                      ; ax = current cluster * 2 => Cluster Offset in bytes
    add ax, FAT_BUFFER          ; ax = 0x500 + Cluster Offset in bytes
    mov di, ax

; Check current cluster EOF
    cmp word [di], FAT_EOF      ; Check the current cluster for EOF
    jae .chain_end              ; if greater than or equal

; Move to next cluster in the chain
    mov ax, [di]
    sub ax, 2                   ; subtract the reserved entries again
    mov [currentCluster], ax

; Update mem address pointed to by ES:BX
    mov ax, [BPB_BytsPerSec]
    xor cx, cx
    mov cl, [BPB_SecPerClus]
    mul cx                      ; ax = bytes per cluster
    add bx, ax                  ; offset the memory pointer by bytes per cluster (since we read an entire cluster)

; Set starting cluster number for next call
    mov ax, [currentCluster]

    jmp FAT_load_chain

.chain_end:
    ret

%endif
