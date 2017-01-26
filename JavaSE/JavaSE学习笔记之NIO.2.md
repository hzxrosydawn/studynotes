###**NIO.2概述**
Java 7对原有的NIO进行了改进，提供了全面的文件IO和文件系统支持（新增了java.io.file包及其子包），增加了基于异步Channel的IO（在java.nio.channels包下增加了许多以Asynchronous开头的Channel接口和类）。Java 7的这种改进称为NIO.2。
####**Path接口**
BIO提供的File类有许多不足：不能利用特定文件系统的特性，性能不高，出错时仅返回失败而不会提供异常信息。NIO.2提供的Path接口代表一个平台无关的文件路径。
主要方法摘要：

- Path getFileName()：以Path对象形式返回该文件路径表示的文件或目录的名称（如果该对象表示文件，则仅返回文件名，如果该对象为路径，则返回最远的子路径名）；
- FileSystem getFileSystem()：返回该创建了该对象的文件系统对象；
- Path getName(int index)：返回指定索引的名称元素（Path对象的名称元素以路径分隔符分开，最接近根路径的索引为0）；
- int getNameCount()：返回该Path对象中所有名称元素的数量；
- Path getParent()：返回表示该Path对象的父路径的Path对象，没有父路径则返回null；
- Path getRoot()：返回表示该Path对象的根路径的Path对象，没有根路径则返回null；
- boolean endsWith(Path other)：检测该Path对象是否以指定路径结尾；
- boolean endsWith(String other)：同上，只是路径参数形式不同；
- boolean startsWith(Path other)：检测该Path对象是否以指定的Path对象开头；
- boolean startsWith(String other)：同上，只是路径参数形式不同；-
- Path relativize(Path other)：将当前Path对象和指定的Path对象构造成一个新的Path对象；
- Path resolve(Path other)：如果other对象是一个绝对路径，则返回other对象。如果other对象是一个空路径，则返回当前Path对象。否则将other表示路径追加到当前Path对象表示的路径后，返回组合后的Path对象；
- Path resolve(String other)：同上，只是参数的形式不同而已；
- Path resolveSibling(Path other)：如果other对象是一个绝对路径或当前Path没有父路径，则返回other对象。如果other对象是一个空路径，则返回当前Path对象。否则将other表示路径追加到当前Path对象表示的父路径后（即和当前路径同级），返回组合后的Path对象；
- Path resolveSibling(String other)：同上，只是参数类型不同；
- Path subpath(int beginIndex, int endIndex)：返回一个指定范围的子Path对象；
- Path toAbsolutePath()：返回表示该Path对象的绝对路径的Path对象；
- File toFile()：将该Path对象转换为File对象；
- Path toRealPath(LinkOption... options)：返回表示一个链接对象的真实路径的Path对象；
- String toString()：将该Path对象转换为字符串；
- URI toUri()：将该Path对象转换为URI对象；

示例：
```java
public class PathTest
{
	public static void main(String[] args)
		throws Exception
	{
		// 以当前路径来创建Path对象
		Path path = Paths.get(".");
		System.out.println("path里包含的路径数量："
			+ path.getNameCount());
		System.out.println("path的根路径：" + path.getRoot());
		// 获取path对应的绝对路径。
		Path absolutePath = path.toAbsolutePath();
		System.out.println(absolutePath);
		// 获取绝对路径的根路径
		System.out.println("absolutePath的根路径："
			+ absolutePath.getRoot());
		// 获取绝对路径所包含的路径数量
		System.out.println("absolutePath里包含的路径数量："
			+ absolutePath.getNameCount());
		System.out.println(absolutePath.getName(3));
		// 以多个String来构建Path对象
		Path path2 = Paths.get("g:" , "publish" , "codes");
		System.out.println(path2);
	}
}
```
#####**使用Path监控文件系统的变化** 
Path提供了下面方法来实现文件系统变化的监控：

- WatchKey register(WatchService watcher, WatchEvent.Kind&lt;?>[] events, WatchEvent.Modifier... modifiers)：用watcher监听该Path目录下文件的变化，events代表监听的事件类型：

 - ENTRY_CREATE：创建或者移动到该目录的条目；
 - ENTRY_DELETE ：被删除或者移出该目录的条目；
 - ENTRY_MODIFY：该目录中被修改的条目。
 
 而modifiers用于指定限制目录被如何注册的修改器；
