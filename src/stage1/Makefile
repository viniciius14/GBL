include $(CONFIG_PATH)

ASM_FORMAT=-f bin

default: echo assemble


echo:
	@echo "\n--- Stage 1 Bootloader ---\n"


assemble:
	$(ASM) $(ASM_FORMAT) $(ASM_FLAGS) $(BOOT_INCLUDES) -D$(FS) -D$(BITS) -DKERNEL_NAME='"$(KERNEL_NAME)"' stage1.S -o $(BIN_DIR)/stage1_$(FS).bin


debug:
	$(ASM) $(ASM_FORMAT) $(ASM_FLAGS) $(BOOT_INCLUDES) -D$(FS) -D$(BITS) -DKERNEL_NAME='"$(KERNEL_NAME)"' stage1.S -E > $(DEBUG_DIR)/stage1_$(FS)_$(BITS).i

	$(ASM) $(ASM_FORMAT) $(ASM_FLAGS) $(BOOT_INCLUDES) -D$(FS) -D$(BITS) -DKERNEL_NAME='"$(KERNEL_NAME)"' stage1.S -l $(DEBUG_DIR)/stage1_$(FS)_$(BITS).lst -o $(BIN_DIR)/stage1_$(FS).bin


# ndisasm is better than objdump for binaries imo
	ndisasm -b 16 -o 0x7C00 \
	$(BIN_DIR)/stage1_$(FS).bin > $(DEBUG_DIR)/stage1.dump

.PHONY: default
