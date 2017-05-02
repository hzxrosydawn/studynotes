## Java 正则表达式详解

正则表达式是一个强大的字符串处理工具，可以对字符串进行查找、提取、分隔、替换等操作。String类里提供了如下几个特殊方法：

- boolean matches(String regex)：判断该字符串是否匹配指定的正则表达式；
- String replaceAll(String regex, String replacement)：将该字符串中所有匹配regex的子串替换成replacement；
- String replaceFirst(String regex, String replacement)：将该字符串中第一个匹配regex的子串替换成replacement；
- String[] split(String regex)：以regex为分隔符，把该字符串分割成多个子串。

上面的方法可以用于：

- 数据验证。比如，你要验证一个字符串是否是正确的EMail，Telphone，Ip等等，那么采用正则表达式就好非常方便；
- 内容查找。比如，你要抓取一个网页的图片，那么肯定要找到 `<img>` 标签，这时候用正则表达式就可以精准的匹配到；
- 内容替换。比如，你要把手机号码中间四位隐藏掉变成这种模式，123****4567，那么采用正则表达式也会非常方便。

## 创建正则表达式

正则表达式是**用于匹配字符串的模板**，包括普通字符（例如，a 到 z 之间的字母）和特殊字符（称为“元字符”）。该模板描述在搜索文本时要匹配的一个或多个字符串，所以创建正则表达式就是创建一个特殊的字符串。

### 正则表达式所支持的合法字符：
- `x` ： 字符x ；
- `\\` ：反斜扛；
- `\0n` ：八进制值0n表示的字符（0 <= n <= 7）；
- `\0nn` ：八进制值0nn表示的字符（0 <= n <= 7）；
- `\0mnn` ：八进制值0mnn表示的字符（0 <= m <= 3, 0 <= n <= 7）； 
- `\xhh` ：十六进制值0xhh表示的字符；
- `\uhhhh` ：十六进制值0xhhhh表示的字符；
- `\x{h...h}` ：十六进制值0xh...h 表示的字符（Character.MIN_CODE_POINT  <= 0xh...h <=  Character.MAX_CODE_POINT）；
- `\t` ：制表符（'\u0009'）；
- `\n` ：新行（换行）符（'\u000A'）；
- `\r` ：回车符（'\u000D'）；
- `\f` ：换页符（'\u000C'）；
- `\a` ：报警（bell）符（'\u0007'）；
- `\e` ：Escape符（'\u001B'）；
- `\cx` ：x对应的控制符。cM匹配Ctrl-M，x必须为A~Z或a~z。

### 元字符（Metacharacters）：

