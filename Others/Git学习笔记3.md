## **7. 自定义 Git**

### **7.1 配置 Git**

如第一章所言，用`git config`配置 Git，要做的第一件事就是设置名字和邮箱地址：

```shell
$ git config --global user.name "John Doe"
$ git config --global user.email johndoe@example.com
```

从现在开始，你会了解到一些类似以上但更为有趣的设置选项来自定义 Git。

先过一遍第一章中提到的 Git 配置细节。Git 使用一系列的配置文件来存储你定义的偏好，它首先会查找`/etc/gitconfig`文件，该文件含有对系统上所有用户及他们所拥有的仓库都生效的配置值（译注：gitconfig是全局配置文件）， 如果传递`--system`选项给`git config`命令， Git 会读写这个文件。

接下来 Git 会查找每个用户的`~/.gitconfig`文件，你能传递`--global`选项让 Git读写该文件。

最后 Git 会查找由用户定义的各个库中 Git 目录下的配置文件（`.git/config`），该文件中的值只对属主库有效。 以上阐述的三层配置从一般到特殊层层推进，如果定义的值有冲突，以后面层中定义的为准，例如：在`.git/config`和`/etc/gitconfig`的较量中， `.git/config`取得了胜利。虽然你也可以直接手动编辑这些配置文件，但是运行`git config`命令将会来得简单些。

#### **7.1.1 客户端基本配置**

Git 能够识别的配置项被分为了两大类：客户端和服务器端，其中大部分基于你个人工作偏好，属于客户端配置。尽管有数不尽的选项，但我只阐述 其中经常使用或者会对你的工作流产生巨大影响的选项，如果你想观察你当前的 Git 能识别的选项列表，请运行

```shell
$ git config --help
```

`git config`的手册页（译注：以man命令的显示方式）非常细致地罗列了所有可用的配置项。

##### 7.1.1.1 core.editor

Git默认会调用你的环境变量editor定义的值作为文本编辑器，如果没有定义的话，会调用Vi来创建和编辑提交以及标签信息， 你可以使用`core.editor`改变默认编辑器：

```shell
$ git config --global core.editor emacs
```

现在无论你的环境变量editor被定义成什么，Git 都会调用Emacs编辑信息。

##### 7.1.1.2 commit.template

如果把此项指定为你系统上的一个文件，当你提交的时候， Git 会默认使用该文件定义的内容。 例如：你创建了一个模板文件`$HOME/.gitmessage.txt`，它看起来像这样：

```shell
subject line

    what happened

    [ticket: X]
```

设置`commit.template`，当运行`git commit`时， Git 会在你的编辑器中显示以上的内容， 设置`commit.template`如下：

```shell
$ git config --global commit.template 
$ HOME/.gitmessage.txt
$ git commit
```

然后当你提交时，在编辑器中显示的提交信息如下：

```shell
subject line

    what happened

    [ticket: X]
    # Please enter the commit message for your changes. Lines starting
    # with '#' will be ignored, and an empty message aborts the commit.
    # On branch master
    # Changes to be committed:
    # (use "git reset HEAD <file>..." to unstage)
    #
    # modified: lib/test.rb
    #
    ~
    ~
    ".git/COMMIT_EDITMSG" 14L, 297C
```

如果你有特定的策略要运用在提交信息上，在系统上创建一个模板文件，设置 Git 默认使用它，这样当提交时，你的策略每次都会被运用。

##### 7.1.1.3 core.pager

core.pager指定 Git 运行诸如`log`、`diff`等所使用的分页器，你能设置成用`more`或者任何你喜欢的分页器（默认用的是`less`）， 当然你也可以什么都不用，设置空字符串：

```shell
$ git config --global core.pager ''
```

这样不管命令的输出量多少，都会在一页显示所有内容。

##### 7.1.1.4 user.signingkey

如果你要创建经签署的含附注的标签（正如第二章所述），那么把你的GPG签署密钥设置为配置项会更好，设置密钥ID如下：

```shell
$ git config --global user.signingkey <gpg-key-id>
```

现在你能够签署标签，从而不必每次运行`git tag`命令时定义密钥：

```shell
$ git tag -s <tag-name>
```

##### 7.1.1.5 core.excludesfile

正如第二章所述，你能在项目库的`.gitignore`文件里头用模式来定义那些无需纳入 Git 管理的文件，这样它们不会出现在未跟踪列表， 也不会在你运行`git add`后被暂存。然而，如果你想用项目库之外的文件来定义那些需被忽略的文件的话，用`core.excludesfile` 通知 Git 该文件所处的位置，文件内容和`.gitignore`类似。

##### 7.1.1.6 help.autocorrect

该配置项只在 Git 1.6.1及以上版本有效，假如你在Git 1.6中错打了一条命令，会显示：

```shell
$ git com
    git: 'com' is not a git-command. See 'git --help'.

    Did you mean this?
    commit
```

如果你把`help.autocorrect`设置成1（译注：启动自动修正），那么在只有一个命令被模糊匹配到的情况下，Git 会自动运行该命令。

#### **7.1.2 Git中的着色**

Git能够为输出到你终端的内容着色，以便你可以凭直观进行快速、简单地分析，有许多选项能供你使用以符合你的偏好。

##### 7.1.2.1 color.ui

Git会按照你需要自动为大部分的输出加上颜色，你能明确地规定哪些需要着色以及怎样着色，设置`color.ui`为true来打开所有的默认终端着色。

```shell
$ git config --global color.ui true
```

设置好以后，当输出到终端时，Git 会为之加上颜色。其他的参数还有false和always，false意味着不为输出着色，而always则表明在任何情况下都要着色，即使 Git 命令被重定向到文件或管道。Git 1.5.5版本引进了此项配置，如果你拥有的版本更老，你必须对颜色有关选项各自进行详细地设置。

你会很少用到`color.ui = always`，在大多数情况下，如果你想在被重定向的输出中插入颜色码，你能传递`--color`标志给 Git 命令来迫使它这么做，`color.ui = true`应该是你的首选。

##### 7.1.2.2 color.*

想要具体到哪些命令输出需要被着色以及怎样着色或者 Git 的版本很老，你就要用到和具体命令有关的颜色配置选项，它们都能被置为`true`、`false`或`always`：

```shell
color.branch
    color.diff
    color.interactive
    color.status
```

除此之外，以上每个选项都有子选项，可以被用来覆盖其父设置，以达到为输出的各个部分着色的目的。例如，让diff输出的改变信息以粗体、蓝色前景和黑色背景的形式显示：

```shell
$ git config --global color.diff.meta “blue black bold”
```

你能设置的颜色值如：normal、black、red、green、yellow、blue、magenta、cyan、white，正如以上例子设置的粗体属性，想要设置字体属性的话，可以选择如：bold、dim、ul、blink、reverse。

如果你想配置子选项的话，可以参考`git config`帮助页。

#### **7.1.3 外部的合并与比较工具**

虽然 Git 自己实现了diff,而且到目前为止你一直在使用它，但你能够用一个外部的工具替代它，除此以外，你还能用一个图形化的工具来合并和解决冲突从而不必自己手动解决。有一个不错且免费的工具可以被用来做比较和合并工作，它就是P4Merge（译注：Perforce图形化合并工具），我会展示它的安装过程。

P4Merge可以在所有主流平台上运行，现在开始大胆尝试吧。对于向你展示的例子，在Mac和Linux系统上，我会使用路径名，在Windows上，`/usr/local/bin`应该被改为你环境中的可执行路径。

下载P4Merge：

```shell
http://www.perforce.com/perforce/downloads/component.html
```

首先把你要运行的命令放入外部包装脚本中，我会使用Mac系统上的路径来指定该脚本的位置，在其他系统上，它应该被放置在二进制文件`p4merge`所在的目录中。创建一个merge包装脚本，名字叫作`extMerge`，让它带参数调用`p4merge`二进制文件：

```shell
$ cat /usr/local/bin/extMerge
    #!/bin/sh
    /Applications/p4merge.app/Contents/MacOS/p4merge $*
```

diff包装脚本首先确定传递过来7个参数，随后把其中2个传递给merge包装脚本，默认情况下， Git 传递以下参数给diff：

```shell
path old-file old-hex old-mode new-file new-hex new-mode
```

由于你仅仅需要`old-file`和`new-file`参数，用diff包装脚本来传递它们吧。

```shell
$ cat /usr/local/bin/extDiff
    #!/bin/sh
    [ $# -eq 7 ] && /usr/local/bin/extMerge "$2" "$5"
```

确认这两个脚本是可执行的：

```shell
$ sudo chmod +x /usr/local/bin/extMerge
    $ sudo chmod +x /usr/local/bin/extDiff
```

现在来配置使用你自定义的比较和合并工具吧。这需要许多自定义设置：`merge.tool`通知 Git 使用哪个合并工具；`mergetool.*.cmd`规定命令运行的方式；`mergetool.trustExitCode`会通知 Git 程序的退出是否指示合并操作成功；`diff.external`通知 Git 用什么命令做比较。因此，你能运行以下4条配置命令：

```shell
$ git config --global merge.tool extMerge
    $ git config --global mergetool.extMerge.cmd \
    'extMerge "$BASE" "$LOCAL" "$REMOTE" "$MERGED"'
    $ git config --global mergetool.trustExitCode false
    $ git config --global diff.external extDiff
```

或者直接编辑`~/.gitconfig`文件如下：

```shell
[merge]
    tool = extMerge
    [mergetool "extMerge"]
    cmd = extMerge \"$BASE\" \"$LOCAL\" \"$REMOTE\" \"$MERGED\"
    trustExitCode = false
    [diff]
    external = extDiff
```

设置完毕后，运行diff命令：

```shell
$ git diff 32d1776b1^ 32d1776b1
```

命令行居然没有发现diff命令的输出，其实，Git 调用了刚刚设置的P4Merge，它看起来像下图所示：

![tools1](.\appendix\tools1.png)

当你设法合并两个分支，结果却有冲突时，运行`git mergetool`，Git 会调用P4Merge让你通过图形界面来解决冲突。

设置包装脚本的好处是你能简单地改变diff和merge工具，例如把`extDiff`和`extMerge`改成KDiff3，要做的仅仅是编辑`extMerge`脚本文件：

```shell
$ cat /usr/local/bin/extMerge
    #!/bin/sh
    /Applications/kdiff3.app/Contents/MacOS/kdiff3 $*
```

现在 Git 会使用KDiff3来做比较、合并和解决冲突。

Git预先设置了许多其他的合并和解决冲突的工具，而你不必设置cmd。可以把合并工具设置为：kdiff3、opendiff、tkdiff、meld、xxdiff、emerge、vimdiff、gvimdiff。如果你不想用到KDiff3的所有功能，只是想用它来合并，那么kdiff3正符合你的要求，运行：

```shell
$ git config --global merge.tool kdiff3
```

如果运行了以上命令，没有设置`extMerge`和`extDiff`文件，Git 会用KDiff3做合并，让通常内设的比较工具来做比较。

#### **7.1.4 格式化与空白**

格式化与空白是许多开发人员在协作时，特别是在跨平台情况下，遇到的令人头疼的细小问题。由于编辑器的不同或者Windows程序员在跨平台项目中的文件行尾加入了回车换行符，一些细微的空格变化会不经意地进入大家合作的工作或提交的补丁中。不用怕，Git 的一些配置选项会帮助你解决这些问题。

##### 7.1.4.1 core.autocrlf

假如你正在Windows上写程序，又或者你正在和其他人合作，他们在Windows上编程，而你却在其他系统上，在这些情况下，你可能会遇到行尾结束符问题。这是因为Windows使用回车和换行两个字符来结束一行，而Mac和Linux只使用换行一个字符。虽然这是小问题，但它会极大地扰乱跨平台协作。

Git可以在你提交时自动地把行结束符CRLF转换成LF，而在签出代码时把LF转换成CRLF。用`core.autocrlf`来打开此项功能，如果是在Windows系统上，把它设置成`true`，这样当签出代码时，LF会被转换成CRLF：

```shell
$ git config --global core.autocrlf true
```

Linux或Mac系统使用LF作为行结束符，因此你不想 Git 在签出文件时进行自动的转换；当一个以CRLF为行结束符的文件不小心被引入时你肯定想进行修正，把`core.autocrlf`设置成input来告诉 Git 在提交时把CRLF转换成LF，签出时不转换：

```shell
$ git config --global core.autocrlf input
```

这样会在Windows系统上的签出文件中保留CRLF，会在Mac和Linux系统上，包括仓库中保留LF。

如果你是Windows程序员，且正在开发仅运行在Windows上的项目，可以设置`false`取消此功能，把回车符记录在库中：

```shell
$ git config --global core.autocrlf false
```

##### 7.1.4.2 core.whitespace

Git预先设置了一些选项来探测和修正空白问题，其4种主要选项中的2个默认被打开，另2个被关闭，你可以自由地打开或关闭它们。

默认被打开的2个选项是`trailing-space`和`space-before-tab`，`trailing-space`会查找每行结尾的空格，`space-before-tab`会查找每行开头的制表符前的空格。

默认被关闭的2个选项是`indent-with-non-tab`和`cr-at-eol`，`indent-with-non-tab`会查找8个以上空格（非制表符）开头的行，`cr-at-eol`让 Git 知道行尾回车符是合法的。

设置`core.whitespace`，按照你的意图来打开或关闭选项，选项以逗号分割。通过逗号分割的链中去掉选项或在选项前加`-`来关闭，例如，如果你想要打开除了`cr-at-eol`之外的所有选项：

```shell
$ git config --global core.whitespace \
    trailing-space,space-before-tab,indent-with-non-tab
```

当你运行`git diff`命令且为输出着色时，Git 探测到这些问题，因此你也许在提交前能修复它们，当你用`git apply`打补丁时同样也会从中受益。如果正准备运用的补丁有特别的空白问题，你可以让 Git 发警告：

```shell
$ git apply --whitespace=warn <patch>
```

或者让 Git 在打上补丁前自动修正此问题：

```shell
$ git apply --whitespace=fix <patch>
```

这些选项也能运用于衍合。如果提交了有空白问题的文件但还没推送到上流，你可以运行带有`--whitespace=fix`选项的`rebase`来让Git在重写补丁时自动修正它们。

#### **7.1.5 服务器端配置**

Git服务器端的配置选项并不多，但仍有一些饶有生趣的选项值得你一看。

##### 7.1.5.1 receive.fsckObjects

Git默认情况下不会在推送期间检查所有对象的一致性。虽然会确认每个对象的有效性以及是否仍然匹配SHA-1检验和，但 Git 不会在每次推送时都检查一致性。对于 Git 来说，库或推送的文件越大，这个操作代价就相对越高，每次推送会消耗更多时间，如果想在每次推送时 Git 都检查一致性，设置 `receive.fsckObjects` 为true来强迫它这么做：

