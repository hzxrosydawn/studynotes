## 映射文件

### 根元素

Hibernate的持久化类和关系数据库之间的映射关系可以用一个XML格式的映射文件来定义。有关映射文件更加详细的信息可以参考位于hibernate-core.jar或hibernate3.jar（bundle版本的Hibernate）中Hibernate DTD文件，可以在该文件中查看到所有元素和属性、默认值以及某些注释。Hibernate会优先从classpath中寻找该DTD文件，其次是网络。

每一个映射文件都有一个唯一的`<hibernate-mapping.../>`根元素，`<hibernate-mapping.../>`根元素可以指定如下几个**可选**属性。

```xml
<hibernate-mapping
	package="package.name"   
	schema="schemaName"                          
	catalog="catalogName"                        
	default-cascade="cascade_style"              
	default-access="field|property|ClassName"    
	default-lazy="true|false"                    
	auto-import="true|false">                                    
 </hibernate-mapping>
```

- package：指定一个包前缀，如果在映射文档中没有指定全限定的类名，就使用这个作为包名；
- schema：指定所映射数据库的Schema名，如果指定了该属性，则表名会自动添加该Schema前缀；
- catalog：指定所映射数据库的Catalog名，如果指定了该属性，则表名会自动添加该Catalog前缀；
- default-cascade：设置Hibernate默认的级联风格，该属性的默认值是none。集合属性不指定级联属性。当配置Java属性映射和集合映射时还可指定cascade属性，用于覆盖该默认的级联风格。如果配置Java属性映射、集合映射时没有指定cascade属性，则Hibemate将采用此处指定的级联风格；
- default-access：指定Hibernate默认的属性访问策略，默认值为property，即使用getter/setter方法对来访问属性。如果指定access="feld"，则Hibernate会忽略getter/setter方法对，而是通过反射来访问成员变量。如果需要实现自己的属性访问策略，则需要自己提供PropertyAccessor接的实现类，然后在access中设置自定义属性访问策略类的名字；
- default-lazy：设置Hibernate默认的延迟加载策略。该属性值**默认为true，即启用延迟加载策略**。当配置Java 属性映射和集合映射时还可指定lazy属性，用于覆盖这里指定的默认延迟加载策略。如果配置Java 属性映射、集合映射时没有指定lazy 属性，则Hiberate 将采用此处指定的延迟加载策略。通常情况下，不应该关闭延迟加载策略，例如当加载一个Teacher对象，且该Teacher对象有N个关联的Student对象时，如果关闭延迟加栽策略，则Hibemate在加载该Teacher对象时会自动加载所有与该Teacher对象关联的Student对象。如果该Teacher有许多Student对象，而程序仅需要访问Teacher对象，则一次加载这些Student对象纯属多余；
- auto-import：设置是否允许在查询语言中使用非全限定的类名（仅限于本映射文件中的类）。该属性默认是true。如果同一份映射文件中有两个持久化类映射，它们的类名是一样的，但处于不同包下，则应该设置`auto-import=false`，否则Hibernate将无法准确分别两个类，从而导致Hibenate抛出一个异常。

> schema和catalog属性用于限定数据表，如果没有指定这两个值，则数据表就是未被限定。

### class元素

`<hibernate-mapping.../>`根元素中可以有多个`<class.../>`子元素，每个`<class.../>`子元素对应一个持久化类的映射，一般建议一个映射文件中仅包含一个`<class.../>`子元素。`<hibernate-mapping.../>`元素指定的`schema`、`catalog`、`default-cascade`、`default-access`、`default-lazy`等属性将会对它所包含的所有的`<class.../>`元素起作用，这些属性将控制每个`<class.../>`元素所映射的持久化类的默认行为。而每个`<class.../>`也可指定这些属性，用于覆盖`<hibernate-mapping.../>`元素指定的默认行为。

```xml
<class
	name="ClassName"                              
	table="tableName"                             
	discriminator-value="discriminator_value"     
	mutable="true|false"                          
	schema="owner"                                
	catalog="catalog"                             
	proxy="ProxyInterface"                        
	dynamic-update="true|false"                   
	dynamic-insert="true|false"                   
	select-before-update="true|false"             
	polymorphism="implicit|explicit"              
	where="arbitrary sql where condition"         
	persister="PersisterClass"                    
	batch-size="N"                                
	optimistic-lock="none|version|dirty|all"      
	lazy="true|false" 
	entity-name="EntityName"
	check="arbitrary sql check condition"
 	rowid="rowid"
	subselect="SQL expression"
	abstract="true|false"
	node="element-name">
<class/>
```

`<class.../>`子元素包含的以下**可选**属性：

- name：指定持久化类（或者接口）的全限定类名。如果不使用全限定的类名，则必须在`<hibemate-mapping>`根元素里指定package属性，用来指定非全限定类名的持久化类所在的包名。如果该属性不存在，则Hibernate将假定这是一个非POJO实体的映射；

- table：指定该持久化类映射的数据表名，Hibernate默认以持久化类的非全限定类名作为表名；

- discriminator-value：用于区分不同的子类的值，在多态行为时使用。当使用`<subclass.../>`元素来定义持久化类的继承关系映射时需要使用该属性。默认和类名一样。可以接受`null`和`not null`值；

- mutable：用于指定持久化类的实例是可变对象还是不可变对象，该属性只能接受true 和false两个属性值，该属性默认值是true；

- schema：覆盖根元素`<hibernate-mapping.../>`中指定的schema名字；

- catalog：覆盖根元素`<hibernate-mapping.../>`中指定的catalog名字；

- proxy：指定一个接口，在延迟加载时作为代理使用，也可以指定该类自己的名字；

- dynamic-update：指定用于更新记录的update语句是否在运行时动态生成，并且只更新那些改变过的字段。默认为false，开启该属性将导致Hibernate需要更多的时间来生成SQL语句。当程序打开了dynamic-update之后，映射文件可以指定如下几种乐观锁定的策略：

  - version：检查version/timestamp字段；
  - all：检查全部字段；
  - dirty：只检查修改过的字段；
  - none：不使用乐观锁定；

  非常强烈建议你在Hibermate 中使用version/timestamp字段来进行乐观锁定。对性能来说，这是最好的选择，并且这也是唯一能够处理在Session外进行脱管操作的策略；

- dynamic-insert：指定用于插入记录的insert语句是否在运行时动态生成，并且只插入那些非空字段。默认为false，开启该属性将导致Hibernate需要更多的时间来生成SQL语句；

- select-before-update：指定Hibernate在更新（update）某个持久化对象之前是否需要先进行一次查询（select）。如果指定该属性为true，则Hibernate可以保证只有当持久化对象的状态被修改过时，才会使用update语句来保存其状态（即显式使用saveOrUpdate()来保存该对象，但如果Hibernate查询到对应记录与该持久化对象的状态相同，则不会使用update语句来保存其状态）。该属性值默认是false。通常来说，使用select-before-update 会降低性能。如果应用程序中某个持久化对象的状态经常会发生改变，那么该属性应该设置为false。如果该持久化对象的状态很少发生改
  变，而程序又经常要保存该对象，则可将该属性设置为true；

