#include <global.h>
#include <screen.h>

void protected_mode_entry() {
	screen_init();
	clrscr();

	printf("+-----------------------+\n");
	printf("| N1.2 Operating System |\n");
	printf("+-----------------------+\n");
	printf("Resolution: %dx%d%x%d", _VESA_VIDEO_MODE_INFO.width, _VESA_VIDEO_MODE_INFO.height, _VESA_VIDEO_MODE_INFO.bpp);
}