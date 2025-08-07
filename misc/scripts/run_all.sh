#!/bin/bash

# Find all files starting with GBL*
shopt -s nullglob
FILES=(build/GBL*)

if [[ ${#FILES[@]} -eq 0 ]]; then
    echo "No files starting with 'GBL' found in build."
    exit 0
fi

# Loop over the files
for file in "${FILES[@]}"; do
    filename="$(basename "$file")"

    # Determine architecture
    if [[ "$filename" == *BITS64* ]]; then
        QEMU_BIN="qemu-system-x86_64"
    else
        QEMU_BIN="qemu-system-i386"
    fi

    # Determine interface type
    if [[ "$filename" == *FAT12* ]]; then
        INTERFACE="if=floppy"
    else
        INTERFACE="if=ide"
    fi

    echo "Launching: $QEMU_BIN with $INTERFACE for $filename"
    $QEMU_BIN \
        -drive file="$file",format=raw,index=0,"$INTERFACE" \
        -m 128M \
        -serial stdio \
        -machine pc
done
