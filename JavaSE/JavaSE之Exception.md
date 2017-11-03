---
typora-root-url: ..\..\graphs\photos
typora-copy-images-to: ..\..\graphs\photos
---

## 异常的分类

Java 通过API中**Throwable 类**的众多子类描述各种不同的异常。因而，**Java 异常都是对象，是 Throwable（可抛出）类的实例**，描述了出现在一段编码中的错误条件。当错误条件生成时，将引发异常。

![Exceptions](/Exceptions.png)

Throwable：有两个重要的子类：Exception（异常）和 Error（错误）。

**Error 类表示程序无法处理的错误**，表示运行应用程序中较严重问题。大多数错误与代码编写者执行的操作无关，而表示代码运行时 JVM 出现的问题 ，这些异常发生时，JVM 一般会选择线程终止 。**这些错误表示故障发生于虚拟机自身、或者发生在虚拟机试图执行应用时** ，**这些错误是不可查的，因为它们在应用程序的控制和处理能力之外**。对于设计合理的应用程序来说，**即使确实发生了错误，本质上也不应该试图去处理它所引起的异常状况**。

**Exception 类表示程序本身可以处理的异常**。Exception 类有一个重要的子类 RuntimeException 。RuntimeException 类及其子类表示 `JVM 常用操作` 引发的错误。例如，若试图使用空值对象引用、除数为零或数组越界，则分别引发NullPointerException、ArithmeticException 和 ArrayIndexOutOfBoundException。

> 注意：**异常和错误的区别：异常能被程序本身可以处理，错误是无法处理**。

Java 的异常(包括 Exception 和 Error )分为**可查的异常（checked exceptions）和不可查的异常（unchecked exceptions）** 。

可查异常 （**编译器要求必须处置的异常**，只有 Java 才提供了 Checked 异常）：**除了 RuntimeException 及其子类、Error 以外，其他的 Exception 类及其子类都属于可查异常**。正确的程序在运行中，很容易出现的、情理可容的、可以预计的异常状况，必须采取某种方式进行处理 。**可查异常的特点是 Java 编译器会检查它，当程序中可能出现可查异常时，要么用 try-catch 语句捕获它，要么用 throws 子句声明抛出它，否则编译不会通过**。 

**不可查异常** （**编译器不要求强制处置的异常**）包括**运行时异常** （RuntimeException与其子类）和**错误** （Error）。

**运行时异常都是 RuntimeException 类及其子类异常**，如NullPointerException（空指针异常）、IndexOutOfBoundsException（下标越界异常）等，这些异常是不可查异常。**程序中可以选择捕获处理运行时异常，也可以不处理。这些异常一般是由程序逻辑错误引起的，程序员应该从逻辑角度尽可能避免这类异常的发生。运行时异常的特点是 Java 编译器不会检查它，也就是说，当程序中可能出现这类异常，即使没有用 try-catch 语句捕获它，也没有用 throws 子句声明抛出它，也会编译通过**。

## 处理异常方式

在Java应用程序中，异常处理机制为： 抛出异常、捕捉异常 。

**抛出异常**：当一个方法出现错误引发异常时，方法创建异常对象并交付运行时系统，异常对象中包含了异常类型和异常出现时的程序状态等异常信息。运行时系统负责寻找处置异常的代码并执行。

**捕获异常** ：在方法抛出异常之后，运行时系统将转为寻找合适的异常处理器（exception handler）。潜在的异常处理器是异常发生时依次存留在调用栈中的方法的集合。当异常处理器所能处理的异常类型与方法抛出的异常类型相符时，即为合适的异常处理器。运行时系统从发生异常的方法开始，依次回查调用栈中的方法，直至找到含有合适异常处理器的方法并执行。当运行时系统遍历调用栈而未找到合适的异常处理器，则运行时系统终止。同时，意味着Java程序的终止。

对于运行时异常、错误和可查异常 ，Java技术所要求的异常处理方式有所不同。

由于运行时异常的不可查性，为了更合理、更容易地实现应用程序，**Java 规定，运行时异常将由 Java 运行时系统自动抛出，允许应用程序忽略运行时异常**。

**对于方法运行中可能出现的 Error ，当运行方法不欲捕捉时，Java 允许该方法不做任何抛出声明**。因为，大多数Error异常属于永远不能被允许发生的状况，也属于合理的应用程序不该捕捉的异常。

