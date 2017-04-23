---
typora-copy-images-to: ..\..\graphs\photos
typora-root-url: ./
---

## Spring依赖注入和控制反转

Dependency Injection and Inversion of Control

注解注入顾名思义就是通过注解来实现注入，Spring和注入相关的常见注解有Autowired、Resource、Qualifier、Service、Controller、Repository、Component。

Autowired是自动注入，自动从spring的上下文找到合适的bean来注入

Resource用来指定名称注入

Qualifier和Autowired配合使用，指定bean的名称

Service，Controller，Repository分别标记类是Service层类，Controller层类，数据存储层的类，spring扫描注解配置时，会标记这些类要生成bean。

Component是一种泛指，标记类是组件，spring扫描注解配置时，会标记这些类要生成bean。

上面的Autowired和Resource是用来修饰字段，构造函数，或者设置方法，并做注入的。而Service，Controller，Repository，Component则是用来修饰类，标记这些类要生成bean。



### 自动装配bean

Spring从两个角度来实现自动装配：

- 组件扫描（component scanning）：Spring会自动发现应用上下文中所创建的bean；
- 自动装配（autowiring）：Spring自动满足bean之间的依赖。

#### 创建可被发现的bean

@Component注解修饰类会作为组件类，并告知Spring要为这个类创建bean。下面代码中的SgtPeppers类使用了@Component注解修饰，就没有必要对其进行显式配置了，Spring会把事情处理妥当。

```java
package soundsystem;

public interface CompactDisc {
  void play();
}
```

```java
package soundsystem;

import org.springframework.stereotype.Component;

@Component
public class SgtPeppers implements CompactDisc {
  private String title = "Sgt. Pepper's Lonely Hearts Club Band";
  private String artist = "The Beatles";
  public void play() {
    System.out.println("Playing " + title + " by " + artist);
  }
}
```

#### 为组件扫描的Bean命名

Spring应用上下文中所有的bean都会给定一个ID。尽管我们没有明确地为上面的代码中的SgtPeppers bean设置ID，但Spring默认会将其类名的第一个字母变为小写来作为其ID。故这个bean所给定的ID为sgtPeppers。

可以向@Component注解传递一个自定义的ID作为当前bean的ID：

```java
@Component("lonelyHeartsClub")
public class SgtPeppers implements CompactDisc {...}
```

还可以使用Java依赖注入规范（Java Dependency Injection）中所提供的@Named注解来为bean设置ID

```java
package soundsystem;

import javax.inject.Named;

@Named("lonelyHeartsClub")
public class SgtPeppers implements CompactDisc {...}
```

@Named注解可以作为@Component注解的替代方案。两者虽有一些细微的差异，但是在大多数场景中，它们是可以互相替换的。但@Named注解的名字的可读性不好——它并没有表明为何种类型的对象指定ID名称。

#### 设置组件扫描的基础包

组件扫描默认是不启用的。启用组件扫描还需要使用@ComponentScan注解显式配置一下，这个注解能够使Spring扫描到@Component注解修饰的类。如下面的代码所示，CDPlayerConfig类使用@ComponentScan注解之后，Spring会扫描到前面使用了@Component注解修饰的SgtPeppers类。

```java
package soundsystem;

import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;

@Configuration
@ComponentScan
public class CDPlayerConfig {}
```

如果没有其他配置的话，@ComponentScan默认会扫描配置类所处的包以及这个包下的所有子包，查找出所有带@Component注解的类，然后自动为它们创建一个bean。如果想使逻辑更清楚，可以将配置类放在单独的包中，使其与其他的应用代码区分开来，这样的话就必须**明确地设置扫描的基础包** ——将@ComponentScan注解的value元素的值指定为要扫描的基础包的名称：

```java
@Configuration
@ComponentScan("soundsystem")
public class CDPlayerConfig {}
```

可以使用@ComponentScan注解的basePackages元素来更加清晰地表明所设置的是基础包：

```java
@Configuration
@ComponentScan(basePackages="soundsystem")
public class CDPlayerConfig {}
```

basePackages元素可以设置多个基础包，只需要将basePackages元素设置为要扫描包的一个数组即可：

```java
@Configuration
@ComponentScan(basePackages={"soundsystem", "video"})
public class CDPlayerConfig {}
```

所设置的基础包是以String类型表示的。但这种方法是类型不安全（not type-safe）的，重构代码时所指定的基础包可能就会出现错误了。

@ComponentScan还可以通过basePackageClasses元素指定为扫描某个类或接口所在的包：

```java
@Configuration
@ComponentScan(basePackageClasses={CDPlayer.class, DVDPlayer.class})
public class CDPlayerConfig {}
```

**basePackageClasses元素所设置的数组中的类所在的包将会作为组件扫描的基础包。可以考虑在这些包中创建一个用来专门进行扫描的空标记接口**（marker interface），通过标记接口可以避免引用任何有应用功能的程序代码，即使这些程序代码在重构后被移除了，也可以保证重构时这种扫描包配置的安全性。

