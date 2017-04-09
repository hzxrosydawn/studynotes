## 注解简介

### Annotation接口

**从JDK1.5开始**，Java增加了对元数据（Metadata）的支持，也就是Annotation（即注解）。Annotation是一种新的接口类型，可通过在interface关键前面添加一个@符号来声明一个注解类型。

> @符号和interface关键字是两个不同的标记，虽然可以在两者之间添加空白，但是强烈反对这种编码风格。

注解其实就是代码里的特殊标记，这些标记可以在编译、类加载、运行时被读取，并执行相应的处理。通过使用注解注解，程序员可以在不改变原有逻辑的情况下，在源文件中嵌入一些补充的信息。代码分析工具、开发工具和部署工具可以通过这些补充信息进行验证或部署。

注解不影响程序运行，无论是否使用Annotation代码都可以正常运行。如果希望让程序中的Annotation在运行时起一定的作用，只能通过某种配套的工具对Annotation中的信息进行访问和处理，访问和处理Annotation的工具统称为APT（Annotation Processing Tool）。

注解提供了一种为程序元素设置元数据的方法，从某些方面来看，注解就像修饰符一样，可用于修饰包、类、构造器、方法、成员变量、参数、局部变量的声明，这些信息被存储在注解的“name=value”对中。

注解通过Annotation接口（java.lang.annotation.Annotation）实现，程序可以**通过反射来获取指定程序元素的Annotation对象**，然后**通过Annotation对象来取得注解里的元数据**。

java.lang.annotation.Annotation接口的定义如下：

```java
public interface Annotation {  
	public Class<? extends Annotation> annotationType();  //返回此annotation的注释类型  
	public boolean equals(Object obj); 
	public int hashCode();  
	String toString(); 
}
```
注解类型声明语法如下：

```
{InterfaceModifier} @interface Identifier {AnnotationTypeBody}
```

注解类型主体声明：

```java
{ {AnnotationTypeMemberDeclaration} }
```

注解类型成员声明：

```
AnnotationTypeElementDeclaration
ConstantDeclaration
ClassDeclaration
InterfaceDeclaration
;
```

注解类型元素声明：

```
{AnnotationTypeElementModifier} UnannType Identifier ( ) [Dims]
 [DefaultValue];
```

注解类型元素修饰部分：

```
(one of)
Annotation public abstract
```

注解类型声明的修饰部分InterfaceModifier可以为若干元注解修饰、public、default、protected、private、abstract、static、strictfp之一。

注解类型声明中的Identifier指定了注解类型的名称。如果注解类型具有与其任何封闭类或接口相同的名称，则会发生编译时错误。

上面声明语法中的{}里的内容都是可选的。

根据注解声明语法：

- 注解类型声明不能是泛型；
- 不允许使用extends关键字（所有注解类型隐式扩展java.lang.annotation.Annotation接口）；
- 方法不能有任何参数和任何形参；
- 方法不能有throws子句。

除非被明确修改，否则，**适用于普通接口声明的所有规则也适用于注解类型声明**。

一个注解类型不能显式声明父类或父接口类型，因为注解类型自身的子类或子接口不是一个注解类型。类似的，java.lang.annotation.Annotation也不是一个注解类型。

注解类型中的声明方法的返回类型必须是基本类型、String、Class或Class的调用、枚举、注解、数组（其元素是前面类型中的一种，且**不能是多重数组**）之一，否则编译出错。如不允许下面几种的情形：

```java
@interface Verboten { 
 String[][] value(); 
}
```

```java
@interface Foo {
  Bar value();
} 
```

### 注解类型元素

**注解类型的每个方法都不能有形参、类型参数和throws子句，也不能使用default和static关键字修饰。注解类型中的每个无参方法声明都定义了注解类型的一个元素，且注解类型的元素仅由这个无参方法的显式声明来定义，这个无参方法的方法名和返回值定义了该元素的名字和类型。注解类型可以有零个或多个元素。不含元素的注解类型（主体为空）称为标记注解类型（marker annotation type），通过其自身的存在来提供信息；单元素注解类型（仅有一个方法声明）中唯一的元素名称是value**。

