# JavaScript笔记

JavaScript 是互联网上最流行的脚本语言，可用于 HTML 和 Web，更可广泛用于服务器、PC、笔记本电脑、平板电脑和智能手机等设备。

## 嵌入方法

1. 使用**javasript:**前缀构建执行JavaScript代码的URL；
2. 将脚本放在 \<script> 与 \</script> 标签之间。

```html
<a href="javasript:alert('运行JavaScript！');">运行JavaScript</a>

<script> 
  alert("我的第一个 JavaScript");
</script>
```

\<script.../>标签包含的脚本可被放置在 HTML 页面的 \<body> 和 \<head> 部分中。**除非业务需求必须将JavaScript脚本放在指定位置，最佳的优化准则是将JavaScript放于body底部，这样可以加快网页加载的速度**。毕竟，加入页面都没加载出来，何谈交互呢？

> 注意：老旧的实例可能会在 <script> 标签中使用 type="text/javascript"。现在已经不必这样做了。JavaScript 是所有现代浏览器以及 HTML5 中的默认脚本语言。

## 显示数据

JavaScript 可以通过不同的方式来输出数据：

### 使用 **window.alert()** 弹出警告框

```html
<!DOCTYPE html>
<html>
<body>

<h1>我的第一个页面</h1>
<p>我的第一个段落。</p>

<script>
window.alert(5 + 6);
</script>

</body>
</html>
```

使用 document.write() 方法将内容写到 HTML 文档中

使用 **innerHTML** 写入到 HTML 元素

```html
<!DOCTYPE html>
<html>
<body>

<h1>我的第一个 Web 页面</h1>

<p id="demo">我的第一个段落</p>

<script>
document.getElementById("demo").innerHTML = "段落已修改。";
</script>

</body>
</html>
```



使用 **console.log()** 写入到浏览器的控制台

## 变量

JavaScript是弱类型的语言，**使用变量之前无须定义，想使用某个变量直接使用即可**。

### 定义变量

**隐式定义变量**：**直接给某个变量名赋值**。如：

```html
<script type="text/javascript"> 
   // 隐式定义变量a 
   a = "Hello JavaSricpt!"; 
   // 使用警告对话框输出a的值 
   alert(a); 
</script>
```

**显示定义变量**：**使用var关键字显式定义变量**。**显式定义变量时如果不为其指定初始值，则该变量的类型是不确定的，第一次给变量赋值后变量的类型才确定下来，使用过程中该变量的值也可以随意改变**。如：

```html
<script type="text/javascript">
	//显式声明变量a
	var a ;
	//给变量a赋值，赋值后a的数据类型为布尔型
	a = true;
	//使用警告对话框输出a的值
	alert(a);
</script>
```

> 注意：**JavaScript变量是区分大小写的**。

### 变量分类

- **全局变量：方法外定义的变量，整个JavaScript中有效**；
- **局部变量：方法里定义的变量，整个方法中有效**。

### 使用变量

**如果局部变量与全局变量同名，则局部变量会覆盖全局变量，且全局变量的作用范围对于执行HTML事件处理同样有效**。

```html
<!DOCTYPE html>
<html>
<head>
	<meta name="author" content="Yeeku.H.Lee(CrazyIt.org)" />
	<meta http-equiv="Content-Type" content="text/html; charset=GBK" />
	<title> 事件处理中的局部变量和全局变量 </title>
	<script type="text/javascript">
		//定义全局变量
		var x="全局变量";
	</script>
</head>
<body>
	<!-- 在onclick事件中重新定义了x局部变量变量 -->
	<input type="button" value="局部变量" 
           onclick="var x='局部变量'; alert('输出x局部变量的值：' + x);"/>
	<!-- 直接输出全局变量x的值 -->
	<input type="button" value="全局变量 "
           onclick="alert('输出x全局变量的值： ' + x);" />
</body>
</html>
```

定义变量时使用var和不使用var是有区别的。下面的两个实例只差一个var关键字但结果却大不相同：

```html
<script type="text/javascript">
	// 定义全局变量
	var scope = "全局变量";
	function test() {
		// 局部变量scope定义在后面，那么全局变量被局部变量覆盖
		// 而下行的scope局部变量尚未赋值，故此处输出undefined
		document.writeln(scope + "<br />");
		// 定义scope的局部变量，其作用范围为整个函数内
		var scope = "局部变量";
		// 再次输出scope的值为“局部变量”
		document.writeln(scope + "<br />");
	}
	test();
</script>
```

