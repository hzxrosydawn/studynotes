---
typora-root-url: ./
typora-copy-images-to: appendix
---

## eclipse基本配置

显示行号

Window -> Preferences -> General -> Editors -> Text Editors -> Show line numbers

### 添加 javadoc

1. Window→Pereferences，打开参数选择对话框，展开Java节点，单击“Installed JREs"，此时右边窗口会显示已经加载的jre；



2. 选中要设置的jre版本，单击"Edit"，弹出JRE编辑窗口；



3. 添加 javadoc：将JRE system libraries下的所有包选中，单击右边的“Javadoc Location”按钮，弹出javadoc设置窗口。选择“Javadoc URL”单选框，单击“Browse”按钮，选中docs/api目录，然后点击“OK”。

### 添加 source

1. 点击 “Window”→“Preferences”→“Java”→“Installed JRES”；
2. 此时“Installed JRES”右边是列表窗格，列出了系统中的 JRE 环境，选择你的JRE，然后点边上的“Edit...”， 会出现一个窗口(Edit JRE)；
3. 选中rt.jar文件的这一项：“C:\Program files\java\jre1.5.006\lib*.jar” ，点 左边的“+” 号展开它；

4. 展开后，可以看到“Source Attachment:(none)”，点这一项，点右边的按钮“Source Attachment...”, 选择你的JDK目录下的 “src.zip”文件；
5. 一路点"ok",结束。


在添加好了javadoc与source后，在Eclipse中，使用快捷键“Shift+F2”，可快速调出选中类的API文档；使用快捷建F3（或在类上点击右键，现在查看声明），可打开类的源文件。

### 配置主题

1. 打开 “Help”→”Eclipse Marketplace“, 如下图： 

   ​

2. 接着在Eclipse Marketplace中搜索”Color Eclipse Themes“，让后安装"Eclipse Color Theme”就行了， 如下图：



3. 打开偏好设置（Preferences）（mac上按"Cmd+，"就可以了）, 设置你所喜欢的theme， 如下图：

http://www.eclipsecolorthemes.org/

### 添加 jar 包的源码

1. 以 Servlet 的 jar 包为例。首先下载 Servlet 源码文件：http://tomcat.apache.org/download-90.cgi，我下载的文件名为”apache-tomcat-9.0.0.M17-src.zip“

![Servlet_Source_Code](appendix/Servlet_Source_Code.png)

2. 点击 “Window”→“Preferences”→“Java”→“Installed JRES”→“Edit”→“Add External JARs”，选择下载好的“apache-tomcat-9.0.0.M17-src.zip”即可。

### 修改拼写检查规则

