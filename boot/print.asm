[bits 16]

; BX - Input string
print_string:
	mov ah, 0x0E

	.loop:
		mov al, [bx]
		cmp al, 0
		je .end

		push bx
		mov bl, 0xFF
		int 0x10
		pop bx

		inc bx

		jmp .loop
	.end:
		ret