**对于所有的可查异常，Java 规定一个方法必须显式捕捉可查异常，或者将可查异常声明为抛出到方法之外**。也就是说，当一个方法选择不捕捉可查异常时，它必须声明将抛出异常。

能够捕捉异常的方法，需要提供相符类型的异常处理器。所捕捉的异常，可能是由于自身语句所引发并抛出的异常，也可能是由某个调用的方法或者 Java 运行时系统等抛出的异常。也就是说，一个方法所能捕捉的异常，一定是 Java 代码在某处所抛出的异常。简单地说，异常总是先被抛出，后被捕捉的。任何 Java 代码都可以抛出异常，如：自己编写的代码、来自Java开发环境包中代码，或者 Java 运行时系统。

捕捉异常通过 try-catch 语句或 try-catch-finally 语句实现。

总体来说，**Java 规定： 对于可查异常必须捕捉、或者声明抛出。允许忽略不可查的 RuntimeException 和 Error**。

### 捕获异常

#### try-catch 语句

其一般语法形式为：

```java
try {  
    // 可能会发生异常的程序代码  
} catch (ExceptionType1 id1){  
    // 捕获并处置try抛出的异常类型Type1  
} catch (ExceptionType2 id2){  
     //捕获并处置try抛出的异常类型Type2  
}  
```

关键词 try 后的一对大括号将一块可能发生异常的代码包起来，称为**监控区域**。Java 方法在运行过程中出现异常，则创建异常对象。将异常抛出监控区域之外，由 Java 运行时系统试图寻找匹配的 catch 子句以捕获异常。 若有匹配的 catch 子句，则运行其异常处理代码，然后 try-catch 语句结束 。

如果抛出的异常对象属于某个 catch 子句中的异常类 ，或者属于该异常类的子类 ，则认为生成的异常对象与该 catch 块捕获的异常类型相匹配。

例1，捕捉throw语句抛出的“除数为0”异常。

```java
public class TestException {  
    public static void main(String[] args) {  
        int a = 6;  
        int b = 0;  
        try { // try监控区域  if (b == 0) throw new ArithmeticException(); // 通过throw语句抛出异常  
            System.out.println("a/b的值是：" + a / b);  
        }  
        catch (ArithmeticException e) { // catch捕捉异常  
            System.out.println("程序出现异常，变量b不能为0。");  
        }  
        System.out.println("程序正常结束。");  
    }  
}  
```

运行结果：

```shell
程序出现异常，变量b不能为0。
程序正常结束。
```

> 注意：“除数为0”等 ArithmeticException，是 RuntimException 的子类。而运行时异常将由运行时系统自动抛出，不需要使用 throw 语句。

例2，捕捉运行时系统自动抛出“除数为0”引发的 ArithmeticException 异常。

```java
 public static void main(String[] args) {  
        int a = 6;  
        int b = 0;  
        try {  
            System.out.println("a/b的值是：" + a / b);  
        } catch (ArithmeticException e) {  
            System.out.println("程序出现异常，变量b不能为0。");  
        }  
        System.out.println("程序正常结束。");  
    }  
}  
```

运行结果： 

```shell
程序出现异常，变量b不能为0。
程序正常结束。
```

运行时系统创建异常对象并抛出监控区域，转而匹配合适的异常处理器 catch，并执行相应的异常处理代码。**由于检查运行时异常的代价远大于捕捉异常所带来的益处，运行时异常不可查**。Java 编译器允许忽略运行时异常，一个方法可以既不捕捉，也不声明抛出运行时异常 。

例3，不捕捉、也不声明抛出运行时异常。

```java
public class TestException {  
    public static void main(String[] args) {  
        int a, b;  
        a = 6;  
        b = 0; // 除数b的值为0  
        System.out.println(a / b);  
    }  
}  
```

运行结果：

```shell
Exception in thread "main" java.lang.ArithmeticException: / by zero at Test.TestException.main(TestException.java:8)try－catch-finally语句
```

try-catch 语句还可以包括第三部分，就是 **finally 子句，它表示无论是否出现异常，都应当执行的内容**。try-catch-finally语句的一般语法形式为：

```java
try {  
    // 可能会发生异常的程序代码  
} catch (Type1 id1) {  
    // 捕获并处理try抛出的异常类型Type1  
} catch (Type2 id2) {  
    // 捕获并处理try抛出的异常类型Type2  
} finally {  
    // 无论是否发生异常，都将执行的语句块  
}  
```