```shell
$ git config --system receive.fsckObjects true
```

现在 Git 会在每次推送生效前检查库的完整性，确保有问题的客户端没有引入破坏性的数据。

##### 7.1.5.2 receive.denyNonFastForwards

如果对已经被推送的提交历史做衍合，继而再推送，又或者以其它方式推送一个提交历史至远程分支，且该提交历史没在这个远程分支中，这样的推送会被拒绝。这通常是个很好的禁止策略，但有时你在做衍合并确定要更新远程分支，可以在push命令后加`-f`标志来强制更新。

要禁用这样的强制更新功能，可以设置`receive.denyNonFastForwards`：

```shell
$ git config --system receive.denyNonFastForwards true
```

稍后你会看到，用服务器端的接收钩子也能达到同样的目的。这个方法可以做更细致的控制，例如：禁用特定的用户做强制更新。

##### 7.1.5.3 receive.denyDeletes

规避`denyNonFastForwards`策略的方法之一就是用户删除分支，然后推回新的引用。在更新的 Git 版本中（从1.6.1版本开始），把`receive.denyDeletes`设置为true：

```shell
$ git config --system receive.denyDeletes true
```

这样会在推送过程中阻止删除分支和标签 — 没有用户能够这么做。要删除远程分支，必须从服务器手动删除引用文件。通过用户访问控制列表也能这么做，在本章结尾将会介绍这些有趣的方式。

### **7.2 Git属性**

一些设置项也能被运用于特定的路径中，这样，Git 以对一个特定的子目录或子文件集运用那些设置项。这些设置项被称为 Git 属性，可以在你目录中的`.gitattributes`文件内进行设置（通常是你项目的根目录），也可以当你不想让这些属性文件和项目文件一同提交时，在`.git/info/attributes`进行设置。

使用属性，你可以对个别文件或目录定义不同的合并策略，让 Git 知道怎样比较非文本文件，在你提交或签出前让 Git 过滤内容。你将在这部分了解到能在自己的项目中使用的属性，以及一些实例。

#### **7.2.1 二进制文件**

你可以用 Git 属性让其知道哪些是二进制文件（以防 Git 没有识别出来），以及指示怎样处理这些文件，这点很酷。例如，一些文本文件是由机器产生的，而且无法比较，而一些二进制文件可以比较 — 你将会了解到怎样让 Git 识别这些文件。

##### **7.2.1.1 识别二进制文件**

一些文件看起来像是文本文件，但其实是作为二进制数据被对待。例如，在Mac上的Xcode项目含有一个以`.pbxproj`结尾的文件，它是由记录设置项的IDE写到磁盘的JSON数据集（纯文本javascript数据类型）。虽然技术上看它是由ASCII字符组成的文本文件，但你并不认为如此，因为它确实是一个轻量级数据库 — 如果有2人改变了它，你通常无法合并和比较内容，只有机器才能进行识别和操作，于是，你想把它当成二进制文件。

让 Git 把所有`pbxproj`文件当成二进制文件，在`.gitattributes`文件中设置如下：

```shell
*.pbxproj -crlf -diff
```

现在，Git 会尝试转换和修正CRLF（回车换行）问题，也不会当你在项目中运行git show或git diff时，比较不同的内容。在Git 1.6及之后的版本中，可以用一个宏代替`-crlf -diff`：

```shell
*.pbxproj binary
```

##### **7.2.1.2 比较二进制文件**

在Git 1.6及以上版本中，你能利用 Git 属性来有效地比较二进制文件。可以设置 Git 把二进制数据转换成文本格式，用通常的diff来比较。

这个特性很酷，而且鲜为人知，因此我会结合实例来讲解。首先，要解决的是最令人头疼的问题：对Word文档进行版本控制。很多人对Word文档又恨又爱，如果想对其进行版本控制，你可以把文件加入到 Git 库中，每次修改后提交即可。但这样做没有一点实际意义，因为运行`git diff`命令后，你只能得到如下的结果：

```shell
$ git diff
    diff --git a/chapter1.doc b/chapter1.doc
    index 88839c4..4afcb7c 100644
    Binary files a/chapter1.doc and b/chapter1.doc differ
```

你不能直接比较两个不同版本的Word文件，除非进行手动扫描，不是吗？ Git 属性能很好地解决此问题，把下面的行加到`.gitattributes`文件：

```shell
*.doc diff=word
```

当你要看比较结果时，如果文件扩展名是"doc"，Git 调用"word"过滤器。什么是"word"过滤器呢？其实就是 Git 使用`strings` 程序，把Word文档转换成可读的文本文件，之后再进行比较：

```shell
$ git config diff.word.textconv strings
```

现在如果在两个快照之间比较以`.doc`结尾的文件，Git 对这些文件运用"word"过滤器，在比较前把Word文件转换成文本文件。

下面展示了一个实例，我把此书的第一章纳入 Git 管理，在一个段落中加入了一些文本后保存，之后运行`git diff`命令，得到结果如下：

```shell
$ git diff
    diff --git a/chapter1.doc b/chapter1.doc
    index c1c8a0a..b93c9e4 100644
    --- a/chapter1.doc
    +++ b/chapter1.doc
    @@ -8,7 +8,8 @@ re going to cover Version Control Systems (VCS) and Git basics
    re going to cover how to get it and set it up for the first time if you don
    t already have it on your system.
    In Chapter Two we will go over basic Git usage - how to use Git for the 80%
    -s going on, modify stuff and contribute changes. If the book spontaneously
    +s going on, modify stuff and contribute changes. If the book spontaneously
    +Let's see if this works.
```

Git 成功且简洁地显示出我增加的文本"Let’s see if this works"。虽然有些瑕疵，在末尾显示了一些随机的内容，但确实可以比较了。如果你能找到或自己写个Word到纯文本的转换器的话，效果可能会更好。 `strings`可以在大部分Mac和Linux系统上运行，所以它是处理二进制格式的第一选择。

你还能用这个方法比较图像文件。当比较时，对JPEG文件运用一个过滤器，它能提炼出EXIF信息 — 大部分图像格式使用的元数据。如果你下载并安装了`exiftool`程序，可以用它参照元数据把图像转换成文本。比较的不同结果将会用文本向你展示：

```shell
$ echo '*.png diff=exif' >> .gitattributes
$ git config diff.exif.textconv exiftool
```

如果在项目中替换了一个图像文件，运行`git diff`命令的结果如下：

```shell
diff --git a/image.png b/image.png
    index 88839c4..4afcb7c 100644
    --- a/image.png
    +++ b/image.png
    @@ -1,12 +1,12 @@
    ExifTool Version Number : 7.74
    -File Size : 70 kB
    -File Modification Date/Time : 2009:04:21 07:02:45-07:00
    +File Size : 94 kB
    +File Modification Date/Time : 2009:04:21 07:02:43-07:00
    File Type : PNG
    MIME Type : image/png
    -Image Width : 1058
    -Image Height : 889
    +Image Width : 1056
    +Image Height : 827
    Bit Depth : 8
    Color Type : RGB with Alpha
```

你会发现文件的尺寸大小发生了改变。

#### **7.2.2 关键字扩展**

使用SVN或CVS的开发人员经常要求关键字扩展。在 Git 中，你无法在一个文件被提交后修改它，因为 Git 会先对该文件计算校验和。然而，你可以在签出时注入文本，在提交前删除它。 Git 属性提供了2种方式这么做。

首先，你能够把blob的SHA-1校验和自动注入文件的`$Id$`字段。如果在一个或多个文件上设置了此字段，当下次你签出分支的时候，Git 用blob的SHA-1值替换那个字段。注意，这不是提交对象的SHA校验和，而是blob本身的校验和：

```shell
$ echo '*.txt ident' >> .gitattributes
    $ echo '$Id$' > test.txt
```

下次签出文件时，Git 入了blob的SHA值：

```shell
$ rm text.txt
    $ git checkout -- text.txt
    $ cat test.txt
    $Id: 42812b7653c7b88933f8a9d6cad0ca16714b9bb3 $
```

然而，这样的显示结果没有多大的实际意义。这个SHA的值相当地随机，无法区分日期的前后，所以，如果你在CVS或Subversion中用过关键字替换，一定会包含一个日期值。

因此，你能写自己的过滤器，在提交文件到暂存区或签出文件时替换关键字。有2种过滤器，"clean"和"smudge"。在 `.gitattributes`文件中，你能对特定的路径设置一个过滤器，然后设置处理文件的脚本，这些脚本会在文件签出前（"smudge"，见下图）

![tools2](.\appendix\tools2.png)

和提交到暂存区前（"clean"，见下图）被调用。这些过滤器能够做各种有趣的事。

![tools3](.\appendix\tools3.png)

这里举一个简单的例子：在暂存前，用`indent`（缩进）程序过滤所有C源代码。在`.gitattributes`文件中设置"indent"过滤器过滤`*.c`文件：

```shell
*.c filter=indent
```

然后，通过以下配置，让 Git 知道"indent"过滤器在遇到"smudge"和"clean"时分别该做什么：

```shell
$ git config --global filter.indent.clean indent
$ git config --global filter.indent.smudge cat
```

于是，当你暂存`*.c`文件时，`indent`程序会被触发，在把它们签出之前，`cat`程序会被触发。但`cat`程序在这里没什么实际作用。这样的组合，使C源代码在暂存前被`indent`程序过滤，非常有效。

另一个例子是类似RCS的`$Date$`关键字扩展。为了演示，需要一个小脚本，接受文件名参数，得到项目的最新提交日期，最后把日期写入该文件。下面用Ruby脚本来实现：

```shell
#! /usr/bin/env ruby
    data = STDIN.read
    last_date = `git log --pretty=format:"%ad" -1`
    puts data.gsub('$Date$', '$Date: ' + last_date.to_s + '$')
```

该脚本从`git log`命令中得到最新提交日期，找到文件中的所有`$Date$`字符串，最后把该日期填充到`$Date$`字符串中 — 此脚本很简单，你可以选择你喜欢的编程语言来实现。把该脚本命名为`expand_date`，放到正确的路径中，之后需要在 Git 中设置一个过滤器（`dater`），让它在签出文件时调用`expand_date`，在暂存文件时用Perl清除之：

```shell
$ git config filter.dater.smudge expand_date
$ git config filter.dater.clean 'perl -pe "s/\\\$Date[^\\\$]*\\\$/\\\$Date\\\$/"'
```

这个Perl小程序会删除`$Date$`字符串里多余的字符，恢复`$Date$`原貌。到目前为止，你的过滤器已经设置完毕，可以开始测试了。打开一个文件，在文件中输入`$Date$`关键字，然后设置 Git 属性：

```shell
$ echo '# $Date$' > date_test.txt
$ echo 'date*.txt filter=dater' >> .gitattributes
```

如果暂存该文件，之后再签出，你会发现关键字被替换了：

```shell
$ git add date_test.txt .gitattributes
$ git commit -m "Testing date expansion in Git"
$ rm date_test.txt
$ git checkout date_test.txt
$ cat date_test.txt
# $Date: Tue Apr 21 07:26:52 2009 -0700$
```

虽说这项技术对自定义应用来说很有用，但还是要小心，因为`.gitattributes`文件会随着项目一起提交，而过滤器（例如：`dater`）不会，所以，过滤器不会在所有地方都生效。当你在设计这些过滤器时要注意，即使它们无法正常工作，也要让整个项目运作下去。

#### **7.2.3 导出仓库**

Git属性在导出项目归档时也能发挥作用。

##### 7.2.3.1 export-ignore

当产生一个归档时，可以设置 Git 不导出某些文件和目录。如果你不想在归档中包含一个子目录或文件，但想他们纳入项目的版本管理中，你能对应地设置`export-ignore`属性。

例如，在`test/`子目录中有一些测试文件，在项目的压缩包中包含他们是没有意义的。因此，可以增加下面这行到 Git 属性文件中：

```shell
test/ export-ignore
```

现在，当运行git archive来创建项目的压缩包时，那个目录不会在归档中出现。

##### 7.2.3.2 export-subst

还能对归档做一些简单的关键字替换。在第2章中已经可以看到，可以以`--pretty=format`形式的简码在任何文件中放入`$Format:$` 字符串。例如，如果想在项目中包含一个叫作`LAST_COMMIT`的文件，当运行`git archive`时，最后提交日期自动地注入进该文件，可以这样设置：

```shell
$ echo 'Last commit date: $Format:%cd$' > LAST_COMMIT
$ echo "LAST_COMMIT export-subst" >> .gitattributes
$ git add LAST_COMMIT .gitattributes
$ git commit -am 'adding LAST_COMMIT file for archives'
```

运行`git archive`后，打开该文件，会发现其内容如下：

```shell
$ cat LAST_COMMIT
Last commit date: $Format:Tue Apr 21 08:38:48 2009 -0700$
```

#### **7.2.4 合并策略**

通过 Git 属性，还能对项目中的特定文件使用不同的合并策略。一个非常有用的选项就是，当一些特定文件发生冲突，Git 会尝试合并他们，而使用你这边的合并。

如果项目的一个分支有歧义或比较特别，但你想从该分支合并，而且需要忽略其中某些文件，这样的合并策略是有用的。例如，你有一个数据库设置文件database.xml，在2个分支中他们是不同的，你想合并一个分支到另一个，而不弄乱该数据库文件，可以设置属性如下：

```shell
database.xml merge=ours
```

如果合并到另一个分支，database.xml文件不会有合并冲突，显示如下：

```shell
$ git merge topic
Auto-merging database.xml
Merge made by recursive.
```

这样，database.xml会保持原样。

### **7.3 Git挂钩**

和其他版本控制系统一样，当某些重要事件发生时，Git 以调用自定义脚本。有两组挂钩：客户端和服务器端。客户端挂钩用于客户端的操作，如提交和合并。服务器端挂钩用于 Git 服务器端的操作，如接收被推送的提交。你可以随意地使用这些挂钩，下面会讲解其中一些。

#### **7.3.1 安装一个挂钩**

挂钩都被存储在 Git 目录下的`hooks`子目录中，即大部分项目中的`.git/hooks`。 Git 默认会放置一些脚本样本在这个目录中，除了可以作为挂钩使用，这些样本本身是可以独立使用的。所有的样本都是shell脚本，其中一些还包含了Perl的脚本，不过，任何正确命名的可执行脚本都可以正常使用 — 可以用Ruby或Python，或其他。在Git 1.6版本之后，这些样本名都是以.sample结尾，因此，你必须重新命名。在Git 1.6版本之前，这些样本名都是正确的，但这些样本不是可执行文件。

把一个正确命名且可执行的文件放入 Git 目录下的`hooks`子目录中，可以激活该挂钩脚本，因此，之后他一直会被 Git 调用。随后会讲解主要的挂钩脚本。

#### **7.3.2 客户端挂钩**

