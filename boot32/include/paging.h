#ifndef __32PAGING_H__
#define __32PAGING_H__

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
	uint64_t next_entry_address : 40;
	uint8_t reserved1 : 1;
	uint16_t avl3 : 10;
	uint8_t xd : 1;
} __attribute__((packed));

struct page_table_entry {
	uint8_t present : 1;
	uint8_t rw : 1;
	uint8_t us : 1;
	uint8_t pwt : 1;
	uint8_t pcd : 1;
	uint8_t a : 1;
	uint8_t d : 1;
	uint8_t pat : 1;
	uint8_t g : 1;
	uint8_t avl1 : 3;
	uint64_t physical_address_base : 40;
	uint8_t reserved1 : 1;
	uint8_t avl2 : 6;
	uint8_t pk : 3;
	uint8_t xd : 1;
} __attribute__((packed));

void identity_prw_map(uint64_t physical, uint64_t virtual, size_t length);

#endif