; Retrieve memory map from BIOS
get_memory_map:
	pushad
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
		ret