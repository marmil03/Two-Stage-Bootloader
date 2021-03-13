section .text
  global _main

  jmp _main

%include "bootsector.asm"
%include "disk_read/read_sector.asm"
%include "disk_read/read_file.asm"
%include "disk_read/Read_FAT.asm"
%include "disk_read/find_file.asm"
%include "Reboot.asm"

reset_disk_system:
  mov dl, Drive_Number  ;drive to reset
  xor ax, ax            ;subfunction 0
  int 0x13              ;BIOS interrupt
  jc boot_failiure      ;display error if carry flag is set
  ret

[bits 16]
_main:
  [org 0x7c00]  ;bootloader offset
  mov bp, 0x9000 ;stack base
  mov sp, bp
  call reset_disk_system                       ;reset disk system
  Find_File file_name, SECOND_STAGE_SEGMENT   ;find scstage.bin
  Read_FAT  FAT_SEGMENT                       ;load FAT table in memory
  Read_File SECOND_STAGE_SEGMENT, FAT_SEGMENT ;read scstage.bin file
  jmp start_second_stage                      ;exectue scstage.bin

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