例5，带 finally 子句、嵌套的异常处理程序。

```java
public class FinallyTest {
	public static void main(String[] args) {
		FileInputStream fis = null;
		try	{
			fis = new FileInputStream("a.txt");
		}
		catch (IOException ioe)	{
			System.out.println(ioe.getMessage());
			// return语句强制方法返回
			return;
			// 使用exit来退出虚拟机
			// System.exit(1);
		}
		finally	{
			// 关闭磁盘文件，回收资源
			if (fis != null) {
				try	{
					fis.close();
				}
				catch (IOException ioe)	{
					ioe.printStackTrace();
				}
			}
			System.out.println("执行finally块里的资源回收!");
		}
	}
}
```

**小结**：

**try 块**：用于捕获异常，**其{}不可省略**，即使try块只有一条语句也不行。**其内定义的变量是代码块局部变量，在 catch 块中不可访问**。其后可接零个或多个 catch 块，如果没有 catch 块，则必须跟一个 finally 块，finally 块必须位于最后。

**catch 块**：用于处理 try 捕获到的异常，其{}也不可省略。

**finally 块**：**不管相关的 try 块中是否出现异常，也不管哪一个相关的 catch 块被执行，甚至在 try 块或 catch 块中遇到 return 语句时，相关的 finally 语句块都将在方法返回之前被执行，通常用于回收再 try 块里开启的物理资源**（如数据库连接、网络连接和磁盘文件等，这些物理资源必须显式回收，垃圾回收机制不会回收它们，垃圾回收机制只回收堆内存中的信息）。但是，在**以下 4 种特殊情况下，finally 块不会被执行**：

1. **在 finally 语句块中发生了异常。尽量避免在 finally 块中使用 return 或 throw 等导致方法终止的语句，否则会导致 try 块、catch 块中的 return、throw 语句失效**；
2. **在前面的代码中用了 System.exit(int) 退出虚拟机**；
3. **程序所在的线程死亡**；
4. **关闭 CPU**。

#### Java 7 新增的自动关闭资源的 try 语句

Java 7 增强了 try 语句的功能：**可以在 try 关键字后面加一对圆括号，把需要显式回收的多个物理资源的声明、初始化语句放在此圆括号里，try 语句可以在该语句结束时自动关闭这些资源。这就要求这些资源类实现 AutoCloseable 接口（其close() 方法抛出 Exception对象）或者 Closeable 接口（AutoCloseable 接口的子接口，其 close() 方法抛出 IOException对象），实现这两个接口就必须实现 close() 方法。Java 7 几乎把所有的资源类（包括文件 IO 的各种类、JDBC 变成的ConnectionStatement 等接口）进行了改写，改写后这些资源类都实现了 AutoCloseable 或 Closeable 接口**。

**例6 Java 7 自动关闭资源的 try() 语句**

```java
public class AutoCloseTest {
	public static void main(String[] args) throws IOException {
		try (
			// 声明、初始化两个可关闭的资源
			// try 语句会自动关闭这两个资源。
			BufferedReader br = new BufferedReader(new FileReader("AutoCloseTest.java"));
			//最后一条语句后没有英文分号
          	PrintStream ps = new PrintStream(new FileOutputStream("a.txt"))) {
			// 使用两个资源
			System.out.println(br.readLine());
			ps.println("庄生晓梦迷蝴蝶");
		}
	}
}
```

**由于自动回收资源的 try() 语句包含隐式的 finally 块，所以没有显式的 catch 块和 finally 块也可以**。

