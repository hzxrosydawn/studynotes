## Eclipse常用快捷键

### 代码跳转与查看：

- F3：查看当前光标所在名称（类名、接口名、变量名）的声明（即源码定义）。或者利用Declaration Tab（声明标签页）（Window --> Show View -- > Declaration）来在实时显示当前光标所在类（或接口）的声明（也是源码，只是没有声明前的信息，比如没有package和import语句）。
- Ctrl+左键：F3功能相同。将光标置于代码中的一个名称上，然后点击鼠标左键，Eclipse会在新标签页中显示出该名称的声明。
- Ctrl+Alt+H：查看一个方法的调用层级。将光标置于代码中的一个方法调用处，然后按下该组合键，就会跳转到该方法的定义处，跳转的同时Eclipse会在Call Hierarchy Tab（调用层级标签页）中显示该方法的调用层级。
- Alt+右/左箭头：在跳转（导航）历史记录（Navigation History）中前进/后退。就像Web浏览器的后退/前进按钮一样，在利用F3多次跳转之后，特别有用。如果你的鼠标上有Forward和Back按钮，那么你就可以使用鼠标上的这两个按钮来前进/后退（在Eclipse和浏览器中都可以使用）了。
- Ctrl+Q：回到最后一次编辑（修改）的地方。多次跳转后，使用这个可以立即回到上次修改代码的地方。
- Ctrl+.：将光标移至当前文件的下一个报错处或警告处。一般与Ctrl+1一并使用，Ctrl+1可以弹出修改建议对话框。
- Ctrl+Shift+P：当光标在一对匹配的括号中时，该快捷键可以在当前位置、两个匹配的括号处，这三个地方来回跳转。
- Ctrl+Shift+上/下箭头：切换到上/下一个类成员名称的开头。
- Ctrl+L ：按下该快捷键，在弹出的Go to Line对话框中输入行号，可以快速跳转到该行。
- Ctrl+K：选中的一串字符，快速定位到下一个与当前选中字符相同的地方。
- Ctrl+Shift+K：选中的一串字符，快速定位到上一个与当前选中字符相同的地方。
- Ctrl+/(小键盘)：折叠/展开当前类中的所有代码。

### 代码编辑快捷键：

- Ctrl+=：放大编辑器字体。
- Ctrl+-：缩小编辑器字体。
- Ctrl+/：对一行（或选中的多行）进行单行注释或取消单行注释。
- Ctrl+Alt+上/下箭头：从高亮显示的部分（当前行或选中的多行）的上/下方一行开始，复制出高亮显示部分。
- Ctrl+Shift+F：重新格式化代码。具体的代码样式可以这样设置：打开Eclipse，选择Window -> Preferences -> Java -> Code Style，然后可以设置Clean Up、Code Templates、Formatter和Organize Imports。利用导出（Export）功能来生成配置文件，可以把这些配置文件放在Wiki上，然后团队里的每个人都可以将其导入到自己的Eclipse中。
- Ctrl+2，L：快速为本地变量赋值。开发过程中，可以先创建对象，如Calendar.getInstance()，然后通过Ctrl+2快捷键将方法的计算结果赋值于一个本地变量之上。 这样节省了输入类名，变量名以及导入声明的时间。Ctrl+F的效果类似，不过效果是把方法的计算结果赋值于类中的域。
- Ctrl+Shift+M：在Java、Jsp和JavaScript编辑器中插入未导入的类的import语句；
- Alt+Shift+M：提取本地变量及方法。直接按下Alt+Shift+M会显示出当前类可重写的方法。如果选中可以从当前编辑的代码中提取变量和方法。比如，要从一个字符串创建一个常量，那么就选中这些字符串，并按下Alt+Shift+M即可。如果同 一个字符串在同一类中的别处出现，它会被自动替换。方法提取也是个非常方便的功能。将大方法分解成较小的、充分定义的方法会极大的减少复杂度，并提升代码的可测试性。
- Alt+Shift+J：为当前光标所在的类成员添加Javadoc注释；
- Ctrl+1：弹出错误代码修改提示对话框，方便快速修改错误代码。一般结合Ctrl+.使用。
- Shift+Enter：在当前行下方创建一个空白行，与光标在当前行的位置无关。
- Ctrl+Shift+Enter：与Shift+Enter相反，即在当前行上方插入空白行，也与光标在当前行的位置无关。
- Ctrl+D：删除当前行。
- Ctrl+Delete/Backspace：删除下一个/上一个单词。
- Ctrl+Shift+Delete：删除到行末。
- Ctrl+Shift+X：把当前选中的文本全部变味大写。
- Ctrl+Shift+Y：把当前选中的文本全部变为小写。
- Ctrl+Shift+O：删除无用包；
- Alt+上/下箭头：将当前行或选中的内容往上或下移动一行。在try-catch部分，这个快捷方式尤其好使。
- Alt+Shift+Z：快速添加常用代码块。选中一段代码，按下这组快捷键可以在弹出的快捷菜单中快速将所选代码添加到try-catch块、do-while、while、for、if、lock、runnable、synchronized或lock等代码块中。
- Alt+Shift+S：快速添加一些类成员。定义好一个Java类的成员变量后，按下这组快捷键可以快速添加sets和gets方法、根据已有成员变量添加构造器、使用父类构造器、重写或实现一个方法等。

> 建议：关于代码的跳转和编辑框I，如果你熟悉Vim或Emacs，请安装Vim插件（请参考[Eclipse插件安装的相关介绍]()）或在Window -> Preferences -> General -> Keys中设置Scheme为Emacs。

### 重构快捷键：

