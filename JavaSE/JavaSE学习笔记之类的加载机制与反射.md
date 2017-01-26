###**类的加载机制**
Java虚拟机把描述类的数据从Class文件加载到内存，并对数据进行校验、转换解析和初始化，最终形成可以被虚拟机直接使用的Java类型，这就是虚拟机的加载机制。类从被加载到虚拟机内存中开始，到卸载出内存为止，它的整个生命周期包括了：加载（Loading）、验证（Verification）、准备（Preparation）、解析（Resolution）、初始化（Initialization）、使用（using）、和卸载（Unloading）七个阶段。其中验证、准备和解析三个部分统称为连接（Linking），而类的加载机制包括加载、连接和初始化。
![这里写图片描述](http://img.blog.csdn.net/20170103172738003?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvcm9zeV9kYXdu/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)
####**类的加载**
类的加载是指将该类的 class文件读入到内存中，并为之创建一个java.lang.Class对象。类的加载时类加载机制的开始。JVM允许系统预先加载某些类。类的加载通常有JVM提供的系统类加载器完成，开发者也可以通过继承ClassLoader基类来定义自己的类加载器，通过不同的类加载器来从不同的来源加载类的二进制数据：

 1. 从本地文件系统加载class文件；
 2. 从JAR包加载class文件。如JDBC编程所用的数据库驱动类即放在JAR包中，JVM可以直接从JAR包读取class文件；
 3. 通过网络加载class文件；
 4. 将一个Java源文件动态编译，并执行加载。

在加载阶段，JVM需要完成以下三件事情： 

1. 通过一个类的权限定名称来获取定义此类的二进制字节流；
2. 将这个字节流所代表的静态存储结构转化为方法区的运行时数据结构； 
3. 在java堆中生成一个代表这个类的java.lang.Class对象，作为方法区这些数据的访问入口。 

####**类的连接**
生成Class对象之后，接着会进入连接阶段，将类的二进制数据合并到JRE中，类的连接又可分为如下三个阶段：
 
1. 验证：检验被加载的Class文件中的字节流包含的信息符合当前虚拟机的要求，而且不会危害虚拟机自身的安全、并和其他类协调一致；
2. 准备：正式为类变量分配内存并设置类变量初始值（数据类型默认的零值（如0、0L、null、false等），而不是被在Java代码中被显式地赋予的值）的阶段，这些内存都将在方法区中进行分配；
3. 解析：将类的二进制数据中的符号引用替换成直接引用。

####**类的初始化**
在类的初始化阶段阶段，JVM负责对类进行初始化，主要是对**类变量**进行初始化。初始化步骤如下：

 - 假如这个类还没有被加载和连接，那么先加载并连接该类；
 - 假如该类的直接父类没有被初始化，那么先初始化其直接父类，依次初始化到Object类；
 - 假如该类有初始化语句，则系统依次执行这些初始化语句。
 
####**类的初始化时机**
Java程序**首次**使用下面6种方式来使用某个类或接口时，JVM就会初始化该类或接口：
 
- 创建该类的实例：使用new操作符、反射和反序列化；
- 调用类或接口的类方法；
- 调用类或接口的类变量，或为该类变量赋值；
- 使用反射方式强制创建某个类或接口对应的Class对象；
- 初始化某个子类时，如果其父类未初始化，则先初始化其父类；
- 直接使用java.exe命令来运行某个主类（包含main()方法的类）。

一个类在被动引用的情况下不会被初始化：

- 通过子类引用父类的静态字段，不会导致子类初始化。对于静态字段，只有直接定义该字段的类才会被初始化，因此当我们通过子类来引用父类中定义的静态字段时，只会触发父类的初始化，而不会触发子类的初始化；
- 通过数组定义来引用类（即数组元素为某个类的类型），不会触发此类的初始化；
- 常量在编译阶段会存入调用类的常量池中，本质上没有直接引用到定义常量的类，因此不会触发定义常量的类的初始化。如final型类变量，如果其在编译时即被替换为具体的值（定义时指定了具体值的话），相当于宏变量，因此使用final型类变量不会导致该类的初始化；如果final型变量指定的值不是确定值（如指定为System.currentTimeMillis()等），编译时无法确定其值，则在调用该变量时则会初始化其所在类。

###**类加载器**
####**类加载器种类**
一旦一个类被加载到JVM中，就不会再次加载该类。在JVM中，一个类使用其全限定类名和加载器名作为其唯一标识。当JVM启动时，会形成由三个类加载器组成的初始类加载器层次结构：

 - **启动（Bootstrap）类加载器）**：该类又称为原始（或根）类加载器，是由C语言实现的（是最顶级的类加载器了，所以启动类加载器是无法被Java程序直接引用的），负责加载存放在%JAVA\_HOME%\jre\lib目录下的核心类，或使用java.exe命令时被-Xbootclasspath选项或-D选项指定sun.boot.class.path系统属性值可以指定的附加的类且能被虚拟机识别的类库（如rt.jar，所有的java.\*开头的类均被Bootstrap ClassLoader加载）；
 -  **扩展（Extension）类加载器**：该加载器由sun.misc.Launcher\$ExtClassLoader实现，可以直接使用扩展类加载器，负责加载JRE扩展目录（%JAVA\_HOME%\jre\lib\ext或由java.ext.dirs系统属性指定的目录）中JAR包中的类。可通过这种方式为Java扩展核心类以外的功能，只要把自己开发的类打包成JAR文件，然后放入%JAVA\_HOME%\jre\lib\ext目录下即可。在使用Java运行程序时，也可以指定其搜索路径，例如：java -D java.ext.dirs=d:\projects\testproj\classes HelloWorld；
 - **系统（System ）类加载器**：该类又称为应用类加载器，由sun.misc.Launcher\$AppClassLoader实现的，可以直接使用扩展类加载器，负责在JVM启动时来自java命令的-classpath选项、java.class.path系统属性，或CLASSPATH环境变量所指定的JAR包和类路径。可以使用ClassLoader的静态方法getSystemClassLoader()来获取系统类加载器。在使用Java运行程序时，也可以加上-cp来覆盖原有的Classpath设置，例如： java -cp ./lavasoft/classes HelloWorld。

####**JVM的三种类加载机制**

- **全盘负责**：当一个类加载器负责加载某个Class时，该Class所依赖的和引用的其他Class也将由该类加载器负责载入，除非显示使用另外一个类加载器来载入；
- **父类委托**：先让父类加载器试图加载该类，只有在父类加载器无法加载该类时才尝试从自己的类路径中加载该类。类加载器之间的父子关系并不是继承关系，是类加载器实例之间的关系；
- **缓存机制**：缓存机制将会保证所有加载过的Class都会被缓存，当程序中需要使用某个Class时，类加载器先从缓存区寻找该Class，只有缓存区不存在，系统才会读取该类对应的二进制数据，并将其转换成Class对象，存入缓存区。这就是为什么修改了Class后，必须重启JVM，程序的修改才会生效。

示例：
```java
public class ClassLoaderPropTest
{
	public static void main(String[] args)
		throws IOException
	{
		// 获取系统类加载器
		ClassLoader systemLoader = ClassLoader.getSystemClassLoader();
		System.out.println("系统类加载器：" + systemLoader);
		/*
		获取系统类加载器的加载路径——通常由CLASSPATH环境变量指定
		如果操作系统没有指定CLASSPATH环境变量，默认以当前路径作为
		系统类加载器的加载路径
		*/
		Enumeration&lt;URL> em1 = systemLoader.getResources("");
		while(em1.hasMoreElements())
		{
			System.out.println(em1.nextElement());
		}
		// 获取系统类加载器的父类加载器：得到扩展类加载器
		ClassLoader extensionLader = systemLoader.getParent();
		System.out.println("扩展类加载器：" + extensionLader);
		System.out.println("扩展类加载器的加载路径："
			+ System.getProperty("java.ext.dirs"));
		//返回null，因为根加载器由C语言实现，通常无法直接访问
		System.out.println("扩展类加载器的parent: "
			+ extensionLader.getParent());
	}
}
```
输出结果：
```java
系统类加载器：sun.misc.Launcher$AppClassLoader@73d16e93
file:/F:/workspace/demo/bin/
扩展类加载器：sun.misc.Launcher$ExtClassLoader@15db9742
扩展类加载器的加载路径：C:\Program Files\Java\jdk1.8.0_102\jre\lib\ext;C:\Windows\Sun\Java\lib\ext
扩展类加载器的parent: null
```
根据以上结果可知，类加载器实例的继承关系为：
![这里写图片描述](http://img.blog.csdn.net/20170103173446231?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvcm9zeV9kYXdu/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)
而实际的继承关系：
![这里写图片描述](http://img.blog.csdn.net/20170103173845055?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvcm9zeV9kYXdu/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

####**类加载的三种方式**：

- 命令行启动应用时候由JVM初始化加载；
- 通过Class.forName()方法动态加载；
- 通过ClassLoader.loadClass()方法动态加载。

示例：
```java
class Test2 { 
    static { 
        System.out.println("静态初始化块执行了！"); 
    } 
}
public class loaderTest { 
    public static void main(String[] args) throws ClassNotFoundException { 
        ClassLoader loader = HelloWorld.class.getClassLoader(); 
        System.out.println(loader); 
        //使用ClassLoader.loadClass()来加载类，仅将.class文件加载到jvm中，不会执行static中的初始化内容
        //只有在newInstance才会去执行static块
        loader.loadClass("Test2"); 
        //使用Class.forName()来加载类，除了将类的.class文件加载到jvm中，还会执行类中的static修饰的初始化块
        //Class.forName("Test2"); 
        //使用Class.forName(name, initialize, loader)带参函数也可控制是否加载static块
        //并指定ClassLoader
        //Class.forName("Test2", false, loader); 
    } 
}
```
类加载器加载class文件的流程：
![这里写图片描述](http://img.blog.csdn.net/20170103185326011?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvcm9zeV9kYXdu/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

####**自定义类加载器**
JVM自带的ClassLoader只是懂得从本地文件系统加载标准的java class文件，开发者通过继承ClassLoader来实现自己的类加载器，自定义类加载器可以实现：

1. 在执行代码前自动验证数字签名；
2. 根据用户提供的密码解密代码，从而实现代码混淆器来避免反编译*.class文件；
3. 根据用户需求动态地加载类；
4. 根据应用需求以字节码的形式从特定的场所取得*.lass文件，例如数据库中和网络中。

**ClassLoader类**
该类是一个抽象类，负责加载类的对象。每个Class对象都包含一个对定义它的 ClassLoader 的引用。 

ClassLoader 类使用委托模型来搜索类和资源。每个 ClassLoader 实例都有一个相关的父类加载器。需要查找类或资源时，ClassLoader 实例会在试图亲自查找类或资源之前，将搜索类或资源的任务委托给其父类加载器。虚拟机的内置类加载器（称为 "bootstrap class loader"）本身没有父类加载器，但是可以将它用作 ClassLoader 实例的父类加载器。 

数组类的 Class 对象不是由类加载器创建的，而是由 Java 运行时根据需要自动创建。数组类的类加载器由 Class.getClassLoader() 返回，该加载器与其元素类型的类加载器是相同的；如果该元素类型是基本类型，则该数组类没有类加载器。

方法摘要：

- Class&lt;?> **loadClass(String name)**：使用指定的二进制名称来加载类。先使用findLoadedClass方法检查是否已经加载了该类，如果加载过直接返回，否则在父类上调用loadClass方法。如果父类为null，则使用根类类加载器来加载。然后再调用findClass方法查找类； 
- protected  Class&lt;?> **loadClass(String name, boolean resolve)**：同上； 
- protected  Class&lt;?> **findClass(String name)**：使用指定的二进制名称查找类；
- protected  String findLibrary(String libname)：返回本机库的绝对路径名；
- protected  Class&lt;?> **findLoadedClass(String name)**：如果JVM已加载了名为name的类，则直接返回该类对象，否则返回null。该方法时Java类加载缓存机制的体现；
- protected  **URL findResource(String name)**：查找具有给定名称的资源； 
- protected  Enumeration&lt;URL> findResources(String name)：返回表示所有具有给定名称的资源的 URL 对象的枚举；
- protected  Class&lt;?> **findSystemClass(String name)**：从本地文件系统中查找类文件，如果找到则使用defineClass方法将原始字节码换成Class对象，以将该文件转换成类；
- protected  Class&lt;?> **defineClass(String name, byte[] b, int off, int len)**：将制定类的字节码文件（即类的.class文件）字节数组byte[] b中，并把它转换成Class对象，该字节码文件可以来自文件、网络等；
- protected  Class&lt;?> defineClass(String name, byte[] b, int off, int len, ProtectionDomain protectionDomain)：使用可选的 ProtectionDomain 将一个 byte 数组转换为 Class 类的实例；
- protected  Class&lt;?> defineClass(String name, ByteBuffer b, ProtectionDomain protectionDomain)：使用可选的 ProtectionDomain 将 ByteBuffer 转换为 Class 类的实例；
- protected  Package definePackage(String name, String specTitle, String specVersion, String specVendor, String implTitle, String implVersion, String implVendor, URL sealBase)：根据 name 在此 ClassLoader 中定义包；
- protected  Package **getPackage(String name)**：返回由此类加载器或其任何祖先所定义的 Package；
- protected  Package[] getPackages()：返回此类加载器及其祖先所定义的所有 Package； 
- ClassLoader **getParent()**：返回委托的父类加载器；
- URL **getResource(String name)**：查找具有给定名称的资源； 
- InputStream getResourceAsStream(String name)：返回读取指定资源的输入流； 
- Enumeration&lt;URL> **getResources(String name)**：查找所有给定名称的资源；
- **static ClassLoader** **getSystemClassLoader()**：返回委托的系统类加载器； 
- static URL **getSystemResource(String name)**：从用来加载类的搜索路径中查找具有指定名称的资源； 
- static InputStream getSystemResourceAsStream(String name)：从用来加载类的搜索路径打开具有指定名称的资源，以读取该资源；
- static Enumeration&lt;URL> **getSystemResources(String name)**：从用来加载类的搜索路径中查找所有具有指定名称的资源；
- protected  void **resolveClass(Class&lt;?> c)**：链接指定的类；
- void setClassAssertionStatus(String className, boolean enabled)：设置在此类加载器及其包含的嵌套类中指定的最高层类所需的断言状态； 
- void setDefaultAssertionStatus(boolean enabled)：设置此类加载器的默认断言状态；
- void setPackageAssertionStatus(String packageName, boolean enabled)：为指定包设置默认断言状态；
- protected  void setSigners(Class&lt;?> c, Object[] signers)：设置类的签署者。 

一般推荐重写findClass方法来实现自定义类加载器，而不是重写loadClass方法。因为重写findClass方法可以避免覆盖默认类加载器的父类委托、缓冲机制两种策略，如果重写loadClass方法逻辑更加复杂。

可以在加载类之前先编译该类的源文件的加载器示例：
```java
public class CompileClassLoader extends ClassLoader
{
	// 读取一个文件的内容
	private byte[] getBytes(String filename)
		throws IOException
	{
		File file = new File(filename);
		long len = file.length();
		byte[] raw = new byte[(int)len];
		try(
			FileInputStream fin = new FileInputStream(file))
		{
			// 一次读取class文件的全部二进制数据
			int r = fin.read(raw);
			if(r != len)
			throw new IOException("无法读取全部文件："
				+ r + " != " + len);
			return raw;
		}
	}
	// 定义编译指定Java文件的方法
	private boolean compile(String javaFile)
		throws IOException
	{
		System.out.println("CompileClassLoader:正在编译 "
			+ javaFile + "...");
		// 调用系统的javac命令
		Process p = Runtime.getRuntime().exec("javac " + javaFile);
		try
		{
			// 其他线程都等待这个线程完成
			p.waitFor();
		}
		catch(InterruptedException ie)
		{
			System.out.println(ie);
		}
		// 获取javac线程的退出值
		int ret = p.exitValue();
		// 返回编译是否成功
		return ret == 0;
	}
	// 重写ClassLoader的findClass方法
	protected Class&lt;?> findClass(String name)
		throws ClassNotFoundException
	{
		Class clazz = null;
		// 将包路径中的点（.）替换成斜线（/）。
		String fileStub = name.replace("." , "/");
		String javaFilename = fileStub + ".java";
		String classFilename = fileStub + ".class";
		File javaFile = new File(javaFilename);
		File classFile = new File(classFilename);
		// 当指定Java源文件存在，且class文件不存在、或者Java源文件
		// 的修改时间比class文件修改时间更晚，重新编译
		if(javaFile.exists() && (!classFile.exists()
			|| javaFile.lastModified() > classFile.lastModified()))
		{
			try
			{
				// 如果编译失败，或者该Class文件不存在
				if(!compile(javaFilename) || !classFile.exists())
				{
					throw new ClassNotFoundException(
						"ClassNotFoundExcetpion:" + javaFilename);
				}
			}
			catch (IOException ex)
			{
				ex.printStackTrace();
			}
		}
		// 如果class文件存在，系统负责将该文件转换成Class对象
		if (classFile.exists())
		{
			try
			{
				// 将class文件的二进制数据读入数组
				byte[] raw = getBytes(classFilename);
				// 调用ClassLoader的defineClass方法将二进制数据转换成Class对象
				clazz = defineClass(name,raw,0,raw.length);
			}
			catch(IOException ie)
			{
				ie.printStackTrace();
			}
		}
		// 如果clazz为null，表明加载失败，则抛出异常
		if(clazz == null)
		{
			throw new ClassNotFoundException(name);
		}
		return clazz;
	}
	// 定义一个主方法
	public static void main(String[] args) throws Exception
	{
		// 如果运行该程序时没有参数，即没有目标类
		if (args.length &lt; 1)
		{
			System.out.println("缺少目标类，请按如下格式运行Java源文件：");
			System.out.println("java CompileClassLoader ClassName");
		}
		// 第一个参数是需要运行的类
		String progClass = args[0];
		// 剩下的参数将作为运行目标类时的参数，
		// 将这些参数复制到一个新数组中
		String[] progArgs = new String[args.length-1];
		System.arraycopy(args , 1 , progArgs
			, 0 , progArgs.length);
		CompileClassLoader ccl = new CompileClassLoader();
		// 加载需要运行的类
		Class&lt;?> clazz = ccl.loadClass(progClass);
		// 获取需要运行的类的主方法
		Method main = clazz.getMethod("main" , (new String[0]).getClass());
		Object[] argsArray = {progArgs};
		main.invoke(null,argsArray);
	}
}
```
```java
public class Hello
{
	public static void main(String[] args)
	{
		for (String arg : args)
		{
			System.out.println("运行Hello的参数：" + arg);
		}
	}
}
```
运行以下命令：
> java CompileClassLoader Hello 自定义的加载器

输出：
>CompileClassLoadr:正在编译 Hello.java...
 运行Hello的参数：自定义的加载器

**URLClassLoader**
该类加载器用于从指向 JAR 文件和目录的 URL 的搜索路径加载类和资源。该类是ClassLoader的实现类，是系统类加载器和扩展类加载器的父类（从继承角度来说），可以直接使用该类。这里假定任何以 '/' 结束的 URL 都是指向目录的。如果不是以该字符结束，则认为该 URL 指向一个将根据需要打开的 JAR 文件。 

构造方法摘要：

- **URLClassLoader(URL[] urls)**：使用默认的父类加载器创建一个URLClassLoader对象。该对象将从urls指定的一系列路径来查询并加载类；
- **URLClassLoader(URL[] urls, ClassLoader parent)**：使用指定的父类加载器创建一个URLClassLoader对象，其他同上； 
- URLClassLoader(URL[] urls, ClassLoader parent, URLStreamHandlerFactory factory)：使用指定的 URL、父类加载器和 URLStreamHandlerFactory 创建新 URLClassLoader对象。 

得到URLClassLoader对象后，就可以通过该对象的loadClass方法加载对象。

从文件系统中加载MySQL驱动的示例：
```java
public class URLClassLoaderTest
{
	private static Connection conn;
	// 定义一个获取数据库连接方法
	public static Connection getConn(String url ,
		String user , String pass) throws Exception
	{
		if (conn == null)
		{
			// 创建一个URL数组,file可以换成http、ftp等
			URL[] urls = {new URL(
				"file:mysql-connector-java-5.1.30-bin.jar")};
			// 以默认的ClassLoader作为父ClassLoader，创建URLClassLoader
			URLClassLoader myClassLoader = new URLClassLoader(urls);
			// 加载MySQL的JDBC驱动，并创建默认实例
			Driver driver = (Driver)myClassLoader.
				loadClass("com.mysql.jdbc.Driver").newInstance();
			// 创建一个设置JDBC连接属性的Properties对象
			Properties props = new Properties();
			// 至少需要为该对象传入user和password两个属性
			props.setProperty("user" , user);
			props.setProperty("password" , pass);
			// 调用Driver对象的connect方法来取得数据库连接
			conn = driver.connect(url , props);
		}
		return conn;
	}
	public static void main(String[] args)throws Exception
	{
		System.out.println(getConn("jdbc:mysql://localhost:3306/mysql"
			, "root" , "32147"));
	}
}
```
###**反射**
####**反射机制**
JAVA反射机制是在运行状态中，对于任意一个类，都能够知道这个类的所有属性和方法；对于任意一个对象，都能够调用它的任意方法和属性；这种动态获取信息以及动态调用对象方法的功能称为java语言的反射机制。

反射机制主要提供了以下功能： 

- 在运行时判断任意一个对象所属的类；
- 在运行时构造任意一个类的对象；
- 在运行时判断任意一个类所具有的成员变量和方法；
- 在运行时调用任意一个对象的方法；
- 生成动态代理。

当一个对象的运行时类型和编译时类型不同，甚至，程序从外部接收的对象编译时是Object类型，但是需要访问其运行时类型的方法。如果知道该对象的实际类型则可以通过instanceof运算符判断该对象是否是某一确定类型，如果是则强制转换为该类型；如果编译时无法预知该对象和类可能属于那些类，只能依靠运行时信息来发现该对象和类的真实信息，这就必须使用反射。

####**访问Class对象**
每个类被加载之后，系统为其生成一个Class类的对象，获取该Class类对象有以下几种方式：

 - 使用Class类的forName(String clazzName)静态方法。需要指定类的全限定类名；
 - 调用某个类的class属性来获取该类对应的Class对象；
 - 调用某个对象的getClass()方法。这个方法继承自Object类。
 
大部分时候推荐使用第二种方法，这样不需要调用方法，性能更好，程序在编译阶段就可以检查需要访问的Class对象是否存在。如果只提供了一个类的全限定名的字符串，那么只能使用第一种方法。


**Class&lt;T>类**
该类为不可变类，其实例表示正在运行中的 Java 类和接口。枚举是一种类，注释是一种接口。每个数组属于被映射为 Class 对象的一个类，所有具有相同元素类型和维数的数组都共享该 Class 对象，基本的 Java 类型和关键字 void 也表示为 Class 对象。

Class 没有公共构造方法，其对象是在加载类时由 Java 虚拟机以及通过调用类加载器中的 defineClass 方法自动创建的。 

方法摘要：

- **static Class&lt;?> forName(String className)**：返回与带有给定字符串名的类或接口相关联的 Class 对象；
- **static Class&lt;?> forName(String name, boolean initialize, ClassLoader loader)**：使用给定的类加载器，返回与带有给定字符串名的类或接口相关联的 Class 对象；
- Constructor&lt;T> **getConstructor(Class&lt;?>... parameterTypes)**：返回该Class对象对应类或接口的、具有指定形参列表的构造器；
- Constructor&lt;?>[] **getConstructors()**：返回该Class对象对应类或接口或接口或接口的所有公共构造方法；
- Constructor&lt;T> **getDeclaredConstructor(Class&lt;?>... parameterTypes)**：返回该Class对象对应类或接口或接口的、具有指定形参列表的构造器，与构造器的访问权限无关；
- Constructor&lt;?>[] **getDeclaredConstructors()**：返回该Class对象对应类或接口的所有构造方法，与构造器的访问权限无关； 
- Constructor&lt;?> getEnclosingConstructor()：如果该 Class 对象表示构造方法中的一个本地或匿名类，则返回 Constructor 对象，它表示底层类的立即封闭构造方法； 
- String **getCanonicalName()**：返回 Java Language Specification 中所定义的底层类的规范化名称； 
- Class&lt;?>[] **getClasses()**：返回一个包含某些 Class 对象的数组，这些对象表示属于此 Class 对象所表示的类的成员的所有公共类和接口；
-Class&lt;?>[] **getDeclaredClasses()**：返回 Class 对象对应类里所包含的全部内部类；   
-Class&lt;?>[] **getDeclaringClasses()**：返回 Class 对象对应类所在的外部类； 
- Class&lt;?> getEnclosingClass()：返回底层类的立即封闭类； 
- Class&lt;? super T> **getSuperclass()**：返回表示此 Class 所表示的实体（类、接口、基本类型或 void）的超类的 Class； 
- Type **getGenericSuperclass()**：返回表示此 Class 所表示的实体（类、接口、基本类型或 void）的**直接**超类的 Type；
- ClassLoader **getClassLoader()**：返回该类的类加载器；
- &lt;A extends Annotation> A **getAnnotation(Class&lt;A> annotationClass)**：获取该Class对象对应类或接口上指定名称的注解，不存在返回null； 
- &lt;A extends Annotation> A **getDeclaredAnnotation(Class&lt;A> annotationClass)**：Java8新增的方法，尝试获取直接修饰该Class对象对应类或接口的、指定类型的注解，不存在则返回null；
- Annotation[] **getAnnotations()**：获取该Class对象对应类或接口上所有的注解；
- Annotation[] **getDeclaredAnnotations()**：返回直接存在于此元素上的所有注释；
- &lt;A extends Annotation> A[] **getAnnotationsByType(Class&lt;A> annotationClass)**：与前面的getDeclaredAnnotations方法相似，由于Java8新增了重复注解，因此需要使用该方法获取修饰该类的、指定类型的多个注解；
- &lt;A extends Annotation> A[] **getDeclaredAnnotationsByType(Class&lt;A> annotationClass)**：与前面的getAnnotations方法相似，由于Java8新增了重复注解，因此需要使用该方法获取修饰该类的、指定类型的多个注解；
- Method getEnclosingMethod()：如果此 Class 对象表示某一方法中的一个本地或匿名类，则返回 Method 对象，它表示底层类的立即封闭方法； 
- Method **getMethod(String name, Class&lt;?>... parameterTypes)**：返回该Class对象对应类或接口的、具有指定形参列表的Method对象；
- Method[] **getMethods()**：返回该Class对象对应类或接口所有的公共 member 方法组成的数组；
- Method **getDeclaredMethod(String name, Class<?>... parameterTypes)**：返回该Class对象对应类或接口的、具有指定形参列表的Method对象；
- Method[] **getDeclaredMethods()**：返回该Class对象对应类或接口所有的member 方法（包括公共、保护、包访问和私有方法，但不包括继承的方法）组成的数组； 
- T[] getEnumConstants()：如果此 Class 对象不表示枚举类型，则返回枚举类的元素或 null；
- Field **getField(String name)**：返回该Class对象对应的类或接口的、具有指定名称的public成员变量；
- Field[] **getFields()**：返回该Class对象对应的类或接口所有的public成员变量；
- Field **getDeclaredField(String name)**：返回该Class对象对应的类或接口的、具有指定名称的任何访问权限成员变量； 
- Field[] **getDeclaredFields()**：返回该Class对象对应的类或接口所有任何访问权限的成员变量；
- Type[] **getGenericInterfaces()**：返回表示某些接口的 Type，这些接口由此对象所表示的类或接口直接实现；
- Class&lt;?>[] **getInterfaces()**：确定此对象所表示的类或接口实现的接口； 
- int **getModifiers()**：返回此类或接口以整数编码的 Java 语言修饰符。使用Modifier工具类解析返回的整数； 
- String **getName()**：以 String 的形式返回此 Class 对象所表示的实体（类、接口、数组类、基本类型或 void）名称；
- Package **getPackage()**：获取此类的包；
- ProtectionDomain getProtectionDomain()：返回该类的 ProtectionDomain；
- URL getResource(String name)：查找带有给定名称的资源；
- InputStream getResourceAsStream(String name)：查找具有给定名称的资源；
- Object[] getSigners()：获取此类的标记；
- String getSimpleName()：返回源代码中给出的底层类的简称；
- TypeVariable&lt;Class&lt;T>>[] getTypeParameters()：按声明顺序返回 TypeVariable 对象的一个数组，这些对象表示用此 GenericDeclaration 对象所表示的常规声明来声明的类型变量； 
- boolean **isAnnotation()**：如果此 Class 对象表示一个注释类型则返回 true；
- boolean **isAnnotationPresent(Class&lt;? extends Annotation> annotationClass)**：如果指定类型的注释存在于此元素上，则返回 true，否则返回 false；
- boolean **isAnonymousClass()**：当且仅当底层类是匿名类时返回 true；
- boolean **isArray()**：判定此 Class 对象是否表示一个数组类；
- boolean isAssignableFrom(Class&lt;?> cls)：判定此 Class 对象所表示的类或接口与指定的 Class 参数所表示的类或接口是否相同，或是否是其超类或超接口；
- boolean **isEnum()**：当且仅当该类声明为源代码中的枚举时返回 true；
- boolean **isInstance(Object obj)**：判定指定的 Object 是否与此 Class 所表示的对象赋值兼容；
- boolean **isInterface()**：判定指定的 Class 对象是否表示一个接口类型；
- boolean **isLocalClass()**：当且仅当底层类是本地类时返回 true；
- boolean **isMemberClass()**：当且仅当底层类是成员类时返回 true； 
- boolean **isPrimitive()**：判定指定的 Class 对象是否表示一个基本类型； 
- boolean **isSynthetic()**：如果此类是复合类，则返回 true，否则 false；
- T **newInstance()**：创建此 Class 对象所表示的类的一个新实例。 

示例：
```java
package reflect;
// 定义可重复注解
@Repeatable(Annos.class)
@interface Anno {}
@Retention(value=RetentionPolicy.RUNTIME)
@interface Annos {
    Anno[] value();
}
// 使用4个注解修饰该类
@SuppressWarnings(value="unchecked")
@Deprecated
// 使用重复注解修饰该类
@Anno
@Anno
public class ClassTest
{
	// 为该类定义一个私有的构造器
	private ClassTest()
	{
	}
	// 定义一个有参数的构造器
	public ClassTest(String name)
	{
		System.out.println("执行有参数的构造器");
	}
	// 定义一个无参数的info方法
	public void info()
	{
		System.out.println("执行无参数的info方法");
	}
	// 定义一个有参数的info方法
	public void info(String str)
	{
		System.out.println("执行有参数的info方法"
			+ "，其str参数值：" + str);
	}
	// 定义一个测试用的内部类
	class Inner
	{
	}
	public static void main(String[] args)
		throws Exception
	{
		// 下面代码可以获取ClassTest对应的Class
		Class<ClassTest> clazz = ClassTest.class;
		// 获取该Class对象所对应类的全部构造器
		Constructor[] ctors = clazz.getDeclaredConstructors();
		System.out.println("ClassTest的全部构造器如下：");
		for (Constructor c : ctors)
		{
			System.out.println(c);
		}
		// 获取该Class对象所对应类的全部public构造器
		Constructor[] publicCtors = clazz.getConstructors();
		System.out.println("ClassTest的全部public构造器如下：");
		for (Constructor c : publicCtors)
		{
			System.out.println(c);
		}
		// 获取该Class对象所对应类的全部public方法
		Method[] mtds = clazz.getMethods();
		System.out.println("ClassTest的全部public方法如下：");
		for (Method md : mtds)
		{
			System.out.println(md);
		}
		// 获取该Class对象所对应类的指定方法
		System.out.println("ClassTest里带一个字符串参数的info()方法为："
			+ clazz.getMethod("info" , String.class));
		// 获取该Class对象所对应类的上的全部注解
		Annotation[] anns = clazz.getAnnotations();
		System.out.println("ClassTest的全部Annotation如下：");
		for (Annotation an : anns)
		{
			System.out.println(an);
		}
		//对于只能保存在源码级别上的注解，使用运行时获取的Class对象无法访问到该注解对象
		System.out.println("该Class元素上的@SuppressWarnings注解为："
			+ Arrays.toString(clazz.getAnnotationsByType(SuppressWarnings.class)));
		System.out.println("该Class元素上的@Anno注解为："
			+ Arrays.toString(clazz.getAnnotationsByType(Anno.class)));
		// 获取该Class对象所对应类的全部内部类
		Class<?>[] inners = clazz.getDeclaredClasses();
		System.out.println("ClassTest的全部内部类如下：");
		for (Class c : inners)
		{
			System.out.println(c);
		}
		// 使用Class.forName方法加载ClassTest的Inner内部类
		Class inClazz = Class.forName("ClassTest$Inner");
		// 通过getDeclaringClass()访问该类所在的外部类
		System.out.println("inClazz对应类的外部类为：" +
			inClazz.getDeclaringClass());
		System.out.println("ClassTest的包为：" + clazz.getPackage());
		System.out.println("ClassTest的父类为：" + clazz.getSuperclass());
	}
}
```
输出：
```
ClassTest的全部构造器如下：
private reflect.ClassTest()
public reflect.ClassTest(java.lang.String)
ClassTest的全部public构造器如下：
public reflect.ClassTest(java.lang.String)
ClassTest的全部public方法如下：
public static void reflect.ClassTest.main(java.lang.String[]) throws java.lang.Exception
public void reflect.ClassTest.info(java.lang.String)
public void reflect.ClassTest.info()
public final void java.lang.Object.wait() throws java.lang.InterruptedException
public final void java.lang.Object.wait(long,int) throws java.lang.InterruptedException
public final native void java.lang.Object.wait(long) throws java.lang.InterruptedException
public boolean java.lang.Object.equals(java.lang.Object)
public java.lang.String java.lang.Object.toString()
public native int java.lang.Object.hashCode()
public final native java.lang.Class java.lang.Object.getClass()
public final native void java.lang.Object.notify()
public final native void java.lang.Object.notifyAll()
ClassTest里带一个字符串参数的info()方法为：public void reflect.ClassTest.info(java.lang.String)
ClassTest的全部Annotation如下：
@java.lang.Deprecated()
@reflect.Annos(value=[@reflect.Anno(), @reflect.Anno()])
该Class元素上的@SuppressWarnings注解为：[]
该Class元素上的@Anno注解为：[@reflect.Anno(), @reflect.Anno()]
ClassTest的全部内部类如下：
class reflect.ClassTest$Inner
inClazz对应类的外部类为：class reflect.ClassTest
ClassTest的包为：package reflect
ClassTest的父类为：class java.lang.Object
```
####**Java8新增的方法参数反射**
Java8在java.lang.reflect包下新增了一个Executable抽象基类，该类对象代表一个可执行的函数，该类派生了Constructor、Method两个子类。

方法摘要：

- AnnotatedType[]	**getAnnotatedExceptionTypes()**：返回一个AnnotatedType对象构成的数组，AnnotatedType对象代表了该Executable对象所代表的方法或构造器的指定声明异常的类型的使用；
- AnnotatedType[]	**getAnnotatedParameterTypes()**：返回一个AnnotatedType对象构成的数组，AnnotatedType对象代表了该Executable对象所代表的方法或构造器的指定形参的类型的使用；
- AnnotatedType	getAnnotatedReceiverType()：返回一个AnnotatedType对象，AnnotatedType对象代表了该Executable对象所代表的方法或构造器的指定接收者的类型的使用；
- abstract AnnotatedType	**getAnnotatedReturnType()**：返回一个AnnotatedType对象，AnnotatedType对象代表了该Executable对象所代表的方法或构造器的指定返回值的类型的使用；
- &lt;T extends Annotation> T **getAnnotation(Class&lt;T> - annotationClass)**：如果该元素存在特定类型的注解，则返回这样一个注解，否则返回null；
- &lt;T extends Annotation> T[] **getAnnotationsByType(Class&lt;T> - annotationClass)**：返回该元素相关的注解组成的数组；
- Annotation[] **getDeclaredAnnotations()**：返回该元素上直接呈现的注解组成的数组；
- abstract Class&lt;?> **getDeclaringClass()**：返回代表声明该对象代表的执行体的类或接口所对应的Class对象；
- abstract Class&lt;?>[]	**getExceptionTypes()**：返回一个Class对象组成的数组。Class对象代表了该对象代表的执行体在下面声明抛出的异常类型；
- Type[]	**getGenericExceptionTypes()**：返回一个Type对象组成的数组，Type对象代表该Executable对象代表的执行体代表的执行体所抛出的声明异常类型；
- Type[]	**getGenericParameterTypes()**：返回一个Type对象组成的数组，Type对象代表该Executable对象代表的执行体所声明的形参类型，数组元素的顺序按照声明的顺序；
- abstract int **getModifiers()**：返回修饰该Executable对象的修饰符；
- abstract String	**getName()**：返回该Executable对象所代表执行体的名字；
- abstract Annotation[][]	**getParameterAnnotations()**：返回一个Annotation对象组成的数组，Annotation对象用于修饰形参，数组元素的顺序按照声明的顺序；
- int	**getParameterCount()**：返回该对象所代表执行体的形参（无论是显式声明还是隐式声明）的数目；
- Parameter[]	**getParameters()**：返回一个由Parameter对象构成的数组，这些Parameter对象代表了该Executable对象所代表的执行体中所有的参数；
- abstract Class&lt;?>[]	**getParameterTypes()**：返回一个由Class对象组成的数组，这些Class对象代表了该Executable对象所代表的执行体的形参类型。数组元素按照声明的顺序；
- abstract TypeVariable&lt;?>[] getTypeParameters()：返回一个由TypeVariable对象构成的数组，这些TypeVariable对象代表该GenericDeclaration对象按声明顺序声明的一般变量类型；
- boolean	**isSynthetic()**：如果该Executable对象是一个合成构造器，则返回true，否则返回false；
- boolean   **isNamePresent()**：判断该类的class文件中是否包含了方法的形参信息；
- boolean	**isVarArgs()**：如果该Executable对象声明为是参数可变的，则返回true，否则返回false；
- abstract String	**toGenericString()**：返回一个描述该Executable对象的字符串，包括任何类型参数；- 

示例：
```java
class Test
{
	public void replace(String str, List<String> list){}
}
public class MethodParameterTest
{
	public static void main(String[] args)throws Exception
	{
		// 获取String的类
		Class<Test> clazz = Test.class;
		// 获取String类的带两个参数的replace()方法
		Method replace = clazz.getMethod("replace"
			, String.class, List.class);
		// 获取指定方法的参数个数
		System.out.println("replace方法参数个数：" + replace.getParameterCount());
		// 获取replace的所有参数信息
		Parameter[] parameters = replace.getParameters();
		int index = 1;
		// 遍历所有参数
		for (Parameter p : parameters)
		{
			if (p.isNamePresent())
			{
				System.out.println("---第" + index++ + "个参数信息---");
				System.out.println("参数名：" + p.getName());
				System.out.println("形参类型：" + p.getType());
				System.out.println("泛型类型：" + p.getParameterizedType());
			}
		}
	}
}
```
由于javac命令默认编译java源文件生成的class文件并不包含方法的形参名信息，如果需要包含形参信息，可以在使用javac编译时指定-parameters选项，执行：
```
javac -parameters -d . MethodParameterTest.java
```
运行后输出：
```

```
###**使用反射来创建并操作对象**
反射相关的类位于java.lang.reflect包下。
![这里写图片描述](http://img.blog.csdn.net/20170104224901599?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvcm9zeV9kYXdu/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)
####**创建对象**
通过反射创建对象有两种方式：

 - 使用Class对象的newInstance()方法来创建该Class对象对应类的实例。这种方式要求该Class对象对应的类有默认构造器，因为执行该方法实际是执行默认构造器。这种方式较常用；
 - 先调用用Class对象的getConstructor()方法来获取指定的Constructor对象，再调用Constructor对象的newInstance()方法来创建该Class对象对应类的实例。通过这种方式可以选择使用指定的构造器。
 
示例1：
```java
public class ObjectPoolFactory
{
	// 定义一个对象池,前面是对象名，后面是实际对象
	private Map<String ,Object> objectPool = new HashMap<>();
	// 定义一个创建对象的方法，
	// 该方法只要传入一个字符串类名，程序可以根据该类名生成Java对象
	private Object createObject(String clazzName)
		throws InstantiationException
		, IllegalAccessException , ClassNotFoundException
	{
		// 根据字符串来获取对应的Class对象
		Class<?> clazz = Class.forName(clazzName);
		// 使用clazz对应类的默认构造器创建实例
		return clazz.newInstance();
	}
	// 该方法根据指定文件来初始化对象池，
	// 它会根据配置文件来创建对象
	public void initPool(String fileName)
		throws InstantiationException
		, IllegalAccessException ,ClassNotFoundException
	{
		try(
			FileInputStream fis = new FileInputStream(fileName))
		{
			Properties props = new Properties();
			props.load(fis);
			for (String name : props.stringPropertyNames())
			{
				// 每取出一对key-value对，就根据value创建一个对象
				// 调用createObject()创建对象，并将对象添加到对象池中
				objectPool.put(name ,
					createObject(props.getProperty(name)));
			}
		}
		catch (IOException ex)
		{
			System.out.println("读取" + fileName + "异常");
		}

	}
	public Object getObject(String name)
	{
		// 从objectPool中取出指定name对应的对象。
		return objectPool.get(name);
	}

	public static void main(String[] args)
		throws Exception
	{
		ObjectPoolFactory pf = new ObjectPoolFactory();
		pf.initPool("obj.txt");
		System.out.println(pf.getObject("a"));
		System.out.println(pf.getObject("b"));
	}
}
```
为以上程序提供一个配置文件obj.txt：
```java
a=java.util.Date
b=javax.swing.JFrame
```
示例2：
```java
//使用反射创建一个JFrame
public class CreateJFrame
{
	public static void main(String[] args)
		throws Exception
	{
		// 获取JFrame对应的Class对象
		Class<?> jframeClazz = Class.forName("javax.swing.JFrame");
		// 获取JFrame中带一个字符串参数的构造器
		Constructor ctor = jframeClazz
			.getConstructor(String.class);
		// 调用Constructor的newInstance方法创建对象
		Object obj = ctor.newInstance("测试窗口");
		// 输出JFrame对象
		System.out.println(obj);
	}
}
```
使用反射创建对象性能较低，只有当程序需要动态创建某个类的对象时才会考虑使用反射，通常在开发通用性比较广的框架、基础平台时可能会大量使用反射。
####**调用方法**
获得Class对象后，调用该Class对象的getMethods方法或getMethod方法可以获得该对象中方法所对应的Method对象。每个Method对象代表一个方法，调用Method对象的invoke()方法即可调用该方法，其方法签名为：

- Object invoke(Object obj, Object... args)：obj为执行该方法的主调，args为传入的实参；

该方法的程序必须有执行对应方法的权限，不能用于执行private修饰的方法，如果需要访问private修饰的方法，则可以先调用setAccessiable(boolean flag)方法，该方法属于Method类的父类AccessibleObject类，用于设定是否取消访问权限的检查。所以Constructor、Filed都可以使用该方法。
示例：
```java
public class ExtendedObjectPoolFactory
{
	// 定义一个对象池,前面是对象名，后面是实际对象
	private Map<String ,Object> objectPool = new HashMap<>();
	private Properties config = new Properties();
	// 从指定属性文件中初始化Properties对象
	public void init(String fileName)
	{
		try(
			FileInputStream fis = new FileInputStream(fileName))
		{
			config.load(fis);
		}
		catch (IOException ex)
		{
			System.out.println("读取" + fileName + "异常");
		}
	}
	// 定义一个创建对象的方法，
	// 该方法只要传入一个字符串类名，程序可以根据该类名生成Java对象
	private Object createObject(String clazzName)
		throws InstantiationException
		, IllegalAccessException , ClassNotFoundException
	{
		// 根据字符串来获取对应的Class对象
		Class<?> clazz =Class.forName(clazzName);
		// 使用clazz对应类的默认构造器创建实例
		return clazz.newInstance();
	}
	// 该方法根据指定文件来初始化对象池，
	// 它会根据配置文件来创建对象
	public void initPool()throws InstantiationException
		,IllegalAccessException , ClassNotFoundException
	{
		for (String name : config.stringPropertyNames())
		{
			// 每取出一对key-value对，如果key中不包含百分号（%）
			// 这就标明是根据value来创建一个对象
			// 调用createObject创建对象，并将对象添加到对象池中
			if (!name.contains("%"))
			{
				objectPool.put(name ,
					createObject(config.getProperty(name)));
			}
		}
	}
	// 该方法将会根据属性文件来调用指定对象的setter方法
	public void initProperty()throws InvocationTargetException
		,IllegalAccessException,NoSuchMethodException
	{
		for (String name : config.stringPropertyNames())
		{
			// 每取出一对key-value对，如果key中包含百分号（%）
			// 即可认为该key用于控制调用对象的setter方法设置值，
			// %前半为对象名字，后半控制setter方法名
			if (name.contains("%"))
			{
				// 将配置文件中key按%分割
				String[] objAndProp = name.split("%");
				// 取出调用setter方法的参数值
				Object target = getObject(objAndProp[0]);
				// 获取setter方法名:set + "首字母大写" + 剩下部分
				String mtdName = "set" +
				objAndProp[1].substring(0 , 1).toUpperCase()
					+ objAndProp[1].substring(1);
				// 通过target的getClass()获取它实现类所对应的Class对象
				Class<?> targetClass = target.getClass();
				// 获取希望调用的setter方法
				Method mtd = targetClass.getMethod(mtdName , String.class);
				// 通过Method的invoke方法执行setter方法，
				// 将config.getProperty(name)的值作为调用setter的方法的参数
				mtd.invoke(target , config.getProperty(name));
			}
		}
	}
	public Object getObject(String name)
	{
		// 从objectPool中取出指定name对应的对象。
		return objectPool.get(name);
	}
	public static void main(String[] args)
		throws Exception
	{
		ExtendedObjectPoolFactory epf = new ExtendedObjectPoolFactory();
		epf.init("extObj.txt");
		epf.initPool();
		epf.initProperty();
		System.out.println(epf.getObject("a"));
	}
}
```
为上面程序提供以下配置文件exObj.txt：
```
a=javax.swing.JFrame
b=javax.swing.JLabel
#set the title of a
a%title=Test Title
```
####**访问成员变量**
通过Class对象的getFields方法或getField方法来获取该类所包括的全部成员变量或指定成员变量。Filed类提供了以下两种方法：

 - getXxx(Object obj)：获取obj对象的该成员变量的值。此处的Xxx是对应8种基本类型，如果成员变量为引用类型，则去掉Xxx；
 - setXxx(Object obj, Xxx val)：将Obj对像的该成员变量设置成val值。此处的Xxx同上。

示例：
```java
class Person
{
	private String name;
	private int age;
	public String toString()
	{
		return "Person[name:" + name +
		" , age:" + age + " ]";
	}
}
public class FieldTest
{
	public static void main(String[] args)
		throws Exception
	{
		// 创建一个Person对象
		Person p = new Person();
		// 获取Person类对应的Class对象
		Class<Person> personClazz = Person.class;
		// 获取Person的名为name的成员变量
		// 使用getDeclaredField()方法表明可获取各种访问控制符的成员变量
		Field nameField = personClazz.getDeclaredField("name");
		// 设置通过反射访问该成员变量时取消访问权限检查
		nameField.setAccessible(true);
		// 调用set()方法为p对象的name成员变量设置值
		nameField.set(p , "Yeeku.H.Lee");
		// 获取Person类名为age的成员变量
		Field ageField = personClazz.getDeclaredField("age");
		// 设置通过反射访问该成员变量时取消访问权限检查
		ageField.setAccessible(true);
		// 调用setInt()方法为p对象的age成员变量设置值
		ageField.setInt(p , 30);
		System.out.println(p);
	}
}
```
####**访问数组**
java.lang.reflect包下还有一个Array类，该类对象代表所有的数组。Array类常用方法如下：

 - static Object newInstance(Class&lt;?> componentType, int... length)：创建一个具有指定元素类型、指定维度的新数组；
 - static xxx getXxx(Object array, int index)：返回Array数组中第index个元素。此处的Xxx是对应8种基本类型，如果成员变量为引用类型，则该方法编程get(Object array, int index)；
 - static void setXxx(Object array, int index, xxx val)：将array数组中第index个元素的值设置为val。此处的Xxx是对应8种基本类型，如果成员变量为引用类型，则该方法编程set(Object array, int index, Object val)；

示:1：
```java
public class ArrayTest1
{
	public static void main(String args[])
	{
		try
		{
			// 创建一个元素类型为String ，长度为10的数组
			Object arr = Array.newInstance(String.class, 10);
			// 依次为arr数组中index为5、6的元素赋值
			Array.set(arr, 5, "疯狂Java讲义");
			Array.set(arr, 6, "轻量级Java EE企业应用实战");
			// 依次取出arr数组中index为5、6的元素的值
			Object book1 = Array.get(arr , 5);
			Object book2 = Array.get(arr , 6);
			// 输出arr数组中index为5、6的元素
			System.out.println(book1);
			System.out.println(book2);
		}
		catch (Throwable e)
		{
			System.err.println(e);
		}
	}
}
```
示例2：
```java
public class ArrayTest2
{
	public static void main(String args[])
	{
		/*
		  创建一个三维数组。
		  根据前面介绍数组时讲的：三维数组也是一维数组，
		  是数组元素是二维数组的一维数组，
		  因此可以认为arr是长度为3的一维数组
		*/
		Object arr = Array.newInstance(String.class, 3, 4, 10);
		// 获取arr数组中index为2的元素，该元素应该是二维数组
		Object arrObj = Array.get(arr, 2);
		// 使用Array为二维数组的数组元素赋值。二维数组的数组元素是一维数组，
		// 所以传入Array的set()方法的第三个参数是一维数组。
		Array.set(arrObj , 2 , new String[]
		{
			"疯狂Java讲义",
			"轻量级Java EE企业应用实战"
		});
		// 获取arrObj数组中index为3的元素，该元素应该是一维数组。
		Object anArr  = Array.get(arrObj, 3);
		Array.set(anArr , 8  , "疯狂Android讲义");
		// 将arr强制类型转换为三维数组
		String[][][] cast = (String[][][])arr;
		// 获取cast三维数组中指定元素的值
		System.out.println(cast[2][3][8]);
		System.out.println(cast[2][2][0]);
		System.out.println(cast[2][2][1]);
	}
}
```
###**使用Proxy和InvocationHandler创建动态代理**
java.lang.reflect包下提供了一个Proxy类和InvocationHandler接口，通过使用这个类和接口可以生成JDK动态代理类或动态代理对象。

Proxy是所有动态代理类的父类。如果在程序中为一个或多个接口动态地生成实现类，就可以使用Proxy来创建动态代理类；如果需要为一个或多个接口动态地创建实例，也可以使用Proxy来创建动态代理实例。
Proxy提供了以下两个静态方法来创建动态代理类和动态代理实例：

 - **static Class&lt;?> getProxyClass(ClassLoader loader, Class&lt;?>... interfaces)**：创建一个动态代理类所对应的Class对象，该代理类将实现interfaces所指定的多个接口。第一个ClassLoader参数指定生成动态代理类的类加载器；
 - **static Object newProxyInstance(ClassLoader loader, Class&lt;?>[] interfaces, InvocationHandler h)**：直接创建一个动态代理对象，该代理对象的实现类实现了interfaces指定的系列接口，执行代理对象的每个方法时都会被替换执行InvocationHandler对象的invoke方法。

即使使用第一个方法生成动态代理类之后，如果程序需要通过代理类来创建对象，依然需要传入一个InvocationHandler对象。总之，系统生成的每个代理对象都有一个与之关联的InvocationHandler对象。当执行动态代理对象里的方法时，实际上会替换成调用InvocationHandler对象的invoke方法，该方法的三个参数如下

 - proxy：代表动态代理对象；
 - method：代表正在执行的方法；
 - args：代表调用目标方法时传入的实参。

示例：
```java
interface Person
{
	void walk();
	void sayHello(String name);
}
class MyInvokationHandler implements InvocationHandler
{
	/*
	执行动态代理对象的所有方法时，都会被替换成执行如下的invoke方法
	其中：
	proxy：代表动态代理对象
	method：代表正在执行的方法
	args：代表调用目标方法时传入的实参。
	*/
	public Object invoke(Object proxy, Method method, Object[] args)
	{
		System.out.println("----正在执行的方法:" + method);
		if (args != null)
		{
			System.out.println("下面是执行该方法时传入的实参为：");
			for (Object val : args)
			{
				System.out.println(val);
			}
		}
		else
		{
			System.out.println("调用该方法没有实参！");
		}
		return null;
	}
}
public class ProxyTest
{
	public static void main(String[] args)
		throws Exception
	{
		// 创建一个InvocationHandler对象
		InvocationHandler handler = new MyInvokationHandler();
		// 使用指定的InvocationHandler来生成一个动态代理对象
		Person p = (Person)Proxy.newProxyInstance(Person.class.getClassLoader()
			, new Class[]{Person.class}, handler);
		// 调用动态代理对象的walk()和sayHello()方法
		p.walk();
		p.sayHello("孙悟空");
	}
}
```
实际上，在普通编程中无须使用动态代理，但是在编写框架或底层基础代码时，动态代理的作用就很大。如果在软件开发中存在相同代码重复出现的情况，有经验的开发者会把这段重复的代码定义为一个方法，让其他需要该重复代码的执行体来调用该方法即可。通过动态代理就可以实现即可执行重复的代码，又无须在程序中以硬编码的方式直接调用重复代码的方法。采用动态代理可以非常灵活地实现解耦，通常都是为指定的目标对象生成动态代理。这种动态代理在AOP（Aspect Orient Programming，面向切面编程）中称为AOP代理，AOP代理可代替目标对象，AOP代理包含了目标对象的全部方法，但AOP代理中的方法与目标对象中的方法存在差异：AOP代理里的方法可以在执行目标方法之前、之后插入一些通用处理。

示例：
```java
public interface Dog
{
	// info方法声明
	void info();
	// run方法声明
	void run();
}
```
```java
public class GunDog implements Dog
{
	// 实现info()方法，仅仅打印一个字符串
	public void info()
	{
		System.out.println("我是一只猎狗");
	}
	// 实现run()方法，仅仅打印一个字符串
	public void run()
	{
		System.out.println("我奔跑迅速");
	}
}
```
```java
public class DogUtil
{
	// 第一个拦截器方法
	public void method1()
	{
		System.out.println("=====模拟第一个通用方法=====");
	}
	// 第二个拦截器方法
	public void method2()
	{
		System.out.println("=====模拟通用方法二=====");
	}
}
```
```java
public class MyInvokationHandler implements InvocationHandler
{
	// 需要被代理的对象
	private Object target;
	public void setTarget(Object target)
	{
		this.target = target;
	}
	// 执行动态代理对象的所有方法时，都会被替换成执行如下的invoke方法
	public Object invoke(Object proxy, Method method, Object[] args)
		throws Exception
	{
		DogUtil du = new DogUtil();
		// 执行DogUtil对象中的method1。
		du.method1();
		// 以target作为主调来执行method方法
		Object result = method.invoke(target , args);
		// 执行DogUtil对象中的method2。
		du.method2();
		return result;
	}
}
```
```java
public class MyProxyFactory
{
	// 为指定target生成动态代理对象
	public static Object getProxy(Object target)
		throws Exception
		{
		// 创建一个MyInvokationHandler对象
		MyInvokationHandler handler =
		new MyInvokationHandler();
		// 为MyInvokationHandler设置target对象
		handler.setTarget(target);
		// 创建、并返回一个动态代理
		return Proxy.newProxyInstance(target.getClass().getClassLoader()
			, target.getClass().getInterfaces() , handler);
	}
}
```
```java
public class Test
{
	public static void main(String[] args)
		throws Exception
	{
		// 创建一个原始的GunDog对象，作为target
		Dog target = new GunDog();
		// 以指定的target来创建动态代理
		Dog dog = (Dog)MyProxyFactory.getProxy(target);
		dog.info();
		dog.run();
	}
}
```

###**反射和泛型**
从JDK5开始，Java的Class类增加了泛型支持，允许使用泛型来限制Class类，例如，String.class的类型实际上是Class&lt;String>。如果Class对应的类暂时未知，则使用Class&lt;?>。通过在反射中使用泛型，可以避免反射生成的对象需要强制类型转换。

示例：
```java
public class MyObjectFactory
{
	public static <T> T getInstance(Class<T> cls)
	{
		try
		{
			return cls.newInstance();
		}
		catch(Exception e)
		{
			e.printStackTrace();
			return null;
		}
	}
	public static void main(String[] args)
	{
		// 获取实例后无须类型转换
		Date d = MyObjectFactory.getInstance(Date.class);
		JFrame f = MyObjectFactory.getInstance(JFrame.class);
	}
}
```
Array的newInstance方法签名如下：
> public static Object newInstance(Class&lt;?> componentType, int... dimensions）

这个方法签名虽然使用了Class&lt;?>泛型，但并没有真正利用这个泛型，可以对该方法进行封装：
```java
public class MyArray
{
	// 对Array的newInstance方法进行包装
	//压制未经检查的异常
	@SuppressWarnings("unchecked")
	public static <T> T[] newInstance(Class<T> componentType, int length)
	{
		return (T[])Array.newInstance(componentType , length);  //①
	}
	public static void main(String[] args)
	{
		// 使用CrazyitArray的newInstance()创建一维数组
		String[] arr = MyArray.newInstance(String.class , 10);
		// 使用MyArray的newInstance()创建二维数组
		// 在这种情况下，只要设置数组元素的类型是int[]即可。
		int[][] intArr = MyArray.newInstance(int[].class , 5);
		arr[5] = "我爱中国";
		// intArr是二维数组，初始化该数组的第二个数组元素
		// 二维数组的元素必须是一维数组
		intArr[1] = new int[]{23, 12};
		System.out.println(arr[5]);
		System.out.println(intArr[1][1]);
	}
}
```
获得了成员变量的Field对象后，就可以容易地获得该成员变量的数据类型：
```java
Class<?> a = f.getType();
```
但是上面的方法只能获得普通类型的成员变量，不能获得变量的泛型信息。为了获得成员变量的泛型信息，应该先使用如下方法来获得成员变量的泛型类型：
```java
Type gType = f.getGenericType();
```
然后将Type对象强制转换ParameterizedType对象，ParameterizedType代表被参数化的类型，也就是增加了泛型限制的类型。ParameterizedType类提供了如下两个方法：

 - getRawType()：返回没有泛型信息的原始类型；
 - getActualArguments()：返回泛型参数的类型。

获取泛型类型的示例：
```java
public class GenericTest
{
	private Map<String , Integer> score;
	public static void main(String[] args)
		throws Exception
	{
		Class<GenericTest> clazz = GenericTest.class;
		Field f = clazz.getDeclaredField("score");
		// 直接使用getType()取出的类型只对普通类型的成员变量有效
		Class<?> a = f.getType();
		// 下面将看到仅输出java.util.Map
		System.out.println("score的类型是:" + a);
		// 获得成员变量f的泛型类型
		Type gType = f.getGenericType();
		// 如果gType类型是ParameterizedType对象
		if(gType instanceof ParameterizedType)
		{
			// 强制类型转换
			ParameterizedType pType = (ParameterizedType)gType;
			// 获取原始类型
			Type rType = pType.getRawType();
			System.out.println("原始类型是：" + rType);
			// 取得泛型类型的泛型参数
			Type[] tArgs = pType.getActualTypeArguments();
			System.out.println("泛型信息是:");
			for (int i = 0; i < tArgs.length; i++)
			{
				System.out.println("第" + i + "个泛型类型是：" + tArgs[i]);
			}
		}
		else
		{
			System.out.println("获取泛型类型出错！");
		}
	}
}
```