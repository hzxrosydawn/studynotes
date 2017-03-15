## 泛型入门

### 编译时不检查类型的异常

```java
public class ListErr {
    public static void main(String[] args) {
        // 创建一个只想保存字符串的List集合
        List strList = new ArrayList();
        strList.add("布达佩斯");
        strList.add("布拉格");
        // "不小心"把一个Integer对象"丢进"了集合
        strList.add(34);
        strList.forEach(str -> System.out.println(((String)str).length()));
    }
}
```

上述程序创建了一个List集合，且该List集合保存字符串对象——但程序不能进行任何限制，如果程序在①处“不小心”把一个Integer对象"丢进"了List集合，这将导致程序在②处引发**ClassCastException异常**，因为程序试图把一个Integer对象转换为String类型

### 使用泛型

参数化类型，允许程序在创建集合时指定集合元素的类型。Java的参数化类型被称为泛型(Generic)

```java
class GenericList {
    public static void main(String[] args) {
        // 创建一个只想保存字符串的List集合
        List<String> strList = new ArrayList<>();
        strList.add("布达佩斯");
        strList.add("布拉格");
        // 下面代码将引起编译错误
        strList.add(34);
        strList.forEach(str -> System.out.println(((String)str).length()));
    }
}
```

strList集合只能保存字符串对象，不能保存其他类型的对象。创建特殊集合的方法是：**在集合接口、类后增加尖括号，尖括号里放一个数据类型，即表明这个集合接口、集合类只能保存特定类型的对象**

①类型声明，在创建这个ArrayList对象时也指定了一个类型参数；②引发编译异常；③不需要进行强制类型转换

泛型使程序更加简洁，集合自动记住所有集合元素的数据类型，从而无须对集合元素进行强制类型转换

### Java7泛型的“菱形”语法

Java允许在**构造器后不需要带完整的泛型信息，只要给出一对尖括号(<>)即可**，Java可以推断尖括号里应该是什么泛型信息

```java
public class DiamondTest {
    public static void main(String[] args) {
        // Java自动推断出ArrayList的<>里应该是String
        List<String> countries = new ArrayList<>();
        countries.add("法兰西第五共和国");
        countries.add("西班牙王国");
        // 遍历countries集合，集合元素就是String类型
        countries.forEach(ele -> System.out.println(ele.length()));
        // Java自动推断出HashMap的<>里应该是String , List<String>
        Map<String , List<String>> citiesInfo = new HashMap<>();
        // Java自动推断出ArrayList的<>里应该是String
        List<String> cities = new ArrayList<>();
        cities.add("巴黎");
        cities.add("巴塞罗那");
        citiesInfo.put("Bienvenue" , cities);
        // 遍历Map时，Map的key是String类型，value是List<String>类型
        citiesInfo.forEach((key , value) -> System.out.println(key + "-->" + value));
    }
}
```

## 深入泛型

**所谓泛型：就是允许在定义类、接口、方法时指定类型形参，这个类型形参将在声明变量、创建对象、调用方法时动态地指定(即传入实际的类型参数，也可称为类型实参)**

### 定义泛型接口、类

List接口、Iterator接口、Map的代码片段

```java
// 定义接口时指定了一个类型形参，该形参名为E
public interface List<E> {
    // 在该接口里，E可作为类型使用
    // 下面方法可以使用E作为参数类型
    void add(E x);
    Iterator<E> iterator(); 
}

// 定义接口时指定了一个类型形参，该形参为E
public interface Iterator<E> {
    // 在该接口里E完全可以作为类型使用
    E next();
    boolean hasNext();
}

// 定义该接口时指定了两个类型形参，其形参名为K、V
public interface Map<K, V> {
    // 在该接口里K、V完全可以作为类型使用
    Set<K> keySet(); 
    V put(K key,V value);
}
```

上面代码说明泛型实质：允许在定义接口、类时声明类型形参，类型形参在整个接口、类体内可当成类型使用

包含泛型声明的类型可以在定义变量、创建对象时传入一个类型实参，从而可以动态地生成无数个逻辑上的子类，但这种子类在物理上并不存在

