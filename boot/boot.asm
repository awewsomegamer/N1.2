[org 0x7C00]

mov [BOOT_DISK], dl

xor ax, ax
mov ds, ax
mov es, ax
mov fs, ax
mov gs, ax
mov ss, ax

mov bx, BOOT_MESSAGE
call print_string

; AX - Sectors to read
; EBX - Buffer
; CL - Sector to start from
; CH - Cylinder number
; DH - Head number

mov dl, [BOOT_DISK]
mov ax, SECTORS_TO_READ
mov ebx, SECOND_STAGE
mov cl, 0x2
mov ch, 0x0
mov dh, 0x0
mov esi, DAP_Packet
call read_disk

mov bx, DISK_READ_MESSAGE
call print_string

mov dl, [BOOT_DISK]

jmp SECOND_STAGE

%include "print.asm"
%include "disk.asm"

DAP_Packet:
	db 0x10
	db 0x0
	dw SECTORS_TO_READ ; Sectors to read
	dd SECOND_STAGE ; Buffer
	dq 0x1 ; LBA

BOOT_DISK: db 0x0
BOOT_MESSAGE: db "N1.2 Bootloader loaded", 0xA, 0xD, 0x0
DISK_READ_MESSAGE: db "Disk read", 0xA, 0xD, 0x0
HELLO_WORLD: db "Hello World", 0xA, 0xD, 0x0

SECOND_STAGE equ 0x8000
SECTORS_TO_READ equ 41

times 510-($-$$) db 0x0
dw 0xAA55