- polymorphism：多态，界定是隐式还是显式的多态查询；当采用`<union-subclass.../>`元素来配置继承映射时，该元素指定是否需要采用隐式多态查询。该属性的默认值为implicit，当指定polymorphism为true时，如果查询时给出的是任何超类、该类实现的接口或该类的名字，都会返回该类（及其子类)的实例。如果查询中给出的是子类的名字，则只返回子类的实例。否则，只有在查询时明确给出某个类名时，才会返回这个类的实例，大部分时候我们都需要使用隐式多态；

- where：指定一个附加的过滤条件（类似于添加where子句），如果一旦指定了该属性，则不管采用load()、get()还是其他查询方法，只要试图加载该持久化类的对象时，该where 条件都会生效。也就是说，只有符合该where 条件的记录才会被加载出来；

- persister：指定一个定制的ClassPersister。通常程序无须指定该属性，除非程序需要自行保存该持久化对象的状态（也就是自己决定怎样保存该对象），程序可以继承org.hibernate.persister.EntityPersister基类创建自定义的持久化器，甚至可以完全从头开始编写一个org.hibernate.persister.ClassPersister接口的实现类，例**如调用存储过程来保存某个持久化对象**，或者将该对象序列化到磁盘，或者使用LDAP 数据库等；

- batch-size：指定根据标识符（identifer）来抓取实例时每批抓取的实例数。该属性值默认是1；

- optimistic-lock：该属性指定乐观锁定策略。该属性的默认值是version；

- lazy：用来设置是否开启延迟加载。覆盖根元素`<hibernate-mapping.../>`中指定的default-lazy属性值；

- check：指定一个SQL 表达式，用于为该持久化类所对应的表指定一个多行的Check约束；

- subselect：该属性用于映射不可变的、只读实体。通俗地说，就是将数据库的子查询映射成Hibernate持久化对象。当需要使用视图（其实质就是一个查询）来代替数据表时，该属性比较有用；

- abstract：用于在`<union-subclass.../>`的继承结构(hierarchies)中标识抽象超类。

如果需要采用继承映射，则`<class.../>` 元素下还会增加`<subclass.../>`、`<joined-subclass.../>`或`<union-subclass.../>`元素，这些元素分别用于定义子类。Hibernate允许将一个接口指定为持久化类，然后可以用元素`<subclass../>`来指定该接口的实现类。我们也可以持久化任何静态的内部类，只要使用静态内部类的格式指定类名即可，如Foo$Bar。

当使用`<class.../>`元素来映射某个持久化类时，通常还需要`<id.../>`和`<property.../>`两个最常见的了元素，其中`<id.../>`元素用于映射标识属性，`<property.../>`用于映射普通属性。

### 映射主键

通常情况下，Hibernate建议为持久化类定义一个标识属性，用于唯一地标识某个持久化实例，而这个标识属性需要映射到底层数据表的主键。标识属性通过`<id.../>`元素来指定。`<id.../>`元素的name属性值就是持久化类的标识属性名。除此之外，`<id.../>`元素还可指定如下几个可选属性：

- type：指定该标识属性的数据类型。该类型既可以是Hibernate的内建类型，也可以是Java类型。如果使用Java类型，则需要使用全限定类名。**该属性是可选的，如果映射文性中没有指定该属性，则由Hibernate自行判断该标识属性的数据类型，通常建议设置该属性，这会保证更好的性能**；
- column：**设置标识属性所映射的数据列的列名。在默认情况下，该列的列名与该标识属性的属性名相同**；
- unsaved-value：**指定当某个实例刚刚创建、还未保存时的标识属性值。这个属性值可用于将这种实例和从以前的Session中装载过、但未再次持久化的实例区分开**。在Hibernate 3中通常无须设置该属性；
- access：指定Hibernate访问该标识属性的访问策略，默认是property。该属性用于覆盖`<hibernate-mapping.../>`根元素中的default-access属性。其实`<id.../>`元素的name也是可选的，如果不设置name属性，则表明该持久化类没有标识属性。

几乎所有现代的数据库建模理论都推荐不要使用具有实际意义的物理主键，而是推荐使用没有任何实际意义的逻辑主键。尽量避免使用复杂的物理主键，应考虑为数据库增加一列，作为逻辑主键。

逻辑主键没有实际意义，仅用来标识一行记录。Hibernate为这种逻辑主键提供了主键生成器，负责为每个持久化实例生成唯一的逻辑主键值。主键生成器负责生成数据表记录的主键。通常有如下常见的主键生成器：

- increment：为short、int或者long类型的主键生成唯一标识。只有在没有其他进程往同一张表中插入数据时才能使用。在集群下不要使用!
- identity：在DB2、MySQL、Microsoft SQL Server、Sybase和HypersonicSQL等**提供identity（自增长）主键**支持的数据表中适用。返回的标识属性是short、int或者long类型的；
- sequence：在DB2、PostgreSQL、Oracle、SAP DB、McKoi等提供sequence支持的数据表中适用。返回的标识属性值是short、int或者long类型的；
- hilo：使用一个高/低位算法高效的生成short、int或者long类型的标识符。给定一个表和字段（默认分别是hibernate_unique_key和next_hi）作为高位值的来源。高/低位算法生成的标识属性值只在一个特定的数据库中是唯一的；
- seqhilo：使用一个高/低位算法来高效地生成short、int或者long类型的标识符，需要给定一个数据库sequence名。该算法与hilo稍有不同，它将主键历史状态保存在Sequence中，适用于支持Sequence的数据库，如Oracle；
- uuid：用一个128位的UUID算法生成字符串类型的标识符，这在一个网络中是唯一的（IP地址也作为算法的）。UUID 被编码为一个32位十六进制数的字符串。UUID算法会根据IP地址，JVM的启动时间（精确到1/4 秒）、系统时间和一个计数器值（在JVM 中唯一）来生成一个32位的字符。因此，通常UUID生成的字符串在一个网络中是唯一的；
- guid：在Microsoft SQL Server和MySQL中使用数据生成的GUID字符串；
- native：根据底层数据库的能力选择identity、sequence或者hilo中的一个；
- assigned：让应用程序在save()之前为对象分配一个标识符。这相当于不指定`<generator.../>`元素时所采用的默认策略；
- select：通过数据库触发器选择某个唯一主键的行，并返回其主键值作为标识属性值。
- foreign：表明直接使用另一个关联的对象的标识属性值（即本持久化对象不能生成主键），这种主键生成器只在基于主键的1-1关联映射中才有用；

Hibernate使用`<id.../>`元素的子元素`<generator>`元素可以用来设置主键生成方式。该元素的作用是指定主键的生成器，通过一个class属性指定生成器对应的类。通常与`<id>`元素结合使用。如下所示：

```xml
<id name="id" column="ID" type="integer">
	<generator class="native" />
</id>
```

大部分数据库，如Oracle、DB2、MySQL等都提供易用的主键生成机制（identity字段或sequence等），因此我们完全可以在数据库提供的主键生成机制上，采用`<generator class="native"/>`的主键生成方式。

如果表使用联合主键，那么你可以映射类的多个属性为标识符属性。`<composite-id>`元素接受`<key-property>`属性映射和`<key-many-to-one>`属性映射作为子元素。以下定义了两个字段作为联合主键：

```xml
<composite-id>
	<key-property name="username" />
	<key-property name="password" />
</composite-id>
```

### 映射普通属性

