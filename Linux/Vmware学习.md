### VMWare 网络配置

VMWare 提供了三种工作模式，它们是 bridged (桥接模式）、NAT (网络地址转换模式)和 host-only (主机模式)。要想在网络管理和维护中合理应用它们，你就应该先了解一下这三种工作模式。

#### bridged（桥接模式）

在这种模式下，VMWare 虚拟出来的操作系统就像是局域网中的一台独立的主机，它可以访问局域网内任何一台机器。在桥接模式下，你需要手工为虚拟系统配置 IP 地址、子网掩码，而且还要和宿主机器处于同一网段，这样虚拟系统才能和宿主机器进行通信。同时，由于这个虚拟系统是局域网中的一个独立的主机系统，那么就可以手工配置它的 TCP/IP 配置信息，以实现通过局域网的网关或路由器访问互联网。使用桥接模式的虚拟系统和宿主机器的关系，就像连接在同一个 Hub 上的两台电脑。想让它们相互通讯，你就需要为虚拟系统配置IP地址和子网掩码，否则就无法通信。

如果你想利用 VMWare 在局域网内新建一个虚拟服务器来为局域网用户提供网络服务（也就是说，让公司内网的办公电脑像访问同一个局域网网段内的其他办公电脑一样访问虚拟机），就应该选择桥接模式。　　

#### host-only（主机模式）

在某些特殊的网络调试环境中，要求将真实环境和虚拟环境隔离开，这时你就可采用 host-only 模式。在 host-only 模式中，所有的虚拟系统是可以相互通信的，但虚拟系统和真实的网络是被隔离开的。在 host-only 模式下，虚拟系统和宿主机器系统是可以相互通信的，相当于这两台机器通过双绞线互连。在 host-only 模式下，虚拟系统的 TCP/IP 配置信息（如 IP 地址、网关地址、DNS 服务器等），都是由 VMnet1 虚拟网络的 DHCP 服务器来动态分配的。

如果你想利用 VMWare 创建一个与网内其他机器相隔离的虚拟系统，进行某些特殊的网络调试工作，可以选择 host-only 模式。个人在多台电脑上安装虚拟机来学习可以选择这种模式，这种模式可以设置静态 IP，从而保证不同电脑上的虚拟机配置完全一直，虚拟机上安装的软件可以方便的迁移。

#### NAT（网络地址转换模式）

使用NAT模式，就是让虚拟系统借助NAT（网络地址转换）功能，通过宿主机器所在的网络来访问公网。也就是说，使用NAT模式可以实现在虚拟系统里访问互联网。NAT模式下的虚拟系统的 TCP/IP 配置信息是由 VMnet8 虚拟网络的 DHCP 服务器提供的，无法进行手工修改，因此虚拟系统也就无法和本局域网中的其他真实主机进行通讯，只能和宿主机进行通信。采用NAT模式最大的优势是虚拟系统接入互联网非常简单，你不需要进行任何其他的配置，只需要宿主机 器能访问互联网即可。
　　如果你想利用VMWare安装一个新的虚拟系统，在虚拟系统中不用进行任何手工配置就能直接访问互联网，建议你采用NAT模式。
　　提示:以上所提到的NAT模式下的VMnet8虚拟网络，host-only模式下的VMnet1虚拟网络，以及bridged模式下的 VMnet0虚拟网络，都是由VMWare虚拟机自动配置而生成的，不需要用户自行设置。VMnet8和VMnet1提供DHCP服务，VMnet0虚拟 网络则不提供

VMnet0：用于虚拟桥接网络下的虚拟交换机
VMnet1：用于虚拟Host-Only网络下的虚拟交换机
VMnet8：用于虚拟NAT网络下的虚拟交换机


修改网络信息

1、先把我们的ip地址设置为静态ip地址。

先去看看我们的网卡目录，

#ls /etc/sysconfig/network-scripts/



 

#vi /etc/sysconfig/network-scripts/ifcfg-ens33

修改为下面内容 

DEVICE=ens33
BOOTPROTO=static
BROADCAST=192.168.50.255
HWADDR=00:0C:29:8E:E8:C9
ONBOOT=yes
TYPE=Ethernet
IPADDR=192.168.50.12  
NETMASK=255.255.255.0
NETWORK=192.168.50.0

 HWADDR后为你的MAC地址



 

192.168.50.0网段由你的虚拟网卡决定，下面是VM虚拟网络编辑器的截图





 

 

2、修改网关配置

# vi /etc/sysconfig/network　

修改后如下：　

NETWORKING=yes
NETWORKING_IPV6=no
HOSTNAME=localhost.localdomain
GATEWAY=192.168.50.2

3、修改DNS 配置

# vi /etc/resolv.conf　

修改后如下：　

nameserver 114.114.114.114
search localdomain

114.114.114.114这个DNS未必可用，我们可以在windows系统命令提示符，使用ipconfig /all来查看可用的DNS

 

 

4.重启网络服务

　　执行命令：

　　service network restart 　或 　 /etc/init.d/network restart

 

5、启用ifconfig 命令

依赖于 net-tools 软件

# yum install -y net-tools

输入#ifconfig ，有了

 

6、CentOS自带vi编辑器，功能没有vim强大，我么再安装一个vim编辑器

# yum install -y vim-enhanced

7、CentOS7最小化安装后没有wget软件，但是以后我们会经常用到这个组件，所以我们安装一下

# yum install -y wget 

8、CentOS自带的国外源有时候会很慢，替换成国内的阿里源

先进入源的目录 
#cd /etc/yum.repos.d 
备份一下官方源 
#mv CentOS-Base.repo CentOS-Base.repo.bak 
将阿里源文件下载下来 
#wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo 
重建源数据缓存 
#yum makecache 
ok,换源完成

