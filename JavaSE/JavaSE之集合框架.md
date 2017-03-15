---
typora-copy-images-to: appendix
typora-root-url: ./
---

## Java集合框架

### 集合概述

Java集合大致可以分为Set、List、Queue和Map四种体系，其中Set代表无序、不可重复的集合；List代表有序、可重复的集合；而Map则代表具有映射关系的集合，Java 5 又增加了Queue体系集合，代表一种队列集合实现。

Java集合就像一种容器，可以把多个对象（实际上是对象的引用，但习惯上称为对象）“丢进”该容器中。从Java 5 增加了泛型以后，Java集合就可以记住容器中对象的数据类型，使得编码更加简洁、健壮。

#### 集合和数组的区别

1. **数组长度在初始化时指定，意味着只能保存定长的数据。而集合可以保存数量不确定的数据。同时可以保存具有映射关系的数据**（即关联数组，键值对 key-value）；
2. **数组元素即可以是基本类型的值，也可以是对象（实际上是对象的引用，一般习惯上称为对象）。集合里只能保存对象（实际上也只是对象的引用变量），基本数据类型的变量要转换成对应的包装类才能放入集合类中**。

### 集合类的继承关系

Java的集合类主要由两个接口派生而出：Collection和Map，Collection和Map是Java集合框架的根接口。

![collections3](/appendix/collections3.png)

#### Iterable接口

迭代器接口，这是Collection类的父接口。实现这个Iterable接口的对象允许使用foreach循环进行遍历，也就是说，所有的Collection集合对象都具有"foreach可遍历性"。该接口方法如下：

- public **abstract Iterator\<T> iterator()**：其实现类通过该方法返回一个代表当前集合对象的泛型\<T>迭代器，用于之后的遍历操作；
- default void **forEach(Consumer<? super T> action)**：其实现类通过该默认方法根据传入的action对象来对每个元素来执行特定操作；
- default Spliterator\<T> **spliterator()**：返回一个Spliterator（splitable iterator可分割迭代器），Spliterator接口是Java为了**并行**遍历数据源中的元素而设计的迭代器（是Iterator的升级版），这个可以类比最早Java提供的顺序遍历迭代器Iterator，但一个是顺序遍历，一个是并行遍历。该方法的默认实现功能有限，一般需要重写。

> 注意：最早Java提供顺序遍历迭代器Iterator时，那个时候还是单核时代，但现在多核时代下，把多个任务分配到不同核上并行执行才能最大发挥多核的能力，所以Spliterator应运而生。参考：https://segmentfault.com/q/1010000007087438

#### Collection接口

Collection接口是Set，Queue，List的父接口。Collection接口中定义了多种方法可供其子类进行实现，以实现数据操作。常用方法如下：

- boolean **add(E e)**：该方法用于向该集合里添加一个元素。如果该集合对象调用该方法后发生了变化，则返回true。如果该集合已经有了指定的元素且不允许包含重复值则返回false；
- boolean addAll(Collection<? extends E> c)：把集合c里的所有元素添加到该集合对象里。如果调用该方法后该集合对象发生了变化，则返回true。如果该集合对象已经有了指定的元素且不允许包含重复值，则返回false；
- boolean **contains(Object o)**：返回该集合里是否包含指定元素；
- boolean containsAll(Collection<?> c)：返回该集合里是否包含集合c里的所有元素；
- boolean **remove(Object o)**：删除集合中的指定元素o，当集合中包含了一个或多个元素o时，该方法只删除第一个符合条件的元素，该方法将返回true；
- boolean removeAll(Collection<?> c)：求差集。即从该集合中删除所有也存在于集合c里元素，**如果删除了一个或一个以上的元素，则返回true**；
- default boolean **removeIf(Predicate<? super E> filter)**：返回是否成功删除了满足给定Predicate对象的集合元素；
- boolean **retainAll(Collection<?> c)**：求交集。即仅保留该集合对象中也存在于指定集合c中的元素；
- void **clear()**：清除集合里的所有元素，将集合长度变为0；
- boolean **isEmpty()**：返回集合是否为空，当集合长度为0时返回true，否则返回false；
- int **size()**：该方法返回集合里元素的个数；
- Iterator\<E> **iterator()**：返回一个Iterator对象，用于遍历集合里的元素；
- Object[] **toArray()**：该方法把集合转换成一个数组，所有的集合元素变成对应的数组元素；
- \<T> T[] toArray(T[] a)：该方法把集合转换成一个数组，返回的数组类型为指定的参数数据类型；
- default Spliterator\<E> **spliterator()**：返回一个针对该集合中所有元素的Spliterator对象（并行遍历器）；
- default Stream\<E> **stream()**：返回一个该集合对象对应的连续的Stream对象。当 spliterator()方法不能返回一个不可变的并发（或后期绑定的）spliterator时应重写该方法；
- default Stream\<E> **parallelStream()**：返回一个可能并行的Stream，该方法也允许返回一个连续的流。当 spliterator()方法不能返回一个不可变的并发（或后期绑定的）spliterator时应重写该方法。


集合就是一个现实容器的抽象，可以进行增、删、改、查（判断和遍历）等操作。一个Collection实例如下。

```java
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashSet;

public class CollectionTest {
    public static void main(String[] args) {
        Collection collection = new ArrayList<>(); 
        // 添加元素
        collection.add("杜兰特");
        // 虽然集合里不能放基本类型的值，但Java支持自动装箱
        collection.add(35);
      	// 输出2
        System.out.println("collection集合的元素个数为：" + collection.size()); 
        // 删除指定元素
        collection.remove(35);
      	// 输出1 
        System.out.println("collection集合的元素个数为：" + collection.size());          
        // 判断是否包含指定字符串
      	// 输出true
        System.out.println("collection集合是否包含\"杜兰特\"字符串：" + collection.contains("杜兰特"));                                    
        collection.add("维斯布鲁克");
      	// 所有Collection实现类都都重写了toString方法，返回形如[ele1, ele2...]的形式
        System.out.println("collection集合的元素：" + collection);
        Collection number = new HashSet<>();
        number.add(35);
        number.add(0);
        System.out.println("collection集合是否完全包含number集合？" + collection.containsAll(number));        	// 输出false
        // 用collection集合减去number集合里的元素
        collection.removeAll(number);
        System.out.println("collection集合的元素：" + collection);
        // 删除collection集合里的所有元素
        collection.clear();
        System.out.println("collection集合的元素：" + collection);
        // 控制number集合里只剩下collection集合里也包含的元素
        number.retainAll(collection);
        System.out.println("number集合的元素：" + number);
    }
}
```

输出如下。

```shell
collection集合的元素个数为：2    
collection集合的元素个数为：1
collection集合是否包含"杜兰特"字符串：true
collection集合的元素：[杜兰特, 维斯布鲁克]
collection集合是否完全包含number集合？false
collection集合的元素：[杜兰特, 维斯布鲁克]
collection集合的元素：[]
number集合的元素：[]
```

> 注意：所有Collection实现类都都重写了toString方法，返回形如[ele1, ele2...]的形式。

### 集合的一般操作

#### 使用Lambda表达式遍历集合

Iterable接口的forEach(Consumer action)默认方法所需参数的类型是一个函数式接口，而Iterable接口是Collection接口的父接口，因此Collection集合对象可直接调用该默认方法。

```java
import java.util.Collection;
import java.util.HashSet;

public class CollectionEach {
    public static void main(String[] args) {
        // 创建一个集合
        Collection teams = new HashSet<>();
        teams.add("Thunder");
        teams.add("Cavaliers");
        teams.add("Warriors");
        // 调用forEach()方法遍历集合
        teams.forEach(obj -> System.out.println("迭代集合元素： " + obj));
    }
}
```

**程序调用Iterable的forEach(Consumer action)遍历集合元素时，程序会依次将集合元素传给Consumer函数式接口的accept(T t)方法（该方法时Consumer中唯一的抽象方法，用来为每个传入的参数执行自定义的操作）**。

#### 使用Java8增强的Iterator遍历集合元素

Iterable接口的iterator()方法返回的Iterator接口对象主要用于遍历集合元素（IIterator对象也被称为迭代器）。它含有以下方法：

- public abstract boolean **hashNext()**：判断当前的遍历位置后面是否还有下一个元素；
- public abstract E **next()**：返回下一个元素；
- default void **remove()**：删除当前遍历到的元素。可以先使用hashNext()判断是否有下一个元素，如果有则next()一次，然后remove()一次。但是**如果在遍历时通过其他方法（不包括本方法）修改了当前集合对象，那么该方法的执行结果是不确定的。所以在遍历集合时不能通过其他方式修改当前集合对象，否则抛出java.util.ConcurrentModificationException异常**；
- default void **forEachRemaining(Consumer<? super E> action)**：对剩余的元素按照迭代顺序（如果指定了迭代顺序）执行给定的操作，直到全部元素执行完毕或抛出异常。

Iterator仅用于遍历集合，Iterator本身并不提供盛装对象的能力。**如果需要创建Iterator对象，则必须与一个被迭代的集合。当使用Iterator对集合元素进行迭代时，Iterator并不是把集合元素本身传给了迭代变量，而是把集合元素的值传给了迭代变量，所以修改迭代变量的值对集合元素本身没有任何影响**。

