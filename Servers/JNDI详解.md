---
typora-copy-images-to: appendix
typora-root-url: appendix
---

在介绍 JNDI 之前先来了解以下一些与 JDNI 相关的基本概念。

## Naming and Directory Concepts

### Naming Concepts

**命名服务（naming service）**是任何计算机系统的基础功能之一。命名服务可以通过**对象（objects）**的名称来找与这些**名称（name）**关联的对象。使用任何计算机程序或系统时总会命名一些对象。例如，当使用电子邮件系统时就必须提供接收者的名字，访问计算机上的某个文件就必须提供这个文件的名称。

![naming-system](/naming-system.gif)

命名服务的基本功能就是为对象映射出一些容易识别的名称，比如地址、识别码等。例如， [Internet Domain Name System (DNS)](http://www.ietf.org/rfc/rfc1034.txt) 为IP地址映射出一个机器的名称。

```
www.example.com ==> 192.0.2.5
```

文件系统为文件的引用映射出了一个文件名，程序就可以通过这个文件名来访问该文件的内容了。

```
c:\bin\autoexec.bat ==> File Reference
```

#### Names

要从**命名系统（naming system）**中查找一个对象，就必须要提供该对象的**名称（name）**。命名系统确定了名称所遵循的语法，这种语法有时称为命名系统的**命名约定（naming convention）**。名称通过由**组件分隔符（component Separator）**所分隔的一些**组件（component ）**来表示。

| Naming System    | Component Separator | Names                       |
| ---------------- | ------------------- | --------------------------- |
| UNIX file system | "/"                 | /usr/hello                  |
| DNS              | "."                 | sales.Wiz.COM               |
| LDAP             | "," and "="         | cn=Rosanna Lee, o=Sun, c=US |

UNIX 文件系统的命名约定为文件相对于根目录的路径，路径中的每个组件从左到右使用斜线“/”来分隔。UNIX  路径名 `/usr/hello` 命名了一个 `/usr` 目录下的一个名为 `hello` 的文件。

DNS 命名约定通过点号“.”来分隔 DNS 名称中的组件。DNS 名称 `sales.Wiz.COM` 使用名称  `sales` 相对于 DNS 入口 `Wiz.COM` 命名了一个 DNS 入口，DNS 入口 `Wiz.COM` 相对于入口 `COM` 命名了一个入口 `Wiz` 。 

 [Lightweight Directory Access Protocol (LDAP)](http://www.ietf.org/rfc/rfc2251.txt) 命名约定从右到左使用逗号“,”分隔排列组件。因此，LDAP 名称 `cn=Rosanna Lee, o=Sun, c=US` 命名了一个 LDAP 入口 `cn=Rosanna Lee` ，该入口相对于入口 `o=Sun` ，入口 `o=Sun` 又相对于入口  `c=US` 。LDAP 有进一步的规则限制：每个组件必须是一个等号“=”连接的 name/value 对。

#### Bindings

名称和对象的关联称为**绑定（binding）**。比如文件名和文件绑定，DNS 绑定了主机名称和 IP 地址，LDAP 名称绑定了 LDAP 入口。

#### References and Addresses

某些对象不能直接由命名服务来保存，也就是说这些对象的副本不能放到命名服务中，而是必须通过放在命名服务中的引用（reference）或指针（pointer）来保存。引用包含了**如何访问对象**的紧凑信息，而对象本身则可能包含更多的状态信息。通过引用与对象进行通讯可以获得更多的对象信息。例如，航班对象可能包含了航班的乘客、机组人员、飞行计划、燃油、仪表状态、航班号和出发时间，而航班对象的引用可能仅包含航班号和出发时间。航班对象的引用是航班对象信息的更紧凑表示。

尽管引用可包含任意信息，但引用一般指向用来访问对象的**地址**（或通信端点）。

#### Context

**上下文（Context）**是一组名称-对象。每个上下文都有一个相关的**命名约定**。上下文提供了返回对象的查找操作，也提供了名称绑定、解绑、列出已绑定的名称等操作。上下文中的一个名称也可以绑定到另一个拥有相同命名约定的上下文对象（也叫子上下文，subcontext）。

![Several examples of contexts, bound to subcontexts.](/context.gif)

UNIX 系统中的文件目录代表一个上下文，相对于某个文件目录而命名的另一个文件目录代表一个子上下文。比如 `/usr`  是一个上下文，而 `/usr/bin` 是一个 `/usr` 上下文的子上下文。DNS 域 `Sun.COM` 中的 `Sun` 是 `COM` 上下文的一个子上下文。LDAP 入口 `o=sun,c=us` 中的 `o=sun` 是 `c=us` 上下文的一个子上下文。

#### Naming Systems and Namespaces

**命名系统（naming system）**是包含了一组连贯的（connected ）具有相同类型（相同的命名约定）的上下文，并提供了一些常用的操作。实现了 DNS 的系统是一个命名系统，使用 LDAP 通信的系统也是一个命名系统。命名系统为其用户提供了命名服务来执行命名相关的操作。命名服务通过其接口来访问。DNS 提供了将主机名映射为 IP 地址的命名服务，LDAP 提供了将 LDAP 名称映射成 LDAP 入口的命名服务，文件系统提供了将文件名映射为文件和目录的命名服务。

**命名空间（namespace）**是一个命名系统中所有名称的集合。UNIX 文件系统有一个包含该文件系统中所有文件名和目录名的命名空间，DNS 命名空间包含了 DNS 域名和入口 ，LDAP 命名空间包含了 LDAP 入口的名称。

### Directory Concepts

许多命名服务都扩展成了**目录服务（directory service）**。目录服务将名称和其对象关联，也将对象和其**属性（attributes）**关联。

```shell
目录服务=命名服务+对象包含的属性
```

我们不仅可以通过查找名称来查找对象和对象的属性，也可以基于对象的属性来搜索相关对象。

![directory-system](/directory-system.gif)

计算机的目录服务代表了一个目录对象，该目录对象可以用来表示一个打印机、计算机、网络等。目录对象包含了其所表示对象的属性。

#### Attributes

目录对象可以拥有属性。例如，打印机可以通过一个包含其打印速度、分辨率、颜色等属性的目录对象来表示，用户可以通过一个包含邮箱、手机号、性别等属性的目录对象来表示。

一个属性由**属性标识器（attribute identifier）**和一组**属性值（attribute values）**构成。属性标识器是一个用来标识属性的记号。例如，两个不同的计算机帐号可能都有一个 `"mail"` 属性，`"mail"` 就是一个属性标识器。属性值就是属性的内容。比如，`"mail "` 属性的属性值可以为 `john.smith@example.com` 。

#### Directories and Directory Services

**目录**是一组连贯的（connected ）目录对象。目录服务提供了创建、添加、移除、修改目录中对象的属性操作。目录服务也通过其自身的接口来访问。以下为一些目录服务：

- Network Information Service (NIS)。NIS 是 UNIX 系统中一种目录服务，用来存储主机、网络、打印机和用户等系统相关信息；
- [Oracle Directory Server](http://www.oracle.com/technetwork/testcontent/index-085178.html)。Oracle Directory Server 是一种基于因特网标准 LDAP 的多用途目录服务。

#### Search Service

我们可以通过向目录服务提供目录的名称来访问相关的目录。许多目录（如基于 LDAP 的目录）也支持搜索（search）。可以通过一个包含逻辑表达式的查询（query）来进行搜索，逻辑表达式中可以包含目标对象具有的属性来作为搜索条件。目录服务执行指定的查询后就会返回满足查询条件的对象。

## Overview of JNDI

JNDI 是 Java Naming and Directory Interface 的缩写，是一种为应用提供命名和目录功能的 Java API。JNDI 独立于任何目录服务实现，所以新目录、合并目录、已部署目录都可以通过一种通用的方式访问。

#### Architecture

JNDI **架构（architecture ）**由一个 API 和一个服务提供接口（service provider interface, SPI）构成。SPI 可以透明地添加多种命名和目录服务，Java 应用通过 JNDI API 来访问其命名和目录服务。如下图所示。

![jndiarch](/jndiarch.gif)

####  Packaging

Java SE 平台已经包含了 JNDI。要使用 JNDI，你必须有 JNDI 类和一个或多个服务提供者。JDK 包括以下命名和目录服务的服务提供者：

- Lightweight Directory Access Protocol (LDAP)，即轻量级目录访问协议
- Common Object Request Broker Architecture (CORBA) Common Object Services (COS) name service，即公共对象请求代理体系架构
- Java Remote Method Invocation (RMI) Registry，即 Java 远程方法调用
- Domain Name Service (DNS)

JNDI 划分在五个包中：

- javax.naming
- javax.naming.directory
- javax.naming.ldap
- javax.naming.event
- javax.naming.spi

### Naming Package

 [`javax.naming`](https://docs.oracle.com/javase/8/docs/api/javax/naming/package-summary.html) 包含有访问命名服务的类和接口。

#### Context

`javax.naming` 包中定义了一个 [`Context`](https://docs.oracle.com/javase/8/docs/api/javax/naming/Context.html) 接口，该接口是查找、绑定/解绑、重命名对象、创建和销毁子上下文（subcontext）的核心接口。

- Lookup：最常用的操作就是 [`lookup()`](https://docs.oracle.com/javase/8/docs/api/javax/naming/Context.html#lookup-javax.naming.Name-)。向该方法传入一个对象名称，就会返回该名称绑定的对象。
- Bindings：[`listBindings()`](https://docs.oracle.com/javase/8/docs/api/javax/naming/Context.html#listBindings-javax.naming.Name-) 方法返回 name-to-object 的绑定枚举集合。绑定包含了所绑定对象的名称，对象的类名称，以及对象本身。
- List：[`list()`](https://docs.oracle.com/javase/8/docs/api/javax/naming/Context.html#list-javax.naming.Name-) 方法和 `listBindings()` 类似，只不过该方法返回一个包含了对象名称和对象类名称枚举集合，不包含对象本身。 `list()` 方法适用于仅想浏览对象信息而不想查看上下文中的所有实际对象。`listBindings()` 方法虽然也可以提供这些信息，但可能代价更高。
- Name：`Name` 是一个表示通用名称的接口 —— 一个包含零个或多个组件的有序序列。命名系统使用该接口来定义遵循其约定的名称。
- References：对象以不同方式存储在命名和目录服务中。对象引用可能是对象很简洁的表示。JNDI 定义了 [`Reference`](https://docs.oracle.com/javase/8/docs/api/javax/naming/Reference.html) 类来表示引用。引用包含了用于构造对象副本的信息。JNDI 尝试将从目录中找到的引用转换为其表示的 Java 对象，这样 JNDI 客户端就有一种错觉，以为存储在目录中的就是 Java 对象。

#### The Initial Context

在 JNDI 中，所有的命名和目录操作都是相对于上下文进行的。没有绝对的根路径。因此，JNDI 定义了一个 [`InitialContext`](https://docs.oracle.com/javase/8/docs/api/javax/naming/InitialContext.html) 类，该类提供了用于命名和目录操作的开始点。一旦有了 initial context，你就可以用它来查找其他上下文和对象。

#### Exceptions

JNDI 定义了一个异常的类继承体系，这些异常可以在执行命名和目录操作过程中抛出。该异常体系的根异常为 [`NamingException`](https://docs.oracle.com/javase/8/docs/api/javax/naming/NamingException.html) 。

### Directory and LDAP Packages



## Directory Package

The [`javax.naming.directory`](https://docs.oracle.com/javase/8/docs/api/javax/naming/directory/package-summary.html) package extends the [`javax.naming`](https://docs.oracle.com/javase/8/docs/api/javax/naming/package-summary.html) package to provide functionality for accessing directory services in addition to naming services. This package allows applications to retrieve associated with objects stored in the directory and to search for objects using specified attributes.

### The Directory Context

The [`DirContext`](https://docs.oracle.com/javase/8/docs/api/javax/naming/directory/DirContext.html) interface represents a *directory context*. `DirContext` also behaves as a naming context by extending the [`Context`](https://docs.oracle.com/javase/8/docs/api/javax/naming/Context.html) interface. This means that any directory object can also provide a naming context. It defines methods for examining and updating attributes associated with a directory entry.

- Attributes

  You use [`getAttributes()`](https://docs.oracle.com/javase/8/docs/api/javax/naming/directory/DirContext.html#getAttributes-javax.naming.Name-) method to retrieve the attributes associated with a directory entry (for which you supply the name). Attributes are modified using [`modifyAttributes()`](https://docs.oracle.com/javase/8/docs/api/javax/naming/directory/DirContext.html#modifyAttributes-javax.naming.Name-javax.naming.directory.ModificationItem:A-) method. You can add, replace, or remove attributes and/or attribute values using this operation.

- Searches

  `DirContext` contains methods for performing content based searching of the directory. In the simplest and most common form of usage, the application specifies a set of attributes possibly with specific values to match and submits this attribute set to the [`search()`](https://docs.oracle.com/javase/8/docs/api/javax/naming/directory/DirContext.html#search-javax.naming.Name-javax.naming.directory.Attributes-) method. Other overloaded forms of [`search()`](https://docs.oracle.com/javase/8/docs/api/javax/naming/directory/DirContext.html#search-javax.naming.Name-java.lang.String-javax.naming.directory.SearchControls-) support more sophisticated search filters.

## LDAP Package

The [`javax.naming.ldap`](https://docs.oracle.com/javase/8/docs/api/javax/naming/ldap/package-summary.html) package contains classes and interfaces for using features that are specific to the [LDAP v3](http://www.ietf.org/rfc/rfc2251.txt) that are not already covered by the more generic [`javax.naming.directory`](https://docs.oracle.com/javase/8/docs/api/javax/naming/directory/package-summary.html) package. In fact, most JNDI applications that use the LDAP will find the `javax.naming.directory`package sufficient and will not need to use the `javax.naming.ldap` package at all. This package is primarily for those applications that need to use "extended" operations, controls, or unsolicited notifications.

- "Extended" Operation

  In addition to specifying well defined operations such as search and modify, the [LDAP v3 (RFC 2251)](http://www.ietf.org/rfc/rfc2251.txt) specifies a way to transmit yet-to-be defined operations between the LDAP client and the server. These operations are called *"extended" operations*. An "extended" operation may be defined by a standards organization such as the Internet Engineering Task Force (IETF) or by a vendor.

- Controls

  The [LDAP v3](http://www.ietf.org/rfc/rfc2251.txt) allows any request or response to be augmented by yet-to-be defined modifiers, called *controls* . A control sent with a request is a *request control* and a control sent with a response is a *response control* . A control may be defined by a standards organization such as the IETF or by a vendor. Request controls and response controls are not necessarily paired, that is, there need not be a response control for each request control sent, and vice versa.

- Unsolicited Notifications

  In addition to the normal request/response style of interaction between the client and server, the [LDAP v3](http://www.ietf.org/rfc/rfc2251.txt) also specifies *unsolicited notifications*--messages that are sent from the server to the client asynchronously and not in response to any client request.

### The LDAP Context

The [`LdapContext`](https://docs.oracle.com/javase/8/docs/api/javax/naming/ldap/LdapContext.html) interface represents a *context* for performing "extended" operations, sending request controls, and receiving response controls. Examples of how to use these features are described in the JNDI Tutorial's [Controls and Extensions](https://docs.oracle.com/javase/jndi/tutorial/ldap/ext/index.html) lesson.

# Event and Service Provider Packages

## Event Package

The [`javax.naming.event`](https://docs.oracle.com/javase/8/docs/api/javax/naming/event/package-summary.html) package contains classes and interfaces for supporting event notification in naming and directory services. Event notification is described in detail in the [Event Notification](https://docs.oracle.com/javase/tutorial/jndi/overview/event.html) trail.

- Events

  A [`NamingEvent`](https://docs.oracle.com/javase/8/docs/api/javax/naming/event/NamingEvent.html) represents an event that is generated by a naming/directory service. The event contains a *type* that identifies the type of event. For example, event types are categorized into those that affect the namespace, such as "object added," and those that do not, such as "object changed."

- Listeners

  A [`NamingListener`](https://docs.oracle.com/javase/8/docs/api/javax/naming/event/NamingListener.html) is an object that listens for `NamingEvent`s. Each category of event type has a corresponding type of `NamingListener`. For example, a [`NamespaceChangeListener`](https://docs.oracle.com/javase/8/docs/api/javax/naming/event/NamespaceChangeListener.html) represents a listener interested in namespace change events and an [`ObjectChangeListener`](https://docs.oracle.com/javase/8/docs/api/javax/naming/event/ObjectChangeListener.html) represents a listener interested in object change events.

To receive event notifications, a listener must be registered with either an [`EventContext`](https://docs.oracle.com/javase/8/docs/api/javax/naming/event/EventContext.html) or an [`EventDirContext`](https://docs.oracle.com/javase/8/docs/api/javax/naming/event/EventDirContext.html). Once registered, the listener will receive event notifications when the corresponding changes occur in the naming/directory service. The details about Event Notification can be found in the [JNDI Tutorial](https://docs.oracle.com/javase/jndi/tutorial/beyond/event/index.html).

## Service Provider Package

The [`javax.naming.spi`](https://docs.oracle.com/javase/8/docs/api/javax/naming/spi/package-summary.html) package provides the means by which developers of different naming/directory service providers can develop and hook up their implementations so that the corresponding services are accessible from applications that use the JNDI.

- Plug-In Architecture

  The `javax.naming.spi` package allows different implementations to be plugged in dynamically. These implementations include those for the [initial context](https://docs.oracle.com/javase/tutorial/jndi/ops/index.html) and for contexts that can be reached from the initial context.

- Java Object Support

  The `javax.naming.spi` package supports implementors of [lookup](https://docs.oracle.com/javase/tutorial/jndi/ops/lookup.html) and related methods to return Java objects that are natural and intuitive for the Java programmer. For example, if you look up a printer name from the directory, then you likely would expect to get back a printer object on which to operate. This support is provided in the form of [object factories](https://docs.oracle.com/javase/tutorial/jndi/objects/index.html#OBJFAC).This package also provides support for doing the reverse. That is, implementors of [`Context.bind()`](https://docs.oracle.com/javase/8/docs/api/javax/naming/Context.html#bind-javax.naming.Name-java.lang.Object-) and related methods can accept Java objects and store the objects in a format acceptable to the underlying naming/directory service. This support is provided in the form of [state factories](https://docs.oracle.com/javase/tutorial/jndi/objects/index.html#STATEFAC).

- Multiple Naming Systems (Federation)

  JNDI operations allow applications to supply names that span multiple naming systems. In the process of completing an operation, one service provider might need to interact with another service provider, for example to pass on the operation to be continued in the next naming system. This package provides support for different providers to cooperate to complete JNDI operations.

The details about the Service Provider mechanism can be found in the [JNDI Tutorial](https://docs.oracle.com/javase/jndi/tutorial/provider/index.html).

# Software Setup

## Required Software

Following is a list of the software/systems that you need:

- [Java platform software](https://docs.oracle.com/javase/tutorial/jndi/software/index.html#JDK)
- [Service provider software](https://docs.oracle.com/javase/tutorial/jndi/software/index.html#PROVIDER)
- [Naming and directory server software](https://docs.oracle.com/javase/tutorial/jndi/software/index.html#SERVER)

------

### [Java Platform Software]()

JNDI is included in the Java SE Platform.

To run the applets, you can use any Java-compatible Web browser, such as Firefox, or Internet Explorer v5 or later. To ensure that your applets take full advantage of the latest features of the Java platform software, you can use the Java Plug-in with your Web browser.

### [Service Provider Software]()

The JNDI API is a generic API for accessing any naming or directory service. Actual access to a naming or directory service is enabled by plugging in a service provider under the JNDI. An overview of the JNDI architecture and the role of service providers is given in the [JNDI Overview](https://docs.oracle.com/javase/tutorial/jndi/overview/index.html) lesson.

A *service provider* is software that maps the JNDI API to actual calls to the naming or directory server. Typically, the roles of the service provider and that of the naming/directory server differ. In the terminology of client/server software, the JNDI and the service provider are the *client* (called the *JNDI client*) and the naming/directory server is the *server*.

Clients and servers may interact in many ways. In one common way, they use a network protocol so that the client and server can exist autonomously in a networked environment. The server typically supports many different clients, not only JNDI clients, provided that the clients conform to the specified protocol. The JNDI does not dictate any particular style of interaction between JNDI clients and servers. For example, at one extreme the client and server could be the same entity.

You need to obtain the classes for the service providers that you will be using. For example, if you plan to use the JNDI to access an LDAP directory server, then you would need software for an LDAP service provider.

The JDK comes with service providers for:

- Light Weight Directory Protocol (LDAP)
- CORBA Common Object Services naming (COS naming)
- RMI registry
- Domain Name Service (DNS)

If you are interested in other providers please check the [JNDI page](http://www.oracle.com/technetwork/java/jndi/index.html) for download information.

This tutorial uses only the LDAP Service provider. When using the LDAP service provider, you need either to set up your own server or to have access to an existing server, as explained next.

### [Naming and Directory Server Software]()

Once you have obtained the service provider software, you then need to set up or have access to a corresponding naming/directory server. Setting up a naming/directory server is typically the job of a network system administrator. Different vendors have different installation procedures for their naming/directory servers. Some require special machine privileges before the server can be installed. You should consult the naming/directory server software's installation instructions.

For the directory examples in this tutorial, you need access to an LDAP server. If you would like to take a quick tour of what LDAP is check out [here](http://en.wikipedia.org/wiki/LDAP). You can use any LDAP-compliant server of your choice. The Oracle Directory Server, which runs on many platforms, including Windows, is available for evaluation at: [Oracle Directory Server](http://www.oracle.com/technetwork/testcontent/index-085178.html).

You can also download free LDAP servers below:

- [OpenDS](http://opends.java.net/)
- [OpenLDAP](http://www.openldap.org/)
- [389 Directory Server](http://directory.fedoraproject.org/)
- [Apache Directory Server](http://directory.apache.org/)

A publicly accessible server is available at: ldap://ldap.openldap.org Naming Context: dc=OpenLDAP,dc=org

# LDAP Setup

Below are the steps involved in building a Java Application that accesses an LDAP Directory Server.

1. Install the [Java Platform](https://docs.oracle.com/javase/tutorial/jndi/software/content.html) Software.
2. Get the Directory Server software as discussed [earlier](https://docs.oracle.com/javase/tutorial/jndi/software/index.html#SERVER).
3. Configure the Directory Server with the desired schema. For using the examples in this tutorial a special [schema](https://docs.oracle.com/javase/tutorial/jndi/software/content.html#SCHEMA) needs to be configured on the server.
4. Populate the directory server with the desired content. For using the examples in this tutorial a special [content](https://docs.oracle.com/javase/tutorial/jndi/software/content.html#LDIF) needs to be populated on the server.
5. Write a JNDI application to access the Directory, compile and run it against the Directory Server to get your desired results. The JNDI examples are covered in the next [lesson](https://docs.oracle.com/javase/tutorial/jndi/ops/index.html).

The *first two* steps are covered in the previous section. The rest of this lesson discusses steps *three* and part of step *four*. The step *five* that involves writing a JNDI application is covered in the next lesson that shows how to write JNDI applications to perform various operations on the directory.

Once you've set up the directory, or have directed your program to communicate with an existing directory, what sort of information can you expect to find there?

The directory can be viewed as consisting of name-to-object bindings. That is, each object in the directory has a corresponding name. You can retrieve an object in the directory by looking up its name.

Also stored in the directory are attributes. An object in the directory, in addition to having a name, also has an optional set of attributes. You can ask the directory for an object's attributes, as well as ask it to search for an object that has certain attributes.

## [Step 3: Directory Schema]()

A schema specifies the types of objects that a directory may contain. This tutorial populates the directory with entries, some of which require special schema definitions. To accommodate these entries, you must first either turn off schema-checking in the server or add the schema files that accompany this tutorial to the server. Both of these tasks are typically performed by the directory server's administrator.

This tutorial comes with two schema files that must be installed:

- [`Schema for Java objects`](https://docs.oracle.com/javase/tutorial/jndi/software/config/java.schema)
- [`Schema for CORBA objects`](https://docs.oracle.com/javase/tutorial/jndi/software/config/corba.schema)

The format of these files is a formal description that possibly cannot be directly copied and pasted into server configuration files. Specifically, the attribute syntaxes are described in terms of [RFC 2252](http://www.ietf.org/rfc/rfc2252.txt).

Different directory servers have different ways of configuring their schema. This tutorial includes some tools for installing the Java and CORBA schemas on directory servers that permit their schemas to be modified via the LDAP. Following is a list of tasks the tools can perform.

1. [`Create Java Schema`](https://docs.oracle.com/javase/tutorial/jndi/software/config/CreateJavaSchema.java)
2. [`Create CORBA Schema`](https://docs.oracle.com/javase/tutorial/jndi/software/config/CreateCorbaSchema.java)

Follow the instructions in the accompanying [`README file`](https://docs.oracle.com/javase/tutorial/jndi/software/config/README-SCHEMA.TXT) to run these programs.

------

**Note: Windows Active Directory.** Active Directory manages its schema by using an internal format. To update the schema, you can use either the Active Directory Management Console snap-in, `ADSIEdit`, or the `CreateJavaSchema` utility, following the instructions for Active Directory.

------

## Step 4: Providing Directory Content for This Tutorial

In the examples of this trail, the results shown reflect how the LDAP directory has been set up using the configuration file ( [`tutorial.ldif`](https://docs.oracle.com/javase/tutorial/jndi/software/config/tutorial.ldif) ) that accompanies this tutorial. If you are using an existing server, or a server with a different setup, then you might see different results. Before you can load the configuration file ( [`tutorial.ldif`](https://docs.oracle.com/javase/tutorial/jndi/software/config/tutorial.ldif) ) into the directory server, you must follow the instructions for updating the server's schema or you can use *ldapadd* or *ldapmodify* command if available on your UNIX system.

For example, using ldapmodify you could do (by plugging in appropriate values for the hostname, administrator DN (-D option), and the password):

```
ldapmodify -a -c -v -h hostname -p 389\
        -D "cn=Administrator, cn=users, dc=xxx, dc=xxx"\
        -w passwd -f tutorial.ldif

```

------

**Installation Note: Access Control.** Different directory servers handle access control differently. Some examples in this tutorial perform updates to the directory. Also, the part of the namespace where you have installed the tutorial might have read access restrictions. Therefore, you need to take server-specific actions to make the directory readable and/or updatable in order for those examples to work. For the [Oracle Directory Server](http://www.oracle.com/technetwork/testcontent/index-085178.html) add the `aci` entry suggested in the [`sunds.aci.ldif`](https://docs.oracle.com/javase/tutorial/jndi/software/config/sunds.aci.ldif) file to the `dn: o=JNDITutorial` entry to make the entire directory readable and updatable. Alternatively, you may change the examples so that they authenticate to the directory. Details of how to do this are described in the [Security](https://docs.oracle.com/javase/tutorial/jndi/ldap/security.html) lesson.

**Installation Note: Namespace Setup.** The entries in the [`tutorial.ldif`](https://docs.oracle.com/javase/tutorial/jndi/software/config/tutorial.ldif) file use the distinguished name (DN) "o=JNDITutorial" for the root naming context. If you have not configured your directory server to have "o=JNDITutorial" as a root naming context, then your attempt to import `tutorial.ldif` will fail. The easiest way to get around this problem is to add the DN of an existing root naming context to each "dn:" line in the `tutorial.ldif` file. For example, if your server already has the root naming context "dc=imc,dc=org", then you should change the line

```
dn: o=JNDITutorial

```

to

```
dn: o=JNDITutorial, dc=imc, dc=org

```

Make this change for each line that begins with "dn:" in the file. Then, in all of the examples in this tutorial, wherever it uses "o=JNDITutorial", use "o=JNDITutorial,dc=imc,dc=org" instead.

**Installation Note: File Format.** Depending on the operating system platform that you are using, you might need to edit `tutorial.ldif` so that it contains the correct newline characters for that platform. For example, if you find that `tutorial.ldif` contains Windows-style newline characters (CRLF) and you are importing this file into a directory server that is running on a UNIX platform, then you need to edit the file and replace CRLF with LF. A symptom of this problem is that the directory server rejects all of the entries in `tutorial.ldif`.

**Installation Note: Windows Active Directory.**

1. The root naming context is not going to be "o=jnditutorial". It will be of the form "dc=x,dc=y,dc=z". You need to follow the previous **Namespace Setup** note.

2. Add the object classes and related attributes for the "inetOrgPerson" and "groupOfUniqueNames" object classes to the Active Directory schema by using the Active Directory Management Console snap-in, `ADSIEdit`. "groupOfUniqueNames" is defined in [RFC 2256](http://www.ietf.org/rfc/rfc2256.txt) , "inetOrgPerson" in[RFC 2798](http://www.ietf.org/rfc/rfc2798.txt).

3. Some of hierarchical relationships used by the tutorial are not allowed by default in Active Directory. To enable these relationships, add them by using the Active Directory Management Console snap-in,

    

   ADSIEdit

   .

   ```
   objectclass: organizationalUnit
   possible superiors: domainDNS
                       inetOrgPerson
                       organizaton
                       organizationalPerson
                       organizationalUnit
                       person
                       top

   objectclass: groupOfUniqueNames
   possible superiors: top

   objectclass: inetOrgPerson
   possible superiors: container
                       organizationalPerson
                       person
                       top

   ```

4. Delete one of the two "sn" attributes from the Mark Twain entry in `tutorial.ldif`. Active Directory defines "sn" to be a single-valued attribute, contrary to [RFC 2256](http://www.ietf.org/rfc/rfc2256.txt).

5. Use the

    

   ldifde

    

   command-line utility to load the modified

    

   tutorial.ldif

    

   file.

   ```
   # ldifde -i -v -k -f tutorial.ldif

   ```

6. Most of the examples assume that the directory has been set up to permit unauthenticated read and update access. Your Active Directory setup might not allow you to do that. See the **Access Control** installation note.

7. Reading an entry sometimes produces more attributes than are shown in the tutorial because Active Directory often returns some internal attributes.

8. Creation of entries might require the specification of additional Active Directory-specific attributes or the use of other object classes.

# Java Application Setup

To use the JNDI in your program, you need to set up its compilation and execution environments.

## Importing the JNDI Classes

Following are the JNDI packages:

- [`javax.naming`](https://docs.oracle.com/javase/8/docs/api/javax/naming/package-summary.html)
- [`javax.naming.directory`](https://docs.oracle.com/javase/8/docs/api/javax/naming/directory/package-summary.html)
- [`javax.naming.event`](https://docs.oracle.com/javase/8/docs/api/javax/naming/event/package-summary.html)
- [`javax.naming.ldap`](https://docs.oracle.com/javase/8/docs/api/javax/naming/ldap/package-summary.html)
- [`javax.naming.spi`](https://docs.oracle.com/javase/8/docs/api/javax/naming/spi/package-summary.html)

The examples in this trail use classes and interfaces from the first two packages. You need to import these two packages into your program or import individual classes and interfaces that you use. The following two lines import all of the classes and interfaces from the two packages `javax.naming` and `javax.naming.directory`.

```
import javax.naming.*;
import javax.naming.directory.*;

```

## Compilation Environment

To compile a program that uses the JNDI, you need access to the JNDI classes. The [Java SE 6](https://docs.oracle.com/javase/tutorial/jndi/software/package.html) already include the JNDI classes, so if you are using it you need not take further actions.

## Execution Environment

To run a program that uses the JNDI, you need access to the JNDI classes and classes for any service providers that the program uses. The [Java Runtime Environment (JRE) 6](https://docs.oracle.com/javase/tutorial/jndi/software/package.html) already includes the JNDI classes and service providers for LDAP, COS naming, the RMI registry and the DNS .

If you are using some other service providers, then you need to download and install their archive files in the *JAVA_HOME*`/jre/lib/ext` directory, where *JAVA_HOME* is the directory that contains the JRE. The [JNDI page](http://www.oracle.com/technetwork/java/jndi/index.html#download) lists some service providers. You may download these providers or use providers from other vendors.

# Naming and Directory Operations

You can use the JNDI to perform naming operations, including read operations and operations for updating the namespace. The following operations are described in this lesson:

- [Looking up an object](https://docs.oracle.com/javase/tutorial/jndi/ops/lookup.html)
- [Listing the contents of a context](https://docs.oracle.com/javase/tutorial/jndi/ops/list.html)
- [Adding, overwriting, and removing a binding](https://docs.oracle.com/javase/tutorial/jndi/ops/bind.html)
- [Renaming an object](https://docs.oracle.com/javase/tutorial/jndi/ops/rename.html)
- [Creating and destroying subcontexts](https://docs.oracle.com/javase/tutorial/jndi/ops/create.html)

## Configuration

Before performing any operation on a naming or directory service, you need to acquire an *initial context*--the starting point into the namespace. This is because all methods on naming and directory services are performed relative to some context. To get an initial context, you must follow these steps.

1. Select the service provider of the corresponding service you want to access.
2. Specify any configuration that the initial context needs.
3. Call the [`InitialContext`](https://docs.oracle.com/javase/8/docs/api/javax/naming/InitialContext.html#constructor_detail) constructor.

## Step1: Select the Service Provider for the Initial Context

You can specify the service provider to use for the initial context by creating a set of *environment properties* (a `Hashtable`) and adding the name of the service provider class to it. Environment properties are described in detail in the [JNDI Tutorial](https://docs.oracle.com/javase/jndi/tutorial/beyond/env/index.html).

If you are using the LDAP service provider included in the JDK, then your code would look like the following.

```
Hashtable<String, Object> env = new Hashtable<String, Object>();
env.put(Context.INITIAL_CONTEXT_FACTORY, 
        "com.sun.jndi.ldap.LdapCtxFactory");

```

To specify the file system service provider in the JDK, you would write code that looks like the following.

```
Hashtable<String, Object> env = new Hashtable>String, Object>();
env.put(Context.INITIAL_CONTEXT_FACTORY, 
        "com.sun.jndi.fscontext.RefFSContextFactory");

```

You can also use *system properties* to specify the service provider to use. Check out the [JNDI Tutorial](https://docs.oracle.com/javase/jndi/tutorial/beyond/index.html) for details.

## Step2: Supply the Information Needed by the Initial Context

Clients of different directories might need various information for contacting the directory. For example, you might need to specify on which machine the server is running and what information is needed to identify the user to the directory. Such information is passed to the service provider via environment properties. The JNDI specifies some generic environment properties that service providers can use. Your service provider documentation will give details on the information required for these properties.

The LDAP provider requires that the program specify the location of the LDAP server, as well as user identity information. To provide this information, you would write code that looks as follows.

```
env.put(Context.PROVIDER_URL, "ldap://ldap.wiz.com:389");
env.put(Context.SECURITY_PRINCIPAL, "joeuser");
env.put(Context.SECURITY_CREDENTIALS, "joepassword");

```

This tutorial uses the LDAP service provider in the JDK. The examples assume that a server has been set up on the local machine at port 389 with the root-distinguished name of `"o=JNDITutorial"` and that no authentication is required for updating the directory. They include the following code for setting up the environment.

```
env.put(Context.PROVIDER_URL, "ldap://localhost:389/o=JNDITutorial");

```

If you are using a directory that is set up differently, then you will need to set up these environment properties accordingly. You will need to replace `"localhost"` with the name of that machine. You can run these examples against any [public directory servers](https://docs.oracle.com/javase/tutorial/jndi/software/index.html) or your own server running on a different machine. You will need to replace `"localhost"` with the name of that machine and replace `o=JNDITutorial` with the naming context that is available.

## Step3: Creating the Initial Context

You are now ready to create the initial context. To do that, you pass to the [`InitialContext` constructor](https://docs.oracle.com/javase/8/docs/api/javax/naming/InitialContext.html#constructor_detail) the environment properties that you created previously:

```
Context ctx = new InitialContext(env);

```

Now that you have a reference to a [`Context`](https://docs.oracle.com/javase/8/docs/api/javax/naming/Context.html) object, you can begin to access the naming service.

To perform directory operations, you need to use an [`InitialDirContext`](https://docs.oracle.com/javase/8/docs/api/javax/naming/directory/InitialDirContext.html). To do that, use one of its [constructors](https://docs.oracle.com/javase/8/docs/api/javax/naming/directory/InitialDirContext.html#constructor_detail):

```
DirContext ctx = new InitialDirContext(env);

```

This statement returns a reference to a [`DirContext`](https://docs.oracle.com/javase/8/docs/api/javax/naming/directory/DirContext.html) object for performing directory operations.

# Naming Exceptions

Many methods in the JNDI packages throw a [`NamingException`](https://docs.oracle.com/javase/8/docs/api/javax/naming/NamingException.html) when they need to indicate that the operation requested cannot be performed. Commonly, you will see a `try/catch` wrapper around the methods that can throw a `NamingException`:

```
try {
    Context ctx = new InitialContext();
    Object obj = ctx.lookup("somename");
} catch (NamingException e) {
    // Handle the error
    System.err.println(e);
}

```

## Exception Class Hierarchy

The JNDI has a rich exception hierarchy stemming from the `NamingException` class. The class names of the exceptions are self-explanatory and are listed [here](https://docs.oracle.com/javase/8/docs/api/javax/naming/package-tree.html).

To handle a particular subclass of `NamingException` specially, you catch the subclass separately. For example, the following code specially treats the `AuthenticationException` and its subclasses.

```
try {
    Context ctx = new InitialContext();
    Object obj = ctx.lookup("somename");
} catch (AuthenticationException e) {
    // attempt to reacquire the authentication information
    ...
} catch (NamingException e) {
    // Handle the error
    System.err.println(e);
}

```

## Enumerations

Operations such as [`Context.list()`](https://docs.oracle.com/javase/8/docs/api/javax/naming/Context.html#list-javax.naming.Name-) and [`DirContext.search()`](https://docs.oracle.com/javase/8/docs/api/javax/naming/directory/DirContext.html#search-javax.naming.Name-java.lang.String-javax.naming.directory.SearchControls-) return a [`NamingEnumeration`](https://docs.oracle.com/javase/8/docs/api/javax/naming/NamingEnumeration.html). In these cases, if an error occurs and no results are returned, then `NamingException` or one of its appropriate subclasses will be thrown at the time that the method is invoked. If an error occurs but there are some results to be returned, then a `NamingEnumeration` is returned so that you can get those results. When all of the results are exhausted, invoking [`NamingEnumeration.hasMore()`](https://docs.oracle.com/javase/8/docs/api/javax/naming/NamingEnumeration.html#hasMore--) will cause a `NamingException` (or one of its subclasses) to be thrown to indicate the error. At that point, the enumeration becomes invalid and no more methods should be invoked on it.

For example, if you perform a `search()` and specify a count limit (*n*) of how many answers to return, then the `search()` will return an enumeration consisting of at most *n* results. If the number of results exceeds *n*, then when `NamingEnumeration.hasMore()` is invoked for the *n+1* time, a `SizeLimitExceededException` will be thrown. See the [Result Count](https://docs.oracle.com/javase/tutorial/jndi/ops/countlimit.html) of this lesson for a sample code.

## Examples in This Tutorial

In the inline sample code that is embedded within the text of this tutorial, the `try/catch` clauses are usually omitted for the sake of readability. Typically, because only code fragments are shown here, only the lines that are directly useful in illustrating a concept are included. You will see appropriate placements of the `try/catch` clauses for `NamingException` if you look in the source files that accompany this tutorial.

The Exceptions in the javax.naming package can be found [here](https://docs.oracle.com/javase/8/docs/api/javax/naming/package-summary.html).

# Lookup an Object

To look up an object from the naming service, use [`Context.lookup()`](https://docs.oracle.com/javase/8/docs/api/javax/naming/Context.html#lookup-javax.naming.Name-) and pass it the name of the object that you want to retrieve. Suppose that there is an object in the naming service with the name `cn=Rosanna Lee,ou=People`. To retrieve the object, you would write

```
Object obj = ctx.lookup("cn=Rosanna Lee,ou=People");

```

The type of object that is returned by `lookup()` depends both on the underlying naming system and on the data associated with the object itself. A naming system can contain many different types of objects, and a lookup of an object in different parts of the system might yield objects of different types. In this example, `"cn=Rosanna Lee,ou=People"` happens to be bound to a context object (`javax.naming.ldap.LdapContext`). You can cast the result of `lookup()` to its target class.

For example, the following code looks up the object `"cn=Rosanna Lee,ou=People"` and casts it to `LdapContext`.

```
import javax.naming.ldap.LdapContext;
...
LdapContext ctx = (LdapContext) ctx.lookup("cn=Rosanna Lee,ou=People");

```

The complete example is in the file [`Lookup.java`](https://docs.oracle.com/javase/tutorial/jndi/ops/examples/Lookup.java).

![Diagram of Lookup example](https://docs.oracle.com/javase/tutorial/figures/jndi/lookup.gif)

There are two new static methods available in Java SE 6 to lookup a name:

- [`InitialContext.doLookup(Name name)`](https://docs.oracle.com/javase/8/docs/api/javax/naming/InitialContext.html#doLookup-javax.naming.Name-)
- [`InitialContext.doLookup(String name)`](https://docs.oracle.com/javase/8/docs/api/javax/naming/InitialContext.html#doLookup-java.lang.String-)

These methods provide a shortcut way of looking up a name without instantiating an InitialContext.

# List the Context

Instead of getting a single object at a time, as with [`Context.lookup()`](https://docs.oracle.com/javase/8/docs/api/javax/naming/Context.html#lookup-javax.naming.Name-) , you can list an entire context by using a single operation. There are two methods for listing a context: one that returns the bindings and one that returns only the name-to-object class name pairs.

## The Context.List() Method

[`Context.list()`](https://docs.oracle.com/javase/8/docs/api/javax/naming/Context.html#list-javax.naming.Name-) returns an enumeration of [`NameClassPair`](https://docs.oracle.com/javase/8/docs/api/javax/naming/NameClassPair.html). Each `NameClassPair` consists of the object's name and its class name. The following code fragment lists the contents of the `"ou=People"` directory (i.e., the files and directories found in `"ou=People"` directory).

```
NamingEnumeration list = ctx.list("ou=People");

while (list.hasMore()) {
    NameClassPair nc = (NameClassPair)list.next();
    System.out.println(nc);
}

```

Running [`this example`](https://docs.oracle.com/javase/tutorial/jndi/ops/examples/List.java) yields the following output.

```
# java List
cn=Jon Ruiz: javax.naming.directory.DirContext
cn=Scott Seligman: javax.naming.directory.DirContext
cn=Samuel Clemens: javax.naming.directory.DirContext
cn=Rosanna Lee: javax.naming.directory.DirContext
cn=Maxine Erlund: javax.naming.directory.DirContext
cn=Niels Bohr: javax.naming.directory.DirContext
cn=Uri Geller: javax.naming.directory.DirContext
cn=Colleen Sullivan: javax.naming.directory.DirContext
cn=Vinnie Ryan: javax.naming.directory.DirContext
cn=Rod Serling: javax.naming.directory.DirContext
cn=Jonathan Wood: javax.naming.directory.DirContext
cn=Aravindan Ranganathan: javax.naming.directory.DirContext
cn=Ian Anderson: javax.naming.directory.DirContext
cn=Lao Tzu: javax.naming.directory.DirContext
cn=Don Knuth: javax.naming.directory.DirContext
cn=Roger Waters: javax.naming.directory.DirContext
cn=Ben Dubin: javax.naming.directory.DirContext
cn=Spuds Mackenzie: javax.naming.directory.DirContext
cn=John Fowler: javax.naming.directory.DirContext
cn=Londo Mollari: javax.naming.directory.DirContext
cn=Ted Geisel: javax.naming.directory.DirContext

```

## The Context.listBindings() Method

[`Context.listBindings()`](https://docs.oracle.com/javase/8/docs/api/javax/naming/Context.html#listBindings-javax.naming.Name-) returns an enumeration of [`Binding`](https://docs.oracle.com/javase/8/docs/api/javax/naming/Binding.html). `Binding` is a subclass of `NameClassPair`. A binding contains not only the object's name and class name, but also the object. The following code enumerates the `"ou=People"` context, printing out each binding's name and object.

```
NamingEnumeration bindings = ctx.listBindings("ou=People");

while (bindings.hasMore()) {
    Binding bd = (Binding)bindings.next();
    System.out.println(bd.getName() + ": " + bd.getObject());
}

```

Running [`this example`](https://docs.oracle.com/javase/tutorial/jndi/ops/examples/ListBindings.java) yields the following output.

```
# java ListBindings
cn=Jon Ruiz: com.sun.jndi.ldap.LdapCtx@1d4c61c
cn=Scott Seligman: com.sun.jndi.ldap.LdapCtx@1a626f
cn=Samuel Clemens: com.sun.jndi.ldap.LdapCtx@34a1fc
cn=Rosanna Lee: com.sun.jndi.ldap.LdapCtx@176c74b
cn=Maxine Erlund: com.sun.jndi.ldap.LdapCtx@11b9fb1
cn=Niels Bohr: com.sun.jndi.ldap.LdapCtx@913fe2
cn=Uri Geller: com.sun.jndi.ldap.LdapCtx@12558d6
cn=Colleen Sullivan: com.sun.jndi.ldap.LdapCtx@eb7859
cn=Vinnie Ryan: com.sun.jndi.ldap.LdapCtx@12a54f9
cn=Rod Serling: com.sun.jndi.ldap.LdapCtx@30e280
cn=Jonathan Wood: com.sun.jndi.ldap.LdapCtx@16672d6
cn=Aravindan Ranganathan: com.sun.jndi.ldap.LdapCtx@fd54d6
cn=Ian Anderson: com.sun.jndi.ldap.LdapCtx@1415de6
cn=Lao Tzu: com.sun.jndi.ldap.LdapCtx@7bd9f2
cn=Don Knuth: com.sun.jndi.ldap.LdapCtx@121cc40
cn=Roger Waters: com.sun.jndi.ldap.LdapCtx@443226
cn=Ben Dubin: com.sun.jndi.ldap.LdapCtx@1386000
cn=Spuds Mackenzie: com.sun.jndi.ldap.LdapCtx@26d4f1
cn=John Fowler: com.sun.jndi.ldap.LdapCtx@1662dc8
cn=Londo Mollari: com.sun.jndi.ldap.LdapCtx@147c5fc
cn=Ted Geisel: com.sun.jndi.ldap.LdapCtx@3eca90

```

## [Terminating a NamingEnumeration]()

A [`NamingEnumeration`](https://docs.oracle.com/javase/8/docs/api/javax/naming/NamingEnumeration.html) can be terminated in one of three ways: naturally, explicitly, or unexpectedly.

- When [`NamingEnumeration.hasMore()`](https://docs.oracle.com/javase/8/docs/api/javax/naming/NamingEnumeration.html#hasMore--) returns `false`, the enumeration is complete and effectively terminated.
- You can terminate an enumeration explicitly before it has completed by invoking [`NamingEnumeration.close()`](https://docs.oracle.com/javase/8/docs/api/javax/naming/NamingEnumeration.html#close--). Doing this provides a hint to the underlying implementation to free up any resources associated with the enumeration.
- If either `hasMore()` or [`next()`](https://docs.oracle.com/javase/8/docs/api/javax/naming/NamingEnumeration.html#next--) throws a [`NamingException`](https://docs.oracle.com/javase/8/docs/api/javax/naming/NamingException.html), then the enumeration is effectively terminated.

Regardless of how an enumeration has been terminated, once terminated it can no longer be used. Invoking a method on a terminated enumeration yields an undefined result.

## Why Two Different List Methods?

`list()` is intended for browser-style applications that just want to display the names of objects in a context. For example, a browser might list the names in a context and wait for the user to select one or a few of the names displayed to perform further operations. Such applications typically do not need access to all of the objects in a context.

`listBindings()` is intended for applications that need to perform operations on the objects in a context en masse. For example, a backup application might need to perform "file stats" operations on all of the objects in a file directory. Or a printer administration program might want to restart all of the printers in a building. To perform such operations, these applications need to obtain all of the objects bound in a context. Thus it is more expedient to have the objects returned as part of the enumeration.

The application can use either `list()` or the potentially more expensive `listBindings()`, depending on the type of information it needs.

# Add, Replace or Remove a Binding

The `Context` interface contains methods for [adding](https://docs.oracle.com/javase/tutorial/jndi/ops/bind.html#BIND), [replacing](https://docs.oracle.com/javase/tutorial/jndi/ops/bind.html#REBIND), and [removing](https://docs.oracle.com/javase/tutorial/jndi/ops/bind.html#UNBIND) a binding in a context.

## [Adding a Binding]()

[`Context.bind()`](https://docs.oracle.com/javase/8/docs/api/javax/naming/Context.html#bind-javax.naming.Name-java.lang.Object-) is used to add a binding to a context. It accepts as arguments the name of the object and the object to be bound.

------

**Before you go on:** The examples in this lesson require that you make additions to the schema. You must either turn off schema-checking in the LDAP server or add [`the schema`](https://docs.oracle.com/javase/tutorial/jndi/software/config/java.schema) that accompanies this tutorial to the server. Both of these tasks are typically performed by the directory server's administrator. See the [LDAP Setup](https://docs.oracle.com/javase/tutorial/jndi/software/content.html)lesson.

------

```
// Create the object to be bound
Fruit fruit = new Fruit("orange");

// Perform the bind
ctx.bind("cn=Favorite Fruit", fruit);

```

[`This example`](https://docs.oracle.com/javase/tutorial/jndi/ops/examples/Bind.java) creates an object of class [`Fruit`](https://docs.oracle.com/javase/tutorial/jndi/ops/examples/Fruit.java) and binds it to the name `"cn=Favorite Fruit"` in the context `ctx`. If you subsequently looked up the name `"cn=Favorite Fruit"` in `ctx`, then you would get the `fruit` object. Note that to compile the `Fruit` class, you need the [`FruitFactory`](https://docs.oracle.com/javase/tutorial/jndi/ops/examples/FruitFactory.java) class.

If you were to run this example twice, then the second attempt would fail with a [`NameAlreadyBoundException`](https://docs.oracle.com/javase/8/docs/api/javax/naming/NameAlreadyBoundException.html). This is because the name `"cn=Favorite Fruit"` is already bound. For the second attempt to succeed, you would have to use [`rebind()`](https://docs.oracle.com/javase/8/docs/api/javax/naming/Context.html#rebind-javax.naming.Name-java.lang.Object-).

## [Adding or Replacing a Binding]()

`rebind()` is used to add or replace a binding. It accepts the same arguments as `bind()`, but the semantics are such that if the name is already bound, then it will be unbound and the newly given object will be bound.

```
// Create the object to be bound
Fruit fruit = new Fruit("lemon");

// Perform the bind
ctx.rebind("cn=Favorite Fruit", fruit);

```

When you run [`this example`](https://docs.oracle.com/javase/tutorial/jndi/ops/examples/Rebind.java), it will replace the binding created by the [`bind()`](https://docs.oracle.com/javase/tutorial/jndi/ops/examples/Bind.java) example.

![The binding to lemon is being replaced by a bind to orange.](https://docs.oracle.com/javase/tutorial/figures/jndi/rebind.gif)

## [Removing a Binding]()

To remove a binding, you use [`unbind()`](https://docs.oracle.com/javase/8/docs/api/javax/naming/Context.html#unbind-javax.naming.Name-).

```
// Remove the binding
ctx.unbind("cn=Favorite Fruit");

```

[`This example`](https://docs.oracle.com/javase/tutorial/jndi/ops/examples/Unbind.java), when run, removes the binding that was created by the [`bind()`](https://docs.oracle.com/javase/tutorial/jndi/ops/examples/Bind.java) or [`rebind()`](https://docs.oracle.com/javase/tutorial/jndi/ops/examples/Rebind.java) example.

# Rename

You can rename an object in a context by using [`Context.rename()`](https://docs.oracle.com/javase/8/docs/api/javax/naming/Context.html#rename-javax.naming.Name-javax.naming.Name-).

```
// Rename to Scott S
ctx.rename("cn=Scott Seligman", "cn=Scott S");

```

![Renaming an object](https://docs.oracle.com/javase/tutorial/figures/jndi/rename-leaf.gif)

[`This example`](https://docs.oracle.com/javase/tutorial/jndi/ops/examples/Rename.java) renames the object that was bound to `"cn=Scott Seligman"` to `"cn=Scott S"`. After verifying that the object got renamed, the program renames it to its original name (`"cn=Scott Seligman"`), as follows.

```
// Rename back to Scott Seligman
ctx.rename("cn=Scott S", "cn=Scott Seligman");

```

For more examples on renaming of LDAP entries check out the [Advanced Topics for LDAP users](https://docs.oracle.com/javase/tutorial/jndi/ldap/rename.html) lesson.

# Create and Destroy Subcontexts

The `Context` interface contains methods for [creating](https://docs.oracle.com/javase/tutorial/jndi/ops/create.html#CREATE) and [destroying](https://docs.oracle.com/javase/tutorial/jndi/ops/create.html#DESTROY) a *subcontext*, a context that is bound in another context of the same type.

The example described here use an object that has *attributes* and create a subcontext in the directory. You can use these `DirContext` methods to associate attributes with the object at the time that the binding or subcontext is added to the namespace. For example, you might create a `Person`object and bind it to the namespace and at the same time associate attributes about that `Person` object. The naming equivalent will have no attributes.

The createSubcontext() differs from bind() in that it creates a new Object i.e a new Context to be bound to the directory while as bind() binds the given Object in the directory.

## [Creating a Context]()

To create a naming context, you supply to [`createSubcontext()`](https://docs.oracle.com/javase/8/docs/api/javax/naming/Context.html#createSubcontext-javax.naming.Name-) the name of the context that you want to create. To create a context that has attributes, you supply to [`DirContext.createSubcontext()`](https://docs.oracle.com/javase/8/docs/api/javax/naming/directory/DirContext.html#createSubcontext-javax.naming.Name-javax.naming.directory.Attributes-) the name of the context that you want to create and its attributes.

------

**Before you go on:** The examples in this lesson require that you make additions to the schema. You must either turn off schema-checking in the LDAP server or add [`the schema`](https://docs.oracle.com/javase/tutorial/jndi/software/config/java.schema) that accompanies this tutorial to the server. Both of these tasks are typically performed by the directory server's administrator. See the [LDAP Setup](https://docs.oracle.com/javase/tutorial/jndi/software/content.html) lesson.

------

```
// Create attributes to be associated with the new context
Attributes attrs = new BasicAttributes(true); // case-ignore
Attribute objclass = new BasicAttribute("objectclass");
objclass.add("top");
objclass.add("organizationalUnit");
attrs.put(objclass);

// Create the context
Context result = ctx.createSubcontext("NewOu", attrs);

```

[`This example`](https://docs.oracle.com/javase/tutorial/jndi/ops/examples/Create.java) creates a new context called `"ou=NewOu"` that has an attribute `"objectclass"` with two values, `"top"` and `"organizationalUnit"`, in the context `ctx`.

```
# java Create
ou=Groups: javax.naming.directory.DirContext
ou=People: javax.naming.directory.DirContext
ou=NewOu: javax.naming.directory.DirContext

```

[`This example`](https://docs.oracle.com/javase/tutorial/jndi/ops/examples/Create.java) creates a new context, called `"NewOu"`, that is a child of `ctx`.

![Diagram shows new subcontext.](https://docs.oracle.com/javase/tutorial/figures/jndi/create.gif)

## [Destroying a Context]()

To destroy a context, you supply to [`destroySubcontext()`](https://docs.oracle.com/javase/8/docs/api/javax/naming/Context.html#destroySubcontext-javax.naming.Name-) the name of the context to destroy.

```
// Destroy the context
ctx.destroySubcontext("NewOu");

```

[`This example`](https://docs.oracle.com/javase/tutorial/jndi/ops/examples/Destroy.java) destroys the context `"NewOu"` in the context `ctx`.

# Attribute Names

An attribute consists of an *attribute identifier* and a set of *attribute values*. The *attribute identifier*, also called *attribute name*, is a string that identifies an attribute. An *attribute value* is the content of the attribute and its type is not restricted to that of string. You use an attribute name when you want to specify a particular attribute for either retrieval, searches, or modification. Names are also returned by operations that return attributes (such as when you perform reads or searches in the directory).

When using attribute names, you need to be aware of certain directory server features so that you won't be surprised by the result. These features are described in the next subsections.

## Attribute Type

In directories such as the LDAP, the attribute's name identifies the attribute's type and is often called the *attribute type name*. For example, the attribute name `"cn"` is also called the attribute type name. An attribute's type definition specifies the syntax that the attribute's value is to have, whether it can have multiple values, and equality and ordering rules to use when performing comparison and ordering operations on the attribute's values.

## Attribute Subclassing

Some directory implementations support *attribute subclassing*, in which the server allows attribute types to be defined in terms of other attribute types. For example, a `"name"` attribute might be the superclass of all name-related attributes: `"commonName"` might be a subclass of `"name"`. For directory implementations that support this, asking for the `"name"` attribute might return the `"commonName"` attribute.

When accessing directories that support attribute subclassing, you have to be aware that the server might return attributes that have names different from those that you requested. To minimize the chance of this, use the most derived subclass.

## Attribute Name Synonyms

Some directory implementations support synonyms for attribute names. For example, `"cn"` might be a synonym for `"commonName"`. Thus a request for the `"cn"` attribute might return the `"commonName"` attribute.

When accessing directories that support synonyms for attribute names, you must be aware that the server might return attributes that have names different from those you requested. To help prevent this from happening, use the canonical attribute name instead of one of its synonyms. The *canonical attribute name* is the name used in the attribute's definition; a synonym is the name that refers to the canonical attribute name in its definition.

## Language Preferences

An extension to the LDAP v3 ( [RFC 2596](http://www.ietf.org/rfc/rfc2596.txt)) allows you to specify a language code along with an attribute name. This resembles attribute subclassing in that one attribute name can represent several different attributes. An example is a `"description"` attribute that has two language variations:

```
description: software
description;lang-en: software products
description;lang-de: Softwareprodukte

```

A request for the `"description"` attribute would return all three attributes.

When accessing directories that support this feature, you must be aware that the server might return attributes that have names different from those that you requested.

# Read Attributes

To read the attributes of an object from the directory, use [`DirContext.getAttributes()`](https://docs.oracle.com/javase/8/docs/api/javax/naming/directory/DirContext.html#getAttributes-javax.naming.Name-) and pass it the name of the object for which you want the attributes. Suppose that an object in the naming service has the name `"cn=Ted Geisel, ou=People"`. To retrieve this object's attributes, you'll need[`code`](https://docs.oracle.com/javase/tutorial/jndi/ops/examples/GetAllAttrs.java) that looks like this:

```
Attributes answer = ctx.getAttributes("cn=Ted Geisel, ou=People");

```

You can then print the contents of this answer as follows.

```
for (NamingEnumeration ae = answer.getAll(); ae.hasMore();) {
    Attribute attr = (Attribute)ae.next();
    System.out.println("attribute: " + attr.getID());
    /* Print each value */
    for (NamingEnumeration e = attr.getAll(); e.hasMore();
         System.out.println("value: " + e.next()))
        ;
}

```

This produces the following output.

```
# java GetattrsAll
attribute: sn
value: Geisel
attribute: objectclass
value: top
value: person
value: organizationalPerson
value: inetOrgPerson
attribute: jpegphoto
value: [B@1dacd78b
attribute: mail
value: Ted.Geisel@JNDITutorial.example.com
attribute: facsimiletelephonenumber
value: +1 408 555 2329
attribute: telephonenumber
value: +1 408 555 5252
attribute: cn
value: Ted Geisel

```

## Returning Selected Attributes

To read a selective subset of attributes, you supply an array of strings that are attribute identifiers of the attributes that you want to retrieve.

```
// Specify the ids of the attributes to return
String[] attrIDs = {"sn", "telephonenumber", "golfhandicap", "mail"};

// Get the attributes requested
Attributes answer = ctx.getAttributes("cn=Ted Geisel, ou=People", attrIDs);

```

[`This example`](https://docs.oracle.com/javase/tutorial/jndi/ops/examples/GetAllAttrs.java) asks for the `"sn"`, `"telephonenumber"`, `"golfhandicap"` and `"mail"` attributes of the object `"cn=Ted Geisel, ou=People"`. This object has all but the `"golfhandicap"` attribute, and so three attributes are returned in the answer. Following is the output of the example.

```
# java Getattrs
attribute: sn
value: Geisel
attribute: mail
value: Ted.Geisel@JNDITutorial.example.com
attribute: telephonenumber
value: +1 408 555 5252
```

# Modify Attributes

The [`DirContext`](https://docs.oracle.com/javase/8/docs/api/javax/naming/directory/DirContext.html) interface contains methods for modifying the attributes and attribute values of objects in the directory.

## [Using a List of Modifications]()

[One way to modify the attributes of an object is to supply a list of modification requests ( ]()[`ModificationItem`](https://docs.oracle.com/javase/8/docs/api/javax/naming/directory/ModificationItem.html)). Each `ModificationItem` consists of a numeric constant indicating the type of modification to make and an [`Attribute`](https://docs.oracle.com/javase/8/docs/api/javax/naming/directory/Attribute.html) describing the modification to make. Following are the three types of modifications:

- [ADD_ATTRIBUTE](https://docs.oracle.com/javase/8/docs/api/javax/naming/directory/DirContext.html#ADD_ATTRIBUTE)
- [REPLACE_ATTRIBUTE](https://docs.oracle.com/javase/8/docs/api/javax/naming/directory/DirContext.html#REPLACE_ATTRIBUTE)
- [REMOVE_ATTRIBUTE](https://docs.oracle.com/javase/8/docs/api/javax/naming/directory/DirContext.html#REMOVE_ATTRIBUTE)

Modifications are applied in the order in which they appear in the list. Either all of the modifications are executed, or none are.

The following code creates a list of modifications. It replaces the `"mail"` attribute's value with a value of `"geisel@wizards.com"`, adds an additional value to the `"telephonenumber"` attribute, and removes the `"jpegphoto"` attribute.

```
// Specify the changes to make
ModificationItem[] mods = new ModificationItem[3];

// Replace the "mail" attribute with a new value
mods[0] = new ModificationItem(DirContext.REPLACE_ATTRIBUTE,
    new BasicAttribute("mail", "geisel@wizards.com"));

// Add an additional value to "telephonenumber"
mods[1] = new ModificationItem(DirContext.ADD_ATTRIBUTE,
    new BasicAttribute("telephonenumber", "+1 555 555 5555"));

// Remove the "jpegphoto" attribute
mods[2] = new ModificationItem(DirContext.REMOVE_ATTRIBUTE,
    new BasicAttribute("jpegphoto"));

```

------

**Windows Active Directory:** Active Directory defines "telephonenumber" to be a single-valued attribute, contrary to [RFC 2256](http://www.ietf.org/rfc/rfc2256.txt). To get this example to work against Active Directory, you must either use an attribute other than "telephonenumber", or change the `DirContext.ADD_ATTRIBUTE` to `DirContext.REPLACE_ATTRIBUTE`.

------

After creating this list of modifications, you can supply it to [`modifyAttributes()`](https://docs.oracle.com/javase/8/docs/api/javax/naming/directory/DirContext.html#modifyAttributes-javax.naming.Name-javax.naming.directory.ModificationItem:A-) as follows.

```
// Perform the requested modifications on the named object
ctx.modifyAttributes(name, mods);

```

## [Using Attributes]()

Alternatively, you can perform modifications by specifying the type of modification and the attributes to which to apply the modification.

For example, the following line replaces the attributes (identified in `orig`) associated with `name` with those in `orig`:

```
ctx.modifyAttributes(name, DirContext.REPLACE_ATTRIBUTE, orig);

```

Any other attributes of `name` remain unchanged.

Both of these uses of `modifyAttributes()` are demonstrated in [`the sample program `](https://docs.oracle.com/javase/tutorial/jndi/ops/examples/ModAttrs.java). This program modifies the attributes by using a modification list and then uses the second form of `modifyAttributes()` to restore the original attributes.

# Add, Replace Bindings with Attributes

The naming examples discussed how you can use [`bind()`, `rebind()`](https://docs.oracle.com/javase/tutorial/jndi/ops/bind.html). The [`DirContext`](https://docs.oracle.com/javase/8/docs/api/javax/naming/directory/DirContext.html) interface contains overloaded versions of these methods that accept attributes. You can use these `DirContext` methods to associate attributes with the object at the time that the binding or subcontext is added to the namespace. For example, you might create a `Person` object and bind it to the namespace and at the same time associate attributes about that `Person` object.

## [Adding a Binding That Has Attributes]()

[`DirContext.bind()`](https://docs.oracle.com/javase/8/docs/api/javax/naming/directory/DirContext.html#bind-javax.naming.Name-java.lang.Object-javax.naming.directory.Attributes-) is used to add a binding that has attributes to a context. It accepts as arguments the name of the object, the object to be bound, and a set of attributes.

```
// Create the object to be bound
Fruit fruit = new Fruit("orange");

// Create attributes to be associated with the object
Attributes attrs = new BasicAttributes(true); // case-ignore
Attribute objclass = new BasicAttribute("objectclass");
objclass.add("top");
objclass.add("organizationalUnit");
attrs.put(objclass);

// Perform bind
ctx.bind("ou=favorite, ou=Fruits", fruit, attrs);

```

[`This example`](https://docs.oracle.com/javase/tutorial/jndi/ops/examples/Bind.java) creates an object of class [`Fruit`](https://docs.oracle.com/javase/tutorial/jndi/ops/examples/Fruit.java) and binds it to the name `"ou=favorite"` into the context named `"ou=Fruits"`, relative to `ctx`. This binding has the `"objectclass"` attribute. If you subsequently looked up the name `"ou=favorite, ou=Fruits"` in `ctx`, then you would get the `fruit`object. If you then got the attributes of `"ou=favorite, ou=Fruits"`, you would get those attributes with which the object was created. Following is this example's output.

```
# java Bind
orange
attribute: objectclass
value: top
value: organizationalUnit
value: javaObject
value: javaNamingReference
attribute: javaclassname
value: Fruit
attribute: javafactory
value: FruitFactory
attribute: javareferenceaddress
value: #0#fruit#orange
attribute: ou
value: favorite

```

The extra attributes and attribute values shown are used to store information about the object (`fruit`). These extra attributes are discussed in more detail in the trail.

If you were to run this example twice, then the second attempt would fail with a [`NameAlreadyBoundException`](https://docs.oracle.com/javase/8/docs/api/javax/naming/NameAlreadyBoundException.html). This is because the name `"ou=favorite"` is already bound in the `"ou=Fruits"` context. For the second attempt to succeed, you would have to use `rebind()`.

## [Replacing a Binding That Has Attributes]()

[`DirContext.rebind()`](https://docs.oracle.com/javase/8/docs/api/javax/naming/directory/DirContext.html#rebind-javax.naming.Name-java.lang.Object-javax.naming.directory.Attributes-) is used to add or replace a binding and its attributes. It accepts the same arguments as `bind()`. However, `rebind()`'s semantics require that if the name is already bound, then it will be unbound and the newly given object and attributes will be bound.

```
// Create the object to be bound
Fruit fruit = new Fruit("lemon");

// Create attributes to be associated with the object
Attributes attrs = new BasicAttributes(true); // case-ignore
Attribute objclass = new BasicAttribute("objectclass");
objclass.add("top");
objclass.add("organizationalUnit");
attrs.put(objclass);

// Perform bind
ctx.rebind("ou=favorite, ou=Fruits", fruit, attrs);

```

When you run [`this example`](https://docs.oracle.com/javase/tutorial/jndi/ops/examples/Rebind.java) , it replaces the binding that the [`bind()`](https://docs.oracle.com/javase/tutorial/jndi/ops/examples/Bind.java) example created.

```
# java Rebind
lemon
attribute: objectclass
value: top
value: organizationalUnit
value: javaObject
value: javaNamingReference
attribute: javaclassname
value: Fruit
attribute: javafactory
value: FruitFactory
attribute: javareferenceaddress
value: #0#fruit#lemon
attribute: ou
value: favorite
```

# Search

One of the most useful features that a directory offers is its *yellow pages*, or *search*, service. You can compose a query consisting of attributes of entries that you are seeking and submit that query to the directory. The directory then returns a list of entries that satisfy the query. For example, you could ask the directory for all entries with a bowling average greater than 200 or all entries that represent a person with a surname beginning with "Sch."

The [`DirContext`](https://docs.oracle.com/javase/8/docs/api/javax/naming/directory/DirContext.html) interface provides several methods for searching the directory, with progressive degrees of complexity and power. The various aspects of searching the directory are covered in the following sections:

- [basic search](https://docs.oracle.com/javase/tutorial/jndi/ops/basicsearch.html)
- [Search Filters](https://docs.oracle.com/javase/tutorial/jndi/ops/filter.html)
- [Search Controls](https://docs.oracle.com/javase/tutorial/jndi/ops/scope.html)

# Basic Search

The simplest form of search requires that you specify the set of attributes that an entry must have and the name of the target context in which to perform the search.

The following code creates an attribute set `matchAttrs`, which has two attributes `"sn"` and `"mail"`. It specifies that the qualifying entries must have a surname (`"sn"`) attribute with a value of `"Geisel"` and a `"mail"` attribute with any value. It then invokes [`DirContext.search()`](https://docs.oracle.com/javase/8/docs/api/javax/naming/directory/DirContext.html#search-javax.naming.Name-javax.naming.directory.Attributes-) to search the context `"ou=People"` for entries that have the attributes specified by `matchAttrs`.

```
// Specify the attributes to match
// Ask for objects that has a surname ("sn") attribute with 
// the value "Geisel" and the "mail" attribute

// ignore attribute name case
Attributes matchAttrs = new BasicAttributes(true); 
matchAttrs.put(new BasicAttribute("sn", "Geisel"));
matchAttrs.put(new BasicAttribute("mail"));

// Search for objects that have those matching attributes
NamingEnumeration answer = ctx.search("ou=People", matchAttrs);

```

You can then print the results as follows.

```
while (answer.hasMore()) {
    SearchResult sr = (SearchResult)answer.next();
    System.out.println(">>>" + sr.getName());
    printAttrs(sr.getAttributes());
}

```

`printAttrs()`is similar to the code in [the `getAttributes()`](https://docs.oracle.com/javase/tutorial/jndi/ops/basicsearch.html) example that prints an attribute set.

Running [`this example`](https://docs.oracle.com/javase/tutorial/jndi/ops/examples/SearchRetAll.java) produces the following result.

```
# java SearchRetAll
>>>cn=Ted Geisel
attribute: sn
value: Geisel
attribute: objectclass
value: top
value: person
value: organizationalPerson
value: inetOrgPerson
attribute: jpegphoto
value: [B@1dacd78b
attribute: mail
value: Ted.Geisel@JNDITutorial.example.com
attribute: facsimiletelephonenumber
value: +1 408 555 2329
attribute: cn
value: Ted Geisel
attribute: telephonenumber
value: +1 408 555 5252

```

## [Returning Selected Attributes]()

The previous example returned all attributes associated with the entries that satisfy the specified query. You can select the attributes to return by passing `search()` an array of attribute identifiers that you want to include in the result. After creating the `matchAttrs` as shown previously, you also need to create the array of attribute identifiers, as shown next.

```
// Specify the ids of the attributes to return
String[] attrIDs = {"sn", "telephonenumber", "golfhandicap", "mail"};

// Search for objects that have those matching attributes
NamingEnumeration answer = ctx.search("ou=People", matchAttrs, attrIDs);

```

[`This example`](https://docs.oracle.com/javase/tutorial/jndi/ops/examples/Search.java) returns the attributes `"sn"`, `"telephonenumber"`, `"golfhandicap"`, and `"mail"` of entries that have an attribute `"mail"` and have a `"sn"` attribute with the value `"Geisel"`. This example produces the following result. (The entry does not have a `"golfhandicap"` attribute, so it is not returned.)

```
# java Search 
>>>cn=Ted Geisel
attribute: sn
value: Geisel
attribute: mail
value: Ted.Geisel@JNDITutorial.example.com
attribute: telephonenumber
value: +1 408 555 5252
```

# Filters

In addition to specifying a search using a set of attributes, you can specify a search in the form of a *search filter*. A search filter is a search query expressed in the form of a logical expression. The syntax of search filters accepted by [`DirContext.search()`](https://docs.oracle.com/javase/8/docs/api/javax/naming/directory/DirContext.html#search-javax.naming.Name-java.lang.String-javax.naming.directory.SearchControls-) is described in [RFC 2254](http://www.ietf.org/rfc/rfc2254.txt).

The following search filter specifies that the qualifying entries must have an `"sn"` attribute with a value of `"Geisel"` and a `"mail"` attribute with any value:

```
(&(sn=Geisel)(mail=*))

```

The following code creates a filter and default [`SearchControls`](https://docs.oracle.com/javase/8/docs/api/javax/naming/directory/SearchControls.html), and uses them to perform a search. The search is equivalent to the one presented in the [basic search](https://docs.oracle.com/javase/tutorial/jndi/ops/basicsearch.html) example.

```
// Create the default search controls
SearchControls ctls = new SearchControls();

// Specify the search filter to match
// Ask for objects that have the attribute "sn" == "Geisel"
// and the "mail" attribute
String filter = "(&(sn=Geisel)(mail=*))";

// Search for objects using the filter
NamingEnumeration answer = ctx.search("ou=People", filter, ctls);

```

Running [`this example`](https://docs.oracle.com/javase/tutorial/jndi/ops/examples/SearchWithFilterRetAll.java) produces the following result.

```
# java SearchWithFilterRetAll
>>>cn=Ted Geisel
attribute: sn
value: Geisel
attribute: objectclass
value: top
value: person
value: organizationalPerson
value: inetOrgPerson
attribute: jpegphoto
value: [B@1dacd75e
attribute: mail
value: Ted.Geisel@JNDITutorial.example.com
attribute: facsimiletelephonenumber
value: +1 408 555 2329
attribute: cn
value: Ted Geisel
attribute: telephonenumber
value: +1 408 555 5252

```

## Quick Overview of Search Filter Syntax

The search filter syntax is basically a logical expression in prefix notation (that is, the logical operator appears before its arguments). The following table lists the symbols used for creating filters.

| Symbol | Description                              |
| ------ | ---------------------------------------- |
| &      | conjunction (i.e., *and* -- all in list must be true) |
| \|     | disjunction (i.e., *or* -- one or more alternatives must be true) |
| !      | negation (i.e., *not* -- the item being negated must not be true) |
| =      | equality (according to the matching rule of the attribute) |
| ~=     | approximate equality (according to the matching rule of the attribute) |
| >=     | greater than (according to the matching rule of the attribute) |
| <=     | less than (according to the matching rule of the attribute) |
| =*     | presence (i.e., the entry must have the attribute but its value is irrelevant) |
| *      | wildcard (indicates zero or more characters can occur in that position); used when specifying attribute values to match |
| \      | escape (for escaping '*', '(', or ')' when they occur inside an attribute value) |

Each item in the filter is composed using an attribute identifier and either an attribute value or symbols denoting the attribute value. For example, the item `"sn=Geisel"` means that the `"sn"` attribute must have the attribute value `"Geisel"` and the item `"mail=*"` indicates that the `"mail"` attribute must be present.

Each item must be enclosed within a set of parentheses, as in `"(sn=Geisel)"`. These items are composed using logical operators such as "&" (conjunction) to create logical expressions, as in `"(& (sn=Geisel) (mail=*))"`.

Each logical expression can be further composed of other items that themselves are logical expressions, as in `"(| (& (sn=Geisel) (mail=*)) (sn=L*))"`. This last example is requesting either entries that have both a `"sn"` attribute of `"Geisel"` and the `"mail"` attribute or entries whose `"sn"`attribute begins with the letter "L."

For a complete description of the syntax, see [RFC 2254](http://ietf.org/rfc/rfc2254.txt).

## [Returning Selected Attributes]()

The previous example returned all attributes associated with the entries that satisfy the specified filter. You can select the attributes to return by setting the search controls argument. You create an array of attribute identifiers that you want to include in the result and pass it to[`SearchControls.setReturningAttributes()`](https://docs.oracle.com/javase/8/docs/api/javax/naming/directory/SearchControls.html#setReturningAttributes-java.lang.String:A-). Here's an example.

```
// Specify the ids of the attributes to return
String[] attrIDs = {"sn", "telephonenumber", "golfhandicap", "mail"};
SearchControls ctls = new SearchControls();
ctls.setReturningAttributes(attrIDs);

```

This example is equivalent to the [Returning Selected Attributes](https://docs.oracle.com/javase/tutorial/jndi/ops/basicsearch.html#SELECT) example in the Basic Search section. Running [`this example`](https://docs.oracle.com/javase/tutorial/jndi/ops/examples/SearchWithFilter.java) produces the following results. (The entry does not have a `"golfhandicap"` attribute, so it is not returned.)

```
# java SearchWithFilter
>>>cn=Ted Geisel
attribute: sn
value: Geisel
attribute: mail
value: Ted.Geisel@JNDITutorial.example.com
attribute: telephonenumber
value: +1 408 555 5252
```

# Scope

The default [`SearchControls`](https://docs.oracle.com/javase/8/docs/api/javax/naming/directory/SearchControls.html) specifies that the search is to be performed in the named context ( [`SearchControls.ONELEVEL_SCOPE`](https://docs.oracle.com/javase/8/docs/api/javax/naming/directory/SearchControls.html#ONELEVEL_SCOPE)). This default is used in the examples in the [Search Filters section](https://docs.oracle.com/javase/tutorial/jndi/ops/filter.html).

In addition to this default, you can specify that the search be performed in the *entire subtree* or only in the named object.

## [Search the Subtree]()

A search of the entire subtree searches the named object and all of its descendants. To make the search behave in this way, pass [`SearchControls.SUBTREE_SCOPE`](https://docs.oracle.com/javase/8/docs/api/javax/naming/directory/SearchControls.html#SUBTREE_SCOPE) to [`SearchControls.setSearchScope()`](https://docs.oracle.com/javase/8/docs/api/javax/naming/directory/SearchControls.html#setSearchScope-int-) as follows.

```
// Specify the ids of the attributes to return
String[] attrIDs = {"sn", "telephonenumber", "golfhandicap", "mail"};
SearchControls ctls = new SearchControls();
ctls.setReturningAttributes(attrIDs);
ctls.setSearchScope(SearchControls.SUBTREE_SCOPE);

// Specify the search filter to match
// Ask for objects that have the attribute "sn" == "Geisel"
// and the "mail" attribute
String filter = "(&(sn=Geisel)(mail=*))";

// Search the subtree for objects by using the filter
NamingEnumeration answer = ctx.search("", filter, ctls);

```

[`This example`](https://docs.oracle.com/javase/tutorial/jndi/ops/examples/SearchSubtree.java) searches the context `ctx`'s subtree for entries that satisfy the specified filter. It finds the entry `"cn= Ted Geisel, ou=People"` in this subtree that satisfies the filter.

```
# java SearchSubtree
>>>cn=Ted Geisel, ou=People
attribute: sn
value: Geisel
attribute: mail
value: Ted.Geisel@JNDITutorial.example.com
attribute: telephonenumber
value: +1 408 555 5252

```

## Search the Named Object

You can also search the named object. This is useful, for example, to test whether the named object satisfies a search filter. To search the named object, pass [`SearchControls.OBJECT_SCOPE`](https://docs.oracle.com/javase/8/docs/api/javax/naming/directory/SearchControls.html#OBJECT_SCOPE) to `setSearchScope()`.

```
// Specify the ids of the attributes to return
String[] attrIDs = {"sn", "telephonenumber", "golfhandicap", "mail"};
SearchControls ctls = new SearchControls();
ctls.setReturningAttributes(attrIDs);
ctls.setSearchScope(SearchControls.OBJECT_SCOPE);

// Specify the search filter to match
// Ask for objects that have the attribute "sn" == "Geisel"
// and the "mail" attribute
String filter = "(&(sn=Geisel)(mail=*))";

// Search the subtree for objects by using the filter
NamingEnumeration answer = 
    ctx.search("cn=Ted Geisel, ou=People", filter, ctls);

```

[`This example`](https://docs.oracle.com/javase/tutorial/jndi/ops/examples/SearchObject.java) tests whether the object `"cn=Ted Geisel, ou=People"` satisfies the given filter.

```
# java SearchObject
>>>
attribute: sn
value: Geisel
attribute: mail
value: Ted.Geisel@JNDITutorial.example.com
attribute: telephonenumber
value: +1 408 555 5252

```

The example found one answer and printed it. Notice that the name of the result is the empty string. This is because the name of the object is always named relative to the context of the search (in this case, `"cn=Ted Geisel, ou=People"`).

# Result Count

Sometimes, a query might produce too many answers and you want to limit the number of answers returned. You can do this by using the count limit search control. By default, a search does not have a count limit--it will return all answers that it finds. To set the count limit of a search, pass the number to [`SearchControls.setCountLimit()`](https://docs.oracle.com/javase/8/docs/api/javax/naming/directory/SearchControls.html#setCountLimit-long-).

[`The following example`](https://docs.oracle.com/javase/tutorial/jndi/ops/examples/SearchCountLimit.java) sets the count limit to 1.

```
// Set the search controls to limit the count to 1
SearchControls ctls = new SearchControls();
ctls.setCountLimit(1);

```

If the program attempts to get more than the count limit number of results, then a [`SizeLimitExceededException`](https://docs.oracle.com/javase/8/docs/api/javax/naming/SizeLimitExceededException.html) will be thrown. So if a program has set a count limit, then it should either differentiate this exception from other [`NamingException`s](https://docs.oracle.com/javase/8/docs/api/javax/naming/NamingException.html) or keep track of the count limit and not request more than that number of results.

Specifying a count limit for a search is one way of controlling the resources (such as memory and network bandwidth) that your application consumes. Other ways to control the resources consumed are to narrow your [search filter](https://docs.oracle.com/javase/tutorial/jndi/ops/filter.html) (be more specific about what you seek), start your search in the appropriate context, and use the appropriate [scope](https://docs.oracle.com/javase/tutorial/jndi/ops/scope.html).

# Time Limit

A time limit on a search places an upper bound on the amount of time that the search operation will block waiting for the answers. This is useful when you don't want to wait too long for an answer. If the time limit specified is exceeded before the search operation can be completed, then a[`TimeLimitExceededException`](https://docs.oracle.com/javase/8/docs/api/javax/naming/TimeLimitExceededException.html) will be thrown.

To set the time limit of a search, pass the number of milliseconds to [`SearchControls.setTimeLimit()`](https://docs.oracle.com/javase/8/docs/api/javax/naming/directory/SearchControls.html#setTimeLimit-int-). The following [`example`](https://docs.oracle.com/javase/tutorial/jndi/ops/examples/SearchTimeLimit.java) sets the time limit to 1 second.

```
// Set the search controls to limit the time to 1 second (1000 ms)
SearchControls ctls = new SearchControls();
ctls.setTimeLimit(1000);

```

To get this particular example to exceed its time limit, you need to reconfigure it to use either a slow server, or a server that has lots of entries. Alternatively, you can use other tactics to make the search take longer than 1 second.

A time limit of zero means that no time limit has been set and that calls to the directory will wait indefinitely for an answer.

