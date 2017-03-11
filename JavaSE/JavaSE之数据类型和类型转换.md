## 数据类型

Java中数据类型主要分为两大类。



### 基本数据类型

**基本数据类型中出了布尔型都是数值类型**。

| 类型     | 关键字     | 位数   | 默认值      | 取值范围                                     |
| ------ | ------- | ---- | -------- | ---------------------------------------- |
| 字节型    | byte    | 8    | 0        | -128(-2^7 )~127(2^8-1)                   |
| 短整型    | short   | 16   | 0        | -32768(-2^15 )~32767(2^15-1)             |
| 整型     | int     | 32   | 0        | -2147483648(-2^31 )~2147483647(2^31-1)，正负21亿左右 |
| 长整型    | long    | 64   | 0        | -9223372036854775808(-2^63 )~9223372036854775807(2^63-1)，足以表示地球上所有的整数值 |
| 单精度浮点数 | float   | 32   | 0.0F     | -3.40232347e38~3.40232347e38             |
| 双精度浮点数 | double  | 64   | 0.0D     | -1.79769313486231570E+308~1.79769313486231570E308 |
| 字符型    | char    | 16   | ‘\u0000’ | ‘\u0000’~'\uFFFF'                        |
| 布尔型    | boolean | 8    | false    | true,false                               |

#### 整数型

Java中整数有以下几种：

- byte；
- short；
- in；
- long。


通常，给出的一个整数值默认为int类型。除非以下情况：

- 如果将一个较小的整数值赋值给byte型（或short类型）且该较小值的范围不超过byte类型（或short型）的范围，则该较小值默认为byte型（或short型）；
- 如果使用一个较大的整数值，且该较大值的范围超过了int类型的范围，Java不会自动将其当做long型对待，而是截取其在内存中的后32位，将其当成int型，从而造成精度丢失。如果要将其作为long型，则应该在其后面添加字母“l”和“L”，因为小写的“l”容易与数字1混淆，故推荐使用“L”；
- 如果将一个较小的整数值（在int型的范围中）赋值给long型变量，Java依然将该整数当成是int型，然后再将其在赋值时转换为long型。

整数型实例：

```java
// 将一个在byte型范围内的整数赋值给byte型变量时，系统会自动将该整数值当成byte型处理
byte a = 127;
// 将一个超过int类范围的整数值赋值给一个long型变量时，系统不会自动将该整数值当成long型，下行代码有误
long b = 222222222222;
// 在该数值后面添加一个L字母表示该数值为long型
long c = 222222222222;
// 将一个较小的整数值（在int型的范围中）赋值给long型变量，系统依然将该整数当成是int型，然后再将其在赋值时转换为long型
long d = 127;
```

Java中的整数有四种表示形式：

- 十进制；
- 二进制。Java 7新增了对二进制整数的支持。以0b或0B开头，共8位，每一位数值为0和1之一；
- 八进制。以0开头，共3位，每一位数值为0~7范围中的一个整数；
- 十六进制。以0x或0X开头，共4位，每一位数值为0~9和a~f（表示10~15的数值）范围中的一个数字或字母。

整数表示形式实例：

```java
// 定义一个普通十进制整数
int decimalValue = 5;
// 定义一个8位的二进制整数
int binaryValue = 0B11001001;
// 定义一个16位的二进制正数，从Java7开始可以使用英文下划线来分割任何类型的较长数值以便识别
int longBinaryValue = 0B1100_1001_0100_1100;
// 定义一个八进制整数
int octalValue = 013;
// 定义一个16进制的整数
int hexadecimalValue = 0XF4;
```


#### 浮点型

Java中的浮点类型遵循IEEE 745标准，采用二进制数据的科学计数法来表示。主要为以下两种：

- float：一个float(单精度)型的浮点数值占4个字节，32位。第1位为符号位，接下来8位表示指数，后面的23位表示底数；
- double：一个double（双精度）型的浮点数值占8个字节，64位。第1位也是符号位，接下来的11位表示指数，后面的52位表示底数。