注解类型从java.lang.annotation.Annotation继承了一些方法，包括从Object类隐式继承来的实例方法。然而这些方法并没有定义注解类型的元素，所以不能在注解中使用这些方法。如果注解类型中声明的方法重写了这些继承来的public或protected方法，就会编译出错。

**声明注解时允许除方法声明之外的其他元素声明。例如，可以声明一个嵌套枚举，用于连接一个注解类型**：

```java
@interface Quality { 
 enum Level {BAD, INDIFFERENT, GOOD} 
 Level value(); 
}
```

### 注解类型元素的默认值

注解类型可通过在其（空）参数列表后面的添加default关键字和指定的默认值来为其元素添加指定的默认值。默认值是阅读注解时动态应用的，不会被编译进注解中。因此，执行更改前，更改默认值将会影响注解，甚至在类中也是如此（假定这些注解没有为默认元素提供一个显式值）。

默认值声明语法：

```java
default ElementValue
```

如果元素类型与默认值得类型不同会在编译时报错。

如：

```java
@interface RequestForEnhancementDefault { 
	int id(); // No default - must be specified in each annotation
  	String synopsis(); // No default - must be specified in each annotation 
 	String engineer() default "[unassigned]"; 
 	String date() default "[unimplemented]"; 
}
```



## 系统内建的Annotation

Annotation必须使用工具来处理，工具负责提取Annotation里包含的元数据，工具还会根据这些元数据增加额外的功能。我们先看一下Java提供的5个基本Annotation的用法，这5个内建注解都位于java.lang包中。

### @Override 限定重写父类方法
@Override注解的定义如下：

```java
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.SOURCE)
public @interface Override {
}
```

@Override就是用来指定方法重写的，它可以**强制一个子类必须覆盖父类的方法**。主要在方法覆写时使用，用于保证方法覆写的正确性。

范例：观察@Override注释的作用
```java
class Person {  
	public  String getInfo(){  
	return "这是一个Person类";  
	}  
}  

class Student extends Person {  
	@Override  
	public String getInfo() {  
		return "这是一个Student类";  
	}  
}  

public class OverrideAnnotationTest {  
	public static void main(String args[]) {  
		Person per = new Student();  
		System.out.print(per.getInfo());  
	}  
}  
```
运行结果：
```java
这是一个Student类
```
以上程序中的子类Student继承Person类，之后重写了Person类中的getInfo()方法，程序运行结果和之前的一样，唯一的不同只是在覆写的getInfo()方法前加上了@Override注解。这样做的目的是**防止用于在声明重写方法时出错**。如果使用@Override注解修饰的方法没有进行正确的重写IDE就会报错。

### @Deprecated 标示已过时
@Deprecated注解的定义如下：

```java
@Documented
@Retention(value=RUNTIME)
@Target(value={CONSTRUCTOR,FIELD,LOCAL_VARIABLE,METHOD,PACKAGE,PARAMETER,TYPE})
public @interface Deprecated {}
```

@Deprecated注解用于表示某个程序单元（构造器、字段、局部变量、方法、包、参数和类型）已过时，当其他程序使用已过时的类、方法时，编译器将会给出警告，因为编程规范强烈不建议谁用过时的类和方法。

下面使用@Deprecated声明一个不建议使用的方法。
```java
class Demo {  
	@Deprecated  
	public String getInfo(){  
		return "被测试类";  
	}  
}  
public class DeprecatedAnnotationTest {  
	public static void main(String args[]) {  
		Demo d = new Demo();  
		System.out.println(d.getInfo());  
	}  
}  
```
以上的Demo类中的getInfo()方法上使用了@Deprecated注释声明，表示此方法不建议用户继续使用，所以在IDE中会使用红色的中划线表示过时方法（或类）的使用，编译时也会出现以下警告信息：

