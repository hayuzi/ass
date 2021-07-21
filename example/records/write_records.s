.include "linux32.s"
.include "record_def.s"

.section .data
# 我们想写入的常量数据
# 每个数据项以空字节（0）填充到适当的长度
# 
# .rept 用于填充每一项  .rept 告诉汇编程序将
# .rept 和 .endr 之间的段重指定次数.
# 在这个过程中，此指令用于将多余的空白字符
# 增加到每个字段末尾以将之填满
record1:
    .ascii "Fredrick\0"
    .rept 31    # 填充到40字节
    .byte 0
    .endr
    .ascii "Bartlett\0"
    .rept 31    # 填充到40字节
    .byte 0
    .endr
    .ascii "4242 S Prairie\nTulsa, OK 55555\0"
    .rept 209   # 填充到240字节
    .byte 0
    .endr
    .long 45
    
record2:
    .ascii "Marilyn\0"
    .rept 32    # 填充到40字节
    .byte 0
    .endr
    .ascii "Taylor\0"
    .rept 33    # 填充到40字节
    .byte 0
    .endr
    .ascii "2224 S Johannan St\nChicago, IL 12345\0"
    .rept 203   # 填充到240字节
    .byte 0
    .endr
    .long 29
    
record3:
    .ascii "Derrick\0"
    .rept 32    # 填充到40字节
    .byte 0
    .endr
    .ascii "McIntire\0"
    .rept 31    # 填充到40字节
    .byte 0
    .endr
    .ascii "500 W Oakland\nSan Diego, CA 54321\0"
    .rept 206   # 填充到240字节
    .byte 0
    .endr
    .long 36
    
# 这是我们要写入文件的文件名
file_name:
    .ascii "test.dat\0"
    .equ ST_FILE_DESCRIPTOR, -4
    
.globl _start
_start:
    # 复制栈指针到 %ebp
    movl  %esp, %ebp
    # 为文件描述符分配空间
    subl  $4, %esp
    # 打开文件
    movl  $SYS_OPEN, %eax
    movl  $file_name, %ebx
    movl  $0101, %ecx       # 本指令表明如果文件不存在则创建，并打开文件用于写入

    movl  $0666, %edx
    int   $LINUX_SYSCALL
    # 存储文件描述符
    movl  %eax, ST_FILE_DESCRIPTOR(%ebp)
    # 写第一条记录
    pushl ST_FILE_DESCRIPTOR(%ebp)
    pushl $record1
    call  write_record
    addl  $8, %esp

    # 写第二条记录
    pushl ST_FILE_DESCRIPTOR(%ebp)
    pushl $record2
    call  write_record
    addl  $8, %esp
    
    # 写第三条记录
    pushl ST_FILE_DESCRIPTOR(%ebp)
    pushl $record3
    call  write_record
    addl  $8, %esp

    # 关闭文件描述符
    movl  $SYS_CLOSE, %eax
    movl  ST_FILE_DESCRIPTOR(%ebp), %ebx
    int   $LINUX_SYSCALL
    
    # 退出程序
    movl  $SYS_EXIT, %eax
    movl  $0, %ebx
    int   $LINUX_SYSCALL