Java中的浮点数有以下两种形式：

- 十进制表示：十进制的浮点数必须包含小数点，否则会被当成int型数值。如5.12，512.0，.512；
- 科学计数法表示：如5.12E2（即5.12x10^2）或2.15e2；

通常，给出的一个浮点数值默认为double类型。如果想将一个浮点数值当成float型处理，则应在该浮点数后面加“f”或“F”。

特殊的浮点数值：正无穷大（用Double类或Float类的POSITIVE_INFINITY表示）、负无穷大（用Double类或Float类的NEGTIVE_INFINITY表示）和非数（用Double类或Float类的NaN表示）。这些特殊值可用于计算出错或溢出。注意以下几点：

- 正数除以0得到正无穷大；
- 负数除以0得到负无穷大；
- 0.0除以0.0得到非数；
- 所有正无穷大都相等，所有负无穷大都相等。而NaN和谁（包括NaN本身）都不相等；

浮点型实例：

```java
public class FloatTest {
	public static void main(String[] args)
	{
		float af = 5.2345556f;
		// 下面将看到af的值已经发生了改变
		System.out.println(af);
		double a = 0.0;
		double c = Double.NEGATIVE_INFINITY;
		float d = Float.NEGATIVE_INFINITY;
		// 看到float和double的负无穷大是相等的。
		System.out.println(c == d);
		// 0.0除以0.0将出现非数
		System.out.println(a / a);
		// 两个非数之间是不相等的
		System.out.println(a / a == Float.NaN);
		// 所有正无穷大都是相等的
		System.out.println(6.0 / 0 == 555.0/0);
		// 负数除以0.0得到负无穷大
		System.out.println(-8 / a);
		// 下面代码将抛出除以0的异常
		// System.out.println(0 / 0);
	}
}
```

运行结果如下：

```powershell
5.2345557
true
NaN
false
true
-Infinity
```

#### 字符型

Java中的字符值通常用于表示单个字符，必须使用单引号（''）括起来，其类型用关键字char表示。Java使用一个16位的Unicode字符集（支持世界上任何语言的字符）作为编码方式，故Java中的字符型值可以表示各种语言的字符。

字符值的表示有以下三种表示形式：

- 单个字符直接使用单括号括起来。如'A'，'9'等；
- 特殊字符使用转义字符来表示。如'\n'，'\t'等；
- 直接使用Unicode值来表示字符值，格式为'\uXXXX'，其中XXXX代表一个十六进制整数，范围为'\u0000'~'\uFFFF'共65536个字符，前面256个字符与ASCII码中的字符相同。

常见转义字符及其Unicode表示如下表所示。

| 转义字符 | 说明   | Unicode表示方式 |
| ---- | ---- | ----------- |
| \b   | 退格符  | \u0008      |
| \n   | 换行符  | \u000a      |
| \r   | 回车符  | \u000d      |
| \t   | 制表符  | \u0009      |
| \"   | 双引号  | \u0022      |
| \'   | 单引号  | \u0027      |
| \\\  | 反斜线  | \u005c      |

char类型可以作为一个16位的无符号整数（0~65535）来参与整数逻辑运算（减、加、乘、除和比较大小）。

字符型实例：

```java
// 直接使用单个字符作为字符值
char a = 'a';
// 使用转义字符作为字符值
char b = '\r';
// 使用Unicode编码值作为字符值
char c = '\u9999';
// 将输出一个汉字“香”
System.out.println(c);
char zhong = '疯';
// 可以将一个char类型变量直接当成int型使用
int zhongValue = zhong;
// 将输出表示“疯”字的整数值
System.out.println(zhongValue);
// 也可以将一个16位的整数值直接当成char类型使用
char d = 97;
// 将输出字母“a”
System.out.println(d);
```

Java使用String类对象表示多个字符组成的字符串：

```java
String string = "I love China";
```

#### 布尔型

