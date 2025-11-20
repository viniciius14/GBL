ASM_SRC    :=start.S
ASM_FORMAT :=-f bin
INCLUDES   :=-I ../firmware/

# Since only 2 files hardcode here
boot16:
	$(ASM) $(ASM_FLAGS) $(ASM_FORMAT) $(INPUTS) $(INCLUDES) start.S -o $(BOOT16)
	$(ASM) $(ASM_FLAGS) $(ASM_FORMAT) $(INPUTS) $(INCLUDES) -E start.S > $(DEBUG_DIR)/start.S
# 	$(ASM) $(ASM_FLAGS) $(ASM_FORMAT) $(INPUTS) $(INCLUDES) GDT/setup32Mode.S -o $(BIN_DIR)/setup32Mode.bin
# 	$(ASM) $(ASM_FLAGS) $(ASM_FORMAT) $(INPUTS) $(INCLUDES) -E GDT/setup32Mode.S > $(DEBUG_DIR)/setup32Mode.S

	@echo -n "Boot16 size in bytes: " >> $(STATS_FILE)
	@wc -c < $(BOOT16) >> $(STATS_FILE)
	@echo ""
	@echo """--- Boot16 Build Complete ---"
	@echo ""
