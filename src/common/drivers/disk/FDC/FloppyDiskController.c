/* --------------- Includes ---------------- */

#include "FloppyDiskController.h"

/* ---------- Function Prototypes ---------- */

/* Wait for the RQM bit to be set in the Main Status register */
static void FloppyDiskController_waitForRQM (void);

static bool FloppyDiskController_specify (void);

static bool FloppyDiskController_configure (void);

static bool FloppyDiskController_recalibrate (void);

static bool FloppyDiskController_seek (const uint16_t lba);

/* Sends a byte to the FIFO register */
static bool FloppyDiskController_sendByte (const uint8_t byte);

/* Gets a byte from the FIFO register */
static bool FloppyDiskController_getByte (uint8_t *const byte);

/* Sends a READ DATA command to the FDC */
static bool FloppyDiskController_sendCmdReadData (uint8_t lba);

/* Status register checking functions */
static bool FloppyDiskController_checkSt0 (const FloppyDiskController_regStatus0 st0);
static bool FloppyDiskController_checkSt1 (const FloppyDiskController_regStatus1 st1);
static bool FloppyDiskController_checkSt2 (const FloppyDiskController_regStatus2 st2);
static bool FloppyDiskController_checkSt3 (const FloppyDiskController_regStatus3 st3);

/* ----------- Global Variables ------------ */



/* -------- Function Implementations ------- */

bool FloppyDiskController_init (void) {

    if (Io_inByte(FDC_ADDR_MAIN_STATUS) == 0xFF) {
        // Console_printString("No controller found.\n");
        return FALSE;
    }

    /* temp */
    FloppyDiskController_regStatus3 temp;
    (void)FloppyDiskController_checkSt3(temp);
    /* end of temp*/

    uint8_t result = 0;

    FloppyDiskController_reset();

    /* Set datarate to 500Kbps */
    Io_outByte(FDC_ADDR_DATA_RATE_SEL, 0x0);

    FloppyDiskController_waitForRQM();

    // FloppyDiskController_printRegs();

    /* 4 SENSE INTERRUPT STATUS commands need to be issued to clear the status flags for each drive.*/
    for (uint8_t i = 0 ; i < 4 ; i++) {
        FloppyDiskController_regStatus0 st0;
        uint8_t pcn = 0;

        FloppyDiskController_sendByte(FDC_CMD_SENSE_INTERRUPT);

        result = FloppyDiskController_getByte((uint8_t *)&st0);

        /* The top 2 bits are set after a reset procedure.
        Either bit being set at any other time is an error indication. */
        (void) FloppyDiskController_checkSt0(st0);

        result |= FloppyDiskController_getByte(&pcn);

        if (result) {
            return FALSE;
        }
    }

    if (FloppyDiskController_configure() || FloppyDiskController_specify()) {
        return FALSE;
    }

    // Console_printString("FDC INIT SUCCESS\n");
    return TRUE;
}

void FloppyDiskController_printRegs (void) {
    // Console_printString("Status A              = "); Console_printHex(Io_inByte(FDC_ADDR_STATUS_A));      Console_printChar('\n');
    // Console_printString("Status B              = "); Console_printHex(Io_inByte(FDC_ADDR_STATUS_B));      Console_printChar('\n');
    // Console_printString("Digital Out           = "); Console_printHex(Io_inByte(FDC_ADDR_DIGITAL_OUT));   Console_printChar('\n');
    // Console_printString("Tape Drive            = "); Console_printHex(Io_inByte(FDC_ADDR_TAPE_DRIVE));    Console_printChar('\n');
    // Console_printString("Main Status           = "); Console_printHex(Io_inByte(FDC_ADDR_MAIN_STATUS));   Console_printChar('\n');
    // Console_printString("Data Rate Sel         = "); Console_printHex(Io_inByte(FDC_ADDR_DATA_RATE_SEL)); Console_printChar('\n');
    // Console_printString("FIFO                  = "); Console_printHex(Io_inByte(FDC_ADDR_DATA_FIFO));     Console_printChar('\n');
    // Console_printString("Digital In            = "); Console_printHex(Io_inByte(FDC_ADDR_DIGITAL_IN));    Console_printChar('\n');
    // Console_printString("Configuration Control = "); Console_printHex(Io_inByte(FDC_ADDR_CONFIG_CTRL));   Console_printChar('\n');
}

