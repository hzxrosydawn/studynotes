### 进入插入模式快捷键

| 快捷键  | 描述            |
| ---- | ------------- |
| i    | 在当前光标所在字符之前插入 |
| I    | 在当前行首插入       |
| a    | 在当前光标所在字符后插入  |
| A    | 在当前行尾插入       |
| o    | 在当前行之后插入一行    |
| O    | 在当前行之前插入一行    |

### 移动命令

| 快捷键  | 描述                                       |
| ---- | ---------------------------------------- |
| h    | 左移一个字符                                   |
| l    | 右移一个字符，一般用w代替                            |
| k    | 上移一个字符                                   |
| j    | 下移一个字符                                   |
| w    | 向前移动一个单词（光标停在单词首部，w将连续的字母数字或特殊字符当做一个单词），如果已到行尾，则转至下一行行首。此命令较快，可以代替l命令 |
| W    | 同w，只是以空白（空格、制表符、换行符）作为单词分隔符来识别是否到达下一个单词  |
| b    | 向后移动一个单词（光标停在单词首部，b将连续的字母数字或特殊字符当做一个单词），如果已到行首，则转至上一行行尾。此命令较快，可以代替h命令 |
| B    | 同b，只是以空白作为单词分隔符来识别是否到达下一个单词              |
| e    | 向前移动一个单词向前移动一个单词，同w，只不过是光标停在单词尾部         |
| E    | 向前移动一个单词，同e，只是以空白作为单词分隔符来识别是否到达单词        |
| ge   | 向后移动一个单词，同b，只是光标停在单词尾部，与e方向相反            |
| gE   | 向后移动一个单词，同b，只是光标停在单词尾部，与e方向相反            |

以上命令可以在行间移动。h、l、k、l四个命令可以配合数字使用，比如`20j`就是向下移动20行，`5h`就是向左移动5个字符。在Vim中，很多命令都可以配合数字使用，比如删除10个字符`10x`。

使用“冒号+行号+回车”可以跳到指定行，比如跳到240行就是 `:240` 回车。另一个方法是 `行号+G` ，比如 `230G` 跳到230行。

