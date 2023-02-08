GDT_ZERO:
	dd 0x0
	dd 0x0

GDT32_CODE:
	dw 0xFFFF
	dw 0x0000
	db 0x00

	db 10011010b ; Access
	db 11001111b ; Flags | Limit

	db 0x00

GDT32_DATA:
	dw 0xFFFF
	dw 0x0000
	db 0x00

	db 10010010b ; Access
	db 11001111b ; Flags | Limit

	db 0x00

GDT64_CODE:
	dw 0xFFFF
	dw 0x0000
	db 0x00

	db 10011010b ; Access
	db 10101111b ; Flags | Limit

	db 0x00

GDT64_DATA:
	dw 0xFFFF
	dw 0x0000
	db 0x00

	db 10010010b ; Access
	db 10101111b ; Flags | Limit

	db 0x00

GDT_END:

GDTR:
	dw GDT_END - GDT_ZERO - 1
	dd GDT_ZERO

CODE32_OFFSET equ GDT32_CODE - GDT_ZERO
DATA32_OFFSET equ GDT32_DATA - GDT_ZERO
CODE64_OFFSET equ GDT64_CODE - GDT_ZERO
DATA64_OFFSET equ GDT64_DATA - GDT_ZERO
