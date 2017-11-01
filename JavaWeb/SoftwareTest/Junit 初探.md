---
typora-copy-images-to: ..\..\..\graphs\photos
typora-root-url: ./
---

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

接下来，我们在测试类中创建了一个测试方法。**测试方法（也简称为测试）需要使用 `@Test` 注解修饰，且是公共的，不带任何参数，并且返回 void 类型**。因为 JUnit 没有方法名称的限制，所以你可以根据自己喜好命名你的方法，只要该方法拥有了`@Test`  注解，JUnit 就会执行它们。**最好的做法是以 `test` 开头加方法名的模式来命名测试方法**。一个测试方法主要包括三个部分：setup、执行操作和验证结果。

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

### Assert 断言

Assert 是编写测试用例的核心实现方式，即期望值是多少，测试的结果是多少，以此来判断测试是否通过。

核心的静态断言方法：

| 方法                  | 描述                                |
| ------------------- | :-------------------------------- |
| assertEquals()      | 查看两个基本数值或对象是否相等。                  |
| assertArrayEquals() | 查看两个数组是否相等。                       |
| assertNotEquals()   | 查看两个基本数值或对象是否不相等。                 |
| assertNull()        | 查看对象是否为空。                         |
| assertNotNull()     | 查看对象是否不为空。                        |
| assertSame()        | 查看两个对象的引用是否相等。类似于使用“==”比较两个对象     |
| assertNotSame()     | 查看两个对象的引用是否不相等。类似于使用“!=”比较两个对象    |
| assertTrue()        | 查看运行结果是否为true。                    |
| assertFalse()       | 查看运行结果是否为false。                   |
| assertThat()        | 查看实际值是否满足指定的条件。应用最为广泛，推荐结合静态导入使用。 |

Hamcrest 是一个测试辅助工具，提供了一套通用的匹配符 Matcher，灵活使用这些匹配符定义的规则，程序员可以更加精确的表达自己的测试思想，指定所想设定的测试条件。JUnit 4 结合 Hamcrest 提供了新的断言语句 assertThat，只需一个 assertThat 语句，结合 Hamcrest 提供的匹配符，就可以表达全部的测试思想。assertThat的基本语法如下：

- assertThat(T actual, Matcher matcher)
- assertThat(String reason, T actual, Matcher matcher)

其中，actual 是接下来想要验证的值，matcher 是使用 Hamcrest 匹配符来表达的对前面变量所期望的值的声明，如果 actual 值与 matcher 所表达的期望值相符，则断言成功，否则断言失败。reason 是自定义的断言失败时显示的信息。

assertThat 具有以下优点：

- 表达统一。只需一条 assertThat 语句即可替代旧有的其他语句（如 assertEquals，assertNotSame，assertFalse，assertTrue，assertNotNull，assertNull 等），使断言变得简单、代码风格统一，增强测试代码的可读性和可维护性；
- 语法直观易懂。assertThat 不再像 assertEquals 那样，使用比较难懂的“谓宾主”语法模式，相反，assertThat 使用了类似于“主谓宾”的易读语法模式，使得代码更加直观、易读，符合人类思维习惯；
- 错误信息更具描述性。旧的断言语法如果断言失败，默认不会有额外的提示信息，如果该断言失败，只会抛出无用的错误信息，如 java.lang.AssertionError，除此之外不会有更多的提示信息。新的断言语法会默认自动提供一些可读的描述信息；
- 跟 Matcher 匹配符联合使用更灵活强大。Matcher 提供了功能丰富的匹配符，assertThat 结合这些匹配符使用可更灵活更准确的表达测试思想。虽然 JUnit 4 本身包含了一些 Hamcrest 的 Matcher，但是数量有限。因此建议你将Hamcrest 包加入项目。

```java
/* 字符相关匹配符 */
// equalTo匹配符断言被测的testedValue等于expectedValue，
// equalTo可以断言数值之间，字符串之间和对象之间是否相等，相当于Object的equals方法
assertThat(testedValue, equalTo(expectedValue));

// equalToIgnoringCase匹配符断言被测的字符串testedString,
// 在忽略大小写的情况下等于expectedString
assertThat(testedString, equalToIgnoringCase(expectedString));


// equalToIgnoringWhiteSpace匹配符断言被测的字符串testedString,
// 在忽略头尾的任意个空格的情况下等于expectedString，
// 注意：字符串中的空格不能被忽略
assertThat(testedString, equalToIgnoringWhiteSpace(expectedString);

// containsString匹配符断言被测的字符串testedString包含子字符串subString
assertThat(testedString, containsString(subString));

// endsWith匹配符断言被测的字符串testedString以子字符串suffix结尾
assertThat(testedString, endsWith(suffix));

//startsWith匹配符断言被测的字符串testedString以子字符串prefix开始
assertThat(testedString, startsWith(prefix));

           
/* 一般匹配符 */
// nullValue()匹配符断言被测object的值为null
assertThat(object,nullValue());

// notNullValue()匹配符断言被测object的值不为null
assertThat(object,notNullValue());

// is匹配符断言被测的object等于后面给出匹配表达式
assertThat(testedString, is(equalTo(expectedValue)));

// is匹配符简写应用之一，is(equalTo(x))的简写，断言testedValue等于expectedValue
assertThat(testedValue, is(expectedValue));

// is匹配符简写应用之二，is(instanceOf(SomeClass.class))的简写，断言testedObject为Cheddar的实例
assertThat(testedObject, is(Cheddar.class));

// not匹配符和is匹配符正好相反，断言被测的object不等于后面给出的object
assertThat(testedString, not(expectedString));

// allOf匹配符断言符合所有条件，相当于“与”（&&）
assertThat(testedNumber, allOf(greaterThan(8), lessThan(16)));

// anyOf匹配符断言符合条件之一，相当于“或”（||）
assertThat(testedNumber, anyOf(greaterThan(16), lessThan(8)));


/* 数值相关匹配符 */
// closeTo匹配符断言被测的浮点型数testedDouble在(20.0-0.5)~(20.0+0.5)范围之内
assertThat(testedDouble, closeTo(20.0, 0.5));

// greaterThan匹配符断言被测的数值testedNumber大于16.0
assertThat(testedNumber, greaterThan(16.0));

// lessThan匹配符断言被测的数值testedNumber小于16.0
assertThat(testedNumber, lessThan (16.0));

// greaterThanOrEqualTo匹配符断言被测的数值testedNumber大于等于16.0
assertThat(testedNumber, greaterThanOrEqualTo(16.0));

// lessThanOrEqualTo匹配符断言被测的testedNumber小于等于16.0
assertThat(testedNumber, lessThanOrEqualTo(16.0));


/* 集合相关匹配符 */
// hasEntry匹配符断言被测的Map对象mapObject含有一个键值为"key"对应元素值为"value"的Entry项
assertThat(mapObject, hasEntry("key", "value" ));

// hasItem匹配符表明被测的迭代对象iterableObject含有元素element项则测试通过
assertThat(iterableObject, hasItem (element));

// hasKey匹配符断言被测的Map对象mapObject含有键值“key”
assertThat(mapObject, hasKey ("key"));

// hasValue匹配符断言被测的Map对象mapObject含有元素值value
assertThat(mapObject, hasValue(value));
```

