---
typora-copy-images-to: ..\..\graphs\photos
typora-root-url: ..\Others
---

###**进程和线程**
**进程（Process）**：**表示每个独立运行的计算机程序**，包含了需要执行的指令；**进程有自己的独立地址空间，有各自的资源和状态信息，不同进程的地址空间是互相隔离的，在没有本进程允许的情况下，一个用户进程不能访问其他进程的地址空间，进程间的切换开销大。多个进程可以在单个处理器上并发轮换（不是并行地同时运行）执行而互不影响**。由于CPU速度极快，用户感觉不到程序是轮换执行的，但如果处理器性能不足时，则会出现卡顿。

**线程（Thread）**：表示**程序的执行流程，是CPU调度执行的基本单位**；**线程是进程的组成部分，一个进程至少有一个线程（即主线程），但线程只有一个父进程；线程有自己的程序计数器、局部变量和堆栈，但不拥有系统资源，而且和父进程中的其他线程共享父进程所拥有的全部资源，包括父进程锁拥有的内存**。

**操作系统可以同时运行多个程序，每个程序至少并发执行一个进程，每个进程至少并发执行一个线程**。

> 并发性(concurrency)与并行性(parallel)
>
> - 并发：在同一时刻，只能有一条指令得到执行，但多个进程指令快速轮换执行，使得在宏观上具有多个进程同时执行的效果。
> - 并行：在同一时刻，有多条指令在多个处理器上同时执行。

###**实现多线程的三种方式**
####**继承Thread类实现多线程**
Java使用Thread类代表线程。继承Thread类实现多线程的步骤如下：

1. **继承Thread类，重写其run()方法来定义该线程的将要执行的任务**；
2. **创建自定义线程类的实例，然后调用线程对象的start()方法启动该线程**。

**start()方法是一个native方法，它将启动一个新线程，并执行run()方法。但Thread类本质上也是实现了Runnable接口的一个实例，它代表一个线程的实例，并且，启动线程的唯一方法就是通过Thread类的start()实例方法**。Thread类的声明如下：

```java
public class Thread extends Object implements Runnable
```

构造器摘要：


- Thread() ：分配新的 Thread 对象。 
- Thread(String name) ：分配新的 Thread 对象。 
- Thread(Runnable target) ：分配新的 Thread 对象。 
- Thread(Runnable target, String name) ：分配新的 Thread 对象。 
- Thread(ThreadGroup group, Runnable target) ：分配新的 Thread 对象。 
- Thread(ThreadGroup group, String name) ：分配新的 Thread 对象。 
- Thread(ThreadGroup group, Runnable target, String name) ：分配新的 Thread 对象，以便将 target 作为其运行对象，将指定的 name 作为其名称，并作为 group 所引用的线程组的一员。 
- Thread(ThreadGroup group, Runnable target, String name, long stackSize) ：分配新的 Thread 对象，以便将 target 作为其运行对象，将指定的 name 作为其名称，作为 group 所引用的线程组的一员，并具有指定的堆栈大小。 

常用方法摘要：

- **void start()** ：使该线程开始执行；Java 虚拟机调用该线程的 run 方法。 
- void run() ： 如果该线程是使用独立的 Runnable 运行对象构造的，则调用该 Runnable 对象的 run 方法；否则，该方法不执行任何操作并返回。 
- void interrupt() ：中断线程。 
- static void yield() ： 暂停当前正在执行的线程对象，并执行其他线程。 
- static boolean interrupted() ：测试当前线程是否已经中断。 
- static boolean holdsLock(Object obj) ：当且仅当当前线程在指定的对象上保持监视器锁时，才返回 true。 
- static int activeCount() ：返回当前线程的线程组中活动线程的数目。 
- void checkAccess() ：判定当前运行的线程是否有权修改该线程。 
- static Thread currentThread() ：返回对当前正在执行的线程对象的引用。 
- void resume() ：已过时。 该方法只与 suspend() 一起使用，但 suspend() 已经遭到反对，因为它具有死锁倾向。有关更多信息，请参阅为何不赞成使用 Thread.stop、Thread.suspend 和 Thread.resume？。 
- long getId() ：返回该线程的标识符。 
- String getName() ：返回该线程的名称。 
- int getPriority() ： 返回线程的优先级。 
- StackTraceElement[] getStackTrace() ：返回一个表示该线程堆栈转储的堆栈跟踪元素数组。 
- Thread.State getState() ：返回该线程的状态。 
  - NEW：尚未启动的线程
  - RUNNABLE：正在JVM中执行的线程
  - BLOCKED：受阻塞的线程 
  - WAITING：无限期地等待另一个线程执行某一特定操作
  - TIMED_WAITING：等待另一个线程执行取决于指定等待时间的操作
  - TERMINATED：已退出的线程
- ThreadGroup getThreadGroup() ：返回该线程所属的线程组。 
- Thread.UncaughtExceptionHandler getUncaughtExceptionHandler() ：返回该线程由于未捕获到异常而突然终止时调用的处理程序。 
- void setName(String name) ： 改变线程名称，使之与参数 name 相同。 
- void setPriority(int newPriority) ：更改线程的优先级。 
- void setContextClassLoader(ClassLoader cl) ：设置该线程的上下文 ClassLoader。 
- void setDaemon(boolean on) ： 将该线程标记为守护线程或用户线程。 
- void setPriority(int newPriority) ：更改线程的优先级。 
- boolean isAlive() ： 测试线程是否处于活动状态。 
- boolean isDaemon() ：测试该线程是否为守护线程。 
- boolean isInterrupted() ：测试线程是否已经中断。 

示例：
```java
//通过继承Thread类来创建线程类
public class FirstThread extends Thread {
	// 重写run方法，run方法的方法体就是线程执行体
	public void run() {
		for (int i = 0; i < 100; i++) {
			// 当线程类继承Thread类时，直接使用this即可获取该线程类的对象
			// Thread对象的getName()返回当前该线程的名字
			// 因此可以直接调用getName()方法返回当前线程的名
			System.out.println(getName() + " " + i);
		}
	}

	public static void main(String[] args) {
		for (int i = 0; i < 100; i++) {
			// 调用Thread的currentThread方法获取当前正在运行的线程对象
			System.out.println(Thread.currentThread().getName() + " " + i);
			// 当i < 20时，只有main线程在运行；
			// 当i >= 20时，可以看到有三个线程并发运行，
          	// 即两条子线程及主线程（Java程序默认的主线程是在调用main()方法时创建的）交替执行
			if (i == 20) {
				// 创建、并启动第一条线程
				new FirstThread().start();
				// 创建、并启动第二条线程
				new FirstThread().start();
			}
		}
	}
}
```
> 注意：**通过继承Thread类创建线程时，多个线程无法共享线程类的实例变量**，可以共享该线程类的类变量。

####**实现Runnable接口方式实现多线程** 
**如果某个类已经继承了其他类，就不能再继承Thread类来创建线程，这种情况下可以通过让该类实现Runnable接口（函数式接口）来创建线程类。实现Runnable接口必须实现其中的run方法，其实Thread类也实现了Runnable接口**。

实现Runnable接口方式实现多线程的步骤：

1. 定义Runnable接口的实现类，并实现其中的run()方法。
2. 创建Runnable实现类的实例，将**该实例作为Thread类构造器的target参数来创建Thread对象，该Thread对象才是真正的线程对象**。
3. 调用Thread对象的start()方法启动线程。

示例： 
```java
// 通过实现Runnable接口来创建线程类
public class SecondThread implements Runnable {
	// run方法同样是线程执行体
	public void run() {
		for (int i = 0; i < 100; i++ ) {
			// 当线程类实现Runnable接口时，
			// 如果想获取当前线程，只能用Thread.currentThread()方法。
			System.out.println(Thread.currentThread().getName() + "  " + i);
		}
	}
  
	public static void main(String[] args) {
		for (int i = 0; i < 100;  i++) {
			System.out.println(Thread.currentThread().getName() + "  " + i);
			if (i == 20) {
				SecondThread st = new SecondThread();
				// 通过new Thread(Runnable target, String name)构造器来创建新线程
				new Thread(st, "新线程1").start();
				new Thread(st, "新线程2").start();
			}
		}
	}
}
```
> 由于Runnable对象只是Thread类的target，多个线程共享一个target，所以多个线程可以共享一个线程类的实例变量。

####**使用ExecutorService、Callable、Future实现有返回结果的多线程** 
**Java 5提供了一个Callable接口（函数式接口），实现该接口的call()方法作为线程执行体，该方法不仅有返回值，而且可以声明抛出异常。同时，Java5提供了一个Future接口来代表Callable接口call()方法的返回值，Future接口有一个实现类FutureTask类，该类同时实现了Runnable接口。所以可以将FutureTask类对象作为call()方法的返回值传入Thread类的target参数来创建线程对象**。Future接口里定义一下几个公共方法来控制它关联的Callable任务：

-  boolean cancel(boolean mayInterruptIfRunning) ：试图取消该Future关联的Callable任务的执行； 
-  V get() ：返回Callable任务里call()方法的返回值。此方法会阻塞，必须等待子线程结束后才能获得返回值。 
-  V get(long timeout, TimeUnit unit) ：同上，只是限制了最多等待时间。如果超时后仍未获得返回值则抛出TimeoutException；
-  boolean isCancelled() ：如果在Callable任务正常完成前被取消，则返回 true；
-  boolean isDone() ：如果Callable任务已完成，则返回 true。一旦返回为ture，则不能返回使用cancel方法了。

**FutureTask类**
`public class FutureTask<V>extends Object implements Runnable Future<V>`：此类提供了对 Future 的基本实现。**仅在计算完成时才能获取结果；如果计算尚未完成，则阻塞 get 方法。一旦计算完成，就不能再重新开始或取消计算。可使用 FutureTask 包装 Callable 或 Runnable 对象。因为 FutureTask 实现了 Runnable接口，所以可将 FutureTask 提交给 Executor 执行**。 

构造方法摘要 ：

- `FutureTask(Callable<V> callable)` ：创建一个 FutureTask，一旦运行就执行给定的 Callable。 
- `FutureTask(Runnable runnable, V result)` ：创建一个 FutureTask，一旦运行就执行给定的 Runnable，并安排成功完成时 get 返回给定的结果 。 

除了作为一个独立的类外，此类还提供了 protected 功能，这在创建自定义任务类时可能很有用：

- `boolean runAndReset()` ： 执行计算而不设置其结果，然后将此 Future 重置为初始状态，如果计算遇到异常或已取消，则该操作失败。 
- `protected  void set(V v)` ：除非已经设置了此 Future 或已将其取消，否则将其结果设置为给定的值。 
- `protected  void setException(Throwable t)` ： 除非已经设置了此 Future 或已将其取消，否则它将报告一个 ExecutionException，并将给定的 throwable 作为其原因。 

使用这种方法实现多线程的步骤：

1. 创建Callable接口实现类，实现call()方法；
2. 使用FutureTask类包装Callable对象，该FutureTask对象封装了Callable对象的call()方法的返回值；
3. 将该FutureTask对象作为Thread对象的target创建并启动新线程；
4. 调用FutureTask对象的get方法获取子线程执行结束后的返回值。

示例：
```java
public class ThirdThread {
	public static void main(String[] args) {
		// 创建Callable对象
		ThirdThread rt = new ThirdThread();
		// 先使用Lambda表达式创建Callable&lt;Integer>对象
		// 使用FutureTask来包装Callable对象
		FutureTask<Integer> task = new FutureTask<Integer>((Callable<Integer>)() -> {
			int i = 0;
			for ( ; i < 100; i++) {
				System.out.println(Thread.currentThread().getName() + " 的循环变量i的值：" + i);
			}
			// call()方法可以有返回值
			return i;
		});
   
		for (int i = 0; i < 100; i++) {
			System.out.println(Thread.currentThread().getName() + " 的循环变量i的值：" + i);
			if (i == 20) {
				// 实质还是以Callable对象来创建、并启动线程
				new Thread(task , "有返回值的线程").start();
			}
		}
      
		try {
			// 获取线程返回值
			System.out.println("子线程的返回值：" + task.get());
		} catch (Exception ex) {
			ex.printStackTrace();
		}
	}
}
```
####**三种实现多线程方式的对比** 
实现Runnable、Callable接口的方式：

- **优点是可以在实现接口后还可以继承其他类，多线程共享同一个target，所以适合多线程处理同一个资源的情况**；
- **缺点是编程稍微复杂，如果需要访问当前类则必须使用Thread.currentThread()方法**。

使用继承Thread类的方式：

- **优点是编程简单，访问当前线程时使用this即可**；
- **缺点是不能再继承其他类**。

### 线程的生命周期

当线程被创建并启动以后，在其整个生命周期中，它要经过新建(New)、就绪（Runnable）、运行（Running）、阻塞(Blocked)和死亡(Terminated)5种状态。

#### 新建和就绪状态

当程序**使用new关键字创建了一个线程之后，该线程就处于新建状态，此时它和其他的Java对象一样，仅仅由Java虚拟机为其分配内存，并初始化其成员变量的值**。此时的线程对象没有表现出任何线程的动态特征，程序也不会执行线程的线程执行体。