- WatchKey register(WatchService watcher, WatchEvent.Kind&lt;?>... events)：同上；

一旦完成注册，就可以调用WatchService如下三个方法来获取被监听目录的文件变化：

 - WatchKey poll()：获取下一个WatchKey，如果没有WatchKey发生就立即返回null；
 - WatchKey poll(long timeout, TimeUnit unti)：尝试等待timeout时间来获取一个WatchKey。poll方法用于指定监控时间；
 - WatchKey take()：获取下一个WatchKey，如果没有WatchKey发生则一直等待。用于一直监控。
 
示例：
```java
public class WatchServiceTest
{
	public static void main(String[] args)
		throws Exception
	{
		// 获取文件系统的WatchService对象
		WatchService watchService = FileSystems.getDefault()
			.newWatchService();
		// 为C:盘根路径注册监听
		Paths.get("C:/").register(watchService
			, StandardWatchEventKinds.ENTRY_CREATE
			, StandardWatchEventKinds.ENTRY_MODIFY
			, StandardWatchEventKinds.ENTRY_DELETE);
		while(true)
		{
			// 获取下一个文件改动事件
			WatchKey key = watchService.take();    //①
			for (WatchEvent<?> event : key.pollEvents())
			{
				System.out.println(event.context() +" 文件发生了 "
					+ event.kind()+ "事件！");
			}
			// 重设WatchKey
			boolean valid = key.reset();
			// 如果重设失败，退出监听
			if (!valid)
			{
				break;
			}
		}
	}
}
```
 

####**Paths工具类**
 
Paths工具类提供了两个用来获取Path对象的静态方法： 
####**Files工具类** 
Files是操作文件的工具类，提供了大量操作文件的简便方法：

- static long copy(InputStream in, Path target, CopyOption... options) ：将输入流对象的所有字节序列复制到目标Path对象中，返回读写的字节数。该输入流在返回时处于流的末尾。默认情况下，如果target已经存在或者target是一个符号链接会复制失败。如果在调用该方法时指定了CopyOption为REPLACE\_EXISTING（该参数目前只能指定为REPLACE_EXISTING），则可以覆盖已存在的表示文件的target，如果target为符号链接则覆盖该符号链接而不是链接所指的文件。如果读写时出现IO异常，则会在已经创建target对象和已经读写一些字节之后抛出IO异常，所以，这种情况下调用该方法后输入流可能不会停留在流的末尾，故强烈建议在出现IO异常时立即关闭此输入流。调用该方法在读写时可能会无限期阻塞，是异步关闭输入流还是在复制时终止当前线程，取决于输入流和文件系统的特性。
- static long	copy(Path source, OutputStream out)：将文件从source复制到out中，但不能覆盖复制。如果读写时出现IO异常，则会在已经创建target对象和已经读写一些字节之后抛出IO异常，所以，这种情况下调用该方法后输入流可能不会停留在流的末尾，故强烈建议在出现IO异常时立即关闭此输入流。调用该方法在读写时可能会无限期阻塞，是异步关闭输入流还是在复制时终止当前线程，取决于输入流和文件系统的特性。注意如果输出流out是Flushable的，那么可能需要在调用该方法之后调用flush方法从缓冲区输出数据；
- static Path	copy(Path source, Path target, CopyOption... options)：将文件从source按options参数指定的规则复制到target中，返回复制后target对象。默认情况下，如果target已经存在或者target是一个符号链接会复制失败。如果source和target表示相同文件则不会复制。文件的属性不需要复制。如果支持符号链接，那么符号链接表示的最终文件会被复制。如果文件是一个路径，怎会在目标位置创建一个空路径（路径内的文件没有复制）。该方法可以和 walkFileTree方法一起使用来复制一个路径及其该路径内部的所有文件或文件树。该方法options参数可以为：
 - REPLACE_EXISTING：可以覆盖已存在的表示文件的target，如果target为符号链接则覆盖该符号链接而不是链接所指的文件；
 - COPY\_ATTRIBUTES：在复制文件时尝试同时复制文件的属性，而属性是平台和文件系统相关的所以未指定复制的属性，但最少复制文件的时间戳（ last-modified-time）；
 - NOFOLLOW\_LINKS：如果文件是符号链接，那么不复制链接所指的文件，而是复制链接本身。如果符号链接的文件属性可以复制，那么这种复制为该参数值所具有的特性，也就是说COPY_ATTRIBUTES属性可能被忽略掉；

   文件的复制可能是不完整的。如果抛出IO异常，那么target可能是不完整的或者文件属性没有被复制。根据其他文件系统特性，覆盖操作时文件存在的检测和新文件的创建也可能是不完整的
 