- Alt+Shift+T：显示重构菜单。
- Alt+Shift+C：改变方法签名。
- Alt+Shift+V：移动。
- Alt+Shift+R：重命名。如果要为一个文件、包、方法或变量重命名，将鼠标移动要修改的名字上，按下Alt+Shift+R，输入新名称并点击回车，当前工程中的所有使用该类型名称的地方都会被重命名。如果重命名的是类中的一个字段，可以通过点击Alt+Shift+R两次来弹出源码处理对话框，这样可以实现get及set方法的自动重命名。

### 快速搜索或查看快捷键：

- Ctrl+Shift+R：打开Open Resource对话框，只需要按下文件名或mask名中的前几个字母，比如applic\*.xml。美中不足的是这组快捷键并非在所有视图下都能用。小提示：利用Navigator视图的黄色双向箭头按钮让编辑窗口和Navigator视图相关联。这会将当前打开的文件对应显示在Navigator视图的层级结构中，这样便于组织信息。如果这影响了速度，就关掉它。
- Ctrl+O：打开当前文件的快速概览（Quick Outline）对话框。如果想要查看当前类的方法或某个特定方法，但又不想把代码拉上拉下，也不想使用查找功能的话，就用Ctrl+O吧。它可以列出当前类中的所有方法及属性，你只需输入你想要查询的方法名，点击Enter就能够直接跳转至你想去的位置。
- Ctrl+Shift+T：打开Open Type对话框，可以搜索任何类名并打开它的文件。
- Ctrl+T：自顶向下查看一个类的继承关系树，再多按一次Ctrl+T，会换成自底向上的显示结构。
- Ctrl+H：打开搜索对话框。可在搜索对话框中设置各种搜索的筛选条件。
- Ctrl+M：最大化当前窗口。

### 窗口切换快捷键：

- Ctrl+E：快速转换到编辑器。这组快捷键可以在打开的编辑器之间浏览。使用Ctrl+Page Down或Ctrl+Page Up可以浏览前后的选项卡，但是在很多文件打开的状态下，Ctrl+E会更加有效率。
- Ctrl+F6：切换到下一个编辑选项卡。可以连续多次按下可以切换到后面的其他编辑选项卡。
- Ctrl+Shift+F6：切换到上一个编辑选项卡。可以连续多次按下可以切换到前面的其他编辑选项卡。
- Ctrl+F7：切换到下一个视图，连续多次按下可以切换到后面的其他视图。
- Ctrl+Shift+F7：切换到上一个视图，连续多次按下可以切换到前面的其他视图。
- Ctrl+F8：切换到下一个透视图（Perspective）。连续多次按下可以切换到后面的其他透视图。比如可以在Java和Java EE透视图之间来回切换。
- Ctrl+Shift+F8：切换到上一个透视图（Perspective）。连续多次按下可以切换到前面的其他透视图。
- Alt+-：显示当前选项卡的右键菜单。
- Ctrl+Shift+G：在workspace中搜索引用（Reference）。这是重构的前提。对于方法，这个热键的作用和F3恰好相反。它使你在方法的栈中，向上找出一个方法的所有调用者。一个与此相关的功能是开启“标记”功能 （Occurrence Marking） 。选择Window -> Preferences -> Java -> Editor -> Mark Occurrences，勾选选项。这时，当你单击一个元素的时候，代码中所有该元素存在的地方都会被高亮显示。一般电脑建议只使用“标记本地变量”（Mark Local Variables）。注意：太多的高亮显示会拖慢Eclipse。


一些通用快捷键（复制、粘贴、保存等）就不介绍了，在Eclipse菜单中的热键在平时使用中慢慢也就知道了。通过按下Ctrl+Shift+L（从3.1版本开始），可以看到所有快捷键的列表。按下Ctrl+Shift+L两次，会显示按键偏好设置对话框，可以在这里设置自己的热键。

### 调试/运行快捷键：

- F7：单步返回。
- F6：单步跳过。
- F5：单步跳入。
- Ctrl+F5：单步跳入选择。
- F11：调试上次启动。
- F8：继续。
- Shift+F5：使用过滤器单步执行。
- Ctrl+Shift+B：添加/去除断点。
- Ctrl+D：显示。
- Ctrl+F11：运行上次启动。
- Ctrl+R：运行至行。
- Ctrl+U：执行。 

### 文件操作快捷键：

- Alt+Shift+N：弹出新建菜单。
- Ctrl+Shift+S：全部保存。
- Ctrl+F4：关闭当前选项卡。
- Ctrl+Shift+F4：关闭当前窗口中的所有选项卡。

### 其他实用技巧：

- **自动遍历**。在一个数组或集合之后，接着输入for，然后在弹出的自动完成提示对话框中选择对应的遍历模式（如没有弹出自动完成提示对话框，则按一下Alt+/），可以选择遍历一个数组（可以选择是否使用一个临时变量）或集合，接着Eclipse会问你想要遍历哪一个数组或集合，然后自动完成循环代码。

- **一次显示多个文件**。把不在激活状态的编辑选项卡拖到一个可见窗口的底部或侧边的滚动条上，就可以在滚动条处打开该编辑窗口。

本文参考了[某度百科](http://baike.baidu.com/link?url=oCjuwzoShV18BX6EJbgJWmWC10u2cVSMbEV_1JSyp_jqqMbkeDrx7boa36kDuCtfMuq2JXeMBFUS8HuvUZfM-ZqmRJFntaKDgbwAoX77EvANKb4esVtDVq74x8ewvsAnxzuDUxUKINoTUXulQq35uq)，朋友们也可以参考更全的[英文版快捷键集合](https://github.com/pellaton/eclipse-cheatsheet)。目前先写到这里，随着Eclipse的深入使用，以后会持续更新本文。
