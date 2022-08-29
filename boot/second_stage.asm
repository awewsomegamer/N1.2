[bits 16]

; Success
mov ah, 0x0E
mov al, 'A'
int 0x10

; Retrieve memory map from BIOS
pushad
get_mmap:
mov ax, 0
mov es, ax
mov di, _MEMORY_MAP_DATA

xor ebx, ebx

.loop:
	mov byte [_MEMORY_MAP_ENTRIES_FOUND], bl
	
	xor edx, edx
	xor eax, eax

	mov edx, 0x534D4150
	mov eax, 0xE820
	mov ecx, 24

	int 0x15

	jc .error
	cmp eax, 0x534D4150
	jne .error

	add di, 24
	
	cmp ebx, 0
	jne .loop

	jmp .success		

.error:
	mov ah, 0x0E
	mov al, 'B'
	int 0x10

	jmp $

.success:
popad

; Success
mov ah, 0x0E
mov al, 'A'
int 0x10

jmp $

; Switch to VESA video mode - figure out target mode

; Switch to 32-bit PM
	; Pre-kernel
	; Generate PML4 map
	; Identity page first page table
	; Good practice to load ISRs for some basic error handling

; Switch to 64-bit Long Mode
	; Hand control to 64 bit kernel
	


; Memory map
MAX_MEMORY_MAP_ENTRIES equ 50

[global _MEMORY_MAP_ENTRIES_FOUND]
_MEMORY_MAP_ENTRIES_FOUND: db 0x0

[global _MEMORY_MAP_DATA]
_MEMORY_MAP_DATA: resb 24 * MAX_MEMORY_MAP_ENTRIES


times 2048 db 0x0