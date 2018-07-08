实践证明，日志打印是在开发中非常重要的功能模块。一旦将日志打印的语句写入代码中，日志的输出就不需要人工干预，还可以将日志持久化存储到本地文件中、数据库中、远程主机上，便于后续研究代码的执行逻辑。适用于 Java 日志打印框架有很多，比如 SLF4J、Logback、Log4j 等，这里介绍一下应用最广的 Log4j 。

## 为什么使用 Log4j 2？

Log4j 1.x 从 1999 年发布至今得到了非常广泛的应用，但经过这些年的发展它有些慢了。而且，由于需要与旧版的 JDK 兼容而变得难以维护，所以 Log4j 1.x 在 2015 年 8 月变为了 [End of Life](https://blogs.apache.org/foundation/entry/apache_logging_services_project_announces) 。

SLF4J/Logback 也在框架上做出了许多必要的改进，但为什么还去操心 [Log4j 2 ](http://logging.apache.org/log4j/2.x/index.html) 呢？理由如下：

1. Log4j 2 是一个可以被用作日志审计的框架。 Log4j 1.x 和 Logback 在重新配置后会丢失事件，而 Log4j 2 不会。在 Logback 中，Appenders（输出源）中的异常对应用来说是不可见的，Log4j 2 中的 Appenders 可以配置为允许异常对应用可见；
2. Log4j 2 包含基于 [LMAX Disruptor library](https://lmax-exchange.github.io/disruptor/) 的下一代异步 Loggers 。在多线程场景下，异步 Loggers 拥有 10 倍于 Log4j 1.x 和 Logback 的生产力和低延迟量级；
3. Log4j 2 对于独立应用来说是 [garbage free](http://logging.apache.org/log4j/2.x/manual/garbagefree.html) 的，对于稳定输出日志 web 应用来说产生的垃圾也是很少的。这就减轻了垃圾回收器的压力从而在响应时间上有更好的性能；
4. Log4j 2 的[插件系统](http://logging.apache.org/log4j/2.x/manual/plugins.html)使得通过添加新的 [Appenders](http://logging.apache.org/log4j/2.x/manual/appenders.html) 、 [Filters](http://logging.apache.org/log4j/2.x/manual/filters.html) 、 [Layouts](http://logging.apache.org/log4j/2.x/manual/layouts.html) 、 [Lookups](http://logging.apache.org/log4j/2.x/manual/lookups.html) 和 Pattern Converters 来扩展该框架变得非常容易，Log4j 本身不需要任何改变；
5. 由于插件系统的配置更加简单，配置项已不需要指定类名；
6. 可以通过代码或配置文件进行配置[自定义的日志级别](http://logging.apache.org/log4j/2.x/manual/customloglevels.html)；
7. 支持 [Lambda 表达式](http://logging.apache.org/log4j/2.x/manual/api.html#LambdaSupport)，基于 Java 8 的代码可以使用 Lambda 表达式简洁的创建日志的 Message ；
8. 支持 [Message 对象](http://logging.apache.org/log4j/2.x/manual/messages.html) 。 我们可以自由地创建有趣、复杂的 Message 类型，编写自定义的 [Layouts](http://logging.apache.org/log4j/2.x/manual/layouts.html) 、 [Filters](http://logging.apache.org/log4j/2.x/manual/filters.html) 和 [Lookups](http://logging.apache.org/log4j/2.x/manual/lookups.html) 来操作这些 Message 类型；
9. Log4j 1.x 支持在 Appenders 上使用 Filters，Logback 也添加了 TurboFilters 来在事件还未被 Logger 处理之前先过滤事件，Log4j 2 支持在事件被 Logger 处理之前配置 Filters 来处理事件，就像事件通过 Logger 处理或在 Appenders 上处理一样；
10. 多数 Logback Appenders 不支持使用 Layout 而仅支持固定格式的数据。 多数 Log4j 2 Appenders 可以使用 Layout 来输出任意期望格式的数据；
11. Log4j 1.x 中的 Layouts 以及 Logback 返回的是一个字符串，这导致了一些编码问题。而 Log4j 2 的 Layouts 总返回一个字节数组，这意味着该字节数组可以应用在任何 Appender 上，不仅仅是写入 OutputStream 中；
12. [Syslog Appender](http://logging.apache.org/log4j/2.x/manual/appenders.html#SyslogAppender) 支持 TCP 和 UDP 协议，也支持 BSD syslog 和  [RFC 5424](http://tools.ietf.org/html/rfc5424) 格式；
13. Log4j 2 应用了 Java 5 的并发支持和最低限度的加锁。Log4j 1.x 有一些死锁问题，这些问题多数在 Logback 得到了修复，但 Logback 类依然需要相当高级别的同步。

## Log4j 2 架构详解

Log4j 2 的架构图如下：

![Log4jClasses](../appendix/Log4jClasses.jpg)

LogManager 通过 `getLogger(final Class<?> clazz)` 静态方法将定位到合适的 LoggerContext，然后从中得到一个 Logger 对象，要创建 Logger 需要关联一个 LoggerConfig，该 LoggerConfig 对象在 Configuration 中关联着传送 LogEvents 的 Appenders。 

### Logger Hierarchy

 Log4j 1.x 中的 Logger 层级由各 Loggers 之间的关系来维护，而 Log4j 2 中的 Logger 层级由 LoggerConfig 对象负责维护。Logger 和 LoggerConfig 都是命名的实体。Logger 的名称是大小写敏感的，遵循以下层级命名规则：

> 如果 LoggerConfig A 的名称后跟一个点号作为后代  LoggerConfig A.\*.B 的名称前缀（\*表示任意中间前缀），那么 LoggerConfig  A 是 LoggerConfig A.\*.B 的 ancestor（An ancestor is a parent or  the parent of an antecedent）；如果名称 A 和 B 之间没有其他内容，那么 LoggerConfig  A 是 LoggerConfig A.B 的 parent。

类似的， `java` 包是 `java.util` 包的 parent，是 `java.util.Vector` 类的 ancestor。这种命名模式对大多数开发者来说都是熟悉的。下表显示了这种层级关系。

| LoggerConfig | ROOT     | com      | com.foo    | com.foo.Bar |
| ------------ | -------- | -------- | ---------- | ----------- |
| Root         | X        | Child    | descendant | descendant  |
| com          | Parent   | X        | Child      | descendant  |
| com.foo      | Ancestor | Parent   | X          | Child       |
| com.foo.Bar  | Ancestor | Ancestor | Parent     | X           |

root LoggerConfig 位于 LoggerConfig 层级的最顶级，它存在于在每个层级中。直接链接到 root LoggerConfig 的 Logger 可以这样获得：

```java
Logger logger = LogManager.getLogger(LogManager.ROOT_LOGGER_NAME);
```

也可以更简单些：

```
Logger logger = LogManager.getRootLogger();
```

其他 Logger 可以通过调用 `LogManager.getLogger(final String name)` 静态方法并传入期望的 Logger 名来获取。更多获取 Logger 的内容请参考 [Log4j 2 API](https://logging.apache.org/log4j/2.x/log4j-api/api.html) 。

### LoggerContext

[LoggerContext](http://logging.apache.org/log4j/2.x/log4j-core/apidocs/org/apache/logging/log4j/core/LoggerContext.html) 充当着日志系统的锚点。不同情况下一个应用可以有多个有效的 LoggerContext。

### Configuration

每个 LoggerContext  都有一个有效的 [Configuration](http://logging.apache.org/log4j/2.x/log4j-core/apidocs/org/apache/logging/log4j/core/config/Configuration.html) ，该 Configuration 包含了所有的 Appenders 、上下文范围的 Filters  ，以及 LoggerConfig， 并包含了 StrSubstitutor 的引用。在重新配置时会存在两个 Configuration。一旦所有的 Logger 重定向到新的 Configuration，旧的 Configuration 就会被停止和禁用。

### Logger

Logger  本身执行无指向的动作，它仅含有一个与 LoggerConfig 关联的名称，继承了 AbstractLogger 并实现了其必需的方法，当配置被修改了，Loggers 可能转而关联不同的 LoggerConfig 从而会改变其自身的行为。如果调用 `LogManager.getLogger` 方法时使用相同的名称参数，则总会返回同一个 Logger 对象。例如：

```
Logger x = LogManager.getLogger("wombat");
Logger y = LogManager.getLogger("wombat");
```

`x` 和`y` 参照的实际上是同一个 Logger 对象。通过将 Logger 命名为其所在类的全限定名可以使输出的日志更具可辨识性，这是目前最好的做法。这不是强制的，开发者可以为 Logger 起任意的期望名称 。既然一般习惯使用所在类的全限定名命名 Logger ，所以 `LogManager.getLogger()` 方法默认创建使用所在类全限定名命名的 Logger 。

### LoggerConfig

当 Logger 在配置文件中声明时，就创建了 [LoggerConfig](http://logging.apache.org/log4j/2.x/log4j-core/apidocs/org/apache/logging/log4j/core/config/LoggerConfig.html) 对象。LoggerConfig 包含一些 Filter ，这些 Filter 用于过滤传递给任意 Appender 的 LogEvent。它还包含了一些 Appender 的引用，这些 Appender 用来处理事件。

### Log Levels

LoggerConfig 会被分配一个日志[级别](https://logging.apache.org/log4j/2.x/log4j-api/apidocs/org/apache/logging/log4j/Level.html)。内建的日志级别有 TRACE、 DEBUG、INFO、WARN、ERROR 和 FATAL。Log4j 2也支持[自定义日志级别](https://logging.apache.org/log4j/2.x/manual/customloglevels.html)，另一种更细粒度化的机制是使用 [Markers](https://logging.apache.org/log4j/2.x/log4j-api/api.html#Markers) 来替代。

Log4j 1.x 和 Logback 都有一个日志级别继承的概念。Log4j 2 中，Logger 和 LoggerConfig 是两个不同的对象，所以这个概念也有所不同。每个 Logger 引用着一个合适的 LoggerConfig  ，该 LoggerConfig  又可以反过来继承该 Logger 的 parent LoggerConfig 的日志级别。

下面列出几张表演示了日志级别的继承逻辑。注意，如果 root LoggerConfig 没有配置，则它会被分配一个默认的日志级别（默认为 ERROR）。

在下面的示例中，只有 `root` Logger 通过与其名称匹配的 LoggerConfig 配置一个日志级别，所有其他 Logger 将引用 root LoggerConfig ，并使用其日志级别。

| Logger Name | Assigned LoggerConfig | LoggerConfig Level | Logger Level |
| ----------- | --------------------- | ------------------ | ------------ |
| root        | root                  | DEBUG              | DEBUG        |
| X           | root                  | DEBUG              | DEBUG        |
| X.Y         | root                  | DEBUG              | DEBUG        |
| X.Y.Z       | root                  | DEBUG              | DEBUG        |

在下面的示例中，所有 Logger 都配置了与各自名称匹配的 LoggerConfig 并从中获取日志级别。

| Logger Name | Assigned LoggerConfig | LoggerConfig Level | Level |
| ----------- | --------------------- | ------------------ | ----- |
| root        | root                  | DEBUG              | DEBUG |
| X           | X                     | ERROR              | ERROR |
| X.Y         | X.Y                   | INFO               | INFO  |
| X.Y.Z       | X.Y.Z                 | WARN               | WARN  |

在下面的示例中，名为 `root` 、`X` 和 `X.Y.Z` 的 Logger 都配置了各自的 LoggerConfig ，但名为 `X.Y` 的 Logger 并没有配置名称匹配的 LoggerConfig ，它将使用名为 `X` 的 LoggerConfig 。因为 `X` LoggerConfig 的名称是  `X.Y` Logger 的名称开头的最长匹配，如果还有名为 `W.X.Y` 的 LoggerConfig ，`X.Y` Logger 将会使用 `W.X.Y` LoggerConfig 。

| Logger Name | Assigned LoggerConfig | LoggerConfig Level | Level |
| ----------- | --------------------- | ------------------ | ----- |
| root        | root                  | DEBUG              | DEBUG |
| X           | X                     | ERROR              | ERROR |
| X.Y         | X                     | ERROR              | ERROR |
| X.Y.Z       | X.Y.Z                 | WARN               | WARN  |

在下面的示例中，`root` 和 `X` Logger 都配置了与各自名称匹配的 LoggerConfig ，`X.Y` 和 `X.Y.Z` Logger 没有匹配 LoggerConfig ，所以从分配给它们的 `X` LoggerConfig  中获取其日志级别。

| Logger Name | Assigned LoggerConfig | LoggerConfig Level | level |
| ----------- | --------------------- | ------------------ | ----- |
| root        | root                  | DEBUG              | DEBUG |
| X           | X                     | ERROR              | ERROR |
| X.Y         | X                     | ERROR              | ERROR |
| X.Y.Z       | X                     | ERROR              | ERROR |

在下面的示例中，`root` ，`X` 和 `X.Y` Logger 都配置了与其各自名称匹配的 LoggerConfig，但 `X.YZ` Logger 没有配置 LoggerConfig，所以从分配给它的 `X` LoggerConfig 中获取其日志级别。由此可见，**如果一个 Logger 没有配置 LoggerConfig ，那么它将会继承使用上一级 LoggerConfig** 。  

| Logger Name | Assigned LoggerConfig | LoggerConfig Level | level |
| ----------- | --------------------- | ------------------ | ----- |
| root        | root                  | DEBUG              | DEBUG |
| X           | X                     | ERROR              | ERROR |
| X.Y         | X.Y                   | INFO               | INFO  |
| X.YZ        | X                     | ERROR              | ERROR |

在下面的示例中，`X.Y` Logger 配置了与其名称匹配的 `X.Y` LoggerConfig ，但 `X.Y`  LoggerConfig 没有配置日志级别，所以，`X.Y` LoggerConfig 从 `X` LoggerConfig 获取其日志级别。`X.Y.Z` Logger 没有配置与其名称匹配的 LoggerConfig ，所以，`X.Y.Z` Logger 将使用 `X.Y` LoggerConfig ，从而其级别也从 `X` LoggerConfig 获得。**如果一个 Logger 的 LoggerConfig 没有配置日志级别，那么该 LoggerConfig 将会继承使用上一级 LoggerConfig 的日志级别** 。  

| Logger Name | Assigned LoggerConfig | LoggerConfig Level | Level |
| ----------- | --------------------- | ------------------ | ----- |
| root        | root                  | DEBUG              | DEBUG |
| X           | X                     | ERROR              | ERROR |
| X.Y         | X.Y                   |                    | ERROR |
| X.Y.Z       | X.Y                   |                    | ERROR |

### Filter

下面的表格解释了日志级别的自动过滤规则。

![BaiduShurufa_2017-11-2_22-20-22](../appendix/BaiduShurufa_2017-11-2_22-20-22.png)

除了日志级别的自动过滤， Log4j 还提供了 [Filter](http://logging.apache.org/log4j/2.x/log4j-core/apidocs/org/apache/logging/log4j/core/Filter.html) （过滤器），在控制到达 LoggerConfig 之前、在控制到达 LoggerConfig 之后但在调用任何 Appender 之前、在控制到 LoggerConfig 之后但在调用某个特定 Appender 之前，以及在每个 Appender 上都可以使用 Filter 进行日志级别的过滤。

类似于防火墙的过滤器一样，每个 Filter 都可以返回 `Accept`、`Deny` 和 `Neutral`（中立）三个值之一：

- `Accept` 表示不会调用其他 Filter ，事件将进行处理；
- `Deny` 表示事件被立即忽略并将控制返回给调用者；
- `Neutral` 表示事件将传递给其他 Filter ，如果没有其他 Filter ，则事件将会被处理。

即使一个事件被某个 Filter 接受了也不一定会输出。当事件被某个前置 LoggerConfig Filter 接受了但被后面的 LoggerConfig 拒绝了或被所有 Appender 拒绝了就会出现这样的情况。

### Appender

Log4j 可将日志打印输出到多种位置（目前可以为控制台、文件、多种数据库 API 、远程套接字服务器、Apache Flume 、JMS 、远程 UNIX Syslog daemon），Log4j 中的日志输出位置称为 [Appender](http://logging.apache.org/log4j/2.x/log4j-core/apidocs/org/apache/logging/log4j/core/Appender.html) （输出源）。可以通过调用当前 Configuration 的[addLoggerAppender](http://logging.apache.org/log4j/2.x/log4j-core/apidocs/org/apache/logging/log4j/core/config/Configuration.html#addLoggerAppenderorg.apache.logging.log4j.core.Logger20org.apache.logging.log4j.core.Appender) 方法将一个 Appender 添加给一个 Logger 。如果一个 Logger 匹配的同名 LoggerConfig 不存在，就会创建一个，Appender 将被添加到该 LoggerConfig ，其他所有 Logger 将会收到通知并更新其 LoggerConfig 引用。

给定 Logger 所允许的每条日志打印请求都会传递给其 LoggerConfig 中的所有 Appender ，也会传递给该 LoggerConfig 的 parent LoggerConfig 中的 Appender 。也就是说，**Appender 会从 LoggerConfig 的继承中继承相加性**。例如，如果一个控制台 Appender 添加到 root Logger中，那么所有允许的日志打印请求将至少输出到控制台，如果一个文件 Appender 添加到一个 LoggerConfig C 中，C 和 C 的 children 允许的日志打印请求将会输出到文件和控制台。可以在声明 Logger 的配置文件中设置 `additivity="false"` 来禁用这种叠加继承。

> Appender Additivity
>
> Logger L 的一条日志打印语句将输出到 L 关联的 LoggerConfig C 中的所有 Appender 以及该 LoggerConfig 的所有 ancestor。然而，如果 LoggerConfig C 一个 ancestor P 的叠加标志设置为了 `false`，那么，L 的输出将直接指向 C 中的所有 Appender 以及 C 的 ancestor 直到 P（包括 P），不会指向到 P 的所有 ancestor 中的 Appender 。Logger 的叠加标识默认为 `true`，表示叠加父级的 Appender 。

下面的表格展示了一个示例：

| Logger Name     | Added Appenders | Additivity Flag | Output Targets         | Comment                                                      |
| --------------- | --------------- | --------------- | ---------------------- | ------------------------------------------------------------ |
| root            | A1              | not applicable  | A1                     | root Logger 没有 parent，所有叠加在这里不适用。              |
| x               | A-x1, A-x2      | true            | A1, A-x1, A-x2         | x 和 root 的所有 Appender 。                                 |
| x.y             | none            | true            | A1, A-x1, A-x2         | x 和 root 的所有 Appender 。但一般不会配置一个没有 Appender 的 Logger 。 |
| x.y.z           | A-xyz1          | true            | A1, A-x1, A-x2, A-xyz1 | x.y.z、x 和 root 中的所有 Appender 。                        |
| security        | A-sec           | false           | A-sec                  | 叠加标志设置为 `false`，所以没有父级的 Appender 叠加。       |
| security.access | none            | true            | A-sec                  | 仅 security 的 A-sec 有叠加，没有叠加 root 的 A1 。          |

**日志级别的继承是指父级 LoggerConfig 的日志级别会被子级 LoggerConfig 所继承，而相加性是指子级 Logger 的日志时间会传递给父级 Logger，两者刚好相反**。

### Layout

Appender 的 [Layout](http://logging.apache.org/log4j/2.x/log4j-core/apidocs/org/apache/logging/log4j/core/Layout.html) （列印格式）用来自定义日志事件的输出格式。[PatternLayout](http://logging.apache.org/log4j/2.x/log4j-core/apidocs/org/apache/logging/log4j/core/layout/PatternLayout.html) 可以使用与 C 语言 printf 函数类似的转换模式来指定输出格式。Log4j 提供了多种不同的 [Layout](http://logging.apache.org/log4j/2.x/manual/layouts.html) 来适用于多种形式的输出，如 JSON 、XML 、HTML 和 Syslog (包括最新的 RFC 5424 版本)。

### StrSubstitutor 和 StrLookup

[StrSubstitutor ](http://logging.apache.org/log4j/2.x/log4j-core/apidocs/org/apache/logging/log4j/core/lookup/StrSubstitutor.html) 类和 [StrLookup](http://logging.apache.org/log4j/2.x/log4j-core/apidocs/org/apache/logging/log4j/core/lookup/StrLookup.html) 接口是从 [Apache Commons Lang](https://commons.apache.org/proper/commons-lang/) 借鉴修改而来用以处理 LogEvents 的。另外，[Interpolator](http://logging.apache.org/log4j/2.x/log4j-core/apidocs/org/apache/logging/log4j/core/lookup/Interpolator.html) 类是从 Apache Commons Configuration 借鉴修改而来从而使 StrSubstitutor 可以处理多个 StrLookups 中的变量，该类也经过修改可以支持处理 LogEvents 。这些类一起让配置可以引用 System Properties 、配置文件、ThreadContext Map 以及 LogEvent 的 StructuredData 中的变量。

## Log4j 2 配置详解

###  Log4j 2 的配置种类

Log4j 2 的配置可以通过以下四种方式之一来实现：

- 通过 XML 、JSON 、YAML 或者 properties 格式的配置文件；
- 通过创建一个 ConfigurationFactory 和 Configuration 接口的实现；
- 调用 Configuration 接口暴露的方法来在默认配置的基础上添加其他组件；
- 通过在内部 Logger 类上调用方法。

### 配置文件的加载顺序

Log4j 包含 4 种 ConfigurationFactory 的实现，分别适用于 JSON 、YAML 、properties 和 XML 配置文件。在 Log4j 启动时可以按照以下顺序自动加载配置文件：

1. 查找 `log4j.configurationFile` 系统属性所指定的配置文件名，如果该系统属性值存在，就尝试使用相应文件扩展名的 ConfigurationFactory 来加载指定的配置文件。通过在代码中调用  `System.setProperties("log4j.configurationFile","FILE_PATH")` 或者将 `-Dlog4jconfigurationFile=file://C:/configuration.xml` 参数传递给 JVM ；
2. 如果没有找到，则 properties ConfigurationFactory 就在 classpath 中寻找 log4j2-**test**.properties 配置文件；
3. 如果没有找到，则 YAML ConfigurationFactory  就在 classpath 中寻找 log4j2-**test**.yaml 或 log4j2-**test**.yml 配置文件；
4. 如果没有找到，则 JSON ConfigurationFactory  就在 classpath 中寻找 log4j2-**test**.json 或 log4j2-**test**.jsn 配置文件；
5. 如果没有找到，则 XML ConfigurationFactory 就在 classpath 中寻找log4j2-**test**.xml 配置文件；
6. 如果没有找到**测试配置文件**，则 properties ConfigurationFactory 就在 classpath 中寻找 log4j2.properties 配置文件；
7. 如果没有找到，则 YAML ConfigurationFactory  就在 classpath 中寻找 log4j2.yaml 或 log4j2.yml 配置文件；
8. 如果没有找到，则 JSON ConfigurationFactory  就在 classpath 中寻找 log4j2.json 或 log4j2.jsn 配置文件；
9. 如果没有找到，则 XML ConfigurationFactory 就在 classpath 中寻找log4j2.xml 配置文件；
10. 如果上面的配置文件都没有找到，就使用默认的 DefaultConfiguration 配置。

### XML 配置简单示例

**案例1**：

创建一个名为 `log4j2test` 的应用，该应用有如下两个类：

```java
package com.foo;

import org.apache.logging.log4j.Logger;
import org.apache.logging.log4j.LogManager;

public class Bar {
	private static final Logger logger = LogManager.getLogger(Bar.class);

	public boolean doIt() {
		// 打印日志
		logger.trace("entry");
		logger.error("Did it again!");
		logger.trace("exit");
		// 日志结束
		return false;
	}
}
```

```java
package com.foo;

import org.apache.logging.log4j.Logger;
import org.apache.logging.log4j.LogManager;

public class MyApp {
	private static final Logger logger = LogManager.getLogger(MyApp.class);

	public static void main(final String... args) {
		logger.trace("Entering application.");
		Bar bar = new Bar();
        if (!bar.doIt()) {
			logger.error("Didn't do it.");
		}
		logger.trace("Exiting application.");
	}
}
```

运行 MyApp 类，由于我们还没有添加配置文件，所以默认的输出结果如下：

```
ERROR StatusLogger No Log4j 2 configuration file found. Using default configuration (logging only errors to the console), or user programmatically provided configurations. Set system property 'log4j2.debug' to show Log4j 2 internal initialization logging. See https://logging.apache.org/log4j/2.x/manual/configuration.html for instructions on how to configure Log4j 2
13:11:00.569 [main] ERROR com.foo.Bar - Did it again!
13:11:00.571 [main] ERROR com.foo.MyApp - Didn't do it.
```

如果 Log4j 找不到配置文件，那么将会使用 DefaultConfiguration  类提供的默认的配置：

- 为 root Logger 添加一个 [ConsoleAppender](https://logging.apache.org/log4j/2.x/log4j-core/apidocs/org/apache/logging/log4j/core/appender/ConsoleAppender.html) ；
- 为该 [ConsoleAppender](https://logging.apache.org/log4j/2.x/log4j-core/apidocs/org/apache/logging/log4j/core/appender/ConsoleAppender.html) 设置一个 pattern 为 “%d{HH:mm:ss.SSS} [%t] %-5level %logger{36} - %msg%n” 的 [PatternLayout](https://logging.apache.org/log4j/2.x/log4j-core/apidocs/org/apache/logging/log4j/core/layout/PatternLayout.html) 。

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
     <!-- 默认打印日志级别为 error -->
    <Root level="error">
      <AppenderRef ref="Console"/>
    </Root>
  </Loggers>
</Configuration>
```

如果我们新建一个名为 log4j2.xml 的文件，将其放入上面应用的 classpath 中，并将日志级别 `error` 修改为 `trace` 后重新运行 Bar 类，结果输出如下：

```
13:11:30.279 [main] TRACE com.foo.MyApp - Entering application.
13:11:30.281 [main] TRACE com.foo.Bar - entry
13:11:30.282 [main] ERROR com.foo.Bar - Did it again!
13:11:30.282 [main] TRACE com.foo.Bar - exit
13:11:30.282 [main] ERROR com.foo.MyApp - Didn't do it.
13:11:30.282 [main] TRACE com.foo.MyApp - Exiting application.
```

### 叠加性

**案例2**：

假如你想忽略除了 `com.foo.Bar` 以外的所有 `TRACE` 日志，仅更改日志级别无法达到目的，解决办法是在配置文件中新建一个 logger 定义：

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
		<Logger name="com.foo.Bar" level="TRACE" />
		<Root level="ERROR">
			<AppenderRef ref="Console" />
		</Root>
	</Loggers>
</Configuration>
```

重新运行结果如下：

```
13:12:24.917 [main] TRACE com.foo.Bar - entry
13:12:24.918 [main] ERROR com.foo.Bar - Did it again!
13:12:24.918 [main] TRACE com.foo.Bar - exit
13:12:24.918 [main] ERROR com.foo.MyApp - Didn't do it.
```

上面的配置记录了 `com.foo.Bar` 中的所有级别的日志事件，但其他所有组件的日志事件中只有 ERROR 级别的才会被记录。

如果我们为 `com.foo.Bar` 的 logger 配置了 Appender，如下所示：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Configuration status="WARN">
	<Appenders>
		<Console name="Console" target="SYSTEM_OUT">
			<PatternLayout pattern="%d{HH:mm:ss.SSS} [%t] %-5level %logger{36} - %msg%n" />
		</Console>
	</Appenders>
	<Loggers>
        <!-- 为新建 logger 指定 Appender -->
		<Logger name="com.foo.Bar" level="TRACE">
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
13:25:55.391 [main] TRACE com.foo.Bar - entry
13:25:55.391 [main] TRACE com.foo.Bar - entry
13:25:55.392 [main] ERROR com.foo.Bar - Did it again!
13:25:55.392 [main] ERROR com.foo.Bar - Did it again!
13:25:55.393 [main] TRACE com.foo.Bar - exit
13:25:55.393 [main] TRACE com.foo.Bar - exit
13:25:55.393 [main] ERROR com.foo.MyApp - Didn't do it.
```

`com.foo.Bar` 类中的 `TRACE` 级别及以上的日志竟然输出了两遍！这是由于名为 `com.foo.Bar` 的 logger 会将其打印事件传递给其 parent logger（这里为 Root ），在 Root logger 中再次执行了打印操作。而案例 2 中的没有重复打印是由于名为 `com.foo.Bar` 的 logger 没有设置 Appender，它仅负责记录的打印事件，然后将其传递给了 Root logger，所以仅 Root logger 有打印操作。这种现象称为**相加性（Additivity）**。这种特性可以用来汇整某几个 logger 的输出，可以通过设置某个 logger 的 additivity 属性为 false 来禁用该特性：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Configuration status="WARN">
	<Appenders>
		<Console name="Console" target="SYSTEM_OUT">
			<PatternLayout pattern="%d{HH:mm:ss.SSS} [%t] %-5level %logger{36} - %msg%n" />
		</Console>
	</Appenders>
	<Loggers>
		<!-- 设置新建 logger 的相加性为 false -->
		<Logger name="com.foo.Bar" level="TRACE" additivity="false">
			<AppenderRef ref="Console" />
		</Logger>
		<Root level="ERROR">
			<AppenderRef ref="Console" />
		</Root>
	</Loggers>
</Configuration>
```

重新运行就可以发现日志不会重复打印了：

```
13:46:27.869 [main] TRACE com.foo.Bar - entry
13:46:27.871 [main] ERROR com.foo.Bar - Did it again!
13:46:27.871 [main] TRACE com.foo.Bar - exit
13:46:27.871 [main] ERROR com.foo.MyApp - Didn't do it.
```

### 自动重新配置

可以通过设置 Configuration 元素的 monitorInterval 属性值（秒数）为一个非零值来让 Log4j 每隔指定的秒数来重新读取配置文件，可以用来动态应用 Log4j 配置。 如：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Configuration monitorInterval="30">
...
</Configuration>
```

> 注意，如果应用运行在生产模式的 Weblogic 上时，修改项目中的文件不会自动生效，必须关闭应用重新更新应用才可以，考虑到不能随便停止应用的需求，可以通过编程方法来进行配置 log4j ，从数据库中动态读取配置信息。

Log4j 可以将基于文件和 Socket 的 Appender 配置信息广而告之（advertise）。例如，Log4j 可以将文件 Appender 中的日志文件位置和 pattern layout 等属性包含到广告（advertisement ）中。[Chainsaw](http://logging.apache.org/chainsaw/) 以及其它外部系统可以发现这些广告，并使用其中的信息来智能地处理日志文件。

这种暴露广告以及其格式的机制依赖于 Advertiser 的实现。使用某个 Advertiser 实现的外部系统必须知道如何定位广告的配置信息。比如，某个使用数据库的 Advertiser 的实现可以将配置信息存储到数据库表中，外部系统可以读取这些数据表从而来发现文件位置和文件格式。

Log4j 提供了一种 multicastdns Advertiser 实现，通过使用 [http://jmdns.sourceforge.net](http://jmdns.sourceforge.net/) 库的 IP 多播来广告 Appenders 的配置信息。Chainsaw 可以自动发现和展示 Log4j 的这种广告。目前，Chainsaw 仅支持 FileAppender 广告。

广告一个 Appender 配置的步骤如下：

- 将 [JmDns](http://jmdns.sourceforge.net/) 库添加到类路径下；
- 设置 Configuration 元素的 advertiser 属性值为multicastdns；
- 设置相应 appender 的 advertise 属性值为 true。

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

### Configuration 元素详解

自 2.9 版本开始，处于安全原因，Log4j 在 XML 文件中不再处理 DTD ，如果你想将配置分割到多个文件中，可以使用  [XInclude](https://logging.apache.org/log4j/2.x/manual/configuration.html#XInclude) 或 [Composite Configuration](https://logging.apache.org/log4j/2.x/manual/configuration.html#CompositeConfiguration) 。

我们一般使用 XML 格式的配置文件。如果本地要测试，可以把 log4j2-test.xml 放到 classpath，而正式环境使用log4j2.xml ，则在打包部署的时候不要打包 log4j2-test.xml 即可。

Log4j 可以使用两种 XML 格式：简明和严格。简明格式可以简化配置，元素名匹配其代表的组件，但不能通过 XML Schema 来验证。比如，可以在父级 Appenders 元素中使用名为 Console 的元素来配置一个 ConsoleAppender ，简明格式的元素名和属性名都不是大小写敏感的。另外，属性既可以指定为属性，也可以指定为包含文本值且没有属性的 XML 元素。例如：

```xml
<PatternLayout pattern="%m%n"/>
```

和

```xml
<PatternLayout>
	<Pattern>%m%n</Pattern>
</PatternLayout>
```

是等价的。

根据上面的介绍就可以理解下面所示的 XML 配置结构。其中，小写字母开头的元素为简明格式。

```xml
<?xml version="1.0" encoding="UTF-8"?>;
<Configuration>
  <Properties>
    <Property name="name1">value</property>
    <Property name="name2" value="value2"/>
  </Properties>
  <filter  ... />
  <Appenders>
    <appender ... >
      <filter  ... />
    </appender>
    ...
  </Appenders>
  <Loggers>
    <Logger name="name1">
      <filter  ... />
    </Logger>
    ...
    <Root level="level">
      <AppenderRef ref="name"/>
    </Root>
  </Loggers>
</Configuration>
```

下面是一个严格格式的 log4j2.xml 配置：

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

Configuration 元素可以使用以下属性：

- advertiser ：可选的 Advertiser 插件名，用来广告个别 FileAppender 或 SocketAppender 的配置。目前唯一可用 Advertiser 名为 “multicastdns ”；
- dest ：`err` （将输出到 stderr 上）或一个文件路径或一个`URL`；
- monitorInterval ：检查配置文件是否有更新的间隔秒数；
- name ：配置的名称；
- packages ：逗号分隔的用于搜索插件的包名列表。插件只会被每个类加载器加载一次，所以仅重新配置该项不会生效；
- schema ：为类加载器定位 XML Schema 位置以验证配置。仅当 strict 属性设置为 true 时该属性才有效，如果不设置该属性，则不会验证 Schema ；  
- shutdownHook ：设置当 JVM 关闭时 log4j 是否也自动关闭。默认是启用的，也可以设置该属性为 disable 来禁用该关闭钩子；
- shutdownTimeout ：设置当 JVM 关闭后 Appender 和后台任务超时多少毫秒才关闭。默认为 0 ，表示每个 Appender 使用其默认的超时，不等待后台任务。这仅是个提示，而不能保证关闭进程不会花费更长的时间。将该值设置过小可能增加日志事件在还未输出到最终位置之前就丢失的风险。如果 shutdownHook 属性未设置，那么将不会使用该属性；
- status ：应该打印到控制台的**内部 Log4j 日志事件**的级别，可设置的值有 `trace` 、`debug` 、`info` 、`warn` 、`error` 和 `fatal` ，Log4j 将会打印出内部初始化等事件的详细信息。设置该属性为 `trace` 是查找 Log4j 故障的第一手工具。也可以通过设置  `log4j2.debug` 系统属性来输出 Log4j 内部日志，包括配置文件加载前的内部日志；
- strict ：使用严格的 XML 格式， JSON 格式的配置文件不支持该属性；
- verbose ：加载插件时是否显示诊断信息。



Log4j 2 在用于 Java EE Web 应用时有一些额外事项需要注意。要确保日志资源在容器关闭或 Web 应用取消部署时能恰当地清理。为了做到这一点，需要在 Web 应用中添加 `log4j-web` 的依赖，可以从 Maven 仓库中找到该依赖。













Log4j 2 只能运行在支持 Servlet 3.0 及以上版本的 Web 应用中，它可以在应用部署时和关闭时随之自动启动和关闭。

> 注意：有些容器会忽略不含 TLD 文件的  jar 文件