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

void outb(uint16_t address, uint8_t value) {
	asm volatile("outb %0, %1" : : "a"(value), "Nd"(address));
}

// void print_num(uint32_t num, uint32_t base) {
// 	if (num / base != 0)
// 		print_num(num / base, base);

// 	outb(0xE9, (*(NUMBERS + (num % base))));
// }

struct idt_entry {
	uint16_t offset1;
	uint16_t selector;
	uint8_t ist : 2;
	uint8_t resvered1 : 6;
	uint8_t type;
	uint16_t offset2;
	uint32_t offset3;
	uint32_t resvered2;
} __attribute__((packed));

struct idt_header {
	uint16_t size;
	uint64_t address;
} __attribute__((packed));

struct idt_entry idt_entries[256];
struct idt_header _idtr;

extern void isr0();
extern void isr1();
extern void isr2();
extern void isr3();
extern void isr4();
extern void isr5();
extern void isr6();
extern void isr7();
extern void isr8();
extern void isr9();
extern void isr10();
extern void isr11();
extern void isr12();
extern void isr13();
extern void isr14();
extern void isr15();
extern void isr16();
extern void isr17();
extern void isr18();
extern void isr19();
extern void isr20();
extern void isr21();
extern void isr22();
extern void isr23();
extern void isr24();
extern void isr25();
extern void isr26();
extern void isr27();
extern void isr28();
extern void isr29();
extern void isr30();
extern void install_idt();

void isr_common_handler() {
	outb(0xE9, 'E');
	for (;;);
}

void set_idt_gate(int gate, uint64_t address, uint16_t selector, uint8_t type, uint8_t ist) {
	idt_entries[gate].offset1 = address & 0xFFFF;
	idt_entries[gate].offset2 = (address >> 16) & 0xFFFF;
	idt_entries[gate].offset3 = (address >> 32) & 0xFFFFFFFF;

	idt_entries[gate].type = type;
	idt_entries[gate].ist = ist;
	idt_entries[gate].selector = selector;
}

void init_idt() {
	set_idt_gate(0, (uint64_t)isr0, 0x18, 0x8E, 0);
	set_idt_gate(1, (uint64_t)isr1, 0x18, 0x8E, 0);
	set_idt_gate(2, (uint64_t)isr2, 0x18, 0x8E, 0);
	set_idt_gate(3, (uint64_t)isr3, 0x18, 0x8E, 0);
	set_idt_gate(4, (uint64_t)isr4, 0x18, 0x8E, 0);
	set_idt_gate(5, (uint64_t)isr5, 0x18, 0x8E, 0);
	set_idt_gate(6, (uint64_t)isr6, 0x18, 0x8E, 0);
	set_idt_gate(7, (uint64_t)isr7, 0x18, 0x8E, 0);
	set_idt_gate(8, (uint64_t)isr8, 0x18, 0x8E, 0);
	set_idt_gate(9, (uint64_t)isr9, 0x18, 0x8E, 0);
	set_idt_gate(10, (uint64_t)isr10, 0x18, 0x8E, 0);
	set_idt_gate(11, (uint64_t)isr11, 0x18, 0x8E, 0);
	set_idt_gate(12, (uint64_t)isr12, 0x18, 0x8E, 0);
	set_idt_gate(13, (uint64_t)isr13, 0x18, 0x8E, 0);
	set_idt_gate(14, (uint64_t)isr14, 0x18, 0x8E, 0);
	set_idt_gate(15, (uint64_t)isr15, 0x18, 0x8E, 0);
	set_idt_gate(16, (uint64_t)isr16, 0x18, 0x8E, 0);
	set_idt_gate(17, (uint64_t)isr17, 0x18, 0x8E, 0);
	set_idt_gate(18, (uint64_t)isr18, 0x18, 0x8E, 0);
	set_idt_gate(19, (uint64_t)isr19, 0x18, 0x8E, 0);
	set_idt_gate(20, (uint64_t)isr20, 0x18, 0x8E, 0);
	set_idt_gate(21, (uint64_t)isr21, 0x18, 0x8E, 0);
	set_idt_gate(22, (uint64_t)isr22, 0x18, 0x8E, 0);
	set_idt_gate(23, (uint64_t)isr23, 0x18, 0x8E, 0);
	set_idt_gate(24, (uint64_t)isr24, 0x18, 0x8E, 0);
	set_idt_gate(25, (uint64_t)isr25, 0x18, 0x8E, 0);
	set_idt_gate(26, (uint64_t)isr26, 0x18, 0x8E, 0);
	set_idt_gate(27, (uint64_t)isr27, 0x18, 0x8E, 0);
	set_idt_gate(28, (uint64_t)isr28, 0x18, 0x8E, 0);
	set_idt_gate(29, (uint64_t)isr29, 0x18, 0x8E, 0);
	set_idt_gate(30, (uint64_t)isr30, 0x18, 0x8E, 0);

	_idtr.size = (sizeof(idt_entries) * 16) - 1;
	_idtr.address = &idt_entries;

	outb(0x20, 0x10 | 0x01);
	outb(0x80, 0x0);
	outb(0xA0, 0x10 | 0x01);
	outb(0x80, 0x0);
	outb(0x21, 0x20);                
	outb(0x80, 0x0);
	outb(0xA1, 0x28);                
	outb(0x80, 0x0);
	outb(0x21, 4);                   
	outb(0x80, 0x0);
	outb(0xA1, 2);                   
	outb(0x80, 0x0);
 
	outb(0x21, 0x01);
	outb(0x80, 0x0);
	outb(0xA1, 0x01);
	outb(0x80, 0x0);

	outb(0x21, 0xFF);
	outb(0xA1, 0xFF);

	install_idt();
}

void kmain() {
	for (int i = 0; i < 720; i++)
		for (int j = 0; j < 1280; j++) {
			*(uint16_t*)(0xFD000000 + j + i * 1280) = 0x55;

			// *((uint8_t*)0xFD000000 + 2 + i * (1280 / 8) + j * 2) = 0xFF;
			// *((uint8_t*)0xFD000000 + 1 + i * (1280 / 8) + j * 2) = 0x00;
			// *((uint8_t*)0xFD000000 + 0 + i * (1280 / 8) + j * 2) = 0x00;
		}

	for (;;);
}