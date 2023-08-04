; Disk driver
; Authors:
;   https://github.com/dontsmi1e    - Base code
; You can add yourself to this list if you made changes in the code.
;
; thanks to that guy: https://www.youtube.com/@nanobyte-dev


    ; --- FUNCTIONS --- ;
; Convert LBA to CHS
; Input:
;   AX - LBA address
; Output:
;   CH, DH, CL - C, H, S
lba_to_chs:
    push ax
    push dx

    xor dx, dx
    div word [bpb_sectors_per_track]

    inc dx
    mov cx, dx

    xor dx, dx
    div word [bpb_heads]

    mov dh, dl
    mov ch, al
    shl ah, 6
    or cl, ah

    pop ax
    mov dl, al
    pop ax

    ret


; Read disk
; Input:
;   AX - LBA address
;   CL - Number of sectors to read
;   DL - Disk number
;   ES:BX - Memory address
disk__read:
    push ax
    push bx
    push cx
    push dx
    push di

    push cx
    call lba_to_chs
    pop ax

    mov ah, 0x02
    int 13h
    jc .error

    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    ret

.error:
    call disk__reset
    stc
    popa
    ret


; Get disk status
; Output:
;   AL - Status
disk__status:
    mov ah, 0x1
    int 13h
    ret


; Reset disk
disk__reset:
    pusha

    mov ah, 0x0
    int 13h

    popa
    ret


    ; --- VARIABLES --- ;
bpb_sectors_per_track:  dw 18
bpb_heads:              dw 2

