%macro Reboot 0
  mov bx, REBOOT_MSG
  call print_message
  xor ax, ax
  int 0x16

  db 0xEA
  dw 0x0000
  dw 0xffff
%endmacro
