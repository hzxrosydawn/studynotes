###**NIO概述**
BIO，也称为阻塞IO，是在JDK1.4之前使用的IO模型。从JDK1.4开始，Java增强了输入/输出的功能，称为新IO（New IO，简称NIO），实现这些功能的类都放在java.nio包及其子包下。NIO采用内存映射文件的方式处理输入/输出，NIO将文件或文件的一段区域映射到内存中，这样就可以通过访问内存一样访问文件了。主要涉及Channel、Buffer、Charset和Selector等类及其子类。

###**Buffer类及其子类**
![ ](http://img.blog.csdn.net/20161210120225302?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvcm9zeV9kYXdu/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)
Buffer类及其子类位于java.nio包下，Buffer（缓冲区）类是一个抽象类，其最常用的类是ByteBuffer，其余子类采用相似的方法管理不同类型的数据。Buffer是特定基本类型元素的线性有限序列。除内容外，缓冲区的基本属性还包括容量、限制和位置：

- capacity（容量）： 是它所包含的元素的数量。Buffer的capacity不能为负并且不能更改。 
- limit（限制）：是第一个不应该读取或写入的元素的索引，即位于limit后的数据不能被读或写。Buffer的限制不能为负，并且不能大于其容量。 
- position（位置） ：是下一个要读取或写入的元素的索引。Buffer的位置不能为负，并且不能大于其限制。 
- mark（标记）：类似于BIO中的mark，Buffer允许将position的位置定位到mark处。标记的定义是可选的。

四者的关系：0 <= mark <= position <= limit <= capacity 

Buffer的所有子类都提供了get()和set()方法，用于向Buffer中获取和放置数据。每个子类都定义了两种获取和放置操作： 

- 相对操作：读取或写入一个或多个元素，它从当前位置开始，然后将位置增加所传输的元素的个数。如果请求的传输超出限制，则相对获取操作将抛出 BufferUnderflowException，相对放置操作将抛出 BufferOverflowException；这两种情况下，都没有数据被传输。 
- 绝对操作：直接根据索引向Buffer中写入或读取数据，该操作不影响position（位置）。如果索引参数超出限制，绝对获取 操作和放置操作将抛出IndexOutOfBoundsException。 

新创建的Buffer对象总有一个0的position和一个未定义的mark。初始limit可以为0，也可以为其他值，这取决于Buffer类型及其构建方式。一般情况下，Buffer的初始内容是未定义的。

除了访问position、limit、capacity的方法以及做标记和重置的方法外，此类还定义了以下可对Buffer进行的操作： 

- clear()：它将limit设置为capacity大小，将position设置为0。使Buffer为下一次读取或相对放置操作（put()方法）做好准备。 
- flip()：它将limit设置为当前position，然后将position设置为0。使Buffer为下一次写入或相对获取操作（get()方法）做好准备。 
- rewind()：它使limit保持不变，将位置设置为 0。使缓冲区为重新读取已包含的数据做好准备。 

<img src="http://img.blog.csdn.net/20161208212003502?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvcm9zeV9kYXdu/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast" width= "600", height= "150" align = center />

Buffer主要的作用就是装入数据，然后输出数据。通过allocate()方法创建Buffer子类对象，初始时position为0，limit为capacity，可通过put()方法向Buffer中放入一些数据（或者从Channel中获取一些数据），随着数据放入，position位置会相应地后移。装载好数据后，调用flip()方法，将limit设置为position所在位置，然后将position设置为0，为输出数据做好准备。当Buffer输出数据结束后，可以调用clear()方法，将position置为0，将limit置为capacity，为下一次读取做好准备。常用方法如下：

- int capacity() ：返回此缓冲区的容量。
- int limit() ：返回此缓冲区的限制。 
- int position() ：返回此缓冲区的位置。 
- Buffer mark() ：在此缓冲区的位置设置标记。 
- Buffer limit(int newLimit) ：设置此缓冲区的限制。 
- Buffer position(int newPosition) ：设置此缓冲区的位置。  
- int remaining() ：返回当前位置与限制之间的元素数。
- Buffer reset() ：将此缓冲区的位置重置为以前mark的位置。 
- boolean hasRemaining() ：告知在当前位置和限制之间是否有元素。  
- abstract  Object array() ：返回此缓冲区的底层实现数组（可选操作）。 
- abstract  int arrayOffset() ：返回此缓冲区的底层实现数组中第一个缓冲区元素的偏移量（可选操作）。  
- abstract  boolean hasArray() ：告知此缓冲区是否具有可访问的底层实现数组。 
- abstract  boolean isDirect() ： 告知此缓冲区是否为直接缓冲区。 
- abstract  boolean isReadOnly()：告知此缓冲区是否为只读缓冲区。
 
注意：
 
- 通过allocate()方法创建的Buffer对象是普通Buffer对象，ByteBuffer对象还提供了一个allocateDirect()方法来创建直接Buffer。直接Buffer的创建成本高于普通Buffer，所以直接Buffer只适用于创建长期生存的Buffer。但是直接Buffer效率高于普通Buffer。只有ByteBuffer提供了allocateDirect()方法。
- 每个缓冲区都是可读取的，但并非每个缓冲区都是可写入的。只读缓冲区不允许更改其内容，但其mark、position和limit值是可变的。可以调用其 isReadOnly 方法确定缓冲区是否为只读。 
- 多个当前线程使用缓冲区是不安全的。如果一个缓冲区由不止一个线程使用，则应该通过适当的同步来控制对该缓冲区的访问。 
- Buffer允许将方法调用组成一个链。如：
```java
 b.flip();
 b.position(23);
 b.limit(42);
```
可以由以下更紧凑的一个语句代替 
```java
 b.flip().position(23).limit(42);
```
示例：
```java
public class BufferTest
{
	public static void main(String[] args)
	{
		// 创建Buffer
		CharBuffer buff = CharBuffer.allocate(8); 
		System.out.println("capacity: "	+ buff.capacity());
		System.out.println("limit: " + buff.limit());
		System.out.println("position: " + buff.position());
		// 放入元素
		buff.put('a');
		buff.put('b');
		buff.put('c');    
		System.out.println("加入三个元素后，position = "
			+ buff.position());
		// 调用flip()方法
		buff.flip();	
		System.out.println("执行flip()后，limit = " + buff.limit());
		System.out.println("position = " + buff.position());
		// 取出第一个元素
		System.out.println("第一个元素(position=0)：" + buff.get());  
		System.out.println("取出一个元素后，position = "
			+ buff.position());
		// 调用clear方法
		buff.clear();    
		System.out.println("执行clear()后，limit = " + buff.limit());
		System.out.println("执行clear()后，position = "
			+ buff.position());
		System.out.println("执行clear()后，缓冲区内容并没有被清除："
			+ "第三个元素为：" +  buff.get(2));   
		System.out.println("执行绝对读取后，position = "
			+ buff.position());
	}
}
```
###**Channel接口及其实现类类**

Channel（通道）接口继承自Closeable接口。Channel（通道）表示到实体（如硬件设备、文件、网络资源或可执行多个 I/O 操作的程序组件）开放的连接。用于将指定文件的部分或全部映射成Buffer。不能直接访问Channel中的数据，只能通过Buffer间接对Channel中的数据进行读写。

创建Channel时它处于打开状态，一旦将其关闭，则保持关闭状态。一旦关闭了某个Channel，试图对其调用 I/O 操作就会导致 ClosedChannelException 被抛出。通过调用Channel的isOpen()方法可测试通道是否处于打开状态。 

一般情况下通道对于多线程的访问是安全的。 
所有的Channel都不应该通过构造器创建，而是应该通过传统节点的getChannel()方法来创建对应的Channel实现类。不同的节点流获得不同的Channel。如FileInputStream、FileOutputStream的getChannel()方法返回的是FileChannel，而PipedInputStream、PipedOutputStream的getChannel()方法返回的是Pipe.SinkChannel、Pipe.SourceChannel。

这里以FileChannel为例，FileChannel抽象类中常用方法有map方法和read、write方法。

- abstract  MappedByteBuffer map(FileChannel.MapMode mode, long position, long size) ：将此通道的文件区域直接映射成ByteBuffer。第一个参数控制映射的模式为只读或读写模式。
- long read(ByteBuffer[] dsts) ：将字节序列从此通道读入给定的缓冲区。 
- abstract  int read(ByteBuffer dst) ： 将字节序列从此通道读入给定的缓冲区。 
- abstract  long read(ByteBuffer[] dsts, int offset, int length) ：将字节序列从此通道读入给定缓冲区的子序列中。 
- abstract  int read(ByteBuffer dst, long position) ：从给定的文件位置开始读取字节序列,并写入给定的缓冲区。 
- long write(ByteBuffer[] srcs) ：将字节序列从给定的缓冲区写入此通道。
- abstract  int write(ByteBuffer src) ：将字节序列从给定的缓冲区写入此通道。  
- abstract  long write(ByteBuffer[] srcs, int offset, int length) ：将字节序列从给定缓冲区的子序列写入此通道。 
- abstract  int write(ByteBuffer src, long position) ：从给定的文件位置开始，将字节序列从给定缓冲区写入此通道。 
- abstract  long position() ：返回此通道的文件位置。 
- abstract  FileChannel position(long newPosition) ：设置此通道的文件位置。 
- abstract  long size() ：返回此通道的文件的当前大小。 


实例：
```java
public class FileChannelTest
{
	public static void main(String[] args)
	{
		File f = new File("FileChannelTest.java");
		try(
			// 创建FileInputStream，以该文件输入流创建FileChannel
			FileChannel inChannel = new FileInputStream(f).getChannel();
			// 以文件输出流创建FileBuffer，用以控制输出
			FileChannel outChannel = new FileOutputStream("a.txt")
				.getChannel())
		{
			// 将FileChannel里的全部数据映射成ByteBuffer
			MappedByteBuffer buffer = inChannel.map(FileChannel
				.MapMode.READ_ONLY , 0 , f.length());   // ①
			// 使用GBK的字符集来创建解码器
			Charset charset = Charset.forName("GBK");
			// 直接将buffer里的数据全部输出
			outChannel.write(buffer);     // ②
			// 再次调用buffer的clear()方法，复原limit、position的位置
			buffer.clear();
			// 创建解码器(CharsetDecoder)对象
			CharsetDecoder decoder = charset.newDecoder();
			// 使用解码器将ByteBuffer转换成CharBuffer
			CharBuffer charBuffer =  decoder.decode(buffer);
			// CharBuffer的toString方法可以获取对应的字符串
			System.out.println(charBuffer);
		}
		catch (IOException ex)
		{
			ex.printStackTrace();
		}
	}
}
``` 
RandomAccessFile类也有一个getChannel()方法可以返回FileChannel，其读写模式取决于RandomAccessFile的打开方式。实例：
```java
public class RandomFileChannelTest
{
	public static void main(String[] args)
		throws IOException
	{
		File f = new File("a.txt");
		try(
			// 创建一个RandomAccessFile对象
			RandomAccessFile raf = new RandomAccessFile(f, "rw");
			// 获取RandomAccessFile对应的Channel
			FileChannel randomChannel = raf.getChannel())
		{
			// 将Channel中所有数据映射成ByteBuffer
			ByteBuffer buffer = randomChannel.map(FileChannel
				.MapMode.READ_ONLY, 0 , f.length());
			// 把Channel的记录指针移动到最后
			randomChannel.position(f.length());
			// 将buffer中所有数据输出
			randomChannel.write(buffer);
		}
	}
}
``` 
如果担心Channel中一次映射的内容太多而导致性能下降，也可以选择多次小批量重复读写数据。示例：
```java
public class ReadFile
{
	public static void main(String[] args)
		throws IOException
	{
		try(
			// 创建文件输入流
			FileInputStream fis = new FileInputStream("ReadFile.java");
			// 创建一个FileChannel
			FileChannel fcin = fis.getChannel())
		{
			// 定义一个ByteBuffer对象，用于重复取水
			ByteBuffer bbuff = ByteBuffer.allocate(256);
			// 将FileChannel中数据放入ByteBuffer中
			while( fcin.read(bbuff) != -1 )
			{
				// 锁定Buffer的空白区
				bbuff.flip();
				// 创建Charset对象
				Charset charset = Charset.forName("GBK");
				// 创建解码器(CharsetDecoder)对象
				CharsetDecoder decoder = charset.newDecoder();
				// 将ByteBuffer的内容转码
				CharBuffer cbuff = decoder.decode(bbuff);
				System.out.print(cbuff);
				// 将Buffer初始化，为下一次读取数据做准备
				bbuff.clear();
			}
		}
	}
}
```
###**字符集和Charset类**  
**字符集：**
先说字符，字符(Character)是文字与符号的总称，包括文字、图形符号、数学符号等。 一组抽象字符的集合就是字符集(Charset)。 字符集常常和一种具体的语言文字对应起来，该文字中的所有字符或者大部分常用字符就构成了该文字的字符集，比如、简体中文字符集、英文字符集。 
**字符编码：**
任何文件存储在计算机里都是二进制的形式，包括文本、图片、视频、程序等。文本之所以能显示出文字来，是因为系统将底层的二进制序列转换成字符的缘故。文本和二进制序列的转换就涉及到编码（Encode）和解码（Decode）的问题。编码就是将文本按照指定的规则解析成二进制序列，解码就是按照一定的规则将二进制序列转换成文本。编码和解码所遵循的规则如果不同就会导致文本显示为乱码，而这个规则就是字符编码。不同的字符集都有对应的字符编码。常见字符集名称及其字符编码：
字符集|描述|字符编码及占用字节
---|---
ASCII字符集		|现代英语和其他西欧语言的字符集						|采用ASCII编码，单字节
GB2312字符集		|简体中文字符集									|采用GB2312编码，双字节
BIG5字符集		|繁体中文字符集									|采用BIG5编码双，双字节	
GB18030字符集	|所有汉字、日文、朝鲜语和中国少数民族文字组成的大字符集	|采用GB18030编码，单字节、双字节和四字
Unicode字符集	|支持世界上所有语言字符								|采用多种字符编码

Unicode 的实现方式不同于编码方式。一个字符的Unicode编码是确定的，但是在实际传输过程中，由于不同系统平台的设计不一定一致，以及出于节省空间的目的，对Unicode编码的实现方式有所不同。 
Unicode的实现方式称为Unicode转换格式(Unicode Translation Format，简称为 UTF)。 

- UTF-8: 8bit变长编码，对于大多数常用字符集(ASCII中0~127字符)它只使用单字节，而对其它常用字符(特别是朝鲜和汉语会意文字)，它使用3字节。 
- UTF-16: 16bit编码，是变长码，大致相当于20位编码，值在0到0x10FFFF之间，基本上就是unicode编码的实现，与CPU字序有关。 

字符集和编码方式如此之多，我们只需选择一种兼容性最好的编码方式和字符集，即UTF-8。毕竟GBK/GB2312是国内的标准，当我们大量使用国外的开源软件时，UTF-8才是编码界最通用的语言。 

Java默认使用Unicode字符集，但是有的操作系统并不是用Unicode字符集，JDK1.4提供了Charset来处理字符序列和字节序列的转换关系。该类定义了用于创建解码器和编码器以及获取与 charset 关联的各种名称的方法。此类的实例是不可变的。常用方法如下：

- static SortedMap&lt;String,Charset> availableCharsets() ：返回当前JDK所支持的所有字符集。 
- static Charset forName(String charsetName) ：返回指定名称的字符编码格式的 charset 对象。 
- abstract  CharsetDecoder newDecoder() ：为此 charset 构造新的解码器。 
- abstract  CharsetEncoder newEncoder() ：为此 charset 构造新的编码器。 
- ByteBuffer encode(CharBuffer cb) ：将此 charset 中的 Unicode 字符编码成字节的便捷方法。 
- ByteBuffer encode(String str) ：将此 charset 中的字符串编码成字节的便捷方法。 
- CharBuffer decode(ByteBuffer bb) ：将此 charset 中的字节解码成 Unicode 字符的便捷方法。 
- String name() ： 返回此 charset 的规范名称。 

其中，CharsetDecoder和CharsetEncoder分别代表编码器和解码器，利用CharsetDecoder的decode()方法可以将ByteBuffer转换成CharBuffer，调用CharsetEncoder的encoder()方法可以将CharBuffer或者String转换成ByteBuffer。如果仅需要简单的编码和解码操作，使用Charset的encode()方法和decode()方法即可。
示例：
```java
public class CharsetTest
{
	public static void main(String[] args)
	{
		// 获取Java支持的全部字符集
		SortedMap<String,Charset>  map = Charset.availableCharsets();
		for (String alias : map.keySet())
		{
			// 输出字符集的别名和对应的Charset对象
			System.out.println(alias + "----->"
				+ map.get(alias));
		}
	}
} 
```
```java
public class CharsetTransform
{
	public static void main(String[] args)
		throws Exception
	{
		// 创建简体中文对应的Charset
		Charset cn = Charset.forName("GBK");
		// 获取cn对象对应的编码器和解码器
		CharsetEncoder cnEncoder = cn.newEncoder();
		CharsetDecoder cnDecoder = cn.newDecoder();
		// 创建一个CharBuffer对象
		CharBuffer cbuff = CharBuffer.allocate(8);
		cbuff.put('孙');
		cbuff.put('悟');
		cbuff.put('空');
		cbuff.flip();
		// 将CharBuffer中的字符序列转换成字节序列
		ByteBuffer bbuff = cnEncoder.encode(cbuff);
		// 循环访问ByteBuffer中的每个字节
		for (int i = 0; i < bbuff.capacity() ; i++)
		{
			System.out.print(bbuff.get(i) + " ");
		}
		// 将ByteBuffer的数据解码成字符序列
		System.out.println("\n" + cnDecoder.decode(bbuff));
	}
}
```

###**文件锁**
文件锁可以控制文件的全部或部分字节的访问，使用文件锁机制可以有效阻止多个进程并发修改同一个文件，所以多数操作系统都提供了文件锁功能。从JDK1.4开始提供FileLock来支持文件锁功能。FileChannel抽象类的获取文件锁的方法如下：

- FileLock lock() ：获取对此通道的文件的独占锁定。 无法获得锁时一直阻塞。
-  FileLock tryLock() ：试图获取对此通道的文件锁。如果获得了文件锁则返回文件锁，否则返回null而不会一直阻塞。 
- abstract  FileLock lock(long position, long size, boolean shared) ： 同上面的lock方法，只是获取部分文件的锁。若shared参数为ture，则请求获得共享锁，允许多个进程读取文件，若为false，则请求获得一个排它锁，仅当前进程可以读写进行操作。
- abstract  FileLock tryLock(long position, long size, boolean shared) ：同上面的trylock方法，只是获取部分文件的锁。

FileLock抽象类常用方法如下：

- FileChannel channel() ：返回文件通道，此锁定保持在该通道的文件上。 
- boolean isShared() ：判断此锁定是否为共享的。 
- abstract  boolean isValid() ：判断此锁定是否有效。 
- long position() ：  返回文件内锁定区域中第一个字节的位置。 
- abstract  void release() ：使用完文件后应该释放此锁定。 
- long size() ：返回锁定区域的大小，以字节为单位。 
- String toString() ：  返回描述此锁定的范围、类型和有效性的字符串。 
- boolean overlaps(long position, long size) ：  判断此锁定是否与给定的锁定区域重叠。 

示例：
```java
public class FileLockTest
{
	public static void main(String[] args)
		throws Exception
	{

		try(
			// 使用FileOutputStream获取FileChannel
			FileChannel channel = new FileOutputStream("a.txt")
				.getChannel())
		{
			// 使用非阻塞式方式对指定文件加锁
			FileLock lock = channel.tryLock();
			// 程序暂停10s
			Thread.sleep(10000);
			// 释放锁
			lock.release();
		}
	}
}
```
 


 


 
 




 
