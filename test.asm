mov bx, A
call PRINT

mov ax, B
mov bx, C
mov cx, D

call READ

mov bx, E
call PRINT

call MMAP

mov bx, F
call PRINT
mov ax, 'A'
add ax, [G]
int 0x10
mov ax, 0xA
int 0x10
mov ax, 0xD
int 0x10

call H
call I

mov bx, J
call PRINT


PRINT:
	db 0x0
MMAP:
	db 0x0
READ:
	db 0x0

A:
	db 0x0
B:
	db 0x0
C:
	db 0x0
D:
	db 0x0
E:
	db 0x0
F:
	db 0x0
G:
	db 0x0
H:
	db 0x0
I:
	db 0x0
J:
	db 0x0
