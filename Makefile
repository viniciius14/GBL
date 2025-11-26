export PROJECT := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))

include $(PROJECT)/misc/config.mk

# User inputs
export FILE_SYSTEM ?=FAT12
export ARCH_BITS   ?=BITS32
export KERNEL_NAME ?=GECKOS  BIN

# User input options
SUPPORTED_FILE_SYSTEMS :=FAT12 FAT16 FAT32
SUPPORTED_TARGET_BITS  :=BITS32 BITS64

TARGET :=$(BUILD_DIR)/GBL_$(FILE_SYSTEM)_$(ARCH_BITS).img

ifeq ($(ARCH_BITS), BITS32)
export ASM_FORMAT :=$(ASM_FORMAT32)
export CC         :=$(CC32)
export EMULATOR   :=$(EMULATOR32)
export LD_FORMAT  :=$(LD_FORMAT32)
export CC_FORMAT  :=$(CC_FORMAT32)
else
export ASM_FORMAT :=$(ASM_FORMAT64)
export CC         :=$(CC64)
export EMULATOR   :=$(EMULATOR64)
export LD_FORMAT  :=$(LD_FORMAT64)
export CC_FORMAT  :=$(CC_FORMAT64)
endif

ifeq ($(FILE_SYSTEM), FAT12)
	INTERFACE=floppy
else
	INTERFACE=ide
endif


.PHONY: GBL run clean build_dir sources link common kernel_stub

GBL: build_dir $(TARGET) $(KERNEL_STUB)

run: GBL
	$(EMULATOR) -d int,unimp,cpu_reset,in_asm -D $(BUILD_DIR)/QEMU_log.txt -no-reboot -drive file=$(TARGET),format=raw,index=0,if=$(INTERFACE) $(EMUL_FLAGS)

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
	mkdir -p $(OBJ_DIR_COMMON)

	touch $(STATS_FILE) && echo -n "" > $(STATS_FILE)
	@echo "\n--- Build Directory Created ---\n"

sources: $(BOOT16) $(BOOT32) $(BOOT64) common

link: sources
# Since there will be no files in OBJ/64 if the target isn't BITS64
	$(LD) $(LD_FLAGS) $(LD_FORMAT) \
	$(shell find $(OBJ_DIR) -type f -name '*.o') \
	-T $(SRC_DIR)/linker.ld -o $(OBJ_DIR)/boot_S2.elf
# Generate disassembly for debugging
	$(OBJ_DMP) $(OBJ_DMP_FLAGS) $(OBJ_DIR)/boot_S2.elf > $(DEBUG_DIR)/boot_S2_dbg.S
# Create binary from the linked elf
	$(OBJ_CPY) -O binary $(OBJ_DIR)/boot_S2.elf $(BIN_DIR)/boot_S2.bin

$(TARGET): link
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
	@mcopy -i $@ $(BIN_DIR)/boot_S2.bin ::GBL_S2.bin
# Add stub kernel to the image
# 	@mcopy -i $@ $(BIN_DIR)/GECKOS.bin ::GECKOS.bin

common:
	$(MAKE) -C $(SRC_DIR)/common

$(BOOT16):
	$(MAKE) -C $(SRC_DIR)/boot16

$(BOOT32):
	$(MAKE) -C $(SRC_DIR)/boot32

$(BOOT64):
ifeq ($(ARCH_BITS), BITS64)
	$(MAKE) -C $(SRC_DIR)/boot64
endif

kernel_stub:
	$(MAKE) -C $(SRC_DIR)/kernelStub
