## **Github验证**

### **使用SSH连接到Github**

GitHub 是最大的 Git 版本库托管商，国内比较有名的版本库托管商如开源中国的[码云](http://git.oschina.net/)，口碑也不错，网速快，但是没有Github活跃，毕竟Github是全世界的程序猿活动的舞台。

使用SSH协议可以验证到远程服务器或服务的连接。通过SSH密匙，你就可以不用每次访问Github时都输入用户名和密码。生成SSH密匙之前，可以先检查是否本机上是否已经有SSH密匙了（SSH密匙一般位于用户主目录下的`.ssh`目录下），打开Git Bash，执行：

```
$ ls -al ~/.ssh
total 38
drwxr-xr-x 1 Vincent Huang 197609    0 Jan 22 12:55 ./
drwxr-xr-x 1 Vincent Huang 197609    0 Jan 26 20:43 ../
-rw-r--r-- 1 Vincent Huang 197609 3243 Jan 21 01:18 id_rsa
-rw-r--r-- 1 Vincent Huang 197609  743 Jan 21 01:18 id_rsa.pub
```

默认情况下，公共密匙的文件名是以下下列之一：

- id\_dsa.pub
- id\_ecdsa.pub
- id\_ed25519.pub
- id\_rsa.pub

如果有（例如名为`id\_rsa.pub` 和 `id\_rsa`）就可以添加到Github等版本库托管网站了。如果没有，就必须创建一个SSH密匙。打开Git Bash执行：

```shell
$ ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
Generating public/private rsa key pair.
Enter file in which to save the key (/c/Users/Username/.ssh/id_rsa):
Created directory '/c/Users/Username/.ssh'.
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /c/Users/Vincent Huang/.ssh/id_rsa.
Your public key has been saved in /c/Users/Vincent Huang/.ssh/id_rsa.pub.
The key fingerprint is:
SHA256:PgMLyghOsRirX+Ml+7v7JmhzbIX1KQ1vdIueyteI5mM your_email@example.com
The key's randomart image is:
+---[RSA 4096]----+
|                 |
|                 |
|..               |
|.oo     o . .    |
|+o  . .oS* + .   |
|=o . ..+o B .    |
|o.o +oo.+= +     |
| . o+==.Eo= .    |
|  ..o==@=+       |
+----[SHA256]-----+
```

根据指定的邮箱作为标签来创建SSH密匙。可以指定生成，密匙的路径，直接敲回车表示使用推荐的默认路径；然后输入密码，直接敲回车表示没有密码。再次检查是否存在SSH密匙：

```
$ ls -al ~/.ssh
total 28
drwxr-xr-x 1 Vincent Huang 197609    0 Jan 26 21:49 ./
drwxr-xr-x 1 Vincent Huang 197609    0 Jan 26 21:49 ../
-rw-r--r-- 1 Vincent Huang 197609 3243 Jan 26 21:49 id_rsa
-rw-r--r-- 1 Vincent Huang 197609  748 Jan 26 21:49 id_rsa.pub
```

其中，`id_rsa`是私有密匙，而`id_rsa.pub`是公共密匙。进入SSH密匙生成的路径，使用无格式编辑器（如NotePad++）打开SSH密匙文件，复制对应的SSH密匙并添加到Github等版本库托管网站。如下图所示：

![sshkeys](https://github.com/hzxrosydawn/studynotes/blob/master/Others/appendix/sshkeys.png)

### **使用GPG密匙给标签和提交操作签名**

GPG即GNU Privacy Guard ，用来签名和验证可信赖的标签（`tag`）和提交（`commit`）。你可以生成一个GPG密匙，并将其添加到你的Github帐号。这样，你在Github上授权的标签（`tag`）和提交（`commit`）将会被Github以安全的方式验证，别人可以确信上面的改动是你本人做的。

先下载并安装[GPG命令行工具](https://www.gnupg.org/download/)，Windows下建议下载仅包含GnuPG组件的[Gpg4win-Vanilla ](https://files.gpg4win.org/gpg4win-vanilla-2.3.3.exe)，下载完成后像一般软件一样安装即可。

在生成GPG密匙之前可以检查是否已经有了GPG密匙。

```shell
$ gpg --list-secret-keys --keyid-format LONG
```

打开Git Bash，执行`gpg --gen-key`：

```shell
$ gpg --gen-key
gpg (GnuPG) 1.4.20; Copyright (C) 2015 Free Software Foundation, Inc.
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.

Please select what kind of key you want:
   (1) RSA and RSA (default)
   (2) DSA and Elgamal
   (3) DSA (sign only)
   (4) RSA (sign only)
Your selection?
RSA keys may be between 1024 and 4096 bits long.
What keysize do you want? (2048) 4096
Requested keysize is 4096 bits
Please specify how long the key should be valid.
         0 = key does not expire
      <n>  = key expires in n days
      <n>w = key expires in n weeks
      <n>m = key expires in n months
      <n>y = key expires in n years
Key is valid for? (0) 1y
Key expires at Fri Jan 26 20:46:17 2018
Is this correct? (y/N) y

You need a user ID to identify your key; the software constructs the user ID
from the Real Name, Comment and Email Address in this form:
    "Heinrich Heine (Der Dichter) <heinrichh@duesseldorf.de>"

Real name: yourname characters
Email address: youremailname@example.com
Comment: this is my home computer`s signature
You selected this USER-ID:
    "yourname characters (this is my home computer`s signature) <youremailname@example.com>"

Change (N)ame, (C)omment, (E)mail or (O)kay/(Q)uit? o
You need a Passphrase to protect your secret key.

We need to generate a lot of random bytes. It is a good idea to perform
some other action (type on the keyboard, move the mouse, utilize the
disks) during the prime generation; this gives the random number
generator a better chance to gain enough entropy.
.+++++
.....+++++
We need to generate a lot of random bytes. It is a good idea to perform
some other action (type on the keyboard, move the mouse, utilize the
disks) during the prime generation; this gives the random number
generator a better chance to gain enough entropy.
.....................+++++
....+++++
gpg: key 5C3457F2 marked as ultimately trusted
public and secret key created and signed.

gpg: checking the trustdb
gpg: 3 marginal(s) needed, 1 complete(s) needed, PGP trust model
gpg: depth: 0  valid:   1  signed:   0  trust: 0-, 0q, 0n, 0m, 0f, 1u
gpg: next trustdb check due at 2018-01-26
pub   4096R/5C3457F2 2017-01-26 [expires: 2018-01-26]
      Key fingerprint = 548D 778C 30A8 8570 4114  4580 A19E E68C 5C34 57F2
uid                 yourname charaters (this is my home computer`s signature)<youremailname@example.com>
sub   4096R/62C7AFC2 2017-01-26 [expires: 2018-01-26]
```

然后按照提示：

1. 指定密匙的算法类型，或者直接按回车键使用默认的`RSA and RSA` 类型；
2. 然后输入期望的密匙大小，推荐最大的`4096` ；
3. 然后选择密匙的有效期，这里输入`1y`（一年的有效期）；
4. 确认以上设置是否正确；
5. 然后输入用户ID信息（输入的邮箱必须是Github上验证过的邮箱），再输入密码。

再次检查是否已经有了GPG密匙：

```shell
$ gpg --list-secret-keys --keyid-format LONG
/c/Users/Username/.gnupg/secring.gpg
-----------------------------------------
sec   4096R/A19EE68C5C3457F2 2017-01-26 [expires: 2018-01-26]
uid                yourname charaters (this is my home computer`s signature)<youremailname@example.com>
ssb   4096R/CCAE904C62C7AFC2 2017-01-26
```

上面是Windows系统上的显示结果。然后执行以下命令：

```shell
$ gpg --armor --export A19EE68C5C3457F2
-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: GnuPG v1

mQINBFiJ8H......WDj7ve
HwCIG0I=
=vDKF
-----END PGP PUBLIC KEY BLOCK-----
```

> 注意，请使用你自己的GPG密匙ID，这里的GPG密匙ID是上面检查输出结果中横线分隔行下面的`A19EE68C5C3457F2`）

然后复制得到的GPG密匙（在-----BEGIN PGP PUBLIC KEY BLOCK-----到-----END PGP PUBLIC KEY BLOCK-----之间的内容），粘贴到你的Github上。如下图所示：

![gpgkeys](https://github.com/hzxrosydawn/studynotes/blob/master/Others/appendix/gpgkeys.png)

