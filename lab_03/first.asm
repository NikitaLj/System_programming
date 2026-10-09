format ELF64
public _start

_start:
    mov rsi, [rsp+16]
    movzx eax, byte [rsi]

    call num_to_str
    call print_str
    call exit


exit:
    mov rax, 1
    mov rbx, 0
    int 0x80


print_str:
    push rax
    push rdi
    push rdx
    push rcx

    mov rax, rsi
    call len_str

    mov rdx, rax
    mov rax, 1
    mov rdi, 1
    syscall

    pop rcx
    pop rdx
    pop rdi
    pop rax
    ret


len_str:
    push rdx
    mov rdx, rax
    .iter:
        cmp byte [rax], 0
        je .next
        inc rax
        jmp .iter
    .next:
        sub rax, rdx
        pop rdx
        ret


num_to_str:
    push rbx
    push rcx
    push rdi
    push rax

    mov rdi, buf + 15
    mov byte [rdi], 0

    mov rbx, 10
    xor rcx, rcx

    .convert:
        xor rdx, rdx
        div rbx
        add dl, '0'
        dec rdi
        mov [rdi], dl
        inc rcx
        test eax, eax
        jnz .convert

    mov byte [rdi + rcx], 10
    mov byte [rdi + rcx + 1], 0

    mov rsi, rdi

    pop rax
    pop rdi
    pop rcx
    pop rbx
    ret


section '.bss' writeable
    buf rb 16