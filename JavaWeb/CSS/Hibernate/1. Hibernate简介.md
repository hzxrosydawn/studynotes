---
-typora-copy-images-to: ..\appendix
---

### Hibernate与ORM

Hibernate是一个开放源代码的**ORM框架**，它对JDBC进行了非常轻量级的对象封装，使得Java程序员可以使用面向对象编程思维来操纵关系型数据库。

ORM（**Object Relation Mapping**）即对象关系映射，可以理解为一种规范，用于完成面向对象编程到关系数据库的映射。当ORM框架完成映射后，既可以利用面向对象程序设计语言的简单易用性，又可以利用关系数据库的技术优势。因此，我们可把ORM框架当成应用程序与数据库之间的桥梁。所有的ORM框架大致都遵循相同的映射思路：

- 数据库表映射类：将一个持久化类（一个普通的Java类）映射到一张数据表（类名对应表名，类属性类型对应数据表中的列类型）后，对这个持久化类创建实例、修改属性、删除实例的操作可以自动转换为对映射数据表的CRUD操作；
- 数据表的行映射对象：即数据表映射类的实例，每个实例对应映射数据表中的一行记录。对持久化类实例的操作会被ORM框架转换为对相关数据表中特定行的操作；
- 数据表的列（字段）映射对象的属性：当修改某个持久化对象的指定属性时，ORM框架将会转换成对相关数据表中指定数据行中指定列的操作。

![20160307142645476](../appendix/20160307142645476-3109117409.png)

ORM框架类型有很多，目前流行的ORM框架如下：

- JPA：JPA本身是一种ORM规范，它并不提供任何ORM实现，只是提供了一些列编程接口，而JPA实现负责为这些编程接口提供实现。它是Java EE规范制定者向开源世界学习的成果。由于JPA是官方标准，具有很大的通用性，如果面向JPA编程，那么应用就可以在不同的ORM框架之间自由切换了。实际上，JPA实体（Entity）完全可以作为Hibernate的持久化对象来使用；
- Hibernate：非常流行的开源ORM框架，具有轻量、高扩展性的特定，已经被JBoss作为持久层解决方案，整个Hibernate项目也一并投入了JBoss的怀抱，而JBoss又加入了Red Hat阻止；
- Mybatis：MyBatis（由iBatis发展而来）是支持定制化SQL、存储过程以及高级映射的优秀的持久层框架。相比于Hibernate，Mybatis使用更易用，已渐渐赶超Hibernate。MyBatis可以对配置和原生Map使用简单的 XML 或注解，将接口和POJO映射成数据库中的记录。
- Toplink：Toplink是Oracle公司捐献给开源社区的，是最早的ORM映射框架之一，也是对JPA规范支持最好的一个框架。在开源应用服务器Glassfish中，被使用为默认的JPA的实现。

### Hibernate优点和缺点

优点：

- 使用简介的hql语句，如插入数据：原来的做法是：insert into 表名称 alue（值1，值2，值3，……），而现在的做法是：save（对象）；
- 简化了DAO层编码工作，使开发更对象化了；
- 移植性好，支持各种数据库，如果换个数据库只要在配置文件中变换配置就可以了，不用改变hibernate代码；
- 支持透明持久化。透明是针对上层而言的。

缺点：

- 若是大量数据批量操作，性能效率比较低，不如直接使用JDBC；
- 复杂表操作就Over了。

### Hibernate架构

先来看一下Hibernate依赖的jar包，这里用MySQL来进行演示：

- antlr-x.x.x.jar：生成SQL语句；
- asm.jar：字节码增强工具类；
- c3p0-x.x.x.jar：数据源连接池组件；
- cglib-x.x.x.jar：代理组件，基于继承的；
- commons-collections-x.x.x.jar：集合工具类组件，会进行高效的操作；
- commons-logging-x.x.x.jar：日志输出的转换组件；
- log4j-x.x.x.jar：日志输出组件，更加详细和可以控制输出格式，及目的地；
- dom4j-x.x.x.jar：XML解析；
- ehcache-x.x.x.jar：缓存组件；
- ejb3-persistence.jar：持久化操作的规范jar包；
- hibernatex.jar：框架的核心jar包；
- jta.jar：全局的事务管理；
- junit-x.x.x.jar：单元测试；
- mysql-connector-java-x.x.x-bin.jar ：MySQL数据库驱动jar包。

