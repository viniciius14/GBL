#ifndef __FDC_H
#define __FDC_H

#include "utils.h"
#include "memory.h"
#include "io.h"
#include "console.h"

/* ---------------- Defines ---------------- */

#define FDC_BASE_ADDR           (0x03F0)
#define FDC_DMA_CHANNEL         (2)
#define FDC_IRQ                 (6)

#define FDC_DIO_RQM_MASK        (BIT(7) | BIT(6))
/* DIO and CMD BIT */
#define FDC_DIO_CMDB_MASK       (BIT(6) | BIT(4))

#define FDC_GET_BYTE_VALUE      (BIT(7) | BIT(6))
#define FDC_SEND_BYTE_VALUE     (BIT(7))

/* Sector size of 512 bytes (128 * X^2) */
#define FDC_SECTOR_SIZE_CODE    (2)

/* ----------------- Types ----------------- */

typedef const enum {
    FDC_ADDR_STATUS_A           = 0x03F0, /* SRA  - R   */
    FDC_ADDR_STATUS_B           = 0x03F1, /* SRB  - R   */
    FDC_ADDR_DIGITAL_OUT        = 0x03F2, /* DOR  - R/W */
    FDC_ADDR_TAPE_DRIVE         = 0x03F3, /* TDR  - R/W */
    FDC_ADDR_MAIN_STATUS        = 0x03F4, /* MSR  - R   */
    FDC_ADDR_DATA_RATE_SEL      = 0x03F4, /* DSR  - W   */
    FDC_ADDR_DATA_FIFO          = 0x03F5, /* FIFO - R/W */
    FDC_ADDR_DIGITAL_IN         = 0x03F7, /* DIR  - R   */
    FDC_ADDR_CONFIG_CTRL        = 0x03F7  /* CCR  - W   */
} FdcRegAddr;

typedef const enum {
    FDC_CMD_READ_TRACK          = 2,
    FDC_CMD_SPECIFY             = 3,
    FDC_CMD_SENSE_DRIVE_STATUS  = 4,
    FDC_CMD_WRITE_DATA          = 5,
    FDC_CMD_READ_DATA           = 6,
    FDC_CMD_RECALIBRATE         = 7,
    FDC_CMD_SENSE_INTERRUPT     = 8,
    FDC_CMD_WRITE_DELETED_DATA  = 9,
    FDC_CMD_READ_ID             = 10,
    FDC_CMD_READ_DELETED_DATA   = 12,
    FDC_CMD_FORMAT_TRACK        = 13,
    FDC_CMD_DUMPREG             = 14,
    FDC_CMD_SEEK                = 15,
    FDC_CMD_VERSION             = 16,
    FDC_CMD_SCAN_EQUAL          = 17,
    FDC_CMD_PERPENDICULAR_MODE  = 18,
    FDC_CMD_CONFIGURE           = 19,
    FDC_CMD_LOCK                = 20,
    FDC_CMD_VERIFY              = 22,
    FDC_CMD_SCAN_LOW_OR_EQUAL   = 25,
    FDC_CMD_SCAN_HIGH_OR_EQUAL  = 29
} FdcCommands;


typedef const volatile struct  {
    uint8_t dir                 : 1;
    uint8_t wp                  : 1;
    uint8_t indx                : 1;
    uint8_t hdsel               : 1;
    uint8_t trk0                : 1;
    uint8_t step                : 1;
    uint8_t drv2                : 1;
    uint8_t int_pending         : 1; /* State of the 82077AA INTERRUPT pin */
} PACKED FdcRegStatusA;
STATIC_ASSERT(sizeof(FdcRegStatusA) == sizeof(uint8_t));

typedef const volatile struct {
    uint8_t mot_en0             : 1; /* Motor bit */
    uint8_t mot_en1             : 1; /* Motor bit */
    uint8_t we                  : 1;
    uint8_t rddata_toggle       : 1; /* Read data toggle */
    uint8_t wrdata_toggle       : 1; /* Write data toggle */
    uint8_t driver_sel          : 1; /* Driver select */
    uint8_t reserved            : 2;
} PACKED FdcRegStatusB;
STATIC_ASSERT(sizeof(FdcRegStatusB) == sizeof(uint8_t));

/* Standard programming practice is to set both MOT ENx and DRIVE SELx bits at the same time. */
typedef volatile struct {
    uint8_t drive_sel0          : 1;
    uint8_t drive_sel1          : 1;
    uint8_t reset               : 1;
    uint8_t dma_gate            : 1;
    uint8_t mot_en0             : 1;
    uint8_t mot_en1             : 1;
    uint8_t mot_en2             : 1;
    uint8_t mot_en3             : 1;
} PACKED FdcRegDigOut;
STATIC_ASSERT(sizeof(FdcRegDigOut) == sizeof(uint8_t));

