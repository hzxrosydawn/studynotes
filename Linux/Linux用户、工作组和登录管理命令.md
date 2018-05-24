---
typora-copy-images-to: ..\..\graphs\photos
typora-root-url: ..\..\graphs\photos
---

## 用户管理

### 概述

用户权限是通过创建用户时分配的用户 ID（User ID，通常缩写为 UID）来跟踪的。 UID 是数值，每个用户都有唯一的 UID，但在登录系统时用的不是 UID，而是登录名。登录名是用户用来登录系统的最长八字符的字符串（字符可以是数字或字母），同时会关联一个对应的密码。 

### /etc/passwd 文件

Linux系统使用 /etc/passwd 文件来将用户的登录名匹配到对应的UID值，该文件包含了一些与用户有关的信息。 

```shell
[root@localhost ~]# cat /etc/passwd
root:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/bin:/sbin/nologin
daemon:x:2:2:daemon:/sbin:/sbin/nologin
adm:x:3:4:adm:/var/adm:/sbin/nologin
lp:x:4:7:lp:/var/spool/lpd:/sbin/nologin
sync:x:5:0:sync:/sbin:/bin/sync
shutdown:x:6:0:shutdown:/sbin:/sbin/shutdown
halt:x:7:0:halt:/sbin:/sbin/halt
mail:x:8:12:mail:/var/spool/mail:/sbin/nologin
operator:x:11:0:operator:/root:/sbin/nologin
games:x:12:100:games:/usr/games:/sbin/nologin
ftp:x:14:50:FTP User:/var/ftp:/sbin/nologin
nobody:x:99:99:Nobody:/:/sbin/nologin
avahi-autoipd:x:170:170:Avahi IPv4LL Stack:/var/lib/avahi-autoipd:/sbin/nologin
systemd-bus-proxy:x:999:997:systemd Bus Proxy:/:/sbin/nologin
systemd-network:x:998:996:systemd Network Management:/:/sbin/nologin
dbus:x:81:81:System message bus:/:/sbin/nologin
polkitd:x:997:995:User for polkitd:/:/sbin/nologin
tss:x:59:59:Account used by the trousers package to sandbox the tcsd daemon:/dev/null:/sbin/nologin
postfix:x:89:89::/var/spool/postfix:/sbin/nologin
sshd:x:74:74:Privilege-separated SSH:/var/empty/sshd:/sbin/nologin
ntp:x:38:38::/etc/ntp:/sbin/nologin
nscd:x:28:28:NSCD Daemon:/:/sbin/nologin
tcpdump:x:72:72::/:/sbin/nologin
vincent:x:1000:1000::/home/vincent:/bin/bash
mysql:x:27:27:MySQL Server:/var/lib/mysql:/bin/false
tomcat:x:1001:1001::/home/tomcat:/bin/bash
```

**root 用户账户是 Linux 系统的管理员，固定分配给它的 UID 是 0**。就像上例中显示的， Linux 系统会为各种各样的功能创建不同的用户账户，而这些账户并不是真的用户。这些账户叫作**系统账户（System Account）**，是系统上运行的各种服务进程访问资源用的特殊账户。所有运行在后台的服务都需要用一个系统用户账户登录到 Linux 系统上。 

在安全成为一个大问题之前，这些服务经常会用 root 账户登录。遗憾的是，如果有非授权的用户攻陷了这些服务中的一个，他立刻就能作为 root 用户进入系统。为了防止发生这种情况，现在运行在 Linux 服务器后台的几乎所有的服务都是用自己的账户登录。这样的话，即使有人攻入了某个服务，也无法访问整个系统。

Linux 为系统账户预留了 500 以下的 UID 值。有些服务甚至要用特定的 UID 才能正常工作。为 普通用户创建账户时，大多数Linux 系统会从 500 开始，将第一个可用 UID 分配给这个账户（并非所有的 Linux 发行版都是这样）。

![passwd-file-791527](/passwd-file-791527-1524573203444.png)

/etc/passwd 文件的字段包含了如下信息：

- 登录用户名
- 用户密码
- 用户账户的 UID（数字形式）
- 用户账户的组 ID（GID）（数字形式）
- 用户账户的文本描述（称为备注字段）
- 用户 home 目录的位置
- 用户的默认 shell

/etc/passwd 文件中的密码字段都被设置成了 x，这并不是说所有的用户账户都用相同的密码。在早期的 Linux 上，/etc/passwd 文件里有加密后的用户密码。但鉴于很多程序都需要访问 /etc/passwd 文件获取用户信息，这就成了一个安全隐患。随着用来破解加密密码的工具的不断演进，用心不良的人开始忙于破解存储在 /etc/passwd 文件中的密码。 Linux 开发人员需要重新考虑这个策略。

现在，绝大多数 Linux 系统都将用户密码保存在另一个单独的文件中（叫作 shadow 文件，位置在 /etc/shadow）。只有特定的程序（比如登录程序）才能访问这个文件。

/etc/passwd 是一个标准的文本文件。你可以用任何文本编辑器在 /etc/password 文件里直接手动进行用户管理（比如添加、修改或删除用户账户）。但这样做极其危险。如果 /etc/passwd 文件出现损坏，系统就无法读取它的内容了，这样会导致用户无法正常登录（即便是 root 用户）。用标准的 Linux 用户管理工具去执行这些用户管理功能就会安全许多。 

### /etc/shadow 文件

/etc/shadow 文件对 Linux 系统密码管理提供了更多的控制。只有 root 用户才能访问 /etc/shadow 文件，这让它比起 /etc/passwd 安全许多。

/etc/shadow 文件为系统上的每个用户账户都保存了一条记录。记录就像下面这样：

```
vincent :  $6$5H0QpwprRiJQR19Y$bXGOh7dI.  :  16431  :  0  :  99999  :  7  :   :   :
|---1---|---------------2-----------------|----3----|--4--|----5----|--6--|-7-|-8-|
```

