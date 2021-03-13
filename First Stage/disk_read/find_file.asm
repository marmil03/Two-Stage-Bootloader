;%1=file_name %2=load_segment
%macro Find_File 2
  mov ax, %2
  mov es, ax

  mov ax, 32
  xor dx, dx
  mul word [Root_Entries]
  div word [Bytes_Per_Sector]
  mov cx, ax
  mov [root_scts], cx
  ;root_scts is number of sectors in root dir

  ;root_start = FAT_Region+(Number_Of_FATs*Sectors_Per_FAT)
  ;root_start = Reserved_Sectors + Hidden Sectors + (Number_Of_FATs * Sectors_Per_FAT)
  xor ax, ax
  mov al, byte [Number_Of_FATs]
  mov bx, word [Sectors_Per_FAT]
  mul bx
  add ax, word [Hidden_Sectors]
  adc ax, word [Hidden_Sectors+2]
  add ax, word [Reserved_Sectors]
  mov [root_strt], ax
 ;root_strt is now calculated

read_next_sector:
  push cx
  push ax
  xor bx, bx
  call Read_Sector

check_entry:
  mov cx, 11 ;file names are 11 bytes
  mov di, bx ;es:di = dir entry address
  lea si, %1 ;ds:si = address of file name
  repz cmpsb ;compare file name to memory
  je found_file ;if found jump
  add bx, word [32]
  cmp bx, word [Bytes_Per_Sector]
  jne check_entry

  pop ax
  inc ax ;check next sector
  pop cx
  jnz read_next_sector ;loop unitl eather found or not
  jmp boot_failiure    ;file not found

found_file:
  mov ax, es:[bx+0x1a]
  mov [file_strt], ax
%endmacro
