Java集合框架

### Java集合类简介

Java集合大致可以分为Set、List、Queue和Map四种体系，其中Set代表无序、不可重复的集合；List代表有序、重复的集合；而Map则代表具有映射关系的集合，Java 5 又增加了Queue体系集合，代表一种队列集合实现。

Java集合就像一种容器，可以把多个对象（实际上是对象的引用，但习惯上都称对象）“丢进”该容器中。从Java 5 增加了泛型以后，Java集合可以记住容器中对象的数据类型，使得编码更加简洁、健壮。

### Java集合和数组的区别

1. 数组长度在初始化时指定，意味着只能保存定长的数据。而集合可以保存数量不确定的数据。同时可以保存具有映射关系的数据（即关联数组，键值对 key-value）；
2. 数组元素即可以是基本类型的值，也可以是对象（实际上是对象的引用，一般习惯上称为对象）。集合里只能保存对象（实际上也只是对象的引用变量），基本数据类型的变量要转换成对应的包装类才能放入集合类中。

### Java集合类之间的继承关系

Java的集合类主要由两个接口派生而出：Collection和Map，Collection和Map是Java集合框架的根接口。

![1637925-6cf37434c1809fe6](C:\Users\Administrator\Desktop\studynotes\JavaSE\appendix\1637925-6cf37434c1809fe6.jpg)

### Iterable接口

迭代器接口，这是Collection类的父接口。实现这个Iterable接口的对象允许使用foreach循环进行遍历，也就是说，所有的Collection集合对象都具有"foreach可遍历性"。该接口方法如下：

- public abstract Iterator\<T> iterator()：其实现类通过该方法返回一个代表当前集合对象的泛型\<T>迭代器，用于之后的遍历操作；
- default void forEach(Consumer<? super T> action)：其实现类通过该默认方法根据传入的action对象来对每个元素来执行特定操作；
- default Spliterator\<T> spliterator()：返回一个Spliterator（splitable iterator可分割迭代器），Spliterator接口是Java为了并行遍历数据源中的元素而设计的迭代器（是Iterator的升级版），这个可以类比最早Java提供的顺序遍历迭代器Iterator，但一个是顺序遍历，一个是并行遍历。该方法的默认实现功能有限，一般需要重写。

> 注意：最早Java提供顺序遍历迭代器Iterator时，那个时候还是单核时代，但现在多核时代下，把多个任务分配到不同核上并行执行才能最大发挥多核的能力，所以Spliterator应运而生。参考：https://segmentfault.com/q/1010000007087438

上面的iterator()方法返回的Iterator接口对象用于遍历集合元素。它含有以下方法：

- public abstract boolean hashNext()：判断当前的遍历位置后面是否还有下一个元素；
- public abstract E next()：返回下一个元素；
- default void remove()：删除当前遍历到的元素。可以先使用hashNext()判断是否有下一个元素，如果有责next()一次，然后remove()一次。但是在遍历时通过其他方法（不包括本方法）修改了当前集合集合，那么该方法的执行结果是不确定的；
- default void forEachRemaining(Consumer<? super E> action)：对剩余的元素按照迭代顺序（如果指定了迭代顺序）执行给定的操作，直到全部元素执行完毕或抛出异常。

### Collection接口

Collection接口是Set，Queue，List的父接口。Collection接口中定义了多种方法可供其子类进行实现，以实现数据操作。由于方法比较多，就偷个懒，直接把JDK文档上的内容搬过来。

常用方法如下：

- boolean add(E e)：
- boolean addAll(Collection<? extends E> c)：
- boolean contains(Object o)：
- boolean containsAll(Collection<?> c)：
- boolean remove(Object o)：
- boolean removeAll(Collection<?> c)：
- default boolean removeIf(Predicate<? super E> filter)：
- void clear()：
- boolean isEmpty()：
- int size()：
- Iterator\<E> iterator()：
-  boolean retainAll(Collection<?> c)：
- Object[] toArray()：
- \<T> T[] toArray(T[] a)：
- default Spliterator\<E> spliterator()：
-  default Stream\<E> stream()：
- default Stream\<E> parallelStream()：



























