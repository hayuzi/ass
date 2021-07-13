# 目的:  展示函数如何工作的程序
#          本程序将计算
#          2^3 + 5^2
#
# 主程序中的所有内容都存储在寄存器中
# 因此数据段不含任何内容
.section .data


.section .text
.globl _start

_start:
    pushl $3                  # push 栈空间压入第二个参数, 栈指针向会减去4个字
    pushl $2                  # push 栈空间压入第一个参数, 栈指针再次减去4个字
    call  power               # call 调用 power函数
    addl  $8, %esp            # move 栈指针值加8，由于栈向下扩展，加8相当于栈空间回退8个字

    pushl %eax                # 保存 %eax中的 函数调用第一个结果到 栈 
    # 调用第二个函数
    pushl $2                  # 栈中压入第二个参数
    pushl $5                  # 栈空间压入第一个参数
    call  power               # call 调用power函数，
                              # 此处栈中会再压入返回地址（下一条指令地址）
    addl  $8, %esp            # 回退栈指针
    popl  %ebx                # 第二个函数调用结果目前已经在%eax中
                              # 我们这一步把第一次调用函数后存在栈中的结果推出到 %ebx
    addl  %eax, %ebx          # 两个数相加
                              # 结果是存储在 %ebx 中的
    movl  $1, %eax            # 将exit系统调用的调用号存储到%eax (%ebx is returned)
    int   $0x80               # 触发系统中断


# 目的:  本函数用于计算一个数的幂
#
# 输入:   第一个参数 - 底数
#        第二个参数 - 底数的指数
#
# 输出:   以返回值的形式给出结果
#
# 注意:   指数必须大于等于1
#
# 变量:
#          %ebx - 保存底数
#          %ecx - 保存指数
#
#          -4(%ebp) - 保存结果
#
#          %eax 用于暂时存储
#
#  .type power, @function 这条指令告诉链接器，应该将符号power作为函数处理
# 因为这个程序只在一个文件中，即使省略这一步也同样奏效。但这是一种比较好的做法
.type power, @function
power:
    pushl %ebp           # 保存旧的基址指针（ 将旧的%ebp指针压到栈中 ），栈增长了
    movl  %esp, %ebp     # 将基址指针设置为栈指针
                         # 此处开始才是该函数后续的栈底。栈底之前就是旧的基址。
    subl  $4, %esp       # 本地存储保留空间，%esp的值减去4个字，扩充了栈空间
    movl  8(%ebp), %ebx  # 将第一个参数放入 %ebx
                         # 将当前栈底指针开始到加上8个字（因为有返回地址以及旧基址各占用了4个字）的位置，读取4个字的数据
    movl  12(%ebp), %ecx # 将第二个参数放入  %ecx
    movl  %ebx, -4(%ebp) # 保存当前的%ebp的结果到 之前预留的栈空间中
power_loop_start:
    cmpl  $1, %ecx       # 如果是1次方，那我们这里已经获得结果
    je    end_power      # 如果前一次比较是相等 跳出循环
    movl  -4(%ebp), %eax # 将当前结果移入 %eax
    imull %ebx, %eax     # 将当前结果与底数相乘（imull执行整数乘法）
    movl  %eax, -4(%ebp) # 保存当前结果（ 从%eax移动到栈中 ）
    decl  %ecx           # 将%ecx值减1
    jmp   power_loop_start # 为递减后的指数进行幂计算

end_power:
    movl -4(%ebp), %eax  # 将返回值移动到 %eax
    movl %ebp, %esp      # 恢复栈指针（  ）
    popl %ebp            # 恢复基指针
    ret                  # 返回，到调用位置的下一个命令