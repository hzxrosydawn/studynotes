### 简介

Druid 数据源是一款阿里巴巴数据库事业部出品、**为监控而生**的 Java 数据库连接池。Druid 是一个 JDBC 组件库，包含数据库连接池、SQL Parser 等组件, 被大量业务和技术产品使用或集成，经历过最严苛线上业务场景考验，是你值得信赖的技术产品。

Github 项目地址：<https://github.com/alibaba/druid>，WIKI 地址：https://github.com/alibaba/druid/wiki。

### 数据库密码加密

进入 Maven 本地仓库执行以下命令就可以使用 Druid 自带的 RSA（512位）对你的数据库密码加密：

```
java -cp druid-1.1.18.jar com.alibaba.druid.filter.config.ConfigTools you_password
privateKey:MIIBVAIBADANBgkqhkiG9w0BAQEFAASCAT4wggE6AgEAAkEApxYcfuieK9Wf063pV9Vqn1F1/m/pvFVkQ/7sL2m5/PcXz2MKxBLt9edvJOZdkVFl1u8DslbixoRpY0uHc3h5GQIDAQABAkA/s6RllhZHrAhlUda2z/z4hLwxp0U7smqpqdUuNmbcVFKcJjlxP4bAYkDaPJGT/uIlKiyKvbCdrkuce/SS28dJAiEA0lO0qhmx9GgkgqYzjMIGObDkHzNRk+cEruEgPW2EnOcCIQDLXp2eqFxX//h50dFez1R0InlIfDYF3k0UtDa2ajF5/wIgQvl+rS/Td/V1stjDz421N8e5TKolzwggeKOdhZILSX8CIQCpKSVwoFhXdnpHUiiWdVypUTeS/IavMO7qxtAvwXswHwIgVIh3wTqlQGxK8ovf2GuX/tfSGZ7qzZbxu7WYiwAe3WE=
publicKey:MFwwDQYJKoZIhvcNAQEBBQADSwAwSAJBAKcWHH7onivVn9Ot6VfVap9Rdf5v6bxVZEP+7C9pufz3F89jCsQS7fXnbyTmXZFRZdbvA7JW4saEaWNLh3N4eRkCAwEAAQ==
password:OgtRnl7pMOFnCg6aeVpbReoyNpYcJBg+RTVycg61F5p8/l2BwQYu7d7Jj+dS0MMGwRpdoYcQuB3Ujk6h31A7BQ==
```

然后，就可以将解密所用的公钥和加密的密码密文配置到 Spring 应用的 properties 或 yaml  格式的配置文件中了，这样，ConfigFilter 就会解密密码。

### 整合 Spring

#### pom.xml 配置

```xml
<dependency>
    <groupId>com.alibaba</groupId>
    <artifactId>druid</artifactId>
    <version>1.1.18</version>
</dependency>
```

> 注意：请尽量使用最新版的 druid，以及时规避漏洞。

#### Spring 整合 Druid 的 xml 配置

