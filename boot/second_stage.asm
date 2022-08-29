[bits 16]

; Success
mov ah, 0x0E
mov al, 'A'
int 0x10

call get_memory_map

; Success
mov ah, 0x0E
mov al, 'A'
add al, byte [_MEMORY_MAP_ENTRIES_FOUND]
int 0x10

; Switch to VESA video mode - figure out target mode

jmp $


; Switch to 32-bit PM
	; Pre-kernel
	; Generate PML4 map
	; Identity page first page table
	; Good practice to load ISRs for some basic error handling

; Switch to 64-bit Long Mode
	; Hand control to 64 bit kernel
	


; Memory map
%include "memory_map.asm"

MAX_MEMORY_MAP_ENTRIES equ 50

[global _MEMORY_MAP_ENTRIES_FOUND]
_MEMORY_MAP_ENTRIES_FOUND: db 0x0

[global _MEMORY_MAP_DATA]
_MEMORY_MAP_DATA: resb 24 * MAX_MEMORY_MAP_ENTRIES


times 2048 db 0x0