## 控制流程

### 顺序结构

顺序结构就是程序从上而下的执行，中间没有任何判断和跳转。顺序结构是编程中最常见的程序结构。

### 分支结构

分支结构根据不同的条件来执行不同的流程。主要包括if分支结构和switch分支结构。

#### if分支结构

if分支结构主要有以下几种类型：

##### if

if结构如下：

```java
if (expression) { 
	statements; 
}
```

##### if else

if else结构如下：

```java
if (expression) { 
	statements; 
} else { 
	statements; 
} 
```

##### if else if

if else if语句结构如下：

```java
if (expression) { 
	statements; 
} else if (expression) { 
	statements; 
}
```

##### if else if else

if else if else结构如下：

```java
if (expression) { 
	statements; 
} else if (expression) { 
	statements; 
} else{ 
	statements; 
} 
```

**注意**：if 和else后面的**条件执行体**总是用"{"和"}"括起来，虽然在执行语句只有一行时可以省略"{"和"}"，但省略花括号容易出现错误，不建议这么做。避免使用如下容易引起错误的格式： 

```java
if (expressionn) 
//AVOID! THIS OMITS THE BRACES {}! 
	statement; 
```

if语句实例：

```java
public class IfTest {
	private int num;
	private int num1;
	private int num2;

	public IfTest(int num, int num1, int num2) {
		this.num = num01;
		this.num1 = num02;
		this.num2 = num03;
	}

	public void testIf() {
		if (num01 > num02) { // if 所接受的参数类型是boolean类型的
			System.out.println(String.valueOf(num01) + "大于" + String.valueOf(num02));
			return;
		}
		System.out.println("=========");
	}

	public void testIf_Else() {
		if (num01 > num02) {
			System.out.println(String.valueOf(num01) + "大于" + String.valueOf(num02));
		} else {
			System.out.println(String.valueOf(num01) + "小于等于" + String.valueOf(num02));
		}
	}
	
	public void testIfElse_IFElse() {
		if (num01 > num02) { 
			System.out.println(String.valueOf(num01) + "大于" + String.valueOf(num02));
		} else if (num == num1) {
			System.out.println(String.valueOf(num01) + "等于" + String.valueOf(num02));
		} else { 
			System.out.println(String.valueOf(num01) + "小于" + String.valueOf(num02));
		}
	}

	public void testIf_If() {
		if (num01 > num02) {
			System.out.printlnString.valueOf(String.valueOf(num01) + "大于" + String.valueOf(num02));
		}

		if (num01 > num03) {
			System.out.println(String.valueOf(num01) + "大于" + String.valueOf(num03));
		}

		if (num02 > num03) {
			System.out.println(String.valueOf(num03) + "大于" + String.valueOf(num03));
		}
	}
}
```

#### switch分支结构

switch分支结构如下：

```java
switch (expression) { 
	case condition01: 
		statements; 
		/* 没有break语句时将会按顺序执行下一个case语句，而不是跳出该结构 */ 
    
	case condition02: 
		statements; 
		break;  
    
	case condition03: 
		statements; 
		break; 
    
    // 定义默认行为
	default: 
		statements; 
		break; 
}
```

switch分支语句后面的控制表达式的数据类型只能是**byte、short、char、int四种基本数据类型及其包装类类型**（int类型范围支持的条件数已经足够用了，所以**没有long**），以及**枚举类型和java.lang.String类型**（从Java 7开始支持），**不能是boolean类型**（只有两种条件可以使用if分支语句）。

系统先计算switch关键字后的表达式的值，然后与条件执行体的case关键字后的条件值比较，如果相等就执行该case关键字后的执行体（如果每个case都有break作为结尾，那么只会匹配**第一个**可匹配的case关键字后的值，不再判断后面的case和default，也不执行后面的执行体），执行到break关键字时将跳出该switch语句。如果没有一个case条件可以匹配，则会执行default（默认）条件下的执行体。

switch语句实例：

