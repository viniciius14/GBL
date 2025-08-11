%ifndef __PAGING_S
%define __PAGING_S
[bits 64]

section .text

enable_paging:
; Todo:
;   - Add the rest of the enabling code
;   - Fill in the page tables
;   - In the linker defines where bss.pages shall go

    mov rdi, PGD
    mov cr3, edi
    ret

section .bss.pages

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