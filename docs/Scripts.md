# Scripts

## [docker](../misc/scripts/docker.sh)
This script is responsible for checking if the user has docker installed and if so, it builds the image and runs it.

## [qemu_gdb](../misc/scripts/qemu_gbd.sh)
This script runs the selected image with QEMU and starts an instance of GBD to debug it, automatically stopping execution on the first instruction.

## [run_all](../misc/scripts/run_all.sh)
This script simply runs all images with QEMU that are currently in the build directory.
