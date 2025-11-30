/* --------------- Includes ---------------- */

#include "fdc.h"

/* ---------- Function Prototypes ---------- */

/* Wait for the RQM bit to be set in the Main Status register */
static void fdcWaitForRQM(void);

static bool fdcSpecify(void);

static bool fdcConfigure(void);

static bool fdcRecalibrate(void);

static bool fdcSeek(const uint16_t lba);

/* Sends a byte to the FIFO register */
static bool fdcSendByte(const uint8_t byte);

/* Gets a byte from the FIFO register */
static bool fdcGetByte(uint8_t *const byte);

/* Status register checking functions */
static bool fdcCheckSt0(const FdcRegStatus0 st0);
static bool fdcCheckSt1(const FdcRegStatus1 st1);
static bool fdcCheckSt2(const FdcRegStatus2 st2);
static bool fdcCheckSt3(const FdcRegStatus3 st3);

/* ----------- Global Variables ------------ */



/* -------- Function Implementations ------- */

bool fdc_init(void) {
    // screen_clear();

    if (inByte(FDC_ADDR_MAIN_STATUS) == 0xFF) {
        // print_string("No controller found.\n");
        return FALSE;
    }

    /* temp */
    FdcRegStatus3 temp;
    (void)fdcCheckSt3(temp);
    /* end of temp*/

    uint8_t result = 0;

    fdc_reset();

    /* Set datarate to 500Kbps */
    outByte(FDC_ADDR_DATA_RATE_SEL, 0x0);

    fdcWaitForRQM();

    // fdcPrintRegs();

    /* 4 SENSE INTERRUPT STATUS commands need to be issued to clear the status flags for each drive.*/
    for (uint8_t i = 0 ; i < 4 ; i++) {
        FdcRegStatus0 st0;
        uint8_t pcn = 0;

        fdcSendByte(FDC_CMD_SENSE_INTERRUPT);

        result = fdcGetByte((uint8_t *)&st0);

        /* The top 2 bits are set after a reset procedure.
        Either bit being set at any other time is an error indication. */
        (void) fdcCheckSt0(st0);

        result |= fdcGetByte(&pcn);

        if (result) {
            return FALSE;
        }
    }

    if (fdcConfigure() || fdcSpecify()) {
        return FALSE;
    }

    // print_string("FDC INIT SUCCESS\n");
    return TRUE;
}

void fdcPrintRegs(void) {
    // print_string("Status A              = "); print_hex(inByte(FDC_ADDR_STATUS_A));      print_char('\n');
    // print_string("Status B              = "); print_hex(inByte(FDC_ADDR_STATUS_B));      print_char('\n');
    // print_string("Digital Out           = "); print_hex(inByte(FDC_ADDR_DIGITAL_OUT));   print_char('\n');
    // print_string("Tape Drive            = "); print_hex(inByte(FDC_ADDR_TAPE_DRIVE));    print_char('\n');
    // print_string("Main Status           = "); print_hex(inByte(FDC_ADDR_MAIN_STATUS));   print_char('\n');
    // print_string("Data Rate Sel         = "); print_hex(inByte(FDC_ADDR_DATA_RATE_SEL)); print_char('\n');
    // print_string("FIFO                  = "); print_hex(inByte(FDC_ADDR_DATA_FIFO));     print_char('\n');
    // print_string("Digital In            = "); print_hex(inByte(FDC_ADDR_DIGITAL_IN));    print_char('\n');
    // print_string("Configuration Control = "); print_hex(inByte(FDC_ADDR_CONFIG_CTRL));   print_char('\n');
}

bool fdcSeek (uint16_t lba) {
    FdcRegStatus0 st0;
    uint8_t pcn = 0, result = 0;

    /* Enable Motor and Drive */
    outByte(FDC_ADDR_DIGITAL_OUT, 0x1C);

    /* Wait for the motor to get up to speed */
    for (volatile uint32_t i = 0 ; i < 25000000 ; i++) {
        ioWait();
    }

    /* Translate the lba address to a chs address */
    uint8_t cyl = 0, head = 0, sector = 0;
    convertLbaChs(lba, &cyl, &head, &sector);

    fdcSendByte(FDC_CMD_SEEK);

    /* (head number << 2) | (drive number) */
    fdcSendByte((head << 2) | (0));
    fdcSendByte(cyl);

    fdcWaitForRQM();

    fdcSendByte(FDC_CMD_SENSE_INTERRUPT);

    result = fdcGetByte((uint8_t *)&st0);

    result |= fdcCheckSt0(st0);

    result |= fdcGetByte(&pcn);

    if (result) {
        // print_string("Seek failure.\n");
        return FALSE;
    }

    return TRUE;
}