Hibernate使用了许多现有的Java API，比如JDBC，Java Transaction API(JTA)和Java Naming and Directory Interface (JNDI)。JDBC提供了提供了连接关系数据库的基本功能，可以让Hibernate任何JDBC驱动支持的关系数据库，JNDI和JTA可以让Hibernate集成到J2EE应用服务器上。Hibernate的核心接口一共有6个，分别为：Configuration、SessionFactory、Session、Transaction、Query和 Criteria。通过这些接口，不仅可以对持久化对象进行存取，还能够进行事务控制。

![hibernate_high_level](../appendix/hibernate_high_level.jpg)

​										Hibernate简易架构

![hibernate_architecture](../appendix/hibernate_architecture.jpg)

​										Hibernate详细架构

下面对这6个核心接口分别加以介绍。

**Configuration**

Configuration对象在任何Hibernate应用中都要首先创建的，它代表Hibernate所需的配置和属性信息，一般只需在应用初始化时创建一次。Configuration对象包含两种主要组件：

- **Database Connection:** Hibernate通过一个或多个配置文件来指定数据库的连接信息，可以有三种形式：hibernate.properties、hibernate.cfg.xml和Java编码手动创建Configuration对象。后续会详细介绍；
- **Class Mapping Setup：**映射关系指定了POJO与数据表之前的映射关系，可以通过映射注解和映射的XML文件来指定。后续会详细介绍。

**SessionFactory**

SessionFactory对象是根据Configuration对象创建的，它是创建Session对象的工厂（通过ConnectionProvider利用配置信息生成数据库连接，从而创建一个Session对象）。SessionFactory对象是不可变的、线程安全的，并被应用中的所有线程共享。

SessionFactory对象是重量级的（它依赖于具体的数据库），通常在应用启动时创建。应该为每个数据库创建一个配置文件和一个对应的SessionFactory对象，所以，如果你的应用中使用多个数据库就需要创建多个配置文件和多个SessionFactory对象；

**Session**

Session对象用来获取一个到数据库物理连接，它是轻量、非线程安全的，应该仅在需要与数据库交互时动态创建，不应该长时间保持打开状态，不用时就应该立即关闭。Session底层封装了JDBC `java.sql.Connection`，所有持久化对象的操作都必须通过Session对象来完成的，它也是创建Transaction对象的工厂。Session对象有一个必选的一级缓存，显式执行其flush方法之前，所有的持久化操作的数据都是缓存在Session中的；

**Transaction**

Transaction（事务）对象代表数据库的一个工作单元，大多数关系型数据库都支持事务功能，它和Session一样，也是短暂的单线程对象。Hibernate中的事务通过事务管理器和JDBC（或JTA）事务来处理，这是一个可选的接口，开发人员可以不使用该接口，而是直接编写自己的事务处理代码；

**Query**

Query对象使用SQL或Hibernate Query Language (HQL)字符串来操作对象，一个Query实例在绑定查询参数、限制返回结果的数量后再执行该查询语句；

**Criteria**

Criteria对象用来创建和执行面向对象标准查询来获取对象。

> **SessionFactory底层封装了ConnectionProvider接口对象，它是生成JDBC连接的工厂，它通过抽象将应用程序与底层的DataSource或DriverManager隔离开，在进程或集群的级别上为事务间可重用的数据提供可选的二级缓存**。该对象无须应用程序直接访问，仅在扩展Hibernate时使用。**实际上很少直接使用DriverManager来获取数据库连接，而是通过DataSource来获取数据库连接**。

**接口间关系**





### Hibernate配置

Hibernate需要提前知道所连接数据库的Url、数据库连接驱动、用户名、密码、数据库连接池以及Java类与数据表的映射关系等信息，Hibernate的这些配置信息通过org.hibernate.cfg.Configuration类实例来设置，该实例的作用是对Hibernate进行配置，以及对它进行启动。在Hibernate的启动过程中，Configuration类实例首先读取Hibernate配置文件，加载配置信息，然后加载映射文件（后面详细介绍），创建一个单例、线程安全地SessionFactory对象。