| 快捷键  | 描述                                       |
| ---- | ---------------------------------------- |
| 0    | （数字0）移动到本行第一个字符上                         |
| ^    | 移动到本行第一个非空白字符上                           |
| \`   | 移动到本行第一个字符，同0键                           |
| \$   | 移动到行尾，如3$移动到下面3行的行尾                      |
| gg   | 移动到文件头 与 [[ 等效                           |
| G    | （shift + g） 移动到文件尾与 ]] 等效                |
| nG   | 移动到第n行                                   |
| f    | （find）命令也可以用于移动，fx将找到光标后第一个为x的字符，3fd将找到第三个为d的字符 |
| F    | 同f，反向查找                                  |
| %    | 跳转到当前光标所在括号的匹配括号下，用来查看一堆匹配括号很方便          |

注：以上移动命令是行内有效

### 删除命令

| 快捷键  | 描述                                      |
| ---- | --------------------------------------- |
| x    | 删除当前光标所在字符，dl 删除当前字符， dl=x              |
| 3x   | 删除当前光标所在字符开始向后三个字符                      |
| X    | 删除当前光标所在字符的前一个字符，dh 删除前一个字符，X=dh        |
| ce   | 删除当前光标所在字符到一个单词末尾之间的字符，并进入插入模式          |
| cE   | 删除当前光标所在字符到一个单词（以空白符分隔）末尾之间的字符，并进入插入模式  |
| cw   | 删除当前光标所在字符到下一个单词开头之间的字符，并进入插入模式         |
| cW   | 删除当前光标所在字符到下一个单词（以空白符分隔）开头之间的字符，并进入插入模式 |
| c    | 删除当前光标所在字符到当前行第一个非空字符之间的字符，并进入插入模式      |
| c0   | 删除当前光标所在字符到行首的字符，并进入插入模式                |
| c$   | 删除当前光标所在字符所在位置到行尾之间的字符，并进入插入模式          |

### 拷贝和粘贴

| 快捷键         | 描述                                       |
| ----------- | ---------------------------------------- |
| yw          | 复制单词                                     |
| y$          | 复制当前光标到行尾                                |
| yy          | 拷贝当前行                                    |
| nyy         | 拷贝当前后开始的n行，比如2yy拷贝当前行及其下一行               |
| yf          | 复制从当前字符到指定字符f                            |
| p           | 在当前光标后粘贴（如在可视模式下用y复制的内容）,如果之前使用了yy命令来复制一行，那么就在当前行的下一行粘贴 |
| P           | 在当前光标前粘贴（如在可视模式下用y复制的内容）,如果之前使用了yy命令来复制一行，那么就在当前行的上一行粘贴 |
| :1,10 co 20 | 将1-10行插入到第20行之后                          |
| :1,co       | 将整个文件复制一份并添加到文件尾部                        |
| ddp         | 交换当前行和其下一行                               |
| xp          | 交换当前字符和其后一个字符                            |

正常模式下按v（逐字）或V（逐行）进入可视模式，然后用jklh命令移动即可选择某些行或字符，再按y即可复制

### 剪切命令

| 快捷键         | 描述                           |
| ----------- | ---------------------------- |
| ndd         | 剪切当前行之后的n行。利用p命令可以对剪切的内容进行粘贴 |
| :1,10d      | 将1-10行剪切。利用p命令可将剪切后的内容进行粘贴。  |
| :1, 10 m 20 | 将第1-10行移动到第20行之后             |

正常模式下按v（逐字）或V（逐行）进入可视模式，然后用`j`、`k`、`l`、`h`命令移动即可选择某些行或字符，再按`d`即可剪切。

### 撤销和重做

| 快捷键    | 描述                      |
| ------ | ----------------------- |
| u      | 撤销（Undo）                |
| U      | 撤销对整行的操作，也算是一次操作，可以被u撤销 |
| Ctrl+R | 重做（Redo）                |

### 保存&退出命令

| 快捷键          | 描述                        |
| ------------ | ------------------------- |
| :wq          | 保存并退出                     |
| :w name.type | 将当前文件保存成名称为name.type的文件   |
| ZZ           | 保存并退出                     |
| :q           | 如果是最后一个被关闭的窗口，那么将退出vim    |
| :q!          | 强制退出并忽略所有更改               |
| :e！          | 放弃所有修改，并打开原来文件            |
| :close       | 最后一个窗口不能使用此命令，可以防止意外退出vim |
| :only        | 关闭所有窗口，只保留当前窗口            |

### 滚屏操作

| 快捷键    | 描述       |
| ------ | -------- |
| Ctrl-e | 向上滚动一行   |
| Ctrl-y | 向下滚动一行   |
| Ctrl-u | 向上滚动半页   |
| Ctrl-d | 向下滚动半页   |
| Ctrl-f | 向下滚动一页   |
| Ctrl-b | 向上滚动一页   |
| zz     | 将当前行置中显示 |
| zt     | 将当前行置顶显示 |
| zb     | 将当前行置底显示 |

### 查找命令

以:和/开头的命令都有历史纪录，可以首先键入:或/然后按上下箭头来选择某个历史搜索内容或命令。 
/text　　查找text，按n健查找下一个，按N健查找前一个。 
?text　  查找text，反向查找，按n健查找下一个，按N健查找前一个。

注意：对于一些特殊的字符需要使用转义字符，例如：*,[,]^,%,/,?,~,$等，当使用这些特殊字符时，需要在它们的前面加上转义符号”\” 
:set ignorecase　　忽略大小写的查找 
:set noignorecase　　不忽略大小写的查找

">"是 一 个 特 殊 的 记 法，它 只 匹 配 一 个 word 的 结 束 处。近 似 
地，"\<"匹配到一个 word 的开始处。这样查找作为一个 word 的"the"就 
可以用：/\，这样就不会匹配到there或clothe

查找很长的词，如果一个词很长，键入麻烦，可以将光标移动到该词上，按*或#键即可以该单词进行搜索。 
*相当于/搜索，而#命令相当于?搜索。 还 可 以 在 这 两 个 命 令 前 加 一 个 命 令 计数： "3*"查找当前光标下的 word 的第三次出现。 
注意"*"和"#"命令会在内部使用这些标记 word 开始和结束的特殊标记来查找整个的 word(你可以 用"g*"和"g#"命令来同时匹配那些包含在其它 word 中的字串。)

:set hlsearch　　高亮搜索结果，所有结果都高亮显示，而不是只显示一个匹配。 
:set nohlsearch　　关闭高亮搜索显示 
:nohlsearch　　关闭当前的高亮显示，如果再次搜索或者按下n或N键，则会再次高亮。 
:set incsearch　　逐步搜索模式，对当前键入的字符进行搜索而不必等待键入完成。 
:set wrapscan　　重新搜索，在搜索到文件头或尾时，返回继续搜索，默认开启。

### 替换命令

| 快捷键          | 描述                                       |
| ------------ | ---------------------------------------- |
| ra           | 将光标所在的单个字符替换为a                           |
| R            | 进入替换模式，输入字符可以将当前位置的字符全部替换                |
| ddp          | 交换光标所在行和其下紧邻的一行                          |
| `:%s/^/#/`   | 全文的行首加入#字符，在Python中批量注释的时候非常有用           |
| `:%s= *$==`  | `将所有行尾多余的空格删除`                           |
| :g^$d        | `删除所有的空行， 这里的g表示对文章中所有符合要求字符串执行替换操作，^表示行首，$表示行尾` |
| ：：sold≠w     | 用old替换new，替换当前行的第一个匹配                    |
| ：：m,nsold≠wg | 用old替换m行到n行中的new，替换当前行的所有匹配              |
| ：：%sold≠w    | 用old替换new，替换所有行的第一个匹配                    |
| ：：%sold≠wgc  | 用old替换new，替换整个文件的所有匹配，并提示替换              |
| :10,20s^/  g | 在第10行至第20行每行前面加四个空格，用于缩进                 |

