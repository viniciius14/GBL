include $(CONFIG_PATH)

# Relative to all the files inside this directory and subdirectories
SRCS := $(wildcard *.S *.c) $(filter-out 64bit/%.S, $(wildcard */*.S)) $(filter-out 64bit/%.c, $(wildcard */*.c))
ifeq ($(ARCH_BITS), BITS64)
SRCS += $(wildcard 64bit/*.S)
endif
OBJS := $(patsubst %.S, $(OBJ_DIR)/%.o, $(SRCS)) $(patsubst %.c, $(OBJ_DIR)/%.o, $(SRCS))

# Relative to the files only in this directory
ASM_SRCS := $(wildcard *.S)
ASM_OBJS := $(patsubst %.S, $(OBJ_DIR)/%.o, $(ASM_SRCS))

C_SRCS := $(wildcard *.c)
C_OBJS := $(patsubst %.c, $(OBJ_DIR)/%.o, $(C_SRCS))


stage2: echo dirs link extract


echo:
	@echo "\n--- Stage 2 Bootloader ---\n"


$(OBJ_DIR)/%.o: %.S
	$(ASM) $(ASM_FORMAT) $(ASM_FLAGS) $(BOOT_INCLUDES) -D$(FILE_SYSTEM) -D$(ARCH_BITS) -DKERNEL_NAME='"$(KERNEL_NAME)"' $< -o $@


$(OBJ_DIR)/%.o: %.c
	$(CC) $(CC_FLAGS) -c $< -o $@


dirs:
	$(MAKE) -C 16bit
	$(MAKE) -C 32bit
ifeq ($(ARCH_BITS), BIT64)
	$(MAKE) -C 64bit
endif

# TODO: $(ASM_OBJS) $(C_OBJS) are coming up empty
link:
	$(LD) $(LD_FLAGS) -T stage2.ld $(ASM_OBJS) $(C_OBJS) -o $(OBJ_DIR)/stage2.elf


extract:
	$(OBJ_CPY) $(OBJ_CPY_FLAGS) $(OBJ_DIR)/stage2.elf $(BIN_DIR)/stage2.bin


debug: LD_FLAGS += -Map=$(DEBUG_DIR)/stage2.map
debug: link
	objdump -D --visualize-jumps --start-address=0x7E00 $(OBJ_DIR)/stage2.elf > $(DEBUG_DIR)/stage2_elf.dump
	ndisasm -b 16 -o 0x7E00 $(BIN_DIR)/stage2.bin > $(DEBUG_DIR)/stage2_bin.dump