Hibemate 使用`<property> `元素来声明持久化类的属性，为`property`元素name属性即可，用来表示持久化类属性名。

```xml
<property 
          name="propertyName"
          column="column_name"
          type="typename"
          update="true|false"
          insert="true|false"
          formula="arbitrary SQL expression"
          access="field|property|ClassName"
          lazy="true|false"
          unique="true|false"
          not-null="true|false"
          optimistic-lock="true|false"
          generated="never|insert|always"
          node="element-name|@attribute-name|element/@attribute|." 
          index="index_name" 
          unique_key="unique_key_id" 
          length="L"
          precision="P"
          scale="S">
  <property/>
```

除此必须的name属性之外，`<property> `元素还支持如下几个可选属性：

- column：用来表示持久化类的属性在数据表中对应的列名。如果不指定column属性，则默认column属性与name属性的值相同。该属性也可以指定为内嵌的`<column.../>`元素；
- type：指定该普通属性的数据类型，它是一个Hibernate类型。该type属性与前面`<id.../>`元素type属性的作用基本类似，但要求更低；
- update、insert：用于设置Hibernate生成的update或insert语句中是否需要包含该字段，这两个属性的默认值都是true。如果该属性是一个“外源性”的属性，即它的值由映射到相同数据列（可以是多个）的其他属性来初始化，或者是由触发器或其他程序生成的，总之**无须由Hibernate生成，则可将这两个属性设为false**；
- formula：该属性指定一个SQL 表达式，指定该属性的值将根据表达式来计算得出，计算出的属性没有和它对应的数据列；
- access：定义Hibernate访问该属性值的策略，默认是property。该属性用于覆盖根元素`<hibemate-mapping.../>`中的default-access属性；
- lazy：指定当该实例属性第一个被访问时，是否启动延迟加载。该属性默认是false；
- unique：设置是否为该属性所映射的数据列添加唯一约束。如果设置为true，就允许该字段作为property-ref引用的目标；
- not-null：设置是否为该属性所映射的数据列添加not null 约束；
- optimistic-clock：设置该属性在进行更新时是否需要使用乐观锁定，该属性值默认是true。也就是说，在默认情况下，当该属性的值发生改变时，该持久化对象的版本值将会增长；
- generated：设置该属性映射的数据列的值是否由数据库生成，该属性可以接受never（不由数据库生成）、insert（该属性值是insert时生成，但不会在随后的update 时重新生成）、always（该属性值在insert 和update 时都会被重新生成）；
- index：指定一个字符串的索引名称。当系统需要Hibernate自动建表时，用于为该属性所映射的数据列创建索引，从而加速基于该数据列的查询。
- unique_key：指定一个**唯一键**的名称。当系统需要Hibernate自动建表时，用于为该属性所映射的数据列创建唯一索引，只有当该数据列具有唯一约束时才有效；
- length：指定该属性所映射数据列的字段长度；
- precision：指定该属性所映射数据列的**有效数字位的位数**，对数值型的数据列有效；
- scale：指定该属性所映射数据列的**小数位数**，对double、float、decimal等类型的数据列有效。

上面的type属性值可以是如下几种：

- Hibemate基本类型名（比如integer、string、character、date、timestamp、float、binary、serializable、object、blob等）；
- Java类的全限定类名，该类等同于上面的一种Hibemate基础类型（如：int、float、char、java.lang.String、java.util.Date、java.lang.Integer、java.sql.Clob 等）；
- 一个可序列化的Java 类的类名；
- 用户自定义的类名。

如果不使用type属性，Hibernate将根据属性名使用反射来猜测出正确的Hibernate类型。有时候，必须使用type属性。比如，区别开Hibernate.DATE和Hibernate.TIMESTAMP，或者指定一个自定义类型。Hibernate默认使用getter和setter方法来操作属性。如果指定了`access="field"`，那么Hibernate就会绕开getter和setter方法，使用反射来直接访问属性。可以通过实现`org.hibernate.property.PropertyAccessor`来创建自定义的属性访问策略。

`<property.../>`元素中的formula属性指定持久化类的属性值使用SQL表达式来动态计算得出，包括运用sum、average、max等函数计算的结果。例如：

```xml
<property name="totalPrice"
	formula="(SELECT SUM(li.quantity*p.price) FROM LineItem li, Product p WHERE li.productId = p.productId AND li.customerId = customerId AND li.orderNumber = orderNumber)"/>
```

formula甚至可以根据当前记录的特定属性值从另一个表查询值。例如下面代码:

```xml
<property name="totalPrice"
	formula="(select cur.name from currency cur where cur.id=currencyID)"/>
```

使用formula属性时有如下几个注意点：

- formula="( sq! )"的英文括号不能少；

- formula="()"的括号里面是SQL表达式语句，SQL表达式中的列名和表名都应该和数据库对应，而不是和持久化对象的属性对应；

- 如果需要在formula属性中使用参数，则直接使用where cur.id= currencylD形式，其中currencylD就是参数，当前持久化实例的currencyID属性值将作为表达式中的currencylD参数传入。例如，有如下持久化类：

  ```java
  public class Student {
  	private long id;
    	private String fistname;
    	private String lastname;
    	private String fullname;
    	// 省略getter和setter方法等
    	....
  }
  ```

  对应的映射文件如下：

  ```xml
  <?xml version="1.0" encoding="gb2312"?>
  <!-- 指定Hiberante3映射文件的DTD信息 -->
  <!DOCTYPE hibernate-mapping PUBLIC 
  	"-//Hibernate/Hibernate Mapping DTD 3.0//EN"
  	"http://www.hibernate.org/dtd/hibernate-mapping-3.0.dtd">
  <!-- hibernate-mapping是映射文件的根元素 -->
  <hibernate-mapping package="org.rosydawn.model">
  	<!-- 每个class元素对应一个持久化对象 -->
  	<class name="Student" table="TABLE_STUDENT">
  		<!-- id元素定义持久化类的标识属性 -->
  		<id name="id">
  			<generator class="identity"/>
  		</id>
  		<!-- property元素定义常规属性 -->
  		<property name="fistname" column="FIRST_NAME" not-null="true"/>
  		<property name="lastname" column="LAST_NAME"/>
  		<!-- 通过formula指定该属性值没有对应的实际数据列
  			该属性值将由系统根据表达式来生成-->
  		<property name="fullname"
  			 formula="(select concat(p.fistname, p.lastname) 
  			 from TABLE_STUDENT p where p.id=id)"/> 
  	</class>
  </hibernate-mapping>
  ```

  从映射文件可以看出Person持久化类的fullname属性的值是根据其他属性计算出来的，在数据表中并没有对应的数据列。在其映射文件中`<property.../>`元素的formula属性定义了详细的计算逻辑。

**如果持久化对象有任何属性不是由Java程序提供，而是由数据库生成的**，包括该数据列使用timestamp数据类型、数据库采用触发器来为该列自动插入值等，**都可以在`<property.../>`元素中指定generated属性。对于指定了generated属性的持久化对象，每当Hibermate执行一条insert（当generated值为insert或always时）或update（当generated属性值为always时）语句时，Hiberate会立刻执行一条select语句来获得该数据列的值，并将该值赋给该持久化对象的这个属性**。

下面实例的Student类与前一个示例的相同，只是此时的fullname属性值将由数据库系统生成，所以在配置fullname属性时应指定generated属性。该持久化类的映射文件如下所示：

