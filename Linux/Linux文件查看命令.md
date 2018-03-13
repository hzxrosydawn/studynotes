---
typora-copy-images-to: ..\..\graphs\photos
typora-root-url: ..\..\graphs\photos
---

### ls 命令

#### 描述

**ls 命令**用来显示目标列表，在 Linux 中是使用率较高的命令。ls 命令的输出信息可以进行彩色加亮显示，以分区不同类型的文件。

#### 语法

```shell
ls [OPTION]... [FILE]...
```

##### 选项

```shell
-a, --all：显示所有文件，包括隐藏的文件；
-A, --almost-all：显示除“.”和“..”以外的所有文件列表，包括隐藏的文件；
-C：多列显示输出结果，仅显示出名称。这是默认选项；
-l：与“-C”选项功能相反，所有输出信息用单列格式输出，不输出为多列。输出的信息比较详细；
-F, --classify ：在每个输出项（文件名或目录名）后面追加文件的类型标识符，具体含义：“*”表示具有可执行权限的普通文件，“/”表示目录，“@”表示符号链接，“|”表示命令管道FIFO，“=”表示sockets套接字。当文件为普通文件时，不输出任何标识符；
-b：将文件中的不可输出的字符以反斜线“\”加字符编码的方式输出（转义形式）；
--block-size=SIZE：以SIZE指定的单位显示文件大小。SIZE可以为 K, M, G, T, P, E, Z, Y (1024的幂)或 KB, MB, ... (1000的幂)；
-B, --ignore-backups：不显示以“~”结尾的备份文件；
-c：与“-lt”选项连用时，按照文件的 ctime 排序输出文件列表，排序的依据是文件的索引节点中的 ctime 字段。与“-l”选项连用时，显示 ctime 并按文件名排序，否则按 ctime 排序，最新的文件在前面；
-d, --directory：仅显示目录名，而不显示目录下的内容列表。显示符号链接文件本身，而不显示其所指向的目录列表；
-U：不分类，按目录顺序列出文件列表；
-f：此选项的效果和同时指定“aU”选项相同，并关闭“-ls --color”选项的效果；
-i, --inode：显示文件索引节点号（inode）。一个索引节点唯一代表一个文件；
--file-type：与“-F”选项的功能相同，但是不显示“*”；
-k：以KB（千字节）为单位显示文件大小；
-l：以长格式显示目录下的内容列表。输出的信息从左到右依次包括文件名，文件类型、权限模式、硬连接数、所有者、组、文件大小和文件的最后修改时间等；
-h, --human-readable：与“-l”选项连用，以更强的可阅读性显示输出文件大小。
-m：用“,”号分隔每个文件和目录的名称；
-n：以用户识别码和群组识别码替代其名称；
-r：当排序输出时以逆序排列输出文件列表；
-R, --recursive：递归显示出子文件中的文件列表；
-s：显示文件和目录的大小，以区块为单位；
-L：如果遇到性质为符号链接的文件或目录，直接列出该链接所指向的原始文件或目录；
-R：递归处理，将指定目录下的所有文件及子目录一并处理；
--full-time：列出完整的日期与时间；
--color[=WHEN]：使用不同的颜色高亮显示不同类型的。可以是 never、auto、always（默认）。LS_COLORS 环境变量可以设置输出颜色的配置。
-1:按每个文件一行输出；
-X：按文件扩展名的字母顺序排列；
-S：以文件大小排序；
-t：用文件的 mtime 排序，较新的文件在前；
--sort=WORD：根据 WORD 来排列输出结果。WORD 可以为-U（none）、-S（size）、-t（time）、-v（version）、-X（extension）；
--time=WORD：与“-l”选项一起，按 WORD 指定的时间来替代默认的 mtime。WORD 可以为 atime 或 access 或 use（-u）、ctime 或 status（-c）。如果还使用了“--sort=time”选项，则可以使用指定的时间作为排序依据。
```

##### 参数

指定要显示列表的目录，也可以是具体的文件列表。

#### 实例

1. ls 命令的无选项形式显示当前目录下非隐藏文件与目录。

```
[root@localhost ~]# ls
anaconda-ks.cfg  install.log  install.log.syslog  satools
```

1. ls -a 显示当前目录下包括隐藏文件在内的所有文件列表。

```
[root@localhost ~]# ls -a
.   anaconda-ks.cfg  .bash_logout   .bashrc  install.log         .mysql_history  satools  .tcshrc   .vilocalhostc
..  .bash_history    .bash_profile  .cshrc   install.log.syslog  .rnd            .ssh     .viminfo
```

1. ls -l 输出长格式列表。

```
[root@localhost ~]# ls -l
anaconda-ks.cfg
install.log
install.log.syslog
satools
```

1. ls -i 显示文件的inode信息

索引节点（index inode，简称为“inode”）是Linux中一个特殊的概念。具有相同的索引节点号的两个文本本质上是同一个文件（除文件名不同外）。

```
[root@localhost ~]# ls -il anaconda-ks.cfg install.log
2345481 -rw------- 1 root root   859 Jun 11 22:49 anaconda-ks.cfg
2345474 -rw-r--r-- 1 root root 13837 Jun 11 22:49 install.log
```

1. ls -m 以逗号分隔输出结果。

```
[root@localhost /]# ls -m
bin, boot, data, dev, etc, home, lib, lost+found, media, misc, mnt, opt, proc, root, sbin, selinux, srv, sys, tmp, usr, var
```

1. ls -t 按最近修改时间排列输出结果，最近修改的文件显示在最上面。

```
[root@localhost /]# ls -t
tmp  root  etc  dev  lib  boot  sys  proc  data  home  bin  sbin  usr  var  lost+found  media  mnt  opt  selinux  srv  misc
```

1. ls -R 显示递归文件。

```
[root@localhost ~]# ls -R
.:
anaconda-ks.cfg  install.log  install.log.syslog  satools

./satools:
black.txt  freemem.sh  iptables.sh  lnmp.sh  mysql  php502_check.sh  ssh_safe.sh
```

1. ls -n 打印文件的UID和GID

