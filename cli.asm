; ***** CLI (Command Line Interface *****

; -------------------- [ Routine: cli_init ] --------------------
; ----------- Initialises the Command Line Interface ------------
cli_init:
  call cli_clear
  ret

; -------------------- [ Routine: cli_user_input ] --------------------
; ----------------------- handles CLI user input ----------------------
cli_user_input:
  call read_keypress
  
  ; handle special scan codes
  cmp al, 0x0d
  je _handle_enter
  cmp ax, SCANCODE_LEFT
  je _handle_bksp
  cmp ax, SCANCODE_RIGHT
  je _handle_right
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
  ret
  
_handle_enter:
  call cli_enter
  ret
_handle_bksp:
  call cli_bksp
  ret
_handle_right:
  ret

cli_enter:
  call print_newline
_cli_test_echo:
  mov bx, INPUT_TEXT
  push bx
  mov bx, STR_CMD_ECHO
  push bx
  call compare_strings
  pop bx
  pop bx
  test ax, ax
  jne _cli_invalid_command
  call cli_echo
  jmp _cli_clear_return
_cli_invalid_command:
  push STR_ERR_INVALCMD
  call print_string
  pop bx
  call print_newline
_cli_clear_return:
  call cli_clear
  ret
  
cli_echo:
  push INPUT_TEXT
  call print_string
  pop bx
  call print_newline
  ret
  
cli_bksp:
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
  ret
  
cli_clear:
  ; reset cursor pos
  mov word [CURSOR_POS], 0x0000
  ; clear input text
  push word INPUT_TEXT
  push 0x0100
  push 0x00
  call memset
  add esp, 6
  ret

STR_CMD_ECHO db "echo",0
STR_ERR_INVALCMD db "Invalid command",0
  
CURSOR_POS dw 0x0000
INPUT_TEXT times 256 dw 0x00

; *** CONSTANTS ***
SCANCODE_LEFT equ 0x4b00
SCANCODE_RIGHT equ 0x4d00
