# BIOS Functions
## int 10h
### Move cursor
```assembly
mov ah, 0x02
mov bh, 0
mov dh, <row>
mov dl, <col>
int 10h
```
### Write char
```assembly
mov ah, 0x0E
mov al, 'A'         ; any char
int 10h
```
### Scrolling
```assembly
mov ah, 0x06        ; scroll up
mov ah, 0x07        ; scroll down
mov al, <lines>     ; to scroll, 0 - clear
mov bh, <color>     ; color.

mov ch, <row>       ; window's upper left corner
mov cl, <column>    ;

mov dh, <row>       ; window's lower right corner
mov dl, <column>    ;


int 10h
```
## int 13h
### Read disk
```assembly
mov ah, 0x02
mov al, 1
mov ch, 0
mov cl, sector_to_read
mov dh, 0
mov dl, 0

mov bx, memory_offset
OR
mov bx, memory_segment
mov es, bx
mov bx, memory_offset

int 13h
```
### Reset disk
```assembly
mov ah, 0x0
int 13h
```
## int 16h
### Get key (blocking)
```assembly
mov ax, 0           ; clear ax reg
mov ah, 0           ; read keyboard scancode (blocking)
int 16h
```