可以为任何类、接口增加泛型声明（并不是只有集合类才可以使用泛型声明，虽然集合类是泛型的重要使用场所）

```java
// 定义Onmyoji类时使用了泛型声明
public class Onmyoji<T> {
    // 使用T类型形参定义实例变量
    private T info;
    public Onmyoji(){}
    // 下面方法使用T类型形参来定义构造器
    public Onmyoji(T info) {
        this.info = info;
    }
    public T getInfo() {
        return info;
    }
    public void setInfo(T info) {
        this.info = info;
    }
    public static void main(String[] args) {
        //由于传给T形参的是String，所以构造器参数只能是String
        Onmyoji<String> a1 = new Onmyoji<>("安倍晴明");
        System.out.println(a1.getInfo());
        // 由于传给T形参的是Double，所以构造器参数只能是Double或double
        Onmyoji<Double> a2 = new Onmyoji<>(520.1314);
        System.out.println(a2.getInfo());
    }
}
```

**当创建带泛型声明的自定义类，为该类定义构造器时，构造器名还是原来的类名，不要增加泛型声明**

### 从泛型类派生子类

当创建了带泛型声明的接口、父类之后，可以为该接口创建实现类，或从父类派生子类。当使用这些接口、父类时不能再包含类型形参

```java
// 定义类Shikigami继承Onmyoji类，Onmyoji类不能跟类型形参
public class Shikigami extends Onmyoji<T>{ }        // 错误
```

方法中的形参（或数据形参）代表变量、常量、表达式等数据。定义方法时，可以声明数据形参；调用方法（使用方法）时，必须为这些数据形参传入实际的数据；与此类似的是，**定义类、接口、方法时可以声明类型形参，使用类、接口、方法时应为类型形参传入实际的类型**

```java
// 使用Onmyoji类时为T形参传入String类型
public class Shikigami extends Onmyoji<String>{ }        // 正确
```

调用方法时必须为所有的数据参数传入参数值，而使用类、接口时也可以不为类型形参传入实际的类型参数

```java
// 使用Onmyoji类时，没有为T形参传入实际的类型参数
public class Shikigami extends Onmyoji{ }        // 正确
```

子类需要重写父类的Getters和Setters方法

```java
private String info;
public String getInfo() {
    return "子类"+ super.getInfo();
}
public void setInfo(String info) {
    this.info = info;
}
```

### 并不存在泛型类

ArrayList<String>类，是一种特殊的ArrayList类。该ArrayList<String>对象只能添加String对象作为集合元素。但实际上，系统并没有为ArrayList<String>生成新的class文件，而且也不会把ArrayList<String>当成新类来处理。因为不管泛型的时间类型参数是什么，它们在运行时总有同样的类(class)

```java
// 分别创建List<String>对象和List<Integer>对象
List<String> l1 = new ArrayList<>();
List<Integer> l2 = new ArrayList<>();
// 调用getClass()方法来比较l1和l2的类是否相等
System.out.println(l1.getClass() == l2.getClass());        // 输出true
```

**不管为泛型的类型形参传入哪一种类型实参，对于Java来说，它们依然被当成同一个类处理，在内存中也只占用一块内存空间，因此在静态方法、静态初始化块或者静态变量的声明和初始化中不允许使用类型形参**

```java
public class R<T> {
    static T info;    // 代码错误，不能在静态变量声明中使用类型形参
    T age;
    public void foo(T msg){}
    public static void bar(T msg){}    // 代码错误，不能在静态方法声明中使用类型形参
}
```

由于系统中并不会真正生成泛型类，所以instanceof运算符后不能使用泛型类。

```java
if(cs instanceof List<String>) {
    ...
} 

```

## 类型通配符

如果Foo是Bar的一个子类型（子类或者子接口），而G是具有泛型声明的类或接口，G<Foo>并不是G<Bar>的子类型

**数组和泛型有所不同，假设Foo是Bar的一个子类型（子类或者子接口），那么Foo[]依然是Bar[]的子类型；但G<Foo>不是G<Bar>的子类型**

