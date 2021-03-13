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
Drive_Number:          db 0 ;0x00->first floppy drive 0x80->first hdd
Unused:                db 0
Ext_Boot_Signature:    db 0x29
Serial_Number:         dd 0xa1b2c3d4
Volume_Label:          db 'MYVOLUME   ' ;Must be 11 bytes
File_System:           db 'FAT16   '    ;Must be 8 bytes

%include "disk_read/read_sector.asm"
%include "disk_read/read_file.asm"
%include "disk_read/Read_FAT.asm"
%include "disk_read/find_file.asm"
%include "Reboot.asm"

reset_disk_system:
  mov dl, Drive_Number  ;drive to reset
  xor ax, ax            ;subfunction 0
  int 0x13              ;BIOS interrupt
  jc reset_disk_system      ;display error if carry flag is set
  ret

[bits 16]
_main:
  [org 0x7c00]  ;bootloader offset
  mov bp, 0x9000 ;stack base
  mov sp, bp
  call reset_disk_system                       ;reset disk system
  Find_File file_name, SECOND_STAGE_SEGMENT   ;find seconds.img
  Read_FAT  FAT_SEGMENT                       ;load FAT table in memory
  Read_File SECOND_STAGE_SEGMENT, FAT_SEGMENT ;read seconds.img file
  jmp start_second_stage                      ;exectue seconds.img

boot_failiure:
  mov bx, DISK_ERROR_MSG ;show error msg
  call print_message
  call print_new_line
  Reboot                 ;Reboot
  jmp $

start_second_stage:
  mov ax, word [SECOND_STAGE_SEGMENT]
  mov es, ax
  mov ds, ax
  jmp SECOND_STAGE_SEGMENT:0
  jmp $

  %include "boot_sector_print_message.asm"

file_name            db  'SCSTAGE BIN' ;must be 11 bytes long -> 8 bytes for file name, 3 bytes for file exstension, all uppercase
REBOOT_MSG           db  'Press any key to reboot...',0
DISK_ERROR_MSG       db  'Disk read error, press key to reboot',0
SECOND_STAGE_SEGMENT equ 0x1000 ;second stage will be loaded into segment 0x1000
FAT_SEGMENT          equ 0x0ee0 ;boot disk's FAT will be loaded into segment 0x0ee0

root_strt            db 0,0 ;offset of root directory
root_scts            db 0,0 ;sectors in root directory
file_strt            db 0,0 ;offset of bootloader

times 510-($-$$) db 0 ;pad with nulls
dw 0xaa55             ;magic word
