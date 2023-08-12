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
; Output:
;   AX - file start
;   CL - file size
fs__read:
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
    jc .not_found
    mov di, bx

    ; Check if first byte is 0
    cmp byte [di], 0
    je .not_found

    ; Print file name
    call string__compare
    jc .skip

    ; Get file size
    add di, 50
    mov cl, byte [di]
    jmp .done

.skip:
    add di, 50
    add ax, word [di]
    jmp .search

.done:
    inc ax
    mov [file_start], ax
    mov [file_size], cx
    clc
    popa
    mov ax, [file_start]
    mov cx, [file_size]
    ret

.not_found:
    stc
    popa
    ret


file_start:     dw 0
file_size:      dw 0

