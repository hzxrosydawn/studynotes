## Tomcat部署项目的四种方式

### 静态部署

#### 直接将web项目文件件拷贝到webapps目录中

​     Tomcat的 `webapps` 目录是Tomcat 默认的应用目录，当服务器启动时，默认会加载所有这个目录下的应用。所以可以将Web应用编译后的文件（IntelliJ IDEA是target目录下的module目录及其所有文件）或打包成 `war` 包的Web应用放在该目录下，服务器默认会自动解开这个 `war` 包，并在这个目录下生成一个同名的文件夹。一个 `war` 包就是有特性格式的 `jar` 包，它是将一个web程序的所有内容进行压缩得到。具体如何打包，可以使用许多开发工具的IDE环境，如Eclipse、IntelliJ IDEA等。也可以用 cmd 命令：

```powershell
jar -cvf mywar.war  myweb
```

​     `webapps` 这个默认的应用目录也是可以改变。打开Tomcat的 `conf` 目录下的 `server.xml` 文件，找到下面内容：

```xml
<Host name="localhost" appBase="webapps" unpackWARs="true" autoDeploy="true" xmlValidation="false" xmlNamespaceAware="false">
```

将 `appBase` 属性修改即可。 

#### 在server.xml中指定

​    在Tomcat的配置文件中，一个Web应用就是一个特定的Context，可以通过在`server.xml`中新建`<Context/>`标签里设置一个Web应用程序的部署。打开`conf`目录中的`server.xml`文件，在`<Host/>`标签内新建一个`<Context/>`标签，内容如下：

```xml
<Context path="/hello" docBase="D:\workspace\hello\WebRoot" debug="0" privileged="true"/> 
```

或者

```xml
<Context path="/myapp" reloadable="true" docBase="D:\myapp" workDir="D:\myapp\work"/>
```

或者

```xml
<Context path="/sms4" docBase="D:\workspace\sms4\WebRoot\myapp.war"/>
```

说明：

- `path` 是虚拟的上下文路径（即应用在服务器上的部署路径，跟在请求url中的端口号之后）。
- `docBase` 是应用程序的物理路径。
- `workDir` 是这个应用的工作目录，存放运行时生成的与这个应用相关的文件。缓存文件的放置地址。
- `debug` 则是设定debug level,  0表示提供最少的信息，9表示提供最多的信息。
- `privileged`设置为true的时候，才允许Tomcat的Web应用使用容器内的Servlet。
- `reloadable` **如果为true，则tomcat会自动检测应用程序的/WEB-INF/lib 和/WEB-INF/classes目录的变化，自动装载新的应用程序，可以在不重起tomcat的情况下改变应用程序，实现热部署**。

antiResourceLocking和antiJARLocking  热部署是需要配置的参数，默认false避免更新了某个webapp，有时候Tomcat并不能把旧的webapp完全删除，通常会留下WEB-INF/lib下的某个jar包，必须关闭Tomcat才能删除，这就导致自动部署失败。设置为true，Tomcat在运行对应的webapp时，会把相应的源文件和jar文件复制到一个临时目录里。

#### 创建一个Context文件 

在`conf\Catalina\localhost`目录（如果该目录不完整就手动创建）中，在该目录中新建一个xml文件，名字不可以随意取，要和path后的那个名字一致。比如，按照下边这个path的配置，xml的名字应该就应该是hello（hello.xml），该xml文件的内容为：

```xml
<Context path="/hello" docBase="E:\workspace\hello\WebRoot" debug="0" privileged="true">
</Context>
```

tomcat自带例子如下：

```xml
<Context docBase="${catalina.home}/server/webapps/host-manager"
privileged="true" antiResourceLocking="false" antiJARLocking="false">
</Context>
```

这个例子是tomcat自带的，编辑的内容实际上和第二种方式是一样的，其中这xml文件名字就是访问路径，这样可以隐藏应用的真实名字。

4. 注意：

​    删除一个Web应用同时也要删除webapps下相应的文件夹和server.xml中相应的Context，还要将Tomcat的conf\catalina\localhost目录下相应的xml文件删除，否则Tomcat仍会去配置并加载。。。

### 动态部署

​     登陆tomcat管理控制台：http://localhost:8080/，输入用户名和密码后便可管理应用并动态发布。

​     在Context Path(option):中输入/yourwebname ，这代表你的应用的访问地址。

​     XML Configration file URL中要指定一个xml文件，比如我们在F:\下建立一个hmcx.xml文件，内容如下： <Context reloadable="false" />其中docBase不用写了，因为在下一个文本框中填入。或者更简单点，这个文本框什么都不填，在WAR or Directory URL:中键入F:\hmcx即可，然后点击Deploy按钮，上面就可以看到了web应用程序，名字就Context Path(option):中的名字。

​    如果部署.war文件还有更加简单的方式，下面还有个Select WAR file uploae点击浏览选择.war文件，然后点击Deploy也可以。