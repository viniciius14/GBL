include $(CONFIG_PATH)

SRCS := $(wildcard *.S)
OBJS := $(patsubst %.S, $(OBJ_DIR)/%.o, $(SRCS))


stage2: echo link extract


echo:
	@echo "\n--- Stage 2 Bootloader ---\n"


$(OBJ_DIR)/%.o: %.S
	$(ASM) $(ASM_FORMAT) $(ASM_FLAGS) $(BOOT_INCLUDES) -D$(FS) -D$(BITS) -DKERNEL_NAME="$(KERNEL_NAME)" $< -o $@


link: $(OBJS)
	$(LD) $(LD_FLAGS) -T $(SRC_DIR)/stage2.ld $(OBJS) -o $(OBJ_DIR)/stage2.elf


extract:
	$(OBJ_CPY) $(OBJ_FLAGS) $(OBJ_DIR)/stage2.elf $(BIN_DIR)/stage2.bin


debug: LD_FLAGS += -Map=$(DEBUG_DIR)/stage2.map
debug: link
	objdump -D --visualize-jumps --start-address=0x7E00 $(OBJ_DIR)/stage2.elf > $(DEBUG_DIR)/stage2_elf.dump
	ndisasm -b 16 -o 0x7E00 $(BIN_DIR)/stage2.bin > $(DEBUG_DIR)/stage2_bin.dump