**Java泛型的设计原则是，只要代码在编译时没有出现警告，就不会遇到运行时ClassCastException异常**

### 使用类型通配符

为了表示各种泛型List的父类，可以使用类型通配符，类型通配符是一个问号(?)，将一个问号作为类型实参传给List集合，写作：List<?>（意思是未知类型元素的List）。这个问号(?)被称为通配符，它的元素类型可以匹配任何类型

```java
public void test(List<?> c) {
    for(int i = 0; i < c.size(); i++) {
        System.out.println(c.get(i));
    }
}
```

现在使用任何类型的List来调用它，程序依然可以访问集合c中的元素，其类型是Object，这永远是安全的，因为不管List的真实类型是什么，它包含的都是 Object

这种带通配符的List仅表示它是各种泛型List的父类，并不能把元素加入到其中

```java
List<?> c = new ArrayList<String>();    
// 下面程序引起编译错误
c.add(new Object());
```

**因为程序无法确认c集合里元素的类型，所以不能向其中添加对象。**根据前面的List<E>接口定义的代码可以发现：add ()方法由类型参数E作为集合的元素类型，所以传给add的参数必须是E类的对象或者其子类的对象。但因为在该例中不知道E是什么类型，所以程序无法将任何对象“丢进”该集合。**唯一的例外是 null，它是所有引用类型的实例**

另一方面，程序可以调用get()方法来返回List<?>集合指定索引处的元素，其返回值是一个未知类型，但可以肯定的是，它总是一个Object。因此，把get()的返回值赋值给一个Object类型的变量，或者放在任何希望是Object类型的地方都可以

### 设定类型通配符的上限

List<Circle>并不是List<Shape>的子类型，所以不能把List<Circle>对象当成List<Shape>使用。为了表示List<Circle>的父类，使用List<? extends Shape>

**List<? extends Shape>是受限通配符**的例子，此处的问号(?)代表一个未知的类型，此处的未知类型一定是Shape的子类也可以是Shape，因此可以把shape称为这个通配符的上限（upper bound）

### 设定类型形参的上限

Java泛型不仅允许在使用通配符形参时设定上限，而且可以在定义类型形参时设定上限，用于表示传给该类型形参的实际类型要么是该上限类型，要门是该上限类型的子类

在一种更极端的情况下，程序需要为类型形参设定多个上限（至少有一个父类上限，可以有多个接口上限），表明该类型形参必须是其父类的子类（其父类本事也行），并且实现多个上限接口

```java
//表明T类型必须是Number类或其子类，并必须实现java.io.Serializablepublic 
class Apple<T extends Number & java.io.Serilizable>
{
    ...
}
```

与类同时继承父类、实现接口类似的是：为类型形参指定多个上限，所有的接口上限必须位于类上限之后。也就是说，如果需要为类型形参指定类上限，类上限必须位于第一位

## 泛型方法

### 定义泛型方法

**Java不允许把对象放进一个未知类型的集合中**

所谓泛型方法，就是在声明方法时定义一个或多个类型形参

```java
修饰符 <T, S> 返回值类型 方法名(形参列表) {
    // 方法体...
}
```

把上面方法的格式和普通方法的格式进行对比，不难发现泛型方法的方法签名比普通方法的方法签名多了类型形参声明，类型形参声明以尖括号括起来，多个类型形参之间以逗号隔开，所有的类型形参声明放在方法修饰符和方法返回值类型之间