进行Hibernate配置步骤如下：

1. 设置配置信息。配置信息可以通过配置文件（hibernate.properties文件或hibernate.cfg.xml文件）来设定，然后通过配置文件来构造Configuration实例，也可以通过Java代码来Configuration实例后手动指定配置

  a) hibernate.properties常用设置示例：

```properties
# ===============================================================================================
# hibernate 基本属性
# ===============================================================================================
# 设置所用数据库连接的驱动器类
hibernate.connection.driver_class=com.mysql.jdbc.Driver
# 设置所用数据库方言。Hibernate根据数据库方言来识别数据库之间的差异
hibernate.dialect==org.hibernate.dialect.MySQLDialect
# 设置所用数据库连接的url
hibernate.connection.url=jdbc:mysql://localhost:3306/test?useUnicode=true&amp;characterEncoding=UTF8
# 设置所用数据库的用户名
hibernate.connection.username=rosydawn
# 设置所用数据库的密码
hibernate.connection.password=database_password
# 输出所有SQL语句到控制台，取值true或false
hibernate.show_sql=true
# 在log和console中打印出格式化的SQL，取值true或false
hibernate.format_sql=true
# 是否Hibernate生成的SQL中添加有助于调试的注释信息，默认值为false，取值true或false
hibernate.use_sql_comments=true
# 设置是否自动提交。通常不建议打开自动提交
#hibernate.connection.autocommit=true
# 在SessionFactory创建时，自动检查数据库结构，或者将数据库schema的DDL导出到数据库
# 取值validate|update|create|create-drop：
# create：每次加载hibernate时都会删除上一次的生成的临时表，然后根据model类再重新来生成新的临时表，
#       哪怕两次没有任何改变也要这样执行，这就是导致数据库表数据丢失的一个重要原因；
# create-drop：每次加载hibernate时根据model类生成表，但是sessionFactory一关闭,表就自动删除；
# update：最常用的属性，第一次加载hibernate时根据model类会自动建立起表的结构（前提是先建立好数据库），
#       以后加载hibernate时根据model类自动更新表结构，即使表结构改变了但表中的行仍然存在不会删除以前的行。
#       要注意的是当部署到服务器后，表结构是不会被马上建立起来的，是要 应用第一次运行起来后才会；
# validate：每次加载hibernate时，验证创建数据库表结构，只会和数据库中的表进行比较，不会创建新表，但是会插入新值。
hibernate.hbm2ddl.auto=update
# 为单向关联(一对一, 多对一)的外连接抓取树（the outer join fetch tree）设置最大深度
# 值为0意味着将关闭默认的外连接抓取，建议在0到3之间取值
hibernate.max_fetch_depth=1
# 为批量抓取设置默认的批量大小，建议的取值为4, 8和16
hibernate.default_batch_fetch_size=8


# ===============================================================================================
# C3P0连接池相关配置
# ===============================================================================================
# 指定连接池里最大连接数
hibernate.c3p0.max_size=2
# 指定连接池里最小连接数
hibernate.c3p0.min_size=2
# 指定连接池里连接的超时时长
hibernate.c3p0.timeout=5000
# 指定连接池里最大缓存Statement对象的数量
hibernate.c3p0.max_statements=100
# 指定连接池里空闲连接的检查时间间隔
hibernate.c3p0.idle_test_period=3000
#　指定连接池里连接耗尽的时候一次同时获取的连接数
hibernate.c3p0.acquire_increment=2
# 每次都验证连接是否可用，为了性能可以设置为false
hibernate.c3p0.validate=false


# ===============================================================================================
# JNDI连接属性。如果无须Hibernate自己管理数据源，而是直接访问容器管理数据源，Hibernate可使用JNDI (Java
# Naming Directory Interface，即Java命名目接口)数据源的相关配置
# ===============================================================================================
# 指定数据源JNDI名字
#hibernate.connection.datasource
# 指定JNDI提供者的URL，该属性是可选的
# 如果JNDI与Hibernate持久化访问的代码处于同个应用中，则无须指定该属性
#hibernate.jndi.ur
# 指定JNDI InitialContextFactory的实现类，该属性也是可选的
# 如果JNDI与Hibernate持久化访间的代码处于同个应用中，则无须指定该属性
#hibernate.jndi.class
#指定连接数据库的用户名，该属性是可选的
#hiberate.connection.username
#指定连按数据库的密码，该属性是可选的
#hibernate.connection.password
#即使使用JNDI数据源，一样需要指定连接数据库的方言。虽然设置数据库方言并不是必需的，但对于优化持久层访问很有必要


# ===============================================================================================
# Hibernate其他属性
# ===============================================================================================
# 为"当前" Session指定一个(自定义的)策略。取值jta|thread|custom.Class
#hibernate.current_session_context_class
# 选择HQL解析器的实现
# 取值org.hibernate.hql.ast.ASTQueryTranslatorFactory
# 或者org.hibernate.hql.classic.ClassicQueryTranslatorFactory
#hibernate.query.factory_class org.hibernate.hql.internal.classic.ClassicQueryTranslatorFactory
# 将Hibernate查询中的符号映射到SQL查询中的符号 (符号可能是函数名或常量名字)
# 取值hqlLiteral=SQL_LITERAL, hqlFunction=SQLFUNC
#hibernate.query.substitutions
# 开启CGLIB来替代运行时反射机制(系统级属性)。反射机制有时在除错时比较有用。
# 注意即使关闭这个优化, Hibernate还是需要CGLIB。你不能在hibernate.cfg.xml中设置此属性，取值true|false
#hibernate.cglib.use_reflection_optimizer=true
# 强制Hibernate按照被更新数据的主键，为SQL更新排序。这么做将减少在高并发系统中事务的死锁，取值true|false
#hibernate.order_updates=true
# 设置是否将被删除对象的生成标识重设为默认值，取值true|false
#hibernate.use_identifier_rollback=true
## 设置是否开启字节码反射优化器，默认值为false，取值true|false
#hibernate.bytecode.use_reflection_optimizer=true
# 设置是否收集有助于性能调节的统计数据，取值true或false
#hibernate.generate_statistics=true
# 为由这个SessionFactory打开的所有Session指定默认的实体表现模式. 取值dynamic-map, dom4j, pojo
#hibernate.default_entity_mode
# 在生成的SQL中, 为非全限定名的表名默认的schema，取值SCHEMA_NAME
#hibernate.default_schema=test
# 在生成的SQL中, 将给定的catalog附加于非全限定名的表名上，取值CATALOG_NAME
#hibernate.default_catalog=test
# SessionFactory创建后，将自动使用这个名字绑定到JNDI中，取值jndi/composite/name
#hibernate.session_factory_name=


# ===============================================================================================
# Hibernate JDBC和连接(connection)属性，，使用JDBC连接时启用
# ===============================================================================================
# 指定JDBC抓取数量的大小，它可以接受一个整数值，实质上是调用Statement.setFetchSize()方法
#hibernate.jdbc.fetch_size=25
# 非零值允许Hibernate使用JDBC2的批量更新，0值表示不开启批处理。建议取5到30之间的值
#hibernate.jdbc.batch_size=5
# 如果想让JDBC驱动从executeBatch()返回正确的行计数，那么将此属性设为true(开启这个选项通常是安全的)
# 同时，Hibernate将为自动版本化的数据使用批量DML. 默认值为false，取值true|false
#hibernate.jdbc.batch_versioned_data=true
# 选择一个自定义的JDBC Batcher。多数应用程序不需要这个配置属性
#hibernate.jdbc.factory_class
# 允许Hibernate使用JDBC2的可滚动结果集。只有在使用用户提供的JDBC连接时，
#这个选项才是必要的, 否则Hibernate会使用连接的元数据，取值true|false
#hibernate.jdbc.use_scrollable_resultset
# 在JDBC读写binary (二进制)或serializable (可序列化) 的类型时使用流(stream)(系统级属性). 取值true|false
#hibernate.jdbc.use_streams_for_binary
# 在数据插入数据库之后，允许使用JDBC3 PreparedStatement.getGeneratedKeys() 来获取数据库生成的key
# 需要JDBC3+驱动和JRE1.4+，如果你的数据库驱动在使用Hibernate的标 识生成器时遇到问题，请将此值设为false
# 默认情况下将使用连接的元数据来判定驱动的能力. 取值true|false
#hibernate.jdbc.use_get_generated_keys
## 选择一个自定义的SQL异常转换器
#hibernate.jdbc.sql_exception_converter
# 自定义ConnectionProvider的类名, 此类用来向Hibernate提供JDBC连接
# 取值classname.of.ConnectionProvider
#hibernate.connection.provider_class
# 设置JDBC事务隔离级别（isolation level）。查看java.sql.Connection来了解各个值的具体意义
# 但请注意多数数据库都不支持所有的隔离级别。取值 1,2,4,8
#hibernate.connection.isolation=4
# 指定Hibernate在何时释放JDBC连接。默认情况下,直到Session被显式关闭或被断开连接时,才会释放JDBC连接。
# 对于应用程序服务器的JTA数据源,你应当使用after_statement, 这样在每次JDBC调用后，都会主动的释放连接。
# 对于非JTA的连接, 使用after_transaction在每个事务结束时释放连接是合理的
# auto将为JTA和CMT事务策略选择after_statement, 为JDBC事务策略选择after_transaction。
# 取值on_close|after_transaction|after_statement|auto
#hibernate.connection.release_mode
# 将JDBC属性propertyName传递到DriverManager.getConnection()中去
#hibernate.connection
# 将属性propertyName传递到JNDI InitialContextFactory中去
#hibernate.jndi


# ===============================================================================================
# Hibernate二级缓存属性，可以提供Hibernate持久化访问的性能
# ===============================================================================================
# 用于设置二级缓存CacheProvider的类名
hibernate.cache.provider_class
# 以频繁的读操作为代价, 优化二级缓存以实现最小化写操作。
# 在Hibernate3中，这个设置对的集群缓存非常有用，对集群缓存的实现而言，默认是开启的
# 取值true|false
hibernate.cache.use_minimal_puts=true
# 是否允许查询缓存，个别查询仍然需要被设置为可缓存的
# 取值true|false
hibernate.cache.use_query_cache=true
# 是否使用二级缓存。可以用来完全禁用二级缓存
# 对那些在类的映射文件中指定了<cache>的持久化类，会默认开启二级缓存
# 取值true|false
hibernate.cache.use_second_level_cache=false
# 设置查询缓存工厂的类名（实现了QueryCache接口），默认为内建的StandardQueryCache
hibernate.cache.query_cache_factory=org.hibernate.cache.internal.StandardQueryCache
# 二级缓存区域名（cache region name）的前缀
# 取值prefix
hibernate.cache.region_prefix=hibernate.test
# 是否强制Hibernate以可读性更好的格式将数据存入二级缓存
# 取值true|false
hibernate.cache.use_structured_entries=true


# ===============================================================================================
# Hibernate事务属性
# ===============================================================================================
# 指定Hibernate事务工厂的类型，该属性必须是TransactionFactory类的直接或间接子类
# 可以指定为org.hibernate.transaction.JDBCTransactionFactory（默认）
# 也可指定为为org.hibernate.transaction.JTATransactionFactory
#hibernate.transaction.factory_class=org.hibernate.transaction.JDBCTransactionFactory
# 指定一个JNDI名字，用来被JTATransactionFactory从应用服务器获取JTA UserTransaction
# 如果指定了hibernate.transaction.manager_lookup_class就不用使用该设置
# 默认值为UserTransaction
#jta.UserTransaction jta/usertransaction
#jta.UserTransaction javax.transaction.UserTransaction
#jta.UserTransaction=UserTransaction
# 设置一个TransactionManagerLookup类名
# 当使用JVM级缓存，或在JTA环境中使用hilo生成策略时需要该类
#hibernate.transaction.manager_lookup_class=org.hibernate.transaction.JBossTransactionManagerLookup
#hibernate.transaction.manager_lookup_class=org.hibernate.transaction.WeblogicTransactionManagerLookup
#hibernate.transaction.manager_lookup_class=org.hibernate.transaction.WebSphereTransactionManagerLookup
#hibernate.transaction.manager_lookup_class=org.hibernate.transaction.OrionTransactionManagerLookup
#hibernate.transaction.manager_lookup_class=org.hibernate.transaction.ResinTransactionManagerLookup
# 指定Session是否在事务完成后自动将数据刷新（flush）到底层数据库
# 现在更好的方法是使用自动session上下文管理
# 取值true|false
#hibernate.transaction.flush_before_completion=true
# 指定是否在唉事务结束后自动关闭session
# 现在更好的方法是使用自动session上下文管理
# 取值true|false
#hibernate.transaction.auto_close_session=false
```