如果使用XML来启用组件扫描的话，那么可以使用Spring context命名空间的 `<context:component-scan>` 元素。一般

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"                                         		 xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xmlns:context="http://www.springframework.org/schema/context"
xsi:schemaLocation="http://www.springframework.org/schema/beans 
                    http://www.springframework.org/schema/beans/spring-beans.xsd
                    http://www.springframework.org/schema/context
                    http://www.springframework.org/schema/context/spring-context.xsd">
  
 	<context:component-scan base-package="soundsystem" />
</beans>
```

`<context:component-scan>` 元素会有与@ComponentScan注解相对应的属性和子元素。

#### 为bean添加自动装配的注解

自动装配就是让Spring自动满足bean依赖的一种方法，在满足依赖的过程中，Spring会在应用上下文中寻找匹配某个bean需求的其他bean。可以借助@Autowired注解声明自动装配。

```java
package soundsystem;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class CDPlayer implements MediaPlayer {
  private CompactDisc cd;
  
  @Autowired
  public CDPlayer(CompactDisc cd) {
    this.cd = cd;
  }
  
  public void play() {
    cd.play();
  }
}
```

在上面代码中，CDPlayer类的构造器上添加了@Autowired注解，这表明当Spring创建CDPlayer bean的时候，会通过这个构造器来进行实例化并且会传入一个可指定为CompactDisc类型的bean。

**@Autowired注解不仅能够用在构造器上，还能用在属性的Setter方法上**。比如说，如果CDPlayer有一个setCompactDisc()方法，那么可以采用如下的注解形式进行自动装配：

```java
@Autowired
public void setCompactDisc(CompactDisc cd) {
  this.cd = cd;
}
```

**@Autowired注解其实可以用在类的任何方法上**。假设CDPlayer类有一个insertDisc()方法，那么@Autowired能够像在setCompactDisc()上那样，发挥完全相同的作用：

```java
@Autowired
public void insertDisc(CompactDisc cd) {
  this.cd = cd;
}
```

**不管是构造器、Setter方法还是其他的方法，Spring都会尝试满足方法参数上所声明的依赖。假如有且只有一个bean匹配依赖需求的话，那么这个bean将会被装配进来。如果没有匹配的bean，那么在应用上下文创建的时候，Spring会抛出一个异常。可以将@Autowired的required属性设置为false来避免异**
**常的出现** ：

```java
@Autowired(required=false)
public CDPlayer(CompactDisc cd) {
  this.cd = cd;
}
```

**将required属性设置为false时，Spring会尝试执行自动装配，但是如果没有匹配的bean的话，Spring将会让这个bean处于未装配的状态。但是，把required属性设置为false时，如果在代码中没有进行null检查的话，这个处于未装配状态的属性有可能会出现NullPointerException。如果有多个bean都能满足依赖关系的话，Spring将会抛出一个异常，表明没有明确指定要选择哪个bean进行自动装配**。

@Autowired是Spring特有的注解。可以考虑将其替换为Java依赖注入规范提供的@Inject注解：

```java
package soundsystem;
import javax.inject.Inject;
import javax.inject.Named;

@Named
public class CDPlayer {
  ...
  @Inject
  public CDPlayer(CompactDisc cd) {
    this.cd = cd;
  }
  ...
}
```

在自动装配中，Spring同时支持@Inject和@Autowired。尽管@Inject和@Autowired之间有着一些细微的差别，但是在大多数场景下，它们都是可以互相替换的。

#### 小结

自动装配的实现：

- Java注解实现：
  1. 使用@Component注解修饰要创建bean实例的POJO；
  2. 在上面的POJO定义中使用@Autowired注解修饰注入其他bean的方法（构造器、setter方法或任意引入其他bean的方法）；
  3. 使用@ComponentScan注解扫描需要创建bean的POJO所在的类。
- XML配置：
  1. 在XML文件中使用 `<bean>` 元素声明要创建bean实例的POJO类；
  2. 在

### 显式装配bean

有时候自动配置的方案行不通，从而需要显式装配。比如说，无法在第三方库中的组件上使用@Component和@Autowired注解，因此就不能使用自动装配的方案了。在进行显式配置的时候，有两种可选方案：Java和XML。

#### 通过Java代码装配bean

在进行显式配置时，由于Java配置代码具有Java语言的特性，所以其功能强大、类型安全并且对重构友好。

但Java配置代码不应该包含任何业务逻辑，也不应该侵入到业务逻辑代码之中。尽管没有强制要求，但通常会将Java配置代码放到单独的包中，使它与其他的应用程序逻辑分离开来。

##### 创建Java配置类

通过为一个Java类添加@Configuration注解来表明该类是一个配置类，该配置类应该包含创建bean的细节：

```java
package soundsystem;