```xml
<!--配置 druid 数据库连接池。-->
<!-- 外部属性文件读入 -->
<bean id="druidDataSource" class="com.alibaba.druid.pool.DruidDataSource" init-method="init" destroy-method="close">
  <property name="url" value="${jdbc.jdbcUrl}"/>
  <!--这一项可配可不配，如果不配置，druid 会根据 url 自动识别 dbType，然后选择相应的 driverClassName。建议配置下。-->
  <property name="driverClassName" value="${jdbc.driverClassName}"/>
  <property name="username" value="${jdbc.username}"/>
  <property name="password" value="${jdbc.password}"/>
  <!--通常来说，只需要修改initialSize、minIdle、maxActive。-->
  <!--初始化时建立物理连接的个数。初始化发生在显示调用 init 方法，或者第一次 getConnection 时。-->
  <property name="initialSize" value="${jdbc.initialSize}"/>
  <!--最小连接数量。-->
  <property name="minIdle" value="${jdbc.minIdle}"/>
  <!--最大连接数量。-->
  <property name="maxActive" value="${jdbc.maxActive}"/>
  <!--是否缓存 preparedStatement，也就是 PSCache。
        PSCache 对支持游标的数据库（如 Oracle）性能提升巨大，其他数据库配置为 false。分库分表较多的数据库，建议配置为 false。-->
  <property name="poolPreparedStatements" value="false"/>
  <!--要启用 PSCache，必须配置大于 0，当大于 0 时，poolPreparedStatements 自动触发修改为 true。
        在 Druid 中，不会存在 Oracle 下 PSCache 占用内存过多的问题，可以把这个数值配置大一些，比如说 100。-->
  <property name="maxOpenPreparedStatements" value="-1"/>
  <!--指定每个连接上 PSCache 的大小。-->
  <property name="maxPoolPreparedStatementPerConnectionSize" value="20"/>
  <!-- 配置一个连接在池中最小生存的时间，单位是毫秒 -->
  <property name="minEvictableIdleTimeMillis" value="30000"/>
  <!-- 配置获取连接等待超时的时间，单位为毫秒。-->
  <property name="maxWait" value="10000"/>
  <!--是否自动提交，默认为 true，可以不用配置。-->
  <property name="defaultAutoCommit" value="true"/>
  <!--验证连接可用与否的 SQL，可以通过以下三个以名称 test 开头属性配置何时进行检查。-->
  <property name="validationQuery" value="SELECT 1"/>
  <!-- 申请连接时执行 validationQuery 检测连接是否有效，做了这个配置会降低性能。-->
  <property name="testOnBorrow" value="false"/>
  <!--归还连接时执行 validationQuery 检测连接是否有效，做了这个配置会降低性能。-->
  <property name="testOnReturn" value="false"/>
  <!--空闲时时执行 validationQuery 检测连接是否有效。如果空闲时间大于 timeBetweenEvictionRunsMillis，
        执行 validationQuery 检测连接是否有效。-->
  <property name="testWhileIdle" value="true"/>
  <!-- 配置间隔多久才进行一次检测，检测需要关闭的空闲连接，单位是毫秒。-->
  <property name="timeBetweenEvictionRunsMillis" value="60000"/>
  <!--。-->
  <property name="filters" value="wall,config"/>
  <!--配置解密密码的RSA算法公钥。用法参考：https://github.com/alibaba/druid/wiki/%E4%BD%BF%E7%94%A8ConfigFilter。
        相比于 proxyFilters 在引用的 bean 中配置插件，filters 使用 connectionProperties 配置插件。-->
  <property name="connectionProperties" value="config.decrypt=true;config.decrypt.key=${jdbc.publicKey}"/>
  <!--也可以通过bean的方式配置扩展插件。-->
  <property name="proxyFilters">
    <list>
      <!--配置记录SQL日志的插件。-->
      <ref bean="slf4Filter"/>
      <!--配置监控插件-->
      <ref bean="statFilter"/>
    </list>
  </property>
  <!--filters 和 proxyFilters 属性是组合关系的，不是替换的。-->
  <!--指定数据源名称。当存在多个数据源时，监控的时候可以通过名字来区分开来。-->
  <property name="name" value="${jdbc.dataSourceName}"/>
  <!--合并多个数据源的监控数据。-->
  <!--<property name="useGlobalDataSourceStat" value="true"/>-->
</bean>
<!--配置 druid 日志插件配置。同时还需要在 log4j x 的配置文件里配置 SQL 日志输出的 appender。-->
<bean id="slf4Filter" class="com.alibaba.druid.filter.logging.Slf4jLogFilter">
  	<!--输出可执行的SQL。-->
    <property name="statementExecutableSqlLogEnable" value="true"/>
    <!--不输出结果集。-->
    <property name="resultSetLogEnabled" value="false"/>
</bean>
<!--配置 druid 监控插件。-->
<bean id="statFilter" class="com.alibaba.druid.filter.stat.StatFilter">
  	<!--配置慢SQL的时间。执行时间超过 slowSqlMillis 的就是慢 SQL。单位为毫秒。-->
    <property name="slowSqlMillis" value="10000"/>
    <!--是否打印慢 SQL。-->
    <property name="logSlowSql" value="true"/>
    <!--是否合并仅参数不同的某些 SQL。-->
    <property name="mergeSql" value="true"/>
</bean>
```

#### 配置 Filter

DruidDataSource 支持通过 Filter-Chain 模式进行扩展，类似 Serlvet 的 Filter，扩展十分方便，你可以拦截任何 JDBC 的方法。有两种配置 Filter 的方式，一种是配置 filters 属性，一种是配置 proxyFilters 属性。filters 和 proxyFilters 的配置是组合关系，而不是替换关系。

可以设置 filters 属性的值为几个逗号分隔的 Filter 别名列表来配置扩展插件。常用的插件有：