```java
// 获取teams集合对应的迭代器
Iterator iterator = teams.iterator();
while (iterator.hasNext()) {
    // iterator.next()方法返回的数据类型是Object类型，因此需要强制类型转换
    String team = (String) iterator.next();
    System.out.println(team);
    if (team.equals("Cavaliers")) {
      	// 遍历集合时不能通过其他方式修改当前集合对象,
      	// 否则抛出java.util.ConcurrentModificationException异常
        // 从集合中删除上一次next()方法返回的元素
        iterator.remove();
    }
    // 对iterator的遍历结果赋值，不会改变集合元素本身
  	// 因为Iterator得到的是原集合对象的副本
    team = "Rocket";
}
System.out.println(teams);
```

#### 使用Lambda表达式遍历Iterator

```java
// 获取teams集合对应的迭代器
Iterator iterator = teams.iterator();
// Iterator的forEachRemaining()方法的参数也是一个Consumer函数式接口
// 使用Lambda表达式（目标类型是Comsumer）来遍历集合元素
iterator.forEachRemaining(obj -> System.out.println("迭代集合元素： " + obj));
```

#### 使用foreach循环遍历集合元素

**使用foreach循环来迭代访问Collection集合里的元素更加简洁，迭代变量不是集合元素本身，系统只是依次把集合元素的值赋给迭代变量。这种遍历集合也不能被改变，否则引发ConcurrentModificationException异常**。

```java
import java.util.*;

public class ForeachTest {
    public static void main(String[] args) {
        // 创建集合、添加元素的代码与前一个程序相同
        Collection books = new HashSet();
        books.add(new String("Head First Java"));
        books.add(new String("Head First PHP"));
        books.add(new String("Head First C++"));
        for (Object obj : books) {
            // 此处的book变量也不是集合元素本身
            String book = (String)obj;
            System.out.println(book);
            if (book.equals("Head First PHP")) {
                // 下面代码会引发ConcurrentModificationException异常
                books.remove(book);
            }
        }
        System.out.println(books);
    }
}
```

#### 使用Java8新增的Predicate操作集合

**Java 8为Collection添加了一个removIf(Predicate filter)的默认方法，该方法将会批量删除符合filter对象中自定义条件（实现其test(T t)方法）的所有元素。该方法需要一个Predicate（断言）函数式接口对象作为参数**，因此可使用Lambda表达式作为参数。

```java
import java.util.*;
import java.util.function.*;

public class PredicateTest2 {
    public static void main(String[] args) {
        // 创建books集合、为books集合添加元素的代码与前一个程序相同
        Collection books = new HashSet();
        books.add(new String("Head First Java"));
        books.add(new String("Head First Android"));
        books.add(new String("Head First PHP"));
        books.add(new String("Head First C++"));
        books.add(new String("Head First Servlet and JSP"));
        // 统计书名包含“First”子串的图书数量
        System.out.println(calAll(books, ele ->((String)ele).contains("First")));
        // 统计书名包含“Java”子串的图书数量
        System.out.println(calAll(books, ele ->((String)ele).contains("Java")));
        // 统计书名字符串长度大于10的图书数量
        System.out.println(calAll(books, ele ->((String)ele).length() > 10));
    }
    public static int calAll(Collection books, Predicate p) {
        int total = 0;
        for (Object obj : books) {
            // 使用Predicate的test()方法判断该对象是否满足Predicate指定的条件
            if (p.test(obj)) {
                total ++;
            }
        }
        return total;
    }
}
```

#### 使用Java8新增的Stream操作集合

