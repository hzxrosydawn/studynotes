---
typora-copy-images-to: appendix
typora-root-url: appendix
---

当程序创建对象、数组等引用类型实体时，系统都会在堆内存中为之分配一块内存区，对象就保存在这块内存区中，当这块内存不再被任何引用变量引用时，这块内存就变成垃圾，等待垃圾回收机制进行回收。垃圾回收机制具有如下特征。

- 垃圾回收机制只负责回收堆内存中的对象，不会回收任何物理资源（例如数据库连接、网络IO等资源）；
- 程序无法精确控制垃圾回收的运行，垃圾回收会在合适的时候进行。当对象永久失去引用后，系统会在合适的时候回收它所占的内存；
- 在垃圾回收机制回收任何对象之前，总会先调用该对象的finalize()方法，该方法可能使该对象重新复活（让一个引用变量重新引用该对象），从而导致垃圾回收机制取消回收。

### 对象在内存中的状态

当一个对象在堆内存中运行时，根据它被引用变量所引用的状态，可以把它所处的状态分成如下三种：

- **可达状态**：当一个对象被创建后，若有一个以上的引用变量引用它，则找个对象在程序中处于可达状态，程序可通过引用变量来调用该对象的实例变量和方法；
- **可恢复状态**：如果程序中某个对象不再有任何引用变量引用它，它就进入了可恢复状态。在这种状态下，系统的垃圾回收机制准备回收该对象所占用的内存，在回收该对象之前，系统会调用所有可恢复状态对象的finalize()方法进行资源清理。如果系统在调用finalize()方法时重新让一个引用变量引用该对象，则这个对象会再次变成可达状态；否则该对象将进入不可达状态；
- **不可达状态**：当对象与所有引用变量的关联都被切断，且系统已经调用所有对象的finalize()方法后依然没有使该对象变成可达状态，那么这个对象将永久性地失去引用，最后变成不可达状态。只有当一个对象处于不可达状态时，系统才会真正回收该对象所占有的资源。

![TIM截图20170618231252](/TIM截图20170618231252-7798814284.jpg)

**一个对象可以被一个方法的局部变量引用，也可以被其他类的类变量引用，或被其他对象的实例变量引用。当某个对象被其他类的类变量引用时，只有该类被销毁后，该对象才会进入可恢复状态；当某个对象被其他对象的实例变量引用时，只有当该对象被销毁后，该对象才会进入可恢复状态**。

### 强制垃圾回收

**当一个对象失去引用后，系统何时调用它的finalize()方法对它进行资源清理，何时它会变成不可达状态，系统何时回收它所占有的内存，对于程序完全透明。程序只能控制一个对象何时不再被任何引用变量引用，绝不能控制它何时被回收。程序无法精确控制Java垃圾回收的时机，但依然可以强制系统进行垃圾回收，但这种强制只是通知系统进行垃圾回收，系统完全有可能并不立即进行垃圾回收，垃圾回收机制也不会对程序的建议完全置之不理：垃圾回收机制不会收到通知后尽快进行垃圾回收**。

**程序强制系统垃圾回收与如下两种方式**：

- **调用System类的gc()静态方法：System.gc()**；
- **调用Runtime对象的gc()实例方法：Runtime.getRuntime().gc()**。

### finalize方法

**在垃圾回收机制回收某个对象所占用的内存之前，通常要求程序调用适当的方法来清理资源，在没有明确清理资源的情况下，Java提供了默认机制来清理该对象的资源，这个机制就是finalize()方法。该方法是定义在Object类里的实例方法**。

```java
protected void finalize() throws Throwable
```

**任何Java类都可以重写Object类的finalize()方法，在该方法中清理该对象占用的资源。如果程序终止之前始终没有进行垃圾回收，则不会调用失去引用对象的finalize()方法来清理资源。垃圾回收机制何时调用对象的finalize()方法是完全透明的，只有当程序需要更多额外的内存时才会进行垃圾回收。完全可能出现这样一种情况：某个失去引用的对象失去了只占用了少量内存，而且系统没有产生严重的内存需求，因此垃圾回收机制并没有试图回收该对象所占用的资源，所以该对象的finalize()方法也不会被调用**。finalize()方法具有如下4个特点：

