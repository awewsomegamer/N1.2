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

%macro PUSHALL 0
	push rax
	push rbx
	push rcx
	push rdx
	push rsi
	push rdi
	push rbp
	push rsp
	push r8
	push r9
	push r10
	push r11
	push r12
	push r13
	push r14
	push r15
%endmacro

%macro POPALL 0
	push r15
	push r14
	push r13
	push r12
	push r11
	push r10
	push r9
	push r8
	push rsp
	push rbp
	push rdi
	push rsi
	push rdx
	push rcx
	push rbx
	push rax
%endmacro



[extern isr_common_handler]
[global isr0]
isr0:
	push 0
	PUSHALL
	call isr_common_handler
	POPALL
	iretq

[global isr1]
isr1:
	push 0
	PUSHALL
	call isr_common_handler
	POPALL
	iretq

[global isr2]
isr2:
	push 0
	PUSHALL
	call isr_common_handler
	POPALL
	iretq

[global isr3]
isr3:
	push 0
	PUSHALL
	call isr_common_handler
	POPALL
	iretq

[global isr4]
isr4:
	push 0
	PUSHALL
	call isr_common_handler
	POPALL
	iretq

[global isr5]
isr5:
	push 0
	PUSHALL
	call isr_common_handler
	POPALL
	iretq

[global isr6]
isr6:
	push 0
	PUSHALL
	call isr_common_handler
	POPALL
	iretq

[global isr7]
isr7:
	push 0
	PUSHALL
	call isr_common_handler
	POPALL
	iretq

[global isr8]
isr8:
	push 0
	PUSHALL
	call isr_common_handler
	POPALL
	iretq

[global isr9]
isr9:
	push 0
	PUSHALL
	call isr_common_handler
	POPALL
	iretq

[global isr10]
isr10:
	push 0
	PUSHALL
	call isr_common_handler
	POPALL
	iretq

[global isr11]
isr11:
	push 0
	PUSHALL
	call isr_common_handler
	POPALL
	iretq

[global isr12]
isr12:
	push 0
	PUSHALL
	call isr_common_handler
	POPALL
	iretq

[global isr13]
isr13:
	push 0
	PUSHALL
	call isr_common_handler
	POPALL
	iretq

[global isr14]
isr14:
	push 0
	PUSHALL
	call isr_common_handler
	POPALL
	iretq

[global isr15]
isr15:
	push 0
	PUSHALL
	call isr_common_handler
	POPALL
	iretq

[global isr16]
isr16:
	push 0
	PUSHALL
	call isr_common_handler
	POPALL
	iretq

[global isr17]
isr17:
	push 0
	PUSHALL
	call isr_common_handler
	POPALL
	iretq

[global isr18]
isr18:
	push 0
	PUSHALL
	call isr_common_handler
	POPALL
	iretq

[global isr19]
isr19:
	push 0
	PUSHALL
	call isr_common_handler
	POPALL
	iretq

[global isr20]
isr20:
	push 0
	PUSHALL
	call isr_common_handler
	POPALL
	iretq

[global isr21]
isr21:
	push 0
	PUSHALL
	call isr_common_handler
	POPALL
	iretq

[global isr22]
isr22:
	push 0
	PUSHALL
	call isr_common_handler
	POPALL
	iretq

[global isr23]
isr23:
	push 0
	PUSHALL
	call isr_common_handler
	POPALL
	iretq

[global isr24]
isr24:
	push 0
	PUSHALL
	call isr_common_handler
	POPALL
	iretq

[global isr25]
isr25:
	push 0
	PUSHALL
	call isr_common_handler
	POPALL
	iretq

[global isr26]
isr26:
	push 0
	PUSHALL
	call isr_common_handler
	POPALL
	iretq

[global isr27]
isr27:
	push 0
	PUSHALL
	call isr_common_handler
	POPALL
	iretq

[global isr28]
isr28:
	push 0
	PUSHALL
	call isr_common_handler
	POPALL
	iretq

[global isr29]
isr29:
	push 0
	PUSHALL
	call isr_common_handler
	POPALL
	iretq

[global isr30]
isr30:
	push 0
	PUSHALL
	call isr_common_handler
	POPALL
	iretq

[global install_idt]
[extern _idtr]
install_idt:
	lidt [_idtr]
	sti

	ret

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