import org.springframework.context.annotation.Configuration;

@Configuration
public class CDPlayerConfig {
	@Bean
	public CompactDisc sgtPeppers() {
  		return new SgtPeppers();
	}
}
```

> 说明：尽管可以同时使用组件扫描和显式配置，但是这里重点介绍于显式配置，因此将CDPlayerConfig的@ComponentScan注解移除掉了。

要在Java配置类中声明bean，需要编写一个会创建所需类型的实例的方法，然后为该方法添加@Bean注解。@Bean注解会告诉Spring该方法将会返回一个要注册为Spring应用上下文中的bean的对象。该方法中包含了产生bean实例的逻辑。

**默认情况下，bean的ID与@Bean注解修饰的方法的名称是一样的**。在本例中，bean的名字将会是sgtPeppers。**如果你想为其设置成一个不同的名字的话，那么可以重命名该方法，也可以通过@Bean注解的元素属性指定一个不同的名字**：

```java
@Bean(name="lonelyHeartsClubBand")
public CompactDisc sgtPeppers() {
  return new SgtPeppers();
}
```

#####  使用Java配置类实现注入

在Java配置类中装配bean的最简单方式就是引用创建bean的方法：

```java
@Bean
public CDPlayer cdPlayer() {
  return new CDPlayer(sgtPeppers());
}
```

cdPlayer()方法像sgtPeppers()方法一样，同样使用了@Bean注解，这表明该方法会创建一个bean实例并将其注册到Spring应用上下文中。所创建的bean ID为cdPlayer，与方法的名字相同。

cdPlayer()的方法体并没有使用默认的无参构造器创建实例，而是调用了其需要传入CompactDisc对象的构造器来创建CDPlayer实例。这样看起来，CompactDisc是通过调用sgtPeppers()来提供的，但情况并非完全如此。因为sgtPeppers()方法上添加了@Bean注解，Spring将会拦截所有对它的调用，并确保直接返回该方法所创建的bean，而不是每次都对其进行实际的调用。

假设在配置类中引入了一个其他的CDPlayer bean，它和之前的那个bean完全一样：

```java
@Bean
public CDPlayer cdPlayer() {
	return new CDPlayer(sgtPeppers());
}

@Bean
public CDPlayer anotherCDPlayer() {
	return new CDPlayer(sgtPeppers());
}
```

虽然现实中在物理上并没有办法将同一张CD光盘放到两个CD播放器中。但是，在软件领域中完全可以将同一个SgtPeppers实例注入到任意数量的其他bean之中。**默认情况下，Spring中的bean都是单例的**，没有必要为第二个CDPlayer bean再创建一个完全相同的SgtPeppers实例。因此，两个CDPlayer bean会得到相同的SgtPeppers实例。

上面在返回语句中调用@Bean修饰的方法来引用bean的方式有点令人困惑，下面传入参数的方式会更容易理解：

```java
@Bean
public CDPlayer cdPlayer(CompactDisc compactDisc) {
	return new CDPlayer(compactDisc);
}
```

当Spring调用cdPlayer()创建CDPlayer bean的时候，它会自动装配一个CompactDisc对象到配置方法之中。然后，方法体就可以按照合适的方式来使用它。这样cdPlayer()方法也能够将CompactDisc注入到CDPlayer的构造器中，而不用明确引用CompactDisc的@Bean方法（如上面的sgtPeppers()方法）。

**通过这种传入对象参数的方式引用其他bean通常是最佳的选择，因为它不会要求将其他bean声明到同一个配置类之中**。在这里甚至没有要求CompactDisc必须要在Java配置类中声明，实际上它可以通过组件扫描功能自动发现或者通过XML来进行配置。可以将配置分散到多个配置类、XML文件以及自动扫描和装配bean之中，只要功能完整健全即可。不管CompactDisc 是采用什么方式创建出来的，Spring都会将其传入到配置方法中，并用来创建CDPlayer bean。

在这里使用CDPlayer的构造器实现了DI功能，但完全可以采用其他风格的DI配置。比如说，如果通过Setter方法注入CompactDisc：

```java
@Bean
public CDPlayer cdPlayer(CompactDisc compactDisc) {
	CDPlayer cdPlayer = new CDPlayer(compactDisc);
	cdPlayer.setCompactDisc(compactDisc);
	return cdPlayer;
}
```

再次强调一遍，**带有@Bean注解的方法可以采用任何必要的Java功能来产生bean实例。构造器和Setter方法只是@Bean方法的两个简单样例**。创建bean的方法仅仅受到Java语法的制约。

### 通过XML装配bean

在Spring刚刚出现的时候，XML是描述配置的主要方式。在XML配置中，要创建一个以 `<beans>` 元素为根元素XML文件：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xsi:schemaLocation="http://www.springframework.org/schema/beans
http://www.springframework.org/schema/beans/spring-beans.xsd
http://www.springframework.org/schema/context">

<!-- configuration details go here -->

</beans>
```

