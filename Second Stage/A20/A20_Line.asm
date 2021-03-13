[bits 16]

is_A20_on:
   pushf
   push ds
   push es
   push di
   push si

   cli
   mov ax, 0
   mov es, ax

   not ax
   mov ds, ax

   mov di, 0x0500
   mov si, 0x0510

   mov al, byte [es:di]
   push ax

   mov al, byte [ds:si]
   push ax

   mov byte [es:di], 0x00
   mov byte [ds:si], 0xff

   cmp byte [es:di], 0xff

   pop ax
   mov byte [ds:si], al

   pop ax
   mov byte [es:di], al
   mov ax,0
   je A20_exit
   mov ax, 1

A20_exit:
  pop si
  pop di
  pop es
  pop ds
  popf
  ret
