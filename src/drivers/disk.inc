; IWOS Kernel ; Floppy driver
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
;   CH - Cylinder
;   DH - Head
;   CL - Sector
disk__lba_to_chs:
    push ax
    push dx

    xor dx, dx
    div word [sectors_per_track]

    inc dx
    mov cx, dx

    xor dx, dx
    div word [heads]

    mov dh, dl
    mov ch, al
    shl ah, 6
    or cl, ah

    pop ax
    mov dl, al
    pop ax

    ret

; Read data from disk
; Input:
;   AX - LBA driver
;   CL - How many sectors to read
;   DL - Drive number
;   ES:BX - memory location
disk__read:
    push ax
    push bx
    push cx
    push dx
    push di

    push cx
    call disk__lba_to_chs
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


; Reset disk controller
disk__reset:
    pusha

    mov ah, 0x0
    int 13h

    popa
    ret


sectors_per_track:      dw 18
heads:                  dw 2

