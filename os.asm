[org 0x9000]

mov bp, 0x8000

; show welcome message
push STR_WELCOME_MESSAGE
call print_string
pop bx

call print_newline

call cli_init
_user_input:

  call cli_user_input
  jmp _user_input
  
; infinite loop
jmp $


%include "io.asm"
%include "text.asm"
%include "memory.asm"
%include "cli.asm"

STR_WELCOME_MESSAGE db "******* MingOS *******", 0x0a, 0x0d,\
                   "Welcome to MingOS!",0 ; null-terminated (,0) and with LF (0x0a) and CR (0x0d)


; boot sector = sector 1 of cyl 0 of head 0 of hdd 0
; from now on = sector 2 ...
times 256 dw 0xdada ; sector 2 = 512 bytes
times 256 dw 0xface ; sector 3 = 512 bytes