```html
<script type="text/javascript">
	// 定义全局变量
	var scope = "全局变量";
	function test() {
		// 在该方法内找不到scope的定义，
      	// 所以这里的scope没有被覆盖，是全局变量
      	// 故此处输出“全局变量”
      	document.writeln(scope + "<br />");
		// 再次为全局变量赋值
		scope = "局部变量";
		// 再次输出scope的值为新赋的值“局部变量”
		document.writeln(scope + "<br />");
	}
	test();
</script>
```

**JavaScript中变量没有块的范围，即代码块中的变量出了代码块依旧可用**。如：

```html
<script type="text/javascript">
	function test(o){
		// 定义变量i，变量i的作用范围是整个函数
		var i = 0;
		if (typeof o == "object") {
			// 定义变量j，变量j的作用范围是整个函数内，而不仅仅是在if块内。
			var j = 5;
			for(var k = 0; k < 10; k++) {
				// 因为JavaScript没有代码块范围
				// 所以k的作用范围是整个函数内，而不是循环体内
				document.write(k);
			}
		}
		// 即使出了循环体，k的值依然存在
		// 下面输出“10 5”
		alert(k + " " + j);
	}
	test(document);
</script>
```

## 基本数据类型

JavaScript基本数据类型如下：

- 数值型(Number)
- 字符串类型（String）
- 布尔(Boolean)
- 未定义（Undefined）和空（Null）

JavaScript 拥有**动态类型**。这意味着**相同的变量可用作不同的类型**。如：

```javascript
var x;               // x 为 undefined
var x = 5;           // 现在 x 为数字
var x = "John";      // 现在 x 为字符串
```

### 数值类型

JavaScript的数值类型**包括所有整数值和浮点值**。

- 支持科学计数法，用于表示极大或极小的数字。形如“5E2”或“3e8”，e和E不区分大小写；
- 小数可以省略小数点前的0：如0.314可以写成“.314”；
- JavaScript支持八进制（以0开头，慎用，不是所有浏览器都支持八进制）和十六进制（以0x或0X开头）。

JavaScript的特殊数值有三个：最大数值、最小数值、Infinity、-Infinity和NaN。这些特殊值可通过JavaScript提供的内嵌类Number来访问：

- Number.MAX_VALUE
- Number.MIN_VALUE
- Number.POSITIVE_INFINITY
- Number.NEGTIVE_INFINITY
- Number.NaN

当数值变量超出其表数范围时会出现Infinity（正无穷大，可以由正数除以0得到），-Infinity（负无穷大，可以由负数除以0得到） ，NaN（Not a number，表示非数，可以通过0/0得到）。特殊值得使用注意以下几点：

- Infinity和-Infinity 与其他任何数值进行运算时，整个算术表达式将会变成NaN，Infinity和-Infinity运算的结果也是NaN；
- Infinity和Infinity总是相等的，-Infinity和-Infinity也总是相等的，不管他们的实际值是多少；
- NaN和任何数都不相等，包括它自己，JavaScript提供了isNaN()函数来判断一个数是否为NaN。

```html
<script type="text/javascript">
	// 定义y为JavaScript支持的最小数值
	var y = -1.7976931348623157e308;
  	// 再次减少y的值
	y = y - 1e292;
	// y的值输出为-Infinity
	alert(y);
	// Infinity、-Infinity和任何数运算都是NaN
	alert(y + 3E3000);
	// 定义a为Infinity
	a = Number.POSITIVE_INFINITY;
	// 定义b为-Infinity
	b = Number.NEGATIVE_INFINITY;
	// Infinity和-Infinity运算也是NaN
	alert(a + b);
  	// 定义x的值为NaN
	var x = 0 / 0; 
	// 两个NaN是不相等的
	if (x != x) {
		alert("NaN不等于NaN");
	}
	// 调用isNaN判断变量
	if (isNaN(x)) {
		alert("x是一个NaN");
	}
</script>
```

> 注意：JavaScript中的浮点值计算存在丢失精度的问题，其他编程语言也是这样。建议比较计算后的浮点数大小时使用**差值比较法**。

### 字符串类型

JavaScript**通过内建类String来表示和操作字符串。字符串一般为使用单引号或双引号括起来的文本，包括单个字符**。String类常用的方法如下：

- String()：构建一个字符串；
- charAt()：返回指定索引处的值；
- charCodeAt()：返回指定索引处的Unicode值；
- length：长度属性，为一个整数值；
- toUpCase()：全部转为大写；
- toLowerCase()：全部转为小写；
- fromCharCode()：**静态方法，通过String类调用**。将一系列Unicode值转换为字符串；
- indexOf(searchString [, startIndex])：返回特定字符串的第一次出现的索引位置；
- lastIndexOf(searchString [, startIndex])：返回特定字符串最后一次出现的位置；
- subString（from [, to]）：返回该字符串的某个子字符串（包前不包后）；
- slice()：同subString()方法，但支持负参数（负数表示从最右边开始，最右边初始索引为-1）；
- search()：使用正则表达式搜索目标子字符串。返回匹配字符串索引的整数值或-1；
- match()：使用正则表达式搜索目标子字符串。返回所有匹配的子字符串构成的数组或null，通过在正则表达式末尾加字符“g”表示支持全局匹配；
- concat()：将多个字符串拼接成一个字符串；
- replace()：将字符串中的某个子字符串以特定字符串替换。支持正则表达式。

