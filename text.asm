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
  _print_string_loop:
    mov al, [bx]
    int 0x10
    inc bx
    mov dx, [bx]
    test dl, dl
    jne _print_string_loop
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
  _compare_string_loop:
    mov bx, [esp+4]
    add bx, cx
    mov dh, [bx] ;dh = a
    mov bx, [esp+2]
    add bx, cx
    mov dl, [bx] ;dl = b
    
    cmp dh, dl
    jne _compare_string_ret_ne ; not equal
    test dh, dh
    je _compare_string_ret_eq ; equal (a == b == 0)
    
    inc cx
    jmp _compare_string_loop
    
  _compare_string_ret_eq:
    mov ax, 0
    ret
  _compare_string_ret_ne:
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
  _parse_string_loop:
    mov bx, [esp+6] ; input
    add bx, cx
    mov ax, [bx]
    cmp al, dl ; delimiter?
    je _parse_string_delim
    cmp al, 0x00 ; null terminator?
    je _parse_string_delim
    ; write to output string
    mov bx, [esp+2] ; output
    add bx, cx
    mov [bx], al
    ; increment counter
    inc cx
    jmp _parse_string_loop
  _parse_string_delim:
  mov ax, bx
  ret
