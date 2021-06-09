# 目的: 创建一个文件向文件写入一串字符串
#        （ 编写程序创建一个名为heynow.txt的文件，并向文件中写入“hey diddle diddle!” ）
#
# 处理过程: (1) 打开名称为 heynow.txt 的文件，选择选项--如果不存在则创建
#          (2) 向文件写入字符串 “hey diddle diddle!”
#            
.section .data
# ###### 常量 ########
# 系统调用号码
    .equ SYS_CLOSE, 6
    .equ SYS_OPEN, 5
    .equ SYS_WRITE, 4
    .equ SYS_READ, 3
    .equ SYS_EXIT, 1
# 文件打开选项 (不同的值请参见 /usr/include/asm/fcntl.h
# 你可以通过选项值想家或者进行OR操作组合使用选项)
# 这将在 10.1.2中深入阐述
    .equ O_RDONLY, 0
    .equ O_CREAT_WRONLY_TRUNC, 03101
# 标准文件描述符
    .equ STDIN, 0
    .equ STDOUT, 1
    .equ STDERR, 2
# 系统调用中断
    .equ LINUX_SYSCALL, 0x80

# 其他，
    .equ DATA_SIZE, 20    
# 栈位置
    .equ ST_FILE_DESCRIPTOR, -4

# # 其他数据项, data_items 是一个指代其后位置的标签
file_name:
    .ascii "heynow.txt\0"

data_str:
    # .ascii 指令用于将字符输入内存，每个字符占用一个存储位置（字符在内部转换成字节）
    .ascii "hey diddle diddle! \0"

.section .text

.globl _start
_start:

    # ### 程序初始化 ###
    # 保存栈指针 (复制栈指针到%ebp)
    movl  %esp, %ebp
    # 在栈上为文件描述符分配空间， 4个字
    subl  $4, %esp

    # ### 打开文件（走系统调用） ###
    movl  $SYS_OPEN, %eax
    # 文件名称移动入 %ebx
    movl  $file_name, %ebx
    # 文件打开选项值移至 %ecx
    movl  $O_CREAT_WRONLY_TRUNC, %ecx   # 本指令表明如果文件不存在则创建
                                        # 并且打开文件用于读写
    # 文件权限
    movl  $0666, %edx                   # 文件权限存入%edx
    # Linux系统调用 
    int   $LINUX_SYSCALL
    # 存储文件描述符到之前栈中的预留位置
    movl  %eax, ST_FILE_DESCRIPTOR(%ebp)
    
    # 向文件写入内容
    # 文件描述符移入寄存器 %ebx
    movl %eax, %ebx
    # 写文件的系统调用号入栈
    movl $SYS_WRITE, %eax
    # 数据内容起始地址移动到 %ecx
    movl $data_str, %ecx
    # 数据内容长度写入 %edc
    movl $DATA_SIZE, %edx
    # 触发系统调用， 将数据写入文件
    int  $LINUX_SYSCALL
  
    # 关闭文件
    movl  $SYS_CLOSE, %eax
    movl  ST_FILE_DESCRIPTOR(%ebp), %ebx
    int   $LINUX_SYSCALL
    
    # 退出程序  exit 系统调用
    movl  $SYS_EXIT, %eax
    movl  $0, %ebx
    int   $LINUX_SYSCALL


# 使用如下命令汇编与链接
# $ as --gstabs -o create.o create.s
# $ as -o create.o create.s
# $ ld -o create create.o
#
