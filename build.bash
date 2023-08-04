DATESTAMP=$(date)

echo "  Building..."

# Clear everything
rm -rf build/
test $? -eq 0 || exit $?
mkdir -p build/ build/bin/ build/root/ build/output/

echo "DO NOT USE THIS DIRECTORY TO STORAGE IMPORTANT FILES, EVERY BUILD PROCESS REMOVES IT COMPLETELY!" > "build/WARNING.txt"
echo "; --- $DATESTAMP --- ;
folders:
    bin         ; Binary files of OS
    output      ; Output files
    root        ; Root directory of disk

bin:
    Bootloader, kernel and programs

output:
    An archive with a root directory, a floppy disk image, and other junk ready for use.

root:
    Stores the structure of the future archive.

; ./build.bash && qemu-system-i386 -debugcon file:debug.bin -fda build/output/disk.img
" > "build/README.txt"

# Assembling
nasm src/boot.asm -o build/bin/boot.bin -DDATESTAMP="'$DATESTAMP'"
test $? -eq 0 || exit $?

nasm src/kernel.asm -o build/bin/kernel.bin -DDATESTAMP="'$DATESTAMP'"
test $? -eq 0 || exit $?

nasm src/programs/hello.asm -o build/bin/hello.bin
test $? -eq 0 || exit $?

# Filling root directory
cp build/bin/kernel.bin build/root/kernel.bin
cp build/bin/hello.bin build/root/hello.bin

# Packing to TAR archive
python3 tools/iwfs.py build/output/root.iwfs build/root/kernel.bin
python3 tools/iwfs.py build/output/root.iwfs build/root/hello.bin
python3 tools/iwfs.py build/output/root.iwfs flappybird.com

# Creating disk image
cat build/bin/boot.bin >> build/output/disk.img
cat build/output/root.iwfs >> build/output/disk.img
truncate -s 1440K build/output/disk.img

echo "  Done!"