Java 8新增了Stream、IntStream、LongStream、DoubleStream等[流式API](https://zhuanlan.zhihu.com/p/20540202)，这API代表多个支持串行和并行聚集操作的元素。

Java 8中的Stream与Java IO包中的InputStream和OutputStream完全不是一个概念，这里的Stream是对集合功能的一种增强，主要用于对集合对象进行便利高效的串行或并行的聚合操作和大批量数据的操作。结合Lambda表达式可以极大的提高开发效率和代码可读性。

Stream是一个通用的流接口，而IntStream、LongStream、DoubleStream分别代表元素类型为int、long和double的流。

Java 8还为上面每个流式API提供了对应的Builder内部类，开发者可以通过这些Builder内部类创建对应的流。独立使用Stream的步骤如下：

- 使用Stream或XxxStream的builder()类方法创建该Stream对应的Builder；
- 重复调用Builder的add()方法向该流中添加多个元素；
- 调用Builder的build()方法获取对应的Stream；
- 调用Stream的聚集方法。

Stream提供了大量的聚集方法供用户调用，对于大部分聚集方法而言，每个Stream只能执行一次。

```java
import java.util.stream.IntStream;
import javax.lang.model.element.Element;
import javax.print.attribute.standard.PrinterLocation;
import javax.swing.text.html.HTMLDocument.HTMLReader.IsindexAction;

public class IntStreamTest {
    public static void main(String[] args) {
        IntStream is = IntStream.builder()
                .add(20)
                .add(16)
                .add(12)
                .add(22)
                .build();
        // 下面调用聚集方法的代码每次只能执行一行
        System.out.println("is所有元素的最大值：" + is.max().getAsInt());
       // System.out.println("is所有元素的最小值：" + is.min().getAsInt());
       // System.out.println("is所有元素的总和：" + is.sum());
       // System.out.println("is所有元素的总数：" + is.count());
       // System.out.println("is所有元素的平均值：" + is.average());
       // System.out.println("is所有元素的平方是否都大于20：" + is.allMatch(ele -> ele * ele > 20));
       // System.out.println("is是否包含任何元素的平方大于20：" + is.anyMatch(ele -> ele * ele > 20));
       // 将is映射成一个新Stream，新Stream的每个元素是原Stream元素的2倍+1
        IntStream newIs =  is.map(ele -> ele * 2 + 1);
        // 使用方法引用的方式来遍历集合元素
        newIs.forEach(System.out::println);
    }
}
```

**使用流的时候应当格外注意，它只能消费一次**。上述聚集方法执行操作每次只能执行一行，否则出现java.lang.IllegalStateException: stream has already been operated upon or closed

Stream提供了大量的方法进行聚集操作，这些方法既可以是“中间的”(intermediate)，也可以是“末端的”(terminal)

- 中间方法：**中间操作允许流保持打开状态，并允许直接调用后续方法。map()方法就是中间方法。中间方法的返回值是另外一个流**；
- 末端方法：**末端方法是对流的最终操作。当对某个Stream执行末端方法后，该流就会被“消耗”且不再可用。sum()、count()、average()等方法都是末端方法**。

流方法的两个特征：

- 有状态的方法：这种方法会给流增加一些新的属性，比如元素的唯一性、元素的最大数量、保证元素以排序的方式被处理等。有状态的方法往往需要更大的性能开销；
- 短路方法：可以尽早结束对流的操作，不必检查所有的元素。

Stream常用的中间方法：

- filter(Predicate predicate)：过滤Stream中所有不符合predicate的元素；
- mapToXxx(ToXxxFunction mapper)：使用ToXxxFunction对流中的元素执行一对一的转换，该方法返回的新流中包含了ToXxxFunction转换生成的所有元素；
- peek(Consumer action)：依次对每个元素执行一些操作，该方法返回的流与原有流包含相同的元素。主要用于调试；
- distinct()：该方法用于排序流中所有重复的元素（判断元素重复的标准是使用equals()比较返回true）。这是一个有状态的方法；
- sorted()：该方法用于保证流中的元素在后续的访问中处于有序状态。这是一个有状态的方法；
- limit(long maxSize)：该方法用于保证对该流的后续访问中最大允许访问的元素个数。这是一个有状态的、短路方法；
- forEach(Consumer action)：遍历流中所有元素，对每个元素执行action；
- toArray()：将流中所有元素转换为一个数组；
- reduce()：该方法有三个重载版本，都用于通过某种操作来合并流中的元素；
- min()：返回流中所有元素的最小值；
- max()：返回流中所有元素的最大值；
- count()：返回流中所有元素的数量；
- anyMatch(Predicate predicate)：判断流中是否至少包含一个元素符合Predicate条件；
- allMatch(Predicate predicate)：判断流中是否每个元素都符合Predicate条件；
- noneMatch(Predicate predicate)：判断流中是否所有元素都不符合Predicate条件；
- findFirst()：返回流中的第一个元素；
- findAny()：返回流中的任意一个元素。

**Java 8允许使用流式API来操作集合，Collection接口提供了一个stream()默认方法可返回该集合对应的流，接下来即可通过流式API来操作集合元素。Stream可以对集合元素进行整体的聚集操作**。

```java
public class CollectionStream {
	public static void main(String[] args) {
		Collection<String> player = new HashSet<>();
		player.add(new String("FMVP+MVP勒布朗詹姆斯"));
		player.add(new String("MVP德里克罗斯"));
		player.add(new String("MVP斯蒂芬库里"));
		player.add(new String("MVP德凯文杜兰特"));
		player.add(new String("FMVP莱昂纳德"));
		player.add(new String("场均三双狂魔维斯布鲁克"));

		// 统计包含“MVP”子串的字符串数量
		System.out.println(player.stream().filter(ele -> ((String) ele).contains("MVP")).count()); // 输出5
		// 统计包含“FMVP”子串的字符串数量
		System.out.println(player.stream().filter(ele -> ((String) ele).contains("FMVP")).count()); // 输出2
		// 统计长度大于10的字符串数量
		System.out.println(player.stream().filter(ele -> ((String) ele).length() > 10).count()); // 输出2
		// 先调用Collection对象的stream()方法将集合转换为Stream
		// 再调用Stream的mapToInt()方法获取原有的Stream对应的IntStream
		player.stream().mapToInt(ele -> ((String) ele).length())
				// 调用forEach()方法遍历IntStream中每个元素
				.forEach(System.out::println); // 输出8 14 8 8 9 11
	}
}
```

### Set集合

Set集合与其父集合Collection集合基本相同，只是行为略有不同，**Set集合不允许包含重复元素**，因为它是无序的（无序容器无法定位多个相同的元素）。

#### HashSet

大多时候使用Set集合时就是使用HashSet实现类。HashSet按Hash算法来存储集合中的元素，因此具有很好的存取和查找性能。

HashSet具有以下特点：

- **不能保证元素的排列顺序**，顺序可能与添加顺序不同，顺序也有可能发生变化；
- **HashSet不是同步的**，如果有两个或两个以上线程同时修改了同一个HashSet集合时，则必须通过代码来保证其同步；
- **集合元素值可以是null**。

**当向HashSet集合中存入一个元素时，HashSet会调用该对象的hashCode()方法来得到该对象的hashCode()值，然后根据该hashCode()值决定该对象在HashSet中的存储位置；HashSet集合判断两个元素相等的标准是两个对象通过equals()方法比较相等，并且两个对象的hashCode()方法返回值也相等。**

hash（也被翻译为哈希、散列）算法的功能：它能保证快速查找被检索的对象，hash算法的价值在于速度。当需要查询集合中某个元素时，**hash算法可以根据该元素的hashCode值计算出该元素的存储位置，从而快速定位该元素**。

之所以选择HashSet，而不直接使用数组，是因为**数组虽然查找迅速，但数组元素的索引是连续的，而且数组的长度是固定的、无法自由增加数组的长度。而HashSet采用每个元素的hashCode值来计算其存储位置，从而可以自由增加HashSet的长度，并可以根据元素的HashCode值来访问元素**。

从存储的角度来讲Hash存储的效率可能不高，这就需要在设计Hash表时多加注意。而从查找、插入和删除的角度上来讲，Hash表的效率是很高的。试想在查找一个表中的记录而不知道其存储位置时，最坏情况下要将此记录与整个表的所有记录进行比较才能确定其位置。而使用Hash表时，记录的存储位置是与记录相关联的，换句话说就是知道了哪个记录就知道了它的存储位置，那么直接去该位置就能获取该记录的所有信息。虽然增加了计算Hash值的开销，但这与查找所带来的开销相比是非常小的。

HashSet中每个能存储元素的“槽位”(slot)通常称为“桶”(bucket)。如果多个hashCode值相同，但他们通过equals()方法返回false，就会在一个“桶”中放进多个元素（称为冲突，多个元素以链表形式存储在一个“桶”中），这会导致性能下降。这就需要设计好的hashCode()方法来使元素能够尽可能的均匀分布在hash表中。**重写hashCode()方法的基本规则如下**：

- **在程序运行过程中，同一个对象多次调用hashCode()方法应该返回相同的值**；
- **当两个对象通过equals()方法比较返回true时，这两个对象的hashCode()方法应该返回相等的值**；
- **对象中用作equals()方法比较标准的实例变量，都应该用于计算hashCode()值**。

Google首席Java架构师Joshua Bloch在他的著作《Effective Java》中提出了一种简单**通用的hashCode()重写算法**：

1. 把某个非零的int常量，比如17，保存在一个名为result的int类型的变量中。即int result = 17；

2. 对于对象中每个关键字段f（需要在equals方法中用于比较的所有字段）完成以下步骤：

   a. 为该字段计算int类型的散列码c：

   ​    (1) 对于boolean值，则散列码c = f ? 1:0；

   ​    (2) 对于byte/char/short/int，则散列码c  = (int)f；

   ​    (3) 对于long值，则散列码c = (int)(f ^ (f >>> 32))；

   ​    (4) 对于float值，则散列码c  = Float.floatToIntBits(f)；

   ​    (6) 对于double值，则先计算Double.doubleToLongBits(f)得到一个long值，再将该long值按照2.a.(3)步骤计算出散列码c的值；

   ​    (7) 对于对象应用，如果该类的equals方法通过递归调用equals的方式来比较这个字段，那么同样为该字段递归地调用hashCode。即散列码c = f.hashCode。如果需要更复杂的比较，则需要为这个字段计算一个“范式（canonical representaction ）”，然后针对这个范式调用hashCode。如果这个字段的值为null，则返回0（或者其他某个常数，但通常是0）；

   ​    (8) 对于数组，则要把每一个元素当做单独的字段来处理。也就是说，递归地应用上述规则，对每个重要元素计算一个散列码，然后根据步骤2.b中的做法把这些散列值组合起来。如果数组字段中的每个元素都很重要，可以利用JDK 1.5及更高版本中提供的java.util.Arrays.hashCode方法。

    b. 按照下面的公式，把步骤2.a中计算得到的散列码c合并到result中：

   ​	result = 31 * result + c；

   每次使用乘法去操作result是为了使散列依赖于字段的顺序。如Test t1 = new Test(1, 0)跟Test t2 = new Test(0, 1), t1和t2的最终hashCode返回值是不一样的。

   还有，为什么使用31呢？因为任何数n乘以31都可以被JVM优化为 (n << 5) -n，移位和减法的操作效率要比乘法的操作效率高的多。

3. 返回result；

4. 写完hashCode方法之后，编写测试来测试一下是否符合前面的基本原则，这些基本规则虽然不能保证性能，但是可以保证不出错。如果相等的实例有着不同的散列码，则要找出原因，并修正错误。

#### LinkedHashSet类

LinkedHashSet集合根据元素的hashCode值来决定元素的存储位置，同时使用链表维护元素的次序，这样使得元素看起来是以插入的顺序保存的。当**遍历LinkedHashSet集合里的元素时，LinkedHashSet将会按元素的添加顺序来访问集合里的元素**。

**LinkedHashSet需要维护元素的插入顺序，因此性能略低于HashSet的性能，但在迭代访问Set里的全部元素时将有很好的性能，因为它以链表来维护内部顺序**。

**虽然LinkedHashSet使用了链表记录集合元素的添加顺序，但LinkedHashSet依然是HashSet，因此不允许集合元素重复**。

#### TreeSet类

TreeSet是SortedSet接口的实现类，通过采用**红黑树**的数据结构来存储集合元素，从而可以确保集合元素处于排序状态。TreeSet的额外方法：

- Comparator **comparator()**：如果TreeSet采用了定制排序，则该方法返回定制排序所使用的Comparator；如果TreeSet采用了自然排序，则返回null；
- Object **first()**：返回集合中的第一个元素；
- Object last()：返回集合中的最后一个元素；
- Object **lower(Object e)**：返回集合中位于指定元素之前的元素（即小于指定元素的最大元素，参考元素不需要是TreeSet集合里的元素）；
- Object **higher(Object e**)：返回集合中位于指定元素之后的元素（即大于指定元素的最小元素，参考元素不需要是TreeSet集合里的元素）；
- SortedSet **subSet(Object fromElement, Object toElement)**：返回此Set的子集，范围从fromElement（包括）到toElement（不包括）；
- SortedSet **headSet(Object toElement)**：返回此Set的子集，由小于toElement的元素组成；
- SortedSet **tailSet(Object fromElement)**：返回此Set的子集，由大于或等于fromElement的元素组成。

TreeSet通用用法实例。

```java
import java.util.*;

public class TreeSetTest {
    public static void main(String[] args) {
        TreeSet nums = new TreeSet();
        // 向TreeSet中添加四个Integer对象
        nums.add(5);
        nums.add(2);
        nums.add(10);
        nums.add(-9);
        // 输出集合元素，看到集合元素已经处于排序状态
        System.out.println(nums);
        // 输出集合里的第一个元素
        System.out.println(nums.first()); // 输出-9
        // 输出集合里的最后一个元素
        System.out.println(nums.last());  // 输出10
        // 返回小于4的子集，不包含4
        System.out.println(nums.headSet(4)); // 输出[-9, 2]
        // 返回大于5的子集，如果Set中包含5，子集中还包含5
        System.out.println(nums.tailSet(5)); // 输出 [5, 10]
        // 返回大于等于-3，小于4的子集。
        System.out.println(nums.subSet(-3 , 4)); // 输出[2]
    }
}
```

TreeSet支持两种排序方法。在默认情况下，TreeSet采用自然排序。

##### 自然排序

TreeSet会调用集合元素的compareTo(Object obj)方法来比较元素之间的大小关系，然后将集合元素按升序排列，这种方式就是自然排序。

**Java提供了一个Comparable接口，该接口里定义了一个compareTo(Object obj)方法，该方法返回一个整数值，实现该接口的类必须实现该方法，实现了该接口的类的对象就可以比较大小。**当一个对象调用该方法与另一个对象进行比较时，例如obj1.compareTo(obj2)，如果该方法返回0，则表明这两个对象相等；如果该方法返回一个正整数，则表明obj1大于obj2；如果该方法返回一个负整数，则表明obj1小于obj2

实现了Comparable接口的常用类：

- BigDecimal、BigInteger以及所有的数值型对应的包装类：按它们对应的数组大小进行比较；
- Character：按字符的UNICODE值进行比较；
- Boolean：true对应的包装类实例大于false对应的包装类实例；
- String：按字符串中字符的UNICODE值进行比较；
- Date、Time：后面的时间、日期比前面的时间、日期大。

**如果试图把一个对象添加到TreeSet，则该对象的类必须实现Comparable接口，否则程序将会抛出异常**。如下面的实例所示。

```java
import java.util.TreeSet;

class Error{ }
public class TreeSetErrorTest {
    public static void main(String[] args) {
        TreeSet treeSet = new TreeSet<>();
        treeSet.add(new Error());
        treeSet.add(new Error());
    }
}
```

上面的程序中添加第一个Error对象时，TreeSet里没有任何元素，所以不会出现任何问题；当添加第二个Error对象时，TreeSet就会调用该对象的compareTo(Object obj)方法与集合中的其他元素进行比较，如果其对应的类没有实现Comparable接口，则会引发ClassCastException异常。

**向TreeSet集合中添加元素时，只有第一个元素无须实现Comparable接口，后面添加的所有元素都必须实现Comparable接口。当然这不是好的做法，因为当试图从TreeSet中取出元素时，依然会抛出ClassCastException异常**。

**大部分类在实现compareTo(Object obj)方法时，都需要将被比较的对象obj强制转换为相同类型，因为只有相同类的实例才能比较大小。向TreeSet中添加的元素应该是同一个类的对象，否则也会引发ClassCastException异常**。

**TreeSet集合判断两个对象是否相等的唯一标准是：如果两个对象通过compareTo(Object obj)方法比较是否返回0，如果返回0，则这两个对象相等，新对象将无法添加到TreeSet集合中**。

如果向TreeSet中添加了一个可变对象后修改了该可变对象的实例变量，这将导致他与其他对象的大小顺序发生了改变，但是TreeSet不会再次调整他们的顺序，甚至可能导致TreeSet中保存的这两个对象通过compareTo(Object obj)方法比较返回0。当再次删除该对象时，TreeSet可能删除失败（甚至集合中原有的、实例变量没有修改过、但其实例变量与该元素变化了的实例变量相等的元素也无法删除）。所以，**建议不要修改放入HashSet和TreeSet集合中元素的关键实例变量**。

##### 定制排序

TreeSet的自然排序是根据集合元素的大小，TreeSet将它们以升序排列。如果需要实现定制排序，例如以降序排列，则需要在创建TreeSet集合对象时，提供一个Comparator对象与该TreeSet集合关联，有该Comparator对象负责集合元素的排序逻辑。由于Comparator是一个函数式接口，因此可以使用Lambda表达式来代替Comparator对象。

定制排序的实例如下。

```java
class M {
    int age;
    public M(int age) {
        this.age = age;
    }
    public String toString() {
        return "M[age:" + age + "]";
    }
}
public class TreeSetTest2 {
    public static void main(String[] args) {
        // 此处Lambda表达式的目标类型是Comparator
        TreeSet ts = new TreeSet((o1 , o2) -> {
            M m1 = (M)o1;
            M m2 = (M)o2;
            // 根据M对象的age属性来决定大小，age越大，M对象反而越小
            return m1.age > m2.age ? -1
                : m1.age < m2.age ? 1 : 0;
        });
        ts.add(new M(5));
        ts.add(new M(-3));
        ts.add(new M(9));
        System.out.println(ts);
    }
}
```

输出结果为：

```java
[M[age:9], M[age:5], M[age:-3]]
```

#### EnumSet类

EnumSet是一个专为枚举类设计的集合类，**EnumSet中的所有元素都必须是指定枚举类型的枚举值，该枚举类型在创建EnumSet时显式或隐式地指定。EnumSet的集合元素也是有序的，EnumSet以枚举值在Enum类内的定义顺序来决定集合元素的顺序**。

**EnumSet在内部以位向量的形式存储，EnumSet对象占用内存很小，运行效率很好**。尤其是进行批量操作（如调用containsAll()和retainAll()方法）时，如果其参数也是EnumSet集合，则该批量操作的执行速度也非常快。

**EnumSet集合不允许加入null元素，否则抛出NullPointException异常**。

**EnumSet没有暴露任何构造器来创建该类的实例，应通过其提供的类方法来创建EnumSet对象**：

- EnumSet **allOf(Class elementType)**：创建一个**包含指定枚举类里所有枚举值**的EnumSet集合；
- EnumSet **complementOf(EnumSet e)**： **创建一个其元素类型与指定EnumSet里元素类型相同的EnumSet集合，新EnumSet集合包含原EnumSet集合所不包含的、此类枚举类剩下的枚举值**（即新EnumSet集合和原EnumSet集合的集合元素加起来是该枚举类的所有枚举值）；
- EnumSet **copyOf(Collection c)**：使用一个普通集合来创建EnumSet集合。要求指定的Collection中的所有元素必须是同一个枚举类的枚举值；
- EnumSet **copyOf(EnumSet e)**：创建一个指定EnumSet具有相同元素类型、相同集合元素的EnumSet集合；
- EnumSet **noneOf(Class elementType)**：创建一个元素类型为指定枚举类型的空EnumSet；
- EnumSet **of(E first, E…rest)**：创建一个包含一个或多个枚举值的EnumSet集合，传入的多个枚举值必须属于同一个枚举类；
- EnumSet **range(E from, E to)**：创建一个包含从from枚举值到to枚举值范围内所有枚举值的EnumSet集合。

EnumSet实例如下。

```java
enum Season {
    SPRING,SUMMER,FALL,WINTER
}
public class EnumSetTest {
    public static void main(String[] args) {
        // 创建一个EnumSet集合，集合元素就是Season枚举类的全部枚举值
        EnumSet es1 = EnumSet.allOf(Season.class);
        System.out.println(es1); // 输出[SPRING,SUMMER,FALL,WINTER]
        // 创建一个EnumSet空集合，指定其集合元素是Season类的枚举值。
        EnumSet es2 = EnumSet.noneOf(Season.class);
        System.out.println(es2); // 输出[]
        // 手动添加两个元素
        es2.add(Season.WINTER);
        es2.add(Season.SPRING);
        System.out.println(es2); // 输出[SPRING,WINTER]
        // 以指定枚举值创建EnumSet集合
        EnumSet es3 = EnumSet.of(Season.SUMMER , Season.WINTER);
        System.out.println(es3); // 输出[SUMMER,WINTER]
        EnumSet es4 = EnumSet.range(Season.SUMMER , Season.WINTER);
        System.out.println(es4); // 输出[SUMMER,FALL,WINTER]
        // 新创建的EnumSet集合的元素和es4集合的元素有相同类型，
        // es5的集合元素 + es4集合元素 = Season枚举类的全部枚举值
        EnumSet es5 = EnumSet.complementOf(es4);
        System.out.println(es5); // 输出[SPRING]
    }
}
```

#### 各Set实现类的性能分析

**HashSet的性能总比TreeSet好，特别是最常用的添加、查询元素等操作。因为TreeSet需要额外的红黑树算法来维护集合元素的次序。只有当需要保持排序的Set时，才应该使用TreeSet，否则都应该使用HashSet**。

**LinkedHashSet是HashSet的一个子类，对于普通的插入、删除操作，LinkedHashSet比HashSet要略微慢一点，这是由维护链表所带来的额外开销所造成的，但由于有了链表，遍历LinkedHashSet会更快**。

**EnumSet是所有Set实现类中性能最好的，但它只能保存同一个枚举的枚举值作为集合元素**。

**HashSet、TreeSet、EnumSet都是线程不安全的，如果有多个线程同时访问一个Set集合，并且有超过一个线程修改了该Set集合，则必须手动保证该Set集合的同步性。通常可以通过Collections工具类的synchronizedSortedSet方法来“包装”该Set集合。在创建时进行，以防对Set集合的意外非同步访问**：

```java
SortedSet s = Collections.synchronizedSortedSet(new TreeSet(...));
```

### List集合

**List集合代表一个元素有序、可重复的集合，集合中每个元素都有其对应的顺序索引。List集合可以通过索引来访问指定位置的集合元素。List集合默认按元素的添加顺序设置元素的索引**。

List作为Collection接口的子接口可以使用Collection接口中的所有方法，而且由于List集合是有序集合，所以List集合增加了一些根据索引操作集合元素的方法：

- void **add(int index, Object element)**：将元素element插入到List集合的index处；
- boolean **addAll(int index, Collection c)**：将集合c所包含的所有元素都插入到List集合的index处；
- Object **remove(int index)**：删除并返回index索引处的元素；
- Object **set(int index, Object element)**：将index索引处的元素替换成element对象，返回被替换的旧元素。**指定的索引必须为List的有效索引**，该方法不会改变List的长度；
- default void **replaceAll(UnaryOperator operator)**：根据operator指定的计算规则重新设置List集合的所有元素，Java 8新增；
- default void **sort(Comparator c)**：根据Comparator参数对List集合的元素排序，Java 8新增；
- Object **get(int index)**：返回集合index索引处的元素；
- int **indexOf(Object o)**：返回对象o在List集合中第一次出现的位置索引；
- int **lastIndexOf(Object o)**：返回对象o在List集合中最后一次出现的位置索引；
- List **subList(int fromIndex, int toIndex)**：返回从索引fromIndex（包含）到索引toIndex（不包含）处所有集合元素组成的子集合。

List集合常用操作实例如下。

```java
import java.util.ArrayList;
import java.util.List;

public class ListTest {
	public static void main(String[] args) {
		List<String> books = new ArrayList<>();
		// 向books集合中添加三个元素
		books.add(new String("Head First Java"));
		books.add(new String("Head First Android"));
		books.add(new String("Head First Java PHP"));
		System.out.println(books);
		// 将新字符串对象插入在第二个位置
		books.add(1, new String("Head First C++"));
		for (int i = 0; i < books.size(); i++) {
			System.out.println(books.get(i));
		}
		// 删除第三个元素
		books.remove(2);
		System.out.println(books);
		// 判断指定元素在List集合中位置：输出1，表明位于第二位
		System.out.println(books.indexOf(new String("Head First Java")));
		// 将第二个元素替换成新的字符串对象
		books.set(1, new String("Head First C++"));
		System.out.println(books);
		// 将books集合的第二个元素（包括）
		// 到第三个元素（不包括）截取成子集合
		System.out.println(books.subList(1, 3));
	}
}
```

输出结果如下。

```shell
[Head First Java, Head First Android, Head First Java PHP]
Head First Java
Head First C++
Head First Android
Head First Java PHP
[Head First Java, Head First C++, Head First Java PHP]
0
[Head First Java, Head First C++, Head First Java PHP]
[Head First C++]
```

List判断两个元素相等只要通过equals()方法比较返回true即可。

```java
class A {
	public boolean equals(Object obj) {
		return true;
	}
}
public class ListTest2 {
	public static void main(String[] args){
		List books = new ArrayList();
		books.add(new String("轻量级Java EE企业应用实战"));
		books.add(new String("疯狂Java讲义"));
		books.add(new String("疯狂Android讲义"));
		System.out.println(books);
		// 删除集合中A对象，将导致第一个元素被删除
		books.remove(new A()); 
		System.out.println(books);
		// 删除集合中A对象，再次删除集合中第一个元素
		books.remove(new A());
		System.out.println(books);
	}
}
```

Java 8为List结合增加的sort()和replaceAll()这两个默认方法，其参数都是一个函数式接口对象，他们的用法如下。

```java
public class ListTest3 {
	public static void main(String[] args) {
		List books = new ArrayList();
		// 向books集合中添加4个元素
		books.add(new String("轻量级Java EE企业应用实战"));
		books.add(new String("疯狂Java讲义"));
		books.add(new String("疯狂Android讲义"));
		books.add(new String("疯狂iOS讲义"));
		// 使用目标类型为Comparator的Lambda表达式对List集合排序
		books.sort((o1, o2)->((String)o1).length() - ((String)o2).length());
		System.out.println(books);
		// 使用目标类型为UnaryOperator的Lambda表达式来替换集合中所有元素
		// 该Lambda表达式控制使用每个字符串的长度作为新的集合元素
		books.replaceAll(ele->((String)ele).length());
		System.out.println(books); // 输出[7, 8, 11, 16]

	}
}
```

#### ListIterator方法

**List还额外提供了一个返回ListIterator对象的ListIterator()方法，ListIterator接口继承了Iterator接口，提供了专门操作List的方法**，ListIterator接口在Iterator接口基础上增加了如下方法：

- boolean **hasPrevious()**：返回该迭代器相关的集合是否还有上一个元素；
- Object previous()：返回该迭代器的上一个元素；
- void **add(Object o)**：在指定位置插入一个元素。

ListIterator相比Iterator增加了向前迭代的功能，Iterator只能向后迭代，ListIterator可以通过add()方法向List集合中添加元素，而Iterator只能删除元素。

```java
import java.util.*;

public class ListIteratorTest {
    public static void main(String[] args) {
        String[] teams = {
            "金州勇士", 
            "俄克拉荷马雷霆",
            "克利夫兰骑士"
        };
        List teamList = new ArrayList();
        for (int i = 0; i < teams.length ; i++ ) {
            teamList.add(teams[i]);
        }
        ListIterator lit = teamList.listIterator();
        while (lit.hasNext()) {
            System.out.println(lit.next());
            lit.add("-------分隔符-------");
        }
        System.out.println("=======下面开始反向迭代=======");
        while(lit.hasPrevious()) {
            System.out.println(lit.previous());
        }
    }
}

```

#### ArrayList和Vector实现类

ArrayList和Vector都是基于数组实现的List类，所以**ArrayList和Vector类封装了一个动态的、允许再分配的Object[]数组。initialCapacity参数用来设置该数组的长度，如果向ArrayList和Vector添加大量元素时，可使用ensureCapacity(int minCapacity)方法一次性增加initialCapacity。减少重分配次数，提高性能**。

创建空的ArrayList和Vector集合时**如果不指定initialCapacity参数，则Object[]数组的长度默认为10**。

重新分配Object[]数组的方法：

- void **ensureCapacity(int minCapacity)**：将ArrayList和Vector集合的长度增加大于或大于minCapacity值；
- void **trimToSize()**：调整ArrayList和Vector集合的Object[]数组长度为当前元素的个数。调用该方法可减少ArrayList和Vector集合对象占用的存储空间。

**Vector和ArrayList在用法上几乎完全相同**，但Vector老旧，其方法名长，具有很多缺点，**通常尽量少用Vector实现类**。ArrayList和Vector的区别：

- **ArrayList是线程不安全，当多个线程访问同一个ArrayList集合时，如果有超过一个线程修改了ArrayList集合，则程序必须手动保证该集合的同步性**；
- **Vector是线程安全，无须程序保证该集合的同步性，也因为线程安全，Vector的性能比ArrayList的性能低**；
- **Collections工具类可以将一个ArrayList变成线程安全，因此依然不推荐Vector实现类**。

Vector还提供了一个Stack子类，用于模拟栈结构，同样不推荐使用Stack，而是使用ArrayDeque来实现栈结构。

#### 固定长度的List

操作数组的工具类：Arrays，该工具类提供了asList(Object.. a)方法，可以把一个数组或者指定个数的对象转换成一个List集合，这个List集合既不是ArrayList实现类的实例，也不是Vector实现类的实例，而是Arrays的内部类ArrayList的实例

Arrays.ArrayList是一个固定长度的List集合，程序只能遍历访问该集合里的元素，不可增加、删除该集合里的元素。

```java
import java.util.*;

public class FixedSizeList {
    public static void main(String[] args) {
        List fixedList = Arrays.asList("克利夫兰骑士", "金州勇士");
        // 获取fixedList的实现类，将输出Arrays$ArrayList
        System.out.println(fixedList.getClass());
        // 使用方法引用遍历集合元素
        fixedList.forEach(System.out::println);
        // 试图增加、删除元素都会引发UnsupportedOperationException异常
        fixedList.add("俄克拉荷马雷霆");
        fixedList.remove("金州勇士");
    }
}
```

### Queue集合

Queue接口用于**模拟队列**这种数据结构，队列通常是指“先进先出”（FIFO）的容器。队列的头部保存在队列中存放时间最长的元素，队列的尾部保存在队列中存放时间最短的元素。**新元素插入（offer）到队列的尾部，访问元素（poll）操作会返回队列头部的元素。通常，队列不允许随机访问队列中的元素**。

Queue接口的方法：

- void add(Object e)：将指定元素加入此队列的**尾部**；
- boolean **offer(Object e)**：将指定的元素插入此队列的尾部（提供）。**当使用容量有限的队列时，此方法通常比add(Object e)有效**；
- Object **poll()**：返回队列头部的元素（**剪短**），并删除该元素。如果队列为空，则返回null；
- Object **remove()**：获取队列头部的元素，并删除该元素；
- Object **peek()**：返回队列头部的元素（**瞥一眼**），但是不删除该元素。如果队列为空，则返回null；
- Object **element()**：获取队列头部的元素，但是不删除该元素。

#### PriorityQueue实现类

Queue接口有一个PriorityQueue实现类，PriorityQueue保存队列元素的顺序不是按加入队列的顺序，而是**按队列元素的大小进行重新排序。因此当调用peek()或poll()方法取出队列中头部的元素时，并不是取出最先进入队列的元素，而是取出队列中的最小的元素**。

```java
public class PriorityQueueTest {
    public static void main(String[] args) {
        PriorityQueue pq = new PriorityQueue();
        pq.offer(6);
        pq.add(-3);
        pq.add(20);
        pq.offer(18);
        //输出：[-3, 6, 20, 18]
        System.out.println(pq);
    }
}
```

**PriorityQueue队列对元素的要求与TreeSet对元素的要求基本一致**。**PriorityQueue不允许插入null元素，它还需要对队列元素进行排序**，PriorityQueue有两种排序方式：

- 自然排序：**采用自然排序的PriorityQueue集合中的元素必须实现Comparator接口，而且应该是一个类的多个实例**，否则可能导致ClassCastException异常；
- 定制排序：**创建PriorityQueue队列时，传入一个Comparable对象，该对象负责对所有队列中的所有元素进行排序**。采用定制排序不要求必须实现Comparator接口。

#### Dueue接口与其实现类

Queue还有一个Deque接口，**Deque代表一个可以同时从两端删除、添加元素双端队列**。**Deque的实现类既可当成队列使用，也可当成栈（先进后出）使用**。

Deque接口常用方法如下：

- void addFirst(Object e)：将指定元素插入到双端队列的头部；
- void addLast(Object e)：将指定元素插入到双端队列的尾部；
- Object getFirst()：获取但不删除双端队列的第一个元素；
- Object getLast()：获取但不删除双端队列的最后一个元素；
- boolean offerFirst(Object e)：将指定元素插入到双端队列的头部；
- boolean offerLast(OBject e)：将指定元素插入到双端队列的尾部；
- Object peekFirst()：获取但不删除双端队列的第一个元素；如果双端队列为空，则返回null；
- Object peekLast()：获取但不删除双端队列的最后一个元素；如果双端队列为空，则返回null；
- Object pollFirst()：获取并删除双端队列的第一个元素；如果双端队列为空，则返回null；
- Object pollLast()：获取并删除双端队列的最后一个元素；如果双端队列为空，则返回null；
- Object removeFirst()：获取并删除该双端队列的第一个元素；
- Object removeLast()：获取并删除该双端队列的最后一个元素o；
- Object pop()（栈方法）：pop出该双端队列所表示的栈的栈顶元素。相当于removeFirst()；
- void push(Object e)(栈方法)：将一个元素push进该双端队列所表示的栈的栈顶。相当于addFirst(e)；
- Iteratord **descendingItrator()**：返回该双端队列对应的迭代器，该迭代器以逆向顺序来迭代队列中的元素；
- Object removeFirstOccurence(Object o)：获取并删除该双端队列的第一次出现的元素o；
- Object removeLastOccurence(Object o)：获取并删除该双端队列的最后一次出现的元素o。

Java为Deque提供了ArrayDeque实现类和LinkedList两个实现类。

##### ArrayDeque实现类

**ArrayDeque是一个基于数组实现的双端队列，创建Deque时同样可指定一个numElements参数，该参数用于指定Object[]数组的长度；如果不指定numElements参数，Deque底层数组的长度为16**。

**当程序中需要使用“栈”这种数据结构时，推荐使用ArrayDeque**，尽量避免使用Stack，因为Stack是古老的集合，性能较差。

ArrayDeque当成栈使用的实例。

```java
import java.util.*;

public class ArrayDequeStack {
    public static void main(String[] args) {
        ArrayDeque stack = new ArrayDeque();
        // 依次将三个元素push入"栈"
        stack.push("金州勇士");
        stack.push("俄克拉荷马雷霆");
        stack.push("克利夫兰骑士");
        // 输出：[克利夫兰骑士, 俄克拉荷马雷霆, 金州勇士]
        System.out.println(stack);
        // 访问第一个元素，但并不将其pop出"栈"，输出：克利夫兰骑士
        System.out.println(stack.peek());
        // 依然输出：[克利夫兰骑士, 俄克拉荷马雷霆, 金州勇士]
        System.out.println(stack);
        // pop出第一个元素，输出：克利夫兰骑士
        System.out.println(stack.pop());
        // 输出：[俄克拉荷马雷霆, 金州勇士]
        System.out.println(stack);
    }
}

```

ArrayDeque作为队列使用的实例。

```java
import java.util.*;

public class ArrayDequeQueue {
    public static void main(String[] args) {
        ArrayDeque queue = new ArrayDeque();
        // 依次将三个元素加入队列
        queue.offer("克利夫兰骑士");
        queue.offer("俄克拉荷马雷霆");
        queue.offer("金州勇士");
        // 输出：[克利夫兰骑士, 俄克拉荷马雷霆, 金州勇士]
        System.out.println(queue);
        // 访问队列头部的元素，但并不将其poll出队列"栈"，输出：克利夫兰骑士
        System.out.println(queue.peek());
        // 依然输出：[克利夫兰骑士, 俄克拉荷马雷霆, 金州勇士]
        System.out.println(queue);
        // poll出第一个元素，输出：克利夫兰骑士
        System.out.println(queue.poll());
        // 输出：[俄克拉荷马雷霆, 金州勇士]
        System.out.println(queue);
    }
}
```

##### LinkedList实现类

**LinkedList实现了List接口和Deque接口，这意味着它既是一个可以根据索引来随机访元素的List集合，也可以被当成双端队列（既是栈、也可以是队列）来使用**。

```java
import java.util.*;

public class LinkedListTest {
    public static void main(String[] args) {
        LinkedList teams = new LinkedList();
        // 将字符串元素加入队列的尾部
        teams.offer("克利夫兰骑士");
        // 将一个字符串元素加入栈的顶部
        teams.push("金州勇士");
        // 将字符串元素添加到队列的头部（相当于栈的顶部）
        teams.offerFirst("俄克拉荷马雷霆");
        // 以List的方式（按索引访问的方式）来遍历集合元素
        for (int i = 0; i < teams.size() ; i++ ) {
            System.out.println("遍历中：" + teams.get(i));
        }
        // 访问、并不删除栈顶的元素
        System.out.println(teams.peekFirst());
        // 访问、并不删除队列的最后一个元素
        System.out.println(teams.peekLast());
        // 将栈顶的元素弹出“栈”
        System.out.println(teams.pop());
        // 下面输出将看到队列中第一个元素被删除
        System.out.println(teams);
        // 访问、并删除队列的最后一个元素
        System.out.println(teams.pollLast());
        // 下面输出：[金州勇士]
        System.out.println(teams);
    }
}
```

#### 各种线性表的性能分析

内部以数组为底层实现的集合在随机访问时性能都比较好，而内部以链表作为底层实现的集合在执行插入、删除操作时有较好的性能。

ArrayList与ArrayDeque内部以数组的形式来保存集合中的元素，因此随机访问集合元素时性能较好；LinkedList内部以链表的形式来保存集合中的元素，因此随机访问集合元素时性能较差，但在插入、删除元素时性能比较出色（只需改变指针所指的地址即可）。Vector也是以数组的形式来存储集合元素的，但因为它实现了线程同步功能（而且实现机制也不好），所以各方面性能都比较差。

总体来说，ArrayList的性能比LinkedList的性能要好，因此大部分时候都应该考虑使用ArrayList。

使用List集合的建议：

- 如果需要遍历List集合元素，对于ArrayList、Vector集合，应该使用随机访问方法（get）来遍历集合元素，这样性能更好；对于LinkedList集合，则应该采用迭代器来遍历集合；
- 如果需要经常执行插入、删除操作来改变包含大量数据的List集合的大小，可考虑使用LinkedList集合。使用ArrayList、Vector集合可能需要经常重新分配内部数组的大小，效果可能较差；
- 如果有多个线程需要访问List集合中的元素，开发者可考虑使用Collections将集合包装成线程安全的集合。

### Map集合

**Map集合用于保存具有映射关系的数据。Map集合中的元素用Map.Entry内部接口对象表示，每个Map.Entry对象保存着一组key：value对，key和value都可以是任何引用类型的数据对象**。

![maps](/appendix/maps.png)

**Map里的key像Set里的元素一样不可重复，实际上，Java先实现了Map，然后通过包装了一个所有value都为null的Map就实现了Set。Map也包含了一个keySet()方法，用于返回Map里所有的key组成的Set集合**。

Map接口常用方法如下：

- V put(K key, V value)：向该Map集合中添加一个key-value对。如果该Map集合中已经有一个与要添加的key相等的key，则新的key-value对的value会覆盖原来的value，该方法会返回被覆盖的value；
- void putAll(Map<? extends K, ? extends V> m)：将指定Map中的key-value对全部添加到该Map集合中；
- V remove(Object key)：删除指定key对应的key-value对，返回被删除key所关联的value值。如果该Map集合中不存在指定的key，则返回null；
- void clear()：清空该Map集合，使其大小为0；
- boolean isEmpty()：判断该Map集合是否为空；
- boolean containsKey(Object key)：判断该Map集合中是否包含指定的key；
- boolean containsValue(Object value)：判断该Map集合中是否包含指定的一个或多个value；
- int size()：返回该Map集合中key-value对的数量；
- Collection\<V> values()：返回该Map集合中所有value组成的Collection；
- Set\<Map.Entry\<K, V>> entrySet()：返回该Map结合中所有Map.Entry对像组成的Set集合；
- Set\<K> keySet()：返回该Map结合中所有key组成的Set集合；
- V get(Object key)：返回该Map集合中指定key对应的value。如果该Map集合中没有对应的key，则返回null。

Map接口常见方法测试实例。

```java
public class MapTest {
	public static void main(String[] args){
		Map map = new HashMap();
		// 成对放入多个key-value对
		map.put("Head First Java" , 109);
		map.put("Head First Android" ,10);
		map.put("Head First C++" , 79);
		map.put("Head First PHP" , 99);
      	// 多次放入的key-value对中value可以重复
		// 放入重复的key时，新的value会覆盖原有的value
		// 如果新的value覆盖了原有的value，该方法返回被覆盖的value
		System.out.println(map.put("Head First Android" , 99)); // 输出10
		System.out.println(map); // 输出的Map集合包含的4个key-value对
		// 判断是否包含指定key
		System.out.println("是否包含值为“Head First Android”的key："
			+ map.containsKey("Head First Android")); // 输出true
		// 判断是否包含指定value
		System.out.println("是否包含值为“99”value："
			+ map.containsValue(99)); // 输出true
		// 获取Map集合的所有key组成的集合，通过遍历key来实现遍历所有key-value对
		for (Object key : map.keySet() ){
			// map.get(key)方法获取指定key对应的value
			System.out.println(key + "-->" + map.get(key));
		}
		map.remove("Head First PHP"); // 根据key来删除key-value对。
		System.out.println(map); // 输出结果不再包含 疯狂Ajax讲义=79 的key-value对
	}
}
```

Java 8为Map新增了许多默认方法：

- default V putIfAbsent(K key, V value)：当该Map集合中与指定的key对应的value为null时才使用指定的value代替原来的null值。该方法返回原来不为null的value或新的value；
- default boolean remove(Object key, Object value)：删除与指定的key-value对匹配的key-value对；
- default V replace(K key, V value)：将该Map集合中指定的key对应的value替换成新的指定的value，并返回之前的value。如果指定的key不存在，则返回null；
- default boolean replace(K key, V oldValue, V newValue)：将该Map中指定的key-value对中的value替换成新的value。如果找不到指定的key-value对，则返回false，也不会添加新的key-value对；
- default void replaceAll(BiFunction<? super K, ? super V, ? extends V> function)：使用给定的BiFunction对该Map集合中所有的key-value对执行计算，将计算得到的新的key-value对替换原来的key-value对；
- default V compute(K key,BiFunction<? super K, ? super V, ? extends V>remappingFunction)：使用给定的BiFunction对该Map集合中所有的key-value对进行计算，只要计算得到的value不为null，就使用新的value覆盖原来的value。如果原来的value不为null，计算得到的新value为null，则删除原来key-value对。如果原value和新value同为null，那么该方法不改变任何key-value对，直接返回null；
- default V computeIfAbsent(K key, Function<? super K, ? extends V> mappingFunction) ：如果该Map集合中指定的key对应的value为null，则使用给定的BiFunction根据key计算一个新的value来覆盖原来值为null的value。如果该Map集合不包含指定的key，那么该方法将会添加一个新的key-value对；
- default V computeIfPresent(K key, BiFunction<? super K, ? super V, ? extends V> remappingFunction)：如果该Map中指定的key对应的value不为null，该方法将使用给定的BiFunction根据给定的key计算出一个新的value，如果新的value不为null，则使用新的value覆盖原来的value。如果新的value为null，则删除原来的key-value对；
- default void forEach(BiConsumer<? super K, ? super V> action)：通过该方法指定的BiConsumer对所有Map.Entry指定指定的操作；
- default V getOrDefault(Object key, V defaultValue)：返回指定的key对象的value，如果找不到指定的key就返回默认的value；
- default V merge(K key, V value, BiFunction<? super V, ? super V, ? extends V> remappingFunction)：该方法会先获取给定的key对应的value，如果获取的value为null，则直接使用给定的value替换原来值为null的value，如果获取的value不为null，则使用给定的BiFunction计算一个新的value，如果给定的value或计算得到的value为null，则删除这个key-value对，否则添加一组的key-value对。

默认方法测试实例。

```java
public class MapTest2 {
	public static void main(String[] args) {
		Map map = new HashMap();
		// 成对放入多个key-value对
		map.put("Head First Java", 109);
		map.put("Head First Android", 99);
		map.put("Head First PHP", 79);
		// 尝试替换key为"疯狂XML讲义"的value，由于原Map中没有对应的key，
		// 因此对Map没有改变，不会添加新的key-value对
		map.replace("Head First C++"  66);
		System.out.println(map);
		// 使用原value与参数计算出来的结果覆盖原有的value
		map.merge("Head First PHP", 10,
			(oldVal, param) -> (Integer)oldVal + (Integer)param);
		System.out.println(map); // "Head First PHP"的value增大了10
		// 当key为"Java"对应的value为null（或不存在时），使用计算的结果作为新value
		map.computeIfAbsent("Java", (key) -> ((String)key).length());
		System.out.println(map); // map中添加了 Java=4 这组key-value对
		// 当key为"Java"对应的value存在时，使用计算的结果作为新value
		map.computeIfPresent("Java",
			(key, value) -> (Integer)value * (Integer)value);
		System.out.println(map); // map中 Java=4 变成 Java=16
	}
}
```

#### HashMap和HashTable实现类

**HashMap和HashTable都是Map接口的典型实现类，他们之间的关系完全类似于ArrayList和Vector之间的关系，所以不建议使用HashTable**。

为了成功地在HashMap中存取、获取对象，应该为用作key的对象重写hashCode()和equals()方法，使两者返回一直的结果：即两个key通过equals()方法比较返回true，那么这两个key的hashCode()方法的返回值也应该相等。

与HashSet类似的是，如果使用可变对象作为HashMap的key，并且程序修改了作为key的可变对象，则也可能出现与HashSet类似的情形：程序再也无法准确访问到Map中被修改过的key了。建议**尽量不要使用可变对象作为HashMap的key，就算需要使用可变对象作为HashMap的key，也不要修改作为key的可变对象**。

#### 使用Properties读取属性文件

**Properties类是Hashtable类的子类，用于处理属性文件。Properties类可以把Map对象和属性文件关联起来，从而可以把Map对象中的key-value对写入属性文件，也可以把属性文件中的“属性名=属性值”加载到Map对象中。由于属性文件里的属性名、属性值只能是字符串类型，所以Properties里的key、value都是字符串类型**。

修改Properties里的key、value值的方法

- String getProperty(String key)：获取Properties中指定属性名对应的属性值，类似于Map的get(Object key)方法
- String getProperty(String key, String defaultValue)：该方法与前一个方法基本类似。该方法多一个功能，如果Properties中不存在指定key时，该方法返回默认值
- Object geProperty(String key、String value)：设置属性值，类似Hashtable的put方法

读、写属性文件的方法：

- void load(InputStream inStream)：从属性文件（以输入流表示）中加载属性名=属性值，把加载到的属性名=属性值对追加到Properties里（由于Properties是Hashtable)的子类，它不保证key-value对之间的次序）
- void Store(OutputStream out, String comment)：将Properties中的key-valu对写入指定属性文件（以输出流表示）

