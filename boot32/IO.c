#include <IO.h>

uint8_t inb(uint16_t address) {
	uint8_t v;
	asm volatile("inb %1, %0" : "=a"(v) : "Nd"(address));
	return v;
}

void outb(uint16_t address, uint8_t value) {
	asm volatile("outb %0, %1" : : "a"(value), "Nd"(address));
}
