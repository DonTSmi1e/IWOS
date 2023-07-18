; IWOS Bootloader ; Floppy driver
; Authors:
;   https://github.com/dontsmi1e    - Base code
; You can add yourself to this list if you made changes in the code.


    ; --- FUNCTIONS --- ;
; Input:
;   AL - How many sectors to read
;   CH - Cylinder
;   DH - Head
;   CL - Sector
;   ES:BX - memory location
disk__read:
    pusha

    mov ah, 0x02                    ; Switching to reading mode
    mov dl, 0                       ; Read drive 0

    int 13h                         ; Reading...
    jc .error                       ; Catch error

    popa
    ret

.error:
    call disk__reset                ; Trying to reset floppy controller
    popa
    stc                             ; Ye, we failed anyway.
    mov al, 1h
    ret


; Reset disk controller
disk__reset:
    pusha

    mov ah, 0x0                     ; Switching to reset mode
    int 13h                         ; Reseting...
    jc .error                       ; Catch error

    popa
    ret

.error:
    popa                            ; We are failed.
    ret

