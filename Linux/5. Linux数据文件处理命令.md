### sort 命令

**sort 命令**用于进行排序、合并或比较操作。要操作的内容可以是文件内容，也可以是命令输出和标准输入（如果没有给出文件，也没有使用 -FILE 选项）。该命令默认将结果写入到标准输出中。

退出状态码：

- 0  没有出错；
- 1  当使用了 `-c` 或者 `-C` 时输入数据未排序；
- 2  如果出错。

#### 语法

```shell
Usage: sort [OPTION]... [FILE]...
   or: sort [OPTION]... --files0-from=F
```

##### 选项

```shell
# sort 命令有三种操作模式：排序（默认）、合并和检查已排序结果。以下选项用于非默认操作模式。
-c, --check, --check=diagnose-first：不进行排序，仅检查给定的文件是否已经排序好了。如果没有排序好，则输出包含第一个乱序行的诊断信息，以状态码 1 退出。如果已经排序好了，就直接退出；
-C, --check=quiet, --check=silent：最多给定一个文件。类似 -c 选项，但不在第一行报告的诊断信息；
-m, --merge：通过将给定的文件排序成一个组来合并它们。每个输入文件总会是排序好的。我们通常进行的都是排序操作，而不是合并。提供合并排序功能是因为在需要合并排序时更快；
# 以下选项会影响输出行的顺序，可以全局设置，也可以作为某个特定关键字段（key field）的一部分。如果没有指定关键字段，则全部的行将应用全局设置进行比较；否则全局设置将通过没有指定选项的关键字段来继承。
-b, --ignore-leading-blanks：忽略每行前面开始出的空白字符（默认情况下空白符为空格、制表符，但可以通过LC_CTYPE 变量来指定）；
-d, --dictionary-order：排序时仅考虑（ASCII表中的）字母、数值和空白字符（默认情况下空白符为空格、制表符，但可以通过LC_CTYPE 变量来指定），不考虑其他特殊字符；
-f, --ignore-case：该选项会忽略大小写。默认情况下，会将大写字母排在前面；
-g, --general-numeric-sort, --sort=general-numeric：根据一般数值（将每行开始的数值转换为long的双精度浮点值，不以数值开头的行不进行处理）进行比较，而不是按照数值的字符串值进行比较。这样可以比较出“5”和“17”的数值大小，而不是比较“5”和“17”中的“1”的字符大小。该选项比“-n, --numeric-sort”要慢得多；
-h, --human-numeric-sort, --sort=human-numeric：排序时比较简化的数值。首先是正负号和0，然后是大小后缀，如k、K或者MGTPEZY等。比如“1023M”比“1G”要小；
-i, --ignore-nonprinting：排序时仅考虑可打印字符；
-M, --month-sort, --sort=month：排序时比较三位字母（不区分大小写）表示的月份。当每行以 Apr、Au、Dec、Feb、Jan 等开头时可以使用该选项；
-n, --numeric-sort, --sort=numeric：按字符串数值来排序（并不转换为浮点数）；
-V, --version-sort：按文本中的（版本）数值自然排序。该选项除了将十进制数字当成索引/版本值以外，其他的与标准排序类似；
-r, --reverse：反向排序；
-R, --random-sort, --sort=random：对输入键（比较的对象）进行hash（hash函数的选择受 `--random-source` 选项的影响），按生成的hash值排序；
    --compress-program=PROG：使用PROG程序压缩临时文件。不使用参数时，PROG必须将标准输入压缩到标准输出。当给出`-d`选项时，将标准输入解压缩到标准输出；
    --files0-from=FILE: 不从命令行读取文件（files），而是从名为FILE的文件中读取文件列表，FILE文件中的各文件名以ASCII NUL字符分隔。当文件名列表很长，可能超过了命令行的限制时该选项就很有用。生成以ASCII NUL字符分隔的文件列表的方式之一就是GNU `find`命令，使用该命令的`-print0`断言。如果FILE值为`-`，以ASCII NUL字符分隔的文件列表将从标准输入中读取;
-k POS1[,POS2] , --key=POS1[,POS2]：指定每行中包含POS1到POS2位置之间（如果没有指定POS2，则为POS1到行尾之间）内容作为排序的比较字段。字段之间以空白符分隔。每个POS的格式为`F[.C][OPTS]`，F表示所用字段的位置，C表示从字段中首个字符开始的位置，字段和字符的位置都是从1开始的，POS2的字符位置为0表示该字段的最后一个字符。如果POS1的`.C`省略了，则默认为1（从字段起始开头），如果POS2的`.C`省略了，则默认为0（到字段末尾）。`OPTS`是排序选项，指定排序的规则；
    --debug：高亮每行用于排序的部分，也向stderr警告出有问题的用法；
    --batch-size=NMERGE：每次最多合并NMERGE个输入。当总合并数超过NMERGE时，；
-o OUTPUT-FILE, --output=OUTPUT-FILE：将输出写入名为OUTPUT-FILE的文件中，而不是标准输出中。比如，你可以使用`sort -o F F`、`cat F | sort -o F`； 
    --random-source=FILE：将名为 FILE 的文件作为随机数据源，这些随机数据源将决定`-R`选项选用哪个随机hash函数；
-s, --stable：禁用最后重排序比较，让`sort`更稳定；
-S, --buffer-size=SIZE：将主内容缓冲区大小为SIZE（默认以1024字节为单位）。在SIZE后面添加`%`表示占用物理内存的百分比。也可以在SIZE后面添加`K`、`M`、`G`、`T`、`P`、`E`、`Z`和`Y`等来表示对应的物理大小。在SIZE后面添加`b`表示SIZE个字节大小；
-t SEPARATOR, --field-separator=SEPARATOR：当在每行中寻找排序键时指定字符SEPARATOR作为字段分隔符。默认情况下，字段以非空白字符和空白字符（默认为空格或制表符）之间的空字符串分隔；
-T TEMPDIR, --temporary-directory=TEMPDIR：指定一个位置来存储临时工作文件，覆盖 `TMPDIR`环境变量。如果该选项使用不止一次，那么临时文件将存放在所有给定的目录中。当有大量的排序或合并操作而占用过多的IO资源，那么多次使用该选项指定多个临时目录来提高性能；
    --parallel=N：设置排序操作的并行数量为N。N默认为可用的处理器数量，但最大为8；
-u, --unique：和`-c`参数一起使用时，检查是否已严格排序。不和`-c`参数一起用时，在有多个相同的行时仅输出一个相同的行；
-z, --zero-terminated：用0值字节（ASCII NUL）分隔排序项，而不是用换行符（ASCII LF）。该选项可以联合`perl -0`或`find -print0`和`xargs -0`一起使用；
    --sort=WORD：根据 WORD 来排序。 WORD可以为 general-numeric（ -g）、human-numeric（-h）、month（-M）、numeric（-n）、random（-R）、version（-V）；
    --help：显示帮助并退出；
    --version：显示版本信息并退出。
```

