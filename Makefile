PROJECT := $(shell pwd)

include $(PROJECT)/misc/config.mk

# Define the path to config.mk
export CONFIG_PATH := $(MISC_DIR)/config.mk

# User inputs
export FILE_SYSTEM ?= FAT12
export ARCH_BITS        ?= BITS32
export KERNEL_NAME ?= KERNEL  BIN

# User Input Options
SUPPORTED_FILE_SYSTEMS := FAT12 FAT16 FAT32
SUPPORTED_TARGET_BITS  := BITS32 BITS64

# Current target
TARGET = $(BUILD_DIR)/GeckOS_$(FILE_SYSTEM)_$(ARCH_BITS).img

# Include all directories while compiling each unit
BOOT_SUBDIRS = $(shell find $(SRC_DIR) -mindepth 1 -type d)
export BOOT_INCLUDES = $(foreach dir, $(BOOT_SUBDIRS),-i $(dir))


GBL: bootloader stats image


all:
	rm -f $(STATS_FILE)
	@for fs in $(SUPPORTED_FILE_SYSTEMS); do \
		for arch in $(SUPPORTED_TARGET_BITS); do \
			echo "\nBuilding GeckOS_$${fs}_$${arch}.img...\n"; \
			rm -rf $(BUILD_DIR)/*/; \
			$(MAKE) FILE_SYSTEM=$$fs ARCH_BITS=$$arch GBL; \
		done \
	done


debug: clean GBL
	$(MAKE) -C stage1 debug
	$(MAKE) -C stage2 debug
	bash $(SCRIPTS_DIR)/QEMU_GDB.sh $(FILE_SYSTEM) $(ARCH_BITS)


clean:
	rm -rf $(BUILD_DIR)
	clear


run: GBL
ifeq ($(FILE_SYSTEM), FAT12)
	$(EMULATOR) -drive file=$(TARGET),format=raw,index=0,if=floppy $(EMUL_FLAGS)
else
	$(EMULATOR) -drive file=$(TARGET),format=raw,index=0,if=ide $(EMUL_FLAGS)
endif

# "Backend" of the Makefile

dirs:
	mkdir -p $(BIN_DIR)
	mkdir -p $(OBJ_DIR)
	mkdir -p $(DEBUG_DIR)


bootloader: dirs
	@echo "\n--- GeckOS Bootloader ---\n"
	$(MAKE) -C $(SRC_DIR)/stage1
	$(MAKE) -C $(SRC_DIR)/stage2


stats:
	@echo "--- TARGET -> $(TARGET) ---" >> $(STATS_FILE)
	$(call bin_size_stat, $(BIN_DIR)/stage1_$(FILE_SYSTEM).bin)
	$(call bin_size_stat, $(BIN_DIR)/stage2.bin)
	@echo "\n" >> $(STATS_FILE)


image:
	@echo "\n--- Image Creation ---\n"
ifeq ($(FILE_SYSTEM), FAT12)
	$(MAKE)  FAT12
else ifeq ($(FILE_SYSTEM), FAT16)
	$(MAKE)  FAT16
else ifeq ($(FILE_SYSTEM), FAT32)
	$(MAKE)  FAT32
endif
# Add stage1 bootloader
	dd if=$(BIN_DIR)/stage1_$(FILE_SYSTEM).bin       of=$(TARGET)     bs=512 seek=0 conv=notrunc
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
	dd if=$(BIN_DIR)/stage1_FAT32.bin      of=$(TARGET)      bs=512 seek=6 conv=notrunc


define bin_size_stat
	@wc -c $1 | awk '{ if ($$2 != "total") { n=split($$2,a,"/"); printf "%s - %s bytes\n", a[n], $$1 } }' >> $(STATS_FILE)
endef


.PHONY: GBL
