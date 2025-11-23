%ifndef __PAGING_S
%define __PAGING_S

[bits 32]

[global setup_paging]

%include "paging_constants.S"

section .text

; Set up paging
; Inputs:
;   - NONE
; Outputs:
;   - NONE
;
setup_paging:
    mov edi, PGD_ADDRESS
    mov cr3, edi

; Clear the page tables
    xor eax, eax
    mov ecx, PAGE_TABLE_SIZE
    rep stosd                   ; For ecx repetitions, store the contents of eax into where edi points to
    mov edi, cr3

; set the first entry of PGD to PUDs address and add to it it's properties
    mov DWORD [edi], PUD_ADDRESS & PT_ADDR_MASK | PT_ENTRY_PRESENT | PT_ENTRY_READ_WRITE

; set the first entry of PUD to PMDs address and add to it it's properties
    mov edi, PUD_ADDRESS
    mov DWORD [edi], PMD_ADDRESS & PT_ADDR_MASK | PT_ENTRY_PRESENT | PT_ENTRY_READ_WRITE

; set the first entry of PMD to PTs address and add to it it's properties
    mov edi, PMD_ADDRESS
    mov DWORD [edi], PT_ADDRESS  & PT_ADDR_MASK | PT_ENTRY_PRESENT | PT_ENTRY_READ_WRITE

; In setup_paging (Still in 32-bit mode, preparing PAE)
; ... (PUD, PMD setup is fine as PGD/PUD/PMD tables are guaranteed to be in low 4GB)

    mov edi, PT_ADDRESS
    mov ebx, 0         ; ebx = current physical address base (0x0)
    mov ecx, PT_ENTRY_COUNT
    mov esi, PT_ENTRY_PRESENT | PT_ENTRY_READ_WRITE ; esi holds the flags (3)

.setEntry:
    ; Write the low 32 bits of the PTE (Physical Address + Flags)
    or ebx, esi     ; ebx now holds PADDR_LOW | FLAGS
    mov DWORD [edi], ebx  ; Write low 32 bits of PTE

    ; Write the high 32 bits of the PTE (Must be 0 if PADDR is < 4GB)
    mov DWORD [edi + 4], 0  ; Write high 32 bits of PTE (PAE entry is 8 bytes)

    ; Restore ebx to PADDR base for next entry
    and ebx, 0xFFFFF000  ; <--- FIX: Use 32-bit mask to clear flags (low 12 bits)

    ; Prepare for next entry (increment physical address base by 4KB)
    add ebx, PAGE_TABLE_SIZE ; Increment physical base address by 4KB (0x1000)
    add edi, PT_ENTRY_SIZE  ; Move to next PTE (increment EDI by 8 bytes)
    loop .setEntry

.enable_pae:
    mov eax, cr4
    or eax, CR4_PAE_ENABLE
    mov cr4, eax

    ret

%endif