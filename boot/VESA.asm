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

		mov bx, VESA_ALGORITHM_ENCOUNTERED_ERROR
		call print_string

		jmp $

		.ret: ret

	.end:
		mov ax, 0x4F02
		mov bx, word [_TOP_VESA_MODE]
		int 0x10
		call .error_check

		ret