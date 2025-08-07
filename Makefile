PROJECT := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))

include $(PROJECT)/misc/config.mk

# User inputs
FILE_SYSTEM ?=FAT12
ARCH_BITS   ?=BITS32
KERNEL_NAME ?=KERNEL  BIN

# User input options
SUPPORTED_FILE_SYSTEMS :=FAT12 FAT16 FAT32
SUPPORTED_TARGET_BITS  :=BITS32 BITS64

GBL_INCLUDES :=$(patsubst %,-i %,$(shell find $(SRC_DIR) -mindepth 1 -type d))
ARCH_DIRS    :=$(STAGE2_DIR)/16bit $(STAGE2_DIR)/32bit

TARGET_IMG   :=$(BUILD_DIR)/GBL_$(FILE_SYSTEM)_$(ARCH_BITS).img

ifeq ($(ARCH_BITS),BITS64)
    ARCH_DIRS  +=$(STAGE2_DIR)/64bit
    ASM_FORMAT :=-f elf64
    CC_FORMAT  :=-m64
    LD_FORMAT  :=-m elf_x86_64
    EMULATOR   :=qemu-system-x86_64
endif

export PROJECT FILE_SYSTEM ARCH_BITS KERNEL_NAME GBL_INCLUDES ARCH_DIRS ASM_FORMAT CC_FORMAT LD_FORMAT

.PHONY: all GBL debug clean run stats build

# Builds the default GBL image
GBL: dirs $(TARGET_IMG)

# Builds all possible GBL Images
all: dirs $(ALL_TARGET_IMAGES)
	$(foreach fs,$(SUPPORTED_FILE_SYSTEMS), $(foreach bits,$(SUPPORTED_TARGET_BITS), rm -rf $(BIN_DIR); rm -rf $(OBJ_DIR); $(MAKE) GBL ARCH_BITS=$(bits) FILE_SYSTEM=$(fs);))

# Runs the created image in QEMU
run: GBL $(TARGET_IMG)
ifeq ($(FILE_SYSTEM), FAT12)
	$(EMULATOR) -drive file=$(TARGET_IMG),format=raw,index=0,if=floppy $(EMUL_FLAGS)
else
	$(EMULATOR) -drive file=$(TARGET_IMG),format=raw,index=0,if=ide $(EMUL_FLAGS)
endif

# Cleans and builds the GBL in debug mode
debug: clean $(TARGET_IMG)
	@echo "\n--- Running Debug Build ---\n"
# TODO check if the extra parameters can be removed
	@$(MAKE) -C $(STAGE1_DIR) debug ARCH_BITS=$(ARCH_BITS) FILE_SYSTEM=$(FILE_SYSTEM)
	@$(MAKE) -C $(STAGE2_DIR) debug ARCH_BITS=$(ARCH_BITS) FILE_SYSTEM=$(FILE_SYSTEM)

# Generates a size report for the current bootloader binaries
stats: GBL
	@echo "--- Target: $(TARGET_IMG) ---" > $(STATS_FILE)
	$(call bin_size_stat, $(STAGE1_BIN))
	$(call bin_size_stat, $(STAGE2_BIN))
	@echo "\n" >> $(STATS_FILE)
	@cat $(STATS_FILE)

clean:
	@rm -rf $(BUILD_DIR)

dirs:
	@mkdir -p $(OBJ_DIR)
	@mkdir -p $(BIN_DIR)
	@mkdir -p $(DEBUG_DIR)


# Inner workings of the Makefile

$(TARGET_IMG): $(STAGE1_BIN) $(STAGE2_BIN)
	@echo "\n--- Image Creation for GBL_$(FILE_SYSTEM)_$(ARCH_BITS).img ---\n"
# Create the base filesystem image
ifeq ($(FILE_SYSTEM), FAT12)
	@echo "\nCreating a FAT 12 image -> $(TARGET_IMG) with 1.44MB\n"
	@dd if=/dev/zero of=$(TARGET_IMG) bs=512 count=2880
	@mkfs.fat $(TARGET_IMG) $(FS_FAT12_ARGS)
else ifeq ($(FILE_SYSTEM), FAT16)
	@echo "\nCreating a FAT 16 image -> $(TARGET_IMG) with 128MB\n"
	@dd if=/dev/zero of=$(TARGET_IMG) bs=512 count=273042
	@mkfs.fat $(TARGET_IMG) $(FS_FAT16_ARGS)
else ifeq ($(FILE_SYSTEM), FAT32)
	@echo "\nCreating a FAT 32 image -> $(TARGET_IMG) with 128MB\n"
	@dd if=/dev/zero of=$(TARGET_IMG) bs=512 count=273042
	@mkfs.fat $(TARGET_IMG) $(FS_FAT32_ARGS)
# Write a copy of stage1 bootloader and File System Information Structure to sector 6
	@dd if=$(STAGE1_BIN) of=$(TARGET_IMG) bs=512 seek=6 conv=notrunc
endif
# Write stage1 bootloader to sector 0
	@dd if=$(STAGE1_BIN) of=$@ bs=512 seek=0 conv=notrunc
# Add stage2 bootloader to the image "normally"
	@mcopy -i $@ $(STAGE2_BIN) ::stage2.bin


# Build the stages of the bootloader
$(STAGE1_BIN):
	@echo "\n--- Building Stage 1 for $(FILE_SYSTEM) $(ARCH_BITS) ---\n"
	@$(MAKE) -C $(STAGE1_DIR) FILE_SYSTEM=$(FILE_SYSTEM) ARCH_BITS=$(ARCH_BITS)

$(STAGE2_BIN):
	@echo "\n--- Building Stage 2 for $(FILE_SYSTEM) $(ARCH_BITS) ---\n"
	@$(MAKE) -C $(STAGE2_DIR) FILE_SYSTEM=$(FILE_SYSTEM) ARCH_BITS=$(ARCH_BITS)
