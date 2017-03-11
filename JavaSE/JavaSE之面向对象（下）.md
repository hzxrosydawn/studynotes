## Java面向对象（下）

### 单例类

**如果一个类始终只能创建一个实例，则这个类被称为单例类**。通过使用private修饰该类的构造器从而避免外部类创建该类的实例，而是通过该类的一个public修饰的类方法调用其私有构造器来创建并返回该类的唯一实例。此外还应该缓存该类的变量，否则无法知道是否已经创建了对象，也就无法保证只创建一个对象。一个简单的单例类如下。

```java
class Singleton {
	// 使用一个类变量来缓存曾经创建的实例
	private static Singleton instance;
	// 将构造器使用private修饰，隐藏该构造器
	private Singleton(){}
	// 提供一个静态方法，用于返回Singleton实例
	// 该方法可以加入自定义的控制，保证只产生一个Singleton对象
	public static Singleton getInstance() {
		// 如果instance为null，表明还不曾创建Singleton对象
		// 如果instance不为null，则表明已经创建了Singleton对象，
		// 将不会重新创建新的实例
		if (instance == null) {
			// 创建一个Singleton对象，并将其缓存起来
			instance = new Singleton();
		}
		return instance;
	}
}
public class SingletonTest {
	public static void main(String[] args) {
		// 创建Singleton对象不能通过构造器，
		// 只能通过getInstance方法来得到实例
		Singleton s1 = Singleton.getInstance();
		Singleton s2 = Singleton.getInstance();
		System.out.println(s1 == s2); // 将输出true
	}
}
```

### final修饰符

#### final成员变量

**final修饰的成员变量一旦有了初始值就不能再被赋值**。**不能访问一个还未显式赋值的final变量**。Java规定final修饰的成员变量必须由程序员显式指定初始值。为final修饰的变量显式赋值的位置如下：

- **final修饰的类变量只能在静态初始化块中或声明该变量时指定初始值**；
- **final喜事的实例变量只能在普通初始化块、声明该实例变量时或在构造器中指定初始值**。

#### final局部变量

系统不会为局部变量进行初始化，局部变量只能由程序员显式初始化。因此，**final修饰的局部变量要么在声明时指定默认值，要么后续手动显式为其赋值。一旦为final修饰的局部变量赋值，就不能再次为其赋值了**。

> 注意：
>
> 1. 因为形参的值由传入的实参决定，所以不能手动对final修饰的形参赋值；
> 2. final修饰的引用变量指向的地址一旦指定将不可更改，但是该地址所指向的对象是可以发生改变的；
> 3. 如果一个final修饰的变量的值在编译时就确定了，那么该变量本质上就是一个“宏变量”了。编译器会把源程序中所有使用该变量的地方直接替换成该变量的值。

#### final方法

final修饰的方法不可被重写。如果父类不想让子类重写它的某一个方法，可以使用final修饰该方法。如Object类的getClass()方法就是使用final修饰的。

**没有必要使用final修饰private修饰的方法，因为private方法仅能在当前类中访问**。

#### final类

**final修饰的类不能被继承**。如果不希望有子类访问某一个类的内部数据，并重写其方法（可能会不安全），那么可以使用final修饰该类。如java.lang.Math类就是一个final类。

#### 不可变类

**不可变（immutable）类的实例创建后就不可改变**。Java提供的8个包装类和java.lang.String类都是不可变类。

创建自定义不可变类规则如下：

- 使用private和final修饰该类的成员变量；
- 根据带参数的构造器来初始化该类的成员变量；
- 仅为该类提供getter方法，不要为该类提供setter方法；
- 如果有必要，重写Object类的hashCode()和equals()方法，从而根据关键成员变量来作为两个对象相等的标准。

java.lang.String类就是根据String对象里的字符序列来作为相等的判断标准的，而且其hashCode()方法也是根据字符序列计算得到的。一个简单的不可变类如下。

```java
public class Address {
	private final String detail;
	private final String postCode;
	// 在构造器里初始化两个实例变量
	public Address() {
		this.detail = "";
		this.postCode = "";
	}
	public Address(String detail , String postCode) {
		this.detail = detail;
		this.postCode = postCode;
	}
	// 仅为两个实例变量提供getter方法
	public String getDetail() {
		return this.detail;
	}
	public String getPostCode() {
		return this.postCode;
	}
	//重写equals()方法，判断两个对象是否相等
	public boolean equals(Object obj) {
		if (this == obj) {
			return true;
		}
		if(obj != null && obj.getClass() == Address.class) {
			Address ad = (Address)obj;
			// 当detail和postCode相等时，可认为两个Address对象相等
			if (this.getDetail().equals(ad.getDetail())
				&& this.getPostCode().equals(ad.getPostCode()))	{
				return true;
			}
		}
		return false;
	}
	public int hashCode() {
		return detail.hashCode() + postCode.hashCode() * 31;
	}
}
```

#### 缓存实例的不可变类

如果需要经常使用相同的不可变实例，则应该考虑缓存这种不可变类的实例。一个缓存实例的不可变类如下。

