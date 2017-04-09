## 在Eclipse中使用Maven创建Web项目

### 1. 建立Maven Project

选择File→New→Other，在New对话框中选择Maven→Maven Project→Next。

​			      		![newmaven](https://github.com/hzxrosydawn/graphs/blob/master/photos/newmaven.png?raw=true)

### 2. 选择项目路径

勾选Use default Workspace location（使用默认工作空间）→Next。


​				    ![newmaven2](https://github.com/hzxrosydawn/graphs/blob/master/photos/newmaven2.png?raw=true) 



### 3. 选择项目类型

在Artifact Id中选择maven-archetype-webapp。

​			    ![newmaven3](https://github.com/hzxrosydawn/graphs/blob/master/photos/newmaven3.png?raw=true)      

### 4. 输入Group ID、Artifact ID以及Package

![newmaven4](https://github.com/hzxrosydawn/graphs/blob/master/photos/newmaven4.png?raw=true)

> 注意：Group Id一般写大项目名称，Artifact Id是子项目名称，Package是默认的包名，不写也可以。

刚建立好后的文件结构如下图所示。

![newmaven5](https://github.com/hzxrosydawn/graphs/blob/master/photos/newmaven5.png?raw=true)

 如果这里显示的内容多，一般是Filters设置的问题；或者Perspective为JavaEE模式，将其改成Java模式就可以了。

### 5. 配置项目

在选择maven_archetype_web原型后，如上图所示，项目中默认只有src/main/resources这个Source Floder，还需要添加src/main/java、src/test/java和src/test/resources这三个Source Floder。右键项目根目录点击New→Source Folder，建出这三个文件夹。
![newmaven6](https://github.com/hzxrosydawn/graphs/blob/master/photos/newmaven6.png?raw=true)
可能只有src/test/resources的Source Folder可以创建，
![newmaven72](https://github.com/hzxrosydawn/graphs/blob/master/photos/newmaven72.png?raw=true)
而添加src/main/java、src/test/java的Source Floder时可能会报The folder is already a source folder的错误。如下图所示。
![newmaven75](https://github.com/hzxrosydawn/graphs/blob/master/photos/newmaven75.png?raw=true)
分析原因：右键项目→Properties→Java Build Path→Source标签，会看到src/main/java， src/test/java已存在，但是后面的括号中的内容为missing。所以只需要创建目录，Source Floder应该就会出现了。
![newmaven76](https://github.com/hzxrosydawn/graphs/blob/master/photos/newmaven76.png?raw=true)
解决办法：使用Navigator视图（如果Package Explorer标签旁边没有Navigator标签，那么Preferences→Show View→Navigator即可显示Navigator标签）直接建立文件夹。比如创建src/main/java：选择Navigator视图→右键目录树中的src/main目录→New→Folder（在现有的src/main目录下直接创建java子目录），如下图所示。
![newmaven7](https://github.com/hzxrosydawn/graphs/blob/master/photos/newmaven7.png?raw=true)
![newmaven77](https://github.com/hzxrosydawn/graphs/blob/master/photos/newmaven77.png?raw=true)
最终在Package Explorer视图中要有前面说过的四个Source Folder，如下图所示。
![newmaven78](https://github.com/hzxrosydawn/graphs/blob/master/photos/newmaven78.png?raw=true)

### 6. 更改编译输出文件的存放目录

右键项目→Build Path→Configure Build Path→Source标签，
![newmaven74](https://github.com/hzxrosydawn/graphs/blob/master/photos/newmaven74.png?raw=true)
Source标签中应该有下面4个已经创建的文件夹：

- src/main/java
- src/main/resources
- src/test/java
- src/test/resources

勾选上最下面的Allow output folders for source folders复选框来允许为Source Folder创建输出文件夹。然后双击每个Source Folder文件夹下的Output folder（有的Source Folder使用最下方的Browse...按钮左边的Default output folder作为默认的编译输出文件夹），按如下规则选择输出目录：
- src/main/java和src/main/resources，选择target/classes；
- src/test/java和src/test/resources，选择target/test-classes；  

![newmaven79](https://github.com/hzxrosydawn/graphs/blob/master/photos/newmaven79.png?raw=true)

> 注意：target/classes和target/test-classes目录存放着编译输出的“.class”文件即相关配置文件，这些“.class”文件和配置文件也是按照相应的包结构存放的。

   如果需要更改文件夹显示的顺序：通过Order and Export标签进行排序即可。

   更改JRE版本：点击Libraries标签→双击JRE System Library，选择合适的（Maven构建Web工程需要使用JDK安装目录下私有JRE，即“Jdk_Installed_Directory/jre”，而不能是公共JRE，关于私有JRE和公共JRE的区别请参考Oracle官网上[关于Private Versus Public JRE的介绍](http://docs.oracle.com/javase/8/docs/technotes/guides/install/windows_jdk_install.html#CHDJCCEG)）、较新的JRE版本。

![newmaven710](https://github.com/hzxrosydawn/graphs/blob/master/photos/newmaven710.png?raw=true)

关于JRE的设置，可通过点击Installed JREs...按钮→通过Add..按钮（或Edit...按钮）来添加系统中已安装（或编辑已添加）的JRE，可以指定系统中已安装JRE的路径（JRE home）和JRE的别名（JRE name），当然也可以复制（通过Duplicate...按钮）和删除（通过Remove...按钮）已添加的JRE。如下图所示。

![newmaven711](https://github.com/hzxrosydawn/graphs/blob/master/photos/newmaven711.png?raw=true)

### 7. 把项目变成Dynamic Web项目

右键项目，选择Properties→Project Facets，点击Convert to faceted form...按钮

取消Dynamic Web Module复选框的勾选（否则更改其版本时下面会提示Cannot change version of  project facet Dynamic Web Module to X.x的错误），将其版本改为3.0（需要1.6及以上的JDK），然后将Java的版本改为1.8，点击Apply按钮。

![newmaven713](https://github.com/hzxrosydawn/graphs/blob/master/photos/newmaven713.png?raw=true)

再勾选Dynamic Web Module复选框，点击下方弹出的Further configuration available...临时按钮，在弹出的对话框中将Content directory改为src/main/webapp，同时勾选Generate web.xml deployment descriptor复选框来生成web.xml配置文件，依次点击OK、Apply和OK按钮。如下图所示。

![newmaven714](https://github.com/hzxrosydawn/graphs/blob/master/photos/newmaven714.png?raw=true)

如果提示错误，可能需要在Java Compiler设置Compiler compliance level 为1.6或更高，或者需要在此窗口的Java的Version改成1.6（Dynamic Web Module为3.0时）或更高。

### 8. 设置部署程序集(Web Deployment Assembly)

​        再次打开当前项目的Properties窗口，点击左侧列表中Deployment Assembly，此处显示的列表是，部署项目时，文件发布的路径。如下图所示。

![newmaven715](https://github.com/hzxrosydawn/graphs/blob/master/photos/newmaven715.png?raw=true)	

​      删除名称中含有test的文件夹，因为test是测试使用，并不需要部署。然后依次点击Apply和OK按钮。置完成效果如下图所示。

​						![newmaven716](https://github.com/hzxrosydawn/graphs/blob/master/photos/newmaven716.png?raw=true)      

### 9. 构建框架：在pom.xml中添加所需要的jar包（依赖和插件）

​        双击项目中的pom.xml文件，默认使用Maven POM Editor打开pom.xml文件，选择Dependencies标签，在Dependencies栏目点击Add按钮，首先弹出一个搜索按钮，例如输入javax.servlet，就会自动搜索关于servlet相关的jar包，可以很方便的地选择使用比较多的版本的jar包，还可以通过Scope来指定jar包的作用范围。如下图所示。

![newmaven718](https://github.com/hzxrosydawn/graphs/blob/master/photos/newmaven718.png?raw=true)

​        需要添加的其他jar包有：junit、jstl。或者点击pom.xml标签直接编辑pom.xml文件，这样可以直接粘贴从Maven仓库（通过Maven仓库，我们可以搜索各种版本的jar包）中复制过来dependency内容。这里给出我们的pom.xml内容：

```xml
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/maven-v4_0_0.xsd">
  <modelVersion>4.0.0</modelVersion>
  <groupId>com.rosydawn.maven.demo</groupId>
  <artifactId>maven-web-demo</artifactId>
  <packaging>war</packaging>
  <version>0.0.1-SNAPSHOT</version>
  <name>maven-web-demo Maven Webapp</name>
  <url>http://maven.apache.org</url>
  <dependencies>
    <dependency>
    	<groupId>javax.servlet</groupId>
    	<artifactId>javax.servlet-api</artifactId>
    	<version>3.1.0</version>
    </dependency>
    <dependency>
    	<groupId>javax.servlet</groupId>
    	<artifactId>jstl</artifactId>
    	<version>1.2</version>
    </dependency>
    <dependency>
    	<groupId>junit</groupId>
    	<artifactId>junit</artifactId>
    	<version>4.11</version>
    </dependency>
  </dependencies>
  <build>
    <finalName>maven-web-demo</finalName>
  </build>
</project>
```

### 10. 发布 

右键项目→Run As→Maven install→右键项目→Run As→Package，生成完后Run As→Run on Servers即可。

也可以使用Tomcat的Maven插件，在pom.xml文件中添加该插件后，即可通过该插件运行Web项目。可通过在pom.xml文件的<bulid>元素中添加以下内容来添加该插件。如以下代码所示：

```xml
  <build>
    <finalName>maven-web-demo</finalName>
    <plugins>
        <plugin>
          <groupId>org.apache.tomcat.maven</groupId>
          <artifactId>tomcat7-maven-plugin</artifactId>
          <version>2.2</version>
          <configuration>
				<port>9999</port><!-- 定义程序运行端口 -->
				<path>/</path><!-- 定义程序映射目录 -->
				<urlEncoding>utf8</urlEncoding><!--解决url乱码 -->
		  </configuration>
        </plugin>
      </plugins>
  </build>
```

添加完该插件后，通过右键项目→Run As→Maven build...，如下图所示。

![newmaven8](https://github.com/hzxrosydawn/graphs/blob/master/photos/newmaven8.png?raw=true)

然后在弹出的对话框的Goals栏中填写tomcat7:run，Name栏为默认的运行配置名称。后续再运行该项目时，可在接选中项目后，如下图所示，

![newmaven9](https://github.com/hzxrosydawn/graphs/blob/master/photos/newmaven9.png?raw=true)

点击工具栏运行按钮，选择初次运行该项目时默认运行配置名称（即maven-web-demo）即可运行该项目了。

目前（2017年4月）Tomcat的Maven插件只支持到Tomcat7，Tomcat的Maven插件的最新信息请参考Tomcat官网上[关于Tomcat的Maven插件的介绍](http://tomcat.apache.org/maven-plugin.html)。