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

Collection接口是Set，Queue，List的父接口。Collection接口中定义了多种方法可供其子类进行实现，以实现数据操作。由于方法比较多，就偷个懒，直接把JDK文档上的内容搬过来。

常用方法如下：

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

- 不能保证元素的排列顺序，顺序可能与添加顺序不同，顺序也有可能发生变化；
- HashSet不是同步的，如果有两个或两个以上线程同时修改了同一个HashSet集合时，则必须通过代码来保证其同步；
- 集合元素值可以是null。

**当向HashSet集合中存入一个元素时，HashSet会调用该对象的hashCode()方法来得到该对象的hashCode()值，然后根据该hashCode()值决定该对象在HashSet中的存储位置；HashSet集合判断两个元素相等的标准是两个对象通过equals()方法比较相等，并且两个对象的hashCode()方法返回值也相等。所以有必要时应该重写所添加对象所属类的equals()方法和hashCode()方法，使两者的判断一致。**

hash（也被翻译为哈希、散列）算法的功能：它能保证快速查找被检索的对象，hash算法的价值在于速度。当需要查询集合中某个元素时，**hash算法可以根据该元素的hashCode值计算出该元素的存储位置，从而快速定位该元素**。

之所以选择HashSet，而不直接使用数组，是因为**数组元素的索引是连续的，而且数组的长度是固定的、无法自由增加数组的长度。而HashSet采用每个元素的hashCode值来计算其存储位置，从而可以自由增加HashSet的长度，并可以根据元素的HashCode值来访问元素**。

HashSet中每个能存储元素的“槽位”(slot)通常称为“桶”(bucket)。重写hashCode()方法的基本规则如下：

- 在程序运行过程中，同一个对象多次调用hashCode()方法应该返回相同的值
- 当两个对象通过equals()方法比较返回true时，这两个对象的hashCode()方法应该返回相等的值
- 对象中用作equals()方法比较标准的实例变量，都应该用于计算hashCode()值

hashCode()方法的基本重写步骤

- 把对象内每个有意义的实例变量（即每个参与equals()方法比较标准的实例变量）计算出一个Int类型的hashCode值

