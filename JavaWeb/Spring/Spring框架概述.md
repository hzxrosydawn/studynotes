---
typora-root-url: appendix
typora-copy-images-to: appendix
---

## 简介

Spring 是个 Java 企业级应用的开源开发框架。Spring 主要用来开发 Java 应用，但 Spring 不仅仅局限于服务器端开发，任何 Java 应用都能在简单性、可测试性和松耦合等方面从 Spring 中获益。Spring 的目标是致力于全方位的简化 Java 开发，并通 过POJO 为基础的编程模型促进良好的编程习惯。

## 策略

为了降低 Java 开发的复杂性，Spring 采取了以下 4 种关键策略：

**一、基于 POJO 的轻量级和最小侵入性编程**。

虽然 Spring 用 bean 或者 JavaBean 来表示应用组件，但并不意味着 Spring 组件必须要遵循 JavaBean 规范。**一个Spring 组件可以是任何形式的 POJO。Spring 竭力避免因自身的 API 而弄乱你的应用代码。Spring 不会强迫你实现Spring 规范的接口或继承 Spring 规范的类，相反，在基于 Spring 构建的应用中，一个类的声明通常没有任何痕迹表明你使用了 Spring。最坏的场景是，一个类或许会使用 Spring 注解，但它依旧是 POJO**。Spring 的非侵入编程模型意味着这个类在 Spring 应用和非 Spring 应用中都可以发挥同样的作用。

**二、通过控制反转（又称依赖注入）和面向接口实现松耦合**。

按照传统的做法，每个对象负责管理与自己相互协作的对象（包括创建和获取它所依赖的对象）的引用，这将会导致高度耦合和难以测试的代码。而 Spring 中通过控制反转（Inversion of Control，IOC）的设计思想来降低这种耦合性。反转是指 IOC 中依赖对象的控制逻辑与传统程序设计相反。**传统程序设计中由我们自己在对象中主动去创建和组装依赖对象，而是在 IOC 思想中是由容器来负责创建和注入依赖对象** 。

![dependency injection](/dependency injection.png)

> 耦合具有两面性（two-headed beast）。一方面，紧密耦合的代码难以测试、难以复用、难以理解，并且典型地表现出“打地鼠”式的bug特性（修复一个bug，将会出现一个或者更多新的bug）。另一方面，一定程度的耦合又是**必须**的——完全没有耦合的代码什么也做不了。为了完成有实际意义的功能，不同的类必须以适当的方式进行交互。总而言之，耦合是必须的，但应当被小心谨慎地管理。