- **永远不要主动调用某个对象的finalize()方法，该方法应交给垃圾回收机制调用**；
- **finalize()方法何时被调用，是否被调用具有不确定性，不要把finalize()方法当成一定会被执行的方法**；
- **当JVM执行可恢复对象的fianlize()方法时，可能使该对象或系统中其他对象重新进入可达状态**；
- **当JVM执行finalize()方法时出现异常时，垃圾回收机制不会报告异常，程序继续执行**。

```java
public class FinalizeTest 
{
    private static FinalizeTest ft = null;
    public void info()
    {
        System.out.println("测试资源清理的finalize方法");
    }
    public static void main(String[] args) 
    {
        //创建FinalizeTest对象立即进入可恢复状态
        new FinalizeTest();
        //通知系统进行资源回收
        System.gc();
        //强制垃圾回收机制调用可恢复对象的finalize()方法
        Runtime.getRuntime().runFinalization();
        System.runFinalization();
        ft.info();
    }
    public void finalize() 
    {
        //让tf引用到试图回收的可恢复对象，即可恢复对象重新变成可达
        ft = this;
    }
}
```

> 由于finalize()方法并不一定会执行，所以不要在该方法中进行资源的清理。

### 对象的软、弱和虚引用

java.lang.ref包下提供了三个类：SoftReference、WeakReference和PhantomReference。这三个类分别表示系统对对象的三种引用方式：软引用、弱引用和虚引用。Java语言对对象的引用有以下4中方式：

#### 强引用

Java程序中最常见的引用方式。程序创建一个对象，并把这个对象赋给一个引用变量，程序通过该引用变量来操作实际的对象。**当一个对象被一个或一个以上的引用变量所引用时，它处于可达状态，不可能被系统垃圾回收机制回收**。

#### 软引用（SoftReference）

**通过SoftReference类来实现。当一个对象只有软引用时，它有可能被垃圾回收机制回收。当系统内存空间足够时，它不会被系统回收，程序也可使用该对象；当系统内存空间不足时，系统可能会回收它。软引用通常用于对内存敏感的程序中**。

#### 弱引用（WeakReference）

**通过WeakReference类实现。弱引用和软引用很像，但弱引用的引用级别更低。对于只有弱引用的对象而已，当系统垃圾回收机制运行时，不管系统内存是否足够，总会回收该对象所占用的内存。当然，并不是说当一个对象只有弱引用时，它就会立即被回收——正如那些失去引用的对象一样，必须等到系统垃圾回收机制运行时才会被回收**。

#### 虚引用（PhantomReference）

通过PhantomReference类实现。**虚引用完全类似于没有引用。虚引用对对象本身没有太大影响，对象甚至感觉不到虚引用的存在。如果一个对象只有一个虚引用时，那么它和没有引用的效果大致相同。虚引用主要用于跟踪对象被垃圾回收的状态，虚引用不能单独使用，虚引用必须和引用队列(ReferenceQueue)联合使用。程序可以通过检查与虚引用关联的引用队列中是否已经包含了该虚引用，从而了解虚引用所引用的对象被系统垃圾回收过程**。

**上面三个引用类都包含了一个get()方法，用于获取被它们所引用的对象**。

**引用队列由java.lang.ref.ReferenceQueue类表示，它用于保存被回收后对象的引用。当联合使用软引用、弱引用和引用队列时，系统在回收被引用的对象之后，将把被回收对象的引用添加到关联的引用队列中。与软引用和弱引用不同的是，虚引用在对象被释放之前，将把它对应的虚引用添加到它关联的引用队列中，这使得可以在对象被回收之前采取行动**。

