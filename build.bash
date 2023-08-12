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
nasm src/boot.asm -o build/bin/boot.bin -DDATESTAMP="'$DATESTAMP'" $@
test $? -eq 0 || exit $?

nasm src/kernel/kernel.asm -o build/bin/kernel.sys -DDATESTAMP="'$DATESTAMP'" $@
test $? -eq 0 || exit $?

nasm src/programs/shell.asm -o build/bin/shell.com -DDATESTAMP="'$DATESTAMP'" $@
test $? -eq 0 || exit $?

nasm src/programs/hello.asm -o build/bin/hello.com $@
test $? -eq 0 || exit $?

# Filling root directory
cp -a build/bin/*.sys build/root/
cp -a build/bin/*.com build/root/
mkdir -p root/
cp -a root/. build/root/.

# Packing to TAR archive
for filename in build/root/*; do
    python3 tools/iwfs.py build/output/root.iwfs $filename
done

# Creating disk image
cat build/bin/boot.bin >> build/output/disk.img
cat build/output/root.iwfs >> build/output/disk.img
truncate -s 1440K build/output/disk.img

echo "  Done!"