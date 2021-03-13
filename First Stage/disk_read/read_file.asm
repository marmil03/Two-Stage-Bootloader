;%1 load_segment %2 fat_segment
%macro Read_File 2
  ;set memory segment that will receive the file
  mov ax, %1
  mov es, ax
  ;set memory offset to 0
  xor bx, bx
  ;set memory segment for FAT
  mov cx, file_strt

read_file_next_sector:
  mov ax, cx        ;sector to read is equal to current FAT entry
  add ax, root_strt ;plus start of root dir
  add ax, root_scts ;plus root dir size
  sub ax, 2         ;minus 2

  ;Read Sector
  push cx
  call Read_Sector
  pop cx
  add bx, Bytes_Per_Sector ;move mem pointer to next section

  push ds
  mov dx, %2    ;make ds:si point to FAT table
  mov ds, dx

  mov si, cx    ;move si pointer to curent FAT table
  mov dx, cx    ;offset is entry value*1.5 bytes
  shr dx, 0x0001
  add si, dx

  mov dx, ds:[si] ;Read fat entry from memory
  test dx, 1      ;set which way to shift
  jz read_next_file_even
  and dx, 0x0fff
  jmp read_next_file_cluster_done
read_next_file_even:
  shr dx, 4
read_next_file_cluster_done:
  pop ds
  mov cx, dx    ;store new FAT entry
  cmp cx, 0xff8 ;if FAT entry is >=0xffe then we reached EOF
  jl read_file_next_sector
%endmacro
