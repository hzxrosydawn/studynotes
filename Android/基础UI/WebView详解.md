[TOC]

### **网页视图**
[WebView](https://developer.android.com/reference/android/webkit/WebView.html)类继承自View类，可以开发网页来作为Activity布局的一部分。它没有网络浏览器应用中的如导航空间和地址栏等特性，WebView默认只显示一个网页。

![](https://developer.android.com/images/ui/webview-small.png)

图8. WebView显示效果

当需要在应用中提供需要更新的信息时（如终端用户协议或用户指南），使用WebView就很有用。可以创建一个包含WebView的Activity，然后用来显示网上的文档。

另一个场景就是，如果应用提供给用户的数据需要网络连接来获得数据（如邮件），你会发现在应用中建立一个WebView来显示网页要比执行一个网络请求，然后解析数据并表现在布局中来的更容易。你可以设计一个适应移动设备的网页，然后在应用中使用WebView来加载它。

**向应用中添加一个WebView**

要向应用添加WebView，将&lt;WebVIew>元素包含仅Activity的布局中即可。例如，这里有一个充满屏幕的WebView：
```xml
<?xml version="1.0" encoding="utf-8"?>
<WebView  xmlns:android="http://schemas.android.com/apk/res/android"
    android:id="@+id/webview"
    android:layout_width="fill_parent"
    android:layout_height="fill_parent"
/>
```
使用[loadUrl()](https://developer.android.com/reference/android/webkit/WebView.html#loadUrl(java.lang.String))来加载一个网页，例如：
```java
WebView myWebView = (WebView) findViewById(R.id.webview);
myWebView.loadUrl("http://www.example.com");
```
在这之前，应用必须有连接网络的权限，应在manifest.xml文件中添加网络权限：
```xml
<manifest ... >
    <uses-permission android:name="android.permission.INTERNET" />
    ...
</manifest>
```
**在WebView中使用JavaScript**

如果使用WebView加载的网页中使用了JavaScript，就必须在WebView中启用JavasScript。一旦开启JavaScript，就可以在应用代码和JavaScript之间创建接口。

WebView默认没有JavaScript，可以通过WebView所关联的[WebSettings](https://developer.android.com/reference/android/webkit/WebSettings.html)来启用它。可以通过[getSettings()](https://developer.android.com/reference/android/webkit/WebView.html#getSettings())方法来获得WebSettings，然后通过[setJavaScriptEnabled()](https://developer.android.com/reference/android/webkit/WebSettings.html#setJavaScriptEnabled(boolean))方法来启用JavaScript。例如：
```java
WebView myWebView = (WebView) findViewById(R.id.webview);
WebSettings webSettings = myWebView.getSettings();
webSettings.setJavaScriptEnabled(true);
```
WebSettings提供了大量你可能认为很有用的设置。比如，可以在使用WebView的网络应用中使用[setUserAgentString()](https://developer.android.com/reference/android/webkit/WebSettings.html#setUserAgentString(java.lang.String))定义一个用户代理字符串。然后访问自定义的用户代理来验证客户端请求来确实自你的应用。

**绑定JavaScript代码到Android代码**

开发使用WebView的网络应用时，可以在JavaScript代码和客户端Android代码之间开发接口。例如，JavaScript代码可以调用Android代码中的方法来显示一个对话框，而不是使用JavaScript的alert()函数。

通过调用[addJavascriptInterface()](https://developer.android.com/reference/android/webkit/WebView.html#addJavascriptInterface(java.lang.Object, java.lang.String))在JavaScript代码和客户端Android代码之间绑定一个接口，传给该方法一个类对象（来绑定到JavaScript）和一个接口名（JavaScript可以通过改接口来访问类）。例如，可以在Android应用中添加以下代码：
```java
public class WebAppInterface {
    Context mContext;

    /** Instantiate the interface and set the context */
    WebAppInterface(Context c) {
        mContext = c;
    }

    /** Show a toast from the web page */
    @JavascriptInterface
    public void showToast(String toast) {
        Toast.makeText(mContext, toast, Toast.LENGTH_SHORT).show();
    }
}
```
>注意：如果设置targetSdkVersion为17或更高，就必须为任何访问JavaScript的方法（必须为public）添加@JavascriptInterface注解，如果不添加该注解，就不能再 Android 4.2及以上版本中访问网页。

可以通过[addJavascriptInterface()](https://developer.android.com/reference/android/webkit/WebView.html#addJavascriptInterface(java.lang.Object,java.lang.String))把上面的WebAppInterface类绑定到运行在WebView中的JavaScript上，并将接口命名为Android。例如：
```java
WebView webView = (WebView) findViewById(R.id.webview);
webView.addJavascriptInterface(new WebAppInterface(this), "android");
```
这样就为WebView中的JavaScript创建了一个创建了一个名为android的接口。这时，应用就可以访问WebAppInterface类了。例如，下面的HTML和JavaScript代码使用新接口在用户点击按钮时创建一个toast消息：
```html
<input type="button" value="Say hello" onClick="showAndroidToast('Hello Android!')" />

<script type="text/javascript">
    function showAndroidToast(toast) {
        Android.showToast(toast);
    }
</script>
```
没必要在JavaScript端实现Android接口，WebView自动就可以访问网页了。点击了网页中的按钮之后，Android接口中的showAndroidToast()函数就会调用WebAppInterface.showToast()方法。

>注意：通过这种机制可以实现通过网页来控制应用，这样既有用有有风险，不要让应用访问不安全的网页。

**控制网页的打开行为**

当用户在WebView中的网页上点击一个链接时，默认使用外部的应用（通常是默认浏览器）来处理该链接。你可以为WebView重写该行为来在该WebView中打开点击的链接。可以根据WebView保存的网页历史来允许用户向前或向后导航。
通过[setWebViewClient()](https://developer.android.com/reference/android/webkit/WebView.html#setWebViewClient(android.webkit.WebViewClient))为WebView提供一个[WebViewClient](https://developer.android.com/reference/android/webkit/WebViewClient.html)来打开点击的链接。例如：
```java
WebView myWebView = (WebView) findViewById(R.id.webview);
myWebView.setWebViewClient(new WebViewClient());
```
这样就可以在WebVIew中打开点击的链接了。

如果需要在点击链接时提供更多的控制，通过重写[shouldOverrideUrlLoading()](https://developer.android.com/reference/android/webkit/WebViewClient.html#shouldOverrideUrlLoading(android.webkit.WebView,java.lang.String))来实现自己的WebViewClient类。例如：
```java
private class MyWebViewClient extends WebViewClient {
    @Override
    public boolean shouldOverrideUrlLoading(WebView view, String url) {
        if (Uri.parse(url).getHost().equals("www.example.com")) {
            // This is my web site, so do not override; let my WebView load the page
            return false;
        }
        // Otherwise, the link is not for a page on my site, so launch another Activity that handles URLs
        Intent intent = new Intent(Intent.ACTION_VIEW, Uri.parse(url));
        startActivity(intent);
        return true;
    }
}
```
然后为WebView提供一个新的WebViewClient实例：
```java
WebView myWebView = (WebView) findViewById(R.id.webview);
myWebView.setWebViewClient(new MyWebViewClient());
```
现在，当用户点击一个链接时，将按照上面重写的shouldOverrideUrlLoading()方法来处理链接。

**根据网页历史实现导航**

当WebView重写URL的加载后，它会自动累计访问的网页历史。可以通过[goBack()](https://developer.android.com/reference/android/webkit/WebView.html#goBack())和[goForward()](https://developer.android.com/reference/android/webkit/WebView.html#goForward())方法来后退和前进。下面的例子演示了如何让Activity使用设备的返回键来实现后退导航：
```java
@Override
public boolean onKeyDown(int keyCode, KeyEvent event) {
    // Check if the key event was the Back button and if there's history
    if ((keyCode == KeyEvent.KEYCODE_BACK) && myWebView.canGoBack()) {
        myWebView.goBack();
        return true;
    }
    // If it wasn't the Back key or there's no web page history, bubble up to the default
    // system behavior (probably exit the activity)
    return super.onKeyDown(keyCode, event);
}
```