- static Path	createDirectory(Path dir, FileAttribute&lt;?>... attrs)：如果目标路径不存在，则创建该路径。文件存在的检测和新文件的创建在所有操作系统中是完整的。attrs参数是可选的，指定在创建路径时自动设置的文件属性序列。如果方法失败，则会在创建部分而不是全部的父路径后执行以上操作；
- static Path	createDirectories(Path dir, FileAttribute&lt;?>... attrs)：在创建目标路径时同时创建所有不存在的目标路径的父路径，返回创建的目标路径。该方法不会像createDirectory方法在创建已存在路径时抛出IO异常。attrs参数特性同createDirectory方法；
- static Path	createFile(Path path, FileAttribute&lt;?>... attrs)：创建一个新的空文件，如果文件已存在则创建失败。文件存在的检测和新文件的创建时一次性的完全操作。attrs参数的使用同上；
- static Path	createLink(Path link, Path existing)：为已存在文件创建链接（该文件的路径入口）；
- static Path	createSymbolicLink(Path link, Path target, FileAttribute&lt;?>... attrs)：为目标文件创建一个符号链接。target可能是绝对路径或相对路径，也可能不存在。如果target是相对路径，那么创建的也是相对于link的相对链接；
- static Path	createTempDirectory(Path dir, String prefix, FileAttribute&lt;?>... attrs)：使用给定的名称前缀在一个指定的路径中创建一个新的路径；
- static Path	createTempDirectory(String prefix, FileAttribute&lt;?>... attrs)：使用给定的名称前缀在默认的临时路径中创建一个新的路径；
- static Path	createTempFile(Path dir, String prefix, String suffix, FileAttribute&lt;?>... attrs)：使用给定的前缀和后缀，在指定的路径中创建一个新的空文件；
- static Path	createTempFile(String prefix, String suffix, FileAttribute&lt;?>... attrs)：使用给定的前缀和后缀，在默认的路径中创建一个新的空文件；
- static void	delete(Path path)：删除一个Path对象。如果该Path对象时路径，则它必须为空。如果删除的是符号链接，那么删除的是该符号链接而不是其所指的文件。在一些文件系统中，如果文件已经被占用则无法删除。该方法可以和 walkFileTree方法一起使用来删除一个路径及其该路径内部的所有文件或文件树；
- static boolean deleteIfExists(Path path)：如果该Path对象已存在则删除该Path对象；
- static boolean exists(Path path, LinkOption... options)：检测该Path对象是否已存在；
- static Object	getAttribute(Path path, String attribute, LinkOption... options)：读取该Path的指定属性的属性值；
- static &lt;V extends FileAttributeView> V	getFileAttributeView(Path path, Class&lt;V> type, LinkOption... options)：返回给定名称属性的视图；
- static FileTime getLastModifiedTime(Path path, LinkOption... options)：返回最后修改时间；
- static FileStore	getFileStore(Path path)：返回FileStore对象来表示该文件所在存储空间对象。FileStore有许多方法返回存储空间的信息；
- static UserPrincipal	getOwner(Path path, LinkOption... options)：返回文件所有者；
- static Set&lt;PosixFilePermission>	getPosixFilePermissions(Path path, LinkOption... options)：返回文件移植权限；
- static boolean isDirectory(Path path, LinkOption... options)：是否为路径；
- static boolean isExecutable(Path path)：是否可执行；
- static boolean isHidden(Path path)：是否是隐藏的；
- static boolean isReadable(Path path)：是否可读；
- static boolean	isRegularFile(Path path, LinkOption... options)
Tests whether a file is a regular file with opaque content.
- static boolean isSameFile(Path path, Path path2)：是否代表同一个文件；
- static boolean isSymbolicLink(Path path)：是否为符号链接；
- static boolean isWritable(Path path)：是否可写；
- static Path	move(Path source, Path target, CopyOption... options)：移动或者重命名文件；
- static BufferedReader newBufferedReader(Path path, Charset cs)：读取成BufferedReader；
- static BufferedWriter newBufferedWriter(Path path, Charset cs, OpenOption... options)：读取成BufferedWriter；
- static DirectoryStream&lt;Path>	newDirectoryStream(Path dir)：打开一个目录，返回一个DirectStream对象来遍历目录的所有条目；
- static DirectoryStream&lt;Path>	newDirectoryStream(Path dir, DirectoryStream.Filter&lt;? super Path> filter)：同上，只是返回的DirectStream对象是通过filter选择器（函数式接口）筛选过的；
- static DirectoryStream&lt;Path>	newDirectoryStream(Path dir, String glob)：同上，只是返回的DirectStream对象是通过glob正则表达式参数筛选过的；
Opens a directory, returning a DirectoryStream to iterate over the entries in the directory.
- static SeekableByteChannel	newByteChannel(Path path, Set&lt;? extends OpenOption> options, FileAttribute&lt;?>... attrs)：打开或者创建一个文件，返回连接到此文件的ByteChannel对象；
- static SeekableByteChannel	newByteChannel(Path path, OpenOption... options)：打开或者创建一个文件，返回连接到此文件的ByteChannel对象；
- static InputStream newInputStream(Path path, OpenOption... options)：读取成InputStream；
- static OutputStream	newOutputStream(Path path, OpenOption... options)：读取成OutputStream；
- static boolean notExists(Path path, LinkOption... options)：是否不存在；
- static String probeContentType(Path path)：探查内容类型；
- static byte[] readAllBytes(Path path)：读取该文件的所有字节；
- static List&lt;String>	readAllLines(Path path, Charset cs):读取文件的所有行；
- static &lt;A extends BasicFileAttributes> A readAttributes(Path path, Class&lt;A> type, LinkOption... options)：读取文件属性值的集合；
- static Map&lt;String,Object>	readAttributes(Path path, String attributes, LinkOption... options)：同上，只是返回值类型不同；
- static Path	readSymbolicLink(Path link)：读取符号链接所指向目标的Path对象；
- static Path	setAttribute(Path path, String attribute, Object value, LinkOption... options)：设置文件的指定属性值；
- static Path	setLastModifiedTime(Path path, FileTime time)：更新文件的最后修改时间；
- static Path	setOwner(Path path, UserPrincipal owner)：设置文件所有者；
- static Path	setPosixFilePermissions(Path path, Set&lt;PosixFilePermission> perms):a设置文件的可移植权限；
- static long	size(Path path)：返回文件的字节大小；
- static Path	write(Path path, byte[] bytes, OpenOption... options)：向文件中写入字节数组；
- static Path	write(Path path, Iterable&lt;? extends CharSequence> lines, Charset cs, OpenOption... options)：向文件中写入文本行；
- static Stream&lt;String> lines(Path path)：从一个文件中读取文件的所有行；
- static Stream&lt;String> lines(Path path, Charset cs)：同上，只是使用指定的字符集读取；
- static Stream&lt;Path> list(Path dir)：返回一个简单增加的Stream，其元素是dir目录的条目，并不递归增加；
- static Stream&lt;Path> find(Path start, int maxDepth, BiPredicate&lt;Path, BasicFileAttributes> matcher, FileVisitOption... options)：通过从指定的文件开始遍历一个文件树，来返回一个简单增加的Stream，其元素是dir目录的条目；
- static Stream&lt;Path>	walk(Path start, FileVisitOption... options)：同上；
- static Stream&lt;Path>	walk(Path start, int maxDepth, FileVisitOption... options)：同上；