布尔型只有一个boolean类型，表示逻辑上的真或假。Java中的boolean**只有true和false两个值，不能使用0或非0表示。其他数据类型也不能转换为boolean类型。**

虽然boolean类型只需要1位即可存储，但是大多数计算机都以字节位最小的内存分配单位，所以boolean类型占1一个字节。

字符串“true”和“false”不会自动转换为boolean型的值（通过Boolean.parseBoolean(String)方法可以），但boolean类型的值可以和字符串进行连接运算（**系统底层通过String.valueOf(boolean)来实现将boolean型的值转换为字符串**）来将boolean型值自动转换为字符串。

boolean型实例：

```java
// 定义a的值位true
boolean a = true;
// 定义b的值位false
boolean b = false;
// 系统自动将boolean型的true转换为字符串（通过String.valueOf(boolean)）
String string = true + "";
// 将打印出字符串“true”
System.out.println("string");
```

## 基本数据类型的类型转换

Java的7中**数值型变量之间可以相互转换**，分为自动类型转换和强制类型转换。

### 基本数据类型的自动转换

当把一个较小的数值赋值给一个表数范围较大的变量时，系统将进行自动类型转换。否则就需要就进行强制类型转换。

自动类型转换示意图：

![自动类型转换](.\appendix\自动类型转换.png)

上图中箭头左边类型的数值可以自动转换为箭头有右边类型的数值。

自动转换实例：

```java
public class AutoConversion {
	public static void main(String[] args) {
		int a  = 6;
		// int可以自动转换为float类型
		float f = a;
		// 下面将输出6.0
		System.out.println(f);
		// 定义一个byte类型的整数变量
		byte b = 9;
		// 下面代码将出错，byte型不能自动类型转换为char型
		// char c = b;
		// 下面是byte型变量可以自动类型转换为double型
		double d = b;
		// 下面将输出9.0
		System.out.println(d);
	}
}
```

Java基本数据类型不具有面向对象的特点，但是Java提供了八个包装类（Byte、Character、Short、Integer、Long、Double、Float、Boolean），能够把基本数据类型转化为引用数据类型。JDK5之后，包装器类和基本数据类型之间可以直接转换，称为自动的装箱拆箱（boxing/unboxing）。例如：

```java
// int型数值直接赋值给Integer类变量（自动装箱）
Integer i = 3;
/// Integer类变量直接当做int使用（自动拆箱）
i++;
```

虽然写法上可以像使用基本数据类型一样使用包装器类型，但是**本质上依然进行了基本类型与包装类之间的转换**，因此，**不要轻易使用包装器类的自动装箱拆箱，以优化的性能。能够使用基本类型就使用基本类型。**

**字符串和数字可通过“+”连接，系统会自动把基本类型的数字转换成字符串**（系统底层通过String.valueOf(xxx)，其中xxx表示8种基本类型的一种）。这是JAVA的装箱机制，最终相当于字符串的连接，这不属于数学运算，“AA”+i得到的确实是AA1,AA2等等；

而**字符**和数字通过“+”号连接时，按上面的自动类型转换示意图中所示，系统会先把char型的单个字符提升为一个整数（单个字符实际上就是一个16位整数），然后按照数学运算来计算，最终结果是整数。因为整型的计算级别比**字符**高，就好比浮点型又比整型高一样，这属于数学运算。

数值和字符或字符串的连接实例：

```java
public class PrimitiveAndString {
	public static void main(String[] args) {
      	// 可以将一个16位的整数值直接当成char类型使用
		char g = 97;
		// 将输出字母“a”
		System.out.println(d);
      	// char型的单个字符和整数值相加时，按数学运算处理
      	char h = g + 1;
      	// 下面将输出字母“b”
      	System.out.println(h);
		// 下面代码是错的，因为5是一个整数，不能直接赋给一个字符串
		// String str1 = 5;
		// 一个基本类型值和字符串进行连接运算时，基本类型值自动转换为字符串
		// String str2 = 3.5f + "";
      	// 建议使用以下手动装箱的方式来替换上一行的连接,这样节约了系统进行判断和执行加法的时间
      	String str2 = String.valueOf(3.5f);
		// 下面输出3.5
		System.out.println(str2);
		// 下面语句输出7Hello!
		System.out.println(3 + 4 + "Hello！");
		// 下面语句输出Hello!34，因为Hello! + 3会把3当成字符串处理，
		// 而后再把4当成字符串处理
		System.out.println("Hello！" + 3 + 4)
	}
}
```

