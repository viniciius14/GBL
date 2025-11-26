%ifndef __BOOT64_CONSTANTS_S
%define __BOOT64_CONSTANTS_S

%macro unreachable 0
    cli             ; disable interrupts
    hlt             ; this way CPU can't get out of "halt" state
    jmp $
%endmacro

; CPU ID related constants
EFLAGS_ID               equ 1 << 21

CPUID_EXTENSIONS        equ 1 << 31
CPUID_EXT_FEATURES      equ CPUID_EXTENSIONS | 1
CPUID_EDX_EXT_FEAT_LM   equ 1 << 29

; Compatibility mode related constants
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

; Kernel related constants
; Memory region where the kernel will be written to
KERNEL_BUFFER_START     equ 0x6F000
KERNEL_BUFFER_END       equ 0x7F000
KERNEL_BUFFER_SIZE      equ 0x10000

; Address where the kernel will be loaded into
KERNEL_START            equ 0x100000; __KERNEL_ENTRY_ADDR
KERNEL_STACK_START      equ 0x100000; __KERNEL_STACK_START_ADDR

%endif
