## 4 关于函数

### 4.1 处理复度

使用函数将程序划分为可独立开发和测试的各部分。函数是在指定类型的数据上完成所定义的某个工作的代码段。


### 4.2 函数的工作原理

#### 函数名
函数名是一个符号，代表该杉树代码的起始地址。在汇编语言中，符号是通过在函数代码前输入函数名作为标签来定义的，就像之前用于跳转的标签

#### 函数参数
函数参数是显示给函数以进行处理的数据项。某些参数有很多参数，有些不含参数

#### 局部变量
局部变量是函数在进行处理时使用的数据存储区，在函数返回时即被废弃。对于局部变量，程序中的任何其他函数都无法访问

#### 静态变量
静态变量也是函数进行处理时用到的数据存储区，但使用后不会被废弃。每当函数代码被激活时都重复使用。
程序的任何其他部分都无法访问此数据。除非绝对必要，否则我们一般不实用静态变量，因为他们可能在将来引起各种问题

#### 全局变量
全局变量是函数进行处理时用到的，在函数之外管理的数据存储区。

#### 返回地址
返回地址是一个“看不见”的参数，因为它不能直接在函数中使用。返回地址这一参数告诉函数当其执行完毕后应该再从哪里开始执行。
在大多数编程语言中，调用函数时候会自动传递这个参数。
而在汇编语言中，call指令会为你处理返回地址，ret指令则负责按照该地址返回到函数调用的地方

#### 返回值
返回值是传回数据到主程序的主要方法。大多数编程语言只允许一个函数有一个返回值。

#### 总结
以上这些部分在大多数编程语言中都存在。然而在每种语言中如何指定每一项却各不相同。
在不同的语言中，变量存储以及计算机传输参数和返回值的方式各不相同。这种差异成为语言的调用约定，因为它描述了在调用函数时，函数预期得到什么样的数据。

汇编语言能使用其偏好的任何调用约定，你甚至可以自己定一个调用约定。但是如果你想与其他语言编写的函数进行互动，就必须服从其他语言的调用约定。


### 4.3 使用C调用约定的汇编语言函数

pushl 指令将一个寄存器值或内存值压入栈顶（栈顶实际上是栈内存的底部，栈内存从高地址向低地址扩展）。
popl 指令将值从栈顶弹出。该指令将值从栈顶移除，并把其放入寄存器或你选择的存储位置

当我们将值入栈的时候，栈顶会移动，以容纳新增加的值。

栈寄存器%esp总是包含一个指向当前栈顶的指针，无论栈顶在何处。
每当我们用pushl将数据入栈，%esp所含的指针值都会减去4，从而指向新的栈顶
popl指令则从栈中删除数据，并且该指令使%esp的值增加4，并将先前的栈顶的值放入你指定的寄存器
pushl和popl都有一个操作数。
对于pushl，是要将其值入栈的寄存器；对于popl，是要接受弹出栈数据的寄存器

如果我们只是想访问栈顶的值，而不想移除该值，在简介寻址方式中使用 %esp即可
```
# 以下代码将栈顶的内容移入 %eax
movl (%esp), %eax

# 以下代码将会在%eax中保存栈顶的指针, 而不是栈顶存放的值。
movl %esp, $eax

# 如果想访问栈顶的下一个值，我们只需要发出指令 (这条指令使用基地址寻址方式，在寻找指针指向的值之前将%esp与4相加)
movl 4(%esp), %eax
```

在C语言的调用约定中，栈是实现函数的局部变量、参数和返回地址的关键因素。

在执行函数之前，一个程序将函数的所有参数按照逆序压入栈中。
接着程序发出一条call指令，表明程序希望开始执行哪一个函数。
call指令会做两件事情：首先，它将下一条指令的地址即返回地址压入栈中；然后修改指令指针（%eip）以指向函数起始处

```
# 如下指令可以将栈顶指针减去8，这样我们能将栈用于变量存储，而无需担心函数调用引起的入栈会破坏存储的变量。
# 函数调用是在栈帧上分配的，而变量仅仅在函数运行期间有效，所以当函数返回时，栈帧就不复存在，这些变量也就不复存在。
sub1 $8, %esp
```


关于栈调用了函数之后的状态，大体如下：
```
参数2       <--- 12(%ebp)
参数1       <--- 8(%ebp)
返回地址     <--- 4(%ebp)
旧%ebp      <--- (%ebp)
局部变量1    <--- -4(%ebp)
局部变量2    <--- -8(%ebp)
```


%ebp特别适合在栈中通过不同的偏移量来寻址访问函数所需的所有数据，而且%ebp正是专门为这一目的设计的，这就是它被称为基址指针的原因。
关于基址指针寻址方式，虽然可以使用其他寄存器，但在x86架构中，使用%ebp寄存器速度会快很多。

访问全局变量和静态变量就像我们在前面的章节中访问内存一样。全局变量和静态变量之间的唯一区别是静态变量只用于一个函数，而全局变量可以由许多函数共同使用。虽然汇编语言对他们一视同仁，但大多数语言会将两者区分开来


当一个函数执行完毕之后，函数会做三件事：
- 将其返回值存储到%eax
- 将栈恢复到调用函数时的状态（移除当前帧，并使调用代码的栈帧重新生效）
- 将控制权交还给调用它的程序。这是通过ret指令实现的，该指令将栈顶的值弹出，并将指令指针寄存器%eip设置为该弹出的值

所以，在函数将控制权返还给调用它的代码时，必须恢复前一个栈帧。如果不这样做，ret将无法正常工作，因为我们当前栈帧的返回地址不在栈顶。因此返回前必须将栈指针 %esp和基址指针%ebp重新设置为函数开始时候的值。

因此要从函数返回，你必须使用如下指令
```
# 将栈顶指针恢复到之前的值
movl %ebp, %esp 
# 将栈中保存的原栈底指针还原回去
popl %ebp
# 返回
ret
```

如此之后，控制权已经转回调用代码哪里，调用代码现在可以检查%eax中的返回值。调用代码也需要弹出其入栈的所有参数，以将栈指针复位至其原先位置（如果不再需要参数值，那你用addl指令将“4x参数个数”加到%esp即可）

#### 函数示例
请参考 [power.s](power.s)

#### 递归函数
由于所有的函数都必须结束，一个递归定义必须包括一个基线条件。基线条件就是递归停止的地方。
如果没有基线条件，该函数将不断的调用自身，直到最终用尽栈空间

递归函数代码如下

