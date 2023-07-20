import os
import sys

def get_files(disk_file):
    """
        Returns a dictionary of IWFS files.
    """
    files = {}
    with open(disk_file, "rb") as f:
        files["__boot__.bin"] = f.read(1024)

        while f:                                # Then we should read last part of our disk
            chunk = f.read(10240)               # Every file is 10240 bytes == 10 kilobyte
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

if len(sys.argv) > 1:
    files = get_files(sys.argv[1])

    try:
        os.mkdir("unpack/")
    except FileExistsError:
        pass

    print("Extracting...")
    for file in files:
        print(file)
        with open("unpack/" + file, 'wb') as f:
            f.write(files[file])
            f.close()
else:
    print(f"Usage: {sys.argv[0]} <filename>")