```shell
Note: DeprecatedAnnotationDemo01.java uses or overrides a deprecated API.  
Note: Recompile with -Xlint:deprecation for details.  
```
虽然出现了警告信息，但是程序还是可以正常执行。因为@Deprecated注释只是表示该方法不建议使用，但并不是不能使用！

@Deprecated的作用与文档注释中的@deprecated标记的作用基本相同，但它们的用法不同，前者是JDK1.5才支持的注解，无须放在文档注释（/\*\*...\*/）语法中，而是直接用于修饰程序中的程序单元。

### @SuppressWarnings 抑制编译器警告
@SuppressWarnings注解的定义如下：

```java
@Target(value={TYPE,FIELD,METHOD,PARAMETER,CONSTRUCTOR,LOCAL_VARIABLE})
@Retention(value=SOURCE)
public @interface SuppressWarnings {
  String[] value();
}
```

@SuppressWarnings指示被该注解修饰的程序单元（TYPE、FIELD、METHOD、PARAMETER、CONSTRUCTOR、LOCAL_VARIABLE）取消显示指定的编译器警告。

@SuppressWarnings会抑制作用于该程序单元的中所有成员。例如，使用@SuppressWarnings修饰某个类取消显示某个编译器警告，同时又修饰该类中的某个方法取消显示另一个编译器警告，那么该方法将会同时取消显示这两个编译器警告。

