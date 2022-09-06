#include <paging.h>
#include <screen.h>

// CR3 = first address of the PML4 (where the page maps start (&pml4))
struct page_map_entry pml4[512] __attribute__((aligned(0x1000))); // Address = [x]PDP[0] (page directory pointers) (struct page_map_entry)

struct page_map_entry pdpt[512] __attribute__((aligned(0x1000))); // Address = [x]PD[0] (page directories) (struct page_map_entry)
struct page_map_entry pdt[512] __attribute__((aligned(0x1000))); // Address = [x]PT[0] (page tables) (struct page_map_entry)
struct page_table_entry pt[512] __attribute__((aligned(0x1000))); // Address = base physical address (pages) (struct page_table_entry)
struct page_table_entry pt2[512] __attribute__((aligned(0x1000))); // Address = base physical address (pages) (struct page_table_entry)

// struct page_map_entry pdpt_framebuffer[512] __attribute__((aligned(0x1000))); // Address = [x]PD[0] (page directories) (struct page_map_entry)
struct page_map_entry pdt_framebuffer[512] __attribute__((aligned(0x1000))); // Address = [x]PT[0] (page tables) (struct page_map_entry)
struct page_table_entry pt_framebuffer[512] __attribute__((aligned(0x1000))); // Address = base physical address (pages) (struct page_table_entry)

void create_pml4() {
	pml4[0].next_entry_address = ((uint64_t)&pdpt) >> 12;
	pml4[0].present = 1;
	pml4[0].rw = 1;

	pdpt[0].next_entry_address = ((uint64_t)&pdt) >> 12;
	pdpt[0].present = 1;
	pdpt[0].rw = 1;

	pdt[0].next_entry_address = ((uint64_t)&pt) >> 12;
	pdt[0].present = 1;
	pdt[0].rw = 1;

	pdt[1].next_entry_address = ((uint64_t)&pt2) >> 12;
	pdt[1].present = 1;
	pdt[1].rw = 1;

	uint32_t fb_pml4_index = (_VESA_VIDEO_MODE_INFO.framebuffer >> 39) & 0x1FF;
	uint32_t fb_pdp_index = (_VESA_VIDEO_MODE_INFO.framebuffer >> 30) & 0x1FF;
	uint32_t fb_pd_index = (_VESA_VIDEO_MODE_INFO.framebuffer >> 21) & 0x1FF;
	uint32_t fb_pt_index = (_VESA_VIDEO_MODE_INFO.framebuffer >> 12) & 0x1FF;

	printf("0x%X 0x%X 0x%X 0x%X\n", fb_pml4_index, fb_pdp_index, fb_pd_index, fb_pt_index);

	// pml4[fb_pml4_index].next_entry_address = ((uint64_t)&pdpt_framebuffer) >> 12;
	// pml4[fb_pml4_index].present = 1;
	// pml4[fb_pml4_index].rw = 1;

	pdpt[fb_pdp_index].next_entry_address = ((uint64_t)&pdt_framebuffer) >> 12;
	pdpt[fb_pdp_index].present = 1;
	pdpt[fb_pdp_index].rw = 1;

	pdt_framebuffer[fb_pd_index].next_entry_address = ((uint64_t)&pt_framebuffer) >> 12;
	pdt_framebuffer[fb_pd_index].present = 1;
	pdt_framebuffer[fb_pd_index].rw = 1;

	// Do first 2 MB
	for (int i = 0; i < 512; i++) {
		pt[i].physical_address_base = i;
		pt[i].present = 1;
		pt[i].rw = 1;

		pt2[i].physical_address_base = i + 0x200;
		pt2[i].present = 1;
		pt2[i].rw = 1;
	}

	// Do framebuffer + 0x1000 * 512
	uint32_t base = (_VESA_VIDEO_MODE_INFO.framebuffer);
	printf("%X\n", base);
	for (int i = 0; i < 512; i++) {
		pt_framebuffer[i].physical_address_base = ((base) >> 12) + i;
		pt_framebuffer[i].present = 1;
		pt_framebuffer[i].rw = 1;
	}

	printf("Identity paged virtual 0x0 -> virtual 0x%X\n", 512 * 0x1000);
	printf("PML4 located at 0x%X\n", &pml4);
	printf("PDPT located at 0x%X\n", &pdpt);
	printf("PDT located at 0x%X\n", &pdt);
	printf("PT located at 0x%X\n", &pt);
	// printf("Framebuffer PDPT located at 0x%X\n", &pdpt_framebuffer);
	printf("Framebuffer PDT located at 0x%X\n", &pdt_framebuffer);
	printf("Framebuffer PT located at 0x%X\n", &pt_framebuffer);

	// for (;;);
}