LD32FLAGS := \
	-T linker.ld \
	-melf_i386 \
	--oformat binary \
	-L/usr/lib/gcc/x86_64-pc-linux-gnu/12.1.1/32/libgcc.a

	
all:
	ld $(LD32FLAGS) second_stage.o ./32_bin/* -o kernel.bin
	

	cat boot.bin kernel.bin > ../kernel.bin

clean:
	rm -rf ./*.o ./32_bin/* ./*.bin