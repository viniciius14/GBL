include $(CONFIG_PATH)


ASM_SRCS := $(wildcard *.S)
ASM_OBJS := $(patsubst %.S, $(OBJ_DIR)/%.o, $(ASM_SRCS))


default: echo assemble


echo:
	@echo "\n--- Stage 2 - 16 Bit ---\n"


$(OBJ_DIR)/%.o: %.S
	$(ASM) $(ASM_FORMAT) $(ASM_FLAGS) $(BOOT_INCLUDES) -D$(FILE_SYSTEM) -D$(ARCH_BITS) -DKERNEL_NAME='"$(KERNEL_NAME)"' $< -o $@


assemble: $(ASM_OBJS)


# debug:
# TODO


.PHONY: default
