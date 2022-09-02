all:
	make -C boot
	make -C boot32
	make -C kernel
	make -C bin

	fdisk -l disk.bin

run: all
	qemu-system-x86_64 -debugcon stdio disk.bin -d cpu_reset

clean:
	make -C bin clean