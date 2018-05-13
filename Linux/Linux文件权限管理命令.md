---
typora-copy-images-to: ..\..\graphs\photos
typora-root-url: ..\..\graphs
---

### 文件权限

Linux 系统是一种典型的多用户系统，不同的用户处于不同的地位，拥有不同的权限。为了保护系统的安全性，Linux 系统对不同的用户访问同一文件（包括目录文件）的权限做了不同的规定。在 Linux 中我们**可以使用 ll 或者 ls  –l 命令来显示一个文件的属性以及文件所属的用户和组**，如：

```shell
[root@localhost vincent]# ll
total 96
-rw-rw-r-- 1 vincent vincent 40960 Apr 17 21:12 doucument.tar
drwxrwxr-x 3 vincent vincent  4096 Mar 13 15:28 package
-rw-rw-r-- 1 vincent vincent    53 Mar  7 09:14 result1
-rw-rw-r-- 1 vincent vincent   107 Mar  7 09:20 result2
-rw-rw-r-- 1 vincent vincent   664 Mar  9 17:06 result3
-rwxrw-r-- 1 vincent vincent    49 Mar  2 15:45 script1
-rwxrw-r-- 1 vincent vincent    85 Mar  5 13:49 test2
-rwxrw-r-- 1 vincent vincent   109 Mar  5 14:27 test3
-rw-rw-r-- 1 vincent vincent    41 Mar 13 09:55 test3.txt
-rwxrw-r-- 1 vincent vincent   119 Mar  6 16:18 test4
-rw-rw-r-- 1 vincent vincent    64 Mar  1 21:00 test.txt
```

文件都有一个特定的所有者，也就是对该文件具有所有权的用户。同时，在 Linux 系统中，用户是按组分类的，一个用户属于一个或多个组。文件所有者以外的用户又可以分为文件所有者的同组用户和其他用户。因此，Linux 系统按文件所有者、文件所有者同组用户和其他用户来规定了不同的文件访问权限。 每个文件的属性由左边第一部分的10个字符来确定（如下图）。 

 ![0.6288602616931696](/photos/0.6288602616931696.png)

实例中，文件的第一个属性表示文件类型，所有可用的值如下：

- 当为 [d] 则表示目录；
- 当为 [-] 则表示文件；
- 若是 [l] 则表示为链接文档（link file）；
- 若是 [b] 则表示可供储存的接口设备（块设备，可随机存取设备）；
- 若是 [c] 则表示串行端口设备（字符型设备，例如键盘、鼠标）；
- 当为 [n] 则表示网络设备；

接下来的字符中，以三个为一组，且均为『rwx』 的三个参数的组合。其中：

- [r]代表可读（read）；
- [w]代表可写（write）；
- [x]代表可执行（execute）；
- [-]代表没有对应的权限。

文件属性从左至右用 0-9 这些数字来表示。第 0 位确定文件类型（前面已经说过可以为哪些文件类型），第 1-3 位确定属主（该文件的所有者）拥有该文件的权限。第 4-6 位确定属组（所有者的同组用户）拥有该文件的权限，第 7-9 位确定其他用户拥有该文件的权限。其中，第 1、4、7 位表示读权限，如果用 `r` 字符表示，则有读权限，如果用 `-` 字符表示，则没有读权限；第 2、5、8 位表示写权限，如果用 `w` 字符表示，则有写权限，如果用 `-` 字符表示没有写权限；第 3、6、9 位表示可执行权限，如果用 `x` 字符表示，则有执行权限，如果用 `-` 字符表示，则没有执行权限。 

对于 root 用户来说，一般情况下，文件的权限对其不起作用，即**root用户对所有文件拥有所有权限**。 

###  chmod 命令

chmod 命令用来变更文件或目录的权限。设置方式采用文字或数字代号皆可。符号链接的权限无法变更，如果用户对符号连接修改权限，其改变会作用在被链接的原始文件。

#### 语法

```shell
chmod [OPTION]... MODE[,MODE]... FILE...
chmod [OPTION]... OCTAL-MODE FILE...
chmod [OPTION]... --reference=RFILE FILE...
```

##### 选项

```shell
-c, --changes：类似 verbose，但仅在已变化之后报告；
-f, --silent, --quiet：不输出多数错误信息；
-v, --verbose：输出每个文件处理的诊断信息；
--no-preserve-root：不特别处理根目录 `/`;
--preserve-root：不递归处理根目录 `/` ；
--reference=RFILE：使用 RFILE 的属性而不是 MODE 值；
-R, --recursive：递归处理文件和目录；
--help：显示帮助信息并退出；
--version：显示版本信息并退出。
```

##### 参数

MODE：文件权限模式。可以是数值，也可以是字符格式；

FILE：待变更的文件。

指定的变更格式 `[ugoa...][[+-=][rwxXst]...][,...]` 。文件权限范围的表示法如下：

