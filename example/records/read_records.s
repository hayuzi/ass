.include "linux32.s"
.include "record_def.s"

.section .data
file_name:
    .ascii "test.dat\0"

.section .bss
    .lcomm record_buffer, RECORD_SIZE

.section .text

# 主程序
.globl _start
_start:
    # 这些是我们将存储输入输出描述符的栈位置
    # ( 仅供参考 - 也可以使用一个 .data 段中的内存地址代替
    # a .data section instead)
    .equ ST_INPUT_DESCRIPTOR, -4
    .equ ST_OUTPUT_DESCRIPTOR, -8
    
    # 复制栈指针到 %ebp
    movl  %esp, %ebp
    # 为保存文件描述符分配空间
    subl  $8, %esp

    # 打开文件
    movl  $SYS_OPEN, %eax
    movl  $file_name, %ebx
    movl  $0, %ecx    # 这表示只读打开
    movl  $0666, %edx
    int   $LINUX_SYSCALL
    
    # 保存文件描述符
    movl  %eax, ST_INPUT_DESCRIPTOR(%ebp)
    # 即使输出文件描述符是常数，我们也将其保存到本地变量
    # 这样如果稍后决定不将其输出到STDOUT，很容易加以更改
    movl  $STDOUT, ST_OUTPUT_DESCRIPTOR(%ebp)
    
record_read_loop:
    pushl ST_INPUT_DESCRIPTOR(%ebp)
    pushl $record_buffer
    call  read_record
    addl  $8, %esp
    # 返回读取的字节数.
    # 如果字节数与我们请求的字节数不同，
    # 说明已经到达文件结束处或出现错误，
    # 我们就要退出
    cmpl  $RECORD_SIZE, %eax
    jne   finished_reading

    # 否则，打印出名，但我们首先必须知道名的大小
    pushl  $RECORD_FIRSTNAME + record_buffer    # 这个结构 由于两者都是汇编程序知道的常数，
                                                # 因此汇编程序在实际汇编的时候能将两者相加，
                                                # 这样整个指令就只是立即寻址方式的单个常量入栈
    call   count_chars
    addl   $4, %esp
    movl   %eax, %edx
    movl   ST_OUTPUT_DESCRIPTOR(%ebp), %ebx
    movl   $SYS_WRITE, %eax
    movl   $RECORD_FIRSTNAME + record_buffer, %ecx
    int    $LINUX_SYSCALL
    pushl  ST_OUTPUT_DESCRIPTOR(%ebp)
    call   write_newline
    addl   $4, %esp
    jmp    record_read_loop
finished_reading:
    movl   $SYS_EXIT, %eax
    movl   $0, %ebx
    int    $LINUX_SYSCALL