```java
public class PropertiesTest {
    public static void main(String[] args)
        throws Exception {
        Properties props = new Properties();
        // 向Properties中增加属性
        props.setProperty("username" , "LeBron");
        props.setProperty("teams" , "Cavaliers");
        // 将Properties中的key-value对保存到a.ini文件中
        props.store(new FileOutputStream("NBA.ini")
            , "comment line");
        // 新建一个Properties对象
        Properties props2 = new Properties();
        // 向Properties中增加属性
        props2.setProperty("gender" , "male");
        // 将a.ini文件中的key-value对追加到props2中
        props2.load(new FileInputStream("NBA.ini") ); 
        System.out.println(props2);
    }
}
```

#### LinkedHashMap实现类

类似于LinkedHashSet与HashSet的关系，**LinkedHashMap是HashMap的子类**。LinkedHashMap也使用双向链表来维护kye-value对的次序（只需要考虑key的次序即可），迭代顺序与key-value对的添加顺序保持一致。

LinkedHashMap需要维护元素的顺序，因此性能略低于HashMap，但它的链表结构在迭代访问时有很好的性能。

#### TreeMap实现类

正如Set接口派生出SortedSet子接口，SortedSet接口有一个TreeSet实现类一样，**Map接口也派生出一个SortedMap子接口，SortedMap接口也有一个TreeMap实现类**。