```
[root@localhost /]# ls -n
total 254
drwxr-xr-x   2 0 0  4096 Jun 12 04:03 bin
drwxr-xr-x   4 0 0  1024 Jun 15 14:45 boot
drwxr-xr-x   6 0 0  4096 Jun 12 10:26 data
drwxr-xr-x  10 0 0  3520 Sep 26 15:38 dev
drwxr-xr-x  75 0 0  4096 Oct 16 04:02 etc
drwxr-xr-x   4 0 0  4096 Jun 12 10:26 home
drwxr-xr-x  14 0 0 12288 Jun 16 04:02 lib
drwx------   2 0 0 16384 Jun 11 22:46 lost+found
drwxr-xr-x   2 0 0  4096 May 11  2011 media
drwxr-xr-x   2 0 0  4096 Nov  8  2010 misc
drwxr-xr-x   2 0 0  4096 May 11  2011 mnt
drwxr-xr-x   2 0 0  4096 May 11  2011 opt
dr-xr-xr-x 232 0 0     0 Jun 15 11:04 proc
drwxr-x---   4 0 0  4096 Oct 15 14:43 root
drwxr-xr-x   2 0 0 12288 Jun 12 04:03 sbin
drwxr-xr-x   2 0 0  4096 May 11  2011 selinux
drwxr-xr-x   2 0 0  4096 May 11  2011 srv
drwxr-xr-x  11 0 0     0 Jun 15 11:04 sys
drwxrwxrwt   3 0 0 98304 Oct 16 08:45 tmp
drwxr-xr-x  13 0 0  4096 Jun 11 23:38 usr
drwxr-xr-x  19 0 0  4096 Jun 11 23:38 var
```

1. ls -l 列出文件和文件夹的详细信息（使用频率高）。

```
[root@localhost /]# ls -l
total 254
drwxr-xr-x   2 root root  4096 Jun 12 04:03 bin
drwxr-xr-x   4 root root  1024 Jun 15 14:45 boot
drwxr-xr-x   6 root root  4096 Jun 12 10:26 data
drwxr-xr-x  10 root root  3520 Sep 26 15:38 dev
drwxr-xr-x  75 root root  4096 Oct 16 04:02 etc
drwxr-xr-x   4 root root  4096 Jun 12 10:26 home
drwxr-xr-x  14 root root 12288 Jun 16 04:02 lib
drwx------   2 root root 16384 Jun 11 22:46 lost+found
drwxr-xr-x   2 root root  4096 May 11  2011 media
drwxr-xr-x   2 root root  4096 Nov  8  2010 misc
drwxr-xr-x   2 root root  4096 May 11  2011 mnt
drwxr-xr-x   2 root root  4096 May 11  2011 opt
dr-xr-xr-x 232 root root     0 Jun 15 11:04 proc
drwxr-x---   4 root root  4096 Oct 15 14:43 root
drwxr-xr-x   2 root root 12288 Jun 12 04:03 sbin
drwxr-xr-x   2 root root  4096 May 11  2011 selinux
drwxr-xr-x   2 root root  4096 May 11  2011 srv
drwxr-xr-x  11 root root     0 Jun 15 11:04 sys
drwxrwxrwt   3 root root 98304 Oct 16 08:48 tmp
drwxr-xr-x  13 root root  4096 Jun 11 23:38 usr
drwxr-xr-x  19 root root  4096 Jun 11 23:38 var
```

1. ls -lh 将文件大小以更好的可读性显示出来。

```
[root@localhost /]# ls -lh
total 254K
drwxr-xr-x   2 root root 4.0K Jun 12 04:03 bin
drwxr-xr-x   4 root root 1.0K Jun 15 14:45 boot
drwxr-xr-x   6 root root 4.0K Jun 12 10:26 data
drwxr-xr-x  10 root root 3.5K Sep 26 15:38 dev
drwxr-xr-x  75 root root 4.0K Oct 16 04:02 etc
drwxr-xr-x   4 root root 4.0K Jun 12 10:26 home
drwxr-xr-x  14 root root  12K Jun 16 04:02 lib
drwx------   2 root root  16K Jun 11 22:46 lost+found
drwxr-xr-x   2 root root 4.0K May 11  2011 media
drwxr-xr-x   2 root root 4.0K Nov  8  2010 misc
drwxr-xr-x   2 root root 4.0K May 11  2011 mnt
drwxr-xr-x   2 root root 4.0K May 11  2011 opt
dr-xr-xr-x 235 root root    0 Jun 15 11:04 proc
drwxr-x---   4 root root 4.0K Oct 15 14:43 root
drwxr-xr-x   2 root root  12K Jun 12 04:03 sbin
drwxr-xr-x   2 root root 4.0K May 11  2011 selinux
drwxr-xr-x   2 root root 4.0K May 11  2011 srv
drwxr-xr-x  11 root root    0 Jun 15 11:04 sys
drwxrwxrwt   3 root root  96K Oct 16 08:49 tmp
drwxr-xr-x  13 root root 4.0K Jun 11 23:38 usr
drwxr-xr-x  19 root root 4.0K Jun 11 23:38 var
```

1. ls -ld 仅显示目录的信息。

```
[root@localhost /]# ls -ld /etc/
drwxr-xr-x 75 root root 4096 Oct 16 04:02 /etc/
```

1. ls -lt 按 mtime 列出文件和目录的详细信息。最近修改的文件的在前面。

```
[root@localhost /]# ls -lt
total 254
drwxrwxrwt   3 root root 98304 Oct 16 08:53 tmp
drwxr-xr-x  75 root root  4096 Oct 16 04:02 etc
drwxr-x---   4 root root  4096 Oct 15 14:43 root
drwxr-xr-x  10 root root  3520 Sep 26 15:38 dev
drwxr-xr-x  14 root root 12288 Jun 16 04:02 lib
drwxr-xr-x   4 root root  1024 Jun 15 14:45 boot
drwxr-xr-x  11 root root     0 Jun 15 11:04 sys
dr-xr-xr-x 232 root root     0 Jun 15 11:04 proc
drwxr-xr-x   6 root root  4096 Jun 12 10:26 data
drwxr-xr-x   4 root root  4096 Jun 12 10:26 home
drwxr-xr-x   2 root root  4096 Jun 12 04:03 bin
drwxr-xr-x   2 root root 12288 Jun 12 04:03 sbin
drwxr-xr-x  13 root root  4096 Jun 11 23:38 usr
drwxr-xr-x  19 root root  4096 Jun 11 23:38 var
drwx------   2 root root 16384 Jun 11 22:46 lost+found
drwxr-xr-x   2 root root  4096 May 11  2011 media
drwxr-xr-x   2 root root  4096 May 11  2011 mnt
drwxr-xr-x   2 root root  4096 May 11  2011 opt
drwxr-xr-x   2 root root  4096 May 11  2011 selinux
drwxr-xr-x   2 root root  4096 May 11  2011 srv
drwxr-xr-x   2 root root  4096 Nov  8  2010 misc
```