```xml
<?xml version="1.0" encoding="gb2312"?>
<!-- 指定Hiberante3映射文件的DTD信息 -->
<!DOCTYPE hibernate-mapping PUBLIC 
	"-//Hibernate/Hibernate Mapping DTD 3.0//EN"
	"http://www.hibernate.org/dtd/hibernate-mapping-3.0.dtd">
<!-- hibernate-mapping是映射文件的根元素 -->
<hibernate-mapping package="org.crazyit.app.domain">
	<!-- 每个class元素对应一个持久化对象 -->
	<class name="Student" table="TABLE_STUDENT">
		<!-- id元素定义持久化类的标识属性 -->
		<id name="id">
			<generator class="identity"/>
		</id>
		<!-- property元素定义常规属性 -->
		<property name="fistname" column="FIRST_NAME" not-null="true"/>
		<property name="lastname" column="LAST_NAME"/>
		<!-- 为该property指定generated属性为always
			该属性的值由数据库生成，
			而Hibernate会在每次插入、更新之后执行
			select语句来查询到该属性的值 -->
		<property name="fullname" column="FULL_NAME" type="string" generated="insert"/>
	</class>
</hibernate-mapping>
```

上面的映射文件指定fullName属性将由数据库系统自动生成，为了让数据库系统使用fullname属性（对应full_name数据列）自动生成值，本程序需要以下触发器支持：

```mysql
DELIMITER |
create trigger TRIGGER_FULL_NAME BEFORE INSERT ON TABLE_STUDENT
	FOR EACH ROW BEGIN
		set new.FULL_NAME=concat(new.FIRST_NAME, new.LAST_NAME);
	END;
|
DELIMITER ;
```

这样，保存一个Student对象后，虽然没有设置该对象的fullname属性值，Hibernate会在该对象插入数据表之前使用触发器为对应的FULL_NAME数据列赋值。如下代码所示：

```java
....
  Student student = new Student();
		//设置消息标题和消息内容
		student.setFistname("Bill");
		student.setLastname("Gates");
		//保存消息
		sess.save(student);
		//输出fullname属性值，将看到fistname和lastname连缀的字符串
		System.out.println(student.getFullname());
....
```

任何可以使用column或formula属性的地方都可使用`<column.../>`或`<formula.../>` 子元素，通常我们使用column属性或formula属性就足够了，但如果需要指定更多额外的信息，则可以通过使用`<column.../>`或`<formula.../>` 子元素来设定。例如，下面的两段代码效果是一样的：

```xml
<property nane="fullname" column="FULL_NAME" type="string" generated="insert"/>
```

使用column子元素来配置列信息：

```xml
<property nane="fullname"  type="string" generated="insert">
  <column name="FULL_NAME"/>
</property>
```

另外，使用`<column.../>`子元素时可以指定一个sql-type属性，用来指定数据列数据的精确SQL类型。

### 映射集合属性

集合属性大致有两种：第1种是单纯的集合属性，例如像List、Set或数组等集合属性，还有一种是Map结构的集合属性，每个属性值都有对应的key映射。

Hibernate要求持久化集合值字段必须声明为接口，实际的接口可以是java.util.Set、java.util.Collction、java.util.List、 java.util Map、java.util.SortedSet、java.util.SortedMap等，其至是自定义类型( 只需要实现org.hibernate.usertype.UserCollectionType接口即可)。

Hibernate之所以要求用集合接口来声明集合属性，是因为当程序持久化某个实例时，Hibernate会自动把程序中的集合实现类替换成Hiberate自己的集合实现类，因此不要试图把Hibernate集合属性强制类型转换为集合实现类，如HashSet、HashMap等，但可以转换为Set、Map等集合，因为Hibernate自己的集合类也实现了Map、Set等接口。

**集合类实例具有值类型的行为**：当持久化对象被保存时，这些集合属性会被自动持久化；当持久化对象被删除时，这些集合属性对应的记录将被自动删除。假设集合元素被从一个持久化对象传递到另一个持久化对象，该集合元素对应的记录会从一个表转移到另一个表。

两个持久化对象不能共享同一个集合元素的引用。集合映射的元素大致有如下几种：

- list：用于映射List 集合属性；
- set：用于映射Set 集合属性；
- map：用于映射Map 集合属性；
- array：用于映射数组集合属性；
- primitive-key：专门用于映射基本数据类型的数组；
- bag：用于映射无序集合；
- idbag：用于映射无序集合，但为集合增加逻辑次序。

这些集合属性素大致有如下**可选**属性：

- name：用于标明该集合属性的名称；
- table：指定保存集合属性的表名。如果没有指定该属性，则表名默认与集合属性同名；
- schema：指定保存集合属性的数据表的schema名称，用于覆盖在根元素中定义的schema属性；
- lazy：设置是否启动延迟加载，该属性默认是true，即大多数操作不会初始化集合类（适用于非常大的集合）；
- inverse：指定该集合关联的实体在双向关联关系中不控制关联关系；
- cascade：指定对持久化对象的持久化操作（如save、update、delete）是否会级联到它所关联的子实体。
- order-by：**该属性用于设置数据库对集合元素排序，该属性仅对1.4或更高版本的JDK有效。该属性的值为指定表的指定字段（一个或几个） 加上asc或者desc关键字，这种排序是数据库进行SQL查询时进行排序的，而不是直接在内存中排序**；
- sort：指定集合的排序顺序，可以为自然排序，或者使用给定的排序类进行排序；
- where：指定任意的SQL语句中where条件，该条件**将在加载或者删除集合元素时起作用**。只有满足该where条件的记录才会被操作；
- batch-size：定义延迟加载时每批抓取集合元素的数量。该属性默认是1；
- access：指定Hibernate访问集合属性的访问策略，默认是property；
- mutable：指定集合中的元素是否可变，如果指定该属性为false，则表明该集合元素不可变，在某此情况下可以进行一些小的性能优化。

因为集合属性都需要保存到另一个数据表中，所以保存集合属性的数据表必须包含一个外键列，用于参照到主键列。该外键列通过在`<set.../>`、`<list.../>`等集合元素中使用`<key.../>`子元素来映射。指定`<key.../>`元素时可以指定如下可选选项：

- column：指定外键字段的列名；
- on-delete：指定外键约束是否打开数据库级别的级联删除；
- property-ref：指定外键引用的字段是否为原表的主键；
- not-null：指定外键列是否具有非空约束，如果指定非空约束，则意味着无论何时，外键总是主键的一部分；
- update：指定外键列是否可更新，如果不允许更新，则意味着无论何时，外键总是主键的一部分；
- unique：指定外键列是否具有唯一约束，如果指定唯一约束，则意味着无论何时，外键总是主键的一部分。

> 当集合元素是基本数据类型、字符串类型、日期类型或其他复合类型时，因为这些集合元素都是从属于持久化对象的，所以`<key.../>`元素的not-null属性默认为true。但对于单向一对多关联来说，外键字段默认是可以为空的（即not-null属性默认为false），因此如果应用需要指定该外键列不允许为空，则需要指明`not-null="true"`。