```java
class CacheImmutale {
	private static int MAX_SIZE = 10;
	// 使用数组来缓存已有的实例
	private static CacheImmutale[] cache = new CacheImmutale[MAX_SIZE];
	// 记录缓存实例在缓存中的位置,cache[pos-1]是最新缓存的实例
	private static int pos = 0;
	private final String name;

	private CacheImmutale(String name) {
		this.name = name;
	}

	public String getName() {
		return name;
	}

	public static CacheImmutale valueOf(String name) {
		// 遍历已缓存的对象
		for (int i = 0; i < MAX_SIZE; i++) {
			// 如果已有相同实例，直接返回该缓存的实例
			if (cache[i] != null && cache[i].getName().equals(name)) {
				return cache[i];
			}
		}
		// 如果缓存池已满
		if (pos == MAX_SIZE) {
			// 把缓存的第一个对象覆盖，即把刚刚生成的对象放在缓存池的最开始位置
			cache[0] = new CacheImmutale(name);
			// 把pos设为1
			pos = 1;
		} else {
			// 把新创建的对象缓存起来，pos加1
			cache[pos++] = new CacheImmutale(name);
		}
		return cache[pos - 1];

	}

	public boolean equals(Object obj) {
		if (this == obj) {
			return true;
		}
		if (obj != null && obj.getClass() == CacheImmutale.class) {
			CacheImmutale ci = (CacheImmutale) obj;
			return name.equals(ci.getName());
		}
		return false;
	}

	public int hashCode() {
		return name.hashCode();
	}
}

public class CacheImmutaleTest {
	public static void main(String[] args) {
		CacheImmutale c1 = CacheImmutale.valueOf("hello");
		CacheImmutale c2 = CacheImmutale.valueOf("hello");
		// 下面代码将输出true
		System.out.println(c1 == c2);
	}
}
```

如Java提供的java.lang.Integer类缓存了-128到127之间的实例。如果为Integer.valueOf(int)静态方法传入-128~127之间的实参，则返回的是已存在的不可变实例，而使用其构造器Integer()返回的是一个新的不可变实例。如下面代码所示。

```java
public class IntegerCacheTest {
	public static void main(String[] args) {
		// 生成新的Integer对象
		Integer in1 = new Integer(6);
		// 生成新的Integer对象，并缓存该对象
		Integer in2 = Integer.valueOf(6);
		// 直接从缓存中取出Ineger对象
		Integer in3 = Integer.valueOf(6);
		System.out.println(in1 == in2); // 输出false
		System.out.println(in2 == in3); // 输出true
		// 由于Integer只缓存-128~127之间的值，
		// 因此200对应的Integer对象没有被缓存。
		Integer in4 = Integer.valueOf(200);
		Integer in5 = Integer.valueOf(200);
		System.out.println(in4 == in5); //输出false
	}
}
```

### 抽象类和抽象方法

如果一个类只是描述某一类对象具有某一功能，但是却没有具体定义该功能如何实现，那么该类就是一个抽象类。比如描述人类的Human类，该Human类可能描述了人类具有工作的能力，却没有定义具体的某类人如何工作（可能是厨师做饭、作家写作、程序员编程等）。抽象类中这种描述某种功能的方法称为抽象方法。

抽象类和抽象方法特点如下：

- 抽象类的定义比普通类的定义增加了abstract 关键字修饰。抽象方法也使用abstract关键字来定义。**抽象方法的声明是一条带英文分号的语句，没有方法体**；
- **抽象类不一定有抽象方法，有抽象方法的类一定是抽象类**；
- **抽象类不能被实例化，即使抽象类没有抽象方法也是不可实例化的**，因为它不是具体的，所以**无法通过new关键字来创建抽象类的实例**。抽象类只能通过多态的方式，让其具体的子类实例化；
- 抽象类的成员包括**成员变量**（既可以是变量，也可以是常量）、**构造器** （抽象类构造器主要用来被子类构造器调用来进行父类中数据的初始化）、**抽象方法**（也可以没有抽象方法）、**非抽象方法**（用于被子类继承达到代码复用的目的）、**初始化块**、**内部类**（接口、枚举）**5种成员**；
- **含有抽象方法的类**（直接定义一个含有抽象方法的抽象类，或继承了一个抽象类但没有实现抽象父类的所有抽象方法，或实现一个接口但没有实现接口的所有抽象方法）**只能被定义成抽象类**。

如果说类是某些具有相同特征对象的抽象，那么抽象类则是对某些具有相同特征的类（不同的类对这些相同特征具有不同的实现）的抽象。**抽象类体现了一种模板模式的设计思想**，这种模板的存在避免了子类实现的随意性，子类在保留抽象父类数据的基础上进行扩展和改造。

**注意**：**抽象方法和空方法**是不同的概念：抽象方法没有方法体，如“public abstract void work();”是一个抽象方法定义，它是一条带分号的语句；而空方法有方法体，只是方法体为空，什么都不做。如“public void work() {}”是一个空方法。

下面定义一个抽象类：

```java
public abstract class Shape {
	// 抽象类的初始化块
  	{
		System.out.println("执行Shape的初始化块...");
	}
	private String color;

	// 定义一个计算周长的抽象方法
	public abstract double calPerimeter();

	// 定义一个返回形状的抽象方法
	public abstract String getType();

	// 定义Shape的构造器，该构造器并不是用于创建Shape对象，
	// 而是用于被子类调用
	public Shape() {}

	public Shape(String color) {
		System.out.println("执行Shape的构造器...");
		this.color = color;
	}

	// color的setter和getter方法
	public void setColor(String color) {
		this.color = color;
	}

	public String getColor() {
		return this.color;
	}
}
```

继承抽象类的实例：

```java
public class Triangle extends Shape {
	// 定义三角形的三边
	private double a;
	private double b;
	private double c;

	public Triangle(String color, double a, double b, double c) {
		super(color);
		this.setSides(a, b, c);
	}

	public void setSides(double a, double b, double c) {
		if (a >= b + c || b >= a + c || c >= a + b) {
			System.out.println("三角形两边之和必须大于第三边");
			return;
		}
		this.a = a;
		this.b = b;
		this.c = c;
	}

	// 重写Shape类的的计算周长的抽象方法
	public double calPerimeter() {
		return a + b + c;
	}

	// 重写Shape类的的返回形状的抽象方法
	public String getType() {
		return "三角形";
	}
}
```

关于abstract关键注意以下几点：

