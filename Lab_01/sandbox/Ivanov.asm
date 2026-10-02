format ELF64
public _start
public exit
public print_symb

section '.data' writable
    msg db "Ivanov Nikita Sergeevich",0
    len = $ - msg
    place db 1

section '.text' executable
_start:
    mov rcx, len
    .iter:
        mov al, [msg + rcx - 1]
        push rcx
        call print_symb
        mov al, 0xA
        call print_symb
        pop rcx
        dec rcx
        cmp rcx, 0
    jne .iter
    call exit
    

print_symb:
        push rax
        mov eax, 4
        mov ebx, 1
        pop rdx
        mov [place], dl
        mov ecx, place
        mov edx, 1
        int 0x80
        ret

exit:
    mov eax, 1
    mov ebx, 0
    int 0x80