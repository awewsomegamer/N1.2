#ifndef __64PMM_H__
#define __64PMM_H__

#include <global.h>

struct memory_map_entry {
	uint64_t base;
	uint64_t length;
	uint32_t type;
	uint32_t acpi3_attrs;
} __attribute__((packed));

void init_pmm();
void* malloc(size_t size);
void free(void* ptr);

#endif