target remote :1234
break *0x7C00
continue
tui reg general
display/i $pc

define dump_all
    dump memory build/dump1.bin 0x00500 0x07BFF
    dump memory build/dump2.bin 0x07C00 0x08FFF
    dump memory build/dump3.bin 0x09000 0x7FFFF
end