当线程对象**调用了start()方法之后，该线程处于就绪状态。Java虚拟机会为其创建方法调用栈和程序计数器，处于这个状态中的线程并没有开始运行，只是表示该线程可以运行了。至于该线程何时开始运行，取决于JVM里线程调度器的调度**。

**启动线程使用start()方法，而不是run()方法。永远不要调用线程对象的run()方法**。调用start()方法来启动线程，系统会把该run()方法当成线程执行体来处理；但如果直按调用线程对象的run()方法，则run()方法立即就会被执行，而且在run()方法返回之前其他线程无法并发执行。也就是说，**系统会把直接调用run方法的线程对象当成一个普通对象，而run()方法也是一个普通方法，而不是线程执行体**。

```java
public class ThreadRunTest extends Thread {
	// 重写run方法，run方法的方法体就是线程执行体
	public void run() {
		for (int i = 0; i < 4; i++) {
			// 直接调用run方法时，Thread的this.getName返回的是该对象名字，
			// 而不是当前线程的名字。
			// 使用Thread.currentThread().getName()总是获取当前线程名字
			System.out.println(Thread.currentThread().getName() + " " + i);
		}
	}

	public static void main(String[] args) {
		for (int i = 0; i < 10; i++) {
			// 调用Thread的currentThread方法获取当前线程
			System.out.println(Thread.currentThread().getName() + " " + i);
			if (i == 5) {
				// 直接调用线程对象的run方法，
				// 系统会把线程对象当成普通对象，run方法当成普通方法，
				// 所以下面两行代码不会并发执行两条线程，而是依次执行两个run方法
				new ThreadRunTest().run();
				new ThreadRunTest().run();
			}
		}
	}
}
```

运行结果如下：

```powershell
main 0
main 1
main 2
main 3
main 4
main 5
main 0
main 1
main 2
main 3
main 0
main 1
main 2
main 3
main 6
main 7
main 8
main 9
```

上面程序运行结果表明整个程序只有一个**名为main的主线程（在JVM启动时，进入某个类的main方法而创建的线程）**。**如果直接调用线程对象的run()方法，则run()方法里不能直接通过getName()方法来获得当前执行线程的名字，而是需要Thread.currentThread()方法先获得当前线程，再调用线程对象的getName()方法来获得线程名字**。

**只能对处于新建状态的线程调用start()方法，否则将引发IllegaIThreadStateExccption异常**

**调用线程对象的start()方法之后，该线程立即进入就绪状态——就绪状态相当于"等待执行"，但该线程并未真正进入运行状态。如果希望调用子线程的start()方法后子线程立即开始执行，程序可以使用Thread.slepp(1)来让当前运行的线程睡眠1毫秒，因为在这1毫秒内CPU不会空闲，它会去执行另一个处于就绪状态的线程**，这样就可以让子线程立即开始执行。

#### 运行和阻塞状态

当发生如下情况时，一个线程将会进入阻塞状态：

- 该线程**调用sleep()方法主动放弃所占用的处理器资源**；
- 该线程**调用了一个阻塞式IO方法，在该方法结束之前，该线程被阻塞**；
- 该线程**试图获得一个同步监视器，但该同步监视器正被其他线程所持有**；
- 该线程**在等待某个通知（notify）**；
- 程序**调用了线程的suspend()方法将该线程挂起。但这个方法容易导致死锁，所以应该尽量避免使用该方法**。

**当前正在执行的线程被阻塞之后，其他线程就可以获得执行的机会。被阻塞的线程会在合适的时候重新进入就绪状态，注意是就绪状态而不是运行状态。也就是说，被阻塞线程的阻塞解除后，必须重新等待线程调度器再次调度它**。

当发生如下特定情况时可以解除上述阻塞，该让线程重新进入就绪状态：

- 调用sleep()方法的线程经过了该方法指定的时间；
- 线程调用的阻塞式IO方法已经返回；
- 线程成功地获得了试图取得的同步监视器；
- 线程正在等待某个通知时，其他线程发出了这个通知；
- **处于挂起状态的线程被调用了resume()恢复方法**。

线程状态转换图：

![threadstates](../../graphs/photos/threadstates.jpg)

**线程从阻塞状态只能进入就绪状态，无法直接进入运行状态。而就绪和运行状态之间的转换通常不受程序控制，而是由系统线程调度所决定。当处于就绪状态的线程获得处理器资源时，该线程进入运行状态；当处于运行状态的线程失去处理器资源时，该线程进入就绪状态。但有一个方法例外，调用yield()方法可以让运行状态的线程转入就绪状态**。

#### 线程死亡

线程会以如下3种方式结束，结束后就处于死亡状态：

- **run()或call()方法执行完成，线程正常结束**。
- 线程抛出一个未捕获的Exception或Error。
- **直接调用该线程stop()方法来结束该线程——该方法容易导致死锁，通常不推荐使用**。

> 当主线程结束时，其他线程不受任何影响，并不会随之结束。一旦子线程启动后，它就拥有和主线程相同的地位，它不会受主线程的影响。

**为了测试某个线程是否已经死亡，可以调用线程对象的isAlive()方法**，当**线程处于就绪、运行、阻塞三种状态时，该方法将返回true**；当**线程处于新建、死亡状态时，该方法将返回false**。

**不要试图对一个已经死亡的线程调用start()方法使它重新启动，死亡就是死亡，该线程将不可再次作为线程执行**。如下程序尝试对处于死亡状态的线程再次调用start()方法，将引发IllegaIThreadStateException异常，这表明处于死亡状态的线程无法再次运行了。

```java
public class StartDeadTest extends Thread {
	public StartDeadTest(String name) {
		super(name);
	}

	// 重写run方法，run方法的方法体就是线程执行体
	public void run() {
		for (int i = 0; i < 3; i++) {
			System.out.println(getName() + " " + i);
		}
	}

	public static void main(String[] args) {
		// 创建线程对象
		StartDeadTest sd = new StartDeadTest("测试线程");
		for (int i = 0; i < 100; i++) {
			if (i == 5) {
				// 启动线程
				sd.start();
			}
			// 调用Thread的currentThread方法获取当前线程，并判断其是否为alive
			System.out.println(Thread.currentThread().getName() + " " + i + "，sd is alive?" + sd.isAlive());
			// 只有当线程处于新建、死亡两种状态时isAlive()方法返回false。
			// 当i > 5，则该线程肯定已经启动过了，如果sd.isAlive()为true时，则正常执行，
			// 但如果sd.isAlive()为false时，那只能是死亡状态了，
			// 再次调用该线程对象的start()方法将会抛出异常
			if (i > 5 && !sd.isAlive()) {
				// 试图再次启动该线程
				sd.start();
			}
		}
	}
}
```

输出结果如下：

```powershell
main 0，sd is alive?false
main 1，sd is alive?false
main 2，sd is alive?false
main 3，sd is alive?false
main 4，sd is alive?false
main 5，sd is alive?true
main 6，sd is alive?true
main 7，sd is alive?true
main 8，sd is alive?true
main 9，sd is alive?true
测试线程 0
main 10，sd is alive?true
测试线程 1
main 11，sd is alive?true
测试线程 2
main 12，sd is alive?true
Exception in thread "main" java.lang.IllegalThreadStateException
	at java.lang.Thread.start(Thread.java:705)
	at threadtest.StartDeadTest.main(StartDeadTest.java:37)
```

上面的结果表明，当main方法中执行到第5次循环（我们手动指定的）时，独立于主线程的测试线程对象sd进入就绪状态，当main方法中执行完第9次循环时（不同的电脑、或同一个台电脑的多次测试结果中该循环次数可能不一样，因为操作系统的线程调度时刻在变化），sd对象进入运行状态，当main方法中执行完第12次循环时（这个循环次数与前面第9次类似，也不是固定的），sd已经执行完毕，这时sd线程对象已经处于死亡状态了，再次调用其start()方法将会抛出java.lang.IllegalThreadStateException异常。

###控制线程

####等待线程结束
如果主线程处理完其他的事务后，需要用到子线程的处理结果，也就是主线程需要等待子线程执行完成之后再结束，这个时候就要用到join方法了。**在当前线程中调用其他线程的join()方法后会暂停当前线程的执行，在调用join()方法的线程执行结束之前，其他线程处于阻塞状态，该线程执行结束之后，其他线程才能执行**。

join方法有如下三种重载形式：

- void join() ：等待该线程终止。 
- void join(long millis) ：等待该线程终止的时间最长为 millis 毫秒。 
- void join(long millis, int nanos) ：等待该线程终止的时间最长为 millis 毫秒 + nanos 纳秒。 

**一般很少使用第三种方法，因为计算机硬件和操作系统达不到纳秒的精度**。

> **join方法通常由使用线程的程序调用，以将大问题划分成许多小问题，每个小问题分配一个线程。当所有的小问题都得到处理后，在调用主线程来进一步操作**。


 示例：
```java
public class JonidThreadTest extends Thread {
	// 提供一个有参数的构造器，用于设置该线程的名字
	public JonidThreadTest(String name) {
		super(name);
	}

	// 重写run()方法，定义线程执行体
	public void run() {
		for (int i = 0; i < 10; i++) {
			System.out.println(getName() + "  " + i);
		}
	}

	public static void main(String[] args) throws Exception {
		for (int i = 0; i < 10; i++) {
			if (i == 5) {
				JonidThreadTest joinThread = new JonidThreadTest("调用join方法的线程");
				joinThread.start();
				// main线程调用了joinThread线程的join()方法，main线程
				// 必须等joinThread执行结束才会向下执行
				joinThread.join();
			}
			System.out.println(Thread.currentThread().getName() + "  " + i);
		}
	}
}
```
运行结果如下：

```powershell
main  0
main  1
main  2
main  3
main  4
调用join方法的线程  0
调用join方法的线程  1
调用join方法的线程  2
调用join方法的线程  3
调用join方法的线程  4
调用join方法的线程  5
调用join方法的线程  6
调用join方法的线程  7
调用join方法的线程  8
调用join方法的线程  9
main  5
main  6
main  7
main  8
main  9
```

####守护线程

**守护线程（Daemon 线程），又称后台线程、精灵线程，在后台运行，为其他线程提供服务。典型的守护线程如垃圾回收线程。Thread类提供了一个setDaemon(true)方法可以将一个线程设置为守护线程，也提供了一个isDaemon()方法来判断当前线程是否为守护线程**。

守护线程特点如下：

 - **所有前台线程死亡之后，JVM会通知所有守护线程自动死亡，但这需要经过一段时间**。
 - **主线程默认是前台线程。但并不是所有的线程默认是前台线程，前台线程创建的线程默认为前台线程，守护线程创建的线程默认为守护线程**。
 - **如需将一个线程设置为守护线程，必须在该线程启动之前设置，即在start()方法之前调用setDaemon(true)方法，否则抛出IllegalThreadStateException异常**。

示例：
```java
public class DeamonThreadTest extends Thread {
	public DeamonThreadTest(String name) {
		super(name);
	}

	// 定义后台线程的线程执行体与普通线程没有任何区别
	public void run() {
		for (int i = 0; i < 1000; i++) {
			System.out.println(getName() + "  " + i);
		}
	}

	public static void main(String[] args) {
		DeamonThreadTest t = new DeamonThreadTest("守护线程");
		// 将此线程设置成后台线程
		t.setDaemon(true);
		// 启动后台线程
		t.start();
		for (int i = 0; i < 10; i++) {
			System.out.println(Thread.currentThread().getName() + "  " + i);
		}
		// -----程序执行到此处，前台线程（main线程）结束------
		// 后台线程也会该随之结束
	}
}
```
####线程睡眠

**Thread类的sleep静态方法用于让当前正在执行的线程暂停一段时间，并进入阻塞状态，即使系统中没有其他线程在执行，这个被暂停的线程在这段时间内也不会被执行**。

sleep方法有两种重载形式：

- static void sleep(long millis) ：在指定的毫秒数内让当前正在执行的线程休眠（暂停执行），**此操作受到系统计时器和调度程序精度和准确性的影响**。 
- static void sleep(long millis, int nanos) ：在指定的毫秒数加指定的纳秒数内让当前正在执行的线程休眠（暂停执行），此操作受到系统计时器和调度程序精度和准确性的影响。一般因为纳秒精度达不到而很少使用。

示例：
```java
public class SleepTest {
	public static void main(String[] args) throws Exception {
		for (int i = 0; i < 10; i++) {
			System.out.println("当前时间: " + new Date());
			// 调用sleep方法让当前线程暂停1s
			Thread.sleep(1000L);
		}
	}
}
```
#### 线程让步

**yield()静态方法与sleep静态方法类似，也是让当前线程暂停，只是不会阻塞该线程，而是强制该线程进入就绪状态，让线程调度器重新调度一次，重新调度之后，优先级较高或相同且处于就绪状态的线程将执行，如果没有这样的线程处于就绪状态，那么该线程会被重新调度执行**。使用yield()方法注意以下几点：

