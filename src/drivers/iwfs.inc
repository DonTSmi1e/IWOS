; Disk driver
; Authors:
;   https://github.com/dontsmi1e    - Base code
; You can add yourself to this list if you made changes in the code.


    ; --- FUNCTIONS --- ;
; Print list of files
fs__dir:
    pusha

    ; Setup registers to read disk
    mov ax, 0
    mov cl, 1
    mov bx, 0xFDFF

.search:
    ; Read sector
    inc ax
    mov ah, 0
    call disk__read
    jc .done
    mov si, bx

    ; Check if first byte is 0
    cmp byte [si], 0
    je .done

    ; Print file name
    call screen__print
    call screen__newline

    ; Get file size
    add si, 50
    add ax, word [si]

    jmp .search

.done:
    popa
    ret


; Load file to memory
; Input:
;   SI - filename
;   BX - memory location
fs__read:
    pusha

    ; Setup registers to read disk
    mov ax, 0
    mov cl, 1

.search:
    ; Read sector
    inc ax
    call disk__read
    jc .not_found
    mov di, bx

    ; Check if first byte is 0
    cmp byte [di], 0
    je .not_found

    ; Print file name
    call string__compare
    jc .search

    ; Get file size
    add di, 50
    mov cl, byte [di]

.load_file:
    inc ax
    call disk__read
    clc
    popa
    ret

.not_found:
    stc
    popa
    ret

