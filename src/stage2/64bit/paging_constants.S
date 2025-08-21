%ifndef __PAGING_CONSTANTS
%define __PAGING_CONSTANTS

PAGE_TABLE_SIZE             equ 0x1000
PAGE_TABLES_START           equ 0x1000

PGD_ADDRESS                 equ PAGE_TABLES_START + (PAGE_TABLE_SIZE * 0)
PUD_ADDRESS                 equ PAGE_TABLES_START + (PAGE_TABLE_SIZE * 1)
PMD_ADDRESS                 equ PAGE_TABLES_START + (PAGE_TABLE_SIZE * 2)
PT_ADDRESS                  equ PAGE_TABLES_START + (PAGE_TABLE_SIZE * 3)

PT_ENTRY_COUNT              equ 512
PT_ENTRY_SIZE               equ 8

; Common flags for all page table entries.
PT_ENTRY_PRESENT            equ 1 << 0   ; Page is present in memory.
PT_ENTRY_READ_WRITE         equ 1 << 1   ; Page is writable.
PT_ENTRY_USER_SUPERVISOR    equ 1 << 2   ; Accessible in user mode.
PT_ENTRY_PWT_WRITE_THRU     equ 1 << 3   ; Write-through caching.
PT_ENTRY_PCD_CACHE_DIS      equ 1 << 4   ; Disable caching for this page.
PT_ENTRY_ACCESSED           equ 1 << 5   ; Set by the CPU on access.
PT_ENTRY_DIRTY              equ 1 << 6   ; Set by the CPU on write.
PT_ENTRY_PAGE_SIZE_HUGE     equ 1 << 7   ; Huge page (2MB or 1GB).
PT_ENTRY_GLOBAL_64          equ 1 << 8   ; Prevents TLB flush.
PT_ENTRY_NX_EXEC_DISABLE    equ 1 << 63  ; No-Execute bit.

PT_ADDR_MASK                equ 0x000FFFFFFFFFF000 ; Mask for 64-bit physical address.

CR4_PAE_ENABLE              equ 1 << 5

%endif