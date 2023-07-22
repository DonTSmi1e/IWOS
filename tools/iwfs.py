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
            chunk = f.read(10240)               # Every file is 30720 bytes == 30 kilobytes
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

if len(sys.argv) > 2:
    match sys.argv[1]:
        case "-u":
            files = get_files(sys.argv[2])

            try:
                os.mkdir("unpack/")
            except:
                pass

            print("Extracting...")
            for file in files:
                print(file)
                with open("unpack/" + file, 'wb') as f:
                    f.write(files[file])
                    f.close()
        case "-p":
            folder = sys.argv[2]
            files = os.listdir(folder)

            print("Packing...")
            try:
                os.remove("pack.img")
            except:
                pass

            size = 1440*1024
            with open("pack.img", "ab") as disk:
                # First of all we must write bootloader
                with open(folder + "/__boot__.bin", "rb") as boot:
                    disk.write(boot.read())
                    boot.close()
                
                # Then we can load other files
                for filename in files:
                    with open(f"{folder}/{filename}", "rb") as file:
                        disk.write(file.read())
                        file.close()

                # Ok, now we should truncate our file
                disk.write(bytearray(size - disk.tell()))

                disk.close()
else:
    print(f"Usage: {sys.argv[0]} -u <disk.img>")

