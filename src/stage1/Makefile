include $(CONFIG_PATH)

ASM_FORMAT=-f bin

default: echo assemble


echo:
	@echo "\n--- Stage 1 Bootloader ---\n"


assemble:
	$(ASM) stage1.S -o $(BIN_DIR)/stage1_$(FILE_SYSTEM).bin $(ASM_FORMAT) $(ASM_FLAGS) $(BOOT_INCLUDES) -D$(FILE_SYSTEM) -D$(ARCH_BITS) -DKERNEL_NAME='"$(KERNEL_NAME)"'


debug:
	$(ASM) $(ASM_FORMAT) $(ASM_FLAGS) $(BOOT_INCLUDES) -D$(FILE_SYSTEM) -D$(ARCH_BITS) -DKERNEL_NAME='"$(KERNEL_NAME)"' stage1.S -E > $(DEBUG_DIR)/stage1_$(FILE_SYSTEM)_$(ARCH_BITS).i

	$(ASM) $(ASM_FORMAT) $(ASM_FLAGS) $(BOOT_INCLUDES) -D$(FILE_SYSTEM) -D$(ARCH_BITS) -DKERNEL_NAME='"$(KERNEL_NAME)"' stage1.S -l $(DEBUG_DIR)/stage1_$(FILE_SYSTEM)_$(ARCH_BITS).lst -o $(BIN_DIR)/stage1_$(FILE_SYSTEM).bin


# ndisasm is better than objdump for binaries imo
	ndisasm -b 16 -o 0x7C00 \
	$(BIN_DIR)/stage1_$(FILE_SYSTEM).bin > $(DEBUG_DIR)/stage1.dump

.PHONY: default