有许多客户端挂钩，以下把他们分为：提交工作流挂钩、电子邮件工作流挂钩及其他客户端挂钩。

##### **7.3.2.1 提交工作流挂钩**

有 4个挂钩被用来处理提交的过程。`pre-commit`挂钩在键入提交信息前运行，被用来检查即将提交的快照，例如，检查是否有东西被遗漏，确认测试是否运行，以及检查代码。当从该挂钩返回非零值时，Git 放弃此次提交，但可以用`git commit --no-verify`来忽略。该挂钩可以被用来检查代码错误（运行类似lint的程序），检查尾部空白（默认挂钩是这么做的），检查新方法（译注：程序的函数）的说明。

`prepare-commit-msg`挂钩在提交信息编辑器显示之前，默认信息被创建之后运行。因此，可以有机会在提交作者看到默认信息前进行编辑。该挂钩接收一些选项：拥有提交信息的文件路径，提交类型，如果是一次修订的话，提交的SHA-1校验和。该挂钩对通常的提交来说不是很有用，只在自动产生的默认提交信息的情况下有作用，如提交信息模板、合并、压缩和修订提交等。可以和提交模板配合使用，以编程的方式插入信息。

`commit-msg`挂钩接收一个参数，此参数是包含最近提交信息的临时文件的路径。如果该挂钩脚本以非零退出，Git 放弃提交，因此，可以用来在提交通过前验证项目状态或提交信息。本章上一小节已经展示了使用该挂钩核对提交信息是否符合特定的模式。

`post-commit`挂钩在整个提交过程完成后运行，他不会接收任何参数，但可以运行`git log -1 HEAD`来获得最后的提交信息。总之，该挂钩是作为通知之类使用的。

提交工作流的客户端挂钩脚本可以在任何工作流中使用，他们经常被用来实施某些策略，但值得注意的是，这些脚本在clone期间不会被传送。可以在服务器端实施策略来拒绝不符合某些策略的推送，但这完全取决于开发者在客户端使用这些脚本的情况。所以，这些脚本对开发者是有用的，由他们自己设置和维护，而且在任何时候都可以覆盖或修改这些脚本。

##### **7.3.2.2 E-mail工作流挂钩**

有3个可用的客户端挂钩用于e-mail工作流。当运行`git am`命令时，会调用他们，因此，如果你没有在工作流中用到此命令，可以跳过本节。如果你通过e-mail接收由`git format-patch`产生的补丁，这些挂钩也许对你有用。

首先运行的是`applypatch-msg`挂钩，他接收一个参数：包含被建议提交信息的临时文件名。如果该脚本非零退出，Git 放弃此补丁。可以使用这个脚本确认提交信息是否被正确格式化，或让脚本编辑信息以达到标准化。

下一个在`git am`运行期间调用是`pre-applypatch`挂钩。该挂钩不接收参数，在补丁被运用之后运行，因此，可以被用来在提交前检查快照。你能用此脚本运行测试，检查工作树。如果有些什么遗漏，或测试没通过，脚本会以非零退出，放弃此次`git am`的运行，补丁不会被提交。

最后在`git am`运行期间调用的是`post-applypatch`挂钩。你可以用他来通知一个小组或获取的补丁的作者，但无法阻止打补丁的过程。

##### **7.3.2.3 其他客户端挂钩**

`pre-rebase`挂钩在衍合前运行，脚本以非零退出可以中止衍合的过程。你可以使用这个挂钩来禁止衍合已经推送的提交对象，Git `pre-rebase`挂钩样本就是这么做的。该样本假定next是你定义的分支名，因此，你可能要修改样本，把next改成你定义过且稳定的分支名。

在`git checkout`成功运行后，`post-checkout`挂钩会被调用。他可以用来为你的项目环境设置合适的工作目录。例如：放入大的二进制文件、自动产生的文档或其他一切你不想纳入版本控制的文件。

最后，在`merge`命令成功执行后，`post-merge`挂钩会被调用。他可以用来在 Git 无法跟踪的工作树中恢复数据，诸如权限数据。该挂钩同样能够验证在 Git 控制之外的文件是否存在，因此，当工作树改变时，你想这些文件可以被复制。

#### **7.3.3 服务器端挂钩**

除了客户端挂钩，作为系统管理员，你还可以使用两个服务器端的挂钩对项目实施各种类型的策略。这些挂钩脚本可以在提交对象推送到服务器前被调用，也可以在推送到服务器后被调用。推送到服务器前调用的挂钩可以在任何时候以非零退出，拒绝推送，返回错误消息给客户端，还可以如你所愿设置足够复杂的推送策略。

##### 7.3.3.1 pre-receive 和 post-receive

处理来自客户端的推送（push）操作时最先执行的脚本就是 `pre-receive` 。它从标准输入（stdin）获取被推送引用的列表；如果它退出时的返回值不是0，所有推送内容都不会被接受。利用此挂钩脚本可以实现类似保证最新的索引中不包含非fast-forward类型的这类效果；抑或检查执行推送操作的用户拥有创建，删除或者推送的权限或者他是否对将要修改的每一个文件都有访问权限。

`post-receive` 挂钩在整个过程完结以后运行，可以用来更新其他系统服务或者通知用户。它接受与 `pre-receive` 相同的标准输入数据。应用实例包括给某邮件列表发信，通知实时整合数据的服务器，或者更新软件项目的问题追踪系统 —— 甚至可以通过分析提交信息来决定某个问题是否应该被开启，修改或者关闭。该脚本无法组织推送进程，不过客户端在它完成运行之前将保持连接状态；所以在用它作一些消耗时间的操作之前请三思。

##### 7.3.3.2 update

update 脚本和 `pre-receive` 脚本十分类似。不同之处在于它会为推送者更新的每一个分支运行一次。假如推送者同时向多个分支推送内容，`pre-receive` 只运行一次，相比之下 update 则会为每一个更新的分支运行一次。它不会从标准输入读取内容，而是接受三个参数：索引的名字（分支），推送前索引指向的内容的 SHA-1 值，以及用户试图推送内容的 SHA-1 值。如果 update 脚本以退出时返回非零值，只有相应的那一个索引会被拒绝；其余的依然会得到更新。

### **7.4 Git 强制策略实例**

在本节中，我们应用前面学到的知识建立这样一个Git 工作流程：检查提交信息的格式，只接受纯fast-forward内容的推送，并且指定用户只能修改项目中的特定子目录。我们将写一个客户端角本来提示开发人员他们推送的内容是否会被拒绝，以及一个服务端脚本来实际执行这些策略。

这些脚本使用 Ruby 写成，一半由于它是作者倾向的脚本语言，另外作者觉得它是最接近伪代码的脚本语言；因而即便你不使用 Ruby 也能大致看懂。不过任何其他语言也一样适用。所有 Git 自带的样例脚本都是用 Perl 或 Bash 写的。所以从这些脚本中能找到相当多的这两种语言的挂钩样例。

#### **7.4.1 服务端挂钩**

所有服务端的工作都在hooks（挂钩）目录的 update（更新）脚本中制定。update 脚本为每一个得到推送的分支运行一次；它接受推送目标的索引，该分支原来指向的位置，以及被推送的新内容。如果推送是通过 SSH 进行的，还可以获取发出此次操作的用户。如果设定所有操作都通过公匙授权的单一帐号（比如＂git＂）进行，就有必要通过一个 shell 包装依据公匙来判断用户的身份，并且设定环境变量来表示该用户的身份。下面假设尝试连接的用户储存在 `$USER` 环境变量里，我们的 update 脚本首先搜集一切需要的信息：

```shell
#!/usr/bin/env ruby
$refname = ARGV[0]
$oldrev = ARGV[1]
$newrev = ARGV[2]
$user = ENV['USER']
puts "Enforcing Policies... \n(#{$refname}) (#{$oldrev[0,6]}) (#{$newrev[0,6]})"
```

没错，我在用全局变量。别鄙视我——这样比较利于演示过程。

##### **7.4.1.1 指定特殊的提交信息格式**

我们的第一项任务是指定每一条提交信息都必须遵循某种特殊的格式。作为演示，假定每一条信息必须包含一条形似 "ref: 1234" 这样的字符串，因为我们需要把每一次提交和项目的问题追踪系统。我们要逐一检查每一条推送上来的提交内容，看看提交信息是否包含这么一个字符串，然后，如果该提交里不包含这个字符串，以非零返回值退出从而拒绝此次推送。

把 `$newrev` 和 `$oldrev` 变量的值传给一个叫做 `git rev-list` 的 Git plumbing 命令可以获取所有提交内容的 SHA-1 值列表。`git rev-list` 基本类似 `git log` 命令，但它默认只输出 SHA-1 值而已，没有其他信息。所以要获取由 SHA 值表示的从一次提交到另一次提交之间的所有 SHA 值，可以运行：

```shell
$ git rev-list 538c33..d14fc7
    d14fc7c847ab946ec39590d87783c69b031bdfb7
    9f585da4401b0a3999e84113824d15245c13f0be
    234071a1be950e2a8d078e6141f5cd20c1e61ad3
    dfa04c9ef3d5197182f13fb5b9b1fb7717d2222a
    17716ec0f1ff5c77eff40b7fe912f9f6cfd0e475
```

截取这些输出内容，循环遍历其中每一个 SHA 值，找出与之对应的提交信息，然后用正则表达式来测试该信息包含的格式话的内容。

下面要搞定如何从所有的提交内容中提取出提交信息。使用另一个叫做 `git cat-file` 的 Git plumbing 工具可以获得原始的提交数据。我们将在第九章了解到这些 plumbing 工具的细节；现在暂时先看一下这条命令的输出：

```shell
$ git cat-file commit ca82a6
    tree cfda3bf379e4f8dba8717dee55aab78aef7f4daf
    parent 085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7
    author Scott Chacon <schacon@gmail.com> 1205815931 -0700
    committer Scott Chacon <schacon@gmail.com> 1240030591 -0700

    changed the version number
```

通过 SHA-1 值获得提交内容中的提交信息的一个简单办法是找到提交的第一行，然后取从它往后的所有内容。可以使用 Unix 系统的 `sed` 命令来实现该效果：

```shell
$ git cat-file commit ca82a6 | sed '1,/^$/d'
    changed the version number
```

这条咒语从每一个待提交内容里提取提交信息，并且会在提取信息不符合要求的情况下退出。为了退出脚本和拒绝此次推送，返回一个非零值。整个脚本大致如下：

```shell
$regex = /\[ref: (\d+)\]/

    # 指定提交信息格式
    def check_message_format
    missed_revs = `git rev-list #{$oldrev}..#{$newrev}`.split("\n")
    missed_revs.each do |rev|
    message = `git cat-file commit #{rev} | sed '1,/^$/d'`
    if !$regex.match(message)
    puts "[POLICY] Your message is not formatted correctly"
    exit 1
    end
    end
    end
    check_message_format
```

把这一段放在 `update` 脚本里，所有包含不符合指定规则的提交都会遭到拒绝。

##### **7.4.1.2 实现基于用户的访问权限控制列表（ACL）系统**

假设你需要添加一个使用访问权限控制列表的机制来指定哪些用户对项目的哪些部分有推送权限。某些用户具有全部的访问权，其他人只对某些子目录或者特定的文件具有推送权限。要搞定这一点，所有的规则将被写入一个位于服务器的原始 Git 仓库的 `acl` 文件。我们让 `update` 挂钩检阅这些规则，审视推送的提交内容中需要修改的所有文件，然后决定执行推送的用户是否对所有这些文件都有权限。

我们首先要创建这个列表。这里使用的格式和 CVS 的 ACL 机制十分类似：它由若干行构成，第一项内容是 `avail` 或者 `unavail`，接着是逗号分隔的规则生效用户列表，最后一项是规则生效的目录（空白表示开放访问）。这些项目由 `|` 字符隔开。

下例中，我们指定几个管理员，几个对 `doc` 目录具有权限的文档作者，以及一个对 `lib` 和 `tests` 目录具有权限的开发人员，相应的 ACL 文件如下：

```shell
avail|nickh,pjhyett,defunkt,tpw
    avail|usinclair,cdickens,ebronte|doc
    avail|schacon|lib
    avail|schacon|tests
```

首先把这些数据读入你编写的数据结构。本例中，为保持简洁，我们暂时只实现 `avail` 的规则（译注：也就是省略了 `unavail` 部分）。下面这个方法生成一个关联数组，它的主键是用户名，值是一个该用户有写权限的所有目录组成的数组：

```shell
def get_acl_access_data(acl_file)
    # read in ACL data
    acl_file = File.read(acl_file).split("\n").reject { |line| line == '' }
    access = {}
    acl_file.each do |line|
    avail, users, path = line.split('|')
    next unless avail == 'avail'
    users.split(',').each do |user|
    access[user] ||= []
    access[user] << path
    end
    end
    access
    end
```

针对之前给出的 ACL 规则文件，这个 `get_acl_access_data` 方法返回的数据结构如下：

```shell
{"defunkt"=>[nil],
    "tpw"=>[nil],
    "nickh"=>[nil],
    "pjhyett"=>[nil],
    "schacon"=>["lib", "tests"],
    "cdickens"=>["doc"],
    "usinclair"=>["doc"],
    "ebronte"=>["doc"]}
```

搞定了用户权限的数据，下面需要找出哪些位置将要被提交的内容修改，从而确保试图推送的用户对这些位置有全部的权限。

使用 `git log` 的 `--name-only` 选项（在第二章里简单的提过）我们可以轻而易举的找出一次提交里修改的文件：

```shell
$ git log -1 --name-only --pretty=format:'' 9f585d

    README
    lib/test.rb
```

使用 `get_acl_access_data` 返回的 ACL 结构来一一核对每一次提交修改的文件列表，就能找出该用户是否有权限推送所有的提交内容:

```shell
# 仅允许特定用户修改项目中的特定子目录
    def check_directory_perms
    access = get_acl_access_data('acl')

    # 检查是否有人在向他没有权限的地方推送内容
    new_commits = `git rev-list #{$oldrev}..#{$newrev}`.split("\n")
    new_commits.each do |rev|
    files_modified = `git log -1 --name-only --pretty=format:'' #{rev}`.split("\n")
    files_modified.each do |path|
    next if path.size == 0
    has_file_access = false
    access[$user].each do |access_path|
    if !access_path || # 用户拥有完全访问权限
    (path.index(access_path) == 0) # 或者对此位置有访问权限
    has_file_access = true
    end
    end
    if !has_file_access
    puts "[POLICY] You do not have access to push to #{path}"
    exit 1
    end
    end
    end
    end

    check_directory_perms