**TreeMap就是一个红黑树数据结构，每个key-value对即作为红黑树的一个节点。TreeMap存储key-value对时，需要根据key对节点进行排序。TreeMap可以保证所有的key-value对处于有序状态**。TreeMap也有两种排序方式：

1. 自然排序：TreeMap的所有key必须实现Comparable接口，而且所有的key应该是同一个类的对象，否则将会抛出ClassCastException异常。
2. 定制排序：创建TreeMap时，传入一个Comparator对象，该对象负责对TreeMap中的所有key进行排序。采用定制排序不需要Map的key实现Comparable接口。

类似于TreeSet中判断两个元素相等的标准，TreeMap中判断两个key相等的标准是：两个key通过compareTo()方法返回0。与TreeSet类似的是，TreeMap中也提供了一系列根据key顺序访问key-value对的方法：

- Map.Entry\<K,V> firstEntry()：返回一个与此映射中的最小键关联的键-值映射关系；如果映射为空，则返回 null；
- Map.Entry\<K,V> lastEntry()返回与此映射中的最大键关联的键-值映射关系；如果映射为空，则返回 null；
- Map.Entry\<K,V> higherEntry(K key)：返回一个键-值映射关系，它与严格大于给定键的最小键关联；如果不存在这样的键，则返回 null；
- Map.Entry\<K,V> lowerEntry(K key)返回一个键-值映射关系，它与严格小于给定键的最大键关联；如果不存在这样的键，则返回 null；
- K firstKey()：返回此映射中当前第一个（最低）键，如果映射为空，则返回 null；
- K lastKey()：返回此映射中当前最后一个（最高）键，如果映射为空，则返回 null；
- K higherKey(K key)：返回严格大于给定键的最小键；如果不存在这样的键，则返回 null；
- K lowerKey(K key)：返回严格小于给定键的最大键；如果不存在这样的键，则返回 null；
- NavigableMap\<K,V> subMap(K fromKey, boolean fromInclusive, K toKey, boolean toInclusive)：返回该Map的子Map，其key范围是从fromKey(是否包括取决于第二个参数)到toKey(是否包括取决于第四个参数)；
- SortedMap\<K,V> subMap(K fromKey, K toKey)：返回此Map的子Map，其key范围是从fromKey(包括)到toKey(不包括)；
- SortedMap\<K,V> tailMap(K fromKey)：返回该Map的子Map，其key的范围是大于fromKey(包括)的所有key；
- NavigableMap\<K,V> tailMap(K fromKey, boolean inclusive)：返回该Map的子Map，其key的范围是大于fromKey(是否包括取决于第二个参数)的所有key；
- SortedMap\<K,V> headMap(K toKey)：返回该Map的子Map，其key的范围是小于toKey（不包括）的所有key；
- NavigableMap\<K,V> headMap(K toKey, boolean inclusive)：返回该Map的子Map，其key的范围是小于toKey（是否包括取决于第二个参数）的所有key。