```html
<script type="text/javascript">
	// 定义字符串s的值
	var s = "abfd--abc@d.comcdefg";
	// 从s中匹配正则表达式
	a = s.search(/[a-z]+@d.[a-zA-Z]{2}m/);
	// 定义字符串变量str
	var str = "1dfd2dfs3df5";
	// 查找字符串中所有单个的数值
	var b = str.match(/\d/g);
	// 输出a和b的值
	alert(a + "\n" + b);
</script>
```

> 注意：
>
> - 字符串的比较通过==即可，不用使用equals()方法；
> - JavaScript中的**正则表达式必须放在两个“/”之间，外面不用加引号**。

### 布尔类型

布尔类型只能有两个值：true 或 false。布尔常用在条件测试中。

### Undefined 和 Null

**Undefined 这个值表示变量不含有值。而null可以用来赋值给某个变量从而将该变量的值清空**。

## 复合类型

### 对象

对象是**一系列命名变量和函数的组合**。其中命名变量的类型既可以是基本数据类型，也可以是复合类型，**命名变量称为属性，对象中的函数称为方法，对象通过“.”来访问属性和方法**。

JavaScript是**基于对象**的，包含以下内置对象：

- Object：对象类；
- Array：数组类；
- Date：日期类；
- Error：错误类；
- Function：函数类；
- Math：数学类。该对象包含许多算术运算的方法；
- Number：数值类；String：字符串类。

### 数组

定义有三种形式：

```javascript
var a = [3, 5, 23];
var b =[];
var c = new Array();
```

JavaScript**数组包含一个length属性**，JavaScript中数组索引从0开始。**JavaScript中数组元素可以为不同类型，数组长度也可以随时变化**。另外，JavaScript中**访问数组元素不会发生越界错误，越界值为undefined**。

### 函数

**函数是JavaScript中的另一种复合类型，可以独立存在**。后面详细介绍函数。函数**使用function关键字声明**，可以包含一段可执行代码，也可以接收调用者作为参数，**参数列表不需要类型声明、也不需要声明返回值的类型**。如：

```javascript
function functionName(param1, param2,...) {
  // 可执行代码
}
```

由于不用指定参数类型，**为了避免传入错误类型的参数，应使用typeof运算符判断一个变量的类型，该运算符返回描述变量的类型的字符串。typeof也可以当成函数使用，如typeof(a)**。如：

```javascript
function judgeAge(age) {
    // 要求age参数必须为数值
    if (typeof age == "number") {
        if(age > 60) {
            alert("老人");
        }
    }
}
```

## 运算符

JavaScript的运算符多数与Java相同，也有一些特殊的运算符：

- typeof运算符和instanceof运算符，两者功能类似；
- 逗号运算符：作为多个表达式的分隔符，返回最右边的表达式的值；
- void运算符：强制不返回任何值。

```html
<script type="text/javascript">
	// 声明变量a,b,c,d。
	var a , b , c , d;
	// 虽然最右边的表达式为56，
	// 但由于使用了void强制取消返回值，因此a的值为undefined。
	a = void(b = 5, c = 7, d = 56);
	// 输出：a = undefined b = 5 c = 7 d =  56
	document.write('a = ' + a + ' b = ' + b + ' c = ' + c + ' d = ' + d);
  	// 如果上面不使用void运算符
	// 则输出：a = 56 b = 5 c = 7 d =  56
</script>
```

## 语句

JavaScript中有些语句与Java不同。

### 异常语句

JavaScript中的**所有异常都是Error对象，Error对象总是通过throw关键字手动抛出**：

```javascript
throw new Error(errorString);
```

一旦出现异常，立即寻找对应的try-catch块来捕获异常，如果没有对应的异常捕捉块，则异常会传给浏览器，程序非正常终止。如Java类似，**JavaScript的try-catch块后面也可以添加finally块，一旦指定finally块，finally块总会获得执行的机会**。如：

```html
<script type="text/javascript">
	try	{
		for (var i = 0 ; i < 10 ; i++){
			// 在页面输出i值
			document.writeln(i + '<br />');
			// 当i大于4时，抛出异常
			if (i > 4) 
				throw new Error('用户自定义错误');
		}
	}
	// 如果try块中的代码出现异常，自动跳转到catch块执行
	catch (e){
		document.writeln('系统出现异常' + e.message + '<br/>');
	}
	// finally块的代码总可以获得执行的机会
	finally	{
		document.writeln('系统的finally块');
	}
</script>
```

