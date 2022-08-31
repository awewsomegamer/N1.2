#include <IDT.h>

struct idt_entry idt_entries[256];
struct idtr idt_header;

void set_idt_gate(int gate, uint32_t address, uint16_t selector, uint8_t type) {
	idt_entries[gate].offset1 = address & 0xFFFF;
	idt_entries[gate].offset2 = (address >> 16) & 0xFFFF;

	idt_entries[gate].reserved = 0;
	idt_entries[gate].type = type;
	idt_entries[gate].selector = selector;
}

void setup_idt() {
	
}