用来装配bean的最基本的XML元素包含在 `spring-beans schema` 之中，在上面这个XML文件 中，它被定义为根命名空间。`<beans>` 是该模式中的一个元素，它是所有Spring配置文件的根元素。在XML中配置Spring时，还有一些其他的模式。

#### 声明一个简单的`<bean>`

要在上面基于XML的配置中声明一个bean，通过使用 `spring-beans schema` 中的`<beans>` 元素：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xsi:schemaLocation="http://www.springframework.org/schema/beans
http://www.springframework.org/schema/beans/spring-beans.xsd
http://www.springframework.org/schema/context">

<bean class="soundsystem.SgtPeppers" />

</beans>
```

`<bean>` 元素类似于Java配置类中的@Bean注解。创建这个bean的类通过class属性来指定其全限定的类名。如果没有明确给定ID，这个bean将会根据全限定类名来进行自动命名。在本例中，bean的ID将会是“soundsystem.SgtPeppers#0”。其中，“#0”是一个计数的形式，用来区分相同类型的其他bean。如果你声明了另外一个SgtPeppers，并且没有明确进行标识，那么它自动得到的ID将会是“soundsystem.SgtPeppers#1”。

尽管自动的bean命名非常方便，但**因为无法确定系统给某个bean的分配的具体ID，所以引用自动命名的bean几乎不可能**。可以通过`<bean>` 元素的id属性为每个bean设置一个自定义的名字：

```xml
<bean id="compactDisc" class="soundsystem.SgtPeppers" />
```

> 注意：
>
> 1. 为了减少XML中繁琐的配置，最好只对那些需要按名字引用的bean（比如，需要将对它的引用注入到另外一个bean中）进行明确地命名；
> 2. Java配置方式可以通过任何可以想象到的方法来创建bean实例，而在XML配置中，bean的创建显得更加被动，由于创建bean的类以**字符串**的形式设置在了class属性中，无法保证设置给class属性的值是真正的类，编译时无法检查到所指定的字符串形式的类。即便它所引用的是实际的类，如果你重构时重命名了类，class属性的值也不会跟着改变。所以这种配置不是类型安全的。

#### 借助构造器注入初始化bean

在Spring XML配置中，只能通过使用 `<bean>` 元素并指定class属性来声明bean。但是，在XML中有多种可选的方案来的配置 `<bean>` 。具体到构造器注入，有两种基本的配置方案可供选择：

- `<constructor-arg>` 元素；
- 用Spring 3.0所引入的c-命名空间。

两者的区别在很大程度上就是是否冗长烦琐。可以看到，`<constructor-arg>` 元素比使用c-命名空间会更加冗长，从而导致XML更加难以读懂。另外，有些事情`<constructor-arg>` 可以做到，但是使用c-命名空间却无法实现。

##### 构造器注入bean引用

前面已经在XML文件中声明了类型为SgtPeppers的bean，并且SgtPeppers类实现了CompactDisc接口，所以这个已声明的SgtPeppers的bean可以注入到CDPlayer bean的声明中：

```xml
<bean id="cdPlayer" class="soundsystem.CDPlayer">
	<constructor-arg ref="compactDisc" />
</bean>
```

当Spring为上面这个 `<bean>` 元素创建CDPlayer的bean实例是，`<constructor-arg>` 元素的 `ref` 属性会告知Spring要将一个ID为 `compactDisc` 的bean引用传递到CDPlayer的构造器中。

可以使用Spring的c-命名空间作为 `<constructor-arg>`  元素替代的方案。c-命名空间是在Spring 3.0中引入的，它可在XML中**更为简洁地描述构造器参数的引用**。要使用它的话，必须要在XML的顶部声明其模式（schema）：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
xmlns:c="http://www.springframework.org/schema/c"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xsi:schemaLocation="http://www.springframework.org/schema/beans
http://www.springframework.org/schema/beans/spring-beans.xsd">

	<bean id="cdPlayer" class="soundsystem.CDPlayer" c:cd-ref="compactDisc" />

</beans>
```

这个 `c:cd-ref` 属性的名字有点诡异：

![cnamespace](../../graphs/photos/cnamespace.png)

属性名以 `c:` 开头，也就是命名空间的前缀。接下来就是要装配的构造器参数名，后面的 `-ref` 会告诉Spring装配的是一个bean的引用，这个bean的ID是 `compactDisc`。显然，使用c-命名空间属性比使用 `<constructor-arg>` 元素更易读，还缩短了代码的长度。

c-命名空间属性不好的地方就是它直接引用了构造器参数的名称，这就需要在编译代码的时候，将调试标志（debug symbol）保存在类代码中。如果你优化构建过程，将调试标志移除掉，那么这种方式可能就无法正常工作了。替代的方案是**使用参数在整个参数列表中的位置信息**：

