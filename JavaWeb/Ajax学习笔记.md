## Ajax学习笔记

### XMLHttpRequest 对象

XMLHttpRequest（XHR） 是 AJAX 的基础。所有现代浏览器（IE7+、Firefox、Chrome、Safari 以及 Opera）均均支持 XMLHttpRequest 对象（IE5 和 IE6 使用 ActiveXObject）。XMLHttpRequest 用于在后台与服务器交换数据,这意味着可以在不重新加载整个网页的情况下，对网页的某部分进行更新。

创建 XMLHttpRequest 对象的语法：

```javascript
variable=new XMLHttpRequest();
```

老版本的 Internet Explorer （IE5 和 IE6）使用 ActiveX 对象：

```javascript
variable=new ActiveXObject("Microsoft.XMLHTTP");
```

为了应对所有的现代浏览器，包括 IE5 和 IE6，请检查浏览器是否支持 XMLHttpRequest 对象。如果支持，则创建 XMLHttpRequest 对象。如果不支持，则创建 ActiveXObject ：

```javascript
var xmlhttp;
if (window.XMLHttpRequest)
  {// code for IE7+, Firefox, Chrome, Opera, Safari
  xmlhttp=new XMLHttpRequest();
  }
else
  {// code for IE6, IE5
  xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
  }
```

### 向服务器发送请求

如需将请求发送到服务器，可以使用 XMLHttpRequest 对象的 open() 和 send() 方法：

```javascript
xmlhttp.open("GET","test1.txt",true);
// send()方法用来执行发送请求的操作
xmlhttp.send();
```

`open(method, url, async)`：规定请求的类型、URL 以及是否异步处理请求。

- `method`：请求的类型，可指定为 GET 或 POST；

- `url`：文件在服务器上的位置。可以是任何类型的文件，比如 .txt 和 .xml，或者服务器脚本文件；

- `async`：true（异步）或 false（同步）。XMLHttpRequest 对象如果要用于 AJAX 的话，`async` 参数必须设置为 true。不推荐使用 async=false，但是对于一些小型的请求，也是可以的。请记住，JavaScript 会等到服务器响应就绪才继续执行。如果服务器繁忙或缓慢，应用程序会挂起或停止。当使用 async=false 时，请不要编写 `onreadystatechange` 函数 - 把代码放到 send() 语句后面即可：

  ```javascript
  xmlhttp.open("GET","test1.txt",false);
  xmlhttp.send();
  document.getElementById("myDiv").innerHTML=xmlhttp.responseText;
  ```

`send(string)`：将请求发送到服务器。`string` 参数仅用在发送 POST 请求时指定要发送的数据。

如果需要像 HTML 表单那样 POST 数据，请使用 setRequestHeader() 来添加 HTTP 头。然后在 send() 方法中规定您希望发送的数据：

```javascript
xmlhttp.open("POST","ajax_test.asp",true);
xmlhttp.setRequestHeader("Content-type","application/x-www-form-urlencoded");
xmlhttp.send("fname=Bill&lname=Gates");
```

`setRequestHeader(header,value)	` ：向请求添加 HTTP 头。

- `header`：规定头的名称；
- `value`：规定头的值。

### 服务器响应

如需获得来自服务器的响应，请使用 XMLHttpRequest 对象的 responseText 或 responseXML 属性。

- `responseText` ：如果来自服务器的响应不是 XML，就使用该属性返回字符串形式的响应，因此可以这样使用：

  ```javascript
  var xmlhttp=new XMLHttpRequest();
  xmlhttp.open("GET","/ajax/test1.txt",true);
  xmlhttp.send();

  document.getElementById("myDiv").innerHTML=xmlhttp.responseText;
  ```

- `    responseXML` ：如果来自服务器的响应是 XML，而且需要作为 XML 对象进行解析，就使用该属性。例如，请求 `books.xm`l 文件，并解析响应：

  ```javascript
  var xmlhttp=new XMLHttpRequest();
  xmlhttp.open("GET","/ajax/test1.txt",true);
  xmlhttp.send();

  var xmlDoc=xmlhttp.responseXML;
  txt="";
  var x=xmlDoc.getElementsByTagName("title");
  for (i=0;i<x.length;i++) {
    txt=txt + x[i].childNodes[0].nodeValue + "<br />";
  }
  document.getElementById("myDiv").innerHTML=txt;
  ```

### onreadystatechange 事件

当请求被发送到服务器时，需要执行一些基于响应的任务。每当 readyState 改变时，就会触发 onreadystatechange 事件。readyState 属性存有 XMLHttpRequest 的状态信息。

下面是 XMLHttpRequest 对象的三个重要的属性：

- `onreadystatechange` ：每当 readyState 属性改变时，就会触发该事件处理器；
- `readyState` ：表示 XMLHttpRequest 的请求状态。从 0 到 4 发生变化：
  - 0：请求未初始化；
  - 1：服务器连接已建立；
  - 2：请求已接收；
  - 3：请求处理中；
  - 4：请求已完成，且响应已就绪。
