---
typora-copy-images-to: ..\..\graphs\photos
typora-root-url: ..\..\graphs\photos
---

## Maven简介

### Maven的安装

安装Maven之前需要安装JDK（Maven 3.3版本需要1.7及更高版本的JDK才能运行，但仍然可以构建基于1.3或更高版本的JDK的Java应用 ）并配置Java环境变量（推荐通过建立JAVA_HOME环境变量的方式来间接指定Java的环境变量，而不是直接把JDK的安装目录作为Java环境变量，否则不能在控制台使用mvn命令。因为目前版本的Maven（版本为3.3.9）在控制台执行时会查找JAVA_HOME环境变量）。关于JDK的安装和Java环境变量的配置请参考：

#### 下载Maven

Maven官方下载地址：http://maven.apache.org/download.cgi。将下载得到的压缩包解压到合适的运行位置，得到名为apache-maven-3.3.x的文件夹（我的是apache-maven-3.3.9）。文件的文件结构如下：

- LICENSE.txt 包含了Apache Maven的软件许可证；
- NOTICE.txt 包含了一些Maven依赖的类库所需要的通告及权限；
- README.txt包含了一些安装指令。 bin/目录包含了运行Maven的mvn脚本；
- boot/ 目录包含了一个负责创建Maven运行所需要的类装载器的JAR文件(classwords-1.1.jar)；
- conf/ 目录包含了一个全局的settings.xml文件，该文件用来自定义你机器上Maven的一些行为。如果你需要自定义Maven，更通常的做法是覆写~/.m2目录下的settings.xml文件，每个用户都有对应的这个目录；
- lib/ 目录有了一个包含Maven核心的JAR文件(maven-2.0.9-uber.jar)。

#### 配置Maven环境变量

将Maven安装目录下的bin目录的全名（我的是C:\Program Files\Java\apache-maven-3.3.9\bin，为什么把Maven安装到C盘，因为我的电脑安装了一块120G的SSD）添加到Path环境变量中，添加环境变量的步骤参考[Java环境变量的添加]()和[环境变量相关介绍]()。

#### 验证Maven

在控制台输入“mvn -v”即可查看Maven的版本。如下图所示。

![maveninstall1](/maveninstall1.png)

Maven会创建一个~/.m2目录（这里的~指用户的home目录）下有：

- ~/.m2/settings.xml：该文件包含了用户相关的认证，仓库和其它信息的配置，用来自定义Maven的行为；


- ~/.m2/repository/：该目录是你本地的仓库。当你从远程Maven仓库下载依赖的时候，Maven在你本地仓库存储了这个依赖的一个副本。

#### 使用Maven Help插件

Maven Help插件能让你列出活动的Maven Profile，显示一个实际POM（effective POM），打印实际settings（effective settings），或者列出Maven插件的属性。常用的命令如下：

- mvn help:active-profiles：列出当前构建中活动的Profile（项目的，用户的，全局的）；
- mvn help:effective-pom：显示当前构建的实际POM，包含活动的Profile；
- mvn help:effective-settings：打印出项目的实际settings, 包括从全局的settings和用户级别settings继承的配置；
- mvn help:describe：描述插件的属性。它不需要在项目目录下运行。但是你必须提供你想要描述插件的groupId和artifactId。

打开控制台，输入“mvn help:help”命令后回车，如果没有help插件，则会在第一次执行该插件前自动从远程仓库下载该插件，下载完成后会打印出该插件的详细说明信息。如下所示。

```shell
C:\Users\User Name>mvn help:help
[INFO] Scanning for projects...
[INFO]
[INFO] ------------------------------------------------------------------------
[INFO] Building Maven Stub Project (No POM) 1
[INFO] ------------------------------------------------------------------------
[INFO]
[INFO] --- maven-help-plugin:2.2:help (default-cli) @ standalone-pom ---
[INFO] Maven Help Plugin 2.2
  The Maven Help plugin provides goals aimed at helping to make sense out of the
  build environment. It includes the ability to view the effective POM and
  settings files, after inheritance and active profiles have been applied, as
  well as a describe a particular plugin goal to give usage information.

This plugin has 9 goals:

help:active-profiles
  Displays a list of the profiles which are currently active for this build.

help:all-profiles
  Displays a list of available profiles under the current project.
  Note: it will list all profiles for a project. If a profile comes up with a
  status inactive then there might be a need to set profile activation
  switches/property.

help:describe
  Displays a list of the attributes for a Maven Plugin and/or goals (aka Mojo -
  Maven plain Old Java Object).

help:effective-pom
  Displays the effective POM as an XML for this build, with the active profiles
  factored in.

help:effective-settings
  Displays the calculated settings as XML for this project, given any profile
  enhancement and the inheritance of the global settings into the user-level
  settings.

help:evaluate
  Evaluates Maven expressions given by the user in an interactive mode.

help:expressions
  Displays the supported Plugin expressions used by Maven.

help:help
  Display help information on maven-help-plugin.
  Call mvn help:help -Ddetail=true -Dgoal=<goal-name> to display parameter
  details.

help:system
  Displays a list of the platform details like system properties and environment
  variables.


[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time: 0.528 s
[INFO] Finished at: 2017-04-03T23:50:35+08:00
[INFO] Final Memory: 9M/153M
[INFO] ------------------------------------------------------------------------
```







