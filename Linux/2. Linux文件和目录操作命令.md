### touch 命令

#### 描述

**touch 命令**有两个功能：

1. 修改文件最后访问时间和最后修改时间（同时会改变状态时间），但文件的内容将不会改变；
2. 用于创建新新的空文件（应用最多）。

先介绍以下 Linux 下文件的几种时间。

1. access time（atime，访问时间）：当读取文件内容或执行文件时，就会更改这个时间，例如使用 cat 去读取 /etc/man.config，那么该文件的 atime 就会改变；
2. modification time（mtime，修改时间）：这个时间指的是文件**内容修改的时间，而不是文件属性的修改时间**。当数据内容修改时，这个时间就会改变，用命令 ls -l 默认显示的就是这个时间；
3. status time（ctime，状态时间）：当文件的内容、所有者、权限或链接设置等**文件状态改变**时，这个时间就会改变。不过要注意的是，即使复制一个文件并复制所有属性也没有办法复制 ctime 属性。

> 文件的时间很重要，因为如果误判文件时间，可能会造成某些程序无法正常运行。

#### 语法

```shell
touch [OPTION]... [FILE]... 
```

##### 选项

```shell
-a：只更改访问时间（atime）；
-c 或 --no-create：如果指定的文件不存在，不创建这些不存在的文件；
-d 或 --date=STRING： 将 atime 和 mtime 修改为指定STRING字符串表示的时间，但 ctime 不会改变；
-f：此参数将忽略不予处理，仅负责解决BSD版本 touch 指令的兼容性问题；
-m：只更该修改时间（mtime）；
-r 或 --reference=FILE：把指定文件或目录的日期时间统统设成和参考文件或目录的日期时间相同；
-t 时间戳：使用[[CC]YY]MMDDhhmm[.ss]格式的时间戳替代当前时间；
--time=WORD：使用WORD指定的时间类型，WORD可以为：access、atime、use（都等于-a选项的效果），modify、mtime（都等于-m 选项的效果）；
--help：在线帮助；
--version：显示版本信息。
```

> 注意：
>
> - -d 或 --date 选项后面的时间日期字符串可以是一种具有一定阅读性时间日期描述，比如“Sun, 29 Feb 2004 16:21:42 -0800“、“2004-02-29 16:21:42”，甚至“next Thursday”、“2 days ago”等。该字符串可以包含日历上的日期、一天中的几点、时区、周几、相对时间、相对日期、以及数字等。
> - -t 选项后面的时间戳格式中 CC 为年数中的前两位，即”世纪数”； YY 为年数的后两位，即某世纪中的年数．如果不给出 CC 的值，则 touch   将把年数CCYY限定在 1969--2068 之内．MM 为月数，DD 为天将把年数 CCYY 限定在 1969--2068 之内．MM 为月数，DD 为天数，hh 为小时数(几点)，mm 为分钟数，SS 为秒数．此处秒的设定范围是 0--61，这样可以处理闰秒．这些数字组成的时间是环境变量 TZ 指定的时区中的一个时间．由于系统的限制，早于 1970 年 1 月 1 日的时间是错误的。

##### 参数

FILE：指定要设置时间属性的文件**列表**。

#### 实例

1. touch 命令直接跟一个不存在的文件名就会创建该指定名称的空文件（大小是零），并**将你的用户名作为文件的属主**。

```shell
[vincent@localhost testdir]$ touch test01 #创建一个空文件
[vincent@localhost testdir]$ ls -l #查看以创建的空文件
total 0
-rw-rw-r--. 1 vincent vincent 0 Dec 30 21:18 test01
[vincent@localhost testdir]$ stat test01 #使用 stat 命令查看文件的详细信息
  File: ‘test01’
  Size: 0         	Blocks: 0          IO Block: 4096   regular empty file
Device: fd00h/64768d	Inode: 7122587     Links: 1
Access: (0664/-rw-rw-r--)  Uid: ( 1000/ vincent)   Gid: ( 1000/ vincent)
Context: unconfined_u:object_r:user_home_t:s0
Access: 2017-12-30 21:18:21.102817751 +0800
Modify: 2017-12-30 21:18:21.102817751 +0800
Change: 2017-12-30 21:18:21.102817751 +0800
 Birth: -
[vincent@localhost testdir]$ 
```

2. 使用 touch 命令的**无选项**形式会同时更新已存在文件的 atime、mtime 和 ctime 为系统的当前时间。 

