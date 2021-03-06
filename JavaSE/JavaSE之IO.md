## File类详解
**File类**位于java.io包下，用来抽象地表示**文件和目录的路径名**。抽象路径名包括两部分：

- 依赖于操作系统的前缀字符串，比如驱动器盘符加英文冒号（Windows系统中的根目录）、`/`（Unix系统中的根目录）、`\\\\`（表示Windows UNC 路径名）。这种前缀是可选的，比如相对路径就没有这些前缀；
- 零或多个表示各级目录的字符串。

路径（Path）既可以是文件，关于路径的详细介绍，请参考维基百科中有关[Path(Computing)](https://en.wikipedia.org/wiki/Path_(computing))的介绍。

由于不同操作系统中路径（如根目录、路径分隔符，目录分隔符）的表示都不相同，所以路径名字符串和File类的抽象路径名之间的转换依赖于操作系统。

- 根目录在不同的操作系统上是不同的。Windows系统中的根目录是驱动器盘符后跟英文冒号，Unix系统中的根目录用`/`表示；
- 路径分隔符在不同的操作系统上是不同的。Windows系统中的多个路径之间使用英文分号`;`来分隔多个路径，Unix系统中使用英文冒号（colon）`:`来分隔符多个路径。典型连续多个路径如Path环境变量；
- 目录分隔符在不同的操作系统上也是不同的。Windows系统中的多个路径之间使用分隔符`\`，Unix系统中的路径分隔符是`/`。Java中默认的路径分隔符定义在系统属性`file.separator`中，可以通过File类的**separator字符串常量**来访问平台无关的路径分隔符。

路径名既可以是绝对的（absolute，or full），也可以是相对的（relative）。绝对路径以根目录开头，仅依靠自身内容就可以定位文件位置而不需要其他信息；而相对路径则不用提供文件的完整路径，默认以当前的工作路径开始，然后结合自身路径一起来定位文件。在java.io包中的类默认相对路径依赖于当前的用户路径（由`user.dir`系统属性指定）。

在Windows系统中，路径前缀总是驱动器盘符后跟英文冒号，如果是绝对路径，还会跟`\\`。UNC的路径前缀是`\\\\`，然后依次主机名和共享目录名。Windows系统中没有指定盘符的相对路径是没有前缀的；而在Unix系统中，绝对路径的前缀总是`/`，相对路径没有前缀

**创建File对象**：

- File(File parent, String child)：以一个表示抽象父路径（parent pathname）的File对象和一个子路径（child pathname）字符串创建一个新的File对象。如果抽象父路径为null，则相当于调用单参数的构造器；否则，抽象父路径应该表示一个目录。如果该目录不为空，则该父路径名就是新File对象的前缀，如果抽象路径名是一个空目录，则新File对象的前缀就是系统默认的目录；
- File(String parent, String child)：同上，只是抽象路径为实际的路径字符串；
- File(String pathname)：以路径字符串创建File对象；
- File(URI uri)：将`file:`开头URI对象转换为抽象路径来创建File对象。`file:`格式的URI对象是依赖于系统的（system-dependent）。

**访问路径的方法**：

- String getName()：返回该抽象路径代表的文件或目录的名称，即路径序列中的最后一个名称（如果是路径名，则返回最后一级的子路径名）；
- String getPath()：将该抽象路径名转换成路径名字符串。返回的字符串使用系统无关的separator常量来分隔路径；
- Strin getParent()：返回该File对象的父路径名字符串。该父路径名为除最后一级路径名以外的路径前缀。如果前缀路径不表示目录，则返回null；
- File getParentFile()：同上，只是返回结果的形式不同；
- String getAbsolutePath()：返回该抽象路径的全路径字符串（即绝对路径的字符串）。如果该抽象路径为空，则返回的是`user.dir`系统属性表示的当前用户目录。如果该抽象路径不为空，则返回结果依赖于操作系统：Windows系统中是根据相对路径所在的驱动器盘符来将其生成绝对路径的，如果没有驱动器盘符，就根据当前用户目录来生成绝对路径。而Unix系统中是根据当前用户目录来将相对路径生成对应的绝对路径的；
- File getAbsoluteFile()：同上，只是返回结果的形式不同；
- String getCanonicalPath()：返回该抽象路径的规范化路径名字符串。规范化路径是绝对的、唯一的，规范形式的严格地讲是依赖于操作系统的。返回结果中会去除`.`和`..`、解析符号链接（Unix平台上）、将驱动器盘符转换成标准大小写（Windows平台上）。任何存在或不存在的文件或目录的规范化路径名都是唯一的，一个不存在的文件或目录的规范化路径名可能会在其创建后改变，一个存在的文件或目录的规范化路径名可能会在其删除后改变；
- File getCanonicalFile()：同上，只是返回结果的形式不同；
- URI toURI()：构造一个表示当前抽象路径的`file:`URI。如果该抽象路径名表示一个目录，则返回结果以斜杠（slash）结尾。对于给定的一个抽象路径名f，只要原始抽象路径名、URI和新抽象路径名是同一个Java虚拟机创建的，就会有`new File( f.toURI()).equals( f.getAbsoluteFile())`。如果该抽象路径代表一个UNC路径名，那么该UNC路径会被编码成一个授权为null的URI。如果想编码成带授权的URI，可以参考[Path类]()的[toUri()]()方法，File类的[toPath()](http://docs.oracle.com/javase/8/docs/api/java/io/File.html#toPath--)方法可以获得一个对应的Path类对象；
- public Path toPath()：该方法是Java 7新增的，将该抽象路径名转换成一个新的Path对象；
- boolean **renameTo(File dest)**：重命名该File对象。该操作的许多行为是依赖于平台的：重命名可能不能将文件移动到另一个位置，也可能不是原子性的，如果目标File对象已存在，该操作可能会失败。应该总是检查该方法的返回值来确保操作成功；

访问磁盘：

- public long getTotalSpace()：返回该抽象路径名所表示分区的总大小（以字节为单位）。如果该抽象路径名不是分区，则返回0L；
- public long getFreeSpace()：返回该抽象路径名所表示分区的可分配大小（以字节为单位，非精确）。如果该抽象路径名不是分区，则返回0L；
- public long getUsableSpace()：返回该抽象路径名所表示分区的可分配给JVM的大小（以字节为单位，非精确），可能会检查写权限等。该方法比getFreeSpace()方法更实用。如果该抽象路径名不是分区，则返回0L；

**操作属性的方法**：

- boolean **exists()**：该File对象对应的文件或目录是否存在；
- boolean **isDirectory()**：判断该抽象路径是否为一个目录；
- boolean **isFile()**：判断该抽象路径是否为一个文件：
- boolean **isAbsolute()**：判断该抽象路径是否为绝对路径；
- boolean isHidden()：判断该抽象路径是否为隐藏；
- boolean canRead()：判断该抽象路径是否可读；
- boolean setReadOnly()：设置为只读的权限，直到删除或标记为可写该File对象才可以改变；
- public boolean setReadable(boolean readable)：为所有者设置可读权限；
- public boolean setReadable(boolean readable, boolean ownerOnly)：为所有者（ownerOnly参数为true）或所有用户（ownerOnly参数为false）设置对该抽象路径的可读权限。某些系统中可能需要使用特殊权限来启动JVM。Java 7 提供的java.nio.file.Files工具类中有关于权限操作的更好方法；
- boolean canWrite()：判断该抽象路径是否可写；
- boolean setWritable(boolean writable)：为所有者设置可写权限；
- boolean setWritable(boolean writable, boolean ownerOnly)：为所有者（ownerOnly参数为true）或所有用户（ownerOnly参数为false）设置对该抽象路径的可写权限。某些系统中可能需要使用特殊权限来启动JVM；
- boolean canExecute()：判断该抽象路径是否可执行；
- public boolean setExecutable(boolean executable)：为所有者设置可执行权限；
- public boolean setExecutable(boolean executable, boolean ownerOnly)：为所有者（ownerOnly参数为true）或所有用户（ownerOnly参数为false）设置对该抽象路径的可执行权限。某些系统中可能需要使用特殊权限来启动JVM；
- long **lastModified()**：获取最后修改时间；
- boolean setLastModified(long time)：设置上次修改的时间；
- long **length()**：获取文件长度。

**操作文件的方法**：

- public int compareTo(File pathname)：根据字典编纂顺序比较两个抽象路径名，如果两个抽象路径名相同就返回0，如果该抽象路径名根据字段编纂顺序小于参数代表的抽象路径名就返回一个负数，否则，返回一个整数。注意，Unix系统中严格区分路径的字母大小写，而Windows系统中不区分路径的大小写；
- boolean **createNewFile()**：仅当该抽象路径表示的文件不存在时原子性地创建一个新的空文件，文件不存在且创建成功返回true，文件已存在就返回false。文件是否存在的检查，以及不存在时的创建都是依赖于文件系统的原子性的单一操作。注意，用于文件锁时不应该使用该方法，因为结果是不可靠的，应该使用[FileLock](http://docs.oracle.com/javase/8/docs/api/java/nio/channels/FileLock.html)来替代；
- **static File createTempFile(String prefix, String suffix)**：静态方法，用前后缀和系统生成的随机数作为文件名创建一个空文件，后缀为空则默认为.tmp。java.nio.file.Files的createTempFile(String prefix, String suffix, FileAttribute<?>... attrs) 静态方法会在创建文件时同时创建合适的权限；
- **static File createTempFile(String prefix, String suffix, File directory)**：比上面的方法多指定了文件目录；
- boolean **delete()**：删除该File对象对应的文件或目录。**如果删除的目录，则该目录必须是空的**。[Files](http://docs.oracle.com/javase/8/docs/api/java/nio/file/Files.html)工具类提供的delete方法会在文件不能删除时抛出IOException异常，在删除出错提交报告时很有用；
- void deleteOnExit()：注册一个钩子，在JVM退出时删除该抽象路径表示的文件或目录，删除顺序与调用该方法来的注册顺序相反。注意，用于文件锁时不应该使用该方法，因为结果是不可靠的，应该使用[FileLock](http://docs.oracle.com/javase/8/docs/api/java/nio/channels/FileLock.html)来替代；
- private **synchronized void readObject(java.io.ObjectInputStream s)**：恢复该文件；
- private **synchronized void writeObject(java.io.ObjectOutputStream s)**：保存该文件；

**操作目录的方法**：

- boolean **mkdir()**：创建一个**目录**，仅当目录创建成功返回true；
- boolean **mkdirs()**：创建一个**目录**，包括任何必要但不存在的父级目录。仅当目录创建成功时才返回true。如果该方法操作失败，可能已经创建了部分父级目录了；
- **String[] list()**：列出该抽象路径下的所有文件名和目录名（仅为子文件名和子目录名，不包含父目录名）组成的字符串数组。如果该抽象路径不是一个目录，则返回null。无法保证该方法以特定的顺序来返回结果。[Files工具类](http://docs.oracle.com/javase/8/docs/api/java/nio/file/Files.html)提供了一个[newDirectoryStream()](http://docs.oracle.com/javase/8/docs/api/java/nio/file/Files.html#newDirectoryStream-java.nio.file.Path-)方法来打开一目录，并遍历该目录下的文件名，通过该方法，当处理大目录时可能会使用更少的资源，处理远程目录时可能具有更好的响应性；
- **File[] listFiles()**：同上，只是返回结果的形式不同；
- **String[] list(FilenameFilter filter)**：选择性列出该抽象路径下的文件名和目录名构成的字符串数组。除了返回结果中的文件名或目录名需要符合FilenameFilter的筛选条件以外，该方法与listFiles方法并无不同；
- File[] listFiles(FilenameFilter filter)：同上，只是返回结果的形式不同；
- **File[] listFiles(FileFilter filter)**：同上，只是筛选条件不同；
- **static File[] listRoots()**：静态方法，列出文件系统的所有根目录，不同的文件系统返回结果不同（Unix系统返回一个英文斜线，而Windows系统返回驱动器盘符构成数组）。远程挂载文件的规范化路径名可能不会以该方法返回数组中的元素开头。如果远程挂载的路径名和本地路径名无二，那么挂载路径名会以该方法返回数组中的元素开头，比如挂载的远程根目录会出现在返回结果中，而包含UNC路径名的挂载根目录不会出现在返回结果中。

注意：FilenameFilter和FileFilter都是函数式接口（可以使用Java 8 的Lambda表达式），只是筛选条件有所不同。

**File类常用方法实例**：
```java
File file = new File(".");
// 直接获取文件名，输出一点
System.out.println(file.getName());
// 获取相对路径的父路径可能出错，下面代码输出null
System.out.println(file.getParent());
// 获取绝对路径
System.out.println(file.getAbsoluteFile());
// 获取上一级路径
System.out.println(file.getAbsoluteFile().getParent());
// 在当前路径下创建一个临时文件
File tmpFile = File.createTempFile("aaa", ".txt", file);
// 指定当JVM退出时删除该文件
tmpFile.deleteOnExit();
// 以系统当前时间作为新文件名来创建新文件
File newFile = new File(System.currentTimeMillis() + "");
System.out.println("newFile对象是否存在：" + newFile.exists());
// 以指定newFile对象来创建一个文件
newFile.createNewFile();
// 以newFile对象来创建一个目录，因为newFile已经存在，
// 所以下面方法返回false，即无法创建该目录
newFile.mkdir();
// 以newFile对象来创建一个目录，虽然已经存在但mkdirs方法可以覆盖源目录
// 所以下面方法返回true，可以创建该目录
 newFile.mkdirs();
// 使用list()方法来列出当前路径下的所有文件和路径
String[] fileList = file.list();
System.out.println("====当前路径下所有文件和路径如下====");
for (String fileName ： fileList) {
     System.out.println(fileName);
}
// listRoots()静态方法列出所有的磁盘根路径。
File[] roots = File.listRoots();
System.out.println("====系统所有根路径如下====");
for (File root ： roots) {
	System.out.println(root);
}
```
File类的list方法可以传入FilenameFilter参数实现文件过滤：
```java
File file = new File(".");
// 使用Lambda表达式（目标类型为FilenameFilter）实现文件过滤器。
// 如果文件名以.java结尾，或者文件对应一个路径，返回true
String[] nameList = file.list((dir, name) -> name.endsWith(".java") || new File(name).isDirectory());
for(String name ： nameList) {
	  System.out.println(name);
}
```
File类**能操作文件和目录，但不能访问文件内容。访问文件内容需要使用IO（输入流/输出流）**。关于文件操作还可参考Java 7新增的[Files工具类]()和[Path接口](http://docs.oracle.com/javase/8/docs/api/java/nio/file/Path.html)。

## Java的IO流 

Java把这些不同来源和目标（键盘、文件和网络）的数据都统一抽象为数据流（Stream）。Java语言的输入输出功能是十分强大而灵活的，美中不足的是看上去输入输出的代码并不是很简洁，因为你往往需要包装许多不同的对象。在Java类库中，**IO部分的内容庞大而广泛，包括标准输入输出，文件的操作，网络上的数据流，字符串流，对象流，zip文件流**。

### Java流的分类

按流向分：

- 输入流： 程序可以**从中读取**数据的流。
- 输出流： 程序可以**向其写入**数据的流。

按数据传输单位分：

- 字节流： 以**字节（8位）为单位**传输数据的流。
- 字符流： 以**字符（16位）为单位**传输数据的流。

按功能分：

- **节点流**用于**直接从目标设备（磁盘、网络等）读/写的流，又称为低级流**。
- **处理流**是对一个已存在的流进行连接和封装，通过对封装后的流来实现数据的读/写。使用相同的处理流可以消除不同节点流的差异，从而使用相同的代码来访问不同的数据源。处理流相比节点流在**性能上更加高效（增加了缓冲以提高效率），操作上更加便捷（提高了许多一次性输入输出大量内容的方法）**。
- **处理流对节点流的包装使用到了装饰器模式（Decorator Pattern）**。装饰器模式要求**所有包覆在原始对象之外的对象，都必须具有与之完全相同的接口**。这使得装饰器的用法变得非常的透明。无论对象是否被装饰过，传给它的消息总是相同的。这也是Java I/O类库要有"filter"类的原因：抽象的"filter"类是所有装饰器的基类。装饰器模式常用于如下的情形：如果用继承来解决各种需求的话，类的数量会多到不切实际的地步。Java的I/O类库需要提供很多功能的组合，于是装饰器模式就有了用武之地。为InputStream和OutputStream定义装饰器的类，分别是FilterInputStream和FilterOutputStream。

### java.io基类

流是一个很形象的概念，当程序需要读取数据的时候，就会开启一个通向数据源的流，这个数据源可以是文件，内存，或是网络连接。类似的，当程序需要写入数据的时候，就会开启一个通向目的地的流。这时候数据好像在这其中“流”动一样。
**Java中的流分为四种，分别由四个抽象类来表示**（分为字节流和字符流两类，每种流都有输入流和输出流，所以一共四个）：InputStream，OutputStream，Reader，Writer。Java中其他多种多样变化的流均是由它们派生出来的。JDK所提供的所有流类位于java.io包中，都分别继承自以下四种抽象流类：

- InputStream：所有继承自InputStream的流都是**用于从中读取数据**的，且**数据单位都是字节**（8位）；
- OutputSteam：所有继承自OutputStream的流都是程序**用于向外输出数据**的，且数据单位都是字节（8位）；
- Reader：所有继承自Reader的流都是**用于从中读取数据**的，且**数据单位都是字符**（16位）；
- Writer：所有继承自Writer的流都是程序**用于向外输出数据**的，且数据单位都是字符（16位）。

区别：Reader和Writer要解决的主要是国际化问题。原先的I/O类库只支持8位的字节流，因此不能很好地处理16位的Unicode字符流。Unicode是国际化的字符集(更何况Java内置的char就是16位的Unicode字符)，加入了Reader和Writer之后，所有的I/O就都支持Unicode了。此外新类库的性能也比旧的好。

但是，**Read和Write并不是取代InputStream和OutputStream，有时，你还必须同时使用"基于byte的类"和"基于字符的类"。为此，它还提供了两个"适配器(adapter)"类。InputStreamReader负责将InputStream转化成Reader，而OutputStreamWriter则将OutputStream转化成Writer**。

### InputStream类

```java
public abstract class InputStream extends Object implements Closeable
```

InputStream是读取**字节**数据用的抽象类。Inputstream抽象类中的常用方法：

- public **abstract int read()**：读取下一个byte的数据，返回读取的byte值（0~255，是一个高位补0的int类型值）。如果已经到了输入流的末尾，则返回-1；
- public int read(byte b[])：读取b.length个的byte数据放到b数组中。返回值是读取的字节数。该方法实际上是调用下一个方法实现的；
- public int read(byte b[], int off, int len)：从输入流中最多读取len个字节的数据，存放到偏移量为off的b数组中。如果已经到了输入流的末尾，则返回-1。该方法实际上是通过第一个方法实现的；
- public int available()：在不阻塞该输入流下次方法调用的情况下，返回该输入流中可以读取（或可跳过）的字节数的**估计值**。如果InputStream对象调用这个方法的话，它只会返回0，**这个方法由继承InputStream类的子类来重写后使用才有用**。注意：若输入阻塞，当前线程将被挂起；
- public int close() ：关闭该流对象并释放相关系统资源，**在使用完后必须关闭打开的流**。

### Reader类

```java
public abstract class Reader extends Object implements Readable, Closeable
```

Reader类是读取字符流的抽象基类，其子类必须实现的Reader类的方法有read(char[], int, int)和close()。Reader类方法如下：

- public boolean	ready()：判断当前字符流是否已准备好被读取。如果下一次用于输入的read()确定不会阻塞，则返回true，否则返回false。但返回false不一定会阻塞下次的read()操作；
- public int read()：读取一个字符的整数值。范围为0~65535；
- public int read(char[] cbuf)：从当前字符流中读取cbuf.length个字符到字符数组cbuf中。该方法实际上是调用下一个方法实现的；
- public abstract int read(char[] cbuf, int off, int len)：从当前字符流中最多读取len个字符的数据，存放到偏移量为off的字符数组cbuf中；
- int read(java.nio.CharBuffer target)：尝试读取字符流到特定的字符缓冲区中；
- public abstract void close()：关闭该流对象并释放相关系统资源。

InputStream类和Reader类都还含有以下方法：

- void mark(int readAheadLimit)：设置流对象的当前标记位置；
- boolean markSupported()： 测试此输入流是否支持 mark 和 reset 方法，并不是所有的输入流都支持这两个方法。默认总是返回false；
- void reset()： 将当前流重新定位到最后一次对此输入流调用 mark 方法时的位置；
- long skip(long n)：忽略输入流中的n个字节（或字符），返回值是实际忽略的字节（或字符）数, 跳过一些字节（字符）来读取。

### OutputStream类
OutputStream类的声明信息为：

```java
public abstract class OutputStream extends Object implements Closeable, Flushable
```

其中，Closeable接口（仅含一个void close()方法）表示可以关闭的操作，因为程序运行到最后肯定要关闭。Flushable接口（仅含一个void flush()方法）表示将缓冲区中数据全部输出，并清空缓冲区。OutputStream提供了3个write方法来执行数据的输出，这个和InputStream是相对应的：

- public abstract void write(int b)：先将int型的b参数的低8位构成的字节数值转换为byte类型，再把该byte值写入到该输出流中。
- public void write(byte b[ ])：将byte数组b中的b.length个字节数据写入到该输出流中。该方法是通过调用下面的方法实现的。
- public void write(byte b[ ], int off, int len)：将byte数组b的从偏移量off开始的len个字节数据写到该输出流中。
- public void flush() ：将数据缓冲区中数据全部输出到目标中，并清空缓冲区。该方法仅保证该输出流中的数据交给了操作系统来输出，并不保证数据会被写入到物理设备（如磁盘）中。
- public void close() ：关闭该输出流并释放与其相关的系统资源。输出流一旦关闭就不能进行输出操作，也不能被再次打开。

### Writer类

```java
public abstract class Writer extends Object implements Appendable, Closeable, Flushable
```

Writer类与OutputStream类似，是各种字符输出流的抽象父类。其子类必须实现write(char[], int, int)、flush()、和close()方法。其主要方法如下：

- public void write(int c)：将一个字符写入该字符输出流中。
- public void write(char[] cbuf)：将一个字符数组写入该字符输出流中。
- public abstract void write(char[] cbuf, int off, int len)：将一个字符数组的部分内容写入该字符输出流中。
- public void write(String str)：将一个字符串写入该字符输出流中。
- public void write(String str, int off, int len)：将一个字符串的部分内容写入该字符输出流中。
- public Writer append(char c)：在该字符输出流后面追加指定的字符。
- public Writer append(CharSequence csq)：在该字符输出流后面追加指定的字符串。
- public Writer append(CharSequence csq, int start, int end)：在该字符输出流的后天追加指定字符串的指定子字符串（通过start和end参数来指定子字符串）。
- public abstract void close()：关闭该字符输出流，首先flush它。对已关闭的字符输出流执行write和flush操作会抛出IOException异常。
- public abstract void flush()：将数据缓冲区中数据全部输出到目标中，并清空缓冲区。如果目标是一个Writer或OutputStream，则会递归flush所有缓冲区。

注意：

- **上述各方法都有可能引起异常**。
- **以上四个基类都是抽象类，不能创建对象。其所含的基本方法被子类重写后才有意义**。
- **在操作的时候，如果目标文件本身不存在，则会为用户自动创建新文件。IO操作中默认是将其进行覆盖的，如果要想执行追加的功能，则必须设置追加的操作**。
- **字节流在操作的时候本身是不会用到缓冲区(内存)的，而是直接操作文件本身，而字符流在操作的时候是使用到缓冲区的**。
- **使用IO操作进行数据输出后，必须关闭输出流。关闭输出流可以保证物理资源被回收，可能还会将缓冲区的数据flush到物理节点（对于字符流来说）**。
- **处理流的构造器参数为一个已经存在的节点流，节点流的构造器参数为一个物理节点。一般使用处理流操作简单，执行效率高。比如关闭流时，只需要关闭上层的处理流即可，其包装的下层节点流会自动关闭**。
##Java的输入/输出流体系

![img](http://img.blog.csdn.net/20161204101157399)

### 字节流体系 
#### FileInputStream类
FileInputStream类是InputStream类的子类，用于**从文件系统中的某个文件中获得输入字节**。哪些文件可用取决于主机环境。**也可用于读取诸如图像数据之类的原始字节流。其构造器可以是一个表示文件名的字符串，也可以是File或FileDescriptor对象**：

- FileInputStream(File file)：通过打开一个到实际文件的连接来创建一个 FileInputStream，该文件通过文件系统中的 File 对象 file 指定。 
- FileInputStream(FileDescriptor fdObj)：通过使用文件描述符 fdObj 创建一个 FileInputStream，该文件描述对象表示**到文件系统中某个实际文件的连接（connection）**，该文件正在被该FileInputStream使用。 
- FileInputStream(String name)：通过打开一个到实际文件的连接来创建一个 FileInputStream，该文件通过文件系统中的路径名 name 指定。 

 扩展方法方法如下：

- FileChannel getChannel() ：返回唯一与该文件输入流相关连的FileChannel对象。 
- FileDescriptor getFD() ：返回一个表示**到文件系统中某个实际文件的连接**的FileDescriptor对象，该文件正在被该FileInputStream使用。 

使用步骤：
1. 关联一个文件以得到一个输入流；
2. 进行读取操作；
3. 关闭该输入流。

注意：

- 用字节流读取中文显示到控制台会出现乱码，因为汉字占两个字节，而FileInputStream每次只能读一个字节，然后就把它转为了字符，而写入文本文件不会出现此情况。
- **如果希望看到正常的文本显示，那么应该在打开文本文件时使用和保存该文本文件时相同的字符集**（Windows下简体中文默认使用GBK字符集，Linux下简体中文默认使用UTF-8字符集）。
- **如果输入输出的内容是文本内容，则应该考虑使用字符流。如果输入输出的内容是二进制内容，则应该考虑使用字节流**。
- **在使用字节流操作中，即使没有关闭，最终也是可以输出的。而在使用字符流的操作中，所有的内容现在都是保存在缓冲区中，在执行关闭操作的时候会强制刷新缓冲区，所以可以把内容输出。如果没有关闭的话，也可以手工调用刷新方法flush()来输出**。 
```java
public class FileInputStreamReview {
    public static void main(String[] args) {
        // test1();
        test2();
    }
  
    /**
     * 文件输入流的创建方式以及字节缓冲流
	 */
	private static void test2() throws IOException {
		// 以代表文件的File对象或String对象为构造器参数创建FileInputStream对象
		// FileInputStream fis = new FileInputStream(new File("jar.txt"));
		FileInputStream fis = new FileInputStream("jar.txt");
		BufferedInputStream bis = new BufferedInputStream(fis);
		// 读取到一个字节数组 
		// byte[] buff = new byte[2*1024];
		// int len = -1;
		// while ((len=bis.read(buff)) != -1) {
		// System.out.println(new String(buff, 0, len));
	// }
      
		// 读取到一个字节, 汉字为2个字节，读取汉字时出现乱码
		int b = -1;
		StringBuilder sb = new StringBuilder();
		while ((b = bis.read()) != -1) {
			sb.append((char)b);
		}
		System.out.println(sb.toString());  
		bis.close();
	}

	/**
	 * 读取的常见三种方式
	 */
	private static void test() throws IOException {
		FileInputStream fis = new FileInputStream("jar.txt");
		// 每次读取一个字符数组，效率高，而且读取中文时不会出现乱码
		// byte[] buff = new byte[1024];
		// int len = 0;
		// while((len = fis.read(buff)) != -1){
		// System.out.print(new String(buff, 0, len));
	// }

	// 每次读取一个字符，效率低
	int ch;
	while((ch = fis.read()) != -1){
		System.out.print((char)ch);
	}

	// 创建的byte数组与流等大小。慎用，如果流过大，则创建字节数组失败
	// byte[] buf = new byte[fis.available()]; //创建一个和流等大小的字节数组
	// fis.read(buf);
	// System.out.println(new String(buf));
	fis.close();
	}
}
```
#### FileOutputStream类
FileOutputStream类是OutputStream抽象类的子类，用于将数据写入File或FileDescriptor 表示的文件中。文件是否可用或是否可以被创建取决于基础平台。特别是某些平台一次只允许一个FileOutputStream（或其他文件写入对象）打开文件进行写入。在这种情况下，如果所涉及的文件已经打开，则此类中的构造方法将失败。FileOutputStream用于写入诸如图像数据之类的原始字节的流。要写入字符流，请考虑使用FileWriter。

构造器摘要：

- FileOutputStream(File file) ：创建一个向指定 File 对象表示的文件中写入数据的文件输出流。 
- FileOutputStream(File file, boolean append) ：创建一个向指定 File 对象表示的文件中写入数据的文件输出流。 
- FileOutputStream(FileDescriptor fdObj)：创建一个向指定文件描述符处写入数据的输出文件流，该文件描述符表示一个到文件系统中的某个实际文件的现有连接。 
- FileOutputStream(String name) ：创建一个向具有指定名称的文件中写入数据的输出文件流。 
- FileOutputStream(String name, boolean append) ：创建一个向具有指定 name 的文件中写入数据的输出文件流。 

 扩展方法摘要：

- protected  void finalize()：清理到文件的连接，并确保在不再引用此文件输出流时调用此流的 close 方法。 
- FileChannel getChannel()：返回与此文件输出流有关的唯一 FileChannel 对象。 
- FileDescriptor getFD()：返回与此流有关的文件描述符。 

示例：
```java
 /**
  * 从一个文件中读取，并将内容写入另一个文件
  * @throws IOException 
  */
private static void test() throws IOException {
	  FileInputStream fis = fis = new FileInputStream("jar.txt");
      FileOutputStream fos = fos=new FileOutputStream("fos.txt",true); // true表示可附加内容    
      byte[] buf = new byte[1024];
      int len = -1;
      while((len = fis.read(buf)) != -1){
	      fos.write(buf, 0, len);
      }
      fis.close();
      fos.close();
}
```

#### ObjectInputStream类和ObjectOutputStream类与序列化机制
序列化的含义：若要**将Java对象持久地保存在磁盘上或在网络上传输，以便以后恢复该对象**，那么**该对象必须转化为平台无关的字节序列，转换的过程称为序列化（Serializable ），恢复序列化对象的过程称为反序列化（Dserializable）**。

可序列化对象的类**必须实现java.io.Serializable或java.io.Externalizable接口之一**。**其中实现Serializable接口时无须实现任何方法，该接口只是负责标记其实现类的对象是可序列化的**。

##### ObjectInputStream类

**ObjectInputStream用于对之前使用ObjectOutputStream写入的基本数据和对象进行反序列化**，其他用途包括**使用套接字流在主机之间传递对象**，或者用于marshal和unmarshal远程通信系统中的实参和形参。 

构造器摘要：

ObjectInputStream(InputStream in)：从指定InputStream创建ObjectInputStream对象。 

除了从基类继承的方法，**它主要功能是对基本类型与引用类型的读取**。主要方法摘要：

- int readInt()：读取一个 32 位的 int 值。 
- Object readObject() ：从ObjectInputStream中读取一个对象（包括字符串和数组）。 该方法的返回值一般还需要强制类型转换成期望的类型。
- String readUTF()：读取UTF-8修改版格式的String。 
- int read()：读取数据字节。
- int read(byte[] buf, int off, int len) ：将数据读入到byte类型的buf数组中。 

反序列化注意：

- **当有多个Java对象写入流中时，必须使用与写入对象时相同的类型和顺序从相应ObjectInputstream中读回对象**。
- **反序列化读取的仅是Java对象，而不是Java类，因此恢复对象时必须提供该对象的类对应的`.class`文件，否则抛出ClassNotFoundException异常**。
- **由于读取的是对象实例，故不必调用构造器来创建实例，反序列化的结果就是对象实例。读取对象时为对象分配内存并将其初始化为零 (NULL)**。
- **应该使用Java的安全强制转换来获取所需的类型。在Java中，字符串和数组都是对象，所以在序列化期间将其视为对象。读取时，需要将其强制转换为期望的类型。可以使DataInput接口上的适当方法从ObjectInputStream中读取基本数据类型**。
- 反序列化一个对象时会恢复其写入时的每个field的类型和值，其中，声明为transient或static的field会被忽略。

示例：
```java
private static void read() throws FileNotFoundException, IOException, ClassNotFoundException {
	FileInputStream fis = new FileInputStream("t.tmp");
	// 包装FileInputStream对象来创建ObjectInputStream对象
	ObjectInputStream ois = new ObjectInputStream(fis);
	// 按与写入对象时相同的类型和顺序依次读取
	int readInt = ois.readInt();
	// 如果知道读取对象实际类型时则将其强制转换为期望的类型
	String string = (String) ois.readObject();
	Date date = (Date) ois.readObject();

	System.out.println("readInt="+readInt);
	System.out.println("string="+string);
	System.out.println("date="+date);
	ois.close();
}
```
##### ObjectOutputStream类
ObjectOutputStream类用于将基本数据类型和Java对象的图形（graph）写入一个OutputStream以实现序列化。可以使用ObjectInputStream来读取（重构）已序列化的对象。

构造器摘要：

ObjectOutputStream(OutputStream out)：创建写入指定OutputStream的ObjectOutputStream。 

除了从基类继承的方法，它主要功能是对基本类型与引用类型进行序列化。主要方法摘要：

- void writeBytes(String str)：以字节序列形式写入一个String。 
- void writeObject(Object obj)：将指定的对象写入到该ObjectOutputStream中。所有对象（包括String和数组）都是通过该方法进行序列化写入的。该方法可以写入多个对象或基本类型数据。 
- void writeUTF(String str)：以 UTF-8 修改版格式写入此String的基本数据。 

序列化注意事项：

- **ObjectOutputStream类和ObjectInputStream类是处理流类，一般分别包装FileOutputStream类和FileInputStream类的对象使用**。
- 对象的默认序列化机制写入的内容是：类名、类签名、该对象的所有非transient实例变量（包括基本类型、数组以及对其他对象的引用），而方法、类变量、transient实例变量（也称为瞬态实例变量）都不会被序列化。**如果某个类的成员变量不是基本类型或String类型（都已实现了序列化接口），而是其他引用类型，那么这些引用对象也会被序列化，这就是序列化机制的递归序列化过程。所以这些引用对象也必须是可序列化的，否则，即使其所在的类实现了序列化接口也是不可序列化的**。
- **一个可序列化类的所有父类（直接父类和间接父类）中，要么有无参数构造器，要么也是可序列化的，否则，反序列化时会抛出InvalidClassException。如果可序列化类的父类不可序列化，则必须带有无参数构造器来初始化其field，该父类中定义的成员变量不会被序列化到二进制流中，这种情况下应该交由当前可序列化类来负责存储和恢复其不可序列化父类的状态信息。**
- **所有保存到磁盘中的对象都有一个序列化编号。如果在序列化时一个对象在本次虚拟机中从未被序列化过，那么就会被序列化，如果被序列化过，那么直接输出一个序列化编号，而不是重新序列化。也就是说，如果多次序列化中包含了同一个引用对象，那么该对象只会被序列化依次，而不是重复序列化同一个对象。在序列化可变对象时，由于只有第一次调用writeObject方法时才会序列化该对象，如果后续修改了该对象并再次序列化则会无效，因为该对象已经序列化过了**。
- 基本数据类型可以使用DataOutput的相关方法来写到序列化流中。字符串也可以通过writeUTF方法来写到序列化流中。

实例：
```java
public class Person implements java.io.Serializable {
	// 成员变量为String类型和基本类型
	private String name;
	private int age;
	// 注意此处没有提供无参数的构造器!
	public Person(String name , int age) {
		System.out.println("有参数的构造器");
		this.name = name;
		this.age = age;
	}
	// 省略name与age的setter和getter方法
}
```
```java
public class Teacher implements java.io.Serializable {
	private String name;
	//其成员变量为引用类型
	private Person student;
	public Teacher(String name , Person student) {
		this.name = name;
		this.student = student;
	}
	// 此处省略了name和student的setter和getter方法
}
```
```java
public class ObjectStreamDemo {
	public static void main(String[] args) throws IOException, ClassNotFoundException {
		// 由于我们要对对象进行序列化，所以我们先自定义一个类
		// 序列化数据其实就是把对象写到文本文件
		write();
		read();
	}
	
	private static void read() {
		try(
			// 创建一个ObjectInputStream输出流
			ObjectInputStream ois = new ObjectInputStream(new FileInputStream("teacher.txt"))) {
			// 依次按写入顺序读取ObjectInputStream输入流中的四个对象
			Teacher t1 = (Teacher)ois.readObject();
			Teacher t2 = (Teacher)ois.readObject();
			Person p = (Person)ois.readObject();
			Teacher t3 = (Teacher)ois.readObject();
			// 输出true
			System.out.println("t1的student引用和p是否相同：" + (t1.getStudent() == p));
			// 输出true
			System.out.println("t2的student引用和p是否相同：" + (t2.getStudent() == p));
			// 输出true
			System.out.println("t2和t3是否是同一个对象：" + (t2 == t3));
		}
		catch (Exception ex) {
			ex.printStackTrace();
		}
	}

	private static void write() {
		try(
			// 创建一个ObjectOutputStream输出流
			ObjectOutputStream oos = new ObjectOutputStream(new FileOutputStream("teacher.txt"))) {
			Person per = new Person("孙悟空", 500);
			Teacher t1 = new Teacher("唐僧", per);
			Teacher t2 = new Teacher("菩提祖师", per);
			// 依次将四个对象写入输出流
			oos.writeObject(t1);
			oos.writeObject(t2);
			// 因为t1和t2都包含了相同的per对象，所以下面的两次序列化写入的是跟之前相同的已序列化对象
			oos.writeObject(per);
			oos.writeObject(t2);
		}
		catch (IOException ex){
			ex.printStackTrace();
		}
	}
}
```

##### 自定义序列化
**可用transient关键字声明那些不需要序列化的实例变量，从而保护一些敏感信息（如帐号密码等），或者跳过一些不可序列化的成员，以免发生java.io.NotSerializableException异常**。

> 注意：**transient关键字只能用于修饰成员变量**。

示例：
```java
 public class Person implements java.io.Serializable {
	private String name;
	// 使用transient修饰的成员变量不会被序列化
	private transient int age;
	// 注意此处没有提供无参数的构造器!
	public Person(String name, int age) {
		System.out.println("有参数的构造器");
		this.name = name;
		this.age = age;
	}
	// 省略name与age的setter和getter方法
}
```
```java
public class TransientTest {
	public static void main(String[] args) {
		try(
			// 创建一个ObjectOutputStream输出流
			ObjectOutputStream oos = new ObjectOutputStream(new FileOutputStream("transient.txt"));
			// 创建一个ObjectInputStream输入流
			ObjectInputStream ois = new ObjectInputStream(new FileInputStream("transient.txt"))) {
			Person per = new Person("孙悟空", 500);
			// 系统会将per对象转换为字节序列并输出，但是没有输出transient修饰的age变量信息
			oos.writeObject(per);
			Person p = (Person)ois.readObject();
			System.out.println(p.getAge());
		}
		catch (Exception ex) {
			ex.printStackTrace();
		}
	}
}
```
**使用transient关键字定义序列化机制虽然简单方便，但是其修饰的成员因为没有被序列化而无法恢复**。Java提供了一种自定义序列化机制，通过这种**自定义序列化机制可以控制如何序列化各实例变量，包括不序列化某些变量(与transient功能相同)**。

序列化和反序列化中需要特殊处理的类需要提供以下方法签名：

- private void writeObject(ObjectOutputStream os) throws IOException：该方法负责写入对象的状态信息，以便相应的readObject方法可以恢复它。通过重写该方法，程序员可以自主决定哪些实例变量需要序列化以及如何序列化。该方法不用去关心当前对象的父类或子类的状态。默认情况下，该方法会调用out.defaultWriteObject方法来保存java对象的各实例变量来完成序列化。
- private void readObject(ObjectInputStream in) throws IOException, ClassNotFoundException：与writeObject相反，该方法负责实现反序列化规则。通过重写该方法，程序员可以自主决定哪些实例变量需要反序列化以及如何反序列化，默认情况下，该方法会调用in.defaultReadObject来恢复java对象的非瞬态实例变量。
- private void readObjectNoData() throws ObjectStreamException：在接收方反序列化过程和发送发的序列化的版本不兼容时，或者接收方版本扩展的类不是发送方版本扩展的类，或者序列化流被扩展时，系统都会调用该方法用于正确地初始化反序列化对象。


 示例：
```java
public class Person implements java.io.Serializable {
    private String name;
    private int age;
    // 注意此处没有提供无参数的构造器!
    public Person(String name , int age) {
        System.out.println("有参数的构造器");
        this.name = name;
        this.age = age;
    }
    // 省略name与age的setter和getter方法
	private void writeObject(java.io.ObjectOutputStream out) throws IOException {
        // 将name实例变量的值反转后写入二进制流
        out.writeObject(new StringBuffer(name).reverse());
        out.writeInt(age);
    }
    private void readObject(java.io.ObjectInputStream in) throws IOException, ClassNotFoundException {
        // 将读取的字符串反转后赋给name实例变量
        this.name = ((StringBuffer)in.readObject()).reverse().toString();
        this.age = in.readInt();
    }
}
```
> 注意：writeObject()方法存储实例变量的顺序和readObject()方法恢复实例变量的顺序应该一致，否则不能正确地恢复该对象。

有种序列化机制**可以在序列化时替换原对象**，这种序列化机制需要为待序列化对象的类提供如下特殊方法：

```java
// 只要该方法存在就会被序列化机制调用
private | protected | default | public  Object writeReplace() throws ObjectStreamException;
```
```java
public class Person implements java.io.Serializable {
    private String name;
    private int age;
    // 注意此处没有提供无参数的构造器!
    public Person(String name , int age) {
        System.out.println("有参数的构造器");
        this.name = name;
        this.age = age;
    }
    // 省略name与age的setter和getter方法
    // 重写writeReplace方法，程序在序列化该对象之前，先调用该方法
    private Object writeReplace() throws ObjectStreamException {
        ArrayList<Object> list = new ArrayList<>();
        list.add(name);
        list.add(age);
        return list;
    }
}
```
```java
public class ReplaceTest {
    public static void main(String[] args) {
        try(
            // 创建一个ObjectOutputStream输出流
            ObjectOutputStream oos = new ObjectOutputStream(new FileOutputStream("replace.txt"));
            // 创建一个ObjectInputStream输入流
            ObjectInputStream ois = new ObjectInputStream(new FileInputStream("replace.txt"))) {
            Person per = new Person("孙悟空", 500);
            // 系统将per对象转换字节序列并输出
            oos.writeObject(per);
            // 反序列化读取得到的是ArrayList
            ArrayList list = (ArrayList)ois.readObject();
            System.out.println(list);
        }
        catch (Exception ex) {
            ex.printStackTrace();
        }
    }
}
```
还有一种反序列化机制**可以实现保护性复制整个对象**，这种机制需要待序列化对象的类提供如下方法：

```java
private | protected | default | public Object readResolve() throws ObjectStreamException
```

1. 该方法并不是用来恢复writeReplace()的。使用writeReplace()后默认已经被彻底替换了，一旦实现了writeReplace()在写入时进行替换就不再需要为待序列化对象的类提供writeObject()和readObject()的实现了，直接通过调用ObjectInputStream的readObject()方法就可以反序列化被替换的结果了。该方法会紧跟着readObject()之后自动调用，该方法的返回值将会作为ObjectInputStream的readObject的返回结果。该方法起到的作用：
   - 调用该方法之前会先调用readObject反序列化得到对象；
   - 接着，如果该方法存在则会自动调用该方法；
   - 在该方法中可以正常通过this访问到刚才反序列化得到的对象的内容；
   - 然后可以根据这些内容进行一定处理返回一个对象；
   - 该对象将作为ObjectInputStream的readObject的返回值（即该对象将作为对象输入流的最终输入）。
2. readResolve方法最重要的应用就是保护性恢复单例、枚举类型的对象。如果使用Java的enum关键字来定义枚举类型则不需要了。Java 5之后的版本都实现了enum类型的自动保护性恢复，但是java 5之前的老版本还是不行。
3. 对于final类重写readResolve()方法没有问题。为了不使继承父类的readResolve()方法出现问题（子类如果不重写该方法就会被反序列化为父类类型，这是对子类来说是一种负担。甚至子类可能根本无法重写该方法），最好在重写该方法时使用private修饰，这样就不会影响到子类的反序列化了。

**Java 5之前的枚举类序列化**示例： 
```java
public class Orientation implements java.io.Serializable {
    public static final Orientation HORIZONTAL = new Orientation(1);
    public static final Orientation VERTICAL = new Orientation(2);
    private int value;
    private Orientation(int value){
        this.value = value;
    }
    // 为枚举类增加readResolve()方法
    private Object readResolve() throws ObjectStreamException {
        if (value == 1) {
            return HORIZONTAL;
        }
        if (value == 2) {
            return VERTICAL;
        }
        return null;
    }
}
```
```java
public class ResolveTest{ 
    public static void main(String[] args) {
        try(
            // 创建一个ObjectOutputStream输入流
            ObjectOutputStream oos = new ObjectOutputStream(
                new FileOutputStream("transient.txt"));
            // 创建一个ObjectInputStream输入流
            ObjectInputStream ois = new ObjectInputStream(
                new FileInputStream("transient.txt"))) {
            oos.writeObject(Orientation.HORIZONTAL);
            Orientation ori = (Orientation)ois.readObject();
            // 返回为true
            System.out.println(ori == Orientation.HORIZONTAL);
        }
        catch (Exception ex) {
            ex.printStackTrace();
        }
    }
}
```
实现Externalizable接口可以让程序员完全控制序列化的数据，实现该接口需要待序列化对象的类实现下面两个方法：

-  void writeExternal(ObjectOutput out)：负责实现序列化。该方法通过调用DataOutput（ObjectOutput的父接口）的方法来保存基本类型的实例变量值，调用ObjectOutput的writeObject方法来保存引用类型的实例变量值。
-  void readExternal(ObjectInput in)：负责实现反序列化。该方法通过调用DataInput(ObjectInput的父接口)的方法来恢复基本类型的实例变量值，调用ObjectInput的readObject方法来恢复引用类型的实例变量值。

相比实现Serializable接口，实现Externalizable接口更加高效一点，但实现Serializable接口更加灵活，其最重要的特色就是可以自动序列化，这也是其应用更广泛的原因。实现Externallizable接口可以提高自定义序列化的性能，但是更加复杂。一般推荐实现Serialiable接口。

**待序列化类可以提供一个名为serialVersionUID的私有静态常量来表示Java类的序列化版本信息，可以避免因项目升级导致的class文件兼容性问题。推荐自定义该常量的值，因为系统默认自动生成的该值会因类的修改(主要是修改非瞬态的实例变量)而不同，导致反序列化失败**。当然，如果保证不同版本间的不兼容可以使用系统生成的默认值。

可以通过调用JDK安装目录的bin子目录中的`serialver.exe`工具生成serialVersionUID（根据类名，接口名，方法和属性等来生成的），如执行： 

```shell
serialver Person
```

则输出：

```shell
Person：static final long serialVersionUID = 4603642343377807741L;
```

或者执行：

```shell
serialer -show Person 
```

则显示出图形化界面。

####PipedInputStream
管道输入流应该连接到管道输出流.管道输入流提供要写入管道输出流的所有数据字节。 
通常，数据由某个线程从 PipedInputStream 对象读取，并由其他线程将其写入到相应的 PipedOutputStream。
不建议对这两个对象尝试使用单个线程，因为这样可能死锁线程。管道输入流包含一个缓冲区，可在缓冲区限定的范围内将读操作和写操作分离开。如果向连接管道输出流提供数据字节的线程不再存在，则认为该管道已损坏。

管道连接的两种方式：

    1. 在构造时以管道输出流对象做参数来构造，即使用PipedInputStream(PipedOutputStream src) 构造
    2. 使用connect(PipedOutputStream src) 方法来建立连接

构造器摘要：

- PipedInputStream() ：创建尚未连接的 PipedInputStream。 
- PipedInputStream(int pipeSize) ：创建一个尚未连接的 PipedInputStream，并对管道缓冲区使用指定的管道大小。 
- PipedInputStream(PipedOutputStream src) ：创建 PipedInputStream，使其连接到管道输出流 src。 
- PipedInputStream(PipedOutputStream src, int pipeSize) ：创建一个 PipedInputStream，使其连接到管道输出流 src，并对管道缓冲区使用指定的管道大小。 

方法摘要：

- int available() ：返回可以不受阻塞地从此输入流中读取的字节数。 
- void connect(PipedOutputStream src) ：使此管道输入流连接到管道输出流 src。 
- int read() ：读取此管道输入流中的下一个数据字节。 
- int read(byte[] b, int off, int len) ：将最多 len 个数据字节从此管道输入流读入 byte 数组。 

#### PipedOutputStream
可以将管道输出流连接到管道输入流来创建通信管道。管道输出流是管道的发送端。通常，数据由某个线程写入 PipedOutputStream 对象，并由其他线程从连接的 PipedInputStream 读取。
不建议对这两个对象尝试使用单个线程，因为这样可能会造成该线程死锁。如果某个线程正从连接的管道输入流中读取数据字节，但该线程不再处于活动状态，则该管道被视为处于 毁坏 状态。

构造器摘要：

- PipedOutputStream() ：创建尚未连接到管道输入流的管道输出流。 
- PipedOutputStream(PipedInputStream snk) ：创建连接到指定管道输入流的管道输出流。 
  ​        
  方法摘要：

- void connect(PipedInputStream snk) ：将此管道输出流连接到接收者。 
- void flush() ：刷新此输出流并强制写出所有缓冲的输出字节。 
- void write(byte[] b, int off, int len) ： 将 len 字节从初始偏移量为 off 的指定 byte 数组写入该管道输出流。 
- void write(int b) ：将指定 byte 写入传送的输出流。 

使用示例：
```java
public class PipedStream {
    public static void main(String[] args) throws IOException {

        PipedInputStream input = new PipedInputStream();
        PipedOutputStream output = new PipedOutputStream();

        // 使输入管道流与输出管道流联通
        input.connect(output);

        new Thread(new Input(input)).start();
        new Thread(new Output(output)).start();

    }

}

class Input implements Runnable {

    private PipedInputStream in;

    Input(PipedInputStream in) {
        this.in = in;
    }

    public void run() {

        try {
            byte[] buf = new byte[1024];
            int len = -1;
            //read 读取从管道输出流写入的数据，没有读到数据则阻塞
            while ((len = in.read(buf)) != -1) {
                String s = new String(buf, 0, len);
                System.out.println("s=" + s);
            }
            in.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

    }
}

class Output implements Runnable {
    private PipedOutputStream out;

    Output(PipedOutputStream out) {
        this.out = out;
    }

    public void run() {

        try {
            while (true) {  // 模拟数据写入
                Thread.sleep(3000);
                out.write("Output管道写入的数据！".getBytes());
            }
        } catch (Exception e) {
            e.printStackTrace();
        }finally{
            try {
                out.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }
}
```
#### SequenceInputStream
序列流，用于将多个输入流串联起来，形成一个更大的流，以方便对多个文件的同时操作。 从第一个输入流开始读取，直到到达文件末尾，接着从第二个输入流读取，依次类推，直到到达包含的最后一个输入流的文件末尾为止。

构造器摘要：

- SequenceInputStream(Enumeration&lt;? extends InputStream> e) ：通过记住参数来初始化新创建的 SequenceInputStream，该参数必须是生成运行时类型为 InputStream 对象的 Enumeration 型参数。 将按顺序读取由该枚举生成的输入流，以提供从此 SequenceInputStream 读取的字节。在用尽枚举中的每个输入流之后，将通过调用该流的 close 方法将其关闭。 
- SequenceInputStream(InputStream s1, InputStream s2) ：通过记住这两个参数来初始化新创建的 SequenceInputStream（将按顺序读取这两个参数，先读取 s1，然后读取 s2），以提供从此 SequenceInputStream 读取的字节。 

方法摘要：

- int available() ：返回不受阻塞地从当前底层输入流读取（或跳过）的字节数的估计值，方法是通过下一次调用当前底层输入流的方法。 
- void close() ：关闭此输入流并释放与此流关联的所有系统资源。 
- int read() ：从此输入流中读取下一个数据字节。 
- int read(byte[] b, int off, int len) ：将最多 len 个数据字节从此输入流读入 byte 数组。

示例1：
1.两个流的情况 
需求：把a.java和b.java的内容复制到copy.java中。 
使用 SequenceInputStream(InputStream s1, InputStream s2)构造实现
```java
public class SequenceInputStreamDemo {
    public static void main(String[] args) throws IOException {
        InputStream s1 = new FileInputStream("a.java");
        InputStream s2 = new FileInputStream("b.java");
        // SequenceInputStream(InputStream s1, InputStream s2)
        SequenceInputStream sis = new SequenceInputStream(s1, s2);
        BufferedOutputStream bos = new BufferedOutputStream(
                new FileOutputStream("copy.java"));

        byte[] bys = new byte[1024];
        int len = -1;
        while ((len = sis.read(bys)) != -1) {
            bos.write(bys, 0, len);
        }

        bos.close();
        sis.close();
    }
}
```
示例2：多个流的情况 
需求：把三个文件a.java,b.java,c.java的内容复制到copy.java中 
使用SequenceInputStream(Enumeration e)构造方法来实现多个流的串联
```java
public class SequenceInputStreamDemo {
    public static void main(String[] args) throws IOException {
        // 创建Vector用于存储输入流
        Vector<InputStream> v = new Vector<InputStream>();
        InputStream s1 = new FileInputStream("a.java");
        InputStream s2 = new FileInputStream("b.java");
        InputStream s3 = new FileInputStream("c.java");
        v.add(s1);
        v.add(s2);
        v.add(s3);
        // Enumeration是Vector的elements()方法的返回值类型，Enumeration<E> elements()
        Enumeration<InputStream> en = v.elements();
        SequenceInputStream sis = new SequenceInputStream(en);
        BufferedOutputStream bos = new BufferedOutputStream(
                new FileOutputStream("copy.java"));

        byte[] bys = new byte[1024];
        int len = 0;
        while ((len = sis.read(bys)) != -1) {
            bos.write(bys, 0, len);
        }

        bos.close();
        sis.close();
    }
}
```
#### ByteArrayInputStream
ByteArrayInputStream 包含一个内部缓冲区，该缓冲区包含从流中读取的字节。内部计数器跟踪 read 方法要提供的下一个字节。关闭 ByteArrayInputStream 无效。此类中的方法在关闭此流后仍可被调用，而不会产生任何 IOException。

构造器摘要：

- ByteArrayInputStream(byte[] buf) ：创建一个 ByteArrayInputStream，使用 buf 作为其缓冲区数组。 
- ByteArrayInputStream(byte[] buf, int offset, int length)：创建 ByteArrayInputStream，使用 buf 作为其缓冲区数组。 

字段摘要：

- protected byte[] buf：由该流的创建者提供的 byte 数组。元素 buf[0] 到 buf[count-1] 是只能从流中读取的字节；元素 buf[pos] 是要读取的下一个字节。 
- protected int pos：要从输入流缓冲区中读取的下一个字符的索引。此值应该始终是非负数，并且不应大于 count 值。从输入流缓冲区中读取的下一个字节是 buf[pos]。 
- protected int mark：流中当前的标记位置。构造时默认将 ByteArrayInputStream 对象标记在位置零处。通过 mark() 方法可将其标记在缓冲区内的另一个位置处。通过 reset() 方法将当前缓冲区位置设置为此点。 
  如果尚未设置标记，则标记值是传递给构造方法的偏移量（如果未提供偏移量，则标记值为 0）。 
- protected int count：比输入流缓冲区中最后一个有效字符的索引大一的索引。此值应该始终是非负数，并且不应大于 buf 的长度。它比 buf 中最后一个可从输入流缓冲区中读取的字节位置大一。 

此类的方法与父类相同，侧重于读。不贴出了。
示例：
```java
private static void test1() {
	byte[] buf=new byte[]{'h','e','l','l','o'};
	// 用一个字节数组来构造一个ByteArrayInputStream
	ByteArrayInputStream bais = new ByteArrayInputStream(buf,0,3);
	byte[] buff = new byte[bais.available()-1];
	try {
		bais.read(buff);
	System.out.println(new String(buff));
	} catch (IOException e) {
		e.printStackTrace();
	}finally{
	try {
		// 关闭 ByteArrayInputStream 无效，是一个空实现
		bais.close(); 
	} catch (IOException e) {
	e.printStackTrace();
	}
}   

// 仍然可以继续读
int read = bais.read();
System.out.println((char)read);
}
```
#### ByteArrayOutputStream
此类实现了一个输出流，其中的数据被写入一个 byte 数组。缓冲区会随着数据的不断写入而自动增长。 
可使用 toByteArray() 和 toString() 获取数据。关闭 ByteArrayOutputStream 无效。此类中的方法在关闭此流后仍可被调用，而不会产生任何 IOException。

构造器摘要：

- ByteArrayOutputStream() ：创建一个新的 byte 数组输出流。 
- ByteArrayOutputStream(int size) ：创建一个新的 byte 数组输出流，它具有指定大小的缓冲区容量（以字节为单位）。 

特有方法摘要：

- int size() ：返回缓冲区的当前大小。 
- byte[] toByteArray() ：创建一个新分配的 byte 数组。 
- String toString() ：使用平台默认的字符集，通过解码字节将缓冲区内容转换为字符串。 
- String toString(String charsetName) ：使用指定的 charsetName，通过解码字节将缓冲区内容转换为字符串。 
- void writeTo(OutputStream out) ：将此 byte 数组输出流的全部内容写入到指定的输出流参数中，这与使用 out.write(buf, 0, count) 调用该输出流的 write 方法效果一样。

```java
 private static void test() throws IOException {
        ByteArrayOutputStream baos=new ByteArrayOutputStream();
        byte[] buf=new byte[]{'h','e','l','l','o','w','o','r','l','d'};
        baos.write(buf, 0, buf.length-5);
        System.out.println(baos.toString());
        baos.close(); // 空实现
        // 继续往流中写入
        baos.write(buf, 5, 5);
        System.out.println(baos.toString());
}
```
#### BufferedInputStream
为另一个输入流添加一些功能，即缓冲输入以及支持 mark 和 reset 方法的能力。在创建 BufferedInputStream 时，会创建一个内部缓冲区数组。缓冲区用以减少频繁的IO操作，提高程序的性能。
在读取或跳过流中的字节时，可根据需要从包含的输入流再次填充该内部缓冲区，一次填充多个字节。mark 操作记录输入流中的某个点，reset 操作使得在从包含的输入流中获取新字节之前，再次读取自最后一次 mark 操作后读取的所有字节。

构造器摘要：
- BufferedInputStream(InputStream in) ：创建一个 BufferedInputStream 并保存其参数，即输入流 in，以便将来使用。 
- BufferedInputStream(InputStream in, int size) ：创建具有指定缓冲区大小的 BufferedInputStream 并保存其参数，即输入流 in，以便将来使用

此类的方法与父类无异，不贴出。
示例：BufferedInputStream性能测试
```java
/**
 * @author pecu
 * 
 *         效率测试
 * 
 *         FileInputStream 
 *               ①read()    35950毫秒 
 *               ②read(buff) 62毫秒
 * 
 *         BufferedInputStream
 *               ③read()    295毫秒   
 *               ④read(buff) 18毫秒
 * 
 */
public class EfficiencyTest {

    public static void main(String[] args) throws IOException {
        //test1();
        //test2();
        //test3();
        test4();
    }

    // BufferedInputStream ④read(buff) 18毫秒
    private static void test4() throws IOException {
        long start = System.currentTimeMillis();
        BufferedInputStream bis = new BufferedInputStream(new FileInputStream(
                "cpp.wmv"));
        BufferedOutputStream bos = new BufferedOutputStream(
                new FileOutputStream("cpp_copy4.wmv"));

        byte[] buff = new byte[1024];
        int len = 1;
        while ((len = bis.read(buff)) != -1) {
            bos.write(buff, 0, len);
        }

        bos.close();
        bis.close();
        System.out.println(System.currentTimeMillis() - start + "毫秒");
    }

    // BufferedInputStream ③read() 295毫秒
    private static void test3() throws IOException {
        long start = System.currentTimeMillis();
        BufferedInputStream bis = new BufferedInputStream(new FileInputStream(
                "cpp.wmv"));
        BufferedOutputStream bos = new BufferedOutputStream(
                new FileOutputStream("cpp_copy3.wmv"));

        int b = 1;
        while ((b = bis.read()) != -1) {
            bos.write(b);
        }

        bos.close();
        bis.close();
        System.out.println(System.currentTimeMillis() - start + "毫秒");
    }

    // FileInputStream ②read(buff) 62毫秒
    private static void test2() throws IOException {
        long start = System.currentTimeMillis();
        FileInputStream fis = new FileInputStream("cpp.wmv");
        FileOutputStream fos = new FileOutputStream("cpp_copy2.wmv");
        int len;
        byte[] buff = new byte[1024];
        while ((len = fis.read(buff)) != -1) {
            fos.write(buff, 0, len);
        }

        fis.close();
        fos.close();
        System.out.println(System.currentTimeMillis() - start + "毫秒");
    }

    // FileInputStream ①read() 35950毫秒
    private static void test1() throws IOException {
        long start = System.currentTimeMillis();
        FileInputStream fis = new FileInputStream("cpp.wmv");
        FileOutputStream fos = new FileOutputStream("cpp_copy1.wmv");
        int b;
        while ((b = fis.read()) != -1) {
            fos.write(b);
        }

        fis.close();
        fos.close();
        System.out.println(System.currentTimeMillis() - start + "毫秒");
    }

}
```
#### **BufferedOutputStream**
为另一个输入流添加一些功能，即缓冲输入以及支持 mark 和 reset 方法的能力。在创建 BufferedInputStream 时，会创建一个内部缓冲区数组。缓冲区减少IO操作以提高性能。
在读取或跳过流中的字节时， 可根据需要从包含的输入流再次填充该内部缓冲区，一次填充多个字节。mark 操作记录输入流中的某个点，reset 操作使得在从包含的输入流中获取新字节之前，再次读取自最后一次 mark 操作后读取的所有字节。

构造方法摘要

- BufferedInputStream(InputStream in) 
         创建一个 BufferedInputStream 并保存其参数，即输入流 in，以便将来使用。 
- BufferedInputStream(InputStream in, int size) 
         创建具有指定缓冲区大小的 BufferedInputStream 并保存其参数，即输入流 in，以便将来使用。 
     示例：
```java
private static void test1() throws IOException {
        BufferedOutputStream bos=new BufferedOutputStream(new FileOutputStream("bos.txt"));
        // 等价于下面两句
        //FileOutputStream fos=new FileOutputStream(new File("bos.txt"));
        //BufferedOutputStream bos=new BufferedOutputStream(fos);

        bos.write(66); // B的ASCII为66
        bos.write(new byte[]{'h','e','l','l','0','~'});
        bos.close(); 
        // 写入文件内容
        // Bhell0~
    }
```
#### **PrintStream**
为其他输出流添加了功能，使它们能够方便地打印各种数据值表示形式。与其他输出流不同，PrintStream 永远不会抛出 IOException，而是异常情况可通过 checkError 方法测试的内部标志。
可以创建一个自动刷新PrintStream；这意味着可在写入 byte 数组之后自动调用 flush 方法，可调用其中一个 println 方法，或写入一个换行符或字节 (‘\n’)来完成。
PrintStream 打印的所有字符都使用平台的默认字符编码转换为字节。在需要写入字符而不是写入字节的情况下，应该使用 PrintWriter 类。

构造器摘要：
从构造方法可以看出，它既可以操作文件，也可以操作字节输出流

- PrintStream(File file) ：创建具有指定文件且不带自动行刷新的新打印流。 
- PrintStream(File file, String csn) ：创建具有指定文件名称和字符集且不带自动行刷新的新打印流。 
- PrintStream(OutputStream out) ： 创建新的打印流。 
- PrintStream(OutputStream out, boolean autoFlush) ：创建新的打印流。 
- PrintStream(OutputStream out, boolean autoFlush, String encoding) ： 创建新的打印流。 
- PrintStream(String fileName) ：创建具有指定文件名称且不带自动行刷新的新打印流。 
- PrintStream(String fileName, String csn) ： 创建具有指定文件名称和字符集且不带自动行刷新的新打印流。、

独有方法摘要：

-  void print(Xxx s) ：打印Xxx（Xxx可为Object、String、基本类型等） 。
-  void println() ：通过写入行分隔符字符串终止当前行。 
-  void println(Xxx x) ：打印Xxx（Xxx可为Object、String、基本类型等），然后插入换行符终止该行。  
-  protected  void setError() ：将该流的错误状态设置为 true。 
-  boolean checkError() ：刷新流并检查其错误状态。 
-  protected  void clearError() ： 清除此流的内部错误状态，在另一个写入操作失败并调用 setError() 之前，此方法将导致 checkError() 的后续调用返回 false。 
-  PrintStream format(Locale l, String format, Object... args) ：使用指定格式字符串和参数将格式化字符串写入此输出流中。 
-  PrintStream format(String format, Object... args) ：使用指定格式字符串和参数将格式化字符串写入此输出流中。 

-  PrintStream printf(Locale l, String format, Object... args) ：使用指定格式字符串和参数将格式化的字符串写入此输出流的便捷方法。 
-  PrintStream printf(String format, Object... args) ： 使用指定格式字符串和参数将格式化的字符串写入此输出流的便捷方法。 

### **字符流体系**
对于字符的操作，我们当然首选字符流。同时，转换流也为我们建立了字节流到字符流的桥梁，使我们对数据的处理更加灵活。但是也要注意一些细节，对于从转换流获得的字符流，它读取的字符必须在编码表中可以查找的到，否则会造成乱码。可以这样形象的理解字符流：字符流 = 字节流+编码表。

| 编码表       | 描述                                       |
| --------- | ---------------------------------------- |
| ASCII     | 美国标准信息交换码。 一种使用7个或8个二进制位进行编码的方案          |
| ISO8859-1 | 拉丁码表。欧洲码表 用一个字节的8位表示。                    |
| GB2312    | 中国的中文编码表。                                |
| GBK       | 中国的中文编码表升级，融合了更多的中文文字符号。                 |
| GB18030   | GBK的取代版本                                 |
| BIG-5码    | 通行于台湾、香港地区的一个繁体字编码方案，俗称“大五码”。            |
| Unicode   | 国际标准码，融合了多种文字。所有文字都用两个字节来表示,Java语言使用的就是unicode |
| UTF-8     | 最多用三个字节来表示一个字符。它定义了一种“区间规则”，这种规则可以和ASCII编码保持最大程度的兼容：<br>它将Unicode编码为00000000-0000007F的字符，用单个字节来表示<br>它将Unicode编码为00000080-000007FF的字符用两个字节表示<br>它将Unicode编码为00000800-0000FFFF的字符用3字节表示 |
#### **FileReader**
用来读取字符文件的便捷类。此类的构造方法假定默认字符编码和默认字节缓冲区大小都是适当的。要自己指定这些值，可以先在 FileInputStream 上构造一个 InputStreamReader。
FileReader 用于读取字符流。要读取原始字节流，请考虑使用 FileInputStream。

构造器摘要

- FileReader(File file) ：在给定从中读取数据的 File 的情况下创建一个新 FileReader。 
- FileReader(FileDescriptor fd) ：在给定从中读取数据的 FileDescriptor 的情况下创建一个新 FileReader。 
- FileReader(String fileName) ：在给定从中读取数据的文件名的情况下创建一个新 FileReader。 

示例
```java
public class FileReaderReview {
    public static void main(String[] args) {
        //ReadMethod1();
        ReadMethod2();
    }

    private static void ReadMethod2() {
        FileReader fr = null;
        try {
            fr= new FileReader("fw.txt");
            char[] buff = new char[1024];
            int len = -1;
            // 每次将读取的内容放入一个数组缓冲区，读到内容返回读取的字符长度，否则返回-1
            while((len=fr.read(buff)) != -1){  
                System.out.print(new String(buff, 0, len));
            }
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }finally{
            if(fr != null){
                try {
                    fr.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }

    }

    private static void ReadMethod1() {
        FileReader fr = null;
        try {
            fr = new FileReader("fw.txt");
            int ch;
            // 每次读取一个字符，读完数据返回-1
            while((ch = fr.read()) != -1){ 
                System.out.print((char)ch);
            }
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }finally{
            if(fr != null){
                try {
                    fr.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }
}
```
#### **FileWriter**
用来写入字符文件的便捷类。此类的构造方法假定默认字符编码和默认字节缓冲区大小都是可接受的。要自己指定这些值，可以先在 FileOutputStream 上构造一个 OutputStreamWriter。
文件是否可用或是否可以被创建取决于底层平台。特别是某些平台一次只允许一个 FileWriter（或其他文件写入对象）打开文件进行写入。在这种情况下，如果所涉及的文件已经打开，则此类中的构造方法将失败。
FileWriter 用于写入字符流。要写入原始字节流，请考虑使用 FileOutputStream。

构造器摘要

- FileWriter(File file) ：根据给定的 File 对象构造一个 FileWriter 对象。 
- FileWriter(File file, boolean append) ：根据给定的 File 对象构造一个 FileWriter 对象。 
- FileWriter(FileDescriptor fd) ： 构造与某个文件描述符相关联的 FileWriter 对象。 
- FileWriter(String fileName) ：根据给定的文件名构造一个 FileWriter 对象。 
- FileWriter(String fileName, boolean append) ： 根据给定的文件名以及指示是否附加写入数据的 boolean 值来构造 FileWriter 对象。 

此类方法与父类同，就不贴出了。
```java
public class FileWriterReview {
    public static final String LINE_SEPARATOR = System.getProperty("line.separator");
    public static void main(String[] args) {
        FileWriter fw = null;
        try {
             fw = new FileWriter("fw.txt",true); // 设置true表示附加内容
             char[] cbuf = new char[]{'h','e','l','l','o'};
            fw.write(cbuf);
            fw.write(LINE_SEPARATOR); // 添加换行
            fw.write("写入字符串");
            fw.append("附加内容");
            //Returns the name of the character encoding being used by this stream. 
            System.out.println(fw.getEncoding()); 
        } catch (IOException e) {
            e.printStackTrace();
        }finally{
            if (fw!=null) {
                try {
                    fw.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }
}
```
#### **InputStreamReader**
InputStreamReader 是字节流通向字符流的桥梁：它使用指定的 charset 读取字节并将其解码为字符。它使用的字符集可以由名称指定或显式给定，或者可以接受平台默认的字符集。
每次调用 InputStreamReader 中的一个 read() 方法都会导致从底层输入流读取一个或多个字节。要启用从字节到字符的有效转换，可以提前从底层流读取更多的字节，使其超过满足当前读取操作所需的字节。

为了达到最高效率，可要考虑在 BufferedReader 内包装 InputStreamReader。例如：
BufferedReader in= new BufferedReader(new InputStreamReader(System.in));

构造器摘要：
可以指定字符集来解码字节文件

- InputStreamReader(InputStream in) ：创建一个使用默认字符集的 InputStreamReader。 
- InputStreamReader(InputStream in, Charset cs) ：创建使用给定字符集的 InputStreamReader。 
- InputStreamReader(InputStream in, CharsetDecoder dec) ：创建使用给定字符集解码器的 InputStreamReader。 
- InputStreamReader(InputStream in, String charsetName) ：创建使用指定字符集的 InputStreamReader。 

特别指出一个特别的方法
String getEncoding() ：返回此流使用的字符编码的名称。 

示例
```java
public class InputStreamReaderReview {
    public static void main(String[] args) throws Exception {

        review3();
    }

    private static void review3() throws IOException, FileNotFoundException {
        // 指定按gbk将字节解码为字符读取到输入流中
        InputStreamReader isr=new InputStreamReader(new FileInputStream("osw.txt"), "gbk");
        char[] cbuf=new char[1024];
        int len=-1;
        while ((len=isr.read(cbuf))!=-1) {
            System.out.println(new String(cbuf, 0, len));
        }
        isr.close();
    }

    private static void review1() throws IOException {
        // 使用BufferedReader提高效率
        BufferedReader br=new BufferedReader(new InputStreamReader(System.in));
        String s=null;
        while(!(s=br.readLine()).equals("over"))
        {
            System.out.println(s.toUpperCase());
        }
        br.close();
    }

    private static void review2() throws Exception {
        FileOutputStream fos=new FileOutputStream(new File("D：\\changeio.txt"));
        // 指定以gbk将字符编码成字节写入流中
        OutputStreamWriter osw=new OutputStreamWriter(fos,"GBK"); 
        osw.write("设为GBK写入");
        osw.close();

        FileInputStream fis = new FileInputStream(new File("D：\\changeio.txt"));
        // 指定按gbk将字节解码为字符读取到输入流中
        InputStreamReader isr = new InputStreamReader(fis,"GBK"); 
        char[] cbuf = new char[1024];
        int len=0;
        while ((len=isr.read(cbuf))!=-1) {
            System.out.println(new String(cbuf,0,len));
        }
        isr.close();
    }
}
```
#### **OutputStreamWriter**
OutputStreamWriter 是字符流通向字节流的桥梁：可使用指定的 charset(字符集) 将要写入流中的字符编码成字节。它使用的字符集可以由名称指定或显式给定，否则将接受平台默认的字符集。
每次调用 write() 方法都会导致在给定字符（或字符集）上调用编码转换器。在写入底层输出流之前，得到的这些字节将在缓冲区中累积。可以指定此缓冲区的大小，不过，默认的缓冲区对多数用途来说已足够大。注意，传递给 write() 方法的字符没有缓冲。

为了获得最高效率，可考虑将 OutputStreamWriter 包装进 BufferedWriter 中，以避免频繁调用转换器。例如：
Writer out = new BufferedWriter(new OutputStreamWriter(System.out));

构造器摘要：
- OutputStreamWriter(OutputStream out) ：创建使用默认字符编码的 OutputStreamWriter。 
- OutputStreamWriter(OutputStream out, Charset cs) ： 创建使用给定字符集的 OutputStreamWriter。 
- OutputStreamWriter(OutputStream out, CharsetEncoder enc) ：创建使用给定字符集编码器的 OutputStreamWriter。 
- OutputStreamWriter(OutputStream out, String charsetName) ：创建使用指定字符集的 OutputStreamWriter。 

示例：
```java
public class OutputStreamWriterReview {
    public static void main(String[] args) throws IOException {
		//test1();
        test2();
    }

    private static void test2() throws IOException {
       // 通过转换流，将字符以gbk编码成字节并写入本地文件，并指定字符集
        OutputStreamWriter osw=new OutputStreamWriter(new FileOutputStream("osw.txt"), "gbk"); 
        osw.write('a');
        osw.write("编码为");
        osw.write("gbk");
        osw.write("你解码吧");
        osw.write("告诉你一个秘密", 0, 5); // 写入字符串的一部分
        osw.flush();
        osw.close();
    }

    private static void test1() throws IOException {
        // 往控制台输出
        OutputStreamWriter osw=new OutputStreamWriter(System.out,"utf-8");
        // 写入缓冲区
        osw.write("你好"); 
        osw.flush();    
        osw.close();    
    }
}
```
#### **BufferedReader**
从字符输入流中读取文本，缓冲各个字符，从而实现字符、数组和行的高效读取。
可以指定缓冲区的大小，或者可使用默认的大小。大多数情况下，默认值就足够大了。

通常，Reader 所作的每个读取请求都会导致对底层字符或字节流进行相应的读取请求。因此，建议用 BufferedReader 包装所有其 read() 操作可能开销很高的 Reader（如 FileReader 和 InputStreamReader）。例如：
 BufferedReader in= new BufferedReader(new FileReader("foo.in"));

构造器摘要：

- BufferedReader(Reader in) ：创建一个使用默认大小输入缓冲区的缓冲字符输入流。 
- BufferedReader(Reader in, int sz) ： 创建一个使用指定大小输入缓冲区的缓冲字符输入流。 

特殊方法：
String readLine()  读取一个文本行。 

示例：
```java
public class BufferedReaderReview {
    public static void main(String[] args) {
        readFile();
    }

    private static void readFile() {
        FileReader fr=null;
        CustomBufferedReader br=null;
        try {
            fr=new FileReader("jar.txt");
            br = new CustomBufferedReader(fr);
            String line=null;
            while((line=br.readLine())!=null){//不包含 line-termination characters
                System.out.println(br.getLineNumber()+"："+line);
            }
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }finally{
            if(br!=null){
                try {
                    br.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }
}
```
#### **BufferedWriter**
提供缓冲的字符输出流，将文本写入字符输出流，缓冲各个字符，从而提供单个字符、数组和字符串的高效写入。
可以指定缓冲区的大小，或者接受默认的大小。在大多数情况下，默认值就足够大了。

该类提供了 newLine() 方法，它使用平台自己的行分隔符概念，此概念由系统属性 line.separator 定义(通过System.getProperty(“line.separator”)来获取)。并非所有平台都使用新行符 (‘\n’) 来终止各行。

通常 Writer 将其输出立即发送到底层字符或字节流，开销很高。所以可以用BufferedWriter 包装这些Writer（如 FileWriters 和 OutputStreamWriters），来提高效率。例如：
PrintWriter out = new PrintWriter(new BufferedWriter(new FileWriter("foo.out")));

构造器摘要：

- BufferedWriter(Writer out) ：创建一个使用默认大小输出缓冲区的缓冲字符输出流。 
- BufferedWriter(Writer out, int sz) ：创建一个使用给定大小输出缓冲区的新缓冲字符输出流。 

方法摘要：
仅列举了它的特有方法
void newLine()  写入一个行分隔符。 

示例：
```java
public class BufferedWriterReview {
    public static void main(String[] args) {
        //writeFile1();
        writeFile2();

    }

    /**
     * readLine读取一行
     * @throws IOException 
     */
    private static void writeFile() throws IOException {
        BufferedWriter bw=new BufferedWriter(new FileWriter("bw2.txt"));
        BufferedReader br=new BufferedReader(new FileReader("fw.txt"));

        String buff=null;
        //BufferedReader的readLine方法返回的字符串不包含换行符。
        while((buff=br.readLine())!=null){  //读取行，不包含换行符
            //将读取的行内容写入文件，偏移量为0，写入长度为buff的长度
            bw.write(buff, 0,buff.length());
            bw.newLine(); // 添加换行
        }

        br.close();
        bw.close();
    }
    
    /**
     * read方法
     */
    private static void writeFile0() throws IOException {
        BufferedWriter bw=new BufferedWriter(new FileWriter("bw.txt"));
        BufferedReader br=new BufferedReader(new FileReader("fw.txt"));
        char buff[] = new char[1024];
        int len;
        while((len=br.read(buff))!=-1){
            bw.write(buff, 0, len);
        }

        br.close();
        bw.close();
    }
}
```

#### **PrintWriter**
提供打印功能的字符输出流：向文本输出流打印对象的格式化表示形式。此类实现在 PrintStream 中的所有 print 方法。它不包含用于写入原始字节的方法，对于这些字节，程序应该使用未编码的字节流进行写入。
与 PrintStream 类不同，如果启用了自动刷新，则只有在调用 println、printf 或 format 的其中一个方法时才可能完成此操作，而不是每当正好输出换行符时才完成。这些方法使用平台自有的行分隔符概念，而不是换行符。

此类中的方法不会抛出 I/O 异常，尽管其某些构造方法可能抛出异常。客户端可能会查询调用 checkError() 是否出现错误。

构造器摘要：
通过构造方法可知，它即可操作文件，也可以操作字节输出流与字符输出流

- PrintWriter(File file) ：使用指定文件创建不具有自动行刷新的新 PrintWriter。 
- PrintWriter(File file, String csn) ：创建具有指定文件和字符集且不带自动刷行新的新 PrintWriter。 
- PrintWriter(OutputStream out) ：根据现有的 OutputStream 创建不带自动行刷新的新 PrintWriter。 
- PrintWriter(OutputStream out, boolean autoFlush) ：通过现有的 OutputStream 创建新的 PrintWriter。 
- PrintWriter(String fileName) ：创建具有指定文件名称且不带自动行刷新的新 PrintWriter。 
- PrintWriter(String fileName, String csn) ：创建具有指定文件名称和字符集且不带自动行刷新的新 PrintWriter。 
- PrintWriter(Writer out) ：创建不带自动行刷新的新 PrintWriter。 
- PrintWriter(Writer out, boolean autoFlush) ：创建新 PrintWriter。 

示例：
启动自动刷新

    1. PrintWriter pw = new PrintWriter(new FileWriter("pw2.txt"), true);
    2. 还是应该调用println()（printf 或 format）的方法才可以，不仅仅自动刷新了，还实现了数据的换行。

println() 与下面三行等价：
```java
bw.write();
bw.newLine();       
bw.flush();
```
```java
public class PrintWriterDemo {
    public static void main(String[] args) throws IOException {
        // 创建打印流对象
        // PrintWriter pw = new PrintWriter("pw2.txt");
        PrintWriter pw = new PrintWriter(new FileWriter("pw2.txt"), true); // 设置自动刷新

		// pw.print(666);
		//pw.print("hello"); // 不会自动刷新
	
        pw.println(666);
        pw.println("hello"); // println()（printf 或 format）致使自动刷新
        
        pw.close();
    }
}   
```
#### **推回输入流**
##### **PushbackInputStream**
PushbackInputStream 为另一个输入流添加性能，即“推回 (push back)”或“取消读取 (unread)”一个字节的能力。在代码片段可以很方便地读取由特定字节值分隔的不定数量的数据字节时，这很有用；在读取终止字节后，代码片段可以“取消读取”该字节，这样，输入流上的下一个读取操作将会重新读取被推回的字节。

构造器摘要：

- PushbackInputStream(InputStream in) ：创建 PushbackInputStream 并保存其参数（即输入流 in），以供将来使用。 
- PushbackInputStream(InputStream in, int size) ：使用指定 size 的推回缓冲区创建 PushbackInputStream，并保存其参数（即输入流 in），以供将来使用。 

##### **PushbackReader**
类似于PushbackInputStream，允许将字符推回到流的字符流 reader。

构造器摘要：
- PushbackReader(Reader in) ：创建具有单字符推回缓冲区的新推回 reader。 
- PushbackReader(Reader in, int size) ：创建具有给定大小推回缓冲区的新推回 reader。 

这两个推回输入流都是处理流，分别额外提供了三个重载的unread方法来将指定内容推回缓冲区，从而允许重新读取刚刚读取的内容（read方法先将推回缓冲区内容读完后如果还没有装满read方法的数组，再从原输入流读取）：

- void unread(byte[]/char[] buf) ：推回一个字符数组，方法是将其复制到推回缓冲区前面。 
- void unread(byte[]/char[] buf, int off, int len) ：推回字符数组的某一部分，方法是将其复制到推回缓冲区的前面。 
- void unread(int c) ：推回单个字符：将其复制到推回缓冲区的前面。 

示例：
```java
public class PushbackTest{
	public static void main(String[] args){
		try(
			// 创建一个PushbackReader对象，指定推回缓冲区的长度为64
			PushbackReader pr = new PushbackReader(new FileReader(
				"PushbackTest.java") , 64)) {
			char[] buf = new char[32];
			// 用以保存上次读取的字符串内容
			String lastContent = "";
			int hasRead = 0;
			// 循环读取文件内容
			while ((hasRead = pr.read(buf)) > 0) {
				// 将读取的内容转换成字符串
				String content = new String(buf , 0 , hasRead);
				int targetIndex = 0;
				// 将上次读取的字符串和本次读取的字符串拼起来，
				// 查看是否包含目标字符串, 如果包含目标字符串
				if ((targetIndex = (lastContent + content)
					.indexOf("new PushbackReader")) > 0) {
					// 将本次内容和上次内容一起推回缓冲区
					pr.unread((lastContent + content).toCharArray());
					// 重新定义一个长度为targetIndex的char数组
					if(targetIndex > 32) {
						buf = new char[targetIndex];
					}
					// 再次读取指定长度的内容（就是目标字符串之前的内容）
					pr.read(buf , 0 , targetIndex);
					// 打印读取的内容
					System.out.print(new String(buf , 0 ,targetIndex));
					System.exit(0);
				}
				else {
					// 打印上次读取的内容
					System.out.print(lastContent);
					// 将本次内容设为上次读取的内容
					lastContent = content;
				}
			}
		}
		catch (IOException ioe) {
			ioe.printStackTrace();
		}
	}
}
```
## **重定向标准输入/输出**
在System类里有以下三个重定向标准输入/输出的方法：

- static void setIn(InputStream in)：重定向标准输入流。
- static void setOut(PrintStream out)：重定向标准输出流。
- static void setError(PrintStream err)：重定向标准错误流。

示例：
```java
public class RedirectIn {
	public static void main(String[] args) {
		try(
			FileInputStream fis = new FileInputStream("RedirectIn.java")) {
			// 将标准输入重定向到fis输入流
			System.setIn(fis);
			// 使用System.in创建Scanner对象，用于获取标准输入
			Scanner sc = new Scanner(System.in);
			// 增加下面一行将只把回车作为分隔符
			sc.useDelimiter("\n");
			// 判断是否还有下一个输入项
			while(sc.hasNext()) {
				// 输出输入项
				System.out.println("键盘输入的内容是：" + sc.next());
			}
		}
		catch (IOException ex) {
			ex.printStackTrace();
		}
	}
}
```
```java
public class RedirectOut {
	public static void main(String[] args) {
		try(
			// 一次性创建PrintStream输出流
			PrintStream ps = new PrintStream(new FileOutputStream("out.txt"))) {
			// 将标准输出重定向到ps输出流
			System.setOut(ps);
			// 向标准输出输出一个字符串
			System.out.println("普通字符串");
			// 向标准输出输出一个对象
			System.out.println(new RedirectOut());
		}
		catch (IOException ex) {
			ex.printStackTrace();
		}
	}
}
```
## **Java虚拟机读写其他进程的数据**
 Runtime的exec()方法返回一个Processor对象，Processor对象代表由该Java对象启动的子进程。Process类有以下三个方法与其他进程通信：

- InputStream getInputStream()：获取子进程的输入流。
- InputStream  getErrorStream()：获取子进程的错误流。
- OutputStream getOutputStream()： 获取子进程的输出流。

```java
public class ReadFromProcess {
	public static void main(String[] args)
		throws IOException {
		// 运行javac命令，返回运行该命令的子进程
		Process p = Runtime.getRuntime().exec("javac");
		try(
			// 以p进程的错误流创建BufferedReader对象
			// 这个错误流对本程序是输入流，对p进程则是输出流
			BufferedReader br = new BufferedReader(new
				InputStreamReader(p.getErrorStream()))) {
			String buff = null;
			// 采取循环方式来读取p进程的错误输出
			while((buff = br.readLine()) != null) {
				System.out.println(buff);
			}
		}
	}
}
```
```java
public class WriteToProcess {
	public static void main(String[] args)
		throws IOException {
		// 运行java ReadStandard命令，返回运行该命令的子进程
		Process p = Runtime.getRuntime().exec("java ReadStandard");
		try(
			// 以p进程的输出流创建PrintStream对象
			// 这个输出流对本程序是输出流，对p进程则是输入流
			PrintStream ps = new PrintStream(p.getOutputStream())) {
			// 向ReadStandard程序写入内容，这些内容将被ReadStandard读取
			ps.println("普通字符串");
			ps.println(new WriteToProcess());
		}
	}
}
// 定义一个ReadStandard类，该类可以接受标准输入，
// 并将标准输入写入out.txt文件。
class ReadStandard {
	public static void main(String[] args) {
		try(
			// 使用System.in创建Scanner对象，用于获取标准输入
			Scanner sc = new Scanner(System.in);
			PrintStream ps = new PrintStream(
			new FileOutputStream("out.txt"))) {
			// 增加下面一行将只把回车作为分隔符
			sc.useDelimiter("\n");
			// 判断是否还有下一个输入项
			while(sc.hasNext()) {
				// 输出输入项
				ps.println("键盘输入的内容是：" + sc.next());
			}
		}
		catch(IOException ioe) {
			ioe.printStackTrace();
		}
	}
}
```
## **RandomAccessFile类**
RandomAccessFile类(继承自Object，是独立的)可以通过操作文件记录指针来访问文件的任意位置，方便地实现流的插入、追加等操作。但是只能读写文件，不能访问IO节点。(RandomAccessFile的绝大多数功能，但不是全部，已经被JDK 1.4的nio的"内存映射文件(memory-mapped files)"给取代了,可以考虑使用内存映射代替RandomAccessFile)

构造器摘要：

- RandomAccessFile(File file, String mode) ：创建从中读取和向其中写入（可选）的随机访问文件流，该文件由 File 参数指定。 
- RandomAccessFile(String name, String mode) ：创建从中读取和向其中写入（可选）的随机访问文件流，该文件具有指定名称。 

其中，mode 参数指定用以打开文件的访问模式。允许的值及其含意为： 

| 值     | 含意                                       |
| ----- | ---------------------------------------- |
| "r"   | 以只读方式打开。调用结果对象的任何 write 方法都将导致抛出 IOException。 |
| "rw"  | 打开以便读取和写入。如果该文件尚不存在，则尝试创建该文件。            |
| "rws" | 打开以便读取和写入，对于 "rw"，还要求对文件的内容或元数据的每个更新都同步写入到底层存储设备。<br>使用 "rws" 要求更新要写入的文件内容及其元数据，这通常要求至少一个以上的低级别 I/O 操作。 |
| "rwd" | 打开以便读取和写入，对于 "rw"，还要求对文件内容的每个更新都同步写入到底层存储设备。<br>"rwd" 模式可用于减少执行的 I/O 操作数量，因为使用 "rwd" 仅要求更新要写入存储的文件的内容。 |

主要方法摘要：

- void seek(long pos) ：设定位文件记录指针到pos处。 
- long getFilePointer() ： 返回此时的文件记录指针位置。 
- void setLength(long newLength) ：设置此文件的长度。 
- int skipBytes(int n) ：尝试跳过输入的 n 个字节以丢弃跳过的字节。 
- long length() ：返回此文件的长度。 
- FileChannel getChannel() ：返回与此文件关联的唯一 FileChannel 对象。 
- FileDescriptor getFD() ：返回与此流关联的不透明文件描述符对象。 
- 该类还有功能类似与InputStream和OutStream的三个read方法和三个write方法，此外，还有许多readXxx()和writeXxx()方法来读写。

示例1：
简单测试
```java
public class RandomAccessFileTest {
	public static void main(String[] args) {
		try(
			RandomAccessFile raf =  new RandomAccessFile(
				"RandomAccessFileTest.java" , "r")) {
			// 获取RandomAccessFile对象文件指针的位置，初始位置是0
			System.out.println("RandomAccessFile的文件指针的初始位置："
				+ raf.getFilePointer());
			// 移动raf的文件记录指针的位置
			raf.seek(300);
			byte[] bbuf = new byte[1024];
			// 用于保存实际读取的字节数
			int hasRead = 0;
			// 使用循环来重复“取水”过程
			while ((hasRead = raf.read(bbuf)) > 0 ) {
				// 取出“竹筒”中水滴（字节），将字节数组转换成字符串输入！
				System.out.print(new String(bbuf , 0 , hasRead ));
			}
		}
		catch (IOException ex) {
			ex.printStackTrace();
		}
	}
}
```
 示例2：
 追加内容 
```java
public class AppendContent {
	public static void main(String[] args) {
		try(
			//以读、写方式打开一个RandomAccessFile对象
			RandomAccessFile raf = new RandomAccessFile("out.txt" , "rw")) {
			//将记录指针移动到out.txt文件的最后
			raf.seek(raf.length());
			raf.write("追加的内容！\r\n".getBytes());
		}
		catch (IOException ex) {
			ex.printStackTrace();
		}
	}
}
```
示例3：
插入内容 
```java
public class InsertContent {
	public static void insert(String fileName , long pos
		, String insertContent) throws IOException {
		File tmp = File.createTempFile("tmp" , null);
		tmp.deleteOnExit();
		try(
			RandomAccessFile raf = new RandomAccessFile(fileName , "rw");
			// 使用临时文件来保存插入点后的数据
			FileOutputStream tmpOut = new FileOutputStream(tmp);
			FileInputStream tmpIn = new FileInputStream(tmp)) {
			raf.seek(pos);
			// ------下面代码将插入点后的内容读入临时文件中保存------
			byte[] bbuf = new byte[64];
			// 用于保存实际读取的字节数
			int hasRead = 0;
			// 使用循环方式读取插入点后的数据
			while ((hasRead = raf.read(bbuf)) > 0 ) {
				// 将读取的数据写入临时文件
				tmpOut.write(bbuf , 0 , hasRead);
			}
			// ----------下面代码插入内容----------
			// 把文件记录指针重新定位到pos位置
			raf.seek(pos);
			// 追加需要插入的内容
			raf.write(insertContent.getBytes());
			// 追加临时文件中的内容
			while ((hasRead = tmpIn.read(bbuf)) > 0 ) {
				raf.write(bbuf , 0 , hasRead);
			}
		}
	}
	public static void main(String[] args)
		throws IOException {
		insert("InsertContent.java" , 45 , "插入的内容\r\n");
	}
}
```