##### 参数

FILE：指定待排序的文件列表。

#### 实例

1. 直接使用sort命令进行简单排序。将文件/文本的每一行作为一个单位，相互比较，比较原则是从首字符向后，依次按ASCII 码值进行比较，最后将它们按升序输出。

```shell
[vincent@localhost testdir01]$ cat test07
AAA:BB:CC
aaa:30:1.6
ccc:50:3.3
ddd:20:4.2
bbb:10:2.5
eee:40:5.4
eee:60:5.1
[vincent@localhost testdir01]$ sort test07
aaa:30:1.6
AAA:BB:CC
bbb:10:2.5
ccc:50:3.3
ddd:20:4.2
eee:40:5.4
eee:60:5.1
```

2. 用-u选项在排序时忽略其他相同行，仅输出一个像同行。uniq命令仅去除像同行，不排序。

```shell
[vincent@localhost testdir01]$ cat test08
aaa:10:1.1
ccc:30:3.3
ddd:40:4.4
bbb:20:2.2
eee:50:5.5
eee:50:5.5
[vincent@localhost testdir01]$ sort -u test08
aaa:10:1.1
bbb:20:2.2
ccc:30:3.3
ddd:40:4.4
eee:50:5.5
[vincent@localhost testdir01]$ uniq test08
aaa:10:1.1
ccc:30:3.3
ddd:40:4.4
bbb:20:2.2
eee:50:5.5
```

3. 联合使用 -n、-r、-k、-t选项，从指定位置开始，以数值进行比较，以指定字符为字段分隔符（默认为空白符），倒序排列比较结果。

