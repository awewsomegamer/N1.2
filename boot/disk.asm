[bits 16]

; DL - Boot disk
; AX - Sectors to read
; EBX - Buffer
; CL - Sector to start from
; CH - Cylinder number
; DH - Head number
read_disk:
	cmp byte [DAP_SUPPORT], 1
	je dap_read

	pushad
	mov ah, 0x41
	mov bx, 0x55AA
	int 0x13
	popad


	jnc .dap_read
	jmp chs_read
	.dap_read:
		mov byte [DAP_SUPPORT], 0x1
		jmp dap_read

chs_read:
	mov ah, 0x02

	int 0x13

	jnc .ret

	mov bx, FAILED_TO_READ_DISK_WITH_CHS
	call print_string
	jmp $

	.ret:
	ret	

dap_read:
	pushad
		mov bx, READING_DAP
		call print_string
	popad


	mov word [DAP_Packet.sectors_to_read], ax
	mov dword [DAP_Packet.buffer], ebx
	
	xor eax, eax
	push cx
		mov cl, ch
		mov ch, 0x0
		mov ax, cx
	pop cx
	
	imul eax, HPC

	push dx
		mov dl, dh
		mov dh, 0x0
		add ax, dx
	pop dx
	
	imul eax, 63

	push cx
		mov ch, 0x0
		add ax, cx
	pop cx

	sub eax, 1
	
	mov dword [DAP_Packet.lba], eax

	mov ah, 0x42
	mov si, DAP_Packet
	int 0x13
	jnc .ret

	mov bx, FAILED_TO_READ_DISK_WITH_DAP
	call print_string

	jmp chs_read

	.ret:
	ret

DAP_Packet:
	db 0x10
	db 0x00
	.sectors_to_read:
	dw 0x0
	.buffer:
	dd 0x0
	.lba:
	dq 1


; Make these dynamic
HPC equ 16
SPT equ 63 

[section .data]
DAP_SUPPORT: db 0x0
FAILED_TO_READ_DISK_WITH_DAP: db "Failed to read the disk with DAP, defaulting to CHS", 0xA, 0xD, 0x0
FAILED_TO_READ_DISK_WITH_CHS: db "Failed to read the disk with CHS", 0xA, 0xD, 0x0
READING_DAP: db "Reading with DAP", 0xA, 0xD, 0x0
[section .text]