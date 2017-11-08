typora-copy-images-to: ..\appendix
typora-root-url: ..\appendix

### 为什么使用 Log4j 2？

实践证明，日志打印是在开发中非常重要的功能模块。一旦将日志打印的语句写入代码中，日志的输出就不需要人工干预，还可以将日志持久化存储到本地文件中、数据库中、远程主机上，便于后续研究代码的执行逻辑。适用于 Java 日志打印框架有很多，比如 SLF4J、Logback、Log4j等，这里介绍一下应用最广的 Log4j。

Log4j 1.x 从 1999 年发布至今得到了非常广泛的应用，但经过这些年的发展它有些慢了。而且，由于需要与旧版的 JDK 兼容而变得难以维护，所以 Log4j 1.x 在 2015 年 8 月变为了 [End of Life](https://blogs.apache.org/foundation/entry/apache_logging_services_project_announces)。

相比于 Log4j 1.x 和 Logback ，更建议使用 Log4j 2，理由如下：

1. Log4j 2 是一个可以被用作日志审计的框架。 Log4j 1.x 和 Logback 在重新配置后会丢失事件，而 Log4j 2 不会。在 Logback 中，Appenders（输出源）中的异常对应用来说是不可见的，Log4j 2 中的 Appenders 可以配置为允许异常对应用可见；
2. Log4j 2 包含基于 [LMAX Disruptor library](https://lmax-exchange.github.io/disruptor/) 的下一代异步 Loggers。在多线程场景下，异步 Loggers 拥有 10 倍于 Log4j 1.x 和Logback 的生产力和低延迟量级；
3. Log4j 2 对于独立应用来说是 [garbage free](http://logging.apache.org/log4j/2.x/manual/garbagefree.html) 的，对于稳定输出日志 web 应用来说产生的垃圾也是很少的。这就减轻了垃圾回收器的压力从而在响应时间上有更好的性能；
4. Log4j 2 的[插件系统](http://logging.apache.org/log4j/2.x/manual/plugins.html)使得通过添加新的 [Appenders](http://logging.apache.org/log4j/2.x/manual/appenders.html)、 [Filters](http://logging.apache.org/log4j/2.x/manual/filters.html)、 [Layouts](http://logging.apache.org/log4j/2.x/manual/layouts.html)、 [Lookups](http://logging.apache.org/log4j/2.x/manual/lookups.html) 和 Pattern Converters 来扩展该框架变得非常容易，Log4j 本身不需要任何改变；
5. 可以通过代码或配置文件进行配置[自定义的日志级别](http://logging.apache.org/log4j/2.x/manual/customloglevels.html)；
6. 支持 [Lambda 表达式](http://logging.apache.org/log4j/2.x/manual/api.html#LambdaSupport)，基于 Java 8 的代码可以使用 Lambda 表达式简洁的创建日志的 Message；
7. 支持 [Message 对象](http://logging.apache.org/log4j/2.x/manual/messages.html) 。 我们可以自由地创建有趣、复杂的 Message 类型，编写自定义的 [Layouts](http://logging.apache.org/log4j/2.x/manual/layouts.html)、 [Filters](http://logging.apache.org/log4j/2.x/manual/filters.html) 和 [Lookups](http://logging.apache.org/log4j/2.x/manual/lookups.html) 来操作这些 Message 类型；
8. Log4j 1.x 支持在 Appenders 上使用 Filters，Logback 也添加了 TurboFilters 来在事件还未被 Logger 处理之前先过滤事件，Log4j 2 支持在事件被 Logger 处理之前配置 Filters 来处理事件，就像事件通过 Logger 处理或在 Appenders 上处理一样；
9. 多数 Logback Appenders 不支持使用 Layout 而仅支持固定格式的数据。 多数 Log4j 2 Appenders 可以使用 Layout 来输出任意期望格式的数据；
10. Log4j 1.x 中的 Layouts 以及 Logback 返回的是一个字符串，这导致了一些编码问题。而 Log4j 2 的 Layouts 总返回一个字节数组，这意味着该字节数组可以应用在任何 Appender 上，不仅仅是写入 OutputStream 中；
11. [Syslog Appender](http://logging.apache.org/log4j/2.x/manual/appenders.html#SyslogAppender) 支持 TCP 和 UDP 协议，也支持 BSD syslog 和  [RFC 5424](http://tools.ietf.org/html/rfc5424) 格式；
12. Log4j 2 应用了 Java 5 的并发支持和最低限度的加锁。Log4j 1.x 有一些死锁问题，这些问题多数在 Logback 得到了修复，但 Logback 类依然需要相当高级别的同步。

### Log4j 2 架构详解

Log4j 2 的架构图如下：

![Log4jClasses](/Log4jClasses.jpg)

LogManager 通过 `getLogger(final Class<?> clazz)` 静态方法将定位到合适的 LoggerContext，然后从中得到一个 Logger 对象，要创建 Logger 需要关联一个 LoggerConfig，该 LoggerConfig 对象在 Configuration 中关联着传送 LogEvents 的 Appenders。 

#### Logger Hierarchy

 Log4j 1.x 中的 Logger 层级由各 Loggers 之间的关系来维护，而在 Log4j 2 中这种关系已经不存在了， Logger 层级由 LoggerConfig 对象负责维护。Loggers 和 LoggerConfigs 都是命名的实体。Logger 的名称是大小写敏感的，遵循以下层级命名规则：

命名级别。如果一个 LoggerConfig 的名称 A 后有一个点号，该点号之后是另一个 LoggerConfig 的名称 B，B 后又有一个点号，该点号后是一个 Logger 名称 C，那么 A 是 C 的 ancestor，A 是 B 的 parent。

例如，名为 `com.foo` 的 LoggerConfig 是名为 `com.foo.Bar` 的 LoggerConfig 的 parent。类似的， `java` 是 `java.util` 的 parent，是 `java.util.Vector` 的 ancestor。这种命名模式对大多数开发者来说都是熟悉的。

root LoggerConfig 位于 LoggerConfig 层级的最顶级，它存在于在每个层级中。直接链接到 root LoggerConfig 的 Logger 可以这样获得：

```java
Logger logger = LogManager.getLogger(LogManager.ROOT_LOGGER_NAME);
```

也可以更简单些：

```
Logger logger = LogManager.getRootLogger();
```

其他 Loggers 可以通过调用 `LogManager.getLogger(final String name)` 静态方法、传入期望的 Logger 名来获取。

#### LoggerContext

[LoggerContext](http://logging.apache.org/log4j/2.x/log4j-core/apidocs/org/apache/logging/log4j/core/LoggerContext.html) 充当着日志系统的锚点。不同情况下一个应用可以有多个有效的 LoggerContexts。

#### Configuration

每个 LoggerContext  都有一个有效的 [Configuration](http://logging.apache.org/log4j/2.x/log4j-core/apidocs/org/apache/logging/log4j/core/config/Configuration.html) ，该 Configuration 包含了所有的 Appenders、上下文范围的 Filters ，以及 LoggerConfigs， 并包含了 StrSubstitutor 的引用。在重新配置时会存在两个 Configuration。一旦所有的 Loggers 重定向到新的 Configuration，旧的 Configuration 就会被停止和禁用。

#### Logger

Logger  本身执行无指向的动作，它有一个与 LoggerConfig 关联的名称，继承了 AbstractLogger 并实现了其必需的方法，当配置被修改了，Loggers 可能转而关联不同的 LoggerConfig 从而会改变其自身的行为。如果调用 `LogManager.getLogger` 方法时使用相同的名称参数，则总会返回同一个 Logger 对象。例如：

```
Logger x = LogManager.getLogger("wombat");
Logger y = LogManager.getLogger("wombat");
```

`x` 和`y` 参照的实际上是同一个 Logger 对象。通过将 Logger 命名为其所在类的全限定名可以使输出的日志更具可辨识性，这是目前最好的做法。这不是强制的，开发者可以为 Loggers 起任意的期望名称 。既然一般习惯使用所在类的全限定名命名 Loggers ，所以 `LogManager.getLogger()` 方法默认创建使用所在类全限定名命名的 Logger。

#### LoggerConfig

[LoggerConfig](http://logging.apache.org/log4j/2.x/log4j-core/apidocs/org/apache/logging/log4j/core/config/LoggerConfig.html) 对象创建于 Loggers 在配置文件中声明的时候。LoggerConfig 包含一些 Filters，这些 Filters 必须在 LogEvent 传递给 Appenders 之前允许其通过。它还包含了一些 Appenders 的引用，这些 Appenders 用来处理事件。

##### Log Levels

LoggerConfigs 会被分配一个日志[级别](https://logging.apache.org/log4j/2.x/log4j-api/apidocs/org/apache/logging/log4j/Level.html)。内建的日志级别有 TRACE、 DEBUG、INFO、WARN、ERROR 和 FATAL。Log4j 2也支持[自定义日志级别](https://logging.apache.org/log4j/2.x/manual/customloglevels.html)，另一种更细粒度化的机制是使用 [Markers](https://logging.apache.org/log4j/2.x/log4j-api/api.html#Markers) 来替代。

Log4j 1.x 和 Logback 都有一个级别继承的概念。Log4j 2 中，Loggers 和 LoggerConfigs 是两个不同的对象，所以这个概念也有所不同。每个 Logger 参照合适的 LoggerConfig  ，该 LoggerConfig  又反过来继承了其 parent LoggerConfig 的日志级别。注意如果 root LoggerConfig 没有配置则它会被分配一个默认的日志级别。

在下面的示例中，只有 `root` Logger 通过与其名称匹配的 LoggerConfig 配置一个日志级别，所有其他参照了它的 Loggers 也使用了其日志级别。

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

在下面的示例中，`root` 、`X` 和 `X.Y.Z` Logger 每个都配置了各自的 LoggerConfig，但 `X.Y` Logger 没有配置匹配名称的 LoggerConfig，所以，它使用 `X` 的 LoggerConfig。

| Logger Name | Assigned LoggerConfig | LoggerConfig Level | Level |
| ----------- | --------------------- | ------------------ | ----- |
| root        | root                  | DEBUG              | DEBUG |
| X           | X                     | ERROR              | ERROR |
| X.Y         | X                     | ERROR              | ERROR |
| X.Y.Z       | X.Y.Z                 | WARN               | WARN  |

在下面的示例中，`root` 和 `X` Logger 都配置了与各自名称匹配的 LoggerConfig，`X.Y` 和 `X.Y.Z` Logger 没有匹配 LoggerConfig，所以从分配给它们的 `X` LoggerConfig  中获取其日志级别。

| Logger Name | Assigned LoggerConfig | LoggerConfig Level | level |
| ----------- | --------------------- | ------------------ | ----- |
| root        | root                  | DEBUG              | DEBUG |
| X           | X                     | ERROR              | ERROR |
| X.Y         | X                     | ERROR              | ERROR |
| X.Y.Z       | X                     | ERROR              | ERROR |

在下面的示例中，`root` ，`X` 和 `X.Y` Logger 都配置了与其各自名称匹配的 LoggerConfig，但 `X.YZ` Logger 没有配置 LoggerConfig，所以从分配给它的 `X` LoggerConfig 中获取其日志级别。由此可见，日志级别是继承自上一级的。  

| Logger Name | Assigned LoggerConfig | LoggerConfig Level | level |
| ----------- | --------------------- | ------------------ | ----- |
| root        | root                  | DEBUG              | DEBUG |
| X           | X                     | ERROR              | ERROR |
| X.Y         | X.Y                   | INFO               | INFO  |
| X.YZ        | X                     | ERROR              | ERROR |

在下面的示例中，`X.Y` Logger 没有配置级别（不是没有配置 LoggerConfig），所以，它从 `X` LoggerConfig 获取其日志级别。而 `X.Y.Z` Logger 使用 `X.Y` LoggerConfig 从而其级别也从 `X` LoggerConfig 获得。

| Logger Name | Assigned LoggerConfig | LoggerConfig Level | Level |
| ----------- | --------------------- | ------------------ | ----- |
| root        | root                  | DEBUG              | DEBUG |
| X           | X                     | ERROR              | ERROR |
| X.Y         | X.Y                   |                    | ERROR |
| X.Y.Z       | X.Y                   |                    | ERROR |

下面的表格解释了级别过滤的工作机制。

![BaiduShurufa_2017-11-2_22-20-22](/BaiduShurufa_2017-11-2_22-20-22.png)

#### Filter

除了日志级别的自动过滤， Log4j 还提供了 [Filter](http://logging.apache.org/log4j/2.x/log4j-core/apidocs/org/apache/logging/log4j/core/Filter.html)s ，在控制到达 LoggerConfig 之前、在控制到达 LoggerConfig 之后但在调用任何 Appenders 之前、在控制到 LoggerConfig 之后但在调用某个特定 Appender 之前，以及在每个 Appender 上都可以使用 Filter 进行过滤日志级别。

类似于防火墙的过滤器一样，每个 Filter 都可以返回 `Accept`、`Deny` 和 `Neutral`（中立）三个值之一：

- `Accept` 表示不会调用其他 Filters，事件将进行处理；
- `Deny` 表示事件被立即忽略并将控制返回给调用者；
- `Neutral` 表示事件将传递给其他 Filters，如果没有其他 Filters，则事件将会被处理。

即使一个事件被某个 Filter 接受了也不一定会输出。当事件被某个前置 LoggerConfig Filter 接受了但被后面的 LoggerConfig 拒绝了或被所有 Appenders 拒绝了就会出现这样的情况。

#### Appender

 Log4j 可将日志打印输出到多种位置（目前可以为控制台、文件、多种数据库 API、远程套接字服务器、Apache Flume、JMS、远程 UNIX Syslog daemon），Log4j 中的日志输出位置称为 [Appender](http://logging.apache.org/log4j/2.x/log4j-core/apidocs/org/apache/logging/log4j/core/Appender.html)。可以通过调用当前 Configuration 的[addLoggerAppender](http://logging.apache.org/log4j/2.x/log4j-core/apidocs/org/apache/logging/log4j/core/config/Configuration.html#addLoggerAppenderorg.apache.logging.log4j.core.Logger20org.apache.logging.log4j.core.Appender) 方法将一个 Appender 添加给一个 Logger。如果一个 Logger 匹配的同名 LoggerConfig 不存在，就会创建一个，Appender 将被添加到该 LoggerConfig，所有其他 Loggers 将会收到通知并更新其 LoggerConfig 引用。

给定 Logger 允许的所有日志打印请求都会传递给该 Logger 的 LoggerConfig 中的所有 Appenders，也会传递给该 LoggerConfig 的 parent LoggerConfig。也就是说，Appenders 会从 LoggerConfig 继承中叠加继承。例如，如果一个控制台 Appender 添加到 root Logger中，那么所有允许的日志打印请求将至少输出到控制台，如果一个文件 Appender添加到一个 LoggerConfig C 中，C 和 C 的 children 允许的日志打印请求将会输出到文件和控制台。可以在声明 Logger 的配置文件中设置 `additivity="false"` 来禁用这种叠加继承。

> Appender Additivity
>
> Logger L的一条日志打印语句将输出到 L 关联的 LoggerConfig C 中的所有 Appenders 以及该 LoggerConfig 的 ancestors。然而，如果 LoggerConfig 一个 ancestor P 的叠加标志设置为了 `false`，L 的输出将直接指向 C 中的所有 Appenders 以及 C 的 ancestor 直到 P（包括 P），不会指向到 P 的 ancestors 中的 Appenders。Logger 的叠加标识默认为 `true`。

下面的表格展示了一个示例：

| Logger Name     | Added Appenders | Additivity Flag | Output Targets         | Comment                                  |
| --------------- | --------------- | --------------- | ---------------------- | ---------------------------------------- |
| root            | A1              | not applicable  | A1                     | root Logger 没有 parent，所有叠加在这里不适用。        |
| x               | A-x1, A-x2      | true            | A1, A-x1, A-x2         | x 的所有 Appenders 以及 root。                 |
| x.y             | none            | true            | A1, A-x1, A-x2         | x 的所有 Appenders 以及 root。但一般不会配置一个没有 Appender 的 Logger。 |
| x.y.z           | A-xyz1          | true            | A1, A-x1, A-x2, A-xyz1 | x.y.z、x 和 root 中的所有 Appenders。           |
| security        | A-sec           | false           | A-sec                  | 由于叠加标志设置为 `false`，所有没有Appender 的叠加。      |
| security.access | none            | true            | A-sec                  | 仅 security 的 Appenders 有叠加，因为 security 的叠加标志设置为了 `false`。 |

#### Layout

Appender 的 [Layout](http://logging.apache.org/log4j/2.x/log4j-core/apidocs/org/apache/logging/log4j/core/Layout.html) 用来自定义日志事件的输出格式。[PatternLayout](http://logging.apache.org/log4j/2.x/log4j-core/apidocs/org/apache/logging/log4j/core/layout/PatternLayout.html) 可以使用与 C 语言 printf 函数类似的转换模式来指定输出格式。Log4j 提供了多种不同的 [Layouts](http://logging.apache.org/log4j/2.x/manual/layouts.html) 适用于多种形式的输出，如JSON,、XML、HTML 和 Syslog (包括最新的 RFC 5424 版本)。

#### StrSubstitutor and StrLookup

[StrSubstitutor ](http://logging.apache.org/log4j/2.x/log4j-core/apidocs/org/apache/logging/log4j/core/lookup/StrSubstitutor.html) 类和 [StrLookup](http://logging.apache.org/log4j/2.x/log4j-core/apidocs/org/apache/logging/log4j/core/lookup/StrLookup.html) 接口是从 [Apache Commons Lang](https://commons.apache.org/proper/commons-lang/) 借鉴修改而来用以处理 LogEvents。另外，[Interpolator](http://logging.apache.org/log4j/2.x/log4j-core/apidocs/org/apache/logging/log4j/core/lookup/Interpolator.html) 类是从 Apache Commons Configuration 借鉴修改而来从而使 StrSubstitutor 可以处理多个 StrLookups 中的变量，该类也经过修改可以支持处理 LogEvents。这些类一起让配置可以引用 System Properties 、配置文件、ThreadContext Map以及 LogEvent 的 StructuredData 中的变量。