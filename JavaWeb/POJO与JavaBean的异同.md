## POJO与JavaBean的异同

按照Martin Fowler的解释是“Plain Old Java Object”，从字面上翻译为“纯洁老式的Java对象”，但大家都使用“简单java对象”来称呼它。POJO的内在含义是指那些没有从任何类继承、也没有实现任何接口，更没有被其它框架侵入的java对象。

pojo和javabean的比较
pojo的格式是用于数据的临时传递，它只能装载数据， 作为数据存储的载体，而不具有业务逻辑处理的能力。
而javabean虽然数据的获取与pojo一样，但是javabean当中可以有其它的方法。

JavaBean 是一种JAVA语言写成的可重用组件。它的方法命名，构造及行为必须符合特定的约定：
这个类必须有一个公共的缺省构造函数。
这个类的属性使用getter和setter来访问，其他方法遵从标准命名规范。
这个类应是可序列化的。

JavaBean的任务就是: “Write once, run anywhere, reuse everywhere”，即“一次性编写，任何地方执行，任何地方重用”。
JavaBean可分为两种：一种是有用户界面（UI，User Interface）的JavaBean；还有一种是没有用户界面，主要负责处理事务（如数据运算，操纵数据库）的JavaBean。JSP通常访问的是后一种JavaBean。

JavaBean遵循以下约定：

- JavaBean类中一般不含有任何业务逻辑代码。
- JavaBean类所有的实例变量必须是private的。
- JavaBean类必须getter和setter方法。
- JavaBean类必须实现Serializable接口或Externalizable接口，即JavaBean必须是可序列化的。
- JavaBean类必须有一个public的默认无参构造器；


- ​
- ​
- 更多信息参考 [JavaBeans Conventions](http://docstore.mik.ua/orelly/java-ent/jnut/ch06_02.htm) 。POJO (plain old Java object) 不是一个严格的定义。它是没有被强制要实现一个特定的接口、或继承一个特定的类，或使用特定注解来兼容指定的框架，可以是任何（一般是比较简单的）Java对象。

所有的JavaBean对象都是POJO，而不是所有的POJO都是JavaBean。