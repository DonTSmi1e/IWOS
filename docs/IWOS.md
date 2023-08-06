# IWOS developer guide
*currently in development*

## Memory map
|     Start    |      End     |    Size   | Description        |
|:------------:|:------------:|:---------:|--------------------|
| `0x00007C00` | `0x00007E00` | 512 bytes | Bootloader code    |
| `0x00010000` | `0x00013000` | 12 KB     | Kernel area        |
| `0x00013000` | `0x0001FDFF` | 52 KB     | Free               |
| `0x0001FDFF` | `0x0001FFFF` | 512 bytes | IWFS driver buffer |

## IWFS
Every file has a 512 bytes sector containing meta data, like filename, file size, etc. File data goes after this sector.
File can be empty. Its size will be 0.

| Offset | Size | Type | Description                         |
|:------:|:----:|:----:|-------------------------------------|
| 0      | 50   | `DB` | File name (padded with zeroes)      |
| 50     | 1    | `DB` | File size (in sectors count)        |
| 51     | 30   | `DB` | Owner username (padded with zeroes) |
| 81     | 431  | `DB` | Reserved (can be used for anything) |