详细配置可参考Hibernate发行包hibernate-release-x.x.x.Final中`project\etc`目录下的hibernate.properties文件，该文件详细列出了Hibernate 配置文件的所有属性。每个配置段都给出了大致的注释，用户只需取消所需配置段的注释，就可以快速配置Hibernate 与数据库的连接。

​	b) hibernate.cfg.xml常用设置示例：


```xml
<?xml version='1.0' encoding='utf-8'?>
<!DOCTYPE hibernate-configuration PUBLIC
        "-//Hibernate/Hibernate Configuration DTD//EN"
        "http://www.hibernate.org/dtd/hibernate-configuration-3.0.dtd">
<!-- 上面的头信息可以在hibernate-core-x.x.x.Final.jar包中的org.hibernate.xsd.hibernate-configuration-3.0.dt文件顶部的注释中获得 -->
<hibernate-configuration>
    <session-factory>
        <!-- 以下所有信息在和Spring整合时都可以在Spring的DataSource、SessionFactory的bean中进行设置  -->
      
       <!-- 指定连接数据库所用的驱动 -->
        <property name="connection.driver_class">com.mysql.jdbc.Driver</property>
        <!-- 指定数据库方言。Hibernate根据数据库方言来识别数据库之间的差异 -->
        <property name="dialect">org.hibernate.dialect.MySQL5Dialect</property>
        <!-- 指定连接数据库的url，其中hibernate是本应用连接的数据库名 -->
        <property name="connection.url">jdbc:mysql://localhost:3306/test?useUnicode=true&amp;characterEncoding=UTF8</property>
        <!-- 指定连接数据库的用户名 -->
        <property name="connection.username">root</property>
        <!-- 指定连接数据库的密码 -->
        <property name="connection.password">hzx123</property>
        <!-- 指定连接池里最大连接数 -->
        <property name="hibernate.c3p0.max_size">25</property>
        <!-- 指定连接池里最小连接数 -->
        <property name="hibernate.c3p0.min_size">3</property>
        <!-- 指定连接池里连接的超时时长 -->
        <property name="hibernate.c3p0.timeout">3000</property>
        <!-- 指定连接池里最大缓存多少个Statement对象 -->
        <property name="hibernate.c3p0.max_statements">100</property>
        <!-- 指定连接池里空闲连接的检查时间间隔 -->
        <property name="hibernate.c3p0.idle_test_period">3000</property>
        <!-- 指定连接池里连接耗尽的时候一次同时获取的连接数 -->
        <property name="hibernate.c3p0.acquire_increment">3</property>

        <property name="hibernate.c3p0.validate">true</property>

        <!-- 根据需要自动创建数据表 -->
        <property name="hbm2ddl.auto">update</property>
        <!-- 打印Hibernate操作所生成的SQL -->
        <property name="show_sql">true</property>
        <!-- 将SQL脚本进行格式化后再输出 -->
        <property name="hibernate.format_sql">true</property>
        <!-- 避免这个错误信息Disabling contextual LOB creation as createClob() method threw error :
        java.lang.reflect.InvocationTargetException -->
        <property name="hibernate.temp.use_jdbc_metadata_defaults">false</property>

        <!-- 罗列所有持久化映射文件路径 -->
        <mapping resource="com/test/entity/User.hbm.xml"/>
        <mapping resource="com/test/entity/Teacher.hbm.xml"/>
        <!-- 也可以罗列所有持久化类的类名来让Hibernate自动搜索对应的映射文件 -->
        <!--<mapping class="com.test.entity.User"/>
        <mapping class="com.test.entity.Teacher"/>-->
    </session-factory>
</hibernate-configuration>
```

