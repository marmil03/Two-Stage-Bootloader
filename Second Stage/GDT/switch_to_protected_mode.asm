[bits 16]

switch_to_pm:
  cli ;switch off interupts

  lgdt [gdt_descriptor] ;load GDT

  mov eax, cr0  ;set the first bit of CR0
  or  eax, 0x1
  mov cr0, eax

  jmp CODE_SEGMENT:init_pm ;make a far jump,forces CPU to flush cache and pre-fetched and real-mode instructions

[bits 32]
init_pm:
  mov ax, DATA_SEGMENT ;In protected mode old segments are meaningless, point segment registers to the data selector in GDT
  mov ds, ax
  mov ss, ax
  mov es, ax
  mov fs, ax
  mov gs, ax

  mov ebp, 0x90000 ;Update stack position
  mov esp, ebp

  call BEGIN_PM
