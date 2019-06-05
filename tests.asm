test_disk_io:
  push 0x80 ; drive
  push 0x04 ; sector
  push 0x00 ; cylinder
  push 0x00 ; head
  push 0x01 ; num sectors
  push STR_DISK_IO_TEST
  call write_disk_chs
  pop ax
  push DISK_READ_TEST
  call read_disk_chs
  add esp, 12
  push DISK_READ_TEST
  call print_string
  pop bx
  ret

DISK_READ_TEST times 256 db 0x00
STR_DISK_IO_TEST db "(Disk IO test)", 0