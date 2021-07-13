# 目的 - 给定一个数字，本程序将计算其阶乘
#       例如，3的阶乘是3x2x1，即6
#       4的阶乘是4x3x2x1，即24，以此类推 
#

# 本程序展示了如何递归调用一个函数.

.section .data

# 本程序无全局数据

.section .text

.globl _start

.globl factorial # 除非我们希望与其他程序共享该函数，否则无需此项

_start:
    pushl $4         # 阶乘有一个参数，就是我想要为其计算阶乘的数字。因此，该数字将入栈

    call  factorial  # 调用阶乘函数
    addl  $4, %esp   # 弹出入栈的参数
    movl  %eax, %ebx # 阶乘将答案返回到 %eax
                     # 我们希望它在 %ebx 中
                     # 这样可以将其作为我们的退出状态
    movl  $1, %eax   # 调用内核推出函数
    int   $0x80
    
# 这是实际的函数定义
.type factorial,@function
factorial:
    pushl %ebp       # 标准函数 - 我们必须在返回前
                     # 恢复 %ebp 到其之前的状态
                     # 因此我们必须将其入栈
    movl  %esp, %ebp # 这条指令是以内我们不想更改栈指针，所以使用%ebp
    
    movl  8(%ebp), %eax # 将第一个参数移入 %eax
                        # 4(%ebp) 保伦返回地址，而
                        # 8(%ebp) 保存第一个参数
    cmpl  $1, %eax      # 如果数字为1，这就是我们的基线条件
                        # 我们只要返回即可（ 1 已经作为返回值在%eax中了 ）
    je end_factorial
    decl  %eax          # 否则，递减值
    pushl %eax          # 为了调用factorial函数将其入栈
    call  factorial     # 调用 factiorial 函数
    movl  8(%ebp), %ebx # %eax 中为返回值，因此我们
                        # 将参数重新加载至 %ebx
    imull %ebx, %eax    # factorial 的结果（在%eax中）相乘
                        # 答案存入%eax，而%eax正是存放返回值的地方

end_factorial:
    movl  %ebp, %esp    # 表春函数返回相关处理 - 我们
    popl  %ebp          # 必须将 %ebp 和 %esp 恢复到
                        # 函数开始运行前的状态
    ret                 # 返回到函数 (这也会将返回值
                        # 弹出栈)

