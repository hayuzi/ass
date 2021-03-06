# # 是注释符号
# 在汇编程序中，任何以小数点符号（.）开始的指令都不会被直接编译成机器指令
# 这些针对汇编程序本身的指令，是由汇编程序处理，实际上并不会由计算机运行，因此被成为汇编指令或者伪操作

# 本程序中.section指令将程序分成几个部分。 .section .data 命令是数据段的开始，数据段中要列出程序所需的所有内存存储空间。
# 由于该程序没有使用任何数据，所以我们不需要这个段，保留这个指令知识为了保持程序的完整性，因为将来写的每一个程序几乎都会有数据段
.section .data

# 该指令表示文本段的开始，文本段是存放程序指令的部分
.section .text

# _start很重要，必须要记住的。
# _start 是一个符号，这就是说他将在汇编或者链接的过程中被其他内容替换
# .globl 表示汇编程序不应该在汇编之后废弃此符号, 因为链接器需要它。
# _start是一个特殊符号，总是用 .globl来标记，因为它标记了该程序的开始位置。 
# 如果不这样编辑这个位置，当计算机加载程序时就不知道从哪里开始运行你的程序
.globl _start

# 定义 _start标签的值。 标签是一个符号，后面跟一个冒号。标签定义一个符号的值
# 当汇编程序对程序进行汇编时，必须为每个数值和每条指令分配地址
# 标签高速汇编程序以该符号的值作为下一条指令或下一个数据元素的位置。
# 这样，如果数据或指令的实际物理位置更改，你就无需重写其引用，因为符号会自动获得新值
_start:

# 计算机指令：程序运行时候，该指令数字1移入 %eax 寄存器
# movl 有两个操作数--源操作数和目的操作数
# 此处 $1中的 数字1前面的$符号 是立即寻址方式寻址。如果没有美元符号，指令将会进行直接寻址，加载地址1中的数字

# 我们准备调用Linux内核，数字 1表示系统调用 exit
movl $1, %eax  

# 将0加载到 %ebx（ 就系统调用 exit而言，它要求将退出状态加载到 %ebx ）
movl $0, %ebx  # 

# int代表中断， 0x80谁要用到的中断号，中断会中断正常的程序流，把控制权从我们的程序转移到Linux，因此将进行一个系统调用
int $0x80



# 关于寄存器：
# x86处理器上有如下几个通用寄存器（ e 开头的寄存器一般是x76架构 32位寄存器的标记， 而 %rax是64位的%eax）
# %eax %ebx %ecx %edx %edi %esi

# 除了这些通用寄存器还有几个专用寄存器
# %ebp %esp %eip %eflags

# 其中一些寄存器，如%eip和%efalgs只能通过特殊指令访问，
# 其他一些则能使用访问通用寄存器的指令来访问，但这些指令会有特殊含义、用途，或者在以特定方式使用时速度更快





