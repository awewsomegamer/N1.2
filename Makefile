all:
	make -C boot
	# make -C boot32
	make -C bin

	fdisk -l kernel.bin

run: all
	qemu-system-x86_64 -drive file=kernel.bin,format=raw

clean:
	make -C bin clean