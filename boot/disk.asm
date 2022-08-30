[bits 16]

read_disk:
	mov ah, 0x41
	mov bx, 0x55AA
	mov dl, [BOOT_DISK]
	int 0x13

	jc chs_read
	jmp dap_read

chs_read:
	mov ah, 0x02
	mov al, SECTORS_TO_READ
	mov ch, 0x00
	mov cl, 0x02
	mov dh, 0x00
	mov dl, [BOOT_DISK]
	mov bx, SECOND_STAGE

	int 0x13

	jnc .ret

	jmp $

	.ret:
	ret	

dap_read:
	mov ah, 0x42
	mov dl, [BOOT_DISK]
	mov si, DAP_Packet
	int 0x13

	jnc .ret

	mov bx, FAILED_TO_READ_DISK_WITH_DAP
	call print_string

	jmp chs_read

	.ret:
	ret

FAILED_TO_READ_DISK_WITH_DAP: db "Failed to read the disk with DAP, defaulting to CHS", 0xA, 0xD, 0x0

DAP_Packet:
	db 0x10
	db 0x00
	dw SECTORS_TO_READ
	dd SECOND_STAGE
	dq 1
