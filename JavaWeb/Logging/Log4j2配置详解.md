## Log4j 2 配置详解

###  Log4j 2 的配置种类

Log4j 2 的配置可以通过以下四种方式之一来实现：

- 通过 XML、JSON、YAML或者properties格式的配置文件；
- 通过创建一个 ConfigurationFactory 和 Configuration 接口的实现；
- 调用 Configuration 接口暴露的方法来在默认配置的基础上添加其他组件；
- 通过在内部 Logger 类上调用方法。

### 配置文件的加载顺序

Log4j 包含 4 种 ConfigurationFactory 的实现，分别适用于 JSON、YAML、properties 和 XML 配置文件。在 Log4j 启动时可以按照以下顺序自动加载配置文件：

1. 查找 `log4j.configurationFile` 系统属性值所指定的配置文件名，如果该系统属性值存在，就尝试使用相应文件扩展名的 ConfigurationFactory 来加载指定的配置文件；
2. 如果没有找到，则 properties ConfigurationFactory 就在 classpath 中寻找 log4j2-**test**.properties 配置文件；
3. 如果没有找到，则 YAML ConfigurationFactory  就在 classpath 中寻找 log4j2-**test**.yaml 或 log4j2-**test**.yml 配置文件；
4. 如果没有找到，则 JSON ConfigurationFactory  就在 classpath 中寻找 log4j2-**test**.json 或 log4j2-**test**.jsn 配置文件；
5. 如果没有找到，则 XML ConfigurationFactory 就在 classpath 中寻找log4j2-**test**.xml 配置文件；
6. 如果没有找到**测试配置文件**，则 properties ConfigurationFactory 就在 classpath 中寻找 log4j2.properties 配置文件；
7. 如果没有找到，则 YAML ConfigurationFactory  就在 classpath 中寻找 log4j2.yaml 或 log4j2.yml 配置文件；
8. 如果没有找到，则 JSON ConfigurationFactory  就在 classpath 中寻找 log4j2.json 或 log4j2.jsn 配置文件；
9. 如果没有找到，则 XML ConfigurationFactory 就在 classpath 中寻找log4j2.xml 配置文件；
10. 如果上面的配置文件都没有找到，就使用默认的 DefaultConfiguration 配置。

### XML配置简单示例

**案例1**：

创建一个名为 `log4j2test` 的应用，该应用有如下两个类：

```java
package com.foo;
import org.apache.logging.log4j.Logger;
import org.apache.logging.log4j.LogManager;
 
public class Foo {
  private static final Logger logger = LogManager.getLogger(Foo.class);
 
  public boolean doIt() {
    // 打印日志 
	logger.trace("entry");
    logger.error("Did it again!");
    logger.trace("exit");
    // 日志结束
    return false;
  }

```

```java
package com.bar;

import com.foo.Foo;
import org.apache.logging.log4j.Logger;
import org.apache.logging.log4j.LogManager;

public class Bar {
	private static final Logger logger = LogManager.getLogger(Bar.class);

	public static void main(final String... args) {
		logger.trace("Entering application.");
		Foo foo = new Foo();
		if (!foo.doIt()) {
			logger.error("Didn't do it.");
		}
		logger.trace("Exiting application.");
	}
}
```

运行 Bar 类，由于我们还没有添加配置文件，所以默认的输出结果如下：

```
16:56:24.581 [main] ERROR com.foo.Foo - Did it again!
16:56:24.582 [main] ERROR com.bar.Bar - Didn't do it.
```

默认配置的等价内容如下：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Configuration status="WARN">
  <Appenders>
    <!-- 默认打印到控制台 -->
    <Console name="Console" target="SYSTEM_OUT">
       <!-- 默认打印格式 -->
      <PatternLayout pattern="%d{HH:mm:ss.SSS} [%t] %-5level %logger{36} - %msg%n"/>
    </Console>
  </Appenders>
  <Loggers>
     <!-- 默认打印日志级别为error -->
    <Root level="error">
      <AppenderRef ref="Console"/>
    </Root>
  </Loggers>
