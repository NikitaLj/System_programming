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
    mov rbx, 1
    xor r8, r8

.line:
    cmp rcx, 325
    jge .done

    mov al, [array + rcx]
    push rcx
    push rbx
    push r8
    call print_symb
    pop r8
    pop rbx
    pop rcx

    inc rcx
    inc r8

    cmp r8, rbx
    jne .line

        push rcx
        push rbx
        push r8
        mov al, 0xA
        call print_symb
        pop r8
        pop rbx
        pop rcx

        xor r8, r8
        inc rbx
        jmp .line

.done:
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