- `u` User，即文件或目录的拥有者；
- `g` Group，即文件或目录的所属群组；
- `o` Other，除了文件或目录拥有者或所属群组之外，其他用户皆属于这个范围；
- `a` All，即全部的用户，包含拥有者，所属群组以及其他用户；
- `+` 表示添加权限；
- `-` 表示去除权限；
- `=` 表示重新分配权限；
- `r` 读取权限，数字代号为“4”;
- `w` 写入权限，数字代号为“2”；
- `x` 执行或切换权限，数字代号为“1”。`-` 替换 r、w、x位置时表示没有对应的权限，对应数字为 0；
- `X` 表示如果对象是目录或者它已有执行权限，赋予执行权限 ；
- `s` 运行时重新设置 UID 或 GID ；
- `t` 设置粘着位(sticky bit)，防止文件或目录被非属主删除。

#### 实例

```shell
$ chmod u+x file             // 给file的属主增加执行权限
$ chmod 751 file             // 给file的属主分配读、写、执行(7)的权限，给file的所在组分配读、执行(5)的权限，给其他用户分配执行(1)的权限
$ chmod u=rwx,g=rx,o=x file  // 上例的另一种形式
$ chmod =r file              // 为所有用户分配读权限
$ chmod 444 file             // 同上例
$ chmod a-wx,a+r   file   　 // 同上例
$ chmod -R u+r directory     // 递归地给directory目录下所有文件和子目录的属主分配读的权限
$ chmod 4755                 // 设置用ID，给属主分配读、写和执行权限，给组和其他用户分配读、执行的权限。
```

###  chown 命令

chown 命令改变某个文件或目录的所有者和所属的组，该命令可以向某个用户授权，使该用户变成指定文件的所有者或者改变文件所属的组。用户可以是用户或者是用户D，用户组可以是组名或组[id](http://man.linuxde.net/id)。文件名可以使由空格分开的文件列表，在文件名中可以包含通配符。

只有文件主和超级用户才可以便用该命令。

#### 语法

```shell
chown [OPTION]... [OWNER][:[GROUP]] FILE...
chown [OPTION]... --reference=RFILE FILE...
```

##### 选项 

```shell
-c, --changes：类似 verbose，但仅在已变化之后报告；
-f, --silent, --quiet：不输出多数错误信息；
-v, --verbose：输出每个文件处理的诊断信息；
--dereference：影响每个符号链接的参照（默认），而不是符号链接本身；
-h, --no-dereference：影响符号链接而不是符号链接的参照（在可以改变符号链接的属主的系统上有用）；
	--from=CURRENT_OWNER:CURRENT_GROUP：改变能匹配到指定属主和/或属组的每个文件的属主和/或属组。属主和属组都可以省略，就不用匹配省略的属性；
	--no-preserve-root：对根目录 `/` 不做特殊处理；
	--preserve-root：不处理根目录 `/`（默认）；
	--reference=RFILE：使用 RFILE 的属性而不是 MODE 值；
-R, --recursive：递归操作目录和文件；
// 下面的选项可修改 -R 选项遍历的层级。如果指定了多个这样的选项，仅最后一个有效。
-H：如果命令行参数是一个符号链接，则遍历它；
-L：遍历每个出现的符号链接；
-P：不遍历任何符号链接（这是默认行为）；
	--help：显示帮助信息并退出；
	--version：输出版本信息并退出。
```

##### 参数 

OWNER：指定文件的所有者和；

GROUP：指定文件的所属工作组；

FILE：指定要改变所有者和工作组的文件列表。支持多个文件和目标，支持 shell 通配符。

#### 实例 

将目录 `/usr/meng` 及其下面的所有文件、子目录的文件主改成 liu。

```shell
chown -R liu /usr/meng
```

### chgrp 命令

chgrp 命令用来改变文件或目录的属组。其中，组名可以是用户组的 id，也可以是用户组的组名。文件名可以是由空格分开的要改变属组的文件列表，也可以是由通配符描述的文件集合。如果用户不是该文件的属主或超级用户（root），则不能改变该文件的属组。

#### 语法 

```shell
chgrp [OPTION]... GROUP FILE...
chgrp [OPTION]... --reference=RFILE FILE...
```

##### 选项 

```shell
-c, --changes：类似 verbose，但仅在已变化之后报告；
-f, --silent, --quiet：不输出多数错误信息；
-v, --verbose：输出每个文件处理的诊断信息；
--dereference：影响每个符号链接的参照（默认），而不是符号链接本身；
-h, --no-dereference：影响符号链接而不是符号链接的参照（在可以改变符号链接的属主的系统上有用）；
组都可以省略，就不用匹配省略的属性；
	--no-preserve-root：对根目录 `/` 不做特殊处理；
	--preserve-root：不处理根目录 `/`（默认）；
	--reference=RFILE：使用 RFILE 的属性而不是 MODE 值；
-R, --recursive：递归操作目录和文件；
// 下面的选项可修改 -R 选项遍历的层级。如果指定了多个这样的选项，仅最后一个有效。
-H：如果命令行参数是一个符号链接，则遍历它；
-L：遍历每个出现的符号链接；
-P：不遍历任何符号链接（这是默认行为）；
	--help：显示帮助信息并退出；
	--version：输出版本信息并退出。
```

##### 参数 

- GROUP：指定的新的属组名；
- FILE：要改变属组的文件列表。多个文件或者目录之间使用空格隔开。

#### 实例 

将`/usr/meng`及其子目录下的所有文件的用户组改为 mengxin。

```shell
chgrp -R mengxin /usr/meng
```