TreeMap常用方法测试实例。

```java
class R implements Comparable{

    int count;

    public R(int count) {
        this.count = count;
    }

    //根据count值判断两个对象是否相等
    @Override
    public boolean equals(Object obj) {
        if(this == obj) return true;
        if(obj == null || this.getClass() != obj.getClass()) return false;
        R r = (R)obj;
        return this.count == r.count;
    }

    // 根据count属性值来判断两个对象的大小
    @Override
    public int compareTo(Object o) {
        R r = (R)o;
        return this.count > r.count ? 1: this.count < r.count ? -1 : 0;
    }

    @Override
    public String toString() {
        return "R [count=" + count + "]";
    }
}

public class TreeMapTest {
    public static void main(String[] args) {
        TreeMap tm = new TreeMap<>();
        tm.put(new R(3),"Java");
        tm.put(new R(-5),"Python");
        tm.put(new R(9),"C++");

        System.out.println(tm);
        // 返回第一个键值对
        System.out.println(tm.firstEntry());
        // 返回最后一个键
        System.out.println(tm.lastKey());
        // 返回比new R(2)大的最小的key-value对
        System.out.println(tm.higherEntry(new R(2)));
        // 返回比new R(2)小的最大key值
        System.out.println(tm.lowerKey(new R(2)));
        // 返回key在new R(-1)和new R(4)之间的子Map
        System.out.println(tm.subMap(new R(-1), new R(4)));
    }
}
```