可见hibernate.properties与hibernate.cfg.xml指定的内容基本相同，只是形式不同。这两种文件要放在应用classpath的根目录下。建议使用hibernate.cfg.xml方式，xml具有良好的可读性，也是官方推荐的，如果同时在hibernate.cfg.xml和hibernate.properties对Hibernate进行了配置，那么前者将覆盖后者。

> Hibernate 连接属性、缓存属性、事务属性等主要用于提升性能，并且Hibernate都提供了适当的默认值。入门者可以忽略这些设置，等学到一定阶段，你可以参考官方文档进行适当配置。

​	c) 手动通过Java代码创建Configuration实例后设置配置信息：


```java
// 当然如果构造Configuration实例时加载了配置文件就不能使用这个方法了
Configuration cfg = new Configuration()
	.addClass(test.User.class)
	.setProperty("hibernate.dialect", "org.hibernate.dialect.MySQLDialect")
	.setProperty("hibernate.connection.datasource", "java:comp/env/jdbc/test")
	.setProperty("hibernate.order_updates", "true");
// 或者批量设置配置信息
// Configuration cfg = setProperties(Properties properties);
```
2. 创建Configuration实例。如果使用配置文件，可以在创建org.hibernate.cfg.Configuration类实例来加载配置文件中的配置信息。