```shell
[vincent@localhost testdir01]$ cat test07
AAA:BB:CC
aaa:30:1.6
ccc:50:3.3
ddd:20:4.2
bbb:10:2.5
eee:40:5.4
eee:60:5.1
#将BB列按照数字从小到大顺序排列
[vincent@localhost testdir01]$ sort -nk 2 -t : test07
AAA:BB:CC
bbb:10:2.5
ddd:20:4.2
aaa:30:1.6
eee:40:5.4
ccc:50:3.3
eee:60:5.1
#将CC列数字从大到小顺序排列
[vincent@localhost testdir01]$ sort -nrk 3 -t : test07
eee:40:5.4
eee:60:5.1
ddd:20:4.2
ccc:50:3.3
bbb:10:2.5
aaa:30:1.6
AAA:BB:CC
```

4. 将文件列表按大小从小到大排列。

```shell
[vincent@localhost testdir01]$ ls -al
total 40
drwxrwxr-x 2 vincent vincent 4096 Apr 15 18:20 .
drwxrwxr-x 5 vincent vincent 4096 Jan 15 10:30 ..
-rw-r--r-- 1 root    root      29 Jan  1 14:29 test01
-rw-r--r-- 1 root    root      30 Jan  1 14:30 test02
-rw-r--r-- 1 root    root      59 Jan  1 14:30 test03
-rw-rw-r-- 1 vincent vincent   17 Apr 13 23:03 test04
-rw-rw-r-- 1 vincent vincent   21 Apr 13 23:04 test05
-rw-rw-r-- 1 vincent vincent   34 Apr 15 18:10 test06
-rw-rw-r-- 1 vincent vincent   76 Apr 15 18:17 test07
-rw-rw-r-- 1 vincent vincent   66 Apr 15 18:20 test08
[vincent@localhost testdir01]$ ls -al | sort -nk 5
total 40
-rw-rw-r-- 1 vincent vincent   17 Apr 13 23:03 test04
-rw-rw-r-- 1 vincent vincent   21 Apr 13 23:04 test05
-rw-r--r-- 1 root    root      29 Jan  1 14:29 test01
-rw-r--r-- 1 root    root      30 Jan  1 14:30 test02
-rw-rw-r-- 1 vincent vincent   34 Apr 15 18:10 test06
-rw-r--r-- 1 root    root      59 Jan  1 14:30 test03
-rw-rw-r-- 1 vincent vincent   66 Apr 15 18:20 test08
-rw-rw-r-- 1 vincent vincent   76 Apr 15 18:17 test07
drwxrwxr-x 2 vincent vincent 4096 Apr 15 18:20 .
drwxrwxr-x 5 vincent vincent 4096 Jan 15 10:30 ..
```

5. 使用 find 命令来生成以ASCII NUL字符分隔的文件列表，将其输出通过管道符作为 `sort --files0-from=` 命令的输入来进行排序。在要进行将其内容排序的文件列表很长时很有用。

```shell
[vincent@localhost testdir01]$ ll
total 20
-rw-r--r-- 1 root    root    29 Jan  1 14:29 test01
-rw-r--r-- 1 root    root    30 Jan  1 14:30 test02
-rw-r--r-- 1 root    root    59 Jan  1 14:30 test03
-rw-rw-r-- 1 vincent vincent 17 Apr 13 23:03 test04
-rw-rw-r-- 1 vincent vincent 21 Apr 13 23:04 test05
# 将“test0？”匹配的文件内容统一排序
[vincent@localhost testdir01]$ find -name "test0?" -print0 | sort --files0-from=-

0
0
0
1
1
1
2
4
5
5
5
6
67
7
8
8
9
a
this is text in test01 file.
this is text in test01 file.
 this is text in test02 file.
 this is text in test02 file.
[vincent@localhost testdir01]$ 
```

### grep 命令

**grep**（global search regular expression(RE) 用于从文件或标准输入中查找出匹配指定正则表达式（不能匹配换行符）的行并打印出来（默认行为）。

#### 语法

```shell
Usage: grep [OPTIONS] PATTERN [FILE...]
   or: grep [OPTIONS] [-e PATTERN | -f FILE] [FILE...]
```

##### 选项

