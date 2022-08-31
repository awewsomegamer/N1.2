#ifndef IO_H
#define IO_H

#include <global.h>

uint8_t inb(uint16_t address);
void outb(uint16_t address, uint8_t value);

#endif