输出结果如下。

```shell
{R [count=-5]=Python, R [count=3]=Java, R [count=9]=C++}
R [count=-5]=Python
R [count=9]
R [count=3]=Java
R [count=-5]
{R [count=3]=Java}
```

#### WeakHashMap实现类

WeakHashMap与HashMap的用法基本相同，区别在于：后者的key保留对象的强引用，即只要HashMap对象不被销毁，其对象所有key所引用的对象不会被垃圾回收，HashMap也不会自动删除这些key所对应的键值对对象。但**WeakHashMap的key只保留了对象的弱引用，如果WeakHashMap对象的key所引用的对象没有被其他强引用变量所引用，则这些key所引用的对象可能被回收，一旦回收了，WeakHashMap会自动删除这些key所对应的key-value对**。

如果需要使用WeakHashMap的key来保留对象的弱引用，则不要让该key所引用的对象具有任何强引用，否则就失去了使用WeakHashMap的意义。

#### IdentityHashMap类

IdentityHashMap与HashMap基本相似，**只是当两个key严格相等时，即key1==key2时，它才认为两个key是相等的 。IdentityHashMap也允许使用null，但不保证键值对之间的顺序**。

#### EnumMap类

1. **EnumMap在内部以数组形式保存，这种实现非常紧凑、高效**；
2. **EnumMap中所有key都必须是单个枚举类的枚举值，创建EnumMap时必须显示或隐式指定它对应的枚举类**；
3. **EnumMap根据key的自然顺序，即枚举值在枚举类中定义的顺序，来维护键值对的次序**；
4. **EnumMap不允许使用null作为key值，但value可以**。