`:[range]s /源字符串 /目标字符串 /[option]`：range和option是可以缺省不填的，各个字段的意思是：
- range：代表检索范围，默认缺省表示当前行检索，1,10表示从第1到第10行，%代表整个文件，等价于1,，而，而.,代表从当前行到文件末尾；
- s：substitute的简写，代表替换；
- option：代表操作类型，默认缺省只对第一个匹配的字符进行替换，g(global)全局替换，c(comfirm)操作时确认，i(ignorecase)不区分大小写，这些选项可以组合使用。比如以下命令，将会显示将要做改动的文本并要求确认：
  - :1,$s/foo/bar/gc

  - replace with foo(y/n/a/q/l/^E/^Y)? 

    这时你可以选择如下操作：

    - y Yes：执行这个替换
    - n No：取消这个替换
    - a All：执行所有替换而不要再询问
    - q Quit：退出而不做任何改动
    - l Last：替换完当前匹配点后退出
    - Ctrl-E：向上翻滚一行
    - Ctrl-Y：向下翻滚一行

文件的提取合并： 
通过输入“:r 文本流”可将文本流中的内容插入到光标所在位置之后 
文本流可以是外部命令的输出打印,如“:r !dir”可以插入dir命令的输出到当前位置，如“：r !dir”将当前目录打印信息输入当前文本 
文本流也可以是文本文件，如“:r Test.java”可以将Test.java文件的额内容插入到当前位置

执行外部命令： 
Normal模式下输入“：!command”来执行外部命令，如Windows下“：!dir”查看当前目录

窗口命令：

- :split或new：打开一个新窗口，光标停在顶层的窗口上 ；
- :split file或:new file 用新窗口打开文件。split打开的窗口都是横向的，使用vsplit可以纵向打开窗口；
- Ctrl+ww：移动到下一个窗口 ；
- Ctrl+wj：移动到下方的窗口 ；
- Ctrl+wk：移动到上方的窗口。

录制宏： 
按q键加任意字母开始录制，再按q键结束录制（这意味着vim中的宏不可嵌套），使用的时候@加宏名，比如qa。。。q录制名为a的宏，@a使用这个宏。 
执行shell命令 
:!command 
:!ls 列出当前目录下文件 
:!perl -c script.pl 检查perl脚本语法，可以不用退出vim，非常方便。 
:!perl script.pl 执行perl脚本，可以不用退出vim，非常方便。 
:suspend或Ctrl - Z 挂起vim，回到shell，按fg可以返回vim。

注释命令： 
perl程序中#开始的行为注释，所以要注释某些行，只需在行首加入# 
3,5 s/^/#/g 注释第3-5行 
3,5 s/^#//g 解除3-5行的注释 
1,$ s/^/#/g 注释整个文档。 
:%s/^/#/g 注释整个文档，此法更快。

帮助命令： 
:help or F1 同时显示整个帮助文档，Ctrl+W可以在编辑文档和帮助文档之间跳转 
:help xxx 显示xxx的帮助，比如 :help i, :help Ctrl-[（即Ctrl+[的帮助）。 
:help 'number' Vim选项的帮助用单引号括起 
:help 特殊键的帮助用<>扩起 
:help -t Vim启动参数的帮助用- 
：help i_ 插入模式下Esc的帮助，某个模式下的帮助用模式_主题的模式 
帮助文件中位于||之间的内容是超链接，可以用Ctrl+]进入链接，Ctrl+o（Ctrl + t）返回

其他非编辑命令： 
. 重复前一次命令 
:set ruler? 查看是否设置了ruler，在.vimrc中，使用set命令设制的选项都可以通过这个命令查看 
:scriptnames 查看vim脚本文件的位置，比如.vimrc文件，语法文件及plugin等。 
:set list 显示非打印字符，如tab，空格，行尾等。如果tab无法显示，请确定用set lcs=tab:>-命令设置了.vimrc文件，并确保你的文件中的确有tab，如果开启了expendtab，那么tab将被扩展为空格。 
Vim教程： 
在Unix系统上： 
$ vimtutor 
在Windows系统上： 
:help tutor 
:syntax 列出已经定义的语法项 
:syntax clear 清除已定义的语法规则 
:syntax case match 大小写敏感，int和Int将视为不同的语法元素 
:syntax case ignore 大小写无关，int和Int将视为相同的语法元素，并使用同样的配色方案