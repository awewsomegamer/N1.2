LDFLAGS := \
	-T linker.ld \
	--oformat binary \
	-melf_i386
	
all:
	ld $(LDFLAGS) second_stage.o ./32_bin/* -o kernel.bin
	cat boot.bin kernel.bin > ../kernel.bin

clean:
	rm -rf ./*.o ./32_bin/* ./*.bin