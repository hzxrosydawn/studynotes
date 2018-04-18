## 用户管理命令

### useradd 命令

useradd 命令用于 Linux 中**创建的新的系统用户。useradd 可用来建立用户帐号。帐号建好之后，再用 passwd 命令设定帐号的密码，也可以使用用 userdel 命令删除帐号。使用useradd 命令所建立的帐号保存在 /etc/passwd 文本文件中**。 在 Slackware 中，adduser 指令是个 script 程序，利用交谈的方式取得输入的用户帐号资料，然后再交由真正建立帐号的 useradd 命令建立新用户，如此可方便管理员建立用户帐号。**在 Red Hat Linux 中，adduser 命令则是 useradd 命令的符号连接，两者实际上是同一个指令**。 

**语法**

```shell
useradd (选项) (参数) 
```

**选项**

- **-c<备注>：加上备注文字。备注文字会保存在passwd的备注栏位中**； 
- -d<登入目录>：指定用户登入时的启始目录； 
- -D：变更预设值； 
- **-e<有效期限>：指定帐号的有效期限**； 
- **-f<缓冲天数>：指定在密码过期后多少天即关闭该帐号**； 
- **-g<群组>：指定用户所属的群组（主组）**； 
- **-G<群组>：指定用户所属的附加群组**； 
- **-m：自动建立用户的登入目录（CentOS 7 默认会创建）**； 
- **-M：不要自动建立用户的登入目录**； 
- **-n：取消建立以用户名称为名的群**组； 
- **-r：建立系统帐号**； 
- -s：指定用户登入后所使用的shell； 
- **-u：指定用户id**。 

**参数** 

用户名：要创建的用户名。 

**实例** 

新建用户加入组： 

```shell
useradd –g sales jack –G company,employees //-g：加入主要组、-G：加入次要组 
```

建立一个新用户账户，并设置ID：

 ```shell
useradd caojh -u 544
 ```

需要说明的是，**设定ID值时尽量要大于500，以免冲突。因为Linux安装后会建立一些特殊用户，一般0到499之间的值留给bin、mail这样的系统账号**。



### passwd命令

passwd命令用于**设置用户的认证信息，包括用户密码、密码过期时间等。系统管理者则能用它管理系统用户的密码。只有管理者可以指定用户名称，一般用户只能变更自己的密码**。 

**语法 **

passwd (选项) (参数) 

**选项 **

- **-d：删除密码，仅有系统管理者才能使用**； 
- -f：强制执行； 
- **-k：设置只有在密码过期失效后，方能更**新； 
- **-l：锁住密码**； 
- **-s：列出密码的相关信息，仅有系统管理者才能使用**； 
- **-u：解开已上锁的帐号**。

**参数 **

用户名：需要设置密码的用户名。 

**知识扩展 **

存放用户信息的文件： 

```shell
 /etc/passwd
 /etc/shadow
```

存放组信息的文件： 

```shell
/etc/group
/etc/gshadow 
```

用户信息文件分析（每项用:隔开） 

```shell
例如：jack:X:503:504:::/home/jack/:/bin/bash 
jack　　     //用户名 
X　　        //口令、密码 
503　　      //用户id（0代表root、普通新建用户从500开始） 
504　　      //所在组id
:　　        //描述 
/home/jack/　//用户主目录 
/bin/bash　　//用户缺省Shell
```

组信息文件分析 

```shell
例如：jack:!:???:13801:0:99999:7::: 
jack　　    //组名
!　　       //被加密的口令 
13801　　   //创建日期与今天相隔的天数
0　　       //口令最短位数 
99999　　   //用户口令
7　　       //到7天时提醒 
*　　       //禁用天数
*　　       //过期天数
```

**实例 **

如果是**普通用户执行passwd只能修改自己的密码。如果新建用户后，要为新用户创建密码，则用 passwd 用户名**，**注意要以root用户的权限来创建**。 

```shell
[root@localhost ~]# passwd linuxde                   		//更改或创建linuxde用户的密码； 
Changing password for user linuxde. New UNIX password:      //请输入新密码；Retype new UNIX password:                                  				 //再输入一次； 
passwd: all authentication tokens updated successfully.     //成功；
```

