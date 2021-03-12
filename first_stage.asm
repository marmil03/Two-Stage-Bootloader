section .text
  global _main

  jmp _main

;***************************************************
;     OEM Parameter Block/BIOS Parameter Block
;***************************************************
Bytes_Per_Sector:      dw 512
Sectors_Per_Cluster:   db 1
Reserved_Sectors:      dw 1
Number_Of_FATs:        db 2
Root_Entries:          dw 224
Total_Sectors:         dw 2880
Media:                 db 0xf0
Sectors_Per_FAT:       dw 9
Sectors_Per_Track:     dw 18
Heads_Per_Cylinder:    dw 2
Hidden_Sectors:        dd 0
Total_Sectors_Big:     dd 0
Drive_Number:          db 0
Unused:                db 0
Ext_Boot_Signature:    db 0x29
Serial_Number:         dd 0xa1b2c3d4
Volume_Label:          db 'MYVOLUME   ' ;Must be 11 bytes
File_System:           db 'FAT16   '    ;Must be 8 bytes

%include "read_sector.asm"
%include "read_file.asm"
%include "Read_FAT.asm"
%include "find_file.asm"
%include "Reboot.asm"

%macro reset_disk_system 0
  mov dl, Drive_Number
  xor ax, ax
  int 0x13
  jc boot_failiure
%endmacro

[bits 16]
_main:
  [org 0x7c00]
  mov bp, 0x9000
  mov sp, bp
  reset_disk_system
  Find_File file_name, SECOND_STAGE_SEGMENT
  Read_FAT  FAT_SEGMENT
  Read_File SECOND_STAGE_SEGMENT, FAT_SEGMENT
  jmp start_second_stage

boot_failiure:
  mov bx, DISK_ERROR_MSG
  call print_message
  call print_new_line
  Reboot
  jmp $

start_second_stage:
  mov ax, word [SECOND_STAGE_SEGMENT]
  mov es, ax
  mov ds, ax
  jmp SECOND_STAGE_SEGMENT:0
  jmp $

  %include "boot_sector_print_message.asm"

file_name            db  'first_stageimg'
REBOOT_MSG           db  'Press any key to reboot...',0
DISK_ERROR_MSG       db  'Disk read error, press key to reboot',0

SECOND_STAGE_SEGMENT equ 0x1000
FAT_SEGMENT          equ 0x0ee0

root_strt            db 0,0
root_scts            db 0,0
file_strt            db 0,0

times 510-($-$$) db 0
dw 0xaa55
