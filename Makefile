all:
	nasm -f bin boot/boot.asm -o bin/boot.bin
clean:
	rm -rf bin/* build/*
run:
	qemu-system-x86_64 -hda bin/boot.bin
