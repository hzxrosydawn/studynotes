## Linux shell 基础命令

### echo 命令

#### 描述

**echo 命令**用于打印出**一行**文本，一般起到提示的作用。该命令在 shell 编程使用频率很高，主要用于告知用户脚本在做什么，它也可以在终端下打印变量值和文本内容。

### 语法

```
echo [SHORT-OPTION]... [STRING]...
echo LONG-OPTION
```

### 选项

```
-n：不输出末尾的换行符。可用于将要打印的文本和下一行的输出打印在同一行；
-e：允许使用反斜线转译字符；下面有详细介绍；
-E：禁用反斜线转译字符（默认）。
```

使用`-e`选项时，若字符串中出现以下字符时，echo 命令可以识别出来加以特殊处理，而不会将它当成一般文字输出：

- \a：发出警告声；
- \b：删除前一个字符；
- \c：最后不加上换行符号；
- \e：转译；
- \f：换行但光标仍旧停留在原来的位置；
- \n：换行且光标移至行首；
- \r：光标移至行首，但不换行；
- \t：插入水平制表符；
- \v：插入垂直制表符；
- \\\：插入\ 字符；
- \0NNN：插入NNN（1~3个八进制数值）所代表的 ASCII 字符；
- \xHH：插入HH（1~2 个十六进制数值）所代表的 ASCII 字符。

### 参数

要打印的变量（以$开头的变量引用）或字符串。

### 实例

1. 使用 -n 选项将两行内容合并成一行打印

```powershell
[vincent@localhost ~]$ cat test1
#!/bin/bash
echo "The time and date are: " 
date
[vincent@localhost ~]$ ./test1 
The time and date are: 
Fri Mar  2 15:45:51 CST 2018
...
[vincent@localhost ~]$ cat test1
#!/bin/bash
echo -n  "The time and date are: " 
date
[vincent@localhost ~]$ ./test1 
The time and date are: Fri Mar  2 15:44:59 CST 2018
```



1. 用 echo 命令打印带有色彩的文字：

**文字色：**

```
echo -e "\e[1;31mThis is red text\e[0m"
This is red text
```

- `\e[1;31m` 将颜色设置为红色
- `\e[0m` 将颜色重新置回

颜色码：重置=0，黑色=30，红色=31，绿色=32，黄色=33，蓝色=34，洋红=35，青色=36，白色=37

**背景色**：

```
echo -e "\e[1;42mGreed Background\e[0m"
Greed Background
```

颜色码：重置=0，黑色=40，红色=41，绿色=42，黄色=43，蓝色=44，洋红=45，青色=46，白色=47

**文字闪动：**

```
echo -e "\033[37;31;5mMySQL Server Stop...\033[39;49;0m"

```

红色数字处还有其他数字参数：0 关闭所有属性、1 设置高亮度（加粗）、4 下划线、5 闪烁、7 反显、8 消隐