format elf64
public _start

include 'func.asm'

section '.data' writable

buffer rb 1
letters db 'BCDFGHJKLMNPQRSTVWXYZbcdfghjklmnpqrstvwxyz'
letters1 db 'AEYUOI'

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

   call write_buffer
   mov al, [buffer]
   cmp al, 'a'
   jb  .check_vowel
   cmp al, 'z'
   ja  .check_vowel
   sub al, 32

.check_vowel:
   mov rdi, letters1
   mov rcx, 12
   repne scasb
   je .loop_read
   mov al, [buffer]
   cmp al, 'A'
   jmp .check_lower
   cmp al, 'Z'
   jbe .is_letter

.check_lower:
   cmp al, 'a'
   jb .not_letter
   cmp al, 'z'
   jbe .is_letter

.not_letter:
   jmp .loop_read     

.is_letter:
   call write_buffer
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

write_buffer:
   mov rax, 1
   mov rdi, r9
   mov rsi, buffer
   mov rdx, 1
   syscall
   ret