```java
Configuration cfg = new Configuration().configure("/etc/hibernate.cfg.xml");
// 或者
Configuration cfg = new Configuration().configure("/etc/hibernate.properties");

// 为Configuration实例指定映射文件
cfg.addResource("test/User.hbm.xml");
// 也可以直接为Configuration实例指定持久化类来让自动搜索映射文件
cfg.addClass(test.Order.class);
```

如果使用hibernate.cfg.xml进行配置，且在该文件中已经指定了某些映射文件（或持久化类）就不需要手动添加这些映射文件（或持久化类）了，如果使用hiberate.properties 文件，就必须在代码中手动添加映射文件（或持久化类）。

使用hiberate properties 文件虽然简单，但必须在代码中手动添加映射文件，这是非常令人沮丧的事情。如果映射文件很多就麻烦了。我们通常宁愿在配置文件中添加映射文件，也不愿意在代码中手动添加，这就是实际开发中不使用hibemate.properties文件作为配置文件的原因。**因为映射文件和持久化类往往是一一对应的，还可以通过向Configurntion对象的addClass方法添加持久化类让Hibemate 自已搜索映射文件。自动搜索映射文件要求映射文件命名要规范，一定要形如`ClassName.hbm.xml`格式，同时映射文件要和对应的持久化类位于相同的包路径中**。