typedef volatile struct {
    uint8_t tape_sel0           : 1;
    uint8_t tape_sel1           : 1;
    uint8_t reserved            : 6;
} PACKED FdcRegTapeDrv;
STATIC_ASSERT(sizeof(FdcRegTapeDrv) == sizeof(uint8_t));

typedef const volatile struct {
    uint8_t drv0_busy           : 1;
    uint8_t drv1_busy           : 1;
    uint8_t drv2_busy           : 1;
    uint8_t drv3_busy           : 1;
    uint8_t cmd_bsy             : 1;
    uint8_t non_dma             : 1;
    uint8_t dio                 : 1;
    uint8_t rqm                 : 1;
} PACKED FdcRegMainStatus;
STATIC_ASSERT(sizeof(FdcRegMainStatus) == sizeof(uint8_t));

typedef volatile struct {
    uint8_t drate_sel0          : 1;
    uint8_t drate_sel1          : 1;
    uint8_t precomp0            : 1;
    uint8_t precomp1            : 1;
    uint8_t precomp2            : 1;
    uint8_t reserved            : 1;
    uint8_t power_down          : 1;
    uint8_t sw_reset            : 1;
} PACKED FdcRegDataRateSel;
STATIC_ASSERT(sizeof(FdcRegDataRateSel) == sizeof(uint8_t));

typedef const volatile struct {
    uint8_t reserved            : 7;
    uint8_t dsk_chg             : 1;
} PACKED FdcRegDigInp;
STATIC_ASSERT(sizeof(FdcRegDigInp) == sizeof(uint8_t));

typedef volatile struct {
    uint8_t drate_sel0          : 1;
    uint8_t drate_sel1          : 1;
    uint8_t reserved            : 6;
} PACKED FdcRegConfigCtrl;
STATIC_ASSERT(sizeof(FdcRegConfigCtrl) == sizeof(uint8_t));

typedef const volatile struct {
    uint8_t ds                  : 2; /* The current selected drive */
    uint8_t h                   : 1; /* The current head address */
    uint8_t reserved            : 1;
    uint8_t ec                  : 1; /* Equipment check */
    uint8_t se                  : 1; /* Seek end */
    uint8_t ic                  : 2; /* Interrupt code */
} PACKED FdcRegStatus0;
STATIC_ASSERT(sizeof(FdcRegStatus0) == sizeof(uint8_t));

typedef const volatile struct {
    uint8_t ma                  : 1; /* Missing Address mark */
    uint8_t nw                  : 1; /* Not Writable */
    uint8_t nd                  : 1; /* No Data */
    uint8_t reserved            : 1;
    uint8_t or                  : 1; /* Overrun / Underrun */
    uint8_t de                  : 1; /* Data Error */
    uint8_t reserved1           : 1;
    uint8_t en                  : 1; /* End of Cylinder */
} PACKED FdcRegStatus1;
STATIC_ASSERT(sizeof(FdcRegStatus1) == sizeof(uint8_t));

typedef const volatile struct {
    uint8_t md                  : 1; /* Missing Data Address Mark */
    uint8_t bc                  : 1; /* Bad Cylinder */
    uint8_t reserved            : 2;
    uint8_t wc                  : 1; /* Wrong Cylinder */
    uint8_t dd                  : 1; /* Data Error in Data Field */
    uint8_t cm                  : 1; /* Control Mark */
    uint8_t reserved1           : 1;
} PACKED FdcRegStatus2;
STATIC_ASSERT(sizeof(FdcRegStatus2) == sizeof(uint8_t));

typedef const volatile struct {
    uint8_t ds                  : 2; /* Drive Select */
    uint8_t hd                  : 1; /* Head Address */
    uint8_t reserved            : 1;
    uint8_t t0                  : 1; /* Track 0 */
    uint8_t reserved1           : 1;
    uint8_t wp                  : 1; /* Write Protected */
    uint8_t reserved2           : 1;
} PACKED FdcRegStatus3;
STATIC_ASSERT(sizeof(FdcRegStatus3) == sizeof(uint8_t));

/* ---------- Function prototypes ---------- */

/* Initialize floppy disk controller */
bool fdc_init(void);
/* Read data from the LBA address into the buffer */
bool fdc_read(const uint16_t lba, uint8_t *buffer);
/* Write data from the buffer into the LBA address */
bool fdc_read(const uint16_t lba, uint8_t *buffer);
/* Reset floppy disk controller */
void fdc_reset(void);
/* Sends a READ DATA command to the FDC */
bool fdc_sendCmdReadData(uint8_t lba);

#endif /* __FDC_H */