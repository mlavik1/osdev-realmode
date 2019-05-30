; *** MEMORY HELPERS ***

; -------------------- [ Routine: memcpy ] --------------------
; -----copies a block of memory from source to destination-----
; input: [esp+6] destination (address)
; input: [esp+4] source (address)
; input: [esp+2] size (in bytes)
memcpy:
  mov si, [esp+4] ; src
  mov di, [esp+6] ; dst
  cld
  mov cx, [esp+2] ; size (# of times to repeat)
  rep movsb
  ret

; -------------------- [ Routine: memset ] --------------------
; -----ifills a block with memory with the specified value-----
; input: [esp+6] destination (address)
; input: [esp+4] word size (in bytes)
; input: [esp+2] byte value
memset:
  mov al, [esp+2]
  mov di, [esp+6]
  mov cx, [esp+4]
  rep stosb
  ret