- stat，表示监控统计；
- log4j、log4j2、slf4j、commonLoggig 等表示使用日志记录 SQL 操作。如果这里要用，建议使用 slf4j；
- wall，表示防止防御 sql 注入；
- config，表示通过外部配置配置 druid。

所有可用的别名映射配置信息参考 druid-xxx.jar/META-INF/druid-filter.properties：

| Filter类名    | 别名                                                    |
| ------------- | ------------------------------------------------------- |
| default       | com.alibaba.druid.filter.stat.StatFilter                |
| stat          | com.alibaba.druid.filter.stat.StatFilter                |
| mergeStat     | com.alibaba.druid.filter.stat.MergeStatFilter           |
| encoding      | com.alibaba.druid.filter.encoding.EncodingConvertFilter |
| log4j         | com.alibaba.druid.filter.logging.Log4jFilter            |
| log4j2        | com.alibaba.druid.filter.logging.Log4j2Filter           |
| slf4j         | com.alibaba.druid.filter.logging.Slf4jLogFilter         |
| commonlogging | com.alibaba.druid.filter.logging.CommonsLogFilter       |
| wall          | com.alibaba.druid.wall.WallFilter                       |

通过设置 filters 属性启用的 Filter 都是默认配置。如果默认配置不能满足你的需求，你需要详细配置 Filter，那么，你可以放弃这种方式，通过使用 proxyFilters 属性来引用其他详细配置的 Filter。

##### 配置 WebStatFilter 

WebStatFilter 用于采集 web-jdbc 关联监控的数据。web.xml 配置如下：

```xml
<filter>
  	<filter-name>DruidWebStatFilter</filter-name>
  	<filter-class>com.alibaba.druid.support.http.WebStatFilter</filter-class>
    <!-- 经常需要排除一些不必要的url，比如*.js,/jslib/*等等 -->
  	<init-param>
  		<param-name>exclusions</param-name>
  		<param-value>*.js,*.gif,*.jpg,*.png,*.css,*.ico,/druid/*</param-value>
  	</init-param>
    <!-- 缺省sessionStatMaxCount是1000个。你可以按需要进行配置 -->
    <init-param>
  		<param-name>sessionStatMaxCount</param-name>
  		<param-value>1000</param-value>
  	</init-param>
    <!-- 你可以关闭session统计功能 -->
    <init-param>
  		<param-name>sessionStatEnable</param-name>
  		<param-value>false</param-value>
  	</init-param>
    <!-- 你可以配置principalSessionName，使得druid能够知道当前的session的用户是谁。根据需要，把其中的xxx.user修改为你user信息保存在session中的sessionName。如果你session中保存的是非string类型的对象，需要重载toString方法 -->
    <init-param>
  		<param-name>principalSessionName</param-name>
  		<param-value>xxx.user</param-value>
  	</init-param>
    <!-- 如果你的user信息保存在cookie中，你可以配置principalCookieName，使得druid知道当前的user是谁。根据需要，把其中的xxx.user修改为你user信息保存在cookie中的cookieNam -->
    <init-param>
  		<param-name>principalCookieName</param-name>
  		<param-value>xxx.user</param-value>
  	</init-param>
    <!-- druid 0.2.7版本开始支持profile，配置profileEnable能够监控单个url调用的sql列表 -->
    <init-param>
    	<param-name>profileEnable</param-name>
    	<param-value>true</param-value>
	</init-param>
</filter>
<filter-mapping>
  	<filter-name>DruidWebStatFilter</filter-name>
  	<url-pattern>/*</url-pattern>
</filter-mapping>

```

##### 配置 StatViewServlet

Druid 内置提供了一个 StatViewServlet 用于展示 Druid 的统计信息。这个 StatViewServlet 的用途包括：

- 提供监控信息展示的 html 页面
- 提供监控信息的 JSON API

注意：使用 StatViewServlet，建议使用 druid 0.2.6 以上版本。

StatViewServlet 是一个标准的 javax.servlet.http.HttpServlet，需要配置在你 web 应用中的 WEB-INF/web.xml 中：

```xml
<servlet>
  	<servlet-name>DruidStatView</servlet-name>
   	<servlet-class>com.alibaba.druid.support.http.StatViewServlet</servlet-class>
</servlet>
<servlet-mapping>
	<servlet-name>DruidStatView</servlet-name>
	<url-pattern>/druid/*</url-pattern>
</servlet-mapping>
```

