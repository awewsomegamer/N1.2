GDT_ZERO:
	dd 0x0
	dd 0x0

GDT_CODE:
	dw 0xFFFF
	dw 0x0000
	db 0xFF

	db 10011010b ; Access
	db 11001111b ; Flags | Limit

	db 0x00

GDT_CODE:
	dw 0xFFFF
	dw 0x0000
	db 0xFF

	db 10010010b ; Access
	db 11001111b ; Flags | Limit

	db 0x00

GDT_END:

GDTR:
	dw GDT_END - GDT_ZERO - 1
	dd GDT_ZERO