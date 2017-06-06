## 

### whatis命令

whatis命令是用于查询一个命令执行什么功能，并将查询结果打印到终端上。 whatis命令在用 `catman -w` 命令创建的**数据库**中查找command参数指定的命令、系统调用、库函数或特殊文件名。whatis命令显示手册部分的页眉行。然后可以发出man命令以获取附加的信息。whatis命令等同于使用man -f命令。

### Linux的变量种类

 按变量的生存周期来划分，Linux变量可分为两类：**永久的**（需要修改配置文件，变量永久生效）和**临时的**（使用export命令声明即可，变量在关闭shell时失效）。

### 设置变量的三种方法

1. 在/etc/profile文件中添加变量，该变量对所有用户来说是永久生效的。
2. 用Vi在文件/etc/profile文件中增加变量，该变量对所有用户来说是永久生效的。

例如：编辑/etc/profile文件，添加CLASSPATH变量

\# vi /etc/profile

export CLASSPATH=./JAVA_HOME/lib;$JAVA_HOME/jre/lib

注：修改文件后要想马上生效还要运行# source /etc/profile不然只能在下次重进此用户时生效。

2.2 在用户目录下的.bash_profile文件中增加变量【对单一用户生效(永久的)】

用VI在用户目录下的.bash_profile文件中增加变量，改变量仅会对当前用户有效，并且是“永久的”。

例如：编辑guok用户目录(/home/guok)下的.bash_profile

$ vi /home/guok/.bash.profile

添加如下内容：

export CLASSPATH=./JAVA_HOME/lib;$JAVA_HOME/jre/lib

注：修改文件后要想马上生效还要运行$ source /home/guok/.bash_profile不然只能在下次重进此用户时生效。

2.3 直接运行export命令定义变量【只对当前shell(BASH)有效(临时的)】

在shell的命令行下直接使用[export 变量名=变量值] 定义变量，该变量只在当前的shell(BASH)或其子shell(BASH)下是有效的，shell关闭了，变量也就失效了，再打开新shell时就没有这个变量，需要使用的话还需要重新定义。

一、修改/etc/sysconfig/i18n文件，如LANG="en_US"，xwindow会显示英文界面，LANG="zh_CN.GB18030"，xwindow会显示中文界面。 

 系统版本 centos6.0

二、还有一种方法cp/etc/sysconfig/i18n$HOME/.i18n修改$HOME/.i18n文件，如LANG="en_US"，xwindow会显示英文界面，LANG="zh_CN.GB18030"，xwindow会显示中文界面。

这样就可以改变个人的界面语言，而不影响别的用户/*/Redhat as4在安装是选择英文/中文/韩文/日文在X Window下一切正常

1)切换到文本模式下时，出现乱码。

2)修改/etc/sysconfig/i18n文档LANG="en_US"

3)重起后,所在信息显示为问号.证明没有修改成功.4)切换到X Window将默认语言改为英文.5)重起后,所有信息显示正常,查看/etc/sysconfig/i18n文档,LANG="en_US.UTF-8"