- **yield()方法不抛出任何异常，而sleep方法抛出InterruptedException异常**。
- **sleep方法的可移植性较好，一般并不推荐使用yield方法控制并发线程的执行**。
- **在多核CPU并行的环境下，yield()方法的执行效果可能会失效，尤其是对高优先级的线程，即调用该方法的线程不一定会重新执行**。

示例：
```java
public class YieldThreadTest extends Thread {
	public YieldThreadTest(String name) {
		super(name);
	}

	// 定义run方法作为线程执行体
	public void run() {
		for (int i = 0; i < 50; i++) {
			System.out.println(getName() + "  " + i);
			// 当i等于20时，使用yield方法让当前线程让步
			if (i == 20) {
				Thread.yield();
			}
		}
	}

	public static void main(String[] args) throws Exception {
		// 启动两条并发线程
		YieldThreadTest yt1 = new YieldThreadTest("高优先级线程");
		// 将ty1线程设置成最高优先级
		// yt1.setPriority(Thread.MAX_PRIORITY);
		yt1.start();
		YieldThreadTest yt2 = new YieldThreadTest("低优先级线程");
		// 将yt2线程设置成最低优先级
		// yt2.setPriority(Thread.MIN_PRIORITY);
		yt2.start();
	}
}
```
上面的运行结果为两个线程并发地各执行一次，如果将设置优先级的两行代码的注释去掉，我们可能会看到低优先级的线程会让高优先级的线程先执行，然后自己再重新执行，而高优先级的线程不一定会重新执行。

####线程的优先级

**每个线程都有一个优先级，高优先级线程的执行优先于低优先级线程。新创建线程的优先级与创建它的线程的优先级相同**。类似于强制垃圾回收，**这里只是建议优先执行高优先级的线程，但这种优先执行不是绝对的，取决于具体底层策略**。

Thread类提供了setPriority(int newPriority) 方法和getPriority()方法来设置和获得线程的优先级，其中setPriority(int newPriority) 方法的参数可以为1~10的整数。Thread类提供了以下三个静态常量表示线程的优先级：

- static int **MAX_PRIORITY**：其值为10，代表最高优先级。
- static int **NORM_PRIORITY**：其值为5，代表默认默认优先级。
- static int **MIN_PRIORITY**：其值为1，代表最低优先级。

**虽然Java提供了10个优先级，但是不同操作系统支持不同，有的操作系统提供的优先级没有10个，为了移植性考虑，应该考虑使用静态常量名称MAX\_PRIORITY、MIN\_PRIORITY、NORM_PRIORITY来代表优先级，而不是直接指定优先级别的数值**。

示例：
```java
public class PriorityThreadTest extends Thread {
	// 定义一个有参数的构造器，用于创建线程时指定name
	public PriorityThreadTest(String name) {
		super(name);
	}

	public void run() {
		for (int i = 0; i < 50; i++) {
			System.out.println(getName() + "，其优先级是：" + getPriority() + "，循环变量的值为:" + i);
		}
	}

	public static void main(String[] args) {
		// 改变主线程的优先级
		Thread.currentThread().setPriority(6);
		for (int i = 0; i < 30; i++) {
			if (i == 10) {
				PriorityThreadTest low = new PriorityThreadTest("低级线程");
				low.start();
				System.out.println("低级线程，创建之初的优先级:" + low.getPriority());
				// 设置该线程为最低优先级
				low.setPriority(Thread.MIN_PRIORITY);
			}
			if (i == 20) {
				PriorityThreadTest high = new PriorityThreadTest("高级线程");
				high.start();
				System.out.println("高级线程，创建之初的优先级:" + high.getPriority());
				// 设置该线程为最高优先级
				high.setPriority(Thread.MAX_PRIORITY);
			}
		}
	}
}
```
从上面的运行结果可以看出，新建线程的初始优先级都相等，当分别为其设置了优先级之后，高优先级的线程会比低优先级的线程优先执行。这里的**“优先执行”不是绝对的先后执行，而是更偏向于先执行高优先级线程。所以，也会存在低优先级线程比高优先级线程先执行的某一时刻**，但总体来说，还是高优先级优先执行完毕。

###线程同步

####线程同步问题
 当使用**多个线程并发访问同一个数据时**，很可能出现线程安全问题。关于多线程并发有一个经典的银行取钱问题：

    1. 用户输入帐号和密码，核对用户帐号密码是否匹配。
    2. 用户输入取款金额。
    3. 系统判断余额是否大于取款金额。
    4. 如果余额大于取款金额，则取款成功，否则，取款失败。

 代码实现如下：
```java
public class Account {
	// 封装账户编号、账户余额的两个成员变量
	private String accountNo;
	private double balance;
	public Account(){}
	// 构造器
	public Account(String accountNo , double balance) {
		this.accountNo = accountNo;
		this.balance = balance;
	}
	// accountNo的setter和getter方法
	public void setAccountNo(String accountNo) {
		this.accountNo = accountNo;
	}
	public String getAccountNo() {
		return this.accountNo;
	}
	// balance的setter和getter方法
	public void setBalance(double balance) {
		this.balance = balance;
	}
	public double getBalance() {
		return this.balance;
	}

	// 下面两个方法根据accountNo来重写hashCode()和equals()方法
	public int hashCode() {
		return accountNo.hashCode();
	}
	public boolean equals(Object obj) {
		if(this == obj)
			return true;
		if (obj !=null && obj.getClass() == Account.class) {
			Account target = (Account)obj;
			return target.getAccountNo().equals(accountNo);
		}
		return false;
	}
}
```
```java
public class DrawThread extends Thread {
	// 模拟用户账户
	private Account account;
	// 当前取钱线程所希望取的钱数
	private double drawAmount;
	public DrawThread(String name , Account account, double drawAmount){
		super(name);
		this.account = account;
		this.drawAmount = drawAmount;
	}
	// 当多条线程修改同一个共享数据时，将涉及数据安全问题。
	public void run() {
		// 账户余额大于取钱数目
		if (account.getBalance() >= drawAmount) {
			// 吐出钞票
			System.out.println(getName() + "取钱成功！吐出钞票:" + drawAmount);
			try {
				Thread.sleep(1);
			} catch (InterruptedException ex) {
				ex.printStackTrace();
			}
			// 修改余额
			account.setBalance(account.getBalance() - drawAmount);
			System.out.println("\t余额为: " + account.getBalance());
		} else {
			System.out.println(getName() + "取钱失败！余额不足！");
		}
	}
}
```
```java
public class DrawTest {
	public static void main(String[] args) {
		// 创建一个账户
		Account acct = new Account("1234567" , 1000);
		// 模拟两个线程对同一个账户取钱
		new DrawThread("甲" , acct , 800).start();
		new DrawThread("乙" , acct , 800).start();
	}
}
```
运行结果可能如下：

```powershell
乙取钱成功！吐出钞票:800.0
甲取钱成功！吐出钞票:800.0
	余额为: 200.0
	余额为: -600.0
```

run()方法不具有同步安全性。由于run()方法中的取钱是耗时操作，还未完成取钱时，如果线程切换后另一个进程也对balance进行操作（可能前一个线程减去取款金额后，还没有获得余额时，另一个线程又再次减去了取款金额，那么前面的线程获得的余额就是多减去了后一个线程的取款金额后的结果），将会输出错误结果。当然也可能出现当前线程完成了取钱操作，另一个线程才对balance进行操作而输出正确结果。

####同步代码块
 Java多线程引入了同步监视器来解决这种同步问题。**通常使用同步代码块来作为同步监视器**。同步代码块语法：
```java
synchronized(obj) {
	...
	//可能出现同步问题的操作
}
```
括号中的obj就是同步监视器，**虽然可以指定任何对象作为同步监视器，但是通常推荐使用可能被并发访问的共享资源作为同步监视器**，如上面例子中的account对象。

使用同步代码块对上面的例子进行修改后即可输出正常的结果：
```java
public class Account {
	// 封装账户编号、账户余额的两个成员变量
	private String accountNo;
	private double balance;
	public Account() {}
	// 构造器
	public Account(String accountNo , double balance) {
		this.accountNo = accountNo;
		this.balance = balance;
	}
	// 此处省略了accountNo和balance的setter和getter方法

	// accountNo的setter和getter方法
	public void setAccountNo(String accountNo) {
		this.accountNo = accountNo;
	}
	public String getAccountNo() {
		return this.accountNo;
	}

	// balance的setter和getter方法
	public void setBalance(double balance) {
		this.balance = balance;
	}
	public double getBalance() {
		return this.balance;
	}

	// 下面两个方法根据accountNo来重写hashCode()和equals()方法
	public int hashCode() {
		return accountNo.hashCode();
	}
	public boolean equals(Object obj) {
		if(this == obj)
			return true;
		if (obj !=null && obj.getClass() == Account.class) {
			Account target = (Account)obj;
			return target.getAccountNo().equals(accountNo);
		}
		return false;
	}
}
```
```java
public class DrawThread extends Thread {
	// 模拟用户账户
	private Account account;
	// 当前取钱线程所希望取的钱数
	private double drawAmount;
	public DrawThread(String name , Account account, double drawAmount) {
		super(name);
		this.account = account;
		this.drawAmount = drawAmount;
	}
	// 当多条线程修改同一个共享数据时，将涉及数据安全问题
	public void run() {
		// 使用account作为同步监视器，任何线程进入下面同步代码块之前，
		// 必须先获得对account账户的锁定——其他线程无法获得锁，也就无法修改它
		// 这种做法符合：“加锁 → 修改 → 释放锁”的逻辑
		synchronized (account) {
			// 账户余额大于取钱数目
			if (account.getBalance() >= drawAmount) {
				// 吐出钞票
				System.out.println(getName() + "取钱成功！吐出钞票:" + drawAmount);
				try {
					Thread.sleep(1);
				} catch (InterruptedException ex) {
					ex.printStackTrace();
				}
				// 修改余额
				account.setBalance(account.getBalance() - drawAmount);
				System.out.println("\t余额为: " + account.getBalance());
			} else {
				System.out.println(getName() + "取钱失败！余额不足！");
			}
		}
		// 同步代码块结束，该线程释放同步锁
	}
}
```
```java
public class DrawTest {
	public static void main(String[] args) {
		// 创建一个账户
		Account acct = new Account("1234567" , 1000);
		// 模拟两个线程对同一个账户取钱
		new DrawThread("甲" , acct , 800).start();
		new DrawThread("乙" , acct , 800).start();
	}
}
```
####**同步方法**
Java还提供了同步方法的支持。使用synchronized关键字修饰的方法即为同步方法。**对于同步的实例方法，同步监视器即是this，也就是调用该方法的对象，无须显式指定。不可变类因为不可变，所以是线程安全的，而可变类就需要手动处理可能出现的并发问题。使用同步方法完成可能出现并发问题的操作可以保证该方法的持有类是一个线程安全类**。

下面将Account类修改成线程安全类：

```java
public class Account {
	// 封装账户编号、账户余额两个成员变量
	private String accountNo;
	private double balance;
	public Account(){}
	// 构造器
	public Account(String accountNo , double balance) {
		this.accountNo = accountNo;
		this.balance = balance;
	}

	// accountNo的setter和getter方法
	public void setAccountNo(String accountNo) {
		this.accountNo = accountNo;
	}
	public String getAccountNo() {
		return this.accountNo;
	}
	// 因此账户余额不允许随便修改，所以只为balance提供getter方法，
	public double getBalance() {
		return this.balance;
	}

	// 提供一个线程安全draw()同步方法来完成取钱操作
	public synchronized void draw(double drawAmount) {
		// 账户余额大于取钱数目
		if (balance >= drawAmount) {
			// 吐出钞票
			System.out.println(Thread.currentThread().getName() + "取钱成功！吐出钞票:" + drawAmount);
			try {
				Thread.sleep(1);
			} catch (InterruptedException ex) {
				ex.printStackTrace();
			}
			// 修改余额
			balance -= drawAmount;
			System.out.println("\t余额为: " + balance);
		} else {
			System.out.println(Thread.currentThread().getName()
				+ "取钱失败！余额不足！");
		}
	}

	// 下面两个方法根据accountNo来重写hashCode()和equals()方法
	public int hashCode() {
		return accountNo.hashCode();
	}
  
	public boolean equals(Object obj) {
		if(this == obj)
			return true;
		if (obj !=null && obj.getClass() == Account.class) {
			Account target = (Account)obj;
			return target.getAccountNo().equals(accountNo);
		}
		return false;
	}
}
```
```java
public class DrawThread extends Thread {
	// 模拟用户账户
	private Account account;
	// 当前取钱线程所希望取的钱数
	private double drawAmount;
	public DrawThread(String name , Account account, double drawAmount) {
		super(name);
		this.account = account;
		this.drawAmount = drawAmount;
	}
	// 当多条线程修改同一个共享数据时，将涉及数据安全问题
	public void run() {
		// 直接调用account对象的draw方法来执行取钱
		// 同步方法的同步监视器是this，this代表调用draw()方法的对象
		// 也就是说：线程进入draw()方法之前，必须先对account对象的加锁
		account.draw(drawAmount);
	}
}
```
```java
public class DrawTest {
	public static void main(String[] args) {
		// 创建一个账户
		Account acct = new Account("1234567" , 1000);
		// 模拟两个线程对同一个账户取钱
		new DrawThread("甲" , acct , 800).start();
		new DrawThread("乙" , acct , 800).start();
	}
}
```
上面的Account类提供了draw()方法，取消了setBalance()方法，通过run()方法来调用draw()方法，而不是在run()方法里直接定义取钱操作更符合面向对象设计规则中的Domain Driven Design（领域驱动设计，DDD），这种方式认为**每个类都应该是完备的领域对象**。 

