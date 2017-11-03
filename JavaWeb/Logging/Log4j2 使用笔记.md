---
typora-copy-images-to: ..\appendix
typora-root-url: ..\appendix
---

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

Log4j 2 的架构图如下：

![Log4jClasses](/Log4jClasses.jpg)

LogManager 通过 `getLogger(final Class<?> clazz)` 静态方法将定位到合适的 LoggerContext，然后从中得到一个 Logger 对象，要创建 Logger 需要关联一个 LoggerConfig，该 LoggerConfig 对象在 Configuration 中关联着传送 LogEvents 的 Appenders。 

#### 日志级别

 Log4j 1.x 中的日志级别由 Loggers 之间的关系来维护，在  Log4j 2 中这些关系已经不存在了，日志级别由 LoggerConfig  对象负责维护。Loggers 和 LoggerConfigs 都是命名的实体。Logger 的名称是大小写敏感的，遵循以下级别命名规则：

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

LoggerConfigs will be assigned a Log [Level](http://logging.apache.org/log4j/2.x/log4j-api/apidocs/org/apache/logging/log4j/Level.html). The set of built-in levels includes TRACE, DEBUG, INFO, WARN, ERROR, and FATAL. Log4j 2 also supports [custom log levels](http://logging.apache.org/log4j/2.x/manual/customloglevels.html). Another mechanism for getting more granularity is to use [Markers](http://logging.apache.org/log4j/2.x/log4j-api/api.html#Markers) instead.

[Log4j 1.x](http://logging.apache.org/log4j/1.2/manual.html) and [Logback](http://logback.qos.ch/manual/architecture.html#effectiveLevel) both have the concept of "Level Inheritance". In Log4j 2, Loggers and LoggerConfigs are two different objects so this concept is implemented differently. Each Logger references the appropriate LoggerConfig which in turn can reference its parent, thus achieving the same effect.

Below are five tables with various assigned level values and the resulting levels that will be associated with each Logger. Note that in all these cases if the root LoggerConfig is not configured a default Level will be assigned to it.

| Logger Name | Assigned LoggerConfig | LoggerConfig Level | Logger Level |
| ----------- | --------------------- | ------------------ | ------------ |
| root        | root                  | DEBUG              | DEBUG        |
| X           | root                  | DEBUG              | DEBUG        |
| X.Y         | root                  | DEBUG              | DEBUG        |
| X.Y.Z       | root                  | DEBUG              | DEBUG        |

In example 1 above, only the root logger is configured and has a Log Level. All the other Loggers reference the root LoggerConfig and use its Level.

| Logger Name | Assigned LoggerConfig | LoggerConfig Level | Level |
| ----------- | --------------------- | ------------------ | ----- |
| root        | root                  | DEBUG              | DEBUG |
| X           | X                     | ERROR              | ERROR |
| X.Y         | X.Y                   | INFO               | INFO  |
| X.Y.Z       | X.Y.Z                 | WARN               | WARN  |

In example 2, all loggers have a configured LoggerConfig and obtain their Level from it.

| Logger Name | Assigned LoggerConfig | LoggerConfig Level | Level |
| ----------- | --------------------- | ------------------ | ----- |
| root        | root                  | DEBUG              | DEBUG |
| X           | X                     | ERROR              | ERROR |
| X.Y         | X                     | ERROR              | ERROR |
| X.Y.Z       | X.Y.Z                 | WARN               | WARN  |

In example 3, the loggers`root`, `X` and `X.Y.Z` each have a configured LoggerConfig with the same name. The Logger `X.Y` does not have a configured LoggerConfig with a matching name so uses the configuration of LoggerConfig `X` since that is the LoggerConfig whose name has the longest match to the start of the Logger's name.

| Logger Name | Assigned LoggerConfig | LoggerConfig Level | level |
| ----------- | --------------------- | ------------------ | ----- |
| root        | root                  | DEBUG              | DEBUG |
| X           | X                     | ERROR              | ERROR |
| X.Y         | X                     | ERROR              | ERROR |
| X.Y.Z       | X                     | ERROR              | ERROR |

In example 4, the loggers `root` and `X` each have a Configured LoggerConfig with the same name. The loggers `X.Y` and `X.Y.Z` do not have configured LoggerConfigs and so get their Level from the LoggerConfig assigned to them,`X`, since it is the LoggerConfig whose name has the longest match to the start of the Logger's name.

| Logger Name | Assigned LoggerConfig | LoggerConfig Level | level |
| ----------- | --------------------- | ------------------ | ----- |
| root        | root                  | DEBUG              | DEBUG |
| X           | X                     | ERROR              | ERROR |
| X.Y         | X.Y                   | INFO               | INFO  |
| X.YZ        | X                     | ERROR              | ERROR |

In example 5, the loggers`root`.`X`, and `X.Y` each have a Configured LoggerConfig with the same name. The logger `X.YZ` does not have configured LoggerConfig and so gets its Level from the LoggerConfig assigned to it,`X`, since it is the LoggerConfig whose name has the longest match to the start of the Logger's name. It is not associated with LoggerConfig `X.Y` since tokens after periods must match exactly.

| Logger Name | Assigned LoggerConfig | LoggerConfig Level | Level |
| ----------- | --------------------- | ------------------ | ----- |
| root        | root                  | DEBUG              | DEBUG |
| X           | X                     | ERROR              | ERROR |
| X.Y         | X.Y                   |                    | ERROR |
| X.Y.Z       | X.Y                   |                    | ERROR |

In example 6, LoggerConfig X.Y it has no configured level so it inherits its level from LoggerConfig X. Logger X.Y.Z uses LoggerConfig X.Y since it doesn't have a LoggerConfig with a name that exactly matches. It too inherits its logging level from LoggerConfig X.

The table below illustrates how Level filtering works. In the table, the vertical header shows the Level of the LogEvent, while the horizontal header shows the Level associated with the appropriate LoggerConfig. The intersection identifies whether the LogEvent would be allowed to pass for further processing (Yes) or discarded (No).

| Event Level | LoggerConfig Level |       |      |      |       |       |      |
| ----------- | ------------------ | ----- | ---- | ---- | ----- | ----- | ---- |
|             | TRACE              | DEBUG | INFO | WARN | ERROR | FATAL | OFF  |
| ALL         | YES                | YES   | YES  | YES  | YES   | YES   | NO   |
| TRACE       | YES                | NO    | NO   | NO   | NO    | NO    | NO   |
| DEBUG       | YES                | YES   | NO   | NO   | NO    | NO    | NO   |
| INFO        | YES                | YES   | YES  | NO   | NO    | NO    | NO   |
| WARN        | YES                | YES   | YES  | YES  | NO    | NO    | NO   |
| ERROR       | YES                | YES   | YES  | YES  | YES   | NO    | NO   |
| FATAL       | YES                | YES   | YES  | YES  | YES   | YES   | NO   |
| OFF         | NO                 | NO    | NO   | NO   | NO    | NO    | NO   |

#### Filter

In addition to the automatic log Level filtering that takes place as described in the previous section, Log4j provides [Filter](http://logging.apache.org/log4j/2.x/log4j-core/apidocs/org/apache/logging/log4j/core/Filter.html)s that can be applied before control is passed to any LoggerConfig, after control is passed to a LoggerConfig but before calling any Appenders, after control is passed to a LoggerConfig but before calling a specific Appender, and on each Appender. In a manner very similar to firewall filters, each Filter can return one of three results, `Accept`, `Deny` or `Neutral`. A response of `Accept`means that no other Filters should be called and the event should progress. A response of `Deny` means the event should be immediately ignored and control should be returned to the caller. A response of `Neutral` indicates the event should be passed to other Filters. If there are no other Filters the event will be processed.

Although an event may be accepted by a Filter the event still might not be logged. This can happen when the event is accepted by the pre-LoggerConfig Filter but is then denied by a LoggerConfig filter or is denied by all Appenders.

#### Appender

The ability to selectively enable or disable logging requests based on their logger is only part of the picture. Log4j allows logging requests to print to multiple destinations. In log4j speak, an output destination is called an [Appender](http://logging.apache.org/log4j/2.x/log4j-core/apidocs/org/apache/logging/log4j/core/Appender.html). Currently, appenders exist for the console, files, remote socket servers, Apache Flume, JMS, remote UNIX Syslog daemons, and various database APIs. See the section on [Appenders](http://logging.apache.org/log4j/2.x/manual/appenders.html) for more details on the various types available. More than one Appender can be attached to a Logger.

An Appender can be added to a Logger by calling the [addLoggerAppender](http://logging.apache.org/log4j/2.x/log4j-core/apidocs/org/apache/logging/log4j/core/config/Configuration.html#addLoggerAppenderorg.apache.logging.log4j.core.Logger20org.apache.logging.log4j.core.Appender) method of the current Configuration. If a LoggerConfig matching the name of the Logger does not exist, one will be created, the Appender will be attached to it and then all Loggers will be notified to update their LoggerConfig references.

**Each enabled logging request for a given logger will be forwarded to all the appenders in that Logger's LoggerConfig as well as the Appenders of the LoggerConfig's parents.** In other words, Appenders are inherited additively from the LoggerConfig hierarchy. For example, if a console appender is added to the root logger, then all enabled logging requests will at least print on the console. If in addition a file appender is added to a LoggerConfig, say *C*, then enabled logging requests for *C*and *C*'s children will print in a file *and* on the console. It is possible to override this default behavior so that Appender accumulation is no longer additive by setting `additivity="false"` on the Logger declaration in the configuration file.

The rules governing appender additivity are summarized below.

- **Appender Additivity**

  The output of a log statement of Logger *L* will go to all the Appenders in the LoggerConfig associated with *L* and the ancestors of that LoggerConfig. This is the meaning of the term "appender additivity".However, if an ancestor of the LoggerConfig associated with Logger *L*, say *P*, has the additivity flag set to `false`, then *L*'s output will be directed to all the appenders in *L*'s LoggerConfig and it's ancestors up to and including *P* but not the Appenders in any of the ancestors of *P*.Loggers have their additivity flag set to `true` by default.

The table below shows an example:

| LoggerName      | AddedAppenders | AdditivityFlag | Output Targets         | Comment                                  |
| --------------- | -------------- | -------------- | ---------------------- | ---------------------------------------- |
| root            | A1             | not applicable | A1                     | The root logger has no parent so additivity does not apply to it. |
| x               | A-x1, A-x2     | true           | A1, A-x1, A-x2         | Appenders of "x" and root.               |
| x.y             | none           | true           | A1, A-x1, A-x2         | Appenders of "x" and root. It would not be typical to configure a Logger with no Appenders. |
| x.y.z           | A-xyz1         | true           | A1, A-x1, A-x2, A-xyz1 | Appenders in "x.y.z", "x" and root.      |
| security        | A-sec          | false          | A-sec                  | No appender accumulation since the additivity flag is set to `false`. |
| security.access | none           | true           | A-sec                  | Only appenders of "security" because the additivity flag in "security" is set to `false`. |

#### Layout

More often than not, users wish to customize not only the output destination but also the output format. This is accomplished by associating a [Layout](http://logging.apache.org/log4j/2.x/log4j-core/apidocs/org/apache/logging/log4j/core/Layout.html) with an Appender. The Layout is responsible for formatting the LogEvent according to the user's wishes, whereas an appender takes care of sending the formatted output to its destination. The [PatternLayout](http://logging.apache.org/log4j/2.x/log4j-core/apidocs/org/apache/logging/log4j/core/layout/PatternLayout.html), part of the standard log4j distribution, lets the user specify the output format according to conversion patterns similar to the C language `printf` function.

For example, the PatternLayout with the conversion pattern "%r [%t] %-5p %c - %m%n" will output something akin to:

```
176 [main] INFO  org.foo.Bar - Located nearest gas station.
```

The first field is the number of milliseconds elapsed since the start of the program. The second field is the thread making the log request. The third field is the level of the log statement. The fourth field is the name of the logger associated with the log request. The text after the '-' is the message of the statement.

Log4j comes with many different [Layouts](http://logging.apache.org/log4j/2.x/manual/layouts.html) for various use cases such as JSON, XML, HTML, and Syslog (including the new RFC 5424 version). Other appenders such as the database connectors fill in specified fields instead of a particular textual layout.

Just as importantly, log4j will render the content of the log message according to user specified criteria. For example, if you frequently need to log `Oranges`, an object type used in your current project, then you can create an OrangeMessage that accepts an Orange instance and pass that to Log4j so that the Orange object can be formatted into an appropriate byte array when required.

#### StrSubstitutor and StrLookup

The [StrSubstitutor ](http://logging.apache.org/log4j/2.x/log4j-core/apidocs/org/apache/logging/log4j/core/lookup/StrSubstitutor.html)class and [StrLookup](http://logging.apache.org/log4j/2.x/log4j-core/apidocs/org/apache/logging/log4j/core/lookup/StrLookup.html) interface were borrowed from [Apache Commons Lang](https://commons.apache.org/proper/commons-lang/) and then modified to support evaluating LogEvents. In addition the [Interpolator](http://logging.apache.org/log4j/2.x/log4j-core/apidocs/org/apache/logging/log4j/core/lookup/Interpolator.html) class was borrowed from Apache Commons Configuration to allow the StrSubstitutor to evaluate variables that from multiple StrLookups. It too was modified to support evaluating LogEvents. Together these provide a mechanism to allow the configuration to reference variables coming from System Properties, the configuration file, the ThreadContext Map, StructuredData in the LogEvent. The variables can either be resolved when the configuration is processed or as each event is processed, if the component is capable of handling it. See [Lookups](http://logging.apache.org/log4j/2.x/manual/lookups.html) for more information.