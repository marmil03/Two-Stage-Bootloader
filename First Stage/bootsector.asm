;***************************************************
;     OEM Parameter Block/BIOS Parameter Block
;***************************************************
bootsector:
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
