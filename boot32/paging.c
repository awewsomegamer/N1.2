#include <paging.h>
#include <screen.h>

// CR3 = first address of the PML4 (where the page maps start (&pml4))
struct page_map_entry pml4[512] __attribute__((aligned(0x1000))); // Address = [x]PDP[0] (page directory pointers) (struct page_map_entry)
struct page_map_entry pdpt[512] __attribute__((aligned(0x1000))); // Address = [x]PD[0] (page directories) (struct page_map_entry)
struct page_map_entry pdt[512] __attribute__((aligned(0x1000))); // Address = [x]PT[0] (page tables) (struct page_map_entry)
struct page_table_entry pt[512] __attribute__((aligned(0x1000))); // Address = base physical address (pages) (struct page_table_entry)

void create_pml4() {
	pml4[0].next_entry_address = (((uint64_t)&pdpt) & 0xFFFFFFFFFFFFF000) >> 12;
	pml4[0].present = 1;
	pml4[0].rw = 1;

	pdpt[0].next_entry_address = (((uint64_t)&pdt) & 0xFFFFFFFFFFFFF000) >> 12;
	pdpt[0].present = 1;
	pdpt[0].rw = 1;

	pdt[0].next_entry_address = (((uint64_t)&pt) & 0xFFFFFFFFFFFFF000) >> 12;
	pdt[0].present = 1;
	pdt[0].rw = 1;

	for (int i = 0; i < 512; i++) {
		pt[i].physical_address_base = i;
		pt[i].present = 1;
		pt[i].rw = 1;
	}
	
	// pml4[0] = (uint64_t)&pdpt | (0b11); // Load address and set present and RW flags
	// pdpt[0] = (uint64_t)&pdt  | (0b11);
	// pdt[0]  = (uint64_t)&pt   | (0b11);
	
	// for (int i = 0; i < 512; i++)
	// 	pt[i] = (i * 0x1000) | (0b11);

	printf("Identity paged virtual 0x0 -> virtual 0x%X\n", 512 * 0x1000);
	printf("PML4 table located at 0x%X\n", &pml4);
	printf("PDPT table located at 0x%X\n", &pdpt);
	printf("PDT table located at 0x%X\n", &pdt);
	printf("PT table located at 0x%X\n", &pt);
}