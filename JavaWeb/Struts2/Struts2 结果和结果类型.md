## Struts2 结果和结果类型

在struts2框架中，当action处理完之后，就应该向用户返回结果信息，该任务被分为两部分：结果类型和结果本身。

Struts允许使用的其他标记语言的技术，目前的结果和流行的选择，包括 **Velocity, Freemaker, XSLT** 和**Tiles**.

结果类型提供了返回给用户信息类型的实现细节。结果类型通常在Struts2中就已预定义好了（见下表），或者是由插件（如Json插件）提供，开发人员也可以自定义结果类型。默认配置的结果类型是dispatcher，该结果类型使用JSP来向用户显示结果。当定义了结果类型之后，该结果类型可以在不同的action中重复使用。

#### Struts2框架提供的结果类型

| 已配置结果类型名       | 类 名                                      | 描 述                                |
| -------------- | ---------------------------------------- | ---------------------------------- |
| dispatcher     | org.apache.struts2.dispatcher.ServletDispatcherResult | 默认结果类型，用来呈现JSP页面                   |
| chain          | com.opensymphony.xwork2.ActionChainResult | 将action和另外一个action链接起来             |
| freemarker     | org.apache.struts2.views.freemarker.FreemarkerResult | 呈现Freemarker模板                     |
| httpheader     | org.apache.struts2.dispatcher.HttpHeaderResult | 返回一个已配置好的HTTP头信息响应                 |
| redirect       | org.apache.struts2.dispatcher.ServletRedirectResult | 将用户重定向到一个已配置好的URL                  |
| redirectAction | org.apache.struts2.dispatcher.ServletActionRedirectResult | 将用户重定向到一个已定义好的action               |
| stream         | org.apache.struts2.dispatcher.StreamResult | 将原始数据作为流传递回浏览器端，该结果类型对下载的内容和图片非常有用 |
| velocity       | org.apache.struts2.dispatcher.VelocityResult | 呈现Velocity模板                       |
| xslt           | org.apache.struts2.views.xslt.XSLTResult | 呈现XML到浏览器，该XML可以通过XSL模板进行转换        |
| plaintext      | org.apache.struts2.dispatcher.PlainTextResult | 返回普通文本类容                           |

简单说明一下result的name属性和type属性：

- SUCCESS：Action正确的执行完成，返回相应的视图，success是name属性的默认值；
- NONE：表示Action正确的执行完成，但并不返回任何视图；
- ERROR：表示Action执行失败，返回到错误处理视图；
- INPUT：Action的执行，需要从前端界面获取参数，INPUT就是代表这个参数输入的界面，一般在应用中，会对这些参数进行验证，如果验证没有通过，将自动返回到该视图；
- LOGIN：Action因为用户没有登陆的原因没有正确执行，将返回该登陆视图，要求用户进行登陆验证。

dispatcher：请求转发，底层调用RequestDispatcher的forward()或include()方法，dispatcher是 type属性的默认值，通常用于转向一个JSP。localtion指定JSP的位置，parse如果为false表示location的值不会被当作 OGNL解析，默认为true。
redirect：重定向，新页面无法显示Action中的数据，因为底层调用response.sendRedirect("")方法，无法共享请求范围内的数据，参数与dispatcher用法相同。
redirect-action：重定向到另一个Action，参数与chain用法相同，允许将原Action中的属性指定新名称带入新Action 中，可以在Result标签中添加 <param name=”b”>${a} </param>，这表示原Action中的变量a的值被转给b，下一个Action可以在值栈中使用b来操作，注意如果值是中文，需要做一些编码处理，因为Tomcat默认是不支持URL直接传递中文的！
velocity：使用velocity模板输出结果，location指定模板的位置（*.vm），parse如果为false，location不被OGNL解析，默认为true。
xslt：使用XSLT将结果转换为xml输出，location指定*.xslt文件的位置，parse如果为false，location不被 OGNL解析，默认为true。matchingPattern指定想要的元素模式，excludePattern指定拒绝的元素模式，支持正则表达式，默认为接受所有元素。
httpheader：根据值栈返回自定义的HttpHeader，status指定响应状态（就是指response.sendError(int i)重定向到500等服务器的状态页）。parse如果为false，header的值不会被OGNL解析，headers，加入到header中的值，例如： <param name=”headers.a”>HelloWorld </param>。可以加多个，这些键-值组成HashMap。
freemaker：用freemaker模板引擎呈现视图，location指定模板（*.ftl）的位置，parse如果为false，location的值不会被OGNL解析。contentType指定以何中类型解析，默认为text/html。
chain：将action的带着原来的状态请求转发到新的action，两个action共享一个ActionContext，actionName指定转向的新的Action的名字。method指定转向哪个方法，namespace指定新的Action的名称空间，不写表示与原Action在相同的名称空间；skipActions指定一个使用 , 连接的Action的name组成的集合，一般不建议使用这种类型的结果。
stream：直接向响应中发送原始数据，通常在用户下载时使用，contentType指定流的类型，默认为 text/plain，contentLength以byte计算流的长度，contentDisposition指定文件的位置，通常为 filename=”文件的位置”，input指定InputStream的名字，例如：imageStream，bufferSize指定缓冲区大小，默认为1024字节。
plaintext：以原始文本显示JSP或者HTML，location指定文件的位置，charSet指定字符集。



