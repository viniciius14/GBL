ENTRY(stage2_16bit)

__STAGE2_GBL_ADDR = 0x7E00;
__PAGING_TABLES_PHYS_ADDR = 0x1000;

__kernel_entry = 0x10000;

SECTIONS {
    . = __STAGE2_GBL_ADDR;

    .text : {
        __text_start__ = .;

        *(stage2_16bit.text)
        *(stage2_32bit.text)
        *(stage2_64bit.text)

        *(.text*)

        __text_end__ = .;
    } : text

    .data : {
        __data_start__ = .;

        *(.data*)

        __data_end__ = .;
    } : data

    .rodata : {
        __rodata_start__ = .;

        *(.rodata*)

        __rodata_end__ = .;
    } : rodata

    .bss : {
        __bss_start__ = .;

        *(.bss*)

        __bss_end__ = .;
    } : bss
}

PHDRS {
    text    PT_LOAD FLAGS(5);  /* R-X (Read + Execute) */
    data    PT_LOAD FLAGS(6);  /* RW- (Read + Write)   */
    rodata  PT_LOAD FLAGS(4);  /* R-- (Read)           */
    bss     PT_LOAD FLAGS(6);  /* RW- (Read + Write)   */
}
