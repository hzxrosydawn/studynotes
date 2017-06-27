javax.persistence包的注解。

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