```

以上的大部分内容应该都比较容易理解。通过 `git rev-list` 获取推送到服务器内容的提交列表。然后，针对其中每一项，找出它试图修改的文件然后确保执行推送的用户对这些文件具有权限。一个不太容易理解的 Ruby 技巧石 `path.index(access_path) ==0` 这句，它的返回真值如果路径以 `access_path` 开头——这是为了确保 `access_path` 并不是只在允许的路径之一，而是所有准许全选的目录都在该目录之下。

现在你的用户没法推送带有不正确的提交信息的内容，也不能在准许他们访问范围之外的位置做出修改。

##### **7.4.2.3 只允许 Fast-Forward 类型的推送**

剩下的最后一项任务是指定只接受 fast-forward 的推送。在 Git 1.6 或者更新版本里，只需要设定 `receive.denyDeletes` 和 `receive.denyNonFastForwards` 选项就可以了。但是通过挂钩的实现可以在旧版本的 Git 上工作，并且通过一定的修改它它可以做到只针对某些用户执行，或者更多以后可能用的到的规则。

检查这一项的逻辑是看看提交里是否包含从旧版本里能找到但在新版本里却找不到的内容。如果没有，那这是一次纯 fast-forward 的推送；如果有，那我们拒绝此次推送：

```shell
# 只允许纯 fast-forward 推送
    def check_fast_forward
    missed_refs = `git rev-list #{$newrev}..#{$oldrev}`
    missed_ref_count = missed_refs.split("\n").size
    if missed_ref_count > 0
    puts "[POLICY] Cannot push a non fast-forward reference"
    exit 1
    end
    end

    check_fast_forward
```

一切都设定好了。如果现在运行 `chmod u+x .git/hooks/update` —— 修改包含以上内容文件的权限，然后尝试推送一个包含非 fast-forward 类型的索引，会得到一下提示：

```shell
$ git push -f origin master
    Counting objects: 5, done.
    Compressing objects: 100% (3/3), done.
    Writing objects: 100% (3/3), 323 bytes, done.
    Total 3 (delta 1), reused 0 (delta 0)
    Unpacking objects: 100% (3/3), done.
    Enforcing Policies...
    (refs/heads/master) (8338c5) (c5b616)
    [POLICY] Cannot push a non-fast-forward reference
    error: hooks/update exited with error code 1
    error: hook declined to update refs/heads/master
    To git@gitserver:project.git
    ! [remote rejected] master -> master (hook declined)
    error: failed to push some refs to 'git@gitserver:project.git'
```

这里有几个有趣的信息。首先，我们可以看到挂钩运行的起点：

```shell
Enforcing Policies...
    (refs/heads/master) (fb8c72) (c56860)
```

注意这是从 update 脚本开头输出到标准你输出的。所有从脚本输出的提示都会发送到客户端，这点很重要。

下一个值得注意的部分是错误信息。

```shell
[POLICY] Cannot push a non fast-forward reference
    error: hooks/update exited with error code 1
    error: hook declined to update refs/heads/master
```

第一行是我们的脚本输出的，在往下是 Git 在告诉我们 update 脚本退出时返回了非零值因而推送遭到了拒绝。最后一点：

```shell
To git@gitserver:project.git
    ! [remote rejected] master -> master (hook declined)
    error: failed to push some refs to 'git@gitserver:project.git'
```

我们将为每一个被挂钩拒之门外的索引受到一条远程信息，解释它被拒绝是因为一个挂钩的原因。

而且，如果那个 ref 字符串没有包含在任何的提交里，我们将看到前面脚本里输出的错误信息：

```shell
[POLICY] Your message is not formatted correctly
```

又或者某人想修改一个自己不具备权限的文件然后推送了一个包含它的提交，他将看到类似的提示。比如，一个文档作者尝试推送一个修改到 `lib` 目录的提交，他会看到

```shell
[POLICY] You do not have access to push to lib/test.rb
```

全在这了。从这里开始，只要 `update` 脚本存在并且可执行，我们的仓库永远都不会遭到回转或者包含不符合要求信息的提交内容，并且用户都被锁在了沙箱里面。

#### **7.4.2 客户端挂钩**

这种手段的缺点在于用户推送内容遭到拒绝后几乎无法避免的抱怨。辛辛苦苦写成的代码在最后时刻惨遭拒绝是十分悲剧切具迷惑性的；更可怜的是他们不得不修改提交历史来解决问题，这怎么也算不上王道。

逃离这种两难境地的法宝是给用户一些客户端的挂钩，在他们作出可能悲剧的事情的时候给以警告。然后呢，用户们就能在提交--问题变得更难修正之前解除隐患。由于挂钩本身不跟随克隆的项目副本分发，所以必须通过其他途径把这些挂钩分发到用户的 .git/hooks 目录并设为可执行文件。虽然可以在相同或单独的项目内 容里加入并分发它们，全自动的解决方案是不存在的。

首先，你应该在每次提交前核查你的提交注释信息，这样你才能确保服务器不会因为不合条件的提交注释信息而拒绝你的更改。为了达到这个目的，你可以增加'commit-msg'挂钩。如果你使用该挂钩来阅读作为第一个参数传递给git的提交注释信息，并且与规定的模式作对比，你就可以使git在提交注释信息不符合条件的情况下，拒绝执行提交。

```shell
#!/usr/bin/env ruby
    message_file = ARGV[0]
    message = File.read(message_file)

    $regex = /\[ref: (\d+)\]/

    if !$regex.match(message)
    puts "[POLICY] Your message is not formatted correctly"
    exit 1
    end
```

如果这个脚本放在这个位置 (`.git/hooks/commit-msg`) 并且是可执行的, 并且你的提交注释信息不是符合要求的，你会看到：

```shell
$ git commit -am 'test'
    [POLICY] Your message is not formatted correctly
```

在这个实例中，提交没有成功。然而如果你的提交注释信息是符合要求的，git会允许你提交：

```shell
$ git commit -am 'test [ref: 132]'
    [master e05c914] test [ref: 132]
    1 files changed, 1 insertions(+), 0 deletions(-)
```

接下来我们要保证没有修改到 ACL 允许范围之外的文件。加入你的 .git 目录里有前面使用过的 ACL 文件，那么以下的 pre-commit 脚本将把里面的规定执行起来：

```shell
#!/usr/bin/env ruby

    $user = ENV['USER']

    # [ insert acl_access_data method from above ]

    # 只允许特定用户修改项目重特定子目录的内容
    def check_directory_perms
    access = get_acl_access_data('.git/acl')

    files_modified = `git diff-index --cached --name-only HEAD`.split("\n")
    files_modified.each do |path|
    next if path.size == 0
    has_file_access = false
    access[$user].each do |access_path|
    if !access_path || (path.index(access_path) == 0)
    has_file_access = true
    end
    if !has_file_access
    puts "[POLICY] You do not have access to push to #{path}"
    exit 1
    end
    end
    end

    check_directory_perms
```

这和服务端的脚本几乎一样，除了两个重要区别。第一，ACL 文件的位置不同，因为这个脚本在当前工作目录运行，而非 Git 目录。ACL 文件的目录必须从

```shell
access = get_acl_access_data('acl')
```

修改成：

```shell
access = get_acl_access_data('.git/acl')
```

另一个重要区别是获取被修改文件列表的方式。在服务端的时候使用了查看提交纪录的方式，可是目前的提交都还没被记录下来呢，所以这个列表只能从暂存区域获取。和原来的

```shell
files_modified = `git log -1 --name-only --pretty=format:'' #{ref}`
```

不同，现在要用

```shell
files_modified = `git diff-index --cached --name-only HEAD`
```

不同的就只有这两点——除此之外，该脚本完全相同。一个小陷阱在于它假设在本地运行的账户和推送到远程服务端的相同。如果这二者不一样，则需要手动设置一下 `$user` 变量。

最后一项任务是检查确认推送内容中不包含非 fast-forward 类型的索引，不过这个需求比较少见。要找出一个非 fast-forward 类型的索引，要么衍合超过某个已经推送过的提交，要么从本地不同分支推送到远程相同的分支上。

既然服务器将给出无法推送非 fast-forward 内容的提示，而且上面的挂钩也能阻止强制的推送，唯一剩下的潜在问题就是衍合一次已经推送过的提交内容。

下面是一个检查这个问题的 pre-rabase 脚本的例子。它获取一个所有即将重写的提交内容的列表，然后检查它们是否在远程的索引里已经存在。一旦发现某个提交可以从远程索引里衍变过来，它就放弃衍合操作：

```shell
#!/usr/bin/env ruby

    base_branch = ARGV[0]
    if ARGV[1]
    topic_branch = ARGV[1]
    else
    topic_branch = "HEAD"
    end

    target_shas = `git rev-list #{base_branch}..#{topic_branch}`.split("\n")
    remote_refs = `git branch -r`.split("\n").map { |r| r.strip }

    target_shas.each do |sha|
    remote_refs.each do |remote_ref|
    shas_pushed = `git rev-list ^#{sha}^@ refs/remotes/#{remote_ref}`
    if shas_pushed.split(“\n”).include?(sha)
    puts "[POLICY] Commit #{sha} has already been pushed to #{remote_ref}"
    exit 1
    end
    end
    end
```

这个脚本利用了一个第六章“修订版本选择”一节中不曾提到的语法。通过这一句可以获得一个所有已经完成推送的提交的列表：

```shell
git rev-list ^#{sha}^@ refs/remotes/#{remote_ref}
```

`SHA^@` 语法解析该次提交的所有祖先。这里我们从检查远程最后一次提交能够衍变获得但从所有我们尝试推送的提交的 SHA 值祖先无法衍变获得的提交内容——也就是 fast-forward 的内容。

这个解决方案的硬伤在于它有可能很慢而且常常没有必要——只要不用 `-f` 来强制推送，服务器会自动给出警告并且拒绝推送内容。然而，这是个不错的练习而且理论上能帮助用户避免一次将来不得不折回来修改的衍合操作。

## **8. Git 与其他系统**

#### **8.1 Git 与 Subversion**

#### **8.2 迁移到 Git**

## **9. Git 内部原理**

### **9.1 底层命令 (Plumbing) 和高层命令 (Porcelain)**

Git 还包含了许多底层命令，这些命令用于以 UNIX 风格使用或由脚本调用。这些命令一般被称为 "plumbing" 命令（底层命令），其他的更友好的命令则被称为 "porcelain" 命令（高层命令）。

本书前八章主要专门讨论高层命令。本章将主要讨论底层命令以理解 Git 的内部工作机制、演示 Git 如何及为何要以这种方式工作。这些命令主要不是用来从命令行手工使用的，更多的是用来为其他工具和自定义脚本服务的。

当你在一个新目录或已有目录内执行 `git init` 时，Git 会创建一个 `.git` 目录，几乎所有 Git 存储和操作的内容都位于该目录下。如果你要备份或复制一个库，基本上将这一目录拷贝至其他地方就可以了。本章基本上都讨论该目录下的内容。该目录结构如下：

```shell
$ ls
    HEAD
    branches/
    config
    description
    hooks/
    index
    info/
    objects/
    refs/
```

该目录下有可能还有其他文件，但这是一个全新的 `git init` 生成的库，所以默认情况下这些就是你能看到的结构。新版本的 Git 不再使用 `branches`目录，`description` 文件仅供 GitWeb 程序使用，所以不用关心这些内容。`config` 文件包含了项目特有的配置选项，`info` 目录保存了一份不希望在 .gitignore 文件中管理的忽略模式 (ignored patterns) 的全局可执行文件。`hooks` 目录保存了第七章详细介绍了的客户端或服务端钩子脚本。

另外还有四个重要的文件或目录：`HEAD` 及 `index` 文件，`objects` 及 `refs` 目录。这些是 Git 的核心部分。`objects` 目录存储所有数据内容，`refs` 目录存储指向数据 (分支) 的提交对象的指针，`HEAD` 文件指向当前分支，`index` 文件保存了暂存区域信息。马上你将详细了解 Git 是如何操纵这些内容的。

### **9.2 Git 对象**

Git 是一套内容寻址文件系统。很不错。不过这是什么意思呢？ 这种说法的意思是，Git 从核心上来看不过是简单地存储键值对（key-value）。它允许插入任意类型的内容，并会返回一个键值，通过该键值可以在任何时候再取出该内容。可以通过底层命令 `hash-object` 来示范这点，传一些数据给该命令，它会将数据保存在 `.git` 目录并返回表示这些数据的键值。首先初使化一个 Git 仓库并确认 `objects` 目录是空的：

```
$ mkdir test
$ cd test
$ git init
Initialized empty Git repository in /tmp/test/.git/
$ find .git/objects
    .git/objects
    .git/objects/info
    .git/objects/pack
$ find .git/objects -type f
$
```

Git 初始化了 `objects` 目录，同时在该目录下创建了 `pack` 和 `info` 子目录，但是该目录下没有其他常规文件。我们往这个 Git 数据库里存储一些文本：

```
$ echo 'test content' | git hash-object -w --stdin
    d670460b4b4aece5915caf5c68d12f560a9fe3e4
```

参数 `-w` 指示 `hash-object` 命令存储 (数据) 对象，若不指定这个参数该命令仅仅返回键值。`--stdin` 指定从标准输入设备 (stdin) 来读取内容，若不指定这个参数则需指定一个要存储的文件的路径。该命令输出长度为 40 个字符的校验和。这是个 SHA-1 哈希值──其值为要存储的数据加上你马上会了解到的一种头信息的校验和。现在可以查看到 Git 已经存储了数据：

```
$ find .git/objects -type f
    .git/objects/d6/70460b4b4aece5915caf5c68d12f560a9fe3e4
```

可以在 `objects` 目录下看到一个文件。这便是 Git 存储数据内容的方式──为每份内容生成一个文件，取得该内容与头信息的 SHA-1 校验和，创建以该校验和前两个字符为名称的子目录，并以 (校验和) 剩下 38 个字符为文件命名 (保存至子目录下)。

通过 `cat-file` 命令可以将数据内容取回。该命令是查看 Git 对象的瑞士军刀。传入 `-p` 参数可以让该命令输出数据内容的类型：

```
$ git cat-file -p d670460b4b4aece5915caf5c68d12f560a9fe3e4
    test content
```

可以往 Git 中添加更多内容并取回了。也可以直接添加文件。比方说可以对一个文件进行简单的版本控制。首先，创建一个新文件，并把文件内容存储到数据库中：

```
$ echo 'version 1' > test.txt
    $ git hash-object -w test.txt
    83baae61804e65cc73a7201a7252750c76066a30
```

接着往该文件中写入一些新内容并再次保存：

```
$ echo 'version 2' > test.txt
    $ git hash-object -w test.txt
    1f7a7a472abf3dd9643fd615f6da379c4acb3e3a
```

数据库中已经将文件的两个新版本连同一开始的内容保存下来了：

```
$ find .git/objects -type f
    .git/objects/1f/7a7a472abf3dd9643fd615f6da379c4acb3e3a
    .git/objects/83/baae61804e65cc73a7201a7252750c76066a30
    .git/objects/d6/70460b4b4aece5915caf5c68d12f560a9fe3e4