```xml
<bean id="cdPlayer" class="soundsystem.CDPlayer" c:_0-ref="compactDisc" />
```

上面的代码**将参数的名称替换成了参数的索引0**，因为在**XML中不允许数字作为属性的第一个字符**，因此必须要添加一个下画线作为前缀。使用位置索引来识别构造器参数感觉比使用名字更好一些。即便在构建的时候移除掉了调试标志，参数却会依然保持相同的顺序。如果有多个构造器参数的话就显得很有用。在这里因为**只有一个构造器参数，就可以根本不用去标示参数索引**：

```xml
<bean id="cdPlayer" class="soundsystem.CDPlayer" c:_-ref="compactDisc" />
```

##### 将字面量注入到构造器中

前面所做的DI通常指的都是类型的装配（将对象的引用装配到依赖于它们的其他对象之中）。接下来介绍用一个字面量值（字符串值）来配置对象。下面代码创建了CompactDisc的一个新的实现：

```java
package soundsystem;

public class BlankDisc implements CompactDisc {
	private String title;
	private String artist;

	public BlankDisc(String title, String artist) {
		this.title = title;
		this.artist = artist;
	}

	public void play() {
		System.out.println("Playing " + title + " by " + artist);
	}
}
```

然后将ID为 `compactDisc` 的 `<bean>` 元素的class属性的值由SgtPeppers替换为上面定义的类BlankDisc：

```xml
<bean id="compactDisc" class="soundsystem.BlankDisc">
	<constructor-arg value="Sgt. Pepper's Lonely Hearts Club Band" />
	<constructor-arg value="The Beatles" />
</bean>
```

但是这一次没有使用 `ref`属性来引用其他的bean，而是使用了value属性，通过该属性表明给定的值要以字面量的形式注入到构造器之中。

如果要使用c-命名空间的话，**第一种方案是引用构造器参数的名字**：

```xml
<bean id="compactDisc" class="soundsystem.BlankDisc"
	c:_title="Sgt. Pepper's Lonely Hearts Club Band"
	c:_artist="The Beatles" />
```

装配字面量与装配引用的区别在于属性名中去掉了 `-ref` 后缀。也可以**通过参数索引装配字面量值**：

```xml
<bean id="compactDisc" class="soundsystem.BlankDisc" 
      c:_0="Sgt. Pepper's Lonely Hearts Club Band" 
      c:_1="The Beatles" />
```

XML不允许某个元素的多个属性具有相同的名字，因此，如果有两个或更多的构造器参数的话，就不能简单地仅使用下画线进行标示。但是如果只有一个构造器参数的话，就可以这样做了。假设BlankDisc只有一个构造器参数，这个参数接受唱片的名称，那么就可以使用下面的形式：

```xml
<bean id="compactDisc" class="soundsystem.BlankDisc"
	c:_="Sgt. Pepper's Lonely Hearts Club Band" />
```

`<constructor-arg>` 和c-命名空间属性都可以实现装配bean引用和字面量值，但是 **`<constructor-arg>` 能够实现装配集合，而c-命名空间却不行**。

#### 装配集合

大多数的CD都会包含十多个磁道，每个磁道上包含一首歌。下面创建一个新的包含磁道列表的BlankDisc：

```java
package soundsystem.collections;
import java.util.List;
import soundsystem.CompactDisc;

public class BlankDisc implements CompactDisc {

	private String title;
	private String artist;
	private List<String> tracks;

	public BlankDisc(String title, String artist, List<String> tracks) {
		this.title = title;
		this.artist = artist;
		this.tracks = tracks;
	}
  
  public void play() {
		System.out.println("Playing " + title + " by " + artist);
		for (String track : tracks) {
		System.out.println("-Track: " + track);
		}
	}

}
```

在声明上面这个类的bean的时候，必须要提供一个磁道列表。最简单的办法是将列表设置为null。因为它是一个构造器参数，所以必须要声明它，不过
你可以采用如下的方式传递null给它：

```xml
<bean id="compactDisc" class="soundsystem.BlankDisc">
	<constructor-arg value="Sgt. Pepper's Lonely Hearts Club Band" />
	<constructor-arg value="The Beatles" />
	<constructor-arg><null/></constructor-arg>
</bean>
```

`<null/>` 元素所做的事情将null传递给构造器。在注入期它能正常执行，但当调用play()方法时会遇到NullPointerException异常。更好的解决方法是提供一个磁道名称的列表。要达到这一点，我们可以有多个可选方案。首先，可以使用 `<list>` 元素将其声明为一个列表：

