.include "linux.s"
.include "record_def.s"
# 目的:   本函数从文件描述符读取一条记录
#
# 输入:   文件描述符和缓冲区
#
# 输出:   本删除将数据写入缓冲区，并返回状态码
#
# 栈局部变量
.equ ST_READ_BUFFER, 8
.equ ST_FILEDES, 12

.section .text

.globl read_record

.type read_record, @function

read_record:
    pushl %ebp              # 标准函数 - 我们必须在返回前
                            # 恢复 %ebp 到其之前的状态
                            # 因此我们必须将其入栈
    movl  %esp, %ebp        # 这条指令是因为我们不想更改栈指针，所以使用%ebp
                            # 4(%ebp) 保存了返回地址，所以以下获取参数从 8 和 12开始
    
    pushl %ebx                          # %ebx 数据入栈 
    movl  ST_FILEDES(%ebp), %ebx        # 12(%ebp)的数据移动到 %ebx寄存器   # 12(%ebp) 保存第二个参数
    movl  ST_READ_BUFFER(%ebp), %ecx    # 8(%ebp)的数据移动到 %ecx寄存器    # 8(%ebp) 保存第一个参数
    movl  $RECORD_SIZE, %edx            # 324这个记录长度值移动到 %edx寄存器中
    movl  $SYS_READ, %eax               # 系统调用号放到 %eax
    int   $LINUX_SYSCALL                # 触发系统调用

# 注意 - %eax 中含返回值，我们将该值传回调用程序

    popl  %ebx          # 将之前存在栈中的%ebx的数据从栈中推回去

    movl  %ebp, %esp    # 标准函数返回相关处理 - 我们
    popl  %ebp          # 必须将 %ebp 和 %esp 恢复到
                        # 函数开始运行前的状态
    ret                 # 返回到函数 (这也会将返回值
                        # 弹出栈)
    
    