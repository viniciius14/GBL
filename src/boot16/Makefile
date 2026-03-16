ASM_SRC      :=start.S
ASM_FORMAT16 :=-f bin
INCLUDES     :=-I ../firmware/

# Since only 1 file, hardcode here
boot16:
	$(ASM) $(ASM_FLAGS) $(ASM_FORMAT16) \
	$(USER_INPUTS) $(INCLUDES) \
	$(ASM_SRC) -o $(BOOT16)
	@$(ASM) $(ASM_FLAGS) $(ASM_FORMAT16) \
	$(USER_INPUTS) $(INCLUDES) -E \
	$(ASM_SRC) > $(DEBUG_DIR16)/start_dbg.S
# # Create an elf compilation unit to be able to use GDB and debug stage1
# 	$(ASM) $(ASM_FLAGS) $(ASM_FORMAT_ELF) -g $(USER_INPUTS) $(INCLUDES) $(ASM_SRC) -o $(OBJ_DIR16)/start.o
# 	$(LD) -m elf_i386 -Ttext 0x7C00 $(OBJ_DIR16)/start.o -o $(OBJ_DIR16)/start.elf


# Stats
# TODO: call a script that output to STATS_FILE the actual number of bytes used
	@echo -n "Boot16 size in bytes: " >> $(STATS_FILE)
	@wc -c < $(BOOT16) >> $(STATS_FILE)
	@echo ""
	@echo """--- Boot16 Build Complete ---"
	@echo ""