#### 各Map实现类的性能分析

由于TreeMap底层采用红黑树来管理key-value对的顺序，所以TreeMap通常比HashMap要慢（尤其在插入、删除key-value对时更慢）。

TreeMap可以保证key-value对的顺序，无须进行专门的排序操作。可以依次通过keySet()方法返回key的Set集合，在使用toArray()方法来返回key的数组，然后再使用Arrays.binarySearch()方法在已排序好的数组快速查找对象。

**一般情况下，应多考虑使用HashMap，因为HashMap就是为快速查询设计的**（HashMap底层也是数组形式）。但**如果程序需要一个排序好的Map时，可以考虑使用TreeMap**。

**LinkedHashMap的随机查找性能比HashMap慢一点，因为它需要维护链表来保持key-value对的顺序。但是LinkedHashMap的插入、删除操作很快**。

### 操作集合Collections工具类

Java提供了一个操作Set、List和Map等集合的Collections工具类。**Collections工具类提供了大量方法对集合进行排序、查询和修改等操作，还提供了将集合对象置为不可变、对集合对象实现同步控制等方法**。

#### 排序操作

- void reverse(List list)：反转指定List集合中元素的顺序；
- void shuffle(List list)：对List集合元素进行随机排序（shuffle方法模拟了“洗牌”动作）；
- void sort(List list)：根据元素的自然顺序对指定List集合的元素按升序进行排序；
- void sort(List list, Comparator c)：根据指定Comparator比较器产生的顺序对List集合元素进行排序；
- void swap(List list, int i, int j)：在指定List集合中的i处元素和j处元素进行交换；
- void rotate(List list, int distance)：当distance为正数时，将List集合的后distance个元素“整体”移到前面；当distance为负数时，将list集合的前distance个元素“整体”移到后边。该方法不会改变集合的长度。

```java
public class SortTest {
    public static void main(String[] args) {
        ArrayList nums = new ArrayList();
        nums.add(2);
        nums.add(-5);
        nums.add(3);
        nums.add(0);
        System.out.println(nums); // 输出:[2, -5, 3, 0]
        Collections.reverse(nums); // 将List集合元素的次序反转
        System.out.println(nums); // 输出:[0, 3, -5, 2]
        Collections.sort(nums); // 将List集合元素的按自然顺序排序
        System.out.println(nums); // 输出:[-5, 0, 2, 3]
        Collections.shuffle(nums); // 将List集合元素的按随机顺序排序
        System.out.println(nums); // 每次输出的次序不固定
    }
}

```

#### 查找、替换操作

- int binarySearch(List list, Object key)：使用二分搜索法搜索指定列表，以获得指定对象在List集合中的索引。 此前必须保证List集合中的元素已经处于有序状态；
- Object max(Collection coll)：根据元素的自然顺序，返回给定collection中的最大元素；
- Object max(Collection coll, Comparator comp)：根据指定Comparator比较器产生的顺序，返回给定collection中的最大元素；
- Object min(Collection coll)：根据元素的自然顺序，返回给定collection中的最小元素；
- Object min(Collection coll, Comparator comp)：根据指定Comparator比较器产生的顺序，返回给定 collection中的最小元素；
- void fill(List list, Object obj)：使用指定元素obj替换指定List集合中的所有元素；
- int frequency(Collection c, Object o)：返回指定collection中指定元素的出现次数；
- int indexOfSubList(List source, List target)：返回子List对象在父List对象中第一次出现的位置索引；如果没有出现这样的列表，则返回-1；
- int lastIndexOfSubList(List source, List target)：返回子List对象在父List对象中最后一次出现的位置索引；如果没有出现这样的列表，则返回-1；
- boolean replaceAll(List list, Object oldVal, Object newVal)：使用一个新值newVal替换List对象的所有旧值oldVal。

```java
public class SearchTest {
    public static void main(String[] args) {
        ArrayList nums = new ArrayList();
        nums.add(23);
        nums.add(0);
        nums.add(9);
        nums.add(3);
        System.out.println(nums); // 输出:[23, 0, 9, 3]
        System.out.println(Collections.max(nums)); // 输出最大元素，将输出23
        System.out.println(Collections.min(nums)); // 输出最小元素，将输出0
        Collections.replaceAll(nums , 0 , 1); // 将nums中的0使用1来代替
        System.out.println(nums); // 输出:[23, 1, 9, 3]
        // 判断-5在List集合中出现的次数，返回1
        System.out.println(Collections.frequency(nums , 23));
        Collections.sort(nums); // 对nums集合排序
        System.out.println(nums); // 输出:[1, 3, 9, 23]
        //只有排序后的List集合才可用二分法查询，输出3
        System.out.println(Collections.binarySearch(nums , 23));
    }
}

```

#### 同步控制

**Collectons提供了多个synchronizedXxx()静态方法，该方法可以将指定集合包装成线程同步的集合**，从而解决多线程并发访问集合时的线程安全问题

Java常用的集合框架中的实现类HashSet、TreeSet、ArrayList、LinkedList、HashMap、TreeMap都是线程不安全的。Collections提供了多个静态方法可以把他们包装成线程同步的集合。

- Collection synchronizedCollection(Collection c)：返回指定collection支持的同步（线程安全的）collection
- List synchronizedList(List list)：返回指定List支持的同步（线程安全的）List
- Map synchronizedMap(Map m)：返回由指定Map支持的同步（线程安全的）Map
- Set synchronizedSet(Set s)：返回指定Set支持的同步（线程安全的）Set

```java
public class SynchronizedTest {
    public static void main(String[] args) {
        // 下面程序创建了四个线程安全的集合对象
        Collection c = Collections
            .synchronizedCollection(new ArrayList());
        List list = Collections.synchronizedList(new ArrayList());
        Set s = Collections.synchronizedSet(new HashSet());
        Map m = Collections.synchronizedMap(new HashMap());
    }
}

```

#### 设置不可变集合

Collections提供了如下三个方法来返回一个不可变集合：

- emptyXxx()：返回一个空的、不可变的集合对象，此处的集合既可以是List、SortedSet、Set、SortedMap、Map；
- singletonXxx()：返回一个只包含指定对象（只有一个或一个元素）的、不可变的集合对象，此处的集合可以是List和Map；
- unmodifiableXxx()：返回指定集合对象的不可变视图，此处的集合可以是：List、SortedSet、Set、SortedMap、Map。

通过上面Collections提供的三类方法，可以生成“只读”的Collection或Map

```java
public class UnmodifiableTest {
    public static void main(String[] args) {
        // 创建一个空的、不可改变的List对象
        List unmodifiableList = Collections.emptyList();
        // 创建一个只有一个元素，且不可改变的Set对象
        Set unmodifiableSet = Collections.singleton("MVP");
        // 创建一个普通Map对象
        Map player = new HashMap();
        player.put("勒布朗詹姆斯", 23);
        player.put("克莱汤普森", 11);
        // 返回普通Map对象对应的不可变版本
        Map unmodifiableMap = Collections.unmodifiableMap(player);
        // 下面任意一行代码都将引发UnsupportedOperationException异常
        // unmodifiableList.add("德怀恩韦德"); 
        // unmodifiableSet.add("克里斯波什"); 
        // unmodifiableMap.put("语伊戈达拉", 9);
    }
}
```