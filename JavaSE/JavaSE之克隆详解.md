---
typora-copy-images-to: appendix
typora-root-url: appendix
---

## Java中对象的创建

clone顾名思义就是复制， 在Java语言中， clone方法被对象调用，所以会复制对象。所谓的复制对象，首先要分配一个和源对象同样大小的空间，在这个空间中创建一个新的对象。那么在java语言中，有几种方式可以创建对象呢？

- 使用new操作符创建一个对象
- 使用clone方法复制一个对象

那么这两种方式有什么相同和不同呢？ new操作符的本意是分配内存。程序执行到new操作符时， 首先去看new操作符后面的类型，因为知道了类型，才能知道要分配多大的内存空间。分配完内存之后，再调用构造函数，填充对象的各个域，这一步叫做对象的初始化，构造方法返回后，一个对象创建完毕，可以把他的引用（地址）发布到外部，在外部就可以使用这个引用操纵这个对象。而clone在第一步是和new相似的， 都是分配内存，调用clone方法时，分配的内存和源对象（即调用clone方法的对象）相同，然后再使用原对象中对应的各个域，填充新对象的域， 填充完成之后，clone方法返回，一个新的相同的对象被创建，同样可以把这个新对象的引用发布到外部。

## 复制对象 or 复制引用

在Java中，以下类似的代码非常常见：

```java
Person p = new Person(23, "zhang");  
Person p1 = p;  
 
System.out.println(p);  
System.out.println(p1);  
```

当`Person p1 = p;`执行之后， 是创建了一个新的对象吗？ 首先看打印结果：

```powershell
com.pansoft.zhangjg.testclone.Person@2f9ee1ac
com.pansoft.zhangjg.testclone.Person@2f9ee1ac
```

可已看出，打印的hashCode值（根据引用地址计算得来）是相同的，既然hashCode值都是相同的，那么肯定是同一个对象。p和p1只是引用而已，他们都指向了一个相同的对象`Person(23, "zhang")` 。 可以把这种现象叫做**引用的复制**。上面代码执行完成之后， 内存中的情景如下图所示：

![reference_copy](/reference_copy.jpg)

而下面的代码是真真正正的克隆了一个对象。

```java
Person p = new Person(23, "zhang");  
Person p1 = (Person) p.clone();  
  
System.out.println(p);  
System.out.println(p1); 
```

从打印结果可以看出，两个对象的hashCode值是不同的，也就是说创建了新的对象， 而不是把原对象的引用赋给了一个新的引用变量：

```powershell
com.pansoft.zhangjg.testclone.Person@2f9ee1ac
com.pansoft.zhangjg.testclone.Person@67f1fba0
```

以上代码执行完成后， 内存中的情景如下图所示：

![TIM截图20170616145042](/TIM截图20170616145042.jpg)

## 浅拷贝

先看下面的浅拷贝示例：

```java
class Course {
    String subject1;
    String subject2;
    String subject3;

    public Course(String sub1, String sub2, String sub3) {
        this.subject1 = sub1;
        this.subject2 = sub2;
        this.subject3 = sub3;
    }
}

class Student implements Cloneable {
    int id;
    String name;
    Course course;

    public Student(int id, String name, Course course) {
        this.id = id;
        this.name = name;
        this.course = course;
    }

    // Object类的clone()方法默认创建浅拷贝的对象
    protected Object clone() throws CloneNotSupportedException {
        return super.clone();
    }
}

public class ShallowCopyInJava {
    public static void main(String[] args) {
        Course science = new Course("Physics", "Chemistry", "Biology");
        Student student1 = new Student(111, "John", science);
        Student student2 = null;

        try {
            // 创建一个student1浅拷贝的克隆对象并赋值给student2
            student2 = (Student) student1.clone();
        } catch (CloneNotSupportedException e) {
            e.printStackTrace();
        }

        // 判断student1和student2的course字段是否为同一个对象，输出为true
        System.out.println(student1.course == student2.course);
        // 修改student2的subject3为“Maths”
        student2.course.subject3 = "Maths";
        // 上面的改变也会映射到源对象student1对象上，输出的student2上修改的结果，是“Maths”
      	// 因为student1和student2的course字段引用的是同一个Course对象
        System.out.println(student1.course.subject3); 
    }
}
```

由于id是基本数据类型，由于基本类型变量存储的就是基本类型的数值，所以拷贝时直接将一个4字节的整数值拷贝过来就行。但是name和course是引用类型， 指向一个真正的对象。在上面的实例中，将直接将源对象中引用变量的引用值拷贝给新对象中的同名变量。这种拷贝叫浅拷贝（Shallow Copy）。浅拷贝的原理如下图所示。

![ShallowCopy](/ShallowCopy.png)

## 深拷贝

在克隆时，如果根据源对象中的引用变量所引用的对象来创建一个新的相同的内部克隆对象，将这个内部克隆对象的引用赋给外部克隆对象中引用变量，这种克隆就是**深拷贝（Deep Copy）**。

**如果想要深拷贝一个对象， 这个对象的类（或其父类）必须要实现Clonable标记接口并处理`CloneNotSupportedException`异常，然后重写Object类的clone方法。重写clone方法时不但要调用父类的clone方法来返回一个当前类的对象引用，还要把当前类中其他所有引用变量也要clone一份 **。

