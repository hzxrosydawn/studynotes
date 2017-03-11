## **Annotation简介**
从JDK1.5开始，Java增加了对元数据（Metadata）的支持，也就是Annotation（注释），这种Annotation与其他的注释有一定的区别，也有一定的联系。Annotation其实就是代码里的特殊标记，这些标记可以在编译、类加载、运行时被读取，并执行相应的处理。

通过使用Annotation注释，程序员可以在不改变原有逻辑的情况下，在源文件中嵌入一些补充的信息。代码分析工具、开发工具和部署工具可以通过这些补充信息进行验证或进行部署。

Annotation提供了一种为程序元素设置元数据的方法，从某些方面来看，Annotation就像修饰符一样，可用于修饰包、类、构造器、方法、成员变量、参数、局部变量的声明，这些信息被存储在Annotation的“name=value”对中。

Annotation不影响程序运行，无论是否使用Annotation代码都可以正常运行。如果希望让程序中的Annotation在运行时起一定的作用，只能通过某种配套的工具对Annotation中的信息进行访问和处理，访问和处理Annotation的工具统称为APT（Annotation Processing Tool）。

Annotation是一个接口（java.lang.annotation.Annotation），程序可以通过反射来获取指定程序元素的Annotation对象，然后通过Annotation对象来取得注释里的元数据。java.lang.annotation.Annotation接口的定义：
```java
public interface Annotation{  
	public Class<? extends Annotation> annotationType();  //返回此annotation的注释类型  
	public boolean equals(Object obj); 
	public int hashCode();  
	   String toString(); 
}
```
## **系统内建的Annotation**
Annotation必须使用工具来处理，工具负责提取Annotation里包含的元数据，工具还会根据这些元数据增加额外的功能。我们先看一下Java提供的5个基本Annotation的用法 --- 使用Annotation时要在其前面增加@符号，并把该Annotation当成一个修饰符使用，用于修饰它支持的程序元素。

- @Override: 覆写的Annotation；
- @Deprecated: 不赞成使用的Annotation；
- @SuppressWarnings: 压制安全警告的Annotation；
- @SafeVarargs: 压制安全警告，Java7新增的；
- @FunctionanlInterface：函数式接口，Java8新增的。