**普通用户如果想更改自己的密码，直接运行passwd即可**，比如当前操作的用户是linuxde。 

```shell
[linuxde@localhost ~]$ passwd 
Changing password for user linuxde.                        //更改linuxde用户的密码； 
(current) UNIX password:                                   //请输入当前密码； 
New UNIX password:                                         //请输入新密码； 
Retype new UNIX password:                                  //确认新密码； 
passwd: all authentication tokens updated successfully.    //更改成功；
```

比如我们**让某个用户不能修改密码，可以用-l选项来锁定**： 

```shell
[root@localhost ~]# passwd -l linuxde                     //锁定用户linuxde不能更改密码； 
Locking password for user linuxde. passwd: Success        //锁定成功； 
[linuxde@localhost ~]# su linuxde                         //通过su切换到linuxde用户； [linuxde@localhost ~]$ passwd                             //linuxde来更改密码； 
Changing password for user linuxde. Changing password for linuxde (current) UNIX password: //输入linuxde的当前密码；
passwd: Authentication token manipulation error           //失败，不能更改密码；
```

**删除密码和查询密码状态**：

```shell
[root@localhost ~]# passwd -d linuxde                     //清除linuxde用户密码； 
Removing password for user linuxde. passwd: Success       //清除成功； 
[root@localhost ~]# passwd -S linuxde                     //查询linuxde用户密码状态； 
Empty password.                                           //空密码，也就是没有密码；
```

注意：**当我们清除一个用户的密码后，登录时就无需密码**，这一点要加以注意。



### usermod命令

usermod命令用于**修改用户的基本信息**。usermod命令**不允许你改变正在线上的使用者帐号名称**。**当usermod命令用来改变user id，必须要确保这名user没在电脑上执行任何程序**。需手动更改使用者的crontab档，也需手动更改使用者的at工作档。采用NIS server须在server上更动相关的NIS设定。 

**语法**

```shell
usermod (选项) (参数) 
```

**选项**

- -c<备注>：修改用户帐号的备注文字； 
- -d<登入目录>：修改用户登入时的目录；
- -e<有效期限>：修改帐号的有效期限；
- -f<缓冲天数>：修改在密码过期后多少天即关闭该帐号；
- -g<群组>：修改用户所属的群组；
- -G<群组>；修改用户所属的附加群组；
- -l<帐号名称>：修改用户帐号名称； 
- -L：锁定用户密码，使密码无效；
- -s：修改用户登入后所使用的shell；
- -u：修改用户ID；
- -U:解除密码锁定。 

**参数**

登录名：指定要修改信息的用户登录名。 

**实例**

将newuser2添加到组staff中： 

```shell
usermod -G staff newuser2 
```

修改newuser的用户名为newuser1：

```shell
usermod -l newuser1 newuser
```

锁定账号newuser1：

```shell
usermod -L newuser1 
```

解除对newuser1的锁定：

```shell
 usermod -U newuser1
```



### chage命令

chage命令是用来**修改帐号和密码的有效期限**。 

语法

```shell
chage [选项] 用户名
```

**选项**

- **-m：密码可更改的最小天数。为零时代表任何时候都可以更改密码**。
- **-M：密码保持有效的最大天数**。
- **-w：用户密码到期前，提前收到警告信息的天数**。
- **-E：帐号到期的日期。过了这天，此帐号将不可用**。
- **-d：上一次更改的日期**。
- **-i：停滞时期。如果一个密码已过期这些天，那么此帐号将不可用**。
- **-l：例出当前的设置。由非特权用户来确定他们的密码或帐号何时过期**。 

**实例**

可以编辑`/etc/login.defs`来设定几个参数，以后设置口令默认就按照参数设定为准：

```shell
PASS_MAX_DAYS 99999
PASS_MIN_DAYS 0
PASS_MIN_LEN 5 
PASS_WARN_AGE 7 
```

当然在`/etc/default/useradd`可以找到如下2个参数进行设置：

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

**通过修改配置文件，能对之后新建用户起作用，而目前系统已经存在的用户，则直接用chage来配置**。 例如某个服务器root帐户密码策略信息如下：