- **final修饰的类不能被继承，final修饰的方法不能被重写，故抽象类和抽象方法不能用final修饰**；
- **abstract只能用于抽象类和抽象方法，不能用于修饰成员变量、局部变量和构造器**；
- **static不能用于修饰抽象方法**，即没有所谓的类抽象方法。如果static能用于修饰抽象方法，那么通过类调用该方法时会出现错误（无法调用一个没有方法体的方法）。虽然abstract和static不能同时修饰抽象方法，但**abstract和static可以用来共同修饰内部类**；
- **abstract修饰的抽象方法被子类重写才有意义，故abstract不能使用和private一起用来修饰方法，应该使用protected修饰**。

### 接口

#### 接口概述

现实中的物理接口，比如常用的USB接口，它一种输入输出的技术规范（interface级别），该规范有不同的版本（类级别），如USB1.0、USB2.0和USB3.0等，只要有USB接口的设备（对象级别），如U盘、移动硬盘、鼠键、游戏手柄等遵守USB传输规范（可以提供不同版本的USB接口），就可以使用USB接口来传输数据，而不管设备内部实现传输的细节。

可以把抽象类进一步抽象为接口（Interface）。**接口使用interface关键字定义**，用来为具有相同行为的多个类制订他们与外界交流的行为**规范**。在设计软件系统时应该应用这种面向接口的思想，尽量降低各模块之间的耦合，为系统提供更好的可扩展性和可维护性。

#### 接口的定义

接口的语法：

```java
[修饰符] interface 接口名 extends 父接口1, 父接口2... {
 	零到多个常量定义
  	零到多个内部类、内部接口、内部枚举类定义
  	零到多个类方法定义
   	零到多个默认方法
    零到多个抽象方法定义
}
```

关于接口的语法：

- **接口的访问权限修饰符为public或default**；
- 接口名的命名规法与类相同。编程规法建议：**如果接口形容的是某种能力，则应该取对应形容词作为接口名**（通常是-able的形式）；**对于Service和DAO类**，基于SOA（Service-Oriented Architecture）的理念，**暴露出来的服务一定是接口，内部的实现类用Impl的后缀与接口区别**（如CacheServiceImpl实现了CacheService接口）；
- **接口里的常量默认使用public static final修饰，这些修饰符可以省略**。编程规范建议接口里的常量名使用全大写的单词命名，单词之间使用英文下划线分隔。尽量不要再接口里定义变量，如果一定要定义变量，则这些变量应该是与接口方法相关的，且是整个应用的基础常量。接口里咩有构造器和初始化块，所以接口里的常量必须在声明时赋值；
- **接口里的内部类、内部接口和内部枚举类默认使用public static修饰，这些修饰符可以省略**；
- **接口里的类方法默认使用public static修饰，public可以省略，但不能省略static**，否则就变成了普通抽象方法。**接口里的类方法有执行体、是接口（或类）相关的，可通过接口名（或其实现类的类名）直接调用**；
- **Java 8允许接口里可以定义默认方法**。默认方法有以下规则：
  - 默认方法**必须使用default关键字修饰，且default不能省略**；
  - 默认方法名**默认使用public修饰，且public可以省略**；
  - 默认方法**不使用static修饰**。**默认方法有执行体，是实例相关的，只能通过接口实现类的实例来调用默认方法**；
- **接口里的普通方法默认使用public abstract修饰，这些修饰符可以省略**。

**编程规范建议接口里的常量声明不要使用任何修饰符（保持代码的简洁性），并加上有效的javadoc注释**。接口可以被当成一个特殊的类，因此一个Java源文件中只能有一个public的外部接口，且源文件的文件名必须与该接口名相同。

接口像类一样可以继承其他接口，而且**接口支持多继承**，即一个接口可以有多个直接父接口。多继承时，**多个父接口排在extends关键字之后，多个父接口之间以英文逗号分隔**。

#### 接口的使用

**接口由于其内部抽象方法的存在不能直接用于创建实例，必须被实现类实现后才可以通过其实现类创建实例**。接口主要用途如下：

- **定义接口类型的变量。也可以将一个对象强制转换为接口类型**；
- **调用接口中的定义的常量**。接口中的成员变量在实现该接口的类中可以直接使用，在没有实现接口的类中可以通过“接口名.成员变量名”来访问该接口中的常量；
- **被其他类实现**。

**使用implements关键字实现一个或多个接口，多个接口之间使用英文逗号分隔**。语法如下：

```java
[修饰符] class 类名 extends 父类名 implements 接口1, 接口2... {
  类体部分
}
```

**一个类实现了一个或多个接口之后，必须全部实现这些接口里的抽象方法，否则该类是一个含有抽象方法的抽象类**。**接口不能显式继承任何类，但所有接口类型的引用变量都可直接赋值给Object类型的引用变量**。Java接口的多实现弥补了单继承在扩展性上的不足。

#### 接口和抽象类的对比

接口体现的是一种规范，规定了其实现类必须对外提供哪些行为方式。接口是多个模块之间的耦合标准和通信标准。一系统中的接口不应该经常改变，接口的改变对整个系统甚至其他系统的影响是辐射式的，将会导致系统中大部分类都需要重写。

抽象类作为多个子类的共同父类，所体现的是一种模板设计模式。这个模板定义了实现某一功能的样式，为子类完成具体实现提供一些基础和限制。

接口和抽象类还有以下异同：

- 接口和抽象类都可以包含抽象方法和类方法，但接口里可以有默认方法（类似于实例方法）、不能有实例方法，而抽象类可以包含实例方法；
- 接口中的变量只能是静态不可变的（即静态常量），不能定义普通成员变量。抽象类既可以定义静态变量，还可以定义普通变量；
- 接口中不能包含构造器，抽象类虽然包含构造器，但是只能交由其子类调用来执行初始化；
- 接口支持多继承，多实现。抽象类可以多实现，但只能单继承。

### 内部类

#### 内部类概述

定义在其他类内部的类称为内部类（也叫嵌套类），内部类所在的类也称为外部类（也叫宿主类）。**内部类体现了组合的思想**，其主要作用如下：