```xml
<bean id="compactDisc" class="soundsystem.BlankDisc">
	<constructor-arg value="Sgt. Pepper's Lonely Hearts Club Band" />
	<constructor-arg value="The Beatles" />
	<constructor-arg>
		<list>
			<value>Sgt. Pepper's Lonely Hearts Club Band</value>
			<value>With a Little Help from My Friends</value>
			<value>Lucy in the Sky with Diamonds</value>
			<value>Getting Better</value>
			<value>Fixing a Hole</value>
			<!-- ...other tracks omitted for brevity... -->
		</list>
	</constructor-arg>
</bean>
```

`<list>` 元素是 `<constructor-arg>` 的子元素，这表明一个包含值的列表将会传递到构造器中。其中，`<value>` 元素用来指定列表中的每个元素。也可以使用 `<ref>` 元素替代 `<value>` ，实现bean引用列表的装配。假设有一个Discography类，它的构造器如下所示：

```java
public Discography(String artist, List<CompactDisc> cds) { ... }
```

可以采取下面的方式配置Discography bean：

```xml
<bean id="beatlesDiscography" class="soundsystem.Discography">
  <constructor-arg value="The Beatles" />
	<constructor-arg>
		<list>
			<ref bean="sgtPeppers" />
			<ref bean="whiteAlbum" />
			<ref bean="hardDaysNight" />
			<ref bean="revolver" />
			...
		</list>
	</constructor-arg>
</bean>
```

如果构造器的参数是java.util.Set类型，也可以按照同样的方式使用`<set>`元素：

```xml
<bean id="compactDisc" class="soundsystem.BlankDisc">
	<constructor-arg value="Sgt. Pepper's Lonely Hearts Club Band" />
	<constructor-arg value="The Beatles" />
	<constructor-arg>
		<set>
			<value>Sgt. Pepper's Lonely Hearts Club Band</value>
			<value>With a Little Help from My Friends</value>
			<value>Lucy in the Sky with Diamonds</value>
			<value>Getting Better</value>
			<value>Fixing a Hole</value>
			<!-- ...other tracks omitted for brevity... -->
		</set>
	</constructor-arg>
</bean>
```

如果是Set的话，所有重复的值都会被忽略掉，存放顺序也不会得以保证。不过无论在哪种情况下，`<set>` 或 `<list>` 都可以用来装配List、Set甚至数组。

### 设置属性

接下来，看一下如何使用Spring XML实现属性注入。假设属性注入的CDPlayer如下所示：

```java
package soundsystem;
import org.springframework.beans.factory.annotation.Autowired;
import soundsystem.CompactDisc;
import soundsystem.MediaPlayer;

public class CDPlayer implements MediaPlayer {
	private CompactDisc compactDisc;

	@Autowired
	public void setCompactDisc(CompactDisc compactDisc) {
		this.compactDisc = compactDisc;
	}

	public void play() {
		compactDisc.play();
	}
}
```

作为一个通用的规则，一般倾向于对强依赖使用构造器注入，而对可选性的依赖使用属性注入。按照这个规则，对于BlankDisc来讲，唱片名称、艺术家以及磁道列表是强依赖，因此构造器注入是正确的方案。CDPlayer类没有任何的构造器（除了隐含的默认构造器），它也没有任何的强依赖。因此，可以采用如下的方式将其声明为Spring bean：

```xml
<bean id="cdPlayer" class="soundsystem.CDPlayer" />
```

Spring在创建bean的时候不会有任何的问题，但是CDPlayerTest会因为出现NullPointerException而导致测试失败，因为我们并没有注入CDPlayer的compactDisc属性。不过，按照如下的方式修改XML就能解决该问题：

```xml
<bean id="cdPlayer" class="soundsystem.CDPlayer">
	<property name="compactDisc" ref="compactDisc" />
</bean>
```

`<property>` 元素为属性的Setter方法所提供的功能与 `<constructor-arg>` 元素为构造器所提供的功能是一样的。在本例中，它引用了ID为compactDisc的bean（通过ref属性），并将其注入到compactDisc属性中（通过setCompactDisc()方法）。这样运行测试就能通过了。

Spring提供了更加简洁的p-命名空间，作为 `<property>` 元素的替代方案。为了启用p-命名空间，必须要在XML文件中与其他的命名空间一起对其进行声明：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
xmlns:p="http://www.springframework.org/schema/p"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xsi:schemaLocation="http://www.springframework.org/schema/beans
http://www.springframework.org/schema/beans/spring-beans.xsd">
  
  <bean id="cdPlayer" class="soundsystem.CDPlayer"
	p:compactDisc-ref="compactDisc" />
</bean>
```

p-命名空间属性的组成如下图所示：

![pnamespace](../../graphs/photos/pnamespace.png)

属性的名字使用了 `p:` 前缀，表明所设置的是一个属性。后面是要注入的属性名。最后，属性的名称后的 `-ref` 表明Spring要进行装配的是引用，而不是字面量。

#### 将字面量注入到属性中

属性也可以注入字面量，这与构造器参数非常类似。重新看一下BlankDisc bean：

```java
package soundsystem;
import java.util.List;
import soundsystem.CompactDisc;