例如，之前讲解泛型操作时，如果在一个类声明时没有指明泛型，则肯定在编译时产生未经检查的泛型警告，那么此时就可以使用@SuppressWarnings压制住这种警告：
```java
class Demo<T> {  
	private T var;  
	public T getVar(){  
		return var;  
	}  
	public void setVar(T var){  
	this.var = var;  
	}  
}  

public class SuppressWarningsAnnotationTest01 {  
	@SuppressWarnings(value="unchecked")  
	public static void main(String args[]){  
		Demo d = new Demo();  
		d.setVar("hello");  
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
压制多个警告的实例：
```java
@Deprecated  
class Demo<T> {  
    private T var;  
    public T getVar(){  
        return var;  
    }  
    public void setVar(T var){  
        this.var = var;  
    }  
}  
public class SuppressWarningsAnnotationTest02 {  
    @SuppressWarnings({"unchecked", "deprecation"})  
    public static void main(String args[]){  
        Demo d = new Demo();  
        d.setVar("hello");  
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
@Deprecated  
class Demo<T> {  
    private T var;  
    public T getVar() {  
        return var;  
    }  
    public void setVar(T var) {  
        this.var = var;  
    }  
}  
public class SuppressWarningsAnnotationTest03 {  
    @SuppressWarnings(value = {"unchecked", "deprecation"})  
    public static void main(String args[]){  
        Demo d = new Demo();  
        d.setVar("hello");  
        System.out.println("Content is:" + d.getVar());  
    }  
} 
```
### **@SafeVarargs与Java 7的“堆污染”**

@SafeVarargs注解的定义如下：

```java
@Documented
@Retention(value=RUNTIME)
@Target(value={CONSTRUCTOR, METHOD})
public @interface SafeVarargs {}
```

在泛型擦除时，下面代码可能导致运行时异常
```java
List list = new ArrayList<Integer>();  
list.add(20);  // 添加元素时引发unchecked异常  
// 下面代码引起“未经检查的转换”的警告，编译、运行时完全正常  
List<String> ls = list;   //***  
// 但是只要访问ls里的元素，则会引用运行时异常  
System.out.println(ls.get(0));  
```
Java把引发这种错误的原因称为 “ 堆污染 ”（Heap Pollution） ，当**把一个不带泛型的对象赋值给一个带泛型的变量时，往往就会发生这种 “ 堆污染 ”。对于形参个数可变的方法，该形参的类型又是泛型，这将更容易导致 “ 堆污染 ”**。
```java
public class ErrorUtils {  
    public static void faultyMethod(List<String>... listStrArray) {  
        // Java语言不允许创建泛型数组，因此listArray只能被当成List[]处理  
        // 此时相当于把List<String>赋给了List，已经发生了 “ 堆污染 ”  
        List[] listArray = listStrArray;   //Line5  
        List<Integer> myList = new ArrayList<Integer>();  
        myList.add(new Random().nextInt(100));  
        // 把listArray的第一个元素赋为myArray  
        listArray[0] = myList;  
        String s = listStrArray[0].get(0);  
    }  
}  
```
上面程序代码中Line5处发生了 “ 堆污染 ” 。由于该方法有个形参是“List<String>...”类型，个数是可变的形参相当于数组。但是Java又不支持泛型数组，因此程序只能把“List<String>...”当成List[]处理。这就发生了堆污染。
如果，不希望看到这个警告，可以使用如下3种方式来 “压制”这个警告：

- 使用@SafeVarargs修饰引发该警告的方法或构造器；
- 使用@SuppressWarnings("unchecked")修饰；
- 编译时使用-Xlint:varargs选项。

第3种方式一般比较少用，通常选择第1种或第2种方式，尤其是使用@SafeVarargs修饰引发该警告的方法或构造器，它是Java 7专门为压制“堆污染”警告提供的。

### **@FunctionalInterface与Java8的函数式接口**
@FunctionanlInterface注解的定义如下：

```java
@Documented
@Retention(value=RUNTIME)
@Target(value=TYPE)
public @interface FunctionalInterface {}
```

Java8规定：如果接口只有一个抽象方法（可以包含多个默认方法和多个static静态方法），那么该接口就是函数式接口。Java8的函数式接口是专为Lambda表达式准备的，而@FunctionalInterface就是用来指定某个接口必须是函数式接口的，只能用来修饰接口。

限制某个接口必须定义为函数式接口：

```java
@FunctionalInterface
pulic interface FunInterface {
	static void foo() {
		System.out.println("foo类方法");
	}
	default void bar() {
		System.out.println("bar默认方法");
	}
	void test();  //只定义一个抽象方法
 }
```

在上面的代码中可能看不出@FunctionInterface发挥的作用，它只是告诉编译器检查它修饰的接口必须是一个函数式接口。如果在增加一个抽象方法，就会在编译时出现所修饰的接口不是函数式接口的出错提示。

## JDK的元Annotation
JDK除了在java.lang下提供5个基本的Annotation之外，还在java.lang.annotation包下提供了6个元Annotation（Meta Annotation），这6个元Annotation用于修饰其他的Annotation定义。
### @Retention
@Retention的定义如下： 

```java
@Documented
@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.ANNOTATION_TYPE)
public @interface Retention {
    /**
     * Returns the retention policy.
     * @return the retention policy
     */
    RetentionPolicy value();
} 
```
@Retention只能用于修饰一个Annotation定义，用于指定被修饰的Annotation可以保留多长时间（保存范围）。@Retention包含一个RetentionPolicy类型的value元素，所以使用@Retention时必须为该value元素指定具体的值。

RetentionPolicy枚举类的枚举常量用于为@Retention注解指定目标Annotation的保留范围：

- RetentionPolicy.SOURCE：Annotation只保留在源代码中，编译器直接丢弃这种Annotation。此Annotation类型的信息只会保留在程序源文件（\*.java）中，编译之后不会保存在编译好的类文件（\*.class）中；
- RetentionPolicy.CLASS：编译器将把Annotation记录在class文件中。当运行Java程序时，JVM不再保留Annotation。**此Annotation类型将保留在程序源文件（\*.java）和编译之后的类文件（\*.class）中。在使用此类时，这些Annotation信息不会被加载到虚拟机（JVM）中。如果一个Annotation声明时没有指定其保留范围，则默认是此范围**；
- RetentionPolicy.RUNTIME：编译器将把Annotation记录在class文件中。当运行Java程序时，JVM也会保留该Annotation，程序**可以通过反射获取该Annotation信息**。此Annotation类型的信息保留在源文件（\*.java）、类文件（\*.class）中，在执行时也会加载到JVM中。
```java
@Rentention(RententionPolicy.SOURCE)
public @interface Testable {}
```
上面的代码并没有使用“value=name”的形式。因为**如果使用注解时只需要为value元素指定值，则使用注解时可以直接在该注解后的括号里指定value成员变量的值，无需使用“value=name”的形式**。

Java内建的Annotation的范围：

- @Override定义采用的是@Retention(value=SOURCE)，只能在源文件中出现；
- @Deprecated定义采用的是@Retention(value=RUNTIME)，可以在运行时出现；
- @SuppressWarnings定义采用的是@Retention(value=SOURCE)，只能在源文件中出现。

下面定义了一个在RUNTIME范围内有效的Annotation：
```java
package com.rosydawn.annotationdemo;  
import java.lang.annotation.Retention;  
import java.lang.annotation.RetentionPolicy; 

// 此Annotation在运行时起作用
// 由于只为value元素指定值，所以也可以使用下面的形式
// @Retention(RetentionPolicy.RUNTIME)
@Retention(value=RetentionPolicy.RUNTIME)   
public @interface MyAnnotation {
    public String name() default "rosydawn";  
}  
```
上面定义的Annotation在程序运行时起作用，这是一种比较常见的使用方式，而如果此时将其设置成其他范围，则以后在Annotation的应用中肯定是无法访问到的。**要想让一个Annotation运行时起作用，必须使用Java中的反射机制来根据注解类型进行其他操作**。 
### @Target
@Target的定义如下：

```java
@Documented
@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.ANNOTATION_TYPE)
public @interface Target {
    /**
     * Returns an array of the kinds of elements an annotation type can be applied to
     */
    ElementType[] value();
}
```

@Target元注解（java.lang.annotation.Target）也只能修饰一个Annotation定义，它也只包含一个名为value的元素，表示被其修饰的Annotation能用于修饰哪些声明类型。

没有@Target元注解修饰的注解类型可以用来修饰**除类型参数（type parameter）声明外**的任何声明。如果一个注解类型T使用了@Target元注解修饰，则注解类型T能修饰的声明类型只能是定义在java.lang.annotation.ElementType枚举类里的枚举常量：

- ElementType.ANNOTATION_TYPE：表明该Annotation只能修饰Annotation声明；
- ElementType.CONSTRUCTOR：表明该Annotation只能修饰构造器声明；
- ElementType.FIELD：指定该策略的Annotation只能修饰成员变量声明；
- ElementType.LOCAL_VARIABLE：指定该策略的Annotation只能修饰只能修饰局部变量（包括for循环中的局部变量和try资源块中的资源变量）声明；
- ElementType.METHOD：指定该策略的Annotation只能修饰方法声明；
- ElementType.PACKAGE：指定该策略的Annotation只能修饰包声明；
- ElementType.PARAMETER：指定该策略的Annotation可以修饰参数声明；
- ElementType.TYPE：指定该策略的Annotation能修饰类、接口（包括注解）或枚举声明；
- ElementType.TYPE_PARAMETER：Java 1.8新增。指定该策略的Annotation可以修饰类、接口（包括注解）或枚举声明中的类型参数
- ElementType.TYPE_USE：Java 1.8新增。指定该策略的Annotation能修饰Type类型的声明。有16种类型环境（ type contexts）可应用Type：
  - 声明中：
    1. 类声明中的extends或implements子句中的类型；
    2. 接口声明中的extends子句中的类型；
    3. 方法的返回值类型（包括注解类型元素的类型）；
    4. 方法或构造器的throws子句中类型；
    5. 泛型的类、接口、方法或构造器的类型参数声明的extends子句中类型；
    6. 类或接口（包括枚举常量）中字段声明的类型；
    7. 方法、构造器、Lambda表达式中形参（formal parameter）声明的类型；
    8. 方法接收参数（receiver parameter）的类型；
    9. 局部变量的声明；
    10. 异常参数声明的类型；
  - 表达式中：
    11. 构造器的显式调用语句、类实例创建表达式或方法调用表达式中显式参数列表中的类型；
    12. 在创建非限定类实例的表达式中，作为要初始化的类类型或者作为要初始化的匿名类的直接父类或直接父接口；
    13. 数组创建表达式中的元素类型；
    14. 转换表达式（cast expression）中转换操作符的类型；
    15. 跟随instanceof关系运算符的类型；
    16. 在方法引用表达式中，作为搜索成员方法的引用类型或作为构造用的类类型或数组类型。

上面的16中情形基本上包含了大多数类型声明和一些表达式声明，所以通过为@Target元注解指定ElementType.TYPE_USE可以将注解用到几乎所有用到类型的地方，从而可以让编译器执行更加严格的语法检查，有利于增强程序的健壮性。

可以为一个注解类型多次应用@Target修饰（每次指定一个枚举常量）来指定不同声明类型，但是不能重复指定同一个枚举常量，否则编译出错。与@Retention类似的是，@Target也可以在括号里直接指定value值，无须使用name=value形式。

### @Documented
@Documented的定义如下：

```java
@Documented
@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.ANNOTATION_TYPE)
public @interface Documented {}
```

**如果一个注解类型被@Documented修饰，那么被该注解类型修饰的类型声明将被javadoc工具提取成文档**。

下面代码中@Documeted指定了javadoc工具生成的API文档将提取@Testable的使用信息。

```java
@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.MEHTOD)
// 定义被@Testable注解修饰的方法可被javadoc工具提取到
@Documented
public @interface Testable {}
```
```java
public class MyTest {
	// 使用@Testable修饰的方法
	@Testable
	public void testInfo() {
		System.out.println("测试方法");
	 }
}
```
使用javadoc工具（在Eclipse中可以选中项目，点击菜单栏的Project→Generate Javadoc）为上面MyTest的java源文件生成的API文档中将包含@Testable信息。
### @Inherited
@Inherited元注解的定义如下：

```java
@Documented
@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.ANNOTATION_TYPE)
public @interface Inherited {}
```

如果一个注解类型T被@Inherited元注解修饰了，那么被该注解类型T就可以被自动继承，即被该注解类型T修饰的类的子类将自动具有注解类型T修饰（即使子类没有显式使用注解类型T修饰）。当在一个类A中利用反射查找该类是否具有注解类型T修饰时，如果该类没有显式使用注解类型T修饰，那么会依次查找其父类、间接父类...一直到Object类。如果找到了有注解类型T修饰的父类，那么就表明该类A具有注解类型T修饰；如果找不到有注解类型T修饰的父类，那么就表明该类A没有被注解类型T修饰。

看下面的例子：

```java
@Target(ElementType.TYPE)
@Retention(RetentionPolicy.RUNTIME)
@Inherited
public @interface AutoInheritable {}
```
如果某个类BaseClass使用了@AutoInheritable修饰，那么BaseClass的子类SubClass将自动使用@AutoInheritable修饰。
```java
@Inheritbale
class BaseClass {}