- **提供了更好的封装，可以把内部类隐藏在外部类中，不允许同一个包中的其他类访问该内部类**；
- **内部类成员可以直接访问外部类的私有数据**，因为内部类也是外部类的成员。但**外部类不能直接访问内部类的成员**（如内部类的成员变量）；
- 匿名内部类适用于创建那些仅需要使用一次的类。

内部类定义在外部类的内部，是外部类的类成员，而**局部内部类**（定义在内部类中的类）和**匿名内部类**不是类成员。

内部类的定义与外部类大致相同。主要区别是**内部类定义在外部类内部，而且可以使用private、protected和static修饰，而外部类不可以使用这三个修饰符**。

#### 非静态内部类

**成员内部类分为静态内部类（使用static修饰）和非静态内部类（不使用static修饰）**。**非静态内部类是外部类实例成员**，所以。

虽然外部类不能直接访问非静态内部类的成员，但可以通过**在外部类实例中创建内部类的实例（内部类实例必须依存于外部类实例），然后通过该内部类实例来访问内部类实例成员**。

**当在非静态内部类的方法中访问某个变量时，系统依次会在该方法中、该方法所在的内部类中、外部类中查找该变量，直到找到该变量为止。如果找不到就会编译出错**。

如果外部类成员变量、内部类成员变量与内部类中方法的局部变量同名，可以通过使用this、**外部类类名.this**作为限定区分。

由于一个类中的静态代码块不能访问实例成员，所以**非静态内部类不能有静态成员，外部类的静态方法、静态代码块也不能访问非静态内部类及其成员**。

如下面的实例所示。

```java

```

#### 静态内部类

**静态内部类可以包含静态成员，也可以包含非静态成员。静态内部类只能访问它外部类的静态成员，不能访问它外部类的实例成员。静态内部类的实例方法也不能访问外部类的实例成员，只能访问外部类的静态成员**。

**外部类依然不能直接访问静态内部类的成员**，但可以**使用静态内部类的类名作为调用者来访问静态内部类的类成员**，也可以使用**静态内部类对象作为调用者来访问静态内部类的实例成员**。

**接口里也可以定义内部类，接口里定义的内部类默认使用public static修饰**。

#### 成员内部类的使用

在外部类内部使用内部类与平常使用普通类没有太大区别。需要注意的是在外部类外部使用非静态内部类额情况。**如果想在外部类外部访问内部类，则内部类不能使用private修饰**(内部类的访问权限修饰符决定了其使用的范围)。**在外部类外部定义内部类变量的语法**如下：

```java
// 内部类就是外部类的一个成员而已，只是这个成员可以用来定义变量
OuterClass.InnerClass varName;
```

##### 在外部类外部使用非静态内部类

由于**非静态内部类对象依存于外部类的对象**，因此**创建非静态内部类的对象时，必须先创建外部类对象。在外部类外部创建非静态内部类对象的语法**如下：

```java
OuterInstance.new InnerConstructor();
// 如果外部类对象还未创建，则先创建外部类对象
new OuterConstructor().new InnerConstructor();
```

**在创建非静态内部类的子类时，必须保证让子类构造器可以调用非静态内部类的构造器，调用非静态内部类的构造器时，必须存在一个外部类对象**。如下面代码所示。

```java
class Out {
  class In {
    public In(String msg) {
      System.out.println(msg);
    }
  }
}
public class SubClass entends Out.In {
  // 显式调用Subclass的构造器
  public Subclass(Out out) {
    // 通过外部类对象在非静态内部类子类的构造器中调用非静态内部类的构造器
    out.super("hello");
  }
}
```

> 注意：**非静态内部类的子类不一定是内部类，它可以是一个外部类，但非静态内部类的子类实例需要保留一个指向其父类所在外部类的对象的引用**。

##### 在外部类外部使用静态内部类

静态内部类是外部类类相关的，所以**在外部类以外的地方创建其静态内部类的实例语法**如下。

```java
new OuterClass.InnerConstructor();
```

调用非静态内部类不需要使用外部类对象，所以创建静态内部类的子类的语法如下。

```java
public class StaticSubClass extends StaticOut.StaticIn {}
```

> 注意：**使用静态内部类的子类比较简单，只需要把外部类当成是其包空间即可。因此，当需要使用内部类时，优先考虑使用静态内部类**。

#### 局部内部类

局部内部类就是定义在方法里的类，**局部内部类仅在该方法里有效，定义局部内部类的变量和创建局部内部类的对象只能在局部内部类所在的方法中进行。因此局部内部类不能使用任何访问控制修饰符和static关键字修饰。局部内部类的作用域很小，所以开发中很少使用局部内部类**。

#### 匿名内部类

**匿名内部类适合创建只需要一次使用的类。创建匿名内部类时会立即创建一个该类的实例，这个类定义立即消失，匿名内部类不能重复使用**。定义匿名内部类语法如下：

```java
new 实现接口() | 父类构造器(实参列表) {
  // 匿名内部类的类体部分
}
```

**匿名内部类必须继承一个父类，或实现一个接口，但是最多只能继承一个父类，或实现一个接口**。匿名内部类还有以下两条规则：

- **匿名内部类不能是抽象类**。因为系统在创建匿名内部类时，会立即创建匿名内部类的对象。因此不允许将匿名内部类定义成抽象类；
- **匿名内部类不能定义构造器。匿名内部类没有类名，所以无法定义构造器，但匿名内部类可以定义初始化块，可以通过实例初始化块来完成构造器需要完成的事情**；
- **匿名内部类必须实现它抽象父类或实现接口里的所有抽象方法，如果有需要，也可以重写父类里的实例方法**；
- **匿名内部类访问的局部变量必须是不可变的**。内部类Java 8以前要求必须通过final关键字显式修饰这种局部变量，从Java 8开始可以省略final修饰而默认这种局部变量是不可变的（Java 8称改功能为“effectively final”）。

假如匿名内部类访问的局部变量是可变的，由于匿名内部类仅执行一次就消失了，如果匿名内部类中修改了该变量，这种修改对外部方法来说是不可见的，外部方法中不知道是谁改动了这个局部变量，这是绝对不允许的。