```java
public class GenericMethodTest {
    // 声明一个泛型方法，该泛型方法中带一个T类型形参，
    static <T> void fromArrayToCollection(T[] a, Collection<T> c) {
        for (T o : a)
        {
            c.add(o);
        }
    }
    public static void main(String[] args) {
        Object[] oa = new Object[100];
        Collection<Object> co = new ArrayList<>();
        // 下面代码中T代表Object类型
        fromArrayToCollection(oa, co);
        String[] sa = new String[100];
        Collection<String> cs = new ArrayList<>();
        // 下面代码中T代表String类型
        fromArrayToCollection(sa, cs);
        // 下面代码中T代表Object类型
        fromArrayToCollection(sa, co);
        Integer[] ia = new Integer[100];
        Float[] fa = new Float[100];
        Number[] na = new Number[100];
        Collection<Number> cn = new ArrayList<>();
        // 下面代码中T代表Number类型
        fromArrayToCollection(ia, cn);
        // 下面代码中T代表Number类型
        fromArrayToCollection(fa, cn);
        // 下面代码中T代表Number类型
        fromArrayToCollection(na, cn);
        // 下面代码中T代表Object类型
        fromArrayToCollection(na, co);
        // 下面代码中T代表String类型，但na是一个Number数组，
        // 因为Number既不是String类型，
        // 也不是它的子类，所以出现编译错误
        // fromArrayToCollection(na, cs);
    }
}
```

为了让编译器能准确地推断出泛型方法中类型形参的类型，不要制造迷惑！系统一旦迷惑了，就是你错了！看如下程序

```java
public class ErrorTest {
    // 声明一个泛型方法，该泛型方法中带一个T类型形参
    static <T> void test(Collection<T> from, Collection<T> to) {
        for (T ele : from) {
            to.add(ele);
        }
    }
    public static void main(String[] args) {
        List<Object> as = new ArrayList<>();
        List<String> ao = new ArrayList<>();
        // 下面代码将产生编译错误
        test(as , ao);
    }
}
```

上面程序中定义了test方法，该方法用于将前一个集合里的元素复制到下一个集合中，该方法中的两个形参 from、to 的类型都是 Collection<T>，这要求调用该方法时的两个集合实参中的泛型类型相同，否则编译器无法准确地推断出泛型方法中类型形参的类型

上面程序中调用test方法传入了两个实际参数，其中as的数据类型是List<String>，而ao的数据类型是List<Object>，与泛型方法签名进行对比：test(Collection<T>a, Collection<T> c)编译器无法正确识别T所代表的实际类型。为了避免这种错误，可以将该方法改为如下形式：

```java
public class RightTest {
    // 声明一个泛型方法，该泛型方法中带一个T形参
    static <T> void test(Collection<? extends T> from , Collection<T> to) {
        for (T ele : from) {
            to.add(ele);
        }
    }
    public static void main(String[] args) {
        List<Object> ao = new ArrayList<>();
        List<String> as = new ArrayList<>();
        // 下面代码完全正常
        test(as , ao);
    }
}
```

上面代码改变了test方法签名，将该方法的前一个形参类型改为 Collection<? extends T>，这种采用类型通配符的表示方式，只要test方法的前一个Collection集合里的元素类型是后一个Collection集合里元素类型的子类即可

### 泛型方法和类型通配符的区别

**大多数时候都可以使用泛型方法来代替类型通配符**。例如，对于 Java 的 Collection 接口中两个方法定义：

```java
public interface Collection<E> {
    boolean containAll(Collection<?> c);
    boolean addAll(Collection<? extends E> c);
     ... 
}
```

上面集合中两个方法的形参都采用了类型通配符的形式，也可以采用泛型方法的形式，如下所示

```java
public interface Collection<E> {
    boolean <T> containAll(Collection<T> c); 
    boolean <T extends E> addAll(Collection<T> c); 
    ...
}
```

上面方法使用了<T extends E>泛型形式，这时定义类型形参时设定上限（其中E是 Collection 接口里定义的类型形参，在该接口里E可当成普通类型使用）。**上面两个方法中类型形参T只使用了一次，类型形参T产生的唯一效果是可以在不同的调用点传入不同的实际类型。对于这种情况，应该使用通配符：通配符就是被设计用来支持灵活的子类化的**

**泛型方法允许类型形参被用来表示方法的一个或多个参数之间的类型依赖关系，或者方法返回值与参数之间的类型依赖关系。**如果没有这样的类型依赖关系，就不应该使用泛型方法

**如果某个方法中一个形参（a）的类型或返回值的类型依赖于另一个形参（b）的类型，则形参（b）的类型声明不应该使用通配符----因为形参（a）或返回值的类型依赖于该形参（b）的类型，如果形参（b）的类型无法确定，程序就无法定义形参（a）的类型。在这种情况下，只能考虑使用在方法签名中声明类型形参 ——也就是泛型方法**

