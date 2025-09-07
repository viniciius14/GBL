# Sources
ifeq ($(ARCH_BITS),BITS64)
    ARCH_DIRS+=$(STAGE2_DIR)/64bit
endif

# Use a foreach to filter out files in the 64bit directory for 32bit builds
ASM_SRCS :=$(foreach dir,$(ARCH_DIRS),$(shell find $(dir) -type f -name "*.S"))
C_SRCS   :=$(foreach dir,$(ARCH_DIRS),$(shell find $(dir) -type f -name "*.c"))

# ASM and C SRCS will now contain <dir>/filename.<S/c>, so remove the dir to not
# screw up the OBJS path (would be OBJ_DIR/<dir>/filename.o and we want OBJ_DIR/filename.o)
ASM_OBJS :=$(patsubst %.S,$(OBJ_DIR)/%.o,$(notdir $(ASM_SRCS)))
C_OBJS   :=$(patsubst %.c,$(OBJ_DIR)/%.o,$(notdir $(C_SRCS)))

# Includes
# Get the default includes and add the main dirs and any possible subdirs inside of them
STAGE2_INCLUDE_DIRS :=$(DEFAULT_INCLUDE_DIRS)
STAGE2_INCLUDE_DIRS +=$(STAGE2_DIR)/16bit $(wildcard $(STAGE2_DIR)/16bit/*/)
STAGE2_INCLUDE_DIRS +=$(STAGE2_DIR)/32bit $(wildcard $(STAGE2_DIR)/32bit/*/)

ifeq ($(ARCH_BITS),BITS64)
    STAGE2_INCLUDE_DIRS +=$(STAGE2_DIR)/64bit $(wildcard $(STAGE2_DIR)/64bit/*/)
endif

# Since this sub project takes .S and .C files we'll need 2 include flags for the -i/-I difference
# between NASM and GCC
STAGE2_INCLUDES_ASM :=$(foreach dir,$(STAGE2_INCLUDE_DIRS),-i $(dir))
STAGE2_INCLUDES_C   :=$(foreach dir,$(STAGE2_INCLUDE_DIRS),-I $(dir))

# Tools
ifeq ($(ARCH_BITS),BITS64)
    ASM_FORMAT =-f elf64
    CC_FORMAT  =-m64
    LD_FORMAT  =-m elf_x86_64
endif

# Helper
LINKER_SCRIPT := $(STAGE2_DIR)/stage2.ld
ALL_OBJS   	  := $(ASM_OBJS) $(C_OBJS)

.PHONY: stage2 debug

stage2: $(STAGE2_BIN)
	wc -c < $(STAGE2_BIN) >> $(STATS_FILE)

debug:
	# TODO


# Convert the ELF executable to a raw binary
$(STAGE2_BIN): $(STAGE2_ELF)
	$(OBJ_CPY) $(OBJ_CPY_FLAGS) $< $@

# Link all object files into the final ELF executable
$(STAGE2_ELF): $(ALL_OBJS)
	$(LD) $(LD_FLAGS) $(ALL_OBJS) -T $(LINKER_SCRIPT) -o $@

# Due to us removing the path from the .o files make will get confused unless we
# tell it to look in these directories for the files
vpath %.c $(STAGE2_INCLUDE_DIRS)
vpath %.S $(STAGE2_INCLUDE_DIRS)


$(C_OBJS) : $(OBJ_DIR)/%.o: %.c
	$(CC) $(CC_FLAGS) \
	$(DEFINES) \
	$(STAGE2_INCLUDES_C) \
	-c $< -o $@
	@echo ""


$(ASM_OBJS): $(OBJ_DIR)/%.o: %.S
	$(ASM) $(ASM_FLAGS) \
	$(DEFINES) \
	$(STAGE2_INCLUDES_ASM) \
	$< -o $@
	@echo ""