```shell
[vincent@localhost testdir]$ touch test01
[vincent@localhost testdir]$ ls -l
total 0
-rw-rw-r--. 1 vincent vincent 0 Dec 30 21:18 test01
[vincent@localhost testdir]$ stat test01 
  File: ‘test01’
  Size: 0         	Blocks: 0          IO Block: 4096   regular empty file
Device: fd00h/64768d	Inode: 7122587     Links: 1
Access: (0664/-rw-rw-r--)  Uid: ( 1000/ vincent)   Gid: ( 1000/ vincent)
Context: unconfined_u:object_r:user_home_t:s0
Access: 2017-12-30 21:18:21.102817751 +0800
Modify: 2017-12-30 21:18:21.102817751 +0800
Change: 2017-12-30 21:18:21.102817751 +0800
 Birth: -
#对已存在文件执行 touch 的无选项形式会更新已存在文件的修改时间、访问时间和状态时间
[vincent@localhost testdir]$ touch test01 
[vincent@localhost testdir]$ stat test01 
  File: ‘test01’
  Size: 0         	Blocks: 0          IO Block: 4096   regular empty file
Device: fd00h/64768d	Inode: 7122587     Links: 1
Access: (0664/-rw-rw-r--)  Uid: ( 1000/ vincent)   Gid: ( 1000/ vincent)
Context: unconfined_u:object_r:user_home_t:s0
Access: 2017-12-30 21:45:09.313783434 +0800
Modify: 2017-12-30 21:45:09.313783434 +0800
Change: 2017-12-30 21:45:09.313783434 +0800
 Birth: -
#也可以同时使用 ls 命令的 -l、--full-time、--time=WORD 选项来查看文件的某种时间
[vincent@localhost testdir]$ ls -l --full-time test01 #查看文件的最近修改时间
-rw-rw-r--. 1 vincent vincent 0 2017-12-30 21:45:09.313783434 +0800 test01
[vincent@localhost testdir]$ ls -l --full-time --time=atime test01 #查看文件的上次访问时间
-rw-rw-r--. 1 vincent vincent 0 2017-12-30 21:45:09.313783434 +0800 test01
[vincent@localhost testdir]$ ls -l --full-time --time=ctime test01 #查看文件的状态改变时间
-rw-rw-r--. 1 vincent vincent 0 2017-12-30 21:45:09.313783434 +0800 test01
[vincent@localhost testdir]$ 
```

3. 可用 -a 选项改变文件的 atime。该选项不会改变文件的 mtime，而文件的 ctime 将会变为执行这条命令时的系统时间。

```shell
[vincent@localhost testdir]$ stat test01 
  File: ‘test01’
  Size: 0         	Blocks: 0          IO Block: 4096   regular empty file
Device: fd00h/64768d	Inode: 7122587     Links: 1
Access: (0664/-rw-rw-r--)  Uid: ( 1000/ vincent)   Gid: ( 1000/ vincent)
Context: unconfined_u:object_r:user_home_t:s0
Access: 2017-12-30 21:45:09.313783434 +0800
Modify: 2017-12-30 21:45:09.313783434 +0800
Change: 2017-12-30 21:45:09.313783434 +0800
 Birth: -
#使用 -a 选项会改变 atime 和 ctime，不会改变 mtime
[vincent@localhost testdir]$ touch -a test01 
[vincent@localhost testdir]$ stat test01
  File: ‘test01’
  Size: 0         	Blocks: 0          IO Block: 4096   regular empty file
Device: fd00h/64768d	Inode: 7122587     Links: 1
Access: (0664/-rw-rw-r--)  Uid: ( 1000/ vincent)   Gid: ( 1000/ vincent)
Context: unconfined_u:object_r:user_home_t:s0
Access: 2017-12-30 21:57:10.137768053 +0800
Modify: 2017-12-30 21:45:09.313783434 +0800
Change: 2017-12-30 21:57:10.137768053 +0800
 Birth: -
[vincent@localhost testdir]$ 
```

4. 可用 -d 选项修改文件的 atime 和 mtime 为指定的时间，而文件的 ctime 将会变为执行这条命令时的系统时间。

