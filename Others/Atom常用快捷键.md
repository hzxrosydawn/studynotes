文件操作快捷键 |描述
--- | ---
Ctrl+N|新建文件（会弹出文件路径设置界面）
Ctrl+Shift+N|打开一个窗口
Ctrl+Shift+T|重新打开上次关闭的条目
Ctrl+O        |打开文件
Ctrl+Shift+O|打开目录
Ctrl+S         |保存当前文件
Ctrl+Shift+S |另存为
Ctrl+W|关闭标签页
Ctrl+Shift+W|关闭窗口

显示操作快捷键|描述
---|---
Alt     |显示/隐藏菜单栏
Ctrl+\  |显式/隐藏树状图
Alt+\   |转移焦点到树状图
Enter   |展开/折叠树状图目录
A       |添加新文件或新目录
M       |移动当前文件或目录
Delete  |删除当前文件或目录
Ctrl+Shift+M      |打开MarkDown预览视图，预览视图包默认已安装，可设置
**Ctrl+Shift+P**      |当前焦点在一个窗格上的时候，调出命令面板
Ctrl+,             |打开设置标签页
Ctrl+Shift+L  |选择特定高亮语法，一般只有Atom识别文件类型出错而采用错误的语法高亮时才会用到该功能

搜索操作快捷键|描述
---|---
Ctrl+T<br>Ctrl+P  |在当前工程下搜索任意文件
Ctrl+B            |仅搜索当前缓冲区中或已打开的文件
Ctrl+Shift+B      |仅搜索上次git提交之后已更改或新建的文件
Ctr+F             |打开搜索替换窗口，在当前文件中搜索
F3                |查找下一个
Esc               |关闭搜索替换窗口

符号查找快捷键|描述
---|---
Ctrl+R      |打开一个列表，包含当前文件中所有的符号
Ctrl+T      |进行模糊查找
Ctrl+Shift+R    |查找存在于整个项目中的符号
符号查找需要在工作目录中生成了`tags`（或者`TAGS`）文件。通过安装`ctags`，并且从命令行中，在你的项目根目录下运行`ctags -R src/`这样的命令，来生成文件。

apm命令|描述
---|---
apm search <package_name>   |搜索指定名称的安装包
apm view <package_name> |查看安装包详细信息
apm install <package_name>  |安装指定安装包的详细信息
apm install <package_name>@<package_version>    |安装指定版本的指定安装包

移动光标快捷键|描述
---|---
Ctrl+Left   |移动到单词头部
Ctrl+Right  |移动到单词尾部
Home        |移动号行首
End           |移动到行尾
Ctrl+Home   |移动到文件头部
Ctrl+End    |移动到文件尾部
Ctrl+G      |在弹出的对话框里输入row:column移动到指定行的指定位置
Ctrl+M |跳转到匹配的相邻的括号处，没有相邻的括号时挑战到最近的括号处
Alt+Ctrl+. 	|关闭当前的XML/HTML标签

书签跳转快捷键|描述
---|---
Ctrl+Alt+F2 |将当前行添加到书签，行号后面有书签标志，再次操作取消添加的书签
F2          |跳转到下一个书签
Shift+F2    |跳转到下一个书签，到最后一个书签后自动循环
Ctrl+F2     |查看所有书签列表以跳转到指定书签

选择快捷键|描述
---|---
Shift+Up        |向上选择
Shift+Down      |向下选择
Shift+Left      |向左选择一个字符
Shift+Right     |向右选择一个字符
Shift+End       |选中当前光标到行尾部分
Shift+Home      |选中当前光标到行首部分
Ctrl+Shift+Left |选中当前光标到上一个单词的开头部分
Ctrl+Shift+Right|选中当前光标到下一个单词的结尾部分
Ctrl+Shift+Home |选中当前光标到文件头的部分
Ctrl+Shift+End  |选中当前光标到文件尾的部分
Ctrl+A          |全选
Ctrl+L          |选中当前行
Alt+Ctrl+M 	|选中当前括号中的所有文本

文本操作快捷键|描述
---|---
Ctrl+J          |将下一行添加到当前行尾
Ctrl+Up/Down    |上下移动当前行    
Ctrl+Shift+D    |复制当前行并在下一行输出
Ctrl+K、Ctrl+U  |将当前单词转换为大写
Ctrl+K、Ctrl+L  |将当前单词转换为小写
Ctrl+Shift+K    |删除当前行
Ctrl+Backspace  |删除到当前单词开头
Ctrl+Delete     |删除到当前单词结尾
Ctrl+Click      |在鼠标单击处再添加一个光标，可连续添加多个光标
Alt+Ctrl+Up/Down|在当前光标上方/下方添加一个光标
Ctrl+D          |选中文档与当前光标所在的单词一样的下一个单词，可重复性选择多次
**Alt+F3**          |选中当前文档中与当前光标所在单词（或搜索框中要搜索的单词）一样的所有单词

空白符处理|描述
---|---
Ctrl+Shift+P，输入Convert Spaces to Tabs	|将空白符装换为Tab
Ctrl+Shift+P，输入Convert Tabs to Spaces	|将Tab装换为空白符

字符编码|描述
---|---
Ctrl+Shift+U|弹出编码对话框，可选择保存文件的编码<br>当打开一个文件时，Atom会自动检测文件编码。如果检测失败，编码会默认设置为UTF-8

折叠快捷键|描述
---|---
Alt+Ctrl+[ 	|折叠
Alt+Ctrl+]	|展开
Alt+Ctrl+Shift+[	|折叠所有
Alt+Ctrl+Shift+]    |展开所有