```java
public class SwitchTest {

	public static void main(String[] args) {
		SwitchTest switchCase = new SwitchTest();
		switchCase.testSwitch(3);
	}
	
	public void testSwitch(byte b) {
		String what;
		switch (b) {
		case 1://意味着选择
			what = "鸡蛋";
			break;//break执行之后会跳出switch-case
		case 2:
			what="鸭蛋";
			break;
		case 3:
			what="鹅蛋";
			break;
		case 4:
			what="鹌鹑蛋";
			break;
		case 5:
			what="鸵鸟蛋";
			break;
		case 6:
			what="笨蛋";
			break;
		case 7:
			what="扯淡";
			break;
		default:
			what="饿着";
			break;
		}
		System.out.println("今天吃: "+what);
	}
}
```
运行结果如下：
```powershell
今天吃:鹅蛋
```
### 循环结构
循环结构用于在满足某一条件时反复执行某一段代码，而这段返回执行的代码称为循环体。当循环到满足某一条件时应该终止该循环，否则将形成死循环而一直循环下去。循环语句**可能**包含如下4个部分：

-  初始化语句（init_statements）：一条或多条语句，用于完成循环开始的一些初始化工作，比如定义、初始化循环变量。在循环开始之前执行；
-  循环条件（circle_expression）：一条布尔表达式，用于判断是否满足循环条件；
-  循环体（body_statements）：该段代码用于在满足循环条件时被反复执行；
-  迭代语句（iteration_statements）：这部分用于控制循环变量的值，当循环变量的值达到终止循环的条件时终止该循环。

#### while循环
while循环先判断循环条件再执行循环体（先奏后斩）。语法如下：
```java
[init_statements]
while (circle_expression) {
  body_statements;
  [iteratin_statements]
}
```
while循环先对循环条件求值，如果循环条件为true，那么执行下面的循环体，否则就不执行。只有当循环体执行完毕后while循环才会执行最后的迭代语句。
如果循环体与迭代语句为一体且只有一条语句，则可以省略循环体的花括号，但这样会降低可读性，不建议这么做。
while循环实例：
```java
public class WhileTest {
	public static void main(String[] args) {
		// 循环的初始化条件
		int count = 0;
		// 当count小于10时，执行循环体
		while (count < 10) {
			System.out.println(count);
			// 迭代语句
			count++;
		}
		System.out.println("循环结束!");

//		// 下面是一个死循环
//		int count = 0;
//		while (count < 10) {
//			System.out.println("不停执行的死循环 " + count);
//			count--;
//		}
//		System.out.println("永远无法跳出的循环体");
	}
}
```
运行结果如下：
```powershell
循环结束!
```
#### do while循环
do while循环与while循环不同，do while循环先执行循环体再判断循环条件（先斩后奏）。do while循环语法如下：
```java
[init_statement]
do {
  body_statements;
  [iteration_statement]
} while (circle_expression);
```
> **注意**：do while循环最后有一个英文分号不可省略。

由于do while循环是先执行循环体后判断，所以即使循环条件一开始就为false，循环体也会执行一次。
do while循环实例：
```java
public class DoWhileTest {
	public static void main(String[] args) {
		// 定义变量count
		int count = 1;
		// 执行do while循环
		do {
			System.out.println(count);
			// 循环迭代语句
			count++;
			// 循环条件紧跟while关键字
		} while (count < 4);
		System.out.println("循环结束!");

		// 定义变量count2
		int count2 = 20;
		// 执行do while循环
		do
			// 这行代码把循环体和迭代部分合并成了一行代码
			System.out.println(count2++);
		while (count2 < 10);
		System.out.println("循环结束!");
	}
}
```
运行结果如下：
```powershell
1
2
3
循环结束!
20
循环结束!
```
#### for循环
for循环比前面两种循环更加简洁和常用，多数情况下可以用来替换while循环和do while循环。for循环的语法如下：
```java
for ([inti_statements];[circle_expression];[iteration_statements]) {
  body_statements;
}
```
for循环先执行初始化语句，然后判断循环条件是否满足（为true），则执行循环体，然后在执行迭代语句；如果不满足循环条件则不执行循环体而是跳出该循环。同前面一样，当循环体只有一条语句时可以省略循环体的花括号，但是不建议这么做。典型的for循环用法如下：