> 注意：
>
> - JavaScript中的异常机制中**不用在函数声明时抛出异常，故没有throws关键字**；
> - try块后**最多只能由一个catch块**；
> - **通过异常对象的message属性即可访问异常对象的描述信息**。

### with语句

with语句主要用于避免多次重复输入同一个对象。with语句语法如下：

```javascript
with(object) {
  // 不含调用者（object）的多条执行语句
}
```

```javascript
document.writeln("Hello<br />");
document.writeln("World<br />");
document.writeln("JavaScript<br />");
```

上面的一段JavaScript代码与下面的with语句效果相同：

```javascript
with(document) {
  writeln("Hello<br />");
  writeln("World<br />");
  writeln("JavaScript<br />");
}
```

## 流程控制

JavaScript的流程控制与Java等语言基本相同，包括if、switch、while、do-while、for等循环体，以及可结合标签的break、continue跳转关键字。

相比Java等语言，**JavaScript有一种for-in循环，主要用于遍历数组中的所有元素，遍历对象中的所有属性**。语法如下：

```javascript
for (index in object) {
  statement...
}
```

遍历数组时循环计数器是数组的索引值：

```html
<script type="text/javascript">
	// 定义数组
	var a = ['hello' , 'javascript' , 'world'];
	// 遍历数组的每个元素
	for (str in a)
		document.writeln('索引' + str + '的值是:' + a[str] + "<br />" );
</script>
```

输出结果如下：

```shell
索引0的值是:hello
索引1的值是:javascript
索引2的值是:world
```

遍历对象时，循环计数器是该对象的属性值：

```html
<script type="text/javascript">
	// 在页面输出静态文本
	document.write("<h1>Navigator对象的全部属性如下：</h1>");
	// 遍历navigator对象的所有属性
	for (propName in navigator)	{
		// 输出navigator对象的所有属性名，以及对应的属性值
		document.write('属性' + propName + '的值是：' + navigator[propName]);
		document.write("<br />");
	}
</script>
```

输出如下：

```shell
Navigator对象的全部属性如下：
属性temporaryStorage的值是：[object DeprecatedStorageQuota]
属性persistentStorage的值是：[object DeprecatedStorageQuota]
属性vendorSub的值是：
...
```

## 函数

**JavaScript通过函数实现代码的复用，函数也是JavaScript的“一等公民’”，可以独立存在**。

### 定义函数的三种方式

#### 定义命名函数

定义命名函数语法如下：

```javascript
function functionName(parameter-list) {
  // 执行代码
}
```

定义并调用一个简单函数实的实例：

```html
<script type="text/javascript">
	hello('屌丝');
	// 定义函数hello，该函数需要一个参数
	function hello(name) {
		alert(name + "，你好");
	}
</script>
```

**在同一个<script.../>元素中，JavaScript允许先调用函数再定义该函数，但在不同<script.../>元素中，必须先定义函数，再调用函数，即在后面的<script.../>元素中可以使用前面<script.../>元素定义的函数**。

**函数可以有返回值（在函数体中通过return语句返回其返回值），也可以没有返回值。不管有没有返回值，函数声明中都没有返回类型**。

#### 定义匿名函数

JavaScript提供了另一种定义函数的方式——匿名函数，语法如下：

```javascript
function(parameter-list) {
  // 执行代码
};
```

定义匿名函数**无须指定函数名**，而是将**参数列表紧跟function关键字**，函数体后面还有一个**英文分号（;）**。

这种语法定义的函数，实际上也定义了一个函数对象（Function实例），接下来可以将这个对象赋值给另一个变量。如：

````html
<script type="text/javascript">
	var f = function(name) {
		document.writeln('匿名函数<br />');
		document.writeln('你好' + name);
	};
	f('屌丝');
</script>
````

**匿名函数的语法具有非常好的可读性，建议优先使用这种方式定义函数**。

#### 使用Function类匿名函数

JavaScript提供的**Function类也可以用来定义函数。Function类的构造器的参数个数不受限制，可以接受一系列字符参数，其中最后一个字符参数是函数的执行体，其中最后一个字符参数是执行体，执行体中的每条语句使用英文分号“;’”分隔，而前面的字符参数都是函数的参数**。如：

````html
<script type="text/javascript">
	// 定义匿名函数，并将函数赋给变量f
	var f = new Function('name', 
              	"document.writeln('Function定义的函数<br />');"	+ 
       			"document.writeln('你好' + name);");
	// 通过变量调用匿名函数
	f('屌丝');
