## 6.读写简单记录

数据一些分别：结构化的和非结构化的. 
一般情况下，程序无法解读非结构化数据内容。而结构化的数据正好相反，是计算机比较擅长处理的。
而且我们可以通过非结构化的数据来转换为结构化数据来处理.

另外，一些反复使用的定义，可以分别独立存放到文件，这些文件仅仅需要时候才包含在汇编语言文件中。

### 6.1 写入记录
参考一下下面的这个示例的文件组织方式 [/example/records](/example/records):
- 使用 [record_def.s](/example/records/record_def.s) 文件保存各个字段相对于记录起始处的偏移量
- 使用 [record_def.s](/example/records/linux.s)文件保存各个一些Linux相关的常量
- 使用 [read_record.s](/example/records/read_record.s) 文件定义一个读取记录函数
- 使用 [write_record.s](/example/records/write_record.s) 文件定义一个写记录函数
- 使用 [write_records.s](/example/records/write_records.s) 写记录的文件


文件中的  .include "linux.s" 声明使指定文件被粘贴到代码当前位置。
我们无需在函数中使用这样的声明，因为链接器能将导出函数与 .global 指令相结合。 
但是在另一个文件中定义的常量确实需要通过这种方式导入。


指令 .rept 和 .endr 之间的段重复 .rept之后指定的次数。
我们通常用该指令填充 .data段中的值。

为了生成应用程序，我们运行以下命令：(分别汇编两个文件，然后用链接器将之合并)
```
as write_records.s -o write_records.o
as write_record.s -o write_record.o
ld write_record.o write_records.o -o write_records
```

目前在64位机器上编译与执行执行相关代码
```
as --32 write_records.s -o write_records.o
as --32 write_record.s -o write_record.o
ld -m elf_i386 write_record.o write_records.o -o write_records

## 执行
./write_records
```

### 6.2 读取记录