public class BlankDisc implements CompactDisc {

	private String title;
	private String artist;
	private List<String> tracks;

	public void setTitle(String title) {
		this.title = title;
	}

	public void setArtist(String artist) {
		this.artist = artist;
	}
  	public void setTracks(List<String> tracks) {
		this.tracks = tracks;
	}

	public void play() {
		System.out.println("Playing " + title + " by " + artist);
		for (String track : tracks) {
			System.out.println("-Track: " + track);
		}
	}
}
```

如果在装配bean的时候不设置这些属性，由于没有指定任何的磁道，那么在运行期CD播放器将不能正常播放内容，也会抛出NullPointerException异常：

```xml
<bean id="reallyBlankDisc" class="soundsystem.BlankDisc" />
```

所以，我们需要装配这些属性，可以借助 `<property>` 元素的value属性实现该功能：

```xml
<bean id="compactDisc" class="soundsystem.BlankDisc">
	<property name="title" value="Sgt. Pepper's Lonely Hearts Club Band" />
	<property name="artist" value="The Beatles" />
	<property name="tracks">
		<list>
			<value>Sgt. Pepper's Lonely Hearts Club Band</value>
			<value>With a Little Help from My Friends</value>
			<value>Lucy in the Sky with Diamonds</value>
			<value>Getting Better</value>
			<value>Fixing a Hole</value>
			<!-- ...other tracks omitted for brevity... -->
		</list>
	</property>
</bean>
```

另外一种可选方案就是使用p-命名空间的属性来完成该功能：

```xml
<bean id="compactDisc" class="soundsystem.BlankDisc"
	p:title="Sgt. Pepper's Lonely Hearts Club Band"
	p:artist="The Beatles">
	<property name="tracks">
		<list>
			<value>Sgt. Pepper's Lonely Hearts Club Band</value>
  			<value>With a Little Help from My Friends</value>
			<value>Lucy in the Sky with Diamonds</value>
			<value>Getting Better</value>
			<value>Fixing a Hole</value>
			<!-- ...other tracks omitted for brevity... -->
		</list>
	</property>
</bean>
```

与c-命名空间一样，装配bean引用与装配字面量的唯一区别在于是否带有 `-ref` 后缀。**如果没有 `-ref` 后缀的话，所装配的就是字面量**。

不能使用p-命名空间来装配集合，没有便利的方式使用p-命名空间来指定一个值（或bean引用）的列表。但是，我们可以使用Spring util-命名空间中的一些功能来简化BlankDiscbean。

util-命名空间所提供的功能之一就是 `<util:list>` 元素，它会创建一个列表的bean。借助 `<util:list>`，我们可以将磁道列表转移到BlankDisc bean之外，并将其声明到单独的bean之中，如下所示：

```xml
<util:list id="trackList">
	<value>Sgt. Pepper's Lonely Hearts Club Band</value>
	<value>With a Little Help from My Friends</value>
	<value>Lucy in the Sky with Diamonds</value>
	<value>Getting Better</value>
	<value>Fixing a Hole</value>
	<!-- ...other tracks omitted for brevity... -->
</util:list>
```

现在，我们能够像使用其他的bean那样，将磁道列表bean注入到BlankDisc bean的tracks属性中：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:p="http://www.springframework.org/schema/p"
	xmlns:util="http://www.springframework.org/schema/util"
	xsi:schemaLocation="http://www.springframework.org/schema/beans
		http://www.springframework.org/schema/beans/spring-beans.xsd
		http://www.springframework.org/schema/util
		http://www.springframework.org/schema/util/spring-util.xsd">
	
  <bean id="compactDisc"
		class="soundsystem.BlankDisc"
		p:title="Sgt. Pepper's Lonely Hearts Club Band"
		p:artist="The Beatles"
		p:tracks-ref="trackList" />
</beans>

```

Spri ng uti l -命名空间中的元素如下表所示：

| 元 素                | 描 述                                |
| ------------------ | ---------------------------------- |
| `<util:constant>`  | 引用某个类型的public static的字段，并将其暴露为bean |
| util:list          | 创建一个java.util.List类型的bean，其中包含值或引用 |
| util:map           | 创建一个java.util.Map类型的bean，其中包含值或引用  |
| util:properties    | 创建一个java.util.Properties类型的bean    |
| util:property-path | 引用一个bean的属性（或内嵌属性），并将其暴露为bean      |
| util:set           | 创建一个java.util.Set类型的bean，其中包含值或引用  |

### 导入和混合配置

在典型的Spring应用中**可能会同时使用自动化和显式配置**。即便你更喜欢通过Java配置实现显式配置，但有的时候XML却是最佳的方案。

这些配置方案都不是互斥的。尽可以将Java配置的组件扫描和自动装配**和/或**XML配置混合在一起。

