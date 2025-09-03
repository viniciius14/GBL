ASM_SRCS := $(wildcard *.S)
C_SRCS   := $(wildcard *.c)

ASM_OBJS := $(patsubst %.S,$(OBJ_DIR)/%.o,$(ASM_SRCS))
C_OBJS   := $(patsubst %.c,$(OBJ_DIR)/%.o,$(C_SRCS))


.PHONY: build debug clean

build: $(ASM_OBJS) $(C_OBJS)


debug:
	$(foreach c_src,$(C_SRCS),\
		@$(CC) $(CC_FORMAT) $(CC_FLAGS) -save-temps -D$(FILE_SYSTEM) -D$(ARCH_BITS) -DKERNEL_NAME='"$(KERNEL_NAME)"' $(GBL_INCLUDES) \
		-c $(c_src) -o $(patsubst %.c,$(OBJ_DIR)/$(ARCH_BITS)_%.o,$(c_src));\
		mv $(patsubst %.c,%.i,$(c_src)) $(DEBUG_DIR)/$(ARCH_BITS)_$(notdir $(patsubst %.c,%.i,$(c_src)));\
		mv $(patsubst %.c,%.s,$(c_src)) $(DEBUG_DIR)/$(ARCH_BITS)_$(notdir $(patsubst %.c,%.s,$(c_src)));\
	)
# Generate listing files (.lst) for Assembly sources.
	$(foreach asm_src,$(ASM_SRCS),\
		@$(ASM) $(ASM_FORMAT) $(ASM_FLAGS) -D$(FILE_SYSTEM) -D$(ARCH_BITS) -DKERNEL_NAME='"$(KERNEL_NAME)"' $(GBL_INCLUDES) \
		$(asm_src) -l $(DEBUG_DIR)/$(ARCH_BITS)_$(notdir $(patsubst %.S,%.lst,$(asm_src))) -o $(patsubst %.S,$(OBJ_DIR)/$(ARCH_BITS)_%.o,$(asm_src));\
	)



# Build Rules

$(OBJ_DIR)/%.o: %.c
	$(CC) $(CC_FORMAT) $(CC_FLAGS) $(if $(filter debug,$(MAKECMDGOALS)),-save-temps,) \
	-D$(FILE_SYSTEM) -D$(ARCH_BITS) -DKERNEL_NAME='"$(KERNEL_NAME)"' \
	$(patsubst -i%,-I%, $(GBL_INCLUDES)) \
	-c $< -o $@

$(OBJ_DIR)/%.o: %.S
	$(ASM) $(ASM_FORMAT) $(ASM_FLAGS) \
	-D$(FILE_SYSTEM) -D$(ARCH_BITS) -DKERNEL_NAME='"$(KERNEL_NAME)"' \
	$(GBL_INCLUDES) \
	$< -o $@
