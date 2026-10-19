format elf64
public _start

include 'func.asm'

section '.data' writable

buffer rb 1
vowels db 'AEIOUY'

section '.text' executable

_start:
   pop rcx
   cmp rcx, 3
   jne .l1

   mov rdi,[rsp+8]
   mov rax, 2
   mov rsi, 0o
   syscall
   cmp rax, 0
   jl .l1
   mov r8, rax

   mov rdi,[rsp+16]
   mov rax, 2
   mov rsi, 577
   mov rdx, 777o
   syscall
   cmp rax, 0
   jl .l1
   mov r9, rax

.loop_read:
   mov rax, 0
   mov rdi, r8
   mov rsi, buffer
   mov rdx, 1
   syscall
   cmp rax, 0
   je .next

   mov al, [buffer]
   mov rdi, vowels
   mov rcx, 6
   repne scasb
   je .loop_read
   mov rax, 1
   mov rdi, r9
   mov rsi, buffer
   mov rdx, 1
   syscall
   jmp .loop_read

.next:
   mov rdi, r8
   mov rax, 3
   syscall
   mov rdi, r9
   mov rax, 3
   syscall

.l1:
   call exit