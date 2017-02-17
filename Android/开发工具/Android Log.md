## **Android  Log详解**

大家都知道可以通过DDMS来查看（和过滤）log信息 。一般在如下几种情况会产生log文件 。

- 程序异常退出 ， uncaused exception
- 程序强制关闭 ，Force Closed (简称FC)
- 程序无响应 ， Application No Response （简称ANR) ， 顺便，一般主线程超过5秒么有处理就会ANR
- 手动生成 。

Log类的签名为“public final class Log extends Object”，用于在手动在控制台中打印日志，方便调试应用。常用的方法有以下5个：Log.v()、Log.d() 、Log.i()、Log.w() 以及 Log.e() 。根据首字母对应VERBOSE，DEBUG，INFO，WARN和ERROR。这5个方法的输出内容从多到少依次为：

1. static int	v(String tag, String msg)：输出颜色为黑色的，任何消息都会输出，这里的v代表verbose啰嗦的意思。平时使用就是Log.v("","")；　
2. static int	d(String tag, String msg)：输出颜色是蓝色的，仅输出调试信息，但也会输出Log.i、Log.w和Log.e的信息；
3. static int	i(String tag, String msg)：输出颜色为绿色，输出一般提示性的消息，它不会输出Log.v和Log.d的信息，但会显示i、w和e的信息；
4. static int	w(String tag, String msg)：输出颜色为橙色，输出警告信息，一般需要我们注意优化Android代码，同时选择它后还会输出Log.e的信息；
5. static int	e(String tag, String msg)：输出颜色为红色，输出错误信息，这里仅显示红色的错误信息，这些错误就需要我们认真的分析，查看栈的信息了。

除了在开发阶段以外，不能将Verbose编译到应用中。Debug可以编译进应用中，但会在运行时被剥离。而Error、Warning和information会被保留。

下面是一个在你的类中声明TAG常量的不错约定：

```java
private static final String TAG = "MyActivity";
```

然后就可以在上面的5中方法使用该TAG常量作为tag参数使用了。


