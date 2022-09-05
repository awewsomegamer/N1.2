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
call get_font

; Vesa success
mov bx, SUCCESSFULLY_ENABLED_VESA
call print_string

cli

; Enable A20
in al, 0x92
or al, 2
out 0x92, al

lgdt [GDTR]

; Enable PE bit
mov eax, cr0
or al, 1
mov cr0, eax

jmp CODE32_OFFSET:PROTECTED_MODE

[bits 32]
[extern protected_mode_entry]
[extern puts]
[extern pml4]

PROTECTED_MODE:
	; Update segments
	mov ax, DATA32_OFFSET
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov ss, ax
	mov gs, ax
	
	; Do more complicated things in C
	call protected_mode_entry

	; Checks for 64 bit mode
	call cpuid_check
	call long_mode_check
	
	; Set PAE bit
	mov edx, cr4
	or edx, (1 << 5)
	mov cr4, edx

	; Set LME
	mov ecx, 0xC0000080
	rdmsr
	or eax, (1 << 8)
	wrmsr

	; Load PML4 table
	mov eax, pml4
	mov cr3, eax
	mov ebx, cr0
	or ebx, (1 << 31)
	mov cr0, ebx
	
	; Change segment selectors
	mov ax, DATA64_OFFSET
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	mov ss, ax

	; Pass information to the kernel
	push _MEMORY_MAP_ENTRIES_FOUND
	push _MEMORY_MAP_DATA
	push _BIOS_VESA_INFO
	push _VESA_VIDEO_MODE_INFO
	push _VIDEO_FONT

	jmp CODE64_OFFSET:LONG_MODE_ENTRY

cpuid_check:
	pushfd
	pop eax
	mov ecx, eax

	xor eax, 1 << 21

	push eax
	popfd

	pushfd
	pop eax
	push ecx
	popfd

	xor eax, ecx
	jnz .ret

	push CPUID_NOT_FOUND
	call puts
	jmp $

	.ret:
	ret

long_mode_check:
	mov eax, 0x80000000
	cpuid
	cmp eax, 0x80000001
	jge .next

	push NO_EXTENDED_FUNCTIONS_FOUND
	call puts
	jmp $

	.next:

	mov eax, 0x80000001
	cpuid
	test edx, 1 << 29
	jnz .ret

	push NO_LONG_MODE_FOUND
	call puts
	jmp $

	.ret:
	ret

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
CPUID_NOT_FOUND: db "No CPUID was found", 0xA, 0xD, 0x0
NO_EXTENDED_FUNCTIONS_FOUND: db "No extended CPUID functions were found", 0xA, 0xD, 0x0
NO_LONG_MODE_FOUND: db "Long mode was found", 0xA, 0xD, 0x0
ENTERED_LONG_MODE: db "Entered long mode", 0xA, 0xD, 0x0
LONG_MODE_ENTRY equ 0xD000

[global _VIDEO_FONT]
_VIDEO_FONT: resb 0x1000

times 2048 db 0x0