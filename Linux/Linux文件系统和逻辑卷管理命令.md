先来介绍几个文件系统和磁盘分区相关的命令。

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

#### 实例

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

### /etc/fstab文件

`fstab` （即 file systems table）系统配置文件中包含了**哪些设备通常使用什么选项挂载到了哪里**。该文件在 Solaris Linux 系统中名为 `/etc/vfstab`。系统启动时会自动通过 `mount` 命令读取该文件中的挂载项来挂载分区，以便在系统启动后可以使用这些分区，管理员也可以在系统启动后执行 `mount` 命令来挂载其他文件。某些管理工具（甚至是图形化工具，如 KDE 桌面的 Kfstab  图形化配置工具）可以读写该文件来管理设备的挂载。

然而，`fstab` 文件仍被当成是基本的系统配置，已被自动挂载机制所替代。现代 Linux 系统可以使用 [udev](https://en.wikipedia.org/wiki/Udev) 来管理热插拔设备而不依赖于 `fstab` 文件 ，[pmount](https://en.wikipedia.org/wiki/Pmount)  也允许一般用户可以在挂载或卸载文件系统时不依赖于 `fstab` 文件。传统的 Linux 系统允许授权用户（root 用户和 wheel 组的用户）在挂载或卸载文件系统时可以不使用 `fstab` 文件。

下面是一个典型的 `fstab` 文件的内容。 

```shell
# device-spec   mount-point     fs-type      options              dump 	pass
LABEL=/         /               ext4         defaults             1 	1
/dev/sda6       none            swap         defaults             0 	0
none            /dev/pts        devpts       gid=5,mode=620       0 	0
none            /proc           proc         defaults             0 	0
none            /dev/shm        tmpfs        defaults             0 	0
# Removable media
/dev/cdrom      /mnt/cdrom      udf,iso9660  noauto,owner,ro      0	 	0
# NTFS Windows 7 partition
/dev/sda1       /mnt/Windows    ntfs-3g      quiet,defaults,locale=en_US.utf8,umask=0,noexec  0 0
# Partition shared by Windows and Linux
/dev/sda7       /mnt/shared     vfat         umask=000            0 	0
# mounting tmpfs
tmpfs           /mnt/tmpfschk   tmpfs        size=100m            0 	0
# mounting cifs
//pingu/ashare  /store/pingu    cifs         credentials=/root/smbpass.txt         0 0
# mounting NFS
pingu:/store    /store          nfs          rw                   0 	0
```

`fsck`，`mount`，`umount` 命令会按顺序读取上面的挂载项来执行其操作。上面的各个字段依次为：

- 第一个字段为分区。其值可以是名称、标签、UUID 等。
- 第二个字段是挂载点。对于 swap 分区和文件来说该字段为 none，而有的Linux 发行版（如 CentOS）中 swap 分区的挂载点是 /swap。
- 第三个字段是文件系统类型。
- 第四个字段为挂载选项（mount options）。该字段用于描述文件系统，比如，是否在启动时自动挂载、是否可写或只读、指定大小等等。特殊选项 `defaults` 根据文件系统类型预设了一些选项。 
- 第五个字段是 dump。该字段表示是否，以及多久通过 [dump](https://en.wikipedia.org/wiki/Dump_(program)) 程序来备份文件系统。0 值表示不会自动备份。
- 第六个字段是 fsck order。该字段的数值表示 `fsck` 程序在系统启动时对设备进行错误检查的顺序。1 表示检查 root（/） 文件系统，2 表示在 root 文件系统之后检查设备，0 表示不检查其他设备。

第四个字段可以配置多个逗号分隔的挂载选项来传递给 mount 命令来决定其挂载行为。常见的选项有：

- auto / noauto：auto 选项表示设备会在系统启动时或 mount -a 命令执行时自动挂载，是默认选项。noauto 表示设备必须的挂载必须手动执行。
- dev / nodev：是否解释文件系统上的字符或块特定设备（block special devices）。
- exec / noexec：是否执行分区上的二进制程序。noexec 在不含二进制文件的分区（例如 /var 分区）或不想执行二进制文件的分区（例如 Windows 分区）上比较有用。
- rw / ro：rw 表示可读写，ro 表示只读（默认）。
- sync / async：文件系统的输入输出是同步还是异步进行。
- suid / nosuid：允许或阻止 suid 、sgid bits 的操作。
- user / users / nouser：user  允许任意用户挂载文件系统，这会自动使用 noexec, nosuid, nodev 选项，除非显式覆写。nouser 表示只有 root 用户可以挂载文件系统。users 表示 users 用户组的用户可以卸载卷。
- defaults：相关类型文件系统的默认配置。对于 ext3 文件系统，该选项等同于 rw、suid、dev、exec、auto、nouser、async（no acl support）。基于 Red Hat 的系统支持为 root 文件系统设置 acl ，但不会为用户创建的 ext3 文件系统上设置 acl。某些文件系统如 XFS 默认允许 acl。
- owner (Linux-specific)：允许设备的属主进行挂载。
- atime / noatime / relatime / strictatime (Linux-specific)：atime / noatime 表示是否在访问时更新 atime，relatime 表示如果在 mtime 之前就更新 atime。

### /etc/mtab文件

`mtab` 文件记录着**当前已挂载**的**文件系统以及它们的初始化选项**。`mtab`的内容和`fstab`中的类似，主要的区别在于后者列出了系统启动时应该挂载的所有文件系统，而前者则列出了当前已挂载的信息（包含不在 `fstab` 文件中、手动挂载的文件系统）。因此，`mtab`的格式通常和`fstab`很相像。大多数情况下，可以在`fstab`中直接使用`mtab`的配置内容。该文件的路径通常为 `/etc/mtab`。

###  /proc/mounts 文件

`/proc/mounts` 文件与 `/etc/mtab` 有着相似的内容，不同的是，前者包含了挂载选项等信息，但 `/proc/mounts` 文件的内容更新（up-to-date ）。

### mount 命令

**mount 命令**用于挂载文件系统到指定的挂载点（mount point）。此命令的最常用于挂载 CD ROM和新创建的分区。

#### 语法

```shell
mount [-lhV]
mount -a [-fFnrsvw] [-t vfstype] [-O optlist]
mount [-fnrsvw] [-o option[,option]...]  device|dir
mount [-fnrsvw] [-t vfstype] [-o options] device dir
```

##### 选项

```shell
-V, --version：输出版本信息；
-h, --help：打印帮助信息；
-v, --verbose：verbose 模式；
-a, --all：挂载 fstab 文件中的所有（指定类型）的文件系统；
-F, --fork：（和 -a 一起使用）并行挂载不同的分区或不同的 NFS 服务器（可以指定超时）。该选项的优点是速度快，缺点是挂载的完成没有特定顺序，所以不能用来同时挂载 /usr 和 /usr/spool；
-f, --fake：执行除了实际的系统调用外所有操作，实际上是一种“假”挂载。与 -v 选项连用来确定 mount 命令试图执行什么时很有用。该选项也可以用来为之前使用 -n 选项挂载的分区添加条目。该选项检查 /etc/mtab 文件中相关记录是否存在，如果相关记录已经存在则检查失败；
-i, --internal-only：不调用 /sbin/mount.<filesystem> 的帮助（即使存在）；
-l, --show-labels：在 mount 的输出中添加分区标签。 mount 使用该选项时必须要有读取磁盘设备的权限（比如 suid root）。用户可以使用 e2label 工具为 ext2、ext3 或 ext4 分区、使用 xfs_admin 为 XFS 分区、使用 reiserfs‐tuneOne 为 reiserfs 文件系统设置一个标签；
-n, --no-mtab：挂载时不写入 /etc/mtab 文件。该选项可用于当 /etc/mtab 文件只有读取权限时；
-c, --no-canonicalize：不规范路径。mount 命令会规范化（命令行或 fstab 中的）所有路径，并将规范化的路径存储到 /etc/mtab 文件中。该选项和 -f 连用用于处理已经规范化的绝对路径；
-s：容忍草率的挂载选项，而不是失败。该选项会忽略文件系统不支持的挂载选项。并不是所有的文件系统都支持该选项，该选项的存在用于支持 Linux autofs-based 自动挂载器；
	--source src：如果 mount 命令仅指定了一个参数，那么该参数将被解释为挂载目标（挂载点）或挂载源（分区）。该选项允许显式定义 mount 命令的挂载源；
	--target dir：该选项允许显式指定挂载点；
-r,	--read-only：将文件系统挂载为只读，相当于 `-o ro`。注意，根据文件系统类型、状态和内核行为，系统可能依旧可以写入分区。例如，如果文件系统是脏的，ext3 或 ext4 将将会重放其日志，如果要阻止这类的写入，可以使用 `ro,noload` 选项挂载 ext3 或 ext4，或者使用 blockdev 设置分区为只读模式；
-w, --rw, --read-write：以读写权限挂载分区，这是默认行为，等同于 `-o rw`；
-L, --label label：以指定的标签挂载分区；
-U, --uuid uuid：挂载具有指定 uuid 的分区。自 Linux 2.1.116 以来，这两个选项需要 /proc/partitions 文件是存在的；
-T, --fstab path：指定可选的 fstab 文件。如果 path 是一个目录，该目录中的文件使用 strverscmp 存储，以`.` 开头或不以 `.fstab` 为扩展名的文件将被忽略。该选项可以指定不止一次，主要是为 initramfs 或 chroot 脚本设计的，在这些脚本中指定的有除了系统配置以外的额外配置。注意，mount 命令不会将 --fstab 选项传递给 /sbin/mount.<type> helpers，这就意味着可选的 fstab 文件对于 helpers 是不可见的。一般的挂载则不会有这个问题，但非 root 
用户总是需要 fstab 来验证用户权限；
-t, --types vfstype：指定挂载特定类型的文件系统；
-O, --test-opts opts：像 -t 限制文件系统类型一样，该选项和 -a 一起连用时用来限制文件系统的选项。例如，`mount -a -O no_netdev` 将挂载 /etc/fstab 中除了具有 _netdev 挂载选项的所有文件系统。 -O 和 -t 也可以组合使用，例如 `mount -a -t ext2 -O _netdev` 将挂载具有 _netdev 挂载选项的 ext2 文件系统；
-o, --options opts：指定逗号分隔挂载选项列表，用于覆写 /etc/fstab 中挂载项的挂载选项； 
-B, --bind：重新将分区挂载到另一个挂载点，这样多个挂载点都可以进入该分区；
-R, --rbind：重新挂载分区以及所有可能子挂载，这样多个挂载点都可以进入该分区；
-M, --move：将挂载移动到另一个挂载点（只能通过新挂载点访问）。
```

##### 参数

optlist：逗号分隔的挂载选项列表。

device：要挂载的分区。

dir：挂载点。

#### 实例

1. `mount` 和 `umount` 命令维护着一个保存在 `/etc/mtab` 文件中的当前已挂载文件系统的列表。仅使用 `mount` 命令时而不附加任何选项和参数就会列出该列表。新挂载的设备会显示在最下方（即使是临时挂载的）。

```shell
# 查看当前所有挂载
[root@localhost ~]# mount
sysfs on /sys type sysfs (rw,nosuid,nodev,noexec,relatime,seclabel)
proc on /proc type proc (rw,nosuid,nodev,noexec,relatime)
devtmpfs on /dev type devtmpfs (rw,nosuid,seclabel,size=484476k,nr_inodes=121119,mode=755)
securityfs on /sys/kernel/security type securityfs (rw,nosuid,nodev,noexec,relatime)
tmpfs on /dev/shm type tmpfs (rw,nosuid,nodev,seclabel)
...
nfsd on /proc/fs/nfsd type nfsd (rw,relatime)
/dev/sda1 on /boot type ext4 (rw,relatime,seclabel,data=ordered)
/dev/mapper/cl-home on /home type ext4 (rw,relatime,seclabel,data=ordered)
binfmt_misc on /proc/sys/fs/binfmt_misc type binfmt_misc (rw,relatime)
tmpfs on /run/user/1000 type tmpfs (rw,nosuid,nodev,relatime,seclabel,size=99996k,mode=700,uid=1000,gid=1000)
fusectl on /sys/fs/fuse/connections type fusectl (rw,relatime)
gvfsd-fuse on /run/user/1000/gvfs type fuse.gvfsd-fuse (rw,nosuid,nodev,relatime,user_id=1000,group_id=1000)
tmpfs on /run/user/0 type tmpfs (rw,nosuid,nodev,relatime,seclabel,size=99996k,mode=700)
/dev/sdb1 on /data type ext4 (rw,relatime,seclabel,data=ordered)
[root@localhost ~]# 
```

2. 使用 `-t` 选项筛选出 `/etc/mtab` 文件中特定文件系统类型的挂载项，使用 `-l` 选项用于在列表项后附加设备标签。

```shell
[root@localhost ~]# mount -l -t ext4
/dev/mapper/cl-root on / type ext4 (rw,relatime,seclabel,data=ordered) [root_label]
/dev/sda1 on /boot type ext4 (rw,relatime,seclabel,data=ordered) [boot_label]
/dev/mapper/cl-home on /home type ext4 (rw,relatime,seclabel,data=ordered) [home_label]
[root@localhost ~]#
```

3. `mount` 命令的标准形式为 `mount -t type device dir` ，用于将指定文件类型（type）的设备分区（device）挂载到指定的目录（dir）。指定目录 `dir` 之前的内容、属主和模式在挂载文件系统后才可见。如果仅指定了设备分区或目录，那么 mount 命令会寻找 `/etc/fstab` 文件中对应的挂载项，并尝试挂载它。`device` 通常为 `/dev/sda1` 的形式，也可以是 LABEL、UUID、PARTUUID、PARTLABEL 等形式。

```shell
# 在根目录下创建一个新目录
[root@localhost ~]# mkdir /data
[root@localhost /]# ls -al /data
total 8
drwxr-xr-x.  2 root root 4096 May 26 10:51 .
dr-xr-xr-x. 20 root root 4096 May 26 10:51 ..
# 将之前已有文件系统的新分区 /dev/sdb1 挂载到 /data
[root@localhost /]# mount -t ext4 /dev/sdb1 /data  
[root@localhost /]# ls -al /data
total 24
drwxr-xr-x.  3 root root  4096 May 13 20:39 .
dr-xr-xr-x. 19 root root  4096 May 13 20:47 ..
drwx------.  2 root root 16384 May 13 20:39 lost+found
# 查看当前所有挂载项时新挂载的设备会显示在最下方（即使是临时挂载的）
[root@localhost ~]# mount
sysfs on /sys type sysfs (rw,nosuid,nodev,noexec,relatime,seclabel)
proc on /proc type proc (rw,nosuid,nodev,noexec,relatime)
devtmpfs on /dev type devtmpfs (rw,nosuid,seclabel,size=484476k,nr_inodes=121119,mode=755)
securityfs on /sys/kernel/security type securityfs (rw,nosuid,nodev,noexec,relatime)
tmpfs on /dev/shm type tmpfs (rw,nosuid,nodev,seclabel)
...
nfsd on /proc/fs/nfsd type nfsd (rw,relatime)
/dev/sda1 on /boot type ext4 (rw,relatime,seclabel,data=ordered)
/dev/mapper/cl-home on /home type ext4 (rw,relatime,seclabel,data=ordered)
binfmt_misc on /proc/sys/fs/binfmt_misc type binfmt_misc (rw,relatime)
tmpfs on /run/user/1000 type tmpfs (rw,nosuid,nodev,relatime,seclabel,size=99996k,mode=700,uid=1000,gid=1000)
fusectl on /sys/fs/fuse/connections type fusectl (rw,relatime)
gvfsd-fuse on /run/user/1000/gvfs type fuse.gvfsd-fuse (rw,nosuid,nodev,relatime,user_id=1000,group_id=1000)
tmpfs on /run/user/0 type tmpfs (rw,nosuid,nodev,relatime,seclabel,size=99996k,mode=700)
/dev/sdb1 on /data type ext4 (rw,relatime,seclabel,data=ordered)
# 查看所有挂载点（临时挂载也会显示在最下方）
[root@localhost /]# df -h
Filesystem           Size  Used Avail Use% Mounted on
/dev/mapper/cl-root  9.8G  4.6G  4.7G  50% /
devtmpfs             474M     0  474M   0% /dev
tmpfs                489M  156K  489M   1% /dev/shm
tmpfs                489M   14M  476M   3% /run
tmpfs                489M     0  489M   0% /sys/fs/cgroup
/dev/sda1            477M  142M  307M  32% /boot
/dev/mapper/cl-home  5.8G  276M  5.2G   5% /home
tmpfs                 98M   24K   98M   1% /run/user/1000
tmpfs                 98M     0   98M   0% /run/user/0
/dev/sdb1            2.0G  6.0M  1.8G   1% /data
[root@localhost /]# 
[root@localhost /]# cat /etc/fstab 

#
# /etc/fstab
# Created by anaconda on Fri May  4 06:32:33 2018
#
# Accessible filesystems, by reference, are maintained under '/dev/disk'
# See man pages fstab(5), findfs(8), mount(8) and/or blkid(8) for more info
#
/dev/mapper/cl-root     /                       ext4    defaults        1 1
UUID=0de62f11-4d89-4557-b04d-64e3e4f2d3eb /boot                   ext4    defaults        1 2
/dev/mapper/cl-home     /home                   ext4    defaults        1 2
/dev/mapper/cl-swap     swap                    swap    defaults        0 0
[root@localhost /]# 
[root@localhost /]# mkdir /appData
[root@localhost /]# mount /appData
mount: can't find /appData in /etc/fstab
[root@localhost /]# mount /dev/sdb3
mount: can't find /dev/sdb3 in /etc/fstab
[root@localhost /]# mount /home/
mount: /dev/mapper/cl-home is already mounted or /home busy
       /dev/mapper/cl-home is already mounted on /home
[root@localhost /]# 
```

4. 挂载一个 ISO 镜像文件。

```shell
[root@localhost /]# mount -t iso9660 -o loop pdf_collections.iso /mnt
[root@localhost /]# cd /mnt
[root@localhost /]# ll
```

5. 挂载 `fstab` 或 `mtab` 中的文件系统时仅指定 `device` 或 `dir` 即可。如果 `mount` 命令同时指定了 `device` 和 `dir` ，那么 `mount` 命令不会读取 `/etc/fstab` 文件，如果需要覆盖 `/etc/fstab` 文件中的挂载选项，那么需要使用  `mount device|dir -o <options>` 。而 `mount -a [-t type] [-O optlist]` 命令会挂载`/etc/fstab` 文件中文件系统类型为 type、**和/或** 挂载选项为 optlist（除了挂载选项包含 noauto 的挂载项）的挂载项。该命令通常放在启动脚本中。添加 -F 选项会使 mount 命令并行叉开（fork），同时挂载所有挂载项。 如果指定的挂载选项列表中存在多个相同的挂载选项，那么以最后一个挂载选项为准。 

### umount 命令

umount 命令用于卸载 mount 命令挂载的分区。

#### 语法

```shell
umount [-hV]
umount -a [-dflnrv] [-t vfstype] [-O options]
umount [-dflnrv] {dir|device}...
```

##### 选项

```shell
-a, --all：卸载 /etc/mtab 中的所有挂载（2.7 及以后版本的 umount 不会卸载 proc 文件系统）；
-A, --all-targets：卸载当前命名空间中特定文件系统的所有挂载点。文件系统可以通过挂载点或设备名（或 UUID 等）来指定。该选项可以和 --recursive 一起使用，当前挂载的所有内置的挂载也会卸载；
-c, --no-canonicalize：不规范路径。参考前面 mount 命令中同名选项的介绍； 
-d, --detach-loop：万一卸载的设备是一个循环设备，也释放该循环设备；
	--fake：执行除了实际的系统调用外所有操作，实际上是一种“假”卸载。该选项也可以用来移除 /etc/mtab 文件中之前使用 -n 选项卸载的条目；
-f, --force：强制卸载（如果是一个不可达的 NFS 系统）（需要 2.1.116 及以后版本的内核）；
-i, --internal-only：不调用 /sbin/umount.<filesystem> helper 即使它存在。如果存在 /sbin/umount.<filesystem> helper，默认会调用它；
-n, --no-mtab：卸载时不会写入 /etc/mtab；
-l, --lazy：懒卸载。将该文件系统从文件系统层级中分离，并尽快清理所有到该文件系统的引用，就好像它不被占用一样（需要 2.4.11 及以后版本的内核）；
-O, --test-opts options,list：表明只会卸载 /etc/fstab 中有特定选项的文件系统。可以指定多个逗号分隔的选项列表来筛选文件系统，每个选项都可以使用 no 前缀来反向筛选；
-R, --recursive：递归卸载每个特定目录。递归会在任意卸载由于任意原因失败时停止。挂载点之间的关系定义在 /proc/self/mountinfo 文件的条目中。该选项中的文件系统必须通过挂载点指定，而不能使用分区名或 UUID；
-r, --read-only：如果卸载失败，则尝试重新以只读挂载；
-t, --types vfstype,ext2,ext3：表明只会卸载特定类型的文件系统。可以指定多个逗号分隔的文件系统类型。可以为每个文件系统类型使用 no 前缀来反向筛选；
-v, --verbose：verbose 模式；
-h, --help：打印帮助信息并退出；
-V, --version：打印版本并退出；
```

##### 参数

optlist：逗号分隔的挂载选项列表。

device：要卸载的分区。

dir：挂载点。

### 配置分区大小

根据前面介绍的分区命令就可以创建分区了，不过需要注意，我们要为某些特定挂载点设置合适的分区大小。CentOS 7 （参考 Red Hat Ent erprise Linux 7 安装手册）至少需要为 `/boot` 、`/ `、`/home` 、`swap` 这四个挂载点配置分区。下面是这四个挂载点分区大小建议：

- `/boot` ：建议大小至少有 500 MB。挂载到 `/boot` 的分区含有操作系统内核，它可让系统引导 CentOS，并提供引导过程中要使用的文件。`/boot` 在日常系统运行中并不需要，只在启动和内核升级的时候用到。多数情况下， 500 MB 的 `/boot` 分区就足够了。
- `/ ` ：建议大小至少为 10 GB。/ 分区（或叫根分区）是最重要而且必需的，需要最先挂载。/ 目录（或叫根目录）是目录树的顶层，所有文件和目录都在 / 目录中显示，即使它们实际上存储在其他的物理设备上（不要将 `/ 目录`与 `/root 目录`混淆。`/root 目录`是 `root 用户`的主目录）。根文件系统中的内容应该足以启动、恢复、修复系统。因此 `/` 目录下的特定目录是不能作为独立分区的。默认情况下所有文件都写入这个分区，除非要写入的路径挂载到了不同分区，比如 `/home` 分区。虽然 5 GB root 分区满足最低安装条件，但还是建议至少分配 10 GB 分区以便可以尽可能安装想要的软件包。
- `/home` ：其分区大小取决于本地保存数据量、用户数量等等。/home 目录包含用户定义的配置文件、缓存、应用程序数据和媒体文件。该分区的存在可以让你在不删除用户数据文件的情况下进行升级或者重装 CentOS。如果存储空间超过 50 GB，则会在创建其他分区的同时自动创建 /home 分区。考虑为所有可能包含敏感数据的分区加密。考虑为所有可能包含敏感数据的分区加密。加密可防止对这些分区中数据的未授权访问，即使他们可以访问物理存储设备。在大多数情况下，应该至少对 /home 分区加密。
- `swap` ：swap 分区支持虚拟内存。当没有足够的 RAM 保存系统处理的数据时会将数据写入 swap 分区。当系统缺乏 swap 空间时，内核会因 RAM 内存耗尽而终止进程。配置过多 swap 空间会造成存储设备处于分配状态而闲置，这是浪费资源。过多 swap 空间还会掩盖内存泄露。内存小于 4G 时设置该分区大小为内存的 2 倍 ，内存大于 4G 时设置该分区的大小和内存大小一致即可 。下表根据系统中的 RAM 容量以及是否需要足够的内存以便系统休眠来提供推荐的 swap 分区大小。

| 系统 RAM 容量 | 建议 swap 空间大小        | 允许休眠的建议 swap 空间大小 |
| ------------- | ------------------------- | ---------------------------- |
| 低于 2 GB     | RAM 容量的两倍            | RAM 容量的三倍               |
| 2 GB - 8 GB   | 与 RAM 容量相等           | RAM 容量的两倍               |
| 8 GB - 64 GB  | 4 GB 到 RAM 容量的 0.5 倍 | RAM 容量的 1.5 倍            |
| 超过 64 GB    | 独立负载（至少 4GB）      | 不建议使用休眠功能           |



下面是可选的挂载点分区：

- `/var` ：/var 分配 8-12 GB 对于桌面系统来说是比较合适的取值，具体取值取决于安装的软件数量。/var 目录中包含大量的应用程序变量数据，例如 spool 目录和文件，管理和登录数据，pacman 的缓存，ABS 树，Apache 网页服务器，临时下载的更新软件包（PackageKit 更新软件默认将更新的软件包下载到 /var/cache/yum/）等等。它通常被用作缓存或者日志记录，因此读写频繁。将它独立出来可以避免由于大量日志写入造成的磁盘空间耗尽等问题。确定挂载在 /var 的分区中有足够空间可用于保存下载的更新以及其他内容。如果要为 /var 生成独立分 区，请确定 /var/cache/yum/ 大小至少在 3.0 GB 以上以便保存下载的软件包更新。

- `/usr` ：/user 目录中包含 CentOS 系统中大部分软件内容。要安装默认软件组需要分配至少 5 GB 空间。如果将该系统作为软件开发工作站使用，则至少需要分配 10GB。如果 /usr 或 /var 是在剩余 root 卷之外进行分区，引导过程会变得非常复杂，因为这些目录包含对引导极为重要的组件。在某些情况下，比如这些目录位于 iSCSI 驱动器或 FCoE 位置， 系统可能无法引导，或 者在关机或重启时挂起，并给出 Device is busy 出错信息。这些限制仅适用于 /usr 或 /var，不会对以下目录产生影响。例如：/var/www 的独立分区可正常工作，没有任何问题。

  考虑在 LVM 卷组中保留部分未分配空间。如果空间需要更改，但不希望删除其他分区中的数据来重新分配存储，这个未分配空间就提供了一些机动性。还可以为该分区选择**精简配置**设备类型，以便该卷可以自动处理未使用的空间。如果将子目录分成分区，就可以在决定使用当前安装 CentOS 新版时保留那些子目录中的内容。例如：如果要在 /var/lib/mysql 中运行 MySQL 数据库，请将那个目录放在单独的分区中，以备之后需要重新安装。

- `/boot/efi` ：如果使用 UEFI 引导方式，则还需要 /boot/efi 分区，该分区应至少应有 50 MB，建议使用 200 MB。我们可以根据需要（比如安装 Weblogic 和 Oracle 时）创建额外的分区。在使用 GPT（GUID 分区表）的引导装载程序的 BIOS 系统中，需要生成大小为 1 MB 的 biosboot 分区。

- `/data`：可以为需要多用户共享的文件建立一个 data （其他名称也可以）分区，比如 Oracle 的数据库实例可以放在该目录下。

为各挂载目录创建好分区之后，就可以为其创建文件系统了。

### 创建文件系统

在 Windows 环境下，格式化的操作相对简单。通常的操作步骤是：先打开资源管理器，接着在希望被执行格式化的盘符图标上右击，然后选择“格式化”，再按照提示操作即可。也可以选择“快速格式化”，但要求分区没有坏道。需要注意的是：对硬盘执行格式化操作时，用户需要拥有系统管理员权限（仅限于 Windows Vista 以及此后推出的作业系统）。在 Windows 环境中，除了可以使用图形化的操作界面执行格式化操作之外，也可以在命令提示字符中使用 `Diskpart 指令`（仅限于 Windows 2000 及以后的作业系统，包含 Windows PE）进行操作。

在 Unix/Linux 环境下，通常使用命令工具执行格式化操作。需要注意的是：对硬盘执行格式化操作时，用户需要拥有超级用户权限。创建文件系统的常用命令如下：

- mkfs：创建一个 ext 文件系统；
- mke2fs：创建一个 ext2 文件系统；
- mkfs.ext2：创建一个 ext2 文件系统；
- mkfs.ext3：创建一个 ext3 文件系统；
- mkfs.ext4：创建一个 ext4 文件系统；
- mkfs.xfs：创建一个 XFS 文件系统；
- xfs_mkfile：创建一个 XFS t文件系统；
- mkfs.cramfs：创建一个 cramfs 文件系统；
- mkfs.btrfs：创建一个 Btrfs 文件系统；
- mkswap：创建一个 swap 文件系统；
- jfs_mkfs：创建一个 JFS 文件系统。  

并非所有文件系统的命令工具都已经默认安装了。要想知道某个文件系统的命令工具是否可用，可以使用 type 命令。

```shell
[root@localhost ~]# type mkfs
mkfs is /usr/sbin/mkfs
[root@localhost ~]# type mke2fs
mke2fs is /usr/sbin/mke2fs
[root@localhost ~]# type mkfs.ext2
mkfs.ext2 is /usr/sbin/mkfs.ext2
[root@localhost ~]# type mkfs.ext3
mkfs.ext3 is /usr/sbin/mkfs.ext3
[root@localhost ~]# type mkfs.ext4
mkfs.ext4 is /usr/sbin/mkfs.ext4
[root@localhost ~]# type mkfs.xfs
mkfs.xfs is /usr/sbin/mkfs.xfs
[root@localhost ~]# type mkfs.cramfs
mkfs.cramfs is /usr/sbin/mkfs.cramfs
[root@localhost ~]# type mkfs.btrfs
mkfs.btrfs is /usr/sbin/mkfs.btrfs
[root@localhost ~]# type xfs_mkfile
xfs_mkfile is /usr/sbin/xfs_mkfile
[root@localhost ~]# type mkswap
mkswap is /usr/sbin/mkswap
[root@localhost ~]# type jfs_mkfs
-bash: type: jfs_mkfs: not found
```

每个文件系统命令都有很多命令行选项，允许你定制如何在分区上创建文件系统。要查看所有可用的命令行选项，可用 man 命令来显示该文件系统命令的手册页面。所有的文件系统命令都允许通过不带选项的简单命令来创建一个默认的文件系统。

```shell
[root@localhost ~]# parted
GNU Parted 3.1
Using /dev/sda
Welcome to GNU Parted! Type 'help' to view a list of commands.
(parted) select /dev/sdb
Using /dev/sdb
(parted) print                                                            
Model: VMware, VMware Virtual S (scsi)
Disk /dev/sdb: 21.5GB
Sector size (logical/physical): 512B/512B
Partition Table: msdos
Disk Flags: 

Number  Start   End     Size    Type     File system  Flags
 1      1049kB  2149MB  2147MB  primary  ext4
 2      2149MB  4296MB  2147MB  primary
 3      4296MB  5370MB  1074MB  primary

(parted) q                                                                
[root@localhost ~]# mkfs.ext3 /dev/sdb2
mke2fs 1.42.9 (28-Dec-2013)
Filesystem label=
OS type: Linux
Block size=4096 (log=2)
Fragment size=4096 (log=2)
Stride=0 blocks, Stripe width=0 blocks
131072 inodes, 524288 blocks
26214 blocks (5.00%) reserved for the super user
First data block=0
Maximum filesystem blocks=536870912
16 block groups
32768 blocks per group, 32768 fragments per group
8192 inodes per group
Superblock backups stored on blocks: 
        32768, 98304, 163840, 229376, 294912

Allocating group tables: done                            
Writing inode tables: done                            
Creating journal (16384 blocks): done
Writing superblocks and filesystem accounting information: done 

[root@localhost ~]# parted
GNU Parted 3.1
Using /dev/sda
Welcome to GNU Parted! Type 'help' to view a list of commands.
(parted) select /dev/sdb                                                  
sdb   sdb1  sdb2  sdb3  
(parted) select /dev/sdb
Using /dev/sdb
(parted) print                                                            
Model: VMware, VMware Virtual S (scsi)
Disk /dev/sdb: 21.5GB
Sector size (logical/physical): 512B/512B
Partition Table: msdos
Disk Flags: 

Number  Start   End     Size    Type     File system  Flags
 1      1049kB  2149MB  2147MB  primary  ext4
 2      2149MB  4296MB  2147MB  primary  ext3
 3      4296MB  5370MB  1074MB  primary

(parted) q
[root@localhost ~]# 
```

为分区创建了文件系统之后，下一步是将它挂载到虚拟目录下的某个挂载点，这样就可以将数据存储在新文件系统中了。你可以将新文件系统通过 mount 命令挂载到虚拟目录中需要额外空间的任何位置。

```shell
[root@localhost ~]# mkdir /data
[root@localhost ~]# cd /
[root@localhost /]# ll
total 70
lrwxrwxrwx.   1 root root     7 May  4 06:32 bin -> usr/bin
dr-xr-xr-x.   5 root root  1024 May  8 21:44 boot
drwxr-xr-x.   2 root root  4096 May 13 20:47 data
drwxr-xr-x.  20 root root  3400 May 13 20:43 dev
drwxr-xr-x. 139 root root 12288 May 13 20:25 etc
drwxr-xr-x.   4 root root  4096 May  4 06:46 home
lrwxrwxrwx.   1 root root     7 May  4 06:32 lib -> usr/lib
lrwxrwxrwx.   1 root root     9 May  4 06:32 lib64 -> usr/lib64
drwx------.   2 root root 16384 May  4 06:32 lost+found
drwxr-xr-x.   2 root root  4096 Nov  5  2016 media
drwxr-xr-x.   3 root root  4096 May  8 21:41 mnt
drwxr-xr-x.   3 root root  4096 May  4 06:42 opt
dr-xr-xr-x. 182 root root     0 May  8 07:35 proc
dr-xr-x---.   5 root root  4096 May 13 20:19 root
drwxr-xr-x.  41 root root  1200 May 13 11:23 run
lrwxrwxrwx.   1 root root     8 May  4 06:32 sbin -> usr/sbin
drwxr-xr-x.   2 root root  4096 Nov  5  2016 srv
dr-xr-xr-x.  13 root root     0 May  8 07:35 sys
drwxrwxrwt.  20 root root  4096 May 13 20:42 tmp
drwxr-xr-x.  13 root root  4096 May  4 06:32 usr
drwxr-xr-x.  22 root root  4096 May  8 07:35 var
[root@localhost /]# mount -t ext4 /dev/sdb1 /data
[root@localhost /]# ls -al /data
total 24
drwxr-xr-x.  3 root root  4096 May 13 20:39 .
dr-xr-xr-x. 19 root root  4096 May 13 20:47 ..
drwx------.  2 root root 16384 May 13 20:39 lost+found
[root@localhost /]# df -h
Filesystem           Size  Used Avail Use% Mounted on
/dev/mapper/cl-root  9.8G  4.6G  4.7G  50% /
devtmpfs             474M     0  474M   0% /dev
tmpfs                489M  156K  489M   1% /dev/shm
tmpfs                489M   14M  476M   3% /run
tmpfs                489M     0  489M   0% /sys/fs/cgroup
/dev/sda1            477M  142M  307M  32% /boot
/dev/mapper/cl-home  5.8G  276M  5.2G   5% /home
tmpfs                 98M   24K   98M   1% /run/user/1000
tmpfs                 98M     0   98M   0% /run/user/0
/dev/sdb1            2.0G  6.0M  1.8G   1% /data
[root@localhost /]# 
```

现在你可以在新分区中保存新文件和目录了！ 这种挂载文件系统的方法只能临时挂载文件系统。当重启 Linux 系统时，文件系统并不会自动挂载。要强制 Linux 在启动时自动挂载新的文件系统，可以将其添加到 /etc/fstab 文件。

### 逻辑卷管理（LVM）

如果用标准分区在硬盘上创建了文件系统，为已有文件系统添加额外的空间多少是一种痛苦的体验。你只能在同一个物理硬盘的可用空间范围内调整分区大小。如果硬盘上没有地方了，你 就必须弄一个更大的硬盘，然后手动将已有的文件系统移动到新的硬盘上。 这时候可以通过将另外一个硬盘上的分区加入已有文件系统，动态地添加存储空间。 Linux 逻辑卷管理器（logical volume manager， LVM）软件包正好可以用来做这个。它可以让你在无需重建整个文件系统的情况下，轻松地管理磁盘空间。 

#### 逻辑卷管理布局

逻辑卷管理的核心在于如何处理安装在系统上的硬盘分区。在逻辑卷管理的世界里，硬盘称作**物理卷（physical volume， PV）**。每个物理卷都会映射到硬盘上特定的物理分区。 多个物理卷集中在一起可以形成一个**卷组（volume group， VG）**。逻辑卷管理系统**将卷组视为一个物理硬盘**，但事实上卷组可能是由分布在多个物理硬盘上的多个物理分区组成的。**卷组提供了一个创建逻辑分区的平台，而这些逻辑分区则包含了文件系统。 整个结构中的最后一层是逻辑卷（logical volume， LV）**。**逻辑卷为Linux提供了创建文件系统的分区环境，作用类似于到目前为止我们一直在探讨的Linux 中的物理硬盘分区。Linux 系统将逻辑卷视为物理分区。 可以使用任意一种标准 Linux 文件系统来格式化逻辑卷，然后再将它加入Linux虚拟目录中的 某个挂载点**。    

![lvm01](G:/graphs/photos/lvm01.png)

Linux 系统将每个逻辑卷视为一个物理分区。每个逻辑卷可以被格式化成某种文件系统，然后挂载到虚拟目录中某个特定位置。 注意，上图中的第三个物理硬盘有一个未使用的分区。通过逻辑卷管理，你随后可以轻松地将这个未使用分区分配到已有卷组：要么用它创建一个新的逻辑卷，要么在需要更多空间时用它来扩展已有的逻辑卷。 类似地，如果你给系统添加了一块硬盘，逻辑卷管理系统允许你将它添加到已有卷组，为某个已有的卷组创建更多空间，或是创建一个可用来挂载的新逻辑卷。这种扩展文件系统的方法要好用得多！    

#### Linux LVM

Linux LVM 是由 Heinz Mauelshagen 开发的，于 1998年 发布到了 Linux 社区。它允许你在 Linux 上用简单的命令行命令管理一个完整的逻辑卷管理环境。 Linux LVM 有两个可用的版本。 

- LVM1：最初的 LVM 包于 1998 年发布，只能用于 Linux 内核 2.4 版本。它仅提供了基本的逻 辑卷管理功能。
- LVM2： LVM 的更新版本，可用于 Linux 内核 2.6 版本。它在标准的 LVM1 功能外提供了额外的功能。

大部分采用 2.6 或更高内核版本的现代 Linux 发行版都提供对 LVM2 的支持。除了标准的逻辑卷管理功能外， LVM2 还提供了另外一些好用的功能。 

1. **快照**。

   最初的Linux LVM允许你在逻辑卷在线的状态下将其复制到另一个设备。这个功能叫作快 照。在备份由于高可靠性需求而无法锁定的重要数据时，快照功能非常给力。传统的备份方法在 将文件复制到备份媒体上时通常要将文件锁定。快照允许你在复制的同时，保证运行关键任务的 Web 服务器或数据库服务器继续工作。遗憾的是， LVM1 只允许你创建只读快照。一旦创建了快照，就不能再写入东西了。 LVM2 允许你创建在线逻辑卷的可读写快照。有了可读写的快照，就可以删除原先的逻辑卷， 然后将快照作为替代挂载上。这个功能对快速故障转移或涉及修改数据的程序试验（如果失败， 需要恢复修改过的数据）非常有用。    

2. **条带化**。

   LVM2 提供的另一个引人注目的功能是条带化（striping）。有了条带化，可跨多个物理硬盘创建逻辑卷。当Linux LVM 将文件写入逻辑卷时，文件中的数据块会被分散到多个硬盘上。每个后继数据块会被写到下一个硬盘上。 条带化有助于提高硬盘的性能，因为 Linux 可以将一个文件的多个数据块同时写入多个硬盘， 而无需等待单个硬盘移动读写磁头到多个不同位置。这个改进同样适用于读取顺序访问的文件， 因为 LVM 可同时从多个硬盘读取数据。

   > LVM 条带化不同于 RAID 条带化。 LVM 条带化不提供用来创建容错环境的校验信息。事实上， LVM 条带化会增加文件因硬盘故障而丢失的概率。单个硬盘故障可能会造成多个逻辑卷无法访问。        

3. **镜像**。

   通过 LVM 安装文件系统并不意味着文件系统就不会再出问题。和物理分区一样， LVM 逻辑卷也容易受到断电和磁盘故障的影响。一旦文件系统损坏，就有可能再也无法恢复。 LVM 快照功能提供了一些安慰，你可以随时创建逻辑卷的备份副本，但对有些环境来说可能还不够。对于涉及大量数据变动的系统，比如数据库服务器，自上次快照之后可能要存储成百上千条记录。 这个问题的一个解决办法就是 LVM 镜像。镜像是一个实时更新的逻辑卷的完整副本。当你创建镜像逻辑卷时， LVM 会将原始逻辑卷同步到镜像副本中。根据原始逻辑卷的大小，这可能需要一些时间才能完成。 一旦原始同步完成， LVM 会为文件系统的每次写操作执行两次写入——一次写入到主逻辑卷，一次写入到镜像副本。可以想到，这个过程会降低系统的写入性能。就算原始逻辑卷因为某些原因损坏了，你手头也已经有了一个完整的最新副本！

#### 使用 Linux LVM

Linux LVM 包只提供了命令行程序来创建和管理逻辑卷管理系统中所有组件。有些 Linux 发行版则包含了命令行命令对应的图形化前端，但为了完全控制你的 LVM 环境，最好习惯直接使用这些命令。

1. **定义物理卷**

   创建过程的第一步就是将硬盘上的物理分区转换成 Linux LVM 使用的物理卷区段。fdisk 命令可以帮忙。在创建了基本的 Linux 分区之后，你需要通过 t 命令改变分区类型。

   ```shell
   
   ```

   分区类型 8e 表示这个分区将会被用作 Linux LVM 系统的一部分，而不是一个直接的文件系统。

   下一步是用分区来创建实际的物理卷。这可以通过 pvcreate 命令来完成。 pvcreate 定义了用于物理卷的物理分区。它只是简单地将分区标记成 Linux LVM 系统中的分区而已。

   ```shell
   
   ```

   > 别被吓人的消息 dev_is_mpath: failed to get device for 8:17 或类似的消息唬住了。只要看到了 successfully created 就没问题。 pvcreate 命令会检查分区是否为多路（multi-path， mpath）设备。如果不是的话，就会发出上面那段消息。    

   如果你想查看创建进度的话，可以使用 pvdisplay 命令来显示已创建的物理卷列表。

   ```shell
   
   ```

   pvdisplay 命令显示出 /dev/sdb1 现在已经被标记为物理卷。注意，输出中的 VG Name 内容为空，因为物理卷还不属于某个卷组。

2. **创建卷组**

   下一步是从物理卷中创建一个或多个卷组。究竟要为系统创建多少卷组并没有既定的规则， 你可以将所有的可用物理卷加到一个卷组，也可以结合不同的物理卷创建多个卷组。 要从命令行创建卷组，需要使用 vgcreate 命令。 vgcreate 命令需要一些命令行参数来定义卷组名以及你用来创建卷组的物理卷名。

   ```shell
   
   ```

   输出结果平淡无奇。如果你想看看新创建的卷组的细节，可用 vgdisplay 命令。

   ```shell
   
   ```

   这个例子使用 /dev/sdb1 分区上创建的物理卷，创建了一个名为 Vol1 的卷组。 创建一个或多个卷组后，就可以创建逻辑卷了。

3. **创建逻辑卷**

   Linux 系统使用逻辑卷来模拟物理分区，并在其中保存文件系统。 Linux 系统会像处理物理分区一样处理逻辑卷，允许你定义逻辑卷中的文件系统，然后将文件系统挂载到虚拟目录上。 要创建逻辑卷，使用 lvcreate 命令。虽然你通常不需要在其他 Linux LVM 命令中使用命令行选项，但 lvcreate 命令要求至少输入一些选项。

   - 

   虽然命令行选项看起来可能有点吓人，但大多数情况下你用到的只是少数几个选项。

   ```shell
   
   ```

   如果想查看你创建的逻辑卷的详细情况，可用 lvdisplay 命令。

   ```shell
   
   ```

   卷组名（Vol1）用来标识创建新逻辑卷时要使 用的卷组。 -l选项定义了要为逻辑卷指定多少可用的卷组空间。注意，你可以按照卷组空闲空间的百分 比来指定这个值。本例中为新逻辑卷使用了所有的空闲空间。 你可以用-l选项来按可用空间的百分比来指定这个大小，或者用-L选项以字节、千字节 （KB）、兆字节（MB）或吉字节（GB）为单位来指定实际的大小。 -n选项允许你为逻辑卷指定 一个名称（在本例中称作lvtest）。    

4. **创建文件系统**

   运行完 lvcreate 命令之后，逻辑卷就已经产生了，但它还没有文件系统。你必须使用相应的命令行程序来创建所需要的文件系统。

   ```shell
   
   ```

   在创建了新的文件系统之后，可以用标准 mount 命令将这个卷挂载到虚拟目录中，就跟它是物理分区一样。唯一的不同是你需要用特殊的路径来标识逻辑卷。

   注意，mkfs.ext4 和 mount 命令中用到的路径都有点奇怪。路径中使用了卷组名和逻辑卷名，而不是物理分区路径。文件系统被挂载之后，就可以访问虚拟目录中的这块新区域了。

5. 修改LVM Linux LVM的好处在于能够动态修改文件系统，因此最好有工具能够让你实现这些操作。在 Linux有一些工具允许你修改现有的逻辑卷管理配置。

   vgchange 激活和禁用卷组
   vgremove 删除卷组
   vgextend 将物理卷加到卷组中
   vgreduce 从卷组中删除物理卷
   lvextend 增加逻辑卷的大小
   lvreduce 减小逻辑卷的大小   

   在手动增加或减小逻辑卷的大小时，要特别小心。逻辑卷中的文件系统需要手动修整来 处理大小上的改变。大多数文件系统都包含了能够重新格式化文件系统的命令行程序， 比如用于 ext2、 ext3 和 ext4 文件系统的 resize2fs 程序。

##