匿名内部类的实现形式：

- **通过实现接口创建匿名内部类对象时，匿名内部类只有一个隐式的无参数构造器，所以“new 接口名()”中的括号里不能传入参数值**；
- **通过继承父类创建匿名内部类时，匿名内部类将拥有和父类相似（形参列表相同）的构造器**。

实现接口创建匿名内部类实例。

```java
interface Product {
    public double getPrice();
    public String getName();
}
public class AnonymousTest {
    public void test(Product p) {
        System.out.println("购买了一个"+p.getName()
                +",花掉了"+p.getPrice());
    }
    public static void main(String[] args) {
        AnonymousTest ta = new AnonymousTest();
        // 调用test()方法时，需要传入一个Product参数
        // 此处传入其匿名实现类的实例
      	// 该匿名内部类实现了Product接口，不能向接口后面的括号传入参数
        ta.test(new Product() {
            public double getPrice() {
                return 567.8;
            }
            public String getName() {
                return "AGP显卡";
            }
        });
    }
}
```

继承父类创建匿名内部类实例。

```java
abstract class Device {
    private String name;
    public abstract double getPrice();
    public Device(){};
    public Device(String name) {
        this.name =name;
    }
    public String getName() {
        return name;
    }
    public void setName(String name) {
        this.name = name;
    }
}
public class AnonymousInner {
    public void test(Device d) {
        System.out.println("购买了一个"+d.getName()+"，花掉了"+d.getPrice());
    }
    public static void main(String[] args) {
        AnonymousInner ai = new AnonymousInner();
        // 调用有参数的构造器创建Device匿名内部类的对象
        ai.test(new Device("电子示波器") {
            public double getPrice() {
                return 67.8;
            }
        });
    // 调用无参数的构造器创建Device匿名内部类的对象
    Device d = new Device() {
        // 初始化块
        {
            System.out.println("匿名内部类的初始化块...");
        }
        // 实现抽象方法
        public double getPrice() {
            return 56.2;
        }
        public String getName() {
            return "键盘";
        }
    };
    ai.test(d);
    }
}
```

### Lambda 表达式

#### Lambda 表达式概述

Java 8新增了Lambda表达式。**Lambda表达式的主要作用就是用来代替匿名内部类的烦琐语法**。它由三部分组成：

- **形参列表**。**形参列表允许省略形参类型。如果形参列表只有一个参数，甚至连形参列表的圆括号也可以省略**。
- **箭头**(->)。必须通过英文中画线号和大于符号组成。
- **代码块**。**如果代码块只包含一条语句，Lambda表达式允许省略代码块的花括号。如果Lambda代码块只有一条return语句，甚至可以省略这条语句return关键字，Lambda表达式会自动返回这条语句的值**。

实例如下：

```java
interface Eatable {
    void test();
}
interface Flyable {
    void fly(String weather);
}
interface Addable {
    int add(int a, int b);
}
public class LambdaQs {
    // 调用该方法需要Eatable对象
    public void eat(Eatable e) {
        System.out.println(e);
        e.test();
    }
    // 调用该方法需要Flyable对象
    public void drive(Flyable f) {
        System.out.println("老司机正在开："+f);
        f.fly("亮瞎眼");
    }
    // 调用该方法需要Addable对象
    public void test(Addable add) {
        System.out.println("34与59的和为："+add.add(34, 59));
    }
    public static void main(String[] args) {
        LambdaQs lq = new LambdaQs();
        // Lamba表达式的代码块只有一条语句，可以省略花括号
        lq.eat(()->System.out.println("苹果很赞哦！"));
        // Lamba表达式的形参列表可以省略形参类型，如果只有一个形参，则可以省略圆括号
        lq.drive(weather -> {
            System.out.println("今天天气是："+weather);
            System.out.println("直升机飞行平稳");
        });
        // Lambda表达式的代码块只有一条语句，可以省略花括号
        // 代码块中只有一条语句，即使该表达式需要返回值，也可以省略return关键字
        lq.test((a, b) -> a + b);
    }
}
```

#### Lambda表达式与函数式接口

Lambda表达式的类型，也被称为“目标类型（target type）”，Lambda表达式的目标类型必须是“函数式接口（function interface）”。**函数式接口中抽象方法只能有一个，可以包含多个默认方法、类方法，但只能声明一个抽象方法**。

> Java 8新增了一个@FunctionalInterface注解，放在接口之前，表明该接口必须得是一个函数式接口，否则编译报错。

Lambda表达式的结果就是实现了函数式接口的匿名内部类对象，所以可以将Lambda表达式的值直接赋值给函数式接口类型的变量。

为了保证Lambda表达式的目标类型是一个明确的函数式接口，可以有如下三种常见的使用方式：

- 将Lambda表达式赋值给函数式接口类型的变量；
- 将Lambda表达式作为函数式接口类型的参数传给某个方法；
- 使用函数式接口对Lambda表达式进行强制类型转换。

Java8在java.util.function包下预定义了大量函数式接口，典型地包含如下4类接口。

- XxxFunction：这类接口中通常包含一个apply()抽象方法，该方法对参数进行处理、转换（apply()方法的处理逻辑由Lambda表达式来实现），然后返回一个新的值。该函数式接口通常用于对指定数据进行转换处理；
- XxxConsumer：这类接口中通常包含一个accept()抽象方法，该方法与XxxFunction接口中的apply()方法基本相似，也负责对参数进行处理，只是该方法不会返回处理结果；
- XxxxPredicate：这类接口中通常包含一个test()抽象方法，该方法通常用来对参数进行某种判断（test()方法的判断逻辑由Lambda表达式来实现），然后返回一个boolean值。该接口通常用于判断参数是否满足特定条件，经常用于进行筛滤数据；
- XxxSupplier：这类接口中通常包含一个getAsXxx()抽象方法，该方法不需要输入参数，该方法会按某种逻辑算法（getAsXxx()方法的逻辑算法由Lambda表达式来实现）返回一个数据。

