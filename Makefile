#MAKEFILE for maroon

all:
	$(shell nasm -f elf64 boot/multiboot_header.S)
	$(shell nasm -f elf64 boot/boot.S)
	$(shell ld -n -o image/boot/kernel.bin -T boot/linker.ld boot/multiboot_header.o boot/boot.o)
	$(shell grub-mkrescue -o output/maroon.iso image)
	rm boot/multiboot_header.o boot/boot.o

clean:
		rm boot/multiboot_header.o boot/boot.o image/boot/kernel.bin
		rm output/*