try-catch-finally 规则( [异常处理语句的语法规则 ](http://book.51cto.com/art/201009/227791.htm)）：

1. 必须在 try 之后添加 catch 或 finally 块。try 块后可同时接 catch 和 finally 块，但至少有一个块；
2. 必须遵循块顺序：若代码同时使用 catch 和 finally 块，则必须将 catch 块放在 try 块之后；
3. catch 块与相应的异常类的类型相关；
4. 一个 try 块可能有多个 catch 块。若如此，则执行第一个匹配的 catch 块。即 Java 虚拟机会把实际抛出的异常对象依次和各个 catch 代码块声明的异常类型匹配，如果异常对象为某个异常类型或其子类的实例，就执行这个 catch 代码块， 不会再执行其他的 catch 代码块，除非在循环中使用了 continue 开始下一次循环，下一次循环又重新运行了 try 块；
5. 可在 try 块、catch 块、finally 块中包含完整异常处理流程的情形称为异常处理的嵌套，虽然没有对嵌套的层数做限定，但是一般不超过 2 层，否则没有必要而且可读性低；
6. 在 try-catch-finally 结构中，可重新抛出异常；
7. 除了下列情况，总将执行finally做为结束：
   - JVM 过早终止（调用 System.exit(int)）；
   - 在 finally 块中抛出一个未处理的异常；
   - 计算机断电、失火、或遭遇病毒攻击。

#### try、catch、finally 语句块的执行顺序:

1. 当try没有捕获到异常时：try语句块中的语句逐一被执行，程序将跳过catch语句块，执行finally语句块和其后的语句；
2. 当try捕获到异常，catch语句块里没有处理此异常的情况：当try语句块里的某条语句出现异常时，而没有处理此异常的catch语句块时，此异常将会抛给JVM处理，finally语句块里的语句还是会被执行，但finally语句块后的语句不会被执行；
3. 当try捕获到异常，catch语句块里有处理此异常的情况：在try语句块中是按照顺序来执行的，当执行到某一条语句出现异常时，程序将跳到catch语句块，并与catch语句块逐一匹配，找到与之对应的处理程序，其他的catch语句块将不会被执行，而try语句块中，出现异常之后的语句也不会被执行，catch语句块执行完后，执行finally语句块里的语句，最后执行finally语句块后的语句。

> **finally 块总会被执行，不管有无异常出现，即使出现 Error 也照样会被执行**。

需要注意的是，一旦某个 catch 捕获到匹配的异常类型，将进入异常处理代码。 一经处理结束，就意味着整个try-catch语句结束。其他的catch子句不再有匹配和捕获异常类型的机会。对于有多个catch子句的异常程序而言，应该先处理小异常，再处理大异常，尽量将捕获底层异常类(子类异常)的catch子句放在前面，同时尽量将捕获相对高层的异常类(父类异常)的catch子句放在后面。否则，捕获底层异常类的catch子句将可能会被屏蔽。另外，**从Java7开始，一个catch块可以捕获多个异常，但是多种异常类型之间应该使用竖线（|），捕获多种异常时，异常变量有隐式的final修饰，不可在对异常变量赋值**。如：

```java
catch (IndexOutOfBoundsException | NumberFormatException ie) {
    System.out.println("出现了数组越界异常或者数字格式异常");
    //下面代码有错
    ie = new ArithmeticException("test");
}
```

try、catch、finally 语句块的执行：

![trycatch](/trycatch.png)

### 抛出异常

#### throws 抛出异常

任何Java代码都可以抛出异常，如：自己编写的代码、来自Java开发环境包中代码，或者Java运行时系统。无论是谁，都可以通过Java的throws语句抛出异常。从方法中抛出的任何异常都必须使用throws子句。如果一个方法可能会出现异常，但没有能力处理这种异常，可以在方法声明处用throws子句来声明抛出异常。例如汽车在运行时可能会出现故障，汽车本身没办法处理这个故障，那就让开车的人来处理。一旦使用了throws语句声明抛出异常，就无须使用try-catch块来捕获该异常了。throws语句用在方法定义时声明该方法要抛出的异常类型，可以抛出多个异常，多个异常之间使用逗号分割。throws语句的语法格式为：

```java
methodname throws Exception1,Exception2,..,ExceptionN  {
  
} 
```

当方法抛出异常列表的异常时， 方法将不对这些类型及其子类类型的异常作处理，而抛向调用该方法的方法或对象 ，由他去处理。例如：

```java
import java.lang.Exception;  
public class TestException {  
    static void pop() throws NegativeArraySizeException {  
        // 定义方法并抛出NegativeArraySizeException异常  int[] arr = new int[-3]; // 创建数组  
    }  
  
    public static void main(String[] args) { // 主方法  try { // try语句处理异常信息  
            pop(); // 调用pop()方法  
        } catch (NegativeArraySizeException e) {  
            System.out.println("pop()方法抛出的异常");// 输出异常信息  
        }  
    }   
}  
```

使用throws关键字将异常抛给调用者后，如果调用者不想处理该异常，可以继续向上抛出，如果抛到main方法时依然无法处理，就抛给JVM处理，JVM打印异常的跟踪栈信息，并终止程序运行。最终要有能够处理该异常的调用者 。

#### throws 抛出异常的规则：

1) 如果是不可查异常（unchecked exception），即 Error、RuntimeException或它们的子类 ，那么可以不使用throws关键字来声明要抛出的异常，编译仍能顺利通过，但在运行时会被系统抛出；

2) 必须声明方法可抛出的任何可查异常 （checked exception）。即如果一个方法可能出现可查异常，要么用try-catch语句捕获 ，要么用throws子句声明将它 抛出 ，否则会导致编译错误；

