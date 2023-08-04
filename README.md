<h1 align="center">Incredibly Wrong OS</h1>

dead project 💀 (no, its not)

Everything is wrong here, even the English here is wrong, because i am stupid russki.

<img align="center" src="screenshots/1.png">
<a href="https://github.com/DonTSmi1e/IWOS/releases">Download floppy image</a>
<hr>

## Resources
<a href="https://wiki.osdev.org">OS Development wiki</a>

<a href="https://github.com/icebreaker/floppybird">Flappy Bird game original sources</a>

## User guide
<a href="https://github.com/DonTSmi1e/IWOS/blob/main/USERGUIDE.md">Here it is!</a>

## Problems
- IWFS (i wanna fat12, but not today)
- 16-bit mode
- No C/C++
- No kernel API (or something that programs can use to print/load file/etc)

<hr>

## Building
**WSL 2.0 supported**

Requirements:
- NASM
- QEMU
```bash
./build.bash                                                                            # Clean and build OS

qemu-system-i386 -debugcon file:debug.bin -fda build/output/disk.img                    # Run OS in QEMU

./build.bash && qemu-system-i386 -debugcon file:debug.bin -fda build/output/disk.img    # Clean, build and run OS
```

<hr>

## Contributing
1. Clone repo
2. Make some changes
3. Edit header of file
4. Make pull request

ez.

<hr>

## Tools
Place useful scripts and programs to `tools` folder.
Like IWFS extractor, yes.

<hr>

## Todo list
- [X] Floppy driver
- [X] Any FS support
- [X] Kernel
- [X] Shell
- [X] Graphic mode (build kernel with -DVESA argument. still in development)
- [ ] FAT12 support
- [ ] 32-bit mode
- [ ] HDD/USB driver
- [ ] FAT32 support
- [ ] Port NASM (or any supported asm)
- [ ] Self-hosted

## Screenshots
![](screenshots/2.png)
![](screenshots/3.png)
![](screenshots/4.png)
