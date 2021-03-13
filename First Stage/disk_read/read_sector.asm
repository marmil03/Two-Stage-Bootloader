Read_Sector:
  xor cx, cx

Read:
  push ax
  push cx
  push bx

  mov bx, Sectors_Per_Track
  xor dx, dx
  div bx

  inc dx
  mov cl, dl

  mov bx, Heads_Per_Cylinder
  xor dx, dx
  div bx

  mov ch, al
  xchg dl, dh

  mov ax, 0x0201
  mov dl, Drive_Number
  pop bx
  int 0x13
  jc read_failed
  pop cx
  pop ax
  ret

read_failed:
  pop cx
  inc cx
  cmp cx, 4
  je boot_failiure

  xor ax, ax
  int 0x13

  pop ax
  jmp Read