3) 当抛出了异常，该方法的调用者才必须处理或者重新抛出该异常。当方法的调用者无力处理该异常的时候，应该继续抛出，而不是囫囵吞枣；

4）若覆盖父类的一个方法，则不能声明类型超过覆盖方法所抛出的异常。声明的任何异常必须是被覆盖方法所声明异常的同类或子类；

5）一般推荐使用Runtime异常，而不是Checked异常。使用Checked异常则更加严谨，但是烦琐。Checked异常要么必须显式捕获并处理，要么显式抛出交给其所在方法的调用者处理，显式抛出异常时如果是重写父类方法，还会受到父类被重写方法所抛出异常类型的限制。而使用Runtime异常则更加自由灵活，既可以不用声明抛出Checked异常而在出现错误时抛出Runtime异常即可，如果有需要，也可以显式捕获该Runtime异常并对异常进行处理。

#### 使用 throw 抛出异常

throw(后面没有s)总是出现在函数体中，用来抛出一个仅且一个Throwable 或者其子类型的异常实例。 程序会在throw语句后立即终止，它后面的语句执行不到 ，然后在包含它的所有try块中（可能在上层调用函数中）从里向外寻找含有与其匹配的catch子句的try块。

异常是异常类的实例对象，可以创建异常类的实例对象通过throw语句抛出。该语句的语法格式：

```java
throw Exception Instance;
```

例如抛出一个IOException类的异常对象：  throw new IOException("IO异常");

如果throw抛出了CheckedException，则该throw要么在try块里，通过catch块显式捕获该异常，要么放在带throws声明（throws语句再次抛出可能出现的异常）的方法中，把该异常交给该方法的调用者处理。如果所有方法都层层上抛获取的异常，最终JVM会进行处理，处理也很简单，就是打印异常消息和堆栈信息。

如果throw抛出的是RuntimeException，则该语句无须使用try-catch块里显式捕获处理该异常，也无须在放在带throws声明抛出的方法中而不理会该异常，把该异常交给该方法的调用者处理。

```java
public class ThrowTest {
	public static void main(String[] args) {
		try	{
			// 调用声明抛出Checked异常的方法，要么显式捕获该异常
			// 要么在main方法中再次声明抛出
			throwChecked(-3);
		}
		catch (Exception e)	{
			System.out.println(e.getMessage());
		}
		// 调用声明抛出Runtime异常的方法既可以显式捕获该异常，
		// 也可不理会该异常
		throwRuntime(3);
	}
	public static void throwChecked(int a)throws Exception {
		if (a > 0) {
			// 自行抛出Exception异常
			// 该代码必须处于try块里，或处于带throws声明的方法中
			throw new Exception("a的值大于0，不符合要求");
		}
	}
	public static void throwRuntime(int a) {
		if (a > 0)	{
			// 自行抛出RuntimeException异常，既可以显式捕获该异常
			// 也可完全不理会该异常，把该异常交给该方法调用者处理
			throw new RuntimeException("a的值大于0，不符合要求");
		}
	}
}
```

catch 和 throw 配合使用：如果当前 catch 处理异常时又出现了新的异常，可以将新的异常再次抛出，交给方法的调用者处理。如：

```java
public class AuctionTest {
	private double initPrice = 30.0;
	// 因为该方法中显式抛出了AuctionException异常，
	// 所以此处需要声明抛出AuctionException异常
	public void bid(String bidPrice) throws AuctionException {
		double d = 0.0;
		try	{
			d = Double.parseDouble(bidPrice);
		}
		catch (Exception e)	{
			// 此处完成本方法中可以对异常执行的修复处理，
			// 此处仅仅是在控制台打印异常跟踪栈信息。
			e.printStackTrace();
			// 再次抛出自定义异常
			throw new AuctionException("竞拍价必须是数值，"
				+ "不能包含其他字符！");
		}
		if (initPrice > d)	{
			throw new AuctionException("竞拍价比起拍价低，"
				+ "不允许竞拍！");
		}
		initPrice = d;
	}
	public static void main(String[] args)	{
		AuctionTest at = new AuctionTest();
		try	{
			at.bid("df");
		}
		catch (AuctionException ae)	{
			// 再次捕捉到bid方法中的异常。并对该异常进行处理
			System.err.println(ae.getMessage());
		}
	}
}
```