- `status` ：返回的http状态码。如 `200` 表示 `OK` ， `404` 表示找不到页面；
- `statusText` ：http状态码对应的提示信息，如 `OK` ，`NOT FOUND` 等。

> 在 onreadystatechange 事件中，规定当服务器响应已做好被处理的准备时所执行的任务。

当 `readyState` 等于 4 且状态为 200 时，表示响应已就绪：

```javascript
xmlhttp.onreadystatechange=function() {
	if (xmlhttp.readyState==4 && xmlhttp.status==200) {
    	document.getElementById("myDiv").innerHTML=xmlhttp.responseText;
    }
}
```

> onreadystatechange 事件被触发 5 次（0 - 4），对应着 readyState 的每个变化。

#### 使用 Callback 函数

`callback` 函数是一种将函数作为参数形式传递给另一个函数的函数。如果网站上存在多个 AJAX 任务，那么应该为创建 XMLHttpRequest 对象编写一个标准的函数，并为每个 AJAX 任务调用该函数。该函数调用应该包含 URL 以及发生 onreadystatechange 事件时执行的任务（每次调用可能不尽相同）：

```javascript
var xmlhttp;
function loadXMLDoc(url,cfunc) {
	if (window.XMLHttpRequest) {
  	// code for IE7+, Firefox, Chrome, Opera, Safari
  	xmlhttp=new XMLHttpRequest();
	} else {
  	// code for IE6, IE5
  	xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
	}
	xmlhttp.onreadystatechange=cfunc;
	xmlhttp.open("GET",url,true);
	xmlhttp.send();
}
function myFunction() {
loadXMLDoc("/ajax/test1.txt",function() {
  	if (xmlhttp.readyState==4 && xmlhttp.status==200) {
    	document.getElementById("myDiv").innerHTML=xmlhttp.responseText;
    }
});
```

### 请求实例

#### 客户端文件

当用户在输入框中键入字符时，在下方会出现提示，会执行函数 "showHint()" 。该函数由 "onkeyup" 事件触发：

```html
<form action=""> 
姓氏：<input type="text" id="txt1" onkeyup="showHint(this.value)" />
</form>
<p>建议：<span id="txtHint"></span></p> 
```

```javascript
function showHint(str) {
	var xmlhttp;
	if (str.length==0) {
  		document.getElementById("txtHint").innerHTML="";
  		return;
	}
	if (window.XMLHttpRequest) {
  		// code for IE7+, Firefox, Chrome, Opera, Safari
  		xmlhttp=new XMLHttpRequest();
  	} else {
    	// code for IE6, IE5
  		xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
  	}
	xmlhttp.onreadystatechange=function() {
  		if (xmlhttp.readyState==4 && xmlhttp.status==200) {
    		document.getElementById("txtHint").innerHTML=xmlhttp.responseText;
    	}
  	}
	xmlhttp.open("GET","gethint.asp?q="+str,true);
	xmlhttp.send();
}
```

#### 源代码解释

- 如果输入框为空 (str.length==0)，则该函数清空 txtHint 占位符的内容，并退出函数；
- 如果输入框不为空，showHint() 函数执行以下任务：
  - 创建 XMLHttpRequest 对象；
  - 当ASP服务器响应就绪时执行函数；
  - 把请求发送到服务器上的文件；
  - 请注意我们向 URL 添加了一个参数 q （带有输入框的内容）。

#### 服务器端ASP 文件

"gethint.asp" 中的源代码会检查一个名字数组，然后向浏览器返回相应的名字：

```asp
<%
response.expires=-1
dim a(30)
'用名字来填充数组
a(1)="Anna"
a(2)="Brittany"
a(3)="Cinderella"
a(4)="Diana"
a(5)="Eva"
a(6)="Fiona"
a(7)="Gunda"
a(8)="Hege"
a(9)="Inga"
a(10)="Johanna"
a(11)="Kitty"
a(12)="Linda"
a(13)="Nina"
a(14)="Ophelia"
a(15)="Petunia"
a(16)="Amanda"
a(17)="Raquel"
a(18)="Cindy"
a(19)="Doris"
a(20)="Eve"
a(21)="Evita"
a(22)="Sunniva"
a(23)="Tove"
a(24)="Unni"
a(25)="Violet"
a(26)="Liza"
a(27)="Elizabeth"
a(28)="Ellen"
a(29)="Wenche"
a(30)="Vicky"

'获得来自 URL 的 q 参数
q=ucase(request.querystring("q"))

'如果 q 大于 0，则查找数组中的所有提示
if len(q)>0 then
  hint=""
  for i=1 to 30
    if q=ucase(mid(a(i),1,len(q))) then
      if hint="" then
        hint=a(i)
      else
        hint=hint & " , " & a(i)
      end if
    end if
  next
end if

'如果未找到提示，则输出 "no suggestion"
'否则输出正确的值
if hint="" then
  response.write("no suggestion")
else
  response.write(hint)
end if
%>
```