![img](https://segmentfault.com/img/bVHjks?w=729&h=123)

- 用第一步计算出来的多个hashCode值组合计算出一个hashCode值返回

## LinkedHashSet类

LinkedHashSet集合根据元素的hashCode值来决定元素的存储位置，同时使用链表维护元素的次序，这样使得元素看起来是以插入的顺序保存的。当遍历LinkedHashSet集合里的元素时，LinkedHashSet将会按元素的添加顺序来访问集合里的元素

LinkedHashSet需要维护元素的插入顺序，因此性能略低于HashSet的性能，但在迭代访问Set里的全部元素时将有很好的性能，因为它以链表来维护内部顺序

虽然LinkedHashSet使用了链表记录集合元素的添加顺序，但LinkedHashSet依然是HashSet，因此不允许集合元素重复

## TreeSet类

TreeSet是SortedSet接口的实现类，可以确保集合元素处于排序状态。根据元素实际值的大小进行排序

TreeSet的额外方法

- Comparator comparator()：如果TreeSet采用了定制排序，则该方法返回定制排序所使用的Comparator；如果TreeSet采用了自然排序，则返回null
- Object first()：返回集合中的第一个元素
- Object last()：返回集合中的最后一个元素
- Object lower(Object e)：返回集合中位于指定元素之前的元素（即小于指定元素的最大元素，参考元素不需要是TreeSet集合里的元素）
- Object higher(Object e)：返回集合中位于指定元素之后的元素（即大于指定元素的最小元素，参考元素不需要是TreeSet集合里的元素）
- SortedSet subSet(Object fromElement, Object toElement)：返回此Set的子集，范围从fromElement（包括）到toElement（不包括）
- SortedSet headSet(Object toElement)：返回此Set的子集，由小于toElement的元素组成
- SortedSet tailSet(Object fromElement)：返回此Set的子集，由大于或等于fromElement的元素组成

HashSet采用hash算法来决定元素的存储位置，TreeSet采用红黑树的数据结构来存储集合元素。

TreeSet支持两种排序方法。在默认情况下，TreeSet采用自然排序

```
import java.util.*;

public class TreeSetTest
{
    public static void main(String[] args)
    {
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

### 自然排序

TreeSet会调用集合元素的compareTo(Object obj)方法来比较元素之间的大小关系，然后将集合元素按升序排列，这种方式就是自然排列

compareTo(Object obj)方法返回一个整数值，实现该接口的类必须实现该方法，实现了该接口的类的对象就可以比较大小。当一个对象调用该方法与另一个对象进行比较时，例如obj1.compareTo(obj2)，如果该方法返回0，则表明这两个对象相等；如果该方法返回一个正整数，则表明obj1大于obj2；如果该方法返回一个负整数，则表明obj1小于obj2

实现了Comparable接口的常用类

- BigDecimal、BigInteger以及所有的数组型对应的包装类：按它们对应的数组大小进行比较
- Character：按字符的UNICODE值进行比较
- Boolean：true对应的包装类实例大于false对应的包装类实例
- String：按字符串中字符的UNICODE值进行比较
- Date、Time：后面的时间、日期比前面的时间、日期大

一个对象添加到TreeSet时，则该对象的类必须实现Comparable接口，否则程序将会抛出异常

```
import java.util.TreeSet;

class Error{ }
public class TreeSetErrorTest 
{
    public static void main(String[] args) 
    {
        TreeSet treeSet = new TreeSet<>();
        treeSet.add(new Error());
        treeSet.add(new Error());        //①
    }
}

```

添加第一个对象时，TreeSet里没有任何元素，所以不会出现任何问题；当添加第二个Error对象时，TreeSet就会调用该对象的compareTo(Object obj)方法与集合中的其他元素进行比较——如果其对应的类没有实现Comparable接口，则会引发ClassCastException异常

向TreeSet集合中添加元素时，只有第一个元素无须实现Comparable接口，后面添加的所有元素都必须实现Comparable接口把一个对象添加到TreeSet集合时，TreeSet会调用该对象的compareTo(Object obj)方法与集合中的其他元素进行比较。向TreeSet中添加的应该是同一个类的对象，否则也会引发ClassCastException异常

如果希望TreeSet能正常运行，TreeSet只能添加同一种类型的对象

当把一个对象加入TreeSet集合中时，TreeSet调用该对象的compareTo(Object obj)方法与容器中的其他对象比较大小，然后根据红黑树结构找到它的存储位置。如果两个对象通过compareTo(Object obj)方法比较相等，新对象将无法添加到TreeSet集合中

### 定制排序

TreeSet的自然排序是根据集合元素的大小，TreeSet将它们以升序排列。如果需要实现定制排序，例如以降序排列，则可以通过Comparator接口的帮助。

```
class M
{
    int age;
    public M(int age)
    {
        this.age = age;
    }
    public String toString()
    {
        return "M[age:" + age + "]";
    }
}
public class TreeSetTest4
{
    public static void main(String[] args)
    {
        // 此处Lambda表达式的目标类型是Comparator
        TreeSet ts = new TreeSet((o1 , o2) ->
        {
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

## EnumSet类

EnumSet是一个专为枚举类设计的集合类，EnumSet中的所有元素都必须是指定枚举类型的枚举值，该枚举类型在创建EnumSet时显式或隐式地指定。EnumSet的集合元素也是有序的，EnumSet以枚举值在Enum类内的定义顺序来决定集合元素的顺序

EnumSet在内部以位向量的形式存储，EnumSet对象占用内存很小，运行效率很好。尤其是进行批量操作（如调用containsAll()和retainAll()方法）时，如果其参数也是EnumSet集合，则该批量操作的执行速度也非常快

EnumSet集合不允许加入null元素，否则抛出NullPointException异常

EnumSet没有暴露任何构造器来创建该类的实例，应通过其提供的类方法来创建EnumSet对象

- EnumSet allOf(Class elementType): 创建一个包含指定枚举类里所有枚举值的EnumSet集合
- EnumSet complementOf(EnumSet e): 创建一个其元素类型与指定EnumSet里元素类型相同的EnumSet集合，新EnumSet集合包含原EnumSet集合所不包含的、此类枚举类剩下的枚举值（即新EnumSet集合和原EnumSet集合的集合元素加起来是该枚举类的所有枚举值）
- EnumSet copyOf(Collection c): 使用一个普通集合来创建EnumSet集合
- EnumSet copyOf(EnumSet e): 创建一个指定EnumSet具有相同元素类型、相同集合元素的EnumSet集合
- EnumSet noneOf(Class elementType): 创建一个元素类型为指定枚举类型的空EnumSet
- EnumSet of(E first,E…rest): 创建一个包含一个或多个枚举值的EnumSet集合，传入的多个枚举值必须属于同一个枚举类
- EnumSet range(E from,E to): 创建一个包含从from枚举值到to枚举值范围内所有枚举值的EnumSet集合

```
enum Season
{
    SPRING,SUMMER,FALL,WINTER
}
public class EnumSetTest
{
    public static void main(String[] args)
    {
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

EnumSet可以复制另一个EnumSet集合中的所有元素来创建新的EnumSet集合，或者复制另一个Collection集合中的所有元素来创建新的EnumSet集合。当复制Collection集合中的所有元素来创建新的EnumSet集合时，要求Collection集合中的所有元素必须是同一个枚举类的枚举值

## 各Set实现类的性能分析

HashSet的性能总比TreeSet好，特别是最常用的添加、查询元素等操作。因为TreeSet需要额外的红黑树算法来维护集合元素的次序。只有当需要保持排序的Set时，才应该使用TreeSet，否则都应该使用HashSet

LinkedHashSet是HashSet的一个子类，对于普通的插入、删除操作，LinkedHashSet比HashSet要略微满意的，这是由维护链表所带来的额外开销所造成的，但由于有了链表，遍历LinkedHashSet会更快

EnumSet是所有Set实现类中性能最好的，但它只能保存同一个枚举的枚举值作为集合元素

HashSet、TreeSet、EnumSet都是线程不安全的，如果有多个线程同时访问一个Set集合，并且有超过一个线程修改了该Set集合，则必须手动保证该Set集合的同步性。通常可以通过Collections工具类的synchronizedSortedSet方法来“包装”该Set集合。在创建时进行，以防对Set集合的意外非同步访问

```
SortedSet s = Collections.synchronizedSortedSet(new TreeSet(...));
```
















