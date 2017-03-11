###**网络基础**
####**网络模型**
网络模型一般是指OSI七层参考模型和TCP/IP四层参考模型。这两个模型在网络中应用最为广泛。
OSI模型，即开放式通信系统互联参考模型(Open System Interconnection)，是由ISO(国际标准化组织）制定的，OSI将计算机网络体系结构(architecture）划分为以下七层。
TCP/IP是一组用于实现网络互连的通信协议。Internet网络体系结构以TCP/IP为核心。基于TCP/IP的参考模型将协议分成四个层次。
两种模型有一定的对应关系：
![这里写图片描述](http://img.blog.csdn.net/20161225130602309?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvcm9zeV9kYXdu/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast) 
####**IP地址和端口**
**IP地址**用于唯一地表示网络中的一个通讯实体。IP地址是IP协议提供的一种统一的地址格式，IP地址分为五类：

- A类用于大型网络（能容纳网络126个，主机1677214台）
- B类用于中型网络（能容纳网络16384个，主机65534台）
- C类用于小型网络（能容纳网络2097152个，主机254台）
- D类用于组播（多目的地址的发送）
- E类用于实验

另外，全零（0.0.0.0.）地址指任意网络。全1的IP地址（255.255.255.255）是当前子网的广播地址。
IP地址采用层次结构，按照逻辑结构划分为两个部分：网络号和主机号。网络号用于识别一个逻辑网络，而主机号用于识别网络中的一台主机的一个连接。因此，IP地址的编址方式携带了明显的位置消息。
一个完整的IP地址由4个字节32位数字组成，为了方便用户理解和记忆，采用点分十进制标记法，字节之间使用符号“.”隔开。
采用32位形式的IP地址如下：00001010 00000000 00000000 00000001
采用点分十进制标记法如下：10.0.0.1

A类地址

1. A类IP地址。由1个字节的网络地址和3个字节的主机地址，网络地址的最高位必须是“0”。
如：0XXXXXXX.XXXXXXXX.XXXXXXXX.XXXXXXXX（X代表0或1）
2. A类IP地址范围：1.0.0.1---126.255.255.254
3. A类IP地址中的私有地址和保留地址：
		① 10.X.X.X是私有地址（所谓的私有地址就是在互联网上不使用，而被用在局域网络中的地址）。
		   范围（10.0.0.1---10.255.255.254）
		② 127.X.X.X是保留地址，用做循环测试用的。

B类地址

1. B类IP地址。由2个字节的网络地址和2个字节的主机地址，网络地址的最高位必须是“10”。
如：10XXXXXX.XXXXXXXX.XXXXXXXX.XXXXXXXX（X代表0或1）
2. B类IP地址范围：128.0.0.1---191.255.255.254。
3. B类IP地址的私有地址和保留地址
		① 172.16.0.0---172.31.255.254是私有地址
		② 169.254.X.X是保留地址。如果你的IP地址是自动获取IP地址，而你在网络上又没有找到可用的DHCP服务器。就会得到其中一个IP。191.255.255.255是广播地址，不能分配。

C类地址

1. C类IP地址。由3个字节的网络地址和1个字节的主机地址，网络地址的最高位必须是“110”。
如：110XXXXX.XXXXXXXX.XXXXXXXX.XXXXXXXX（X代表0或1）
2. C类IP地址范围：192.0.0.1---223.255.255.254。
3. C类地址中的私有地址：
	  192.168.X.X是私有地址。（192.168.0.1---192.168.255.255)这些私有地址是用于局域网的。

D类地址

1.  D类地址不分网络地址和主机地址，它的第1个字节的前四位固定为1110。
如：1110XXXX.XXXXXXXX.XXXXXXXX.XXXXXXXX（X代表0或1）
2. D类地址范围：224.0.0.1---239.255.255.254

E类地址

1. E类地址不分网络地址和主机地址，它的第1个字节的前四位固定为 1111。
如：1111XXXX.XXXXXXXX.XXXXXXXX.XXXXXXXX（X代表0或1）
2. E类地址范围：240.0.0.1---255.255.255.254是一个32位的二进制地址，为了便于记忆，将它们分为4组，每组8位，由小数点分开，用四个字节来表示，而且，用点分开的每个字节的数值范围是0~255，如202.116.0.1，这种书写方法叫做点数表示法。

一个通信实体同时有多个通信程序提供服务只有IP还不行，还需要**端口**。端口是一个16位整数，是一种抽象的软件结构，是应用程序与网络交流的门户。不同的应用程序处理不同的端口上的数据，同一台机器上不能有两个程序使用同一个端口。端口号可以是0~65535，通常分为三类：

 - 公认端口（Well Known Ports）：0~1023，它们紧密绑定一些特定服务；
 - 注册端口（Registered Ports）：1024~49151，它们松散地绑定一些服务，应用程序通常使用这些端口；
 - 动态和或私有端口（Dynamic and/or Private Ports ）：49152~65535，这些端口是应用程序使用的动态端口，应用程序一般不会主动使用这些端口。
 
###**Java的基本网络支持**
Java在java.net包下提供了一些网络支持的类和接口。
####**InetAddress类**
InetAddress类代表一个IP地址， 没有构造器，依靠静态方法获取InetAddress实例：

- static **InetAddress[]** **getAllByName**(String host) ：在给定主机名的情况下，根据系统上配置的名称服务返回其 IP 地址所组成的数组。因为有些域名是有多个IP地址的。；
- static InetAddress **getByAddress**(byte[] addr) ：在给定原始 IP 地址的情况下，返回 InetAddress 对象；
- static InetAddress getByAddress(String host, byte[] addr) ：根据提供的主机名和 IP 地址创建 InetAddress；
- static InetAddress **getByName**(String host) ：在给定主机名的情况下确定主机的 IP 地址；
- static InetAddress **getLocalHost**() ：返回本地主机IP对应的InetAddress对象。实现尽最大努力试图到达主机，但防火墙和服务器配置可能阻塞请求，使其在某些特定的端口可以访问时处于不可到达状态。如果可以获得权限，则典型实现将使用 ICMP ECHO REQUEST；否则它将试图在目标主机的端口 7 (Echo) 上建立 TCP 连接。 

其他方法摘要：
 
- byte[] **getAddress**() ： 返回此 InetAddress 对象的原始 IP 地址；
- String getCanonicalHostName() ：获取此 IP 地址的完全限定域名； 
- String **getHostAddress**() ：返回 IP 地址字符串（以文本表现形式）；
- String **getHostName**() ：获取此 IP 地址的主机名；
- boolean **isReachable**(int timeout) ：测试是否可以达到该地址。 

InetAddress类还有两个子类：Inet4Address和Inet6Address，分别代表IPv4地址和IPv6地址。

InetAddress示例：
```java
public class InetAddressTest
{
	public static void main(String[] args)
		throws Exception
	{
		// 根据主机名来获取对应的InetAddress实例
		InetAddress ip = InetAddress.getByName("www.hao123.com");
		// 判断是否可达
		System.out.println("hao123是否可达：" + ip.isReachable(2000));
		// 获取该InetAddress实例的IP字符串
		System.out.println(ip.getHostAddress());
		// 根据原始IP地址来获取对应的InetAddress实例
		InetAddress local = InetAddress.getByAddress(
			new byte[]{127,0,0,1});
		System.out.println("本机是否可达：" + local.isReachable(5000));
		// 获取该InetAddress实例对应的全限定域名
		System.out.println(local.getCanonicalHostName());
	}
}
``` 
**InetSocketAddress**
此类代表了**IP 地址和端口号**。它还可以是一个对**主机名+端口号**，在此情况下，将尝试解析主机名。如果解析失败，则该地址将被视为未解析地址，但是其在某些情形下仍然可以使用，比如通过代理连接。它提供不可变对象，供套接字用于绑定、连接或用作返回值。 通配符是一个特殊的本地 IP 地址。它通常表示“任何”，只能用于 bind 操作。

构造方法摘要:
 
- InetSocketAddress(InetAddress addr, int port) 
          根据 IP 地址和端口号创建套接字地址。 
- InetSocketAddress(int port) 
          创建套接字地址，其中 IP 地址为通配符地址，端口号为指定值。 
- InetSocketAddress(String hostname, int port) 
          根据主机名和端口号创建套接字地址。 

常用方法方法摘要:

- static InetSocketAddress createUnresolved(String host, int port)：根据主机名和端口号创建未解析的套接字地址； 
- boolean equals(Object obj)：将此对象与指定对象比较； 
- InetAddress getAddress()：获取 InetAddress；
- String getHostName()：获取 hostname；
- int getPort()：获取端口号；
- boolean isUnresolved()：检查是否已解析地址。 

####**URLDecoder和URLEncoder**
在Google搜索“中国”，在搜索结果的页面的地址栏末尾显式“%E4%B8%AD%E5%9B%BD”，这种字符串称为application/x-www-form-urlencoded字符串。URL中含有非西欧字符串时会将其转换为application/x-www-form-urlencoded字符串。Java中提供了URLDecoder类和URLEncoder类来完成这种相互转换：

- URLDecoder类提供了static String decode(String s, String enc) 静态方法：使用指定的编码机制对 application/x-www-form-urlencoded 字符串解码； 
- URLEncoder类提供了static String encode(String s, String enc) 静态方法： 使用指定的编码机制将字符串转换为 application/x-www-form-urlencoded 格式。 
 
示例：
```java
public class URLDecoderTest
{
	public static void main(String[] args)
		throws Exception
	{
		// 将application/x-www-form-urlencoded字符串
		// 转换成普通字符串,输出中国
		String keyWord = URLDecoder.decode(
			"%E4%B8%AD%E5%9B%BD", "utf-8");
		System.out.println(keyWord);
		// 将普通字符串转换成
		// application/x-www-form-urlencoded字符串
		String urlStr = URLEncoder.encode(
			"中国" , "GBK");
		System.out.println(urlStr);
	}
} 
```
####**URL 、URLConnection、 URLPermission**
**URL**（Uniform Resource Locator）即统一资源定位器，它是指向互联网“资源”的指针。资源可以是简单的文件或目录，也可以是对更为复杂的对象的引用，例如对数据库或搜索引擎的查询。有关 URL 的类型和格式的更多信息，可从以下位置找到： 
http://www.socs.uts.edu.au/MosaicDocs-old/url-primer.html 。
URL主要有协议名，主机名，端口号，资源等组成。格式为：
protocol://host:port/resourceName
例如：http://www.socs.uts.edu.au/MosaicDocs-old/url-primer.html，它的协议是http，中间是主机路径，后面为文件名，没有端口号（默认80）。
URL类就是这样一个处理同意资源定位器的类。
构造方法摘要：

- URL(String spec) ：根据 String 表示形式创建 URL 对象；
- URL(URL context, String spec) ：通过在指定的上下文中对给定的 spec 进行解析创建 URL；
- URL(URL context, String spec, URLStreamHandler handler)：通过在指定的上下文中用指定的处理程序对给定的 spec 进行解析来创建 URL；
- URL(String protocol, String host, String file) ：根据指定的 protocol 名称、host 名称和 file 名称创建 URL； 
- URL(String protocol, String host, int port, String file)：根据指定 protocol、host、port 号和 file 创建 URL 对象；
- URL(String protocol, String host, int port, String file, URLStreamHandler handler) ：根据指定的 protocol、host、port 号、file 和 handler 创建 URL 对象。

常用方法摘要：

 - String getFile() ：获取此 URL 的文件名；
 - String getHost() ：获取此 URL 的主机名（如果适用）；
 - String getPath() ：获取此 URL 的路径部分； 
 - int getPort() ：获取此 URL 的端口号； 
 - String getProtocol() ：获取此 URL 的协议名称； 
 - String getQuery() ：获取此 URL 的查询部分； 
 - String getRef() ：获取此 URL 的锚点（也称为“引用”）； 
 - String getUserInfo() ：获取此 URL 的 userInfo 部分；
 - protected  void set(String protocol, String host, int port, String file, String ref) ：设置 URL 的字段；
 - protected  void set(String protocol, String host, int port, String authority, String userInfo, String path, - String query, String ref) ：设置 URL 的指定的 8 个字段；
 - **URLConnection** **openConnection**() ：返回一个 URLConnection 对象，它表示到 URL 所引用的远程对象的连接；
 - URLConnection openConnection(Proxy proxy)：与openConnection()类似，所不同是连接通过指定的代理建立；不支持代理方式的协议处理程序将忽略该代理参数并建立正常的连接；
 - **InputStream openStream**() ：打开到此 URL 的连接并返回一个用于从该连接读入的 InputStream。 

**URLConnection**类是一个抽象类，它是所有应用程序和URL通信连接类的超类，此类的实例可用于读取和写入此 URL 引用的资源。通常，创建一个到 URL 的连接需要几个步骤： 

 - 通过在 URL 上调用 openConnection 方法创建URLConnection连接对象；
 - 设置URLCOnnection参数和一般请求属性；
 - 如果只发送GET方式请求，则使用 connect 方法建立到远程对象的连接即可。如果需要发送POST方式的请求，则需要获取URLConnection实例对应的输出流来发送请求参数；
 - 远程对象变为可用。可以访问远程对象的头字段或通过输入流读取远程对象的数据。

该类提供以下字段：

- protected  boolean **allowUserInteraction**：如果为true，则在允许用户交互（例如弹出一个验证对话框）的上下文中对此 URL 进行检查；
- protected  boolean connected ：如果为 false，则此连接对象尚未创建到指定 URL 的通信连接；
- protected  boolean doInput ：此变量由 setDoInput 方法设置；
- protected  boolean doOutput ：此变量由 setDoOutput 方法设置；
- protected  long ifModifiedSince ：有些协议支持跳过对象获取，除非该对象在某个特定时间点之后又进行了修改； 
- protected  URL url ：URL 表示此连接要在互联网上打开的远程对象；
- protected  boolean useCaches ：如果为 true，则只要有条件就允许协议使用缓存。

**在建立到远程对象的连接之前**，可使用以下方法修改或设置以上参数： 

void setConnectTimeout(int timeout) ：设置一个指定的超时值（以毫秒为单位），该值将在打开到此 URLConnection 引用的资源的通信链接时使用； 
- static void setDefaultAllowUserInteraction(boolean defaultallowuserinteraction) ：将未来的所有 URLConnection 对象的 allowUserInteraction 字段的默认值设置为指定的值；
- void setAllowUserInteraction(boolean allowuserinteraction) ：设置此 URLConnection 的 allowUserInteraction 字段的值；
- void setDefaultUseCaches(boolean defaultusecaches) ：将 useCaches 字段的默认值设置为指定的值；
- void setDoInput(boolean doinput) ：将此 URLConnection 的 doInput 字段的值设置为指定的值； 
- void setDoOutput(boolean dooutput) ：将此 URLConnection 的 doOutput 字段的值设置为指定的值；
- void setIfModifiedSince(long ifmodifiedsince) ：将此 URLConnection 的 ifModifiedSince 字段的值设置为指定的值；
- void setUseCaches(boolean usecaches) ：将此 URLConnection 的 useCaches 字段的值设置为指定的值。 

使用以下方法修改一般请求属性： 

-  void setRequestProperty(String key, String value) ：设置一般请求属性。如果已存在具有该关键字的属性，则用新值改写其值。使用以逗号分隔的列表语法，这样可实现将多个属性添加到一个属性中。 
-  void addRequestProperty(String key, Stringvalue)：添加由键值对指定的一般请求属性。此方法不会改写与相同键关联的现有值。 

上面每个 set 方法都有一个用于获取参数值或一般请求属性值的对应get方法。适用的具体参数和一般请求属性取决于协议。

在**建立到远程对象的连接后**，以下方法用于访问头字段和内容： 

- Object getContent() ：获取此 URL 连接的内容；
- Object getContent(Class[] classes) ：获取此 URL 连接的内容；
- String getHeaderField(int n) ：返回第 n 个头字段的值； 
- String getHeaderField(String name) ：返回指定的头字段的值； 
- OutputStream getOutputStream() ：返回写入到此连接的输出流； 
- InputStream getInputStream() ：返回从此打开的连接读取的输入流。 

某些头字段需要经常访问。以下方法提供对这些字段的便捷访问： 

- String getContentEncoding() ：获取content-encoding响应头字段的值；
- int getContentLength() ：获取content-length响应头字段的值；
- String getContentType() ：获取content-type响应头字段的值；
- long getDate()：获取date响应头字段的值；
- long getExpiration()：获取expires（有效期）响应头字段的值；
- long getLastModified()：获取last-modified响应头字段的值。

getContent 方法使用 getContentType 方法以确定远程对象类型；子类重写 getContentType 方法很容易。 

**HttpURLConnection**是URLConnection的子类，代表与URL之间的HTTP连接。该类提供了许多HTTP状态码的字段。
构造方法摘要：

- protected  HttpURLConnection(URL u) ：HttpURLConnection 的构造方法。 

方法摘要：

- abstract  void disconnect() ：指示近期服务器不太可能有其他请求；
- abstract  boolean usingProxy() ：指示连接是否通过代理。 
- static boolean getFollowRedirects() ：返回指示是否应该自动执行 HTTP 重定向 (3xx) 的 boolean 值；
- InputStream getErrorStream() ：如果连接失败但服务器仍然发送了有用数据，则返回错误流； 
- String **getHeaderField**(int n) ：返回 nth 头字段的值； 
- long **getHeaderFieldDate**(String name, long Default) ：返回解析为日期的指定字段的值；
- String **getHeaderFieldKey**(int n) ： 返回 nth 头字段的键；
- boolean getInstanceFollowRedirects() ：返回此 HttpURLConnection 的 instanceFollowRedirects 字段的值； 
- Permission **getPermission**() ：返回一个权限对象，其代表建立此对象表示的连接所需的权限； 
- String **getRequestMethod**() ：获取请求方法；
- int **getResponseCode**() ：从 HTTP 响应消息获取状态码；
- String **getResponseMessage**() ：获取与来自服务器的响应代码一起返回的 HTTP 响应消息（如果有）； 
- void setChunkedStreamingMode(int chunklen) ：此方法用于在预先不知道内容长度时启用没有进行内部缓冲的 HTTP 请求正文的流； 
- void setFixedLengthStreamingMode(int contentLength) ： 此方法用于在预先已知内容长度时启用没有进行内部缓冲的 HTTP 请求正文的流；
- static void setFollowRedirects(boolean set) ： 设置此类是否应该自动执行 HTTP 重定向（响应代码为 3xx 的请求）； 
- void setInstanceFollowRedirects(boolean followRedirects) ：设置此 HttpURLConnection 实例是否应该自动执行 HTTP 重定向（响应代码为 3xx 的请求）；
- void **setRequestMethod**(String method) ：设置 URL 请求的方法， GET POST HEAD OPTIONS PUT DELETE TRACE 以上方法之一是合法的，具体取决于协议的限制； 

Java8新增了一个URLPermission工具类，用于管理HttpURLConnection的权限问题，如果在HttpURLConnection安装了安全管理器，通过该对象打开链接时就需要先取得权限。

多线程下载工具类示例：
```java
public class DownUtil
{
	// 定义下载资源的路径
	private String path;
	// 指定所下载的文件的保存位置
	private String targetFile;
	// 定义需要使用多少线程下载资源
	private int threadNum;
	// 定义下载的线程对象
	private DownThread[] threads;
	// 定义下载的文件的总大小
	private int fileSize;

	public DownUtil(String path, String targetFile, int threadNum)
	{
		this.path = path;
		this.threadNum = threadNum;
		// 初始化threads数组
		threads = new DownThread[threadNum];
		this.targetFile = targetFile;
	}

	public void download() throws Exception
	{
		URL url = new URL(path);
		HttpURLConnection conn = (HttpURLConnection) url.openConnection();
		conn.setConnectTimeout(5 * 1000);
		conn.setRequestMethod("GET");
		conn.setRequestProperty(
			"Accept",
			"image/gif, image/jpeg, image/pjpeg, image/pjpeg, "
			+ "application/x-shockwave-flash, application/xaml+xml, "
			+ "application/vnd.ms-xpsdocument, application/x-ms-xbap, "
			+ "application/x-ms-application, application/vnd.ms-excel, "
			+ "application/vnd.ms-powerpoint, application/msword, */*");
		conn.setRequestProperty("Accept-Language", "zh-CN");
		conn.setRequestProperty("Charset", "UTF-8");
		conn.setRequestProperty("Connection", "Keep-Alive");
		// 得到文件大小
		fileSize = conn.getContentLength();
		conn.disconnect();
		int currentPartSize = fileSize / threadNum + 1;
		RandomAccessFile file = new RandomAccessFile(targetFile, "rw");
		// 设置本地文件的大小
		file.setLength(fileSize);
		file.close();
		for (int i = 0; i < threadNum; i++)
		{
			// 计算每条线程的下载的开始位置
			int startPos = i * currentPartSize;
			// 每个线程使用一个RandomAccessFile进行下载
			RandomAccessFile currentPart = new RandomAccessFile(targetFile,
				"rw");
			// 定位该线程的下载位置
			currentPart.seek(startPos);
			// 创建下载线程
			threads[i] = new DownThread(startPos, currentPartSize,
				currentPart);
			// 启动下载线程
			threads[i].start();
		}
	}

	// 获取下载的完成百分比
	public double getCompleteRate()
	{
		// 统计多条线程已经下载的总大小
		int sumSize = 0;
		for (int i = 0; i < threadNum; i++)
		{
			sumSize += threads[i].length;
		}
		// 返回已经完成的百分比
		return sumSize * 1.0 / fileSize;
	}

	private class DownThread extends Thread
	{
		// 当前线程的下载位置
		private int startPos;
		// 定义当前线程负责下载的文件大小
		private int currentPartSize;
		// 当前线程需要下载的文件块
		private RandomAccessFile currentPart;
		// 定义已经该线程已下载的字节数
		public int length;

		public DownThread(int startPos, int currentPartSize,
			RandomAccessFile currentPart)
		{
			this.startPos = startPos;
			this.currentPartSize = currentPartSize;
			this.currentPart = currentPart;
		}

		@Override
		public void run()
		{
			try
			{
				URL url = new URL(path);
				HttpURLConnection conn = (HttpURLConnection)url
					.openConnection();
				conn.setConnectTimeout(5 * 1000);
				conn.setRequestMethod("GET");
				conn.setRequestProperty(
					"Accept",
					"image/gif, image/jpeg, image/pjpeg, image/pjpeg, "
					+ "application/x-shockwave-flash, application/xaml+xml, "
					+ "application/vnd.ms-xpsdocument, application/x-ms-xbap, "
					+ "application/x-ms-application, application/vnd.ms-excel, "
					+ "application/vnd.ms-powerpoint, application/msword, */*");
				conn.setRequestProperty("Accept-Language", "zh-CN");
				conn.setRequestProperty("Charset", "UTF-8");
				InputStream inStream = conn.getInputStream();
				// 跳过startPos个字节，表明该线程只下载自己负责哪部分文件。
				inStream.skip(this.startPos);
				byte[] buffer = new byte[1024];
				int hasRead = 0;
				// 读取网络数据，并写入本地文件
				while (length < currentPartSize
					&& (hasRead = inStream.read(buffer)) != -1)
				{
					currentPart.write(buffer, 0, hasRead);
					// 累计该线程下载的总大小
					length += hasRead;
				}
				currentPart.close();
				inStream.close();
			}
			catch (Exception e)
			{
				e.printStackTrace();
			}
		}
	}
}
```
上面多线程下载的步骤是：

1. 创建URL对象；
2. 通过URL对象openConnection方法来获取对应的额URLConnection对象，然后获得其所指向资源的大小（通过getContentLength()方法）；
3. 在本地磁盘上创建一个与网络资源大小相等的空文件；
4. 计算每个线程应该下载网络资源的哪个部分；
5. 依次创建、启动多个线程来下载网络资源的多个部分。

执行多线程下载示例：
```java
public class MultiThreadDown
{
	public static void main(String[] args) throws Exception
	{
		// 初始化DownUtil对象
		final DownUtil downUtil = new DownUtil("http://img.blog.csdn.net/20161225130602309?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvcm9zeV9kYXdu/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast"
			, "collection.png", 4);
		// 开始下载
		downUtil.download();
		new Thread(() -> {
				while(downUtil.getCompleteRate() < 1)
				{
					// 每隔0.1秒查询一次任务的完成进度，
					// GUI程序中可根据该进度来绘制进度条
					System.out.println("已完成："
						+ downUtil.getCompleteRate());
					try
					{
						Thread.sleep(1000);
					}
					catch (Exception ex){}
				}
		}).start();
	}
}
```
如果既要使用输入流读取URLConnection响应的内容，又要使用输出流发送请求参数，一定要先使用输出流，再使用输入流。

发送GET请求时只需要请求参数放在URL字符串之后，以？隔开，程序直接调用URLConnection对象的connect()方法即可；如果程序需要发送POST请求，则需要先设置doIn和doOut两个请求头字段的值，再使用URLConnection对应的输出流来发送请求参数。不管是事发送GET请求，还是POST请求，程序获取URLConnection响应的方式一样——如果程序确定远程响应是字符流，则可以使用字符流来读取，如果程序无法确定远程响应是字符流，则使用字节流即可。

GET和POST请求示例：
```java
public class GetPostTest
{
	/**
	 * 向指定URL发送GET方法的请求
	 * @param url 发送请求的URL
	 * @param param 请求参数，格式满足name1=value1&name2=value2的形式。
	 * @return URL所代表远程资源的响应
	 */
	public static String sendGet(String url , String param)
	{
		String result = "";
		String urlName = url + "?" + param;
		try
		{
			URL realUrl = new URL(urlName);
			// 打开和URL之间的连接
			URLConnection conn = realUrl.openConnection();
			// 设置通用的请求属性
			conn.setRequestProperty("accept", "*/*");
			conn.setRequestProperty("connection", "Keep-Alive");
			conn.setRequestProperty("user-agent"
				, "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1)");
			// 建立实际的连接
			conn.connect();
			// 获取所有响应头字段
			Map<String, List<String>> map = conn.getHeaderFields();
			// 遍历所有的响应头字段
			for (String key : map.keySet())
			{
				System.out.println(key + "--->" + map.get(key));
			}
			try(
				// 定义BufferedReader输入流来读取URL的响应
				BufferedReader in = new BufferedReader(
					new InputStreamReader(conn.getInputStream() , "utf-8")))
			{
				String line;
				while ((line = in.readLine())!= null)
				{
					result += "\n" + line;
				}
			}
		}
		catch(Exception e)
		{
			System.out.println("发送GET请求出现异常！" + e);
			e.printStackTrace();
		}
		return result;
	}
	/**
	 * 向指定URL发送POST方法的请求
	 * @param url 发送请求的URL
	 * @param param 请求参数，格式应该满足name1=value1&name2=value2的形式。
	 * @return URL所代表远程资源的响应
	 */
	public static String sendPost(String url , String param)
	{
		String result = "";
		try
		{
			URL realUrl = new URL(url);
			// 打开和URL之间的连接
			URLConnection conn = realUrl.openConnection();
			// 设置通用的请求属性
			conn.setRequestProperty("accept", "*/*");
			conn.setRequestProperty("connection", "Keep-Alive");
			conn.setRequestProperty("user-agent",
			"Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1)");
			// 发送POST请求必须设置如下两行
			conn.setDoOutput(true);
			conn.setDoInput(true);
			try(
				// 获取URLConnection对象对应的输出流
				PrintWriter out = new PrintWriter(conn.getOutputStream()))
			{
				// 发送请求参数
				out.print(param);
				// flush输出流的缓冲
				out.flush();
			}
			try(
				// 定义BufferedReader输入流来读取URL的响应
				BufferedReader in = new BufferedReader(new InputStreamReader
					(conn.getInputStream() , "utf-8")))
			{
				String line;
				while ((line = in.readLine())!= null)
				{
					result += "\n" + line;
				}
			}
		}
		catch(Exception e)
		{
			System.out.println("发送POST请求出现异常！" + e);
			e.printStackTrace();
		}
		return result;
	}
	// 提供主方法，测试发送GET请求和POST请求
	public static void main(String args[])
	{
		// 发送GET请求
		String s = GetPostTest.sendGet("http://blog.csdn.net/"
			, null);
		System.out.println(s);
		// 发送POST请求
		String s1 = GetPostTest.sendPost("http://passport.csdn.net/account/login"
			, "ref=toolbar");
		System.out.println(s1);
	}
}
```
---
###**基于TCP协议的网络传输**
####**TCP/IP协议**
TCP/IP（Transmission Control Protocol/Internet Protocol），即传输控制协议/因特网互联协议，又名网络通讯协议，是Internet最基本的协议、Internet国际互联网络的基础，由网络层的IP协议和传输层的TCP协议组成。

IP协议的责任就是把数据以数据包的形式从源地址传送到目的地址，根据数据包包头中包括的目的地址将数据包传送到目的地址。它还提供对数据大小的重新组装功能，以适应不同网络对包大小的要求。但是IP协议不负责保证传送可靠性，流控制，包顺序和其它对于主机到主机协议来说很普通的服务。

TCP协议用于在通信设备之间建立用于发送和接受数据的链路。TCP协议采用的重发机制(一但传输出现问题就发出信号，要求重新传输，直到所有数据安全正确地传输到目的地)保证了数据传输的可靠性。

虽然以上两种协议功能不同，但是它们是在同一时期作为同一个协议设计的，功能上互补，访问Internet的计算机必须都安装这两个协议，实际上将两者统称为TCP/IP协议。

####**使用ServerSocket/Socket进行通信**
**ServerSocket类**
在两个通信端没有建立虚拟链路之前，必须有一个通信实体首先主动监听来自另一端的请求。Java提供了ServerSocket类来接受其他通信实体的连接请求。ServerSocket对象使用accept()方法用于监听来自客户端的Socket连接，如果收到一个客户端Socket的连接请求，该方法将返回一个与客户端Socket对应的Socket对象。如果没有连接，它将一直处于等待状态。通常情况下，服务器不应只接受一个客户端请求，而应该通过循环调用accept()不断接受来自客户端的所有请求。

构造器摘要：

- ServerSocket()：创建非绑定ServerSocket对象；
- ServerSocket(int port)：创建绑定到特定端口（推荐1024以上的端口号）的ServerSocket对象，没有使用IP时默认绑定到本机默认的IP；
- ServerSocket(int port, int backlog)：增加一个用来改变连接队列长度backlog参数；
- ServerSocket(int port, int backlog, InetAddress bindAddr)：在机器存在多个IP地址的情况下，允许通过localAddr参数来指定将ServerSocket绑定到指定的IP地址。

方法摘要：

- Socket accept()：如果接收到来自客户端的一个连接请求，则返回一个与客户端对应的Socket，否则该方法将会被阻塞； 
- void bind(SocketAddress endpoint)：将 ServerSocket 绑定到特定地址（IP 地址和端口号）； 
- void bind(SocketAddress endpoint, int backlog)：将 ServerSocket 绑定到特定地址（IP 地址和端口号）；  
- void close()：当使用完ServerSocket之后，应该使用该方法来关闭此ServerSocket对象； 
- ServerSocketChannel getChannel()：返回与此套接字关联的唯一 ServerSocketChannel 对象（如果有）；  
- InetAddress getInetAddress()：返回此服务器套接字的本地地址； 
- int getLocalPort()：返回此套接字在其上侦听的端口； 
- SocketAddress getLocalSocketAddress()：返回此套接字绑定的端点的地址，如果尚未绑定则返回 null； 
- int getReceiveBufferSize()：获取此 ServerSocket 的 SO_RCVBUF 选项的值，该值是将用于从此 ServerSocket 接受的套接字的建议缓冲区大小； 
- boolean getReuseAddress()：测试是否启用 SO_REUSEADDR；  
- int getSoTimeout()：获取 SO_TIMEOUT 的设置；  
- protected  void implAccept(Socket s)：ServerSocket 的子类使用此方法重写 accept() 以返回它们自己的套接字子类； 
- boolean isBound()：返回 ServerSocket 的绑定状态；  
- boolean isClosed()：返回 ServerSocket 的关闭状态；  
- void setPerformancePreferences(int connectionTime, int latency, int bandwidth)：设置此 ServerSocket 的性能首选项； 
- void setReceiveBufferSize(int size)：为从此 ServerSocket 接受的套接字的 SO_RCVBUF 选项设置默认建议值； 
- void setReuseAddress(boolean on)：启用/禁用 SO_REUSEADDR 套接字选项； 
- static void setSocketFactory(SocketImplFactory fac)：为应用程序设置服务器套接字实现工厂； 
- void setSoTimeout(int timeout)：通过指定超时值启用/禁用 SO_TIMEOUT，以毫秒为单位。 

**Socket类**
客户端通常使用Socket对象连接到指定的服务器。

构造器摘要：

- Socket(InetAddress/String address, int port)：创建一个连接到指定 IP 地址的指定端口号的Socket，由于没有指定本地IP地址和本地端口，默认使用本机主机的默认IP地址，默认使用系统分配的端口，适用于本机主机只有一个IP地址的情况；
- Socket(InetAddress/String  address, int port, InetAddress localAddr, int localPort)：：创建一个连接到指定 IP 地址的指定端口号的Socket，并指定本地IP地址和本地端口，适用于本地主机有多个IP地址的情况；          

方法摘要：

- void bind(SocketAddress bindpoint) ：将套接字绑定到本地地址； 
- void close()：关闭此套接字；  
- void connect(SocketAddress endpoint)：将此套接字连接到服务器，获取连接之前会一直阻塞； 
- void connect(SocketAddress endpoint, int timeout)：将此套接字连接到服务器，并指定一个超时值； 
- void setSoTimeout(int timeout)：启用/禁用带有指定超时值的 SO_TIMEOUT，以毫秒为单位； 
- boolean isBound()：返回套接字的绑定状态； 
- boolean isClosed()：返回套接字的关闭状态； 
- boolean isConnected()：返回套接字的连接状态； 
- SocketChannel getChannel()：返回与此数据报套接字关联的唯一 SocketChannel 对象（如果有）； 
- InetAddress getInetAddress()：返回套接字连接的地址； 
- boolean getKeepAlive()：测试是否启用 SO_KEEPALIVE；  
- int getPort()：返回此套接字连接到的远程端口；  
- InetAddress getLocalAddress()：获取套接字绑定的本地地址；  
- int getLocalPort()：返回此套接字绑定到的本地端口；  
- SocketAddress getLocalSocketAddress()：返回此套接字绑定的端点的地址，如果尚未绑定则返回 null； 
- InputStream getInputStream()：返回此套接字的输入流，利用该输入流从该套接字读取数据；   
- OutputStream getOutputStream()：返回此套接字的输出流，利用该输出力向该套接字输出数据；


实际运行中可能不想一直阻塞，可以通过connect方法或setSoTimeout方法设置连接的超时时长，超时未连接成功则抛出SocketTimeoutException异常。

示例：
```java
public class Server
{
	public static void main(String[] args)	{
	    try{
		    // 创建一个ServerSocket，用于监听客户端Socket的连接请求
		    ServerSocket ss = new ServerSocket(30000);
	    	// 采用循环不断接受来自客户端的请求
		    while (true)
		    {
			    // 每当接受到客户端Socket的请求，服务器端也对应产生一个Socket
			    Socket s = ss.accept();
			    // 将Socket对应的输出流包装成PrintStream
		    	PrintStream ps = new PrintStream(s.getOutputStream());
		    	// 进行普通IO操作
		    	ps.println("您好，您收到了服务器的新年祝福！");
	    	}
	    }
	    catch (IOException e) {
	        e.printStacktrace();
	    }
	    finally {
	        // 关闭输出流，关闭Socket
		    ps.close();
		    s.close();
	    }
	}
}
```
```java
public class Client
{
	public static void main(String[] args)
	{
        try { 
		    //Socket socket = new Socket("127.0.0.1" , 30000); 
		    //设置超时为10s
		    //socket.setSoTimeout(10000);
		    //或者使用connect()方法设置超时
		    Socket socket = new Socket;
		    socket.connect(new InetAddress(host, port), 10000);
		    // 将Socket对应的输入流包装成BufferedReader
		    Scaner scan = new Scaner(socket.getInputStream()));
		    // 进行普通IO操作
	    	String line = scan.readLine();
		    System.out.println("来自服务器的数据：" + line);
		}
		catch (IOException e){
		    e.printStacktrace();
		}
		catch (SocketTimeoutException e) {
		    e.printStacktrace();
		}
		finally {  
		    // 关闭输入流、socket
		    br.close();
		    socket.close();
		}
	}
}
```
先运行Server类，再运行Client类，程序会输出：“来自服务器的数据：您好，您收到了服务器的新年祝福！”。

由于连接和流的操作会阻塞，应该为客户端和服务端的每次通信都另外开辟一条线程。

一个命令行界面的C/S聊天室示例，该聊天室支持群聊和私聊：
下面是在server包下的类：
```java
public interface MyProtocol
{
	// 定义协议字符串的长度
	int PROTOCOL_LEN = 2;
	// 下面是一些协议字符串，服务器和客户端交换的信息都应该在前、后添加这种特殊字符串。
	String MSG_ROUND = "§γ";
	String USER_ROUND = "∏∑";
	String LOGIN_SUCCESS = "1";
	String NAME_REP = "-1";
	String PRIVATE_ROUND = "★【";
	String SPLIT_SIGN = "※";
}
```
```java
// 通过组合HashMap对象来实现MyMap，MyMap要求value也不可重复
public class MyMap<K,V>
{
	// 创建一个线程安全的HashMap
	public Map<K ,V> map = Collections.synchronizedMap(new HashMap<K,V>());
	// 根据value来删除指定项
	public synchronized void removeByValue(Object value)
	{
		for (Object key : map.keySet())
		{
			if (map.get(key) == value)
			{
				map.remove(key);
				break;
			}
		}
	}
	// 获取所有value组成的Set集合
	public synchronized Set<V> valueSet()
	{
		Set<V> result = new HashSet<V>();
		// 将map中所有value添加到result集合中
		map.forEach((key , value) -> result.add(value));
		return result;
	}
	// 根据value查找key。
	public synchronized K getKeyByValue(V val)
	{
		// 遍历所有key组成的集合
		for (K key : map.keySet())
		{
			// 如果指定key对应的value与被搜索的value相同，则返回对应的key
			if (map.get(key) == val || map.get(key).equals(val))
			{
				return key;
			}
		}
		return null;
	}
	// 实现put()方法，该方法不允许value重复
	public synchronized V put(K key,V value)
	{
		// 遍历所有value组成的集合
		for (V val : valueSet() )
		{
			// 如果某个value与试图放入集合的value相同
			// 则抛出一个RuntimeException异常
			if (val.equals(value)
				&& val.hashCode()== value.hashCode())
			{
				throw new RuntimeException("MyMap实例中不允许有重复value!");
			}
		}
		return map.put(key , value);
	}
}
```
```java
public class Server
{
	private static final int SERVER_PORT = 30000;
	// 使用MyMap对象来保存每个客户名字和对应输出流之间的对应关系。
	public static MyMap<String , PrintStream> clients
		= new MyMap<>();
	public void init()
	{
		try(
			// 建立监听的ServerSocket
			ServerSocket ss = new ServerSocket(SERVER_PORT))
		{
			// 采用死循环来不断接受来自客户端的请求
			while(true)
			{
				Socket socket = ss.accept();
				new ServerThread(socket).start();
			}
		}
		// 如果抛出异常
		catch (IOException ex)
		{
			System.out.println("服务器启动失败，是否端口"
				+ SERVER_PORT + "已被占用？");
		}
	}
	public static void main(String[] args)
	{
		Server server = new Server();
		server.init();
	}
}
```
```java
public class ServerThread extends Thread
{
	private Socket socket;
	BufferedReader br = null;
	PrintStream ps = null;
	// 定义一个构造器，用于接收一个Socket来创建ServerThread线程
	public ServerThread(Socket socket)
	{
		this.socket = socket;
	}
	public void run()
	{
		try
		{
			// 获取该Socket对应的输入流
			br = new BufferedReader(new InputStreamReader(socket
				.getInputStream()));
			// 获取该Socket对应的输出流
			ps = new PrintStream(socket.getOutputStream());
			String line = null;
			while((line = br.readLine())!= null)
			{
				// 如果读到的行以MyProtocol.USER_ROUND开始，并以其结束，
				// 可以确定读到的是用户登录的用户名
				if (line.startsWith(MyProtocol.USER_ROUND)
					&& line.endsWith(MyProtocol.USER_ROUND))
				{
					// 得到真实消息
					String userName = getRealMsg(line);
					// 如果用户名重复
					if (Server.clients.map.containsKey(userName))
					{
						System.out.println("重复");
						ps.println(MyProtocol.NAME_REP);
					}
					else
					{
						System.out.println("成功");
						ps.println(MyProtocol.LOGIN_SUCCESS);
						Server.clients.put(userName , ps);
					}
				}
				// 如果读到的行以MyProtocol.PRIVATE_ROUND开始，并以其结束，
				// 可以确定是私聊信息，私聊信息只向特定的输出流发送
				else if (line.startsWith(MyProtocol.PRIVATE_ROUND)
					&& line.endsWith(MyProtocol.PRIVATE_ROUND))
				{
					// 得到真实消息
					String userAndMsg = getRealMsg(line);
					// 以SPLIT_SIGN分割字符串，前半是私聊用户，后半是聊天信息
					String user = userAndMsg.split(MyProtocol.SPLIT_SIGN)[0];
					String msg = userAndMsg.split(MyProtocol.SPLIT_SIGN)[1];
					// 获取私聊用户对应的输出流，并发送私聊信息
					Server.clients.map.get(user).println(Server.clients
						.getKeyByValue(ps) + "悄悄地对你说：" + msg);
				}
				// 公聊要向每个Socket发送
				else
				{
					// 得到真实消息
					String msg = getRealMsg(line);
					// 遍历clients中的每个输出流
					for (PrintStream clientPs : Server.clients.valueSet())
					{
						clientPs.println(Server.clients.getKeyByValue(ps)
							+ "说：" + msg);
					}
				}
			}
		}
		// 捕捉到异常后，表明该Socket对应的客户端已经出现了问题
		// 所以程序将其对应的输出流从Map中删除
		catch (IOException e)
		{
			Server.clients.removeByValue(ps);
			System.out.println(Server.clients.map.size());
			// 关闭网络、IO资源
			try
			{
				if (br != null)
				{
					br.close();
				}
				if (ps != null)
				{
					ps.close();
				}
				if (socket != null)
				{
					socket.close();
				}
			}
			catch (IOException ex)
			{
				ex.printStackTrace();
			}
		}
	}
	// 将读到的内容去掉前后的协议字符，恢复成真实数据
	private String getRealMsg(String line)
	{
		return line.substring(MyProtocol.PROTOCOL_LEN
			, line.length() - MyProtocol.PROTOCOL_LEN);
	}
}
```
下面是在client包下的类：
```java
public interface MyProtocol
{
	// 定义协议字符串的长度
	int PROTOCOL_LEN = 2;
	// 下面是一些协议字符串，服务器和客户端交换的信息都应该在前、后添加这种特殊字符串。
	String MSG_ROUND = "§γ";
	String USER_ROUND = "∏∑";
	String LOGIN_SUCCESS = "1";
	String NAME_REP = "-1";
	String PRIVATE_ROUND = "★【";
	String SPLIT_SIGN = "※";
}
```
```java
public class Client
{
	private static final int SERVER_PORT = 30000;
	private Socket socket;
	private PrintStream ps;
	private BufferedReader brServer;
	private BufferedReader keyIn;
	public void init()
	{
		try
		{
			// 初始化代表键盘的输入流
			keyIn = new BufferedReader(
				new InputStreamReader(System.in));
			// 连接到服务器
			socket = new Socket("127.0.0.1", SERVER_PORT);
			// 获取该Socket对应的输入流和输出流
			ps = new PrintStream(socket.getOutputStream());
			brServer = new BufferedReader(
				new InputStreamReader(socket.getInputStream()));
			String tip = "";
			// 采用循环不断地弹出对话框要求输入用户名
			while(true)
			{
				String userName = JOptionPane.showInputDialog(tip
					+ "输入用户名"); 
				// 将用户输入的用户名的前后增加协议字符串后发送
				ps.println(MyProtocol.USER_ROUND + userName
					+ MyProtocol.USER_ROUND);
				// 读取服务器的响应
				String result = brServer.readLine();
				// 如果用户重复，开始下次循环
				if (result.equals(MyProtocol.NAME_REP))
				{
					tip = "用户名重复！请重新";
					continue;
				}
				// 如果服务器返回登录成功，结束循环
				if (result.equals(MyProtocol.LOGIN_SUCCESS))
				{
					break;
				}
			}
		}
		// 捕捉到异常，关闭网络资源，并退出该程序
		catch (UnknownHostException ex)
		{
			System.out.println("找不到远程服务器，请确定服务器已经启动！");
			closeRs();
			System.exit(1);
		}
		catch (IOException ex)
		{
			System.out.println("网络异常！请重新登录！");
			closeRs();
			System.exit(1);
		}
		// 以该Socket对应的输入流启动ClientThread线程
		new ClientThread(brServer).start();
	}
	// 定义一个读取键盘输出，并向网络发送的方法
	private void readAndSend()
	{
		try
		{
			// 不断读取键盘输入
			String line = null;
			while((line = keyIn.readLine()) != null)
			{
				// 如果发送的信息中有冒号，且以//开头，则认为想发送私聊信息
				if (line.indexOf(":") > 0 && line.startsWith("//"))
				{
					line = line.substring(2);
					ps.println(MyProtocol.PRIVATE_ROUND +
					line.split(":")[0] + MyProtocol.SPLIT_SIGN
						+ line.split(":")[1] + MyProtocol.PRIVATE_ROUND);
				}
				else
				{
					ps.println(MyProtocol.MSG_ROUND + line
						+ MyProtocol.MSG_ROUND);
				}
			}
		}
		// 捕捉到异常，关闭网络资源，并退出该程序
		catch (IOException ex)
		{
			System.out.println("网络通信异常！请重新登录！");
			closeRs();
			System.exit(1);
		}
	}
	// 关闭Socket、输入流、输出流的方法
	private void closeRs()
	{
		try
		{
			if (keyIn != null)
			{
				ps.close();
			}
			if (brServer != null)
			{
				ps.close();
			}
			if (ps != null)
			{
				ps.close();
			}
			if (socket != null)
			{
				keyIn.close();
			}
		}
		catch (IOException ex)
		{
			ex.printStackTrace();
		}
	}
	public static void main(String[] args)
	{
		Client client = new Client();
		client.init();
		client.readAndSend();
	}
}
```
```java
public class ClientThread extends Thread
{
	// 该客户端线程负责处理的输入流
	BufferedReader br = null;
	// 使用一个网络输入流来创建客户端线程
	public ClientThread(BufferedReader br)
	{
		this.br = br;
	}
	public void run()
	{
		try
		{
			String line = null;
			// 不断从输入流中读取数据，并将这些数据打印输出
			while((line = br.readLine())!= null)
			{
				System.out.println(line);
				/*
				本例仅打印了从服务器端读到的内容。实际上，此处的情况可以更复杂：
				如果希望客户端能看到聊天室的用户列表，则可以让服务器在
				每次有用户登录、用户退出时，将所有用户列表信息都向客户端发送一遍。
				为了区分服务器发送的是聊天信息，还是用户列表，服务器也应该
				在要发送的信息前、后都添加一定的协议字符串，客户端此处则根据协议
				字符串的不同而进行不同的处理！
				更复杂的情况：
				如果两端进行游戏，则还有可能发送游戏信息，例如两端进行五子棋游戏，
				则还需要发送下棋坐标信息等，服务器同样在这些下棋坐标信息前、后
				添加协议字符串后再发送，客户端就可以根据该信息知道对手的下棋坐标。
				*/
			}
		}
		catch (IOException ex)
		{
			ex.printStackTrace();
		}
		// 使用finally块来关闭该线程对应的输入流
		finally
		{
			try
			{
				if (br != null)
				{
					br.close();
				}
			}
			catch (IOException ex)
			{
				ex.printStackTrace();
			}
		}
	}
}
```
先运行Server类，再多次运行Client类启动多个客户端，并输入用户名。
####**半关闭的Socket**
在IO中表示输出已经结束，则通过关闭输出流来实现，但是在socket中是行不通的，因为关闭socket，会导致无法再从该socket中读取数据了。为了解决这种问题，java提供了半关闭以及判断半关闭的方法：

- shutdownInput():关闭该Socket的输入流，程序还可以通过该Socket的输出流输出数据；
- shutdownOutput():关闭该Socket的输出流，程序还可以通过该Socket的输入流读取数据；
- boolean isInputShutdown()：返回该Socket是否为半读状态 (read-half)； 
- boolean isOutputShutdown()：返回该Socket是否为半写状态 (write-half)。

如果我们对同一个Socket实例先后调用shutdownInput和shutdownOutput方法，该Socket实例依然没有被关闭，只是该Socket既不能输出数据，也不能读取数据。
示例：
```java
public class Server
{
	public static void main(String[] args)
		throws Exception
	{
		ServerSocket ss = new ServerSocket(30000);
		Socket socket = ss.accept();
		PrintStream ps = new PrintStream(socket.getOutputStream());
		ps.println("服务器的第一行数据");
		ps.println("服务器的第二行数据");
		// 关闭socket的输出流，表明输出数据已经结束
		socket.shutdownOutput();
		// 下面语句将输出false，表明socket还未关闭。
		System.out.println(socket.isClosed());
		Scanner scan = new Scanner(socket.getInputStream());
		while (scan.hasNextLine())
		{
			System.out.println(scan.nextLine());
		}
		scan.close();
		socket.close();
		ss.close();
	}
}
```
```java
public class Client
{
	public static void main(String[] args)
		throws Exception
	{
		Socket s = new Socket("localhost" , 30000);
		Scanner scan = new Scanner(s.getInputStream());
		while (scan.hasNextLine())
		{
			System.out.println(scan.nextLine());
		}
		PrintStream ps = new PrintStream(s.getOutputStream());
		ps.println("客户端的第一行数据");
		ps.println("客户端的第二行数据");
		ps.close();
		scan.close();
		s.close();
	}
}
```
当调用了shutdownOutput()或shutdownInput()方法关闭了输出流或输入流之后，该Socket就无法再次打开输出流或输入流，因此这种做法不适合保持持久通信状态的交互式应用，只适用于一站式的通信协议，例如HTTP协议：客户端连接到服务器之后，开始发送完数据，发送完之后无须再次发送数据，只需要读取服务器响应的数据即可，当读取完成后，该Socket也该关闭了。
####**使用NIO实现非阻塞Socket通信**
从JDK1.4开始，Java提供了NIO API实现非阻塞式Socket通信。之前介绍的都是阻塞式通信，当服务器需要同时处理大量客户端时，需要创建很多线程，这样会导致性能下降，而使用NIO API则可以让服务器使用有限的几个线程处理所有连接到服务器的所有客户端。

NIO提供了以下几个类来支持非阻塞式Socket通信：
**Selector**
该抽象类代表SelectableChannel 对象的多路复用器。所有希望采用非阻塞方式通信的Channel都应该注册到Selector对象上。可以通过该类的open()静态方法使用系统默认的Selector来创建该类的实例，也可通过调用自定义的Selector的 openSelector() 方法来创建选择器。通过Selector对象的 close() 方法关闭选择器之前，它一直保持打开状态。

通过 SelectionKey 对象来表示SelectableChannel到Selector的注册关系。选择器维护了三种选择键集： 

- 所有注册在该Selector上的SelectionKey组成的集合：此集合由该Selector对象的keys()方法返回；
- 所有需要进行IO处理而被选择的SelectionKey集合：此集合由该Selector对象selectedKeys()方法返回；
- 所有被取消注册关系的Channel对应的SelectionKey组成的集合：在下一次调用select()方法时，这些SelectionKey会被彻底删除，程序通常无须访问该集合。 

在新创建的Selector中，这三个集合都是空集合。 

方法摘要：

- abstract  void close()：关闭此选择器； 
- abstract  boolean isOpen()：告知此选择器是否已打开； 
- abstract  Set<SelectionKey> **keys**()：所有注册在该Selector上的SelectionKey组成的集合； 
- static Selector **open**()：使用系统默认的Selector来创建该类的实例；
- abstract  SelectorProvider provider()：返回创建此通道的提供者；
- abstract  int **select**()：监控所有注册的Channel，返回所有需要进行IO操作的Channel对应的SelectionKey的数目；
- abstract  int select(long timeout)：同上，增加了超时时长；
- abstract  int **selectNow**()：执行一个立即返回的select()操作，相对于无参数的select()方法而言，该方法不会阻塞线程； 
- abstract  Set<SelectionKey> **selectedKeys**()：监控所有注册的Channel，返回所有需要进行IO操作的Channel对应的SelectionKey组成的集合；
- abstract  Selector wakeup()：使一个尚未返回的select()方法立即返回。 

<img src="http://img.blog.csdn.net/20161229005107578?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvcm9zeV9kYXdu/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast" width=500 />

**SelectableChannel**
该抽象类代表一个支持非阻塞IO操作的Channel，它可以被注册到Selector上，这种注册关系用SelectionKey示例表示。SelectionKey对象支持阻塞和非阻塞两种模式，但所有的Channel默认都是阻塞模式，在结合使用基于Selector的多路复用时，非阻塞模式是最有用的，向选择器注册某个通道前，必须将该通道置于非阻塞模式(通过configureBlocking方法设置)，并且在注销之前可能无法返回到阻塞模式。 

不能直接注销已注册Channel，必须先取消该Channel对应的SelectionKey。可通过调用SelectionKey对象的cancel()方法显式地取消该SelectionKey。无论是通过调用Channel的close方法，还是中断阻塞于该通道上I/O操作中的线程来关闭该Channel，都会隐式地取消该通道的所有SelectionKey对象。如果已注册的某个Selector本身已关闭，则立即将注销该Channel在该Selector上的注册。 一个Channel至多只能在任意特定Selector上注册一次。 

方法摘要：

- abstract  boolean **isBlocking**()：判断该Channel上的每个I/O操作在完成前是否被阻塞。
- abstract  SelectableChannel **configureBlocking**(boolean block)：设置该Channel的是否为阻塞模式； 
- abstract  Object blockingLock()：获取其 configureBlocking 和 register 方法实现同步的对象。
- abstract  boolean **isRegistered**()：判断该Channel当前是否已向一个或多个选择器注册。 
- SelectionKey **register(Selector sel, int ops)**：向给定的Selector注册该Channel，返回对应的SelectionKey。 
- abstract  SelectionKey register(Selector sel, int ops, Object att)：同上；
- abstract  SelectionKey keyFor(Selector sel)：获取表示该Channel向给定Selector注册的SelectionKey。不存在就返回null； 
- abstract  SelectorProvider provider()：返回创建该Channel的提供者。 
- abstract  int validOps()：返回一个整数值，表示该Channel所支持的操作。SelectionKey中用静态常量定义了4中IO操作：OP\_READ(1)、OP\_WRITE(4)、OP\_CONNECT(8)、OP\_ACCEPT(16)。 这4个值中的任意2个、3个、4个进行按位或的计算结果都相等，而且任意2个、3个、4个相加的结果都不相等，所以可以根据validOps()方法的返回值来确定该SelectionKey支持的操作。

**ServerSocketChannel**：该抽象类支持非阻塞操作，对应于java.net.ServerSocket类，只支持OP\_ACCEPT操作。该抽象类也有一个accept()方法，类似于ServerSocket的accept()方法。

**SocketChannel**：类似的，该抽象类也支持非阻塞操作，对应于java.net.Socket类，支持OP\_CONNECT、OP\_READ和OP\_WRITE操作。这个类还实现了ByteChannel接口、ScatteringByteChannel接口和GatheringByteChannel接口，所以它可以读写ByteBuffer对象。
![这里写图片描述](http://img.blog.csdn.net/20161229004858997?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvcm9zeV9kYXdu/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)   
服务器上的所有Channel（包括ServerSocketChannel和SocketChannel）都需要向Selector注册，该Selector负责监视这些Socket的IO状态，当存在需要进行IO操作的Channel时，该Selector的select()方法将会返回所有这些Channel对应的SelectionKey的数目，可以通过selectedKeys()方法返回这些SelectionKey的集合。程序通过不断调用Selector的select()方法即可知道当前有哪些Channel需要进行IO操作。如果该Selector上没有需要进行IO操作的Channel，那么select()方法竟会被阻塞。

使用NIO实现多人聊天室示例：
```java
public class NServer
{
	// 用于检测所有Channel状态的Selector
	private Selector selector = null;
	static final int PORT = 30000;
	// 定义实现编码、解码的字符集对象
	private Charset charset = Charset.forName("UTF-8");
	public void init()throws IOException
	{
		selector = Selector.open();
		// ServerSocketChannel不能直接监听某个端口
		// 也不能使用已有ServerSocket的getChannel()方法来获取它
		// 必须先通过open静态方法来创建一个ServerSocketChannel实例，在使用bind()方法绑定一个端口
		ServerSocketChannel server = ServerSocketChannel.open();
		InetSocketAddress isa = new InetSocketAddress("127.0.0.1", PORT);
		// 将该ServerSocketChannel绑定到指定IP地址
		server.bind(isa);
		// 设置ServerSocket以非阻塞方式工作
		server.configureBlocking(false);
		// 将server注册到指定Selector对象
		server.register(selector, SelectionKey.OP_ACCEPT);
		while (selector.select() > 0)
		{
			// 依次处理selector上的每个已选择的SelectionKey
			for (SelectionKey sk : selector.selectedKeys())
			{
				// 从selector上的已选择Key集中删除正在处理的SelectionKey
				selector.selectedKeys().remove(sk);      // ①
				// 如果sk对应的Channel包含客户端的连接请求
				if (sk.isAcceptable())        // ②
				{
					// 调用accept方法接受连接，产生服务器端的SocketChannel
					SocketChannel sc = server.accept();
					// 设置采用非阻塞模式
					sc.configureBlocking(false);
					// 将该SocketChannel也注册到selector
					sc.register(selector, SelectionKey.OP_READ);
					// 将sk对应的Channel设置成准备接受其他请求
					sk.interestOps(SelectionKey.OP_ACCEPT);
				}
				// 如果sk对应的Channel有数据需要读取
				if (sk.isReadable())     // ③
				{
					// 获取该SelectionKey对应的Channel，该Channel中有可读的数据
					SocketChannel sc = (SocketChannel)sk.channel();
					// 定义准备执行读取数据的ByteBuffer
					ByteBuffer buff = ByteBuffer.allocate(1024);
					String content = "";
					// 开始读取数据
					try
					{
						while(sc.read(buff) > 0)
						{
							buff.flip();
							content += charset.decode(buff);
						}
						// 打印从该sk对应的Channel里读取到的数据
						System.out.println("读取的数据：" + content);
						// 将sk对应的Channel设置成准备下一次读取
						sk.interestOps(SelectionKey.OP_READ);
					}
					// 如果捕捉到该sk对应的Channel出现了异常，即表明该Channel
					// 对应的Client出现了问题，所以从Selector中取消sk的注册
					catch (IOException ex)
					{
						// 从Selector中删除指定的SelectionKey
						sk.cancel();
						if (sk.channel() != null)
						{
							sk.channel().close();
						}
					}
					// 如果content的长度大于0，即聊天信息不为空
					if (content.length() > 0)
					{
						// 遍历该selector里注册的所有SelectionKey
						for (SelectionKey key : selector.keys())
						{
							// 获取该key对应的Channel
							Channel targetChannel = key.channel();
							// 如果该channel是SocketChannel对象
							if (targetChannel instanceof SocketChannel)
							{
								// 将读到的内容写入该Channel中
								SocketChannel dest = (SocketChannel)targetChannel;
								dest.write(charset.encode(content));
							}
						}
					}
				}
			}
		}
	}
	public static void main(String[] args)
		throws IOException
	{
		new NServer().init();
	}
}
```
```java
public class NClient
{
	// 定义检测SocketChannel的Selector对象
	private Selector selector = null;
	static final int PORT = 30000;
	// 定义处理编码和解码的字符集
	private Charset charset = Charset.forName("UTF-8");
	// 客户端SocketChannel
	private SocketChannel sc = null;
	public void init()throws IOException
	{
		selector = Selector.open();
		InetSocketAddress isa = new InetSocketAddress("127.0.0.1", PORT);
		// 调用open静态方法创建连接到指定主机的SocketChannel
		sc = SocketChannel.open(isa);
		// 设置该sc以非阻塞方式工作
		sc.configureBlocking(false);
		// 将SocketChannel对象注册到指定Selector
		sc.register(selector, SelectionKey.OP_READ);
		// 启动读取服务器端数据的线程
		new ClientThread().start();
		// 创建键盘输入流
		Scanner scan = new Scanner(System.in);
		while (scan.hasNextLine())
		{
			// 读取键盘输入
			String line = scan.nextLine();
			// 将键盘输入的内容输出到SocketChannel中
			sc.write(charset.encode(line));
		}
	}
	// 定义读取服务器数据的线程
	private class ClientThread extends Thread
	{
		public void run()
		{
			try
			{
				while (selector.select() > 0)
				{
					// 遍历每个有可用IO操作Channel对应的SelectionKey
					for (SelectionKey sk : selector.selectedKeys())
					{
						// 删除正在处理的SelectionKey
						selector.selectedKeys().remove(sk);
						// 如果该SelectionKey对应的Channel中有可读的数据
						if (sk.isReadable())
						{
							// 使用NIO读取Channel中的数据
							SocketChannel sc = (SocketChannel)sk.channel();
							ByteBuffer buff = ByteBuffer.allocate(1024);
							String content = "";
							while(sc.read(buff) > 0)
							{
								sc.read(buff);
								buff.flip();
								content += charset.decode(buff);
							}
							// 打印输出读取的内容
							System.out.println("聊天信息：" + content);
							// 为下一次读取作准备
							sk.interestOps(SelectionKey.OP_READ);
						}
					}
				}
			}
			catch (IOException ex)
			{
				ex.printStackTrace();
			}
		}
	}
	public static void main(String[] args)
		throws IOException
	{
		new NClient().init();
	}
}
```
####**使用JDK7的AIO实现异步非阻塞通信**
Java7提供的NIO.2提供了更高效的异步Channel支持，基于这种异步Channel的IO机制称为异步IO（Asynchronous IO）。

对于IO操作可以分成两步：

 1. 发出IO请求。如果发出的IO请求阻塞线程就是阻塞IO，如果发出的IO请求不阻塞线程就是非阻塞IO；
 2. 完成IO操作。如果实际IO操作由操作系统完成，再将结果返回给应用程序，这就是异步IO；如果实际IO操作需要应用程序本身执行，会阻塞线程，那就是同步IO。

Java对BIO、NIO、AIO的支持：

- Java BIO ： 同步并阻塞，服务器实现模式为一个连接一个线程，即客户端有连接请求时服务器端就需要启动一个线程进行处理，如果这个连接不做任何事情会造成不必要的线程开销，当然可以通过线程池机制改善；
- Java NIO ： 同步非阻塞，服务器实现模式为一个请求一个线程，即客户端发送的连接请求都会注册到多路复用器上，多路复用器轮询到连接有I/O请求时才启动一个线程进行处理；
- Java AIO(NIO.2) ： 异步非阻塞，服务器实现模式为一个有效请求一个线程，客户端的I/O请求都是由OS先完成了再通知服务器应用去启动线程进行处理。

BIO、NIO、AIO适用场景分析:

- BIO方式适用于连接数目比较小且固定的架构，这种方式对服务器资源要求比较高，并发局限于应用中，JDK1.4以前的唯一选择，但程序直观简单易理解。
- NIO方式适用于连接数目多且连接比较短（轻操作）的架构，比如聊天服务器，并发局限于应用中，编程比较复杂，JDK1.4开始支持。
- AIO方式使用于连接数目多且连接比较长（重操作）的架构，比如相册服务器，充分调用OS参与并发操作，编程比较复杂，JDK7开始支持。

NIO.2提供了一系列以Asynchronous开头的Channel接口和类：
<img src="http://img.blog.csdn.net/20161229125059748?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvcm9zeV9kYXdu/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast" width=500 />

#####**AsynchronousServerSocketChannel**
该抽象类代表一个异步通道，用于面向流的监听套接字，可以创建TCP服务端，绑定地址，监听端口等。

方法摘要：

- static AsynchronousServerSocketChannel	**open()**：创建一个默认的未监听的AsynchronousServerSocketChannel对象；
- static AsynchronousServerSocketChannel	**open(AsynchronousChannelGroup group)**：使用指定的AsynchronousChannelGroup来创建一个AsynchronousServerSocketChannel；
- AsynchronousServerSocketChannel	**bind(SocketAddress local)**：将该Channel的套接字绑定到一个本地地址来监听；
- abstract AsynchronousServerSocketChannel	**bind(SocketAddress local, int backlog)**：同上，指定了backlog参数；
- abstract Future&lt;AsynchronousSocketChannel> **accept()**：创建一个接受来自客户端的连接。由于异步操作由操作系统完成，程序无法获知accept方法何时返回结果。如果要获取连接成功后返回AsynchronousSocketChannel对象，则应该调用该方法返回值的get()方法——但是get()方法会阻塞该线程；
- abstract &lt;A> void	**accept(A attachment, CompletionHandler&lt;AsynchronousSocketChannel,? super A> handler)**：通过指定的CompletionHandler参数来创建一个连接。连接成功或失败都会触发CompletionHandler对象中的相应方法。其中连接成功后应该返回AsynchronousSocketChannel对象；
- AsynchronousChannelProvider provider()：返回该Channel的提供者；
- abstract &lt;T> AsynchronousServerSocketChannel	**setOption(SocketOption&lt;T> name, T value)**：设置套接字选项的值。可以为：SO\_RCVBUF（该套接字接受缓冲区的大小）和SO\_REUSEADDR（重用地址）；

通过open方法新创建的AsynchronousServerSocketChannel是打开的，但是并没有绑定，可以通过bind方法绑定一个本地地址来监听连接。一旦绑定，通过accept方法来初始化来自客户端的连接。

**Interface CompletionHandler&lt;V,A>**
该接口用来消费异步IO操作的结果，V 代表IO操作返回的结果类型，A代表发起IO操作时传入的对象类型。该接口定义了以下两个方法：

- void	completed(V result, A attachment)：当IO操作成功完成后调用此方法；
- void	failed(Throwable exc, A attachment)：当IO操作失败时调用该方法。

以上方法的实现应该以一种及时的方式完成，以便于调用的线程分发给其他ompletionHandler。

#####**AsynchronousChannelGroup**
该抽象类代表一个异步通道组，它可以实现资源共享。它封装了这样一种结构，用来控制由绑定到该AsynchronousChannelGroup的异步通道初始化的IO操作。AsynchronousChannelGroup有一个相关的线程池来提交IO操作，并分发给CompletionHandler来消费异步操作的执行结果。终止AsynchronousChannelGroup会导致其相关线程池的shutdown。通过调用其 withFixedThreadPool 或 withCachedThreadPool 静态方法来创建一个AsynchronousChannelGroup对象。JVM中有一个自动创建的系统范围的默认AsynchronousChannelGroup，创建时未指定AsynchronousChannelGroup的异步Channel会绑定到这个默认AsynchronousChannelGroup。这个默认AsynchronousChannelGroup可以通过以下系统属性来配置：

- java.nio.channels.DefaultThreadPool.threadFactory：该属性值是一个具体的ThreadFactory类的全名。该类通过系统类加载器加载和实例化。该工厂类的 newThread 方法用来创建这个默认AsynchronousChannelGroup相关的线程池中的每个线程。如果加载和实例化过程该属性值失败会在创建该默认组时抛出一个未指明的错误；
- java.nio.channels.DefaultThreadPool.initialSize：该属性值为该默认组的initialSize参数（参见[withCachedThreadPool][1]方法）。该属性值是初始大小参数的字符串表示，如果该值不能解析为Integer类型会在创建该默认组时抛出一个未指明的错误。

如果ThreadFactory类没有配置，那么该线程池中的线程是守护线程。完成Channel上IO操作的初始化工作的CompletionHandler肯定会如预期地被线程池中的线程调用。

方法摘要：

- static AsynchronousChannelGroup	**withCachedThreadPool**(ExecutorService executor, int - initialSize)：通过指定的线程池来创建一个AsynchronousChannelGroup，该线程组用来创建需要的新线程；
- static AsynchronousChannelGroup	**withFixedThreadPool**(int nThreads, ThreadFactory threadFactory)：通过指定的线程池来创建一个AsynchronousChannelGroup，该线程组用来创建需要的新线程；
- static AsynchronousChannelGroup	**withThreadPool**(ExecutorService executor)：通过指定的线程池来创建一个AsynchronousChannelGroup；- 
- AsynchronousChannelProvider	**provider**()：返回该异步通道组的提供者；
- abstract void	**shutdown**()：关闭该异步通道组；
- abstract boolean **isShutdown**()：判断该异步通道组是否关闭；
- abstract void	**shutdownNow**()：关闭该异步通道组并关闭该组中所有已打开的通道；
- abstract boolean awaitTermination(long timeout, TimeUnit unit)：等待该组的终止；
- abstract boolean **isTerminated**()：判断该异步通道组是否终止；

#####**AsynchronousSocketChannel**
该抽象类代表一个异步通道，用于面向流的监听套接字。该类对象只能通过以下两种方式：

- 通过该类的open静态方法创建未绑定的AsynchronousSocketChannel；
- 或者通过AsynchronousServerSocketChannel的accept方法返回。

不能通过任何已存在的Socket创建该类对象。

一个新创建的AsynchronousSocketChannel通过调用其connect方法来连接，一旦连接，则一直保持连接到其被关闭。
方法摘要：

- static AsynchronousSocketChannel	**open()**：创建一个异步套接字通道；
- static AsynchronousSocketChannel	**open(AsynchronousChannelGroup group)**：通过指定的AsynchronousChannelGroup来创建AsynchronousSocketChannel对象；
- abstract AsynchronousSocketChannel	**bind(SocketAddress local)**：绑定一个本地地址；
- abstract Future&lt;Void>	**connect(SocketAddress remote)**：连接这个Channel；
- abstract &lt;A> void	**connect(SocketAddress remote, A attachment, CompletionHandler&lt;Void,? super A> handler)**：同上，增加了CompletionHandler参数；
- abstract SocketAddress	**getRemoteAddress()**：返回该通道的套接字所连接的远程地址。可用于判断该Channel是否任然处于连接状态；
- AsynchronousChannelProvider	**provider()**：返回此Channel的提供者；
- abstract Future&lt;Integer> **read(ByteBuffer dst)**：将该Channel中的字节序列读取到给定的缓冲区中；
- abstract &lt;A> void **read(ByteBuffer[] dsts, int offset, int length, long timeout, TimeUnit unit, A attachment, CompletionHandler&lt;Long,? super A> handler)**：将该Channel中的字节序列读取到给定的缓冲区中；
- &lt;A> void **read(ByteBuffer dst, A attachment, CompletionHandler&lt;Integer,? super A> handler)**：将该Channel中的字节序列读取到给定的缓冲区中；
- abstract &lt;A> void	**read(ByteBuffer dst, long timeout, TimeUnit unit, A attachment, - CompletionHandler&lt;Integer,? super A> handler)**：将该Channel中的字节序列读取到给定的缓冲区中；
- abstract Future&lt;Integer> **write(ByteBuffer src)**：将一段字节序列从给定缓冲区写入该通道中；
- abstract &lt;A> void	**write(ByteBuffer[] srcs, int offset, int length, long timeout, TimeUnit unit, A attachment, CompletionHandler&lt;Long,? super A> handler)**：将一段字节序列从给定缓冲区写入该通道中；
- &lt;A> void	**write(ByteBuffer src, A attachment, CompletionHandler&lt;Integer,? super A> handler)**：将一段字节序列从给定缓冲区写入该通道中；
- abstract &lt;A> void	**write(ByteBuffer src, long timeout, TimeUnit unit, A attachment, CompletionHandler&lt;Integer,? super A> handler)**：将一段字节序列从给定缓冲区写入该通道中；
- abstract AsynchronousSocketChannel	**shutdownInput()**：在不管该Channel情况下关闭输入流；
- abstract AsynchronousSocketChannel	**shutdownOutput()**：在不管该Channel情况下关闭输出流；
- abstract <T> AsynchronousSocketChannel	**setOption(SocketOption&lt;T> name, T value)**：设置套接字选项的值：

 - SO_SNDBUF：套接字发送缓冲区的大小；
 - SO_RCVBUF：套接字接受缓冲区的大小；
 - SO_KEEPALIVE：保持活动连接；
 - SO_REUSEADDR：重用地址；
 - TCP_NODELAY：禁用纳格算法。

AsynchronousSocketChannel用法一般分以下几步：

 1. 调用open静态方法创建AsynchronousSocketChannel对象；
 2. 调用AsynchronousSocketChannel对象的connect方法连接到指定的IP地址、指定端口的服务器；
 3. 调用AsynchronousSocketChannel对象的read、write方法进行读写。
 
使用线程池管理异步Channel，并使用CompletionHandler监听异步IO操作的多人聊天器示例：
```java
public class AIOServer
{
	static final int PORT = 30000;
	final static String UTF_8 = "utf-8";
	static List<AsynchronousSocketChannel> channelList
		= new ArrayList<>();
	public void startListen() throws InterruptedException,
		Exception
	{
		// 创建一个线程池
		ExecutorService executor = Executors.newFixedThreadPool(20);
		// 以指定线程池来创建一个AsynchronousChannelGroup
		AsynchronousChannelGroup channelGroup = AsynchronousChannelGroup
			.withThreadPool(executor);
		// 以指定线程池来创建一个AsynchronousServerSocketChannel
		AsynchronousServerSocketChannel serverChannel
			= AsynchronousServerSocketChannel.open(channelGroup)
			// 指定监听本机的PORT端口
			.bind(new InetSocketAddress(PORT));
		// 使用CompletionHandler接受来自客户端的连接请求
		serverChannel.accept(null, new AcceptHandler(serverChannel));  // ①
		Thread.sleep(5000);
	}
	public static void main(String[] args)
		throws Exception
	{
		AIOServer server = new AIOServer();
		server.startListen();
	}
}
// 实现自己的CompletionHandler类
class AcceptHandler implements
	CompletionHandler<AsynchronousSocketChannel, Object>
{
	private AsynchronousServerSocketChannel serverChannel;
	public AcceptHandler(AsynchronousServerSocketChannel sc)
	{
		this.serverChannel = sc;
	}
	// 定义一个ByteBuffer准备读取数据
	ByteBuffer buff = ByteBuffer.allocate(1024);
	// 当实际IO操作完成时候触发该方法
	@Override
	public void completed(final AsynchronousSocketChannel sc
		, Object attachment)
	{
		// 记录新连接的进来的Channel
		AIOServer.channelList.add(sc);
		// 准备接受客户端的下一次连接
		serverChannel.accept(null , this);
		sc.read(buff , null
			, new CompletionHandler<Integer,Object>() 
		{
			@Override
			public void completed(Integer result
				, Object attachment)
			{
				buff.flip();
				// 将buff中内容转换为字符串
				String content = StandardCharsets.UTF_8
					.decode(buff).toString();
				// 遍历每个Channel，将收到的信息写入各Channel中
				for(AsynchronousSocketChannel c : AIOServer.channelList)
				{
					try
					{
						c.write(ByteBuffer.wrap(content.getBytes(
							AIOServer.UTF_8))).get();
					}
					catch (Exception ex)
					{
						ex.printStackTrace();
					}
				}
				buff.clear();
				// 读取下一次数据
				sc.read(buff , null , this);
			}
			@Override
			public void failed(Throwable ex, Object attachment)
			{
				System.out.println("读取数据失败: " + ex);
				// 从该Channel读取数据失败，就将该Channel删除
				AIOServer.channelList.remove(sc);
			}
		});
	}
	@Override
	public void failed(Throwable ex, Object attachment)
	{
		System.out.println("连接失败: " + ex);
	}
}
```
```java
public class AIOClient
{
	final static String UTF_8 = "utf-8";
	final static int PORT = 30000;
	// 与服务器端通信的异步Channel
	AsynchronousSocketChannel clientChannel;
	JFrame mainWin = new JFrame("多人聊天");
	JTextArea jta = new JTextArea(16 , 48);
	JTextField jtf = new JTextField(40);
	JButton sendBn = new JButton("发送");
	public void init()
	{
		mainWin.setLayout(new BorderLayout());
		jta.setEditable(false);
		mainWin.add(new JScrollPane(jta), BorderLayout.CENTER);
		JPanel jp = new JPanel();
		jp.add(jtf);
		jp.add(sendBn);
		// 发送消息的Action,Action是ActionListener的子接口
		Action sendAction = new AbstractAction()
		{
			public void actionPerformed(ActionEvent e)
			{
				String content = jtf.getText();
				if (content.trim().length() > 0)
				{
					try
					{
						// 将content内容写入Channel中
						clientChannel.write(ByteBuffer.wrap(content
							.trim().getBytes(UTF_8))).get(); 
					}
					catch (Exception ex)
					{
						ex.printStackTrace();
					}
				}
				// 清空输入框
				jtf.setText("");
			}
		};
		sendBn.addActionListener(sendAction);
		// 将Ctrl+Enter键和"send"关联
		jtf.getInputMap().put(KeyStroke.getKeyStroke('\n'
			, java.awt.event.InputEvent.CTRL_MASK) , "send");
		// 将"send"和sendAction关联
		jtf.getActionMap().put("send", sendAction);
		mainWin.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		mainWin.add(jp , BorderLayout.SOUTH);
		mainWin.pack();
		mainWin.setVisible(true);
	}
	public void connect()
		throws Exception
	{
		// 定义一个ByteBuffer准备读取数据
		final ByteBuffer buff = ByteBuffer.allocate(1024);
		// 创建一个线程池
		ExecutorService executor = Executors.newFixedThreadPool(80);
		// 以指定线程池来创建一个AsynchronousChannelGroup
		AsynchronousChannelGroup channelGroup =
			AsynchronousChannelGroup.withThreadPool(executor);
		// 以channelGroup作为组管理器来创建AsynchronousSocketChannel
		clientChannel = AsynchronousSocketChannel.open(channelGroup);
		// 让AsynchronousSocketChannel连接到指定IP、指定端口
		clientChannel.connect(new InetSocketAddress("127.0.0.1"
			, PORT)).get();
		jta.append("---与服务器连接成功---\n");
		buff.clear();
		clientChannel.read(buff, null
			, new CompletionHandler<Integer,Object>()
		{
			@Override
			public void completed(Integer result, Object attachment)
			{
				buff.flip();
				// 将buff中内容转换为字符串
				String content = StandardCharsets.UTF_8
					.decode(buff).toString();
				// 显示从服务器端读取的数据
				jta.append("某人说：" + content + "\n");
				buff.clear();
				clientChannel.read(buff , null , this);
			}
			@Override
			public void failed(Throwable ex, Object attachment)
			{
				System.out.println("读取数据失败: " + ex);
			}
		});
	}
	public static void main(String[] args)
		throws Exception
	{
		AIOClient client = new AIOClient();
		client.init();
		client.connect();
	}
}
```
----
###**UDP协议网络编程**
####**UDP协议**
UDP（User Datagram Protocol）协议，即用户数据报协议，是OSI参考模型中一种无连接的传输层协议，主要支持那些需要在计算机之间传输数据的不可靠网络连接。UDP的主要作用是完成网络数据和数据报之间的转换——在信息发送端，UDP协议将网络数据流封装为数据报，然后将数据报发送出去；在信息接收端，UDP协议将数据报转换成实际数据内容。

UDP协议与TCP协议的比较：

- TCP传输的效率不如UDP高。使用UDP时，每个数据报中都给出了完整的地址信息，因此无需要建立发送方和接收方的连接，而且也没有超时重发等机制，故而传输速度很快。对于TCP协议，由于它是一个面向连接的协议，在socket之间进行数据传输之前必然要建立连接，所以在TCP中多了一个连接建立的时间。
- UDP的吞吐量和可靠性不如TCP。使用UDP传输数据时是有大小限制的，每个被传输的数据报必须限定在64KB之内。而TCP没有这方面的限制。UDP是一个不可靠的协议，发送方所发送的数据报并不一定以相同的次序到达接收方。而TCP是一个可靠的协议，它确保接收方完全正确地获取发送方所发送的全部数据。
- 由于TCP在网络通信上有极强的生命力，主要用于远程连接（Telnet）和文件传输（FTP）、邮件发送（SMTP、POP3）、HTTP连接等；相比之下UDP操作简单，而且仅需要较少的监护，主要用于并不需要保证严格传输可靠性的场景，比如网络游戏、视频会议系统，并不要求音频视频数据绝对的正确，只要保证连贯性就可以了。

####**DatagramSocket**
此类表示用来发送和接收UDP协议数据报的Socket（在通讯实例的两端个建立一个Socket，但这两个Socket之间并没有虚拟链路）。
构造方法摘要：
- DatagramSocket()：创建一个DatagramSocket对象，并将其绑定到本地主机上的默认IP地址和随机一个可用的端口；
- DatagramSocket(int port)：创建一个DatagramSocket对象，并将其绑定到本地主机上的默认IP地址和指定端口；
- DatagramSocket(SocketAddress bindaddr)：创建一个DatagramSocket对象，并将其绑定到本地主机上指定的地址；
- DatagramSocket(int port, InetAddress laddr)：创建一个DatagramSocket对象，并将其绑定到本地主机上的指定的IP地址和指定端口；
- protected  DatagramSocket(DatagramSocketImpl impl)：创建带有指定 DatagramSocketImpl 的未绑定数据报套接字。 

方法摘要：

- void **bind(SocketAddress addr)**：将此 DatagramSocket 绑定到特定的地址和端口。 
- boolean **isBound()**：返回套接字的绑定状态。 
- void **connect(InetAddress address, int port)**：将套接字连接到此套接字的远程地址。 
- void **connect(SocketAddress addr)**：将此套接字连接到远程套接字地址（IP 地址 + 端口号）。
- boolean **isConnected()**：返回套接字的连接状态；
- void **receive(DatagramPacket p)**：从此套接字接收数据报包。 
- void **send(DatagramPacket p)**：从此套接字发送数据报包。 
- void **disconnect()**：断开套接字的连接。 
- void **close()**：关闭此数据报套接字。 
- boolean **isClosed()**：返回是否关闭了套接字。
- DatagramChannel **getChannel()**：返回与此数据报套接字关联的唯一 DatagramChannel 对象（如果有）。 
- InetAddress **getInetAddress()**：返回此套接字连接的地址。 
- InetAddress **getLocalAddress()**：获取套接字绑定的本地地址。 
- int **getLocalPort()**：返回此套接字绑定的本地主机上的端口号。 
- SocketAddress **getLocalSocketAddress()**：返回此套接字绑定的端点的地址，如果尚未绑定则返回 null。 
- int **getPort()**：返回此套接字的端口。 
- int **getReceiveBufferSize()**：获取此 DatagramSocket 的 SO_RCVBUF 选项的值，该值是平台在 DatagramSocket 上输入时使用的缓冲区大小。 
- SocketAddress **getRemoteSocketAddress()**：返回此套接字连接的端点的地址，如果未连接则返回 null。 
- boolean getReuseAddress()：检测是否启用了 SO_REUSEADDR。 
- int **getSendBufferSize()**：获取此 DatagramSocket 的 SO_SNDBUF 选项的值，该值是平台在 DatagramSocket 上输出时使用的缓冲区大小。 
- int **getSoTimeout()**：获取 SO_TIMEOUT 的设置。 
- int **getTrafficClass()**：为从此 DatagramSocket 上发送的包获取 IP 数据报头中的流量类别或服务类型。 
- void **setBroadcast(boolean on)**：启用/禁用 SO_BROADCAST。 
-static void setDatagramSocketImplFactory(DatagramSocketImplFactory fac)：为应用程序设置数据报套接字实现工厂。 
- void **setReceiveBufferSize(int size)**：将此 DatagramSocket 的 SO_RCVBUF 选项设置为指定的值。 
- void **setReuseAddress(boolean on)**：启用/禁用 SO_REUSEADDR 套接字选项。 
- void **setSendBufferSize(int size)**：将此 DatagramSocket 的 SO_SNDBUF 选项设置为指定的值。 
- void **setSoTimeout(int timeout)**：启用/禁用带有指定超时值的 SO_TIMEOUT，以毫秒为单位。 
- void **setTrafficClass(int tc)**：为从此 DatagramSocket 上发送的数据报在 IP 数据报头中设置流量类别 (traffic class) 或服务类型八位组 (type-of-service octet)。 

使用DatagramSocket发送数据时，DatagramSocket并不知道将该数据报发送到哪里，而是由DatagramPacket自身决定数据报的目的地。

####**DatagramPacket**
此类表示数据报包。 

构造器摘要：

- DatagramPacket(byte[] buf, int length)：构造 DatagramPacket，用来接收长度为 length 的数据包；
- DatagramPacket(byte[] buf, int length, InetAddress address, int port)：构造数据报包，用来将长度为 length 的包发送到指定IP地址的主机上的指定端口号；
- DatagramPacket(byte[] buf, int offset, int length)：构造 DatagramPacket，用来接收长度为 length 的包，在缓冲区中指定了偏移量；
- DatagramPacket(byte[] buf, int offset, int length, InetAddress address, int port)：构造数据报包，用来将长度为 length 偏移量为 offset 的包发送到指定IP地址的主机上的指定端口号； 
- DatagramPacket(byte[] buf, int offset, int length, SocketAddress address)：构造数据报包，用来将长度为 length 偏移量为 offset 的包发送到指定IP地址的主机上的指定端口号；
- DatagramPacket(byte[] buf, int length, SocketAddress address)：构造数据报包，用来将长度为 length 的包发送到指定IP地址的主机上的指定端口号。 

方法摘要：

- InetAddress **getAddress()**：返回某台机器的 IP 地址，此数据报将要发往该机器或者是从该机器接收到的； 
- byte[] **getData()**：返回数据缓冲区； 
- int **getLength()**：返回将要发送或接收到的数据的长度；
- int **getOffset()**：返回将要发送或接收到的数据的偏移量； 
- int **getPort()**：返回某台远程主机的端口号，此数据报将要发往该主机或者是从该主机接收到的；
- SocketAddress **getSocketAddress()**：获取要将此包发送到的或发出此数据报的远程主机的 SocketAddress（通常为 IP 地址 + 端口号）； 
- void **setAddress(InetAddress iaddr)**：设置要将此数据报发往的那台机器的 IP 地址；
- void **setData(byte[] buf)**：为此包设置数据缓冲区；
- void **setData(byte[] buf, int offset, int length)**：为此包设置数据缓冲区；
- void **setLength(int length)**：为此包设置长度；
- void **setPort(int iport)**：设置要将此数据报发往的远程主机上的端口号；
- void **setSocketAddress(SocketAddress address)**：设置要将此数据报发往的远程主机的 SocketAddress（通常为 IP 地址 + 端口号）。 

在C/S程序中使用UDP协议时，实际上没有没明确的客户端和服务器端之分，因为两者功能相似，一般把固定IP地址、固定端口号的DatagramSocket对象所在的程序称为服务器，因为该DatagramSocket可以主动接收客户端数据。

在接收数据之前，应该使用DatagramPacket的不包含地址的构造器创建DatagramPacket对象，给出接收数据的字节数组及其长度。然后调用DatagramSocket的receive方法等待数据报的到来，receive将一直等待（阻塞）到接收到一个数据报为止。

在发送数据之前，应该使用DatagramPacket的包含完整地址的构造器创建DatagramPacket对象，此时字节数组里存放了想发送的数据。然后通过调用DatagramSocket的send方法来发送该DatagramPacket对象到指定地址。

当另一端接收到一个DatagramPacket对象后，程序可以调用DatagramPacket对象的一系列getXxx方法来获取发送者的信息。

使用UDP协议实现的C/S通信示例：
```java
public class UdpServer
{
	public static final int PORT = 30000;
	// 定义每个数据报的最大大小为4K
	private static final int DATA_LEN = 4096;
	// 定义接收网络数据的字节数组
	byte[] inBuff = new byte[DATA_LEN];
	// 以指定字节数组创建准备接受数据的DatagramPacket对象
	private DatagramPacket inPacket =
		new DatagramPacket(inBuff , inBuff.length);
	// 定义一个用于发送的DatagramPacket对象
	private DatagramPacket outPacket;
	// 定义一个字符串数组，服务器发送该数组的的元素
	String[] books = new String[]
	{
		"疯狂Java讲义",
		"轻量级Java EE企业应用实战",
		"疯狂Android讲义",
		"疯狂Ajax讲义"
	};
	public void init()throws IOException
	{
		try(
			// 创建DatagramSocket对象
			DatagramSocket socket = new DatagramSocket(PORT))
		{
			// 采用循环接受数据
			for (int i = 0; i < 1000 ; i++ )
			{
				// 读取Socket中的数据，读到的数据放入inPacket封装的数组里。
				socket.receive(inPacket);
				// 判断inPacket.getData()和inBuff是否是同一个数组
				System.out.println(inBuff == inPacket.getData());
				// 将接收到的内容转成字符串后输出
				System.out.println(new String(inBuff
					, 0 , inPacket.getLength()));
				// 从字符串数组中取出一个元素作为发送的数据
				byte[] sendData = books[i % 4].getBytes();
				// 以指定字节数组作为发送数据、以刚接受到的DatagramPacket的
				// 源SocketAddress作为目标SocketAddress创建DatagramPacket。
				outPacket = new DatagramPacket(sendData
					, sendData.length , inPacket.getSocketAddress());
				// 发送数据
				socket.send(outPacket);
			}
		}
	}
	public static void main(String[] args)
		throws IOException
	{
		new UdpServer().init();
	}
}
```
```java
public class UdpClient
{
	// 定义发送数据报的目的地
	public static final int DEST_PORT = 30000;
	public static final String DEST_IP = "127.0.0.1";
	// 定义每个数据报的最大大小为4K
	private static final int DATA_LEN = 4096;
	// 定义接收网络数据的字节数组
	byte[] inBuff = new byte[DATA_LEN];
	// 以指定字节数组创建准备接受数据的DatagramPacket对象
	private DatagramPacket inPacket =
		new DatagramPacket(inBuff , inBuff.length);
	// 定义一个用于发送的DatagramPacket对象
	private DatagramPacket outPacket = null;
	public void init()throws IOException
	{
		try(
			// 创建一个客户端DatagramSocket，使用随机端口
			DatagramSocket socket = new DatagramSocket())
		{
			// 初始化发送用的DatagramSocket，它包含一个长度为0的字节数组
			outPacket = new DatagramPacket(new byte[0] , 0
				, InetAddress.getByName(DEST_IP) , DEST_PORT);
			// 创建键盘输入流
			Scanner scan = new Scanner(System.in);
			// 不断读取键盘输入
			while(scan.hasNextLine())
			{
				// 将键盘输入的一行字符串转换字节数组
				byte[] buff = scan.nextLine().getBytes();
				// 设置发送用的DatagramPacket里的字节数据
				outPacket.setData(buff);
				// 发送数据报
				socket.send(outPacket);
				// 读取Socket中的数据，读到的数据放在inPacket所封装的字节数组里。
				socket.receive(inPacket);
				System.out.println(new String(inBuff , 0
					, inPacket.getLength()));
			}
		}
	}
	public static void main(String[] args)
		throws IOException
	{
		new UdpClient().init();
	}
}
```
####**MulticastSocket**
此类代表一个多播套接字，继承自DatagramSocket类，可以将数据报以广播的方式发送到多个客户端。该类通过 D 类 IP 地址和标准 UDP 端口号指定。D 类 IP 地址在 224.0.0.0~239.255.255.255 的范围内，但地址 224.0.0.0 被保留，不应使用。

若要使用多点广播，则需要让一个数据报标有一组目标主机地址，当数据报发出后，整个组的所有主机都能收到该数据报。IP多点广播实现了将单一信息发送到多个接受者的广播，其思想是**设置一组特殊网络地址作为多点广播地址**，当客户端需要发送、接受广播消息时，加入到这个多点广播地址（一组地址）即可。

具体的实现策略就是定义一个多点广播地址，使得每个MulticastSocket都加入到这个地址中。从而每次使用MulticastSocket发送数据报（包含的广播地址）时，所有加入了这个多点广播地址的MulticastSocket对象都可以收到信息。当然，MulticastSocket也可以接收加入到该组地址的其他MulticastSocket发送的消息。

构造方法摘要：

- MulticastSocket()：使用本机默认地址、随机端口创建创建多播套接字；
- MulticastSocket(int port)：使用本机默认地址、指定端口创建多播套接字；
- MulticastSocket(SocketAddress bindaddr)：使用本机指定IP地址、指定端口的套接字地址创建多播套接字。 

如果创建仅用于发送数据报的MulticastSocket对象，则使用默认地址，随机端口即可。但如果创建接受用的MulticastSocket对象，则该MulticastSocket对象必须具有指定端口，否则发送方无法确定发送数据报的目标端口。

方法摘要：

- void **joinGroup(InetAddress mcastaddr)**：将该MulticastSocket加入指定的多点广播地址；
- void **joinGroup(SocketAddress mcastaddr, NetworkInterface netIf)**：将该MulticastSocket加入指定接口上的多点广播地址。netIf为指定要接收多播数据报包的本地接口，也可以为 null，表示由 setInterface(InetAddress) 或 setNetworkInterface(NetworkInterface) 设置的接口； 
- void **leaveGroup(InetAddress mcastaddr)**：让该MulticastSocket离开指定的多点广播地址；
- void **leaveGroup(SocketAddress mcastaddr, NetworkInterface netIf)**：让该MulticastSocket离开指定接口上的多点广播地址；
- void **setInterface(InetAddress inf)**：某些系统中肯能有多个网络接口，需要在一个指定的网络接口上监听。设置该MulticastSocket使用指定的网络接口； 
- InetAddress **getInterface()**：获取用于多播数据包的网络接口的地址； 
- void **setNetworkInterface(NetworkInterface netIf)**：指定在此套接字上发送的输出多播数据报的网络接口；
- NetworkInterface **getNetworkInterface()**：获取多播网络接口集合； 
- void **setTimeToLive(int ttl)**：该ttl参数用于设置数据报最多可以跨过多少个网络。当ttl为0时，指定数据报应停留在本机地址；当ttl为1时，指定数据报发送到本地局域网；当ttl为32时，指定数据报只能发送到本站点的网络上；当ttl为64时，意味着数据报应保留在本地区；当ttl为128时，意味着数据报应保留在本大洲；当ttl为255时，意味着数据报可以发送到所有地方。该值默认为1； 
- int **getTimeToLive()**：获取在套接字上发出的多播数据包的默认生存时间；
- void **setLoopbackMode(boolean disable)**：启用/禁用多播数据报的本地回送；
- boolean **getLoopbackMode()**：设置该MulticastSocket发送的数据报会被回送到自身。

一个基于广播的多人聊天室示例：
```java
// 让该类实现Runnable接口，该类的实例可作为线程的target
public class MulticastSocketTest implements Runnable
{
	// 使用常量作为本程序的多点广播IP地址
	private static final String BROADCAST_IP
		= "230.0.0.1";
	// 使用常量作为本程序的多点广播目的的端口
	public static final int BROADCAST_PORT = 30000;
	// 定义每个数据报的最大大小为4K
	private static final int DATA_LEN = 4096;
	//定义本程序的MulticastSocket实例
	private MulticastSocket socket = null;
	private InetAddress broadcastAddress = null;
	private Scanner scan = null;
	// 定义接收网络数据的字节数组
	byte[] inBuff = new byte[DATA_LEN];
	// 以指定字节数组创建准备接受数据的DatagramPacket对象
	private DatagramPacket inPacket
		= new DatagramPacket(inBuff , inBuff.length);
	// 定义一个用于发送的DatagramPacket对象
	private DatagramPacket outPacket = null;
	public void init()throws IOException
	{
		try(
			// 创建键盘输入流
			Scanner scan = new Scanner(System.in))
		{
			// 创建用于发送、接收数据的MulticastSocket对象
			// 由于该MulticastSocket对象需要接收数据，所以有指定端口
			socket = new MulticastSocket(BROADCAST_PORT);
			broadcastAddress = InetAddress.getByName(BROADCAST_IP);
			// 将该socket加入指定的多点广播地址
			socket.joinGroup(broadcastAddress);
			// 设置本MulticastSocket发送的数据报会被回送到自身
			socket.setLoopbackMode(false);
			// 初始化发送用的DatagramSocket，它包含一个长度为0的字节数组
			outPacket = new DatagramPacket(new byte[0]
				, 0 , broadcastAddress , BROADCAST_PORT);
			// 启动以本实例的run()方法作为线程体的线程
			new Thread(this).start();
			// 不断读取键盘输入
			while(scan.hasNextLine())
			{
				// 将键盘输入的一行字符串转换字节数组
				byte[] buff = scan.nextLine().getBytes();
				// 设置发送用的DatagramPacket里的字节数据
				outPacket.setData(buff);
				// 发送数据报
				socket.send(outPacket);
			}
		}
		finally
		{
			socket.close();
		}
	}
	public void run()
	{
		try
		{
			while(true)
			{
				// 读取Socket中的数据，读到的数据放在inPacket所封装的字节数组里。
				socket.receive(inPacket);
				// 打印输出从socket中读取的内容
				System.out.println("聊天信息：" + new String(inBuff
					, 0 , inPacket.getLength()));
			}
		}
		// 捕捉异常
		catch (IOException ex)
		{
			ex.printStackTrace();
			try
			{
				if (socket != null)
				{
					// 让该Socket离开该多点IP广播地址
					socket.leaveGroup(broadcastAddress);
					// 关闭该Socket对象
					socket.close();
				}
				System.exit(1);
			}
			catch (IOException e)
			{
				e.printStackTrace();
			}
		}
	}
	public static void main(String[] args)
		throws IOException
	{
		new MulticastSocketTest().init();
	}
}
```
---
###**使用代理服务器**
从Java5开始，java.net包下提供了Proxy和ProxySelector两个类来提供代理服务。
####**Proxy**
该类表示代理设置。Proxy 是不可变对象。该类仅有一个构造器：

- Proxy(Proxy.Type type, SocketAddress sa) ：sa参数指定代理服务器的地址，Proxy.Type是该类的内部枚举类，该参数表示代理服务器的三种类型：
 - Proxy.Type.DIRECT：表示直接连接，不使用代理；
 - Proxy.Type.HTTP：表示支持高级协议代理，如 HTTP 或 FTP；
 - Proxy.Type.SOCKS：表示 SOCKS（V4 或 V5）代理。 

创建了Proxy对象后，程序就可以在使用URLConnection的openConnection(Proxy proxy)方法打开连接时，或者在使用Socket构造器Socket(Proxy proxy)时传入一个Proxy对象，作为本次连接所用的代理服务器。
在URLConnection中使用代理服务器：
```java
public class ProxyTest
{
	// 下面是代理服务器的地址和端口，
	// 换成实际有效的代理服务器的地址和端口
	final String PROXY_ADDR = "129.82.12.188";
	final int PROXY_PORT = 3124;
	// 定义需要访问的网站地址
	String urlStr = "http://www.crazyit.org";
	public void init()
		throws IOException , MalformedURLException
	{
		URL url = new URL(urlStr);
		// 创建一个代理服务器对象
		Proxy proxy = new Proxy(Proxy.Type.HTTP
			, new InetSocketAddress(PROXY_ADDR , PROXY_PORT));
		// 使用指定的代理服务器打开连接
		URLConnection conn = url.openConnection(proxy);
		// 设置超时时长。
		conn.setConnectTimeout(5000);
		try(
			// 通过代理服务器读取数据的Scanner
			Scanner scan = new Scanner(conn.getInputStream(), "utf-8");
			PrintStream ps = new PrintStream("index.htm"))
		{
			while (scan.hasNextLine())
			{
				String line = scan.nextLine();
				// 在控制台输出网页资源内容
				System.out.println(line);
				// 将网页资源内容输出到指定输出流
				ps.println(line);
			}
		}
	}
	public static void main(String[] args)
		throws IOException , MalformedURLException
	{
		new ProxyTest().init();
	}
}
```
####**ProxySelector**
该抽象类代表一个代理服务器选择器，可以继承该类实现自己的代理服务器选择器。

方法摘要：

 - **abstract  void connectFailed(URI uri, SocketAddress sa, IOException ioe)**：连接代理服务器失败时回调该方法；
 - **abstract List<Proxy> select(URI uri)**：根据业务需要返回代理服务器列表，如果该方法返回的集合中只包含一个Proxy，那么该Proxy将会作为默认代理服务器；
 - **static void setDefault(ProxySelector ps)**：设置（或取消设置）系统级代理选择器；
 - static ProxySelector getDefault()：获取系统级代理选择器。
 
实现自定义代理服务器选择器后，调用该类的setDefault(ProxySelector ps)静态方法来注册该代理选择器即可。
示例：
```java
ublic class ProxySelectorTest
{
	// 下面是代理服务器的地址和端口，
	// 随便一个代理服务器的地址和端口
	final String PROXY_ADDR = "139.82.12.188";
	final int PROXY_PORT = 3124;
	// 定义需要访问的网站地址
	String urlStr = "http://www.crazyit.org";
	public void init()
		throws IOException , MalformedURLException
	{
		// 注册默认的代理选择器
		ProxySelector.setDefault(new ProxySelector()
		{
			@Override
			public void connectFailed(URI uri
				, SocketAddress sa, IOException ioe)
			{
				System.out.println("无法连接到指定代理服务器！");
			}
			// 根据"业务需要"返回特定的对应的代理服务器
			@Override
			public List<Proxy> select(URI uri)
			{
				// 本程序总是返回某个固定的代理服务器。
				List<Proxy> result = new ArrayList<>();
				result.add(new Proxy(Proxy.Type.HTTP
					, new InetSocketAddress(PROXY_ADDR , PROXY_PORT)));
				return result;
			}
		});
		URL url = new URL(urlStr);
		// 没有指定代理服务器、直接打开连接
		URLConnection conn = url.openConnection(); 
		// 设置超时时长。
		conn.setConnectTimeout(3000);
		try(
			// 通过代理服务器读取数据的Scanner
			Scanner scan = new Scanner(conn.getInputStream());
			PrintStream ps = new PrintStream("index.htm"))
		{
			while (scan.hasNextLine())
			{
				String line = scan.nextLine();
				// 在控制台输出网页资源内容
				System.out.println(line);
				// 将网页资源内容输出到指定输出流
				ps.println(line);
			}
		}
	}
	public static void main(String[] args)
		throws IOException , MalformedURLException
	{
		new ProxySelectorTest().init();
	}
}
```
**DefaultProxySelector**
此类是ProxySelector的默认实现类，只是未公开，应该尽量避免直接使用该类。系统已经将该类注册为默认的代理选择器。可以通过ProxySelector类的getDefault()方法来获取该类的实例。该类对其父类抽象方法的实现为：
 - connectFailed方法：如果连接失败，DefaultProxySelector将尝试不使用代理服务器，而是直接连接；
 - select方法：DefaultProxySelector会根据系统属性来决定使用哪个代理服务器。ProxySelector会检测系统属性与URL之间的匹配，然后使用相应的属性值作为代理服务器；

常用的代理服务器属性名：

 - http.proxyHost：设置HTTP访问所使用的代理服务器的主机地址。该属性名的前缀可以改为https、ftp等；
 - http.proxyPort：设置HTTP访问所使用的代理服务器端口。该属性名的前缀可以改为https、ftp等；
 - http.nonProxyHosts：设置HTTP访问中不需要使用代理服务器的主机，支持使用*通配符；支持指定多个地址，多个地址之间使用竖线（|）分隔。
 
通过改变系统属性来改变默认的代理服务器：
```java
public class DefaultProxySelectorTest
{
	// 定义需要访问的网站地址
	static String urlStr = "http://www.crazyit.org";
	public static void main(String[] args) throws Exception
	{
		// 获取系统的默认属性
		Properties props = System.getProperties();
		// 通过系统属性设置HTTP访问所用的代理服务器的主机地址、端口
		props.setProperty("http.proxyHost", "192.168.10.96");
		props.setProperty("http.proxyPort", "8080");
		// 通过系统属性设置HTTP访问无需使用代理服务器的主机
		// 可以使用*通配符，多个地址用|分隔
		props.setProperty("http.nonProxyHosts", "localhost|192.168.10.*");
		// 通过系统属性设置HTTPS访问所用的代理服务器的主机地址、端口
		props.setProperty("https.proxyHost", "192.168.10.96");
		props.setProperty("https.proxyPort", "443");
		/* DefaultProxySelector不支持https.nonProxyHosts属性，
		 DefaultProxySelector直接按http.nonProxyHosts的设置规则处理 */
		// 通过系统属性设置FTP访问所用的代理服务器的主机地址、端口
		props.setProperty("ftp.proxyHost", "192.168.10.96");
		props.setProperty("ftp.proxyPort", "2121");
		// 通过系统属性设置FTP访问无需使用代理服务器的主机
		props.setProperty("ftp.nonProxyHosts", "localhost|192.168.10.*");
		// 通过系统属性设置设置SOCKS代理服务器的主机地址、端口
		props.setProperty("socks.ProxyHost", "192.168.10.96");
		props.setProperty("socks.ProxyPort", "1080");
		// 获取系统默认的代理选择器
		ProxySelector selector = ProxySelector.getDefault(); 
		System.out.println("系统默认的代理选择器：" + selector);
		// 根据URI动态决定所使用的代理服务器
		System.out.println("系统为ftp://www.crazyit.org选择的代理服务器为："
			+ ProxySelector.getDefault().select(new URI("ftp://www.crazyit.org"))); 
		URL url = new URL(urlStr);
		// 直接打开连接，默认的代理选择器会使用http.proxyHost、
		// http.proxyPort系统属性设置的代理服务器，
		// 如果无法连接代理服务器，默认的代理选择器会尝试直接连接
		URLConnection conn = url.openConnection();   // ③
		// 设置超时时长。
		conn.setConnectTimeout(3000);
		try(
			Scanner scan = new Scanner(conn.getInputStream() , "utf-8"))
		{
			// 读取远程主机的内容
			while(scan.hasNextLine())
			{
				System.out.println(scan.nextLine());
			}
		}
	}
}
```
[1]: http://tool.oschina.net/uploads/apidocs/jdk_7u4/java/nio/channels/AsynchronousChannelGroup.html#withCachedThreadPool%28java.util.concurrent.ExecutorService,%20int%29