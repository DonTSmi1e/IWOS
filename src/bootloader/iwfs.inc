; IWOS Bootloader ; IWFS driver
; Authors:
;   https://github.com/dontsmi1e    - Base code
; You can add yourself to this list if you made changes in the code.
;
; Requirements:
;   src/bootloader/disk.inc


    ; --- FUNCTIONS --- ;
; Input:
;   SI - filename
;   ES:BX - memory location
fs__open:
    pusha

    mov al, 20h                  ; Sectors to read   (always 20)
    mov ch, 0h                   ; Cylinder          (0-79; total 80)
    mov dh, 0h                   ; Head              (0-1; total 2)
    mov cl, 2h                   ; Sector            (1-18; total 18)
    mov dl, 19h                  ; Counter.          (always 19)

    jmp .search

.reset_head: ; What is reset sector?
    inc ch                      ; We are increase our cylinder,
    mov dh, 0h                  ; and set head to 0.
    jmp .fix_chs

.reset_sector: ; What is reset sector?
    inc dh                      ; We are increase our head,
    mov cl, 1h                  ; and set sector to 1.
    jmp .fix_chs

.fix_chs:
    ; We are wanna get all disk space, right?
    cmp cl, 19h                 ; If sector is 19 (maximum is 18),
    je .reset_sector            ; reset sector.

    cmp dh, 2h                  ; If head is 2 (maximum is 1),
    je .reset_head              ; reset head.

    cmp ch, 80h                 ; If cylinder is 80 (maximum is 79),
    je .not_found               ; file doesnt exist 0_0

    ret

.search:
    ; We are wanna get all disk space, right?
    call .fix_chs

    ; Reading
    call disk__read
    jc .not_found
    inc cl                      ; Increment sector number

    add bx, 2h                  ; First two bytes must be jmp instruction, so we should skip it
    mov di, bx                  ; Moving our filename in DI
    repe cmpsb                  ; Comparing SI with DI
    sub bx, 2h                  ; Restoring BX

    je .found                   ; Jump to .found, if strings same
    jmp .search                 ; If no, continue our search.

.not_found:
    stc
    popa
    ret

.found:
    clc
    popa
    ret

