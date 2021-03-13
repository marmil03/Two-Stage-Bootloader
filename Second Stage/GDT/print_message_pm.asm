
[bits 32]

VIDEO_MEMORY equ 0xb8000
WHITE_ON_BLACK equ 0x0f

message_print:
  pusha
  call message_print_start
  popa
  ret

do_char: call char_print
message_print_start:
  mov eax, [esi]
  lea esi, [esi+1]
  cmp al,  0
  jne do_char
  add byte [y_pos], 1
  mov byte [x_pos], 0
  ret
char_print:
  mov ah, WHITE_ON_BLACK
  mov ecx, eax
  movzx eax, byte [y_pos]
  mov edx,160
  mul edx
  movzx ebx, byte [x_pos]
  shl ebx, 1

  mov edi, VIDEO_MEMORY
  add edi, eax
  add edi, ebx

  mov eax, ecx
  mov word [ds:edi], ax
  add byte [x_pos], 1
  ret

x_pos db 0
y_pos db 2