```shell
[vincent@localhost testdir]$ stat test01 
  File: ‘test01’
  Size: 0         	Blocks: 0          IO Block: 4096   regular empty file
Device: fd00h/64768d	Inode: 7122587     Links: 1
Access: (0664/-rw-rw-r--)  Uid: ( 1000/ vincent)   Gid: ( 1000/ vincent)
Context: unconfined_u:object_r:user_home_t:s0
Access: 2017-12-30 21:18:21.102817751 +0800
Modify: 2017-12-30 21:18:21.102817751 +0800
Change: 2017-12-30 21:18:21.102817751 +0800
 Birth: -
#使用 -d 选项会改变文件的 atime 和 atime，而文件的 ctime 变为执行这条命令的时间
[vincent@localhost testdir]$ touch -d '2 days ago' test01 
[vincent@localhost testdir]$ stat test01 
  File: ‘test01’
  Size: 0         	Blocks: 0          IO Block: 4096   regular empty file
Device: fd00h/64768d	Inode: 7122587     Links: 1
Access: (0664/-rw-rw-r--)  Uid: ( 1000/ vincent)   Gid: ( 1000/ vincent)
Context: unconfined_u:object_r:user_home_t:s0
Access: 2017-12-28 21:43:53.350836009 +0800
Modify: 2017-12-28 21:43:53.350836009 +0800
Change: 2017-12-30 21:43:53.349785055 +0800
 Birth: -
[vincent@localhost testdir]$ 
```

5. 可用 -m 选项改变文件的 mtime。该选项不会改变文件的 atime，而文件的 ctime  将会变为执行这条命令时的系统时间。

```shell
[vincent@localhost testdir]$ stat test01
  File: ‘test01’
  Size: 0         	Blocks: 0          IO Block: 4096   regular empty file
Device: fd00h/64768d	Inode: 7122587     Links: 1
Access: (0664/-rw-rw-r--)  Uid: ( 1000/ vincent)   Gid: ( 1000/ vincent)
Context: unconfined_u:object_r:user_home_t:s0
Access: 2017-12-30 21:57:10.137768053 +0800
Modify: 2017-12-30 21:45:09.313783434 +0800
Change: 2017-12-30 21:57:10.137768053 +0800
 Birth: -
#使用 -m 选项会改变 mtime 和 ctime，不会改变 atime
[vincent@localhost testdir]$ touch -m test01 
[vincent@localhost testdir]$ stat test01 
  File: ‘test01’
  Size: 0         	Blocks: 0          IO Block: 4096   regular empty file
Device: fd00h/64768d	Inode: 7122587     Links: 1
Access: (0664/-rw-rw-r--)  Uid: ( 1000/ vincent)   Gid: ( 1000/ vincent)
Context: unconfined_u:object_r:user_home_t:s0
Access: 2017-12-30 21:57:10.137768053 +0800
Modify: 2017-12-30 21:59:07.080765557 +0800
Change: 2017-12-30 21:59:07.080765557 +0800
 Birth: -
[vincent@localhost testdir]$ 
```

6. 可用 -r 选项指定一个文件的 atime 和 mtime 与参考文件相同，该文件的 ctime 将会变为执行这条命令时的系统时间。

```shell
#新建一个空文件 test02
[vincent@localhost testdir]$ touch test02
#查看 test01 和 test02 这两个文件的信息
[vincent@localhost testdir]$ stat *
  File: ‘test01’
  Size: 0         	Blocks: 0          IO Block: 4096   regular empty file
Device: fd00h/64768d	Inode: 7122587     Links: 1
Access: (0664/-rw-rw-r--)  Uid: ( 1000/ vincent)   Gid: ( 1000/ vincent)
Context: unconfined_u:object_r:user_home_t:s0
Access: 2017-12-30 21:57:10.137768053 +0800
Modify: 2017-12-30 21:59:07.080765557 +0800
Change: 2017-12-30 21:59:07.080765557 +0800
 Birth: -
  File: ‘test02’
  Size: 0         	Blocks: 0          IO Block: 4096   regular empty file
Device: fd00h/64768d	Inode: 166216      Links: 1
Access: (0664/-rw-rw-r--)  Uid: ( 1000/ vincent)   Gid: ( 1000/ vincent)
Context: unconfined_u:object_r:user_home_t:s0
Access: 2017-12-30 22:07:06.671755323 +0800
Modify: 2017-12-30 22:07:06.671755323 +0800
Change: 2017-12-30 22:07:06.671755323 +0800
 Birth: -
#指定文件 test01 的 与文件 test02相同
[vincent@localhost testdir]$ touch -r test02 test01
#查看文件 test01 修改后的信息。发现文件 test01 的 atime 和 mtime 与文件 test02 相同， 
#而文件 test01 的ctime 变为了执行 touch -r test02 test01 命令的时间
[vincent@localhost testdir]$ stat *
  File: ‘test01’
  Size: 0         	Blocks: 0          IO Block: 4096   regular empty file
Device: fd00h/64768d	Inode: 7122587     Links: 1
Access: (0664/-rw-rw-r--)  Uid: ( 1000/ vincent)   Gid: ( 1000/ vincent)
Context: unconfined_u:object_r:user_home_t:s0
Access: 2017-12-30 22:07:06.671755323 +0800
Modify: 2017-12-30 22:07:06.671755323 +0800
Change: 2017-12-30 22:07:31.486754794 +0800
 Birth: -
  File: ‘test02’
  Size: 0         	Blocks: 0          IO Block: 4096   regular empty file
Device: fd00h/64768d	Inode: 166216      Links: 1
Access: (0664/-rw-rw-r--)  Uid: ( 1000/ vincent)   Gid: ( 1000/ vincent)
Context: unconfined_u:object_r:user_home_t:s0
Access: 2017-12-30 22:07:06.671755323 +0800
Modify: 2017-12-30 22:07:06.671755323 +0800
Change: 2017-12-30 22:07:06.671755323 +0800
 Birth: -
[vincent@localhost testdir]$ 
```

