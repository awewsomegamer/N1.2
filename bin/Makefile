LD32FLAGS := \
	-T linker32.ld \
	-melf_i386 \
	--oformat binary \
	-L/usr/lib/gcc/x86_64-pc-linux-gnu/12.1.1/32/libgcc.a

LD64FLAGS := \
	-T linker32.ld \
	--oformat binary \
	-L/usr/lib/gcc/x86_64-pc-linux-gnu/12.1.1/32/libgcc.a

all:
	ld $(LD32FLAGS) second_stage_asm.o ./32_bin/* -o second_stage.bin
	ld $(LD64FLAGS) long_mode_asm.o  ./64_bin/* -o kernel.bin

	cat boot.bin second_stage.bin kernel.bin > ../disk.bin

clean:
	rm -rf ./*.o ./32_bin/* ./*.bin ./64_bin/*