以上的Annotation都是java.lang.annotation.Annotation接口的子类。在Java中都有各自的定义：
| Annotation            | Java中的声明                                 |
| --------------------- | ---------------------------------------- |
| @Override             | @Target(value=Method)<br>@Retention(value=SOURCE)<br>public @interface Override |
| @Deprecated           | @Documented<br>@Retention(value=RUNTIME)<br>public @interface Deprecated |
| @SuppressWarnings     | @Target(value={TYPE,FIELD,METHOD,PARAMETER,CONSTRUCTOR,LOCAL_VARIABLE<br>@Retention(value=SOURCE)<br>public @interface SuppressWarnings |
| @SafeVarargs          | @Documented<br>@Target(value={CONSTRUCTOR,METHOD})<br>@Retention(value=RUNTIME)<br>public @interface SafeVarargs |
| @FunctionanlInterface | @Documented<br>@Target(value=TYPE)<br>@Retention(value=RUNTIME)<br>public @interface FunctionalInterface |

### **@Override 限定重写父类方法**
@Override就是用来指定方法覆载的，它可以**强制一个子类必须覆盖父类的方法**。主要在方法覆写时使用，用于保证方法覆写的正确性。

范例：观察@Override注释的作用
```java
package org.forfan06.annotationdemo;  
class Person{  
	public  String getInfo(){  
	return "这是一个Person类";  
	}  
}  
class Student extends Person{  
	@Override  
	public String getInfo(){  
		return "这是一个Student类";  
	}  
}  
public class OverrideAnnotationDemo01{  
	public static void main(String args[]){  
		Person per = new Student();  
		System.out.print(per.getInfo());  
	}  
}  
```
运行结果：
```java
这是一个Student类.
```
以上程序中的子类Student继承Person类，之后覆写了Person类中的getInfo()方法，程序运行结果和之前的一样，唯一的不同只是在覆写的getInfo()方法前加上了@Override注释。这样做的目的是**防止用于在覆写方法是将方法定义出错**。

范例：错误的覆写 。
```java
package org.forfan06.annotationdemo;  
class Person{  
	public  String getInfo(){  
		return "这是一个Person类";  
	}  
}  
class Student extends Person{  
	@Override  
	public String getinfo(){  
		return "这是一个Student类";  
	}  
}  
public class OverrideAnnotationDemo02{  
	public static void main(String args[]){  
		  Person per = new Student();  
	      System.out.print(per.getInfo());  
	}  
}  
```
编译时出错，因为由于粗心把I写成了i，所以getInfo()和getinfo()是两个方法，所以使用了@Override注释，可以确保方法被正确覆写。会在出错的地方给出指示：
```java
OverrideAnnotationDemo02.java:8: error: method does not override or implement a method from a supertype  
	@Override  
	^  
1 error  
	
编译错误
```
@Override的使用限制：@Override在使用时**只能在方法上应用**；而其他元素，如类、属性等是不能使用此Annotation的。
### **@Deprecated 标示已过时**
@Deprecated注释用于表示某个程序元素（类、方法等）已过时，当其他程序使用已过时的类、方法时，编译器将会给出警告。

@Deprecated注释的主要功能是用来声明一个不建议使用的方法。如果在程序中使用了此方法，则在编译时将会出现警告信息。
范例：使用@Deprecated声明一个不建议使用的方法。
```java
package org.forfan06.annotationdemo;  
class Demo{  
	@Deprecated  
	public String getInfo(){  
		return "被测试类";  
	}  
}  
public class DeprecatedAnnotationDemo01{  
	public static void main(String args[]){  
		Demo d = new Demo();  
		System.out.println(d.getInfo());  
	}  
}  
```
以上的Demo类中的getInfo()方法上使用了@Deprecated注释声明，表示此方法不建议用户继续使用，所以在编译时将会出现一下的警告信息：
```shell
Note: DeprecatedAnnotationDemo01.java uses or overrides a deprecated API.  
Note: Recompile with -Xlint:deprecation for details.  
```
虽然出现了警告信息，但是程序还是可以正常执行。因为@Deprecated注释只是表示该方法不建议使用，但并不是不能使用！！！ 
-->@Deprecated注释除了可以声明方法之外，还可以声明一个类<--
范例：在类声明中使用@Deprecated注释
```java	
package org.forfan06.annotationdemo;  
@Deprecated  
class Demo{  
	public String getInfo(){  
		return "测试测试";  
	}  
}  
public class DeprecatedAnnotationDemo02{  
	public static void main(String args[]){  
		Demo d = new Demo();  
		System.out.println(d.getInfo());  
	}  
}  
```
编译时出现警告：
```shell
Note: DeprecatedAnnotationDemo02.java uses or overrides a deprecated API.  
Note: Recompile with -Xlint:deprecation for details.  
```
Thread类中的@Deprecated声明，在Thread类中有3个方法是使用了@Deprecated注释声明的： suspend()、stop()、resume()。

@Deprecated的作用与文档注释中的@deprecated标记的作用基本相同，但它们的用法不同，前者是JDK1.5才支持的注解，无须放在文档注释语法（/**...**/）中，而是直接用于修饰程序中的程序单元，如方法、类、接口等等。

### **@SuppressWarnings 抑制编译器警告**
@SuppressWarnings指示被该Annotation修饰的程序元素（以及该程序元素中的所有子元素）取消显示指定的编译器警告。

@SuppressWarnings会抑制作用于该程序元素的所有子元素。例如，使用@SuppressWarnings修饰某个类取消显示某个编译器警告，同时又修饰该类中的某个方法取消显示另一个编译器警告，那么该方法将会同时取消显示这两个编译器警告。

@SuppressWarnings注释的主要功能是用来压制警告，例如，之前讲解泛型操作时，如果在一个类声明时没有指明泛型，则肯定在编译时产生未经检查的泛型警告，那么此时就可以使用@SuppressWarnings压制住这种警告：
```java
package org.forfan06.annotationdemo;  
class Demo<T>{  
	private T var;  
	public T getVar(){  
		return var;  
	}  
	public void setVar(T var){  
	this.var = var;  
	}  
}  
public class SuppressWarningsAnnotationDemo01{  
	@SuppressWarnings(value="unchecked")  
	public static void main(String args[]){  
		Demo d = new Demo();  
		d.setVar("forfan06");  
	    System.out.println("Content is:" + d.getVar());  
	}  
} 
```
程序在声明Demo对象时，并没有指定具体的泛型类型。如果没有@SuppressWarnings注释修饰的话，会出现一下警告信息：
```java
Note: /judge/data/20140904/1409817887476_java_34546/SuppressWarningsAnnotationDemo01.java uses unchecked or unsafe operations.  
Note: Recompile with -Xlint:unchecked for details.  
```
 在@SuppressWarnings注释中的unchecked，表示的是不检查。当然，**如果现在需要压制更多地警告信息，可以在后面继续增加字符串，只是在增加时，要按照数组的格式增加**。
 范例：压制多个警告
```java
package org.forfan06.annotationdemo;  
@Deprecated  
class Demo<T>{  
    private T var;  
    public T getVar(){  
        return var;  
    }  
    public void setVar(T var){  
        this.var = var;  
    }  
}  
public class SuppressWarningsAnnotationDemo02{  
    @SuppressWarnings({"unchecked", "deprecation"})  
    public static void main(String args[]){  
        Demo d = new Demo();  
        d.setVar("forfan06");  
        System.out.println("Content is:" + d.getVar());  
    }  
}  
```
上面程序同时存在了泛型和不建议使用方法两种警告信息，但是由于使用了@SuppressWarnings注释，所以此时程序在编译时将不会出现任何的警告信息。 
@SuppressWarnings中的关键字如下表所示：
| 关键字         | 描述                                       |
| ----------- | ---------------------------------------- |
| deprecation | 使用了不赞成使用的类或方法时的警告                        |
| unchecked   | 执行了未检查的转换时警告。例如，泛型操作中没有指定泛型类型            |
| fallthrough | 当使用switch操作时case后未加入break操作，而导致程序继续执行其它case语句时出现的警告 |
| path        | 当设置了一个错误的类路径、源文件路径时出现的警告                 |
| serial      | 当在可序列化的类上缺少serialVersionUID定义时的警告        |
| finally     | 任何finally子句不能正常完成时的警告                    |
| all         | 关于以上所有情况的警告                              |
另外，在设置注释信息时，是以key-value的形式出现的。所以以上的@SuppressWarnings也可以直接使用“value = {"unchecked", "deprecation"}” 的方式设置。
范例：另外一种形式的@SuppressWarnings。
```java
package org.forfan06.annotationdemo;  
@Deprecated  
class Demo<T>{  
    private T var;  
    public T getVar(){  
        return var;  
    }  
    public void setVar(T var){  
        this.var = var;  
    }  
}  
public class SuppressWarningsAnnotationDemo03{  
    @SuppressWarnings(value = {"unchecked", "deprecation"})  
    public static void main(String args[]){  
        Demo d = new Demo();  
        d.setVar("forfan06");  
        System.out.println("Content is:" + d.getVar());  
    }  
} 
```
### **@SafeVarargs与Java 7的“堆污染”**
在泛型擦除时，下面代码可能导致运行时异常
```java
List list = new ArrayList<Integer>();  
list.add(20);  //添加元素时引发unchecked异常  
//下面代码引起“未经检查的转换”的警告，编译、运行时完全正常  
List<String> ls = list;   //***  
//但是只要访问ls里的元素，则会引用运行时异常  
System.out.println(ls.get(0));  
```
Java把引发这种错误的原因成为 “ 堆污染 ”（Heap Pollution） ，当把一个不带泛型的对象赋值给一个带泛型的变量时，往往就会发生这种 “ 堆污染 ”。对于形参个数可变的方法，该形参的类型又是泛型，这将更容易导致 “ 堆污染 ”。
```java
public class ErrorUtils{  
    public static void faultyMethod(List<String>... listStrArray){  
        //Java语言不允许创建泛型数组，因此listArray只能被当成List[]处理  
        //此时相当于把List<String>赋给了List，已经发生了 “ 堆污染 ”  
        List[] listArray = listStrArray;   //Line5  
        List<Integer> myList = new ArrayList<Integer>();  
        myList.add(new Random().nextInt(100));  
        //把listArray的第一个元素赋为myArray  
        listArray[0] = myList;  
        String s = listStrArray[0].get(0);  
    }  
}  
```
上面程序代码中Line5处发生了 “ 堆污染 ” 。由于该方法有个形参是List&lt;String>...类型，个数是可变的形参相当于数组。但是，Java又不支持泛型数组，因此程序只能把List&lt;String>...当成List[]处理。这就发生了 堆污染。
如果，不希望看到这个警告，可以使用如下3种方式来 “压制”这个警告：

- 使用@SafeVarargs修饰引发该警告的方法或构造器；
- 使用@SuppressWarnings("unchecked")修饰；
- 编译时使用-Xlint:varargs选项。

第3种方式一般比较少用，通常选择第1种或第2种方式，尤其是使用@SafeVarargs修饰引发该警告的方法或构造器，它是Java 7专门为压制“堆污染”警告提供的。

### **@FunctionalInterface与Java8的函数式接口**
Java8规定：如果接口只有一个抽象方法（可以包含多个默认方法和多个static静态方法），那么该接口就是函数式接口。Java8的函数式接口是专为Lambda表达式准备的，而@FunctionalInterface就是用来指定某个接口必须是函数式接口的，只能用来修饰接口。
范列：限制某个接口必须定义为函数式接口。
```java
@FunctionalInterface
pulic interface FunInterface {
	static void foo() {
		System.out.println("foo类方法");
	}
	default void bar() 	{
		System.out.println("bar默认方法");
	}
	void test();  //只定义一个抽象方法
 }
```

在上面的代码中可能看不出@FunctionInterface发挥的作用，它只是告诉编译器检查它修饰的接口必须是一个函数式接口。如果在增加一个抽象方法，就会在编译时出现所修饰的接口不是函数式接口的出错提示。

## **JDK的元Annotation**
JDK除了在java.lang下提供5个基本的Annotation之外，还在java.lang.annotation包下提供了6个Meta Annotation（元Annotation），其中有5个元Annotation用于修饰其他的Annotation定义。
### **@Retention**
@Retention只能用于修饰一个Annotation定义，用于指定被修饰的Annotation可以保留多长时间（保存范围）。@Retention包含一个RetentionPolicy类型的value成员变量，所以使用@Retention时必须为该value成员变量指定值。
```java
//@Retention的定义：  
@Documented  
@Rentention(value=RUNTIME)  
@Target(value=ANNOTATION_TYPE)  
public @interface Retention{  
    RetentionPolicy value();  
}  
```
Retention定义中的RetentionPolicy变量用于指定Annotation的保存范围。 其包含一下3个范围：

- RetentionPolicy.CLASS: 编译器将把Annotation记录在class文件中。当运行Java程序时，JVM不再保留Annotation。**此Annotation类型将保留在程序源文件（\*.java）和编译之后的类文件（\*.class）中。在使用此类时，这些Annotation信息不会被加载到虚拟机（JVM）中。如果一个Annotation声明时没有指定范围，则默认是此范围**；
- RetentionPolicy.RUNTIME: 编译器将把Annotation记录在class文件中。当运行Java程序时，JVM也会保留Annotation，程序可以通过反射获取该Annotation信息。此Annotation类型的信息保留在源文件（\*.java）、类文件（\*.class）中，在执行时也会加载到JVM中；
- RetentionPolicy.SOURCE:  Annotation只保留在源代码中，编译器直接丢弃这种Annotation。此Annotation类型的信息只会保留在程序源文件（\*.java）中，编译之后不会保存在编译好的类文件（\*.class）中。
```java
@Rentention(RententionPolicy.SOURCE)
public @interface Testable{}
```
上面的代码并没有使用value=...的形式。因为如果使用注解时只需要为value成员变量指定值，则使用注解时可以直接在该注解后的括号里指定value成员变量的值，无需使用“value=name”的形式。

Java内建的Annotation的范围：

- @Override定义采用的是@Retention(value=SOURCE)，只能在源文件中出现；
- @Deprecated定义采用的是@Retention(value=RUNTIME)，可以在运行时出现；
- @SuppressWarnings定义采用的是@Retention(value=SOURCE)，只能在源文件中出现。

范例：定义在RUNTIME范围有效的Annotation。
```java
package org.forfan06.annotationdemo;  
import java.lang.annotation.Retention;  
import java.lang.annotation.RetentionPolicy;  
@Retention(value=RetentionPolicy.RUNTIME) //此Annotation在运行时起作用  
public @interface MyDefaultRetentionAnnotation{  
    public String name() default "forfan06";// 只能设置枚举的取值  
}  
```
上面定义的Annotation在程序运行时起作用，这是一种比较常见的使用方式，而如果此时将其设置成其他范围，则以后在Annotation的应用中肯定是无法访问到的。
要想让一个Annotation起作用，必须结合Java中的反射机制。 
### **@Target**
@Target元Annotation也只能修饰一个Annotation定义，它也包含一个名为value的成员变量，用于被修饰的Annotation能用于修饰哪些程序单元。该成员变量的值只能是以下几个：

- ElementType.ANNOTATION_TYPE：指定该策略的Annotation只能修饰Annotation；
- ElementType.CONSTRUCTOR：指定该策略的Annotation只能修饰构造器；
- ElementType.FIELD：指定该策略的Annotation只能修饰成员变量；
- ElementType.LOCAL_VARIABLE：指定该策略的Annotation只能修饰只能修饰成员变量；
- ElementType.METHOD：指定该策略的Annotation只能修饰方法定义；
- ElementType.PACKAGE：指定该策略的Annotation只能修饰包定义；
- ElementType.PARAMETER：指定该策略的Annotation可以修饰参数；
- ElementType.TYPE：指定该策略的Annotation能修饰类、接口（包括注解）或枚举定义。

与@Retention类似的是，@Target也可以在括号里直接指定value值，无须使用name=value形式。
### **@Documented**
@Documented用于指定被该元Annotation修饰的Annotation类将被javadoc工具提取成文档，所有使用该Annotation修饰的程序元素API文档将会包含该Annotation说明。
```java
@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.MEHTOD)
//定义Testable Annotation将被javadoc工具提取
@Documented
public @interface Testable {
}
```
上面代码中@Documeted指定了javadoc工具生成的API文档将提取@Testable的使用信息。
```java
public class MyTest {
	//使用@Testable修饰的方法
	@Testable
	public void info() {
		System.out.println("info方法");
	 }
}
```
使用javadoc工具为上面两份java文件生成API文档后将包含@Testable的信息。
### **@Inherited**
@Inherited元Annotation指定被它修饰的Annotation将具有继承性，被它修饰的Annotation修饰的类的子类将自动具有继承性。
```java
@Target(ElementType.TYPE)
@Retention(RetentionPolicy.RUNTIME)
@Inherited
public @interface Inheritable {
}
```
如果某个类使用了@Inheritable修饰，那么该类的子类将自动使用@Inheritable修饰。
```java
@Inheritbale
class Base {
}
public class InheritbaleTest extends Base {
	public static void main(String[] args) {
		//打印InheritableTest类是否有@Inheritable修饰
		System.out.println(InheritableTest.class.isAnnotationPresent(Inheritable.class));
	}
}
```
上面代码将输出ture。
## **使用自定义Annotation**
### **自定义Annotation**
 使用@interface关键字来定义新的Annotation，如： 
```java
 public @interface Test {
 }
```
定义了该Annotation之后可以在程序的任何地方使用该Annotation，默认情况下，可用于修饰任何程序元素，包括类、接口和方法等。通常把Annotation放在所有修饰符之前，并且单独一行。如：
```java
@Test
public class MyClass {
	...
}
```
Annotation还可以带成员变量，其成员变量在Annotation定义中以无形参的方法形式来声明，其方法名和返回值定义了该成员变量的名字和类型。如：
```java
public @interface MyTag {
	//定义带两个成员变量的Annotation
	//Annotation的成员变量以方法的形式来定义
	String name();
	int age();
}
```
一旦定义了成员变量之后就应该在使用该Annotation时给其成员变量指定值。如：
```java
public class Test {
	//使用带有成员变量的Annotation时应该为其成员变量赋值
	@MyTag(name="xx", age=6)
	public void info() {
	}
}
```
也可以在定义Annotation时为其成员变量通过default关键字指定默认值。如：
```java
public @interface MyTag {
	//定义带有成员变量的Annotation时应该为其成员变量指定默认初始值
	String name() default "xx";
	int age()  default 6;
}
```
这样就可以在使用该Annotation时不显式指定值，而使用默认值。如：
```java
public class Test {
	//使用带有默认成员变量值的Annotation时不显式指定值，而使用默认值
	@MyTag
	public void info() {
	}
}
```
根据Annotation是否包含成员变量可以将Annotation分为两类：

- 标记Annotation：不包含成员变量的Annotation称为标记。通过其自身的存在来提供信息；
- 元数据Annotation：包含成员变量的Annotation因为可以接收更多的元数据，所以称为元数据Annotation。

### **提取Annotation信息**

Annotation接口是所有注解类的父接口。JDK5在java.lang.reflect包下新增了AnnotatedElement接口，该接口代表程序中可以接受注解的程序元素，该接口有以下子类：

- Class：类定义；
- Constructor：构造器定义；
- Field：类的成员变量定义；
- Method：类的方法定义；
- Package：类的包定义。

这些类主要是用于反射的工具类。只有在定义Annotation时使用了@Retention(RetentionPolicy.RUNTIME)修饰，该Annotation才会在运行时可见，JVM才会在装载\*.class文件时才能读取保存在\*.class文件中的Annotation，才能通过java.lang.reflect包下反射API获取某个类的AnnotatedElement对象之后，获取该程序元素对象的Annotation信息。

- &lt;T extends Annotation> T	getAnnotation(Class&lt;T> annotationClass)：返回该程序元素上指定类型的注解，如果不存在则返回null；
- default &lt;T extends Annotation> TgetDeclaredAnnotation(Class&lt;T> annotationClass)：Java8新增的，用于获取直接修饰该程序元素、指定类型的Annotation，如果不存在则返回null；
- Annotation[] getAnnotations()：返回该程序元素的所有注解；
- Annotation[] getDeclaredAnnotations()：返回直接修饰该程序元素、指定类型的Annotation；
- default booleanisAnnotationPresent(Class&lt;? extends Annotation> annotationClass)：返回该程序元素上是否存在指定类型的注解；
- default<T extends Annotation> T[] getAnnotationsByType(Class<T> annotationClass)：该方法与前面的getAnnotation()方法类似。由于Java8新增了重复注解，此方法用于返回修饰该程序元素、指定类型的多个Annotation；
- default&lt;T extends Annotation>T[] getDeclaredAnnotationsByType(Class&lt;T> annotationClass)：该方法与前面的getDeclaredAnnotation()方法类似。由于Java8新增了重复注解，此方法用于返回直接修饰该程序元素、指定类型的多个Annotation。

获取Test类的info方法里的所有注解：
```java
//获取该Test类的info方法的所有注解
Annotation[] aArray = Class.forName("Test").getMethod("info").getAnnotations();
//遍历输出所有注解
for (Annotation an : aArray) {
	System.out.println("an");
}
```
如果需要获取某个注解里的元数据，则可以将注解类强制转换为所需的注解类型，然后通过注解对象的抽象方法来访问这些元数据。
```java
//获取该Test类的info方法的所有注解
Annotation[] aArray = Class.forName("Test").getMethod("info").getAnnotations();
//遍历输出所有注解
for (Annotation tag : aArray) {
	//如果tag注解是MyTag类型
	if (tag instanceof MyTag) {
		System.out.println("Tag is " + tag);
		//将tag对象强制转换为MyTag类型
		//输出tag对象的method成员变量的值
		System.out.println("tag.name is " + ((MyTag)tag).method());
	}
}
```
### **使用Annotation示例**
 下面的@Testable注解接口用于标记哪些方法是可测试的：
```java
// 使用JDK的元数据Annotation：Retention
@Retention(RetentionPolicy.RUNTIME)
// 使用JDK的元数据Annotation：Target
@Target(ElementType.METHOD)
// 定义一个标记注解，不包含任何成员变量，即不可传入元数据
public @interface Testable
{
}
```
 在JUnit框架中它要求测试用例的测试方法必须以test开头。如果使用@Testable注解，则可以把任何方法标记为可测试的。
 使用@Testable标记MyTest类的哪些方法是可测试的：
```java
 public class MyTest
{
	// 使用@Testable注解指定该方法是可测试的
	@Testable
	public static void m1()
	{
	}
	public static void m2()
	{
	}
	// 使用@Testable注解指定该方法是可测试的
	@Testable
	public static void m3()
	{
		throw new IllegalArgumentException("参数出错了！");
	}
	public static void m4()
	{
	}
	// 使用@Testable注解指定该方法是可测试的
	@Testable
	public static void m5()
	{
	}
	public static void m6()
	{
	}
	// 使用@Testable注解指定该方法是可测试的
	@Testable
	public static void m7()
	{
		throw new RuntimeException("程序业务出现异常！");
	}
	public static void m8()
	{
	}
}
```
下面的注解工具类分析目标类，如果目标类中的方法使用了@Testable注解修饰，则通过反射来运行该测试方法：
```java
public class ProcessorTest
{
	public static void process(String clazz)
		throws ClassNotFoundException
	{
		int passed = 0;
		int failed = 0;
		// 遍历clazz对应的类里的所有方法
		for (Method m : Class.forName(clazz).getMethods())
		{
			// 如果该方法使用了@Testable修饰
			if (m.isAnnotationPresent(Testable.class))
			{
				try
				{
					// 调用m方法
					m.invoke(null);
					// 测试成功，passed计数器加1
					passed++;
				}
				catch (Exception ex)
				{
					System.out.println("方法" + m + "运行失败，异常："
						+ ex.getCause());
					// 测试出现异常，failed计数器加1
					failed++;
				}
			}
		}
		// 统计测试结果
		System.out.println("共运行了:" + (passed + failed)
			+ "个方法，其中：\n" + "失败了:" + failed + "个，\n"
			+ "成功了:" + passed + "个！");
	}
}
```
提供主类来运行测试工具类分析目标类：
```java
public class RunTests
{
	public static void main(String[] args)
		throws Exception
	{
		// 处理MyTest类
		ProcessorTest.process("MyTest");
	}
} 
```
使用自定义Annotation的思路是：用自定义Annotation给程序元素添加特殊标记，然后通过反射获取这些特殊标记，然后做出相应的处理。
下面通过注解来简化添加时间监听器的编程。
 首先定义一个@ActionListenerFor注解：
```java
@Target(ElementType.FIELD)
@Retention(RetentionPolicy.RUNTIME)
public @interface ActionListenerFor
{
	// 定义一个成员变量，用于设置元数据
	// 该listener成员变量用于保存监听器实现类
	Class<? extends ActionListener> listener();
}
```
使用@ActionListenerFor为两个按钮添加事件监听器：
```java
public class AnnotationTest
{
	private JFrame mainWin = new JFrame("使用注解绑定事件监听器");
	// 使用Annotation为ok按钮绑定事件监听器
	@ActionListenerFor(listener=OkListener.class)
	private JButton ok = new JButton("确定");
	// 使用Annotation为cancel按钮绑定事件监听器
	@ActionListenerFor(listener=CancelListener.class)
	private JButton cancel = new JButton("取消");
	public void init()
	{
		// 初始化界面的方法
		JPanel jp = new JPanel();
		jp.add(ok);
		jp.add(cancel);
		mainWin.add(jp);
		ActionListenerInstaller.processAnnotations(this);     // ①
		mainWin.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		mainWin.pack();
		mainWin.setVisible(true);
	}
	public static void main(String[] args)
	{
		new AnnotationTest().init();
	}
}
// 定义ok按钮的事件监听器实现类
class OkListener implements ActionListener
{
	public void actionPerformed(ActionEvent evt)
	{
		JOptionPane.showMessageDialog(null , "单击了确认按钮");
	}
}
// 定义cancel按钮的事件监听器实现类
class CancelListener implements ActionListener
{
	public void actionPerformed(ActionEvent evt)
	{
		JOptionPane.showMessageDialog(null , "单击了取消按钮");
	}
}
```
利用注解的元数据取得监听器实现类，然后通过反射来创建监听器对象，然后将监听器对象绑定到指定的按钮：
```java
public class ActionListenerInstaller
{
	// 处理Annotation的方法，其中obj是使用Annotation修饰的对象
	public static void processAnnotations(Object obj)
	{
		try
		{
			// 获取obj对象的类
			Class cl = obj.getClass();
			// 获取指定obj对象的所有成员变量，并遍历每个成员变量
			for (Field f : cl.getDeclaredFields())
			{
				// 将该成员变量设置成可自由访问。
				f.setAccessible(true);
				// 获取该成员变量上ActionListenerFor类型的Annotation
				ActionListenerFor a = f.getAnnotation(ActionListenerFor.class);
				// 获取成员变量f的值
				Object fObj  = f.get(obj);
				// 如果f是AbstractButton的实例，且a不为null
				if (a != null && fObj != null
					&& fObj instanceof AbstractButton)
				{
					// 获取a注解里的listner元数据（它是一个监听器类）
					Class<? extends ActionListener> listenerClazz = a.listener();
					// 使用反射来创建listner类的对象
					ActionListener al = listenerClazz.newInstance();
					AbstractButton ab = (AbstractButton)fObj;
					// 为ab按钮添加事件监听器
					ab.addActionListener(al);
				}
			}
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}
	}
}
```
### **Java8新增的重复注解**
在Java8以前，对同一个元素使用多个相同类型的注解需要使用Annotation“容器”：
```java
@Results({@Retention(name="failure", location=""failed.jsp), 
@Result(name="success", location="succ.jsp")})
public Action FooAction{ ... }
```
从Java8开始，如果的原来的注解进行适当的改造，就可以对同一个对象使用多个相同类型的注解。下面看如何进行改造。
首先定义一个FKTag注解：
```java
// 指定该注解信息会保留到运行时
@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.TYPE)
@Repeatable(FkTags.class)
public @interface FkTag
{
	// 为该注解定义2个成员变量
	String name() default "疯狂软件";
	int age();
}
```
为了使该注解可以对同一个对象重复使用，创建FKTag注解时必须使用@Repeatable修饰该注解，对应的value成员变量得是一个可以包含多个FKTag注解的“容器”注解。因此，还需要创建一个可以包含多个FKTag注解的“容器”注解：
```java
// 指定该注解信息会保留到运行时
@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.TYPE)
public @interface FkTags
{
	// 定义value成员变量，该成员变量可接受多个@FkTag注解
	FkTag[] value();
}
```
注意：“**容器”注解的保留其必须不断于它所包含的注解的保留期**，否则编译出错。
这样就可以使用Java8新增的重复注解语法：
```java
@FkTag(age=5)
@FkTag(name="疯狂Java", age=9)
```
也可以继续使用以前的“容器”语法：
```java
@FkTags({@FkTag(age=5), 
@FkTag(name="疯狂Java"， age=9)})
```
下面的程序演示了重复注解的本质：
```java
@FkTag(age=5)
@FkTag(name="疯狂Java" , age=9)
//@FkTags({@FkTag(age=5),
//	@FkTag(name="疯狂Java" , age=9)})
public class FkTagTest
{
	public static void main(String[] args)
	{
		Class<FkTagTest> clazz = FkTagTest.class;
		/* 使用Java 8新增的getDeclaredAnnotationsByType()方法获取
			修饰FkTagTest类的多个@FkTag注解 */
		FkTag[] tags = clazz.getDeclaredAnnotationsByType(FkTag.class);
		// 遍历修饰FkTagTest类的多个@FkTag注解
		for(FkTag tag : tags)
		{
			System.out.println(tag.name() + "-->" + tag.age());
		}
		/* 使用传统的getDeclaredAnnotation()方法获取
			修饰FkTagTest类的@FkTags注解 */
		FkTags container = clazz.getDeclaredAnnotation(FkTags.class);
		System.out.println(container);
	}
} 
```
上面程序依然可以获得FkTags注解可以看出重复注解只是老语法的简化，重复注解依然会被当成是“容器”注解的value成员变量的数组元素。
## **编译时处理Annotation**
APT(Annotation Processing Tool )作为一种注解处理工具，用于检测源代码文件。并对查找到的源码中Annotation信息进行处理。处理过程中可以生产额外的源文件和其他文件（取决于程序编码），APT还可以编译它自己生成的源文件和原来的源文件，将他们一起生成.class文件。由此可见，APT简化了开发者的工作量。

Java的javac.exe命令有一个processor选项，该选项可以指定一个Annotation处理器，指定的处理器将在编译时提取并处理源文件中的Annotation信息。

每个Annotation处理器都需要实现javax.annotation.processing包下的Processor接口。为了实现更少的方法，一般继承AbstractProcessor类来实现Annotation处理器。一个Annotation可以处理一种或者多种Annotation类型。下面定义的3种Annotation类型，分别用于修饰持久化类，标识属性和普通成员类型：
```java
@Target(ElementType.TYPE)
@Retention(RetentionPolicy.SOURCE)
@Documented
public @interface Persistent
{
	String table();
}
```
```java
@Target(ElementType.FIELD)
@Retention(RetentionPolicy.SOURCE)
@Documented
public @interface Id
{
	String column();
	String type();
	String generator();
}
```
```java
@Target(ElementType.FIELD)
@Retention(RetentionPolicy.SOURCE)
@Documented
public @interface Property
{
	String column();
	String type();
}
```
下面使用注解来修饰Person类：
```java
@Persistent(table="person_inf")
public class Person
{
	@Id(column="person_id",type="integer",generator="identity")
	private int id;
	@Property(column="person_name",type="string")
	private String name;
	@Property(column="person_age",type="integer")
	private int age;

	//无参数的构造器
	public Person()
	{
	}
	//初始化全部成员变量的构造器
	public Person(int id , String name , int age)
	{
		this.id = id;
		this.name = name;
		this.age = age;
	}

	// 下面省略所有成员变量的setter和getter方法

	//id的setter和getter方法
	public void setId(int id)
	{
		this.id = id;
	}
	public int getId()
	{
		return this.id;
	}

	//name的setter和getter方法
	public void setName(String name)
	{
		this.name = name;
	}
	public String getName()
	{
		return this.name;
	}

	//age的setter和getter方法
	public void setAge(int age)
	{
		this.age = age;
	}
	public int getAge()
	{
		return this.age;
	}

}
```
x下面为这三个Annotation生成一个APT工具类，根据该工具可以生成一个Hibernate映射文件：
```java
@SupportedSourceVersion(SourceVersion.RELEASE_8)
// 指定可处理@Persistent、@Id、@Property三个Annotation
@SupportedAnnotationTypes({"Persistent" , "Id" , "Property"})
public class HibernateAnnotationProcessor
	extends AbstractProcessor
{
	// 循环处理每个需要处理的程序对象
	public boolean process(Set<? extends TypeElement> annotations
		, RoundEnvironment roundEnv)
	{
		// 定义一个文件输出流，用于生成额外的文件
		PrintStream ps = null;
		try
		{
			// 遍历每个被@Persistent修饰的class文件
			for (Element t : roundEnv.getElementsAnnotatedWith(Persistent.class))
			{
				// 获取正在处理的类名
				Name clazzName = t.getSimpleName();
				// 获取类定义前的@Persistent Annotation
				Persistent per = t.getAnnotation(Persistent.class);
				// 创建文件输出流
				ps = new PrintStream(new FileOutputStream(clazzName
					+ ".hbm.xml"));
				// 执行输出
				ps.println("<?xml version=\"1.0\"?>");
				ps.println("<!DOCTYPE hibernate-mapping PUBLIC");
				ps.println("	\"-//Hibernate/Hibernate "
					+ "Mapping DTD 3.0//EN\"");
				ps.println("	\"http://www.hibernate.org/dtd/"
					+ "hibernate-mapping-3.0.dtd\">");
				ps.println("<hibernate-mapping>");
				ps.print("	<class name=\"" + t);
				// 输出per的table()的值
				ps.println("\" table=\"" + per.table() + "\">");
				for (Element f : t.getEnclosedElements())
				{
					// 只处理成员变量上的Annotation
					if (f.getKind() == ElementKind.FIELD)   // ①
					{
						// 获取成员变量定义前的@Id Annotation
						Id id = f.getAnnotation(Id.class);      // ②
						// 当@Id Annotation存在时输出<id.../>元素
						if(id != null)
						{
							ps.println("		<id name=\""
								+ f.getSimpleName()
								+ "\" column=\"" + id.column()
								+ "\" type=\"" + id.type()
								+ "\">");
							ps.println("		<generator class=\""
								+ id.generator() + "\"/>");
							ps.println("		</id>");
						}
						// 获取成员变量定义前的@Property Annotation
						Property p = f.getAnnotation(Property.class);  // ③
						// 当@Property Annotation存在时输出<property.../>元素
						if (p != null)
						{
							ps.println("		<property name=\""
								+ f.getSimpleName()
								+ "\" column=\"" + p.column()
								+ "\" type=\"" + p.type()
								+ "\"/>");
						}
					}
				}
				ps.println("	</class>");
				ps.println("</hibernate-mapping>");
			}
		}
		catch (Exception ex)
		{
			ex.printStackTrace();
		}
		finally
		{
			if (ps != null)
			{
				try
				{
					ps.close();
				}
				catch (Exception ex)
				{
					ex.printStackTrace();
				}
			}
		}
		return true;
	}
}
```
执行以下命令：
rem 使用HibernateAnnotationProcessor作为APT处理Person.java中的Annotation
javac -processor HibernateAnnotationProcessor Person.java
就可以在相同路径下看到Person.hbm.xml文件：
```xml
<?xml version="1.0"?>
<!DOCTYPE hibernate-mapping PUBLIC
	"-//Hibernate/Hibernate Mapping DTD 3.0//EN"
	"http://www.hibernate.org/dtd/hibernate-mapping-3.0.dtd">
<hibernate-mapping>
	<class name="Person" table="person_inf">
		<id name="id" column="person_id" type="integer">
		<generator class="identity"/>
		</id>
		<property name="name" column="person_name" type="string"/>
		<property name="age" column="person_age" type="integer"/>
	</class>
</hibernate-mapping>
```