断言示例：

```java
import static org.hamcrest.CoreMatchers.allOf;
import static org.hamcrest.CoreMatchers.anyOf;
import static org.hamcrest.CoreMatchers.both;
import static org.hamcrest.CoreMatchers.containsString;
import static org.hamcrest.CoreMatchers.equalTo;
import static org.hamcrest.CoreMatchers.everyItem;
import static org.hamcrest.CoreMatchers.hasItems;
import static org.hamcrest.CoreMatchers.not;
import static org.hamcrest.CoreMatchers.sameInstance;
import static org.hamcrest.CoreMatchers.startsWith;
import static org.junit.Assert.assertArrayEquals;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertNotSame;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertSame;
import static org.junit.Assert.assertThat;
import static org.junit.Assert.assertTrue;

import java.util.Arrays;

import org.hamcrest.core.CombinableMatcher;
import org.junit.Test;

public class AssertTests {
  @Test
  public void testAssertArrayEquals() {
    byte[] expected = "trial".getBytes();
    byte[] actual = "trial".getBytes();
    assertArrayEquals("failure - byte arrays not same", expected, actual);
  }

  @Test
  public void testAssertEquals() {
    assertEquals("failure - strings are not equal", "text", "text");
  }

  @Test
  public void testAssertFalse() {
    assertFalse("failure - should be false", false);
  }

  @Test
  public void testAssertNotNull() {
    assertNotNull("should not be null", new Object());
  }

  @Test
  public void testAssertNotSame() {
    assertNotSame("should not be same Object", new Object(), new Object());
  }

  @Test
  public void testAssertNull() {
    assertNull("should be null", null);
  }

  @Test
  public void testAssertSame() {
    Integer aNumber = Integer.valueOf(768);
    assertSame("should be same", aNumber, aNumber);
  }

  // JUnit Matchers assertThat
  @Test
  public void testAssertThatBothContainsString() {
    assertThat("albumen", both(containsString("a")).and(containsString("b")));
  }

  @Test
  public void testAssertThatHasItems() {
    assertThat(Arrays.asList("one", "two", "three"), hasItems("one", "three"));
  }

  @Test
  public void testAssertThatEveryItemContainsString() {
    assertThat(Arrays.asList(new String[] { "fun", "ban", "net" }), everyItem(containsString("n")));
  }

  // Core Hamcrest Matchers with assertThat
  @Test
  public void testAssertThatHamcrestCoreMatchers() {
    assertThat("good", allOf(equalTo("good"), startsWith("good")));
    assertThat("good", not(allOf(equalTo("bad"), equalTo("good"))));
    assertThat("good", anyOf(equalTo("bad"), equalTo("good")));
    assertThat(7, not(CombinableMatcher.<Integer> either(equalTo(3)).or(equalTo(4))));
    assertThat(new Object(), not(sameInstance(new Object())));
  }

  @Test
  public void testAssertTrue() {
    assertTrue("failure - should be true", true);
  }
}
```

### Runner 测试运行器

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