在Java的所有集合类型（包括数组、Map）中，只有Set 集合是无序的，即没有显式的索引值。List、数组使用整数作为集合元素的索引值，而Map则使用key作为集合元素的索引。因此，在所有的集合映射中，除了`<set.../>`和`<bag.../>`元素外，都需要为集合元素的数据表指定一个索引列，用于保存数组索引，或者List的索引，或者Map集合的key索引。

用于映射索引列的元素有如下几个：

- `<list-index.../>`：用于映射List集合、数组的索引列；
- `<map-key.../>`：用于映射Map集合、基本数据类型的索引列；
- `<map-key-many-to-many>`：用于映射Map集合、**实体引用**类型的索引列；
- `<composite-map-key>`：用于映射Map集合、**复合数据**类型的索引列。

Hibernate集合元素数据类型几乎可以是任意数据类型，包括基本类型、字符串、日期、自定义类型、复合类型以及对其他持久化对象的引用。如果集合元素是基本类型、字符串、日期、自定义类型、复合类型等，则位于集合中的对象可能根据“值”语义来操作（其生命周期完全依赖于集合持有者，必须通过集合持有者来访问这些集合元素）；如果集合元素是其他持久化对象的引用，此时就变成了送联映射，那么这此集合元素都具有自己的生命周期。

综合所有情形，用于映射集合元素的大致包括如下几种元素：

- `<element.../>`：当集合元素是基本类型及其包装类、字符串类型和日期类型时使用该元素；
- `<composite-element../>`：当集合元素是复合类型时使用该元素；
- `<one-to-many.../>`或`<many-to-many.../>`：当集合元素是其他持久化对象的引用时使用它们。也就是说，这两个元素主要用于进行关联关系映射。

下面针对不同集合属性具体讲解。

#### List集合属性

List 是有序集合，因此持久化到数据库时也必须增加列来表示集合元素的次序（如id属性）。**集合属性只能以接口声明，该集合属性必须使用实现类完成初始化**。例如在下面的代码中，schools属性对应多个学校，其类型只能是List，不能是Arraylist，但使用ArrayList初始化。

```java
public class Person {
	//标识属性
	private Integer id;
	//普通属性name
	private String name;
	//普通属性age
	private int age;
	//集合属性，保留该对象关联的学校
	private List<String> schools = new ArrayList<String>();
	
	//省略setter和getter方法
  	...
}
```

虽然声明schools属性时使用了`List<String>`类型，但程序**必须显式地初始化该集合属性，否则程序运行时会抛出NullpointerException**，这个异常与Hibernate无关，只是当程序向该List集合（Hibernate没有对它初始化）中添加属性时，如果该属性还未初始化就会引发NullpointerException异常。

该持久化类的标识属性、普通属性的映射与前面相同，不同的是增加了集合属性。对本例的List集合属性，应该使用`<list.../> `元素完成映射、`<list.../>` 元素要求`<list-index.../>`的子元素来映射List集合的索引列。**集合属性的值不可能与持久化类存储在同一张表内，集合属性会存放在另外的表中，因此，必须以外健关联，所以需要增加`<key.../>`元素来映射该外键列**。

```xml
<?xml version="1.0" encoding="GBK"?>
<!DOCTYPE hibernate-mapping PUBLIC 
	"-//Hibernate/Hibernate Mapping DTD 3.0//EN"
	"http://www.hibernate.org/dtd/hibernate-mapping-3.0.dtd">
<hibernate-mapping package="com.rosydawn.model">
	<class name="Person" table="PERSON_INF">
		<!-- 映射标识属性 -->
		<id name="id" column="PERSON_ID">
			<!-- 指定主键生成器策略 -->
			<generator class="indentity"/>
		</id>
		<!-- 映射普通属性 -->
		<property name="name" type="string"/>
		<property name="age" type="int"/>
		<!-- 映射List集合属性 -->
		<list name="schools" table="SCHOOL">
			<!-- 映射集合属性数据表的外键列 -->
			<key column="PERSON_ID" not-null="true"/>
			<!-- 映射集合属性数据表的集合索引列 -->
			<list-index column="LIST_ORDER"/>
			<!-- 映射保存集合元素的数据列。由于list集合属性使用泛型，这里也可以不指定元素类型 -->
			<element column="SCHOOL_NAME" type="string"/>
		</list>
	</class>
</hibernate-mapping>
```

上面的映射文件中的List集合属性的元素是String类型，所以集合元素使用`<element.../>`元素即可。

**如果定义持久化类的集合属性时使用泛型来限制集合元素的类型，这样Hibernate可以通过反射来取得集合元素的数据类型。因此，定义`<element.../>`元素时无须指定type属性。但显式指定`<element.../>`元素的type属性来告诉Hibernate集合元素的类型就可以避免了Hibernate自己去识别。而`<list-index.../>`元素无须指定type属性，因为Hibernate可以确定List集合的索引值总是整数类型的**。

有了POJO类，也有了映射文件，该类可以完成持久化访问了：

```java
//创建并保存Person对象
private void createAndStorePerson(){
	//打开线程安全的session对象
	Session session = HibernateUtil.currentSession();
	//打开事务
	Transaction tx = session.beginTransaction();
  
	//创建Person对象
	Person yeeku = new Person();
	//为Person对象设置属性
	yeeku.setAge(10);
	yeeku.setName("Bill");
  
	//创建List集合
	List<String> schools = new ArrayList<String>();
	schools.add("小学");
	schools.add("中学");
	//设置List集合属性
	yeeku.setSchools(schools);
	session.save(yeeku);
	tx.commit();
	HibernateUtil.closeSession();
}
```

程序运行结束后，数据库将生成两个表，其中`PERSON_INF`表用于保存持久化类Person的基本属性，而`SCHOOL`表将用于保存集合属性schools。对于同一个持久化对象而言，它所包含的集合元素的索引是不会重复的，因此List集合属性可以用关联持久化对象的外键和集合索引列作为联合主键。所以上面程序得到的SCHOOL数据表会以SCHOOL.PERSON_ID和SCHOOL.LIST_ORDER作为联合主键。

#### 数组属性映射

Hibernate对数组和List的处理方式非常相似，实际上，List和数组也非常像，尤其是JDK 1.5增加了自动装箱、自动拆箱特性之后，它们用法的区别只是List的长度可以变化，而数组的长度不可变而已。

```java
public class Person {
	//标识属性
	private Integer id;
	//普通属性name
	private String name;
	//普通属性age
	private int age;
	//数组属性，保留该对象关联的学校
	private String[] schools;
	
	//省略setter和getter方法
  	...
}
```

**对数组集合属性，应该使用`<array.../>`元素完成映射，而`<array.../>`元素的子元素、属性等与`<list.../>`元素的用法完全一样**。下面是该持久化类的映射文件：

```xml
<?xml version="1.0" encoding="GBK"?>
<!DOCTYPE hibernate-mapping PUBLIC 
	"-//Hibernate/Hibernate Mapping DTD 3.0//EN"
	"http://www.hibernate.org/dtd/hibernate-mapping-3.0.dtd">
<hibernate-mapping package="com.rosydawn.model">
	<class name="Person" table="PERSON_INF">
		<!-- 映射标识属性 -->
		<id name="id" column="PERSON_ID">
			<!-- 指定主键生成器策略 -->
			<generator class="indentity"/>
		</id>
		<!-- 映射普通属性 -->
		<property name="name" type="string"/>
		<property name="age" type="int"/>
		<!-- 映射数组属性 -->
		<array name="schools" table="SCHOOL">
			<!-- 映射数组属性数据表的外键列 -->
			<key column="PERSON_ID" not-null="true"/>
			<!-- 映射数组属性数据表的集合索引列 -->
			<list-index column="LIST_ORDER"/>
			<!-- 映射保存数组元素的数据列 -->
			<element column="SCHOOL_NAME" type="string"/>
		</array>
	</class>
</hibernate-mapping>
```

