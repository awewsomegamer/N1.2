[bits 16]

; read_disk:
; 	mov ah, 0x41
; 	mov bx, 0x55AA
; 	mov dl, [BOOT_DISK]
; 	int 0x13

; 	jc chs_read
; 	jmp d_lba


; DAP:		db 16 		; packet size
; 		db 0x0		; 0
; blocks: 	dw 1		; sectors to read
; where:  	dw 0x8000	; where to read
; d_lba: 		dd 1		; lower 32 bits of 48-bit start lba
; 		dw 0		; upper 16 bits of 48-bit start lba

; 		; Setup DAP
; 		mov si, DAP
; 		mov ah, 0x42
; 		mov dl, [BOOT_DISK]
; 		int 0x13

; 		; Handle error
; 		jnc .ret

; 		mov ah, 0x0E
; 		mov al, 'B'
; 		int 0x10

; 		jmp $

; 		.ret:
; 		ret

chs_read:
	mov ah, 0x02
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
