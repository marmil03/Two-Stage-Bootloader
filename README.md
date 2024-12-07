# Two-Stage Bootloader
Two stage bootloader that can jump to an x86 kernel. \
First stage contains initial setup and is used only for jumping to second stage. \
Second stage contains all other initialization neccessary to enable a long jump to x86 kernel. \
Some operations performed in second stage are: \
enabling A20 line, setting up Global Descriptor Table (GDT), enabling protected mode and final jump to the kernel \
Start date: 10.02.2021.\
End   date: 13.03.2021.