```shell
[root@linuxde ~]# chage -l root 
最近一次密码修改时间 ： 	        3月 12, 2013 
密码过期时间 ：		           从不 
密码失效时间 ：                   从不 
帐户过期时间 ：           		   从不 
两次改变密码之间相距的最小天数 ： 	0 
两次改变密码之间相距的最大天数 ：	99999 
在密码过期之前警告的天数 ：		  7
```

 可以通过如下命令修改我的密码过期时间： 

```shell
[root@linuxde ~]# chage -M 60 root 
[root@linuxde ~]# chage -l root 
最近一次密码修改时间 ： 			3月 12, 2013 
密码过期时间 ： 			   	   5月 11, 2013 
密码失效时间 ：			       从不 
帐户过期时间 ：		           从不 
两次改变密码之间相距的最小天数 ：   0 
两次改变密码之间相距的最大天数 ：   60 
在密码过期之前警告的天数 ：        9 
```

然后通过如下命令设置密码失效时间： 

```shell
[root@linuxde ~]# chage -I 5 root 
[root@linuxde ~]# chage -l root 
最近一次密码修改时间 ： 		  3月 12, 2013 
密码过期时间 ： 				 5月 11, 2013 
密码失效时间 ：                 5月 16, 2013 
帐户过期时间 ：                 从不 
两次改变密码之间相距的最小天数 ： 0 
两次改变密码之间相距的最大天数 ： 60 
在密码过期之前警告的天数 ：      9
```

 从上述命令可以看到，在密码过期后5天，密码自动失效，这个用户将无法登陆系统了。



### userdel命令

userdel命令用于**删除给定的用户，以及与用户相关的文件**。**若不加选项，则仅删除用户帐号，而不删除相关文件**。 

**语法**

userdel (选项) (参数) 

**选项**

- **-f：强制删除用户，即使用户当前已登录**；
- **-r：删除用户的同时，删除与用户相关的所有文件**。

**参数** 

用户名：要删除的用户名。 

**实例**

userdel命令很简单，比如我们现在有个用户linuxde，其家目录位于/var目录中，现在我们来删除这个用户：

```shell
userdel linuxde 		//删除用户linuxde，但不删除其家目录及文件；
userdel -r linuxde 		//删除用户linuxde，其家目录及文件一并删除；
```

**请不要轻易用-r选项；它会删除用户的同时删除用户所有的文件和目录，切记如果用户目录下有重要的文件，在删除前请备份**。 其实也有最简单的办法，但这种办法有点不安全，也就是直接在`/etc/passwd`中删除您想要删除用户的记录。但最好不要这样做，`/etc/passwd`是极为重要的文件，可能您一不小心会操作失误。



### id命令

id命令可以**显示真实有效的用户ID(UID)和组ID(GID)**。**UID 是对一个用户的单一身份标识，组ID（GID）则可对应多个UID。id命令已经默认预装在大多数Linux系统中，要使用它，只需要在你的控制台输入id**。**不带选项输入id会显示使用活跃的用户**。**id使我们更加容易地找出用户的UID以GID而不必在/etc/group文件中搜寻，当我们想知道某个用户的UID和GID时id命令是非常有用的，一些程序可能需要UID/GID来运行**。

**语法**

```shell
id [-gGnru] [--help] [--version] [用户名称]
```

选项

- -g或--group：显示用户所属群组的ID；
- -G或--groups：显示用户所属附加群组的ID；
- -n或--name：显示用户，所属群组或附加群组的名称；
- -r或--real：显示实际ID；
- -u或--user：显示用户ID；
- -help：显示帮助；
- -version：显示版本信息。 

**实例**

```shell
[root@localhost ~]# id 
uid=0(root) gid=0(root) groups=0(root),1(bin),2(daemon),3(sys),4(adm),6(disk),10(wheel) 
```

解释：用户root的UID号码 = 0，GID号码 = 0。用户root是下面组的成员：

- root组GID号是：0
- bin组GID号是：1
- daemon组GID号是：2
- sys组GID号是：3
- adm组GID号是：4
- disk组GID号是：6
- wheel组GID号是：10

