[bits 16]

; AX - Number of sectors to read
; CH - Cylinder number
; CL - Sector number
; DH - Head number
; EBX - Buffer
; DL - Drive
; ESI - Pointer to DAP structure
read_disk:
	; Check for extension
	pushad
	mov ah, 0x41
	mov bx, 0x55AA
	int 0x13
	jnc .supported
	popad

	jmp read_with_chs

	.supported:
		popad
		jmp read_with_dap

read_with_dap:
	mov ah, 0x42
	int 0x13

	jnc .ret

	pushad
	mov bx, DAP_READ_ERROR
	call print_string
	popad

	jmp read_with_chs

	.ret:
	ret

read_with_chs:
	mov ah, 0x02
	
	int 0x13

	jnc .ret

	mov bx, CHS_READ_ERROR
	call print_string
	jmp $

	.ret:
	ret

CHS_READ_ERROR: db "Could not read the disk with CHS", 0xA, 0xD, 0x0
DAP_READ_ERROR: db "Could not read the disk with DAP, trying CHS", 0xA, 0xD, 0x0