> 注意：**synchronized关键字可以修改代码块和方法，但是不能修饰构造器和成员变量**。

**可变类的线程安全是以牺牲性能为代价的，为了减少线程安全所带来的负面影响**，通常建议：

 - 不要对线程安全类的所有方法进行同步，**仅对那些可能改变共享资源的操作进行方法同步**。
 - **如果可变类有两种运行环境：单线程和多线程，应该为该类提供线程安全和线程不安全两种版本，分别用于单线程环境下用于保证性能和多线程环境下保证安全，如线程不安全的StringBuilder在单线程情况下效率高，效率不高的StringBuffer在多线程操作时是安全的**。

####同步监视器锁定的释放
线程在以下几种情况下**释放对同步监视器的锁定**：

 - 当前线程的同步方法、同步代码块**执行结束**后即释放同步监视器。
 - 当前线程的同步方法、同步代码块**遇到了return、break**终止了该同步方法、同步代码块的执行后立即释放同步监视器。
 - 当前线程的同步方法、同步代码块中**出现了未处理的Error或Exception**，导致该方法、代码块异常结束时立即释放同步监视器。
 - 当前线程的同步方法、同步代码块执行时，程序**执行了同步监视器的wait()方法**后，当前线程暂停并释放同步监视器。

在**以下情况下线程不会释放同步监视器的锁定**：

 - 当前线程的同步方法、同步代码块执行时程序**调用了Thread.sleep()方法、Thread.yield()方法来暂停当前线程的执行**，当前线程不会释放同步监视器的锁定。
 - 当前线程的同步代码块执行时，**其他线程调用了该线程的suspen()方法（易导致死锁）将该线程挂起**，该线程不会释放同步监视器。当然，**应该尽量避免使用suspend()和resume()方法来控制线程**。

####同步锁
synchronized 方法和代码块提供的内部锁机制使得使用监视器锁编程方便了很多，而且还避免了很多涉及到锁的常见编程错误。**这种内部锁机制提供了对每个对象相关的隐式监视器锁的访问，但却强制所有锁的获取和释放均要出现在同一个块结构中：当获取了多个锁时，它们必须以相反的顺序释放（First Lock Last Unlock），且必须在与所有锁被获取时相同的范围内释放所有锁。而且synchronized提供的内部锁机制不能中断那些正在等待获取锁的线程，并且在请求锁失败的情况下必须无限等待**。有时需要更灵活地使用锁。例如，某些遍历并发访问的数据结果的算法要求使用 "hand-over-hand" 或 "chain locking"：获取节点 A 的锁，然后再获取节点 B 的锁，然后释放 A 并获取 C，然后释放 B 并获取 D，依此类推。Lock 接口的实现允许锁在不同的作用范围内获取和释放，并允许以任何顺序获取和释放多个锁。

**从Java5开始提供了一种更加灵活的同步机制——同步锁，锁由java.util.concurrent.locks包下的Lock接口对象充当。通常，锁提供了对共享资源的独占访问。一次只能有一个线程获得锁，对共享资源的所有访问都需要首先获得Lock接口对象**。 

Java5提供的同步锁支持如下图所示：
![diagram_lock](../../graphs/photos/diagram_lock.png)

某些锁可能允许对共享资源并发访问，如ReadWriteLock(读写锁)。Lock、ReadWriteLock是Java5提供的两个根接口，并为Lock提供了ReentrantLock（可重入锁）实现类，为ReadWriteLock提供了ReentrantReadWriteLock实现类。

Java8之后新增了新型的StampedLock。它在大多数场景中可以替代传统的ReentrantReadWriteLock。为读写操作提供三种锁模式：Writing、ReadingOptimistic、Reading。

**Lock接口**

Lock接口提供的同步锁比内部锁更加灵活、性能更好，其方法摘要：

- void lock() ：获取锁。如果锁不可用，比如会导致死锁的调用，出于线程调度目的，将禁用当前线程，并且在获得锁之前，该线程将一直处于休眠状态。 
- void unlock() ：释放锁。 
- boolean tryLock() ：仅在锁为空闲状态时才获取该锁。如果锁可用，则获取锁，并立即返回值 true。如果锁不可用，则此方法将立即返回值 false。
- boolean tryLock(long time, TimeUnit unit) ：同上。如果锁在给定的等待时间内空闲，并且当前线程未被中断，则获取锁。 
- void lockInterruptibly() ：如果当前线程未被中断，则获取锁。 
- Condition newCondition() ：返回绑定到此 Lock 实例的新 Condition 实例。 

**ReentrantLock类**

ReentrantLock类实现了Lock接口，**代表具有重入性的锁，也就是线程可以对已经加锁的ReentrantLock锁再次加锁，ReentrantLock会维持一个计数器来跟踪Lock方法的嵌套调用，线程在每次lock()加锁后，必须显式调用unLock()来释放锁，所以一段被锁保护的代码可以调用另一个被相同锁保护的方法**。

构造方法摘要：

- ReentrantLock() ：创建一个 ReentrantLock 的实例。
- ReentrantLock(boolean fair) ：创建一个具有给定公平策略的 ReentrantLock。fair为true时使用更加公平的加锁机制，在锁被释放后，会优先给等待时间最长的线程，避免一些线程长期无法获得锁。

此类的构造器接受一个可选的构造参数。**当设置为 true 时表示使用公平锁，在多个线程的争用下，这些公平锁锁倾向于将访问权授予等待时间最长的线程。否则此锁将无法保证任何特定访问顺序。与采用默认设置（使用不公平锁）相比，使用公平锁的程序在许多线程访问时表现为很低的总体吞吐量（即速度很慢，常常极其慢），但是在获得锁和保证锁分配的均衡性时差异较小。不过要注意的是，公平锁不能保证线程调度的公平性。因此，使用公平锁的众多线程中的一员可能获得多倍的成功机会，这种情况发生在其他活动线程没有被处理并且目前并未持有锁时。还要注意的是，未定时的 tryLock 方法并没有使用公平设置。因为即使其他线程正在等待，只要该锁是可用的，此方法就可以获得成功**。 

独有方法摘要： 

- int getHoldCount() ： 查询当前线程保持此锁的次数。
- protected  Thread getOwner() ：返回目前拥有此锁的线程，如果此锁不被任何线程拥有，则返回 null。
- protected  Collection&lt;Thread> getQueuedThreads() ：返回一个 collection，它包含可能正等待获取此锁的线程。
- int getQueueLength() ：返回正等待获取此锁的线程估计。
- protected  Collection&lt;Thread> getWaitingThreads(Condition condition) ：返回一个 collection，它包含可能正在等待与此锁相关给定条件的那些线程。
- int getWaitQueueLength(Condition condition) ：返回等待与此锁相关的给定条件的线程估计数。
- boolean hasQueuedThread(Thread thread) ：查询给定线程是否正在等待获取此锁。
- boolean hasQueuedThreads() ：查询是否有些线程正在等待获取此锁。
- boolean hasWaiters(Condition condition) ：查询是否有些线程正在等待与此锁有关的给定条件。
- boolean isFair() ：如果此锁的公平设置为 true，则返回 true。
- boolean isHeldByCurrentThread() ：查询当前线程是否保持此锁。
- boolean isLocked() ：查询此锁是否由任意线程保持。 

**ReentrantLock 实现了标准的互斥操作，也就是一次只能有一个线程持有锁，也即所谓独占锁的概念。在这种情况下任何“读/读”，“写/读”，“写/写”操作都不能同时发生，这与synchronized提供的内部锁的工作机制相同。这个特点在一定程度上降低了吞吐量，实际上独占锁是一种保守的锁策略。锁是有一定的开销的，当并发比较大的时候，锁的开销就比较客观了。所以如果可能的话就尽量少用锁，非要用锁的话就尝试看能否改造为读写锁**。

在大多数情况下，应该使用以下语句： 
```java
public class LockTest {
	// 定义锁对象
	private final ReentrantLock lock = new ReentrantLock();
	// 定义需要保存线程安全的方法
    public void m() {
	    // if the lock is available
		if (lock.tryLock()) {
	        try {
	            // manipulate protected state
	        } finally {
	            lock.unlock();
	        }
	     } else {
	         // perform alternative actions
	     }
	}
}
```
或者trylock用法
```java
public class X {
	// 定义锁对象
	private final ReentrantLock lock = new ReentrantLock();
	// 定义需要保存线程安全的方法
    public void m() {
      	// 加锁
	    l.lock();
     	try {
         	// access the resource protected by this lock
          	// ...
  		// 使用finally块来保证释放锁
     	} finally {
         	l.unlock();
     	}
}
```
> **锁定和取消锁定出现在不同作用范围中时，必须谨慎地确保保持锁定时所执行的所有代码用 try-finally 或 try-catch 加以保护，以确保在必要时释放锁**。  

**ReadWriteLock接口**
**ReadWriteLock接口表示两个锁，读取的共享锁和写入的排他锁。在多数线程读取，少数线程写入的情况下，可以提高多线程的性能，提高使用该数据结构的吞吐量。如果是相反的情况，较多的线程写入，该接口会降低性能**。

**读写锁分为读锁和写锁，多个读锁不互斥，读锁与写锁互斥，写锁与写锁互斥，这是由jvm自己控制的，你只要上好相应的锁即可。如果你的代码只读数据，可以很多人同时读，但不能同时写，那就上读锁；如果你的代码修改数据，只能有一个人在写，且不能同时读取，那就上写锁。总之，读的时候上读锁，写的时候上写锁**！

方法摘要：

- Lock readLock() ： 返回用于读取操作的锁；
- Lock writeLock() ： 返回用于写入操作的锁。 

**在ReadWriteLock中每次读取共享数据就需要读取锁，当需要修改共享数据时就需要写入锁。看起来好像是两个锁，但其实不尽然**。

**ReentrantReadWriteLock**

此类是`ReadWriteLock`接口的实现类，提供了与ReentrantLock类相似的语法定义。该类不会强制优先获取reader锁或优先获取writer锁，但它确实支持可选的公平策略：

- 非公平模式（默认）：当通过非公平模式创建该类的对象时，未指定进入读写锁的顺序，受到 reentrancy 约束的限制。连续竞争的非公平锁可能无限期地推迟一个或多个 reader 或 writer 线程，但吞吐量通常要高于公平锁；
- 当公平地构造线程时。当释放当前保持的锁时，可以为等待时间最长的单个 writer 线程分配写入锁，如果有一组等待时间大于所有正在等待的 writer 线程的 reader 线程，将为该组分配写入锁。 如果保持写入锁，或者有一个等待的 writer 线程，则试图获得公平读取锁（非重入地）的线程将会阻塞。直到当前最久的等待 writer 线程已获得并释放了写入锁之后，该线程才会获得读取锁。当然，如果等待 writer 放弃其等待，而保留一个或更多 reader 线程为队列中带有写入锁自由的时间最长的 waiter，则将为那些 reader 分配读取锁。 试图获得公平写入锁的（非重入地）的线程将会阻塞，除非读取锁和写入锁都自由（这意味着没有等待线程）。

此锁允许 reader 和 writer 按照 ReentrantLock 的样式重新获取读取锁或写入锁。在写入线程保持的所有写入锁都已经释放后，才允许重入 reader 使用它们。比如，在预期 collection 很大，读取者线程访问它的次数多于写入者线程，可以使用 ReentrantReadWriteLock 来提高并发性：
```java
class RWDictionary {
    private final Map&lt;String, Data> m = new TreeMap&lt;String, Data>();
    private final ReentrantReadWriteLock rwl = new ReentrantReadWriteLock();
    private final Lock r = rwl.readLock();
    private final Lock w = rwl.writeLock();

    public Data get(String key) {
        r.lock();
        try { return m.get(key); }
        finally { r.unlock(); }
    }
    public String[] allKeys() {
        r.lock();
        try { return m.keySet().toArray(); }
        finally { r.unlock(); }
    }
    public Data put(String key, Data value) {
        w.lock();
        try { return m.put(key, value); }
        finally { w.unlock(); }
    }
    public void clear() {
        w.lock();
        try { m.clear(); }
        finally { w.unlock(); }
    }
 }
```
**重入还允许从写入锁降级为读取锁，其实现方式是：先获取写入锁，然后获取读取锁，最后释放写入锁。但是，从读取锁升级到写入锁是不可能的。重入性减少了锁在各个线程之间的等待**。**例如遍历一个HashMap，每次next()之前加锁，之后释放，可以保证一个线程一口气完成遍历，而不会每次next()之后释放锁，然后和其他线程竞争，降低了加锁的代价， 提供了程序整体的吞吐量。（即，让一个线程一口气完成任务，再把锁传递给其他线程）**。
利用重入来执行升级缓存后的锁降级（为简单起见，省略了异常处理）： 
```java
class CachedData {
   Object data;
   volatile boolean cacheValid;
   ReentrantReadWriteLock rwl = new ReentrantReadWriteLock();

   void processCachedData() {
     rwl.readLock().lock();
     if (!cacheValid) {
        // Must release read lock before acquiring write lock
        rwl.readLock().unlock();
        rwl.writeLock().lock();
        // Recheck state because another thread might have acquired
        //   write lock and changed state before we did.
        if (!cacheValid) {
          data = ...
          cacheValid = true;
        }
        // Downgrade by acquiring read lock before releasing write lock
        rwl.readLock().lock();
        rwl.writeLock().unlock(); // Unlock write, still hold read
     }

     use(data);
     rwl.readLock().unlock();
   }
 }
```
**读取锁和写入锁都支持锁获取期间的中断**。 

