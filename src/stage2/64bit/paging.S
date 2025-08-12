%ifndef __PAGING_S
%define __PAGING_S

[bits 32]

[global setup_paging]

%include "common.S"

section .text

; Set up paging
; Inputs:
;   - NONE
; Outputs:
;   - NONE
;
setup_paging:
    mov edi, PGD
    mov cr3, edi

; Clear the page tables
    xor eax, eax
    mov ecx, PAGE_TABLE_SIZE
    rep stosd                   ; For ecx repetitions, store the contents of eax into where edi points to
    mov edi, cr3

; set the first entry of PGD to PUDs address and add to it it's properties
    mov DWORD [edi], PUD_ADDRESS & PT_ADDR_MASK | PT_PRESENT | PT_READABLE

; set the first entry of PUD to PMDs address and add to it it's properties
    mov edi, PUD_ADDRESS
    mov DWORD [edi], PMD_ADDRESS & PT_ADDR_MASK | PT_PRESENT | PT_READABLE

; set the first entry of PMD to PTs address and add to it it's properties
    mov edi, PMD_ADDRESS
    mov DWORD [edi], PT_ADDRESS  & PT_ADDR_MASK | PT_PRESENT | PT_READABLE

    mov edi, PT_ADDRESS
    mov ebx, PT_PRESENT | PT_READABLE
    mov ecx, ENTRIES_PER_PT

.setEntry:
    mov DWORD [edi], ebx
    add ebx, PAGE_TABLE_SIZE
    add edi, SIZEOF_PT_ENTRY
    loop .setEntry

.enable_pae:
    mov eax, cr4
    or eax, CR4_PAE_ENABLE
    mov cr4, eax

    ret

section .pages.bss nobits
align 4096

PGD:
    resb PAGE_TABLE_SIZE

PUD:
    resb PAGE_TABLE_SIZE

PMD:
    resb PAGE_TABLE_SIZE

PT:
    resb PAGE_TABLE_SIZE

%endif