#### 方法引用和构造器引用

如果Lambda表达式的代码块只有一条代码，还可以在代码块中使用更加简洁的方法引用和构造器引用。方法引用和构造器引用都需要使用两个英文冒号。如下表所示。

| 种类          | 示例         | 说明                                      | 对应的Lambda表达式                  |
| ----------- | ---------- | --------------------------------------- | ----------------------------- |
| 引用类方法       | 类名::类方法    | 函数式接口中被实现方法的全部参数传给该类方法作为参数              | (a,b,...)->类名.类方法(a,b,...)    |
| 引用特定对象的实例方法 | 特定对象::实例方法 | 函数式接口中被实现方法的全部参数传给该方法作为参数               | (a,b,...)->特定对象.实例方法(a,b,...) |
| 引用某类对象的实例方法 | 类名::实例方法   | 函数式接口中被实现方法的第一个参数作为调用者，后面的参数全部传给该方法作为参数 | (a,b,...)->a.实例方法(b,...)      |
| 引用构造器       | 类名::new    | 函数式接口中被实现方法的全部参数传给该类方法作为参数              | (a,b,...)->new 类名(a,b,...)    |

##### 1. 引用类方法

```java
@FunctionalInterface
interface Converter{
    Integer convert(String from);
}
```

该函数式接口包含一个convert()抽象方法，该方法负责将String参数转换成Integer。下面代码使用Lambda表达式来创建Converter对象。

```java
//下面代码使用Lambda表达式创建Converter对象
Converter converter1 = from -> Integer.valueOf(from);
```

上面Lambda表达式的代码块只有一条语句，因此程序省略了该代码块的花括号；而且由于表达式所实现的convert()方法需要返回值，因此Lambda表达式将会把这条代码的值作为返回值调用convert1对象的convert()方法将字符串转换为整数了，例如如下代码。

```java
Integer val = converter1.convert("99");
System.out.println(val); // 输出整数99
```

上面Lambda表达式的代码块只有一行调用类方法的代码，因此可以使用如下方法引用进行替换

```java
// 方法引用代替Lambda表达式：引用类方法。
// 函数式接口中被实现方法的全部参数传给该类方法作为参数。
Converter converter1 = Integer::valueOf;
```

对于上面的类方法引用，也就是调用Integer类的valueOf()类方法来实现Converter函数式接口中唯一的抽象方法，当调用Converter接口中唯一的抽象方法时，调用参数将会传给Integer类的valueOf()类方法。

##### 2. 引用特定对象的实例方法

```java
// 下面代码使用Lambda表达式创建Converter对象
Converter converter2 = from -> "I love you".indexOf(from);

Integer value = converter2.convert("u");
System.out.println(value); // 输出2
```

```java
// 方法引用代替Lambda表达式：引用特定对象的实例方法。
// 函数式接口中被实现方法的全部参数传给该方法作为参数。
Converter converter2 = "I love you"::indexOf;
```

对于上面的实例方法引用，也就是调用"I love you"对象的indexOf()实例方法来实现Converter函数式接口中唯一的抽象方法，当调用Converter接口中唯一的抽象方法时，调用参数将会传给"I love you"对象的indexOf()实例方法。

##### 3. 引用某类对象的实例方法

定义如下函数式接口

```java
@FunctionalInterface
interface MyTest {
    String test(String a , int b , int c);
}
```

使用Lambda表达式来创建一个MyTest对象

```java
MyTest mt = (a, b, c) -> a.substring(b, c);
String str = mt.test("Java I Love you" ,2 ,9);
System.out.println(str); // 输出:va I Lo
```

```java
// 方法引用代替Lambda表达式：引用某类对象的实例方法
// 函数式接口中被实现方法的第一个参数作为调用者
// 后面的参数全部传给该方法作为参数
MyTest mt = String::substring;
```

##### 4. 引用构造器

```java
@FunctionalInterface
interface YourTest {
    JFrame win(String title);
}
```

下面代码使用Lambda表达式创建YourTest对象

```java
YourTest yt = (String a) -> new JFrame(a);
```

```java
JFrame jf = yt.win("我的窗口");
System.out.println(jf);

// 构造器引用代替Lambda表达式
// 函数式接口中被实现方法的全部参数传给该构造器作为参数
// 如果有多个重载构造器，则依据形参列表确定调用哪一个构造器
YourTest yt = JFrame::new;
```

对于上面的构造器引用，也就是调用某个JFrame类的构造器来实现YourTest函数式接口中唯一的抽象方法，当调用YourTest接口中的唯一的抽象方法时，调用参数将会传给JFrame构造器。调用YourTest对象的win()抽象方法时，实际只传入了一个String类型的参数，这个String类型的参数会被传给JFrame构造器，这就确定了调用JFrame类的、带一个String参数的构造器。

#### Lambda表达式与匿名内部类的联系和区别

Lambda表达式是匿名内部类的一种简化，存在如下相同点：

- **Lambda表达式与匿名内部类一样，都可以直接访问“effectively final”的局部变量，以及外部类的成员变量（包括实例变量和类变量）**；
- **Lambda表达式创建的对象与匿名内部类生成的对象一样，都可以直接调用从接口中继承的默认方法**。

```java
@FunctionalInterface
interface Displayable {
    //定义一个抽象方法和默认方法
    void display();
    default int add(int a, int b) {
        return a + b;
    }
}

public class LambdaAndInner {
    private int age = 24;
    private static String name = "简单点，说话的方式简单点" ;
    public void test() {
        String sing = "演员";
        Displayable dis = () -> {
            //访问“effectively final”的局部变量
            System.out.println("sing局部变量为："+ sing);
            //访问外部类的实例变量和类变量
            System.out.println("外部类的age实例变量为："+ age);
            System.out.println("外部类的name类变量为："+ name);
        };
        dis.display();
        //调用dis对象从接口中继承的add()方法
        System.out.println(dis.add(34, 59));
    }
    public static void main(String[] args) {
        LambdaAndInner lambdaAndInner = new LambdaAndInner();
        lambdaAndInner.test();
    }
}
```