在 /etc/shadow 文件的每条记录中都有 9 个字段：

- 与 /etc/passwd 文件中的登录名字段对应的登录名（如上面的 `vincent`）；
- 加密后的密码（如上面的 `$6$5H0QpwprRiJQR19Y$bXGOh7dI.`）。原密码应该最少 8-12 个字符串，包括特殊字符、数值、小写字母等。一般密码格式为 `$id$salt$hashed` ，`$id` 为 GNU/Linux 所用的算法：
  1. ` $1$ ` 为 MD5
  2. `$2a$` 为 Blowfish
  3. `$2y$` 为 Blowfish
  4. `$5$` 为 SHA-256
  5. `$6$` 为 SHA-512
- 自上次修改密码后过去的天数（自 1970 年 1 月 1 日开始计算，如上面的 `16431`）；
- 自上次修改密码之后多少天才能再次更改密码（如上面的 `0` 表示任何时间都可以修改密码）；
- 密码的最大有效天数，这些天过去后必须修改密码（如上面的 `99999`）；
- 密码过期之前提前多少天提醒用户更改密码（如上面的 `7` 表示一整周）；
- 密码过期后多少天禁用用户账户，在此期间系统会给出密码已过期的警示（上面没有设置）；
- 用户账户被禁用的日期，用自 1970 年 1 月 1 日到当天的天数表示（上面没有设置）；
- 预留字段给将来使用。

使用 shadow 密码系统后， Linux 系统可以更好地控制用户密码。它可以控制用户多久更改一次密码，以及什么时候禁用该用户账户，如果密码未更新的话。 

### useradd 命令

`useradd` 命令用于 Linux 中**创建的新的系统用户。`useradd` 可用来建立用户帐号。帐号建好之后，再用 `passwd` 命令设定帐号的密码，也可以使用 `userdel` 命令删除帐号。使用 `useradd` 命令所建立的帐号保存在 `/etc/passwd` 文本文件中**。 在 Slackware 中，`adduser` 指令是个 `script` 程序，利用交互的方式取得输入的用户帐号资料，然后再交由真正建立帐号的 `useradd` 命令建立新用户，如此可方便管理员建立用户帐号。**在 Red Hat Linux 中，`adduser` 命令则是 `useradd` 命令的符号连接，两者实际上是同一个指令**。  

#### 语法

```shell
Usage：useradd [options] LOGIN
   or：useradd -D
   or:useradd -D [options]
```

##### 选项

```shell
-b, --base-dir BASE_DIR：如果没有指定 -d HOME_DIR，就指定默认的名为 BASE_DIR 的基目录（base directory）。该 BASE_DIR 连接用户名后生成 home 目录名。如果没有使用 -m 选项，则 BASE_DIR 必须存在。如果没有指定该选项，useradd 将会使用 /etc/default/useradd 中的 HOME 变量指定的基目录，或者以 /home 目录为基目录；
-c, --comment COMMENT：可以是任何文件字符串。一般为简单的登录描述，作为用户的备注信息，会保存在 /etc/passwd 文件的备注栏位中；
-d, --home-dir HOME_DIR：为用户指定一个名为 HOME_DIR home 目录（如果不想用登录名作为 home 目录名的话）。默认为添加到 BASE_DIR 后的 LOGIN 名。HOME_DIR 目录不一定非要存在，但会在不存在是创建出来；
-D, --defaults：看下面的“改变默认值”部分；
-e, --expiredate EXPIRE_DATE：设置该用户过期的日期。过期账户将被禁用。该日期格式为 YYYY-MM-DD。如果没有指定该选项，则会使用 /etc/default/useradd 中的 EXPIRE 变量作为默认的过期日期，或者默认为空字符串（不会过期）；
-f, --inactive INACTIVE：设置这个账户密码过期多少天后这个账户被禁用。0 表示密码一过期就立即禁用，-1 表示
禁用这个功能。如果没有指定该选项，useradd 命令将会使用 /etc/default/useradd 中的 INACTIVE 变量（意为不活动的）作为该天数，或者使用默认值 -1；
-g, --gid GROUP：设置用户的组名或组的 Id。所指定的组名必须已经存在，组的 Id 也必须指向一个已存在的组。如果没有指定该选项，useradd 命令的行为将取决于 /etc/login.defs 中的 USERGROUPS_ENAB 变量，如果该变量的值为 yes（或者在命令行指定了 -U/--user-group 选项），将会为用户创建一个与用户名相同的组。如果该变量的值为 no（或者在命令行指定了 -N/--no-user-group 选项），则将使用 /etc/default/useradd 中的 GROUP 变量作为用户的主组（primary group），或者默认为 100；
-G, --groups GROUP1[,GROUP2,...[,GROUPN]]]：设置该用户所属附加群组（supplementary groups）。每个附加群组之间以逗号分隔，中间没有空白符。这些附加群组和 -g 选项指定的组具有相同的限制条件。默认仅为用户所属的主组。
-k, --skel SKEL_DIR：设置 skeleton directory（框架目录，预存文件夹），该目录里复制了用户主目录中的文件和目录，如果 useradd 创建了主目录的话。仅当指定了 -m（--create-home）选项时该选项才有效。如果没有设置该选项。如果可能的话，也会复制访问控制表（ACLs，Access Control List）和扩展属性；
-K, --key KEY=VALUE：覆盖 /etc/login.defs 中的默认值（UID_MIN，UID_MAX，UMASK，PASS_MAX_DAYS和其他）。例如，-K PASS_MAX_DAYS=-1 可以用来在创建系统账户时会禁用密码过期功能，即使该系统账户连密码都没有。可以指定多个 -K 选项，如 -K UID_MIN=100 -K UID_MAX=499；
-l, --no-log-init：不将用户添加到 lastlog 和 faillog 数据库中。默认情况下，用户在 lastlog 和 faillog 数据库中的 entry 会重置，从而避免重用之前被删除用户用户的 entry；
-m, --create-home：创建用户的 home 目录（如果不存在的话）。skeleton directory 目录中的文件和目录（可通过 -k 选项来设置）会复制到该 home 目录中。默认情况下，如果没有设置该选项，且 CREATE_HOME 不被允许，则不会创建 home 目录；
-M, --no-create-home：不创建用户的 home 目录，即使 /etc/login.defs 系统级设置 CREATE_HOME 为 yes；
-N, --no-user-group：不创建和用户名相同的组名。但将用户添加到 -g 选项指定的组或者 /etc/default/useradd 文件中 GROUP 变量指定的组中。该选项的默认行为（如果没有指定 -g、-N 和 -U 选项）定义在 /etc/login.defs 中的 USERGROUPS_ENAB 变量里；
-o, --non-unique：允许创建重复 UID 的账户。仅在 -u 选项一起使用时才有效；
-p, --password PASSWORD：为用户账户指定默认密码。默认是禁用密码的。不推荐这种方式来设置密码，因为在用户列出执行过程时会显示出密码。确定你的密码遵循系统密码策略；
-r, --system：创建一个系统账户。系统用户创建时不会在 /etc/shadow 文件中添加 时间信息，这类用户的数值 ID 在 /etc/login.defs 中定义的 SYS_UID_MIN-SYS_UID_MAX 范围内选取，而不是从 UID_MIN-UID_MAX 范围（对应的 GID 用于创建组）选取。useradd 命令，不管 /etc/login.defs (CREATE_HOME) 的默认设置如何。如果你想为系统用户创建 home 目录，那么就指定 -m 选项；
-R, --root CHROOT_DIR：应用 CHROOT_DIR 目录的变化，且使用 CHROOT_DIR 目录中的配置文件；
-s, --shell SHELL：为用户指定默认的登录 shell。默认该值为空，系统会选择 /etc/default/useradd 中 SHELL
 变量指定的默认的登录shell，或者默认为空字符串；
-u, --uid UID：为用户指定唯一的 UID。该数值应该是唯一的，除非使用了 -o 选项。该数值必须是非负的。默认使用大于或等于 UID_MID 值、且大于每个已存在用户 ID 的最小 ID；
-U, --user-group：为用户创建一个与用户名相同的组，并将该用户添加到该组中。该选项的默认行为（如果没有指定 -g、-N 和 -U 选项）定义在 /etc/login.defs 中的 USERGROUPS_ENAB 变量里；
-Z, --selinux-user SEUSER：用于用户登录的 SELinux 用户。默认该值为空，系统会选择默认的 SELinux 用户；
-h, --help：显示帮助信息并退出。
```

