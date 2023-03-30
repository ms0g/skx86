all:
	nasm -f bin boot/boot.asm -o boot.bin
run:
	qemu-system-x86_64 -hda boot.bin
