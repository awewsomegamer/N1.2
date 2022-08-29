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
; Find supported modes

; void do_vesa() {
; 	get_vesa_bios_info();
; 	uint16_t* current_mode = (uint16_t*)(*((uint32_t*)&_BIOS_VESA_INFO + 14));
;	
;	int top_x = 0;
;	int top_y = 0;
; 	int top_bpp = 0;
; 	int top_mode = 0;
;
; 	do {
; 		get_video_mode_info(current_mode);
; 		
;		if ((uint16_t)(*(uint32_t*)_VESA_VIDEO_MODE_INFO + 18) >= top_x || (uint16_t)(*(uint32_t*)_VESA_VIDEO_MODE_INFO + 20) >= top_y || (uint8_t)(*(uint32_t*)_VESA_VIDEO_MODE_INFO + 5) >= top_bpp)
;			top_mode = current_mode;
; 
; 	} while (current_mode != 0xFFFF)
;	
;	switch_mode(top_mode);
; }

do_vesa:

mov ax, 0
mov es, ax
mov di, _BIOS_VESA_INFO
mov ax, 0x4F00
int 0x10
call .error_check

; AX - current pointer to the mode
mov eax, dword [_BIOS_VESA_INFO + 14]

.loop:
	cmp word [eax], 0xFFFF
	je .end

	push eax
	mov cx, 0x0118
	mov ax, 0x4F01
	mov di, _VESA_VIDEO_MODE_INFO
	int 0x10
	call .error_check
	pop eax

	mov ax, [_TOP_VESA_WIDTH]
	cmp word [_VESA_VIDEO_MODE_INFO + 18], ax
	jl .loop
	mov ax, [_TOP_VESA_HEIGHT]
	cmp word [_VESA_VIDEO_MODE_INFO + 20], ax
	jl .loop
	mov al, [_TOP_VESA_BPP]
	cmp byte [_VESA_VIDEO_MODE_INFO + 25], al
	jl .loop

	mov ax, word [_VESA_VIDEO_MODE_INFO + 18]
	mov word [_TOP_VESA_WIDTH], ax
	mov ax, word [_VESA_VIDEO_MODE_INFO + 20]
	mov word [_TOP_VESA_HEIGHT], ax 
	mov al, byte [_VESA_VIDEO_MODE_INFO + 25]
	mov byte [_TOP_VESA_BPP], al

	jmp .end

.error_check:
	cmp ax, 0x004F
	je .ret

	mov ah, 0x0E
	mov al, 'B'
	int 0x10
	jmp $

	.ret: ret

.end:
	mov ah, 0x0E
	mov al, 'A'
	int 0x10



; mov ax, 0
; mov es, ax
; mov di, _BIOS_VESA_INFO
; mov ax, 0x4F00
; int 0x10
; push 'B'
; call .error_check

; ; Check each video mode's information
; mov eax, dword _BIOS_VESA_INFO + 14

; .check_loop:
; 	; Get video mode
; 	mov bx, word [eax]

; 	cmp bx, 0xFFFF
; 	je .ret

; 	; Get video mode info
; 	push eax
; 	mov ax, 0x4F01
; 	mov cx, bx
; 	mov di, _VESA_VIDEO_MODE_INFO
; 	push 'C'
; 	call .error_check
; 	pop eax
	
; 	; Check info (WxHxBPP), change this to default to highest
; 	mov ax, word [_VESA_VIDEO_MODE_INFO + 18] ; Width
; 	cmp ax, 800
; 	jl .next
; 	mov ax, word [_VESA_VIDEO_MODE_INFO + 20] ; Height
; 	cmp ax, 600
; 	jl .next
; 	mov al, byte [_VESA_VIDEO_MODE_INFO + 25] ; BPP
; 	cmp ax, 24
; 	jl .next

; 	; If info matches needs, switch
; 	mov ax, 0x4F02
; 	int 0x10
; 	push 'D'
; 	call .error_check

; 	jmp .ret

; .next:
; 	add eax, 2
; 	jmp .check_loop

; .error_check:
; 	cmp ax, 0x004F
; 	jne .ret

; 	pop bx
; 	mov ah, 0x0E
; 	mov al, 'B'
; 	int 0x10

; 	jmp $
	
; .ret: 
; 	ret
	

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
_TOP_VESA_BPP: db 0x0

; Memory map
%include "memory_map.asm"

MAX_MEMORY_MAP_ENTRIES equ 50

[global _MEMORY_MAP_ENTRIES_FOUND]
_MEMORY_MAP_ENTRIES_FOUND: db 0x0

[global _MEMORY_MAP_DATA]
_MEMORY_MAP_DATA: resb 24 * MAX_MEMORY_MAP_ENTRIES

times 2048 db 0x0