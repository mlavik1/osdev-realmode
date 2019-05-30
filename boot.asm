[org 0x7c00]

jmp boot_start

OEM_ID                db 		"MING-OS " ; 11 bytes
BytesPerSector        dw 		0x0200
SectorsPerCluster     db 		0x08
ReservedSectors       dw 		0x0020
FATs                  db 		0x01
RootEntries           dw 		0x0000
SmallSectors          dw 		0x0000
MediaDescriptor       db 		0xF8
SectorsPerFAT         dw 		0x0000
SectorsPerTrack       dw 		0x003D
Heads                 dw 		0x0002
HiddenSectors         dd 		0x00000000
TotalSectors     	    dd 		0x00FE3B1F		

DriveNumber           db 		0x00
CurrentHead           db   	0x00
Signature             db 		0x29
VolumeID              dd 		0xFFFFFFFF
VolumeLabel           db 		"MINGOS BOOT" ; 11 bytes
SystemID              db 		"FAT16   "

boot_start:
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
		   