#### Set集合属性

**Set 集合属性的映射与List 有点不同，因为Set 是无序、不可重复的集合，因此`<set.../>`元素无须使用`<list-index.../>`子元素来映射集合元素的索引列。与List相同的是，Set 集合同样需要使用`<key.../>`元素映射外键列，用于保证持久化类和集合属性的关联。Set集合属性声明时，只能使用Set接口，不能使用实现类**。

```java
public class Person {
	//标识属性
	private Integer id;
	//普通属性name
	private String name;
	//普通属性age
	private int age;
	//数组属性，保留该对象关联的学校
	private Set<String> schools = new HashSet<String>();
	
	//省略setter和getter方法
  	...
}
```

上面的程序中的schools是一个Set集合，因此应该使用`<set.../>`元素进行映射，`<set.../>`元素无须使用`<list-index.../>`子元素。

```xml
<?xml version="1.0" encoding="GBK"?>
<!DOCTYPE hibernate-mapping PUBLIC 
	"-//Hibernate/Hibernate Mapping DTD 3.0//EN"
	"http://www.hibernate.org/dtd/hibernate-mapping-3.0.dtd">
<hibernate-mapping package="com.rosydawn.model">
	<class name="Person" table="PERSON_INF">
		<!-- 映射标识属性 -->
		<id name="id" column="PERSON_ID">
			<!-- 指定主键生成器策略 -->
			<generator class="indentity"/>
		</id>
		<!-- 映射普通属性 -->
		<property name="name" type="string"/>
		<property name="age" type="int"/>
		<!-- 映射Set集合属性 -->
		<set name="schools" table="SCHOOL">
			<!-- 映射集合属性数据表的外键列 -->
			<key column="PERSON_ID" not-null="true"/>
			<!-- 映射保存集合元素的数据列，增加非空约束 -->
			<element column="SCHOOL_NAME" type="string" not-null="true"/>
		</set>
	</class>
</hibernate-mapping>
```

对比List和Set两种集合属性：List集合的元素有顺序，而Set 集合的元素没有顺序。**当集合属性在另外的表中存储时，List集合属性可以用关联持久化类的外键列和集合元素索引列作为联合主键，但Set集合没有索引列，则以关联持久化类的外键和元素列作为联合主键，前提是元素列不能为空。所以，一般将`<element.../>`元素`not-null`属性显式设置为true，该属性默认为false。映射Set集合属性时，如果为`<element.../>`元素设置`not-null="true"`，则集合属性表以关联持久化类的外键列和元素列作为联合主键，否则该表没有主键，但List 集合属性的表总是以外键列和元素索引列作为联合主键。**

#### bag集合映射

`<bag.../>`元素既可以映射List集合属性，也可以映射Set集合属性，甚至可以映射Collection集合属性。不管是哪种集合属性，使用`<bag.../>`元素都将被映射成无序集合。集合属性对应的表没有主键。`<bag.../>`元素只需要`<key.../>`元素来映射关联的外键列，而使用`<element.../>`元素来映射集合属性的元素列。

```java
public class Person {
	//标识属性
	private Integer id;
	//普通属性name
	private String name;
	//普通属性age
	private int age;
	//集合属性，保留该对象关联的学校
	private Collection<String> schools = new ArrayList<String>();
	
	//省略setter和getter方法
  	...
}
```

对应的映射文件如下：

```xml
<?xml version="1.0" encoding="GBK"?>
<!DOCTYPE hibernate-mapping PUBLIC 
	"-//Hibernate/Hibernate Mapping DTD 3.0//EN"
	"http://www.hibernate.org/dtd/hibernate-mapping-3.0.dtd">
<hibernate-mapping package="com.rosydawn.model">
	<class name="Person" table="PERSON_INF">
		<!-- 映射标识属性 -->
		<id name="id" column="PERSON_ID">
			<!-- 指定主键生成器策略 -->
			<generator class="indentity"/>
		</id>
		<!-- 映射普通属性 -->
		<property name="name" type="string"/>
		<property name="age" type="int"/>
		<!-- 使用bag元素映射集合属性 -->
		<bag name="schools" table="SCHOOL">
			<!-- 映射集合属性数据表的外键列 -->
			<key column="PERSON_ID" not-null="true"/>
			<!-- 映射保存集合元素的数据列 -->
			<element column="SCHOOL_NAME" type="string" not-null="true"/>
		</bag>
	</class>
</hibernate-mapping>
```

当使用`<bag.../>`元素来映射集合属性时，即使指定保存集合元素的数据列不能为null，保存集合元素的数据表依然没有主键。

#### Map集合元素

**Map集合属性需要使用`<map.../>`元素进行映射，当配置`<map.../>`元素时也需要使用`<key.../>`元素映射外键列。除此之外，Map集合属性还需要映射Map key。映射Map集合key的元素比较多，当Map的key是字符串类型、日期类型时，直接使用`<map-key.../>`元素来映射Map key即可，Hibernate将以外键列和key列作为联合主键**。与所有集合属性类似的是，集合属性的声明只能使用接口，但程序依然需要使用集合实现类显式初始化该集合属性。

假设有如下POJO 类：

```java
public class Person {
	//标识属性
	private Integer id;
	//普通属性name
	private String name;
	//普通属性age
	private int age;
	//Map集合属性，保留该对象关联的考试成绩
	private Map<String, Float> scores = new HashMap<String, Float>();
	
	//省略setter和getter方法
  	...
}
```

对应的映射文件如下：

```xml
<?xml version="1.0" encoding="GBK"?>
<!DOCTYPE hibernate-mapping PUBLIC 
	"-//Hibernate/Hibernate Mapping DTD 3.0//EN"
	"http://www.hibernate.org/dtd/hibernate-mapping-3.0.dtd">
<hibernate-mapping package="com.rosydawn.model">
	<class name="Person" table="PERSON_INF">
		<!-- 映射标识属性 -->
		<id name="id" column="PERSON_ID">
			<!-- 指定主键生成器策略 -->
			<generator class="indentity"/>
		</id>
		<!-- 映射普通属性 -->
		<property name="name" type="string"/>
		<property name="age" type="int"/>
		<!-- 映射Map集合属性 -->
		<map name="scores" table="SCORE">
			<!-- 映射集合属性数据表的外键列 -->
			<key column="PERSON_ID" not-null="true"/>
			<!-- 映射集合属性数据表的Map key列 -->
			<map-key column="SUBJECT" type="string"/>
			<!-- 映射保存集合元素的数据列 -->
			<element column="GRADE" type="float"/>
		</map>
	</class>
</hibernate-mapping>
```

上面的程序运行后，保存集合属性的SCORE表将会以PERSON_ID列和SUBJECT列作为联合主键。

#### 集合属性的性能分析