bool fdcRecalibrate (void) {
    FdcRegStatus0 st0;
    uint8_t pcn = 0, result = 0;

    /* Enable Motor and Drive */
    outByte(FDC_ADDR_DIGITAL_OUT, 0x1C);

    /* Wait for the motor to get up to speed */
    for (uint32_t i = 0 ; i < 25000000 ; i++) {
        ioWait();
    }

    fdcSendByte(FDC_CMD_RECALIBRATE);
    fdcSendByte(0);                   /* Drive number */

    fdcWaitForRQM();

    fdcSendByte(FDC_CMD_SENSE_INTERRUPT);

    result = fdcGetByte((uint8_t *)&st0);
    result |= fdcCheckSt0(st0);
    result |= fdcGetByte(&pcn);

    if (result) {
        // print_string("Seek failure.\n");
        return FALSE;
    }

    return TRUE;
}

/* TODO: Add further status checks */
bool fdc_read(const uint16_t lba, uint8_t *buffer) {
    (void)buffer;

    for (uint8_t retries = 0 ; retries < 3 ; retries++) {
        // print_string("1\n");
        if (fdcSeek(lba) == FALSE || fdcRecalibrate() == FALSE) {
            continue;
        }

        /* Head settling time */
        for (uint16_t i = 0 ; i < (MAX_UINT16 - 1) ; i++) {
            ioWait();
        }
        // print_string("2\n");
        if (fdc_sendCmdReadData(lba)) {
            // print_string("send cmd failed");
            return FALSE;
        }

        // print_string("3\n");
        uint8_t local[512] = {0};

        for (int i = 0; i < 512; i++) {
            fdcWaitForRQM();
            local[i] = inByte(FDC_ADDR_DATA_FIFO);
            print_hex(local[i]);
        }


        // print_string("Successful end of fdc_read.\n");

        return TRUE;
    }
    // print_string("\nFAILURE FDC READ\n");

    return FALSE;
}

bool fdcSpecify(void) {
    uint8_t result = 0;

    result = fdcSendByte(FDC_CMD_SPECIFY);
    /* (SRT_value << 4) | (HUT_value)  */
    // result |= fdcSendByte((8 << 4) | (0));   /* SRT = 8ms, HUT = Maximum */
    /* (HLT_value << 1) | (NDMA) */
    // result |= fdcSendByte((5 << 1) | (1));   /* HLT = 5ms, NDMA = No */

    result |= fdcSendByte(0xBB);
    result |= fdcSendByte(0x04);


    if (result) {
        return FALSE;
    }
    return TRUE;
}

bool fdcConfigure(void) {
    uint8_t result = 0;

    result = fdcSendByte(FDC_CMD_CONFIGURE);
    result |= fdcSendByte(0x0);
    /* (implied seek enable << 6) | (fifo disable << 5) | (polling disable << 4) | (threshold value) */
    result |= fdcSendByte((1 << 6) | (0 << 5) | (0 << 4) | (8));
    /* Set precompensation value to default */
    result |= fdcSendByte(0x0);

    if (result) {
        return FALSE;
    }

    return TRUE;
}

void fdc_reset(void) {
    /* Disable the FDC */
    /* An I/O from an ISA bus can take as long as 500ns or even more time, so writing it twice will ensure enough time as passed */
    outByte(FDC_ADDR_DIGITAL_OUT, 0x00);
    outByte(FDC_ADDR_DIGITAL_OUT, 0x00);

    /* Wait */
    for(uint16_t i = 0 ; i < (MAX_UINT16 - 1) ; i++) {
        ioWait();
    }

    /* Enable the FDC */
    outByte(FDC_ADDR_DIGITAL_OUT, 0x0C);

    /* Wait */
    for(uint16_t i = 0 ; i < (MAX_UINT16 - 1) ; i++) {
        ioWait();
    }
}

static void fdcWaitForRQM(void) {
    /* Check for RQM bit */
    while (inByte(FDC_ADDR_MAIN_STATUS) != (BIT(7))) {
        ; /* Polling loop, wait until the FDC is ready */
    }
}

bool fdcSendByte(uint8_t byte) {
    uint32_t timeout = 0;

    /* Check for DIO and RQM bits - 10 XXX XXX */
    while ((inByte(FDC_ADDR_MAIN_STATUS) & (FDC_DIO_RQM_MASK)) != FDC_SEND_BYTE_VALUE) {
        timeout++;
        if (timeout >= 1000000) { /* TODO: Figure out a more reasonable number */
            // print_string("Timeout error in fdcSendByte.\n");
            return FALSE;
        }
    }
    outByte(FDC_ADDR_DATA_FIFO, byte);

    return TRUE;
}

