#include <stdint.h>

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
// extern uint8_t NUMBERS;
/*
	Plan:

	Create a PMM
		- Interpret recieved memory map entries
		- Clean up given memory map entries
			- Overlapping entries are mapped into one if of the same type
			- Memory entries are organized in descending order based on base address
		- Notation of entry types
		- Notations of memory regions
		- Make a malloc
			- Find next free address
		- Make a free
			- Find the entry which a pointer is at
			- Mark it as free
	
	Create a VMM
		- Create page tables
			- Swap the old CR3 for the new page tables
		- Load new PML4 structure into memory
		- Make a malloc
			- Figure out steps to making a virtual malloc
		- Make a free
			- Figure out steps to making a virtual free

	kmain:
		Using afore mentioned functions:
			- Map the framebuffer so text can be displayed
			- Copy all relevant information from the bootloader into the kernel
			- Free up the space used by the bootloader
			- Relocate the kernel to the higher half of virtual memory
			- Port boot32 screen functions to kernel
			
		Do the following after above is done:
			- clrscr();
			- printf("+-----------------------+");
			- printf("| N1.2 Operating System |");
			- printf("+-----------------------+");
			- printf("Entered 64 bit long mode");
*/

// void outb(uint16_t address, uint8_t value) {
// 	asm volatile("outb %0, %1" : : "a"(value), "Nd"(address));
// }

// void print_num(uint32_t num, uint32_t base) {
// 	if (num / base != 0)
// 		print_num(num / base, base);

// 	outb(0xE9, (*(NUMBERS + (num % base))));
// }

void kmain() {
	// *(uint8_t*)_VESA_VIDEO_MODE_INFO.framebuffer = 0x0;

	// *(uint8_t*)0xFB000010 = 0x00;

	// print_num(_VESA_VIDEO_MODE_INFO.framebuffer, 16);
	// outb(0xE9, '\n');
	// outb(0xE9, *((uint8_t*)&NUMBERS + 1));
	// outb(0xE9, '\n');

	// struct VESA_INFO info = *(&_VESA_VIDEO_MODE_INFO);

	// for (int i = 0; i < info.height; i++)
	// 	for (int j = 0; j < info.width; j++) {
	// 		*((uint8_t*)info.framebuffer + 2 + i * info.pitch + j * info.bpp / 8) = 0xFF;
	// 		*((uint8_t*)info.framebuffer + 1 + i * info.pitch + j * info.bpp / 8) = 0x00;
	// 		*((uint8_t*)info.framebuffer + 0 + i * info.pitch + j * info.bpp / 8) = 0x00;
	// 	}

	for (;;);
}