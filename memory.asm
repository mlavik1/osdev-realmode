; *** MEMORY HELPERS ***

; -------------------- [ Routine: memcpy ] --------------------
; -----copies a block of memory from source to destination-----
; input: [esp+6] destination (address)
; input: [esp+4] source (address)
; input: [esp+2] size (in bytes)
memcpy:
  mov cx, 0x0000 ; it
  _memcpy_loop:
    ; set source
    mov bx, [esp+4]
    add bx, cx
    mov al, [bx]
    ; set destination
    mov bx, [esp+6]
    add bx, cx
    ; copy value to destination
    mov byte [bx], al
    ; increment counter
    inc cx
    mov ax, [esp+2]
    cmp cx, ax
    jl _memcpy_loop
  ret

; -------------------- [ Routine: memset ] --------------------
; -----ifills a block with memory with the specified value-----
; input: [esp+6] destination (address)
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