打印用户名、UID 和该用户所属的所有组，要这么做，我们可以使用 `-a` 选项：

```shell
[root@localhost ~]# id -a 
uid=0(root) gid=0(root) groups=0(root),1(bin),2(daemon),3(sys),4(adm),6(disk),10(wheel)
```

输出所有不同的组ID ，有效的，真实的和补充的，我们可以使用 `-G` 选项来实现： 

```shell
[root@localhost ~]# id -G 
0 1 2 3 4 6 10
```

结果只会显示GID号。你可以和`/etc/group`文件比较。

下面是`/etc/group`文件的示例内容，只输出有效的组ID，通过使用 -g 选项来只输出有效组ID：

```shell
[root@localhost ~]# id -g 
0
```

输出特定用户信息，我们可以输出特定的用户信息相关的UID和GID。只需要在id命令后跟上用户名： 

```shell
[root@localhost ~]# id www 
uid=500(www) gid=500(www) groups=500(www)
```



### finger命令

finger命令用于**查找并显示用户信息，包括本地与远端主机的用户，帐号名称没有大小写的差别。单独执行finger指令，它会显示本地主机现在所有的用户的登陆信息，包括帐号名称，真实姓名，登入终端机，闲置时间，登入时间以及地址和电话**。

**语法**

```shell
finger (选项) (参数) 
```

**选项**

- -l：列出该用户的帐号名称，真实姓名，用户专属目录，登入所用的Shell，登入时间，转信地址，电子邮件状态，还有计划文件和方案文件内容；
- -m：排除查找用户的真实姓名；
- -s：列出该用户的帐号名称，真实姓名，登入终端机，闲置时间，登入时间以及地址和电话；
- -p：列出该用户的帐号名称，真实姓名，用户专属目录，登入所用的Shell，登入时间，转信地址，电子邮件状态，但不显示该用户的计划文件和方案文件内容。

 不指定finger的选项如果提供操作者的话，缺省设为-l输出风格，否则为-s风格，注意在两种格式中，如果信息不足，都有一些域可能丢失，如果没有指定参数finger会为当前登录的每个用户打印一个条目。

**参数**

用户名：指定要查询信息的用户。 

**实例**

在计算机上使用finger：

```shell
[root@localhost root]# finger 
login Name Tty Idle Login time Office Office Phone 
root root tty1 2 Dec 18 13 
root root pts/0 1 Dec 18 13 
root root *pts/1 Dec 18 13
```

如果要查询远程机上的用户信息，需要在用户名后面接@主机名，采用用户名@主机名的格式，不过要查询的网络主机需要运行finger守护进程的支持。



## 登录管理

### logname命令

logname命令**用来显示登录时的用户名称（不一定是当前用户名称，因为登录之后可能切换了用户）**。 

语法 

```shell
logname (选项) 
```

**选项** 

--help：在线帮助； 

--vesion：显示版本信息。



### su命令

su命令用于**切换当前用户身份到其他用户身份，变更时须输入所要变更的用户帐号与密码**。 

**语法**

```shell
su (选项) (参数) 
```

**选项**

- -c<指令>或--command=<指令>：执行完指定的指令后，即恢复原来的身份；
- -f或——fast：适用于csh与tsch，使shell不用去读取启动文件； 
- -l或——login：改变身份时，也同时变更工作目录，以及HOME,SHELL,USER,logname。此外，也会变更PATH变量； 
- -m,-p或--preserve-environment：变更身份时，不要变更环境变量；
- -s或--shell=：指定要执行的shell；
- --help：显示帮助；
- --version；显示版本信息。

**参数**

用户：指定要切换身份的目标用户。 

**实例**

变更帐号为root并在执行ls指令后退出变回原使用者：

```shell
su -c ls root 
```

变更帐号为root并传入-f选项给新执行的shell：

```shell
su root -f
```

变更帐号为test并改变工作目录至test的家目录：

```shell
su -test
```



### nologin命令

nologin命令可以**拒绝用户登录系统，同时给出信息**。**如果尝试以这类用户登录，就在log里添加记录，然后在终端输出This account is currently not available信息 。一般设置这样的帐号是给启动服务的账号所用的，这只是让服务启动起来，但是不能登录系统**。 