**写入锁提供了一个 Condition 实现，对于写入锁来说，该实现的行为与 ReentrantLock.newCondition() 提供的 Condition 实现对 ReentrantLock 所做的行为相同。当然，此 Condition 只能用于写入锁。 读取锁不支持 Condition，readLock().newCondition() 会抛出 UnsupportedOperationException**。 

嵌套类摘要：

- static class ReentrantReadWriteLock.ReadLock ：readLock() 方法返回的锁； 
- static class ReentrantReadWriteLock.WriteLock ：writeLock() 方法返回的锁。 

独有方法摘要：

- protected  Thread getOwner() ：返回当前拥有写入锁的线程，如果没有这样的线程，则返回 null；
- protected  Collection&lt;Thread> getQueuedReaderThreads() ：返回一个 collection，它包含可能正在等待获取读取锁的线程；
- protected  Collection&lt;Thread> getQueuedThreads() ：返回一个 collection，它包含可能正在等待获取读取或写入锁的线程；
- protected  Collection&lt;Thread> getQueuedWriterThreads() ：返回一个 collection，它包含可能正在等待获取写入锁的线程；
- int getQueueLength() ：返回等待获取读取或写入锁的线程估计数目；
- int getReadHoldCount() ：查询当前线程在此锁上保持的重入读取锁数量；
- int getReadLockCount() ：查询为此锁保持的读取锁数量；
- protected  Collection&lt;Thread> getWaitingThreads(Condition condition) ：返回一个 collection，它包含可能正在等待与写入锁相关的给定条件的那些线程；
- int getWaitQueueLength(Condition condition) ： 返回正等待与写入锁相关的给定条件的线程估计数目；
- int getWriteHoldCount() ：查询当前线程在此锁上保持的重入写入锁数量；
- boolean hasQueuedThread(Thread thread) ：查询是否给定线程正在等待获取读取或写入锁；
- boolean hasQueuedThreads() ：查询是否所有的线程正在等待获取读取或写入锁；
- boolean hasWaiters(Condition condition) ：查询是否有些线程正在等待与写入锁有关的给定条件；
- boolean isFair() ：如果此锁将公平性设置为 ture，则返回 true；
- boolean isWriteLocked() ：查询是否某个线程保持了写入锁；
- boolean isWriteLockedByCurrentThread() ：查询当前线程是否保持了写入锁。 

**ReentrantLock类和ReentrantReadWriteLock类具有重入性：即允许一个线程多次获取同一个锁（它们会记住上次获取锁并且未释放的线程对象，和加锁的次数，getHoldCount()）。同一个线程每次获取锁，加锁数+1，每次释放锁，加锁数-1，到0，则该锁被释放，可以被其他线程获取**。

以同步锁的形式实现上面的示例：
```java
public class Account {
	// 定义锁对象
	private final ReentrantLock lock = new ReentrantLock();
	// 封装账户编号、账户余额的两个成员变量
	private String accountNo;
	private double balance;
	public Account(){}
	// 构造器
	public Account(String accountNo , double balance) {
		this.accountNo = accountNo;
		this.balance = balance;
	}

	// accountNo的setter和getter方法
	public void setAccountNo(String accountNo) {
		this.accountNo = accountNo;
	}
	public String getAccountNo() {
		return this.accountNo;
	}
	// 因此账户余额不允许随便修改，所以只为balance提供getter方法，
	public double getBalance() {
		return this.balance;
	}

	// 提供一个线程安全draw()方法来完成取钱操作
	public void draw(double drawAmount) {
		// 加锁
		lock.lock();
		try {
			// 账户余额大于取钱数目
			if (balance >= drawAmount) {
				// 吐出钞票
				System.out.println(Thread.currentThread().getName()
					+ "取钱成功！吐出钞票:" + drawAmount);
				try {
					Thread.sleep(1);
				}
				catch (InterruptedException ex) {
					ex.printStackTrace();
				}
				// 修改余额
				balance -= drawAmount;
				System.out.println("\t余额为: " + balance);
			}
			else {
				System.out.println(Thread.currentThread().getName()
					+ "取钱失败！余额不足！");
			}
		}
		finally {
			// 修改完成，释放锁
			lock.unlock();
		}
	}

	// 下面两个方法根据accountNo来重写hashCode()和equals()方法
	public int hashCode() {
		return accountNo.hashCode();
	}
	public boolean equals(Object obj) {
		if(this == obj)
			return true;
		if (obj !=null && obj.getClass() == Account.class) {
			Account target = (Account)obj;
			return target.getAccountNo().equals(accountNo);
		}
		return false;
	}
}
```
####**死锁**
**两个线程相互等待对方释放同步监视器就会发生死锁。必须手动措施防止死锁的发生，因为一旦出现死锁，虚拟机不会抛出异常，也不会给出提示，而是一直阻塞。Thread类中的suspend()方法容易导致死锁，不推荐使用**。

死锁示例：

```java
class A {
	public synchronized void foo( B b ) {
		System.out.println("当前线程名: " + Thread.currentThread().getName() + " 进入了A实例的foo()方法" );  
		try {
			Thread.sleep(200);
		}
		catch (InterruptedException ex) {
			ex.printStackTrace();
		}
		System.out.println("当前线程名: " + Thread.currentThread().getName()
			+ " 企图调用B实例的last()方法");  
		b.last();
	}
	public synchronized void last() {
		System.out.println("进入了A类的last()方法内部");
	}
}
class B {
	public synchronized void bar( A a ) {
		System.out.println("当前线程名: " + Thread.currentThread().getName() + " 进入了B实例的bar()方法" );  
		try {
			Thread.sleep(200);
		}
		catch (InterruptedException ex) {
			ex.printStackTrace();
		}
		System.out.println("当前线程名: " + Thread.currentThread().getName() + " 企图调用A实例的last()方法");  
		a.last();
	}
	public synchronized void last() {
		System.out.println("进入了B类的last()方法内部");
	}
}
public class DeadLock implements Runnable {
	A a = new A();
	B b = new B();
	public void init() {
		Thread.currentThread().setName("主线程");
		// 调用a对象的foo方法
		a.foo(b);
		System.out.println("进入了主线程之后");
	}
	public void run() {
		Thread.currentThread().setName("副线程");
		// 调用b对象的bar方法
		b.bar(a);
		System.out.println("进入了副线程之后");
	}
	public static void main(String[] args) {
		DeadLock dl = new DeadLock();
		// 以dl为target启动新线程
		new Thread(dl).start();
		// 调用init()方法
		dl.init();
	}
}
```
###**线程通信**
####**传统的线程通信**
如果要求存款者存钱之后必须取钱，取钱之后必须存钱，两者都不能连续两次存钱或取钱。对于这种要求线程之间通信的场景。Object类提供了wait()、notify()和notifyAll()三个方法来控制这种传统线程间的通信：

- wait：导致当前线程等待，直到其他线程调用notify()或notifyAll()方法来唤醒该线程，该方法三种重载形式（无时间参数、以毫秒为参数、以毫秒加纳秒为参数 ）。调用wait方法的线程会释放同步监视器的锁定；
- notify()：唤醒在此同步监视器上等待的单个线程。如果有多个线程在同步监视器上等待，则会任意唤醒其中一个线程。只有当前线程使用wait方法放弃对该同步监视器的锁定，才可以执行被唤醒的线程；
- notifyAll：同上，只是唤醒此同步监视器上等待的所有线程。

以上三个方法由同步监视器调用 ，即必须结合synchronized关键字使用。对于同步代码块，由括号中的同步监视器调用；对于同步方法，默认实例(this)就是同步监视器，所以可以在同步方法中直接调用这三个方法。

示例：
```java
public class Account {
	// 封装账户编号、账户余额的两个成员变量
	private String accountNo;
	private double balance;
	// 标识账户中是否已有存款的旗标
	private boolean flag = false;

	public Account(){}
	// 构造器
	public Account(String accountNo , double balance) {
		this.accountNo = accountNo;
		this.balance = balance;
	}

	// accountNo的setter和getter方法
	public void setAccountNo(String accountNo) {
		this.accountNo = accountNo;
	}
	public String getAccountNo() {
		return this.accountNo;
	}
	// 因此账户余额不允许随便修改，所以只为balance提供getter方法，
	public double getBalance() {
		return this.balance;
	}

	public synchronized void draw(double drawAmount) {
		try {
			// 如果flag为假，表明账户中还没有人存钱进去，取钱方法阻塞
			if (!flag) {
				wait();
			}
			else {
				// 执行取钱
				System.out.println(Thread.currentThread().getName()
					+ " 取钱:" +  drawAmount);
				balance -= drawAmount;
				System.out.println("账户余额为：" + balance);
				// 将标识账户是否已有存款的旗标设为false。
				flag = false;
				// 唤醒其他线程
				notifyAll();
			}
		}
		catch (InterruptedException ex) {
			ex.printStackTrace();
		}
	}
	public synchronized void deposit(double depositAmount) {
		try {
			// 如果flag为真，表明账户中已有人存钱进去，则存钱方法阻塞
			if (flag) {
				wait();
			}
			else {
				// 执行存款
				System.out.println(Thread.currentThread().getName()
					+ " 存款:" +  depositAmount);
				balance += depositAmount;
				System.out.println("账户余额为：" + balance);
				// 将表示账户是否已有存款的旗标设为true
				flag = true;
				// 唤醒其他线程
				notifyAll();
			}
		}
		catch (InterruptedException ex) {
			ex.printStackTrace();
		}
	}

	// 下面两个方法根据accountNo来重写hashCode()和equals()方法
	public int hashCode() {
		return accountNo.hashCode();
	}
	public boolean equals(Object obj) {
		if(this == obj)
			return true;
		if (obj !=null && obj.getClass() == Account.class) {
			Account target = (Account)obj;
			return target.getAccountNo().equals(accountNo);
		}
		return false;
	}
}
```
```java
public class DepositThread extends Thread {
	// 模拟用户账户
	private Account account;
	// 当前取钱线程所希望存款的钱数
	private double depositAmount;
	public DepositThread(String name , Account account, double depositAmount){
		super(name);
		this.account = account;
		this.depositAmount = depositAmount;
	}
	// 重复100次执行存款操作
	public void run() {
		for (int i = 0 ; i &lt; 100 ; i++ ) {
			account.deposit(depositAmount);
		}
	}
}
```
```java
public class DrawThread extends Thread {
	// 模拟用户账户
	private Account account;
	// 当前取钱线程所希望取的钱数
	private double drawAmount;
	public DrawThread(String name , Account account, double drawAmount) {
		super(name);
		this.account = account;
		this.drawAmount = drawAmount;
	}
	// 重复100次执行取钱操作
	public void run() {
		for (int i = 0 ; i &lt; 100 ; i++ ) {
			account.draw(drawAmount);
		}
	}
} 
```
```java
public class DrawTest {
	public static void main(String[] args) {
		// 创建一个账户
		Account acct = new Account("1234567" , 0);
		new DrawThread("取钱者" , acct , 800).start();
		new DepositThread("存款者甲" , acct , 800).start();
		new DepositThread("存款者乙" , acct , 800).start();
		new DepositThread("存款者丙" , acct , 800).start();
	}
}
```
####**使用Condition控制线程通信**
Java提供了Condition结合Lock的方式来替代synchronized结合wait、notify()、notifyAll()的方式。Condition接口将 Object 监视器方法（wait、notify 和 notifyAll）分解成截然不同的对象，以便通过将这些对象与任意 Lock 实现组合使用，为每个对象提供多个等待集（wait-set）。其中，Lock 替代了 synchronized 方法和语句的使用，Condition 替代了 Object 监视器方法的使用。Condition接口提供了以下方法：

-  void await() ：造成当前线程在接到信号或被中断之前一直处于等待状态，直到其他线程调用Condition的signal()或signalAll()方法来唤醒该线程；
-  boolean await(long time, TimeUnit unit) ：同上，只是可以指定了等待的时间；
-  long awaitNanos(long nanosTimeout) ：同上，只是返回nanosTimeout 值减去花费在等待此方法的返回结果的时间的估算。正值可以用作对此方法进行后续调用的参数，来完成等待所需时间结束。小于等于零的值表示没有剩余时间。可以用此值来确定在等待返回但某一等待条件仍不具备的情况下，是否要再次等待，以及再次等待的时间；
-  void awaitUninterruptibly() ：造成当前线程在接到信号之前一直处于等待状态。如果在进入此方法时设置了当前线程的中断状态，或者在等待时，线程被中断，那么在接到信号之前，它将继续等待。当最终从此方法返回时，仍然将设置其中断状态；
-  boolean awaitUntil(Date deadline) ：造成当前线程在接到信号、被中断或到达指定最后期限之前一直处于等待状态；
-  void signal() ： 唤醒一个等待线程；
-  void signalAll() ： 唤醒所有等待线程。 

