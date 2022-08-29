[org 0x7C00]

mov [BOOT_DISK], dl

mov ah, 0x0E
mov al, 'A'
int 0x10

call read_disk

mov ah, 0x0E
mov al, 'A'
int 0x10

jmp 0x8000

%include "disk.asm"

BOOT_DISK: db 0x0

times 510-($-$$) db 0x0
dw 0xAA55