也可以同时使用泛型方法和通配符，如Java的Collections.copy方法

```java
public class Collections {
    public static <T> void copy(List<T> dest, List<? extends T> src)
{
        ...
    }
    ...
}
```

上面copy方法中的dest和src存在明显的依赖关系，从源List中复制出来的元素，必须可以“丢进”目标List中，所以源List集合元素的类型只能是目标集合元素的类型的子类型或者它本身。但JDK定义src形参类型时使用的是类型通配符，而不是泛型方法。这是因为：该方法无须向src集合中添加元素，也无须修改src集合里的元素，所以可以使用类型通配符，不使用泛型方法

类型通配符与泛型方法（在方法签名中显式声明类型形参）还有一个显著的区别：**类型通配符既可以在方法签名中定义形参的类型，也可以用于定义变量的类型；但泛型方法中的类型形参必须在对应方法中显式声明**

### Java7的“菱形”语法与泛型构造器

**Java允许在构造器签名中声明类型形参，这样就产生了所渭的泛型构造器。**一旦定义了泛型构造器，接下来在调用构造器时，就不仅可以让Java根据数据参数的类型来“推断”类型形参的类型，而且程序员也可以显式地为构造器中的类型形参指定实际的类型

```java
class Foo {
    public <T> Foo(T t) {
        System.out.println(t);
    }
}
public class GenericConstructor {
    public static void main(String[] args) {
        // 泛型构造器中的T参数为String。
        new Foo("疯狂Java讲义");
        // 泛型构造器中的T参数为Integer。
        new Foo(200);
        // 显式指定泛型构造器中的T参数为String，
        // 传给Foo构造器的实参也是String对象，完全正确。
        new <String> Foo("疯狂Android讲义");
        // 显式指定泛型构造器中的T参数为String，
        // 但传给Foo构造器的实参是Double对象，下面代码出错
        new <String> Foo(12.3);
    }
}
```

前面介绍过 Java 7 新增的“菱形”语法，它允许调用构造器时在构造器后使用一对尖括号来代表泛型信息。但如果程序显式指定了泛型构造器中声明的类型形参的实际类型，则不可以使用“菱形”语法

```java
class MyClass<E> {
    public <T> MyClass(T t) {
        System.out.println("t参数的值为：" + t);
    }
}
public class GenericDiamondTest {
    public static void main(String[] args) {
        // MyClass类声明中的E形参是String类型。
        // 泛型构造器中声明的T形参是Integer类型
        MyClass<String> mc1 = new MyClass<>(5);
        // 显式指定泛型构造器中声明的T形参是Integer类型，
        MyClass<String> mc2 = new <Integer> MyClass<String>(5);
        // MyClass类声明中的E形参是String类型。
        // 如果显式指定泛型构造器中声明的T形参是Integer类型
        // 此时就不能使用"菱形"语法，下面代码是错的。
        // MyClass<String> mc3 = new <Integer> MyClass<>(5);
    }
}
```

上面程序中最后一行代码既指定了泛型构造器中的类型形参是 Integer 类型，又想使用“菱形”语法，所以这行代码无法通过编译

### 设定通配符下限

实现将src集合里的元素复制到dest集合里的功能，因为dest集合可以保存src集合里的所有元素，所以dest集合元素的类型应该是src集合元素类型的父类，假设该方法需要一个返回值，返回最后一个被复制的元素。为了表示两个参数之间的类型依赖，考虑同时使用通配符、泛型参数来实现该方法

```java
public static <T> T copy(Collection<T> dest, Collection<? extends T> src) {
    T last = null;
    for (T ele : src) {
        last = ele;
        dest.add(ele); 
    } 
    return last; 
}
```

实际上有一个问题：当遍历src集合的元素时，src元素的类型是不确定的（但可以肯定它是T的子类），程序只能用T来笼统地表示各种src集合的元素类型

