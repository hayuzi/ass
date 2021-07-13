 
# 获取数据中的最大值
# 

# 数据段
.section .data

# 开始是数据项, data_items 是一个指代其后位置的标签. 此处未使用 .globl 是因为其他任何文件不需要知道他们的位置
data_items:

    # 接下来的指令以 .long 开始，会让汇编程序为 .long之后的数字列表保留内存
    .long 3,67,34,222,45,75,54,34,44,33,22,11,66,0

    # 当然还有其他的数据类型比如:
    #  .byte（每个字节类型的数字占用一个存储为位置）
    #  .int 每个整型数字（这个类型与int指令不同）占用两个存储位置，数字范围为 0～65535
    #  .long 长整型占用 4个存储位置，与寄存器使用的空间相同，（0～4294967295）
    #  .ascii 指令用于将字符输入内存，每个字符占用一个存储位置（字符在内部转换成字节）

.section .text

.globl _start

_start:
    movl $0, %edi                   # 将0移入索引寄存器

    # data_items是数字列表起始处的位置编号，存储每个数字需要4个存储位置（因为我们声明数字为 .long类型）
    # 此刻%edi含有0
    # 这一行代码的意思：从data_items的起始位置开始，获取第一项的数字（因为%edi为0），并将该数字存储到%eax
    # 这就是汇编语言中使用索引寻址的方式。该指令的通用格式如下：  movl 起始地址(,%edi,字长)
    movl data_items(,%edi,4) %eax   # 加载数据的第一个字节
    movl %eax, %ebx                 # 由于这是第一项， %eax就是最大值

start_loop:                         # 开始循环
    # cmpl 指令对两个值进行比较，比较指令的结果存储在 状态寄存器 %eflags
    cmpl $0, %eax                   # 检测是否到达数据末尾
    # je 是流控制指令（je中 e表示 equal），表示如果方才比较的的值相等，则跳转到 end_loop 的位置
    # 其他类似的指令有：
    # je 等值则跳转
    # jg 如果第二个值大于第一个值则跳转
    # jl 如果第二个值小雨第一个值则跳转
    # 其他还有 jle  jge 等，都是在大于小于的基础上混合等于判断
    # jmp 是无条件跳转
    je  loop_exit
    incl %edi                       # 加载下一个值（ incl将%edi的值加1 ）
    movl data_items(,%edi,4), %eax  
    cmpl %ebx, %eax                 # 比较值
    jle start_loop                  # 若新数据项不大于原最大值，则跳到循环起始处
    movl %eax, %ebx                 # 将新的值移动到最大值寄存器
    jmp start_loop                  # 跳到循环起处

loop_exit:
    # %ebx是系统调用exit的状态码
    # 已经存放了最大值
    movl $1, %eax                   # 1是exit()系统调用
    int $0x80



