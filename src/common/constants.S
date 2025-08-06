%ifndef __CONSTANTS_S
%define __CONSTANTS_S

; FAT related constants
%ifdef FAT_FS
    FAT_BUFFER              equ 0x00500
    ROOT_DIR_BUFFER         equ 0x07E00
    FILE_NAME_SIZE          equ 11
    CLUSTER_LOW_OFFSET      equ 26
    CLUSTER_HIGH_OFFSET     equ 20
    DIR_ENTRY_SIZE          equ 32

; TODO: delete in the future and replace with runtime calculation
    %ifdef FAT12            ; BPB_RsvdSecCnt + (BPB_NumFATs * BPB_FATSz16) + ((BPB_RootEntCnt * 32) + BPB_BytsPerSec - 1) / BPB_BytsPerSec
        FAT_DATA_START      equ (0x1 + (0x2 * 0x9) + ((0xE0 * 32) + 0x200 - 1) / 0x200)
    %elifdef FAT16          ; BPB_RsvdSecCnt + (BPB_NumFATs * BPB_FATSz16) + ((BPB_RootEntCnt * 32) + BPB_BytsPerSec - 1) / BPB_BytsPerSec
        FAT_DATA_START      equ (0x4 + (0x2 * 0x86) + ((0x200 * 32) + 0x200 - 1) / 0x200)
    %elifdef FAT32          ; BPB_RsvdSecCnt + (BPB_NumFATs * BPB_FATSz32)
        FAT_DATA_START      equ (0x20 + (0x2 * 0x214))
    %endif

    %ifdef FAT12
        FAT_EOF             equ 0xFF8
    %elifdef FAT16
        FAT_ENTRY_SIZE      equ 0x2
        FAT_EOF             equ 0xFFF8
    %elifdef FAT32
        FAT_ENTRY_SIZE      equ 0x4
        FAT_EOF_HIGH        equ 0xFFFF
        FAT_EOF_LOW         equ 0xFFF8
    %endif
%endif

MAX_SECTORS_READ        equ 127

STAGE2_STACK            equ 0x07C00

STAGE2_OFFSET           equ 0x07E00
STAGE2_SEGMENT          equ 0x00000

MMAP_SMAP               equ 0x534D4150
MMAP_ENTRY_SIZE         equ 24
MMAP_ENTRY_COUNT        equ 32
MMAP_ENTRIES_SIZE       equ (MMAP_ENTRY_SIZE * MMAP_ENTRY_COUNT)

KERNEL_BUFFER_START     equ 0x6F000
KERNEL_BUFFER_END       equ 0x7F000

KERNEL_START            equ 0x100000

KERNEL_STACK_SIZE       equ 0x1000

VIDEO_MEMORY            equ 0xB8000
WHITE_ON_BLACK          equ 0x0F

%endif
