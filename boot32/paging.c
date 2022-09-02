#include <paging.h>
#include <screen.h>

// CR3 = first address of the PML4 (where the page maps start (&pml4))
struct page_map_entry pml4[512]; // Address = [x]PDP[0] (page directory pointers)
struct page_map_entry pdpt[512]; // Address = [x]PD[0] (page directories)
struct page_map_entry pdt[512]; // Address = [x]PT[0] (page tables)
struct page_table_entry pt[512]; // Address = base physical address (pages)

void create_pml4() {
	pml4[0].next_entry_address = pdpt;
	pml4[0].present = 1;
	pml4[0].rw = 1;

	pdpt[0].next_entry_address = pdt;
	pdpt[0].present = 1;
	pdpt[0].rw = 1;

	pdt[0].next_entry_address = pt;
	pdt[0].present = 1;
	pdt[0].rw = 1;

	for (int i = 0; i < 512; i++) {
		pt[i].physical_address_base = i * 0x1000;
		pt[i].present = 1;
		pt[i].rw = 1;
	}
	
	printf("Identity paged virtual 0x0 -> virtual 0x%X", 512 * 0x1000);
}