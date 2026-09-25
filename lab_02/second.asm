format ELF64
public _start
public exit
public print_symb

section '.bss' writable
    array db 325 dup ('!')
    place db 1

section '.text' executable
_start:
    xor rcx, rcx
    xor rbx, rbx
    .iter:
        mov al, [array + rcx]
        push rcx
        push rbx
        call print_symb
        pop rbx
        pop rcx
        inc rbx
        cmp rbx, 13
        jne .check_max
            push rcx
            push rbx
            mov al, 0xA
            call print_symb
            pop rbx
            pop rcx
            xor rbx, rbx
        .check_max:
        inc rcx
        cmp rcx, 325
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