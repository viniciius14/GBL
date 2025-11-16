; File System Information Structure

%ifdef FAT32
    FSI_LeadSig:        dd 0x41615252       ; This lead signature is used to validate the beginning of the FSInfo structure in the sector.
    FSI_Reserved1:      times (480) db 0x0  ; Reserved. Must be set to 0.
    FSI_StrucSig:       dd 0x61417272       ; An additional signature validating the integrity of the FSInfo structure.
    FSI_Free_Count:     dd 0xFFFFFFFF       ; Contains the last known free cluster count on the volume.
    FSI_Nxt_Free:       dd 0xFFFFFFFF       ; Contains the cluster number of the first available (free) cluster on the volume.
    FSI_Reserved2:      dd 0x0, 0x0, 0x0    ; Reserved. Must be set to 0.
    FSI_TrailSig:       dd 0xAA550000       ; This trail signature is used to validate the integrity of the data in the sector containing the FSInfo structure.
%endif
