#include <screen.h>

extern uint8_t _VIDEO_FONT;
uint8_t* framebuffer;

uint32_t cx = 0;
uint32_t cy = 0;

#define PUT_PIXEL(x, y, color) \
			*((uint8_t*)framebuffer + 2 + y * _VESA_VIDEO_MODE_INFO.pitch + x * _VESA_VIDEO_MODE_INFO.bpp / 8) = (color >> 16) & 0xFF; \
			*((uint8_t*)framebuffer + 1 + y * _VESA_VIDEO_MODE_INFO.pitch + x * _VESA_VIDEO_MODE_INFO.bpp / 8) = (color >> 8) & 0xFF; \ 
			*((uint8_t*)framebuffer + 0 + y * _VESA_VIDEO_MODE_INFO.pitch + x * _VESA_VIDEO_MODE_INFO.bpp / 8) = color & 0xFF; \

void screen_init() {
	framebuffer = (uint8_t*)_VESA_VIDEO_MODE_INFO.framebuffer;
}

void clrscr() {
	for (int i = 0; i < _VESA_VIDEO_MODE_INFO.height; i++)
		for (int j = 0; j < _VESA_VIDEO_MODE_INFO.width; j++) {
			PUT_PIXEL(j, i, (j*i) % 0xFF);
		}
}

void putc(char c) {
	switch (c) {
	case '\n':
		cy += FONT_HEIGHT;

	case '\r':
		cx = 0;

		return;

	case '\b':
		if (cx == 0) {
			cx = _VESA_VIDEO_MODE_INFO.width - FONT_WIDTH;
			cy -= FONT_HEIGHT;
			putc(' ');
			cx = _VESA_VIDEO_MODE_INFO.width - FONT_WIDTH;
			cy -= FONT_HEIGHT;
		} else {
			cx -= FONT_WIDTH;
			putc(' ');
			cx -= FONT_WIDTH;
		}

		return;
	}

	uint8_t* data = &_VIDEO_FONT + c * FONT_HEIGHT;

	for (int i = cy; i < cy + FONT_HEIGHT; i++)
		for (int j = cx; j < cx + FONT_WIDTH; j++) {
			PUT_PIXEL(j, i, (j*i % 0xFF));
		}

	int rx = 0;
	for (int i = 0; i < FONT_HEIGHT; i++) {
		for (int j = FONT_WIDTH - 1; j >= 0; j--) {
			if ((data[i] >> j) & 1) {
				PUT_PIXEL((rx + cx), (i + cy), 0xFFFFFF);
			}
			rx++;
		}

		rx = 0;
	}

	cx += FONT_WIDTH;
}

const char* numbers = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";

void putn(uint32_t num, uint32_t base) {
	if (num / base != 0)
		putn(num / base, base);

	putc((*(numbers + (num % base))));
}

void puts(char* s) {
	while (*s)
		putc(*s++);
}

void printf(char* form, ...) {
	va_list args;
	va_start(args, form);

	uint8_t found_arg = 0;

	while (*form) {
		if (*form == '%') {
			form++;

			switch (*form) {
			case 'd':
				putn(va_arg(args, uint32_t), 10);
				found_arg = 1;
				break;

			case 'X':
				putn(va_arg(args, uint32_t), 16);
				found_arg = 1;
				break;

			case 's':
				puts(va_arg(args, char*));
				found_arg = 1;
				break;

			case 'c':
				putc(va_arg(args, int));
				found_arg = 1;
				break;
			}
		}

		if (!found_arg)
			putc(*form);

		found_arg = 0;
		form++;
	}
}