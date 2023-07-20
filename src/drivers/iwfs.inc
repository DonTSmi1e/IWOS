; IWOS Kernel ; IWFS driver
; Authors:
;   https://github.com/dontsmi1e    - Base code
; You can add yourself to this list if you made changes in the code.
;
; Requirements:
;   src/bootloader/include/string.inc
;   src/bootloader/include/disk.inc


    ; --- FUNCTIONS --- ;
; Load file from disk
; Input:
;   SI - Filename
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
    cmp byte [di], 0
    sub bx, 2

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