DI（Dependency Injection）依赖注入是控制反转从另一个角度的描述。由于控制反转概念比较模糊（字面上可以理解为反转控制逻辑，但没有说清楚反转哪些方面的控制），所以 2004 年大师级人物 Martin Fowler 在[其个人网站上](https://martinfowler.com/articles/injection.html#InversionOfControl)又给出了一个更具自解释性（self-explanatory）的名字：`依赖注入`，相对 IOC 而言，依赖注入明确描述了被注入对象通过 IOC 容器来装配进其依赖的对象。通过 DI，对象无需自行创建或管理它们的依赖关系，依赖关系将被自动注入到需要它们的对象当中去。Spring 采用自动装配、 XML 或 Java 代码来描述依赖关系。通过依赖关系的配置就可以在不改变所依赖的类的情况下，修改依赖关系。Spring 通过应用上下文（Application Context）装载 bean 的定义并把它们组装起来。Spring 应用上下文全权负责对象的创建和组装。

好处：解耦，使代码更加的整洁、清晰，易于测试。

**三、基于切面和惯例进行声明式编程**。DI 能够让相互协作的软件组件保持松耦合，而面向切面编程（Aspect-oriented programming，AOP）允许你**把遍布应用各处的功能分离出来形成可重用的组件**。

面向切面编程是面向对象编程的进一步提升，它往往被定义成**促使软件系统实现关注点的分离（separation of concerns）**的一种技术。系统由许多不同的组件组成，每一个组件各负责一块特定功能。**除了实现自身核心的功能之外，各个组件还经常承担着额外的职责**。诸如日志、事务管理和安全这些**融合到核心业务逻辑的系统服务**通常被称为**横切关注点（**cross-cutting concerns**）**，**因为它们会横跨系统的多个组件**。

如果这些关注点分散到多个组件中去将会给你的代码带来双重的复杂性：

- **实现系统关注点功能的代码将会重复出现在多个组件中。这意味着如果你要改变这些关注点的逻辑，必须修改各个模块中的相关实现。即使你把这些关注点抽象为一个独立的模块，其他模块只是调用它的方法，但方法的调用还是会重复出现在各个模块中**。
- **组件会因为那些与自身核心业务无关的代码而变得混乱。一个向地址簿增加地址条目的方法应该只关注如何添加地址，而不应该关注它是不是安全的或者是否需要支持事务**。


**AOP 能够使这些服务模块化，并以声明的方式将它们应用到它们需要影响的组件中去。所造成的结果就是这些组件会具有更高的内聚性并且会更加关注自身的业务，完全不需要了解涉及系统服务所带来复杂性。总之，AOP 能够确保POJO 的简单性**。

我们**可以把切面想象为覆盖在很多组件之上的一个外壳。应用是由那些实现各自业务功能的模块组成的。借助 AOP，可以使用各种功能层去包裹核心业务层**。这些**功能层以声明的方式灵活地应用到系统中，核心应用甚至根本不知道它们的存在**。这是一个非常强大的理念，可以实现安全、事务和日志等横切关注点与核心业务逻辑的分离。

![aopdemo](/aopdemo.png)

**通过切面和模板减少样板式代码**。**样板式代码（boilerplate code）就是那些为了执行某些操作而必须编写但又与业务逻辑无关的代码**。比如一条 SQL 操作需要建立数据库连接、创建 Statement、执行 SQL，关闭数据库连接、Statement 和结果集，还有捕获异常。但实际的业务代码只有执行SQL的部分，其余的都是样板式代码。**Spring 旨在通过模板封装来消除样板式代码**。比如，Spring 的 JdbcTemplate 使得执行数据库操作时，避免传统的 JDBC 样板代码成为了可能。

## Bean的管理

在Spring应用中，对象由Spring容器创建和装配，并存在容器之中。容器是Spring框架的核心。Spring容器使用DI管理应用中各组件之间的相互协作关系。毫无疑问，这些对象更简单干净，更易于理解，更易于重用并且更易于进行单元测试。Spring自带了多个容器实现，可以归为两种不同的类型。

- **bean工厂**（org.springframework.beans.factory.BeanFactory接口定义）是最简单的容器，提供基本的DI支持。
- **应用上下文**（org.springframework.context.ApplicationContext接口定义）基于BeanFactory构建，并提供应用框架级别的服务，例如从属性文件解析文本信息以及发布应用。事件给感兴趣的事件监听者。

虽然我们可以在bean工厂和应用上下文之间任选一种，但**bean工厂对大多数应用来说往往太低级了，因此，应用上下文要比bean工厂更受欢迎**。

Spring自带了多种类型的应用上下文。下面罗列的几个是你最有可能遇到的：

- **ClassPathXmlApplicationContext**：从**类路径下的一个或多个XML配置文件**中加载上下文定义，把应用上下文的定义文件作为类资源。
- **AnnotationConfigWebApplicationContext**：从**一个或多个基于Java的配置类**中加载Spring Web应用上下文。
- AnnotationConfigApplicationContext：从一个或多个基于Java的配置类中加载Spring应用上下文。
- FileSystemXmlApplicationcontext：从文件系统下的一个或多个XML配置文件中加载上下文定义。
- XmlWebApplicationContext：从Web应用下的一个或多个XML配置文件中加载上下文定义。

无论是从文件系统中装载应用上下文还是从类路径下装载应用上下文，将bean加载到bean工厂的过程都是相似的。这些类都可以向其构造器传入响应的参数来创建应用上下文。其中，ClassPathXmlApplicationContext 和 AnnotationConfigWebApplicationContext 是最常用的应用上下文，分别用于从类路径下加载XML文件和上下文的类的全限定类名。应用上下文准备就绪之后，我们就可以调用上下文的getBean()方法从Spring容器中获取bean。

在传统的Java应用中，bean的生命周期很简单。使用Java关键字new进行bean实例化，然后该bean就可以使用了。一旦该bean不再被使用，则由Java自动进行垃圾回收。相比之下，Spring容器中的bean的生命周期就显得相对复杂多了。下图展示了bean装载到Spring应用上下文中的一个典型的生命周期过程。

![bean lifecyle](/bean lifecyle.png)

在bean准备就绪之前，bean工厂执行了若干启动步骤：

1. Spring对bean进行实例化；
2. Spring将值和bean的引用注入到bean对应的属性中；
3. 如果bean实现了BeanNameAware接口，Spring将bean的ID传递给setBeanName()方法；
4. 如果bean实现了BeanFactoryAware接口，Spring将调用setBeanFactory()方法，将BeanFactory容器实例传入；
5. 如果bean实现了ApplicationContextAware接口，Spring将调用setApplicationContext()方法，将bean所在的应用上下文的引用传入进来；
6. 如果bean实现了BeanPostProcessor接口，Spring将调用它们的postProcessBeforeInitialization()方法；
7. 如果bean实现了InitializingBean接口，Spring将调用它们的afterPropertiesSet()方法。类似地，如果bean使用init-method声明了初始化方法，该方法也会被调用；
8. 如果bean实现了BeanPostProcessor接口，Spring将调用它们的post-ProcessAfterInitialization()方法；
9. 此时，bean已经准备就绪，可以被应用程序使用了，它们将一直驻留在应用上下文中，直到该应用上下文被销毁；
10. 如果bean实现了DisposableBean接口，Spring将调用它的destroy()接口方法。同样，如果bean使用destroy-method声明了销毁方法，该方法也会被调用。

容器是Spring框架最核心的部分，它管理着Spring应用中bean的创建、配置和管理。在该模块中，包括了Spring bean工厂，它为Spring提供了DI的功能。基于bean工厂，我们还会发现有多种Spring应用上下文的实现，每一种都提供了配置Spring的不同方式。除了bean工厂和应用上下文，该模块也提供了许多企业服务，例如E-mail、JNDI访问、EJB集成和调度。所有的Spring模块都构建于核心容器之上。当你配置应用时，其实你隐式地使用了这些类。





