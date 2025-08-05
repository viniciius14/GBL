include $(CONFIG_FILE)

ARCH_DIR := $(STAGE2_DIR)/$(ARCH_BITS)

C_SRCS   := $(wildcard *.c)
ASM_SRCS := $(wildcard *.S)

C_OBJS   := $(patsubst %.c,$(OBJ_DIR)/$(ARCH_BITS)_%.o,$(C_SRCS))
ASM_OBJS := $(patsubst %.S,$(OBJ_DIR)/$(ARCH_BITS)_%.o,$(ASM_SRCS))


.PHONY: build debug clean

build: $(C_OBJS) $(ASM_OBJS)

debug: | $(DEBUG_DIR)
	$(foreach c_src,$(C_SRCS),\
		$(CC) $(CC_FLAGS) -save-temps \
		-D$(FILE_SYSTEM) -D$(ARCH_BITS) -DKERNEL_NAME='"$(KERNEL_NAME)"' \
		$(GBL_INCLUDES) \
		-c $(c_src) -o $(patsubst %.c,$(OBJ_DIR)/$(ARCH_BITS)_%.o,$(c_src));\
		mv $(patsubst %.c,%.i,$(c_src)) $(DEBUG_DIR)/$(ARCH_BITS)_$(notdir $(patsubst %.c,%.i,$(c_src)));\
		mv $(patsubst %.c,%.s,$(c_src)) $(DEBUG_DIR)/$(ARCH_BITS)_$(notdir $(patsubst %.c,%.s,$(c_src)));\
	)
# Generate listing files (.lst) for Assembly sources.
	$(foreach asm_src,$(ASM_SRCS),\
		$(ASM) $(ASM_FORMAT) $(ASM_FLAGS) \
		-D$(FILE_SYSTEM) -D$(ARCH_BITS) -DKERNEL_NAME='"$(KERNEL_NAME)"' \
		$(GBL_INCLUDES) \
		$(asm_src) -l $(DEBUG_DIR)/$(ARCH_BITS)_$(notdir $(patsubst %.S,%.lst,$(asm_src))) -o $(patsubst %.S,$(OBJ_DIR)/$(ARCH_BITS)_%.o,$(asm_src));\
	)



# Build Rules

$(OBJ_DIR)/$(ARCH_BITS)_%.o: %.c | $(OBJ_DIR)
	$(CC) $(CC_FLAGS) $(if $(filter debug,$(MAKECMDGOALS)),-save-temps,) \
	-D$(FILE_SYSTEM) -D$(ARCH_BITS) -DKERNEL_NAME='"$(KERNEL_NAME)"' \
	$(GBL_INCLUDES) \
	-c $< -o $@

$(OBJ_DIR)/$(ARCH_BITS)_%.o: %.S | $(OBJ_DIR)
	$(ASM) $(ASM_FORMAT) $(ASM_FLAGS) \
	-D$(FILE_SYSTEM) -D$(ARCH_BITS) -DKERNEL_NAME='"$(KERNEL_NAME)"' \
	$(GBL_INCLUDES) \
	$< -o $@