1. 在使用spelling功能时请导入词典库(一个txt文档，每行一个单词).。如果需要素材,，可到[Kevin's Word List on Sourceforge.net]()上获取。不过若是觉得在这上面寻找麻烦,，也可以使用[作者上传的词库](http://www.javalobby.org/images/postings/rj/eclipse_spelling/dictionary.txt)。将该页面打开, 可以看到一行行词汇， 将他们全部复制保存到txt文档中,，然后在Eclipse中导入就可以了。你也可以添加自己的词汇。
2. 在使用过程中，Eclipse会在拼写错误的单词下面显示红色的波浪线,，这时你只要按下Ctrl+1就可以看到供选择的匹配项。不过Eclipse在最佳匹配这方面做得差强人意,，大伙就将就下吧。


### 更改文件编码和换行符

为了避免数据库的查询出现乱码和错误，需要将文件的编码格式改为UTF-8。点击 “Window”→“Preferences”→“General”→“Workspace”，将下面的“Text file encoding”框里的单选按钮改为“Other：UTF-8”，将“New text file line delimiter”框里的单选按钮改为“Other：Unix”。

![eclipse_enconding](appendix/eclipse_enconding.png)

### 设置自动添加Javadoc注释

点击 “Window”→“Preferences”→“Java”→“Code Templates”（或者直接在Preferences中直接搜索“Code Templates”）。找到Comments。该目录下就是有关注释的相关代码风格设置，这里有各种类型，字段，类型，构造方法以及继承的方法，这里面已经是系统默认的注释，你可以点击Edit按钮自行定义，现在重要的是点击下面的勾选按钮进行勾选，然后应用设置即可使用默认的设置。



![Eclipse5](appendix/Eclipse5.png)

![Eclipse6](appendix/Eclipse6.png)

### Eclipse插件安装

Eclipse插件安装方法大体有以下四种：

**一、直接复制法**

假设 Eclipse 的安装目录在 C:\eclipse，解压下载的 eclipse 插件或者安装 eclipse 插件到指定目录 AA（如：C:\AA）文件夹，打开 AA 文件夹，在 AA 文件夹里分别包含两个文件夹 features 和 plugins，然后把两个文件夹里的文件分别复制到 C:\eclipse 文件夹中所对应的 features 和 plugins 中，一般的把插件文件直接复制到 eclipse 目录里是最直接也是最愚蠢的一种方法！因为日后想要删除这些插件会非常的困难，不推荐使用。

> 注意：直接将插件包解压到 plugins 文件夹下之后，重启eclipse，可能不会加载新的插件。

解决方法是：

1. 打开命令行，到当前 eclipse 的目录下，输入 eclipse -clean，重新启动 eclipse，这样 eclipse 就会加载新的插件了；
2. 如果插件不能生效，则请将 eclipse\configuration\org.eclipse.update 目录删除后再启动 eclipse。

你可以在 eclipse 的菜单“Help”→“About Eclipse SDK”→“Feature Details”和“Plug-in Details”中看到新安装的插件。

**二、使用 link 文件法**

1. 假设 Eclipse 的安装目录在 C:\eclipse，在该文件夹下，新建这样的目录结构C:\eclipse\PluginsEclipse\jode\eclipse 。
2. 解压下载的 eclipse 插件或者安装 eclipse 插件到指定目录 BB（如：C:\BB）文件夹，打开 BB 文件夹，然后把 BB 文件夹里的两个文件夹 features 和 plugins 复制到刚刚新建好C:\eclipse\PluginsEclipse\jode\eclipse，这样 eclipse 中就有了两个插件目录 features 和 plugins 。
3. 在 C:\eclipse 目录中新建 links（C:\eclipse\links）目录，在 links 目录中建立一个以 link 为扩展名的文本文件如 jode.link，内容如下 path=C:/eclipse/PluginsEclipse/jode 或者 path=C:\\eclipse\\PluginsEclipse\\jode（插件的目录），保存后重启 eclipse 插件就会安装完成。

> 注意：link 文件中 path=插件目录的 path 路径分隔要用\\或是/。

**三、使用 eclipse 自带图形界面安装**

选择“Help”→“Software Updates”→“Manager Configuration”，再选择“Add”→“Extension Location”，找到你要安装插件的目录就可以了。使用 Eclipse 的“Help”→“SoftwareUpdates”→“Find and install”→“Search for new features”，输入软件安装地址进行安装强烈推荐这种方法，优点很多比如可以方便的添加删除，也不用自己写 link 文件！

第二种和第三种方法所指向的目录都指的是 eclipse 的安装目录。如果用第三种方法，在 eclipse 这个目录下必须有文件 .eclipseextension，如果下载的插件没有这个文件，那就随便 eclipse 安装目录下的那个文件拷过去就行，只有有这么个文件就可以了，内容没什么用，主要是一些版本信息。例如：

```
id=org.eclipse.platform name=Eclipse Platform
version=3.1.1
id=org.eclipse.platform name=Eclipse Platform version=3.1.1
```

**四、使用 dropins 安装插件**

从 eclipse 3.5 开始，安装目录下就多了一个 dropins 目录。只要将插件解压后拖到该目录即可安装插件。

比如安装 svn 插件 subclipse-1.8.16.zip，只需要如下的三步即可：

1、使用 winrar 等压缩软件将压缩包解压至某一文件夹，比如 subclipse-1.8.16

2、将此目录移动/复制至 Eclipse 安装目录下的 dropins 目录

3、重启 eclipse 。

由于此种安装方式可以将不同的插件安装在不同的目录里，并且不用麻烦地写配置文件，因此管理起来会非常方便，推荐使用。

### 安装 Vim 插件

在 eclipse 中使用 vi 模式的插件 viplugin：

点击 Eclipse中 的“Help”→“Install New Software”→“Add”，添加网址 [http://www.viplugin.com/](http://www.viplugin.com/)。然后点击 OK后，将搜索出的插件选项全部选上后点击 Next，然后选择 Accept ，最后点击 Finish。安装完成后重启 Eclipse，重启后会提示找不到路径中的文件。这是因为此插件需要收费，可以破解。破解步骤如下：

1、在 eclipse 根目录下建立名为 viPlugin2.lic 的文件。并使用记事本打开，将以下字符串插入其中：

```
q1MHdGlxh7nCyn_FpHaVazxTdn1tajjeIABlcgJBc20
```

2、重启 Eclipse viplugin 已经破解。



Eclipse导入工程后工程上显示一个小红叉，但工程里没有文件错误，也没有语法错误，百思不得其解啊，后来在网上找了一些资料说是项目引用的类库路径有问题。【项目】->【右键】->【build path】->【configure build path】->【libraries】，查看一下引用的类库路径。网上都说是因为这里引用错误引起的，但是我在项目导入的时候做的第一件事情就是修改这里的library，因此不是这个原因。

在problems中显示错误是：Target runtime Apache Tomcat 6.0 is not defined. 在网上查了一下终于找到解决方法。方法是：在工程目录下的.settings文件夹里，打开org.eclipse.wst.common.project.facet.core.xml文件，其内容是：

```xml
<?xmlversion="1.0"encoding="UTF-8"?> 
<faceted-project> 
	<runtimename="Apache Tomcat v6.0"/> 
	<fixedfacet="jst.web"/> 
	<fixedfacet="jst.java"/> 
	<installedfacet="jst.java"version="6.0"/> 
	<installedfacet="jst.web"version="2.5"/> 
	<installedfacet="wst.jsdt.web"version="1.0"/> 
</faceted-project>
```

将其修改为：

```xml
<?xmlversion="1.0"encoding="UTF-8"?> 
<faceted-project> 
	<installedfacet="jst.java"version="6.0"/> 
	<installedfacet="jst.web"version="2.5"/> 
	<installedfacet="wst.jsdt.web"version="1.0"/> 
</faceted-project>
```

即可。