public class SubClass extends BaseClass {
	public static void main(String[] args) {
		// 打印SubClass类是否有@AutoInheritable注解修饰，
      	// 由于其父类具有@AutoInheritable修饰，即使SubClass没有显式使用@AutoInheritable修饰，
      	// 下面也将输出ture
		System.out.println(SubClass.class.isAnnotationPresent(AutoInheritable.class));
	}
}
```

### @Native

 @Native元注解的定义如下：

```java
@Documented
@Target(ElementType.FIELD)
@Retention(RetentionPolicy.SOURCE)
public @interface Native {}
```

@Native元注解是Java 8新增的一个注解，表明一个常量字段可能会被本地代码（native code）引用。该注解可被生成本地头文件的工具用作提示，用来确定是否需要一个头文件，如果需要，就提示应该包含哪些声明。该注解只有在进行本地编码（native code）会用到。

### @Repeatable

@Repeatable元注解的定义如下：

```java
@Documented
@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.ANNOTATION_TYPE)
public @interface Repeatable {
    /**
     * Indicates the <em>containing annotation type</em> for the
     * repeatable annotation type.
     * @return the containing annotation type
     */
    Class<? extends Annotation> value();
}
```

@Repeatable元注解是Java 8新增的。在Java 8以前，对同一个元素使用多个相同类型的注解需要使用数组形式：

```java
@Results({@Result(name="failure", location="failed.jsp"), @Result(name="success", location="success.jsp")})
public Action FooAction{ ... }
```

从Java 8开始，如果一个注解类型T被@Repeatable元注解修饰，且该@Repeatable元注解的value元素值为包含多个注解类型T的注解类型TC，那么该类型注解T就是可重复使用的。其中注解类型TC作为注解类型T的“容器”须满足以下条件：

- 注解类型TC必须声明一个仅且一个返回值是T[]的value()方法；
- 注解类型TC中除value()方法之外的其他方法必须具有默认值；
- 注解类型TC的保留时间必须通过@Retention元注解显式或隐式地指定为不短于注解类型T的保留时间；
- 可应用注解类型T的程序单元种类至少要与注解类型TC相同。特别地，如果可应用注解类型T的程序单元的种类的集合为m1，可应用注解类型TC的程序单元的种类的集合为m2，m2中的每一个类型都必须出现在m1中，除了以下情形：
  - 如果m2中的类型有java.lang.annotation.ElementType.ANNOTATION_TYPE，那么m1中至少要有java.lang.annotation.ElementType.ANNOTATION_TYPE、java.lang.annotation.ElementType.TYPE、java.lang.annotation.ElementType.TYPE_USE之一；
  - 如果m2中的类型有java.lang.annotation.ElementType.TYPE，那么m1中至少要有java.lang.annotation.ElementType.TYPE、java.lang.annotation.ElementType.TYPE_USE之一；
  - 如果m2中的类型有java.lang.annotation.ElementType.TYPE_PARAMETER，那么m1中至少要有java.lang.annotation.ElementType.TYPE_PARAMETER、java.lang.annotation.ElementType.TYPE_USE之一；
- 如果注解类型T使用了@Documented元注解修饰，那么注解类型TC也必须使用@Documented元注解修饰。如果注解类型T没有使用了@Documented元注解修饰，注解类型TC也可以使用@Documented元注解修饰；
- 如果注解类型T使用了@Inherited元注解修饰，那么注解类型TC也必须使用@Inherited元注解修饰。如果注解类型T没有使用了@Inherited元注解修饰，注解类型TC也可以使用@Inherited元注解修饰；

> 注意：
>
> 1. 一个注解类型不能指定自身作为其注解类型的容器，两个注解类型也不能指定彼此作为自己的注解类型的容器；
> 2. 一个注解类型T的容器TC可以**有**自己的注解类型容器TC`，也就是说该注解类型容易它自身也是一个可重复的注解类型；
> 3. 如果一个注解类型T的容器TC过时了（通过@Deprecated修饰了），那么使用注解类型T就会抛出过时异常（即使注解类型T没有显式使用@Deprecated修饰）。强烈不建议这么做。