</script>
````

这种语法的函数执行体阅读性很差，不建议使用。

### 局部函数

如局部变量一样，**定义在函数中的函数称为局部函数，局部函数不能在其外部函数之外调用，只有当其外部函数执行时，它才有被执行的机会**。实例如下：

```html
<script type="text/javascript">
	//定义全局函数
	function outer() {
		//定义第一个局部函数
		function inner1() {
			document.write("局部函数11111<br />");
		}
		//定义第二个局部函数
		function inner2() {
			document.write("局部函数22222<br />");  
		}
		document.write("开始测试局部函数...<br />");
		//在浏览器中调用第一个局部函数
		inner1();
		//在浏览器中调用第二个局部函数
		inner2();
		document.write("结束测试局部函数...<br />");
	}
	document.write("调用outer之前...<br />");
	//调用全局函数
	outer();
	//在外部函数之外的地方调用局部函数会出错
	inner1();
	document.write("调用outer之后...<br />");
</script>
```

### 函数、方法。对象和类

在JavaScript中定义一个函数之后，可以得到以下4项：

- **函数**：就像Java的方法，函数可以被调用；
- **对象**：定义了一个函数，系统也会创建一个Function类的实例对象；
- **方法**：**定义了一个函数之后，该函数通常会附加给某个对象，作为该对象的方法。如果没有明确将该函数附加到哪个对象上，该函数会默认附加到window对象上，作为window对象的方法**；
- **类**：定义函数的同时也得到了一个与函数同名的类，该函数也是该类的唯一构造器。

定义函数之后，调用函数的方式有以下两种：

- 直接调用函数：这种方式总是返回函数中return语句的返回值，如果没有return语句，则直接调用函数就不返回任何值；
- **使用new关键字调用函数：这种方式调用函数总有一个返回值，返回值就是一个JavaScript对象**。

```html
<script type="text/javascript">
	// 定义了一个函数，该函数也是一个类
	function Person(name , age)	{
		// 将参数name的值赋给name属性
		this.name = name;
		// 将参数age的值赋给age属性
		this.age = age;
		// 为函数分配info方法，使用匿名函数来定义方法
		this.info = function() {
			document.writeln("我是：" + this.name + "<br />");
			document.writeln("我今年：" + this.age + "岁" + <br />");
		};
	}
	// 创建p对象
	var p = new Person('屌丝' , 29);
	// 执行info方法
	p.info();
</script>
```

### 函数的实例属性和类属性

JavaScript函数中除了局部变量，还有实例属性和类属性。

- 局部变量：在函数中通过var关键字或不加任何前缀来声明；
- **实例属性：在函数中以this前缀作为修饰**；
- **类属性：在函数中以函数名作为前缀修饰**。

实例属性和类属性是面向对象的概念。

- **实例属性属于单个对象，必须由对象来调用，而类属性属于类（即函数）本身，必须通过类来访问。通过对象访问类属性将返回undefined**；
- 同一个类（即函数）只占用一块内存，因此每个类属性将只占用一块内存。同一个类每创建一个对象，系统将为该对象的每个实例属性分配一块内存；
- JavaScript是一种动态语言，**可随时为对象增加属性和方法。当直接为对象的某个不存在的属性赋值时，即可视为给对象增加属性**。

```html
<script type="text/javascript">
	// 定义函数Person
	function Person(national, age) {
		// this修饰的变量为实例属性
		this.age = age;
		// Person修饰的变量为类属性
		Person.national =national;
		// 以var定义的变量为局部变量
		var bb = 0;
	}
	// 创建Person的第一个对象p1。国籍为中国，年纪为29
	var p1 = new Person('中国' , 29);
	document.writeln("创建第一个Person对象<br />");
	// 输出第一个对象p1的年纪和国籍
	document.writeln("p1的age属性为" + p1.age + "<br />");
	document.writeln("p1的national属性为" + p1.national + "<br />");
	document.writeln("通过Person访问静态national属性为" 
		+ Person.national + "<br />");
	// p1没有的bb属性，下面输出undefined
	document.writeln("p1的gender属性为" + p1.gender + "<br />");
  	// 为对象不存在的属性赋值，相当于为该对象增加这个属性
  	p1.gender = "male";
  	document.writeln("添加gender属性后，p1的gender属性为" + p1.gender + "<br />");
	// 创建Person的第二个对象p2
	var p2 = new Person('美国' , 32);
	document.writeln("创建两个Person对象之后<br />"); 
	// 再次输出p1的年纪和国籍
	document.writeln("p1的age属性为" + p1.age + "<br />");
	document.writeln("p1的national属性为" + p1.national + "<br />");
	// 输出p2的年纪和国籍
	document.writeln("p2的age属性为" + p2.age + "<br />");
	document.writeln("p2的national属性为" + p2.national + "<br />");
	// 通过类名访问类属性
	document.writeln("通过Person访问静态national属性为"
		+ Person.national + "<br />");
</script>
```

