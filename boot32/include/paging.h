#ifndef PAGING_H
#define PAGING_H

#include <global.h>

struct page_map_entry {
	uint8_t present : 1;
	uint8_t rw : 1;
	uint8_t us : 1;
	uint8_t pwt : 1;
	uint8_t pcd : 1;
	uint8_t a : 1;
	uint8_t avl1 : 1;
	uint8_t ps : 1;
	uint8_t avl2 : 4;
	uint64_t address : 40;
	uint8_t reserved1 : 1;
	uint16_t avl3 : 10;
	uint8_t xd : 1;
};

void create_pml4();

#endif