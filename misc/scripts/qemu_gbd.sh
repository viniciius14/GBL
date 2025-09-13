#!/bin/bash
set -e

# Sanitize inputs
if [ -z "$1" ] || [ -z "$2" ] || [ $# -eq 0 ] || [ $# -gt 2 ]
then
    echo "Usage \"bash /qemu_gdb.sh <FILESYSTEM> <BITS>\""
    echo "Options are: FAT12 FAT16 FAT32 for FILESYSTEM"
    # echo "Options are: BITS32 BITS64 for ARCHITECTURE BITS"
    echo "Options are: BITS32 for ARCHITECTURE BITS"
    return
fi

if [ ! -d "/build/" ]; then
  echo "Build directory doesn't exist yet."
  echo "Please run the make command and build an image."
  return
fi

# Find the image
IMG="$(find build/ -type f -name "GBL*.img")"

# Determine interface type
if [[ "$1" == "FAT12" ]]; then
    INTERFACE="if=floppy"
else
    INTERFACE="if=ide"
fi

# Determine architecture
# if [[ "$2" == "BITS64" ]]; then
#     QEMU_BIN="qemu-system-x86_64"
# else
#     QEMU_BIN="qemu-system-i386"
# fi

echo "Launching: $QEMU_BIN with $INTERFACE for $filename"

$QEMU_BIN \
    -drive file=${IMG},format=raw,index=0,"$INTERFACE" \
    -m 128M \
    -serial stdio \
    -machine pc \
    -s -S &

# Start GDB and connect to the same port as QEMU
i386-elf-gdb --nh --nx --command=misc/gdb/.gdbinit

kill %1
