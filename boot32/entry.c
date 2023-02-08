#include <global.h>
#include <screen.h>
#include <paging.h>

void protected_mode_entry() {
	screen_init();
	clrscr();

	printf("+-----------------------+\n");
	printf("| N1.2 Operating System |\n");
	printf("+-----------------------+\n");
	printf("Resolution: %dx%d%x%d\n", _VESA_VIDEO_MODE_INFO.width, _VESA_VIDEO_MODE_INFO.height, _VESA_VIDEO_MODE_INFO.bpp);
	printf("Framebuffer located at 0x%X\n", _VESA_VIDEO_MODE_INFO.framebuffer);

	create_pml4();
}