上面Lambda表达式创建了一个Display的对象，Lambda表达式的代码块中的三行代码分别示范了访问“effectively final”的局部变量、外部类的实例变量和类变量。从这点来看，Lambda表达式的代码块与匿名内部类的方法体是相同的。与匿名内部类相似的是，由于Lambda表达式访问了sing局部变量，该局部变量相当于与一个隐式的final修饰，因此不允许对sing局部变量重新赋值。

Lambda表达式与匿名内部类主要存在如下区别：

- **匿名内部类可以为任意接口创建实例。不管接口包含多少个抽象方法，只要匿名内部类实现所有的抽象方法即可，但Lambda表达式只能为函数式接口创建实例**；
- **匿名内部类可以为抽象类甚至普通类创建实例；但Lambda表达式只能为函数式接口创建实例**；
- **匿名内部类实现的抽象方法的方法体允许调用接口中定义的默认方法，但Lambda表达式的代码块不允许调用默认方法**。

#### 使用Lambda表达式调用Arrays的类方法

Arrays类的有些方法需要Comparator、XxxOperator、XxxFunction等接口的实例，这些接口都是函数式接口，因此可以使用Lambda表达式来调用Arrays的方法。

```java
import java.util.Arrays;
import javax.management.openmbean.OpenDataException;

public class LambdaArrays {
    public static void main(String[] args) {
        String arr1[] = new String[]{"皇家马德里", "巴塞罗那", "巴黎圣日耳曼","尤文图斯","切尔西"};
        Arrays.parallelSort(arr1, (o1, o2) -> o1.length() - o2.length());
        System.out.println(Arrays.toString(arr1));
        int[] arr2 = new int[]{4, 2, 1, 3, 5};
        // left代表数组中前一个索引处的元素，计算第一个元素时，left为1
        // right代表数组中当前索引处的元素
        Arrays.parallelPrefix(arr2, (left, right) -> left * right);
        System.out.println(Arrays.toString(arr2));
        long[] arr3 = new long[5];
        // operand代表正在计算的元素索引
        Arrays.parallelSetAll(arr3, operand -> operand * 5);
        System.out.println(Arrays.toString(arr3));
    }
}
```

- (o1, o2) -> o1.length() - o2.length()：目标类型是Comparator指定了判断字符串大小的标准：字符串越长，即可认为该字符串越大；
- (left, right) -> left * right：目标类型是IntBinaryOperator，该对象将会根据前后两个元素来计算当前元素的值；
- operand -> operand * 5：目标类型是IntToLongFunction，该对象将会根据元素的索引来计算当前元素的值。

Lambda表达式可以让程序更加简洁。

### 枚举类

#### 枚举类概述

**实例有限而且固定的类，在Java里被称为枚举类。JDK 1.5增加了对枚举类的支持。Java 5使用enum关键字来定义枚举类**。**枚举类是一种特殊的类，它一样可以有自己的成员变量、方法，可以实现一个或多个接口，也可以定义自己的构造器**。

- **枚举类使用enum定义，默认继承了java.lang.Enum类，而不是默认继承Object类，因此枚举类不能显示继承其他父类。其中java.lang.Enum类实现了java.lang.Serializable和java.lang.Comparable两个接口**；
- **使用enum定义、非抽象的枚举类默认会使用final修饰，因此枚举类不能派生子类**；
- **枚举类的构造器只能使用private访问控制符，如果省略了构造器的访问控制符，则默认使用private修饰**；
- **枚举类的所有实例必须在枚举类的第一行显式列出，否则这个枚举类永远都不能产生实例。列出这些实例时，系统会自动添加public static final修饰，无须程序员显式添加**。
- **枚举类可以实现一个或多个接口**；

**枚举类默认提供了一个values()方法，该方法可以很方便地遍历所有的枚举值**。

```java
public enum SeasonEnum {
    //在第一行列出4个枚举实例
    SPRING, SUMMER, FALL, WINTER;
}
```

编译上面Java程序，将生成一个SeasonEnum.class文件，这表明枚举类是一个特殊的Java类。所有的枚举值之间以英文逗号(,)隔开，枚举值列举结束后以英文分号作为结束。这些枚举值代表了该枚举类的所有可能的实例。

```java
public class EnumTest {
    public void judge(SeasonEnum s) {
        //switch语句里的表达式可以是枚举值
        switch(s) {
            case SPRING:
                System.out.println("春之樱");
                break;
            case SUMMER:
                System.out.println("夏之蝉");
                break;
            case FALL:
                System.out.println("秋之枫");
                break;
            case WINTER:
                System.out.println("冬之雪");
                break;
        }
    }
    public static void main(String[] args) {
        //枚举类默认有一个values()方法，返回该枚举类的所有实例
        for(SeasonEnum s : SeasonEnum.values()) {
            System.out.println(s);
        }
        //使用枚举实例时，可通过EnumClass.variable形式来访问
        new EnumTest().judge(SeasonEnum.SPRING);
    }
}
```

**当switch控制表达式使用枚举类型时，后面case表达式中的值直接使用枚举值的名字，无须添加枚举类作为限定**。java.lang.Enum类中提供了如下几个方法：