##### 参数

LOGIN：要创建的用户名。 

#### 实例

1. 新建用户加入组。

```shell
useradd –g sales jack –G company,employees //-g：加入主要组、-G：加入次要组 
```

2. 建立一个新用户账户，并设置ID。

 ```shell
useradd caojh -u 544
 ```

需要说明的是，**设定ID值时尽量要大于500，以免冲突。因为Linux安装后会建立一些特殊用户，一般0到499之间的值留给bin、mail这样的系统账号**。

3. 使用 -D 选项来查看设置在 /etc/default/useradd 文件中的系统默认值。在创建新用户时，如果你不在命令行中指定具体的值， useradd 命令就会使用 -D 选项所显示的那些默认值。 

```shell
[root@localhost ~]# useradd -D
GROUP=100 				// 新用户会被添加到 GID 为 100 的公共组
HOME=/home				// 新用户的 home 目录将会位于 /home/loginname
INACTIVE=-1				// 新用户账户密码在过期后不会被禁用
EXPIRE=				    // 新用户账户未被设置过期日期
SHELL=/bin/bash			// 新用户账户将 bash shell 作为默认 shell
SKEL=/etc/skel			// 系统会将 /etc/skel 目录下的内容复制到用户的 home 目录下
CREATE_MAIL_SPOOL=yes 	 // 系统为该用户账户在 mail 目录下创建一个用于接收邮件的文件
// /etc/skel/ 目录中的文件如下，它们是 bash shell 环境的标准启动文件
[root@localhost skel]# ls -al /etc/skel/
total 20
drwxr-xr-x.  2 root root 4096 Feb 24  2017 .
drwxr-xr-x. 83 root root 4096 Mar  7 13:52 ..
-rw-r--r--   1 root root   18 Dec  7  2016 .bash_logout
-rw-r--r--   1 root root  193 Dec  7  2016 .bash_profile
-rw-r--r--   1 root root  231 Dec  7  2016 .bashrc
[root@localhost home]# useradd -m tomcat
// 为用户创建 home 目录时默认会复制 /etc/skel/ 目录中的内容到用户 home 目录中
[root@localhost home]# ls -al /home/tomcat/
total 20
drwx------  2 tomcat tomcat 4096 Apr 22 22:13 .
drwxr-xr-x. 4 root   root   4096 Apr 22 22:13 ..
-rw-r--r--  1 tomcat tomcat   18 Dec  7  2016 .bash_logout
-rw-r--r--  1 tomcat tomcat  193 Dec  7  2016 .bash_profile
-rw-r--r--  1 tomcat tomcat  231 Dec  7  2016 .bashrc

```

4. 在创建新用户账户时可以更改系统指定的默认值。但如果总需要修改某个值的话，最好还是修改一下系统的默认值。可以在 -D 选项后跟上一个指定的值来修改系统默认的新用户设置。  

```shell
// 将 tsch shell 作为所有新建用户的默认登录shell
[root@localhost home]# useradd -D -s /bin/tsch
[root@localhost home]# useradd -D
GROUP=100
HOME=/home
INACTIVE=-1
EXPIRE=
SHELL=/bin/tsch
SKEL=/etc/skel
CREATE_MAIL_SPOOL=yes
```

### userdel 命令

userdel 命令用于**删除指定的用户，以及与用户相关的文件。若不加选项，则仅删除用户帐号，而不删除相关文件**。 

#### 语法