根据配置中的 url-pattern 来访问内置监控页面，如果是上面的配置，内置监控页面的首页是 /druid/index.html，例如：
http://110.76.43.235:9000/druid/index.html，http://110.76.43.235:8080/mini-web/druid/index.html。

如果你需要配置访问监控页面的权限，可以配置 Servlet 的 loginUsername 和 loginPassword 这两个初始参数：

```xml
<!-- 配置 Druid 监控信息显示页面 -->  
<servlet>  
    <servlet-name>DruidStatView</servlet-name>  
    <servlet-class>com.alibaba.druid.support.http.StatViewServlet</servlet-class>  
    <init-param>  
	<!-- 允许清空统计数据 -->  
	<param-name>resetEnable</param-name>  
	<param-value>true</param-value>  
    </init-param>  
    <init-param>  
	<!-- 用户名 -->  
	<param-name>loginUsername</param-name>  
	<param-value>druid</param-value>  
    </init-param>  
    <init-param>  
	<!-- 密码 -->  
	<param-name>loginPassword</param-name>  
	<param-value>druid</param-value>  
    </init-param>  
</servlet>  
<servlet-mapping>  
    <servlet-name>DruidStatView</servlet-name>  
    <url-pattern>/druid/*</url-pattern>  
</servlet-mapping>  
```

StatViewSerlvet 展示出来的监控信息比较敏感，是系统运行的内部情况，如果你需要做访问控制，可以配置 allow 和 deny 这两个参数：

```xml
<servlet>
      <servlet-name>DruidStatView</servlet-name>
      <servlet-class>com.alibaba.druid.support.http.StatViewServlet</servlet-class>
  	<init-param>
  		<param-name>allow</param-name>
  		<param-value>128.242.127.1/24,128.242.128.1</param-value>
  	</init-param>
  	<init-param>
  		<param-name>deny</param-name>
  		<param-value>128.242.127.4</param-value>
  	</init-param>
  </servlet>
```

判断规则

- deny 优先于 allow，如果在 deny 列表中，就算在 allow 列表中，也会被拒绝；
- 如果 allow 没有配置或者为空，则允许所有访问。

ip 配置规则和格式

配置的格式

```xml
  <IP>
  或者
  <IP>/<SUB_NET_MASK_size>
```

其中，“128.242.127.1/24”中的 24 表示，前面 24 位是子网掩码，比对的时候，前面 24 位相同就匹配。由于匹配规则不支持 IPV6，配置了 allow 或者 deny 之后，会导致 IPV6 无法访问。

在 StatViewSerlvet 输出的 html 页面中，有一个功能是 Reset All，执行这个操作之后，会导致所有计数器清零，重新计数。你可以通过配置参数关闭它。

```xml
 <servlet>
      <servlet-name>DruidStatView</servlet-name>
      <servlet-class>com.alibaba.druid.support.http.StatViewServlet</servlet-class>
  	<init-param>
  		<param-name>resetEnable</param-name>
  		<param-value>false</param-value>
  	</init-param>
  </servlet>
```



> 建议通过配置用户的权限来限制哪些用户可以访问监控页面，而不是将密码明文配置在 webl.xml 中。

示例如下:

### 整合 Spring Boot  和  Log4j2

#### pom.xml 配置 

```xml
<!--Spring-boot中去掉logback的依赖，要作为第一个声明的spring-boot-starter。根据Maven依赖解析的声明优先原则，只会读取第一个去除了logback依赖的spring-boot-starter依赖-->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
    <exclusions>
        <exclusion>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-logging</artifactId>
        </exclusion>
    </exclusions>
</dependency>
<!--日志-->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-log4j2</artifactId>
</dependency>
<!--数据库连接池-->
<dependency>
    <groupId>com.alibaba</groupId>
    <artifactId>druid-spring-boot-starter</artifactId>
    <version>1.1.6</version>
</dependency>
<!--其他依赖-->
```

#### log4j2.xml 日志配置

