all:
	make -C boot
	make -C boot32
	make -C kernel
	make -C bin

	fdisk -l bootloader.bin
	fdisk -l disk.bin

run: all
	qemu-system-x86_64 -debugcon stdio disk.bin -d cpu_reset -m 128M

clean:
	make -C bin clean