```shell
# 正则匹配相关选项
-E, --extended-regexp：将 PATTERN 当作一个扩展的正则表达式（extended regular expression，ERE）；
-F, --fixed-strings：将 PATTERN 当作一个固定字符串的列表，固定字符串之间以换行符分隔。每行固定字符串都用于匹配；
-G, --basic-regexp：将 PATTERN 当作一个基本的正则表达式（basic regular expression，BRE）。这是默认行为；
-P, --perl-regexp：将 PATTERN 当作一个 Perl 类型的正则表达式；
-e, --regexp=PATTERN：使用 PATTERN 来匹配。可以用来指定多个查找 patterns，或者保护以中划线 - 开头的 pattern；
-f, --file=FILE：从名为 FILE 的文件中获取 patterns，每行一个 pattern；
-i, --ignore-case：忽略 PATTERN 和输入文件中的大小写；
-w, --word-regexp：仅选择全词匹配的行。匹配字符串必须是在每行的末尾，或者后面是非单词字符（non-word characters）。单词字符包括字母、数字和下划线；
-x, --line-regexp：仅选择全行完全匹配的行；
-z, --null-data：数据行以0值字节结尾，而不是换行符；
# 输出控制
-m, --max-count=NUM：当匹配了 NUM 行之后就停止读取文件。可以用于后续恢复查找。当 grep 停止匹配时就不会输出后续的行了。如果也使用了 -c 或 --count 选项，则不会输出比 NUM 更大的数。如果也使用了 -v 或 --inverse-match 选项，grep 会在输出 NUM 行不匹配的行之后停止；
-b, --byte-offset：在输出行的最前面打印出匹配部分开头的字节偏移量（从0开始）；
-n, --line-number：在输出行的最前面打印出匹配行原来的行号；
    --line-buffered：每匹配出一行就马上输出一行； 
-H, --with-filename：在输出行的最前面打印出每个匹配的文件名。这是有多个搜索文件时的默认行为；
-h, --no-filename：在输出行的最前面不打印文件名。这是仅有一个搜索文件时或仅有标准输入时的默认行为；
    --label=LABEL：在输出行的最前面打印出实际上来自与标准输入的输入，就好像输入来自于文件 LABLE 一样。比如，`gzip -cd foo.gz | grep --label=foo -H something`名来的输出形式为每行前面以foo开头，之后每行中都包含有 something 字符串；
-o, --only-matching：仅打印出匹配行的匹配部分，每个匹配部分单独一行；
-q, --quiet, --silent：不向标准输出写入任何信息。找到匹配行后（甚至出错时）返回退出状态码0；
    --binary-files=TYPE：假定二进制文件类型为 TYPE，TYPE 可以为'binary'（默认），'text'和'without-match'；
-a, --text：像处理文本一样处理二进制文件，同`--binary-files=text`；
-I：同`--binary-files=without-match`；
-d, --directories=ACTION：如何处理目录。ACTION可以为'read'，'recurse'（遍历读取目录下的文件，跟随位于命令行上的符号链接）或'skip'；
-D, --devices=ACTION：如何处理设备，FIFOs和sockets。ACTION可以为'read'或'skip'；
-r, --recursive：等同于`--directories=recurse`。跟随位于命令行上的符号链接；
-R, --dereference-recursive：类似于`--directories=recurse`，但不跟随符号链接；
    --include=FILE_PATTERN：仅查找匹配到 FILE_PATTERN 的文件；
    --exclude=FILE_PATTERN：跳过匹配到 FILE_PATTERN 的文件和目录；
    --exclude-from=FILE：跳过匹配到 FILE 文件所指定的若干 PATTERN 的文件；
    --exclude-dir=PATTERN：跳过匹配到 PATTERN 的目录；
-L, --files-without-match：仅输出不包含匹配的输入文件名；
-l, --files-with-matches：仅输出包含匹配的输入文件名；
-c, --count： 仅输出匹配的行数。如果也使用了 -v 或 --inverse-match 选项，则显示不匹配的行数；
-T, --initial-tab：确保实际行开头位于制表符的结束的位置，和带前缀的选项（-H，-n，-b，--label）连用时可以用于对齐实际输出行的开头；
-Z, --null：在文件名之后打印一个0值字节（ASCII NUL字符）。比如，`grep -lZ`输出的文件名以 ASCII NUL 字符分隔，而不是一般的换行符。该选项可以用于`find -print0`，`perl -0`，`sort -z`和`xargs -0`等命令一起使用，来处理任意文件名（即使文件名中包含了换行符）；
# 上下文控制（Context control）
-B, --before-context=NUM：连同所有匹配行之前的 NUM 行内容一起打印。将包含组分隔符的行放入匹配的连续组中（组分隔符通过`--group-separato`选项定义）；
-A, --after-context=NUM：连同所有匹配行之后的 NUM 行内容一起打印。将包含组分隔符的行放入匹配的连续组中（组分隔符通过`--group-separato`选项定义）；
-C, --context=NUM：连同所有匹配行前后各 NUM 行内容一起打印。将包含组分隔符的行放入匹配的连续组中（组分隔符通过`--group-separato`选项定义）；
-NUM：同`-C, --context=NUM`，该选项中的`-NUM`中的`NUM`同`-C, --context=NUM`中的`NUM`；
    --group-separator=SEP：使用SEP作为组分隔符；
    --no-group-separator：使用空字符作为组分隔符；
    --color[=WHEN],--colour[=WHEN]：高亮显示匹配的字符串。WHEN 可以是'always'、'never'或'auto'；
-U, --binary：不跳过行尾CR回车符(MSDOS/Windows)
-u, --unix-byte-offsets：输出偏移量时略去CR回车符（MSDOS/Windows)；
#杂项
-s, --no-messages：不显示错误信息（文件不存在或无读取权限）；
-v, --invert-match：反转查找，即查找不匹配的行；
-V, --version：显示版本信息并退出；
    --help：显示帮助文本并退出；
```

