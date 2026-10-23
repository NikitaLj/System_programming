format elf64
public _start

include 'func.asm'

section '.bss' writable

Struc stat
{
  .st_dev dq ?
  .st_ino dq ?
  .st_nlink dq ?
  .st_mode dd ?
  .st_uid dd ?
  .st_gid dd ?
  .st_rdev dq ?
  .st_res_1 dd ?
  .st_size dq ?
  .st_blksize dq ?
  .st_blocks dq ?
  .st_atime dq ?
  .st_atime_nsec dq ?
  .st_mtime dq ?
  .st_mtime_nsec dq ?
  .st_ctime dq ?
  .st_ctime_nsec dq ?
  .st_unused rq 3
}

dents rb 4096
path rb 4200
rnd rb 1
mystat stat

section '.text' executable

_start:
   pop rcx
   cmp rcx, 2
   jne .l1

   mov r14, [rsp+8]

   mov rsi, r14
   mov rdi, path
.copy_dir:
   mov al, [rsi]
   cmp al, 0
   je .copy_dir_done
   mov [rdi], al
   inc rsi
   inc rdi
   jmp .copy_dir
.copy_dir_done:
   mov byte [rdi], '/'
   inc rdi
   mov r9, rdi

   mov rax, 2
   mov rdi, r14
   mov rsi, 0o
   syscall
   cmp rax, 0
   jl .l1
   mov r8, rax

.read_dir:
   mov rax, 217
   mov rdi, r8
   mov rsi, dents
   mov rdx, 4096
   syscall
   cmp rax, 0
   jle .close
   mov r12, rax
   xor r13, r13

.entry:
   cmp r13, r12
   jge .read_dir
   lea r15, [dents+r13]
   movzx rax, word [r15+16]
   add r13, rax

   lea rsi, [r15+19]
   mov rdi, r9
.copy_name:
   mov al, [rsi]
   mov [rdi], al
   inc rsi
   inc rdi
   cmp al, 0
   jne .copy_name

   mov rax, 4
   mov rdi, path
   mov rsi, mystat
   syscall
   cmp rax, 0
   jl .entry

   mov eax, dword [mystat.st_mode]
   and eax, 0xF000
   cmp eax, 0x8000
   jne .entry

   mov rax, 318
   mov rdi, rnd
   mov rsi, 1
   mov rdx, 0
   syscall
   test byte [rnd], 1
   jz .entry

   mov rax, 76
   mov rdi, path
   mov rsi, [mystat.st_size]
   shl rsi, 1
   syscall
   jmp .entry

.close:
   mov rdi, r8
   mov rax, 3
   syscall

.l1:
   call exit