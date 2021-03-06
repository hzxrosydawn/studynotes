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

```shell
[root@localhost ~]# ls
anaconda-ks.cfg  install.log  install.log.syslog  satools
```

2. ls -a 显示当前目录下包括隐藏文件在内的所有文件列表。

```shell
[root@localhost ~]# ls -a
.   anaconda-ks.cfg  .bash_logout   .bashrc  install.log         .mysql_history  satools  .tcshrc   .vilocalhostc
..  .bash_history    .bash_profile  .cshrc   install.log.syslog  .rnd            .ssh     .viminfo
```

3. ls -i 显示文件的 inode 信息。

索引节点（index inode，简称为“inode”）是 Linux 中一个特殊的概念。具有相同的索引节点号的两个文本本质上是同一个文件（除文件名不同外）。

```shell
[root@localhost ~]# ls -il anaconda-ks.cfg install.log
2345481 -rw------- 1 root root   859 Jun 11 22:49 anaconda-ks.cfg
2345474 -rw-r--r-- 1 root root 13837 Jun 11 22:49 install.log
```

4. ls -m 以逗号分隔输出结果。

```shell
[root@localhost /]# ls -m
bin, boot, data, dev, etc, home, lib, lost+found, media, misc, mnt, opt, proc, root, sbin, selinux, srv, sys, tmp, usr, var
```

5. ls -t 按最近修改时间排列输出结果，最近修改的文件显示在最上面。

```shell
[root@localhost /]# ls -t
tmp  root  etc  dev  lib  boot  sys  proc  data  home  bin  sbin  usr  var  lost+found  media  mnt  opt  selinux  srv  misc
```

6. ls -R 显示递归文件。

```shell
[root@localhost ~]# ls -R
.:
anaconda-ks.cfg  install.log  install.log.syslog  satools

./satools:
black.txt  freemem.sh  iptables.sh  lnmp.sh  mysql  php502_check.sh  ssh_safe.sh
```

7. ls -n 打印文件的 UID 和 GID。

```shell
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

8. ls -l 列出文件和文件夹的详细信息（使用频率高）。

```shell
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

9. ls -lh 将文件大小以更好的可读性显示出来。

```shell
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

10. ls -ld 仅显示目录的信息。

```shell
[root@localhost /]# ls -ld /etc/
drwxr-xr-x 75 root root 4096 Oct 16 04:02 /etc/
```

11. ls -lt 按 mtime 列出文件和目录的详细信息。最近修改的文件的在前面。

```shell
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

12. ls -ltr 按最近修改时间的逆序列出文件和目录的详细信息。

```shell
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

13. ls -F 按照特殊字符对文件进行分类。

```shell
[root@localhost nginx-1.2.1]# ls -F
auto/  CHANGES  CHANGES.ru  conf/  configure*  contrib/  html/  LICENSE  Makefile  man/  objs/  README  src/
```

14. ls --color=auto 列出文件并标记颜色分类。蓝色表示目录，绿色表示可执行文件，红色表示压缩文件，浅蓝色表示链接文件，灰色表示其他类型的文件。

```shell
[root@localhost nginx-1.2.1]# ls --color=auto
auto  CHANGES  CHANGES.ru  conf  configure  contrib  html  LICENSE  Makefile  man  objs  README  src
```

15. 使用占位符来过滤文件列表。其中，问号（?）代表一个字符，星号（*）代表零个或多个字符，中括号（[]）可以进行范围匹配，感叹号（!）可以进行排除匹配。

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

### cat 命令

**cat 命令**拼接文本文件内容，并打印到标准输出设备上。cat 命令经常用来显示文件的内容，类似于下的 type 命令。

#### 语法

```shell
cat [OPTION]... [FILE]...
```

##### 选项

```shell
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

```shell
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

```shell
more [OPTION]... [FILE]...
```

##### 选项

```shell
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

2. 显示文件 file 的内容，每 10 行显示一次，而且在显示之前先清屏。

```shell
more -c -10 file
```

### less 命令

#### 描述

**less 命令**的作用与 more 十分相似，都可以用来浏览文字档案的内容，不同的是 less 命令允许用户向前或向后浏览文件，而 more 命令只能向前浏览。用 less 命令显示文件时，用 PageUp 键向上翻页，用 PageDown 键向下翻页。要退出 less 程序，应按 Q 键。

#### 语法

```shell
less [OPTION]... [FILE]...
```

##### 选项

```shell
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

```shell
tail [OPTION]... [FILE]...
```

##### 选项

```shell
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

```shell
head [OPTION]... [FILE]...
```

##### 选项

```shell
-n, --lines=[-]K：指定显示头部的 K 行内容。使用 -K 形式时，显示出除了末尾 K 行内容以外的所有内容；
-c, --bytes=[-]K：指定显示头部的 K 个字符。使用 -K 形式时，显示出除了末尾 K 个字节以外的所有内容；
-q, --quiet, --silent：在显示头信息时不显示文件名。
-v, --verbose：总是在显示头信息时显示文件名；
```

##### 参数

FILE：指定显示头部内容的文件列表。

### file 命令

#### 描述

**file 命令**用来探测给定文件的类型。file 命令对文件的检查分为文件系统、魔法幻数检查和语言检查3个过程。

#### 语法

```shell
file [OPTION...] [FILE...]
```

##### 选项