```java
public class ReferenceTest {
    public static void main(String[] args) throws Exception {
        // 创建一个字符串对象
        String str = new String("克利夫兰骑士");
        // 创建一个弱引用，让此弱引用引用到到"克利夫兰骑士"字符串
        WeakReference wr = new WeakReference(str);
        // 切断str引用和"克利夫兰骑士"字符串之间的引用
        str = null;
        // 取出弱引用所引用的对象
        System.out.println(wr.get());
        // 强制垃圾回收
        System.gc();
        System.runFinalization();
        // 再次取出弱引用所引用的对象
        System.out.println(wr.get());
    }
}

```

![TIM截图20170618234728](/TIM截图20170618234728.jpg)


上面的代码中调用了`System.gc();`和`System.runFinalization();`通知系统进行垃圾回收，如果系统立即进行垃圾回收，那么就会将弱引用wr所引用的对象回收。将看到输出null。

**采用`String str = "克利夫兰骑士";`代码定义字符串时，系统会使用常量池来管理这个字符串字面量（会使用强引用来引用它），系统不会回收这个字符串直接量**。

```java
import java.lang.ref.PhantomReference;
import java.lang.ref.ReferenceQueue;

public class PhantomReferenceTest {
    public static void main(String[] args) throws Exception {
        // 创建一个字符串对象
        String str = new String("迈阿密热火");
        // 创建一个引用队列
        ReferenceQueue rq = new ReferenceQueue<>();
        // 创建一个虚引用，让此虚引用引用到"迈阿密热火"字符串
        PhantomReference pr = new PhantomReference(str, rq);
        // 切断str引用和"迈阿密热火"字符串之间的引用
        str = null;
        // 取出虚引用所引用的对象，并不能通过虚引用获取被引用的对象，所以此处输出null
        System.out.println(pr.get());
        // 强制垃圾回收
        System.gc();
        System.runFinalization();
        // 垃圾回收之后，虚引用将被放入引用队列中
        // 取出引用队列中最先进入队列的引用于pr进行比较
        System.out.println(rq.poll() == pr);
    }
}
```

**系统无法通过虚引用来获取被引用的对象，即使此时并未强制进行垃圾回收**，所以程序第一次输出为null。**当程序强制垃圾回收后，只有虚引用引用的字符串对象将会被垃圾回收，当被引用的对象被回收后，对应的虚引用将被添加到关联的引用队列中**，因此程序第二次输出为true。

**使用这些引用类可以避免在程序执行期间将对象留在内存中。如果以软引用、弱引用或虚引用的方式引用对象，垃圾回收器就能够随意地释放对象。如果希望尽可能减小程序在其生命周期中所占用的内存大小时，这些引用类就很有作用。要使用这些引用类，就不能保留对对象的强引用。如果保留了对对象的强引用，就会浪费这些引用类所提供的任何好处**。

下面两段代码演示了如果获取可能已经被回收弱引用，其中recreateIt()方法用于生成一个obj对象。

```java
//取出弱引用所引用的对象
obj = wr.get();
//如果取出的对象为null
if (obj == null) {
    //重新创建一个新的对象，再次让弱引用去引用该对象
    wr = new WeakReference(recreateIt());
    //取出弱引用所引用的对象，将其赋给obj变量
    obj = wr.get();
}
...//操作obj对象
//再次切断obj和对象之间的关联
obj = null;
```

```java
//取出弱引用所引用的对象
obj = wr.get();
//如果取出的对象为null
if (obj == null) {
    //重新创建一个新的对象，再次强引用去引用该对象
    obj = recreateIt();
    //取出弱引用所引用的对象，将其赋给obj变量
    wr = new WeakReference(obj);
}
...//操作obj对象
//再次切断obj和对象之间的关联
obj = null;
```

第一段代码存在一定问题：当if块执行完成后，obj还是有可能为null。因为垃圾回收的不确定性，假设系统在if块执行期间进行了垃圾回收，则系统会再次将wr所引用的对象回收，从而导致obj依然为null。第二段代码则不会出现这个问题，当if块执行结束后，obj一定不为null。