示例：
```java
public class FilesTest
{
	public static void main(String[] args)
		throws Exception
	{
		// 复制文件
		Files.copy(Paths.get("FilesTest.java")
			, new FileOutputStream("a.txt"));
		// 判断FilesTest.java文件是否为隐藏文件
		System.out.println("FilesTest.java是否为隐藏文件："
			+ Files.isHidden(Paths.get("FilesTest.java")));
		// 一次性读取FilesTest.java文件的所有行
		List<String> lines = Files.readAllLines(Paths
			.get("FilesTest.java"), Charset.forName("gbk"));
		System.out.println(lines);
		// 判断指定文件的大小
		System.out.println("FilesTest.java的大小为："
			+ Files.size(Paths.get("FilesTest.java")));
		List<String> poem = new ArrayList<>();
		poem.add("水晶潭底银鱼跃");
		poem.add("清徐风中碧竿横");
		// 直接将多个字符串内容写入指定文件中
		Files.write(Paths.get("pome.txt") , poem
			, Charset.forName("gbk"));
		// 使用Java 8新增的Stream API列出当前目录下所有文件和子目录
		Files.list(Paths.get(".")).forEach(path -> System.out.println(path));
		// 使用Java 8新增的Stream API读取文件内容
		Files.lines(Paths.get("FilesTest.java") , Charset.forName("gbk"))
			.forEach(line -> System.out.println(line));
		FileStore cStore = Files.getFileStore(Paths.get("C:"));
		// 判断C盘的总空间，可用空间
		System.out.println("C:共有空间：" + cStore.getTotalSpace());
		System.out.println("C:可用空间：" + cStore.getUsableSpace());
	}
}
```
可见，Files工具类的工具方法大大简化了文件IO，因此应该掌握这些工具方法的使用。
#####**使用Files工具类遍历文件**
 