</Configuration>
```

如果我们新建一个名为 log4j2.xml 的文件，将其放入上面应用的 classpath 中，并将日志级别 `error` 修改为 `trace` 后重新运行 Bar 类，结果输出如下：

```
17:11:04.735 [main] TRACE com.bar.Bar - Entering application.
17:11:04.736 [main] TRACE com.foo.Foo - entry
17:11:04.736 [main] ERROR com.foo.Foo - Did it again!
17:11:04.736 [main] TRACE com.foo.Foo - exit
17:11:04.736 [main] ERROR com.bar.Bar - Didn't do it.
17:11:04.736 [main] TRACE com.bar.Bar - Exiting application.
```

### 相加性

**案例2**：

假如你想忽略除了 `com.foo.Foo` 以外的所有 `TRACE` 日志，仅更改日志级别无法达到目的，解决办法是在配置文件中新建一个 logger 定义：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Configuration status="WARN">
	<Appenders>
		<Console name="Console" target="SYSTEM_OUT">
			<PatternLayout pattern="%d{HH:mm:ss.SSS} [%t] %-5level %logger{36} - %msg%n" />
		</Console>
	</Appenders>
	<Loggers>
		<!-- 新建一个指定名称和指定级别的 logger -->
		<Logger name="com.foo.Foo" level="TRACE" />
		<Root level="ERROR">
			<AppenderRef ref="Console" />
		</Root>
	</Loggers>
</Configuration>
```

重新运行结果如下：

```
17:36:47.192 [main] TRACE com.foo.Foo - entry
17:36:47.193 [main] ERROR com.foo.Foo - Did it again!
17:36:47.193 [main] TRACE com.foo.Foo - exit
17:36:47.193 [main] ERROR com.bar.Bar - Didn't do it.
```

结果所有 `TRACE` 级别的日志中只有 Foo 类中的 `TRACE` 级别的日志输出了。

**案例3**：

如果我们为 `com.foo.Foo` 的 logger 配置了 Appender，如下所示：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Configuration status="WARN">
	<Appenders>
		<!-- 默认打印到控制台 -->
		<Console name="Console" target="SYSTEM_OUT">
			<!-- 默认打印格式 -->
			<PatternLayout pattern="%d{HH:mm:ss.SSS} [%t] %-5level %logger{36} - %msg%n" />
		</Console>
	</Appenders>
	<Loggers>
		<!-- 默认打印日志级别为error -->
		<Logger name="com.foo.Foo" level="TRACE">
			<AppenderRef ref="Console" />
		</Logger>
		<Root level="ERROR">
			<AppenderRef ref="Console" />
		</Root>
	</Loggers>
</Configuration>
```

重新运行结果如下：

```
17:45:32.899 [main] TRACE com.foo.Foo - entry
17:45:32.899 [main] TRACE com.foo.Foo - entry
17:45:32.900 [main] ERROR com.foo.Foo - Did it again!
17:45:32.900 [main] ERROR com.foo.Foo - Did it again!
17:45:32.900 [main] TRACE com.foo.Foo - exit
17:45:32.900 [main] TRACE com.foo.Foo - exit
17:45:32.900 [main] ERROR com.bar.Bar - Didn't do it.
```

 `com.foo.Foo` 类中的 `TRACE` 级别及以上的日志竟然输出了两遍！这是由于名为 `com.foo.Foo` 的 logger 会将其打印事件传递给其 parent logger（这里为Root ），在 Root logger 中再次执行了打印操作。而案例2中的没有重复打印是由于名为 `com.foo.Foo` 的 logger 没有设置 Appender，它仅负责记录的打印事件，然后将其传递给了 Root logger，所以仅 Root logger 有打印操作。这种现象称为**相加性（Additivity）**。这种特性可以用来汇整某几个 logger 的输出，可以通过设置某个 logger 的 additivity 属性为 false 来禁用该特性：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Configuration status="WARN">
	<Appenders>
		<!-- 默认打印到控制台 -->
		<Console name="Console" target="SYSTEM_OUT">
			<!-- 默认打印格式 -->
			<PatternLayout pattern="%d{HH:mm:ss.SSS} [%t] %-5level %logger{36} - %msg%n" />
		</Console>
	</Appenders>
	<Loggers>
		<!-- 默认打印日志级别为error -->
		<Logger name="com.foo.Foo" level="TRACE" additivity="false">
			<AppenderRef ref="Console" />
		</Logger>
		<Root level="ERROR">
			<AppenderRef ref="Console" />
		</Root>
	</Loggers>
</Configuration>
```

重新运行就可以发现日志不会重复打印了。

### 自动重新配置