输出结果如下：

```shell
创建第一个Person对象
p1的age属性为29
p1的national属性为undefined
通过Person访问静态national属性为中国
p1的gender属性为undefined
添加gender属性后，p1的gender属性为male
创建两个Person对象之后
p1的age属性为29
p1的national属性为undefined
p2的age属性为32
p2的national属性为undefined
通过Person访问静态national属性为美国
```

### 调用函数的三种方式

#### 直接调用函数

直接调用函数直接以函数附加的对象作为调用者，在函数后的括号内传入参数来调用函数。这种调用最为常见和简单。如：

```javascript
window.alert("测试代码");
p.walk();
```

#### 以call()方法调用函数

有时候在调用函数时需要动态传入一个函数引用，这时候就需要使用call()方法来动态调用函数了。如：

```html
<script type="text/javascript">
	// 定义一个each函数
	var each = function(array , fn) {
		for(var index in array)	{
			// 以window为调用者来调用fn函数，
			// index、array[index]是传给fn函数的参数
			fn.call(null , index , array[index]);
		}
	}
	// 调用each函数，第一个参数是数组，第二个参数是函数
	each([4, 20 , 3] , function(index , ele) {
		document.write("第" + index + "个元素是：" + ele + "<br />");
	});
</script>
```

通过call()调用函数的语法如下：

```javascript
函数引用.call(调用者, 参数1, 参数2...);
```

上面的call()调用与直接调用的关系为：

```javascript
调用者.函数(参数1, 参数2...) = 函数引用.call(调用者, 参数1, 参数2...)
```

> 在JavaScript严格模式(strict mode)下, 在调用函数时第一个参数会成**this**的值， 即使该参数不是一个对象。在JavaScript非严格模式(non-strict mode)下, 如果第一个参数的值是null或undefined, 它将使用全局对象替代。

#### 以apply()方法调用函数

apply()方法与call()方法基本功能相似，区别如下：

- 通过call()调用函数时必须在括号中详细列出每个参数；
- 通过apply()动态地调用函数时，可以在括号以arguments来代表全部参数，arguments相当于一个数组。

```html
<script type="text/javascript">
	// 定义一个函数
	var myfun = function(a, b) {
		alert("a的值是：" + a + "\nb的值是：" + b);
	}
	// 以call()方法动态地调用函数
	myfun.call(window, 12, 23);
	var example = function(num1, num2) {
		// 直接用arguments代表调用example函数时传入的所有参数
		myfun.apply(this, arguments);
	}
	example(20, 40);
	// 为apply()动态调用传入数组
	myfun.apply(window, [12, 23]);
</script>
```

当函数没有被自身的对象调用时， this的值就会变成全局对象。在web浏览器中全局对象是浏览器窗口（window对象）。上面实例中example函数调用时没有指定对象，所以该实例中的this在调用时指的是window对象。

> 注意：使用window对象作为一个变量容易造成程序崩溃。

### 函数的独立性

**虽然可以将函数定义成某个类或某个对象的方法，但函数时JavaScript的“一等公民”，它永远是独立的。函数不会固定从属于某一个类或对象**。看下面的实例：

```html
<script type="text/javascript">
	function Person(name){
		this.name = name;
		// 定义一个info方法
		this.info = function(){
			alert("我的name是：" + this.name);
		}
	}
	var p = new Person("屌丝");
	// 调用p对象的info方法
	p.info();
	var name = "测试名称";
	// 以window对象作为调用者来调用p对象的info方法
	p.info.call(window);
</script>
```

控制台输出结果如下：

```shell
我的name是：屌丝
我的name是：测试名称
```

**函数（包括匿名的内嵌函数）从来不是依附于某个特定类或对象的，它可以被分离出来单独使用，也可以称为另一对象的函数**。所以当上面实例中info()方法的调用者为window时输出的是window的name变量的值（测试名称）。

### 函数的参数处理

像Java一样，**JavaScript的参数传递也全部采用的是按值传递的方式**。

**JavaScript中没有函数重载。如果先后定义了两个同名函数，他们的形参列表并不相同，这不是函数重载，而是后面的函数覆盖前面的函数**。

```html
<script type="text/javascript">
	function test() {
		alert("第一个无参数的test函数");
	}
	// 后面定义的函数将会覆盖前面定义的函数
	function test(name) {
		alert("第二个带name参数的test函数：" + name);
	}
	// 即使不传入参数，程序依然调用带一个参数的test函数。
	test();
</script>
```

