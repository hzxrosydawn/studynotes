---
typora-copy-images-to: ..\..\..\graphs\photos
typora-root-url: ./
---

使用Struts2创建Hello World入门实例

### 创建一个Maven Web项目

使用IDE（这里以IntelliJ IDEA为例）创建一个Maven Web项目，在 `pom.xml` 文件中添加Struts2的依赖：

```xml
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/maven-v4_0_0.xsd">
  <modelVersion>4.0.0</modelVersion>
  <groupId>com.rosydawn</groupId>
  <artifactId>test-project</artifactId>
  <packaging>war</packaging>
  <version>1.0-SNAPSHOT</version>
  <name>test-project Maven Webapp</name>
  <url>http://maven.apache.org</url>
  <dependencies>
    <dependency>
      <groupId>junit</groupId>
      <artifactId>junit</artifactId>
      <version>4.12</version>
      <scope>test</scope>
    </dependency>
    <!--struts2项目的依赖-->
    <dependency>
      <groupId>org.apache.struts</groupId>
      <artifactId>struts2-core</artifactId>
      <version>2.5.10</version>
    </dependency>
    <!--servlet依赖-->
    <dependency>
      <groupId>javax.servlet</groupId>
      <artifactId>javax.servlet-api</artifactId>
      <version>3.1.0</version>
    </dependency>
    <!--jsp依赖-->
    <dependency>
      <groupId>javax.servlet.jsp</groupId>
      <artifactId>jsp-api</artifactId>
      <version>2.2</version>
    </dependency>
  </dependencies>
  <build>
    <finalName>test-project</finalName>
  </build>
</project>
```

### 在web.xml文件中添加Struts2过滤器

```xml
<?xml version="1.0" encoding="UTF-8"?>
<web-app xmlns="http://xmlns.jcp.org/xml/ns/javaee"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/javaee http://xmlns.jcp.org/xml/ns/javaee/web-app_3_1.xsd"
         version="3.1">
    <filter>
        <filter-name>struts</filter-name>
        <filter-class>org.apache.struts2.dispatcher.filter.StrutsPrepareAndExecuteFilter</filter-class>
        <!-- struts 2.3之前的版本使用的配置 -->
        <!-- org.apache.struts2.dispatcher.FilterDispatcher -->
        <!-- org.apache.struts2.dispatcher.ng.filter.StrutsPrepareAndExecuteFilter -->
    </filter>
    <filter-mapping>
        <filter-name>struts</filter-name>
        <url-pattern>*.action</url-pattern>
    </filter-mapping>
</web-app>
```

### 创建Action/动作

每个URL将被映射到一个特定的 `Action/动作` ，它提供了针对用户请求的处理逻辑。

Struts2中的动作必须要有一个无参数的方法返回String或结果的对象，而且必须是一个POJO。如果没有指定不带参数的方法，则默认使用execute()方法。也可以选择扩展 `ActionSupport` 类实现的6个接口，包括动作界面。动作界面如下：

```java
public interface Action {
   public static final String SUCCESS = "success";
   public static final String NONE = "none";
   public static final String ERROR = "error";
   public static final String INPUT = "input";
   public static final String LOGIN = "login";
   public String execute() throws Exception;
}
```

先在 `src/main/java` 目录中的 `com.rosydawn.helloworld.model` 包下创建一个MessageStore的model类：

```java
package com.rosydawn.helloworld.model;

public class MessageStore {
    private String message;
    
    public MessageStore() {
        message = "Hello Struts User";
    }

    public String getMessage() {
        return message;
    }
}
```

然后在 `src/main/java` 目录中的 `com.rosydawn.helloworld.action` 包下创建我们的Action动作类：

```java
package com.rosydawn.helloworld.action;

import com.rosydawn.helloworld.model.MessageStore;
import com.opensymphony.xwork2.ActionSupport;

public class HelloWorldAction extends ActionSupport {
    private MessageStore messageStore;
  
    public String execute() throws Exception {
        messageStore = new MessageStore() ;
        return SUCCESS;
    }
    public MessageStore getMessageStore() {
        return messageStore;
    }
}
```

用户发起访问 `HelloWorld.jsp` 页面的请求后，HelloWorldAction类的execute方法将会被调用，该方法创建了一个 `MessageStore` 对象，同时返回了一个 `ActionSupport.SUCCESS` 对象。为了使 `MessageStore` 对象能被服务页面访问到，我们必须按照JavaBean的格式来为这个私有成员提供getter和setter方法。