### 强制类型转换

如果将一个表数范围较大的数值赋值给一个表数范围较小的变量，这时必须进行强制类型装换。强制类型装换的语法为(targetType)value。如果该数的实际值没有超过了该变量的表数范围还好，如果超过了就会引起溢出，造成数据丢失。这种转换也成为“缩小转换（Narrow Conversion）”。

强制类型转换实例：

```java
public class NarrowConversion {
	public static void main(String[] args) 	{
		int iValue = 233;
		// 强制把一个int类型的值转换为byte类型的值时，会截取32位int数值的后8位作为转换结果
		byte bValue = (byte)iValue;
		// 故将输出-23
		System.out.println(bValue);
		double dValue = 3.98;
		// 强制把一个浮点类型的数值转换位整数类型，将截取浮点类型数值的整数部分作为转换结果
		int tol = (int)dValue;
		// 故将输出3
		System.out.println(tol);
	}
}
```

将int型的233强制转换为byte型的原理如下图所示：

![ForceConversion](.\appendix\ForceConversion.png)

### 表达式类型的自动提升

当一个算术表达式中包含多种基本类型的数值时，整个算术表达式的数据类型将发生自动提升，提升的规则如下：

- 所有的byte、short、char型数值都被提升为int型；
- 整个算术表达式的数据类型自动提升到与表达式中最高等级操作数同样的类型（等级按照上面的自动类型转换示意图所示，箭头右边的类型的等级高于左边）。

自动提升实例：

```java
public class AutoPromote {
	public static void main(String[] args) {
		// 定义一个short类型变量
		short sValue = 5;
		// 下面代码将出错：表达式中的sValue将自动提升到int类型，
		// 则右边的表达式类型为int，将一个int类型赋给short类型的变量将发生错误。
		// sValue = sValue - 2;
		byte b = 40;
		char c = 'a';
		int i = 23;
		double d = .314;
		// 右边表达式中在最高等级操作数为d（double型）
		// 则右边表达式的类型为double型,故赋给一个double型变量
		double result = b + c + i * d;
		// 将输出144.222
		System.out.println(result);
		int val = 3;
		// 右边表达式中2个操作数都是int，故右边表达式的类型为int
		// 因此，虽然23/3不能除尽，依然得到一个int整数
		int intResult = 23 / val;
		System.out.println(intResult); // 将输出7
		// 输出字符串Hello!a7
		System.out.println("Hello!" + 'a' + 7);
		// 输出字符串104Hello!
		System.out.println('a' + 7 + "Hello!");
	}
}
```

### 直接量

直接量指在源代码中直接给出的值。如在"int a = 5;"这行代码中5就是一个直接量。

Java中能指定直接量的有以下8中类型：

- int类型的直接量：可以有十进制、二进制、八进制、十六进制等形式；
- long类型的直接量：在整数值后面添加一个“l”或“L”即可将其变为long型直接量；
- float类型的直接量：在整数值后面添加一个“f”或“F”即可将其变为float型直接量；
- double类型的直接量：直接给出的一个小数（也可加“d”或“D”后缀，不过没有意义）或科学计数法形式的浮点数默认为double型直接量；
- boolean类型的直接量：只有true和false两个值；
- char类型的直接量：该类型的直接量有三种形式：单引号括起来的字符、转义字符和Unicode值表示的字符；
- String类型的直接量：一个使用双引号括起来的字符序列即为String类型的直接量；
- null类型的直接量：只有一个null值。

