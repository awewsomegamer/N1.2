all:
	make -C boot
	make -C boot32
	make -C bin

	fdisk -l kernel.bin

run: all
	qemu-system-x86_64 -debugcon stdio kernel.bin -d cpu_reset

clean:
	make -C bin clean