**从 Java 7 开始，编译器会执行更加严格地检查 throw 语句抛出的异常实际类型**，如：

```java
public static void main(String[] args) throws FileNotFoundException {
		// Java 6 认为“throw ex”代码可能抛出 Exception，
		// 所以在 Java 6 中该方法声明中应抛出 Exception，应使用 throws Exception;
		// 而 Java 7 会检查“throw ex”代码可能抛出异常的实际类型，
		// 因此，此处只需声明抛出FileNotFoundException即可。
		try	{
			new FileOutputStream("a.txt");
		}
		catch (Exception ex) {
			ex.printStackTrace();
			throw ex;
		}
	}
```

## 异常链

企业级应用常常有严格的分层关系，层与层之间划分明确，上层依赖于下层，不能跨层访问。如果底层出现了原始异常（包含对开发者的提示的信息，提供给用户会不友好，也不安全），通常做法是，程序先捕获原始异常，然后抛出一个新的业务异常（包含对用户的提示信息），这种处理方式称为异常转译。这种把捕获一个异常然后接着抛出另一个异常，并把原始信息保留下来的方式是23种设计模式中的职责链模式，也被称为异常链。从 JDK 1.4 开始，Throwable 基类有了一个可以接收 Throwable clause 参数的构造器，，这样可以把原始异常传递给新的异常再次抛出。如：

```java
public calSal() throws SalException {
    try {
            //实现工资结算业务逻辑
            ... 
    }
    catch(SqlException sql) {    
        //保存原始异常信息，针对管理员
        ....
        //抛出新的异常
        throw new SalException(sql);
    }
    catch(Exception e) {
    //保存异常信息
    ...
    //抛出针对用户的异常，交给调用者处理
    throw new SalException(e);
}
```

## Throwable 类中的常用方法

注意：catch 关键字后面括号中的 Exception 类型的参数 e ，e 就是 try 代码块传递给 catch 代码块的异常实例对象。通常异常处理常用 3 个函数来获取异常的有关信息：

- getCause()： 返回抛出异常的原因。如果 cause 不存在或未知，则返回 null；
- getMeage()： 返回异常的详细描述字符串；
- getStackTrace()：返回该异常的跟踪栈信息；
- printStackTrace()： 将对象的堆栈跟踪信息输出至标准错误输出，作为字段 System.err 的值。可以根据打印的异常跟踪栈信息找到异常的源头。在发布版本中就不要再使用该方法了，而是应该将异常妥善处理；
- printStackTrace(PrintStream s)：将对象的堆栈跟踪信息输出至指定输出流；

有时为了简单会忽略掉 catch 语句后的代码，这样 try-catch 语句就成了一种摆设，一旦程序在运行过程中出现了异常，就会忽略处理异常，而错误发生的原因很难查找。

## Java 常见异常

在 Java 中提供了一些异常用来描述经常发生的错误，对于这些异常，有的需要程序员进行捕获处理或声明抛出，有的是由 Java 虚拟机自动进行捕获处理。Java 中常见的异常类：

#### RuntimeException 子类:

- java.lang.ArrayIndexOutOfBoundsException，数组索引越界异常。当对数组的索引值为负数或大于等于数组大小时抛出；
- java.lang.ArithmeticException，算术条件异常。譬如：整数除零等；
- java.lang.NullPointerException。空指针异常。当应用试图在要求使用对象的地方使用了 null 时，抛出该异常。譬如：调用 null 对象的实例方法、访问 null 对象的属性、计算 null 对象的长度、使用 throw 语句抛出 null 等等；
- java.lang.ClassNotFoundException，找不到类异常。当应用试图根据字符串形式的类名构造类，而在遍历CLASSPAH 之后找不到对应名称的 class 文件时，抛出该异常；
- java.lang.NegativeArraySizeException ，数组长度为负异常；
- java.lang.ArrayStoreException，数组中包含不兼容的值抛出的异常；
- java.lang.SecurityException，安全性异常；
- java.lang.IllegalArgumentException 非法参数异常；

#### IOException

- IOException，操作输入流和输出流时可能出现的异常；
- EOFException ，文件已结束异常；
- FileNotFoundException，文件未找到异常。