- int **compareTo(E o)**：该方法**用于与指定枚举对象比较顺序。同一个枚举实例只能与相同类型的枚举实例进行比较**。如果该枚举对象位于指定枚举对象之后，则返回正整数。如果该枚举对象位于指定枚举对象之前，则返回负整数，否则返回零；
- String name()：**返回此枚举实例的名称**，这个名称就是定义枚举类时列出的所有枚举值之一。**与此方法相比，大多数程序员应该优先考虑使用toString()方法，因为toString()方法返回更加用户友好的名称**；
- int **ordinal()**：**返回枚举值在枚举类中的索引值**（就是枚举值在枚举声明中的位置，**第一个枚举值的索引值为零**）；
- String **toString()**：**返回枚举常量的名称，与name方法相似，但toString()方法更常用**；
- public static \<T extends Enum \<T>> T **valueOf**(Class\<T> enumType, String name)：**这是一个静态方法，用于返回指定枚举类中指定名称的枚举值**。名称必须与在该枚举类中声明枚举值时所用的标识符完全匹配，不允许使用额外的空白字符。

**当程序使用System.out.println(s)语句来打印枚举值时，实际上输出的是该枚举值的toString()方法，也就是输出该枚举值的名字**。

#### 枚举类的成员变量、方法和构造器

**枚举类的实例只能是枚举值，而不是随意地通过new来创建枚举类对象**。

```java
public enum Gender {
    MALE, FEMALE;
    //定义一个public修饰的实例变量
    private String name;
    public void setName(String name) {
        switch (this) {
        case MALE:
            if (name().equals("男")) {
                this.name = name;
            } else {
                System.out.println("参数错误");
                return;
            }
            break;
        case FEMALE:
            if (name().equals("女")) {
                this.name = name;
            } else {
                System.out.println("参数错误");
                return;
            }
            break;
        }
    }
    public String getName() {
        return this.name();
    }
}
```

```java
public class GenderTest {
    public static void main(String[] args) {
        //通过Enum的valueOf()方法来获取指定枚举类的枚举值
        //Gender gender = Enum.valueOf(Gender.class, "FEMALE");
        Gender g = Gender.valueOf("FEMALE");
        g.setName("女");
        System.out.println(g +"代表："+ g.getName());
        g.setName("男");
        System.out.println(g +"代表："+ g.getName());
    }
}
```

**枚举类通常应该使用final定义成不可变类，还应将枚举类的成员变量都使用private final修饰。如果将所有的成员变量都使用final修饰符来修饰，必须在构造器里为这些成员变量指定初始值，为枚举类显式定义带参数的构造器**。

**一旦为枚举类显式定义了带参数的构造器，列出枚举值时就必须对应地传入参数**。

```java
public enum Gender {
    // 此处的枚举值必须调用对应的构造器来创建
    MALE("男"), FEMAL("女");
    private final String name;
    private Gender(String name) {
        this.name =name;
    }
    public String getName() {
        return this.name();
    }
}
```

#### 实现接口的枚举类

枚举类也可以像普通类一样实现一个或多个接口，实现接口时也需要实现该接口所包含的方法。

```java
public interface GenderDesc {
    void info();
}
```

**如果由枚举类来实现接口里的方法，则每个枚举值在调用该方法时都有相同的行为方式（因为方法体完全一样）。如果需要每个枚举值在调用该方法时呈现出不同的行为方式，则可以让每个枚举值分别来实现该方法，从而让不同的枚举值调用该方法时具有不同的行为方式**。

```java
public enum Gender implements GenderDesc {
    // 此处的枚举值必须调用对应构造器来创建
  	// 花括号部分实际上是一个类体部分
    MALE("男") {
        public void info() {
            System.out.println("这个枚举值代表男性");
        }
    },
    FEMALE("女") {
        public void info() {
            System.out.println("这个枚举值代表女性");
        }
    };
    // 其他部分与codes\06\6.9\best\Gender.java中的Gender类完全相同
    private final String name;
    // 枚举类的构造器只能使用private修饰
    private Gender(String name) {
        this.name = name;
    }
    public String getName() {
        return this.name;
    }
    // 增加下面的info()方法，实现GenderDesc接口必须实现的方法
    public void info() {
        System.out.println("这是一个用于用于定义性别的枚举类");
    }
}
```

当创建MALE和FEMALE两个枚举值时，后面又紧跟了一对花括号，这对花括号里包含了一个info()方法定义。花括号部分实际上就是一个类体部分，在这种情况下，当创建MALE和FEMALE枚举值时，并不是直接创建Gender枚举类的实例，而是相当于创建Gender的匿名子类的实例。

**并不是所有的枚举类都使用了final修饰。非抽象的枚举类才默认使用final修饰。对于一个抽象的枚举类而言，只要它包含了抽象方法，它就是抽象枚举类，系统会默认使用abstract修饰，而不是使用final修饰**。

**编译上面的程序，生成Gender.class、Gender\$1.class和Gender\$2.class三个文件，证明了：MALE和FEMALE实际上是Gender匿名子类的实例，而不是Gender类的实例**。当调用MALE和FEMALE两个枚举值的方法时，就会看到两个枚举值的方法表现不同的行为方式。

#### 包含抽象方法的枚举类

```java
public enum Operation {
    PLUS {
        public double eval(double x, double y) {
            return x + y;
        }
    },
    MINUS {
        public double eval(double x, double y) {
            return x - y;
        }
    },
    TIMES {
        public double eval(double x, double y) {
            return x * y;
        }
    },
    DIVIDE {
        public double eval(double x, double y) {
            return x / y;
        }
    };
    //为枚举类定义一个抽象方法
    //这个抽象方法由不同的枚举值提供不同的实现
    public abstract double eval(double x, double y);
    public static void main(String[] args) {
        System.out.println(Operation.PLUS.eval(3, 4));
        System.out.println(Operation.MINUS.eval(5, 4));
        System.out.println(Operation.TIMES.eval(8, 8));
        System.out.println(Operation.DIVIDE.eval(1, 5));
    }
}
```

**枚举类里定义抽象方法时也不能使用abstract关键字将枚举类定义成抽象类，因为系统自动会为它添加abstract关键字，但因为枚举类需要显式创建枚举值，而不是作为父类，所以定义每个枚举值时必须为抽象方法提供实现，否则将出现编译错误**。