7. 可用 -t 选项加时间来指定文件的 atime 和 mtime，而文件的 ctime 也会变为执行这条命令时的系统时间。

```shell
[vincent@localhost testdir]$ stat test01
  File: ‘test01’
  Size: 0         	Blocks: 0          IO Block: 4096   regular empty file
Device: fd00h/64768d	Inode: 7122587     Links: 1
Access: (0664/-rw-rw-r--)  Uid: ( 1000/ vincent)   Gid: ( 1000/ vincent)
Context: unconfined_u:object_r:user_home_t:s0
Access: 2017-12-30 22:07:06.671755323 +0800
Modify: 2017-12-30 22:07:06.671755323 +0800
Change: 2017-12-30 22:07:31.486754794 +0800
 Birth: -
[vincent@localhost testdir]$ touch -t 201712310000.30 test01
[vincent@localhost testdir]$ stat test01
  File: ‘test01’
  Size: 0         	Blocks: 0          IO Block: 4096   regular empty file
Device: fd00h/64768d	Inode: 7122587     Links: 1
Access: (0664/-rw-rw-r--)  Uid: ( 1000/ vincent)   Gid: ( 1000/ vincent)
Context: unconfined_u:object_r:user_home_t:s0
Access: 2017-12-31 00:00:30.000000000 +0800
Modify: 2017-12-31 00:00:30.000000000 +0800
Change: 2017-12-30 22:18:08.500741201 +0800
 Birth: -
[vincent@localhost testdir]$ 
```

### cd 命令

#### 描述

**cd 命令**用来切换工作目录（change working directory）到指定的 dirName 中。 其中 dirName 表示法可为绝对路径或相对路径。若目录名称省略，则变换至当前用户的 home 目录。另外，~ 也表示为 home 目录，. 则表示当前工作目录，.. 则表示当前工作目录的上一层目录。

#### 语法

```shell
cd [OPTION]... DIRECTORY
```

##### 选项

```shell
-p：如果要切换到的目标目录是一个符号连接，直接切换到符号连接指向的目标目录；
-L：如果要切换到的目标目录是一个符号连接，直接切换到字符连接名代表的目录，而非符号连接所指向的目标目录；
-：当仅实用"-"一个选项时，当前工作目录将被切换到环境变量"OLDPWD"所表示的目录（即上一个刚使用过的目录）。
```

##### 参数

DIRECTORY：要切换到的目标目录。

#### 实例

```shell
cd    进入用户主目录；
cd ~  进入用户主目录；
cd -  返回进入此目录之前所在的目录。方便在两个目录之间进行切换；
cd ..  返回上级目录（若当前目录为“/“，则执行完后还在“/"；".."为上级目录的意思）；
cd ../..  返回上两级目录；
cd !$  把上个命令的选项作为cd参数使用。
```

### cp 命令

#### 描述

**cp 命令**将源文件复制至目标文件，或将多个源文件复制至目标目录。**当一次复制多个文件时，目标文件参数必须是一个已经存在的目录**，否则将出现错误。

#### 语法

```shell
cp [OPTION]... [-T] SOURCE DEST
or:  cp [OPTION]... SOURCE... DIRECTORY
or:  cp [OPTION]... -t DIRECTORY SOURCE...
```

##### 选项