> 标记接口没有声明要实现的抽象方法，仅用于告诉JVM要实现的功能，其他的标记接口如能实现序列化的Serializable接口。

下面的示例演示了Student类的course字段的深拷贝。

```java
class Course implements Cloneable {
    String subject1;
    String subject2;
    String subject3;

    public Course(String sub1, String sub2, String sub3) {
        this.subject1 = sub1;
        this.subject2 = sub2;
        this.subject3 = sub3;
    }

    protected Object clone() throws CloneNotSupportedException {
        return super.clone();
    }
}

class Student implements Cloneable {
    int id;
    String name;
    Course course;

    public Student(int id, String name, Course course) {
        this.id = id;
        this.name = name;
        this.course = course;
    }

    // 重写clone()方法来创建一个深拷贝的对象
   	// 重写时不但要调用父类的clone方法来返回一个当前类的对象引用，还要把当前类中其他所有引用变量也要clone一份 
    protected Object clone() throws CloneNotSupportedException {
        Student student = (Student) super.clone();
        student.course = (Course) course.clone();
        return student;
    }
}

public class DeepCopyInJava {
    public static void main(String[] args) {
        Course science = new Course("Physics", "Chemistry", "Biology");
        Student student1 = new Student(111, "John", science);
        Student student2 = null;

        try {
            // 创建一个深拷贝的student1并将其赋值给student2
            student2 = (Student) student1.clone();
        } catch (CloneNotSupportedException e) {
            e.printStackTrace();
        }

        // 判断student1和student2的course字段是否为同一个对象，输出为false
        System.out.println(student1.course == student2.course);
        // 修改student2的subject3为“Maths”
        student2.course.subject3 = "Maths";
        // 上面的改变不会映射到源对象student1对象上，输出的仍是student1的course变量原来的所引用的对象，仍是是“Biology”
      	// 因为student1和student2的course字段引用的不是同一个Course对象了
        System.out.println(student1.course.subject3); 
    }
}
```

上面实例的原理图如下所示。

![DeepCopy](/DeepCopy.png)

当无法确定是一个对象是否实现了Clonable接口并重写了clone方法时，可以使用instanceof运算符来判断当前对象是否是Clonable接口类型的变量。

## 浅拷贝和深拷贝的区别

| 浅拷贝（Shallow Copy）            | 深拷贝（Deep Copy）                   |
| ---------------------------- | -------------------------------- |
| 克隆的对象和源对象不是100%互斥的           | 克隆对象和源对象是100%互斥的                 |
| 克隆对象的任何改变都会映射到源对象上，反之亦然      | 克隆对象的任何改变不会映射到源对象上，反之亦然          |
| clone方法默认是浅复制                | 实现深拷贝必须重写clone方法                 |
| 如果一个对象仅含有基本类型的field，则优先使用浅拷贝 | 如果一个对象含有指向其他对象的field的应用，则优先使用深拷贝 |
| 浅拷贝快而代价小                     | 深拷贝慢而代价高                         |

## 克隆总结

尽管克隆有许多设计缺陷，但仍然是一种流行的拷贝方式。克隆有以下优点：

- 克隆对象所需的编码很少。仅需要在一个父类里定义一个四五行代码的clone方法，当然，如果深拷贝的话就要重写该方法。
- 如果项目中已经实现了克隆机制，那么后续拷贝一个对象时使用克隆就是最简便的方式。
- 拷贝数组时使用克隆是最快的。

克隆的缺点：

- 克隆的实现很烦琐。实现克隆需要实现Clonable接口、重写clone()方法、处理CloneNotSupportedException异常、调用clone()方法，然后强转对象。
- 无法有效控制克隆对象的创建，因为没有调用任何构造器。
- 如果在子类中重写了clone方法，那么其所有父类都要声明一个clone方法，否则，在子类的clone方法中不能调用super.clone()方法。
- 深拷贝实现起来很复杂。实现深拷贝必须递归克隆当前类中所有引用变量。
- 克隆不能处理对象中的final字段（final字段一旦初始化后就无法再被赋值）。如果我们想使每个Person类对象都是根据id（Person类的id字段是final的）唯一的，使用克隆机制就无法这一要求，由于没有调用构造器，克隆对象的id无法通过clone()方法来修改，所以会创建id重复的Person对象。

克隆的确定还真不少，一般建议：

- 对于深拷贝，推荐使用[commons-lang SerializationUtils](http://commons.apache.org/proper/commons-lang/javadocs/api-release/org/apache/commons/lang3/SerializationUtils.html)和[Java Deep Cloning Library](https://github.com/kostaskougios/cloning/) 。
- 对于浅拷贝，推荐使用[commons-beanutils BeanUtils](https://commons.apache.org/proper/commons-beanutils/javadocs/v1.8.3/apidocs/org/apache/commons/beanutils/BeanUtils.html#cloneBean(java.lang.Object))和[Spring BeanUtils](http://static.springsource.org/spring/docs/2.5.6/api/org/springframework/beans/BeanUtils.html) 。

多数时候使用构造器拷贝更方便，比如：

```java
public Person(Person original) {
    this.id = original.id + 1;
    this.name = new String(original.name);
    this.city = new City(original.city);
}
```

拷贝构造器可以克服克隆机制的所有缺点，而且还具有更大的灵活性。