#### 其他异常

- ClassCastException，类型转换异常类；
- ArrayStoreException，数组中包含不兼容的值抛出的异常；
- SQLException，操作数据库异常类；
- NoSuchFieldException，字段未找到异常；
- NoSuchMethodException，方法未找到抛出的异常；
- NumberFormatException，字符串转换为数字抛出的异常；
- StringIndexOutOfBoundsException，字符串索引超出范围抛出的异常；
- IllegalAccessException，不允许访问某类异常；
- InstantiationException，当应用程序试图使用 Class 类中的 newInstance() 方法创建一个类的实例，而指定的类对象无法被实例化时，抛出该异常。

### 异常处理的目标

- 使程序代码混乱最小化；
- 捕获并保留诊断信息；
- 通知合适的开发人员；
- 采用合适的方式结束异常活动。

达到以上目标需要遵循**异常处理原则**：

- 不要过度使用异常。不要把普通错误当成异常，普通错误应该编写错误处理代码，而不是当成异常简单抛出。只有对外部的、不能确定和预知的运行时错误才使用异常。不应该使用异常来代替正常的流程控制。异常处理的初衷是将异常处理代码和正常流程分离，而且异常处理的效率低于正常的控制流程；
- 不要使用过大的 try 块。try 块越大，出现异常的可能性越大，后面的 catch 块就越多，可读性也很差；
- 避免使用 catch all 语句。一次捕获所有异常(catch (Throwable e))，这样做会使不同的异常不能得到对应的何时处理，如果要分情况处理还要在 catch 块中使用分支语句，得不偿失。这样也可能捕获到一些错误（Error）、从而看不到正常的异常；
- 不要忽略捕获到的异常。理应对捕获到的异常进行处理，而不是置之不理。对于捕获到的异常：
  - 处理异常。对异常进行修复，然后绕过异常发生的地方继续执行，或者用别的数据计算来替换原来的返回值，或者提示用户重新操作.....总之，应该处理 Checked 异常；
  - 重新抛出新的异常。尽量昨晚当前层的任务，然后进行异常转译，把异常包装成当前层的异常，重新抛出给上层调用者；
  - 在何时的层处理异常。如果当前层不知道如何处理异常，就显式抛出该异常给上层调用者处理。

## 使用自定义异常类

使用 Java 内置的异常类可以描述在编程时出现的大部分异常情况。除此之外，用户还可以自定义异常。 **用户自定义异常类，只需继承 Exception 基类，如果自定义 Runtime 异常，那么继承 RuntimeException 基类即可 。自定义异常类需要提供两个构造器，一个无参数构造器，一个是带字符串参数的构造器，这个字符串将作为异常类的 getMessage() 方法的返回值**。

在程序中使用自定义异常类，大体可分为以下几个步骤。

1. 继承 Exception 基类或 RuntimeException 基类来创建自定义异常类；
2. 在应用方法中通过 throw 关键字抛出异常对象；
3. 如果在当前抛出异常的方法中处理异常，可以使用 try-catch 语句捕获并处理。否则，在方法的声明处通过 throws 关键字指明要抛出给方法调用者的异常，继续进行下一步操作；
4. 在出现异常方法的调用者中捕获并处理异常。

自定义可查异常实例：

```java
public class NameNotFoundException extends Exception {
    public NameNotFoundException(String message) {
        super(message);
    }
}
```

```java
public class CustomerService {
    public Customer findByName(String name) throws NameNotFoundException {
        if ("".equals(name)) {
            throw new NameNotFoundException("Name is empty!");
        }
        return new Customer(name);
    }

    public static void main(String[] args) {
        CustomerService obj = new CustomerService();
        try {
            Customer cus = obj.findByName("");
        } catch (NameNotFoundException e) {
            e.printStackTrace();
        }
    }
}
```

自定义不可查异常实例：

```java
public class ListTooLargeException extends RuntimeException{
    public ListTooLargeException(String message) {
        super(message);
    }
}
```

```java
public class CustomerService {
    public void analyze(List<String> data) {
        if (data.size() > 50) {
            //runtime exception
            throw new ListTooLargeException("List can't exceed 50 items!");
        }
		//...
    }

    public static void main(String[] args) {
        CustomerService obj = new CustomerService();
		//create 100 size
        List<String> data = new ArrayList<>(Collections.nCopies(100, "mkyong"));
        obj.analyze(data);
    }
}
```