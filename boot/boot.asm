org 0
bits 16

; faked bios parameter block since running on real hardware.
; https://wiki.osdev.org/FAT#BPB_.28BIOS_Parameter_Block.29
_start:
     jmp short start
     nop

times 33 db 0

start:
     jmp 0x7c0:init
init:
     cli ; clear interrupts
     mov ax, 0x7c0
     mov ds, ax
     mov es, ax
     mov ax, 0x00
     mov ss, ax
     mov sp, 0x7c00
     sti ; enable interrupts

     mov si, message
     call print
     jmp $

print:
     mov bx, 0
.loop:
     lodsb
     cmp al, 0
     je .done
     call print_char
     jmp .loop
.done:
     ret

print_char:
     mov ah, 0eh
     int 0x10
     ret

message: db 'Hello World!', 0

times 510-($ - $$) db 0
dw 0xAA55