bool FloppyDiskController_seek (uint16_t lba) {
    FloppyDiskController_regStatus0 st0;
    uint8_t pcn = 0, result = 0;

    /* Enable Motor and Drive */
    Io_outByte(FDC_ADDR_DIGITAL_OUT, 0x1C);

    /* Wait for the motor to get up to speed */
    for (volatile uint32_t i = 0 ; i < 25000000 ; i++) {
        Io_wait();
    }

    /* Translate the lba address to a chs address */
    uint8_t cyl = 0, head = 0, sector = 0;
    Memory_lbaToChs(lba, &cyl, &head, &sector);

    FloppyDiskController_sendByte(FDC_CMD_SEEK);

    /* (head number << 2) | (drive number) */
    FloppyDiskController_sendByte((head << 2) | (0));
    FloppyDiskController_sendByte(cyl);

    FloppyDiskController_waitForRQM();

    FloppyDiskController_sendByte(FDC_CMD_SENSE_INTERRUPT);

    result = FloppyDiskController_getByte((uint8_t *)&st0);

    result |= FloppyDiskController_checkSt0(st0);

    result |= FloppyDiskController_getByte(&pcn);

    if (result) {
        // Console_printString("Seek failure.\n");
        return FALSE;
    }

    return TRUE;
}

bool FloppyDiskController_recalibrate (void) {
    FloppyDiskController_regStatus0 st0;
    uint8_t pcn = 0, result = 0;

    /* Enable Motor and Drive */
    Io_outByte(FDC_ADDR_DIGITAL_OUT, 0x1C);

    /* Wait for the motor to get up to speed */
    for (uint32_t i = 0 ; i < 25000000 ; i++) {
        Io_wait();
    }

    FloppyDiskController_sendByte(FDC_CMD_RECALIBRATE);
    FloppyDiskController_sendByte(0);                   /* Drive number */

    FloppyDiskController_waitForRQM();

    FloppyDiskController_sendByte(FDC_CMD_SENSE_INTERRUPT);

    result = FloppyDiskController_getByte((uint8_t *)&st0);
    result |= FloppyDiskController_checkSt0(st0);
    result |= FloppyDiskController_getByte(&pcn);

    if (result) {
        // Console_printString("Seek failure.\n");
        return FALSE;
    }

    return TRUE;
}

/* TODO: Add further status checks */
bool FloppyDiskController_read (const uint16_t lba, uint8_t *buffer, uint16_t sectorCount) {
    (void)buffer;
    (void)sectorCount;

    for (uint8_t retries = 0 ; retries < 3 ; retries++) {
        // Console_printString("1\n");
        if (FloppyDiskController_seek(lba) == FALSE || FloppyDiskController_recalibrate() == FALSE) {
            continue;
        }

        /* Head settling time */
        for (uint16_t i = 0 ; i < (MAX_UINT16 - 1) ; i++) {
            Io_wait();
        }
        // Console_printString("2\n");
        if (FloppyDiskController_sendCmdReadData(lba)) {
            // Console_printString("send cmd failed");
            return FALSE;
        }

        // Console_printString("3\n");
        uint8_t local[512] = {0};

        for (int i = 0; i < 512; i++) {
            FloppyDiskController_waitForRQM();
            local[i] = Io_inByte(FDC_ADDR_DATA_FIFO);
            Console_printHex(local[i]);
        }


        // Console_printString("Successful end of FloppyDiskController_read.\n");

        return TRUE;
    }
    // Console_printString("\nFAILURE FDC READ\n");

    return FALSE;
}

bool FloppyDiskController_specify (void) {
    uint8_t result = 0;

    result = FloppyDiskController_sendByte(FDC_CMD_SPECIFY);
    /* (SRT_value << 4) | (HUT_value)  */
    // result |= FloppyDiskController_sendByte((8 << 4) | (0));   /* SRT = 8ms, HUT = Maximum */
    /* (HLT_value << 1) | (NDMA) */
    // result |= FloppyDiskController_sendByte((5 << 1) | (1));   /* HLT = 5ms, NDMA = No */

    result |= FloppyDiskController_sendByte(0xBB);
    result |= FloppyDiskController_sendByte(0x04);


    if (result) {
        return FALSE;
    }
    return TRUE;
}

