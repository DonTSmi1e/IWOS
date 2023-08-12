# IWOS developer guide
*currently in development*

## Memory map
|     Start    |      End     |  Size  | Description           | Usable? |
|:------------:|:------------:|:------:|-----------------------|---------|
| `0x00007C00` | `0x00007E00` | 512 B  | Bootloader code       | No      |
| `0x00007E00` | `0x00008000` | 512 B  | Disk operation buffer | No      |
| `0x00008000` | `0x0000FFFF` | 31 KB  | Free                  | Yes     |
| `0x00010000` | `0x00020000` | 64 KB  | Kernel                | No      |
| `0x00020000` | `0x0007FFFF` | 320 KB | Programs              | Yes*    |

*: The kernel allocates one memory segment on its own for each program run.

## IWFS
Every file has a 512 bytes sector containing meta data, like filename, file size, etc. File data goes after this sector.
File can be empty. Its size will be 0.

| Offset | Size | Type | Description                         |
|:------:|:----:|:----:|-------------------------------------|
| 0      | 50   | `DB` | File name (padded with zeroes)      |
| 50     | 1    | `DB` | File size (in sectors count)        |
| 51     | 30   | `DB` | Owner username (padded with zeroes) |
| 81     | 431  | `DB` | Reserved (can be used for anything) |

## Kernel interrupts
| Interrupt | Input                           | Output                  | Description          |
|:---------:|---------------------------------|-------------------------|----------------------|
| `0x20`    | AH - function code              | Carry flag set if error | Screen functions     |
| `0x21`    | AH - function code              | Carry flag set if error | Keyboard functions   |
| `0x22`    | AH - function code              | Carry flag set if error | Filesystem functions |
| `0x80`    | AX - file start; CL - file size |                         | Execute program      |

### int 0x20
| Function code | Input          | Output | Description     |
|:-------------:|----------------|--------|-----------------|
| `0x0`         | AL - character |        | Print character |
| `0x1`         | SI - string    |        | Print string    |
| `0x2`         |                |        | Clear screen    |

### int 0x21
| Function code | Input                | Output                               | Description  |
|:-------------:|----------------------|--------------------------------------|--------------|
| `0x0`         |                      | AH - BIOS scan code; AL - ASCII char | Wait key     |
| `0x1`         | BL - character limit | DI - entered string                  | Input string |

### int 0x22
| Function code | Input                              | Output                          | Description                  |
|:-------------:|------------------------------------|---------------------------------|------------------------------|
| `0x0`         |                                    |                                 | Print root directory content |
| `0x1`         | SI - file name                     | AX - file start; CL - file size | Get file info                |
| `0x2`         | SI - file name; BX - memory offset | BX - file content               | Read file                    |
