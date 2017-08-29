这里以Struts 2.5.10为例介绍Struts2的涉及到的配置，同时也对以前版本Struts2的某些配置做简单介绍。

## web.xml

Struts需要在web.xml文件中定义一个FilterDispatcher（核心控制器），该指定的Filter用于初始化Struts框架，并处理所有请求，该Filter可以包含一些初始化参数来影响额外的配置文件（如果存在的话）和框架的行为。

```xml
<?xml version="1.0" encoding="UTF-8"?>
<web-app xmlns="http://xmlns.jcp.org/xml/ns/javaee"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/javaee http://xmlns.jcp.org/xml/ns/javaee/web-app_3_1.xsd"
         version="3.1">
  	...
    <filter>
      	<filter-name>struts</filter-name>
        <!-- struts 2..1.3（不包含）之前的版本使用的配置 -->
      	<!-- <filter-class>org.apache.struts2.dispatcher.FilterDispatcher</filter-class> -->
     
      	<!-- 从struts 2.1.3开始，FilterDispatcher被弃用了，2.1.3（包含）到2.5（不包含）之间的版本使用以下配置 -->
        <!-- org.apache.struts2.dispatcher.ng.filter.StrutsPrepareAndExecuteFilter -->
     
     	<!-- 从struts 2.5开始，所有的过滤器都移到了org.apache.struts2.dispatcher.filter顶级包中 -->
        <filter-class>org.apache.struts2.dispatcher.filter.StrutsPrepareAndExecuteFilter</filter-class>
      	<!-- init-param会被加载成Struts常量 -->
      	<init-param>
            <param-name>struts.devMode</param-name>
            <param-value>true</param-value>
        </init-param>
    </filter>
    <filter-mapping>
       	<filter-name>struts</filter-name>
        <url-pattern>/*</url-pattern>
    </filter-mapping>
  	....
</web-app>
```

## Struts常量

**Struts2常量通过定义Struts2框架和插件行为的关键设置来自定义Struts应用**，故Struts2的常量**也被称为Struts2属性**。Struts2常量可以在多个文件中定义，其被搜索的顺序如下，后面文件中的配置可以覆盖前面的同名配置：

- struts-default.xml
- struts-plugin.xml
- struts.xml
- struts.properties
- web.xml

注意：

1. 之所以使用struts.propreties文件配置，是因为为了保持与WebWork的向后兼容。
2. 在实际开发中，在web.xml中配置常量相比其他两种，需要更多的代码量，会降低了web.xml的可读性。
3. 通常推荐在struts.xml文件中配置struts2的常量，而且便于集中管理。

## struts.properties

可以从struts2-core-2.5.10.jar中的org.apache.struts2包下找到一个default.properties的属性文件，**该配置文件中的每一个key-value对都定义了一个Struts2框架的常量**，该配置文件一般放在web应用的classpath目录（一般为`/WEB-INF/classes`）下。Struts 2.5.10的default.properties文件内容如下。

```properties
### 标准的UI主题
### Change this to reflect which path should be used for JSP control tag templates by default
struts.ui.theme=xhtml
struts.ui.templateDir=template
### Change this to use a different token to indicate template theme expansion
struts.ui.theme.expansion.token=~~~
#sets the default template type. Either ftl, vm, or jsp
struts.ui.templateSuffix=ftl

### Configuration reloading
### This will cause the configuration to reload struts.xml when it is changed
### struts.configuration.xml.reload=false

### Location of velocity.properties file.  defaults to velocity.properties
struts.velocity.configfile = velocity.properties

### Comma separated list of VelocityContext classnames to chain to the StrutsVelocityContext
struts.velocity.contexts =

### Location of the velocity toolbox
struts.velocity.toolboxlocation=

### used to build URLs, such as the UrlTag
struts.url.http.port = 80
struts.url.https.port = 443
### possible values are: none, get or all
struts.url.includeParams = none

### Load custom default resource bundles
# struts.custom.i18n.resources=testmessages,testmessages2

### workaround for some app servers that don't handle HttpServletRequest.getParameterMap()
### often used for WebLogic, Orion, and OC4J
struts.dispatcher.parametersWorkaround = false

### configure the Freemarker Manager class to be used
### Allows user to plug-in customised Freemarker Manager if necessary
### MUST extends off org.apache.struts2.views.freemarker.FreemarkerManager
#struts.freemarker.manager.classname=org.apache.struts2.views.freemarker.FreemarkerManager

### Enables caching of FreeMarker templates
### Has the same effect as copying the templates under WEB_APP/templates
### struts.freemarker.templatesCache=false

### Enables caching of models on the BeanWrapper
struts.freemarker.beanwrapperCache=false

### See the StrutsBeanWrapper javadocs for more information
struts.freemarker.wrapper.altMap=true

### maxStrongSize for MruCacheStorage for freemarker, when set to 0 SoftCacheStorage which performs better in heavy loaded application
### check WW-3766 for more details
struts.freemarker.mru.max.strong.size=0

### configure the XSLTResult class to use stylesheet caching.
### Set to true for developers and false for production.
struts.xslt.nocache=false

### Whether to always select the namespace to be everything before the last slash or not
struts.mapper.alwaysSelectFullNamespace=false

### Whether to allow static method access in OGNL expressions or not
struts.ognl.allowStaticMethodAccess=false

### Whether to throw a RuntimeException when a property is not found
### in an expression, or when the expression evaluation fails
struts.el.throwExceptionOnFailure=false

### Logs as Warnings properties that are not found (very verbose)
struts.ognl.logMissingProperties=false

### Caches parsed OGNL expressions, but can lead to memory leaks
### if the application generates a lot of different expressions
struts.ognl.enableExpressionCache=true

### Indicates if Dispatcher should handle unexpected exceptions by calling sendError()
### or simply rethrow it as a ServletException to allow future processing by other frameworks like Spring Security
struts.handle.exception=true
### END SNIPPET: complete_file
```

> 由于常量配置可以在`struts.xml`文件中进行，`struts.properties`配置文件是用来向后兼容的。

`struts.xml`文件时Struts2的默认配置文件，一般放在web应用的classpath目录（一般为`/WEB-INF/classes`）下。该配置文件最大的作用就是配置Action和请求之间的对象关系，并配置逻辑视图名和物理视图资源之间的对象关系。除此之外，该配置文件还可以配置拦截器、Bean、常量、导入其他配置文件等。

## struts.xml

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
  
    <!-- 该属性指定web.xml文件中声明的过滤器不拦截哪些特定的请求。可以使用英文逗号分隔匹配模式列表来声明不拦截某些请求 -->
    <constant name="struts.action.excludePattern" value="*.html,*.png"/>
  
    <!-- 该属性设置Struts2应用是否使用开发模式。如果设置该属性为true，则可以在应用出错时显示更多、更友好的出错提示。
        该属性只接受true和false两个值，该属性的默认值是false。
        通常,应用在开发阶段,将该属性设置为true,当进入产品发布阶段后,则该属性设置为false。 -->
    <constant name="struts.devMode" value="true"/>
	<!-- 从 Struts 2.5.6开始，声明Struts常量时可以使用值替换 -->
   	<!-- <constant name="struts.devMode" value="${env.STRUTS_DEV_MODE:false}"/> -->
  
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

