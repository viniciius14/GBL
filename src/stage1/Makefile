include $(CONFIG_PATH)

ASM_FORMAT=-f bin

default: echo assemble


echo:
	@echo "\n--- Stage 1 Bootloader --- \n"


assemble:
	$(ASM) $(ASM_FORMAT) $(ASM_FLAGS) $(BOOT_INCLUDES) -D$(FS) -D$(BITS) -DKERNEL_NAME="$(KERNEL_NAME)" stage1.S -o $(BIN_DIR)/stage1_$(FS).bin


debug:
	$(ASM) $(ASM_FORMAT) $(ASM_FLAGS) $(BOOT_INCLUDES) stage1.S -E > $(DEBUG_DIR)/stage1_$(FS)_$(BITS).i
	$(ASM) $(ASM_FORMAT) $(ASM_FLAGS) $(BOOT_INCLUDES) stage1.S -l $(DEBUG_DIR)/stage1_$(FS)_$(BITS).lst

.PHONY: default