```java
public class ForTest {
	public static void main(String[] args) {
		for (int i = 0; i < 10; i++) {
          	// 即使循环体只有一条执行语句，可以省略循环体的花括号，但不建议这样做,
          	// 否则降低了可读性，易出错
			System.out.println(i);
		}
		System.out.println("循环结束");
		// 下面可以通过temp临时变量来访问循环变量的值
		// statements;
	}
}
```

> 初始化语句、循环条件和更新语句这三条语句都是可选的，所以for循环可以有8种形式，这三条语句之间在语法上没有任何关系，是完全独立的，它们的执行是完全独立的。

**建议**：建议不要在循环体内修改循环变量的值，否则容易出错。如下面代码所示，由于在循环体内直接修改循环变量的值，将导致永远也无法达到循环终止的条件，循环也不会终止，将一直输出1：

```java
public class ForErrorTest {
	public static void main(String[] args) {
		// 循环的初始化条件,循环条件，循环迭代语句都在下面一行
		for (int count = 0; count < 10; count++) {
			System.out.println(count);
			// 再次修改了循环变量
			count *= 0.1;
		}
      	
      	// 下面也是一种死循环
      	/* for (;;) {
      		System.out.println(1);
      	} */
      
		System.out.println("循环结束!");
	}
}
```
输出结果如下：
```powershell
1
1
1
...
```
如果非要访问或修改循环变量的值，可以在循环体外建立一个临时变量来在循环体内存放循环变量的值，然后在访问或修改临时变量的值。如下面代码所示：

```java
public class ForTest2 {
	public static void main(String[] args) {
		int temp;
		for (int i = 0; i < 10; i++) {
			System.out.println(i);
			temp = i;
		}
		System.out.println("循环结束");
		// 下面可以通过temp临时变量来访问循环变量的值
		// statements;
	}
}
```
> **注意**：
> - 由于while循环和do while循环中的迭代语句紧跟在循环体后面，则在循环体中使用了continue退出本次循环，迭代代码将不会被执行；而for循环的迭代语句没有和循环体在一起，那么即使在循环体中使用了continue退出本次循环，迭代代码依然会被执行。关于continue关键字的用法请参考下面的**流程控制部分**；	
> - 通常使用i、j、k来作为循环变量；
> - 以上三种循环都可以一层套一层，但是不建议超过三层。

#### forEach循环

从JDK 1.5开始，Java提供了一种简单的forEach循环，用于遍历数组和集合时更加简洁。使用forEach循环遍历数组和集合元素时，无须获得数组和集合长度，无须根据索引来访问数组元素和集合元素。语法格式如下：

```java
for(数据类型 变量名 : 数组名 | 集合名) {
	// 变量自动迭代访问每个元素
}
```

上面圆括号中**“数据类型**”是数组或集合的元素类型，“**变量名**”是一个形参名，是forEach循环会自动将分号后面的数组或集合的每个元素依次赋值给该形参名指定的变量。如下面代码所示：

```java
public class ForEachTest {
	public static void main(String[] args) {
		String[] books = {"Head First Java" ,
		"Head First Php",
		"Head First Android"};
		// 使用foreach循环来遍历数组元素，
		// 其中book将会自动迭代每个数组元素
		for (String book : books) {
			System.out.println(book);
		}
	}
}
```

输出结果如下：

```powershell
Head First Java
Head First Php,
Head First Android
```

值得注意的是，建议不要在循环体中修改循环遍历的值（虽然语法上允许），这样做没有实际意义，而且还容易出错。如：