Condition实例被绑定在一个Lock对象上，调用Lock对象的newCondition()方法来该Lock对象上的Condition实例。

使用Condition结合Lock实现线程通信的示例：
```java
public class Account {
	// 显式定义Lock对象
	private final Lock lock = new ReentrantLock();
	// 获得指定Lock对象对应的Condition
	private final Condition cond  = lock.newCondition();
	// 封装账户编号、账户余额的两个成员变量
	private String accountNo;
	private double balance;
	// 标识账户中是否已有存款的旗标
	private boolean flag = false;

	public Account(){}
	// 构造器
	public Account(String accountNo , double balance) {
		this.accountNo = accountNo;
		this.balance = balance;
	}

	// accountNo的setter和getter方法
	public void setAccountNo(String accountNo) {
		this.accountNo = accountNo;
	}
	public String getAccountNo() {
		return this.accountNo;
	}
	// 因此账户余额不允许随便修改，所以只为balance提供getter方法，
	public double getBalance() {
		return this.balance;
	}

	public void draw(double drawAmount) {
		// 加锁
		lock.lock();
		try {
			// 如果flag为假，表明账户中还没有人存钱进去，取钱方法阻塞
			if (!flag) {
				cond.await();
			}
			else {
				// 执行取钱
				System.out.println(Thread.currentThread().getName()
					+ " 取钱:" +  drawAmount);
				balance -= drawAmount;
				System.out.println("账户余额为：" + balance);
				// 将标识账户是否已有存款的旗标设为false。
				flag = false;
				// 唤醒其他线程
				cond.signalAll();
			}
		}
		catch (InterruptedException ex) {
			ex.printStackTrace();
		}
		// 使用finally块来释放锁
		finally {
			lock.unlock();
		}
	}
	public void deposit(double depositAmount) {
		lock.lock();
		try {
			// 如果flag为真，表明账户中已有人存钱进去，则存钱方法阻塞
			if (flag) {
				cond.await();
			}
			else {
				// 执行存款
				System.out.println(Thread.currentThread().getName()
					+ " 存款:" +  depositAmount);
				balance += depositAmount;
				System.out.println("账户余额为：" + balance);
				// 将表示账户是否已有存款的旗标设为true
				flag = true;
				// 唤醒其他线程
				cond.signalAll();
			}
		}
		catch (InterruptedException ex) {
			ex.printStackTrace();
		}
		// 使用finally块来释放锁
		finally {
			lock.unlock();
		}
	}

	// 下面两个方法根据accountNo来重写hashCode()和equals()方法
	public int hashCode() {
		return accountNo.hashCode();
	}
	public boolean equals(Object obj) {
		if(this == obj)
			return true;
		if (obj !=null && obj.getClass() == Account.class) {
			Account target = (Account)obj;
			return target.getAccountNo().equals(accountNo);
		}
		return false;
	}
}
```
```java
public class DepositThread extends Thread {
	// 模拟用户账户
	private Account account;
	// 当前取钱线程所希望存款的钱数
	private double depositAmount;
	public DepositThread(String name , Account account, double depositAmount) {
		super(name);
		this.account = account;
		this.depositAmount = depositAmount;
	}
	// 重复100次执行存款操作
	public void run() {
		for (int i = 0 ; i &lt; 100 ; i++ ) {
			account.deposit(depositAmount);
		}
	}
}
```
```java
public class DrawThread extends Thread {
	// 模拟用户账户
	private Account account;
	// 当前取钱线程所希望取的钱数
	private double drawAmount;
	public DrawThread(String name , Account account, double drawAmount) {
		super(name);
		this.account = account;
		this.drawAmount = drawAmount;
	}
	// 重复100次执行取钱操作
	public void run() {
		for (int i = 0 ; i &lt; 100 ; i++ ) {
			account.draw(drawAmount);
		}
	}
}
```
```java
public class DrawTest {
	public static void main(String[] args) {
		// 创建一个账户
		Account acct = new Account("1234567" , 0);
		new DrawThread("取钱者" , acct , 800).start();
		new DepositThread("存款者甲" , acct , 800).start();
		new DepositThread("存款者乙" , acct , 800).start();
		new DepositThread("存款者丙" , acct , 800).start();
	}
}
```
####**使用BlockingQueue接口控制线程通信**
该接口是是Queue的子接口，代表线程安全的阻塞式队列；当队列已满时，想队列添加会阻塞；当队列空时，取数据会阻塞。非常适合消费者-生产者模式。通过交替地向BlockingQueue中放入、取出元素，即可很好地控制线程通讯。
![](http://img.blog.csdn.net/20161224200622805?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvcm9zeV9kYXdu/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)
BlockingQueue提供了两个阻塞式方法：

 - put(E e)：尝试把E放入BlockingQueue尾部，如果队列已满，则阻塞该线程；
 - take()：尝试从BlockingQueue头部中取出元素，如果队列已空，则阻塞该线程。

BlockingQueue中提供了以下方法：
| 操作       | 抛出异常      | 返回值              | 阻塞线程方法 | 指定超时方法               |
| -------- | --------- | ---------------- | ------ | -------------------- |
| 队尾插入元素   | add(e)    | boolean offer(e) | put(e) | offer(e, time, unit) |
| 队头删除元素   | remove(e) | boolean poll()   | take() | poll(time, unti)     |
| 获取、不删除元素 | element() | peel()           | 无      | 无                    |

BlockingQueue包含以下实现类：

- ArrayBlockingQueue：基于数组实现的BlockingQueue；
- LinkedBlockingQueue：基于链表实现的BlockingQueue；
- PriorityBlockingQueue：它并不是标准的阻塞队列。它使用remo()、poll()、take()方法时，并不是取出队列中时间最长的元素，而是队列中最小的元素。可以采用默认的元素大小排序（实现Comparable接口），也可以自定义大小的标准（实现Comparator接口）；
- DelayQueue：底层基于PriorityBlockingQueue实现，但是要求其元素实现Delay函数式接口（仅含一个long getDelay()方法，其元素根据该方法的返回值排序）；
- SynchronousQueue：同步队列。对该队列的存取操作必须交替进行。

ArrayBlockingQueue的示例：
```java
public class BlockingQueueTest {
	public static void main(String[] args) throws Exception {
		// 定义一个长度为2的阻塞队列
		BlockingQueue&lt;String> bq = new ArrayBlockingQueue&lt;>(2);
		bq.put("Java"); // 与bq.add("Java"、bq.offer("Java")相同
		bq.put("Java"); // 与bq.add("Java"、bq.offer("Java")相同
		bq.put("Java"); // 队列已满，继续放入元素则会阻塞线程。
	}
}
```
示例2：
```java
class Producer extends Thread {
	private BlockingQueue&lt;String> bq;
	public Producer(BlockingQueue<String> bq) {
		this.bq = bq;
	}
	public void run() {
		String[] strArr = new String[] {
			"Java",
			"Struts",
			"Spring"
		};
		for (int i = 0 ; i &lt; 999999999 ; i++ ) {
			System.out.println(getName() + "生产者准备生产集合元素！");
			try {
				Thread.sleep(200);
				// 尝试放入元素，如果队列已满，线程被阻塞
				bq.put(strArr[i % 3]);
			}
			catch (Exception ex){ex.printStackTrace();}
			System.out.println(getName() + "生产完成：" + bq);
		}
	}
}
class Consumer extends Thread {
	private BlockingQueue<String> bq;
	public Consumer(BlockingQueue<String> bq) {
		this.bq = bq;
	}
	public void run() {
		while(true) {
			System.out.println(getName() + "消费者准备消费集合元素！");
			try {
				Thread.sleep(200);
				// 尝试取出元素，如果队列已空，线程被阻塞
				bq.take();
			}
			catch (Exception ex){ex.printStackTrace();}
			System.out.println(getName() + "消费完成：" + bq);
		}
	}
}
public class BlockingQueueTest2 {
	public static void main(String[] args) {
		// 创建一个容量为1的BlockingQueue
		BlockingQueue<String> bq = new ArrayBlockingQueue<>(1);
		// 启动3条生产者线程
		new Producer(bq).start();
		new Producer(bq).start();
		new Producer(bq).start();
		// 启动一条消费者线程
		new Consumer(bq).start();
	}
}
```
###**线程组和未处理异常**
Java使用ThreadGroup表示线程组，线程组可以对其中的一批线程进行批量处理，对线程组的操作会作用于其中的所有线程。所有线程都有其所属的线程组，如果在创建线程时没有通过Thread类的构造器显式指定线程组，则该线程属于默认线程组。默认情况下，线程和创建它的父线程同属一个线程组。一个线程一旦加入了一个线程组，则一直属于该线程组，直到其死亡，中途不能更改其所属的线程组。
ThreadGroup类构造器如下：

- ThreadGroup(String name) ：构造一个新线程组；
- ThreadGroup(ThreadGroup parent, String name) ：创建一个新线程组。 

常用方法如下：

- int activeCount() ：返回此线程组中活动线程的估计数；
- void destroy() ：销毁此线程组及其所有子组；
- int enumerate(Thread[] list) ： 把此线程组及其子组中的所有活动线程复制到指定数组中；
- int enumerate(Thread[] list, boolean recurse) ： 把此线程组中的所有活动线程复制到指定数组中；
- int enumerate(ThreadGroup[] list) ：把对此线程组中的所有活动子组的引用复制到指定数组中； 
- int enumerate(ThreadGroup[] list, boolean recurse) ：把对此线程组中的所有活动子组的引用复制到指定数组中；
- int getMaxPriority() ： 返回此线程组的最高优先级；
- String getName() ：返回此线程组的名称；
- ThreadGroup getParent() ：返回此线程组的父线程组；
- void interrupt() ：中断此线程组中的所有线程； 
- boolean isDaemon() ：测试此线程组是否为一个后台程序线程组；
- boolean isDestroyed() ：测试此线程组是否已经被销毁；
- void list() ：将有关此线程组的信息打印到标准输出；
- boolean parentOf(ThreadGroup g) ：测试此线程组是否为线程组参数或其祖先线程组之一；
- void setDaemon(boolean daemon) ：更改此线程组的后台程序状态；
- void setMaxPriority(int pri) ：设置线程组的最高优先级；
- void uncaughtException(Thread t, Throwable e) ：当此线程组中的线程因为一个未捕获的异常而停止，并且线程没有安装特定 Thread.UncaughtExceptionHandler 时，由JVM调用此方法处理没有处理的异常。 

示例：
```java
class MyThread extends Thread {
	// 提供指定线程名的构造器
	public MyThread(String name) {
		super(name);
	}
	// 提供指定线程名、线程组的构造器
	public MyThread(ThreadGroup group , String name) {
		super(group, name);
	}
	public void run() {
		for (int i = 0; i &lt; 20 ; i++ ) {
			System.out.println(getName() + " 线程的i变量" + i);
		}
	}
}
public class ThreadGroupTest {
	public static void main(String[] args) {
		// 获取主线程所在的线程组，这是所有线程默认的线程组
		ThreadGroup mainGroup = Thread.currentThread().getThreadGroup();
		System.out.println("主线程组的名字："
			+ mainGroup.getName());
		System.out.println("主线程组是否是后台线程组："
			+ mainGroup.isDaemon());
		new MyThread("主线程组的线程").start();
		ThreadGroup tg = new ThreadGroup("新线程组");
		tg.setDaemon(true);
		System.out.println("tg线程组是否是后台线程组："
			+ tg.isDaemon());
		MyThread tt = new MyThread(tg , "tg组的线程甲");
		tt.start();
		new MyThread(tg , "tg组的线程乙").start();
	}
}
```

Thread类提供了以下两个方法来设置线程的Thread.UncaughtExceptionHandler(Thread类内嵌的静态接口，代表一个异常处理器，该接口中唯一的方法uncaughtException(Thread t, Throwable e)方法负责处理异常)：

- static void setDefaultUncaughtExceptionHandler(Thread.UncaughtExceptionHandler eh) ：为该线程类所有实例设置其默认的Thread.UncaughtExceptionHandler来处理异常。 
- void setUncaughtExceptionHandler(Thread.UncaughtExceptionHandler eh) ：为该线程示例设置Thread.UncaughtExceptionHandler来处理异常。

ThreadGroup类实现了Thread.UncaughtExceptionHandler接口，所以每个线程的线程组会作为该线程默认的异常处理器。当某一线程因未捕获的异常而即将终止时，Java 虚拟机将使用 Thread.getUncaughtExceptionHandler() 查询该线程以获得其UncaughtExceptionHandler对象（由setUncaughtExceptionHandler()方法设置），如果找到了该对象，则调用该异常处理器的uncaughtException()方法，将线程和异常作为参数传递。则使用该对象来处理该异常。如果找不到该对象则使用该线程所属线程组的uncaughtException()方法来处理该异常。使用异常处理器进行处理后，异常仍会传播给上一级调用者。

线程组处理异常的流程如下：
1. 如果该线程组有父线程组，则调用父线程组的uncaughtException方法来处理该异常
2. 否则，如果该线程实例所属的线程类有默认的异常处理器（由setDefaultUncaughtExceptionHandler方法设置的异常处理器），那么就调用该异常处理器来处理该异常
3. 否则，将异常调试栈的信息打印到System.err错误输出流，并结束该线程。

```java
// 定义自己的异常处理器
class MyExHandler implements Thread.UncaughtExceptionHandler
{
	// 实现uncaughtException方法，该方法将处理线程的未处理异常
	public void uncaughtException(Thread t, Throwable e)
	{
		System.out.println(t + " 线程出现了异常：" + e);
	}
}
public class ExHandler
{
	public static void main(String[] args)
	{
		// 设置主线程的异常处理器
		Thread.currentThread().setUncaughtExceptionHandler
			(new MyExHandler());
		int a = 5 / 0;     // ①
		System.out.println("程序正常结束！");
	}
}
```
###**线程池**
系统启动一个新线程的成本是比较高的，因为它涉及到与操作系统的交互。在这种情况下，使用线程池可以很好的提供性能，尤其是当程序中需要创建大量生存期很短暂的线程时，更应该考虑使用线程池。线程池在系统启动时即创建大量空闲的线程，程序将一个Runnable对象或Callable对象传给线程池，线程池就会启动一条线程来执行该对象的run()或call()方法，当run()或call()方法执行结束后，该线程并不会死亡，而是再次返回线程池中成为空闲状态，等待执行下一个Runnable对象或Callable对象的run方法。

除此之外，使用线程池可以有效地控制系统中并发线程的数量，但系统中包含大量并发线程时，会导致系统性能剧烈下降，甚至导致JVM崩溃。而线程池的最大线程数参数可以控制系统中并发的线程不超过此数目。 

在JDK1.5之前，开发者必须手动的实现自己的线程池，从JDK1.5之后，Java内建支持线程池。
与多线程并发的所有支持的类都在java.lang.concurrent包中。我们可以使用里面的类更加的控制多线程的执行。 

####**Executors接口**
JDK1.5中提供Executors工厂类来产生连接池，该工厂类中包含如下的几个静态工程方法来创建连接池： 

- static **ExecutorService** **newCachedThreadPool**() ：创建一个具有缓冲功能的线程池，系统根据需要创建线程，这些线程将会被缓存在线程池中；
- static ExecutorService newCachedThreadPool(ThreadFactory threadFactory) ：同上，并在需要时使用提供的 ThreadFactory 创建新线程；
- static ExecutorService **newFixedThreadPool**(int nThreads) ：创建一个可重用的、具有固定线程数的线程池；
- static ExecutorService newFixedThreadPool(int nThreads, ThreadFactory threadFactory) ：同上，在需要时使用提供的 ThreadFactory 创建新线程；

- static **ScheduledExecutorService** **newScheduledThreadPool**(int corePoolSize) ：创建具有指定线程数的线程池，它可以在指定延迟后执行线程任务，corePoolSize指池中所保存的线程数，即使线程是空闲的也被保存在线程池内；
- static ScheduledExecutorService newScheduledThreadPool(int corePoolSize, ThreadFactory threadFactory) ：同上，在需要时使用提供的 ThreadFactory 创建新线程；
- static ScheduledExecutorService **newSingleThreadScheduledExecutor**() ：创建只有一条线程的线程池，它可以在指定延迟后执行线程任务；
  - static ExecutorServicenewWorkStealingPool(int parallelism)：Java8新增，创建持有足够线程的线程池来支持给定的并行级别，该方法还会使用多个队列来减少竞争。该方法可以充分发挥多核处理器的并行计算优势；
  - static ExecutorServicenewWorkStealingPool()：该方法是前一个方法的简化版本，默认使用当前机器的所有处理器数作为并行级别。

####**ExecutorService接口**
该类代表一个尽快执行的线程池（只要线程池中有空闲线程立即执行线程任务），程序只要将一个Runnable对象或Callable对象提交给该线程池即可，该线程就会尽快的执行该任务。
ExecutorService有几个重要的方法：

 - boolean	isShutdown() ：如果此执行程序已关闭，则返回 true；
    - booleanisTerminated() ：如果关闭后所有任务都已完成，则返回 true；
     - voidshutdown() ： 用完线程池后，应该使用此方法启动线程池的关闭序列，调用该方法后线程池不会在接受新的任务，但会将以前所有已提交的任务执行完成。当线程池中的所有任务都执行完毕之后，池中的线程都会死亡；
     - List&lt;Runnable>shutdownNow() ： 该方法也可以关闭线程池，试图停止所有正在执行的活动任务，暂停处理正在等待的任务，并返回等待执行的任务列表；
     - &lt;T> Future &lt;T>submit(Callable&lt;T> task) ：将一个 Callable 对象提交给指定的线程池，线程池会在有空闲线程时执行Callable对象代表的任务。其中Future对象代表Callable对象里call()方法的返回值；
     - Future &lt;?>submit(Runnable task) ：将一个 Runnable 对象提交给指定的线程池，线程池会在有空闲线程时执行Runnable对象代表的任务。其中Future对象代表Runnable任务的返回值——但是run()方法没有返回值，所以Future对象将在run()方法执行结束后返回null。但可以通过调用Future的isDone()、isCancelled()方法获得Runnable对象的执行状态；
     - &lt;T> Future &lt;T>submit(Runnable task, T result) ：将一个 Runnable 对象提交给指定的线程池，线程池会在有空闲线程时执行Runnable对象代表的任务。其中result显式指定线程结束后的返回值，所以Future对象将在run()方法执行结束后返回result。

####**ScheduleExecutorService类**
ScheduleExecutorService类代表可在指定延迟后或周期性执行线程任务的线程池。ScheduleExecutorService类是ExecutorService类的子类。所以，它里面也有直接提交任务的submit方法，并且新增了一些延迟任务处理的方法： 

- &lt;V> ScheduledFuture&lt;V>	schedule(Callable&lt;V> callable, long delay, TimeUnit unit) ： 指定callable任务在delay延迟后执行；
  - ScheduledFuture &lt;?>schedule(Runnable command, long delay, TimeUnit unit) ：指定command任务在delay延迟后执行；
  - ScheduledFuture &lt;?>scheduleAtFixedRate(Runnable command, long initialDelay, long period, TimeUnit unit) ： 指定command任务在delay延迟后执行，而且以指定的频率重复执行。也就是将在 initialDelay 后开始执行，然后在 initialDelay+period 后执行，接着在 initialDelay + 2 * period 后执行，依此类推；
  - ScheduledFuture&lt;?>scheduleWithFixedDelay(Runnable command, long initialDelay, long delay, TimeUnit unit) ：创建并执行一个在给定初始延迟后首次启用的定期操作，随后，在每一次执行终止和下一次执行开始之间都存在给定的延迟。如果任务在下一次执行时遇到异常，就会取消后续执行；否则，只能通过程序来显式取消或终止该任务。

使用线程池的步骤如下：

 - 调用Executors类的静态工厂办法创建一个ExecutorService对象，该对象代表一个线程池；
 - 创建Runnable实现类或Callable实现类的实例作为线程执行的任务；
 - 调用ExecutorService对象的submit()方法来提交Runnable实例或Callable实例；
 - 当不想提交任何任务时，调用ExecutorService对象的shutdown()方法来关闭线程池。

示例：
```java
public class ThreadPoolTest {
	public static void main(String[] args) throws Exception {
		// 创建足够的线程来支持4个CPU并行的线程池
		// 创建一个具有固定线程数（6）的线程池
		ExecutorService pool = Executors.newFixedThreadPool(6);
		// 使用Lambda表达式创建Runnable对象
		Runnable target = () -> {
			for (int i = 0; i &lt; 100 ; i++ ) {
				System.out.println(Thread.currentThread().getName()
					+ "的i值为:" + i);
			}
		};
		// 向线程池中提交两个线程
		pool.submit(target);
		pool.submit(target);
		// 关闭线程池
		pool.shutdown();
	}
} 
```
####**ForkJoinPool类**
为了充分利用如今多核CPU的并行计算优势，Java7提供了ForkJoinPool类，该类支持将一个任务拆分成多个"小任务"，再把小任务合并成总的计算结果。该类是ExecutorService接口的实现类，提供了以下两个构造器：

 - ForkJoinPool(int parallelism)：创建一个包含parallelism个并行线程的ForkJoinPool；
 - ForkJoinPool()：以Runtime.availableProcessors()方法的返回值作为parallelism参数创建ForkJoinPool。

主要方法如下：

- static &lt;T> ForkJoinTask &lt;T>	adapt(Callable&lt;? extends T> callable)：返回一个执行callable任务中call()方法的ForkJoinTask对象。返回结果时将checked异常转换为Runtime异常，结果取决于join()方法；
- static ForkJoinTask&lt;?> adapt(Runnable runnable)：返回一个执行runnable任务中run()方法的ForkJoinTask对象。根据于join()方法的返回值返回null，因为Runnable对象没有返回值；
- static &lt;T> ForkJoinTask&lt;T> adapt(Runnable runnable, T result)：返回一个执行runnable任务中run()方法的ForkJoinTask对象。根据join()方法返回指定的类型；
- boolean cancel(boolean mayInterruptIfRunning)：尝试取消任务的执行；
- boolean compareAndSetForkJoinTaskTag(short e, short tag)：为该任务有条件地、原子地设置标签值；
- void complete(V value)：如果该任务没有被终止或取消，则完成该任务。返回给定value类型的值作为join()等相关分解操作的结果；
- void completeExceptionally(Throwable ex)：如果该任务没有被终止或取消，则非正常地完成该任务。抛出根据join()等相关操作指定的给定异常；
  - protected abstract booleanexec()：立即执行该任务，如果该任务正常完成则返回true；
- ForkJoinTask &lt;V> fork()：如果可以，在当前任务所运行的线程池中分次异步地执行当前任务。如果不是运行在ForkJoinPool中的ForkJoinWorkerThread对象，则使用ForkJoinPool.commonPool()；
- V get()：返回计算的结果，如果计算有必要等待则等待；
- V get(long timeout, TimeUnit unit)：同上，指定了等待时间；
  - ThrowablegetException()：返回基础计算的抛出的异常，如果计算被取消了返回一个CancellationException，如果没有计算或者计算没有完成则返回null；
  - shortgetForkJoinTaskTag()：返回该任务的标签；
- static ForkJoinPool getPool()：返回控制该任务执行的ForkJoinPool对象，如果当前任务不在ForkJoinPool中则返回null；
- static int getQueuedTaskCount()：被当前worker线程所分解的但是还未执行的任务的大概数量；
  - abstract VgetRawResult()：返回join()方法将返回的结果，即使该任务异常结束。如果该任务还不知道是否完成则返回null；
- static boolean inForkJoinPool()：如果当前线程是一个当作ForkJoinPool运行的ForkJoinWorkerThread对象，则返回true；
- V invoke()：开始执行该任务，有必要则等待任务完成，返回结果。如果下面的计算抛出了RuntimeException或Error则返回这些RuntimeException或Error；
- static &lt;T extends ForkJoinTask&lt;?>> Collection&lt;T> invokeAll(Collection&lt;T> tasks)：分解指定集合中的所有任务，如果isDone约束着每个任务或遇到未经检查的异常则返回，这样异常会再次抛出；
  - static voidinvokeAll(ForkJoinTask&lt;?>... tasks)：同上；
  - static voidinvokeAll(ForkJoinTask&lt;?> t1, ForkJoinTask&lt;?> t2)：同上；
- boolean isCancelled()：如果任务在正常完成前被取消则返回true；
- boolean isCompletedAbnormally()：如果任务抛出异常或被取消则返回true；
- boolean isCompletedNormally()：如果该任务正常结束则返回true；
- boolean isDone()：如果任务完成了则返回true；
- V join()：返回计算完成的结果；
  - voidquietlyComplete()：不设置值地正常完成该任务；
  - voidquietlyInvoke()：开始执行该任务，有必要则等待，但是不返回结果或抛出异常；
  - voidquietlyJoin()：合并该任务，但是不反悔结果或抛出异常；
  - voidreinitialize()：重设该任务的内部记录，允许后续的分解；
  - shortsetForkJoinTaskTag(short tag)：原子地为该任务设置标签值；
  - protected abstract voidsetRawResult(V value)：强制返回给定类型的结果；
- boolean tryUnfork()：尝试为该任务执行逆分解过程。

Java8进一步扩展了ForkJoinPool的功能，为其添加了通用池的功能。ForkJoinPool提供以下两个静态方法提供通用池功能：

- static ForkJoinPool commonPool()：该方法返回一个通用池，通用池的运行状态不受shutdown()或shutdownNow()方法的影响。当然，调用System.exit(0)方法终止虚拟机会导致通用池中正在执行的任务都会被自动终止；
- static int getCommonPoolParallelism()：该方法返回通用池的并行级别。

创建了ForkJoinPool实例后，就可以调用ForkJoinPool的submit(ForJoinTask task)或invoke(ForkJoinTask task)方法来执行指定任务了。其中ForkJoinTask代表一个可并行、合并的任务。ForkJoinTask是一个抽象类，它有两个抽象子类：RecursiveAction（代表一个没有返回值的任务，只需实现其负责计算的protected abstract void compute() 方法）和RecursiveTask（代表一个有返回值的任务，只需实现其负责计算的protected abstract V compute()方法）。  
![这里写图片描述](http://img.blog.csdn.net/20161224203755461?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvcm9zeV9kYXdu/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)
任务拆解示例：
```java
// 继承RecursiveAction来实现"可分解"的任务
class PrintTask extends RecursiveAction {
	// 每个“小任务”只最多只打印50个数
	private static final int THRESHOLD = 50;
	private int start;
	private int end;
	// 打印从start到end的任务
	public PrintTask(int start, int end) {
		this.start = start;
		this.end = end;
	}
  
	@Override
	protected void compute() {
		// 当end与start之间的差小于THRESHOLD时，开始打印
		if(end - start &lt; THRESHOLD) {
			for (int i = start ; i &lt; end ; i++ ) {
				System.out.println(Thread.currentThread().getName()
					+ "的i值：" + i);
			}
		} else {
			// 如果当end与start之间的差大于THRESHOLD时，即要打印的数超过50个
			// 将大任务分解成两个小任务。
			int middle = (start + end) / 2;
			PrintTask left = new PrintTask(start, middle);
			PrintTask right = new PrintTask(middle, end);
			// 并行执行两个“小任务”
			left.fork();
			right.fork();
		}
	}
}

public class ForkJoinPoolTest {
	public static void main(String[] args) throws Exception {
		ForkJoinPool pool = new ForkJoinPool();
		// 提交可分解的PrintTask任务
		pool.submit(new PrintTask(0 , 300));
		pool.awaitTermination(2, TimeUnit.SECONDS);
		// 关闭线程池
		pool.shutdown();
	}
}
```
有返回值的任务分解示例：
```java
// 继承RecursiveTask来实现"可分解"的任务
class CalTask extends RecursiveTask<Integer> {
	// 每个“小任务”只最多只累加20个数
	private static final int THRESHOLD = 20;
	private int arr[];
	private int start;
	private int end;
	// 累加从start到end的数组元素
	public CalTask(int[] arr , int start, int end) {
		this.arr = arr;
		this.start = start;
		this.end = end;
	}
  
	@Override
	protected Integer compute() {
		int sum = 0;
		// 当end与start之间的差小于THRESHOLD时，开始进行实际累加
		if(end - start &lt; THRESHOLD) {
			for (int i = start ; i &lt; end ; i++ ) {
				sum += arr[i];
			}
			return sum;
		} else {
			// 如果当end与start之间的差大于THRESHOLD时，即要累加的数超过20个时
			// 将大任务分解成两个小任务。
			int middle = (start + end) / 2;
			CalTask left = new CalTask(arr , start, middle);
			CalTask right = new CalTask(arr , middle, end);
			// 并行执行两个“小任务”
			left.fork();
			right.fork();
			// 把两个“小任务”累加的结果合并起来
			return left.join() + right.join();
		}
	}
}

public class Sum {
	public static void main(String[] args) throws Exception {
		int[] arr = new int[100];
		Random rand = new Random();
		int total = 0;
		// 初始化100个数字元素
		for (int i = 0 , len = arr.length; i &lt; len ; i++ ) {
			int tmp = rand.nextInt(20);
			// 对数组元素赋值，并将数组元素的值添加到sum总和中。
			total += (arr[i] = tmp);
		}
		System.out.println(total);
		// 创建一个通用池
		ForkJoinPool pool = ForkJoinPool.commonPool();
		// 提交可分解的CalTask任务
		Future&lt;Integer> future = pool.submit(new CalTask(arr , 0 , arr.length));
		System.out.println(future.get());
		// 关闭线程池
		pool.shutdown();
	}
}
```
###**ThreadLocal类**
**ThreadLocal是thread local variable(线程局部变量)，它并不是一个线程。线程局部变量(ThreadLocal)为每一个使用该变量的线程都提供一个变量值的副本，每一个线程都可以独立地改变自己的副本，而不会和其它线程的副本冲突**。

**从线程的角度看，每个线程都保持一个对其线程局部变量副本的隐式引用，只要线程是活动的并且 ThreadLocal 实例是可访问的；在线程消失之后，其线程局部实例的所有副本都会被垃圾回收（除非存在对这些副本的其他引用）**。

通过ThreadLocal存取的数据，总是与当前线程相关，也就是说，JVM 为每个运行的线程，绑定了私有的本地实例存取空间，从而为多线程环境常出现的并发访问问题提供了一种隔离机制。在ThreadLocal类中有一个Map，用于存储每一个线程的变量的副本。 

概括起来说，对于多线程资源共享的问题，同步机制采用了“以时间换空间”的方式，而ThreadLocal采用了“以空间换时间”的方式。前者仅提供一份变量，让不同的线程排队访问，而后者为每一个线程都提供了一份变量，因此可以同时访问而互不影响。

方法摘要：

- T get()： 返回此线程局部变量的当前线程副本中的值，如果这是线程第一次调用该方法，则创建并初始化此副本。
- protected  T initialValue()：返回此线程局部变量的当前线程的“初始值”。线程第一次使用 get() 方法访问变量时将调用此方法，但如果线程之前调用了 set(T) 方法，则不会对该线程再调用 initialValue 方法。通常，此方法对每个线程最多调用一次，但如果在调用 get() 后又调用了 remove()，则可能再次调用此方法。 如果程序员希望将线程局部变量初始化为 null 以外的某个值，则必须为 ThreadLocal 创建子类，并重写此方法。通常，将使用匿名内部类。initialValue 的典型实现将调用一个适当的构造方法，并返回新构造的对象。
- void remove()： 移除此线程局部变量当前线程的值。这可能有助于减少线程局部变量的存储需求。如果再次访问此线程局部变量，那么在默认情况下它将拥有其 initialValue。
- void set(T value)：设置此线程局部变量中当前线程副本中的值。许多应用程序不需要这项功能，它们只依赖于 initialValue() 方法来设置线程局部变量的值。

在程序中一般都重写initialValue方法，以给定一个特定的初始值。

示例：
```java
class Account {
	/* 定义一个ThreadLocal类型的变量，该变量将是一个线程局部变量
	每个线程都会保留该变量的一个副本 */
	private ThreadLocal&lt;String> name = new ThreadLocal&lt;>();
	// 定义一个初始化name成员变量的构造器
	public Account(String str) {
		this.name.set(str);
		// 下面代码用于访问当前线程的name副本的值
		System.out.println("---" + this.name.get());
	}
	// name的setter和getter方法
	public String getName() {
		return name.get();
	}
	public void setName(String str) {
		this.name.set(str);
	}
}

class MyTest extends Thread {
	// 定义一个Account类型的成员变量
	private Account account;
	public MyTest(Account account, String name) {
		super(name);
		this.account = account;
	}
	public void run() {
		// 循环10次
		for (int i = 0 ; i &lt; 10 ; i++) {
			// 当i == 6时输出将账户名替换成当前线程名
			if (i == 6) {
				account.setName(getName());
			}
			// 输出同一个账户的账户名和循环变量
			System.out.println(account.getName() + " 账户的i值：" + i);
		}
	}
}

public class ThreadLocalTest {
	public static void main(String[] args) {
		// 启动两条线程，两条线程共享同一个Account
		Account at = new Account("初始名");
		/*
		虽然两条线程共享同一个账户，即只有一个账户名
		但由于账户名是ThreadLocal类型的，所以每条线程
		都完全拥有各自的账户名副本，所以从i == 6之后，将看到两条
		线程访问同一个账户时看到不同的账户名。
		*/
		new MyTest(at , "线程甲").start();
		new MyTest(at , "线程乙").start ();
	}
}
```
对于多线程资源共享的问题，**同步机制采用了“以时间换空间”的方式，而ThreadLocal采用了“以空间换时间”的方式。前者仅提供一份变量，让不同的线程排队访问，而后者为每一个线程都提供了一份变量，因此可以同时访问而互不影响**。**若多个线程之间需要共享资源，以达到线程间的通信时，就使用同步机制；若仅仅需要隔离多线程之间的关系资源，则可以使用ThreadLocal**。

ThreadLocal在日常开发中使用到的地方较少，但是在某些特殊的场景下，通过ThreadLocal可以轻松实现一些看起来很复杂的功能。一般来说，当某些数据是以线程为作用域并且不同线程具有不同的数据副本的时候，就可以考虑使用ThreadLocal。例如在Handler和Looper中。对于Handler来说，它需要获取当前线程的Looper，很显然Looper的作用域就是线程并且不同的线程具有不同的Looper，这个时候通过ThreadLocal就可以轻松的实现Looper在线程中的存取。如果不采用ThreadLocal，那么系统就必须提供一个全局的哈希表供Handler查找指定的Looper，这样就比较麻烦了，还需要一个管理类。

ThreadLocal的另一个使用场景是复杂逻辑下的对象传递，比如监听器的传递，有些时候一个线程中的任务过于复杂，就可能表现为函数调用栈比较深以及代码入口的多样性，这种情况下，我们又需要监听器能够贯穿整个线程的执行过程。这个时候就可以使用到ThreadLocal，通过ThreadLocal可以让监听器作为线程内的全局对象存在，在线程内通过get方法就可以获取到监听器。如果不采用的话，可以使用参数传递，但是这种方式在设计上不是特别好，当调用栈很深的时候，通过参数来传递监听器这个设计太糟糕。而另外一种方式就是使用static静态变量的方式，但是这种方式存在一定的局限性，拓展性并不是特别的强。比如有10个线程在执行，就需要提供10个监听器对象。

###线程安全的集合

可以使用Collections工具类提供的类方法将线程不安全的集合包装成线程安全的集合，所用方法如下：

- static &lt;T> Collection&lt;T> synchronizedCollection(Collection&lt;T> c) ：返回指定 collection 支持的同步（线程安全的）collection；
- static &lt;T> List&lt;T>  synchronizedList(List&lt;T> list) ： 返回指定列表支持的同步（线程安全的）列表；
- static &lt;K,V> Map&lt;K,V>  synchronizedMap(Map&lt;K,V> m) ：返回由指定Map支持的同步（线程安全的）Map；
- static &lt;T> Set&lt;T>  synchronizedSet(Set&lt;T> s) ：返回指定 set 支持的同步（线程安全的）set；
- static &lt;K,V> SortedMap&lt;K,V>  synchronizedSortedMap(SortedMap&lt;K,V> m) ：返回指定有序Map支持的同步（线程安全的）有序Map；
- static &lt;T> SortedSet&lt;T> synchronizedSortedSet(SortedSet&lt;T> s) ：返回指定有序 set 支持的同步（线程安全的）有序 set；

如果需要把某个集合包装成线程安全的集合，则应该在创建之后立即包装，如：
```java
HashMap m = Collections.synchronizedMap(new HashMap());
```
**从Java5开始，在java.util.concurrent包下提供了大量支持高效并发操作的集合接口和实现类**：
![这里写图片描述](http://img.blog.csdn.net/20161224232603365?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvcm9zeV9kYXdu/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

![这里写图片描述](http://img.blog.csdn.net/20161224232616053?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvcm9zeV9kYXdu/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

**以Concurrent开头的集合类代表了支持并发访问的集合，它们支持多个线程并发写入访问，这些写入操作都是线程安全的，但读取不必锁定。这些集合采用复杂的算法保证不会锁住整个集合，因此在并发写入时有高效的性能。多个线程并发访问一个集合时，ConcurrentLinkedQueue是一个恰当的选择，它不允许使用null元素。默认情况下ConcurrentHashMap支持16个线程并发写入，超过16的线程可能需要等待，可以通过设置concurrencyLevel构造器参数（默认为16）来支持更多的线程并发访问**。Java8为ConcurrentHashMap增加了30多个新方法，主要如下：

- forEach系列（forEach、forEachKey、forEachValue、forEachEntry）；
- search系列（search、searchKeys、searchValues、searchEntries）；
- reduce系列（reduce、reduceToDouble、reduceToLong、reduceKeys、reduceValues）；
- 还有mappingCount()、newKeySet()等，增强后的ConcurrentHashMap更适合做缓存实现类使用。

CopyOnWriteArraySet底层封装了CopyOnWriteArrayList，因此两者实现机制类似。
**CopyOnWriteArrayList则是以复制底层数组的方法来使实现操作。当对CopyOnWriteArrayList读取时，无须加锁或阻塞，当执行写入操作时。该集合会在底层复制一份新的数组，接下来对新的数组执行写入操作，由于操作的是副本，故是线程安全的。但是写入操作需要频繁复制数组，性能较差，所以CopyOnWriteArrayList适合读取操作远大于写入操作的场景**。