```shell
userdel [options] LOGIN
```

##### 选项

```shell
-f, --force：强制删除用户，即使该用户仍在登录。该选项也会强制删除用户的 home 目录和 mail spool，即使其他用户在使用该 home 目录，或者指定用户不是该 mail spool （mail spool 通过在 login.defs 文件中的 MAIL_DIR 变量来定义）拥有者。如果 /etc/login.defs 中 USERGROUPS_ENAB 变量设置为 yes，且如果存在和被删除用户同名的组，那么该组也会被删除，即使该组也是其他用户的主组。注意：该选项很危险，可能会使你的系统处于不一致状态；
-r, --remove：将删除用户的整个 home 目录和用户的 mail spool。位于其他文件系统中的文件需要手动查询删除；
-R, --root CHROOT_DIR：应用 CHROOT_DIR 目录的任何改变和 CHROOT_DIR 中的配置文件；
-Z, --selinux-user：删除映射用户登录的 SELinux 用户；
-h, --help：显示帮助信息并推出。
```

##### 参数

LOGIN：要删除的用户名。 

#### 实例

userdel 命令很简单，比如我们现在有个用户 linuxde，其 home 目录位于 /var 目录中，现在我们来删除这个用户。

```shell
userdel linuxde 		// 删除用户linuxde，但不删除其家目录及文件
userdel -r linuxde 		// 删除用户linuxde，其家目录及文件一并删除
```

**请不要轻易用 -r 选项，它会删除用户的同时删除用户所有的文件和目录，切记如果用户目录下有重要的文件，在删除前请备份**。 其实也有最简单的办法，但这种办法有点不安全，也就是直接在`/etc/passwd`中删除您想要删除用户的记录。但最好不要这样做，`/etc/passwd`是极为重要的文件，可能您一不小心会操作失误。

### passwd 命令

passwd 命令用于**设置用户的认证信息，包括用户密码、密码过期时间等。系统管理者则能用它管理系统用户的密码。只有管理者可以指定用户名称，一般用户只能变更自己的密码**。 如果需要为系统中的大量用户修改密码， chpasswd 命令可以事半功倍。 chpasswd 命令能从标准输入自动读取登录名和密码对（由冒号分割）列表，给密码加密，然后为用户账户设置。你也可以用重定向命令来将含有 userid:passwd 对的文件重定向给该命令。 

#### 语法

```shell
passwd  [-k] [-l] [-u [-f]] [-d] [-e] [-n mindays] [-x maxdays] [-w warndays] [-i inactivedays] [-S]  [--stdin] [username]
```

##### 选项

```shell
-k, --keep：设置只有在密码过期失效后，方能更新。用户期望保留他们的非过期密码；
-l, --lock：锁定指定用的密码，仅 root 用户可用。通过在加密后的密码前加一个 ! 字符来使密码失效。这种锁定不是完全锁定的，用户仍可以通过其他方式（如 ssh 公钥认证）登录，使用 `chage -E 0 user` 命令替换完全的用户锁定；
	--stdin：该选项用来表明密码应该从标准输入中读取新密码，可以是一个管道；
-u, --unlock：该选项与 -l 选项相反，它会通过去除 ! 前缀来解锁帐号。该选项仅 root 用户可用。默认情况下，该命令不能创建无密码的帐号（这样它就不会去除 ! 前缀来进行解锁），-f 选项将会覆写这种保护；
-d, --delete：用于快速删除用户的密码，该用户将无密码。仅 root 用户可用；
-e, --expire：用于快速使用户的密码失效，该用户会在下次登录时被强制修改密码。仅 root 用户可用；
-f, --force：强制指定特定的选项，配合其他选项使用；
-n, --minimum DAYS：设置密码的最短有效天数，如果用户帐号支持密码有效期的话。仅 root 用户可用；
-x, --maximum DAYS：设置密码的最长有效天数，如果用户帐号支持密码有效期的话。仅 root 用户可用；
-w, --warning DAYS：设置用户提前多少天开始接收密码将要过期的警告，如果用户帐号支持密码有效期的话。仅 root 用户可用；
-i, --inactive DAYS：设置用户密码失效后，在帐号遭禁用之前的不活跃天数，如果用户帐号支持密码有效期的话。仅 root 用户可用；
-S, --status：输出用户帐号的密码状态的简短信息。仅 root 用户可用。
```

##### 参数 

username：需要设置密码的用户名。

#### 实例

1. 如果是**普通用户执行 passwd 只能修改自己的密码。如果新建用户后，要为新用户创建密码，则用 passwd 用户名**，**注意要以 root 用户的权限来创建**。 

```shell
[root@localhost ~]# passwd linuxde
Changing password for user linuxde. New UNIX password: 
password:
passwd: all authentication tokens updated successfully. 
```

2. **普通用户如果想更改自己的密码，直接运行 passwd 即可**，比如当前操作的用户是 linuxde。 

```shell
[linuxde@localhost ~]$ passwd 
Changing password for user linuxde. 
(current) UNIX password:                             
New UNIX password:                               
Retype new UNIX password:                            
passwd: all authentication tokens updated successfully.
```

3. **用 -l 选项来让某个用户不能修改密码** 。

```shell
[root@localhost ~]# passwd -l linuxde                     // 锁定用户linuxde不能更改密码； 
Locking password for user linuxde. passwd: Success        // 锁定成功； 
[linuxde@localhost ~]# su linuxde                         // 通过su切换到linuxde用户； [linuxde@localhost ~]$ passwd                             // linuxde来更改密码； 
Changing password for user linuxde. Changing password for linuxde (current) UNIX password: //输入linuxde的当前密码；
passwd: Authentication token manipulation error           // 失败，不能更改密码；
```

4. **删除密码和查询密码状态** 。

```shell
[root@localhost ~]# passwd -d linuxde    
Removing password for user linuxde. passwd: Success 
[root@localhost ~]# passwd -S linuxde               
Empty password.                               
```

