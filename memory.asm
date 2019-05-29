; *** MEMORY HELPERS ***

memcpy:
  ; TODO
  ret

; -------------------- [ Routine: memset ] --------------------
; -----ifills a block with memory with the specified value-----
; input: [esp+6] target address
; input: [esp+4] word size (in bytes)
; input: [esp+2] byte value
memset:
  mov cx, 0x0000 ; it
  _memset_loop:
    ; set destination
    mov bx, [esp+6]
    add bx, cx
    ; copy value to destination
    mov ax, [esp+2]
    mov byte [bx], al
    ; increment counter
    inc cx
    mov ax, [esp+4]
    cmp cx, ax
    jl _memset_loop
  ret
