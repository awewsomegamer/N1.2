all:
	ld -T linker.ld --oformat binary -melf_i386 second_stage.o -o kernel.bin #./32_bin/*
	cat boot.bin kernel.bin > ../kernel.bin

clean:
	rm -rf ./*.o ./32_bin/* ./*.bin