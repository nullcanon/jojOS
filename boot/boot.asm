    org 0x7c00
BaseOfStack equ 0x7c00

;BIOS 会加载引导程序到内存0x7c00处
;   因此，让栈指针寄存器sp指向 0x7c00
;BIOS跳转时，cs寄存器的值时0x0000，表示段基地址
Label_Start:

    mov ax, cs
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, BaseOfStack 
    
;下面的程序主要是调用BIOS中断服务程序 INT 10h 来操作屏幕
;======= 清屏
    mov ax, 0600h
    mov bx, 0700h
    mov cx, 0
    mov dx, 0184fh
    int 10h
;======= 设置光标
    mov ax, 0200h
    mov bx, 0000h
    mov dx, 0000h
    int 10h
;======= 在屏幕显示：Start Booting
    mov ax, 1301h
    mov bx, 000fh
    mov dx, 0000h
    mov cx, 10
    push ax
    mov ax, ds
    mov es, ax
    pop ax
    mov bp, StartBootMessage
    int 10h

;调用 INT 13h 复位软盘磁头
    xor ah, ah
    xor dl, dl
    int 13h
;$表示当前行被编译后的地址，因此下面表示死循环
    jmp $ 

    StartBootMessage: db    "Start Boot"

;510字节剩下的填充为0，最后两个字节蛇者为0xaa55
    times 510 - ($ - $$)    db  0
    dw  0xaa55