虽然，Spring Boot 应用会自动寻找类路径下名为 log4j2.xml 日志配置文件，但仍建议将文件名设置为 spring-log4j2.xml。下面的日志置完整，可直接拷贝使用：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<configuration status="OFF">
    <appenders>
        <Console name="Console" target="SYSTEM_OUT">
            <!--只接受程序中DEBUG级别的日志进行处理-->
            <ThresholdFilter level="DEBUG" onMatch="ACCEPT" onMismatch="DENY"/>
            <PatternLayout pattern="[%d{HH:mm:ss.SSS}] %-5level %class{36} %L %M - %msg%xEx%n"/>
        </Console>

        <!--处理DEBUG级别的日志，并把该日志放到logs/debug.log文件中-->
        <!--打印出DEBUG级别日志，每次大小超过size，则这size大小的日志会自动存入按年份-月份建立的文件夹下面并进行压缩，作为存档-->
        <RollingFile name="RollingFileDebug" fileName="./logs/debug.log"
                     filePattern="logs/$${date:yyyy-MM}/debug-%d{yyyy-MM-dd}-%i.log.gz">
            <Filters>
                <ThresholdFilter level="DEBUG"/>
                <ThresholdFilter level="INFO" onMatch="DENY" onMismatch="NEUTRAL"/>
            </Filters>
            <PatternLayout
                    pattern="[%d{yyyy-MM-dd HH:mm:ss}] %-5level %class{36} %L %M - %msg%xEx%n"/>
            <Policies>
                <SizeBasedTriggeringPolicy size="500 MB"/>
                <TimeBasedTriggeringPolicy/>
            </Policies>
        </RollingFile>

        <!--处理INFO级别的日志，并把该日志放到logs/info.log文件中-->
        <RollingFile name="RollingFileInfo" fileName="./logs/info.log"
                     filePattern="logs/$${date:yyyy-MM}/info-%d{yyyy-MM-dd}-%i.log.gz">
            <Filters>
                <!--只接受INFO级别的日志，其余的全部拒绝处理-->
                <ThresholdFilter level="INFO"/>
                <ThresholdFilter level="WARN" onMatch="DENY" onMismatch="NEUTRAL"/>
            </Filters>
            <PatternLayout
                    pattern="[%d{yyyy-MM-dd HH:mm:ss}] %-5level %class{36} %L %M - %msg%xEx%n"/>
            <Policies>
                <SizeBasedTriggeringPolicy size="500 MB"/>
                <TimeBasedTriggeringPolicy/>
            </Policies>
        </RollingFile>

        <!--处理WARN级别的日志，并把该日志放到logs/warn.log文件中-->
        <RollingFile name="RollingFileWarn" fileName="./logs/warn.log"
                     filePattern="logs/$${date:yyyy-MM}/warn-%d{yyyy-MM-dd}-%i.log.gz">
            <Filters>
                <ThresholdFilter level="WARN"/>
                <ThresholdFilter level="ERROR" onMatch="DENY" onMismatch="NEUTRAL"/>
            </Filters>
            <PatternLayout
                    pattern="[%d{yyyy-MM-dd HH:mm:ss}] %-5level %class{36} %L %M - %msg%xEx%n"/>
            <Policies>
                <SizeBasedTriggeringPolicy size="500 MB"/>
                <TimeBasedTriggeringPolicy/>
            </Policies>
        </RollingFile>

        <!--处理error级别的日志，并把该日志放到logs/error.log文件中-->
        <RollingFile name="RollingFileError" fileName="./logs/error.log"
                     filePattern="logs/$${date:yyyy-MM}/error-%d{yyyy-MM-dd}-%i.log.gz">
            <ThresholdFilter level="ERROR"/>
            <PatternLayout
                    pattern="[%d{yyyy-MM-dd HH:mm:ss}] %-5level %class{36} %L %M - %msg%xEx%n"/>
            <Policies>
                <SizeBasedTriggeringPolicy size="500 MB"/>
                <TimeBasedTriggeringPolicy/>
            </Policies>
        </RollingFile>

        <!--druid的日志记录追加器-->
        <RollingFile name="druidSqlRollingFile" fileName="./logs/druid-sql.log"
                     filePattern="logs/$${date:yyyy-MM}/api-%d{yyyy-MM-dd}-%i.log.gz">
            <PatternLayout pattern="[%d{yyyy-MM-dd HH:mm:ss}] %-5level %L %M - %msg%xEx%n"/>
            <Policies>
                <SizeBasedTriggeringPolicy size="500 MB"/>
                <TimeBasedTriggeringPolicy/>
            </Policies>
        </RollingFile>
    </appenders>

    <loggers>
        <root level="DEBUG">
            <appender-ref ref="Console"/>
            <appender-ref ref="RollingFileInfo"/>
            <appender-ref ref="RollingFileWarn"/>
            <appender-ref ref="RollingFileError"/>
            <appender-ref ref="RollingFileDebug"/>
        </root>

        <!--记录druid-sql的记录-->
        <logger name="druid.sql.Statement" level="debug" additivity="false">
            <appender-ref ref="druidSqlRollingFile"/>
        </logger>
        <logger name="druid.sql.Statement" level="debug" additivity="false">
            <appender-ref ref="druidSqlRollingFile"/>
        </logger>

        <!--log4j2 自带过滤日志-->
        <Logger name="org.apache.catalina.startup.DigesterFactory" level="error" />
        <Logger name="org.apache.catalina.util.LifecycleBase" level="error" />
        <Logger name="org.apache.coyote.http11.Http11NioProtocol" level="warn" />
        <logger name="org.apache.sshd.common.util.SecurityUtils" level="warn"/>
        <Logger name="org.apache.tomcat.util.net.NioSelectorPool" level="warn" />
        <Logger name="org.crsh.plugin" level="warn" />
        <logger name="org.crsh.ssh" level="warn"/>
        <Logger name="org.eclipse.jetty.util.component.AbstractLifeCycle" level="error" />
        <Logger name="org.hibernate.validator.internal.util.Version" level="warn" />
        <logger name="org.springframework.boot.actuate.autoconfigure.CrshAutoConfiguration" level="warn"/>
        <logger name="org.springframework.boot.actuate.endpoint.jmx" level="warn"/>
        <logger name="org.thymeleaf" level="warn"/>
    </loggers>
