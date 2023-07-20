###### Incredibly Wrong FS

## Disk structure (Floppy 1.44M)
| Sector |                      |   |
|--------|----------------------|---|
| 1      | Bootloader (Stage 1) |   |
| 2      | Bootloader (Stage 2) |   |
| 3-*    | Files                |   |

ye, thats all.

## File structure
All files has fixed size (10240 bytes).
Every file must contain special header:
```x86asm
jmp main                                ; Jump to main function
file_name:          db 'test.com', 0    ; File name with null-terminator
```
and special footer:
```x86asm
times 10240-($-$$) db 0                  ; So output file will have size 1024 bytes
```
