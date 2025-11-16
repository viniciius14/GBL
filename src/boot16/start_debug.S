%line 1+1 start.S
[bits 16]
[org 0x7C00]

[section .text]





%line 16+1 boot16_constants.S
STACK_START equ 0x07C00



 FAT_BUFFER equ 0x00500
 ROOT_DIR_BUFFER equ 0x07E00
 FILE_NAME_SIZE equ 11
 CLUSTER_LOW_OFFSET equ 26
 CLUSTER_HIGH_OFFSET equ 20
 DIR_ENTRY_SIZE equ 32



 FAT_DATA_START equ (0x1 + (0x2 * 0x9) + ((0xE0 * 32) + 0x200 - 1) / 0x200)
%line 35+1 boot16_constants.S



 FAT_EOF equ 0xFF8
%line 48+1 boot16_constants.S

MAX_SECTORS_READ equ 127

STAGE2_OFFSET equ 0x07E00
STAGE2_SEGMENT equ 0x00000

%line 59+1 boot16_constants.S

%line 67+1 boot16_constants.S

%line 20+1 metadata/FAT/FAT_header.S
jmp strict short start
nop

BS_OEMName: db "GECKOS  "


 BPB_BytsPerSec: dw 0x200
 BPB_SecPerClus: db 0x1
 BPB_RsvdSecCnt: dw 0x1
 BPB_NumFATs: db 0x2
 BPB_RootEntCnt: dw 0xE0
 BPB_TotSec16: dw 2880
 BPB_Media: db 0xF0
 BPB_FATSz16: dw 0x9
 BPB_SecPerTrk: dw 0x12
 BPB_NumHeads: dw 0x2
 BPB_HiddSec: dd 0x0
 BPB_TotSec32: dd 0x0
%line 65+1 metadata/FAT/FAT_header.S




 BS_DrvNum: db 0x0
 BS_Reserved1: db 0x0
 BS_BootSig: db 0x29
 BS_VolID: db 0x12, 0x34, 0x56, 0x78
 BS_VolLab: db "GECKOS     "
 BS_FilSysType: db "FAT12   "
%line 16+1 start.S
start:
 cli
 cld
 jmp 0x0000:.stage1_start

.stage1_start:
 xor ax, ax
 mov ds, ax
 mov es, ax
 mov ss, ax
 mov sp, STACK_START
 mov [BS_DrvNum], dx


 mov ah, 0x0
 mov al, 0x3
 int 0x10

 mov si, stage2FileName


 call find_file

 xor bx, bx
 mov es, bx
 mov bx, STAGE2_OFFSET
 call load_file

 jmp setup


%line 48+1 GDT/setup32Bit.S
[bits 16]









[section .text]

%line 61+1 GDT/A20.S
[bits 16]

[section .text]







A20_line:






.A20_disabled:

 in al, 0x92
 or al, 2
 out 0x92, al










.A20_enabled:



 ret



















































%line 68+1 GDT/GDT.S
[bits 16]

[section .text]



set_GDT:
 cli
 lgdt [GDT_Descriptor]

 ret



GDT_Start:
 .null_descriptor:
 dd 0
 dd 0
 .code_descriptor:
 dw 0xFFFF
 dw 0
 db 0
 db 0b10011010
 db 0b11001111
 db 0
 .data_descriptor:
 dw 0xFFFF
 dw 0
 db 0
 db 0b10010010
 db 0b11001111
 db 0
GDT_End:


GDT_Descriptor:
 dw GDT_End - GDT_Start - 1
 dd GDT_Start

%line 63+1 start.S
setup32Bit:


 xor ax, ax
 mov ds, ax
 mov es, ax








 call A20_line










 mov al, 0x13


 xor ah, ah
 int 0x10


 call set_GDT


 mov eax, cr0
 or eax, 1
 mov cr0, eax

 ret
























%line 48+1 start.S

setup:
 call setup32Bit

 jmp GDT_Start.code_descriptor - GDT_Start:0x7E00

%line 76+1 ../firmware/BIOS/BIOS_read.S
[bits 16]


















read:
 push ax
 push bx
 push cx
 push dx
 push di
 push cx
 call lba_to_chs
 pop ax
 mov ah, 0x2
 mov di, 3

.retry:
 pusha
 stc
 int 13h
 jnc .done

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
 pop ax
 ret










lba_to_chs:
 push ax
 push dx

 xor dx, dx
 div word [BPB_SecPerTrk]

 inc dx
 mov cx, dx

 xor dx, dx
 div word [BPB_NumHeads]

 mov dh, dl
 mov ch, al
 shl ah, 6
 or cl, ah

 pop ax
 mov dl, al
 pop ax
 ret

%line 79+1 ../firmware/BIOS/BIOS_disk_reset.S
[bits 16]

[section .text]

[global BIOS_disk_reset]


[extern failure]








BIOS_disk_reset:
 pusha
 mov ah, 0
 stc
 int 13h
 jc failure

 popa
 ret

%line 83+1 drivers/FAT/FAT12_utils.S
find_file:

 mov ax, [BPB_RsvdSecCnt]
 mov cl, [BPB_FATSz16]
 mov bx, FAT_BUFFER
 call read


 xor dx, dx
 mov ax, [BPB_RootEntCnt]
 mov bx, DIR_ENTRY_SIZE
 mul bx
 add ax, [BPB_BytsPerSec]
 dec ax
 mov bx, [BPB_BytsPerSec]
 div bx
 push ax

 xor bx, bx
 mov ax, [BPB_FATSz16]
 mov bl, [BPB_NumFATs]
 mul bx
 add ax, [BPB_RsvdSecCnt]


 pop cx
 mov bx, ROOT_DIR_BUFFER
 call read


 mov di, ROOT_DIR_BUFFER
 mov ax, 1
.search_file:
 mov cx, FILE_NAME_SIZE
 push di
 repe cmpsb
 pop di
 je .get_start_cluster

 add di, DIR_ENTRY_SIZE
 inc ax
 cmp ax, [BPB_RootEntCnt]
 jl .search_file

 jmp failure

.get_start_cluster:
 mov ax, [di + CLUSTER_LOW_OFFSET]
 ret







load_file:
 sub ax, 2
 mov [currentCluster], ax

.loop:

 xor cx, cx
 mov cl, [BPB_SecPerClus]
 mul cx
 add ax, [dataRegionSector]

 mov dl, [BS_DrvNum]
 call read





 mov ax, [currentCluster]
 add ax, 2
 mov cx, 3
 mul cx
 mov cx, 2
 div cx
 add ax, FAT_BUFFER
 mov di, ax
 mov ax, [di]
 test dx, dx
 jnz .odd

.even:
 and ax, 0x0FFF
 jmp .after

.odd:
 shr ax, 4

.after:

 cmp word ax, FAT_EOF
 jae .chain_end


 sub ax, 2
 mov [currentCluster], ax


 mov ax, [BPB_BytsPerSec]
 xor cx, cx
 mov cl, [BPB_SecPerClus]
 mul cx
 add bx, ax
 mov ax, [currentCluster]

 jmp .loop

.chain_end:
 ret

%line 56+1 start.S
failure:


 hlt
 jmp $

stage2FileName: db "GBL_S2  BIN"
errorMsg: db "CRITICAL ERROR", 0
currentCluster: dw 0
dataRegionSector: dw FAT_DATA_START

times (510 - ($ - $$)) db 0
dw 0xAA55