##### 参数

PATTERN：用于匹配的正则表达式；

FILE：要查找的文本文件。

#### 实例

1. 在文件中搜索一个单词，命令会返回一个包含"match_pattern"（不加双引号）的文本行。

```shell
grep match_pattern file_name
grep "match_pattern" file_name
```

2. 在多个文件中查找。

```shell
grep "match_pattern" file_1 file_2 file_3 ...
```

3. 使用 -v 选项输出不匹配"match_pattern"的所有行。

```shell
grep -v "match_pattern" file_name
```

3. 使用 `--color=auto `选项高亮显示匹配到内容。

```shell
grep --color "match_pattern" file_name
```

4. 使用正则表达式。

```shell
grep -E "[1-9]+"
或
egrep "[1-9]+"
```

5.  使用 `-o` 选项只输出文件中匹配到的部分。

```shell
grep -o "match_pattern" file_name
```

6. 统计文件或者文本中包含匹配字符串的行数 -c 选项：

```shell
grep -c "text" file_name
```

7. 在多级目录中对文本进行递归搜索：

```shell
# 在当前目录中递归搜索
grep "text" . -r -n
```

8. 忽略匹配样式中的字符大小写：

```shell
echo "hello world" | grep -i "HELLO"
hello
```

9. 使用 `-e` 选项指定多个匹配样式。

```shell
echo this is a text line | grep -e "is" -e "line" -o
is
line
# 也可以使用 -f 选项来通过文件指定匹配多个样式，在样式文件中逐行写出需要匹配的字符
cat patfile
aaa
bbb
echo aaa bbb ccc ddd eee | grep -f patfile -o
```

10. 在搜索结果中包括或者排除指定文件。

```shell
# 只在目录中所有的.php和.html文件中递归搜索字符"main()"
grep "main()" . -r --include *.{php,html}
# 在搜索结果中排除所有 README 文件
grep "main()" . -r --exclude "README"
# 在搜索结果中排除 filelist 文件列表里的文件
grep "main()" . -r --exclude-from filelist
```

11. 使用0值字节作为文件名分隔符。

```shell
#测试文件：
echo "aaa" > file1
echo "bbb" > file2
echo "aaa" > file3
grep "aaa" file* -lZ | xargs -0 rm
#执行后会删除file1和file3，grep输出用-Z选项来指定以0值字节作为终结符文件名（\0），xargs -0 读取输入并用0值字节终结符分隔文件名，然后删除匹配文件，-Z通常和-l结合使用。
```

12. 静默输出：

```shell
grep -q "test" filename
#不会输出任何信息，如果命令运行成功返回0，失败则返回非0值。一般用于条件测试。
```

13. 打印出匹配文本之前或者之后的行：

```shell
# 显示匹配某个结果之后的3行，使用 -A 选项
seq 10 | grep "5" -A 3
5
6
7
8
# 显示匹配某个结果之前的3行，使用 -B 选项
seq 10 | grep "5" -B 3
2
3
4
5
# 显示匹配某个结果的前三行和后三行，使用 -C 选项
seq 10 | grep "5" -C 3
2
3
4
5
6
7
8
# 如果匹配结果有多个，会用“--”作为各匹配结果之间的分隔符
echo -e "a\nb\nc\na\nb\nc" | grep a -A 1
a
b
--
a
b
```
### tar 命令