</configuration>
```

#### application.yml 配置

下面是一个根据 Druid 官方文档介绍和 Druid 源码整理的十分完整配置（以 Oracle 数据库为例，注释里也有 MySQL 的配置说明）：

```yml
spring:
  datasource:
    name: druidDataSource
    type: com.alibaba.druid.pool.DruidDataSource
    druid:
      #############################################
      # 配置 druid 数据源常见必要配置
      #############################################
      # mysql数据库连接URL示例：jdbc:mysql://localhost:3306/test
      url: jdbc:oracle:thin:@localhost:1521:ORCL
      # driver-class-name 可配可不配，如果不配置，druid 会根据 url 自动识别 dbType，然后选择相应的 driverClassName。建议配置下
      # mysql数据库驱动类：com.mysql.jdbc.Driver
      driver-class-name: oracle.jdbc.driver.OracleDriver
      username: your_database_username
      # 密文密码。在maven本地仓库的druid的jar包目录下执行“java -cp druid-1.1.18.jar com.alibaba.druid.filter.config.ConfigTools you_password”会输出所用的加密私钥（每次执行加密都会变化）和公钥（默认一直不变），以及加密的密码密文
      password: OgtRnl7pMOFnCg6aeVpbReoyNpYcJBg+RTVycg61F5p8/l2BwQYu7d7Jj+dS0MMGwRpdoYcQuB3Ujk6h31A7BQ==
      # 初始连接大小
      initial-size: 10
      # 最大连接大小
      max-active: 50
      # 最小连接数
      min-idle: 10
      #############################################
      # druid 数据源其他配置
      #############################################
      # 是否缓存 preparedStatement，也就是 PSCache
      # PSCache 对支持游标的数据库（如 Oracle）性能提升巨大，其他数据库配置为 false。分库分表较多的数据库，建议配置为 false
      pool-prepared-statements: true
      # 指定每个连接上 PSCache 的大小。去掉后监控界面sql无法统计
      max-pool-prepared-statement-per-connection-size: 20
      # 配置获取连接等待超时的时间，单位为毫秒
      max-wait: 10000
      # 验证连接可用与否的 SQL，可以通过以下三个以名称 test 开头属性配置何时进行检查
      # MySQL、SQL Server、SQL Server测试连接语句：select 1
      validation-query: SELECT 1 FROM DUAL
      # 申请连接时执行 validationQuery 检测连接是否有效，做了这个配置会降低性能
      test-on-borrow: false
      # 归还连接时执行 validationQuery 检测连接是否有效，做了这个配置会降低性能
      test-on-return: false
      # 空闲时时执行 validationQuery 检测连接是否有效。空闲时间大于 timeBetweenEvictionRunsMillis 的连接会被执行 validationQuery 是否有效
      test-while-idle: true
      # 配置间隔多久才进行一次检测，检测需要关闭的空闲连接，单位是毫秒
      time-between-eviction-runs-millis: 60000
      # 配置一个连接在池中最小生存的时间，单位是毫秒
      min-evictable-idle-time-millis: 30000
      # 指定 validationQuery 的超时时间，单位是毫秒
      validation-query-timeout: 3000
 #########################################################################################################
      # filters 通过逗号分隔别名列表的方式配置扩展插件。常用的插件有：
      #   stat，表示监控统计；
      #   log4j、log4j2、slf4j、commonLogging 等表示使用日志记录 SQL 操作。如果这里要用，建议使用 slf4j；
      #   wall，表示防止防御sql注入；
      #   config，表示通过外部配置配置 druid。
      # 所有可用的别名映射配置信息参考 druid-xxx.jar!/META-INF/druid-filter.properties
      #########################################################################################################
      filters: stat,wall,slf4j # 配置多个英文逗号分隔，filters使用 connectionProperties配置插件
      # 配置connection-properties，启用RSA解密（512字节），这里不配置公钥，而是使用默认的公钥
      # Druid的ConfigTools每次加密的私钥会发生变化，但公钥默认不变
      #connect-properties: config.decrypt=true
      # 当然也可以通过config.decrypt.key配置引用的公钥
      connection-properties: config.decrypt=true;config.decrypt.key=${spring.datasource.druid.public-key}
      public-key: MFwwDQYJKoZIhvcNAQEBBQADSwAwSAJBAKcWHH7onivVn9Ot6VfVap9Rdf5v6bxVZEP+7C9pufz3F89jCsQS7fXnbyTmXZFRZdbvA7JW4saEaWNLh3N4eRkCAwEAAQ==
      # 监控配置
      web-stat-filter:  # 监控WebStatFilter配置，说明请参考Druid Wiki
        enabled: true
        url-pattern: /*
        exclusions: "*.js,*.gif,*.jpg,*.png,*.css,*.ico,/druid/*"
      #        session-stat-enable:
      #        session-stat-max-count:
      #        principal-session-name:
      #        principal-cookie-name:
      #        profile-enable:
      stat-view-servlet:  # StatViewServlet配置，说明请参考Druid Wiki
        enabled: true #是否启用StatViewServlet（监控页面）默认值为false（考虑到安全问题默认并未启动，如需启用建议设置密码或白名单以保障安全）
        reset-enable: false
        url-pattern: /druid/*
        #        login-username: admin
        #        login-password: admin
        # 添加IP白名单
        #allow:
        # 添加IP黑名单，当白名单和黑名单重复时，黑名单优先级更高
        #deny:
      # Spring监控配置
      aop-patterns: com.rosydawn.demo # Spring监控AOP切入点，如x.y.z.service.*,配置多个英文逗号分隔
      # 配置StatFilter
      filter:
        # 启动ConfigFilter
        config:
          enabled: true
        stat:
          enabled: true
          db-type: AliOracle
          log-slow-sql: true
          slow-sql-millis: 3000
          merge-sql: true
        # 配置WallFilter
        wall:
          enabled:
          db-type: oracle
          config:
            delete-allow: false
            drop-table-allow: false
        slf4j:
          enabled: true
```

许多配置都可以使用默认配置即可，通常只需要简化配置：

```yml

```

> 注意：上面的 yml 配置是基于 druid-spring-boot-starter 1.1.6 的，旧版的 druid-spring-boot-starter 可能不一样。

使用上面的 yml 或 properties 配置文件之后就不需要创建其他类即可使用 DataSource 的 Bean 了。

druid-spring-boot-starter 的版本与 druid 的版本保持一致。但是，可能处于兼容 Spring Boot 1.x 考虑，druid-spring-boot-starter 版本编译所依赖的 spring-boot-autoconfigure 版本（即 Spring Boot 的版本）有些奇怪，新版 druid-spring-boot-starter 所依赖的 spring-boot-autoconfigure 版本反而变小了。这也导致了 **yml 的配置因 druid-spring-boot-starter 的版本而有些不同**。目前所有 druid-spring-boot-starter 版本所依赖的 spring-boot-autoconfigure 版本以及 slf4j-api 的版本如下表所示：

| druid-spring-boot-starter 版本 | spring-boot-autoconfigure 版本 | slf4j-api 版本 |
| ------------------------------ | ------------------------------ | -------------- |
| 1.1.10~1.1.20                  | 1.5.12.RELEASE                 | 1.7.25         |
| 1.1.9                          | 2.0.0.RELEASE                  | 1.7.25         |
| 1.1.8                          | 2.0.0.RC1                      | 1.7.25         |
| 1.1.8_20180212                 | 2.0.0.RC1                      | 1.7.25         |
| 1.1.7                          | 1.5.10.RELEASE                 | 1.7.25         |
| 1.1.5~1.1.6                    | 1.5.6.RELEASE                  | NONE           |
| 1.1.0~1.1.4                    | 1.5.3.RELEASE                  | NONE           |

从上表可以看出，druid-spring-boot-starter 从 1.1.10 版本开始所依赖的 spring-boot-autoconfigure 版本降低为了 1.5.12.RELEASE。理论上，只要你的 druid-spring-boot-starter 的版本不低于 1.1.10，spring-boot-autoconfigure 版本不低于 2.1.x，上面的 yml 或 properties 配置文件应该都是可用的，druid-spring-boot-starter 未来依赖的 Spring Boot 的版本发生大变化后就不知道了。


```
# 配置日志输出
spring.datasource.druid.filter.slf4j.enabled=true
spring.datasource.druid.filter.slf4j.statement-create-after-log-enabled=false
spring.datasource.druid.filter.slf4j.statement-close-after-log-enabled=false
spring.datasource.druid.filter.slf4j.result-set-open-after-log-enabled=false
spring.datasource.druid.filter.slf4j.result-set-close-after-log-enabled=false
```

### 如何获取 Druid 的监控数据

Druid 的监控数据可以在开启 StatFilter 后通过 DruidStatManagerFacade 进行获取，获取到监控数据之后你可以将其暴露给你的监控系统进行使用。Druid 默认的监控系统数据也来源于此。下面给做一个简单的演示，在 Spring Boot 中如何通过 HTTP 接口将 Druid 监控数据以 JSON 的形式暴露出去，实际使用中你可以根据你的需要自由地对监控数据、暴露方式进行扩展。

```java
@RestController
public class DruidStatController {
    @GetMapping("/druid/stat")
    public Object druidStat(){
        // DruidStatManagerFacade#getDataSourceStatDataList 该方法可以获取所有数据源的监控数据，除此之外 DruidStatManagerFacade 还提供了一些其他方法，你可以按需选择使用。
        return DruidStatManagerFacade.getInstance().getDataSourceStatDataList();
    }
}
```





### 输出日志于 druid-sql.log

```
[2018-02-07 14:15:50] DEBUG 134 statementLog - {conn-10001, pstmt-20000} created. INSERT INTO city  ( id,name,state ) VALUES( ?,?,? )
[2018-02-07 14:15:50] DEBUG 134 statementLog - {conn-10001, pstmt-20000} Parameters : [null, b2ffa7bd-6b53-4392-aa39-fdf8e172ddf9, a9eb5f01-f6e6-414a-bde3-865f72097550]
[2018-02-07 14:15:50] DEBUG 134 statementLog - {conn-10001, pstmt-20000} Types : [OTHER, VARCHAR, VARCHAR]
[2018-02-07 14:15:50] DEBUG 134 statementLog - {conn-10001, pstmt-20000} executed. 5.113815 millis. INSERT INTO city  ( id,name,state ) VALUES( ?,?,? )
[2018-02-07 14:15:50] DEBUG 134 statementLog - {conn-10001, stmt-20001} executed. 0.874903 millis. SELECT LAST_INSERT_ID()
[2018-02-07 14:15:52] DEBUG 134 statementLog - {conn-10001, stmt-20002, rs-50001} query executed. 0.622665 millis. SELECT 1
```



### 将 Druid 配置成 JNDI 数据源

com.alibaba.druid.pool.DruidDataSourceFactory 实现了 javax.naming.spi.ObjectFactory，可以作为 JNDI 数据源来配置。

#### 配置成 Tomcat JNDI 数据源

在 Tomcat 使用 JNDI 配置 DruidDataSource，在 `<TOMCAT_HOME>/conf/context.xml` 中，在中加入如下配置：

```xml
<Resource
      name="jdbc/druid-test"
      factory="com.alibaba.druid.pool.DruidDataSourceFactory"
      auth="Container"
      type="javax.sql.DataSource"
   
      maxActive="100"
      maxIdle="30"
      maxWait="10000"
      url="jdbc:derby:memory:tomcat-jndi;create=true"
      filters="stat"
      />
```

前半部分是基本信息，不能少的，后半部分是连接池的参数。













##  