1. ls -ltr 按最近修改时间的逆序列出文件和目录的详细信息。

```
[root@localhost /]# ls -ltr
total 254
drwxr-xr-x   2 root root  4096 Nov  8  2010 misc
drwxr-xr-x   2 root root  4096 May 11  2011 srv
drwxr-xr-x   2 root root  4096 May 11  2011 selinux
drwxr-xr-x   2 root root  4096 May 11  2011 opt
drwxr-xr-x   2 root root  4096 May 11  2011 mnt
drwxr-xr-x   2 root root  4096 May 11  2011 media
drwx------   2 root root 16384 Jun 11 22:46 lost+found
drwxr-xr-x  19 root root  4096 Jun 11 23:38 var
drwxr-xr-x  13 root root  4096 Jun 11 23:38 usr
drwxr-xr-x   2 root root 12288 Jun 12 04:03 sbin
drwxr-xr-x   2 root root  4096 Jun 12 04:03 bin
drwxr-xr-x   4 root root  4096 Jun 12 10:26 home
drwxr-xr-x   6 root root  4096 Jun 12 10:26 data
dr-xr-xr-x 232 root root     0 Jun 15 11:04 proc
drwxr-xr-x  11 root root     0 Jun 15 11:04 sys
drwxr-xr-x   4 root root  1024 Jun 15 14:45 boot
drwxr-xr-x  14 root root 12288 Jun 16 04:02 lib
drwxr-xr-x  10 root root  3520 Sep 26 15:38 dev
drwxr-x---   4 root root  4096 Oct 15 14:43 root
drwxr-xr-x  75 root root  4096 Oct 16 04:02 etc
drwxrwxrwt   3 root root 98304 Oct 16 08:54 tmp
```

1. ls -F 按照特殊字符对文件进行分类。

```
[root@localhost nginx-1.2.1]# ls -F
auto/  CHANGES  CHANGES.ru  conf/  configure*  contrib/  html/  LICENSE  Makefile  man/  objs/  README  src/
```

1. ls --color=auto 列出文件并标记颜色分类。蓝色表示目录，绿色表示可执行文件，红色表示压缩文件，浅蓝色表示链接文件，灰色表示其他类型的文件。

```
[root@localhost nginx-1.2.1]# ls --color=auto
auto  CHANGES  CHANGES.ru  conf  configure  contrib  html  LICENSE  Makefile  man  objs  README  src
```

1. 使用占位符来过滤文件列表。其中，问号（?）代表一个字符，星号（*）代表零个或多个字符，中括号（[]）可以进行范围匹配，感叹号（！）可以进行排除匹配。

```shell
[vincent@localhost package]$ ls -l redis-3.2.9.???.gz
-rwx--x--x 1 root root 1547695 Jun 17  2017 redis-3.2.9.tar.gz
[vincent@localhost package]$ ls -l *.gz
-rwxr----x 1 vincent vincent 9393241 Jun  8  2017 apache-tomcat-8.5.15.tar.gz
-rwx--x--x 1 root    root    1547695 Jun 17  2017 redis-3.2.9.tar.gz
[vincent@localhost package]$ ls -l test0[1-3]
-rw-rw-r-- 1 vincent vincent 0 Jan  1 10:38 test01
-rw-rw-r-- 1 vincent vincent 0 Jan  1 10:38 test02
-rw-rw-r-- 1 vincent vincent 0 Jan  1 10:38 test03
[vincent@localhost package]$ ls -l test0[!1]
-rw-rw-r-- 1 vincent vincent 0 Jan  1 10:38 test02
-rw-rw-r-- 1 vincent vincent 0 Jan  1 10:38 test03
[vincent@localhost package]$ 
```

ls -|*|grep "^-"| wc -|

### cat 命令

**cat 命令**拼接文本文件内容，并打印到标准输出设备上。cat 命令经常用来显示文件的内容，类似于下的 type 命令。

#### 语法

```
cat [OPTION]... [FILE]...
```

##### 选项

```
-n, --number：从1开始对所有输出的行数编号；
-b, --number-nonblank：和 -n 相似，只不过对于空白行不编号；
-s或--squeeze-blank：当遇到有连续两行以上的空白行，就代换为一行的空白行；
-A：显示不可打印字符，行尾显示“$”；
-T, --show-tabs：将文本内容中的制表符 TAB 以 ^I 替代显示；
-E, --show-ends：在文件末尾显示 $;
-v, --show-nonprinting：除了 LFD 和 TAB 依赖，使用 ^ 和 M- 符号；
-e：等价于"-vE"选项；
-t：等价于"-vT"选项；
```

##### 参数

FILE：指定要拼接的文件列表。

#### 实例

显示文本内容和拼接显示多个文本的内容。

```
[root@localhost testdir01]# cat test01
this is text in test01 file.
[root@localhost testdir01]# cat test02
 this is text in test02 file.
[root@localhost testdir01]# cat test01 test02 > test03
[root@localhost testdir01]# cat test03
this is text in test01 file.
 this is text in test02 file.
[root@Mr testdir01]# cat -n test03
     1	this is text in test01 file.
     2	 this is text in test02 file.
[root@Mr testdir01]# 
```

### more 命令

#### 描述

**more 命令**是一个基于 vi 编辑器文本过滤器，它以全屏幕的方式按页显示文本文件的内容，支持 vi 中的关键字定位操作。more 名单中内置了若干快捷键，常用的有 H（获得帮助信息），Enter（向下翻滚一行），空格（向下滚动一屏），Q（退出命令）。