```

再将文件恢复到第一个版本：

```
$ git cat-file -p 83baae61804e65cc73a7201a7252750c76066a30 > test.txt
    $ cat test.txt
    version 1
```

或恢复到第二个版本：

```
$ git cat-file -p 1f7a7a472abf3dd9643fd615f6da379c4acb3e3a > test.txt
    $ cat test.txt
    version 2
```

需要记住的是几个版本的文件 SHA-1 值可能与实际的值不同，其次，存储的并不是文件名而仅仅是文件内容。这种对象类型称为 blob 。通过传递 SHA-1 值给 `cat-file -t` 命令可以让 Git 返回任何对象的类型：

```
$ git cat-file -t 1f7a7a472abf3dd9643fd615f6da379c4acb3e3a
    blob
```

#### 9.2.1 tree (树) 对象

接下去来看 tree 对象，tree 对象可以存储文件名，同时也允许存储一组文件。Git 以一种类似 UNIX 文件系统但更简单的方式来存储内容。所有内容以 tree 或 blob 对象存储，其中 tree 对象对应于 UNIX 中的目录，blob 对象则大致对应于 inodes 或文件内容。一个单独的 tree 对象包含一条或多条 tree 记录，每一条记录含有一个指向 blob 或子 tree 对象的 SHA-1 指针，并附有该对象的权限模式 (mode)、类型和文件名信息。以 simplegit 项目为例，最新的 tree 可能是这个样子：

```
$ git cat-file -p master^{tree}
    100644 blob a906cb2a4a904a152e80877d4088654daad0c859 README
    100644 blob 8f94139338f9404f26296befa88755fc2598c289 Rakefile
    040000 tree 99f1a6d12cb4b6f19c8655fca46c3ecf317074e0 lib
```

`master^{tree}` 表示 `branch` 分支上最新提交指向的 tree 对象。请注意 `lib` 子目录并非一个 blob 对象，而是一个指向别一个 tree 对象的指针：

```
$ git cat-file -p 99f1a6d12cb4b6f19c8655fca46c3ecf317074e0
    100644 blob 47c6340d6459e05787f644c2447d2595f5d3a54b simplegit.rb
```

从概念上来讲，Git 保存的数据如下图所示：

![principle1](.\appendix\principle1.png)

你可以自己创建 tree 。通常 Git 根据你的暂存区域或 index 来创建并写入一个 tree 。因此要创建一个 tree 对象的话首先要通过将一些文件暂存从而创建一个 index 。可以使用 plumbing 命令 `update-index` 为一个单独文件 ── test.txt 文件的第一个版本 ──　创建一个 index　。通过该命令人为的将 test.txt 文件的首个版本加入到了一个新的暂存区域中。由于该文件原先并不在暂存区域中 (甚至就连暂存区域也还没被创建出来呢) ，必须传入 `--add`参数;由于要添加的文件并不在当前目录下而是在数据库中，必须传入 `--cacheinfo` 参数。同时指定了文件模式，SHA-1 值和文件名：

```
$ git update-index --add --cacheinfo 100644 \
    83baae61804e65cc73a7201a7252750c76066a30 test.txt
```

在本例中，指定了文件模式为 `100644`，表明这是一个普通文件。其他可用的模式有：`100755` 表示可执行文件，`120000` 表示符号链接。文件模式是从常规的 UNIX 文件模式中参考来的，但是没有那么灵活 ── 上述三种模式仅对 Git 中的文件 (blobs) 有效 (虽然也有其他模式用于目录和子模块)。

现在可以用 `write-tree` 命令将暂存区域的内容写到一个 tree 对象了。无需 `-w` 参数 ── 如果目标 tree 不存在，调用 `write-tree` 会自动根据 index 状态创建一个 tree 对象。

```
$ git write-tree
    d8329fc1cc938780ffdd9f94e0d364e0ea74f579
    $ git cat-file -p d8329fc1cc938780ffdd9f94e0d364e0ea74f579
    100644 blob 83baae61804e65cc73a7201a7252750c76066a30 test.txt
```

可以这样验证这确实是一个 tree 对象：

```
$ git cat-file -t d8329fc1cc938780ffdd9f94e0d364e0ea74f579
    tree
```

再根据 test.txt 的第二个版本以及一个新文件创建一个新 tree 对象：

```
$ echo 'new file' > new.txt
    $ git update-index test.txt
    $ git update-index --add new.txt
```

这时暂存区域中包含了 test.txt 的新版本及一个新文件 new.txt 。创建 (写) 该 tree 对象 (将暂存区域或 index 状态写入到一个 tree 对象)，然后瞧瞧它的样子：

```
$ git write-tree
    0155eb4229851634a0f03eb265b69f5a2d56f341
    $ git cat-file -p 0155eb4229851634a0f03eb265b69f5a2d56f341
    100644 blob fa49b077972391ad58037050f2a75f74e3671e92 new.txt
    100644 blob 1f7a7a472abf3dd9643fd615f6da379c4acb3e3a test.txt
```

请注意该 tree 对象包含了两个文件记录，且 test.txt 的 SHA 值是早先值的 "第二版" (`1f7a7a`)。来点更有趣的，你将把第一个 tree 对象作为一个子目录加进该 tree 中。可以用 `read-tree` 命令将 tree 对象读到暂存区域中去。在这时，通过传一个 `--prefix` 参数给 `read-tree`，将一个已有的 tree 对象作为一个子 tree 读到暂存区域中：

```
$ git read-tree --prefix=bak d8329fc1cc938780ffdd9f94e0d364e0ea74f579
    $ git write-tree
    3c4e9cd789d88d8d89c1073707c3585e41b0e614
    $ git cat-file -p 3c4e9cd789d88d8d89c1073707c3585e41b0e614
    040000 tree d8329fc1cc938780ffdd9f94e0d364e0ea74f579 bak
    100644 blob fa49b077972391ad58037050f2a75f74e3671e92 new.txt
    100644 blob 1f7a7a472abf3dd9643fd615f6da379c4acb3e3a test.txt
```

如果从刚写入的新 tree 对象创建一个工作目录，将得到位于工作目录顶级的两个文件和一个名为 `bak` 的子目录，该子目录包含了 test.txt 文件的第一个版本。可以将 Git 用来包含这些内容的数据想象成如下图所示：

![principle2](.\appendix\principle2.png)

#### **9.2.2 commit (提交) 对象**

你现在有三个 tree 对象，它们指向了你要跟踪的项目的不同快照，可是先前的问题依然存在：必须记往三个 SHA-1 值以获得这些快照。你也没有关于谁、何时以及为何保存了这些快照的信息。commit 对象为你保存了这些基本信息。

要创建一个 commit 对象，使用 `commit-tree` 命令，指定一个 tree 的 SHA-1，如果有任何前继提交对象，也可以指定。从你写的第一个 tree 开始：

```
$ echo 'first commit' | git commit-tree d8329f
    fdf4fc3344e67ab068f836878b6c4951e3b15f3d
```

通过 `cat-file` 查看这个新 commit 对象：

```
$ git cat-file -p fdf4fc3
    tree d8329fc1cc938780ffdd9f94e0d364e0ea74f579
    author Scott Chacon <schacon@gmail.com> 1243040974 -0700
    committer Scott Chacon <schacon@gmail.com> 1243040974 -0700

    first commit
```

commit 对象有格式很简单：指明了该时间点项目快照的顶层树对象、作者/提交者信息（从 Git 设置的 `user.name` 和 `user.email`中获得)以及当前时间戳、一个空行，以及提交注释信息。

接着再写入另外两个 commit 对象，每一个都指定其之前的那个 commit 对象：

```
$ echo 'second commit' | git commit-tree 0155eb -p fdf4fc3
    cac0cab538b970a37ea1e769cbbde608743bc96d
    $ echo 'third commit' | git commit-tree 3c4e9c -p cac0cab
    1a410efbd13591db07496601ebc7a059dd55cfe9
```

每一个 commit 对象都指向了你创建的树对象快照。出乎意料的是，现在已经有了真实的 Git 历史了，所以如果运行 `git log` 命令并指定最后那个 commit 对象的 SHA-1 便可以查看历史：

```
$ git log --stat 1a410e
    commit 1a410efbd13591db07496601ebc7a059dd55cfe9
    Author: Scott Chacon <schacon@gmail.com>
    Date: Fri May 22 18:15:24 2009 -0700

    third commit

    bak/test.txt | 1 +
    1 files changed, 1 insertions(+), 0 deletions(-)

    commit cac0cab538b970a37ea1e769cbbde608743bc96d
    Author: Scott Chacon <schacon@gmail.com>
    Date: Fri May 22 18:14:29 2009 -0700

    second commit

    new.txt | 1 +
    test.txt | 2 +-
    2 files changed, 2 insertions(+), 1 deletions(-)

    commit fdf4fc3344e67ab068f836878b6c4951e3b15f3d
    Author: Scott Chacon <schacon@gmail.com>
    Date: Fri May 22 18:09:34 2009 -0700

    first commit

    test.txt | 1 +
    1 files changed, 1 insertions(+), 0 deletions(-)
```

真棒。你刚刚通过使用低级操作而不是那些普通命令创建了一个 Git 历史。这基本上就是运行　`git add` 和 `git commit` 命令时 Git 进行的工作　──保存修改了的文件的 blob，更新索引，创建 tree 对象，最后创建 commit 对象，这些 commit 对象指向了顶层 tree 对象以及先前的 commit 对象。这三类 Git 对象 ── blob，tree 以及 tree ── 都各自以文件的方式保存在 `.git/objects` 目录下。以下所列是目前为止样例中的所有对象，每个对象后面的注释里标明了它们保存的内容：

```
$ find .git/objects -type f
    .git/objects/01/55eb4229851634a0f03eb265b69f5a2d56f341 # tree 2
    .git/objects/1a/410efbd13591db07496601ebc7a059dd55cfe9 # commit 3
    .git/objects/1f/7a7a472abf3dd9643fd615f6da379c4acb3e3a # test.txt v2
    .git/objects/3c/4e9cd789d88d8d89c1073707c3585e41b0e614 # tree 3
    .git/objects/83/baae61804e65cc73a7201a7252750c76066a30 # test.txt v1
    .git/objects/ca/c0cab538b970a37ea1e769cbbde608743bc96d # commit 2
    .git/objects/d6/70460b4b4aece5915caf5c68d12f560a9fe3e4 # 'test content'
    .git/objects/d8/329fc1cc938780ffdd9f94e0d364e0ea74f579 # tree 1
    .git/objects/fa/49b077972391ad58037050f2a75f74e3671e92 # new.txt
    .git/objects/fd/f4fc3344e67ab068f836878b6c4951e3b15f3d # commit 1
```

如果你按照以上描述进行了操作，可以得到如下图所示的对象图：

![principle3](.\appendix\principle3.png)

#### **9.2.3 对象存储**

之前我提到当存储数据内容时，同时会有一个文件头被存储起来。我们花些时间来看看 Git 是如何存储对象的。你将看来如何通过 Ruby 脚本语言存储一个 blob 对象 (这里以字符串 "what is up, doc?" 为例) 。使用 `irb` 命令进入 Ruby 交互式模式：

```
$ irb
    >> content = "what is up, doc?"
    => "what is up, doc?"
```

Git 以对象类型为起始内容构造一个文件头，本例中是一个 blob。然后添加一个空格，接着是数据内容的长度，最后是一个空字节 (null byte)：

```
>> header = "blob #{content.length}\0"
    => "blob 16\000"
```

Git 将文件头与原始数据内容拼接起来，并计算拼接后的新内容的 SHA-1 校验和。可以在 Ruby 中使用 `require` 语句导入 SHA1 digest 库，然后调用 `Digest::SHA1.hexdigest()` 方法计算字符串的 SHA-1 值：

```
>> store = header + content
    => "blob 16\000what is up, doc?"
    >> require 'digest/sha1'
    => true
    >> sha1 = Digest::SHA1.hexdigest(store)
    => "bd9dbf5aae1a3862dd1526723246b20206e5fc37"
```

Git 用 zlib 对数据内容进行压缩，在 Ruby 中可以用 zlib 库来实现。首先需要导入该库，然后用 `Zlib::Deflate.deflate()` 对数据进行压缩：

```
>> require 'zlib'
    => true
    >> zlib_content = Zlib::Deflate.deflate(store)
    => "x\234K\312\311OR04c(\317H,Q\310,V(-\320QH\311O\266\a\000_\034\a\235"
```

最后将用 zlib 压缩后的内容写入磁盘。需要指定保存对象的路径 (SHA-1 值的头两个字符作为子目录名称，剩余 38 个字符作为文件名保存至该子目录中)。在 Ruby 中，如果子目录不存在可以用 `FileUtils.mkdir_p()` 函数创建它。接着用 `File.open` 方法打开文件，并用 `write()` 方法将之前压缩的内容写入该文件：

```
>> path = '.git/objects/' + sha1[0,2] + '/' + sha1[2,38]
    => ".git/objects/bd/9dbf5aae1a3862dd1526723246b20206e5fc37"
    >> require 'fileutils'
    => true
    >> FileUtils.mkdir_p(File.dirname(path))
    => ".git/objects/bd"
    >> File.open(path, 'w') { |f| f.write zlib_content }
    => 32
```

这就行了 ── 你已经创建了一个正确的 blob 对象。所有的 Git 对象都以这种方式存储，惟一的区别是类型不同 ── 除了字符串 blob，文件头起始内容还可以是 commit 或 tree 。不过虽然 blob 几乎可以是任意内容，commit 和 tree 的数据却是有固定格式的。

### **9.3 Git References**

你可以执行像 `git log 1a410e` 这样的命令来查看完整的历史，但是这样你就要记得 `1a410e` 是你最后一次提交，这样才能在提交历史中找到这些对象。你需要一个文件来用一个简单的名字来记录这些 SHA-1 值，这样你就可以用这些指针而不是原来的 SHA-1 值去检索了。

在 Git 中，我们称之为“引用”（references 或者 refs，译者注）。你可以在 `.git/refs` 目录下面找到这些包含 SHA-1 值的文件。在这个项目里，这个目录还没不包含任何文件，但是包含这样一个简单的结构：

```
$ find .git/refs
    .git/refs
    .git/refs/heads
    .git/refs/tags
    $ find .git/refs -type f
    $
```

如果想要创建一个新的引用帮助你记住最后一次提交，技术上你可以这样做：

```
$ echo "1a410efbd13591db07496601ebc7a059dd55cfe9" > .git/refs/heads/master
```

现在，你就可以在 Git 命令中使用你刚才创建的引用而不是 SHA-1 值：

```
$ git log --pretty=oneline master
    1a410efbd13591db07496601ebc7a059dd55cfe9 third commit
    cac0cab538b970a37ea1e769cbbde608743bc96d second commit
    fdf4fc3344e67ab068f836878b6c4951e3b15f3d first commit
