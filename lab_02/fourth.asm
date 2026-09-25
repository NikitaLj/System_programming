format ELF64
public _start
public exit
public print_symb

section '.bss' writable
    place db 0

section '.text' executable
_start:
    mov rax, 5440848234
    xor rbx, rbx

.sum:
    xor rdx, rdx
    mov rsi, 10
    div rsi
    add rbx, rdx
    test rax, rax
    jnz .sum

    mov rax, rbx
    xor rcx, rcx

.push_symb:
    xor rdx, rdx
    mov rsi, 10
    div rsi
    add dl, '0'
    push rdx
    inc rcx
    test rax, rax
    jnz .push_symb

.pop_symb:
    pop rax
    push rcx
    call print_symb
    pop rcx
    dec rcx
    jnz .pop_symb

    mov al, 0xA
    call print_symb
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
    xor ebx, ebx
    int 0x80