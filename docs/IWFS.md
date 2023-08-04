# Incredibly Wrong FS
Based on USTAR. Yep.

## Details
Every file has a 512 bytes sector containing meta data, like filename, file size, etc. File data goes after this sector.
File can be empty. Its size will be 0.

| Offset | Size | Type | Description                         |
|:------:|:----:|:----:|-------------------------------------|
| 0      | 50   | `DB` | File name (padded with zeroes)      |
| 50     | 1    | `DB` | File size (in sectors count)        |
| 51     | 30   | `DB` | Owner username (padded with zeroes) |
| 81     | 431  | `DB` | Reserved (can be used for anything) |