```shell
-a, --archive：效果等同于同时指定 -dpR（或 -dR --preserve=all）；
--backup[=CONTROL]：为每个已存在的目标文件创建备份；
-b:类似 --backup 但不接受参数;
--copy-contents:递归复制时复制特殊文件的内容；
-d：当复制符号连接时，把目标文件或目录也建立为符号连接，并指向与源文件或目录连接的原始文件或目录。等于--no-dereference --preserve=links；
-f：在如果目标文件无法打开（不是目录）则将其移除并重试(当 -n 选项存在时则不需再选此项)；
-i, --interactive：覆盖既有文件之前先询问用户；
-H：跟随源文件中的命令行符号链接；
-l, --link：对源文件建立硬连接，而非复制文件；
-L, --dereference：总是跟随符号链接；
-n, --no-clobber：不要覆盖已存在的文件(使前面的 -i 选项失效)；
-P, --no-dereference：不跟随源文件中的符号链接；
-p：等于--preserve=mode,ownership,timestamps；
--preserve[=属性列表]：保持指定的属性(默认：mode,ownership,timestamps)，如果可能的话就保持附加属性：context, links, xattr, all等；
-R, -r, --recursive：递归复制目录及目录内的所有项目；
-s, --symbolic-link：对源文件建立符号连接，而非复制文件；
-S, --suffix=SUFFIX：在备份文件时，用指定的后缀“SUFFIX”代替文件的默认后缀；
-t, --target-directory=DIRECTORY：将所有的源（SOURCE）参数复制到DIRECTORY中；
-T, --no-target-directory：将目标（DEST）参数当成是一个普通文件。
-u, --update：只会在源文件的更改时间比目标文件新时或是名称相互对应的目标文件并不存在时，才复制文件；
-b：覆盖已存在的文件目标前将目标文件备份；
-v：详细显示命令执行的操作。
```

##### 参数

- SOURCE：指定源文件列表。**默认情况下，cp 命令不能复制目录，如果要复制目录，则必须使用 -R 选项**；
- DEST：指定目标文件，用于复制单个文件。**当“源文件”为多个文件时，要求“目标文件”为指定的目录**；
- DIRECTORY：指定要将源文件列表复制到的目录。

#### 实例

1. 将指定文件复制到当前目录下：

```shell
cp ../mary/homework/assign .
```

2. 将文件 file 复制到目录 /usr/men/tmp 下，并改名为 file1。

```shell
cp file /usr/men/tmp/file1
```

3. 将目录 /usr/men 下的所有文件及其子目录复制到目录 /usr/zh 中。

```shell
cp -r /usr/men /usr/zh
```

4. 交互式地将目录 /usr/men 中的以m打头的所有 .c 文件复制到目录 /usr/zh 中。

```shell
cp -i /usr/men m*.c /usr/zh
```

使用 cp 命令复制文件时候，有时候会需要覆盖一些同名文件，覆盖文件的时候都会有提示：需要不停的按 Y 来确定执行覆盖。文件数量不多还好，但是要是几百个估计按 Y 都要吐血了，于是折腾来半天总结了一个方法：

```shell
#复制目录 aaa 下所有到 /bbb 目录下，这时如果 /bbb 目录下有和 aaa 同名的文件，需要按Y来确认并且会略过 aaa 目录下的子目录。
cp aaa/* /bbb

#这次依然需要按 Y 来确认操作，但是没有忽略子目录。
cp -r aaa/* /bbb

#依然需要按 Y 来确认操作，并且把 aaa 目录以及子目录和文件属性也传递到了 /bbb。
cp -r -a aaa/* /bbb

#成功，没有提示按 Y、传递了目录属性、没有略过目录。
\cp -r -a aaa/* /bbb 
```

### ln 命令

**ln 命令**用来为文件创建链接文件。

### 扩展知识

Linux具有为一个文件起多个名字的功能，称为链接（Link）。被链接的文件可以存放在相同的目录下，但是必须有不同的文件名。被链接的文件也可以有相同的文件名，但是存放在不同的目录下。**只要对一个链接文件进行修改，所有关联文件都会同步这种变化**。对于某个文件的各链接文件，我们可以给它们指定不同的存取权限，以控制对信息的共享和增强安全性（针对硬链接）。

链接文件类型分为硬链接（Hard Link）和符号链接（Symbolic Link）两种。使用 ln 命令创建的默认链接类型是硬链接。

##### 硬链接

硬链接会创建独立的虚拟文件，其中包含了原始文件的信息及位置。**硬链接和其源文件从根本上而言是同一个文件，它们的 lnode 节点号相同**。引用硬链接文件等同于引用了源文件。要创建硬链接，原始文件也必须事先存在。

