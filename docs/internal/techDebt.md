# Technical Debt
- Assuming 50 sector section will be enough/won't cause issues (stage2 fat implementations for FAT16 nd FAT32)
- Failure label jumping to BIOS_print instead of calling it (to call it we'd need to level the stack, so: mov sp, 0x7c00 and then we should be able to call stuff?)
- In the main makefile we're doing "	$(shell find $(OBJ_DIR32) -type f -name '*.o') \
	$(shell find $(OBJ_DIR64) -type f -name '*.o') \" instead of something cleaner because we're generating files into OBJDIR16 which we do not want to be compiled
