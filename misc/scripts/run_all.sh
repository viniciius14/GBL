#!/bin/sh

# Define available options
FILE_SYSTEMS="FAT12 FAT16 FAT32"
ARCH_BITS_LIST="BITS32 BITS64"

echo ""
echo "=== Building all combinations of FILE_SYSTEM and ARCH_BITS ==="
echo ""

for FS in $FILE_SYSTEMS; do
    for AB in $ARCH_BITS_LIST; do
        echo "--------------------------------------------------------"
        echo " Cleaning build directory..."
        make clean

        echo " Building for FILE_SYSTEM=$FS  ARCH_BITS=$AB"
        make FILE_SYSTEM=$FS ARCH_BITS=$AB run || {
            echo "Build failed for $FS / $AB"
            exit 1
        }

        echo "Done: $FS / $AB"
        echo "--------------------------------------------------------"
        echo ""
    done
done

echo ""
echo "=== All builds completed successfully ==="
