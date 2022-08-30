#include <stdint.h>

#define FONT_WIDTH 8
#define FONT_HEIGHT 16

struct VESA_INFO {
	uint16_t attributes;
	uint8_t window_a;	
	uint8_t window_b;	
	uint16_t granularity;
	uint16_t window_size;
	uint16_t segment_a;
	uint16_t segment_b;
	uint32_t win_func_ptr;		
	uint16_t pitch;			
	uint16_t width;			
	uint16_t height;			
	uint8_t w_char;			
	uint8_t y_char;			
	uint8_t planes;
	uint8_t bpp;			
	uint8_t banks;			
	uint8_t memory_model;
	uint8_t bank_size;		
	uint8_t image_pages;
	uint8_t reserved0;
 
	uint8_t red_mask;
	uint8_t red_position;
	uint8_t green_mask;
	uint8_t green_position;
	uint8_t blue_mask;
	uint8_t blue_position;
	uint8_t reserved_mask;
	uint8_t reserved_position;
	uint8_t direct_color_attributes;
 
	uint32_t framebuffer;		
	uint32_t off_screen_mem_off;
	uint16_t off_screen_mem_size;	
	uint8_t reserved1[206];
} __attribute__ ((packed));

extern struct VESA_INFO _VESA_VIDEO_MODE_INFO;
extern uint8_t _VIDEO_FONT;
uint32_t* framebuffer;

uint32_t cx = 0;
uint32_t cy = 0;

#define PUT_PIXEL(x, y, color) \
			*((uint8_t*)framebuffer + 2 + y * _VESA_VIDEO_MODE_INFO.pitch + x * _VESA_VIDEO_MODE_INFO.bpp / 8) = (color >> 16) & 0xFF; \
			*((uint8_t*)framebuffer + 1 + y * _VESA_VIDEO_MODE_INFO.pitch + x * _VESA_VIDEO_MODE_INFO.bpp / 8) = (color >> 8) & 0xFF; \ 
			*((uint8_t*)framebuffer + 0 + y * _VESA_VIDEO_MODE_INFO.pitch + x * _VESA_VIDEO_MODE_INFO.bpp / 8) = color & 0xFF; \

const char* numbers = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";

void print_num(int num, int base) {
	if (num / base != 0)
		print_num(num / base, base);

	asm volatile ( "outb %0, %1" : : "a"((*(numbers + (num % base)))), "Nd"(0xE9) );
}

void putc(char c) {
	uint8_t* data = &_VIDEO_FONT + c * FONT_HEIGHT;
	print_num(data, 16);

	for (int i = 0; i < FONT_HEIGHT; i++) {
		for (int j = 0; j < FONT_WIDTH; j++) {
			if ((data[i] >> j) & 1) {
				PUT_PIXEL((j + cx), (i + cy), 0xFFFFFF);
			}
		}
	}

	cx += FONT_WIDTH;
}

void protected_mode_entry() {
	framebuffer = (uint32_t*)_VESA_VIDEO_MODE_INFO.framebuffer;

	for (int i = 0; i < _VESA_VIDEO_MODE_INFO.height; i++)
		for (int j = 0; j < _VESA_VIDEO_MODE_INFO.width; j++) {
			PUT_PIXEL(j, i, 0xFF);
		}

	// for (char c = 'A'; c <= 'Z'; c++)
		// putc('A');
}