[bits 64]
[extern kmain]

pop rax
mov dword [_VIDEO_FONT], eax
pop rax
mov dword [_VESA_VIDEO_MODE_INFO], eax
pop rax
mov dword [_BIOS_VESA_INFO], eax
pop rax
mov dword [_MEMORY_MAP_DATA], eax
pop rax
mov dword [_MEMORY_MAP_ENTRIES_FOUND], eax

jmp kmain

; Pointers
[global _VIDEO_FONT]
_VIDEO_FONT: dd 0x0
[global _VESA_VIDEO_MODE_INFO]
_VESA_VIDEO_MODE_INFO: dd 0x0
[global _BIOS_VESA_INFO]
_BIOS_VESA_INFO: dd 0x0
[global _MEMORY_MAP_DATA]
_MEMORY_MAP_DATA: dd 0x0
[global _MEMORY_MAP_ENTRIES_FOUND]
_MEMORY_MAP_ENTRIES_FOUND: dd 0x0

; [global NUMBERS]
; NUMBERS: db "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ", 0x0
