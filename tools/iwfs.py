import os
import sys
import math

class IWFS:
    def __init__(self, file):
        self.file = file
    
    def append(self, file_path):
        file = {}

        # Create new file in table
        with open(file_path, "rb") as target:
            file = {
                "filename":     file_path.split("/")[-1].encode("utf-8"),
                "sectors":      math.ceil(os.stat(file_path).st_size / 512).to_bytes(1, 'big'),
                "owner":        "admin".encode("utf-8"),
                "content":      target.read()
                }
            file["filename"]    += b"\x00" * (50 - len(file["filename"]))
            file["owner"]       += b"\x00" * (30 + 431 - len(file["owner"]))
            file["content"]     += b"\x00" * ((512 * int.from_bytes(file["sectors"], 'big')) - len(file["content"]))
            target.close()

        with open(self.file, "ab") as archive:
            # Write file
            for entry in file:
                archive.write(file[entry])
            archive.close()

        return True

class IWFS_Disk:
    def __init__(self, file):
        self.file = file
    
    def read(self):
        files = []
        with open(self.file, "rb") as disk:
            files.append(disk.read(512))

            while True:
                metadata = disk.read(512)
                try:
                    if metadata[0] == 0:
                        break
                except IndexError:
                    print("Um, there's no data. Maybe your image corrupted?")
                    sys.exit(1)
                size = metadata[50]
                file = disk.read(512 * size)
                files.append(metadata)
                files.append(file)
            
            disk.close()

        return files

    def append(self, file_path):
        file = {}
    
        files = self.read()

        # Create new file in table
        with open(file_path, "rb") as target:
            file = {
                "filename":     file_path.split("/")[-1].encode("utf-8"),
                "sectors":      math.ceil(os.stat(file_path).st_size / 512).to_bytes(1, 'big'),
                "owner":        "admin".encode("utf-8"),
                "content":      target.read()
                }
            file["filename"]    += b"\x00" * (50 - len(file["filename"]))
            file["owner"]       += b"\x00" * (30 + 431 - len(file["owner"]))
            file["content"]     += b"\x00" * ((512 * int.from_bytes(file["sectors"], 'big')) - len(file["content"]))
            target.close()

        with open(self.file, "wb") as archive:
            # Write files
            for data in files:
                archive.write(data)
            for entry in file:
                archive.write(file[entry])
            archive.truncate(1474560)
            archive.close()

        return True

if __name__ == "__main__":
    if len(sys.argv) > 2:
        if "-D" in sys.argv:
            file = IWFS_Disk(sys.argv[1])
        else:
            file = IWFS(sys.argv[1])
        file.append(sys.argv[2])
        sys.exit(0)

    print(f"Usage: {sys.argv[0]} <archive> <file>")
    sys.exit(1)