- `\` ：反斜线（backslash）用于转义下一个字符，或指定一个八进制、十六进制字符。例如，“\n”匹配\n，“\\\”匹配“\\”。多种编程语言中都有的“转义字符”的概念；

- `^` ：匹配以插入符（caret）**后面**的**字符串**的开头的字符串。`^abc` 和abc、abcdefg和abc123；

- `$` ：匹配以美元符（dollar）**前面**的**字符串**结尾的字符串。`abc$` 可以匹配abc、endsinabc和123abc；

- `*` ：星号（asterisk）前面的**子表达式（包括单个字符，下同）**可以出现任意次。例如，`zo*` 能匹配z、zo和zoo（`*` 号前的o可以出现任意次）；

- `+` ：加号（plus）指定前面的**子表达式**至少出现一次(大于等于1次）。例如，“zo+”能匹配“zo”以及“zoo”，但不能匹配“z”。+等价于{1,}；

- `?` ：问号（question）指定前面的**子表达式**最多出现一次（小于等于1次）。例如，“do(es)?”可以匹配“do”或“does”。?等价于{0,1}；

- `.` ：句号（period）匹配除“\r\n”之外的任何**单个字符**。要匹配包括“\r\n”在内的任何字符，请使用像“[\s\S]”的模式；

- `x|y` ：匹配x或y代表的**字符串**。例如，`z|food` 能匹配z或food(此处请谨慎)。`(z|f)ood` 则可匹配zood或food；

- `{...}` ：花括号（brace）中的数字表示前面子表达式出现的次数。有以下三种形式：
  - `{n}` ：n是一个非负整数，用于指定前面**子表达式**只能出现n次。例如，`o{2}` 不能匹配Bob中的o，只能匹配food中的两个o。要匹配花括号，请使用`\{` 和 `\}`；
  - `{n,}` ：n是一个非负整数，用于指定前面**子表达式**至少出现n次。例如，`o{2,}` 不能匹配Bob中的o，但能匹配foooood中的所有o。`o{1,}` 等价于 `o+` 。`o{0,}` 则等价于 `o*`；
  - `{n,m}` ：m和n均为非负整数，其中n<=m。用于指定前面的**子表达式**至少出现n次、最多出现m次。例如，`o{1,3}` 将匹配 `fooooood` 中的前三个o。`o{0,1}` 等价于 `o?` 。请注意**在逗号和两个数之间不能有空格** ；

- `[...]` ：中括号（bracket）内的表达式用于匹配一个特定的范围**单个**字符。有以下几种形式：
  - 表示枚举。如 `[xyz]` 匹配中括号中所有字符中的任意一个字符。例如，`[abc]` 可以匹配 `plain` 中的 `a` ；
  - 表示范围。如 `[a-z]` 匹配指定范围内的任意一个字符。例如，`[a-z]` 可以匹配 `a` 到 `z` 范围内的任意一个小写字母字符。注意：**只有连字符在字符组内部时，并且出现在两个字符之间时，才能表示字符的范围；如果出字符组的开头，则只能表示连字符本身** ；
  - 表示取反。如 `[^xyz]` 匹配除中括号中所有字符以外的任意一个字符。例如，`[^abc]` 可以匹配非a、b、c的任意一个字符，如 `plain` 中的 `plin` ，`[^a-f]` 匹配不是a~f范围内的任意字符；
  - 表示交集。如 `[a-z&&[def]]` 匹配\[a~z]与\[def]集合的交集中的任意一个字符，即d、e、f之一。；
  - 表示差集。如 `[a-z&&[^bc]]` 匹配a~z范围中除了b、c以外的所有小写字母。`[a-z&&[^m-p]]` 匹配a~z范围内除了m~p之间的所有小写字母，相当于[a-lq-z]；
  - 表示并集。如 `[a-d[m-p]]` 匹配\[a-d]和\[m-p]的并集中的任意一个字符，即a~d和m~p这两个范围中的任意一个字符，相当于\[a-dm-p]。
  - `(...)` ：圆括号（paren，parenthesis）用于将**多个表达式**组成一个子表达式。圆括号中可以使用或运算符（|），例如，正则表达式"((public)|(protected)|(prvate))"用于匹配Java的三个访问控制符其中之一。有以下几种形式：
    - ​



> 注意：如果要匹配这些元字符本身，就必须先在这些字符前面添加一个反斜线（`\`）将其转义。



\b  匹配一个单词边界，也就是指单词和空格间的位置（即正则表达式的“匹配”有两种概念，一种是匹配字符，一种是匹配位置，这里的\b就是匹配位置的）。例如，“er\b”可以匹配“never”中的“er”，但不能匹配“verb”中的“er”。  \B  匹配非单词边界。“er\B”能匹配“verb”中的“er”，但不能匹配“never”中的“er”。  \cx  匹配由x指明的控制字符。例如，\cM匹配一个Control-M或回车符。x的值必须为A-Z或a-z之一。否则，将c视为一个原义的“c”字符。  \d  匹配一个数字字符。等价于[0-9]。grep 要加上-P，perl正则支持  \D  匹配一个非数字字符。等价于[0-9]。grep要加上-Pperl正则支持  \f  匹配一个换页符。等价于\x0c和\cL。  \n  匹配一个换行符。等价于\x0a和\cJ。  \r  匹配一个回车符。等价于\x0d和\cM。  \s  匹配任何不可见字符，包括空格、制表符、换页符等等。等价于[ \f\n\r\t\v]。  \S  匹配任何可见字符。等价于^ \f\n\r\t\v]。  \t  匹配一个制表符。等价于\x09和\cI。  \v  匹配一个垂直制表符。等价于\x0b和\cK。  \w  匹配包括下划线的任何单词字符。类似但不等价于“[A-Za-z0-9_]”，这里的”单词”字符使用Unicode字符集。  \W  匹配任何非单词字符。等价于“[^A-Za-z0-9_]”。  \xn  匹配n，其中n为十六进制转义值。十六进制转义值必须为确定的两个数字长。例如，“\x41”匹配“A”。“\x041”则等价于“\x04&1”。正则表达式中可以使用ASCII编码。  \num  匹配num，其中num是一个正整数。对所获取的匹配的引用。例如，“(.)\1”匹配两个连续的相同字符。  \n  标识一个八进制转义值或一个向后引用。如果\n之前至少n个获取的子表达式，则n为向后引用。否则，如果n为八进制数字（0-7），则n为一个八进制转义值。  \nm  标识一个八进制转义值或一个向后引用。如果\nm之前至少有nm个获得子表达式，则nm为向后引用。如果\nm之前至少有n个获取，则n为一个后跟文字m的向后引用。如果前面的条件都不满足，若n和m均为八进制数字（0-7），则\nm将匹配八进制转义值nm。  \nml  如果n为八进制数字（0-7），且m和l均为八进制数字（0-7），则匹配八进制转义值nml。  \un  匹配n，其中n是一个用四个十六进制数字表示的Unicode字符。例如，\u00A9匹配版权符号`（&copy;）`。  \p{P}  小写 p 是 property 的意思，表示 Unicode 属性，用于 Unicode 正表达式的前缀。中括号内的“P”表示Unicode 字符集七个字符属性之一：标点字符。其他六个属性：L：字母；M：标记符号（一般不会单独出现）；Z：分隔符（比如空格、换行等）；S：符号（比如数学符号、货币符号等）；N：数字（比如阿拉伯数字、罗马数字等）；C：其他字符。*注：此语法部分语言不支持，例：javascript。  `< >`  匹配词（word）的开始（<）和结束（>）。例如正则表达式`<the>`能够匹配字符串”for the wise”中的”the”，但是不能匹配字符串”otherwise”中的”the”。注意：这个元字符不是所有的软件都支持的。  ( )  将( 和 ) 之间的表达式定义为“组”（group），并且将匹配这个表达式的字符保存到一个临时区域（一个正则表达式中最多可以保存9个），它们可以用 \1 到\9 的符号来引用。

### 预定义字符

正则表达式中的“通配符”远远超出了普通通配符的功能，被称为预定义字符。



![img](https://segmentfault.com/img/bVG0I2?w=734&h=175)


?  当该字符紧跟在任何一个其他限制符`（*,+,?，{n}，{n,}，{n,m}）`后面时，匹配模式为**非贪婪模式**。非贪婪模式下尽可能少的匹配所搜索的字符串，而默认的贪婪模式则尽可能多的匹配所搜索的字符串。例如，对于字符串“oooo”，“o+?”将匹配单个“o”，而“o+”将匹配所有“o”。

### 边界匹配符

![img](https://segmentfault.com/img/bVG0KM?w=724&h=213)

### 数量标识符

- Greedy（贪婪模式）：数量表示符默认采用贪婪模式。贪婪模式的表达式会一直匹配下去，直到无法匹配
- Reluctant（勉强模式）：用问号后缀（?）表示，只会匹配最少的字符，也称为最小匹配模式
- Possessive（占有模式）：用加号后缀（+）表示，目前只有Java支持占有模式，通常较少使用

![img](https://segmentfault.com/img/bVG0ME?w=733&h=171)

贪婪模式和勉强模式的对比：

```
String str = "SSR! 大天狗";
//贪婪模式的正则表达式
System.out.println(str.replaceFirst("\\w*","□"));
//勉强模式的正则表达式
System.out.println(str.replaceFirst("\\w*?","□"));
```

"\w*"使用了贪婪模式，数量表示符(*)会一直匹配下去，所以该字符串前面的所有单词 字符都被它匹配到，直到遇到空格，所以替换后的效果是“□! 大天狗”；如果使用勉强模式，数量表示符(*)会尽量匹配最少字符，即匹配0个字符，所以替换后的结果是“□SSR! 大天狗”。

## 使用正则表达式

Pattern对象是正则表达式编译后在内存中的表示形式，因此，正则表达式字符串必须先被编译为Pattern对象，然后再利用该Pattern对象创建对应的Matcher对象。执行匹配所涉及的状态保留在Matcher对象中，多个Matcher对象可共享同一个Pattern对象。

典型调用顺序

```
//将一个字符串编译成Pattern对象
Pattern pattern = Pattern.compile("a*b");
//使用Pattern对象创建Matcher对象
Matcher matcher = pattern.matcher("aaaaab");
boolean b = matcher.matches();        //返回true