一个文件的硬链接数可以在目录的长列表格式的第二列中看到，无额外链接的文件的链接数为 1。在默认情况下，ln 命令创建硬链接。ln 命令会增加链接数，rm 命令会减少链接数。一个文件除非链接数为 0，否则不会从文件系统中被物理地删除。

> 使用 ls -li 命令可以看到链接文件的 lnode 节点号和链接数。

对硬链接有如下限制：

- **不能对目录做硬链接**。
- **不能在不同的文件系统之间做硬链接**。就是说，链接文件和被链接文件必须位于同一个文件系统中。

##### 符号链接

符号链接也称为软链接，是将一个路径名链接到一个文件。符号链接文件是一种特别类型的文件。事实上，它只是一个文本文件，其中包含它所链接的另一个文件的路径名。所有读、写文件内容的命令被用于符号链接时，将沿着链接方向前进来访问实际的文件。符号链接文件不是一个独立的文件，它的许多属性依赖于源文件，所以**给符号链接文件设置存取权限是没有意义的**。

**与硬链接不同的是，符号链接是一个新文件，它和其源文件具有不同的 lnode 节点号**。符号链接没有硬链接的限制，可以对目录做符号链接，也可以在不同文件系统之间做符号链接。

用 ln  命令的 -s 选项可以建立符号链接。建立符号链接时源文件最好用绝对路径名，这样可以在任何工作目录下进行符号链接。而当源文件用相对路径时，如果当前的工作路径与要创建的符号链接文件所在路径不同，就不能进行链接。

符号链接文件与其所链接文件的区别：

- 删除符号链接所链接文件，只是删除了文件数据，而不会删除其符号链接。一旦以同样文件名创建了源文件，原有的符号链接将继续指向该文件的新数据。
- 在目录长列表中，符号链接作为一种特殊的文件类型显示出来，其第一个字母是 l。由于符号链接是一个新的文件，所以其 lnode 编号与其所链接文件不同 。符号链接的大小是其所链接文件的路径名中的字节数。
- **当用 ls -l 命令列出文件长列表时，可以看到符号链接名后有一个箭头指向其所链接文件**。

#### 语法

```shell
Usage: ln [OPTION]... [-T] TARGET LINK_NAME   (1st form)
  or:  ln [OPTION]... TARGET                  (2nd form)
  or:  ln [OPTION]... TARGET... DIRECTORY     (3rd form)
  or:  ln [OPTION]... -t DIRECTORY TARGET...  (4th form)
```

##### 选项

```shell
--backup[=CONTROL]：若需覆盖文件，则覆盖前先行备份。CONTROL指定备份模式；
-b：和 --backup 一样，但不接受参数；
-d，-F，——directory：建立目录的硬连接(只适用于超级用户，而且有不可预知的风险，慎用)；
-f，——force：强行建立文件或目录的连接，不论所链接文件是否存在；
-i，——interactive：覆盖既有文件之前先询问用户；
-n，--no-dereference：如果目标目录已经是一个符号链接了，那么把 LINK_NAME 视为一般文件；
-s，——symbolic：对源文件建立符号连接，而非硬连接；
-S, --suffix=SUFFIX：用"-b"参数备份目标文件后，备份文件的字尾会被加上一个备份字符串，预设的备份字符串是符号“~”，用户可通过“-S”参数来改变它。形式为 -S<字尾备份字符串>或--suffix=<字尾备份字符串>；
-t, --target-directory=DIRECTORY：在指定目录中创建链接；
-T, --no-target-directory：总是将 LINK_NAME 视为一般文件；
-v，——verbose：显示指令执行过程；
```

##### 参数

- 第一种形式为目标（TARGET）创建名为 LINK_NAME 的链接；
- 第二种形式在当前目录下为目标（TARGET）创建链接；
- 第三种形式和第四种形式为 DIRECTORY 中的每个 TARGET 创建一个链接；

- TARGET 可以是文件或者目录。

#### 实例

1. ln -s 为一个文件创建符号链接。符号链接的文件类型标识为 l，长列表中符号链接名后有一个 -> 符号指向其所链接的文件。可以看出符号链接的 lnode 编号与 其所链接的文件不同。

```shell
[vincent@localhost testdir01]$ ls -l test01
-rw-rw-r-- 1 vincent vincent 0 Dec 31 23:19 test01
[vincent@localhost testdir01]$ ln -s test01 sl_test01
[vincent@localhost testdir01]$ ls -li *test01
2458532 lrwxrwxrwx 1 vincent vincent 6 Jan  1 12:29 sl_test01 -> test01
2458523 -rw-rw-r-- 1 vincent vincent 0 Dec 31 23:19 test01
[vincent@localhost testdir01]$ 
```

