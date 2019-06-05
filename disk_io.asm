; -------------------- [ Routine: read_disk_chs ] --------------------
; --------- Reads the specified number of sectors from disk ----------
; input:
;   [esp+12] = drive (0 = floppy, 1 = floppy2, 0x80 = hdd, 0x81 = hdd2)
;   [esp+10] = sector
;   [esp+8] = cylinder
;   [esp+6] = head
;   [esp+4] = num sectors
;   [esp+2] = output address
read_disk_chs:
  mov ah, 0x02      ; x02 = 'read'
  mov al, [esp+4]   ; number of sectors to read
  mov cl, [esp+10]  ; sector
  mov ch, [esp+8]   ; cylinder
  mov dl, [esp+12]  ; drive number
  mov dh, [esp+6]   ; head
  mov bx, [esp+2]   ; where to store the data
  int 0x13
  jc .error ; if error (stored in the carry bit (CF))

  mov dx, [esp+6] ; num sectors to read
  cmp al, dh      ; al = number of sectors read
  jne .error
  .error:
    nop
  ret

; -------------------- [ Routine: write_disk_chs ] --------------------
; --------- Writes the specified number of sectors from disk ----------
; input:
;   [esp+12] = drive (0 = floppy, 1 = floppy2, 0x80 = hdd, 0x81 = hdd2)
;   [esp+10] = sector
;   [esp+8] = cylinder
;   [esp+6] = head
;   [esp+4] = num sectors
;   [esp+2] = buffer address
write_disk_chs:
  mov ah, 0x03      ; x03 = 'write'
  mov al, [esp+4]   ; number of sectors to read
  mov cl, [esp+10]  ; sector
  mov ch, [esp+8]   ; cylinder
  mov dl, [esp+12]  ; drive number
  mov dh, [esp+6]   ; head
  mov bx, [esp+2]   ; buffer address
  int 0x13
  jc .error ; if error (stored in the carry bit (CF))

  mov dx, [esp+6] ; num sectors to read
  cmp al, dh      ; al = number of sectors read
  jne .error
  .error:
    nop
  ret
  