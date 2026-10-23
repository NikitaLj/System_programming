format elf64
public _start

include 'func.asm'

section '.data' writable

buffer rb 100
space db ' ', 0

section '.text' executable

_start:
   pop rcx
   cmp rcx, 4
   jne .l1

   mov rsi, [rsp+8]
   call str_number
   mov r12, rax

   mov rsi, [rsp+16]
   call str_number
   mov r13, rax

   mov rsi, [rsp+24]
   call str_number
   mov r14, rax

   mov r8, 1

.loop_x:
   cmp r8, r13
   jg .l1

   mov rax, r8
   mul r8
   mul r12
   inc rax
   mov r10, rax

   mov r9, 1
.loop_y:
   cmp r9, r14
   jg .next_x
   mov rax, r9
   mul r9
   cmp rax, r10
   je .found
   ja .next_x
   inc r9
   jmp .loop_y

.found:
   mov rax, r8
   mov rsi, buffer
   call number_str
   call print_str
   mov rsi, space
   call print_str
   mov rax, r9
   mov rsi, buffer
   call number_str
   call print_str
   call new_line

.next_x:
   inc r8
   jmp .loop_x

.l1:
   call exit