在Struts2中，Action类不必实现实现任何接口或扩展任何类，但它需要创建一个execute()方法来实现所有的业务逻辑，并返回一个字符串值，告诉用户重定向到哪里。

> 注意：你可能会看到一些用户实现 `com.opensymphony.xwork2.Action` 类， 但这是可选的，因为`com.opensymphony.xwork2.Action` 只是提供一些方便的常量。Struts1中的Action类需要扩展 `org.apache.struts.action.Action` 。 但是，Struts 2的Action类是可选的，但是仍然允许执行 `com.opensymphony.xwork2.Action` 的一些方便的常量，或者扩展 `com.opensymphony.xwork2.ActionSupport` 对于一些常见的默认动作执行的功能。

接下来创建显示信息的服务页面 `src/main/webapp/HelloWorld.jsp` ：

```jsp
<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%--引入本地已下载的Struts2依赖中的s标签--%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Hello World!</title>
  </head>
  <body>
    <h2><s:property value="messageStore.message" /></h2>
  </body>
</html>
```

在上面的jsp文件中， `<s:property>` 标签用来显示调用  `HelloWorldAction`  控制器类的 `getMessageStore` 方法的返回值，是一个属性，接着后面 `.message` 是 `MessageStore` 对象的一个属性。可见 `s` 标签用来访问控制器传来的**动态数据**对象非常方便。

### 在struts.xml文件中添加配置

在 `src/main/resources` 目录下创建下面的 `struts.xml` 文件：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE struts PUBLIC
		"-//Apache Software Foundation//DTD Struts Configuration 2.5//EN"
		"http://struts.apache.org/dtds/struts-2.5.dtd">
<struts>
    <constant name="struts.devMode" value="true" />
    <package name="basicstruts2" namespace="/welcome" abstract="false" extends="struts-default">
        <action name="index">
            <result>/index.jsp</result>
        </action>
        <action name="hello" class="com.rosydawn.helloworld.action.HelloWorldAction" method="execute">
            <result name="success">/HelloWorld.jsp</result>
        </action>
    </package>