Files类提供了以下两个方法来遍历文件和子目录：
 
 - static Path	walkFileTree(Path start, FileVisitor&&lt;? super Path> visitor)：遍历start路径下的所有文件和子目录 ；
 - static Path	walkFileTree(Path start, Set&lt;FileVisitOption> options, int maxDepth, FileVisitor&lt;? super Path> visitor)：同上，只是最多遍历maxDepth深度，是否对符号链接有效（因为options参数只能为FOLLOW_LINKS枚举值）；
  
其中。FileVisitor接口代表一个文件访问器，遍历文件和子目录都会触发FilterVisitor里的相应方法，其中有四个方法：

- FileVisitResult	postVisitDirectory(T dir, IOException exc)：访问子目录后触发该方法；
- FileVisitResult	preVisitDirectory(T dir, BasicFileAttributes attrs)：在访问子目录之前触发该方法；
- FileVisitResult	visitFile(T file, BasicFileAttributes attrs)：访问文件时触发该方法；
- FileVisitResult	visitFileFailed(T file, IOException exc)：访问文件失败时触发该方法；
 
 没必要完全实现以上四个方法，可通过继承SimpleFileVisitor类（实现了FileVisitor接口）来实现自己的文件访问器，可以根据需要选择性的重写指定方法。 以上四个方法都返回一个FileVisitResult枚举类对象，该类定义了一下几种后续行为：
 
- CONTINUE：代表继续访问的后续行为；
- SKIP_SIBLINGS：代表继续访问的后续行为，只是不访问该文件或目录的同级文件或目录；
- SKIP_SUBTREE：代表继续访问的后续行为，只是不访问该文件或目录的子目录；
- TERMINATE：代表终止访问的子目录。
 
 示例：
 ```java
public class FileVisitorTest
{
	public static void main(String[] args)
		throws Exception
	{
		// 遍历g:\publish\codes\15目录下的所有文件和子目录
		Files.walkFileTree(Paths.get("g:", "publish" , "codes" , "15")
			, new SimpleFileVisitor<Path>()
		{
			// 访问文件时候触发该方法
			@Override
			public FileVisitResult visitFile(Path file
				, BasicFileAttributes attrs) throws IOException
			{
				System.out.println("正在访问" + file + "文件");
				// 找到了FileInputStreamTest.java文件
				if (file.endsWith("FileInputStreamTest.java"))
				{
					System.out.println("--已经找到目标文件--");
					return FileVisitResult.TERMINATE;
				}
				return FileVisitResult.CONTINUE;
			}
			// 开始访问目录时触发该方法
			@Override
			public FileVisitResult preVisitDirectory(Path dir
				, BasicFileAttributes attrs) throws IOException
			{
				System.out.println("正在访问：" + dir + " 路径");
				return FileVisitResult.CONTINUE;
			}
		});
	}
}
 ```
示例二：
复制一个目录树到另一个位置，应该对符号链接有效，同时在复制一个目录中条目的之前创建目标目录。
```java
final Path source = ...
final Path target = ...

Files.walkFileTree(source, EnumSet.of(FileVisitOption.FOLLOW_LINKS), Integer.MAX_VALUE,
	new SimpleFileVisitor<Path>() {
	@Override
	public FileVisitResult preVisitDirectory(Path dir, BasicFileAttributes attrs)
		throws IOException{
		Path targetdir = target.resolve(source.relativize(dir));
		try {
			Files.copy(dir, targetdir);
		} catch (FileAlreadyExistsException e) {
		if (!Files.isDirectory(targetdir))
			throw e;
		}
		return CONTINUE;
	 }
	@Override
	public FileVisitResult visitFile(Path file, BasicFileAttributes attrs)
		throws IOException {
		Files.copy(file, target.resolve(source.relativize(file)));
	return CONTINUE;
	}
});
```
#####**访问文件属性**
NIO.2在java.nio.file.attribute包下提供了大量用来访问文件属性的工具类，用来简单读取、修改文件属性：

 - XxxAttributeView：实现自FileAttributeView接口，代表某种文件属性的视图；
 - XxxAttributes：代表某种文件属性的“集合”，一般通过XxxAttributeView对象来获取XxxAttributes。
 
