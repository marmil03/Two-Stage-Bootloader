[bits 16]

Enable_A20:
  call is_A20_on
  cmp ax, 0
  jne A20_Enabled

  call A20_BIOS
  call is_A20_on
  cmp ax, 0
  jne A20_Enabled

  call A20_Keyboard_Controller
  call is_A20_on
  cmp ax, 0
  jne A20_Enabled

  call A20_Fast_Gate
  call is_A20_on
  xchg bx, bx
  cmp ax, 0
  jne A20_Enabled

  mov bx, MSG_A20_UNAVAILABLE
  call print_message
  call print_new_line
end:
  ret

A20_Enabled:
  mov bx, MSG_A20_ON
  call print_message
  call print_new_line
  jmp end

MSG_A20_ON          db 'A20 is activated'  , 0
MSG_A20_UNAVAILABLE db 'A20 is unavailable', 0
