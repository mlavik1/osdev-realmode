; *** keyboard ***

; -------------------- [ Routine: read_keypress ] --------------------
; -----------waits for keyboard input and returns scan code-----------
; OUT: al = scan code of keypress
read_keypress:
  mov ah, 0x00
  int 0x16
  ret

; -------------------- [ Routine: move_cursor_left ] --------------------
move_cursor_left:
  mov ah, 0x03
  mov bh, 0x00
  int 0x10
  test dl, dl
  je .return
  dec dl
  mov ah, 0x02
  int 0x10
  .return:
  ret

; -------------------- [ Routine: move_cursor_right ] --------------------
move_cursor_right:
  mov ah, 0x03
  mov bh, 0x00
  int 0x10
  inc dl
  mov ah, 0x02
  int 0x10
  ret
  