include misc/config.mk

# Define the path to config.mk
export CONFIG_PATH := $(PROJECT)/misc/config.mk

# User inputs
export FS   ?= FAT12
export BITS ?= BITS32
export KERNEL_NAME ?= KERNEL  BIN

OUTPUT_DIR ?= $(BUILD_DIR)

# Input options
SUPPORTED_FILE_SYSTEMS := FAT12 FAT16 FAT32
SUPPORTED_TARGET_BITS  := BITS32 BITS64

# Current target
TARGET = $(OUTPUT_DIR)/GeckOS_$(FS)_$(BITS).img

# Include all directories while compiling each unit
BOOT_SUBDIRS = $(shell find $(SRC_DIR) -mindepth 1 -type d)
export BOOT_INCLUDES = $(foreach dir, $(BOOT_SUBDIRS),-i $(dir))


GBL: bootloader stats image


all:
	rm -f $(STATS)
	@for fs in $(SUPPORTED_FILE_SYSTEMS); do \
		for arch in $(SUPPORTED_TARGET_BITS); do \
			echo "\nBuilding GeckOS_$${fs}_$${arch}.img...\n"; \
			rm -rf $(BUILD_DIR)/*/; \
			$(MAKE) FS=$$fs BITS=$$arch GBL; \
		done \
	done


clean:
	rm -rf $(BUILD_DIR)
	clear


debug: GBL
	$(MAKE) -C $(SRC_DIR)/stage1 debug
	$(MAKE) -C $(SRC_DIR)/stage2 debug
	bash $(SCRIPTS_DIR)/QEMU.sh $(FS) $(BITS)


run: GBL
ifeq ($(FS), FAT12)
	$(EMULATOR) -drive file=$(TARGET),format=raw,index=0,if=floppy $(EMUL_FLAGS)
else
	$(EMULATOR) -drive file=$(TARGET),format=raw,index=0,if=ide $(EMUL_FLAGS)
endif

### "Backend" of the Makefile

dirs:
	mkdir -p $(BIN_DIR)
	mkdir -p $(OBJ_DIR)
	mkdir -p $(DEBUG_DIR)


bootloader: dirs
	@echo "\n--- GeckOS Bootloader ---\n"
	$(MAKE) -C $(SRC_DIR)/stage1
	$(MAKE) -C $(SRC_DIR)/stage2


stats:
	@echo "--- TARGET -> $(TARGET) ---" >> $(STATS)
	$(call bin_size_stat, $(BIN_DIR)/stage1_$(FS).bin)
	$(call bin_size_stat, $(BIN_DIR)/stage2.bin)
	@echo "\n" >> $(STATS)


image:
	@echo "\n--- Image Creation ---\n"
ifeq ($(FS), FAT12)
	$(MAKE)  FAT12
else ifeq ($(FS), FAT16)
	$(MAKE)  FAT16
else ifeq ($(FS), FAT32)
	$(MAKE)  FAT32
endif
# Add stage1 bootloader
	dd if=$(BIN_DIR)/stage1_$(FS).bin       of=$(TARGET)     bs=512 seek=0 conv=notrunc
# Add stage2 bootloader
	mcopy -i $(TARGET) $(BIN_DIR)/stage2.bin ::


FAT12:
	@echo "\nCreating a FAT 12 image -> $(TARGET) with 1.44MB\n"
	dd if=/dev/zero                         of=$(TARGET)     bs=512        count=2880
	mkfs.fat $(TARGET) -a -F 12 -S 512 -s 1 -r 224 -R 1


FAT16:
	@echo "\nCreating a FAT 16 image -> $(TARGET) with 128MB\n"
	dd if=/dev/zero                         of=$(TARGET)     bs=512        count=273042
	mkfs.fat $(TARGET) -a -F 16 -S 512 -s 8 -r 512 -R 4


FAT32:
	@echo "\nCreating a FAT 32 image -> $(TARGET) with 128MB\n"
	dd if=/dev/zero                         of=$(TARGET)     bs=512        count=273042
	mkfs.fat $(TARGET) -a -F 32 -S 512 -s 4 -R 32
# Add copy of stage1 bootloader and File System Information Structure
	dd if=$(BIN_DIR)/stage1_FAT32.bin      of=$(TARGET)     bs=512  seek=6 conv=notrunc


define bin_size_stat
	@wc -c $1 | awk '{ if ($$2 != "total") { n=split($$2,a,"/"); printf "%s - %s bytes\n", a[n], $$1 } }' >> $(STATS)
endef


.PHONY: GBL