```shell
-b, --brief：列出辨识结果时，不显示文件名称；
-c, --checking-printout：详细显示指令执行过程，便于排错或分析程序执行的情形；
-f, --files-from FILE：指定名称文件，其内容有一个或多个文件名称时，让 file 依序辨识这些文件，格式为每列一个文件名称；
-L, --dereference：跟随符号链接。即直接显示符号连接所指向的文件类别；
-h, --no-dereference：不跟随符号链接；
-m, --magic-file LIST：使用冒号分隔的列表来指定魔法数字文件。
```

##### 参数

FILE：要确定类型的文件列表，多个文件之间使用空格分开，可以使用 shell 通配符匹配多个文件。

#### 实例

1. 显示文件类型。

```shell
[root@localhost ~]# file install.log
install.log: UTF-8 Unicode text
[root@localhost ~]# file -b install.log      #不显示文件名称
UTF-8 Unicode text
[root@localhost ~]# file -i install.log      #显示MIME类别。
install.log: text/plain; charset=utf-8
[root@localhost ~]# file -b -i install.log
text/plain; charset=utf-8
```

2. 显示符号链接的文件类型。

```shell
[root@localhost ~]# ls -l /var/mail
lrwxrwxrwx 1 root root 10 08-13 00:11 /var/mail -> spool/mail
[root@localhost ~]# file /var/mail
/var/mail: symbolic link to `spool/mail'
[root@localhost ~]# file -L /var/mail
/var/mail: directory
[root@localhost ~]# file /var/spool/mail
/var/spool/mail: directory
[root@localhost ~]# file -L /var/spool/mail
/var/spool/mail: directory
```

### stat 命令

stat 命令用于显示文件的状态信息。stat 命令的输出信息比 ls 命令的输出信息要更详细。

#### 语法 

```shell
 stat [OPTION]... FILE...
```

##### 选项 

```shell
-L, --dereference：支持符号链接；
-f, --file-system：显示文件系统状态而不是文件状态；
-c  --format=FORMAT：使用指定的格式而不是默认格式，在每个 FORMAT 应用后面输出一个换行符；
	--printf=FORMAT：与 --format 类似，但会解析反斜线转义符，且不会输出强制的换行符。如果需要换行符，就在 FORMAT 中包含 \n；
-t, --terse：以简洁方式输出信息；
	--help：显示帮助信息并退出；
	--version：输出版本信息并退出。
```

##### 参数 

FILE：指定要显示信息的普通文件或者文件系统对应的设备文件名。

#### 实例 

```shell
[root@localhost vincent]# ls -l test.txt 
-rw-rw-r-- 1 vincent vincent 64 Mar  1 21:00 test.txt
[root@localhost vincent]# stat test.txt 
  File: ‘test.txt’
  Size: 64              Blocks: 8          IO Block: 4096   regular file
Device: fd01h/64769d    Inode: 2458583     Links: 1
Access: (0664/-rw-rw-r--)  Uid: ( 1000/ vincent)   Gid: ( 1000/ vincent)
Access: 2018-04-15 20:58:17.428766874 +0800
Modify: 2018-03-01 21:00:08.284469479 +0800
Change: 2018-03-01 21:00:08.287469441 +0800
 Birth: -
[root@localhost vincent]# stat -f test.txt 
  File: "test.txt"
    ID: efb76fb81de3d6e8 Namelen: 255     Type: ext2/ext3
Block size: 4096       Fundamental block size: 4096
Blocks: Total: 10288208   Free: 9063952    Available: 8539677
Inodes: Total: 2621440    Free: 2555692
[root@localhost vincent]# stat -t test.txt   
test.txt 64 8 81b4 1000 1000 fd01 2458583 1 0 0 1523797097 1519909208 1519909208 0 4096
[root@localhost vincent]# 
```
### type 命令

type 命令用来显示指定命令的类型，判断给出的指令是内部指令还是外部指令。

命令类型：

- alias：别名。
- keyword：关键字，Shell 保留字。
- function：函数，Shell 函数。
- builtin：内建命令，Shell 内建命令。
- file：文件，磁盘文件，外部命令。
- unfound：没有找到。

#### 语法 

```shell
type [-afptP] COMMAND [COMMAND ...]
type [OPTION] COMMAND [COMMAND ...]
```

##### 选项 

```shell
-t：输出“file”、“alias”或者“builtin”，分别表示给定的指令为“外部指令”、“命令别名”或者“内部指令”；
-p：如果给出的指令为外部指令，则显示其绝对路径；
-a：在环境变量“PATH”指定的路径中，显示给定指令的信息，包括命令别名。
```

##### 参数 

COMMAND：要显示类型的指令。

#### 实例 

```shell
[root@localhost ~]# type ls
ls is aliased to `ls --color=tty'
[root@localhost ~]# type cd
cd is a shell builtin
[root@localhost ~]# type date
date is /bin/date
[root@localhost ~]# type mysql
mysql is /usr/bin/mysql
[root@localhost ~]# type nginx
-bash: type: nginx: not found
[root@localhost ~]# type if
if is a shell keyword
[root@localhost ~]# type which
which is aliased to `alias | /usr/bin/which --tty-only --read-alias --show-dot --show-tilde'
[root@localhost ~]# type -a cd
cd is a shell builtin
[root@localhost ~]# type -a grep
grep is /bin/grep
```