```

当然，我们并不鼓励你直接修改这些引用文件。如果你确实需要更新一个引用，Git 提供了一个安全的命令 `update-ref`：

```
$ git update-ref refs/heads/master 1a410efbd13591db07496601ebc7a059dd55cfe9
```

基本上 Git 中的一个分支其实就是一个指向某个工作版本一条 HEAD 记录的指针或引用。你可以用这条命令创建一个指向第二次提交的分支：

```
$ git update-ref refs/heads/test cac0ca
```

这样你的分支将会只包含那次提交以及之前的工作：

```
$ git log --pretty=oneline test
    cac0cab538b970a37ea1e769cbbde608743bc96d second commit
    fdf4fc3344e67ab068f836878b6c4951e3b15f3d first commit
```

现在，你的 Git 数据库应该看起来像如下图所示：

![principle4](.\appendix\principle4.png)

每当你执行 `git branch (分支名称)` 这样的命令，Git 基本上就是执行 `update-ref` 命令，把你现在所在分支中最后一次提交的 SHA-1 值，添加到你要创建的分支的引用。

#### **9.3.1 HEAD 标记**

现在的问题是，当你执行 `git branch (分支名称)` 这条命令的时候，Git 怎么知道最后一次提交的 SHA-1 值呢？答案就是 HEAD 文件。HEAD 文件是一个指向你当前所在分支的引用标识符。这样的引用标识符——它看起来并不像一个普通的引用——其实并不包含 SHA-1 值，而是一个指向另外一个引用的指针。如果你看一下这个文件，通常你将会看到这样的内容：

```
$ cat .git/HEAD
    ref: refs/heads/master
```

如果你执行 `git checkout test`，Git 就会更新这个文件，看起来像这样：

```
$ cat .git/HEAD
    ref: refs/heads/test
```

当你再执行 `git commit` 命令，它就创建了一个 commit 对象，把这个 commit 对象的父级设置为 HEAD 指向的引用的 SHA-1 值。

你也可以手动编辑这个文件，但是同样有一个更安全的方法可以这样做：`symbolic-ref`。你可以用下面这条命令读取 HEAD 的值：

```
$ git symbolic-ref HEAD
    refs/heads/master
```

你也可以设置 HEAD 的值：

```
$ git symbolic-ref HEAD refs/heads/test
    $ cat .git/HEAD
    ref: refs/heads/test
```

但是你不能设置成 refs 以外的形式：

```
$ git symbolic-ref HEAD test
    fatal: Refusing to point HEAD outside of refs/
```

#### **9.3.2 Tags**

你刚刚已经重温过了 Git 的三个主要对象类型，现在这是第四种。Tag 对象非常像一个 commit 对象——包含一个标签，一组数据，一个消息和一个指针。最主要的区别就是 Tag 对象指向一个 commit 而不是一个 tree。它就像是一个分支引用，但是不会变化——永远指向同一个 commit，仅仅是提供一个更加友好的名字。

正如我们在第二章所讨论的，Tag 有两种类型：annotated 和 lightweight 。你可以类似下面这样的命令建立一个 lightweight tag：

```
$ git update-ref refs/tags/v1.0 cac0cab538b970a37ea1e769cbbde608743bc96d
```

这就是 lightweight tag 的全部 —— 一个永远不会发生变化的分支。 annotated tag 要更复杂一点。如果你创建一个 annotated tag，Git 会创建一个 tag 对象，然后写入一个指向指向它而不是直接指向 commit 的 reference。你可以这样创建一个 annotated tag（`-a` 参数表明这是一个 annotated tag）：

```
$ git tag -a v1.1 1a410efbd13591db07496601ebc7a059dd55cfe9 -m 'test tag'
```

这是所创建对象的 SHA-1 值：

```
$ cat .git/refs/tags/v1.1
    9585191f37f7b0fb9444f35a9bf50de191beadc2
```

现在你可以运行 `cat-file` 命令检查这个 SHA-1 值：

```
$ git cat-file -p 9585191f37f7b0fb9444f35a9bf50de191beadc2
    object 1a410efbd13591db07496601ebc7a059dd55cfe9
    type commit
    tag v1.1
    tagger Scott Chacon <schacon@gmail.com> Sat May 23 16:48:58 2009 -0700

    test tag
```

值得注意的是这个对象指向你所标记的 commit 对象的 SHA-1 值。同时需要注意的是它并不是必须要指向一个 commit 对象；你可以标记任何 Git 对象。例如，在 Git 的源代码里，管理者添加了一个 GPG 公钥（这是一个 blob 对象）对它做了一个标签。你就可以运行：

```
$ git cat-file blob junio-gpg-pub
```

来查看 Git 源代码仓库中的公钥. Linux kernel 也有一个不是指向 commit 对象的 tag —— 第一个 tag 是在导入源代码的时候创建的，它指向初始 tree （initial tree，译者注）。

#### **9.3.3 Remotes**

你将会看到的第四种 reference 是 remote reference（远程引用，译者注）。如果你添加了一个 remote 然后推送代码过去，Git 会把你最后一次推送到这个 remote 的每个分支的值都记录在 `refs/remotes` 目录下。例如，你可以添加一个叫做 `origin` 的 remote 然后把你的 `master` 分支推送上去：

```
$ git remote add origin git@github.com:schacon/simplegit-progit.git
    $ git push origin master
    Counting objects: 11, done.
    Compressing objects: 100% (5/5), done.
    Writing objects: 100% (7/7), 716 bytes, done.
    Total 7 (delta 2), reused 4 (delta 1)
    To git@github.com:schacon/simplegit-progit.git
    a11bef0..ca82a6d master -> master
```

然后查看 `refs/remotes/origin/master` 这个文件，你就会发现 `origin` remote 中的 `master` 分支就是你最后一次和服务器的通信。

```
$ cat .git/refs/remotes/origin/master
    ca82a6dff817ec66f44342007202690a93763949
```

Remote 应用和分支主要区别在于他们是不能被 check out 的。Git 把他们当作是标记这些了这些分支在服务器上最后状态的一种书签。

### **9.4 Packfiles**

我们再来看一下 test Git 仓库。目前为止，有 11 个对象 ── 4 个 blob，3 个 tree，3 个 commit 以及一个 tag：

```
$ find .git/objects -type f
    .git/objects/01/55eb4229851634a0f03eb265b69f5a2d56f341 # tree 2
    .git/objects/1a/410efbd13591db07496601ebc7a059dd55cfe9 # commit 3
    .git/objects/1f/7a7a472abf3dd9643fd615f6da379c4acb3e3a # test.txt v2
    .git/objects/3c/4e9cd789d88d8d89c1073707c3585e41b0e614 # tree 3
    .git/objects/83/baae61804e65cc73a7201a7252750c76066a30 # test.txt v1
    .git/objects/95/85191f37f7b0fb9444f35a9bf50de191beadc2 # tag
    .git/objects/ca/c0cab538b970a37ea1e769cbbde608743bc96d # commit 2
    .git/objects/d6/70460b4b4aece5915caf5c68d12f560a9fe3e4 # 'test content'
    .git/objects/d8/329fc1cc938780ffdd9f94e0d364e0ea74f579 # tree 1
    .git/objects/fa/49b077972391ad58037050f2a75f74e3671e92 # new.txt
    .git/objects/fd/f4fc3344e67ab068f836878b6c4951e3b15f3d # commit 1
```

Git 用 zlib 压缩文件内容，因此这些文件并没有占用太多空间，所有文件加起来总共仅用了 925 字节。接下去你会添加一些大文件以演示 Git 的一个很有意思的功能。将你之前用到过的 Grit 库中的 repo.rb 文件加进去 ── 这个源代码文件大小约为 12K：

```
$ curl http://github.com/mojombo/grit/raw/master/lib/grit/repo.rb > repo.rb
    $ git add repo.rb
    $ git commit -m 'added repo.rb'
    [master 484a592] added repo.rb
    3 files changed, 459 insertions(+), 2 deletions(-)
    delete mode 100644 bak/test.txt
    create mode 100644 repo.rb
    rewrite test.txt (100%)
```

如果查看一下生成的 tree，可以看到 repo.rb 文件的 blob 对象的 SHA-1 值：

```
$ git cat-file -p master^{tree}
    100644 blob fa49b077972391ad58037050f2a75f74e3671e92 new.txt
    100644 blob 9bc1dc421dcd51b4ac296e3e5b6e2a99cf44391e repo.rb
    100644 blob e3f094f522629ae358806b17daf78246c27c007b test.txt
```

然后可以用 `git cat-file` 命令查看这个对象有多大：

```
$ git cat-file -s 9bc1dc421dcd51b4ac296e3e5b6e2a99cf44391e
    12898
```

稍微修改一下些文件，看会发生些什么：

```
$ echo '# testing' >> repo.rb
    $ git commit -am 'modified repo a bit'
    [master ab1afef] modified repo a bit
    1 files changed, 1 insertions(+), 0 deletions(-)
```

查看这个 commit 生成的 tree，可以看到一些有趣的东西：

```
$ git cat-file -p master^{tree}
    100644 blob fa49b077972391ad58037050f2a75f74e3671e92 new.txt
    100644 blob 05408d195263d853f09dca71d55116663690c27c repo.rb
    100644 blob e3f094f522629ae358806b17daf78246c27c007b test.txt
```

blob 对象与之前的已经不同了。这说明虽然只是往一个 400 行的文件最后加入了一行内容，Git 却用一个全新的对象来保存新的文件内容：

```
$ git cat-file -s 05408d195263d853f09dca71d55116663690c27c
    12908
```

你的磁盘上有了两个几乎完全相同的 12K 的对象。如果 Git 只完整保存其中一个，并保存另一个对象的差异内容，岂不更好？

事实上 Git 可以那样做。Git 往磁盘保存对象时默认使用的格式叫松散对象 (loose object) 格式。Git 时不时地将这些对象打包至一个叫 packfile 的二进制文件以节省空间并提高效率。当仓库中有太多的松散对象，或是手工调用 `git gc` 命令，或推送至远程服务器时，Git 都会这样做。手工调用 `git gc`命令让 Git 将库中对象打包并看会发生些什么：

```
$ git gc
    Counting objects: 17, done.
    Delta compression using 2 threads.
    Compressing objects: 100% (13/13), done.
    Writing objects: 100% (17/17), done.
    Total 17 (delta 1), reused 10 (delta 0)
```

查看一下 objects 目录，会发现大部分对象都不在了，与此同时出现了两个新文件：

```
$ find .git/objects -type f
    .git/objects/71/08f7ecb345ee9d0084193f147cdad4d2998293
    .git/objects/d6/70460b4b4aece5915caf5c68d12f560a9fe3e4
    .git/objects/info/packs
    .git/objects/pack/pack-7a16e4488ae40c7d2bc56ea2bd43e25212a66c45.idx
    .git/objects/pack/pack-7a16e4488ae40c7d2bc56ea2bd43e25212a66c45.pack
```

仍保留着的几个对象是未被任何 commit 引用的 blob ── 在此例中是你之前创建的 "what is up, doc?" 和 "test content" 这两个示例 blob。你从没将他们添加至任何 commit，所以 Git 认为它们是 "悬空" 的，不会将它们打包进 packfile 。

剩下的文件是新创建的 packfile 以及一个索引。packfile 文件包含了刚才从文件系统中移除的所有对象。索引文件包含了 packfile 的偏移信息，这样就可以快速定位任意一个指定对象。有意思的是运行 `gc` 命令前磁盘上的对象大小约为 12K ，而这个新生成的 packfile 仅为 6K 大小。通过打包对象减少了一半磁盘使用空间。

Git 是如何做到这点的？Git 打包对象时，会查找命名及尺寸相近的文件，并只保存文件不同版本之间的差异内容。可以查看一下 packfile ，观察它是如何节省空间的。`git verify-pack` 命令用于显示已打包的内容：

```
$ git verify-pack -v \
    .git/objects/pack/pack-7a16e4488ae40c7d2bc56ea2bd43e25212a66c45.idx
    0155eb4229851634a0f03eb265b69f5a2d56f341 tree 71 76 5400
    05408d195263d853f09dca71d55116663690c27c blob 12908 3478 874
    09f01cea547666f58d6a8d809583841a7c6f0130 tree 106 107 5086
    1a410efbd13591db07496601ebc7a059dd55cfe9 commit 225 151 322
    1f7a7a472abf3dd9643fd615f6da379c4acb3e3a blob 10 19 5381
    3c4e9cd789d88d8d89c1073707c3585e41b0e614 tree 101 105 5211
    484a59275031909e19aadb7c92262719cfcdf19a commit 226 153 169
    83baae61804e65cc73a7201a7252750c76066a30 blob 10 19 5362
    9585191f37f7b0fb9444f35a9bf50de191beadc2 tag 136 127 5476
    9bc1dc421dcd51b4ac296e3e5b6e2a99cf44391e blob 7 18 5193 1 \
    05408d195263d853f09dca71d55116663690c27c
    ab1afef80fac8e34258ff41fc1b867c702daa24b commit 232 157 12
    cac0cab538b970a37ea1e769cbbde608743bc96d commit 226 154 473
    d8329fc1cc938780ffdd9f94e0d364e0ea74f579 tree 36 46 5316
    e3f094f522629ae358806b17daf78246c27c007b blob 1486 734 4352
    f8f51d7d8a1760462eca26eebafde32087499533 tree 106 107 749
    fa49b077972391ad58037050f2a75f74e3671e92 blob 9 18 856
    fdf4fc3344e67ab068f836878b6c4951e3b15f3d commit 177 122 627
    chain length = 1: 1 object
    pack-7a16e4488ae40c7d2bc56ea2bd43e25212a66c45.pack: ok
