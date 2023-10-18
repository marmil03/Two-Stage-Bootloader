
section .text
  global _main

  jmp _main

%include "../First Stage/bootsector.asm"
%include "../First Stage/disk_read/read_sector.asm"
%include "../First Stage/disk_read/read_file.asm"
%include "../First Stage/disk_read/Read_FAT.asm"
%include "../First Stage/disk_read/find_file.asm"

reset_disk_system:
  mov dl, Drive_Number  ;drive to reset
  xor ax, ax            ;subfunction 0
  int 0x13              ;BIOS interrupt
  jc boot_failiure      ;display error if carry flag is set
  ret

;copy bootsector information
%macro copy_boot_sector 0
  push ds
  xor ax, ax
  mov ds, ax
  mov si, 0x7c03
  lea di, bootsector
  mov cx, 34
  rep movsb
  pop ds
%endmacro

_main:
  [org 0x1000]
  mov bx, MSG
  call print_message

  copy_boot_sector
  Find_File file_name, KERNEL_SEGMENT
  Read_File KERNEL_SEGMENT, FAT_SEGMENT

  call reset_disk_system

  call Enable_A20

  call switch_to_pm

boot_failiure:
  mov bx, DISK_ERROR_MSG ;show error msg
  call print_message
  call print_new_line
  Reboot                 ;Reboot
  jmp $

  %include "../First Stage/boot_sector_print_message.asm"
  %include "A20/A20_Line.asm"
  %include "A20/A20_Enable.asm"
  %include "A20/A20_Checking.asm"
  %include "GDT/GDT.asm"
  %include "GDT/switch_to_protected_mode.asm"
  %include "GDT/print_message_pm.asm"
  %include "jump_to_kernel.asm"

[bits 32]
BEGIN_PM:
  mov esi, MSG_PROTECTED_MODE
  call message_print
;jump to kernel:
  JumpToKernel
  jmp $

file_name          db  'KERNEL  BIN'
MSG                db  'Sucessfully landed in second stage',0
MSG_PROTECTED_MODE db  'Successfully landed in 32-bit Protected Mode',0
REBOOT_MSG         db  'Press any key to reboot...',0
DISK_ERROR_MSG     db  'Disk read error, press key to reboot',0
KERNEL_SEGMENT     equ 0x2000
FAT_SEGMENT        equ 0x0ee0

root_strt          db 0,0 ;offset of root directory
root_scts          db 0,0 ;sectors in root directory
file_strt          db 0,0 ;offset of file