**如所有弱类型的编程语言一样，JavaScript的参数列表无须类型声明，这就需要在函数调用的时候必须手动判断传入的参数类型、以及参数是否包含了需要访问的属性和方法，之后才能进行进行相关操作**（即**[鸭子类型](http://baike.baidu.com/link?url=sQh2f_830O592B-q521NCyJDP-yG6jEUqC54xLDNkkIiqheRzf3rF1MA97ruH3NAPrJ9h29NrUcEV_jK0u3JKfa8KmQ2BjfrmReUAlhKZgKpHQwuQWRAnstoED0G3DCN)**的判断）。

```html
<script type="text/javascript">
	// 定义函数changeAge,函数需要一个参数
	function changeAge(person) {
		// 首先要求person必须是对象，而且person的age属性为number
		if (typeof person == 'object' 
			&& typeof person.age == 'number'){
			//执行函数所需的逻辑操作
			document.write("函数执行前person的Age值为：" 
				+ person.age + "<br />");
			person.age = 10;
			document.write("函数执行中person的Age值为：" 
				+ person.age + "<br />");
		}
		// 否则将输出提示，参数类型不符合
		else {
			document.writeln("参数类型不符合" +
				typeof person + "<br />");
		}
	}
	// 分别采用不同方式调用函数
	changeAge();
	changeAge('xxx');
	changeAge(true);
	// 采用JSON语法创建第一个对象
	p = {abc : 34};
	changeAge(p);
	// 采用JSON语法创建第二个对象
	person = {age : 25};
	changeAge(person);
</script>
```

### 使用对象

JavaScript没有提供完善的继承语法，所以JavaScript中定义的类没有父子关系，但这些类都是Object类的子类。JavaScript通过提供一些内建类来方便地创建各自的对象。

JavaScript中的对象本质上是一个关联数组，或者说更像Java中的Map数据结构，有一组key-value对组成，只是JavaScript对象的value不仅可以是值，还可以是函数，此时该函数就是该对象的方法。当value是基本类型的值或复合类型的值时，此时的value就是该对象的属性值。

**当需要访问某个对象的属性时，不仅可以使用obj.propName的形式，也可以采用obj[propName]的形式，有时候必须得是这种形式**。

JavaScript是一种动态语言，可以自由地为对象增加一些属性和方法，当程序为对象某个不存的属性赋值时，即可认为是为该对象增加属性。如果某个属性值是函数时，即可认为该属性变成了方法。如：

```html
<script type="text/javascript">
	// 创建Person函数
	function Person(name, age)	{
		this.name = name;
		this.age = age;
		// 为Person对象指定info方法
		this.info = function() {
			//输出Person实例的name和age属性
			document.writeln("姓名：" + this.name);
			document.writeln("年龄：" + this.age);
		}
	}
	// 创建Person实例p1
	var p1 = new Person('diaosi', 29);
    for (propName in p1) {
		// 遍历Person对象的属性
		document.writeln('p1对象的' + propName + "属性值为：" + p[propName] + "<br />");
	}
	// 执行p1的info方法
	p1.info();
	document.writeln("<hr />");
	// 创建Person实例p2
	var p2 = new Person('baifumei' , 20);
	// 执行p2的info方法
	p2.info();
</script>
```

上面为Person类增加info()方法的方式很不好：

- 性能低下：每次创建Person实例时，都会创建一个新的info函数，多个Person对象就需要创建多个info函数。这就会造成系统泄露，从而引起性能下降。实际上，info函数只需要一个就够了；
- 使得info函数中的局部变量**产生闭包**：闭包即扩大了局部变量的作用范围（应该是局部变量仅在其函数中有效），使得局部变量一直存活到函数之外的地方。

```html
<script type="text/javascript">
	// 创建Person函数
	function Person() {
		// locVal是个局部变量，原本应该该函数结束后立即失效
		var locVal = '漏网之鱼';
      	// 当然下面语句也可以使用有名称的方法
      	// this.info = function abc() {
		this.info = function() {
			// 此处会形成闭包
			document.writeln("locVal的值为：" + locVal);
			return locVal;
		}
	}
	var p = new Person();
	// 调用p对象的info()方法
	var val = p.info();
  	// 就算出了函数，由于闭包，局部变量依然可以访问
	// 输出val返回值，该返回值就是局部变量locVal
	alert(val);
</script>

```

通常不建议在函数定义（即类定义）中直接为该函数定义方法，而是建议使用prototype属性。JavaScript的所有类（即函数）都有一个prototype属性，当为JavaScript类的prototype属性增加函数、属性时，则可视为是对原有类型的扩展。这就是JavaScript的伪继承继承机制。

```html
<script type="text/javascript">
	// 定义一个Person函数，同时也定义了Person类
	function Person(name , age)	{
		// 将局部变量name、age赋值给实例属性name、age
		this.name = name;
		this.age = age;
		// 使用内嵌的函数定义了Person类的方法
		this.info = function()	{
			document.writeln("姓名：" + this.name + "<br />");
			document.writeln("年龄：" + this.age + "<br />");
		}
	}
	// 创建Person的实例p1
	var p1 = new Person('李小璐' , 29);
	// 执行Person的info方法
	p1.info();
	// 此处不可调用walk方法，变量p还没有walk方法
	// 将walk方法增加到Person的prototype属性上
	Person.prototype.couple = function(couple)	{
		document.writeln(this.name + couple +'<br />');
	}
	document.writeln('<br />');
	// 创建Person的实例p2
	var p2 = new Person('高圆圆' , 30);
	// 执行p2的info方法
	p2.info();
	document.writeln('<br />');
	// 执行p2的couple方法
	p2.couple('赵又廷了');
	// 此时p1也具有了couple方法——JavaScript允许为类动态增加方法和属性
	// 执行p1的couple方法
	p1.couple('贾乃亮了');
</script>
```

输出如下：

```shell
姓名：李小璐
年龄：29

姓名：高圆圆
年龄：30

高圆圆赵又廷了
李小璐贾乃亮了
```

**这种伪继承实质上是修改了原来的类，并不是产生了一个新的子类**。因此上面实例中原来没有couple方法的Person类将不复存在。JavaScript的内建类也可以通过prototype属性进行扩展。

虽然**任何时候都可以为一个类增加属性和方法，但通常建议在类定义结束以后立即增加该类所需的方法，这样可以避免造成不必要的混乱**。

### 创建对象

JavaScript中创建对象可以不使用任何类。JavaScript中创建对象大致有三种方式。

#### 使用new关键字调用构造器创建对象

JavaScript中所有的函数都可以作为构造器使用，使用new调用函数后总可以返回一个对象。如：

```html
<script type="text/javascript">
	// 定义一个函数，同时也定义了一个Person类
	function Person(name, age)	{
		//将name、age形参赋值给name、age实例属性
		this.name = name;
		this.age = age;
	}
	// 分别以两种方式创建Person实例
  	// 如果调用有参函数时没有传入参数，则该实例中对应的参数的值都未初始化，都是undefined
	var p1 = new Person();
	var p2 = new Person('diaosi', 29);
	// 输出p1的属性:undefined undefined
	document.writeln("p1的属性如下:"	+ p1.name + " " + p1.age + "<br />");
	// 输出p2的属性:diaosi 29
	document.writeln("p2的属性如下:" + p2.name +  " " + p2.age);
</script>
```

#### 使用Object直接创建对象

JavaScript的对象都是Object类的子类，因此可以采用如下方法创建对象：

```javascript
// 创建一个默认对象
var myObj = new Object();
```

上面的语句创建了一个不含任何属性和方法的空对象，但由于JavaScript是动态的，可以后续为该对象动态地增加属性和方法。如：

```html
<script type="text/javascript">
	// 创建空对象
	var myObj = new Object();
	// 增加属性
	myObj.name = 'diaosi';
	// 增加属性
	myObj.age = 29;
	// 输出对象的两个属性
	document.writeln(myObj.name + myObj.age);
</script>
```

从上面实例中为对象赋值的语句可以看出，JavaScript对象实质上就是一个关联数组。

JavaScript也允许将一个已有的函数添加为对象的方法。如：

```html
<script type="text/javascript">
	// 创建空对象
	var myObj = new Object();
	// 为空对象增加属性
	myObj.name = 'diaosi';
	myObj.age = 29;
	// 创建一个函数
	function abc() {
		document.writeln("对象的name属性:" + this.name);
		document.writeln("<br />");
		document.writeln("对象的age属性:" + this.age);
	};
	// 将已有的函数添加为对象的方法，不能添加括号，否则变成了函数调用
	myObj.info = abc;
	document.writeln("<br />");
	// 调用方法
	myObj.info();
</script>
```

> 注意：将已有函数添加为对象方法时，不能在函数名后添加括号。一旦添加了括号，就变成了函数调用，而不再是将函数本身赋给对象的方法，而是将函数的返回值赋给对象的属性。

#### 使用JSON语法创建对象

JSON（JavaScript Object Nation）语法提供了一种更简单的方式来创建对象，可以避免书写函数，

























只能在 HTML 输出流中使用 **document.write**。 如果您在文档已加载后使用它（比如在函数中），会覆盖整个文档。