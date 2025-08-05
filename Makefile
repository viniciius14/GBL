PROJECT := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))

include $(PROJECT)/misc/config.mk

# User inputs
FILE_SYSTEM ?= FAT12
ARCH_BITS   ?= BITS32
KERNEL_NAME ?= KERNEL  BIN

# User Input Options
SUPPORTED_FILE_SYSTEMS := FAT12 FAT16 FAT32
SUPPORTED_TARGET_BITS  := BITS32 BITS64

# Current target
TARGET_IMG = $(BUILD_DIR)/GeckOS_$(FILE_SYSTEM)_$(ARCH_BITS).img
# All possible target images
ALL_TARGET_IMAGES := $(foreach fs,$(SUPPORTED_FILE_SYSTEMS), \
           $(foreach bits,$(SUPPORTED_TARGET_BITS), \
           $(BUILD_DIR)/GeckOS_$(fs)_$(bits).img))

# TODO: See if this can be compacted into a single line
GBL_DIRS     = $(shell find $(SRC_DIR) -mindepth 1 -type d)
GBL_INCLUDES = $(foreach dir, $(GBL_DIRS),-i $(dir))

export PROJECT FILE_SYSTEM ARCH_BITS KERNEL_NAME CC_FLAGS ASM_FLAGS GBL_INCLUDES

.PHONY: all GBL debug clean run stats

# User targets

# Builds the default GBL image
GBL: $(BIN_DIR)/stage1_$(FILE_SYSTEM).bin $(BIN_DIR)/stage2.bin

# Builds all possible GBL Images
all: $(ALL_TARGET_IMAGES)

# Runs the created image in QEMU
run: $(TARGET_IMG)
ifeq ($(FILE_SYSTEM), FAT12)
	$(EMULATOR) -drive file=$(TARGET_IMG),format=raw,index=0,if=floppy $(EMUL_FLAGS)
else
	$(EMULATOR) -drive file=$(TARGET_IMG),format=raw,index=0,if=ide $(EMUL_FLAGS)
endif

# Cleans, builds the GBL, then runs QEMU with GDB
debug: clean GBL
	@echo "\n--- Running Debug Build ---\n"
	@$(MAKE) -C $(STAGE1_DIR) debug ARCH_BITS=$(ARCH_BITS) FILE_SYSTEM=$(FILE_SYSTEM)
	@$(MAKE) -C $(STAGE2_DIR) debug ARCH_BITS=$(ARCH_BITS) FILE_SYSTEM=$(FILE_SYSTEM)
	@bash $(SCRIPTS_DIR)/QEMU_GDB.sh $(FILE_SYSTEM) $(ARCH_BITS)


# Stats target: Generates a size report for the current bootloader binaries.
stats: GBL
	@echo "--- Target: $(CURRENT_TARGET_IMG) ---" > $(STATS_FILE)
	$(call bin_size_stat, $(BIN_DIR)/stage1_$(FILE_SYSTEM)_$(ARCH_BITS).bin)
	$(call bin_size_stat, $(BIN_DIR)/stage2_$(ARCH_BITS).bin)
	@echo "\n" >> $(STATS_FILE)
	@cat $(STATS_FILE) # Display the stats after generation


clean:
	rm -rf $(BUILD_DIR)


# Inner workings of the Makefile

# Build the final image
$(BUILD_DIR)/GeckOS_%.img: GBL | $(BIN_DIR) $(OBJ_DIR)
	@echo "\n--- Image Creation for GeckOS_$*_$(ARCH_BITS).img ---\n"
# First create the base filesystem image
	@$(MAKE) $(basename $@)
# Then add stage1 bootloader
	@dd if=$(BIN_DIR)/stage1_$*_$(ARCH_BITS).bin of=$@ bs=512 seek=0 conv=notrunc
# Add stage2 bootloader
	@mcopy -i $@ $(BIN_DIR)/stage2.bin ::


# Build the stages of the bootloader
$(BIN_DIR)/stage1_$(FILE_SYSTEM).bin: | $(BIN_DIR)
	@echo "\n--- Building Stage 1 for $(FILE_SYSTEM) ---\n"
	@$(MAKE) -C $(SRC_DIR)/stage1 FILE_SYSTEM=$(FILE_SYSTEM)

$(BIN_DIR)/stage2.bin: | $(BIN_DIR)
	@echo "\n--- Building Stage 2 for $(FILE_SYSTEM) ---\n"
	@$(MAKE) -C $(SRC_DIR)/stage2 FILE_SYSTEM=$(FILE_SYSTEM)


# Create the base filesystem image
$(BUILD_DIR)/GeckOS_FAT12.img: | $(BIN_DIR)
	@echo "\nCreating a FAT 12 image -> $(TARGET_IMG) with 1.44MB\n"
	@dd if=/dev/zero of=$(TARGET_IMG) bs=512 count=2880
	@mkfs.fat $(TARGET_IMG) $(FS_FAT12_ARGS)

$(BUILD_DIR)/GeckOS_FAT16.img: | $(BIN_DIR)
	@echo "\nCreating a FAT 16 image -> $(TARGET_IMG) with 128MB\n"
	@dd if=/dev/zero of=$(TARGET_IMG) bs=512 count=273042
	@mkfs.fat $(TARGET_IMG) $(FS_FAT16_ARGS)

$(BUILD_DIR)/GeckOS_FAT32.img: | $(BIN_DIR)
	@echo "\nCreating a FAT 32 image -> $(TARGET_IMG) with 128MB\n"
	@dd if=/dev/zero of=$(TARGET_IMG) bs=512 count=273042
	@mkfs.fat $(TARGET_IMG) $(FS_FAT32_ARGS)
# Add copy of stage1 bootloader and File System Information Structure
	@dd if=$(BIN_DIR)/stage1_FAT32.bin of=$(TARGET_IMG) bs=512 seek=6 conv=notrunc


# Build the necessary directories
$(BIN_DIR) $(OBJ_DIR) $(DEBUG_DIR):
	mkdir -p $@