```

如果你还记得的话, `9bc1d` 这个 blob 是 repo.rb 文件的第一个版本，这个 blob 引用了 `05408` 这个 blob，即该文件的第二个版本。命令输出内容的第三列显示的是对象大小，可以看到 `05408` 占用了 12K 空间，而 `9bc1d` 仅为 7 字节。非常有趣的是第二个版本才是完整保存文件内容的对象，而第一个版本是以差异方式保存的 ── 这是因为大部分情况下需要快速访问文件的最新版本。

最妙的是可以随时进行重新打包。Git 自动定期对仓库进行重新打包以节省空间。当然也可以手工运行 `git gc` 命令来这么做。

### **9.5 The Refspec**

你已经使用过一些简单的远程分支到本地引用的映射方式了，这种映射可以更为复杂。 假设你像这样添加了一项远程仓库：

```
$ git remote add origin git@github.com:schacon/simplegit-progit.git
```

它在你的 `.git/config` 文件中添加了一节，指定了远程的名称 (`origin`), 远程仓库的URL地址，和用于获取操作的 Refspec:

```
[remote "origin"]
    url = git@github.com:schacon/simplegit-progit.git
    fetch = +refs/heads/*:refs/remotes/origin/*
```

Refspec 的格式是一个可选的 `+` 号，接着是 `:` 的格式，这里 `` 是远端上的引用格式， `` 是将要记录在本地的引用格式。可选的 `+` 号告诉 Git 在即使不能快速演进的情况下，也去强制更新它。

缺省情况下 refspec 会被 `git remote add` 命令所自动生成， Git 会获取远端上 `refs/heads/` 下面的所有引用，并将它写入到本地的 `refs/remotes/origin/`. 所以，如果远端上有一个 `master` 分支，你在本地可以通过下面这种方式来访问它的历史记录：

```
$ git log origin/master
    $ git log remotes/origin/master
    $ git log refs/remotes/origin/master
```

它们全是等价的，因为 Git 把它们都扩展成 `refs/remotes/origin/master`.

如果你想让 Git 每次只拉取远程的 `master` 分支，而不是远程的所有分支，你可以把 fetch 这一行修改成这样：

```
fetch = +refs/heads/master:refs/remotes/origin/master
```

这是 `git fetch` 操作对这个远端的缺省 refspec 值。而如果你只想做一次该操作，也可以在命令行上指定这个 refspec. 如可以这样拉取远程的 `master` 分支到本地的 `origin/mymaster` 分支：

```
$ git fetch origin master:refs/remotes/origin/mymaster
```

你也可以在命令行上指定多个 refspec. 像这样可以一次获取远程的多个分支：

```
$ git fetch origin master:refs/remotes/origin/mymaster \
    topic:refs/remotes/origin/topic
    From git@github.com:schacon/simplegit
    ! [rejected] master -> origin/mymaster (non fast forward)
    * [new branch] topic -> origin/topic
```

在这个例子中， `master` 分支因为不是一个可以快速演进的引用而拉取操作被拒绝。你可以在 refspec 之前使用一个 `+` 号来重载这种行为。

你也可以在配置文件中指定多个 refspec. 如你想在每次获取时都获取 `master` 和 `experiment` 分支，就添加两行：

```
[remote "origin"]
    url = git@github.com:schacon/simplegit-progit.git
    fetch = +refs/heads/master:refs/remotes/origin/master
    fetch = +refs/heads/experiment:refs/remotes/origin/experiment
```

但是这里不能使用部分通配符，像这样就是不合法的：

```
fetch = +refs/heads/qa*:refs/remotes/origin/qa*
```

但无论如何，你可以使用命名空间来达到这个目的。如你有一个QA组，他们推送一系列分支，你想每次获取 `master` 分支和QA组的所有分支，你可以使用这样的配置段落：

```
[remote "origin"]
    url = git@github.com:schacon/simplegit-progit.git
    fetch = +refs/heads/master:refs/remotes/origin/master
    fetch = +refs/heads/qa/*:refs/remotes/origin/qa/*
```

如果你的工作流很复杂，有QA组推送的分支、开发人员推送的分支、和集成人员推送的分支，并且他们在远程分支上协作，你可以采用这种方式为他们创建各自的命名空间。

#### **9.5.1 推送 Refspec**

采用命名空间的方式确实很棒，但QA组成员第1次是如何将他们的分支推送到 `qa/` 空间里面的呢？答案是你可以使用 refspec 来推送。

如果QA组成员想把他们的 `master` 分支推送到远程的 `qa/master` 分支上，可以这样运行：

```
$ git push origin master:refs/heads/qa/master
```

如果他们想让 Git 每次运行 `git push origin` 时都这样自动推送，他们可以在配置文件中添加 `push` 值：

```
[remote "origin"]
    url = git@github.com:schacon/simplegit-progit.git
    fetch = +refs/heads/*:refs/remotes/origin/*
    push = refs/heads/master:refs/heads/qa/master
```

这样，就会让 `git push origin` 缺省就把本地的 `master` 分支推送到远程的 `qa/master` 分支上。

#### **9.5.2 删除引用**

你也可以使用 refspec 来删除远程的引用，是通过运行这样的命令：

```
$ git push origin :topic
```

因为 refspec 的格式是 `:`, 通过把 `` 部分留空的方式，这个意思是是把远程的 `topic` 分支变成空，也就是删除它。

### **9.6 传输协议**

Git 可以以两种主要的方式跨越两个仓库传输数据：基于HTTP协议之上，和 `file://`, `ssh://`, 和 `git://` 等智能传输协议。这一节带你快速浏览这两种主要的协议操作过程。

#### **9.6.1 哑协议**

Git 基于HTTP之上传输通常被称为哑协议，这是因为它在服务端不需要有针对 Git 特有的代码。这个获取过程仅仅是一系列GET请求，客户端可以假定服务端的Git仓库中的布局。让我们以 simplegit 库来看看 `http-fetch` 的过程：

```
$ git clone http://github.com/schacon/simplegit-progit.git
```

它做的第1件事情就是获取 `info/refs` 文件。这个文件是在服务端运行了 `update-server-info` 所生成的，这也解释了为什么在服务端要想使用HTTP传输，必须要开启 `post-receive` 钩子：

```
=> GET info/refs
    ca82a6dff817ec66f44342007202690a93763949 refs/heads/master
```

现在你有一个远端引用和SHA值的列表。下一步是寻找HEAD引用，这样你就知道了在完成后，什么应该被检出到工作目录：

```
=> GET HEAD
    ref: refs/heads/master
```

这说明在完成获取后，需要检出 `master` 分支。 这时，已经可以开始漫游操作了。因为你的起点是在 `info/refs` 文件中所提到的 `ca82a6` commit 对象，你的开始操作就是获取它：

```
=> GET objects/ca/82a6dff817ec66f44342007202690a93763949
    (179 bytes of binary data)
```

然后你取回了这个对象 － 这在服务端是一个松散格式的对象，你使用的是静态的 HTTP GET 请求获取的。可以使用 zlib 解压缩它，去除其头部，查看它的 commmit 内容：

```
$ git cat-file -p ca82a6dff817ec66f44342007202690a93763949
    tree cfda3bf379e4f8dba8717dee55aab78aef7f4daf
    parent 085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7
    author Scott Chacon <schacon@gmail.com> 1205815931 -0700
    committer Scott Chacon <schacon@gmail.com> 1240030591 -0700

    changed the version number
```

这样，就得到了两个需要进一步获取的对象 － `cfda3b` 是这个 commit 对象所对应的 tree 对象，和 `085bb3` 是它的父对象；

```
=> GET objects/08/5bb3bcb608e1e8451d4b2432f8ecbe6306e7e7
    (179 bytes of data)
```

这样就取得了这它的下一步 commit 对象，再抓取 tree 对象：

```
=> GET objects/cf/da3bf379e4f8dba8717dee55aab78aef7f4daf
    (404 - Not Found)
```

Oops - 看起来这个 tree 对象在服务端并不以松散格式对象存在，所以得到了404响应，代表在HTTP服务端没有找到该对象。这有好几个原因 － 这个对象可能在替代仓库里面，或者在打包文件里面， Git 会首先检查任何列出的替代仓库：

```
=> GET objects/info/http-alternates
    (empty file)
```

如果这返回了几个替代仓库列表，那么它会去那些地方检查松散格式对象和文件 － 这是一种在软件分叉之间共享对象以节省磁盘的好方法。然而，在这个例子中，没有替代仓库。所以你所需要的对象肯定在某个打包文件中。要检查服务端有哪些打包格式文件，你需要获取 `objects/info/packs` 文件，这里面包含有打包文件列表（是的，它也是被 `update-server-info` 所生成的）；

```
=> GET objects/info/packs
    P pack-816a9b2334da9953e530f27bcac22082a9f5b835.pack
```

这里服务端只有一个打包文件，所以你要的对象显然就在里面。但是你可以先检查它的索引文件以确认。这在服务端有多个打包文件时也很有用，因为这样就可以先检查你所需要的对象空间是在哪一个打包文件里面了：

```
=> GET objects/pack/pack-816a9b2334da9953e530f27bcac22082a9f5b835.idx
    (4k of binary data)
```

现在你有了这个打包文件的索引，你可以看看你要的对象是否在里面 － 因为索引文件列出了这个打包文件所包含的所有对象的SHA值，和该对象存在于打包文件中的偏移量，所以你只需要简单地获取整个打包文件：

```
=> GET objects/pack/pack-816a9b2334da9953e530f27bcac22082a9f5b835.pack
    (13k of binary data)
```

现在你也有了这个 tree 对象，你可以继续在 commit 对象上漫游。它们全部都在这个你已经下载到的打包文件里面，所以你不用继续向服务端请求更多下载了。 在这完成之后，由于下载开始时已探明HEAD引用是指向 `master` 分支， Git 会将它检出到工作目录。

整个过程看起来就像这样：

```
$ git clone http://github.com/schacon/simplegit-progit.git
    Initialized empty Git repository in /private/tmp/simplegit-progit/.git/
    got ca82a6dff817ec66f44342007202690a93763949
    walk ca82a6dff817ec66f44342007202690a93763949
    got 085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7
    Getting alternates list for http://github.com/schacon/simplegit-progit.git
    Getting pack list for http://github.com/schacon/simplegit-progit.git
    Getting index for pack 816a9b2334da9953e530f27bcac22082a9f5b835
    Getting pack 816a9b2334da9953e530f27bcac22082a9f5b835
    which contains cfda3bf379e4f8dba8717dee55aab78aef7f4daf
    walk 085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7
    walk a11bef06a3f659402fe7563abf99ad00de2209e6
```

#### **9.6.2 智能协议**

这个HTTP方法是很简单但效率不是很高。使用智能协议是传送数据的更常用的方法。这些协议在远端都有Git智能型进程在服务 － 它可以读出本地数据并计算出客户端所需要的，并生成合适的数据给它，这有两类传输数据的进程：一对用于上传数据和一对用于下载。

##### **9.6.2.1 上传数据**

为了上传数据至远端， Git 使用 `send-pack` 和 `receive-pack` 进程。这个 `send-pack` 进程运行在客户端上，它连接至远端运行的 `receive-pack`进程。

举例来说，你在你的项目上运行了 `git push origin master`, 并且 `origin` 被定义为一个使用SSH协议的URL。 Git 会使用 `send-pack` 进程，它会启动一个基于SSH的连接到服务器。它尝试像这样透过SSH在服务端运行命令：

```
$ ssh -x git@github.com "git-receive-pack 'schacon/simplegit-progit.git'"
    005bca82a6dff817ec66f4437202690a93763949 refs/heads/master report-status delete-refs
    003e085bb3bcb608e1e84b2432f8ecbe6306e7e7 refs/heads/topic
    0000
```

这里的 `git-receive-pack` 命令会立即对它所拥有的每一个引用响应一行 － 在这个例子中，只有 `master` 分支和它的SHA值。这里第1行也包含了服务端的能力列表（这里是 `report-status` 和 `delete-refs`）。

每一行以4字节的十六进制开始，用于指定整行的长度。你看到第1行以005b开始，这在十六进制中表示91，意味着第1行有91字节长。下一行以003e起始，表示有62字节长，所以需要读剩下的62字节。再下一行是0000开始，表示服务器已完成了引用列表过程。

现在它知道了服务端的状态，你的 `send-pack` 进程会判断哪些 commit 是它所拥有但服务端没有的。针对每个引用，这次推送都会告诉对端的 `receive-pack` 这个信息。举例说，如果你在更新 `master` 分支，并且增加 `experiment` 分支，这个 `send-pack` 将会是像这样：

```
0085ca82a6dff817ec66f44342007202690a93763949 15027957951b64cf874c3557a0f3547bd83b3ff6
    refs/heads/master report-status
    00670000000000000000000000000000000000000000 cdfdb42577e2506715f8cfeacdbabc092bf63e8d refs/heads/experiment
    0000
```

这里的全'0'的SHA-1值表示之前没有过这个对象 － 因为你是在添加新的 experiment 引用。如果你在删除一个引用，你会看到相反的： 就是右边是全'0'。

Git 针对每个引用发送这样一行信息，就是旧的SHA值，新的SHA值，和将要更新的引用的名称。第1行还会包含有客户端的能力。下一步，客户端会发送一个所有那些服务端所没有的对象的一个打包文件。最后，服务端以成功(或者失败)来响应：

```
000Aunpack ok
```

##### **9.6.2.2 下载数据**

当你在下载数据时， `fetch-pack` 和 `upload-pack` 进程就起作用了。客户端启动 `fetch-pack` 进程，连接至远端的 `upload-pack` 进程，以协商后续数据传输过程。

在远端仓库有不同的方式启动 `upload-pack` 进程。你可以使用与 `receive-pack` 相同的透过SSH管道的方式，也可以通过 Git 后台来启动这个进程，它默认监听在9418号端口上。这里 `fetch-pack` 进程在连接后像这样向后台发送数据：

```
003fgit-upload-pack schacon/simplegit-progit.git\0host=myserver.com\0
```

它也是以4字节指定后续字节长度的方式开始，然后是要运行的命令，和一个空字节，然后是服务端的主机名，再跟随一个最后的空字节。 Git 后台进程会检查这个命令是否可以运行，以及那个仓库是否存在，以及是否具有公开权限。如果所有检查都通过了，它会启动这个 `upload-pack` 进程并将客户端的请求移交给它。

如果你透过SSH使用获取功能， `fetch-pack` 会像这样运行：

```
$ ssh -x git@github.com "git-upload-pack 'schacon/simplegit-progit.git'"
```

不管哪种方式，在 `fetch-pack` 连接之后， `upload-pack` 都会以这种形式返回：

```
0088ca82a6dff817ec66f44342007202690a93763949 HEAD\0multi_ack thin-pack \
    side-band side-band-64k ofs-delta shallow no-progress include-tag
    003fca82a6dff817ec66f44342007202690a93763949 refs/heads/master
    003e085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7 refs/heads/topic
    0000
```

这与 `receive-pack` 响应很类似，但是这里指的能力是不同的。而且它还会指出HEAD引用，让客户端可以检查是否是一份克隆。

在这里， `fetch-pack` 进程检查它自己所拥有的对象和所有它需要的对象，通过发送 "want" 和所需对象的SHA值，发送 "have" 和所有它已拥有的对象的SHA值。在列表完成时，再发送 "done" 通知 `upload-pack` 进程开始发送所需对象的打包文件。这个过程看起来像这样：

```
0054want ca82a6dff817ec66f44342007202690a93763949 ofs-delta
    0032have 085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7
    0000
    0009done
```

这是传输协议的一个很基础的例子，在更复杂的例子中，客户端可能会支持 `multi_ack` 或者 `side-band` 能力；但是这个例子中展示了智能协议的基本交互过程。

### **9.7 维护及数据恢复**

你时不时的需要进行一些清理工作 ── 如减小一个仓库的大小，清理导入的库，或是恢复丢失的数据。本节将描述这类使用场景。

#### **9.7.1 维护**

Git 会不定时地自动运行称为 "auto gc" 的命令。大部分情况下该命令什么都不处理。不过要是存在太多松散对象 (loose object, 不在 packfile 中的对象) 或 packfile，Git 会进行调用 `git gc` 命令。 `gc` 指垃圾收集 (garbage collect)，此命令会做很多工作：收集所有松散对象并将它们存入 packfile，合并这些 packfile 进一个大的 packfile，然后将不被任何 commit 引用并且已存在一段时间 (数月) 的对象删除。

可以手工运行 auto gc 命令：

```
$ git gc --auto
```

再次强调，这个命令一般什么都不干。如果有 7,000 个左右的松散对象或是 50 个以上的 packfile，Git 才会真正调用 gc 命令。可能通过修改配置中的 `gc.auto` 和 `gc.autopacklimit` 来调整这两个阈值。

`gc` 还会将所有引用 (references) 并入一个单独文件。假设仓库中包含以下分支和标签：

```
$ find .git/refs -type f
    .git/refs/heads/experiment
    .git/refs/heads/master
    .git/refs/tags/v1.0
    .git/refs/tags/v1.1
```

这时如果运行 `git gc`, `refs` 下的所有文件都会消失。Git 会将这些文件挪到 `.git/packed-refs` 文件中去以提高效率，该文件是这个样子的：

```
$ cat .git/packed-refs
    # pack-refs with: peeled
    cac0cab538b970a37ea1e769cbbde608743bc96d refs/heads/experiment
    ab1afef80fac8e34258ff41fc1b867c702daa24b refs/heads/master
    cac0cab538b970a37ea1e769cbbde608743bc96d refs/tags/v1.0
    9585191f37f7b0fb9444f35a9bf50de191beadc2 refs/tags/v1.1
    ^1a410efbd13591db07496601ebc7a059dd55cfe9
```

当更新一个引用时，Git 不会修改这个文件，而是在 `refs/heads` 下写入一个新文件。当查找一个引用的 SHA 时，Git 首先在 `refs` 目录下查找，如果未找到则到 `packed-refs` 文件中去查找。因此如果在 `refs` 目录下找不到一个引用，该引用可能存到 `packed-refs` 文件中去了。

请留意文件最后以 `^` 开头的那一行。这表示该行上一行的那个标签是一个 annotated 标签，而该行正是那个标签所指向的 commit 。

#### **9.7.2 数据恢复**

在使用 Git 的过程中，有时会不小心丢失 commit 信息。这一般出现在以下情况下：强制删除了一个分支而后又想重新使用这个分支，hard-reset 了一个分支从而丢弃了分支的部分 commit。如果这真的发生了，有什么办法把丢失的 commit 找回来呢？

下面的示例演示了对 test 仓库主分支进行 hard-reset 到一个老版本的 commit 的操作，然后恢复丢失的 commit 。首先查看一下当前的仓库状态：

```
$ git log --pretty=oneline
    ab1afef80fac8e34258ff41fc1b867c702daa24b modified repo a bit
    484a59275031909e19aadb7c92262719cfcdf19a added repo.rb
    1a410efbd13591db07496601ebc7a059dd55cfe9 third commit
    cac0cab538b970a37ea1e769cbbde608743bc96d second commit
    fdf4fc3344e67ab068f836878b6c4951e3b15f3d first commit
```

接着将 `master` 分支移回至中间的一个 commit：

```
$ git reset --hard 1a410efbd13591db07496601ebc7a059dd55cfe9
    HEAD is now at 1a410ef third commit
    $ git log --pretty=oneline
    1a410efbd13591db07496601ebc7a059dd55cfe9 third commit
    cac0cab538b970a37ea1e769cbbde608743bc96d second commit
    fdf4fc3344e67ab068f836878b6c4951e3b15f3d first commit
```

这样就丢弃了最新的两个 commit ── 包含这两个 commit 的分支不存在了。现在要做的是找出最新的那个 commit 的 SHA，然后添加一个指它它的分支。关键在于找出最新的 commit 的 SHA ── 你不大可能记住了这个 SHA，是吧？

通常最快捷的办法是使用 `git reflog` 工具。当你 (在一个仓库下) 工作时，Git 会在你每次修改了 HEAD 时悄悄地将改动记录下来。当你提交或修改分支时，reflog 就会更新。`git update-ref` 命令也可以更新 reflog，这是在本章前面的 "Git References" 部分我们使用该命令而不是手工将 SHA 值写入 ref 文件的理由。任何时间运行 `git reflog` 命令可以查看当前的状态：

```
$ git reflog
    1a410ef HEAD@{0}: 1a410efbd13591db07496601ebc7a059dd55cfe9: updating HEAD
    ab1afef HEAD@{1}: ab1afef80fac8e34258ff41fc1b867c702daa24b: updating HEAD
```

可以看到我们签出的两个 commit ，但没有更多的相关信息。运行 `git log -g` 会输出 reflog 的正常日志，从而显示更多有用信息：

```
$ git log -g
    commit 1a410efbd13591db07496601ebc7a059dd55cfe9
    Reflog: HEAD@{0} (Scott Chacon <schacon@gmail.com>)
    Reflog message: updating HEAD
    Author: Scott Chacon <schacon@gmail.com>
    Date: Fri May 22 18:22:37 2009 -0700

    third commit

    commit ab1afef80fac8e34258ff41fc1b867c702daa24b
    Reflog: HEAD@{1} (Scott Chacon <schacon@gmail.com>)
    Reflog message: updating HEAD
    Author: Scott Chacon <schacon@gmail.com>
    Date: Fri May 22 18:15:24 2009 -0700

    modified repo a bit
```

看起来弄丢了的 commit 是底下那个，这样在那个 commit 上创建一个新分支就能把它恢复过来。比方说，可以在那个 commit (ab1afef) 上创建一个名为 `recover-branch` 的分支：

```
$ git branch recover-branch ab1afef
    $ git log --pretty=oneline recover-branch
    ab1afef80fac8e34258ff41fc1b867c702daa24b modified repo a bit
    484a59275031909e19aadb7c92262719cfcdf19a added repo.rb
    1a410efbd13591db07496601ebc7a059dd55cfe9 third commit
    cac0cab538b970a37ea1e769cbbde608743bc96d second commit
    fdf4fc3344e67ab068f836878b6c4951e3b15f3d first commit
```

酷！这样有了一个跟原来 `master` 一样的 `recover-branch` 分支，最新的两个 commit 又找回来了。接着，假设引起 commit 丢失的原因并没有记录在 reflog 中 ── 可以通过删除 `recover-branch` 和 reflog 来模拟这种情况。这样最新的两个 commit 不会被任何东西引用到：

```
$ git branch -D recover-branch
    $ rm -Rf .git/logs/
```

因为 reflog 数据是保存在 `.git/logs/` 目录下的，这样就没有 reflog 了。现在要怎样恢复 commit 呢？办法之一是使用 `git fsck` 工具，该工具会检查仓库的数据完整性。如果指定 `--ful` 选项，该命令显示所有未被其他对象引用 (指向) 的所有对象：

```
$ git fsck --full
    dangling blob d670460b4b4aece5915caf5c68d12f560a9fe3e4
    dangling commit ab1afef80fac8e34258ff41fc1b867c702daa24b
    dangling tree aea790b9a58f6cf6f2804eeac9f0abbe9631e4c9
    dangling blob 7108f7ecb345ee9d0084193f147cdad4d2998293
```

本例中，可以从 dangling commit 找到丢失了的 commit。用相同的方法就可以恢复它，即创建一个指向该 SHA 的分支。

#### **9.7.3 移除对象**

Git 有许多过人之处，不过有一个功能有时却会带来问题：`git clone` 会将包含每一个文件的所有历史版本的整个项目下载下来。如果项目包含的仅仅是源代码的话这并没有什么坏处，毕竟 Git 可以非常高效地压缩此类数据。不过如果有人在某个时刻往项目中添加了一个非常大的文件，那们即便他在后来的提交中将此文件删掉了，所有的签出都会下载这个大文件。因为历史记录中引用了这个文件，它会一直存在着。

当你将 Subversion 或 Perforce 仓库转换导入至 Git 时这会成为一个很严重的问题。在此类系统中，(签出时) 不会下载整个仓库历史，所以这种情形不大会有不良后果。如果你从其他系统导入了一个仓库，或是发觉一个仓库的尺寸远超出预计，可以用下面的方法找到并移除大 (尺寸) 对象。

警告：此方法会破坏提交历史。为了移除对一个大文件的引用，从最早包含该引用的 tree 对象开始之后的所有 commit 对象都会被重写。如果在刚导入一个仓库并在其他人在此基础上开始工作之前这么做，那没有什么问题 ── 否则你不得不通知所有协作者 (贡献者) 去衍合你新修改的 commit 。

为了演示这点，往 test 仓库中加入一个大文件，然后在下次提交时将它删除，接着找到并将这个文件从仓库中永久删除。首先，加一个大文件进去：

```
$ curl http://kernel.org/pub/software/scm/git/git-1.6.3.1.tar.bz2 > git.tbz2
    $ git add git.tbz2
    $ git commit -am 'added git tarball'
    [master 6df7640] added git tarball
    1 files changed, 0 insertions(+), 0 deletions(-)
    create mode 100644 git.tbz2
```

喔，你并不想往项目中加进一个这么大的 tar 包。最后还是去掉它：

```
$ git rm git.tbz2
    rm 'git.tbz2'
    $ git commit -m 'oops - removed large tarball'
    [master da3f30d] oops - removed large tarball
    1 files changed, 0 insertions(+), 0 deletions(-)
    delete mode 100644 git.tbz2
```

对仓库进行 `gc` 操作，并查看占用了空间：

```
$ git gc
    Counting objects: 21, done.
    Delta compression using 2 threads.
    Compressing objects: 100% (16/16), done.
    Writing objects: 100% (21/21), done.
    Total 21 (delta 3), reused 15 (delta 1)
```

可以运行 `count-objects` 以查看使用了多少空间：

```
$ git count-objects -v
    count: 4
    size: 16
    in-pack: 21
    packs: 1
    size-pack: 2016
    prune-packable: 0
    garbage: 0
```

`size-pack` 是以千字节为单位表示的 packfiles 的大小，因此已经使用了 2MB 。而在这次提交之前仅用了 2K 左右 ── 显然在这次提交时删除文件并没有真正将其从历史记录中删除。每当有人复制这个仓库去取得这个小项目时，都不得不复制所有 2MB 数据，而这仅仅因为你曾经不小心加了个大文件。当我们来解决这个问题。

首先要找出这个文件。在本例中，你知道是哪个文件。假设你并不知道这一点，要如何找出哪个 (些) 文件占用了这么多的空间？如果运行 `git gc`，所有对象会存入一个 packfile 文件；运行另一个底层命令 `git verify-pack` 以识别出大对象，对输出的第三列信息即文件大小进行排序，还可以将输出定向到 `tail` 命令，因为你只关心排在最后的那几个最大的文件：

```
$ git verify-pack -v .git/objects/pack/pack-3f8c0...bb.idx | sort -k 3 -n | tail -3
    e3f094f522629ae358806b17daf78246c27c007b blob 1486 734 4667
    05408d195263d853f09dca71d55116663690c27c blob 12908 3478 1189
    7a9eb2fba2b1811321254ac360970fc169ba2330 blob 2056716 2056872 5401
```

最底下那个就是那个大文件：2MB 。要查看这到底是哪个文件，可以使用第 7 章中已经简单使用过的 `rev-list` 命令。若给 `rev-list` 命令传入 `--objects` 选项，它会列出所有 commit SHA 值，blob SHA 值及相应的文件路径。可以这样查看 blob 的文件名：

```
$ git rev-list --objects --all | grep 7a9eb2fb
    7a9eb2fba2b1811321254ac360970fc169ba2330 git.tbz2
```

接下来要将该文件从历史记录的所有 tree 中移除。很容易找出哪些 commit 修改了这个文件：

```
$ git log --pretty=oneline --branches -- git.tbz2
    da3f30d019005479c99eb4c3406225613985a1db oops - removed large tarball
    6df764092f3e7c8f5f94cbe08ee5cf42e92a0289 added git tarball
```

必须重写从 `6df76` 开始的所有 commit 才能将文件从 Git 历史中完全移除。这么做需要用到第 6 章中用过的 `filter-branch` 命令：

```
$ git filter-branch --index-filter \
    'git rm --cached --ignore-unmatch git.tbz2' -- 6df7640^..
    Rewrite 6df764092f3e7c8f5f94cbe08ee5cf42e92a0289 (1/2)rm 'git.tbz2'
    Rewrite da3f30d019005479c99eb4c3406225613985a1db (2/2)
    Ref 'refs/heads/master' was rewritten
```

`--index-filter` 选项类似于第 6 章中使用的 `--tree-filter` 选项，但这里不是传入一个命令去修改磁盘上签出的文件，而是修改暂存区域或索引。不能用 `rm file` 命令来删除一个特定文件，而是必须用 `git rm --cached` 来删除它 ── 即从索引而不是磁盘删除它。这样做是出于速度考虑 ── 由于 Git 在运行你的 filter 之前无需将所有版本签出到磁盘上，这个操作会快得多。也可以用 `--tree-filter` 来完成相同的操作。`git rm` 的 `--ignore-unmatch` 选项指定当你试图删除的内容并不存在时不显示错误。最后，因为你清楚问题是从哪个 commit 开始的，使用 `filter-branch` 重写自 `6df7640` 这个 commit 开始的所有历史记录。不这么做的话会重写所有历史记录，花费不必要的更多时间。

现在历史记录中已经不包含对那个文件的引用了。不过 reflog 以及运行 `filter-branch` 时 Git 往 `.git/refs/original` 添加的一些 refs 中仍有对它的引用，因此需要将这些引用删除并对仓库进行 repack 操作。在进行 repack 前需要将所有对这些 commits 的引用去除：

```
$ rm -Rf .git/refs/original
    $ rm -Rf .git/logs/
    $ git gc
    Counting objects: 19, done.
    Delta compression using 2 threads.
    Compressing objects: 100% (14/14), done.
    Writing objects: 100% (19/19), done.
    Total 19 (delta 3), reused 16 (delta 1)
```

看一下节省了多少空间。

```
$ git count-objects -v
    count: 8
    size: 2040
    in-pack: 19
    packs: 1
    size-pack: 7
    prune-packable: 0
    garbage: 0
```

repack 后仓库的大小减小到了 7K ，远小于之前的 2MB 。从 size 值可以看出大文件对象还在松散对象中，其实并没有消失，不过这没有关系，重要的是在再进行推送或复制，这个对象不会再传送出去。如果真的要完全把这个对象删除，可以运行 `git prune --expire` 命令。