#ifndef __32IO_H__
#define __32IO_H__

#include <global.h>

uint8_t inb(uint16_t address);
void outb(uint16_t address, uint8_t value);

#endif