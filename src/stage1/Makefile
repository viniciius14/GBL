include $(CONFIG_PATH)

ASM_FORMAT=-f bin

default: echo assemble


echo:
	@echo "\n --- Stage 1 Bootloader --- \n"


assemble:
	$(ASM) $(ASM_FORMAT) $(ASM_FLAGS) $(BOOT_INCLUDES) stage1.S -o $(BIN_DIR)/stage1_$(FS).bin


.PHONY: default
