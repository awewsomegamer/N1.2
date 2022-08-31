#ifndef IDT_H
#define IDT_H

#include <global.h>

struct idt_entry {
	uint16_t offset1;
	uint16_t selector;
	uint8_t reserved;
	uint8_t type;
	uint16_t offset2;
} __attribute__((packed));

struct idtr {
	uint16_t size;
	uint32_t address;
} __attribute__((packed));

void setup_idt();

#endif