该命令一次显示一屏文本，满屏后停下来，并且在屏幕的底部出现一个提示信息，给出至今己显示的该文件的百分比：--More--（XX%）可以用下列不同的方法对提示做出回答：

- 按 Space 键：显示文本的下一屏内容；
- 按 Enter 键：只显示文本的下一行内容；
- 按斜线符 /：接着输入一个模式，可以在文本中寻找下一个相匹配的模式；
- 按 H 键：显示帮助屏，该屏上有相关的帮助信息；
- 按 B 键：显示上一屏内容；
- 按 Q 键：退出 more 命令。

注意：当文件较大时，使用 cat 命令的话，文本在屏幕上迅速闪过（滚屏），用户往往看不清所显示的内容。因此，一般用 more 等命令分屏显示。为了控制滚屏，可以按 Ctrl+S 键，停止滚屏；按 Ctrl+Q 键可以恢复滚屏。按 Ctrl+C（中断）键可以终止该命令的执行，并且返回 Shell 提示符状态。

#### 语法

```
more [OPTION]... [FILE]...
```

##### 选项

```
-NUM：指定每屏显示NUM行；
-d：显示“[press space to continue,'q' to quit.]”和“[Press 'h' for instructions]”；
-c：不进行滚屏操作。每次刷新这个屏幕；
-s：将多个空行压缩成一行显示；
-u：禁止下划线；
+NUM：从NUM行开始显示；
+/STRING：从匹配的查询字符串开始显示。
```

##### 参数

FILE：指定分页显示内容的文件。

#### 实例

1. 显示文件 file 的内容，但在显示之前先清屏，并且在屏幕的最下方显示完核的百分比。

```shell
more -dc file
```

1. 显示文件 file 的内容，每 10 行显示一次，而且在显示之前先清屏。

```shell
more -c -10 file
```

### less 命令

#### 描述

**less 命令**的作用与 more 十分相似，都可以用来浏览文字档案的内容，不同的是 less 命令允许用户向前或向后浏览文件，而 more 命令只能向前浏览。用 less 命令显示文件时，用 PageUp 键向上翻页，用 PageDown 键向下翻页。要退出 less 程序，应按 Q 键。

#### 语法

```
less [OPTION]... [FILE]...
```

##### 选项

```
-e，-E：文件内容显示完毕后，自动退出；
-f，--force：强制显示非一般文件；
-g：不加亮显示搜索到的所有关键词，仅显示当前显示的关键字，以提高显示速度；
-I：搜索时忽略大小写的差异；
-N：每一行行首显示行号；
-s：将连续多个空行压缩成一行显示；
-S：在单行显示较长的内容，而不换行显示；
-xN：将 TAB 字符显示为N个空格字符。
```

##### 参数

FILE：指定要分屏显示内容的文件。

### tail 命令

#### 描述

**tail 命令**用于将文件中的尾部内容打印到标准输出。tail 命令默认在屏幕上显示指定文件的末尾 10 行。如果给定的文件不止一个，则在显示的每个文件前面加一个文件名标题。如果没有指定文件或者文件名为“-”，则读取标准输入。

#### 语法

```
tail [OPTION]... [FILE]...
```

##### 选项

```
--retry：即是在tail命令启动时，文件不可访问或者文件稍后变得不可访问，都始终尝试打开文件。使用此选项时需要与选项“——follow=name”连用；
-c, --bytes=K：输出文件尾部的 K（K 为整数）个字节内容。或者使用 -c +K 来从第 K 个字节内容开始显示；
-f, --follow[={name|descriptor}]：显示文件最新追加的内容。“name”表示以文件名的方式监视文件的变化。“-f”与“-fdescriptor”等效；
-F：与选项“-follow=name --retry"功能相同；
-n, --lines=K：输出文件的尾部 K（K 为整数）行内容。K 值后面可以有后缀：b表示512，k表示1024，m表示1 048576(1M)。也开始使用 -n +K 来从第 K 行开始显示；
--pid=PID：与 -f 选项连用，当指定的进程号的进程终止后，自动退出 tail 命令；
-q, --quiet, --silent：当有多个文件参数时，不输出各个文件名；
-s, --sleep-interval=N：与“-f”选项连用，指定监视文件变化时间间隔为N秒；
-v, --verbose：当有多个文件参数时，总是输出各个文件名。
```

##### 参数

FILE：指定要显示尾部内容的文件列表。

#### 实例

```shell
tail file #显示文件file的最后10行
tail +20 file #显示文件file的内容，从第20行至文件末尾
tail -c 10 file #显示文件file的最后10个字符
tail -f app.log #显示日志文件app.log最新追加的内容。用于监控日志十分方便。
```

### head 命令

#### 描述

**head 命令**用于显示文件的开头的内容。在默认情况下，head 命令显示文件的头 10 行的内容。

#### 语法

```
head [OPTION]... [FILE]...
```

##### 选项

```
-n, --lines=[-]K：指定显示头部的 K 行内容。使用 -K 形式时，显示出除了末尾 K 行内容以外的所有内容；
-c, --bytes=[-]K：指定显示头部的 K 个字符。使用 -K 形式时，显示出除了末尾 K 个字节以外的所有内容；
-q, --quiet, --silent：在显示头信息时不显示文件名。
-v, --verbose：总是在显示头信息时显示文件名；
```

##### 参数

FILE：指定显示头部内容的文件列表。

### sort 命令

**sort 命令**是在 Linux 里非常有用，它将文件进行排序，并将排序结果标准输出。sort命令既可以从特定的文件，也可以从stdin中获取输入。

### 语法

```
Usage: sort [OPTION]... [FILE]...
   or: sort [OPTION]... --files0-from=F
```

### 选项

