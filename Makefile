#MAKEFILE for maroon
TARGET := x86_64
ifeq ($(TARGET),arm)
TARGET := arm
endif
TARGET_TUPLE := $(TARGET)-unknown-linux-gnu
KERNEL := build/$(TARGET)/kernel-$(TARGET).bin
IMAGE := build/maroon-$(TARGET).iso

LINKER := boot/arch/$(TARGET)/scripts/linker.ld
GRUB := boot/arch/$(TARGET)/config/grub.cfg
MAROON_SRC_FILES := $(wildcard boot/arch/$(TARGET)/*.S)
MAROON_OBJ_FILES := $(patsubst boot/arch/$(TARGET)/%.S, build/$(TARGET)/%.o, $(MAROON_SRC_FILES))
MAROON_STATIC_LIB := target/$(TARGET_TUPLE)/debug/libkernel.a

.PHONY: all clean run image

all: $(IMAGE)

clean:
	  @rm -r build/*

run: $(IMAGE)
	  @qemu-system-x86_64 -cdrom $(IMAGE)

image: $(IMAGE)

$(IMAGE): $(KERNEL) $(GRUB)
	  @mkdir -p build/$(TARGET)/image/boot/grub
	  @cp $(KERNEL) build/$(TARGET)/image/boot/kernel.bin
	  @cp $(GRUB) build/$(TARGET)/image/boot/grub
	  @grub-mkrescue -o $(IMAGE) build/$(TARGET)/image
	  @rm -r build/$(TARGET)

$(KERNEL): cargo $(MAROON_OBJ_FILES) $(LINKER)
	  @ld -n -T $(LINKER) -o $(KERNEL) $(MAROON_OBJ_FILES) $(MAROON_STATIC_LIB)

cargo:
		@cargo build --target $(TARGET_TUPLE)

# compile assembly files
build/$(TARGET)/%.o: boot/arch/$(TARGET)/%.S
	  @mkdir -p $(shell dirname $@)
	  @nasm -felf64 $< -o $@