2. ln 无选项形式为一个文件创建硬链接。硬链接的 lnode 编号（第一列）与其所链接的文件相同，两者的大小、链接数（第三列）也相同。

```shell
[vincent@localhost testdir01]$ ls -l *test01
lrwxrwxrwx 1 vincent vincent 6 Jan  1 12:29 sl_test01 -> test01
-rw-rw-r-- 1 vincent vincent 0 Dec 31 23:19 test01
[vincent@localhost testdir01]$ ln test01 hl_test01
[vincent@localhost testdir01]$ ls -li *test01
2458523 -rw-rw-r-- 2 vincent vincent 0 Dec 31 23:19 hl_test01
2458532 lrwxrwxrwx 1 vincent vincent 6 Jan  1 12:29 sl_test01 -> test01
2458523 -rw-rw-r-- 2 vincent vincent 0 Dec 31 23:19 test01
[vincent@localhost testdir01]$ 
```

如果使用 cp 命令的无选项形式复制一个文件，而该文件又已经被链接到了另一个源文件上，那么得到的其实是源文件的一个副本。千万别创建软链接文件的软链接。这会形成混乱的链接链，不仅容易断裂，还会造成各种麻烦。 

### mv 命令

#### 描述

**mv 命令**可以将文件和目录移动到另一个位置或重新命名。文件的时间戳和 lnode 编号都没有改变。改变的只有位置和名称。

#### 语法

```shell
 mv [OPTION]... [-T] SOURCE DEST
 or:  mv [OPTION]... SOURCE... DIRECTORY
 or:  mv [OPTION]... -t DIRECTORY SOURCE...
```

将 SOURCE 重命名为 DEST，或者将 SOURCE 移动到 DIRECTORY 中。

##### 选项

```shell
--backup[=CONTROL]：若需覆盖文件，则覆盖前先行备份。CONTROL指定备份模式；
-b：和 --backup 一样，但不接受参数；
-f, --force：若目标文件或目录与现有的文件或目录重复，则直接覆盖现有的文件或目录；
-i, --interactive：交互式操作，覆盖前先行询问用户，如果源文件与目标文件或目标目录中的文件同名，则询问用户是否覆盖目标文件。用户输入”y”，表示将覆盖目标文件；输入”n”，表示取消对源文件的移动。这样可以避免误将文件覆盖。
--strip-trailing-slashes：删除源文件名后面的斜杠“/”；
-S, --suffix=SUFFIX：为备份文件指定 SUFFIX 后缀，而不使用默认的 ~ 后缀；
-t, --target-directory=DIRECTORY：指定源文件要移动到目标目录；
-u, --update：当源文件比目标文件新或者目标文件不存在时，才执行移动操作。
```

##### 参数

- SOURCE：源文件列表；
- DEST：要改成的的目标文件名；
- DIRECTORY：该移动到的目标目录名。

#### 实例

1. 将文件ex3改名为new1

```shell
mv ex3 new1
```

2. 将目录 /usr/men 中的所有文件移到当前目录（用 . 表示）中：

```shell
mv /usr/men/* .
```

3. 也可以使用mv命令移动文件位置并修改文件名称，这些操作只需一步就能完成。

```shell
[vincent@localhost testdir01]$ ls -l test01
-rw-rw-r-- 2 vincent vincent 0 Dec 31 23:19 test01
[vincent@localhost testdir01]$ mv test01 ../testdir02/test01_mv
[vincent@localhost testdir01]$ ls -l ../testdir02/test01_mv
-rw-rw-r-- 2 vincent vincent 0 Dec 31 23:19 ../testdir02/test01_mv
[vincent@localhost testdir01]$ 
```

### rm 命令

#### 描述

**rm 命令**可以删除一个目录中的一个或多个文件或子目录，也可以将某个目录及其中的所有文件及其子目录均删除掉。对于链接文件，只是删除整个链接文件，而原有文件保持不变。

注意：使用 rm 命令要格外小心。因为一旦删除了一个文件，就无法再恢复它。所以，在删除文件之前，最好再看一下文件的内容，确定是否真要删除。rm 命令可以用 -i 选项，这个选项在使用文件扩展名字符删除多个文件时特别有用。使用这个选项，系统会要求你逐一确定是否要删除。这时，必须输入 y 并按 Enter 键，才能删除文件。

