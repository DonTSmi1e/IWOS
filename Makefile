# Maybe you want use something else then NASM?
AS=nasm

# OS files: bootloader, kernel, maybe drivers, idk
BINARIES= 	bin/bootloader/mbr.bin				\
			bin/bootloader/boot.bin				\
			bin/kernel16.bin

# Just don't touch it, write your own programs in src/programs/ folder
PROGRAMS=$(patsubst src/programs/%.asm, bin/programs/%.bin, $(wildcard src/programs/*.asm))

# Disk settings
DISK_NAME=disk.img
DISK_SIZE=1440K

# Build file and add it to disk image
bin/%.bin: src/%.asm
	@mkdir -p $(@D)
	$(AS) $< -o $@
	cat $@ >> $(DISK_NAME)

# Builds OS and programs, filling disk zeroes by setted size
build: $(BINARIES) $(PROGRAMS)
	truncate -s $(DISK_SIZE) $(DISK_NAME)

# Builds programs
programs: $(PROGRAMS)

# Just runs qemu
run: build
	qemu-system-i386 -fda $(DISK_NAME)

# Remove disk and bin folder
clean:
	rm -rf $(DISK_NAME) bin/