自动装配的时候会考虑到Spring容器中所有的bean，不管它是在Java配置或XML中声明的还是通过组件扫描获取到的。

####  在Java配置中引用XML配置

假设CDPlayerConfig已经变得有些**笨重而需要将其进行拆分**。一种方案就是将BlankDisc从CDPlayerConfig拆分出来，定义到它自己的CDConfig类中，如下所示：

```java
package soundsystem;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class CDConfig {
	@Bean
	public CompactDisc compactDisc() {
		return new SgtPeppers();
	}
}
```

compactDisc()方法已经从CDPlayerConfig中移除掉了，我们需要有一种方式将这两个类组合在一起。一种方法就是在CDPlayerConfig中使用**@Import注解**导
入CDConfig：

```java
package soundsystem;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Import;

@Configuration
@Import(CDConfig.class)
public class CDPlayerConfig {

	@Bean
	public CDPlayer cdPlayer(CompactDisc compactDisc) {
		return new CDPlayer(compactDisc);
	}
}
```

或者采用一个更好的办法，也就是不在CDPlayerConfig中使用@Import，而是创建一个更高级别的SoundSystemConfig，**在这个类中使用@Import将两个配置类组合在一起**：

 ```java
package soundsystem;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Import;

@Configuration
@Import({CDPlayerConfig.class, CDConfig.class})
public class SoundSystemConfig {
}
 ```

现在，假设（基于某些原因）希望通过XML来配置BlankDisc，如下所示：

```xml
<bean id="compactDisc"
	class="soundsystem.BlankDisc"
	c:_0="Sgt. Pepper's Lonely Hearts Club Band"
	c:_1="The Beatles">
	<constructor-arg>
		<list>
			<value>Sgt. Pepper's Lonely Hearts Club Band</value>
			<value>With a Little Help from My Friends</value>
    		<value>Lucy in the Sky with Diamonds</value>
			<value>Getting Better</value>
			<value>Fixing a Hole</value>
			<!-- ...other tracks omitted for brevity... -->
		</list>
	</constructor-arg>
</bean>
```

假设BlankDisc定义在名为cd-config.xml的文件中，该文件位于根类路径下，那么可以修改SoundSystemConfig，让它使用**@ImportResource注解**，如下所示：

```java
package soundsystem;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Import;
import org.springframework.context.annotation.ImportResource;

@Configuration
@Import(CDPlayerConfig.class)
@ImportResource("classpath:cd-config.xml")
public class SoundSystemConfig {
}
```

这样的话，配置在Java配置中的CDPlayer bean以及配置在XML中BlankDisc bean都会被加载到Spring容器之中。

#### 在XML配置中引用Java配置

**在XML中可以使用import元素来拆分XML配置**。假设希望将BlankDisc bean拆分到它自己的配置文件中，该文件名为cd-config.xml，这与之前使用@ImportResource是一样的。我们可以在下面的XML配置文件中使用 `<import>` 元素来引用该cd-config.xml文件：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:c="http://www.springframework.org/schema/c"
	xsi:schemaLocation="http://www.springframework.org/schema/beans
		http://www.springframework.org/schema/beans/spring-beans.xsd">
  
 	<import resource="cd-config.xml" />
	<bean id="cdPlayer"	class="soundsystem.CDPlayer" :cd-ref="compactDisc" />
</beans>
```

现在，假设仅将BlankDisc配置在XML之中，而CDPlayer配置在JavaConfig中。**`<bean>` 元素能够用来将Java配置导入到XML配置中**。为了将Java配置类导入到XML配置中，可以在下面名为cdplayer-config.xml这样声明bean：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:c="http://www.springframework.org/schema/c"
	xsi:schemaLocation="http://www.springframework.org/schema/beans
		http://www.springframework.org/schema/beans/spring-beans.xsd">

	<bean class="soundsystem.CDConfig" />
	<bean id="cdPlayer" class="soundsystem.CDPlayer" c:cd-ref="compactDisc" />

</beans>
```

这样，一个使用XML描述的bean和另一个使用Java配置类就被组合在一起了。类似地，可以创建一个更高层次的配置文件，这个文件不声明任何的bean，只是负责将两个或更多的配置组合起来。例如，可以将CDConfig bean从之前的XML文件中移除掉，而是使用第三个配置文件将这两个组合在一起：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:c="http://www.springframework.org/schema/c"
	xsi:schemaLocation="http://www.springframework.org/schema/beans
		http://www.springframework.org/schema/beans/spring-beans.xsd">

	<bean class="soundsystem.CDConfig" />
	<import resource="cdplayer-config.xml" />

</beans>
```

不管使用Java配置还是使用XML进行装配，通常都会创建一个根配置（root configuration），这个配置会将两个或更多的装配类**和/或**XML文件组合起来。也可以在根配置中启用组件扫描（通过 `<context:component-scan>` 或@ComponentScan）。