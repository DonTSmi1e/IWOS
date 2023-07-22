import os
import sys

class IWFS:
    def __init__(self, disk_file):
        self.disk = disk_file

    def files(self):
        """
            Returns a dictionary of IWFS files.
        """
        files = {}
        with open(self.disk, "rb") as f:
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
    
    def write(self, file_path):
        files = self.files()

        # Create new file in table
        with open(file_path, "rb") as target:
            files[file_path.split("/")[-1]] = target.read()
            target.close()

        os.remove(self.disk) # Remove old disk image
        size = 1440*1024 # 1440*1024 = 1.44MB
        with open(self.disk, "ab") as disk:
            # Write table
            for filename in files:
                disk.write(files[filename])

            # Truncate image
            disk.write(bytearray(size - disk.tell()))
            disk.close()

        return True

    def delete(self, file_name):
        files = self.files()

        # Remove file from table
        if file_name == "__boot__.bin":
            return False
        del files[file_name]

        os.remove(self.disk) # Remove old disk image
        size = 1440*1024 # 1440*1024 = 1.44MB
        with open(self.disk, "ab") as disk:
            # Write table
            for filename in files:
                disk.write(files[filename])

            # Truncate image
            disk.write(bytearray(size - disk.tell()))
            disk.close()

        return True

if __name__ == "__main__":
    print("Use iwfsmanager.py")