#!/bin/bash

# Sanitize inputs
if [ -z "$1" ] || [ -z "$2" ] || [ $# -eq 0 ] || [ $# -gt 2 ]
then
    echo "Usage \"bash /qemu_gdb.sh <FILESYSTEM> <BITS>\""
    echo "Options are: FAT12 FAT16 FAT32 for FILESYSTEM"
    echo "Options are: BITS32 BITS64 for ARCHITECTURE BITS"
    exit
fi

# Find the image
IMG="$(find build/ -type f -name "GeckOS_*.img")"

# Start QEMU as a background process
if [[ "$1" == "FAT12" ]]
then
    qemu-system-i386 -drive file=${IMG},format=raw,index=0,if=floppy -m 128M -serial stdio -s -S &
else
    qemu-system-i386 -drive file=${IMG},format=raw,index=0,if=ide -m 128M -serial stdio -s -S &
fi

# Start GDB and connect to the same port as QEMU
i386-elf-gdb --nh --nx --command=misc/.gdbinit

kill %1
