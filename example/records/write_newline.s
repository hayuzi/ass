# 写一个换行符到 STDOUT
.include "linux32.s"

.globl write_newline
.type write_newline, @function

.section .data

newline:
    .ascii "\n"

.section .text
    .equ ST_FILEDES, 8

write_newline:
    pushl %ebp
    movl  %esp, %ebp
    movl  $SYS_WRITE, %eax
    movl  ST_FILEDES(%ebp), %ebx
    movl  $newline, %ecx
    movl  $1, %edx
    int   $LINUX_SYSCALL
    movl  %ebp, %esp
    popl  %ebp
    ret