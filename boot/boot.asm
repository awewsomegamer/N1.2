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

call read_disk

mov bx, DISK_READ_MESSAGE
call print_string

jmp SECOND_STAGE

%include "print.asm"
%include "disk.asm"

BOOT_DISK: db 0x0
BOOT_MESSAGE: db "N1.2 Bootloader loaded", 0xA, 0xD, 0x0
DISK_READ_MESSAGE: db "Disk read", 0xA, 0xD, 0x0

SECOND_STAGE equ 0x8000
SECTORS_TO_READ equ 42

times 510-($-$$) db 0x0
dw 0xAA55