bool FloppyDiskController_configure (void) {
    uint8_t result = 0;

    result = FloppyDiskController_sendByte(FDC_CMD_CONFIGURE);
    result |= FloppyDiskController_sendByte(0x0);
    /* (implied seek enable << 6) | (fifo disable << 5) | (polling disable << 4) | (threshold value) */
    result |= FloppyDiskController_sendByte((1 << 6) | (0 << 5) | (0 << 4) | (8));
    /* Set precompensation value to default */
    result |= FloppyDiskController_sendByte(0x0);

    if (result) {
        return FALSE;
    }

    return TRUE;
}

void FloppyDiskController_reset (void) {
    /* Disable the FDC */
    /* An I/O from an ISA bus can take as long as 500ns or even more time, so writing it twice will ensure enough time as passed */
    Io_outByte(FDC_ADDR_DIGITAL_OUT, 0x00);
    Io_outByte(FDC_ADDR_DIGITAL_OUT, 0x00);

    /* Wait */
    for(uint16_t i = 0 ; i < (MAX_UINT16 - 1) ; i++) {
        Io_wait();
    }

    /* Enable the FDC */
    Io_outByte(FDC_ADDR_DIGITAL_OUT, 0x0C);

    /* Wait */
    for(uint16_t i = 0 ; i < (MAX_UINT16 - 1) ; i++) {
        Io_wait();
    }
}

static void FloppyDiskController_waitForRQM (void) {
    /* Check for RQM bit */
    while (Io_inByte(FDC_ADDR_MAIN_STATUS) != (BIT(7))) {
        ; /* Polling loop, wait until the FDC is ready */
    }
}

bool FloppyDiskController_sendByte (uint8_t byte) {
    uint32_t timeout = 0;

    /* Check for DIO and RQM bits - 10 XXX XXX */
    while ((Io_inByte(FDC_ADDR_MAIN_STATUS) & (FDC_DIO_RQM_MASK)) != FDC_SEND_BYTE_VALUE) {
        timeout++;
        if (timeout >= 1000000) { /* TODO: Figure out a more reasonable number */
            // Console_printString("Timeout error in FloppyDiskController_sendByte.\n");
            return FALSE;
        }
    }
    Io_outByte(FDC_ADDR_DATA_FIFO, byte);

    return TRUE;
}

bool FloppyDiskController_getByte (uint8_t *const byte) {
    uint32_t timeout = 0;
    /* Check for DIO and RQM bits - 11 XXX XXX*/
    while ((Io_inByte(FDC_ADDR_MAIN_STATUS) & (FDC_DIO_RQM_MASK)) != FDC_GET_BYTE_VALUE) {
        timeout++;
        if (timeout >= 1000000) { /* TODO: Figure out a more reasonable number */
            // Console_printString("Timeout error in FloppyDiskController_getByte.\n");
            return FALSE;
        }
    }
    *byte = Io_inByte(FDC_ADDR_DATA_FIFO);

    return TRUE;
}

/* WIP */
// static bool FloppyDiskController_sendCommand (const FloppyDiskController_commands_e FloppyDiskController_cmd, uint32_t result, ...) {
//     if (FloppyDiskControllerSendByte(FloppyDiskControllerCmd) == FALSE) {
//         return FALSE;
//     }

//     switch (FloppyDiskControllerCmd) {
//     case FDC_CMD_READ_TRACK:
//     case FDC_CMD_SPECIFY:
//     case FDC_CMD_SENSE_DRIVE_STATUS:
//     case FDC_CMD_WRITE_DATA:
//     case FDC_CMD_READ_DATA:
//     case FDC_CMD_RECALIBRATE:
//     case FDC_CMD_SENSE_INTERRUPT:
//     case FDC_CMD_WRITE_DELETED_DATA:
//     case FDC_CMD_READ_ID:
//     case FDC_CMD_READ_DELETED_DATA:
//     case FDC_CMD_FORMAT_TRACK:
//     case FDC_CMD_DUMPREG:
//     case FDC_CMD_SEEK:
//     case FDC_CMD_VERSION:
//     case FDC_CMD_SCAN_EQUAL:
//     case FDC_CMD_PERPENDICULAR_MODE:
//     case FDC_CMD_CONFIGURE:
//     case FDC_CMD_LOCK:
//     case FDC_CMD_VERIFY:
//     case FDC_CMD_SCAN_LOW_OR_EQUAL:
//     case FDC_CMD_SCAN_HIGH_OR_EQUAL:
//         break;
//     default:
//         return FALSE;
//     }

//     return FALSE;
// }



