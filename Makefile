OBJS = ./build/kernel/kernel.s.o \
		./build/kernel/kernel.o \
		./build/idt/idt.s.o \
		./build/idt/idt.o \
		./build/disk/disk.o \
		./build/disk/streamer.o \
		./build/memory/memory.o \
		./build/memory/heap/heap.o \
		./build/memory/heap/kheap.o \
		./build/memory/paging/paging.o \
		./build/memory/paging/paging.s.o \
		./build/fs/pparser.o \
		./build/string/string.o \
		./build/io/io.s.o
INCLUDES = -I./kernel -I./config -I./memory -I./memory/heap -I./memory/paging -I./idt -I./io -I./status -I./disk -I./fs -I./string
FLAGS = -g -ffreestanding -falign-jumps -falign-functions -falign-labels -falign-loops \
		-fstrength-reduce -fomit-frame-pointer -finline-functions -Wno-unused-function -fno-builtin \
		-Werror -Wno-unused-label -Wno-cpp -Wno-unused-parameter -nostdlib -nostartfiles -nodefaultlibs -Wall -O0 -Iinc

all: ./bin/boot.bin ./bin/kernel.bin
	rm -rf ./bin/os.bin
	dd if=./bin/boot.bin >> ./bin/os.bin
	dd if=./bin/kernel.bin >> ./bin/os.bin
	dd if=/dev/zero bs=1048576 count=16 >> ./bin/os.bin

./bin/boot.bin: ./boot/boot.s
	nasm -f bin boot/boot.s -o bin/boot.bin

./bin/kernel.bin: $(OBJS)
	i686-elf-ld -g -relocatable $(OBJS) -o ./build/kernel/kernelfull.o
	i686-elf-gcc $(FLAGS) -T ./kernel/linker.ld -o ./bin/kernel.bin ./build/kernel/kernelfull.o

./build/kernel/kernel.s.o: ./kernel/kernel.s
	nasm -f elf -g ./kernel/kernel.s  -o ./build/kernel/kernel.s.o

./build/kernel/kernel.o: ./kernel/kernel.c
	i686-elf-gcc $(INCLUDES) $(FLAGS) -std=gnu99 -c ./kernel/kernel.c -o ./build/kernel/kernel.o

./build/idt/idt.s.o: ./idt/idt.s
	nasm -f elf -g ./idt/idt.s  -o ./build/idt/idt.s.o

./build/idt/idt.o: ./idt/idt.c
	i686-elf-gcc $(INCLUDES) $(FLAGS) -std=gnu99 -c ./idt/idt.c -o ./build/idt/idt.o

./build/disk/disk.o: ./disk/disk.c
	i686-elf-gcc $(INCLUDES) $(FLAGS) -std=gnu99 -c ./disk/disk.c -o ./build/disk/disk.o

./build/disk/streamer.o: ./disk/streamer.c
	i686-elf-gcc $(INCLUDES) $(FLAGS) -std=gnu99 -c ./disk/streamer.c -o ./build/disk/streamer.o

./build/io/io.s.o: ./io/io.s
	nasm -f elf -g ./io/io.s  -o ./build/io/io.s.o

./build/memory/memory.o: ./memory/memory.c
	i686-elf-gcc $(INCLUDES) $(FLAGS) -std=gnu99 -c ./memory/memory.c -o ./build/memory/memory.o

./build/memory/heap/heap.o: ./memory/heap/heap.c
	i686-elf-gcc $(INCLUDES) $(FLAGS) -std=gnu99 -c ./memory/heap/heap.c -o ./build/memory/heap/heap.o

./build/memory/heap/kheap.o: ./memory/heap/kheap.c
	i686-elf-gcc $(INCLUDES) $(FLAGS) -std=gnu99 -c ./memory/heap/kheap.c -o ./build/memory/heap/kheap.o

./build/memory/paging/paging.o: ./memory/paging/paging.c
	i686-elf-gcc $(INCLUDES) $(FLAGS) -std=gnu99 -c ./memory/paging/paging.c -o ./build/memory/paging/paging.o

./build/memory/paging/paging.s.o: ./memory/paging/paging.s
	nasm -f elf -g ./memory/paging/paging.s  -o ./build/memory/paging/paging.s.o

./build/fs/pparser.o: ./fs/pparser.c
	i686-elf-gcc $(INCLUDES) $(FLAGS) -std=gnu99 -c ./fs/pparser.c -o ./build/fs/pparser.o

./build/string/string.o: ./string/string.c
	i686-elf-gcc $(INCLUDES) $(FLAGS) -std=gnu99 -c ./string/string.c -o ./build/string/string.o

clean:
	rm -rf ./bin/*
	rm -rf $(OBJS)
	
run:
	qemu-system-i386 -hda ./bin/os.bin
