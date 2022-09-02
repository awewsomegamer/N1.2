all:
	nasm -f bin boot.asm -o ../bin/boot.bin
	nasm -f elf32 second_stage.asm -o ../bin/second_stage.o
	# nasm -f elf64 second_stage.asm -o ../bin/long_mode.o
	