> 注意：**当我们清除一个用户的密码后，登录时就无需密码**，这一点要加以注意。

### usermod 命令

usermod 命令用于**修改用户的基本信息（会改动系统账户文件）**。usermod 命令**不允许你改变正在线上的使用者帐号名称**。**当 usermod 命令用来改变 user id，必须要确保这名 user 没在电脑上执行任何程序**。usermod 命令是用户账户修改工具中最强大的一个。其参数大部分跟 useradd 命令的参数一样，它能用来修改 /etc/passwd 文件中的大部分字段，只需用与想修改的字段对应的命令行参数就可以了。  

#### 语法

```shell
usermod [options] LOGIN
```

##### 选项

```shell
-a, --append：将用户添加到附加群组（supplementary group(s)）仅和 -G 选项一起使用；
-c, --comment COMMENT：修改用户帐号的备注信息；
-d, --home HOME_DIR：指定用户新的登录目录。如果给定了 -m 选项，当前 home 目录中的内容将会移到新的 home 目录中。如果新的 home 目录不存在，则会创建它。如果当前 home 目录不存在，新的 home 目录也不会创建；
-e, --expiredate EXPIRE_DATE：设置该用户过期的日期。过期账户将被禁用。该日期格式为 YYYY-MM-DD。如果没有指定该选项，或者默认为空字符串，则不会过期。该选项需要 /etc/shadow 文件，如果该文件不存在，则会创建一个；
-f, --inactive INACTIVE：设置这个账户密码过过期多少天后这个账户被禁用。0 表示密码一过期就立即禁用，-1 表示
禁用该功能。该选项需要 /etc/shadow 文件，如果该文件不存在，则会创建一个；
-g, --gid GROUP：设置用户的组名或组 Id。所指定的组名必须已经存在，组 Id 也必须指向一个已存在的组。之前组所拥有的用户 home 目录中的文件会归新组所拥有，用户 home 目录之外的文件的属组需要手动修改；
-G, --groups GROUP1[,GROUP2,...[,GROUPN]]]：如果属于某个组的用户没有列出来，则这些用户将会从这个组移除。这种行为可以通过 -a 选项来改变（可以将用户添加到附加群组
-l, --login NEW_LOGIN：用户的登录名将从 LOGIN 改为 NEW_LOGIN，其他的都不会改变。用户的 home 目录和 mail spool 需要手动修改为新的登录名；
-L, --lock：锁定用户密码。在加密密码之前添加一个 `！` 符号来禁用密码。可以将该选项与 `-p` 和 `-U` 选项一起使用。注意：如果您希望锁定用户帐号（不仅仅是密码的访问），就应该也将 EXPIRE_DATE 设置为 1；
-m, --move-home：将用户的 home 目录移动到新的位置。该选项和 -d （或 --home）选项一起使用时才有效。如果当前的用户 home 目录不存在，将会创建新的用户 home 目录，usemod 命令会尝试采用文件的属主，复制模式、ACL 以及扩展属性，但后续可能需要手动操作；
-o, --non-unique：该选项和 -u 选项一起使用时允许将用户的 ID 改变为非唯一的。
-p, --password PASSWORD：修改密码为 PASSWORD。注意：不建议使用该选项，因为密码在用户列出进度时是可见的；
-R, --root CHROOT_DIR：应用 CHROOT_DIR 目录中的改变，使用 CHROOT_DIR 目录中的配置文件；
-s, --shell SHELL：为用户指定新的登录 shell。如果指定的程序名为空，则系统会使用默认的 shell 程序；
-u, --uid UID：为用户指定新的用户 ID。除非使用了 -o 选项，否则，该指定的 ID 必须是唯一的，其值必须是非负的。用户的邮箱，用户拥有的所有文件和用户 home 目录中的文件将会自动使用新的 ID，而用户 home 目录之外的用户文件需要手动修改。不会做任何关于 UID_MIN、UID_MAX、SYS_UID_MIN 和 SYS_UID_MAX（在/etc/login.defs 中定义） 的检查；
-U, --unlock：解锁用户密码。将会去除加密密码前面的 `!` 字符。不能和 -p 和 -l 选项一起使用。注意：如果您想解锁用户帐号（不仅仅是密码的访问），就应该也设置 EXPIRE_DATE（例如，设置为 99999，或者设置为 /etc/default/useradd 文件中定义的 EXPIRE 变量值）；
-Z, --selinux-user SEUSER：为用户的登录指定新的 SELinux 用户。SEUSER 为空时将移除用户登录时的 SELinux 用户映射。
```

##### 参数

LOGIN：指定要修改信息的用户登录名。 

#### 实例

1. 将 newuser2 添加到组 staff 中。

```shell
usermod -G staff newuser2 
```

2. 修改 newuser 的用户名为 newuser1。

```shell
usermod -l newuser1 newuser
```

3. 锁定账号 newuser1。

```shell
usermod -L newuser1 
```

4. 解除对 newuser1 的锁定。

```shell
 usermod -U newuser1
```

### chage 命令

chage 命令是用来**修改用户密码的过期信息**。 

#### 语法

```shell
chage [options] LOGIN
```

##### 选项

