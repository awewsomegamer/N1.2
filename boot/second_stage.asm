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

; Switch to VESA video mode
do_vesa:

mov ax, 0
mov es, ax
mov di, _BIOS_VESA_INFO
mov ax, 0x4F00
int 0x10
call .error_check

; EAX - current pointer to the mode
mov eax, dword [_BIOS_VESA_INFO + 14]

.loop:
	cmp word [eax], 0xFFFF
	je .end

	push eax
	mov cx, word [eax]
	mov ax, 0x4F01
	mov di, _VESA_VIDEO_MODE_INFO
	int 0x10
	call .error_check
	pop eax
	
	add eax, 2

	push eax
	mov ax, [_TOP_VESA_WIDTH]
	cmp word [_VESA_VIDEO_MODE_INFO + 18], ax
	pop eax
	jl .loop
	push eax
	mov ax, [_TOP_VESA_HEIGHT]
	cmp word [_VESA_VIDEO_MODE_INFO + 20], ax
	pop eax
	jl .loop
	push eax
	mov al, [_TOP_VESA_BPP]
	cmp byte [_VESA_VIDEO_MODE_INFO + 25], al
	pop eax
	jl .loop

	push eax
	mov ax, word [_VESA_VIDEO_MODE_INFO + 18]
	mov word [_TOP_VESA_WIDTH], ax
	mov ax, word [_VESA_VIDEO_MODE_INFO + 20]
	mov word [_TOP_VESA_HEIGHT], ax 
	mov al, byte [_VESA_VIDEO_MODE_INFO + 25]
	mov byte [_TOP_VESA_BPP], al
	pop eax

	push eax
	mov ax, word [eax]
	mov word [_TOP_VESA_MODE], ax
	pop eax

	jmp .loop

.error_check:
	cmp ax, 0x004F
	je .ret

	mov ah, 0x0E
	mov al, 'B'
	int 0x10
	jmp $

	.ret: ret

.end:
	mov ax, 0x4F02
	mov bx, word [_TOP_VESA_MODE]
	int 0x10
	call .error_check

	mov ah, 0x0E
	mov al, 'A'
	int 0x10

jmp $


; Switch to 32-bit PM
	; Pre-kernel
	; Generate PML4 map
	; Identity page first page table
	; Good practice to load ISRs for some basic error handling

; Switch to 64-bit Long Mode
	; Hand control to 64 bit kernel
	

; VESA information
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

times 2048 db 0x0