#### 语法

```shell
rm [OPTION]... FILE...
```

##### 选项

```shell
-d, --dir：删除空目录；
-f, --force：强制删除文件或目录。不给出任何提示，即使文件不存在；
-i：在删除每个文件或目录之前先询问用户；
-I：在删除之前仅提示一次；
--interactive[=WHEN]：指定在删除之前的提示类型。WHEN可以为once（等同-I），或 always（等同-i），没有 WHEN 时总是给出提示；
-r, -R, --recursive：递归处理，将指定目录下的所有文件与子目录一并处理；
--preserve-root：不对根目录进行递归操作；
-v：显示指令的详细执行过程。
```

##### 参数

- FILE：指定被删除的文件列表，如果参数中含有非空目录，则必须加上 -r 或者 -R 选项。如果是空目录，则使用 -d 选项。

#### 实例

1. 交互式删除当前目录下的文件 test 和 example。

```shell
rm -i test example
Remove test ?n（不删除文件test)
Remove example ?y（删除文件example)
```

2. 删除当前目录下除隐含文件外的所有文件和子目录（非常危险！）

```shell
rm -r *
```

### mkdir 命令

#### 描述

**mkdir 命令**用来创建目录。如果在指定名称的目录的前面没有加任何路径名，则在当前目录下创建指定名称的目录；如果指定名称的目录前面有路径，将会在指定路径下创建指定名称的目录。在创建目录时，应保证新建的目录与它所在目录下的文件没有重名。 

**最好采用前后一致的命名方式来区分文件和目录**。例如，**目录名可以以大写字母开头，这样，在目录列表中目录名就出现在前面**。

#### 语法

```shell
mkdir [OPTION]... DIRECTORY...
```

##### 选项

```shell
-m, --mode=MODE：建立目录的同时设置目录的权限（rwx）；
-p, --parents：若所要建立目录的上层目录目前尚未建立，则会一并建立上层目录；
```

##### 参数

DIRECTORY：要创建的目录。

#### 实例

1. 创建目录。

```shell
[vincent@localhost testdir01]$ mkdir TestDir
[vincent@localhost testdir01]$ ls -l -d TestDir
drwxrwxr-x 2 vincent vincent 4096 Jan  1 13:52 TestDir
[vincent@localhost testdir01]$ 
```

2. 创建多级目录。

```shell
[vincent@localhost testdir01]$ mkdir Level01/Level02/TestDir
mkdir: cannot create directory ‘Level01/Level02/TestDir’: No such file or directory
[vincent@localhost testdir01]$ mkdir -p Level01/Level02/TestDir
[vincent@localhost testdir01]$ ls -l -d Level01/Level02/TestDir/
drwxrwxr-x 2 vincent vincent 4096 Jan  1 13:54 Level01/Level02/TestDir/
[vincent@localhost testdir01]$ 
```

### rmdir 命令

#### 描述

**rmdir 命令**用来删除**空目录**。要删除目录中的所有文件必须先用 rm 命令全部删除。另外，当前工作目录必须在被删除目录之上，不能是被删除目录本身，也不能是被删除目录的子目录。

该命令功能可用 rm 命令的 -d 选项替代。

#### 语法

```shell
rmdir [OPTION]... DIRECTORY...
```

##### 选项

```shell
-p, --parents：删除指定目录后，若该目录的上层目录已变成空目录，则将其一并删除；
--ignore-fail-on-non-empty：使 rmdir 命令忽略由于删除非空目录时导致的错误信息；
```

##### 参数

DIRECTORY：要删除的空目录列表。当删除多个空目录时，目录名之间使用空格隔开。

#### 实例

只能删除非空目录

```shell
[root@localhost testdir01]# tree Level01
Level01
└── Level02
    └── TestDir
        └── test03

2 directories, 1 file
[root@localhost testdir01]# rmdir Level01/Level02/TestDir
rmdir: failed to remove ‘Level01/Level02/TestDir’: Directory not empty
[root@localhost testdir01]# rm Level01/Level02/TestDir/test03 
rm: remove regular empty file ‘Level01/Level02/TestDir/test03’? y
[root@localhost testdir01]# rmdir Level01/Level02/TestDir
[root@localhost testdir01]# tree Level01
Level01
└── Level02

1 directory, 0 files
[root@localhost testdir01]# rmdir -p Level01/Level02
[root@localhost testdir01]# tree
.

0 directories, 0 files
[root@localhost testdir01]# 
```