```
-b：忽略每行前面开始出的空格字符；
-c：检查文件是否已经按照顺序排序；
-d：排序时，处理英文字母、数字及空格字符外，忽略其他的字符；
-f：排序时，将小写字母视为大写字母；
-i：排序时，除了040至176之间的ASCII字符外，忽略其他的字符；
-m：将几个排序号的文件进行合并；
-M：将前面3个字母依照月份的缩写进行排序；
-n：依照数值的大小排序；
-o<输出文件>：将排序后的结果存入制定的文件；
-r：以相反的顺序来排序；
-t<分隔字符>：指定排序时所用的栏位分隔字符；
+<起始栏位>-<结束栏位>：以指定的栏位来排序，范围由起始栏位到结束栏位的前一栏位。

-b, --ignore-leading-blanks：忽略每行前面开始出的空格字符；
-d, --dictionary-order：排序时仅处理英文字母、数字及空格字符外，忽略其他的字符；
-f, --ignore-case：          fold lower case to upper case characters
-g, --general-numeric-sort  compare according to general numerical value
-i, --ignore-nonprinting    consider only printable characters
-M, --month-sort            compare (unknown) < 'JAN' < ... < 'DEC'
-h, --human-numeric-sort    compare human readable numbers (e.g., 2K 1G)
-n, --numeric-sort          compare according to string numerical value
-R, --random-sort           sort by random hash of keys
    --random-source=FILE    get random bytes from FILE
-r, --reverse               reverse the result of comparisons
    --sort=WORD             sort according to WORD:
                                general-numeric -g, human-numeric -h, month -M,
                                numeric -n, random -R, version -V
-V, --version-sort          natural sort of (version) numbers within text

Other options:

    --batch-size=NMERGE   merge at most NMERGE inputs at once;
                            for more use temp files
-c, --check, --check=diagnose-first  check for sorted input; do not sort
-C, --check=quiet, --check=silent  like -c, but do not report first bad line
    --compress-program=PROG  compress temporaries with PROG;
                              decompress them with PROG -d
    --debug               annotate the part of the line used to sort,
                              and warn about questionable usage to stderr
    --files0-from=F       read input from the files specified by
                            NUL-terminated names in file F;
                            If F is - then read names from standard input
-k, --key=KEYDEF          sort via a key; KEYDEF gives location and type
-m, --merge               merge already sorted files; do not sort
-o, --output=FILE         write result to FILE instead of standard output
-s, --stable              stabilize sort by disabling last-resort comparison
-S, --buffer-size=SIZE    use SIZE for main memory buffer
-t, --field-separator=SEP  use SEP instead of non-blank to blank transition
-T, --temporary-directory=DIR  use DIR for temporaries, not $TMPDIR or /tmp;
                              multiple options specify multiple directories
    --parallel=N          change the number of sorts run concurrently to N
-u, --unique              with -c, check for strict ordering;
                              without -c, output only the first of an equal run
-z, --zero-terminated     end lines with 0 byte, not newline
    --help     display this help and exit
    --version  output version information and exit
```

### 参数

文件：指定待排序的文件列表。

### 实例

