OBJS = ./build/kernel/kernel.asm.o ./build/kernel/kernel.o ./build/idt/idt.asm.o ./build/idt/idt.o ./build/memory/memory.o
INCLUDES = -I./kernel -I./config -I./memory -I./idt
FLAGS = -g -ffreestanding -falign-jumps -falign-functions -falign-labels -falign-loops \
		-fstrength-reduce -fomit-frame-pointer -finline-functions -Wno-unused-function -fno-builtin \
		-Werror -Wno-unused-label -Wno-cpp -Wno-unused-parameter -nostdlib -nostartfiles -nodefaultlibs -Wall -O0 -Iinc

all: ./bin/boot.bin ./bin/kernel.bin
	rm -rf ./bin/os.bin
	dd if=./bin/boot.bin >> ./bin/os.bin
	dd if=./bin/kernel.bin >> ./bin/os.bin
	dd if=/dev/zero bs=512 count=100 >> ./bin/os.bin

./bin/boot.bin: ./boot/boot.asm
	nasm -f bin boot/boot.asm -o bin/boot.bin

./bin/kernel.bin: $(OBJS)
	i686-elf-ld -g -relocatable $(OBJS) -o ./build/kernel/kernelfull.o
	i686-elf-gcc $(FLAGS) -T ./kernel/linker.ld -o ./bin/kernel.bin ./build/kernel/kernelfull.o

./build/kernel/kernel.asm.o: ./kernel/kernel.asm
	nasm -f elf -g ./kernel/kernel.asm  -o ./build/kernel/kernel.asm.o

./build/kernel/kernel.o: ./kernel/kernel.c
	i686-elf-gcc $(INCLUDES) $(FLAGS) -std=gnu99 -c ./kernel/kernel.c -o ./build/kernel/kernel.o

./build/idt/idt.asm.o: ./idt/idt.asm
	nasm -f elf -g ./idt/idt.asm  -o ./build/idt/idt.asm.o

./build/idt/idt.o: ./idt/idt.c
	i686-elf-gcc $(INCLUDES) $(FLAGS) -std=gnu99 -c ./idt/idt.c -o ./build/idt/idt.o

./build/memory/memory.o: ./memory/memory.c
	i686-elf-gcc $(INCLUDES) $(FLAGS) -std=gnu99 -c ./memory/memory.c -o ./build/memory/memory.o

clean:
	rm -rf ./bin/*
	rm -rf ./build/kernel/kernel.asm.o
	rm -rf ./build/kernel/kernelfull.o
	rm -rf ./build/kernel/kernel.o
	rm -rf ./build/idt/idt.asm.o
	rm -rf ./build/idt/idt.o
	rm -rf ./build/memory/memory.o

run:
	qemu-system-x86_64 -hda ./bin/os.bin
