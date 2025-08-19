%ifndef __CONSTANTS_S
%define __CONSTANTS_S

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

EFLAGS_ID               equ 1 << 21

CPUID_EXTENSIONS        equ 1 << 31
CPUID_EXT_FEATURES      equ CPUID_EXTENSIONS | 1
CPUID_EDX_EXT_FEAT_LM   equ 1 << 29

PAGE_TABLE_SIZE         equ 0x1000
PGD_ADDRESS             equ 0x1000
PUD_ADDRESS             equ 0x2000
PMD_ADDRESS             equ 0x3000
PT_ADDRESS              equ 0x4000
PT_ADDR_MASK            equ 0xFFFFFFFFFF000
PT_PRESENT              equ 1 << 0
PT_READABLE             equ 1 << 1
ENTRIES_PER_PT          equ 512
SIZEOF_PT_ENTRY         equ 8
CR4_PAE_ENABLE          equ 1 << 5

EFER_MSR                equ 0xC0000080
EFER_LM_ENABLE          equ 1 << 8

CR0_PM_ENABLE           equ 1 << 0
CR0_PG_ENABLE           equ 1 << 31

PRESENT                 equ 1 << 7
NOT_SYS                 equ 1 << 4
EXEC                    equ 1 << 3
DC                      equ 1 << 2
RW                      equ 1 << 1
ACCESSED                equ 1 << 0

GRAN_4K                 equ 1 << 7
SZ_32                   equ 1 << 6
LONG_MODE               equ 1 << 5

%endif
