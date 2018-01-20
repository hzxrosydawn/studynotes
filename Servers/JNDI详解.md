---
typora-copy-images-to: appendix
typora-root-url: appendix
---

JNDI is the Java Naming and Directory Interface

### 命名（Naming）的概念

**命名服务（naming service）**是任何计算机系统的基础设施之一。命名服务可以通过**对象（objects）**的名称来找与这些**名称（name）**关联的对象。使用任何计算机程序或系统时总会命名一些对象。例如，当使用电子邮件系统时就必须提供接收者的名字，访问计算机上的某个文件就必须提供这个文件的名称。

![naming-system](/naming-system.gif)

命名服务的基本功能就是为对象映射出一些容易识别的名称，比如地址、识别码等。例如， [Internet Domain Name System (DNS)](http://www.ietf.org/rfc/rfc1034.txt) 为IP地址映射出一个机器的名称。

```
www.example.com ==> 192.0.2.5
```

文件系统为文件的引用映射出了一个文件名，程序就可以通过这个文件名来访问该文件的内容了。

```
c:\bin\autoexec.bat ==> File Reference
```

### 名称（Names）

要从**命名系统（naming system）**中查找一个对象，就必须要提供该对象的名称。命名系统确定了名称所遵循的语法，这种语法有时称为命名系统的**命名约定（naming convention）**。名称通过由**组件分隔符（component Separator）**所分隔的一些**组件（component ）**来表示。

| Naming System    | Component Separator | Names                       |
| ---------------- | ------------------- | --------------------------- |
| UNIX file system | "/"                 | /usr/hello                  |
| DNS              | "."                 | sales.Wiz.COM               |
| LDAP             | "," and "="         | cn=Rosanna Lee, o=Sun, c=US |

UNIX 文件系统的命名约定为文件相对于根目录的路径，路径中的每个组件从左到右使用斜线“/”来分隔。UNIX  路径名 `/usr/hello` 命名了一个 `/usr` 目录下的一个名为 `hello` 的文件。

DNS 命名约定通过点号“.”来分隔 DNS 名称中的组件。DNS 名称 `sales.Wiz.COM` 使用名称  `sales` 相对于 DNS 入口 `Wiz.COM` 命名了一个 DNS 入口，DNS 入口 `Wiz.COM` 相对于入口 `COM` 命名了一个入口 `Wiz` 。 

 [Lightweight Directory Access Protocol (LDAP)](http://www.ietf.org/rfc/rfc2251.txt) 命名约定从右到左使用逗号“,”分隔排列组件。因此，LDAP 名称 `cn=Rosanna Lee, o=Sun, c=US` 命名了一个 LDAP 入口 `cn=Rosanna Lee` ，该入口相对于入口 `o=Sun` ，入口 `o=Sun` 又相对于入口  `c=US` 。LDAP 有进一步的规则限制：每个组件必须是一个等号“=”连接的 name/value 对。

### 绑定



The association of a name with an object is called a *binding*. A file name is *bound* to a file.

The DNS contains bindings that map machine names to IP addresses. An LDAP name is bound to an LDAP entry.

## References and Addresses

Depending on the naming service, some objects cannot be stored directly by the naming service; that is, a copy of the object cannot be placed inside the naming service. Instead, they must be stored by reference; that is, a *pointer* or *reference* to the object is placed inside the naming service. A reference represents information about how to access an object. Typically, it is a compact representation that can be used to communicate with the object, while the object itself might contain more state information. Using the reference, you can contact the object and obtain more information about the object.

For example, an airplane object might contain a list of the airplane's passengers and crew, its flight plan, and fuel and instrument status, and its flight number and departure time. By contrast, an airplane object reference might contain only its flight number and departure time. The reference is a much more compact representation of information about the airplane object and can be used to obtain additional information. A file object, for example, is accessed using a *file reference*. A printer object, for example, might contain the state of the printer, such as its current queue and the amount of paper in the paper tray. A printer object reference, on the other hand, might contain only information on how to reach the printer, such as its print server name and printing protocol.

Although in general a reference can contain any arbitrary information, it is useful to refer to its contents as *addresses* (or communication end points): specific information about how to access the object.

For simplicity, this tutorial uses "object" to refer to both objects and object references when a distinction between the two is not required.

## Context

A *context* is a set of name-to-object bindings. Every context has an associated naming convention. A context always provides a lookup (*resolution*) operation that returns the object, it typically also provides operations such as those for binding names, unbinding names, and listing bound names. A name in one context object can be bound to another context object (called a *subcontext*) that has the same naming convention.

![Several examples of contexts, bound to subcontexts.](https://docs.oracle.com/javase/tutorial/figures/jndi/context.gif)

A file directory, such as `/usr`, in the UNIX file system represents a context. A file directory named relative to another file directory represents a subcontext (UNIX users refer to this as a *subdirectory*). That is, in a file directory `/usr/bin`, the directory `bin` is a subcontext of `usr`. A DNS domain, such as `COM`, represents a context. A DNS domain named relative to another DNS domain represents a subcontext. For the DNS domain `Sun.COM`, the DNS domain `Sun` is a subcontext of `COM`.

Finally, an LDAP entry, such as `c=us`, represents a context. An LDAP entry named relative to another LDAP entry represents a subcontext. For the LDAP entry `o=sun,c=us`, the entry `o=sun` is a subcontext of `c=us`.

## Naming Systems and Namespaces

A *naming system* is a connected set of contexts of the same type (they have the same naming convention) and provides a common set of operations.

A system that implements the DNS is a naming system. A system that communicates using the LDAP is a naming system.

A naming system provides a *naming service* to its customers for performing naming-related operations. A naming service is accessed through its own interface. The DNS offers a naming service that maps machine names to IP addresses. LDAP offers a naming service that maps LDAP names to LDAP entries. A file system offers a naming service that maps filenames to files and directories.

A *namespace* is the set of all possible names in a naming system. The UNIX file system has a namespace consisting of all of the names of files and directories in that file system. The DNS namespace contains names of DNS domains and entries. The LDAP namespace contains names of LDAP entries.









