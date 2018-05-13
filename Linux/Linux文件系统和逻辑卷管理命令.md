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
    --help：显示帮助并退出；
    --version：显示版本信息并退出。
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

1. 使用 -h 选项以 KB 以上的单位来显示，可读性高：

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

1. 以指定的单位来显示大小：

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
Usage: du [OPTION]... [FILE]...
   or: du [OPTION]... --files0-from=F
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

1. 使用 -s 选项来显示所有目录中第一层字目录和子文件的大小，可以借助 sort 命令按文件大小排序。

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

1. 使用 --apparent-size 选项来显示文件的 Apparent Size。

```shell
[vincent@localhost ~]$ du -s test3.txt 
4       test3.txt
[vincent@localhost ~]$ du -s --apparent-size test3.txt 
1       test3.txt
[vincent@localhost ~]$ 
```

1. 使用 du --files0-from= 选项来显示文件中所指定的文件大小。

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

![BaiduShurufa_2018-3-13_9-56-1]()

然后执行  du --files0-from=./test3.txt 就可以显示 test3.txt 文件中指定的文件的使用空间信息：

```shell
[vincent@localhost ~]$ du --files0-from=./test3.txt
4       /home/vincent/test1
4       /home/vincent/test2
```

1. 使用 --time 选项来显示文件的最后修改时间。

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