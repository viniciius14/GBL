all:
	x86_64-elf-gcc -m32 -Wall -Wextra -Werror -nostdlib -fno-builtin -ffreestanding -mgeneral-regs-only -fdata-sections -ffunction-sections -pedantic -std=c11 -Wl,-emain -c main.c -o ../../build/obj/kernelStub.o

	objcopy -O binary ../../build/obj/kernelStub.o ../../build/bin/GECKOS.bin