```shell
-d, --lastday LAST_DAY：设置上次修改密码到现在的日期。该日期可以设置为从 1970 年 1 月 1 日到上次修改日期之间的天数，也可以设置为 YYYY-MM-DD 格式的日期（或者在您所在区域更通用的格式）。如果 LAST_DAY 设置为 0，用户将在下次登录时被强制要求修改密码；
-E, --expiredate EXPIRE_DATE：设置用户帐号不可访问的日期。该日期可以设置为从 1970 年 1 月 1 日到上次修改日期之间的天数，也可以设置为 YYYY-MM-DD 格式的日期（或者在您所在区域更通用的格式）。被锁定的用户必须联系系统管理员才能再次使用系统。将 EXPIRE_DATE 值设置为 -1 将会删除过期日期；
-h, --help：显示帮助信息并退出；
-I, --inactive INACTIVE：设置密码过期到锁定账户的天数（这期间用户为不活跃状态）。被锁定的用户必须联系系统管理员才能再次使用系统。将 INACTIVE 值设置为 -1 将会解除账户的不活跃状态；
-l, --list：列出账户的时效信息；
-m, --mindays MIN_DAYS：设置密码修改之间的最小间隔天数。MIN_DAYS 值为 0 时表示用户可以随时修改其密码；
-M, --maxdays MAX_DAYS：设置密码修改之间的最大间隔天数。当 MAX_DAYS 加上 LAST_DAY 小于当前当前天数，用户将被要求修改其密码才能使用其账户，可以使用 -w 选项来提前警告用户。MAX_DAYS 值为 0 时表示用户可以随时修改其密码；将 MAX_DAYS 值设置为 -1 将会不检查密码的活跃性检查；
-R, --root CHROOT_DIR：应用 CHROOT_DIR 目录中的改变，使用 CHROOT_DIR 目录中的配置文件；
-W, --warndays WARN_DAYS：设置在密码过期之前多少天显示密码将要过期、需要修改的警告。
```

如果没有指定任何选项，chage 命令将以交互式的方式运行，提示用户当前所有字段的现有值，输入新值即可替换相关字段的当前值，或者在相关行上留白表示仍使用现有值。

##### 参数

LOGIN：指定要修改信息的用户登录名。 

实例

1. 可以编辑 `/etc/login.defs` 文件来设定几个参数，以后就可以在命令中使用这几个参数来作为某些选项的默认值。

```shell
PASS_MAX_DAYS 99999
PASS_MIN_DAYS 0
PASS_MIN_LEN 5 
PASS_WARN_AGE 7 
```

2. 在 `/etc/default/useradd` 文件中也可以找到如下几个参数进行设置。

```shell
#useradd defaults file 
GROUP=100 
HOME=/home 
INACTIVE=-1 
EXPIRE= 
SHELL=/bin/bash 
SKEL=/etc/skel 
CREATE_MAIL_SPOOL=yes
```

3. **通过修改配置文件，能对之后新建用户起作用，而目前系统已经存在的用户，则直接用 chage 来配置**。 例如某个服务器 root 帐户密码策略信息如下：

```shell
[root@localhost ~]# chage -l root
Last password change                                    : Jun 07, 2017
Password expires                                        : never
Password inactive                                       : never
Account expires                                         : never
Minimum number of days between password change          : 0
Maximum number of days between password change          : 99999
Number of days of warning before password expires       : 7
```

4.  可以通过如下命令修改密码过期时间。

```shell
[root@localhost ~]# chage -M 360 root
[root@localhost ~]# chage -l root
Last password change                                    : Jun 07, 2017
Password expires                                        : Jun 02, 2018
Password inactive                                       : never
Account expires                                         : never
Minimum number of days between password change          : 0
Maximum number of days between password change          : 360
Number of days of warning before password expires       : 7
```

5. 然后通过如下命令设置密码失效时间。

```shell
[root@localhost ~]# chage -I 60 root
[root@localhost ~]# chage -l root
Last password change                                    : Jun 07, 2017
Password expires                                        : Jun 02, 2018
Password inactive                                       : Aug 01, 2018
Account expires                                         : never
Minimum number of days between password change          : 0
Maximum number of days between password change          : 360
Number of days of warning before password expires       : 7
```

 从上述命令可以看到，在密码过期 60 天后密码自动失效，这个用户将无法登陆系统了。

### id 命令

id 命令可以**显示真实有效的用户 ID（UID）和组 ID（GID）。** UID 是对一个用户的单一身份标识，组 ID（GID）则可对应多个 UID。id 命令已经默认预装在大多数 Linux 系统中，要使用它，只需要在你的控制台输入 id**。**不带选项输入 id 会显示使用活跃的用户**。**id 使我们更加容易地找出用户的 UID 以及 GID，而不必在 /etc/group 文件中搜寻，当我们想知道某个用户的 UID 和 GID 时 id 命令是非常有用的，一些程序可能需要 UID/GID 来运行。

#### 语法

```shell
 id [OPTION]... [USER]
```

##### 选项

```shell
-a：
-Z, --context：仅打印当前用户的安全信息（security context）；
-g, --group：仅打印有效的组 ID；
-G, --groups：打印所有组 ID；
-n, --name：打印名称而不是数字 ID，用于 -ugG 选项；
-r, --real：打印真实 ID 而不是有效 ID（使用 -ugG 选项）。
-u, --user：仅打印有效的用户 ID；
-z, --zero：以 NUL 字符而不是空白符来分隔条目。默认格式中不可用；
    --help：显示帮助信息并退出；
    --version：输出版本信息并退出。
```

##### 参数

USER：待查看 ID 的用户名。如果不指定用户名，则显示当前用户的 ID 信息。

#### 实例

1. 不使用任何选项和参数。

```shell
[root@localhost ~]# id 
uid=0(root) gid=0(root) groups=0(root),1(bin),2(daemon),3(sys),4(adm),6(disk),10(wheel) 
```

解释： root 用户的 UID  = 0，GID 号码 = 0。root 用户是下面组的成员：

- root 组 GID 号是：0
- bin 组 GID号是：1
- daemon 组 GID 号是：2
- sys 组 GID 号是：3
- adm 组 GID 号是：4
- disk 组 GID 号是：6
- wheel 组 GID 号是：10

2. 使用 `-G` 选项来输出所有不同的组 ID （有效的，真实的和补充的）。结果只会显示 GID 号。

```shell
[root@localhost ~]# id -G
0 1 2 3 4 6 10
```

3. 在 id 命令后跟上用户名来输出特定用户信息。 

```shell
[root@localhost ~]# id vincent
uid=1000(vincent) gid=1000(vincent) groups=1000(vincent)
```

### finger 命令

