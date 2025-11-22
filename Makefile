PROJECT := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))

include $(PROJECT)/misc/config.mk

# User inputs
FILE_SYSTEM ?=FAT12
ARCH_BITS   ?=BITS32
KERNEL_NAME ?=GECKOS  BIN

# User input options
SUPPORTED_FILE_SYSTEMS :=FAT12 FAT16 FAT32
SUPPORTED_TARGET_BITS  :=BITS32 BITS64

TARGET :=$(BUILD_DIR)/GBL_$(FILE_SYSTEM)_$(ARCH_BITS).img

export PROJECT FILE_SYSTEM ARCH_BITS KERNEL_NAME

EMULATOR=$(EMULATOR32)
ifeq (($ARCH_BITS), BITS64)
	EMULATOR=$(EMULATOR64)
endif

INTERFACE=ide
ifeq ($(FILE_SYSTEM), FAT12)
	INTERFACE=floppy
endif

.PHONY: GBL all run debug clean

GBL: build_dir $(TARGET) $(KERNEL_STUB)

run: GBL
	$(EMULATOR) -drive file=$(TARGET),format=raw,index=0,if=$(INTERFACE) $(EMUL_FLAGS)

clean:
	rm -rf $(BUILD_DIR)

build_dir:
	mkdir -p $(OBJ_DIR)
	mkdir -p $(OBJ_DIR32)
	mkdir -p $(OBJ_DIR64)
	mkdir -p $(BIN_DIR)
	mkdir -p $(DEBUG_DIR)
	mkdir -p $(DEBUG_DIR16)
	mkdir -p $(DEBUG_DIR32)
	mkdir -p $(DEBUG_DIR64)

	touch $(STATS_FILE) && echo -n "" > $(STATS_FILE)
	@echo "\n--- Build Directory Created ---\n"

kernel_stub:
	$(MAKE) -C $(SRC_DIR)/kernelStub

$(TARGET): $(BOOT16) $(BOOT32) $(BOOT64)
	@echo "\n--- Image Creation for GBL_$(FILE_SYSTEM)_$(ARCH_BITS).img ---"
# Create the base filesystem image
ifeq ($(FILE_SYSTEM), FAT12)
	@echo "\nCreating a FAT 12 image -> $(TARGET) with 1.44MB\n"
	dd if=/dev/zero of=$(TARGET) bs=512 count=2880
	mkfs.fat $(TARGET) $(FS_FAT12_ARGS)
else ifeq ($(FILE_SYSTEM), FAT16)
	@echo "\nCreating a FAT 16 image -> $(TARGET) with 128MB\n"
	@dd if=/dev/zero of=$(TARGET) bs=512 count=273042
	@mkfs.fat $(TARGET) $(FS_FAT16_ARGS)
else ifeq ($(FILE_SYSTEM), FAT32)
	@echo "\nCreating a FAT 32 image -> $(TARGET) with 128MB\n"
	@dd if=/dev/zero of=$(TARGET) bs=512 count=273042
	@mkfs.fat $(TARGET) $(FS_FAT32_ARGS)
# Write a copy of stage1 bootloader and File System Information Structure to sector 6
	@dd if=$(BOOT16) of=$(TARGET) bs=512 seek=6 conv=notrunc
endif
# Write stage1 bootloader to sector 0
	@dd if=$(BOOT16) of=$@ bs=512 seek=0 conv=notrunc
# Add stage2 bootloader to the image
ifeq ($(ARCH_BITS), BITS32)
	@mcopy -i $@ $(BOOT32) ::GBL_S2.bin
else ifeq ($(ARCH_BITS), BITS64)
	@mcopy -i $@ $(BOOT64) ::GBL_S2.bin
endif
# Add stub kernel to the image
# 	@mcopy -i $@ $(BIN_DIR)/GECKOS.bin ::GECKOS.bin

$(BOOT16):
	$(MAKE) -C $(SRC_DIR)/boot16

$(BOOT32):
	$(MAKE) -C $(SRC_DIR)/boot32

ifeq ($(ARCH_BITS), BITS32)
# Perform the linking of the 32/.o files into an elf and then to a binary
	$(LD) $(LD_FLAGS) $(LD_FORMAT) $(OBJ_DIR32)/boot32_all.o -T $(BOOT32_DIR)/linker.ld -o $(OBJ_DIR32)/boot32.elf
	$(OBJ_CPY) -O binary $(OBJ_DIR32)/boot32.elf $(BOOT32)
endif

$(BOOT64):
ifeq ($(ARCH_BITS), BITS64)
	$(MAKE) -C $(SRC_DIR)/boot64

# Perform the linking of the 32/.o and the 64/.o files into an elf and then to a binary
	$(LD) $(LD_FLAGS) $(LD_FORMAT64) $(OBJ_DIR32)/boot32_all.o $(OBJ_DIR64)/boot64_all.o -T $(BOOT64_DIR)/linker.ld -o $(OBJ_DIR64)/boot64.elf
	$(OBJ_CPY) -O binary $(OBJ_DIR64)/boot64.elf $(BOOT64)
endif


