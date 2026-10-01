format ELF64
public _start

; ============ ТОЧКА ВХОДА ============
_start:
    mov rsi, [rsp + 16]      ; rsi = адрес argv[1]
    movzx eax, byte [rsi]    ; eax = ASCII-код символа

    call num_to_str          ; eax → строка в buf, rsi = адрес
    call print_str           ; напечатать строку из rsi
    call exit                ; выход


; ============ ВЫХОД ============
exit:
    mov rax, 1
    mov rbx, 0
    int 0x80


; ============ ПЕЧАТЬ СТРОКИ ============
; вход: rsi — адрес строки (конец помечен нулём)
print_str:
    push rax
    push rdi
    push rdx
    push rcx

    mov rax, rsi
    call len_str             ; rax = длина

    mov rdx, rax             ; rdx = длина
    mov rax, 1               ; write
    mov rdi, 1               ; stdout
    syscall

    pop rcx
    pop rdx
    pop rdi
    pop rax
    ret


; ============ ДЛИНА СТРОКИ ============
; вход: rax — адрес строки
; выход: rax — длина
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


; ============ ЧИСЛО → СТРОКА ============
; вход:  eax — число (например 65)
; выход: rsi — адрес строки
; (в конце строки добавляется \n и нулевой терминатор)
num_to_str:
    push rbx
    push rcx
    push rdi
    push rax

    mov rdi, buf + 15        ; пишем с конца буфера
    mov byte [rdi], 0        ; нулевой терминатор для len_str

    mov rbx, 10              ; делим на 10
    xor rcx, rcx             ; счётчик цифр

    .convert:
        xor rdx, rdx
        div rbx              ; eax/10 → eax, остаток в edx
        add dl, '0'          ; цифра → символ
        dec rdi
        mov [rdi], dl
        inc rcx
        test eax, eax
        jnz .convert

    ; дописываем перевод строки
    mov byte [rdi - 1], 10   ; '\n' перед числом
    dec rdi

    mov rsi, rdi             ; rsi = начало строки

    pop rax
    pop rdi
    pop rcx
    pop rbx
    ret


section '.bss' writeable
    buf rb 16