finger 命令用于**查找并显示用户信息，包括本地与远端主机的用户，帐号名称没有大小写的差别。单独执行 finger 指令，它会显示本地主机现在所有的用户的登陆信息，包括帐号名称，真实姓名，登入终端机，闲置时间，登入时间以及地址和电话**。出于安全性考虑，很多Linux系统管理员会在系统上禁用 finger 命令，不少 Linux 发行版甚至都没有默认安装该命令。 

#### 语法

```shell
finger [-lmsp] [user ...] [user@host ...]
```

##### 选项

```shell
-s：显示用户端的登录名，真实名，终端名，写状态（如果写权限被禁用，则在终端名后显示 `*`），idle 时间，登录时间，办公地点和办公电话。登录时间以月、日、小时和分钟显示，除非超过六个月，则显示年而不是小时和分钟。未知设备、不存在的 idle 和登录时间以单独的星号显示；
-l：以多行格式来显示 -s 选项所描述的所有信息，包括用户 home 目录，home 电话号码，登录 shell，邮箱状态和 home 目录中“.plan”，“.project”，“.pgpkey”和“.forward”文件中的内容；
-p：阻止 -l 选项输出“.plan”, “.project” and “.pgpkey”文件中的内容；
-m：阻止匹配用户名。用户一般是一个登录名，匹配也可以适用于用户的真实名称。匹配是区分大小写的；
```

如果没有指定任何选项，如果提供操作数（operand）的话，finger 命令默认为 -l 输出风格，否则为 -s 风格。注意在两种格式中，如果信息不足，都可能会有一些字段丢失。如果没有指定参数，finger 会为当前登录的每个用户打印一个条目（entry）。

finger 可用于查找远程主机上的用户。指定用户的格式为“user@host”或“@host”。不过要查询的网络主机需要运行 finger 守护进程的支持。

##### 参数

user，user@host：指定要查询信息的用户。 

#### 实例

1. 在计算机上使用 finger。

```shell
[root@localhost root]# finger 
login Name Tty Idle Login time Office Office Phone 
root root tty1 2 Dec 18 13 
root root pts/0 1 Dec 18 13 
root root *pts/1 Dec 18 13
```

## 登录管理

### logname 命令

logname 命令用来**显示当前用户名称（不一定是当前登录用户的名称，因为登录之后可能切换了用户）**。 

#### 语法 

```shell
 logname [OPTION]
```

##### 选项

```shell
--help：显示帮助并退出；
--vesion：显示版本信息并退出。
```

### su 命令

su（switch user） 命令用于**切换当前用户身份到其他用户身份，变更时须输入所要变更的用户帐号与密码**。 

#### 语法

```shell
su [options...] [-] [user [args...]]
```

##### 选项

```shell
-c, --command=command：将命令传递给 shell；执行完指定的指令后，即恢复原来的身份；
    --session-command=command：同 -c 选项，但不创建新的会话（不鼓励使用该选项）；
-f, --fast：使 shell 不用去读取启动文件。适用于 csh 与 tsch；
-g, --group=group：设定主组（仅 root 用户可用）；
-G, --supp-group=group：设定附属群组（仅 root 用户可用）；
-, -l, --login：改变身份时，也同时变更工作目录，以及HOME，SHELL，USER，logname。此外，也会变更 PATH 变量；
-m, -p, --preserve-environment：变更身份时，不要变更环境变量。如果使用了 --login，该选项将被忽略；
-s, --shell=SHELL：使用指定的 shell，而不是默认的 shell。所运行 shell 的选择顺序依次为：通过 --shell 指定，SHELL 环境变量所指定的 shell（如果使用了 --preserve-environment 选项），目标用户的 passwd 条目中所列的 shell，/bin/sh。对于有受限的 shell（例如，在 /etc/shells 中没有列出的）的目标用户，--shell 选项和 SHELL 变量将会被忽略（除非是指定该命令的是 root 用户）；
    --help：显示帮助并退出；
    --vesion：显示版本信息并退出。
```

##### 参数

user：指定要切换身份的目标用户。 

#### 实例

1. 变更帐号为 root 并在执行 ls 指令后退出变回原使用者。

```shell
su -c ls root 
```

2. 变更帐号为 root 并传入 -f 选项给新执行的 shell。

```shell
su root -f
```

3. 变更帐号为 test 并改变工作目录至 test 的家目录。

```shell
su -test
```

### nologin 命令

nologin 命令可以**拒绝用户登录系统，同时给出信息**。**如果尝试以这类用户登录，就在 log 里添加记录，然后在终端输出This account is currently not available 信息 。一般设置这样的帐号是给启动服务的账号所用的，这只是让服务启动起来，但是不能登录系统**。 

**禁止用户登录后，用户不能登录系统，但可以登录 ftp、SAMBA 等。在 Linux 下做系统维护的时候，希望个别用户或者所有用户不能登录系统，保证系统在维护期间正常运行。这个时候我们就要禁止用户登录**。  

#### 实例

1. 禁止个别用户登录，比如禁止 lynn 用户登录。 

```shell
passwd -l lynn
```

这就锁定了 lynn 用户，这样该用户就不能登录了。 

```shell
passwd -u lynn
```

上面是对锁定的用户 lynn 进行解锁，用户可登录了。     

2. 通过修改`/etc/passwd`文件。执行

```shell
vi /etc/passwd
```

更改为：

```shell
lynn:x:500:500::/home/lynn:/sbin/nologin
```

 该用户就无法登录了。   

3. 禁止所有用户登录。

```shell
touch /etc/nologin //除root以外的用户不能登录
```

## 工作组管理命令

### 概述

组权限允许多个用户对系统中的对象（比如文件、目录或设备等）共享一组共用的权限。 Linux 发行版在处理默认组的成员关系时略有差异。有些 Linux 发行版会创建一个组，把所有用户都当作这个组的成员。遇到这种情况要特别小心，因为文件很有可能对其他用户也是可读的。有些发行版会为每个用户创建单独的一个组，这样可以更安全一些。 