// if (in command phase)
// send command
// if (command not valid)
//     - If it was invalid, the next time the RQM bit in
//     the MSR register is a ‘‘1’’ the DIO and CB bits will
//     also be ‘‘1’’, indicating the FIFO must be read
//     - A result byte of 80H will be read out of the FIFO, indi-
//     cating an invalid command was issued.
//     - After reading
//     the result byte from the FIFO the 82077AA will re-
//     turn to the command phase.



bool FloppyDiskController_sendCmdReadData (uint8_t lba) {
    FloppyDiskController_sendByte(FDC_CMD_READ_DATA);

    /* Check if the command was valid */
    {
        uint8_t status = 0;
        // Console_printString("2.1\n");

        if ((Io_inByte(FDC_ADDR_MAIN_STATUS) & FDC_DIO_CMDB_MASK) == FDC_DIO_CMDB_MASK) {
            FloppyDiskController_getByte(&status);
        }

        if (status == 0x80) {
            return FALSE;
        }
    }

    uint8_t result = 0, cylinder = 0, head = 0, sector = 0, sectorSize = FDC_SECTOR_SIZE_CODE;
    FloppyDiskController_regStatus0 st0; /* Status Register 0*/
    FloppyDiskController_regStatus1 st1; /* Status Register 1*/
    FloppyDiskController_regStatus2 st2; /* Status Register 2*/

    Memory_lbaToChs(lba, &cylinder, &head, &sector);

    result |= FloppyDiskController_sendByte(cylinder);
    result |= FloppyDiskController_sendByte(head);
    result |= FloppyDiskController_sendByte(sector);
    result |= FloppyDiskController_sendByte(sectorSize);
    result |= FloppyDiskController_sendByte(18);                      /* EOT */
    result |= FloppyDiskController_sendByte(0x1B);                    /* GPL */
    result |= FloppyDiskController_sendByte(0xFF);                    /* DTL */

    if (result) {
        return FALSE;
    }

    FloppyDiskController_waitForRQM();

    FloppyDiskController_getByte((uint8_t *)&st0);
    FloppyDiskController_getByte((uint8_t *)&st1);
    FloppyDiskController_getByte((uint8_t *)&st2);

    result |= FloppyDiskController_checkSt0(st0);
    result |= FloppyDiskController_checkSt1(st1);
    result |= FloppyDiskController_checkSt2(st2);

    FloppyDiskController_getByte(&cylinder);
    FloppyDiskController_getByte(&head);
    FloppyDiskController_getByte(&sector);
    FloppyDiskController_getByte(&sectorSize);

    // Console_printString("READ SUCESS\n");
    return TRUE;
}

bool FloppyDiskController_checkSt0 (const FloppyDiskController_regStatus0 st0) {
    bool result = TRUE;
    (void)st0;
    // k_print("Drive Select =    %d.\n", st0->ds);
    // k_print("Head Address =    %d.\n", st0->h);
    // k_print("Equipment Check = %d.\n", st0->ec);
    // k_print("Seek End =        %d.\n", st0->se);
    // k_print("Interrupt Code =  %d.\n", st0->ic);

    return result;
}

bool FloppyDiskController_checkSt1 (const FloppyDiskController_regStatus1 st1) {
    bool result = TRUE;
    (void)st1;
    // k_print("Missing Address Mark = %d.\n", st1->ma);
    // k_print("Not Writable =         %d.\n", st1->nw);
    // k_print("No Data =              %d.\n", st1->nd);
    // k_print("Overrun/Underrun =     %d.\n", st1->or);
    // k_print("Data Error =           %d.\n", st1->de);
    // k_print("End of Cylinder =      %d.\n", st1->en);

    return result;
}

bool FloppyDiskController_checkSt2 (const FloppyDiskController_regStatus2 st2) {
    bool result = TRUE;
    (void)st2;
    // k_print("Missing Data Address Mark = %d.\n", st2->md);
    // k_print("Bad Cylinder =              %d.\n", st2->bc);
    // k_print("Wrong Cylinder =            %d.\n", st2->wc);
    // k_print("Data Error in Data Field =  %d.\n", st2->dd);
    // k_print("Control Mark =              %d.\n", st2->cm);

    return result;
}

bool FloppyDiskController_checkSt3 (const FloppyDiskController_regStatus3 st3) {
    bool result = TRUE;
    (void)st3;
    // k_print("Drive Select =    %d.\n", st3->ds);
    // k_print("Head Address =    %d.\n", st3->hd);
    // k_print("Track 0 =         %d.\n", st3->t0);
    // k_print("Write Protected = %d.\n", st3->wp);

    return result;
}
