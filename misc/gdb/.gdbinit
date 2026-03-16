target remote :1234

# Add file mappings
directory src/
add-symbol-file build/obj/16/start.elf 0x7c00
add-symbol-file build/obj/stage2.elf 0x7e00

# 16 bit mode
set architecture i8086

# Stop right at the beginning of execution
break *0x7C00
continue
tui reg general
display/i $pc

# Functions
define dump_all
    dump memory build/dump1.bin 0x00500 0x07BFF
    dump memory build/dump2.bin 0x07C00 0x08FFF
    dump memory build/dump3.bin 0x09000 0x7FFFF
end
