# IWOS
###### Incredibly Wrong OS

## Building

### Windows
`todo`

### Linux

#### Requirements:
- NASM
- Make
- QEMU

```bash
make clean      # Delete bin/ and disk.img
make build      # Build project
make run        # Run disk.img in QEMU (qemu-system-i386)

make clean run  # Just build and run OS.
```

## Contributing
1. Clone repo
2. Make some changes
3. Edit header of file
4. Make pull request

ez.

## Tools
Place useful scripts and programs to `tools` folder.
Like IWFS extractor, yes.

## Todo list:
- [X] Floppy driver
- [X] Any FS support
- [ ] Kernel
- [ ] Shell
- [ ] FAT12 support
- [ ] 32-bit mode
- [ ] HDD/USB driver
- [ ] FAT32 support
- [ ] Graphic mode
- [ ] Port NASM (or any supported asm)
- [ ] Self-hosted

maybe something else. idk.