</struts>
```

该配置文件主要声明包和包含动作（action）类。

> 注意：Strut配置文件是用来映射Action控制器类和前端服务页面的关系的。该配置文件的名称必须是 `struts.xml`。

`<package>` 元素定义了一组action处理逻辑，用于给action分组：

- `name` 属性是**必须**的，它指定了一组处理逻辑的包名，仅用于标识，可自定义为任意值；
- `namespace` 属性是可选的，它指定匹配一组请求的前缀url路径。如果没有使用该属性的话，该属性就默认为`/`；
- `abstract` 属性是可选的，**默认为false** ，如果将该属性指定为true，那么该 `<package>` 元素就不能声明 `<action>` 子元素了，只能用来被其他 `<package>` 元素的 `extends` 属性来引用；
- `extends` 属性必须指定为 struts-default ，表示继承默认的 `struts-default.xml` 配置。该默认配置文件位于 `struts2-core.jar` 文件的根目录中。默认配置文件包含了Struts2的标准配置，一般不会直接用到该配置文件。

`<package>` 元素可以实现分离的模块化配置。这一点非常有用，当一个大项目被划分成不同的模块，比如说，如果该项目有三个模块：`business_applicaiton` ，`customer_application` 和 `staff_application` ，可以分别创建三个包来存储相关的动作。

`<action>` 子元素定义了一个请求的配置：

- `name` 属性指定了某个具体请求在应用环境下的后缀url路径；
- `class` 属性指定了处理指定名称的请求的全限定类名。目标请求通过 `<package>` 元素 `namespace` 属性和`<action>` 元素的 `name` 属性来联合指定；
- `method` 属性是可选的，指定了Action类中处理某个请求的方法的名称。如果没有使用该属性，则该属性默认为 `execute`，即Action类中的 `execute` 方法；
- `<result>` 子元素，其 `name` 属性对应处理请求方法的返回值（都是字符串），并根据这个返回值来选择特定的页面、图片或其他网络资源，或者交给其他 `<action>` 元素处理。也就是说，`<result>` 子元素也可以包含其他 `<aciton>` 元素。

 其他常用的可选子元素如下：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE struts PUBLIC
        "-//Apache Software Foundation//DTD Struts Configuration 2.5//EN"
        "http://struts.apache.org/dtds/struts-2.5.dtd">
<!--上面的xml版本声明和文档类型声明可以在名为"org.apache.struts:struts2-core:2.5.10"里的名为"struts-2.5.dtd"中找到。
    本配置文件必须名为"struts.xml"，该配置文件用于映射Action处理类与服务页面的关系，将两者连接起来-->
<struts>
    <!--指定Web应用的默认编码集。该属性对于处理中文请求参数非常有用，对于获取中文请求参数值，应该将该属性值设置为GBK或者GB2312。
	    提示:当设置该参数为GBK时,相当于调用HttpServletRequest的setCharacterEncoding方法. -->
    <constant name="struts.i18n.encoding" value="UTF-8"/>
  
    <!--该属性指定不拦截哪些特定的请求。拦截的请求在web.xml文件通过struts2的过滤器来指定-->
    <constant name="struts.action.excludePattern" value="*.html,*.png"/>
  
    <!--该属性设置Struts2应用是否使用开发模式。如果设置该属性为true，则可以在应用出错时显示更多、更友好的出错提示。
        该属性只接受true和false两个值，该属性的默认值是false。
        通常,应用在开发阶段,将该属性设置为true,当进入产品发布阶段后,则该属性设置为false。 -->
    <constant name="struts.devMode" value="true"/>

    <!--该属性指定上传文件的临时保存路径,该属性的默认值是javax.servlet.context.ServletContext中的TMEPDIR静态常量，
        其值为“javax.servlet.context.tempdir” -->
    <constant name="struts.multipart.saveDir" value="" />

    <!--该属性指定struts2文件上传中整个请求内容允许的最大字节数，这里指定为10M大小。  -->
    <constant name="struts.multipart.maxSize" value="1073741824"/>
  
    <!--该属性指定需要struts2处理的请求后缀，该属性的默认值是action，即所有匹配后缀为“*.action”的请求都由struts2处理。
        如果用户需要指定多个请求后缀,则多个后缀之间以英文逗号(,)隔开。 -->
    <constant name="struts.action.extension" value="action"/>

    <!--配置比较多时，分而治之、各个击破（divide and conquer）才是最佳策略。
        include元素用来引入其他配置文件-->
    <include file="struts-other.xml"/>

</struts>
```

### 创建URL  Action

接下来创建一个包含 `Action URL` 的服务页面 `src/main/webapp/index.jsp` ：

```jsp
<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="s" uri="/struts-tags" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Basic Struts 2 Application - Welcome</title>
    </head>
    <body>
        <h1>Welcome To Struts 2!</h1>
        <p><a href="<s:url action='hello'/>">Come with me!</a></p>
    </body>
</html>
```

`index.jsp` 页面中的 `url` 标签指定了一个带有  `welcome/helloworld` 动作的 URL。正如前面的 `struts.xml` 配置文件所示， `welcome/helloworld` 动作由 `<package>` 元素的 `namespace` 属性和 `<action>` 元素的 `name` 属性共同决定，这个动作对应于 `HelloWorldAction` 类的 `execute` 方法，加入我们部署项目是指定项目的 Application Context 为 `struts2-test`  这样用户访问 ` http://localhost:8080/welcome/index.action` 点击 `index.jsp` 页面上的 `Come with me!` 链接后，浏览器会向服务器发送一个 ` http://localhost:8080/welcome/hello.action` 请求，Struts 2 框架使用 `org.apache.struts2.dispatcher.filter.StrutsPrepareAndExecuteFilter` 分发请求，然后会调用 `HelloWorldAction` 控制器类的 `execute` 方法，该方法返回一个值为 `success` 的字符串（即从`ActionSupport` 间接继承的`SUCCESS` 常量），该字符串对应于 `<action>` 元素的 `name` 属性。然后，`HelloWorld.jsp` 页面就会显示出来。

![struts_hello1](../../../graphs/photos/struts_hello1.png)

 ` http://localhost:8080/welcome/index.action` 请求实际生成的网页源码如下：

```html
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Basic Struts 2 Application - Welcome</title>
</head>
<body>
<h1>Welcome To Struts 2!</h1>
<p><a href="/welcome/hello.action">Come with me!</a></p>
</body>
</html>
```



![struts_hello2](../../../graphs/photos/struts_hello2.png)