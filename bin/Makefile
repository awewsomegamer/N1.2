OBJS := $(wildcard *.o)

all:
	ld -T linker.ld --oformat binary -melf_i386 second_stage.o $(filter-out second_stage.o, $(OBJS)) -o kernel.bin
	cat boot.bin kernel.bin > ../kernel.bin