@Repeatable实例如下：

首先定义一个@Profession注解。

```java
// 指定该注解信息会保留到运行时
@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.TYPE)
@Repeatable(Professions.class)
public @interface Profession {
	// 为该注解定义2个元素
	String name() default "John";
	int age();
}
```

为了使该注解可以对同一个对象重复使用，创建@Profession注解时必须使用@Repeatable修饰该注解，对应的value元素得是一个可以包含多个@Profession注解的“容器”注解。因此，还需要创建一个可以包含多个@Profession注解的“容器”注解：

```java
// 指定该注解信息会保留到运行时
@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.TYPE)
public @interface Professions {
	// 定义value元素，该元素可接受多个@Profession注解
	Profession[] value();
}
```

这样就可以使用Java 8新增的重复注解语法：

```java
@Profession(age=30)
@Profession(name="Bob", age=25)
```

也可以继续使用以前的“容器”语法：

```java
@Profession({@Profession(age=27), @Profession(name="Alex"， age=30)})
```

下面的程序演示了重复注解的本质：

```java
@Profession(age=28)
@Profession(name="David" , age=29)
// @Profession({@Profession(age=28), @Profession(gender="female" , age=29)})
public class ProfessionTest {
	public static void main(String[] args) {
		Class<ProfessionTest> clazz = ProfessionTest.class;
		/* 使用Java 8新增的getDeclaredAnnotationsByType()方法获取
			修饰ProfessionTest类的多个@Profession注解 */
		Profession[] professions = clazz.getDeclaredAnnotationsByType(Profession.class);
		// 遍历修饰ProfessionTest类的多个@Profession注解
		for(Profession profession : professions) {
			System.out.println(profession.name() + "-->" + profession.age());
		}
		/* 使用传统的getDeclaredAnnotation()方法获取
			修饰ProfessionTest类的@Professions注解 */
		Professions container = clazz.getDeclaredAnnotation(Professions.class);
		System.out.println(container);
	}
} 
```