```java
public class ForEachErorTest {
	public static void main(String[] args) {
		String[] books = {"Head First Java" ,
		"Head First Php",
		"Head First Android"};
		// 使用foreach循环来遍历数组元素，
		// 其中book将会自动迭代每个数组元素
		for (String book : books) {
          	book = "Head First Java";
			System.out.println(book);
		}
	}
}
```

输出结果如下：

```java
Head First Java
Head First Java
Head First Java
```

### 流程的控制
Java提供了continue和break来控制循环。此外，return也可以结束整个方法，当在循环体中使用return时也会结束该循环。
#### break
不管哪一种循环，只要在循环体中遇到了**break**，系统将**结束该循环**，开始执行循环之后的代码。如下面代码所示：
```java
public class BreakTest {
	public static void main(String[] args) {
		// 一个简单的for循环
		for (int i = 0; i < 10; i++) {
			System.out.println("i的值是" + i);
			if (i == 2) {
				// 执行该语句时将结束循环
				break;
			}
		}
	}
}
```

运行结果如下：

```powershell
i的值是0
i的值是1
i的值是2
```

break不仅可以结束当前循环，还可以结束外层循环。只需要在**外层循环之前**定义一个后面带英文冒号的标签，然后在内层循环中的break关键字之后紧跟该标签，就可以在运行到该break语句处时结束该标签表示的外层循环。如下面代码所示：

```java
public class BreakTest2 {
	public static void main(String[] args) {
		// 外层循环，outer作为标识符
		outer: for (int i = 0; i < 5; i++) {
			// 内层循环
			for (int j = 0; j < 3; j++) {
				System.out.println("i的值为:" + i + "  j的值为:" + j);
				if (j == 1) {
					// 跳出outer标签所标识的循环。
					break outer;
				}
			}
		}
	}
}
```

运行结果如下：

```powershell
i的值为:0  j的值为:0
i的值为:0  j的值为:1
```

#### continue

continue关键字只是结束本次循环，开始下一次循环，除非满足了循环结束的条件，否则循环不会终止。而break则是终止了整个循环。如下面代码所示：

```java
public class ContinueTest {
	public static void main(String[] args) {
		// 一个简单的for循环
		for (int i = 0; i < 3; i++) {
			System.out.println("i的值是" + i);
			if (i == 1) {
				// 忽略本次循环的剩下语句
				continue;
			}
			System.out.println("continue后的输出语句");
		}
	}
}
```

运行结果如下：

```powershell
i的值是0
continue后的输出语句
i的值是1
i的值是2
continue后的输出语句
```

与break类似的，continue也可以紧跟一个标签，用于直接结束所标识循环的当次循环，重新开始下一次循环。如下面代码所示：

```java
public class ContinueTest2 {
	public static void main(String[] args) {
		// 外层循环
		outer: for (int i = 0; i < 5; i++) {
			// 内层循环
			for (int j = 0; j < 3; j++) {
				System.out.println("i的值为:" + i + "  j的值为:" + j);
				if (j == 1) {
					// 忽略outer标签所指定的循环中本次循环所剩下语句。
					continue outer;
				}
			}
		}
	}
}
```

运行结果如下：

```powershell
i的值为:0  j的值为:0
i的值为:0  j的值为:1
i的值为:1  j的值为:0
i的值为:1  j的值为:1
i的值为:2  j的值为:0
i的值为:2  j的值为:1
i的值为:3  j的值为:0
i的值为:3  j的值为:1
i的值为:4  j的值为:0
i的值为:4  j的值为:1
```

#### return

return用于返回当前方法的结果并结束当前方法。当在一个方法中遇到循环体中的return语句（Java中的多数循环都放在方法中执行）时就会结束return所在的循环。如下面代码所示：

```java
public class ReturnTest {
	public static void main(String[] args) {
		// 一个简单的for循环
		for (int i = 0; i < 3; i++) {
			System.out.println("i的值是" + i);
			if (i == 1) {
				return;
			}
			System.out.println("return后的输出语句");
		}
	}
}
```

运行结果如下：

```powershell
i的值是0
return后的输出语句
i的值是1
```