**对于集合属性，通常推荐使用延迟加载策略**。所谓延迟加载就是等系统需要使用集合属性时才从数据库装载关联的数据。Hibernate对集合属性默认采用延迟加载，在某些特殊的情况下，为`<set.../>`、`<list.../>`、`<map.../>`等元素设置`lazy="false"`属性来取消延迟加载。

根据前面的讲解，可将集合分成如下两类：

- 有序集合：集合里的元素可以根据key或index访问；
- 无序集合：集合里的元素只能遍历。

有序集合都拥有一个由外键列和集合元素索引列组成的联合主键，在这种情况下，集合属性的更新是非常高效的，主键已经被有效地索引，因此当Hibernate试图更新或删除行时，可以迅速找到该行数据。而无序集合，例如Set的主键由`<key.../>`和其他元素字段构成，或者根本没有主键。如果集合中元素是组合元素或者大文本、大二进制字段，数据库可能无法有效地对复杂的主键进行索引，即使可以建立索引，性能也非常差。

在这种情况下，`<bag.../>`映射是最差的。因为`<bag.../>`允许有重复的元素值，也没有索引字段，因此不可能定义主键。Hibernate无法判断重复行。如果试图修改这种集合属性时，Hibernate先删除全部集合。然后重新创建整个集合，效率非常低下。

显然，有序集合的属性在增加、删除、修改中拥有较好的性能表现。

对于多对多关联、值数据的集合而言，有序集合类比Set多一个好处：因为Set集合内部结构的原因，所以如果“改变”Set集合的某个元素，Hibernate并不会立即更新（update）该元素对应的数据行。因此，对于Set集合而言，只有在执行插入（insert）和删除（delete）操作时“改变”才有效。

**虽然数组也是有序集合，但数组无法使用延迟加载，因为数组的长度不可变，所以，实际上用数组作为集合的性能并不高，通常我们认为List、Map集合性能较高，而Set则紧随其后**。

在Hibernate中，Set应该是最通用的集合类型，这是因为“Set集合”的语义最贴近关系模型的关联关系，因此Hibernate的关联映射都是采用`<set.../>`元素（也可用`<bag.../>`元素）映射的。而且，在设计良好的Hibernate领域模型中，I-N关联的1的一端通常带有`inverse="true"`，对于这种关联映射，1的端不再控制关联关系，所有更新操作将会在N的一端进行处理，对于这种情况，无须考虑其集合的更新性能。

一旦我们指定了`inverse="true"`属性，则表明该集合映射作为反向集合使用，此时1的一端将不再控制关联关系。在这种情况下，使用`<list.../>`和`<bag.../>`映射属性将有较好的性能，因为我们可以在未初始化集合元素的情况下直接向bag或list添加新元素。因为Collection.add()和Collection.addAll()方法、以及List.add()和List.addAll()方法总是返回true。

但Set集合不同，Set集合需要保证集合元素不能重复，因此当程序试图向Set集合中添加元素时，Set集合需要先加载所有集合元素，再依次比较添加的新元素是否重复，最后才可以决定是否能成功添加新元素，所以向Set集合中添加元素时性能较低。

当我们试图删除集合的全部元素时，Hibernate是比较智能的。例如，我们调用List集合的clear()方法删除全部集合元素，Hibernate不会逐个地删除集合元素，而是使用一个delete语句就搞定了。

但如果我们不是删除全部集合元素，而是删除绝大部分集合元素，例如对个长度为20的集合类，如果我们要利除其中19 个集合元素，只剩下一个集合元素，Hibernate就没有我们期望的那么智能了，它会先调用一条delete语句删除全部集合元素，再调用Hibernate将会逐个地删除19个集合元素，这将产生19条delete语句。这时候我们需要一点小小的技巧，就可强制Hibernate先执行一条delete语句删除全部集合元素，再执行条insert语句插入希望剩下的集合元素。例如如下代码片段：

```java
List temp = person.getSchools();
// 强制person的schools集合属性为null
// Hibernate将调用delete语句删除person关联的全部集合元素
person.setSchools(null);
// 此处采用循环方式删除temp集合中的19个元素
// 但此时的temp集合和person实体无关，因此不会产生delete语句
...
// 再次将temp集合设置成person的schools属性值
// Hibernate将只需一条insert语句即可插入希望剩下的记录
person.setSchools(temp);
```

集合属性表里的记录完全“从属”于主表的实体，当主表的记录被删除时，集合属性表里“从属”于该记录的数据将会被删除：Hibernate无法直接加载、查询集合属性表中的记录，只能先加载主表实体，再通过主表实体去获取集合属性对应的记录。

#### 有序集合映射

Hibernate还支持使用SortedSet和SortedMap两个有序集合，当我们需要映射这种有序集合时，应该为`<map.../>`元素或`<set.../>`元素指定sort属性，该属性值可以是如下三个值：

- unsorted：映射有序集合时不排序；
- natural：映射有序集合时使用自然排序；
- java.util.Comparator实现类的类名：使用排序器对有序集合元素进行定制排序。

Hibernate的有序集合的行为与java.util.TreeSet或java.utilTreeMap的行为非常相似。示例代码如下：

```java
public class Person {
	//标识属性
	private Integer id;
	//普通属性name
	private String name;
	//普通属性age
	private int age;
	//有序集合属性，保留该对象参与的培训
	private SortedSet<String> course = new TreeSet<String>();
	
	//省略setter和getter方法
  	...
}
```

对应的映射文件如下：

```xml
<?xml version="1.0" encoding="GBK"?>
<!DOCTYPE hibernate-mapping PUBLIC 
	"-//Hibernate/Hibernate Mapping DTD 3.0//EN"
	"http://www.hibernate.org/dtd/hibernate-mapping-3.0.dtd">
<hibernate-mapping package="com.rosydawn.model">
	<class name="Person" table="PERSON_INF">
		<!-- 映射标识属性 -->
		<id name="id" column="PERSON_ID">
			<!-- 指定主键生成器策略 -->
			<generator class="indentity"/>
		</id>
		<!-- 映射普通属性 -->
		<property name="name" type="string"/>
		<property name="age" type="int"/>
		<!-- 映射SortedSet集合属性 -->
		<set name="trainings" table="COURSES" sort="natural">
			<!-- 映射集合属性数据表的外键列 -->
			<key column="PERSON_ID" not-null="true"/>
			<!-- 映射保存集合元素的数据列,增加非空约束 -->
			<element type="string" column="COURSE_NAME" not-null="true"/>
		</set>
	</class>
</hibernate-mapping>
```

按下来，**我们将hibernate.cfg.xml文件中的`hbm2ddl.auto`属性修改为`update`，这可保证后面操作不会承建数据表**，这样就可以为原来的Person对象的trainings属性增加元素了。

```java
private void createAndStorePerson() {
	Session session = HibernateUtil.currentSession();
	Transaction tx = session.beginTransaction();
  
	// 创建Person对象
	Person person = new Person();
	// 为Person对象设置属性
	person.setAge(9);
	person.setName("Bill");
	// 创建Set集合
	SortedSet<String> courses = new TreeSet<String>();
	courses.add("Art");
	courses.add("English");
	// 设置Set集合属性
	person.setCourses(s);
	session.save(courses);

  	// 因为前面的add()方法已经修改了持久化状态的Person对象
  	// 所以这里无须显式使用save()方法来保存程序所做的修改
	Person p = (Person)session.get(Person.class , 1);
	p.getCourses().add("Nature");

	tx.commit();
	HibernateUtil.closeSession();
}
```

