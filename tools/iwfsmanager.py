"""
    IWFS GUI manager
"""

import os
import sys

from tkinter import *
from tkinter import ttk
from tkinter import filedialog
from tkinter import messagebox

from iwfs import IWFS

# GUI functions
def select_disk():
    global disk, disk_files

    filename = filedialog.askopenfilename(initialdir = ".",
                                          title = "Select a File",
                                          filetypes = (("Disk image", "*.img"), ("Floppy", "*.flp")))

    disk = IWFS(filename)
    disk_files = disk.files()
    root.title(disk.disk)

    update_list()

def extract():
    selected_file = file_list.get(file_list.curselection())
    with open(selected_file, "wb") as file:
        file.write(disk_files[selected_file])
        file.close()

def delete():
    selected_file = file_list.get(file_list.curselection())
    if not disk.delete(selected_file):
        messagebox.showerror("Bootloader", "You can't delete bootloader.")
        return
    update_list()

def load():
    filename = filedialog.askopenfilename(initialdir = ".",
                                          title = "Select a File",
                                          filetypes = (("Binary", "*.bin"), ("COM", "*.com")))
    if filename != "":
        if filename.split("/")[-1] == "__boot__.bin":
            if os.stat(filename).st_size != 1024:
                messagebox.showerror("Invalid size", "Bootloader must be 1024 bytes in size.")
                return
        elif os.stat(filename).st_size != 10240:
            messagebox.showerror("Invalid size", "The file must be 10240 bytes in size.")
            return

        if filename.split("/")[-1] in disk_files:
            messagebox.showwarning("Overwriting", f"{filename.split('/')[-1]} will be overwritten.")
        disk.write(filename)
        update_list()

def update_list():
    file_list.delete(0, END)

    disk_files = disk.files()
    for file in disk_files:
        file_list.insert(END, file)

def run():
    if os.system(f"qemu-system-i386 -fda {disk.disk}"):
        messagebox.showerror("Run error", "It doesn't work.")

def run_wsl():
    if os.system(f"wsl qemu-system-i386 -fda {disk.disk}"):
        messagebox.showerror("Run error", "It doesn't work.")

# GUI
root = Tk()
root.title("Loading...")
root.geometry("600x300")

root.rowconfigure(0, weight=1)
root.columnconfigure(0, weight=1)

file_list = Listbox()
file_list.pack(side=LEFT, fill=BOTH, expand=YES)

scroll = Scrollbar(command=file_list.yview)
scroll.pack(side=LEFT, fill=Y)

file_list.config(yscrollcommand=scroll.set)
 
select_disk()
update_list()

ttk.Button(text="Change disk", command=select_disk).pack(fill=X)
ttk.Button(text="Extract", command=extract).pack(fill=X)
ttk.Button(text="Upload", command=load).pack(fill=X)
ttk.Button(text="Delete", command=delete).pack(fill=X)
ttk.Button(text="Run in QEMU", command=run).pack(fill=X)
if sys.platform.startswith("win"):
    ttk.Button(text="Run in QEMU (WSL)", command=run_wsl).pack(fill=X)

root.mainloop()