sort将文件/文本的每一行作为一个单位，相互比较，比较原则是从首字符向后，依次按[ASCII](http://zh.wikipedia.org/zh/ASCII)码值进行比较，最后将他们按升序输出。

```
[root@mail text]# cat sort.txt
aaa:10:1.1
ccc:30:3.3
ddd:40:4.4
bbb:20:2.2
eee:50:5.5
eee:50:5.5

[root@mail text]# sort sort.txt
aaa:10:1.1
bbb:20:2.2
ccc:30:3.3
ddd:40:4.4
eee:50:5.5
eee:50:5.5
```

忽略相同行使用-u选项或者[uniq](http://man.linuxde.net/uniq)：

```
[root@mail text]# cat sort.txt
aaa:10:1.1
ccc:30:3.3
ddd:40:4.4
bbb:20:2.2
eee:50:5.5
eee:50:5.5

[root@mail text]# sort -u sort.txt
aaa:10:1.1
bbb:20:2.2
ccc:30:3.3
ddd:40:4.4
eee:50:5.5

或者

[root@mail text]# uniq sort.txt
aaa:10:1.1
ccc:30:3.3
ddd:40:4.4
bbb:20:2.2
eee:50:5.5

```

sort的-n、-r、-k、-t选项的使用：

```
[root@mail text]# cat sort.txt
AAA:BB:CC
aaa:30:1.6
ccc:50:3.3
ddd:20:4.2
bbb:10:2.5
eee:40:5.4
eee:60:5.1

#将BB列按照数字从小到大顺序排列：
[root@mail text]# sort -nk 2 -t: sort.txt
AAA:BB:CC
bbb:10:2.5
ddd:20:4.2
aaa:30:1.6
eee:40:5.4
ccc:50:3.3
eee:60:5.1

#将CC列数字从大到小顺序排列：
[root@mail text]# sort -nrk 3 -t: sort.txt
eee:40:5.4
eee:60:5.1
ddd:20:4.2
ccc:50:3.3
bbb:10:2.5
aaa:30:1.6
AAA:BB:CC

# -n是按照数字大小排序，-r是以相反顺序，-k是指定需要爱排序的栏位，-t指定栏位分隔符为冒号
```

**-k选项的具体语法格式：**

-k选项的语法格式：

```
FStart.CStart Modifie,FEnd.CEnd Modifier
-------Start--------,-------End--------
 FStart.CStart 选项  ,  FEnd.CEnd 选项

```

这个语法格式可以被其中的逗号`,`分为两大部分，**Start**部分和**End**部分。Start部分也由三部分组成，其中的Modifier部分就是我们之前说过的类似n和r的选项部分。我们重点说说`Start`部分的`FStart`和`C.Start`。`C.Start`也是可以省略的，省略的话就表示从本域的开头部分开始。`FStart.CStart`，其中`FStart`就是表示使用的域，而`CStart`则表示在`FStart`域中从第几个字符开始算“排序首字符”。同理，在End部分中，你可以设定`FEnd.CEnd`，如果你省略`.CEnd`，则表示结尾到“域尾”，即本域的最后一个字符。或者，如果你将CEnd设定为0(零)，也是表示结尾到“域尾”。

从公司英文名称的第二个字母开始进行排序：

```
$ sort -t ' ' -k 1.2 facebook.txt
baidu 100 5000
sohu 100 4500
google 110 5000
guge 50 3000

```

使用了`-k 1.2`，表示对第一个域的第二个字符开始到本域的最后一个字符为止的字符串进行排序。你会发现baidu因为第二个字母是a而名列榜首。sohu和 google第二个字符都是o，但sohu的h在google的o前面，所以两者分别排在第二和第三。guge只能屈居第四了。

只针对公司英文名称的第二个字母进行排序，如果相同的按照员工工资进行降序排序：

```
$ sort -t ' ' -k 1.2,1.2 -nrk 3,3 facebook.txt
baidu 100 5000
google 110 5000
sohu 100 4500
guge 50 3000

```

由于只对第二个字母进行排序，所以我们使用了`-k 1.2,1.2`的表示方式，表示我们“只”对第二个字母进行排序。（如果你问“我使用`-k 1.2`怎么不行？”，当然不行，因为你省略了End部分，这就意味着你将对从第二个字母起到本域最后一个字符为止的字符串进行排序）。对于员工工资进行排 序，我们也使用了`-k 3,3`，这是最准确的表述，表示我们“只”对本域进行排序，因为如果你省略了后面的3，就变成了我们“对第3个域开始到最后一个域位置的内容进行排序” 了。





### df 命令

**df 命令** 用于显示某个文件所在的文件系统或者所有文件系统（默认）的信息，包括磁盘总空间大小、被占用空间大小、剩余空间大小、已用空间百分比以及挂载点所在位置等信息。大小默认以 KB 为单位。

#### 语法

```shell
df [OPTION]... [FILE]...
```

##### 选项

```shell
-a, --all：包含全部的文件系统；
-B, --block-size=SIZE：以 SIZE 所指定的单位来显示区块大小。SIZE 可以为一个数值，或者加上一个可选的单位，10M 等效于 1010241024。这里的单位可以为 K、M、G、T、P、E、Z、Y（以 1024 为进率），或者 KB、MB（以 1000 为单位。SIZE 的值根据  DF_BLOCK_SIZE， BLOCK_SIZE， BLOCKSIZE 环境变量而设置，否则默认为 1024 字节（或者为 512 字节，如果设置了 POSIXLY_CORRECT 的话）；
-m, --megabytes：以 1048576 字节（1 MB）为单位显示大小；
    --direct：将挂载点显示为文件；
    --total：在输出结果的最下面一行显示出总计大小；
-h, --human-readable：以可读性较高的方式（以K、M、G为单位）显示大小；
-H, --si：同上，但以 1000 为进率而不是 1024；
-i, --inodes：显示出 inode 的信息而不是区块使用信息；
-k, --block-size=1K：以 1024 字节（1 KB）为单位来显示大小；
-l, --local：仅显示本地端的文件系统；
    --no-sync：在取得磁盘使用信息之前不执行 sync 指令，此为默认值；
    --output[=FIELD_LIST]：使用 FIELD_LIST 指定的输出格式，如果忽略 FIELD_LIST ，则打印所有字段。FIELD_LIST 为一个逗号分隔的列表，可用的名称有 source、fstype、itotal、iused、iavail、ipcent、size、used、avail、pcent、file、和target。详情参考该命令的 info 帮助信息；
-P, --portability：使用 POSIX 输出格式；
    --sync：在获取磁盘使用信息之前执行 sync 指令；
-t, --type=TYPE：仅显示 TYPE 所指定的文件系统类型的磁盘信息；
-T, --print-type：显示文件系统的类型；
-x, --exclude-type=TYPE：仅显示非 TYPE 所指定的文件系统的磁盘信息；
    --help：显示帮助；
    --version：显示版本信息。
```

> 注意：以上长格式选项的参数也适用于对应的短格式的选项。例如 `df -BM` 等同于 `df --block-size=1M` 。

##### 参数

FILE：指定文件系统上的文件。

#### 实例

1. df 命令默认会显示每个有数据的已挂载文件系统，默认以 KB 为单位：

```shell
[vincent@localhost ~]$ df
Filesystem     1K-blocks    Used Available Use% Mounted on
/dev/vda1       41152832 4920600  34135132  13% /
devtmpfs          932064       0    932064   0% /dev
tmpfs             941868       0    941868   0% /dev/shm
tmpfs             941868     348    941520   1% /run
tmpfs             941868       0    941868   0% /sys/fs/cgroup
tmpfs             188376       0    188376   0% /run/user/1000
tmpfs             188376       0    188376   0% /run/user/0
```

默认的 df 命令输出内容有：

- 设备的设备文件位置；
- 能容纳多少个1024字节（1 KB）大小的块；
- 已用了多少个1024字节（1 KB）大小的块；
- 还有多少个1024字节（1 KB）大小的块可用；
- 已用空间所占的比例；
- 设备挂载到了哪个挂载点上。 

2. 使用 -h 选项以 KB 以上的单位来显示，可读性高：

```shell
[vincent@localhost ~]$ df -h
Filesystem      Size  Used Avail Use% Mounted on
/dev/vda1        40G  4.7G   33G  13% /
devtmpfs        911M     0  911M   0% /dev
tmpfs           920M     0  920M   0% /dev/shm
tmpfs           920M  348K  920M   1% /run
tmpfs           920M     0  920M   0% /sys/fs/cgroup
tmpfs           184M     0  184M   0% /run/user/1000
tmpfs           184M     0  184M   0% /run/user/0
```

3. 以指定的单位来显示大小：

```shell
# 以下两个命令等效
[vincent@localhost ~]$ df -BM
Filesystem     1M-blocks  Used Available Use% Mounted on
/dev/vda1         40189M 4807M    33335M  13% /
devtmpfs            911M    0M      911M   0% /dev
tmpfs               920M    0M      920M   0% /dev/shm
tmpfs               920M    1M      920M   1% /run
tmpfs               920M    0M      920M   0% /sys/fs/cgroup
tmpfs               184M    0M      184M   0% /run/user/1000
tmpfs               184M    0M      184M   0% /run/user/0
[vincent@localhost ~]$ df --block-size=1M
Filesystem     1M-blocks  Used Available Use% Mounted on
/dev/vda1          40189  4807     33335  13% /
devtmpfs             911     0       911   0% /dev
tmpfs                920     0       920   0% /dev/shm
tmpfs                920     1       920   1% /run
tmpfs                920     0       920   0% /sys/fs/cgroup
tmpfs                184     0       184   0% /run/user/1000
tmpfs                184     0       184   0% /run/user/0
```

### du 命令

**du 命令** 也是查看使用空间的，但是与 df 命令不同的是， du 命令是查看的时文件和目录（其中每个子目录）所使用的磁盘空间大小。

#### 语法

```shell
du [OPTION]... [FILE]...
or:  du [OPTION]... --files0-from=F
```

##### 选项

```shell
-0, --null：在每行的末尾打印一个 0 字节（ASCII NUL），而不是一个新行，即所有输出结果不分行显示。该选项可让其他程序在输出中含有新行时解析输出结果；
-a, --all：也显示目录中文件的大小，而不仅仅是目录；
    --apparent-size：打印 APPARENT size，而不是 DISK USAGE size。尽管 APPARENT size 一般稍小，但由于稀疏文件（sparse file）文件中的“洞”（holes）、内部碎片、间接区块等，APPARENT size 也可能稍大。下面有关于稀疏文件、Apparent Size 和 Disk Usage Size 的详细介绍；
-B, --block-size=SIZE：以 SIZE 所指定的单位来显示区块大小。SIZE 可以为一个数值，或者加上一个可选的单位，10M 等效于 1010241024。这里的单位可以为 K、M、G、T、P、E、Z、Y（以 1024 为进率），或者 KB、MB（以 1000 为单位。SIZE 的值根据  DF_BLOCK_SIZE， BLOCK_SIZE， BLOCKSIZE 环境变量而设置，否则默认为 1024 字节（或者为 512 字节，如果设置了 POSIXLY_CORRECT 的话）；
-b, --bytes：等效于“--apparent-size --block-size=1”；
-c, --total：：在输出结果的最下面一行显示出总计大小；
-D, --dereference-args: 解除命令行上所列出符号链接的参照，其他符号链接不受影响。即统计时不包含符号链接所指位置的大小，而是统计符号链接源文件的大小；
-d, --max-depth=N：显示目录（如果使用了 --all 选项则也包括文件）的总计信息。N 指定了显示的最大目录深度。其中，根目录为起始目录，其深度为 0。例如，“du --max-depth=0” 等效于“du -s”； 
    --files0-from=F：简化磁盘使用空间的输出，不超过命令行的宽度。不处理命令行中的文件，仅处理 FILE 文件中的文件名（每个文件名以 ASCII NUL 结尾）。如果 F 是 “-”，就从标准输入中读取，在标准输入时每输入一个文件名就按两次 Ctrl + D；
-H：等效于“--dereference-args (-D)” ；
-h, --human-readable：以可读性较高的方式（以K、M、G为单位）显示大小；
    --inodes：显示出 inode 的信息而不是区块的使用信息； 
-k：等效于“--block-size=1K”；
-L, --dereference：解除所有符号链接的参照；
-l, --count-links：重复计算硬件链接的文件；
-m：等效于“--block-size=1M”；
-P, --no-dereference：不遵循任何符号链接（默认）；
-S, --separate-dirs：对于目录来说，不包含其子目录的大小；
    --si：类似“-h”，但使用 1000 作为进率，而不是 1024；
-s, --summarize：：显示每个输出参数的总计；
-t, --threshold=SIZE：不包含小于 SIZE（正值） 的条目或者大于 SIZE（负值） 的条目；
    --time：显示目录中所有文件和子目录的最后修改时间；
    --time=WORD：显示 WORD所表示的时间，WORD 可以为：atime、access、use、ctime 或者 status；
    --time-style=STYLE：使用 STYLE 表示时间，可以为：full-iso、long-iso、iso 或者 +FORMAT；FORMAT 被翻译成类似“date”；
-X, --exclude-from=FILE：不包含能匹配 FILE 所表示的模式的文件；
    --exclude=PATTERN：不包含匹配 PATTERN 模式的文件；
-x, --one-file-system：跳过在不同文件系统上的目录；
    --help：显示帮助并退出；
    --version：显示版本信息并退出；
```

##### 参数

FILE：要显示大小的文件列表。

**Sparse File**

稀疏文件（[Sparse File](https://zh.wikipedia.org/wiki/%E7%A8%80%E7%96%8F%E6%96%87%E4%BB%B6)）是一种计算机文件，它能尝试在文件内容大多为空时更有效率地使用文件系统的空间。它的原理是以简短的信息（元数据）表示空数据块，而不是在在磁盘上占用实际空间来存储空数据块。只有真实（非空）的数据块会按原样写入磁盘。

在读取稀疏文件时，文件系统会按元数据在运行时将这些透明转换为“真实”的数据块，即填充为零。应用程序不会察觉这个转换。

大多数现代的文件系统支持稀疏文件，包括大多数 Unix 变种和 NTFS。苹果的 HFS+ 不提供稀疏文件支持，但在 OS X 中，虚拟文件系统层支持在任何受支持文件系统中存储稀疏文件，包括 HFS+。2016 年 6 月在 WWDC 宣布的苹果文件系统（APFS）支持稀疏文件。稀疏文件常被用在磁盘映像、数据库快照、日志文件和科学应用中。

**优势**
稀疏文件的优势是，它分配的存储空间只在需要时使用：这样节省了磁盘空间，并且可以创建很大的文件，即使文件系统中的可用空间不足。这也减少了首次写入的时间，因为系统不会分配“跳过”的空间。如果初始分配需要写入全零到空间，这也使得系统不必入两次。

**缺点**
稀疏文件的缺点包括：稀疏文件可能碎片化；文件系统的空余空间报告可能产生误导；包含稀疏文件的文件系统被填满可能产生意外效果，例如只是重写现有文件的内容时遭遇磁盘已满或超出配额错误——开发者未预料到文件可能被稀疏；使用非显式支持的计算机程序复制稀疏文件可能会复制整个内容，即未压缩的文件大小，包括未实际在磁盘上分配的零空间——也就是使稀疏文件失去稀疏属性。稀疏文件也不是被所有备份软件和应用支持。不过，VFS 的实现回避了先前两个缺点。在Windows 上加载稀疏的可执行文件（exe 或 dll）可能需要更多时间，因为文件不被映射到内存和缓存。

**Apparent Size & Disk Usage Size**

`ls` 命令和 `du` 命令都可以显示 Apparent Size 和 Disk Usage Size（Normal Size）。`du` 显示 Disk Usage Size 时不使用任何参数，显示 Apparent Size 时需要使用 `--apparent-size` 参数才行。`ls` 或 `ls -l` 显示的是 Apparent Size，`ls -s` 显示的是 Disk Usage Size。

- **Apparent Size**：（在 `ls -ls` 输出的中间）是对于应用来说的大小，是应用识别出的文件实际内容大小；
- **Disk Usage Size**：（在 `ls -ls` 输出的左边）是文件所占用的磁盘空间大小。Disk Usage Size 是文件系统的区块大小的整数倍。比如，一个包含 3003 字节内容的文件的 Apparent Size 是 3003 字节，如果在区块大小为 4k 的文件系统中，由于最小存储单元为 4k = 4096 字节，所以该文件实际占用某个区块的前 3003 字节，而后面的 1093 字节空间就浪费了，该文件的 Disk Usage Size 就是 4096 字节。由于 Disk Usage Size 总会计算最后的区块完整大小，而 Usage Size 只会计算最后区块中实际包含数据的字节，所以 Disk Usage Size 一般比对应的 Apparent Size 稍大（稀疏文件除外）。不使用任何选项时的 `ls` 和 `du` 命令显示的都是 Disk Usage Size。这也是 df 命令所显示的大小。

### 实例

1. 使用 -a 和 -h 选项来以更好地可读性显示当前目录中所有文件的大小信息。使用 -c 选项在最后一行显示出所有文件的总计大小。

```shell
[vincent@localhost package]$ du -ah .
0       ./test03
9.0M    ./java_dev_tools/apache-tomcat-8.5.15.tar.gz
4.0K    ./java_dev_tools/.test1
163M    ./java_dev_tools/jdk-8u131-linux-x64.rpm
172M    ./java_dev_tools
0       ./test01
0       ./.test
0       ./test02
172M    .
[vincent@localhost package]$ du -ahc .
0       ./test03
9.0M    ./java_dev_tools/apache-tomcat-8.5.15.tar.gz
4.0K    ./java_dev_tools/.test1
163M    ./java_dev_tools/jdk-8u131-linux-x64.rpm
172M    ./java_dev_tools
0       ./test01
0       ./.test
0       ./test02
172M    .
172M    total
[vincent@localhost package]$ 
```

2. 使用 -s 选项来显示所有目录中第一层字目录和子文件的大小，可以借助 sort 命令按文件大小排序。

```shell
[root@localhost vincent]# du -sh *
619M    database
188K    document
172M    package
4.0K    result1
4.0K    result2
4.0K    result3
4.0K    test1
4.0K    test2
4.0K    test3
4.0K    test3.txt
4.0K    test4
4.0K    test.txt
35M     webapp
4.0K    webapps
[root@localhost vincent]# du -s * | sort -nr
633068  database
175372  package
35212   webapp
188     document
4       webapps
4       test.txt
4       test4
4       test3.txt
4       test3
4       test2
4       test1
4       result3
4       result2
4       result1
# 显示前 5 个大文件或目录
[root@localhost vincent]# du -s * | sort -nr | head -n 5
633068  database
175372  package
35212   webapp
188     document
4       webapps
# 显示后 5 个大文件或目录
[root@localhost vincent]# du -s * | sort -nr | tail -n 5
4       test2
4       test1
4       result3
4       result2
4       result1
[root@localhost vincent]# 
```

3. 使用 --apparent-size 选项来显示文件的 Apparent Size。

```shell
[vincent@localhost ~]$ du -s test3.txt 
4       test3.txt
[vincent@localhost ~]$ du -s --apparent-size test3.txt 
1       test3.txt
[vincent@localhost ~]$ 
```

4. 使用 du --files0-from= 选项来显示文件中所指定的文件大小。

```shell
[vincent@localhost ~]$ ll
total 7
-rw-rw-r-- 1 vincent vincent   53 Mar  7 09:14 result1
-rw-rw-r-- 1 vincent vincent  107 Mar  7 09:20 result2
-rw-rw-r-- 1 vincent vincent  664 Mar  9 17:06 result3
-rwxrw-r-- 1 vincent vincent   49 Mar  2 15:45 test1
-rwxrw-r-- 1 vincent vincent   85 Mar  5 13:49 test2
-rwxrw-r-- 1 vincent vincent  109 Mar  5 14:27 test3
-rw-rw-r-- 1 vincent vincent   41 Mar 13 09:55 test3.txt
[vincent@localhost ~]$ vim test3.txt
```

使用 Vim 编辑器中输出 ASCII  NUL 来分隔文件路径。关于如何在 Vim 中输入不可见字符，请参考：http://blog.csdn.net/chenster/article/details/53307707

![BaiduShurufa_2018-3-13_9-56-1](/BaiduShurufa_2018-3-13_9-56-1.png)

然后执行  du --files0-from=./test3.txt 就可以显示 test3.txt 文件中指定的文件的使用空间信息：

```shell
[vincent@localhost ~]$ du --files0-from=./test3.txt
4       /home/vincent/test1
4       /home/vincent/test2
```

5. 使用 --time 选项来显示文件的最后修改时间。

```shell
[root@localhost vincent]# du --time -s *
633068  2018-01-04 20:11        database
188     2018-01-16 14:17        document
175372  2018-03-13 15:28        package
4       2018-03-07 09:14        result1
4       2018-03-07 09:20        result2
4       2018-03-09 17:06        result3
4       2018-03-02 15:45        test1
4       2018-03-05 13:49        test2
4       2018-03-05 14:27        test3
4       2018-03-13 09:55        test3.txt
4       2018-03-06 16:18        test4
4       2018-03-01 21:00        test.txt
35212   2017-06-09 09:33        webapp
4       2017-06-08 23:23        webapps
[root@localhost vincent]# 
```

