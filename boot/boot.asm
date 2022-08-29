[org 0x7C00]

mov [BOOT_DISK], dl

mov ah, 0x0E
mov al, 'A'
int 0x10

mov al, SECTORS_TO_READ
call chs_read

mov ah, 0x0E
mov al, 'A'
int 0x10

jmp SECOND_STAGE

%include "disk.asm"

BOOT_DISK: db 0x0

SECOND_STAGE equ 0x8000
SECTORS_TO_READ equ 9

times 510-($-$$) db 0x0
dw 0xAA55
