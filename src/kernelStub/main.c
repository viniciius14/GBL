#define SCREEN_WIDTH    320
#define SCREEN_HEIGHT   200
#define SCREEN_SIZE     (SCREEN_WIDTH * SCREEN_HEIGHT)
#define VC_PINK         0xE3

void main (void)
{
    unsigned char *const video_memory = (unsigned char *)0xA0000;
    int idx = 0;
    for (; idx < SCREEN_SIZE ; idx++) {
        video_memory[idx] = VC_PINK;
    }
}