### 调度结果类型：

调度（**dispatcher**）的结果类型是默认的类型，是用来指定，如果没有其他的结果类型。它被用来转发到一个[servlet](http://www.yiibai.com/servlet)，[JSP](http://www.yiibai.com/jsp)，[HTML](http://www.yiibai.com/html)页面，等等，在服务器上。它使用RequestDispatcher.forward()方法。

在我们前面的例子中，我们看到了“shorthand”的版本，在这里我们提供了一个JSP的路径作为body的结果标记。

```
<result name="success">
   /HelloWorld.jsp
</result>

```

我们也可以指定JSP文件中使用一个<param name="location">的标签内的<result...>元素如下：

```
<result name="success" type="dispatcher">
   <param name="location">
      /HelloWorld.jsp
   </param >
</result>

```

我们还可以提供一个分析参数，默认值是true。解析参数的位置参数确定是否将被解析为OGNL表达式。

## FreeMaker结果类型：

在这个例子中，我们将看到我们如何使用FreeMaker作为视图技术。 freemaker是一种流行的模板引擎，用于生成输出，使用预定义的模板。让我们创建一个Freemaker模板文件hello.fm以下内容：

```
Hello World ${name}

```

在此以上的文件是一个模板，其中名称是使用已定义的动作外，将通过放慢参数。在CLASSPATH中将保存该文件。接下来，让我们修改struts.xml中指定的结果如下：

```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE struts PUBLIC
"-//Apache Software Foundation//DTD Struts Configuration 2.0//EN"
"http://struts.apache.org/dtds/struts-2.0.dtd">

<struts>
   <constant name="struts.devMode" value="true" />
   <package name="helloworld" extends="struts-default">

      <action name="hello" 
         class="com.tutorialspoint.struts2.HelloWorldAction"
         method="execute">
         <result name="success" type="freemarker">
            <param name="location">/hello.fm</param>
         </result>
      </action>
      
   </package>

</struts>

```

让我们保持我们的HelloWorldAction.java，HelloWorldAction.jsp和index.jsp文件，为我们创造了他们的例子章。现在，右键点击项目名称，并单击“导出”> WAR文件创建一个WAR文件。然后，这WAR部署在Tomcat的webapps目录下。最后，启动Tomcat服务器，并尝试访问URL http://localhost:8080/HelloWorldStruts2/index.jsp。这会给你以下画面：

输入值"Struts2" 并提交页面。您应该看到下一页

正如你可以看到，这是完全一样的不同之处在于，我们是不依赖于使用JSP作为视图技术的JSP视图。在这个例子中，我们已经使用Freemaker。

## 重定向结果类型：

重定向结果的类型调用标准**response.sendRedirect()**方法，使浏览器来创建一个新的请求给定的位置。
我们可以提供的位置无论是在体内的<result...>元素或作为一个<param name="location">元素。重定向也支持解析的参数。下面是一个例子使用XML配置：

****

```
<action name="hello" 
   class="com.tutorialspoint.struts2.HelloWorldAction"
   method="execute">
   <result name="success" type="redirect">
       <param name="location">
         /NewWorld.jsp
      </param >
   </result>
</action>

```

因此，只要修改struts.xml文件中定义重定向上述类型，并创建一个新的的文件NewWorld.jpg在那里你会被重定向hello操作时，将返回成功。您可以查看[Struts2重定向动作](http://www.yiibai.com/struts_2/struts_redirect_action.htm) 例子更好地理解。