bool fdcGetByte(uint8_t *const byte) {
    uint32_t timeout = 0;
    /* Check for DIO and RQM bits - 11 XXX XXX*/
    while ((inByte(FDC_ADDR_MAIN_STATUS) & (FDC_DIO_RQM_MASK)) != FDC_GET_BYTE_VALUE) {
        timeout++;
        if (timeout >= 1000000) { /* TODO: Figure out a more reasonable number */
            // print_string("Timeout error in fdcGetByte.\n");
            return FALSE;
        }
    }
    *byte = inByte(FDC_ADDR_DATA_FIFO);

    return TRUE;
}
/* WIP */
// static bool fdcSendCommand(const fdcCommands_e fdcCmd, uint32_t result, ...) {
//     if (fdcSendByte(fdcCmd) == FALSE) {
//         return FALSE;
//     }

//     switch (fdcCmd) {
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



bool fdc_sendCmdReadData(uint8_t lba) {
    fdcSendByte(FDC_CMD_READ_DATA);

    /* Check if the command was valid */
    {
        uint8_t status = 0;
        // print_string("2.1\n");

        if ((inByte(FDC_ADDR_MAIN_STATUS) & FDC_DIO_CMDB_MASK) == FDC_DIO_CMDB_MASK) {
            fdcGetByte(&status);
        }

        if (status == 0x80) {
            return FALSE;
        }
    }

    uint8_t result = 0, cylinder = 0, head = 0, sector = 0, sectorSize = FDC_SECTOR_SIZE_CODE;
    FdcRegStatus0 st0; /* Status Register 0*/
    FdcRegStatus1 st1; /* Status Register 1*/
    FdcRegStatus2 st2; /* Status Register 2*/

    convertLbaChs(lba, &cylinder, &head, &sector);
    // print_string("2.2\n");

    result |= fdcSendByte(cylinder);
    result |= fdcSendByte(head);
    result |= fdcSendByte(sector);
    result |= fdcSendByte(sectorSize);
    result |= fdcSendByte(18);                      /* EOT */
    result |= fdcSendByte(0x1B);                    /* GPL */
    result |= fdcSendByte(0xFF);                    /* DTL */

    if (result) {
        return FALSE;
    }
    // print_string("2.3.1\n");
    // // fdcPrintRegs();

    fdcWaitForRQM();
    // print_string("2.3.2\n");

    fdcGetByte((uint8_t *)&st0);
    fdcGetByte((uint8_t *)&st1);
    fdcGetByte((uint8_t *)&st2);

    result |= fdcCheckSt0(st0);
    result |= fdcCheckSt1(st1);
    result |= fdcCheckSt2(st2);

    fdcGetByte(&cylinder);
    fdcGetByte(&head);
    fdcGetByte(&sector);
    fdcGetByte(&sectorSize);

    // print_string("READ SUCESS\n");
    return TRUE;
}


bool fdcCheckSt0(const FdcRegStatus0 st0) {
    bool result = TRUE;
    (void)st0;
    // k_print("Drive Select =    %d.\n", st0->ds);
    // k_print("Head Address =    %d.\n", st0->h);
    // k_print("Equipment Check = %d.\n", st0->ec);
    // k_print("Seek End =        %d.\n", st0->se);
    // k_print("Interrupt Code =  %d.\n", st0->ic);

    return result;
}

bool fdcCheckSt1(const FdcRegStatus1 st1) {
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

bool fdcCheckSt2(const FdcRegStatus2 st2) {
    bool result = TRUE;
    (void)st2;
    // k_print("Missing Data Address Mark = %d.\n", st2->md);
    // k_print("Bad Cylinder =              %d.\n", st2->bc);
    // k_print("Wrong Cylinder =            %d.\n", st2->wc);
    // k_print("Data Error in Data Field =  %d.\n", st2->dd);
    // k_print("Control Mark =              %d.\n", st2->cm);

    return result;
}

bool fdcCheckSt3(const FdcRegStatus3 st3) {
    bool result = TRUE;
    (void)st3;
    // k_print("Drive Select =    %d.\n", st3->ds);
    // k_print("Head Address =    %d.\n", st3->hd);
    // k_print("Track 0 =         %d.\n", st3->t0);
    // k_print("Write Protected = %d.\n", st3->wp);

    return result;
}