可以通过设置 Configuration 元素的 monitorInterval 属性值（秒数）为一个非零值来让Log4j 每隔指定的秒数来重新读取配置文件，可以用来动态应用 Log4j 配置。 如：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Configuration monitorInterval="30">
...
</Configuration>
```

> 注意，如果应用运行在生产模式的 Weblogic 上时，修改项目中的文件不会生效，必须关闭应用重新更新应用才可以，考虑到不能随便停止应用的需求，可以通过编程方法来进行配置 log4j，从数据库中动态读取配置信息。

Log4j 可以 `“advertis”` 基于文件和 Socket 的 Appenders 配置信息。例如，Log4j 可以将文件 Appender 中的日志文件位置和 pattern layout 包含到 advertisement 中。[Chainsaw](http://logging.apache.org/chainsaw/) 以及其它外部系统可以发现这些 advertisements，并使用其重的信息来智能地处理日志文件。

这种应用 advertisement 的机制以及 advertisement 的格式依赖于Advertiser 的实现。使用某个 Advertiser 实现的外部系统必须知道如何如何定位  advertised 的配置信息。比如，某个使用数据库的 Advertiser 的实现可以将配置信息存储到数据库表中，外部系统可以读取这些数据表从而来发现文件位置和文件格式。

Log4j 提供了一种 multicastdns Advertiser 实现，通过使用 [http://jmdns.sourceforge.net](http://jmdns.sourceforge.net/) 库的IP 多播来 advertise Appenders 的配置信息。Chainsaw 可以自动发现和展示 Log4j 的这种 advertisements 。目前， Chainsaw 仅支持 FileAppender advertisements 。

advertise 一个 Appender 配置的步骤如下：

- 将 [JmDns](http://jmdns.sourceforge.net/) 库添加到类路径下；
- 设置 Configuration 元素的 advertiser 属性值为multicastdns；
- 设置相应 appender 的 advertise 属性值为 true；

如果 advertise 基于 FileAppender 的配置，则设置 advertiseURI 属性值设置为一个合适的 URI，供 Chainsaw 来访问文件。例如，通过设置一个  [Commons VFS](http://commons.apache.org/proper/commons-vfs/) sftp:// 的 URI ，文件可通过 ssh/sftp 来让 Chainsaw 访问，如果通过 Web 服务器来访问文件也可以设置一个 http:// 的 URI ，如果通过本地运行的 Chainsaw 来访问文件也可以指定一个 file:// 的URI。

下面是一个应用 advertised  Appender 的配置：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Configuration advertiser="multicastdns">
...
</Configuration>
<Appenders>
  <File name="File1" fileName="output.log" bufferedIO="false" advertiseURI="file://path/to/output.log" advertise="true">
  ...
  </File>
</Appenders>
```

### Configuration元素详解

一个比较完整的 log4j2.xml 配置如下所示：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Configuration status="debug" strict="true" name="XMLConfigTest"
               packages="org.apache.logging.log4j.test">
  <Properties>
    <Property name="filename">target/test.log</Property>
  </Properties>
  <Filter type="ThresholdFilter" level="trace"/>
 
  <Appenders>
    <Appender type="Console" name="STDOUT">
      <Layout type="PatternLayout" pattern="%m MDC%X%n"/>
      <Filters>
        <Filter type="MarkerFilter" marker="FLOW" onMatch="DENY" onMismatch="NEUTRAL"/>
        <Filter type="MarkerFilter" marker="EXCEPTION" onMatch="DENY" onMismatch="ACCEPT"/>
      </Filters>
    </Appender>
    <Appender type="Console" name="FLOW">
      <Layout type="PatternLayout" pattern="%C{1}.%M %m %ex%n"/><!-- class and line number -->
      <Filters>
        <Filter type="MarkerFilter" marker="FLOW" onMatch="ACCEPT" onMismatch="NEUTRAL"/>
        <Filter type="MarkerFilter" marker="EXCEPTION" onMatch="ACCEPT" onMismatch="DENY"/>
      </Filters>
    </Appender>
    <Appender type="File" name="File" fileName="${filename}">
      <Layout type="PatternLayout">
        <Pattern>%d %p %C{1.} [%t] %m%n</Pattern>
      </Layout>
    </Appender>
  </Appenders>
 
  <Loggers>
    <Logger name="org.apache.logging.log4j.test1" level="debug" additivity="false">
      <Filter type="ThreadContextMapFilter">
        <KeyValuePair key="test" value="123"/>
      </Filter>
      <AppenderRef ref="STDOUT"/>
    </Logger>
 
    <Logger name="org.apache.logging.log4j.test2" level="debug" additivity="false">
      <AppenderRef ref="File"/>
    </Logger>
 
    <Root level="trace">
      <AppenderRef ref="STDOUT"/>
    </Root>
  </Loggers>
 
</Configuration>
```



我们一般默认使用log4j2.xml进行命名。如果本地要测试，可以把log4j2-test.xml放到classpath，而正式环境使用log4j2.xml，则在打包部署的时候不要打包log4j2-test.xml即可。














Log4j 2 在用于 Java EE Web 应用时有一些额外事项需要注意。要确保日志资源在容器关闭或 Web 应用取消部署时能恰当地清理。为了做到这一点，需要在 Web 应用中添加 `log4j-web` 的依赖，可以从 Maven 仓库中找到该依赖。













Log4j 2 只能运行在支持 Servlet 3.0 及以上版本的 Web 应用中，它可以在应用部署时和关闭时随之自动启动和关闭。

> 注意：有些容器会忽略不含 TLD 文件的  jar 文件