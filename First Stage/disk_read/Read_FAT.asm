;%1=fat_segment
%macro Read_FAT 1
  mov ax, %1
  mov es, ax

  mov ax, word [Reserved_Sectors] ;add reserved sectors
  add ax, word [Hidden_Sectors]   ;add hidden sectors
  adc ax, word [Hidden_Sectors + 2]

  mov cx, word [Sectors_Per_FAT]  ;number of sectors per FAT
  xor bx, bx
read_next_fat_sector:
  push cx
  push ax
  call Read_Sector
  pop ax
  pop cx
  inc ax
  add bx, word [Bytes_Per_Sector]
  jnz read_next_fat_sector

%endmacro