```

上面定义的Pattern对象可以多次重复使用。如果仅需一次使用，则可直接使用Pattern类的静态matches()方法，此方法自动把指定字符串编译成匿名的Pattern对象，并执行匹配

```
boolean b = pattern.matches("a*b", "aaaaab");        //返回true

```

上面语句等效于前面的三条语句，但采用这种语句每次都需要重新编译新的Pattern对象，不能重新利用已编译的Pattern对象，所以效率不高

Pattern是不可变类，可供多个并发线程安全使用

Matcher类提供的常用方法：

- find()：返回目标字符串中是否包含与Pattern匹配的子串
- group()：返回上一次与Pattern匹配的子串
- start()：返回上一次与Pattern匹配的子串在目标字符串中的开始位置
- end()：返回上一次与Pattern匹配的子串在目标字符串中结束位置加1
- lookingAt()：返回目标字符串前面部分与Pattern是否匹配
- matches()：返回整个目标字符串与Pattern是否匹配
- reset()：将现有的Matcher对象应用于一个新的字符序列

CharSequence接口，该接口代表一个字符序列，其中CharBuffer、String、StringBuffer、StringBuilder都是它的实现类。

通过Matcher()类的find()和group()方法从目标字符串中依次取出特定子串（匹配正则表达式的子串）

```
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class FindGroup 
{
    public static void main(String[] args) 
    {
        //使用字符串模拟从网络上得到的网页源码
        String string = "四洲休闲食品：0754-88117038" + 
        "清风牌面巾纸：8008282272" + "统一冰红茶：4007000660";
        //创建一个Pattern对象，并用它建立一个Matcher对象
        //该正则表达式只抓取400X和800X段的电话号码
        //实际要抓取哪些电话号码，只要修改正则表达式即可
        Matcher matcher = Pattern.compile("((400\\d)|(800\\d))\\d{6}").matcher(string);
        //将所有符合正则表达式的子串（电话号码）全部输出
        while (matcher.find()) 
        {
            System.out.println(matcher.group());
        }
    }
}

