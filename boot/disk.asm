[bits 16]

; AX - Number of sectors to read
; CH - Cylinder number
; CL - Sector number
; DH - Head number
; EBX - Buffer
; DL - Drive
read_disk:
	; Check for extension
	pushfd
	pushad
	mov ah, 0x41
	mov bx, 0x55AA
	int 0x13
	jnc .supported
	popad
	popfd

	jmp read_with_chs

	.supported:
		popad
		popfd
		jmp read_with_dap

read_with_dap:
	mov word [DAP_Base_Packet.sectors_to_read], ax
	mov dword [DAP_Base_Packet.buffer], ebx

	
	; Do CHS to LBA calculation
	

	mov si, DAP_Base_Packet
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

DAP_Base_Packet:
	db 0x10
	db 0x0
	.sectors_to_read:
	dw 0x0
	.buffer:
	dd 0x0
	.lba
	dq 0x0


HPC equ 16
SPT equ 63

CHS_READ_ERROR: db "Could not read the disk with CHS", 0xA, 0xD, 0x0
DAP_READ_ERROR: db "Could not read the disk with DAP, trying CHS", 0xA, 0xD, 0x0