### /etc/group 文件 

与用户账户类似，组信息也保存在系统的一个文件中。 /etc/group 文件包含系统上用到的每个组的信息。下面是一些来自Linux 系统上 /etc/group 文件中的典型例子。

```shell
root:x:0:root
bin:x:1:root,bin,daemon
daemon:x:2:root,bin,daemon
sys:x:3:root,bin,adm
adm:x:4:root,adm,daemon
rich:x:500:
mama:x:501:
katie:x:502:
jessica:x:503:
mysql:x:27:
test:x:504:
```

系统账户所用的组通常会分配低于 500 的 GID 值，而用户组的 GID 则会从 500 开始分配。 /etc/group 文件有 4 个字段：

- 组名
- 组密码
- GID
- 属于该组的用户列表

**组密码允许非组内成员通过它临时成为该组成员**。这个功能并不很普遍，但确实存在。千万不能通过直接修改 /etc/group 文件来添加用户到一个组，要用 usermod 命令。在添加用户到不同的组之前，首先得创建组。 

用户账户列表某种意义上有些误导人。你会发现，在列表中，有些组并没有列出用户。这并不是说这些组没有成员。当一个用户在 /etc/passwd 文件中指定某个组作为默认组时，用户账户不会作为该组成员再出现在 /etc/group 文件中。 

### groupadd 命令

**groupadd 命令用于创建一个新的工作组，新工作组的信息将被添加到系统文件中。 **

#### 语法

```shell
 groupadd [options] GROUP
```

##### 选项

```shell
-f, --force：使用该选项时，如果指定的组已存在则以成功状态码退出。如果 GID 已经使用，则取消 -g 选项；
-g, --gid GID：指定唯一的非负 GID，除非使用了 -o 选项。默认使用大于等于 GID_MIN 、大于其他所有组的最小的 ID 值；
-K, --key KEY=VALUE：覆盖 /etc/login.defs 中的默认值（GID_MIN，GID_MAX 等）。可以指定多个 -K 选项；
-o, --non-unique：该选项允许添加一个不是唯一的 GID；
-p, --password PASSWORD：为新组使用该加密密码。默认禁用密码。不建议使用该选项，因为在列出执行过程时密码是可视的；
-r, --system：创建一个新的系统组（System Group），数值 ID 介于 SYS_GID_MIN-SYS_GID_MAX（定义在 login.defs） 范围。
-R, --root CHROOT_DIR：应用 CHROOT_DIR 目录中中的变化，使用 CHROOT_DIR 目录中的配置文件；
-h, --help：显示帮助信息并退出。
```

##### 参数 

GROUP：指定新建工作组的组名。 

#### 实例 

建立一个新组，并设置组ID加入系统。

```shell
groupadd -g 344 linuxde
```

此时在/etc/passwd文件中产生一个组ID（GID）是344的项目。

### groupdel 命令

groupdel 命令用于删除指定的工作组，该命令要修改的系统文件包括 /ect/group 和 /ect/gshadow。若该群组中仍包括某些用户，则必须先删除这些用户后，方能删除群组。 

#### 语法 

```shell
 groupdel [options] GROUP
```

##### 选项

```shell
-R, --root CHROOT_DIR：应用 CHROOT_DIR 目录中中的变化，使用 CHROOT_DIR 目录中的配置文件；
-h, --help：显示帮助信息并退出。
```

##### 参数 

GROUP：要删除的工作组名。 

#### 实例 

```shell
groupadd damon //创建damon工作组
groupdel damon //删除这个工作组
```

### groups 命令

groups 命令会在标准输入输出上**输出指定用户所在组的组成员**。

#### 语法 

```shell
 groups [OPTION]... [USERNAME]...
```

##### 选项 

```shell
-h, --help：显示帮助信息并退出。
-version：显示版本信息并退出。
```

##### 参数 

USERNAME：指定要打印所属工作组的用户名。 

#### 实例 

显示 linux 用户所属的组 

```shell
 groups linux 
 linux : linux adm dialout cdrom plugdev lpadmin admin sambashare
```

### gpasswd 命令

gpasswd 命令是**管理工作组文件 /etc/group 和 /etc/gshadow 的工具**。 

#### 语法

```shell
 gpasswd [option] GROUP
```

##### 选项

```shell
-a, --add user:将指定的用户添加到指定的组
-d, --delete user：将指定的用户从指定的组中删除；
-Q, --root CHROOT_DIR：应用 CHROOT_DIR 目录中中的变化，使用 CHROOT_DIR 目录中的配置文件；
-r, --remove-password：从指定的组中删除密码。该组的密码将为空，只有该组的成员才可以使用 newgrp 命令登入指定的组；
-R, --restrict：限制用户登入指定的组。组密码将设置为 `!`。只有有密码的组成员才可以使用 newgrp 命令登入指定的组；
-A, --administrators user,...：指定管理员列表；
-M, --members user,...：指定组员列表；
-h, --help：显示帮助信息并退出。
```

##### 参数

GROUP：指定要管理的工作组。

#### 实例

如系统有个 peter 账户，该账户本身不是 groupname 群组的成员，使用 newgrp 需要输入密码即可。 `gpasswd groupname`  让当前使用者暂时加入成为 `groupname`  组的成员，之后该用户建立的文件的 group 也会是 groupname。所以该方式可以暂时让当前用户建立其他的组的文件，而不是当前用户所在的组的文件。 可以使用 `gpasswd groupname` 设定密码，从而让知道该群组密码的人可以暂时具备 groupname 群组功能的。 执行 `gpasswd -A peter users` 就可以让 peter 成为 users 群组的管理员。

**注意：添加用户到某一个组 可以使用 usermod -G group_name user_name 这个命令可以添加一个用户到指定的组，但是以前添加的组就会清空掉。 所以想要添加一个用户到一个组，同时保留以前添加的组时，请使用 gpasswd 这个命令来添加操作用户： **

```shell
gpasswd -a user_name group_name
```