```

find()方法还可以传入一个int类型的参数，带int参数的find()方法将从该int索引处向下搜索。start()和end()方法主要用于确定子串在目标字符串中的位置

```
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class StartEnd 
{
    public static void main(String[] args) 
    {
        //创建一个Pattern对象，并用它建立一个Matcher对象
        String regStr = "France LoireAtlantique Bretagne Nantes";
        System.out.println("目标字符串是：" + regStr);
        Matcher matcher = Pattern.compile("\\w+").matcher(regStr);
        while (matcher.find()) 
        {
            System.out.println(matcher.group() + 
                    "子串的起始位置：" + matcher.start() +
                    "，其结束位置：" + matcher.end());
        }
    }
}

```

```
目标字符串是：France LoireAtlantique Bretagne Nantes
France子串的起始位置：0，其结束位置：6
LoireAtlantique子串的起始位置：7，其结束位置：22
Bretagne子串的起始位置：23，其结束位置：31
Nantes子串的起始位置：32，其结束位置：38

```

程序创建一个邮件地址Pattern，再将其与多个邮寄地址进行匹配。当程序中的Matcher为null时，程序调用matcher()方法来创建一个Matcher对象，一旦Matcher对象被创建，程序就调用Matcher的reset()方法将该Matcher应用于新的字符序列

```
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class MatchesTest 
{
    public static void main(String[] args) 
    {
        String[] mails =
            {
                    "LeBornJames@gmail.com",
                    "FlashWade@163.com",
                    "Bosh@yahoo.com"
            };
        String mailRegEx = "\\w{3,20}@\\w+\\.(com|org|cn|net|gov|ed)";
        Pattern mailPattern = Pattern.compile(mailRegEx);
        Matcher matcher = null;
        for (String mail : mails) 
        {
            if (matcher == null) 
            {
                matcher = mailPattern.matcher(mail);
            }
            else 
            {
                matcher.reset();
            }
            String result = mail + (matcher.matches() ? "是":"不是") + "一个有效邮件地址";
            System.out.println(result);
        }
    }
}

```

Matcher类提供的replaceAll()把字符串中所有与正则表达式的子串替换成："呵呵"。还提供replaceFirst()，该方法只替换第一匹配的子串。split()方法以空格为分隔符，将字符串分割成多个子串

```
public class StringReg
{
    public static void main(String[] args)
    {
        String[] msgs =
        {
            "Java has regular expressions in 1.4",
            "regular expressions now expressing in Java",
            "Java represses oracular expressions"
        };
        for (String msg : msgs)
        {
        System.out.println(msg.replaceFirst("re\\w*" , "哈哈:)"));
        System.out.println(Arrays.toString(msg.split(" ")));
        }
    }
}
```

1、 正则表达式的几个重要的概念
•子表达式:在正则表达式中，如果使用"()"括起来的内容，称之为“子表达式”
•捕获：子表达式匹配到的结果会被系统放在缓冲区中，这个过程，我们称之为“捕获”
•反向引用：我们使用"\n"，其中n是数字，表示引用之前某个缓冲区之间的内容，我们称之为“反向引用”

7、特殊用法
•(?=) ： 正向预查：匹配以指定内容结束的字符串
•(?!) ： 负向预查：匹配不是以指定内容结束的字符串
•(?:) ： 不把选择匹配符的内容放到缓冲区