**语法**

nologin 

**实例**

Linux禁止用户登录：

**禁止用户登录后，用户不能登录系统，但可以登录ftp、SAMBA等**。我们**在Linux下做系统维护的时候，希望个别用户或者所有用户不能登录系统，保证系统在维护期间正常运行。这个时候我们就要禁止用户登录**。  

1、禁止个别用户登录，比如禁止lynn用户登录。 

```shell
passwd -l lynn
```

这就锁定了lynn用户，这样该用户就不能登录了。 

```shell
passwd -u lynn
```

上面是对锁定的用户lynn进行解锁，用户可登录了。     

2、通过修改`/etc/passwd`文件。执行

```shell
vi /etc/passwd
```

更改为：

```shell
lynn:x:500:500::/home/lynn:/sbin/nologin
```

 该用户就无法登录了。   

3、禁止所有用户登录。

```shell
 touch /etc/nologin //除root以外的用户不能登录
```

## 工作组管理命令

### groupadd命令

**groupadd命令用于创建一个新的工作组，新工作组的信息将被添加到系统文件中。 **

**语法 **

```shell
groupadd (选项) (参数) 
```

**选项**

- -g：指定新建工作组的id；
- -r：创建系统工作组，系统工作组的组ID小于500；
- -K：覆盖配置文件“/ect/login.defs” ；
- -o：允许添加组ID号不唯一的工作组。

**参数 **

组名：指定新建工作组的组名。 

**实例 **

**建立一个新组，并设置组ID加入系统： **

```shell
groupadd -g 344 linuxde
```

**此时在/etc/passwd文件中产生一个组ID（GID）是344的项目。**



### groupdel命令

**groupdel命令用于删除指定的工作组，本命令要修改的系统文件包括/ect/group和/ect/gshadow。若该群组中仍包括某些用户，则必须先删除这些用户后，方能删除群组。 **

**语法 **

```shell
groupdel (参数) 
```

**参数** 

**组：要删除的工作组名。 **

**实例 **

```shell
groupadd damon //创建damon工作组
groupdel damon //删除这个工作组
```



### groups命令

groups命令在标准输入输出上**输出指定用户所在组的组成员**，**每个用户属于/etc/passwd中指定的一个组和在/etc/group中指定的其他组**。

**语法** 

```shell
groups (选项) (参数) 
```

**选项 **

- --help：显示命令的帮助信息；
- --version：显示命令的版本信息。

**参数 **

用户名：指定要打印所属工作组的用户名。 

**实例 **

显示linux用户所属的组 

```shell
 groups linux 
 linux : linux adm dialout cdrom plugdev lpadmin admin sambashare
```



### gpasswd命令

gpasswd命令是**管理工作组文件/etc/group和/etc/gshadow的工具**。 

**语法**

gpasswd (选项) (参数)

选项

- -a：添加用户到组；
- -d：从组删除用户； 
- -A：指定管理员； 
- -M：指定组成员和-A的用途差不多； 
- -r：删除密码； 
- -R：限制用户登入组，只有组中的成员才可以用newgrp加入该组。 

**参数** 

组：指定要管理的工作组。

**实例**

如系统有个peter账户，该账户本身不是groupname群组的成员，使用newgrp需要输入密码即可。 **`gpasswd groupname` 让当前使用者暂时加入成为`groupname` 组的成员，之后该用户建立的文件的group也会是groupname。所以该方式可以暂时让当前用户建立其他的组的文件，而不是当前用户所在的组的文件。 可以使用`gpasswd groupname`设定密码，从而让知道该群组密码的人可以暂时具备groupname群组功能的**。 执行 `gpasswd -A peter users` 就可以让peter成为users群组的管理员，就可以执行下面的操作：

```shell
gpasswd -a mary users gpasswd -a allen users
```

**注意：添加用户到某一个组 可以使用 usermod -G group_name user_name 这个命令可以添加一个用户到指定的组，但是以前添加的组就会清空掉。 所以想要添加一个用户到一个组，同时保留以前添加的组时，请使用gpasswd这个命令来添加操作用户： **

```shell
gpasswd -a user_name group_name
```