完全使用Java代码创建Configuration实例不利于后期代码维护。一个Configuration实例可能需要大段代码，Hbemate所有的配置属性都需要通过代码设置，并需要在代码中手动加载所有映射文件。这是一件极度烦琐的事，对于大项目尤其如此。这种策略一般结合配置文件一起使用。

3. 获得SessionFactory

```java
SessionFactory sessionFactory = cfg.buildSessionFactory();
```

当所有映射定义被 Configuration 解析后，应用程序必须获得一个用于构造org.hibernate.Session 实例的工厂SessionFactory。这个工厂是使用单例模式创建的不可变对象，将被应用程序的所有线程安全地共享，只需要被实例化一次。

### 持久化类和映射关系

Hibernate使用[POJO]()（普通传统的Java对象）作为持久化对象（Persistent Object，简称PO），这就是Hibernate被称为低侵入性设计的原因，Hibernate不要求持久化类继承任何父类，或实现任何接口，这样可以保证代码不被污染。POJO经过映射后就可以成为Hibernate的PO：

​									PO = POJO + 映射关系

映射关系可以通过映射文件和映射注解来实现。

综上所述，一般Hibernate的工作流程如下：

1. 通过`Configuration().configure();`读取并解析`hibernate.cfg.xml`配置文件；
2. 由`hibernate.cfg.xml`中的`<mapping resource="com/xx/User.hbm.xml"/>`读取解析映射信息；
3. 通过`config.buildSessionFactory();`得到`sessionFactory`；
4. 通过`sessionFactory.openSession();`得到`session`；
5. 通过`session.beginTransaction();`开启事务；
6. 进行一系列持久化操作；
7. `session.getTransaction().commit();`提交事；
8. 关闭`session`；
9. 关闭`sessionFactory`；

