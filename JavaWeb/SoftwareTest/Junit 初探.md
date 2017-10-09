### JUnit 框架简介

[JUnit](http://junit.org/junit4/) 是 Java 社区中知名度最高的单元测试工具。它诞生于 1997 年，由 Erich Gamma 和 Kent Beck 共同开发完成。其中 Erich Gamma 是经典著作《设计模式：可复用面向对象软件的基础》一书的作者之一（ one of the `"Gang of Four"`），并在 Eclipse 中有很大的贡献；Kent Beck 则是一位极限编程（XP）方面的专家和先驱。

麻雀虽小，五脏俱全。JUnit 设计的非常小巧，但是功能却非常强大。Martin Fowler 如此评价 JUnit：在软件开发领域，从来就没有如此少的代码起到了如此重要的作用。它大大简化了开发人员执行单元测试的难度，特别是 JUnit 4 使用 Java 5 中的注解（annotation）使测试变得更加简单。

Junit 的特性：

- 用于测试期望结果的断言（Assertion）；
- 用于共享共同测试数据的测试工具；
- 用于方便的组织和运行测试的测试套件；
- 图形和文本的测试运行期。

### JUnit 版本选择

JUnit 的最新文档版为4.12，建议使用该版本。其 Maven 依赖如下：

```xml
<dependency>
 	<groupId>junit</groupId>
    <artifactId>junit</artifactId>
	<version>4.12</version>
	<scope>test</scope>
</dependency>
```

JUnit 4.xx 使用了注解、泛型和静态导入等 JDK 1.5 提供的新特性，所以需要 JDK 1.5+ 的支持。而 JUnit 3.xx 需要 JDK 1.2+ 支持。3.xx 版本的 JUnit 一般使用 Junit 3.8.1。

JUnit 自身绑定了一个 hamcrest-core 1.3 的jar包，但不建议使它，最好排除这个jar包，而是使用 hamcrest-library 1.3 的jar包：

```xml
<dependency>
 	<groupId>junit</groupId>
    <artifactId>junit</artifactId>
	<version>4.12</version>
	<scope>test</scope>
	<exclusions>
		<exclusion>
			<groupId>org.hamcrest</groupId>
			<artifactId>hamcrest-core</artifactId>
 		</exclusion>
	</exclusions>
</dependency>
<dependency>
	<groupId>org.hamcrest</groupId>
	<artifactId>hamcrest-library</artifactId>
	<version>1.3</version>
	<scope>test</scope>
</dependency>
```

> JUnit  和 hamcrest 是两个不同的框架，只不过是 JUnit 使用了hamcrest框架而已，hamcrest 可以有效增加 JUnit 的测试能力，用一些相对通俗的语言来进行测试。

###  JUnit 入门实例

看下面的示例代码：

```java
public class Calculator {
    public double add(double number1, double number2) {
        return number1 + number2;
    }
}
```

```java
import static org.junit.Assert.*;
import org.junit.Test;

public class CalculatorTest {
    @Test
    public void testAdd() {
        Calculator calculator = new Calculator();
        double result = calculator.add(10, 50);
        assertEquals(60, result, 0);
    }
}
```

我们为 Calculator 类创建一个对应的测试类 CalculatorTest：**定义一个测试类的要求这个类必须是公共的，且拥有一个可用的无参构造器**。我们可以对它任意命名，但**通常的做法是在类名称的末尾添加“Test"后缀** 。也要注意，虽然在 JUnit 3 中需要让测试类扩展 TestCase 类，但是在 JUnit 4 中，已经不需要这样做了。

接下来，我们在测试类中创建了一个测试方法。**测试方法（也简称为测试）需要使用 `@Test` 注解修饰，且是公共的，不带任何参数，并且返回 void 类型**。因为 JUnit 没有方法名称的限制，所以你可以根据自己喜好命名你的方法，只要该方法拥有了`@Test`  注解，JUnit 就会执行它们。**最好的做法是以 `test` 开头加方法名的模式来命名测试方法**。

然后，我们通过创建 `Calculator` 类的一个实例（被测试的对象）来开始进行测试，接着，通过调用测试方法并传递两个已知值来执行测试。最后，我们调用了**`assertEquals()` 方法来判断预期结果与测试结果是否相等。这个方法是我们使用静态导入的 `org.junit.Assert` 类的一系列静态断言方法之一，静态导入简化了静态方法的调用**。

**如果实际值不等于预期值，那么运行测试类时 JUnit 就会抛出的 `java.lang.AssertionError` 的错误，并给出断言的提示信息，这将导致测试失败。在多数情况下，第三个 delta 参数可以是零，大可放心地忽略它。它总是伴随着非精确计算而出现。delta 参数提供了一个误差范围，如果实际值在 `expected - delta` 和 `expected + deIta` 范围之内，则测试算通过。当进行带有舍入误差或截断误差的数学运算时，或者当断言关于日期相关的条件时，该参数可能就非常有用，因为这些数据的精确度取决于操作系统**。

> 注意：单元测试代码不是用来证明您是对的，而是为了证明您没有错。因此单元测试的范围要全面，比如对边界值、正常值、错误值得测试；对代码可能出现的问题要全面预测，而这也正是需求分析、详细设计环节中要考虑的。

**JUnit 在调用每个测试方法之前会为该方法所在的测试类创建一个新的实例。这有助于使测试方法之间相互独立，并且避免在测试代码中产生意外的副作用。因为每个测试方法都运行于一个新的测试类实例上，所以我们就不能在测试方法之间重用各个实例变量值**。

让我们来看看 JUnit 核心对象：

- 断言：即 Assert，可以让你去定义你想测试的条件，当条件成立时，assert 方法保持沉默，但条件不成立时则抛出异常；
- 测试：一个使用 `@Test` 注解修饰的方法定义了一个测试。为了运行这个方法，JUnit 会创建一个其所在测试类的新实例，然后再调用这个测试方法；
- 测试类：**即 Test class 或 TestCase 或 test case，也称测试用例，是一个包含一个或者多个测试的类**，而这些测试就是指那些用 `@Test` 注解修饰的方法。**使用一个测试类，可以把具有公共行为的测试归为一组，通常在生产类和测试类之间都存在着一对的对关系**；
- 测试集：**即 test suite 或 Suite，又叫测试套件，是指一组测试**。测试集是一种把多个测试归入一组的便捷方式。比如，**如果你没有为测试类定义一个测试集，那么 JUnit 会自动提供一个测试集来包含该测试类中所有的测试。一个测试集通常会将同一个包中的测试类归入一个组**；
- 测试运行器：**即 Runner 或 test runner，是用来运行测试和测试集的程序**。JUnit 提供了多种运行器来执行你的测试。JUnit4 是向后兼容的，可以运行JUnit 3 的测试。

**当你需要一次运行多个测试类时，你就要创建一个测试集。你的测试集也是一个特定的测试运行器（或者 Runner），因此可以像运行测试类那样运行它**。一旦你理解了**测试类、测试集与测试运行器** 是如何工作的，你就可以编写你所需要的任何测试了。这3个对象形成了JUnit 框架的核心。一般，我们只需要编写测试类与测试集，其他类会在能后帮你完成测试。

**要运行一个基础的测试类，你不需要做什么特别的工作，JUnit 会代替你使用一个测试运行器来管理你的测试类的生命周期，包括创建类、调用测试以及搜集结果**。

### 运行参数化测试

**Parameterized（参数化）的测试运行器允许你使用不同的参数多次运行同一个测试**。示例代码如下：

```java
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;
import org.junit.runners.Parameterized.Parameters;
import static org.junit.Assert.*;

import java.util.Arrays;
import java.util.Collection;

@RunWith(value = Parameterized.class)
public class ParameterizedTest {
    private double expectedValue;
    private double valueOne;
    private double valueTwo;

    @Parameters
    public static Collection<Integer[]> getTestParameters() {
        return Arrays.asList(new Integer[][]{
                {2, 1, 1},  //expected, valueOne, valueTwo
                {3, 2, 1},  //expected, valueOne, valueTwo
                {4, 3, 1},  //expected, valueOne, valueTwo 
        });
    }

    public ParameterizedTest(double expectedValue, double valueOne, double valueTwo) {
        this.expectedValue = expectedValue;
        this.valueOne = valueOne;
        this.valueTwo = valueTwo;
    }

    @Test
    public void testAdd() {
        Calculator calculator = new Calculator();
        assertEquals(expectedValue, calculator.add(valueOne, valueTwo), 0);
    }
}
```

要使用 Parametrerized 的测试运行器来运行一个测试类，那就必须要满足以下要求：

- 首先，**使用 `@RunWith(Parameterized.class)` 修饰测试类。 Parameterized 作为该测试类的运行器**；
- 其次，**必须声明测试中所使用的实例变量，同时提供一个用 `@Parameters` 注解修饰的方法，这个方法的签名必须是 `@Parameters public static java.util.Collection` 开始 ，无任何参数。Collection 集合的元素必须是相同长度的数组，这个数组的元素必须要和该类唯一的公共构造函数的参数相匹配**。


我们的这个例子提供的是  `getTestParameters` 方法，每个数组包含了3 个元素，对应于公共构造函数的3个参数。我们想要测试 Calculator 程序的 add 方法，所以我们提供了3个参数： expected 值与两个待求和的值，我们为测试指定了需要的构造器。注意，这次我们的测试用例没有无参构造器，而有一个可以为测试接受参数的构造器。我们在 testAdd 测试方法中实例化了 Calculator 类，并断言调用了我们所提供的参数。

运行这个测试，将会根据 `@Parameters ` 方法的返回集合进行重复的循环测试，传入测试的实参就是返回集合每个数组元素中对应的元素，循环次数与返回集合的元素数量相同。

这里我们要逐步分析 JUnit 的运行过程，以充分理解这项强大的功能。**首先，JUnit 调用了静态方法 getTestParameters ，接下来，JUnit 为 getTestParameters 方法返回集合中的数组元素进行循环，然后，JUnit 使用由数组元素构成的系列参数来调用唯一的公共构造器（如果存在多个公共构造器，Junit 就会抛出一个断言错误）**。在这个示例中，JUnit 使用数组中的第一个数组[2, 1, 1]，**然后 JUnit 会像平时样调用 @Test 方法。JUnit 会为 getTestparameters 方法返回集合中的下一个数组重复以上过程**。

参数化的 Parameterized 类是 JUnit 众多测试运行器中的一个。测试运行器可以让你控制 JUnit 如何运行测试。

### JUnit 测试运行器

JUnit 4 可以向后兼容 3.8.x 版本。因为 JUnit 的 4.x 版本与 3.x 版本完全不同，所以 JUnit 4 很有可能不仅要运行 JUnit 4 的测试，可能还要运行 JUnit 3.x 版本的测试，所以 JUnit 的最新版本中提供不同的运行器，分别用来运行 JUnit 3.x、JUnit 4.x 的测试以及其他不同的测试集。JUnit 4 的测试运行器如下：

- org.junit.internal.runners.JUnit38ClassRunner：这个运行器包含在当前的 JUnit 版本中仅仅是为了向后兼容，它将测试用例作为 JUnt 3.8 的测试用例来启动；
- org.junit.runners.JUnit4：这个运行器将测试用例作为 JUnit 4 的测试用例来启动；
- org.junit.runners.Parameterized.Parameters：这个测试运行器使用不同的参数来运行相同的测试集；
- org.junit.runners.Suite：Suite 是一个包含不同测试的容器，同时 Suite 也是一个运行器，可以运行一个测试类中所以一 @Test 注解修改的方法。

如果测试类中没有显示提供任何运行器，那么 JUnit 将会使用一个默认的运行器。如果希望 JUnit 使用某个特定的测试运行器，那么就使用 @Runwith 注解来指定测试运行器类，例如：

```java
@Runwith(value = org.junit.internal.runners.JUnit38ClassRunner.class) 
public class TestWithJunit38 extends junit.framework.TestCase {
	...
}
```

为了能够尽可能快捷地运行测试，JUnit 提供了一个facade （即外观，org.junit.runner.JUnitCore），它可以运行任何测试运行器。JUnit 设计这个 facade 来执行你的测试，并收集测试结果与统计信息。

> facade 设计模式为子系统中的一组接口提供了一个统一的高级别接口，使得子系统更易于使用。

JUnit 的 facade 决定使用哪个运行器来运行你的测试。它支持 Junit 3.8 的测试、JUnit 4 的测试以及两者的混合体。

在JUnit 4 版本之前，JUnit 包含了 Swing 和 AWT 测试行器，但是到 JUnit 4 就不再包含它们了。这些图形化界面的测试运行器都带有一个横跨屏幕的进度指示条，这就是著名的 JUnit 绿条。JUnit 用户都喜欢把通过测试叫做“绿条”，把测试失败叫做“红条”。因此，“保持绿条就是保持代码干净”是 Junit 的座右铭。

Junit 自带的几个测试运行器都继承了 org.junit.runner.Runner 类，我们也可以继承该类来创建自定义的测试运行器。

### 用  Suite 组合测试

对于单个测试类，可以直接编译运行。在实际项目中，随着项目进度的开展，单元测试类会越来越多，一个一个地单独运行测试类肯定是不可行的。为了解决这个问题，JUnit 使用 Suite （测试集或测试套件）作为一个运行器，把几个测试作为一个集合一起运行。这样，每次需要验证系统功能正确性时，只执行一个或几个测试套件便可以了。测试套件的写法非常简单，只需要遵循以下规则：

1. 创建一个空类作为 Suite 的入口；
2. 使用注解 org.junit.runner.RunWith 和 org.junit.runners.Suite.SuiteClasses 修饰这个空类；
3. 将 org.junit.runners.Suite.class 作为参数传入注解 RunWith，以提示 JUnit 为此类使用 Suite 运行器执行；
4. 将需要放入此 Suite 的测试类的 class 对象组成数组，作为 SuiteClasses 注解的参数；
5. 保证这个空类使用 public 修饰，而且存在一个可用的 public 的无参构造函数。

Junit 4  中使用 @SuiteClasses 注解来组合多个测试类，结合 @RunWith 注解一起来创建 Suite。如下所示：

```java
import org.junit.runner.RunWith;
import org.junit.runners.Suite;

@RunWith(Suite.class)
@Suite.SuiteClasses({
  TestFeatureLogin.class,
  TestFeatureLogout.class,
  TestFeatureNavigate.class,
  TestFeatureUpdate.class
})

public class FeatureTestSuite {
  // the class remains empty,
  // used only as a holder for the above annotations
}
```

**如果没有提供一个自己的 Suite ，那么测试运行器会自动创建一个默认的 Suite。这个默认的 Suite 会扫描你的测试类，找出所有使用 @Test 注解修饰的测试方法，并为每个测试方法创建一个测试类的实例，然后 JUnit 就会独立地执行每个 @Test 方法，以避免潜在的负面影响**。对于前面的 CalculatorTest 测试类，其默认的 Suite 可以这样表示：

```java
@RunWith(value = Suite.class)
@SuiteClasses(value = {CalculatorTest.class})
public class AllTests {
}
```

**如果将另一个测试添加到使用默认 Suite 的测试类中，那么这个默认的 Suite 就会自动包含这个测试。Suite 对象其实是一个 Runner ，可以执行测试类中所有 @Test 注释的方法**。

JUnit 设计精妙，可以创建一组测试集。下面的代码展示了如何将测试用例组合成若干测试集，这些测试集又构成一个主测试集。

```java
[...]
public class TestCaseA {
    @Test
    public void testA1() {
        assertEquals("Dummy test-case", 1+1, 2);
    }
}

[...]
public class TestCaseB {
    @Test
    public void testB1() {
        assertTrue("Dummy test-case", true);
    }
}

[...]
@RunWith(value = Suite.class)
@SuiteClasses(value = {TestCaseA.class})
public class TestSuiteA {
}

[...]
@RunWith(value=Suite.class)
@SuiteClasses(value = {TestCaseB.class})
public class TestSuiteB {
}

[...]
@RunWith(value = Suite.class)
@SuiteClasses(value = {TestSuiteA.class, TestSuiteB.class})
public class MasterTestSuite{
}
```

为了简化，这里的测试集 TestSuiteA 与 TestSuiteB 分别只有一个测试用例，而真正的测试集应该包含多个测试类，就像这里的主测试集。如果运行某个测试集，则该测试集中的所有测试都会运行，如果运行主测试集，则该主测试集中的所有  Suite 包含的测试都会运行。

Ant 与 Maven 也提供了运行多组测试类和l 测试集的功能， 你可以通过正则表达式的类型、要运行的测试类和测试集的名称来指定运行哪些测试类和测试集。 另外，有些 IDE （比如 Eclipse ）允许你在某个指定的包或者源代码目录中运行所有的测试类与 Suite。

### 异常测试

确保代码正常完成很重要，同样，确保代码在特定的异常情况下能抛出期望的异常也很重要，JUnit 有三种方式测试特定情况下是否抛出预期的异常：

- 将 @Test 注解的 expected 元素的值指定为期望的异常类型。这种方式只能测试抛出异常的类型，无法得知异常的详细信息。如果测试的代码中有多个地方都可以抛出指定类型的异常，那么就无法判断出哪里抛出了异常了。示例代码如下：

  ```java

  import org.junit.Test;
  import java.util.ArrayList;

  public class Exception1Test {

      @Test(expected = ArithmeticException.class)
      public void testDivisionWithException() {
          int i = 1 / 0;
      }

      @Test(expected = IndexOutOfBoundsException.class)
      public void testEmptyList() {
          new ArrayList<>().get(0);
      }
  }
  ```
  - 使用 try-catch 块和 fail() 方法。这种方式在 JUnit 3 中使用较多，JUnit 4 已经不推荐使用这种方式了。其中，fail() 方法用于终止将出现异常的代码的后续执行，如果预期出现异常的代码行没有抛出任何异常，而且也没有使用fail() 方法，那么该测试就会假通过。这种方式可以测出异常类型和异常的详细信息。实例代码如下：

  ```java
  import org.junit.Test;
  import java.util.ArrayList;
  import static junit.framework.TestCase.fail;
  import static org.hamcrest.CoreMatchers.is;
  import static org.hamcrest.MatcherAssert.assertThat;

  public class Exception2Test {

      @Test
      public void testDivisionWithException() {
          try {
              int i = 1 / 0;
              fail(); //remember this line, else 'may' false positive
          } catch (ArithmeticException e) {
              assertThat(e.getMessage(), is("/ by zero"));
  			//assert others
          }
      }

      @Test
      public void testEmptyList() {
          try {
              new ArrayList<>().get(0);
              fail();
          } catch (IndexOutOfBoundsException e) {
              assertThat(e.getMessage(), is("Index: 0, Size: 0"));
          }
      }
  }
  ```

- 使用 `@Rule` 和 `ExpectedException`（JUnit 4.7 新增）。这种方式可以也可以测出异常类型和异常的详细信息，但是比使用 try-catch 块和 fail() 方法更简洁。示例代码如下：

  ```java
  import org.junit.Rule;
  import org.junit.Test;
  import org.junit.rules.ExpectedException;

  import static org.hamcrest.CoreMatchers.containsString;
  import static org.hamcrest.CoreMatchers.is;
  import static org.hamcrest.Matchers.hasProperty;

  public class Exception3Test {
      @Rule
      public ExpectedException thrown = ExpectedException.none();

      @Test
      public void testDivisionWithException() {
          thrown.expect(ArithmeticException.class);
        	// if contains some string or not 
          thrown.expectMessage(containsString("/ by zero"));
          int i = 1 / 0;
      }

  	@Test
  	public void testIndexOutOfBoundsException() throws IndexOutOfBoundsException {
      	List<> list = new ArrayList<>();
        	// test type
      	thrown.expect(IndexOutOfBoundsException.class);
        	// test given message
      	thrown.expectMessage("Index: 0, Size: 0");
      	list.get(0); // execution will never get past this line
  	}
  }
  ```

  此外，还可以使用 org.hamcrest.Matchers 来检查异常。例如：

  ```java
  import static org.hamcrest.Matchers.hasProperty;
  import static org.hamcrest.Matchers.is;
  import static org.hamcrest.Matchers.startsWith;

  import javax.ws.rs.NotFoundException;
  import javax.ws.rs.core.Response;
  import javax.ws.rs.core.Response.Status;

  import org.junit.Rule;
  import org.junit.Test;
  import org.junit.rules.ExpectedException;

  public class TestExy {
      @Rule
      public ExpectedException thrown = ExpectedException.none();

      @Test
      public void shouldThrow() {
          TestThing testThing = new TestThing();
          thrown.expect(NotFoundException.class);
          thrown.expectMessage(startsWith("some Message"));
          thrown.expect(hasProperty("response", hasProperty("status", is(404))));
          testThing.chuck();
      }

      private class TestThing {
          public void chuck() {
              Response response = Response.status(Status.NOT_FOUND)
                .entity("Resource not found")
                .build();
              throw new NotFoundException("some Message", response);
          }
      }
  }
  ```

  ​