查看数据库可以发现，后添加的元素依次排到了最前面。

如果希望数据库查询自己对集合元素排序，则可以利用`<set.../>`、`<bag.../>`或者`<map.../>`元素的`order-by`属性，该属性只能在1.4或者更高版本的JDK（因为底层需要利用LinkedHashSet或LinkedHashMap来实现）中有效，它会在SQL 查询中完成排序，而不是在内存中完成排序。例如有如下配置片段：

```xml
<?xml version="1.0" encoding="GBK"?>
<!DOCTYPE hibernate-mapping PUBLIC 
	"-//Hibernate/Hibernate Mapping DTD 3.0//EN"
	"http://www.hibernate.org/dtd/hibernate-mapping-3.0.dtd">
<hibernate-mapping package="com.rosydawn.model">
	<class name="Person" table="PERSON_INF">
		<!-- 映射标识属性 -->
		<id name="id" column="PERSON_ID">
			<!-- 指定主键生成器策略 -->
			<generator class="indentity"/>
		</id>
		<!-- 映射普通属性 -->
		<property name="name" type="string"/>
		<property name="age" type="int"/>
		<!-- 映射SortedSet集合属性 -->
		<set name="trainings" table="COURSES" order-by="TRAINING DESC">
			<!-- 映射集合属性数据表的外键列 -->
			<key column="PERSON_ID" not-null="true"/>
			<!-- 映射保存集合元素的数据列,增加非空约束 -->
			<element type="string" column="COURSE_NAME" not-null="true"/>
		</set>
	</class>
</hibernate-mapping>
```

上面的order-by属性指定了一个SQL排序子句，这意味着当程序通过Person实体获取courses属性时，所生成的SQL语句总会添加`order by courses desc`子句。

### 映射数据库对象

有时候我们希望在映射文件中创建和删除触发器、存储过程等数据库对象，Hibernate提供了`<database-object.../>`元素来满足这种需求。借助于Hibernate的Schema交互工具，这样就可让Hibernate映射文件拥有完全定义用户Schema的能力。使用`<database-object.../>`元素只有如下两种形式：

- 第一种形式是在映射文件中显式声明create和drop命令：

  ```xml
  <hibernate-mapping>
  	...
  	<database-object>
  		<!-- 定义创建数据库对象的语句 -->
  		<create>create trigger t_full_name_generator ...</create>
  		<!-- 让drop元素为空，不删除任何对象 -->
  		<drop>drop trigger t_full_name_generator ...</drop>
  	</database-object>
    	...
  </hibernate-mapping>
  ```

在上面的`<create.../>`元素里的内容就是一个完整的DDL语句，用于创建一个触发器；而`<drop.../>`元素里也定义了删除指定数据库对象的DDL。每个`<database-object.../>`元素中只有一组`<create.../>`、`<drop.../>`对。

- 第二种形式是提供一个类，这个类知道如何组织create和drop命令。这个特别类必须实现org.hibernate.mapping.AuxiliaryDatabaseObject接口。

  ```xml
  <hibernate-mapping>
  	...
  	<database-object>
  		<definition class="MyTriggerDefinition"/>
  	</database-object>
    	...
  </hibernate-mapping>
  ```

如果我们想指定某些数据库对象仅在特定的方言中才可使用，还可在`<database-object.../>`元素里使用`<dialect-object.../>`元素来进行配置。配置片段代码如下：

```xml
<hibernate-mapping>
	...
	<database-object>
		<!-- 定义创建数据库对象的语句 -->
		<create>create trigger t_full_name_generator ...</create>
		<!-- 让drop元素为空，不删除任何对象 -->
		<drop>drop trigger t_full_name_generator ...</drop>
      	<!-- 指定仅对MySQL数据库有效 -->
		<dialect-scope name="org.hibernate.dialect.MySQLDialect"/>
		<dialect-scope name="org.hibernate.dialect.MySQLInnoDBDialect"/>
	</database-object>
  	...
</hibernate-mapping>
```



虽然上面的示例代码片段都示范了如何创建、删除触发器，但实际上所有可以在java.sql.Statement.exccute()方法中执行的SQL语句都可以在此使用。例如，下面的配置文件将利用Hibernate映射文件来创建一个数据表：

```xml
<?xml version="1.0" encoding="gb2312"?>
<!-- 指定Hiberante3映射文件的DTD信息 -->
<!DOCTYPE hibernate-mapping PUBLIC 
	"-//Hibernate/Hibernate Mapping DTD 3.0//EN"
	"http://www.hibernate.org/dtd/hibernate-mapping-3.0.dtd">
<!-- hibernate-mapping是映射文件的根元素 -->
<hibernate-mapping>
	<!-- 使用data-object元素定义数据库对象 -->
	<database-object>
		<!-- 定义创建数据库对象的语句 -->
		<create>create table test(t_name varchar(255));</create>
		<!-- 让drop元素为空，不删除任何对象 -->
		<drop></drop>
		<!-- 指定仅对MySQL数据库有效 -->
		<dialect-scope name="org.hibernate.dialect.MySQLDialect"/>
		<dialect-scope name="org.hibernate.dialect.MySQLInnoDBDialect"/>
	</database-object>	
</hibernate-mapping>
```

该映射文件甚至没有映射任何的持久化类，只是使用`<database-object.../>`元素创建了一个简单的数据表。为了让该映射文件所定义的`<database-object.../>`元素生效，主程序只需如下两行即可：

```java
// 实例化Configuration，这行代码默认加载hibernate.cfg.xml文件
Configuration conf = new Configuration().configure();
// 以Configuration创建SessionFactory
SessionFactory sf = conf.buildSessionFactory();

```

运行上面两行代码，将看到Hibernate数据库里多了一个简单的数据表test。

> 为了让Hibernate根据`<database-object.../>`元素创建数据表，一定要将Hibernate配置文件里的hbm2ddl.auto 属性值修改成create。

实际上，如果我们仅仅为了根据映射文件来生成数据库对象，则可以利用Hibernate提供的SchemaExport工具，该工具可根据映射文件来生成数据库对象。我们可以将程序该为如下形式：

```java
// 创建SchemaExport对象
SchemaExport se = new SchemaExport(conf);
// 设置输出格式良好的SQL脚本
se.setFormat(true)
	//设置保存SQL脚本的文件名
	.setOutputFile("new.sql")
	//输出SQL脚本，并执行SQL脚本
	.create(true, true);
```

执行上面的程序，将会看到程序生成了一个new.sql文件，该文件里保存了创建test数据表的SQL脚本。

> 如果使用上面的程序来根据*.hbm.xml文件生成数据库对象，则无须将hbm2ddl.auto属性值修改成create，使用update也行。

除此之外，该工具类甚至提供了一个`public static void main(String[] args)`方法，也就是说，可直接使用java命令来解释、执行该工具类，命令格式如下：

```powershell
java -cp hibernate_claespaths org.hibernate.tool.hbm2ddl.SchemaExport options mapping_files
```

使用该命令的效果与直接在程序中利用SchemaExport对象的效果完全一样，使用该命令时可传入的选项可参考API 文档来了解各方法的功能和意义。





