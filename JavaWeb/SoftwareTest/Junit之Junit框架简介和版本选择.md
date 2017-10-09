### 单元测试

单元测试是指对软件中的最小可测试单元进行检查和验证。对于单元测试中单元的含义，一般来说，要根据实际情况去判定其具体含义，如C语言中单元指一个函数，Java里单元指一个类，图形化的软件中可以指一个窗口或一个菜单等。可以说，单元就是人为规定的最小的被测功能模块。单元测试是在软件开发过程中要进行的最低级别的测试活动，软件的独立单元将在与程序的其他部分相隔离的情况下进行测试。

单元测试框架应该遵循以下几条最佳实践原则：

- 每个单元测试都必须独立于其他所有单元测试而运行；
- 框架应该以单个测试为单位来检测和报告错误；
- 应该易于定义要运行哪些单元测试。

为了满足第三条规则，就需要为每个要测试的方法编写大量的测试代码，开始看起来有些费力不讨好，但随着测试方法的不断增加，这么做是非常值得的。





hamcrest简介和TestSuite

hamcrest可以有效增加junit的测试能力，用一些相对通俗的语言来进行测试

如要使用junit中的assertThat来进行断言
第一个参数表示实际值，第二个参数表示hamcrest的表达式

```java
@Test  
public void testHamcrest() {  
    //首先需要静态导入import static org.hamcrest.Matchers.*;  
    //判断50是否大于20并且小于60，具体的hamcrest的比较参数可以在文档中查询  
    assertThat(50, allOf(greaterThan(20), lessThan(60)));  
    //判断某个字符串是否以另一个字符串结尾  
    assertThat("abc.txt", endsWith("txt"));  
}  
```

常用的比较方式
逻辑
  allOf - 如果所有匹配器都匹配才匹配, short circuits (很难懂的一个词,意译是短路,感觉不对,就没有翻译)(像 Java &&)
  anyOf - 如果任何匹配器匹配就匹配, short circuits (像 Java ||)
  not - 如果包装的匹配器不匹配器时匹配,反之亦然
对象
  equalTo - 测试对象相等使用Object.equals方法
  hasToString - 测试Object.toString方法
  instanceOf, isCompatibleType - 测试类型
  notNullValue, nullValue - 测试null
  sameInstance - 测试对象实例
  Beans
  hasProperty - 测试JavaBeans属性
集合
  array - 测试一个数组元素test an array’s elements against an array of matchers
  hasEntry, hasKey, hasValue - 测试一个Map包含一个实体,键或者值
  hasItem, hasItems - 测试一个集合包含一个元素
  hasItemInArray - 测试一个数组包含一个元素
数字
  closeTo - 测试浮点值接近给定的值
  greaterThan, greaterThanOrEqualTo, lessThan, lessThanOrEqualTo - 测试次序
文本
  equalToIgnoringCase - 测试字符串相等忽略大小写
  equalToIgnoringWhiteSpace - 测试字符串忽略空白
  containsString, endsWith, startsWith - 测试字符串匹配
可以通过TestSuit来组成多个测试组件

果一个方法被 @Before 修饰过了，那么在每个测试方法调用之前，这个方法都会得到调用。所以上面的例子中， testAdd() 被运行之前， setup() 会被调用一次，把 mCalculator 实例化，接着运行 testAdd() ； testMultiply() 被运行之前， setup() 又会被调用一次，把 mCalculator 再次实例化，接着运行 testMultiply() 。如果还有其他的测试方法，则以此类推。

对应于 @Before 的，有一个 @After ，作用估计你也猜得到，那就是每个测试方法运行结束之后，会得到运行的方法。比如一个测试文件操作的类，那么在它的测试类中，可能 @Before 里面需要去打开一个文件，而每个测试方法运行结束之后，都需要去close这个文件。这个时候就可以把文件close的操作放在 @After 里面，让它自动去执行。

类似的，还有 @BeforeClass 和 @AfterClass 。 @BeforeClass 的作用是，在跑一个测试类的所有测试方法之前，会执行一次被 @BeforeClass 修饰的方法，执行完所有测试方法之后，会执行一遍被 @AfterClass 修饰的方法。这两个方法可以用来setup和release一些公共的资源，需要注意的是，被这两个annotation修饰的方法必须是静态的



JUnit为我们提供的assert方法，多数都在 Assert 这个类里面。最常用的那些如下：

assertEquals(expected, actual)
验证expected的值跟actual是一样的，如果是一样的话，测试通过，不然的话，测试失败。如果传入的是object，那么这里的对比用的是equals()

assertEquals(expected, actual, tolerance)
这里传入的expected和actual是float或double类型的，大家知道计算机表示浮点型数据都有一定的偏差，所以哪怕理论上他们是相等的，但是用计算机表示出来则可能不是，所以这里运行传入一个偏差值。如果两个数的差异在这个偏差值之内，则测试通过，否者测试失败。

assertTrue(boolean condition)
验证contidion的值是true

assertFalse(boolean condition)
验证contidion的值是false

assertNull(Object obj)
验证obj的值是null

assertNotNull(Object obj)
验证obj的值不是null

assertSame(expected, actual)
验证expected和actual是同一个对象，即指向同一个对象

assertNotSame(expected, actual)
验证expected和actual不是同一个对象，即指向不同的对象

fail()
让测试方法失败

注意：上面的每一个方法，都有一个重载的方法，可以在前面加一个String类型的参数，表示如果验证失败的话，将用这个字符串作为失败的结果报告。

比如：

assertEquals("Current user Id should be 1", 1, currentUser.id());

