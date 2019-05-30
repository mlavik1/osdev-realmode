[org 0x9000]

mov bp, 0x8000

; show welcome message
push STR_WELCOME_MESSAGE
call print_string
pop bx

call print_newline

; read user input - TODO: move to separate file? (make re-usable functions/labels?)
_user_input:
  ; reset relative cursor pos and input text
  mov word [CURSOR_POS], 0x0000
  push word INPUT_TEXT
  push 0x0100
  push 0x00
  call memset
  add esp, 4
_user_input_start:
  call read_keypress
  
  ; handle special scan codes
  cmp al, 0x0d
  je _handle_enter
  cmp ax, SCANCODE_LEFT
  je _handle_bksp
  cmp ax, SCANCODE_RIGHT
  je _loop
  cmp al, 0x08
  je _handle_bksp
  
  ; print (if not special scan code)
  call print_char
  ; store character
  mov dx, [CURSOR_POS]
  mov bx, INPUT_TEXT
  add bx, dx
  mov byte [bx], al
  ; increment cursor pos
  inc dx
  mov [CURSOR_POS], dx
  ; loop
  jmp _user_input_start
  
  ; execute
_handle_bksp:
  call move_cursor_left
  mov al, ' '
  call print_char_at_cursor
  ; decrement cursor pos
  mov dx, [CURSOR_POS]
  dec dx
  mov [CURSOR_POS], dx
  ; erase character
  mov bx, INPUT_TEXT
  add bx, dx
  mov word [bx], 0x00
  jmp _loop
  
_handle_enter:
  call print_newline
_test_echo:
  mov bx, INPUT_TEXT
  push bx
  mov bx, STR_CMD_ECHO
  push bx
  call compare_strings
  pop bx
  pop bx
  test ax, ax
  jne _invalid_command
  call echo
  jmp _user_input
_invalid_command:
  push STR_ERR_INVALCMD
  call print_string
  pop bx
  call print_newline
  jmp _user_input
_loop:
  jmp _user_input_start

; infinite loop
jmp $

echo:
  push INPUT_TEXT
  call print_string
  pop bx
  call print_newline
  ret

%include "io.asm"
%include "text.asm"
%include "memory.asm"

STR_CMD_ECHO db "echo",0
STR_ERR_INVALCMD db "Invalid command",0

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
