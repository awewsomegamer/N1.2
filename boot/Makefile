all:
	nasm -f bin boot.asm -o ../bin/boot.bin
	nasm -f elf32 second_stage.asm -o ../bin/second_stage_asm.o
	nasm -f elf64 long_mode.asm -o ../bin/long_mode_asm.o
	