format ELF64
public _start

_start:
    mov rsi, [rsp + 16]
    call str_to_int
    mov r12, rax

    mov rsi, [rsp + 24]
    call str_to_int
    mov r13, rax

    mov rsi, [rsp + 32]
    call str_to_int
    mov r14, rax

    mov rax, r13
    xor rdx, rdx
    div r12

    add rax, r14
    sub rax, r12

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
        test rax, rax
        jnz .convert

    mov byte [rdi + rcx], 10
    mov byte [rdi + rcx + 1], 0

    mov rsi, rdi

    pop rax
    pop rdi
    pop rcx
    pop rbx
    ret


str_to_int:
    xor rax, rax
    mov rbx, 10

    .loop:
        movzx rcx, byte [rsi]
        cmp rcx, 0
        je .done
        cmp rcx, '0'
        jl .next
        cmp rcx, '9'
        jg .next

        sub rcx, '0'
        imul rax, rbx
        add rax, rcx

    .next:
        inc rsi
        jmp .loop

    .done:
        ret


section '.bss' writeable
    buf rb 32