### Suite 测试集

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
      public void testDivisionWithZero() {
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
  import static org.hamcrest.MatcherAssert.assertThat;
  import static org.hamcrest.CoreMatchers.is;

  public class Exception2Test {
      @Test
      public void testDivisionWithZero() {
          try {
              int i = 1 / 0;
              fail();
          } catch (ArithmeticException e) {
              assertThat(e.getMessage(), is("/ by zero"));
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
  import java.util.ArrayList;

  public class Exception3Test {
      @Rule
      public ExpectedException thrown = ExpectedException.none();

      @Test
      public void testDivisionWithZero() {
          // test type
          thrown.expect(ArithmeticException.class);
          // if contains some string or not
          thrown.expectMessage("/ by zero");
          int i = 1 / 0;
      }

      @Test
      public void testEmptyList() {
          // test type
          thrown.expect(IndexOutOfBoundsException.class);
          // test given message
          thrown.expectMessage("Index: 0, Size: 0");
          // execution will never get past this line
          new ArrayList<>().get(0);
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

### 忽略某个测试

  在 JUnit 4 中可以将 @Ignore 注解放在某个测试方法之前或之后来来忽略这个测试：

  ```java
  import org.junit.Ignore;
  import org.junit.Test;
  import static org.hamcrest.MatcherAssert.assertThat;
  import static org.hamcrest.Matchers.is;

  public class IgnoreTest {
      @Test
      public void testMath1() {
          assertThat(1 + 1, is(2));
      }

      @Ignore
      @Test
      public void testMath2() {
          assertThat(1 + 2, is(3));
      }

      @Ignore("some one please create a test for Math3!")
      @Test
      public void testMath3() {
          assertThat(1 + 3, is(3));
      }
  }
  ```

被 @Ignore 注解修饰的测试在执行时会被忽略而不会被执行，该注解的唯一元素可以指定忽略的原因。运行上面的测试类，会发现仅有第一个测试会被执行。

### Test fixtures

测试环境设置过程的自动化，是测试中最具挑战性的部分，在单元测试、集成测试、系统测试中都是如此。测试执行所需要的固定环境称为 Test Fixture（姑且翻译成测试固件吧），也就是测试运行之前所需的稳定的、公共的、可重复的运行环境，这个“环境”不仅可以是数据，也可以指对被测软件的准备，例如准备输入数据、创建 mock 对象、加载数据库等。

JUnit 4 使用注解来创建测试运行所需的 Test Fixture，这些 Test Fixture 可以在每个测试运行之前和之后运行，也可以在所有测试运行之前和之后仅运行一次。

@Before 和 @After 注解用于修饰  public void 类型的无参方法，这两种方法分别在**每个测试执行之前和之后**都会执行一次（即使 @Before 方法和 @Test 方法抛出了异常， @After 方法也会执行）。@Before 通常用于为一个测试类中的所有测试统一初始化相同的数据（比如某些对象的初始化，为了保证测试之间的独立性，这些对象必须在每个测试执行之前都进行初始化，如文件流）， @After 通常用于为一个测试类中的所有测试清理之前统一初始化的数据。除非父类的 @Before、@Afte 方法被重写了，否则，父类的 @Before 方法会在当前子类的 @Before 方法之前执行，父类的 @After 方法会在当前子类的 @After 方法执行之后执行。

Managing test fixtures 实例如下：

```java
import org.junit.AfterClass;
import org.junit.BeforeClass;
import org.junit.Before;
import org.junit.After;
import org.junit.Test;

import java.io.Closeable;
import java.io.IOException;

public class ExpensiveTestFixtures {
    private ManagedResource myManagedResource;
    private static ExpensiveManagedResource myExpensiveManagedResource;

    static class ExpensiveManagedResource implements Closeable {
        @Override
        public void close() throws IOException {
        }
    }

    static class ManagedResource implements Closeable {
        @Override
        public void close() throws IOException {
        }
    }

    @BeforeClass
    public static void setUpClass() {
        System.out.println("@BeforeClass setUpExpensiveClass");
        myExpensiveManagedResource = new ExpensiveManagedResource();
    }

    @AfterClass
    public static void tearDownClass() throws IOException {
        System.out.println("@AfterClass tearDownExpensiveClass");
        myExpensiveManagedResource.close();
        myExpensiveManagedResource = null;
    }

    @Before
    public void setUp() {
        System.out.println("@Before setUpCommonClass");
        this.myManagedResource = new ManagedResource();
    }

    @After
    public void tearDown() throws IOException {
        System.out.println("@After tearDownCommonClass");
        this.myManagedResource.close();
        this.myManagedResource = null;
    }

    @Test
    public void test1() {
        System.out.println("@Test test1()");
    }

    @Test
    public void test2() {
        System.out.println("@Test test2()");
    }
}
```

运行结果如下：

```powershell
@Before setUp
@Test test1()
@After tearDown
@Before setUp
@Test test2()
@After tearDown
```

@BeforeClass 和 @AfterClass 用于修饰 public static void 类型的无参方法，这两种方法分别在**所有测试执行的之前和之后**执行一次（即使 @BeforeClass 方法抛出了异常， @AfterClass 方法也会执行）。@BeforeClass 通常用于为一个测试类中的所有测试统一分配昂贵资源（如数据库连接、HTTP连接等仅需创建一次即可运行所有测试的资源），@AfterClass 通常用于为一个测试类中的所有测试回收这些昂贵资源。除非父类的 @BeforeClass、@AfterClass 方法被隐藏了，否则，父类的 @BeforeClass 方法会在当前子类的 @BeforeClass 方法之前执行，父类的 @AfterClass 方法会在当前子类的 @AfterClass 方法执行之后执行。

Managing expensive test fixtures 示例：

```java
import java.io.Closeable;
import java.io.IOException;

import org.junit.After;
import org.junit.AfterClass;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;

public class TestFixturesExample {
    private ManagedResource myManagedResource;
    private static ExpensiveManagedResource myExpensiveManagedResource;

    static class ExpensiveManagedResource implements Closeable {
        @Override
        public void close() throws IOException {
        }
    }

    static class ManagedResource implements Closeable {
        @Override
        public void close() throws IOException {
        }
    }

    @BeforeClass
    public static void setUpClass() {
        System.out.println("@BeforeClass setUpClass");
        myExpensiveManagedResource = new ExpensiveManagedResource();
    }

    @AfterClass
    public static void tearDownClass() throws IOException {
        System.out.println("@AfterClass tearDownClass");
        myExpensiveManagedResource.close();
        myExpensiveManagedResource = null;
    }

    @Before
    public void setUp() {
        System.out.println("@Before setUp");
        this.myManagedResource = new ManagedResource();
    }

    @After
    public void tearDown() throws IOException {
        System.out.println("@After tearDown");
        this.myManagedResource.close();
        this.myManagedResource = null;
    }

    @Test
    public void test1() {
        System.out.println("@Test test1()");
    }

    @Test
    public void test2() {
        System.out.println("@Test test2()");
    }
}
```

运行结果如下：

```powershell
@BeforeClass setUpExpensiveClass
@Before setUpCommonClass
@Test test1()
@After tearDownCommonClass
@Before setUpCommonClass
@Test test2()
@After tearDownCommonClass
@AfterClass tearDownExpensiveClass
```

### 参数化测试

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

### @Rule 和 @ClassRule

@Rule 注解用于修饰字段或方法。修饰的字段必须是 public 的、非 static 的，且实现了 org.junit.rules.TestRule 接口（建议）或 org.junit.rules.MethodRule 接口；修饰的方法也必须是 public 的、非 static 的，且返回值类型实现了 org.junit.rules.TestRule 接口（建议）或 org.junit.rules.MethodRule 接口。

当使用 @Rule 注解时，传递给其 TestRule apply() 方法的 Statement 会在运行所有 @Before 方法，接着运行 @Test 方法，然后运行所有 @After 方法，任一方法失败就抛出相应的异常。如果一个类存在多个 @Rule 修饰的程序单元，那么会先运行 @Rule 修饰的字段语句，然后再运行 @Rule 修饰的方法。多个 @Rule 修饰的字段语句或方法的运行顺序取决于所用 JVM 的反射API（这种顺序通常是未定义的），可以通过使用 org.junit.rules.RuleChain 来控制多个 @Rule 修饰的程序单元的执行顺序。

@ClassRule 注解用于修饰字段或方法。修饰的字段必须是 public 、 static 的，且实现了 org.junit.rules.TestRule 接口；修饰的方法也必须是 public 、static 的，且返回值类型实现了 org.junit.rules.TestRule 接口。

当使用 @ClassRule 注解时，传递给其 TestRule apply() 方法的 Statement 会在运行所有 @BeforeClass 方法，接着运行整个类体（如果标准测试类的话会运行其所有方法，如果是测试集的话会运行所有测试类），然后运行所有 @AfterClass 方法。**传给 TestRule 的 Statement 不能抛出任何异常，如果从 TestRule 抛出异常，则会造成不确定的行为，这就意味着 ErrorCollector，ExpectedException 和 Timeout 等 TestRule 实现类在使用 @ClassRule 时会有不确定的行为**。如果一个类存在多个 @ClassRule 修饰的程序单元，那么会先运行 @ClassRule 修饰的字段语句，然后再运行 @ClassRule 修饰的方法。多个 @ClassRule 修饰的字段语句或方法的运行顺序取决于所用 JVM 的反射API（这种顺序通常是未定义的）。

> JUnit 4.7 增加的 MethodRule 接口已经不建议使用了，请使用 JUnit 4.9 新增的 TestRule 接口代替，TestRule 接口更加适用于class rule。MethodRule接口定义的唯一方法：
>
> `Statement apply(Statement base, FrameworkMethod method, Object target);` 
>
> TestRule 的对应物：
>
> `Statement apply(Statement base, Description description);`

### TestRule 详解

org.junit.rules.TestRule 接口对象可以为测试添加额外的检查（否则测试可能会失败），或者为测试执行必要的设置或清理工作，或者在其他地方观察测试的执行以报告该测试。 @BeforeClass、@AfterClass、@Before、@After 所修饰方法能做的事，TestRule 也可以完成，而且 TestRule 更强大，它可以轻松地在多个项目或类之间共享。

JUnit 默认的运行器以两种方式识别 TestRule ：@Rule 注解修饰的方法级别的 TestRule 和 @ClassRule 注解修饰的类级别 TestRule。可以为一个测试或测试集的运行添加多个 TestRule，执行测试或测试集的 Statement 会依次传递给 @Rule 修饰的程序单元并返回一个替代的或修改过的（取决 TestRule 的实现） Statement，该 Statement 会传递下一个 @Rule 修饰的程序单元（如果有的话）。

JUnit 4 引入 @ClassRule 和 @Rule 注解是想让以前在 @BeforeClass、@AfterClass、@Before、@After 中的逻辑能更加方便地实现重用，因为 @BeforeClass、@AfterClass、@Before、@After 是将逻辑封装在一个测试类的方法中的，如果想实现重用，就需要我们将这些逻辑提取到一个单独的类中，然后在这些注解方法中调用这个单独类中的逻辑，而 @ClassRule、@Rule 则是将逻辑封装在一个类中，当需要使用时，直接赋值即可，对不需要重用的逻辑则可用匿名类实现。因此，JUnit 在接下来的版本中更倾向于多用 @ClassRule 和 @Rule。同时由于 Statement 链构造的特殊性，@ClassRule 或 @Rule 也保证了类似父类 @BeforeClass 或 @Before 方法要比子类的这些方法执行早，而父类的 @AfterClass 或 @After 方法执行要比子类的这些方法要早的特点。

下面介绍 TestRule 的一些实现类。

![TestRule](../../../graphs/photos/TestRule.png)

- ExpectedException：make flexible assertions about thrown exceptions
- TestName：remember the test name for use during the method
- TestWatcher：add logic at events during method execution
- Timeout：cause test to fail after a set time

#### TestWatcher 和 TestName

先来看两个简单的吧，TestWatcher 为子类提供了四个事件方法以监控测试方法在运行过程中的状态，一般它可以作为信息记录使用。如果 TestWatcher 应用了 @ClassRule 注解，则该测试类在运行之前（调用所有的 @BeforeClass 方法之前）会调用其 starting() 方法；当所有 @AfterClass 方法调用结束后，其 succeeded() 方法会被调用；若 @AfterClass 方法中出现异常，则其 failed() 方法会被调用；最后，其finished() 方法会被调用；所有这些方法的 Description 是 Runner 对应的 Description。如果 TestWatcher 应用了 @Rule 注解，则在每个测试方法运行前（所有的 @Before 方法运行前）会调用其 starting() 方法；当所有 @After 方法调用结束后，其 succeeded() 方法会被调用；若 @After 方法中出现异常，则其 failed() 方法会被调用；最后，其 finished() 方法会被调用；所有 Description 的实例是测试方法的 Description 实例。其原型如下：

```java
public abstract class TestWatcher implements TestRule {
    public Statement apply(final Statement base, final Description description) {
        return new Statement() {
            @Override
            public void evaluate() throws Throwable {
                List<Throwable> errors = new ArrayList<Throwable>();

                startingQuietly(description, errors);
                try {
                    base.evaluate();
                    succeededQuietly(description, errors);
                } catch (@SuppressWarnings("deprecation") org.junit.internal.AssumptionViolatedException  e) {
                    errors.add(e);
                    skippedQuietly(e, description, errors);
                } catch (Throwable e) {
                    errors.add(e);
                    failedQuietly(e, description, errors);
                } finally {
                    finishedQuietly(description, errors);
                }

                MultipleFailureException.assertEmpty(errors);
            }
        };
    }

    private void succeededQuietly(Description description,
            List<Throwable> errors) {
        try {
            succeeded(description);
        } catch (Throwable e) {
            errors.add(e);
        }
    }

    private void failedQuietly(Throwable e, Description description,
            List<Throwable> errors) {
        try {
            failed(e, description);
        } catch (Throwable e1) {
            errors.add(e1);
        }
    }

    @SuppressWarnings("deprecation")
    private void skippedQuietly(
            org.junit.internal.AssumptionViolatedException e, Description description,
            List<Throwable> errors) {
        try {
            if (e instanceof AssumptionViolatedException) {
                skipped((AssumptionViolatedException) e, description);
            } else {
                skipped(e, description);
            }
        } catch (Throwable e1) {
            errors.add(e1);
        }
    }

    private void startingQuietly(Description description,
            List<Throwable> errors) {
        try {
            starting(description);
        } catch (Throwable e) {
            errors.add(e);
        }
    }

    private void finishedQuietly(Description description,
            List<Throwable> errors) {
        try {
            finished(description);
        } catch (Throwable e) {
            errors.add(e);
        }
    }

    /**
     * 当一个测试成功时调用
     */
    protected void succeeded(Description description) {
    }

    /**
     * 当一个测试失败时调用
     */
    protected void failed(Throwable e, Description description) {
    }

    /**
     * 当一个测试由于失败的假定而被跳过时调用
     */
    @SuppressWarnings("deprecation")
    protected void skipped(AssumptionViolatedException e, Description description) {
        // For backwards compatibility with JUnit 4.11 and earlier, call the legacy version
        org.junit.internal.AssumptionViolatedException asInternalException = e;
        skipped(asInternalException, description);
    }

    /**
     * 当一个测试由于失败的假定而被跳过时调用
     *
     * @deprecated use {@link #skipped(AssumptionViolatedException, Description)}
     */
    @Deprecated
    protected void skipped(
            org.junit.internal.AssumptionViolatedException e, Description description) {
    }

    /**
     * 当一个测试要启动时调用
     */
    protected void starting(Description description) {
    }

    /**
     * 当一个测试结束（无论通过还是失败）时调用
     */
    protected void finished(Description description) {
    }
}
```

TestName 是对 TestWatcher 的一个简单实现，它会在 starting() 方法中记录每次运行的名字。如果 TestName 应用@Rule 注解，则 starting() 中传入的 Description 是对每个测试方法的 Description，因而 getMethodName() 方法返回的是测试方法的名字。一般 TestName 不应用 @ClassRule 注解，如果真有人这样用了，则 starting() 中 Description 的参数是 Runner 的 Description 实例，一般 getMethodName() 返回值为 null。其原型如下：

```java
public class TestName extends TestWatcher {
    private String name;

    @Override
    protected void starting(Description d) {
        name = d.getMethodName();
    }

    /**
     * @return the name of the currently-running test method
     */
    public String getMethodName() {
        return name;
    }
}
```

#### Verifier 和 ErrorCollector

Verifier （抽象类）是在所有测试已经结束的时候，再加入一些额外的逻辑（重写其 verify() 方法），如果额外的逻辑通过，才表示测试成功，否则，测试依旧失败，即使在之前的运行中都是成功的。其原型如下：

```java
public abstract class Verifier implements TestRule {
    public Statement apply(final Statement base, Description description) {
        return new Statement() {
            @Override
            public void evaluate() throws Throwable {
                base.evaluate();
                verify();
            }
        };
    }

    /**
     * Override this to add verification logic. Overrides should throw an
     * exception to indicate that verification failed.
     */
    protected void verify() throws Throwable {
    }
}
```

Verifier 可以为多个测试加入一些公共的验证逻辑。当 @Rule 应用于 Verifier 时，它会在所有 @After 方法运行结束后调用其 verify() 方法，如果 verifier() 方法验证失败就抛出某个异常，则该测试方法的 testFailure 事件将会被触发，导致该测试方法失败；当 Verifier 应用在 @ClassRule 时，它会在所有的 @AfterClass 方法执行完后执行其 verify() 方法，如果 verify() 失败就抛出某个异常，这将会触发关于该测试类的 testFailure，此时测试类中的所有测试方法都已经运行成功了，却在最后收到一个关于测试类的 testFailure 事件，这确实是一个比较诡异的事情，因而 @ClassRule 中提到ErrorCollector（继承了 Verifier）不可以应用 @ClassRule 注解，否则其行是不确定的；前面也提到过，@ClassRule 注解修饰的字段或方法的返回值在运行时不能抛异常，否则其行为是不确定的。

ErrorCollector 是对 Verifier 的一个实现，它可以在运行某个测试方法的过程中收集多个异常（即使前面出错了，后面依然会继续执行，但最后会失败），而这些错误信息会在最后调用ErrorCollector 的 verify() 方法时统一报告出来。其原型如下：

```java
public class ErrorCollector extends Verifier {
    private List<Throwable> errors = new ArrayList<Throwable>();

    @Override
    protected void verify() throws Throwable {
        MultipleFailureException.assertEmpty(errors);
    }

    /**
     * 将 Throwable 添加到 errors 列表中，代码依然继续执行，但最后会失败
     */
    public void addError(Throwable error) {
        errors.add(error);
    }

    /**
     * 如果 value 与 matcher 不匹配就收集该异常，代码依然继续执行，但最后会失败
     */
    public <T> void checkThat(final T value, final Matcher<T> matcher) {
        checkThat("", value, matcher);
    }

    /**
     * 同上，只是增加了失败的原因描述 
     */
    public <T> void checkThat(final String reason, final T value, final Matcher<T> matcher) {
        checkSucceeds(new Callable<Object>() {
            public Object call() throws Exception {
                assertThat(reason, value, matcher);
                return value;
            }
        });
    }

    /**
     * 如果 callable 抛出异常，就收集该异常，代码依然继续执行，但最后会失败
     */
    public <T> T checkSucceeds(Callable<T> callable) {
        try {
            return callable.call();
        } catch (Throwable e) {
            addError(e);
            return null;
        }
    }
}
```

#### ExternalResource 和 TemporaryFolder

ExternalResource 在测试开始之前设置所依赖的外部资源以及在测试结束后清理这些资源。相关操作可以通过重写其 before() 和 after() 方法来实现.这里资源诸如 Socket 、服务器连接和数据库连接的开启与断开、临时文件的创建与删除等。如果 ExternalResource 用在 @ClassRule 注解字段中，其 before() 方法会在所有 @BeforeClass 方法之前调用，其 after() 方法会在所有 @AfterClass 方法之后调用（即使在执行 @AfterClass方法时抛出了异常）；如果 ExternalResource用在 @Rule 注解字段中，其 before() 方法会在所有 @Before 方法之前调用，其 after() 方法会在所有 @After 方法之后调用。其原型如下：

```java
public abstract class ExternalResource implements TestRule {
    public Statement apply(Statement base, Description description) {
        return statement(base);
    }

    private Statement statement(final Statement base) {
        return new Statement() {
            @Override
            public void evaluate() throws Throwable {
                before();
                try {
                    base.evaluate();
                } finally {
                    after();
                }
            }
        };
    }

    /**
     * 重写该方法来开启你自己的外部资源
     *
     * @throws 开启资源失败抛出异常，这样 after() 方法就不会执行
     */
    protected void before() throws Throwable {
        // do nothing
    }

    /**
     * 重写该方法来清理自己的外部资源
     */
    protected void after() {
        // do nothing
    }
}
```

TemporaryFolder 是对 ExternalResource 的一个实现，其 before() 方法中在临时文件夹中创建一个以 junit 开头的随机文件夹，其 after() 方法将创建的临时文件夹清空并删除该临时文件夹。另外 TemporaryFolder 还提供了几个方法以在新创建的临时文件夹中创建新的文件、文件夹。其原型如下：

```java
public class TemporaryFolder extends ExternalResource {
    private final File parentFolder;
    private File folder;

    public TemporaryFolder() {
        this(null);
    }

    public TemporaryFolder(File parentFolder) {
        this.parentFolder = parentFolder;
    }

    @Override
    protected void before() throws Throwable {
        create();
    }

    @Override
    protected void after() {
        delete();
    }

    // testing purposes only

    /**
     * for testing purposes only. Do not use.
     */
    public void create() throws IOException {
        folder = createTemporaryFolderIn(parentFolder);
    }

    /**
     * 在临时文件夹下创建一个新的指定名称的文件
     */
    public File newFile(String fileName) throws IOException {
        File file = new File(getRoot(), fileName);
        if (!file.createNewFile()) {
            throw new IOException(
                    "a file with the name \'" + fileName + "\' already exists in the test folder");
        }
        return file;
    }

    /**
     * 在临时文件夹下创建一个新的以"junit"开头的随机名称的文件
     */
    public File newFile() throws IOException {
        return File.createTempFile("junit", null, getRoot());
    }

    /**
     * 在临时文件夹下创建一个新的指定名称的文件夹
     */
    public File newFolder(String folder) throws IOException {
        return newFolder(new String[]{folder});
    }

    /**
     * 在临时文件夹下创建若干个新的指定名称的文件
     */
    public File newFolder(String... folderNames) throws IOException {
        File file = getRoot();
        for (int i = 0; i < folderNames.length; i++) {
            String folderName = folderNames[i];
            validateFolderName(folderName);
            file = new File(file, folderName);
            if (!file.mkdir() && isLastElementInArray(i, folderNames)) {
                throw new IOException(
                        "a folder with the name \'" + folderName + "\' already exists");
            }
        }
        return file;
    }
    
    /**
     * 验证包含路径分隔符的指定名称的文件夹是否能创建成功
     */
    private void validateFolderName(String folderName) throws IOException {
        File tempFile = new File(folderName);
        if (tempFile.getParent() != null) {
            String errorMsg = "Folder name cannot consist of multiple path components separated by a file separator." + " Please use newFolder('MyParentFolder','MyFolder') to create hierarchies of folders";
            throw new IOException(errorMsg);
        }
    }

    private boolean isLastElementInArray(int index, String[] array) {
        return index == array.length - 1;
    }

    /**
     * 在临时文件夹下创建一个新的随机名称的文件夹
     */
    public File newFolder() throws IOException {
        return createTemporaryFolderIn(getRoot());
    }

    private File createTemporaryFolderIn(File parentFolder) throws IOException {
        File createdFolder = File.createTempFile("junit", "", parentFolder);
        createdFolder.delete();
        createdFolder.mkdir();
        return createdFolder;
    }

    /**
     * @return 临时文件夹的位置
     */
    public File getRoot() {
        if (folder == null) {
            throw new IllegalStateException(
                    "the temporary folder has not yet been created");
        }
        return folder;
    }

    /**
     * 删除临时文件夹下的所有文件和文件夹，
     * 一般不直接调用，因为 @Rule 注解提供的机制会在 after() 方法中调用它
     */
    public void delete() {
        if (folder != null) {
            recursiveDelete(folder);
        }
    }

    private void recursiveDelete(File file) {
        File[] files = file.listFiles();
        if (files != null) {
            for (File each : files) {
                recursiveDelete(each);
            }
        }
        file.delete();
    }
}
```

#### Timeout 与 ExpectedException

Timeout 与 ExpectedException 都是对 @Test 注解中 timeout 和 expected 字段的部分替代实现。只是 @Test 注解只适用于单个测试方法，而这两个实现适用于全局测试类。对 Timeout 来说，如果不是在测试类中所有的测试方法都需要有时间限制，并不推荐适用 Timeout；对 ExpectedException，它使用了Hamcrest 中的 Matcher 来匹配，因而提供了更强大的控制能力，但是一般的使用 @Test 中的 expected 字段就够了，它多次调用 expected 表达是 and 的关系，即如果我有两个 Exception，则抛出的 Exception 必须同时是这两个类型的，感觉没有什么大的意义，因而不推荐使用这个 Rule。这两个 Rule 原本就是基于测试方法设计的，因而如果应用在 @ClassRule 上好像没有什么大的意义，不过 Timeout 感觉是可以应用在 @ClassRule 中的，如果要测试一个测试类整体运行时间的话，当然如果存在这种需求的话。其原型如下：

```java
public class Timeout implements TestRule {
    private final long timeout;
    private final TimeUnit timeUnit;
    private final boolean lookForStuckThread;

    /**
     * Returns a new builder for building an instance.
     *
     * @since 4.12
     */
    public static Builder builder() {
        return new Builder();
    }

    /**
     * Create a {@code Timeout} instance with the timeout specified
     * in milliseconds.
     * <p>
     * This constructor is deprecated.
     * <p>
     * Instead use {@link #Timeout(long, java.util.concurrent.TimeUnit)},
     * {@link Timeout#millis(long)}, or {@link Timeout#seconds(long)}.
     *
     * @param millis the maximum time in milliseconds to allow the
     * test to run before it should timeout
     */
    @Deprecated
    public Timeout(int millis) {
        this(millis, TimeUnit.MILLISECONDS);
    }

    /**
     * Create a {@code Timeout} instance with the timeout specified
     * at the timeUnit of granularity of the provided {@code TimeUnit}.
     *
     * @param timeout the maximum time to allow the test to run
     * before it should timeout
     * @param timeUnit the time unit for the {@code timeout}
     * @since 4.12
     */
    public Timeout(long timeout, TimeUnit timeUnit) {
        this.timeout = timeout;
        this.timeUnit = timeUnit;
        lookForStuckThread = false;
    }

    /**
     * Create a {@code Timeout} instance initialized with values form
     * a builder.
     *
     * @since 4.12
     */
    protected Timeout(Builder builder) {
        timeout = builder.getTimeout();
        timeUnit = builder.getTimeUnit();
        lookForStuckThread = builder.getLookingForStuckThread();
    }

    /**
     * Creates a {@link Timeout} that will timeout a test after the
     * given duration, in milliseconds.
     *
     * @since 4.12
     */
    public static Timeout millis(long millis) {
        return new Timeout(millis, TimeUnit.MILLISECONDS);
    }

    /**
     * Creates a {@link Timeout} that will timeout a test after the
     * given duration, in seconds.
     *
     * @since 4.12
     */
    public static Timeout seconds(long seconds) {
        return new Timeout(seconds, TimeUnit.SECONDS);
    }

    /**
     * Gets the timeout configured for this rule, in the given units.
     *
     * @since 4.12
     */
    protected final long getTimeout(TimeUnit unit) {
        return unit.convert(timeout, timeUnit);
    }

    /**
     * Gets whether this {@code Timeout} will look for a stuck thread
     * when the test times out.
     *
     * @since 4.12
     */
    protected final boolean getLookingForStuckThread() {
        return lookForStuckThread;
    }

    /**
     * Creates a {@link Statement} that will run the given
     * {@code statement}, and timeout the operation based
     * on the values configured in this rule. Subclasses
     * can override this method for different behavior.
     *
     * @since 4.12
     */
    protected Statement createFailOnTimeoutStatement(
            Statement statement) throws Exception {
        return FailOnTimeout.builder()
            .withTimeout(timeout, timeUnit)
            .withLookingForStuckThread(lookForStuckThread)
            .build(statement);
    }

    public Statement apply(Statement base, Description description) {
        try {
            return createFailOnTimeoutStatement(base);
        } catch (final Exception e) {
            return new Statement() {
                @Override public void evaluate() throws Throwable {
                    throw new RuntimeException("Invalid parameters for Timeout", e);
                }
            };
        }
    }

    /**
     * Builder for {@link Timeout}.
     *
     * @since 4.12
     */
    public static class Builder {
        private boolean lookForStuckThread = false;
        private long timeout = 0;
        private TimeUnit timeUnit = TimeUnit.SECONDS;

        protected Builder() {
        }

        /**
         * Specifies the time to wait before timing out the test.
         *
         * <p>If this is not called, or is called with a
         * {@code timeout} of {@code 0}, the returned {@code Timeout}
         * rule instance will cause the tests to wait forever to
         * complete, however the tests will still launch from a
         * separate thread. This can be useful for disabling timeouts
         * in environments where they are dynamically set based on
         * some property.
         *
         * @param timeout the maximum time to wait
         * @param unit the time unit of the {@code timeout} argument
         * @return {@code this} for method chaining.
         */
        public Builder withTimeout(long timeout, TimeUnit unit) {
            this.timeout = timeout;
            this.timeUnit = unit;
            return this;
        }

        protected long getTimeout() {
            return timeout;
        }

        protected TimeUnit getTimeUnit()  {
            return timeUnit;
        }

        /**
         * Specifies whether to look for a stuck thread.  If a timeout occurs and this
         * feature is enabled, the rule will look for a thread that appears to be stuck
         * and dump its backtrace.  This feature is experimental.  Behavior may change
         * after the 4.12 release in response to feedback.
         *
         * @param enable {@code true} to enable the feature
         * @return {@code this} for method chaining.
         */
        public Builder withLookingForStuckThread(boolean enable) {
            this.lookForStuckThread = enable;
            return this;
        }

        protected boolean getLookingForStuckThread() {
            return lookForStuckThread;
        }


        /**
         * Builds a {@link Timeout} instance using the values in this builder.,
         */
        public Timeout build() {
            return new Timeout(this);
        }
    }
}
```

```java
public class ExpectedException implements TestRule {
    /**
     * Returns a {@linkplain TestRule rule} that expects no exception to
     * be thrown (identical to behavior without this rule).
     */
    public static ExpectedException none() {
        return new ExpectedException();
    }

    private final ExpectedExceptionMatcherBuilder matcherBuilder = new ExpectedExceptionMatcherBuilder();

    private String missingExceptionMessage= "Expected test to throw %s";

    private ExpectedException() {
    }

    /**
     * This method does nothing. Don't use it.
     * @deprecated AssertionErrors are handled by default since JUnit 4.12. Just
     *             like in JUnit &lt;= 4.10.
     */
    @Deprecated
    public ExpectedException handleAssertionErrors() {
        return this;
    }

    /**
     * This method does nothing. Don't use it.
     * @deprecated AssumptionViolatedExceptions are handled by default since
     *             JUnit 4.12. Just like in JUnit &lt;= 4.10.
     */
    @Deprecated
    public ExpectedException handleAssumptionViolatedExceptions() {
        return this;
    }

    /**
     * Specifies the failure message for tests that are expected to throw 
     * an exception but do not throw any. You can use a {@code %s} placeholder for
     * the description of the expected exception. E.g. "Test doesn't throw %s."
     * will fail with the error message
     * "Test doesn't throw an instance of foo.".
     *
     * @param message exception detail message
     * @return the rule itself
     */
    public ExpectedException reportMissingExceptionWithMessage(String message) {
        missingExceptionMessage = message;
        return this;
    }

    public Statement apply(Statement base,
            org.junit.runner.Description description) {
        return new ExpectedExceptionStatement(base);
    }

    /**
     * Verify that your code throws an exception that is matched by
     * a Hamcrest matcher.
     * <pre> &#064;Test
     * public void throwsExceptionThatCompliesWithMatcher() {
     *     NullPointerException e = new NullPointerException();
     *     thrown.expect(is(e));
     *     throw e;
     * }</pre>
     */
    public void expect(Matcher<?> matcher) {
        matcherBuilder.add(matcher);
    }

    /**
     * Verify that your code throws an exception that is an
     * instance of specific {@code type}.
     * <pre> &#064;Test
     * public void throwsExceptionWithSpecificType() {
     *     thrown.expect(NullPointerException.class);
     *     throw new NullPointerException();
     * }</pre>
     */
    public void expect(Class<? extends Throwable> type) {
        expect(instanceOf(type));
    }

    /**
     * Verify that your code throws an exception whose message contains
     * a specific text.
     * <pre> &#064;Test
     * public void throwsExceptionWhoseMessageContainsSpecificText() {
     *     thrown.expectMessage(&quot;happened&quot;);
     *     throw new NullPointerException(&quot;What happened?&quot;);
     * }</pre>
     */
    public void expectMessage(String substring) {
        expectMessage(containsString(substring));
    }

    /**
     * Verify that your code throws an exception whose message is matched 
     * by a Hamcrest matcher.
     * <pre> &#064;Test
     * public void throwsExceptionWhoseMessageCompliesWithMatcher() {
     *     thrown.expectMessage(startsWith(&quot;What&quot;));
     *     throw new NullPointerException(&quot;What happened?&quot;);
     * }</pre>
     */
    public void expectMessage(Matcher<String> matcher) {
        expect(hasMessage(matcher));
    }

    /**
     * Verify that your code throws an exception whose cause is matched by 
     * a Hamcrest matcher.
     * <pre> &#064;Test
     * public void throwsExceptionWhoseCauseCompliesWithMatcher() {
     *     NullPointerException expectedCause = new NullPointerException();
     *     thrown.expectCause(is(expectedCause));
     *     throw new IllegalArgumentException(&quot;What happened?&quot;, cause);
     * }</pre>
     */
    public void expectCause(Matcher<? extends Throwable> expectedCause) {
        expect(hasCause(expectedCause));
    }

    private class ExpectedExceptionStatement extends Statement {
        private final Statement next;

        public ExpectedExceptionStatement(Statement base) {
            next = base;
        }

        @Override
        public void evaluate() throws Throwable {
            try {
                next.evaluate();
            } catch (Throwable e) {
                handleException(e);
                return;
            }
            if (isAnyExceptionExpected()) {
                failDueToMissingException();
            }
        }
    }

    private void handleException(Throwable e) throws Throwable {
        if (isAnyExceptionExpected()) {
            assertThat(e, matcherBuilder.build());
        } else {
            throw e;
        }
    }

    private boolean isAnyExceptionExpected() {
        return matcherBuilder.expectsThrowable();
    }

    private void failDueToMissingException() throws AssertionError {
        fail(missingExceptionMessage());
    }
    
    private String missingExceptionMessage() {
        String expectation= StringDescription.toString(matcherBuilder.build());
        return format(missingExceptionMessage, expectation);
    }
}
```

#### RuleChain

RuleChain 提供一种将多个 TestRule 串在一起执行的机制，它首先从 outChain() 方法开始创建一个最外层的 TestRule 创建的 Statement，而后调用 round() 方法，不断向内层添加 TestRule 创建的 Statement。如其注释文档中给出的一个例子：

```java
 @Rule
public TestRule chain= RuleChain
	.outerRule(new LoggingRule("outer rule"))
	.around(new LoggingRule("middle rule"))
	.around(new LoggingRule("inner rule"));
```

如果LoggingRule只是类似ExternalResource中的实现，并且在before()方法中打印starting…，在after()方法中打印finished…，那么这条链的执行结果为：

```shell
starting outer rule
starting middle rule
starting inner rule
finished inner rule
finished middle rule
finished outer rule
```

由于 TestRule 的 apply() 方法是根据的当前传入的 Statement，创建一个新的 Statement，以决定当前 TestRule 逻辑的执行位置，因而第一个调用 apply() 的 TestRule 产生的 Statement 将在 Statement 链的最里面，也正是有这样的逻辑，所以around() 方法实现的时候，都是把新加入的 TestRule 放在第一个位置，然后才保持其他已存在的 TestRule 位置不变。其原型如下：

```java
public class RuleChain implements TestRule {
    private static final RuleChain EMPTY_CHAIN = new RuleChain(
            Collections.<TestRule>emptyList());

    private List<TestRule> rulesStartingWithInnerMost;

    /**
     * Returns a {@code RuleChain} without a {@link TestRule}. This method may
     * be the starting point of a {@code RuleChain}.
     *
     * @return a {@code RuleChain} without a {@link TestRule}.
     */
    public static RuleChain emptyRuleChain() {
        return EMPTY_CHAIN;
    }

    /**
     * Returns a {@code RuleChain} with a single {@link TestRule}. This method
     * is the usual starting point of a {@code RuleChain}.
     *
     * @param outerRule the outer rule of the {@code RuleChain}.
     * @return a {@code RuleChain} with a single {@link TestRule}.
     */
    public static RuleChain outerRule(TestRule outerRule) {
        return emptyRuleChain().around(outerRule);
    }

    private RuleChain(List<TestRule> rules) {
        this.rulesStartingWithInnerMost = rules;
    }

    /**
     * Create a new {@code RuleChain}, which encloses the {@code nextRule} with
     * the rules of the current {@code RuleChain}.
     *
     * @param enclosedRule the rule to enclose.
     * @return a new {@code RuleChain}.
     */
    public RuleChain around(TestRule enclosedRule) {
        List<TestRule> rulesOfNewChain = new ArrayList<TestRule>();
        rulesOfNewChain.add(enclosedRule);
        rulesOfNewChain.addAll(rulesStartingWithInnerMost);
        return new RuleChain(rulesOfNewChain);
    }

    /**
     * {@inheritDoc}
     */
    public Statement apply(Statement base, Description description) {
        for (TestRule each : rulesStartingWithInnerMost) {
            base = each.apply(base, description);
        }
        return base;
    }
}
```

#### TestRule 在 Statement 的运行

TestRule 实例的运行都是被封装在一个叫 RunRules 的 Statement 中运行的。在构造 RunRules 实例是传入 TestRule 实例的集合，然后遍历所有的 TestRule 实例，为每个 TestRule 实例调用一遍 apply() 方法以构造出要执行 TestRule 的 Statement 链。类似 RuleChain，这里在前面的 TestRule 构造的 Statement 被是最终构造出的 Statement 的最里层，结合 TestClass 在获取注解字段的顺序时，先查找子类，再查找父类，因而子类的 TestRule 实例产生的 Statement 是在 Statement 链的最里层，从而保证了类似 ExternalResource 实现中，before() 方法的执行父类要比子类要早，而 after() 方法的执行子类要比父类要早的特性。RunRules 的原型如下：

```java
public class RunRules extends Statement {
    private final Statement statement;

    public RunRules(Statement base, Iterable<TestRule> rules, Description description) {
        statement = applyAll(base, rules, description);
    }

    @Override
    public void evaluate() throws Throwable {
        statement.evaluate();
    }

    private static Statement applyAll(Statement result, Iterable<TestRule> rules,
            Description description) {
        for (TestRule each : rules) {
            result = each.apply(result, description);
        }
        return result;
    }
}
```

一个典型的 @Rule 示例如下：

```java
import java.io.Closeable;
import java.io.IOException;

import org.junit.After;
import org.junit.AfterClass;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Rule;
import org.junit.Test;
import org.junit.rules.ExternalResource;

public class RulesTest {
    @Rule
    public ExternalResource resource = new ExpensiveExternalResource();
    private ManagedResource myManagedResource;
    private static ExpensiveManagedResource MyExpensiveManagedResource;

    static class ExpensiveExternalResource extends ExternalResource {
        ExpensiveExternalResource() {
            System.out.println("ExpensiveExternalResource constructor");
        }

        @Override
        protected void before() throws Throwable {
            System.out.println("ExpensiveExternalResource before");
        }

        @Override
        protected void after() {
            System.out.println("ExpensiveExternalResource after");
        }
    }

    static class ExpensiveManagedResource implements Closeable {
        @Override
        public void close() throws IOException {
        }
    }

    static class ManagedResource implements Closeable {
        @Override
        public void close() throws IOException {
        }
    }

    @BeforeClass
    public static void setUpClass() {
        System.out.println("RulesTest @BeforeClass setUpClass");
        MyExpensiveManagedResource = new ExpensiveManagedResource();
    }

    @AfterClass
    public static void tearDownClass() throws IOException {
        System.out.println("RulesTest @AfterClass tearDownClass");
        MyExpensiveManagedResource.close();
        MyExpensiveManagedResource = null;
    }

    @Before
    public void setUp() {
        System.out.println("RulesTest @Before setUp");
        this.myManagedResource = new ManagedResource();
    }

    @After
    public void tearDown() throws IOException {
        System.out.println("RulesTest @After tearDown()");
        this.myManagedResource.close();
        this.myManagedResource = null;
    }

    @Test
    public void test1() {
        System.out.println("RulesTest @Test test1()");
    }

    @Test
    public void test2() {
        System.out.println("RulesTest @Test test2()");
    }
}
```

运行结果如下：

```powershell
RulesTest @BeforeClass setUpClass
ExpensiveExternalResource constructor
ExpensiveExternalResource before
RulesTest @Before setUp
RulesTest @Test test1()
RulesTest @After tearDown()
ExpensiveExternalResource after
ExpensiveExternalResource constructor
ExpensiveExternalResource before
RulesTest @Before setUp
RulesTest @Test test2()
RulesTest @After tearDown()
ExpensiveExternalResource after
RulesTest @AfterClass tearDownClass
```

从结果可以看出，ExternalResource 的 before() 方法在 @Before 方法之前被调用，可见其作用与  @Before 方法类似；ExternalResource 的 after() 方法在 @After 方法之后被调用之后调用，可见其作用与  @After 方法类似；ExternalResource 用来抽象出重用资源管理代码是一种不错方的法。可以使用子类管理资源的使用，从而达到代码的高度重用。

下面的测试类在每次执行测试之前先创建一个临时文件夹，在每个测试执行结束后在删除该临时文件夹：

```java
public static class HasTempFolder {
	@Rule
	public TemporaryFolder folder= new TemporaryFolder();
  
  	@Test
	public void testUsingTempFolder() throws IOException {
		File createdFile= folder.newFile("myfile.txt");
		File createdFolder= folder.newFolder("subfolder");
		// ...
	}
}
```

也可以用 @Rule 修饰的方法来完成：

```java
public static class HasTempFolder {
	private TemporaryFolder folder= new TemporaryFolder();
  
	@Rule
	public TemporaryFolder getFolder() {
 		return folder;
	}
  
	@Test
	public void testUsingTempFolder() throws IOException {
		File createdFile= folder.newFile("myfile.txt");
		File createdFolder= folder.newFolder("subfolder");
		// ...
	}
}
```



