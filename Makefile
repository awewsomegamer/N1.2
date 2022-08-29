all:
	make -C boot
	make -C kernel32
	make -C bin

	fdisk -l kernel.bin

run: all
	qemu-system-x86_64 kernel.bin