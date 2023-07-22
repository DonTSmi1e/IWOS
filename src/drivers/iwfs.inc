; IWOS Kernel ; IWFS driver
; Authors:
;   https://github.com/dontsmi1e    - Base code
; You can add yourself to this list if you made changes in the code.
;
; Requirements:
;   src/drivers/string.inc
;   src/drivers/disk.inc
;   src/drivers/screen.inc


    ; --- FUNCTIONS --- ;
; Load file from disk
; Input:
;   SI - Filename
;   CL - Sectors to read
;   ES:BX - memory location
fs__read:
    pusha

    mov ax, 2
    mov cl, 20

.search:
    call disk__read
    jc .not_found
    add ax, 20

    add bx, 2
    mov di, bx
    sub bx, 2

    cmp byte [di], 0
    je .not_found

    call string__compare
    jnc .found

    jmp .search

.found:
    clc
    popa
    ret

.not_found:
    stc
    popa
    ret


; Print list of files
; Input:
;   ES:BX - memory location
fs__dir:
    pusha

    mov ax, 2
    mov cl, 1

.search:
    call disk__read
    jc .done
    add ax, 20

    add bx, 2
    mov si, bx
    sub bx, 2

    cmp byte [si], 0
    je .done

    call screen__print
    call screen__newline

    jmp .search

.done:
    popa
    ret

