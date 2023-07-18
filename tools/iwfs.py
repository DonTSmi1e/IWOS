import os

def get_files():
    """
        Returns a dictionary of IWFS files.
    """
    files = {}
    with open("disk.img", "rb") as f:
        f.read(512)                             # We don't need bootloader, yes?

        while f:                                # Then we should read last part of our disk
            chunk = f.read(4096)               # Every file is 10240 bytes == 10 kilobytes
            filename = ""                       # Empty string for filename

            # Trying to get filename
            i = 0                               # Byte counter
            for byte in chunk[2:]:
                byte = chunk[2:][i:i+1]             # Taking one byte
                if byte == b'\x00':             # Is 0x0?
                    break                       # Ye, breaking...
                else:                           # Nope, decoding byte
                    filename += byte.decode()
                    i += 1

            # Now we have filename... or no?
            if filename == "":
                break                           # No, filename is empty - end of disk.
                
            files[filename] = chunk             # Loading our file to memory

        f.close()
    return files

files = get_files()
os.system("mkdir -p unpack/")
for file in files:
    with open("unpack/" + file, 'wb') as f:
        f.write(files[file])
        f.close()
