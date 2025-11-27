#!/bin/sh

# Define available options
FILE_SYSTEMS="FAT12 FAT16 FAT32"
ARCH_BITS_LIST="BITS32 BITS64"

for FS in $FILE_SYSTEMS; do
    for AB in $ARCH_BITS_LIST; do
        make clean

        make FILE_SYSTEM=$FS ARCH_BITS=$AB run || {
            echo "Build failed for $FS / $AB"
            exit 1
        }
    done
done
