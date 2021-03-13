;GDT - Global Descriptor Table
gdt_start:

;null descriptor
gdt_null:
  dd 0x0
  dd 0x0

gdt_code: ;code segment descriptor
  ;base 0x0, limit=0xfffff
  ;1st flags: (present) 1  (privilege) 00  (descriptor type) 1 ->1001b
  ;type flags: (code) 1 (conforming) 0 (readable) 1 (accessed) 0 ->1010b
  ;2nd flags: (granularity) 1 (32-bit default) 1 (64-bit segment) 0 (AVL) 0->1100b
  dw 0xffff     ;Limit (0-15)
  dw 0x0        ;Base  (0-15)
  db 0x0        ;Base  (16-23)
  db 10011010b  ;1st flags, type flags
  db 11001111b  ;2nd flags, Limit(16-19)
  db 0x0        ;Base  (bits 24-31)

gdt_data: ;data segment descriptor
  ;type flags (code)0 (expand down) 0 (writable) 1 (accessed) 0 ->0010b
  dw 0xffff
  dw 0x0
  db 0x0
  db 10010010b
  db 11001111b
  db 0x0

gdt_end: ;Label is used for calculating the size of GDT for GDT descriptor

;GDT descriptor
gdt_descriptor:
  dw gdt_end - gdt_start - 1 ;Size of GDT

  dd gdt_start ;Start address

;Constants for GDT offsets
CODE_SEGMENT equ gdt_code - gdt_start
DATA_SEGMENT equ gdt_data - gdt_start
