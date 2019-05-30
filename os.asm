[org 0x9000]

mov bp, 0x8000

; TEST: memset two bytes of the welcome message
push word STR_WELCOME_MESSAGE
push 0x0002
push 0x26
call memset
pop ax
pop ax
pop ax

; show welcome message
mov bx, STR_WELCOME_MESSAGE
push bx
call print_string
pop bx

call print_newline


; read user input - TODO: move to separate file? (make re-usable functions/labels?)
_user_input:
  ; reset relative cursor pos and input text
  mov word [CURSOR_POS], 0x0000
  mov word [INPUT_TEXT], 0x0000  ; TODO: make memcpy function !!! (clear 256 bytes)
_user_input_start:
  call read_keypress
  
  ; handle special scan codes
  cmp al, 0x0d
  je _handle_enter
  cmp ax, SCANCODE_LEFT
  je _handle_left
  cmp ax, SCANCODE_RIGHT
  je _handle_right
  cmp al, 0x08
  je _handle_bksp
  
  ; print (if not special scan code)
  call print_char
  jmp _user_input_start
  
  ; move cursor left
_handle_left:
  call move_cursor_left
  jmp _loop
  ; move cursor right
  
_handle_right:
  call move_cursor_right
  jmp _loop
  ; execute
_handle_bksp:
  call move_cursor_left
  mov al, ' '
  call print_char_at_cursor
  jmp _loop
_handle_enter:
  call print_newline
  mov bx, STR_CMD_ECHO
  push bx
  mov bx, STR_CMD_ECHO
  push bx
  call compare_strings
  pop bx
  pop bx
  test ax, ax
  je _handle_match
  mov al, 'n'
  call print_char
  call _loop
_handle_match:
  mov al, 'y'
  call print_char
_loop:
  jmp _user_input_start

; infinite loop
jmp $

%include "io.asm"
%include "text.asm"
%include "memory.asm"

STR_CMD_ECHO db "echo",0

STR_WELCOME_MESSAGE db "******* MingOS *******", 0x0a, 0x0d,\
                   "Welcome to MingOS!",0 ; null-terminated (,0) and with LF (0x0a) and CR (0x0d)


CURSOR_POS dw 0x0000
INPUT_TEXT times 256 dw 0x00
                   
; boot sector = sector 1 of cyl 0 of head 0 of hdd 0
; from now on = sector 2 ...
times 256 dw 0xdada ; sector 2 = 512 bytes
times 256 dw 0xface ; sector 3 = 512 bytes

; *** CONSTANTS ***
SCANCODE_LEFT equ 0x4b00
SCANCODE_RIGHT equ 0x4d00