当 currentUser.id() 的值不是1的时候，在结果报道里面将显示"Current user Id should be 1"，这样可以让测试结果更具有可读性，更清楚错误的原因是什么。

比较有意思的是最后一个方法， fail() ，你或许会好奇，这个有什么用呢？其实这个在很多情况下还是有用的，比如最明显的一个作用就是，你可以验证你的测试代码真的是跑了的。

此外，它还有另外一个重要作用，那就是验证某个被测试的方法会正确的抛出异常，不过这点可以通过下面讲到的方法，更方便的做到，所以就不讲了。



使用[spring](http://lib.csdn.net/base/javaee)的[测试](http://lib.csdn.net/base/softwaretest)框架需要加入以下依赖包：

- JUnit 4 
- Spring Test （Spring框架中的test包）
- Spring 相关其他依赖包（不再赘述了，就是context等包）

在此，推荐创建一个和src平级的源文件目录，因为src内的类都是为日后产品准备的，而此处的类仅仅用于测试。而包的名称可以和src中的目录同名，这样由于在test源目录中，所以不会有冲突，而且名称又一模一样，更方便检索。这也是Maven的约定。

 1、测试方法上必须使用@Test进行修饰

 2、测试方法必须使用public void 进行修饰，不能带任何参数

 3、新建一个源代码目录来存放我们的测试代码

 4、测试类的包应该和被测试类保持一致

 5、测试单元中的每个方法必须可以独立测试，测试间不能有任何的依赖

 6、测试类使用Test作为类名的后缀。（不是必须）

 7、测试方法使用test作为方法名的后缀。（不是必须）

# 测试失败的两种情况

  

Failure：一般由单元测试使用的断言方法判断失败所引起的，这表示测试点发现了问题，就是说程序输出的结果和我们预期的不一样；

error：是由代码异常所引起的，它可以产生于测试代码本身的错误，也可以是被测式代码中的一个隐藏的bug；

JUnit的运行流程

@BeforeClass
修饰的方法会在所有方法被调用前执行，而且该方法是静态的，所以当测试类被加载后就接着就会运行它；而且在内存中它只会存在一份实例，它比较适合加载配置文件；
@AfterClass
所修饰的方法通常用来对资源的清理，如关闭数据库的连接；
@Before和@After
会在每个测试方法的前后各执行一次；

JUnit的常用注解

@Test:将一个普通的方法修饰成为一个测试方法
@Test(expected=XX.class) @Test(timeout=毫秒 )
 --->用于测试死循环，性能测试
@BeforeClass：它会在所有的方法运行前被执行，static修饰
@AfterClass:它会在所有的方法运行结束后被执行，static修饰
@Before：会在每一个测试方法被运行前执行一次
@After：会在每一个测试方法运行后被执行一次
@Ignore:所修饰的测试方法会被测试运行器忽略
@RunWith:可以更改测试运行器 org.junit.runner.Runner

JUnit中测试套件的使用

1、测试套件就是组织测试类一起运行的
写一个作为测试套件的入口类，是一个空类，类中不能包含其他方法，更改测试运行器为Suite.class，将要测试的类作为数组传入到Suite.SuiteClasses({})中。
2、测试套件中也可以包含其他的测试套件，加载得方式和加载测试类是一样的（）即类名.class；

JUnit的参数化设置

1.更改默认的测试运行器为RunWith(Parameterized.class
2.声明变量来存放预期值 和结果值
3.声明一个返回值 为Collection的公共静态方法，并使用@Parameters进行修饰
4.为测试类声明一个带有参数的公共构造函数，并在其中为之声明变量赋值

| @Test(timeout=200)                       | 表示下面的测试是限时测试，如果超过规定的时间，就测试失败        |
| ---------------------------------------- | ----------------------------------- |
| @Test(expected=IllegalArgumentException.class) | 异常测试，验证方法能否抛出预期的错误                  |
| @Ignore                                  | 注释掉一个测试方法或一个类，被注释的方法或类，不会被执行        |
| @BeforeClass                             | 修饰static的方法，在整个类执行之前执行该方法一次。        |
| @AfterClass                              | 同样修饰static的方法，在整个类执行结束前执行一次。如释放资源   |
| @Before                                  | 修饰public void的方法，在每个测试用例（方法）执行时都会执行 |
| @After                                   | 修饰public void的方法，在每个测试用例执行结束后执行     |

@Before：
使用了该元数据的方法在每个测试方法执行之前都要执行一次。

@After：
使用了该元数据的方法在每个测试方法执行之后要执行一次。

注意：@Before和@After标示的方法只能各有一个。这个相当于取代了JUnit以前版本中的setUp和tearDown方法，当然你还可以继续叫这个名字，不过JUnit不会霸道的要求你这么做了。

@Test(expected=*.class)
在JUnit4.0之前，对错误的测试，我们只能通过fail来产生一个错误，并在try块里面assertTrue（true）来测试。现在，通过@Test元数据中的expected属性。expected属性的值是一个异常的类型

@Test(timeout=xxx):
该元数据传入了一个时间（毫秒）给测试方法，
如果测试方法在制定的时间之内没有运行完，则测试也失败。

@ignore：
该元数据标记的测试方法在测试中会被忽略。当测试的方法还没有实现，或者测试的方法已经过时，或者在某种条件下才能测试该方法（比如需要一个数据库联接，而在本地测试的时候，数据库并没有连接），那么使用该标签来标示这个方法。同时，你可以为该标签传递一个String的参数，来表明为什么会忽略这个测试方法。比如：@lgnore(“该方法还没有实现”)，在执行的时候，仅会报告该方法没有实现，而不会运行测试方法。







