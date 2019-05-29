[org 0x7c00]
mov bp, 0x8000 ; set the stack pointer
mov sp, bp

mov bx, 0x9000 ; es:bx <- where to store the data
mov dh, 2 ; dh <- number of sectors to read
call disk_load

; run OS
jmp 0x9000

jmp $

; load 'dh' sectors from drive 'dl' into ES:BX
disk_load:
pusha
    ;save to the stack for later use.
    push dx

    mov ah, 0x02 ; ah <- 0x02 = 'read'
    mov al, dh   ; al <- number of sectors to read
    mov cl, 0x02 ; cl <- sector (0x01 is boot sector, so first available is 0x02)
    mov ch, 0x00 ; ch <- cylinder
    ; dl <- drive number (0 = floppy, 1 = floppy2, 0x80 = hdd, 0x81 = hdd2)
    mov dh, 0x00 ; dh <- head number (0x0 .. 0xF)
    int 0x13 ; INT 13h BIOS interrupt (AH=02h => read sectors from drive)
    jc disk_error ; if error (stored in the carry bit (CF))

    pop dx
    cmp al, dh    ; al <- (return:) number of sectors read
    jne sectors_error
    popa
    ret

disk_error:
    jmp disk_loop

sectors_error:
    jmp disk_loop

disk_loop:
    jmp $


DISK_ERROR: db "Disk read error", 0
SECTORS_ERROR: db "Incorrect number of sectors read", 0

times 510 - ($-$$) db 0
dw 0xaa55
		   