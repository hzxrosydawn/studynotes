##**1.安装JAVA开发环境**
 因为Android本地开发使用的是JAVA语言，所以首先要安装JAVA开发环境。到Oracle的官方网站上可以下载到最新版本的JDK，根据开发平台选择对应的最新JDK。
 下载地址：http://www.oracle.com/technetwork/java/javase/downloads/index.html
![这里写图片描述](http://img.blog.csdn.net/20161126120154856)
点击Java SE Downloads，然后选择Accept License Agreement之后，根据开发平台选择对应的最新JDK：
![这里写图片描述](http://img.blog.csdn.net/20161126110753763)
32位Linux平台的Windows选择Linux x86，64位Linux平台的Linux选择Linux x64，32位Windows平台的选择Windows x86，64位Windows平台的选择Windows x64。下载之后，安装即可。

**Linux平台安装JDK**：

将下载的tar.gz文件解压到任意目录，推荐/usr/share/目录下或者/home/目录下，以/usr/share/目录为例：

进入下载目录输入以下命令：

**Windows平台正常安装即可**：
![这里写图片描述](http://img.blog.csdn.net/20161126112530731)

- 开发工具：该选项是JDK的核心，包含了JDK运行所必需的命令。该选项会安装一个私有JRE，如果仅开发Java程序，就无须再安装下面的公共JRE了；
- 源代码：该选项将会安装Java核心类库的源代码；
- 公共JRE是一个独立的JRE系统，会单独安装在系统的其他路径下。公用JRE会向Internet Explorer浏览器和系统中注册java运行环境。通过这种方式，系统任何应用程序都可以使用公用JRE。由于现在在网页上执行APPLET的机会越来越少，而且完全可以选择使用JDK目录下的JRE来运行Java程序，因此没有太大必要安装公共JRE。

安装到： 建议自定义安装目录。

安装完毕后，在目录下面有五个文件夹、一个src类库源码压缩包和几个声明文件，其他五个文件夹分别是：bin、db、include、lib、 jre，db这个文件看业务需求~

bin：最主要的是编译器(javac.exe)；

db：jdk从1.6之后内置了Derby数据库，它是是一个纯用Java实现的内存数据库，属于Apache的一个开源项目。用Java实现的，所以可以在任何平台上运行；另外一个特点是体积小，免安装，只需要几个小jar包就可以运行了。

include：java和JVM交互用的头文件；

lib：常用类库

jre：Java运行环境

JVM（ Java Virtual Machine）就是我们常说的Java虚拟机，它是Java实现跨平台的最核心的部分，所有的Java程序会首先被编译为.class的类文件，这种类文件可以在虚拟机上执行，.class文件并不直接与机器的操作系统相对应，而是经过虚拟机间接与操作系统交互，由虚拟机将程序解释给本地系统执行，类似于C#中的CLR。

虽然JVM是运行Java程序的核心虚拟机，但是JVM不能单独搞定.class的执行，还需要其他的诸如类加载器、字节码校验器和大量类库。

JRE是一个包含了JVM可执行文件、设置文件、所需库文件和其他一些扩展。

JDK包含JRE，而JRE包含JVM，总的来说JDK是用于java程序的开发,而jre则是只能运行class而没有编译的功能，Eclipse、IntelliJ IDEA等其他IDE有自己的编译器而不是用JDK bin目录中自带的，所以在安装时只需选中jre路径就ok了。

##**2.设置JAVA环境变量**
Linux平台添加Java环境变量：

安装好后，配置环境变量：计算机——>右击——>属性——>高级系统设置设置—>环境变量：
右键此电脑——>属性： 
![这里写图片描述](http://img.blog.csdn.net/20161126113507516)
高级系统设置： 
![这里写图片描述](http://img.blog.csdn.net/20161126114446907)
环境变量： 
![这里写图片描述](http://img.blog.csdn.net/20161126114517127)
用户变量仅对对应的用户有效，系统变量对所有用户有效，这里选择系统变量。

新建系统变量

变量名：JAVA_HOME 变量值：C:\Program Files\Java\jdk1.7.0（这个是你安装JDK时的路径，按照实际情况改成你自己的目录）然后确定。

然后在系统变量里找到Classpath，没有的话新建一个。（不区分大小写）

把这个路径添加到变量值的最前面——.;%JAVA_HOME%\lib\dt.jar;%JAVA_HOME%\lib\tools.jar;

注意：最前面有一个点号和分号

然后在系统变量里找到PATH，没有的话新建一个。（不区分大小写）

把这个路径添加到变量值里面——%JAVA_HOME%\bin;%JAVA_HOME%\jre\bin;

注意，最好添加到最前面

检验JDK是否安装并配置成功

快捷键——WIN+R：输入cmd，打开命令提示符

输入java -version，回车

输入javac -version，回车

如果出现如下信息，则安装和配置成功！



一路确定，Java环境变量设置完毕。
检查Java环境变量设置是否有效：
运行Win+R快捷键调出运行窗口，输入cmd，调出命令行窗口，在输入”java -version“命令会看到java的版本信息，说明java环境变量设置成功：




##**下载Android SDK**
由于GFW对Google服务器的阻挡，已经不能直接打开Google的网站下载最新的SDK，但是我们可以在国内的一些网站上下载到各平台的SDK，如：
 http://www.androiddevtools.cn/
这里的SDK也是比较新的。即使不是最新的也可以按网站的说明选择合适的Android SDK在线更新镜像服务器升级SDK。
其中，Windows版SDK有在线安装版和直接安装版两种，根据个人喜好选择下载。 
![这里写图片描述](http://img.blog.csdn.net/20161126123059385)
如需要下载官方SDK最新版，请参考科学上网：

官方SDK下载地址：
https://developer.android.com/studio/index.html
![这里写图片描述](http://img.blog.csdn.net/20161126131204355)

Linux平台安装SDK：

Windows平台安装SDk：直接运行安装文件即可，安装时SDK自动检测出Java安装目录。

安装后选择自己所需的文件下载即可：

下载建议

最新的SDK无法下载有关版本的simples和sources，可以在 http://www.androiddevtools.cn/手动下载后添加到SDK安装目录下对应的文件夹中。


##**3.下载Eclipse或AndroidStudio（推荐）**

**下载Eclipse并安装ADT**：
可在Eclipse官网：http://Eclipse.org/下载Eclipse，然后在国内的网站http://www.androiddevtools.cn/上下载到最新的ADT并安装即可。
**或者下载安装ADT Bundle**：
ADT Bundle包含了Eclipse、ADT插件和SDK Tools，是已经集成好的IDE，只需安装好JDK即可开始开发，推荐初学者下载ADT Bundle，不用再折腾开发环境。也可以在http://www.androiddevtools.cn/上下载到ADT Bundle。但是现在Google已经不对ADT进行更新了，已经将Android开发转移到Android Studio上面了。所以建议使用Android Studio开发。
###**下载AndroidStudio（推荐）** 
在国内的网站http://www.androiddevtools.cn/上下载到各平台最新的Android Studio，或者借助科学上网自行到Android Studio官方网站：https://developer.android.com/studio/index.html下载AS，解压之后运行即可。
Linux平台AS的安装：
Windows平台AS的安装与配置：
双击android-studio-bundle-xxxxxx-windows.exe文件，选择安装组件：
![这里写图片描述](http://img.blog.csdn.net/20161126133732070)
Android SDK：由于前面我们已经安装了SDK，所以这里选择不再安装SDK。
Android Virtual Device是Android开发的虚拟机，现在的新版虚拟镜像都是基于X86架构的，运行速度比较快，如果你的电脑支持加速功能，那么推荐安装。也可以选择另一款号称最快的Android模拟器：Genymotion。
关于Genymotion的安装，参考：

接下来选择SDK：由于之前已经安装了SDK，所以选择已安装SDK的路径。
如果之前没有安装SDK，也可以选择Install the latest Android SDK选项，会在线安装最新的SDK。但是由于GFW，可能不能下载，参考：http://www.androiddevtools.cn/上的说明选择合适的Android SDK在线更新镜像服务器，或者借助科学上网。 
![这里写图片描述](http://img.blog.csdn.net/20161126133821102)
安装完，或者绿色版解压完，别慌着的打开Android Stduio。建议先配置Android Studio的缓存路径。
###**配置Android Studio的缓存路径**：
这部分参考：http://www.jianshu.com/p/fc03942548cc#
缓存文件主要是存放一些AndroidStudio设置和插件和项目的缓存信息的，这也是为什么Android Stduio启动速度比Eclipse快的部分原因，但缺点是第一次建立缓存会比较慢。缓存文件夹如图：

为什么要配置这个文件呢？因为这个缓存文件夹是默认在磁盘中，随着你项目的增多，缓存会越来越大。甚至会达到几G的大小，所以最好移到非系统盘，也方便以后重装系统时，没必要的迁移。什么？你用的是固态硬盘，怕转移缓存文件后拖慢AS的启动速度，那么还是不要转移到机械硬盘分区了，那就转移到固态硬盘的分区吧，放在AS的安装路径之外就行了。

下面来介绍改缓存路径的方法，找到Android Studio根目录，进入bin,再找到idea.properties，以文本编辑器打开并修改它，找到要修改的选项，去掉前面的#，也就是注释符号。然后修复后面的配置路径，图片就是我改好的：
![这里写图片描述](http://img.blog.csdn.net/20161126143046315)
如图中所示，我把缓存路径改到了C盘（我的系统和软件都安装在固态硬盘上了，所以放在了C盘以追求启动速度），插件目录我改到AS的根目录，主要为了以后方便打包。
还有提醒一下，由于windows的路径是\而这个配置文件的路径符号是/,大家注意区分。
缓存路径，改完了，该是打开Android Studio 的时候了。进入以下路径D:\android-studio\bin，找到studio.exe，由于我系统是64位的，我打开的studio64.exe。
![这里写图片描述](http://img.blog.csdn.net/20161126143307002)
第一个选项是以前已经安装或者使用过的导入前面所提到的ASCache文件夹，导入就可以恢复配置和项目缓存，没有的话就选择第二个吧。点OK之后就是这个样子了。
![这里写图片描述](http://img.blog.csdn.net/20161126143433336)
在新建一个项目之前，这里先普及Android Studio和Eclipse在某些概念不同的地方。Android Studio 中，有一些概念是和 Eclipse 不同的，从 Eclipse 迁移至 Android Studio 会有很多上手不顺的情况发生，当然在明确了概念的不同之后，还是容易可以切换过来。
| 对比   | Eclipse    | Android Studio    |
| ---- | ---------- | ----------------- |
| 工作区  | workspace  | project           |
| 项目   | project    | module            |
| 引用   | preference | module dependency |
简单的来说，android Stduio，把一个项目比喻成一个工程的一个个模块，外部的依赖也是一个个模块，这样一个项目的结构就很清晰明了。当然也有一个缺点，就是一个窗口只能打开一个project,不能像Eclipse那样一次一个窗口打开多个项目。
另外，**新版AS可以导入以前的Eclipse项目哦！**

###**设置字体和配色**
是不是觉得白色太亮瞎，字体和配色都太丑，没关系，接下来自定义字体和配色。
这里有很多种配色方案文件：
http://color-themes.com/
导入颜色和字体的配置文件：File->Import Settings->选择下载的配色的.jar文件->重启AS。
但还是有一些地方是白色，那是因为主题没有修改。设置主题：File->Settings->Appearance & Behavior->Appearace-> UI Options->Theme ->下拉选择Darcula->重启AS。
这时候发现编辑器代码字体很小，设置编辑器的颜色和字体：File->Settings->Editor->Colors & Fonts->Scheme->下拉选择sublimeMonoKai，点击OK，效果如图：
![这里写图片描述](http://img.blog.csdn.net/20161126150549249)
sublimeMonoKai配色是sublime Text上经典的配色。

总结：
搭建Android开发环境主要分为三个步骤： 
安装JDK并配置环境变量 
安装Android SDK并更新 
安装IDE（Eclipse、AS） 
主要由于国内网络环境不好，部分软件下载受阻或者很慢，这个时候就要考虑国内的镜像来安装或更新，加快更新速度。