```java
List<Number> ln = new ArrayList<>; 
List<Integer> li = new ArrayList<>; 
// 下面代码引起编译错误 
Integer last = copy(ln, li);
```

ln的类型是List<Number>，与copy方法签名的形参类型进行对比即得到T的实际类型是 Number，而不是Integer类型——即copy方法的返回值也是Number类型，而不是Integer类型，但实际上是后一个复制元素的元素类型一定是 Integer。也就是说，**程序在复制集合元素的过程中，丢失src集合元素的类型**

对于上面的copy方法，可以这样理解两个集合参数之间的依赖关系：不管src集合元素的类型是什么，只要dest集合元素的类型与前者相同或是前者的父类即可。**Java允许设定通配符的下限：<? super Type>，这个通配符表示它必须是Type本身，或是Type的父类**

```java
public class MyUtils {
    // 下面dest集合元素类型必须与src集合元素类型相同，或是其父类
    public static <T> T copy(Collection<? super T> dest
        , Collection<T> src)  {
        T last = null;
        for (T ele  : src) {
            last = ele;
            dest.add(ele);
        }
        return last;
    }
    public static void main(String[] args) {
        List<Number> ln = new ArrayList<>();
        List<Integer> li = new ArrayList<>();
        li.add(5);
        // 此处可准确的知道最后一个被复制的元素是Integer类型
        // 与src集合元素的类型相同
        Integer last = copy(ln , li); 
        System.out.println(ln);
    }
}
```

使用这种语句，就可以保证程序的①处调用后推断出晟后一个被复制的元素类型是 Integer，而不是笼统的 Number 类型

### 泛型方法与方法重载

因为泛型既允许设定通配符的上限，也允许设定通配符的下限，从而允许在一个类里包含如下两个方法定义

```java
public class MyUtils { 
    public static <T> void copy(Collection<T> dest , Collection<? extends T> src) 
    {...}   
    public static <T> copy(Collection<? super T> dest, Collection<T> src) 
    {...}
}
```

MyUtils类中包含两个copy方法，这两个方法的参数列表存在一定的区别，但这种区别不是很明确：这两个方法的两个参数都是Collection对象，前一个集合里的集合元素类型是后一个集合里集合元素类型的父类。如果这个类仅包含这两个方法不会有任何错误，但只要调用这个方法就会引起编译错误

```java
List<Number> ln = new ArrayList<>; 
List<Integer> li = new ArrayList<>; 
copy(ln , li);
```

上面程序调用copy方法，但这个copy()方法既可以匹配①号copy方法，此时T类型参数的类型是 Number；也可以匹配②号copy()方法，此时T参数的类型是Integer。编译器无法确定这行代码想调用哪个copy()方法，所以这行代码将引起编译错误

### Java8改进的类型推断

Java8改进了泛型方法的类型推断能力，类型推断主要有如下两方面

- 可通过调用方法的上下文来推断类型参数的目标类型
- 可在方法调用链中，将推断得到的类型参数传递到最后一个方法

```java
class MyUtil<E> {
    public static <Z> MyUtil<Z> nil() {
        return null;
    }
    public static <Z> MyUtil<Z> cons(Z head, MyUtil<Z> tail) {
        return null;
    }
    E head() {
        return null;
    }
}
public class InferenceTest {
    public static void main(String[] args) {
        // 可以通过方法赋值的目标参数来推断类型参数为String
        MyUtil<String> ls = MyUtil.nil();
        // 无需使用下面语句在调用nil()方法时指定类型参数的类型
        MyUtil<String> mu = MyUtil.<String>nil();
        // 可调用cons方法所需的参数类型来推断类型参数为Integer
        MyUtil.cons(42, MyUtil.nil());
        // 无需使用下面语句在调用nil()方法时指定类型参数的类型
        MyUtil.cons(42, MyUtil.<Integer>nil());

        // 希望系统能推断出调用nil()方法类型参数为String类型，
        // 但实际上Java 8依然推断不出来，所以下面代码报错
        // String s = MyUtil.nil().head();
        String s = MyUtil.<String>nil().head();
    }
}

```

## 擦除和转换

