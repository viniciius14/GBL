%ifndef __FAT32_UTILS_S
%define __FAT32_UTILS_S

; Find a file in a FAT filesystem
; Inputs:
;   SI = pointer to 11-byte filename
; Outputs:
;   AX = starting cluster
; Assumptions:
;   Direction flag is cleared
;   DL = Drive Number
FAT_find_file:
; Load the File Allocation Table into memory
    mov ax, [BPB_RsvdSecCnt]    ; ax = File Allocation Table region start sector
    ; Since the File Allocation Table is too big to be loaded in it's entirety we'll load it only partially
    ; 0x7C00 - STACK_SIZE (+/- 500 bytes) - FAT_BUFFER(0x500) => 0x6C00 / BPB_BytsPerSec => +/- 54 sectors that we can read
    mov cl, 50                  ; load 50 sectors into memory
    mov bx, FAT_BUFFER          ; es:bx points to destination
    call BIOS_read

; Load the Root Directory into memory
    mov ax, [BPB_RootClus]      ; cluster number of the first cluster of the root directory
    mov [currentCluster], ax
    mov bx, ROOT_DIR_BUFFER
    call FAT_load_chain         ; Go to the File Allocation Table and load the root dir into memory

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
    sub ax, 2                   ; clusters are numbered starting from 2, not from 0
    mov [currentCluster], ax

.loop:
; Read cluster into memory
    xor cx, cx                  ; clear out cx
    mov cl, [BPB_SecPerClus]
    mul cx                      ; ax = cluster number * BPB_SecPerClus => starting sector number
    add ax, [dataRegionSector]  ; ax += dataRegionSector => actual starting sector address (LBA)
    mov dl, [BS_DrvNum]
    call BIOS_read

; Get cluster offset into the File Allocation Table
    mov ax, [currentCluster]
    add ax, 2                   ; add 2 to take into account the reserved entries
    xor cx, cx
    mov cl, FAT_ENTRY_SIZE      ; cl = 2
    mul cx                      ; ax = current cluster * 2 => Cluster Offset in bytes
    add ax, FAT_BUFFER          ; ax = 0x500 + Cluster Offset in bytes
    mov di, ax

; Check current cluster EOF
    cmp word [di], FAT_EOF_LOW  ; Check the current cluster for EOF
    jae .chain_end              ; if greater than or equal

; Move to next cluster in the chain
    mov ax, [di]
    sub ax, 2
    mov [currentCluster], ax

; Update mem address pointed to by ES:BX
    mov ax, [BPB_BytsPerSec]
    xor cx, cx
    mov cl, [BPB_SecPerClus]
    mul cx                      ; ax = bytes per cluster
    add bx, ax                  ; offset the memory pointer by bytes per cluster (since we read an entire cluster)

; Set starting cluster number for next call
    mov ax, [currentCluster]

    jmp .loop

.chain_end:
    ret

%endif