上面程序依然可以获得@Professions注解可以看出**重复注解只是老语法的简化，重复注解依然会被当成是“容器”注解的value成员变量的数组元素**。

## 使用自定义Annotation

### 自定义Annotation
 使用@interface关键字来定义新的Annotation，如： 
```java
 public @interface Test {
 }
```
定义了该Annotation之后可以在程序的任何地方使用该Annotation，默认情况下，该Annotation可用于修饰任何程序元素，包括类、接口和方法等。通常把Annotation放在所有修饰符之前，并且单独一行。如：
```java
@Test
public class MyClass {
	...
}
```
Annotation还可以带零到多个元素。元素在Annotation定义中以无形参方法的形式来声明，其方法名和返回值定义了该元素的名字和类型。如：
```java
public @interface MyTag {
	//定义带两个元素的Annotation
	//Annotation的元素以方法的形式来定义
	String name();
	int age();
}
```
一旦定义了元素之后就应该在使用该Annotation时给其元素指定值（或者不显式指定值而使用默认值）。如：
```java
public class Test {
	//使用带有元素的Annotation时应该为其元素赋值
	@MyTag(name="xx", age=6)
	public void info() {
	}
}
```
也可以在定义Annotation时为其元素通过default关键字指定默认值。如：
```java
public @interface MyTag {
	//定义带有成员变量的Annotation时应该为其元素指定默认初始值
	String name() default "xx";
	int age()  default 6;
}
```
这样就可以在使用该Annotation时不显式指定值，而使用默认值。如：
```java
public class Test {
	//使用有默认值的元素的Annotation时不显式指定值，而使用默认值
	@MyTag
	public void info() {
	}
}
```
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
- default booleanisAnnotationPresent(Class<? extends Annotation> annotationClass)：返回该程序元素上是否存在指定类型的注解；
- default<T extends Annotation> T[] getAnnotationsByType(Class<T> annotationClass)：该方法与前面的getAnnotation()方法类似。由于Java8新增了重复注解，此方法用于返回修饰该程序元素、指定类型的多个Annotation；
- default<T extends Annotation>T[] getDeclaredAnnotationsByType(Class<T> annotationClass)：该方法与前面的getDeclaredAnnotation()方法类似。由于Java8新增了重复注解，此方法用于返回直接修饰该程序元素、指定类型的多个Annotation。

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
		catch (Exception e)	{
			e.printStackTrace();
		}
	}
}
```
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