在严格的泛型代码里，带泛型声明的类总应该带着泛型参数。但是为了和古老的java代码保持一致，也就是说为了向下兼容，也允许在使用带泛型声明的类时不指定实际的类型参数。如果没有为这个泛型指定实际的类型参数，则该类型参数被称作raw type（原始类型），默认是声明该类型参数时指定的第一个上限类型

当把一个具体泛型信息的对象赋值给另外一个没有泛型信息的变量时，所有尖括号之间的类型信息都将被扔掉。比如说将一个List<String>类型赋值给一个list，这个时候原来的这个List<String>集合的类型就变成了类型参数的上限了，也就是Object

```java
class Apple<T extends Number> {
    T size;
    public Apple() {
    }
    public Apple(T size) {
        this.size = size;
    }
    public void setSize(T size) {
        this.size = size;
    }
    public T getSize() {
        return this.size;
    }
}
public class ErasureTest {
    public static void main(String[] args) {
        Apple<Integer> a = new Apple<>(6); 
        // a的getSize()方法返回Integer对象
        Integer as = a.getSize();
        // 把a对象赋给Apple变量，丢失尖括号里的类型信息
        Apple b = a;
        // b只知道size的类型是Number
        Number size1 = b.getSize();
        // 下面代码引起编译错误
        Integer size2 = b.getSize();
    }
}
```

上面程序定义了一个带泛型声明的Apple类，其类型形参的上限是Number，这个类型形参用来定义Apple类的size变量。程序在①处创建了一个Apple对象，该Apple对象传入了Integer作为类型形参的值，所以调用a的getSize()方法时返回Integer类型的值。当把a赋给一个不带泛型信息的b变量时，编译器就会丢失a对象的泛型信息，即所有尖括号里的信息都会丢失——因为Apple的类型形参的上限是Number类，所以编译器依然知道b的getSize()方法返回Number类型，但具体是Number的哪个子类就不清楚了

从逻辑上来看，List<String>是List的子类，如果直接把一个List对象赋给一个List<String>对象应该引起编译错误，但实际上不会。对于泛型而言，可以直接把一个List对象赋予一个List<String>对象，编译器仅仅提示“未经检查的转换”

```java
public class ErasureTest2 {
    public static void main(String[] args) {
        List<Integer> li = new ArrayList<>();
        li.add(34);
        li.add(59);
        List list = li;
        // 下面代码引起“未经检查的转换”的警告，编译、运行时完全正常
        List<String> ls = list; 
        // 但只要访问ls里的元素，如下面代码将引起运行时异常
        // ClassCastException
        System.out.println(ls.get(0));
    }
}
```

上面程序中定义了一个List<Integer>对象，这个List对象保留了集合元素的类型信息。当把这个List对象赋给一个List类型的List后，**编译器就会丢失前者的泛型信息，即丢失List集合里元素的类型信息，这是典型的擦除。**Java又允许直接把List对象赋给一个List<Type>（Type可以是任何类型）类型的变量，所以程序在①处可以编译通过，只是发出“未经检查的转换”警告，所以当试图把该集合里的元素当成String类型的对象取出时，将引发运行时异常

下面代码与上面代码的行为完全相似

```java
public class ErasureTest2 {
    public static void main(String[] args) {
        List<Integer> li = new ArrayList<>();
        li.add(34);
        li.add(59); 
        System.out.println((String)li.get(0));   
    }
}
```

程序从li中获取一个元素，并试图通过强制类型转换把它转换成一个String，将引发运行时异常。前面使用泛型代码时，系统与之存在完全相似的行为，所以引发相同的**ClassCastException**异常

## 泛型与数组

Java泛型与一个很重要的设计原则——如果一段代码在编译时没有提出“[unchecked] 未经检查的转换”警告，则程序在运行时不会引发ClassCastException异常。正是基于这个原因，所以数组元素的类型不能包含类型变量或类型形参，除非是无上限的类型通配符。但可以声明元素类型包含类型变量或类型形参的数组。也就是说，只能声明List<String>[]形式的数组，但不能创建ArrayList<String>[10]这样的数组对象。

Java不支持创建泛型数组