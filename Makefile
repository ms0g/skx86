OBJS = ./build/kernel.asm.o

all: ./bin/boot.bin ./bin/kernel.bin
	rm -rf ./bin/os.bin
	dd if=./bin/boot.bin >> ./bin/os.bin
	dd if=./bin/kernel.bin >> ./bin/os.bin
	dd if=/dev/zero bs=512 count=100 >> ./bin/os.bin

./bin/boot.bin: ./boot/boot.asm
	nasm -f bin boot/boot.asm -o bin/boot.bin

./bin/kernel.bin: $(OBJS)
	x86_64-elf-ld -g -relocatable $(OBJS) -o ./build/kernelfull.o
	x86_64-elf-gcc -T linker.ld -o ./bin/kernel.bin -ffreestanding -O0 -nostdlib ./build/kernelfull.o

./build/kernel.asm.o: kernel.asm
	nasm -f elf64 -g kernel.asm  -o ./build/kernel.asm.o

clean:
	rm -rf bin/* build/*

run:
	qemu-system-x86_64 -hda bin/os.bin