**tar** 命令可以为 Linux 文件和目录创建档案（archive），也可以从档案中恢复文件和目录。tar 命令最初被用来在磁带上创建档案，现在，用户可以在任何设备上创建档案。利用 tar 命令可以把一大堆的文件和目录全部打包成一个文件，这对于备份文件或将几个文件组合成为一个文件以便于网络传输是非常有用的。

首先要弄清两个概念：打包和压缩。**打包是指将一大堆文件或目录变成一个总的文件；压缩则是将一个大的文件通过一些压缩算法变成一个小文件**。

为什么要区分这两个概念呢？这源于 **Linux 中很多压缩程序只能针对一个文件进行压缩，当你想要压缩一大堆文件时，你得先将这一大堆文件先打成一个包（tar命令），然后再用压缩程序进行压缩（gzip bzip2命令）**。

#### 语法

```shell
tar [OPTION...] [FILE]...
```

##### 选项

```shell
# 主要操作模式：
-A, --catenate, --concatenate：向已存在归档文件中附加新的文件；
-c, --create：创建一个新的归档文件；
-d, --diff, --compare：检查归档文件和文件系统的不同之处；
    --delete：从已有tar归档文件（不是磁带上的）中删除；
-r, --append：追加文件到已有tar归档文件末尾；
-t, --list：列出已有tar归档文件的内容；
    --test-label：测试归档文件卷标（volume label）并退出；
-u, --update：将比tar归档文件中已有的同名文件新的文件追加到该tar归档文件中；
-x, --extract, --get：从已有tar归档文件中提取文件；
# 一般选项：
-C, --directory=DIR：切换到指定名为DIR目录；
-f, --file=ARCHIVE：指定特定归档文件名称为ARCHIVE文件或设备；
-j, --bzip2：将输出重定向给bzip2命令来压缩内容；
-J, --xz：将输出重定向给xz命令来压缩内容；
-z, --gzip, --gunzip, --ungzip：将输出重定向给gzip命令来压缩内容；
-p, --preserve-permissions：还原文件时沿用原来的文件权限（默认超级用户才可以）；
-P, --absolute-names：文件名使用绝对名称，不移除文件名称前的“/”号；
-k：保留原有文件不覆盖；
--exclude=PATTERN：排除符合PATTERN模式的文件；
-N, --newer=DATE-OR-FILE, --after-date=DATE-OR-FILE：只将较指定日期更新的文件保存到备份文件里；
-v, --verbose：在处理文件时显示文件；
```

##### 参数

FILE：归档操作的文件或目录。

#### 实例

1. 使用 -c 选项将现有文件打包成指定名称的归档文件。

```shell
# 在选项 -f 之后的文件档名是自己取的，一般都用 .tar 来作为辨识
tar -cvf log.tar log2018.log log2017.log
# 加上 -z 选项，打包后以 gzip 命令压缩
# 一般以 .tar.gz 或 .tgz 来命名 gzip 压缩过的 tar 包
tar -zcvf log.tar.gz log2018.log log2017.log
# 加上 -j 选项，，打包后以 bzip2 命令压缩
# 一般以 .tar.bz2 来命名 bzip2 压缩过的 tar 包
tar -jcvf log.tar.bz2 log2018.log log2017.log
# 使用 -N 选项只备份目录下比某个日期新的文件
tar -N "2012/11/13" -zcvf log.tar.gz logdir
```

2. 使用 -t 选项列出归档文件中的所有文件。

```shell
tar -tvf log.tar
# 加上 -z 选项查看 gzip 压缩的 .tar.gz 文件内的文件
tar -ztvf log.tar.gz
# 加上 -j 选项查看 bzip2 压缩的 .tar.bz2 文件内的文件
tar -jtvf log.tar.bz2
```
3. 使用 -x 选项解压归档文件中的所有文件。

```shell
tar -xf log.tar
# 加上 -z 选项解压缩 gzip 压缩的 .tar.gz 文件内的文件
tar -zxvf /home/vincent/log.tar.gz
# 加上 -j 选项解压缩 bzip2 压缩的 .tar.bz2 文件内的文件
tar -jxvf /home/vincent/log.tar.bz2
# 只将 tar 内的部分文件解压出来
tar -zxvf /home/vincent/log.tar.gz log2018.log
# 加上 -p 选项将文件权限保存下来
tar -zcvpf log31.tar.gz log2018.log log2017.log
# 使用 --exclude 选项备份文件夹内容是排除部分文件
tar --exclude scf/service -zcvf scf.tar.gz scf/*
```
