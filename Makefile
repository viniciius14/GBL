PROJECT := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))

include $(PROJECT)/misc/config.mk

# User inputs
FILE_SYSTEM ?= FAT12
ARCH_BITS   ?= BITS32
KERNEL_NAME ?= KERNEL  BIN

# User input options
SUPPORTED_FILE_SYSTEMS := FAT12 FAT16 FAT32
SUPPORTED_TARGET_BITS  := BITS32 BITS64

ALL_TARGET_IMAGES := $(foreach fs,$(SUPPORTED_FILE_SYSTEMS),$(foreach bits,$(SUPPORTED_TARGET_BITS),$(BUILD_DIR)/GeckOS_$(fs)_$(bits).img))
TARGET_IMG        := $(BUILD_DIR)/GeckOS_$(FILE_SYSTEM)_$(ARCH_BITS).img

# TODO: See if this can be compacted into a single line
GBL_DIRS	 = $(shell find $(SRC_DIR) -mindepth 1 -type d)
GBL_INCLUDES = $(foreach dir, $(GBL_DIRS),-i $(dir))

export PROJECT FILE_SYSTEM ARCH_BITS KERNEL_NAME CC_FLAGS ASM_FLAGS GBL_INCLUDES

.PHONY: all GBL debug clean run stats build

# User targets

# Builds the default GBL image
GBL: dirs $(TARGET_IMG)

# Builds all possible GBL Images
all: dirs $(ALL_TARGET_IMAGES)

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
	@$(MAKE) -C $(SRC_DIR)/stage1 debug ARCH_BITS=$(ARCH_BITS) FILE_SYSTEM=$(FILE_SYSTEM)
	@$(MAKE) -C $(SRC_DIR)/stage2 debug ARCH_BITS=$(ARCH_BITS) FILE_SYSTEM=$(FILE_SYSTEM)

# Generates a size report for the current bootloader binaries
stats: GBL
	@echo "--- Target: $(TARGET_IMG) ---" > $(STATS_FILE)
	$(call bin_size_stat, $(BIN_DIR)/stage1_$(FILE_SYSTEM)_$(ARCH_BITS).bin)
	$(call bin_size_stat, $(BIN_DIR)/stage2.bin)
	@echo "\n" >> $(STATS_FILE)
	@cat $(STATS_FILE)

clean:
	@rm -rf $(BUILD_DIR)

dirs:
	@mkdir -p $(OBJ_DIR)
	@mkdir -p $(BIN_DIR)
	@mkdir -p $(DEBUG_DIR)


# Inner workings of the Makefile

$(TARGET_IMG): $(BIN_DIR)/stage1_$(FILE_SYSTEM)_$(ARCH_BITS).bin $(BIN_DIR)/stage2.bin
	@echo "\n--- Image Creation for GeckOS_$(FILE_SYSTEM)_$(ARCH_BITS).img ---\n"
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
	@dd if=$(BIN_DIR)/stage1_$(FILE_SYSTEM)_$(ARCH_BITS).bin of=$(TARGET_IMG) bs=512 seek=6 conv=notrunc
endif
# Add stage1 bootloader
	@dd if=$(BIN_DIR)/stage1_$(FILE_SYSTEM)_$(ARCH_BITS).bin of=$@ bs=512 seek=0 conv=notrunc
# Add stage2 bootloader
	@mcopy -i $@ $(BIN_DIR)/stage2.bin ::


# Build the stages of the bootloader
$(BIN_DIR)/stage1_$(FILE_SYSTEM)_$(ARCH_BITS).bin:
	@echo "\n--- Building Stage 1 for $(FILE_SYSTEM) $(ARCH_BITS) ---\n"
	@$(MAKE) -C $(SRC_DIR)/stage1 FILE_SYSTEM=$(FILE_SYSTEM) ARCH_BITS=$(ARCH_BITS)

$(BIN_DIR)/stage2.bin:
	@echo "\n--- Building Stage 2 for $(FILE_SYSTEM) $(ARCH_BITS) ---\n"
	@$(MAKE) -C $(SRC_DIR)/stage2 FILE_SYSTEM=$(FILE_SYSTEM) ARCH_BITS=$(ARCH_BITS)


# Rule to handle building all images
$(BUILD_DIR)/GeckOS_%.img:
	$(MAKE) TARGET_IMG=$@ FILE_SYSTEM=$(patsubst GeckOS_%_%.img,%,$(notdir $@)) ARCH_BITS=$(patsubst GeckOS_%.img,%,$(basename $(notdir $@)))
