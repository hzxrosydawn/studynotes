

Hibernate 这种 ORM 框架的出现启发了Java EE 规范的制定者，于是催生了 JPA 规范。从另一方面来看，JPA 规范的出现又为 Hibernate 等 ORM 框架制定了标准。而 Hibernate  从版本开始实现了 JPA 规范，早期应用中的 Hibernate 使用 XML 文件管理持久化类和数据表之间的映射关系，而 JPA 规范则推荐使用更简单、易用的 Annotation 来管理实体类与数据表之间的映射关系，这样就避免了一个实体需要同时维护两份文件（Java 类和 XML 映射文件），实体类的 Java 代码以及映射信息都可集中在一份文件中。不管是 XML 配置文件，还是 Annotation ，它们的本质是一样的，只是信息的载体不同而已。

在JPA 操作过程中，最常用的3 种组件如下:

- 实体：实体其实就是一个普通的POJO，只是为它增加了 XML 映射文件或映射注解，通过使用这种 XML 映射文件或映射注解，即可建立实体和底层数据表之间的对应关系。JPA 的实体与 Hibernate 中的持久化对象如出一辙，只是 Hibernate 早期采用 XML 映射文件来管理 POJO 和数据表之间的对应关系，而实体则采用 Annotation 来管理 POJO 和数据表之间的对应关系；
- EntityManager：实体只是和底层数据表具有映射关系的POJO，它本身并没有任何持久化能力，只有使用EntityManager 来对实体进行操作时，JPA 规范才可将这种操作转换为对底层数据库的操作。从这个意义上来看，JPA 规范的 EntityManager 的作用有点类似于 Hibernate 框架的Session。与Hibernate 中Session 类似的是，当程序需要使用 JPA 添加、删除、更新实体时，应用程序都需要使用 EntityManager 这个接口来完成。除此之外，如果应用程序需要检索实体，则通过 EntityManager 根据 JPQL 创建 Query 对象来实现；
- JPQL查询：类似于 Hibernate 提供的 HQL 查询语言，JPA 提供了JPQL 查询语言，这种查询语言非常简单、易用，可以非常方便地检索已保存的实体。JPA 提供了一个 Query 接口来执行查询，EntityManager 根据已有的 JPQL 来创建 Query 对象，然后由 Query 对象来执行查询。

在进行实际的数据库访问之前，Hibernate 需要使用 hibernate.properties 或 hibernate.cfg.xml 文件来管理数据库连接、连接池信息，而 JPA 则需要使用 persistence.xml （位于类路径的 META-INF 路径下）来管理数据库连接、连接池信息，JPA将这些信息称为持久化单元，也就是说，persistence.xml 文件用于管理JPA 的持久化单元信息。

实体入门

javax.persistence 包提供了一些 JPA 注解来将 POJO 包装成 JPA 实体：

- @Entity注解用来表示被其修饰的类是一个实体类。其可选的name元素表示该实体的名称，默认为实体类的非限定名，用来在查询时参考该实体。其值不能是Java Persistence 查询语言中的任何保留字；
- @Table注解用来指定一个实体类（所以常与@Entity一起使用）的主表，额外的其他表可以通过@SecondaryTable注解或@SecondaryTables注解来指定。如果一个实体类没有使用@Table注解修饰，则相当于使用@Table注解各元素的默认值。@Table注解的所有元素都是可选的：
  - name元素用于指定该实体类所对应的数据库主表的表名，默认与实体名相同；
  - catalog元素用于指定该catalog，默认与default catalog相同；
  - schema元素用于指定schema，默认与default schema相同；
  - uniqueConstraints元素用来指定一组用于该表的约束（UniqueConstraint[]），仅`创建表`功能可用时该元素才有效，可以和@Column和@JoinColumn注解指定的约束一起使用。默认没有任何额外的约束；
  - indexes元素用来指定一组用于该表的一组索引（Index[] ），仅`创建表`功能可用时该元素才有效。默认没有任何额外的约束。
- @Id注解用来指定实体的主键，可用于修饰实体的主键属性或字段、主键属性的getter方法。被该注解修饰的字段或属性（field or property）的类型可以是Java基本类型或其包装类、String、java.util.Date、java.sql.Date、java.math.BigDecimal或java.math.BigInteger。实体主键的映射列假定为主表的主键列。如果没有指定@Column注解，主键列名假定为主键属性或字段的名称；
- @Column注解用来为持久化属性或字段指定映射列，如果一个持久化属性或字段没有使用该注解修饰，则相当于使用该注解元素的默认值







@OneToOne关联不是单向的就是双向的。单向关联依赖于数据库外键，子实体一侧通过@JoinColumn的name元素来指定当前实体表中的外键列，而被关联的实体不用进行任何限定。这与单向的@ManyToOne关联一样。双向关联父端的@OneToOne注解通过mappedBy来指定关联字段。

```
// mappedBy元素的值为many端的表示关联关系的字段。如果是单向的@OneToMany关联，该元素是必选的，否则是可选的
// targetEntity元素指定目标关联实体的class。如果指定的集合使用了泛型，则该元素是可选的，否则，该元素的值必须显式指定。
// cascade元素指定关联目标的级联操作类型，默认不进行任何级联操作。如果目标集合是一个map，则级联操作到map的value上
// orphanRemoval元素指定关联实体从关联关系中删除时是否级联删除这些关联实体
// fetch元素指定one端记录加载时many端使用懒加载模式还是急切模式
```

```
// 对于@OneToMany关联关系，如果是单向的，Hibernate会在两个关联实体之间创建一个连接表。单向的@OneToMany关联在删除父实体记录时
// 效率低下（还需要操作连接表），特殊情况下，如flushing the persistence context时，Hibernate会删除所有数据库子实体，然后重新插
// 入依然存在于内存中的子实体，效率十分低下。而且One端还必须通过mappedBy元素指定Many端的关联字段。因此，Hibernate建议使用双
// 向的@OneToMany关联（即在One端增加集合属性，使用@OneToMany注解修饰该集合属性，集合元素为子实体类型，同时在Many端增加父实体类型
// 的关联属性，并使用@ManyToOne注解修饰该属性），而不是单向的@OneToMany，在Many端来控制关联关系。双向的@OneToMany关联不会创建连
// 接表，而是通过子实体的外键列进行关联。双向关联时必须保证两端的添加和删除操作是同步的

// @JoinColumn用来为连接关联实体或集合指定一个外键列。配合使用外键关联的@ManyToOne或@OneToMany时，name为子实体数据表
// 的外键列名。insertable和updatable分别表示该字段是否出现在Hibernate生成的insert和update语句中,默认都为true。
// 如果这两个元素设置为false，表明该字段是一个纯粹的外源关联，而不是可映射到数据表中的属性
```