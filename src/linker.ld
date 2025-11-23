ENTRY(setup32Mode)

__STAGE2_START_ADDR = 0x7E00;
__KERNEL_ENTRY_ADDR = 0x10000;
__KERNEL_STACK_START_ADDR = 0x7FFF0;

SECTIONS {
    . = __STAGE2_START_ADDR;

    .text : {
        *(setup32Mode.text)
        *(boot32.text)
        *(setup64Mode.text)
        *(boot64.text)

        *(.text*)
    } : text

    .data : {
        *(.data*)
    } : data

    .rodata : {
        *(.rodata*)
    } : rodata

    .bss : {
        *(.bss*)
    } : bss
}

PHDRS {
    text    PT_LOAD FLAGS(5);  /* R-X (Read + Execute) */
    data    PT_LOAD FLAGS(6);  /* RW- (Read + Write)   */
    rodata  PT_LOAD FLAGS(4);  /* R-- (Read)           */
    bss     PT_LOAD FLAGS(6);  /* RW- (Read + Write)   */
}
