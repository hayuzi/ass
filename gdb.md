使用GDB调试汇编程序
==

## 调试步骤
```
# 使用GDB时候增加-tui选项
gdb -tui ./file.name
```


打开gdb后运行layout regs命令（显示寄存器信息），不同的lyout 参数表示不同的窗口功能
```
layout：用于分割窗口，可以一边查看代码，一边测试。主要有以下几种用法：
layout src：显示源代码窗口
layout asm：显示汇编窗口
layout regs：显示源代码/汇编和寄存器窗口
layout split：显示源代码和汇编窗口
layout next：显示下一个layout
layout prev：显示上一个layout
Ctrl + L：刷新窗口
Ctrl + x，再按1：单窗口模式，显示一个窗口
Ctrl + x，再按2：双窗口模式，显示两个窗口

Ctrl + x，再按a：回到传统模式，即退出layout，回到执行layout之前的调试窗口。
```

在调试中，先需要给 代码的标签打上断点
```
# 如果在代码中有 _start 标签， 则可以使用如下命令在该位置打上断点
b _start

# 而后通过 r 命令启动程序
r

# 而后可以使用 n 命令执行下一步
n
```



