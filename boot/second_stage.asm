[bits 16]

mov bx, SUCCESSFULLY_REACHED_STAGE_TWO

call get_memory_map

; Memory map success
mov bx, MEMORY_MAP_ENTRIES_FOUND_MESSAGE
call print_string
mov al, 'A'
add al, byte [_MEMORY_MAP_ENTRIES_FOUND]
int 0x10
mov al, 0xA
int 0x10
mov al, 0xD
int 0x10

; Switch video mode to VESA
call do_vesa

; Vesa success
mov bx, SUCCESSFULLY_ENABLED_VESA
call print_string

cli

; Enable A20
in al, 0x92
or al, 2
out 0x92, al

lgdt [GDTR]

mov eax, cr0
or al, 1
mov cr0, eax

jmp 0x08:PROTECTED_MODE

[bits 32]
[extern protected_mode_entry]

PROTECTED_MODE:
	mov ax, 0x10
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov ss, ax
	mov gs, ax

	call protected_mode_entry

	jmp $


; Switch to 32-bit PM
	; Pre-kernel
	; Generate PML4 map
	; Identity page first page table
	; Good practice to load ISRs for some basic error handling

; Switch to 64-bit Long Mode
	; Hand control to 64 bit kernel
	

[bits 16]

%include "GDT.asm"
%include "print.asm"

; VESA information
%include "VESA.asm"

[global _BIOS_VESA_INFO]
_BIOS_VESA_INFO: resb 512

[global _VESA_VIDEO_MODE_INFO]
_VESA_VIDEO_MODE_INFO: resb 256

_TOP_VESA_WIDTH: dw 0x0
_TOP_VESA_HEIGHT: dw 0x0
_TOP_VESA_MODE: dw 0x0
_TOP_VESA_BPP: db 0x0
; Memory map
%include "memory_map.asm"

MAX_MEMORY_MAP_ENTRIES equ 50

[global _MEMORY_MAP_ENTRIES_FOUND]
_MEMORY_MAP_ENTRIES_FOUND: db 0x0

[global _MEMORY_MAP_DATA]
_MEMORY_MAP_DATA: resb 24 * MAX_MEMORY_MAP_ENTRIES

MEMORY_MAP_ENTRIES_FOUND_MESSAGE: db "Number of memory map entries found is ", 0x0
SUCCESSFULLY_REACHED_STAGE_TWO: db "Successfully made it to second stage", 0xA, 0xD, 0x0
SUCCESSFULLY_ENABLED_VESA: db "Successfully enabled VESA mode", 0xA, 0xD, 0x0
VESA_ALGORITHM_ENCOUNTERED_ERROR: db "Vesa algorithm encoutnered an error", 0xA, 0xD, 0x0

times 2048 db 0x0