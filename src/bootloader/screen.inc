; IWOS Bootloader ; Screen library
; Authors:
;   https://github.com/dontsmi1e    - Base code
; You can add yourself to this list if you made changes in the code.


    ; --- DEFINES --- ;
%define NEWLINE 0x0D, 0xA


    ; --- FUNCTIONS --- ;
; Input:
;   SI - string to print  
print:
    pusha                       ; Saving our registers
    mov ah, 0x0E                ; Switching to TTY mode

.loop:
    mov al, [si]                ; Take char from SI

    or al, al                   ; Is Null?
    je .end                     ; Yep, jump to end
    int 10h                     ; No, print char
    
    inc si                      ; Increase pointer to SI
    jmp .loop                   ; And going back

.end:
    popa                        ; Restoring our registers
    ret                         ; And back to main code