AclFileAttributeView：用来为特定文件设置ACL（Access Control List）及文件所有者属性。其getAcl()方法返回List&lt;AclEntry>对象，该返回值代表该文件的权限集，通过setAcl(List)方法可以修改该文件的ACL。
 
BasicFileAttributeView：用来获取或修改文件的基本属性，包括文件的最后修改时间、最后访问时间、大小、是否为目录、是否为符号链接等。其readAttributes()方法返回一个BasicFileAttributes对象，对文件夹基本属性的修改是通过BasicFileAttributes对象完成的。

DosFileAttributeView：用来获取或修改文件的DOS相关属性，如文件是否只读、是否隐藏、是否为系统文件、是否是存档文件等。其readAttributes()方法返回一个DosFileAttributes对象来修改以上属性。
 
FileOwnerAttributeView：用于获取或修改文件的所有者。其getOwner()返回一个UserPrincipal对象来代表文件所有者，其setOwner(UserPrincipal onwer)方法来改变文件的所有者。
 
PosixFileAttributeView：用于获取或修改POSIX（Portable Operating System Interface of INIX）属性，其readAttributes()方法返回一个PosixFileAttributes对象来获取或修改文件的所有者、组所有者、访问权限信息（即chmod命令所修改的权限）。该View只能在Unix、Linux系统中使用。
 
UserDefinedFileAttributeView：它可以让开发者为文件设置一些自定义属性。
 
 示例：
```java
public class AttributeViewTest
{
	public static void main(String[] args)
		throws Exception
	{
		// 获取将要操作的文件
		Path testPath = Paths.get("AttributeViewTest.java");
		// 获取访问基本属性的BasicFileAttributeView
		BasicFileAttributeView basicView = Files.getFileAttributeView(
			testPath , BasicFileAttributeView.class);
		// 获取访问基本属性的BasicFileAttributes
		BasicFileAttributes basicAttribs = basicView.readAttributes();
		// 访问文件的基本属性
		System.out.println("创建时间：" + new Date(basicAttribs
			.creationTime().toMillis()));
		System.out.println("最后访问时间：" + new Date(basicAttribs
			.lastAccessTime().toMillis()));
		System.out.println("最后修改时间：" + new Date(basicAttribs
			.lastModifiedTime().toMillis()));
		System.out.println("文件大小：" + basicAttribs.size());
		// 获取访问文件属主信息的FileOwnerAttributeView
		FileOwnerAttributeView ownerView = Files.getFileAttributeView(
			testPath, FileOwnerAttributeView.class);
		// 获取该文件所属的用户
		System.out.println(ownerView.getOwner());
		// 获取系统中guest对应的用户
		UserPrincipal user = FileSystems.getDefault()
			.getUserPrincipalLookupService()
			.lookupPrincipalByName("guest");
		// 修改用户
		ownerView.setOwner(user);
		// 获取访问自定义属性的FileOwnerAttributeView
		UserDefinedFileAttributeView userView = Files.getFileAttributeView(
			testPath, UserDefinedFileAttributeView.class);
		List<String> attrNames = userView.list();
		// 遍历所有的自定义属性
		for (String name : attrNames)
		{
			ByteBuffer buf = ByteBuffer.allocate(userView.size(name));
			userView.read(name, buf);
			buf.flip();
			String value = Charset.defaultCharset().decode(buf).toString();
			System.out.println(name + "--->" + value) ;
		}
		// 添加一个自定义属性
		userView.write("发行者", Charset.defaultCharset()
			.encode("疯狂Java联盟"));
		// 获取访问DOS属性的DosFileAttributeView
		DosFileAttributeView dosView = Files.getFileAttributeView(testPath
			, DosFileAttributeView.class);
		// 将文件设置隐藏、只读
		dosView.setHidden(true);
		dosView.setReadOnly(true);
	}
}
```