---
typora-copy-images-to: appendix
typora-root-url: ./
---

# Tomcat 9的安装和配置

Tomcat可以独立地作为一个服务器，单独启动、关闭，这时需要配置Tomcat的相关环境变量。

在Tomcat的安装目录中有一个“RUNNING.txt”文件，里面详细论述了如何开始使用Servlet/JSP容器Apache Tomcat（包括Tomcat依赖关系的相关细节，Tomcat可能也可以在任何满足要求的Java早期预先/抢先体验使用版（build）上工作。）：下载、安装、配置等。

配置（正常使用Tomcat所需的）环境变量：

Tomcat是一个Java程序而且不会直接用到环境变量，但Tomcat的startup脚本需要使用环境变量，该脚本使用环境变量来准备启动Tomcat的命令。

设置CATALINA_HOME（必需的）和CATALINA_BASE（可选的）：

环境变量CATALINA_HOME必须被设置为Tomcat发行版中“binary”文件的根目录位置，若缺省CATALINA_HOME，Tomcat的startup脚本将会利用其具有的一些内部逻辑推理方法，基于startup脚本在*nix系统中的位置和在Windows系统中的当前目录，自动地设置上下文相关的CATALINA_HOME变量值，但这个内部逻辑可能无法在所有情境中起作用，因此推荐明确地手动设置该变量。

环境变量CATALINA_BASE则用来指定Tomcat的“active configuration”的根目录位置，该变量是可选的，默认是跟CATALINA_HOME等值的。

为简化以后的更新和维护工作，推荐使用不同的CATALINA_HOME和CATALINA_BASE值（关于这点，它被记录在下面的“多Tomcat实例”部分）。

设置JRE_HOME或JAVA_HOME（必需的）

JRE_HOME用来指定JRE的位置，JAVA_HOME用来指定JDK的位置。当已经使用了JRE_HOME时，再使用JAVA_HOME来提供访问某些额外启动项的入口是不被允许的。若JRE_HOME和JAVA_HOME都被指定，使用的是JRE_HOME。推荐使用Tomcat的“setenv”脚本来指定这两个变量的值。

Tomcat也可以通过Eclipse来启动即在Eclipse中启动外部Tomcat服务器，这时只要Eclipse能正常使用就不再需要配置Tomcat的相关环境变量。