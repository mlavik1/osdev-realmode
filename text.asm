; *** text ***

; -------------------- [ Routine: print_char ] --------------------
; ----------------------- prints a character ----------------------
; IN: al = character to print
print_char:
  mov ah, 0x0e
  int 0x10
  ret

; -------------------- [ Routine: print_char_at_cursor ] --------------------
; ----------------------- prints a character at cursor ----------------------
; IN: al = character to print
print_char_at_cursor:
  mov ah, 0x0a
  mov bh, 0x00
  mov cx, 0x01
  int 0x10
  ret

; -------------------- [ Routine: print_string ] --------------------
; --------------------------- prints a string ----------------------------
; input: [esp+2] address of string
print_string:
  mov bx, [esp+2] ; read parameter from stack (+2 because 16bit)
  mov ah, 0x0e ; tty
  .loop:
    mov al, [bx]
    int 0x10
    inc bx
    mov dx, [bx]
    test dl, dl
    jne .loop
  ret

; -------------------- [ Routine: print_newline ] --------------------
print_newline:
  mov ah, 0x0e ; tty
  mov al, 10 ;LF
  int 0x10
  mov al, 13 ;CR
  int 0x10
  ret
  
; -------------------- [ Routine: compare_strings ] --------------------
; --------------------------- compares two strings ----------------------------
; input: [esp+4] = string a
; input: [esp+2] = string b
; return: ax = 1(different) or 0 (same)
compare_strings:
  mov cx, 0
  .loop:
    mov bx, [esp+4]
    add bx, cx
    mov dh, [bx] ;dh = a
    mov bx, [esp+2]
    add bx, cx
    mov dl, [bx] ;dl = b
    
    cmp dh, dl
    jne .ret_ne ; not equal
    test dh, dh
    je .ret_eq ; equal (a == b == 0)
    
    inc cx
    jmp .loop
    
  .ret_eq:
    mov ax, 0
    ret
  .ret_ne:
    mov ax, 1
    ret
  ret

; -------------------- [ Routine: parse_string ] --------------------
; -------------------- parses a delimited string --------------------
; input: [esp+6] = input string
; input: [esp+4] = delimiter
; input: [esp+2] = (output) parsed string
; return: ax = current position (at delimiter or null terminator)
parse_string:
  mov dx, [esp+4] ; delim
  mov cx, 0 ; counter
  .loop:
    mov bx, [esp+6] ; input
    add bx, cx
    mov ax, [bx]
    cmp al, dl ; delimiter?
    je .delim
    cmp al, 0x00 ; null terminator?
    je .delim
    ; write to output string
    mov bx, [esp+2] ; output
    add bx, cx
    mov [bx], al
    ; increment counter
    inc cx
    jmp .loop
  .delim:
  mov ax, bx
  ret

; -------------------- [ Routine: print_hex ] --------------------
; ------------ prints the hex representation of a word -----------
; input: [esp+2] = word to print
print_hex:
; print '0x'
  mov al, '0'
  call print_char
  mov al, 'x'
  call print_char
  ; print high nybble
  mov ax, [esp+2]
  shr ax, 4
  call print_nybble_hex
  ; print low nybble
  mov ax, [esp+2]
  and ax, 0x0f
  call print_nybble_hex
  ret



; *** INTERNAL ROUTINES ***

print_nybble_hex:
  cmp al, 0x09
  jg .greater
  .less:
  add al, 48
  call print_char
  ret
  .greater:
  add al, 55
  call print_char
  ret
