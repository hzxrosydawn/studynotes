---
typora-root-url: ./
typora-copy-images-to: appendix
---

# CSS笔记

定义：CSS指层叠样式表 (Cascading Style Sheets)。这些样式可以用来定义如何显示HTML 元素。

## 语法

![selector](/appendix/selector.gif)

CSS规则由两个主要的部分构成：选择器，以及一条或多条声明。

- 选择器通常是需要改变样式的HTML元素；
- 每条声明由一个属性和一个值组成；
- 属性（property）是希望设置的样式属性（style attribute），每个属性有一个值。属性和值被冒号分开。

CSS声明总是以英文分号(;)结束，声明组以大括号({})括起来：

```css
p {color:red; text-align:center;}
```

为了让CSS可读性更强，你可以每行只描述一个属性：

```css
p
{
color:red;
text-align:center;
}
```

## 注释

CSS注释以 "/\*" 开始, 以 "\*/" 结束, 实例如下：

```css
/*这是个注释*/
p
{
text-align:center;
/*这是另一个注释*/
color:black;
font-family:arial;
}
```

## 选择器

关于CSS 3选择器的详细信息请参考W3C官方介绍：https://www.w3.org/TR/css3-selectors/。

### 元素选择器

以**元素名作为选择依据**的元素选择器是最简单、最基本的选择器。如下面的实例中所有`p`元素的文本居中：

```css
p {text-align:center;}
```

在W3C标准中，元素选择器又称为类型选择器（type selector）。“类型选择器匹配文档语言元素类型的名称。类型选择器匹配文档树中该元素类型的每一个实例。”

一种特殊的情况如下：

```css
* 
```

上面`*`表示的选择器可以选择所有元素。

### 属性选择器

CSS 2 引入了属性选择器。属性选择器可以根据元素的属性及属性值来选择元素。严格地讲，元素选择器也是属性选择器。属性选择器有以下几种。

简单属性选择器匹配所有包含（即显式指定了）指定属性（可以有多个属性限定）的（或某一类型）元素。语法如下：

```css
E[attr1][attr2] ... {...}
```

下面的实例把包含标题属性（`title`）的所有元素变为红色：

```css
*[title] {color:red;}
```

还可以根据多个属性进行选择，只需将属性选择器链接在一起即可。下面的实例将同时有`href`和`title`属性的超链接的文本设置为红色：

```css
a[href][title] {color:red;}
```

属性选择器还有以下几种形式：

- E[attr=value]{...}：匹配所有包含`attr`属性，且属性值为`value`的E元素。例如，`[target=-blank] ` 选择所有使用target="-blank"的元素；

- E[attr~=value]{...}：匹配所有包含`attr`属性（其属性值为[空白](https://www.w3.org/TR/css3-selectors/#whitespace)分隔的系列值），且属性值中含有`value`的E元素。例如，`[title~=flower]`选择标题属性的属性值中含有单词"flower"的所有元素；

- E[attr|=value]{...}：匹配所有包含`attr`属性（其属性值为连字符分隔的系列值），且属性值的起始值为`value`的E元素。例如：

  ```css
  *[lang|="en"] {color: red;}
  ```

  上面这个规则会选择`lang`属性等于`en`或以`en-`开头的所有元素。因此，以下示例标记中的前三个元素将被选中，而不会选择后两个元素：

  ```css
  <p lang="en">Hello!</p>
  <p lang="en-us">Greetings!</p>
  <p lang="en-au">G'day!</p>
  <p lang="fr">Bonjour!</p>
  <p lang="cy-en">Jrooana!</p>
  ```

- E[attr^="value"]{...}：匹配所有包含`attr`属性（其属性值为字符串），且属性值以“value”字符串开头的E元素；

- E[attr$="value"]{...}：匹配所有包含`attr`属性（其属性值为字符串），且属性值以“value”字符串结尾的E元素；

- E[attr*="value"]{...}：匹配所有包含`attr`属性（其属性值为字符串），且属性值中含有“value”字符串的E元素；

### id 选择器

HTML元素以其`id`属性来设置**id 选择器**，CSS中id选择器以`#` 来定义。如以下的样式规则应用于属性`id="param1"`的 HTML元素：

```css
#param1
{
text-align:center;
color:red;
}
```

或者`#`号之前也可以加元素的名称。如下面的实例中所有`id="param1"`的`p`元素的文本居中：

```css
p#param1 {text-align:center;}
```

### class选择器

class选择器用于描述一组`class`属性为指定值的HTML元素的样式。在 CSS 中，类选择器以一个英文点号`.`加`class`属性值表示。在以下的例子中，所有拥有`class="center"`的HTML元素均为居中：

```css
.center {text-align:center;}
```

或者英文点号之前也可以加元素的名称。如下面的实例中所有`class="center"`的`p`元素的文本居中：

```css
p.center {text-align:center;}
```

> 注意：`id`和`class`的名称的第一个字符都不能使用数字！因为这种名称在Mozilla/Firefox中不起作用。

### 后代选择器

后代选择器（descendant selector）又称为包含选择器。后代选择器可以选择作为某元素后代的元素，要求元素必须位于某个的元素的内部（在内部即可，而不管其深度），它会根据文档的上下文关系来确定某个元素的样式。语法如下：

```css
E F {...} /*F元素必须位于E元素的内部*/
```

在后代选择器中，规则**左边的选择器可以为两个或多个用空格分隔的选择器**。选择器之间的空格是一种结合符，必须从右向左读选择器。

例如，下面的实例使列表中的所有`strong`元素变为斜体字，而不是通常的粗体字：

```css
li strong {
    font-style: italic;
    font-weight: normal;
  }
```

**最右边的选择器匹配的元素的深度可以是任意的**。例如，`ul em`选择器将会选择以下标记中的**所有** `em` 元素：

```html
<ul>
  <li>List item 1
    <ol>
      <li>List item 1-1</li>
      <li>List item 1-2</li>
      <li>List item 1-3
        <ol>
          <li>List item 1-3-1</li>
          <li>List item <em>1-3-2</em></li>
          <li>List item 1-3-3</li>
        </ol>
      </li>
      <li>List item 1-4</li>
    </ol>
  </li>
  <li>List item 2</li>
  <li>List item 3</li>
</ul>
```

### 子选择器

与后代选择器相比，子元素选择器（Child selectors）要求元素必须是某个元素的子元素。语法如下：

```css
E > F {...} /* F元素必须是E元素的子元素*/
```

例如，选择只作为`h1`元素子元素的`strong`元素，可以这样写：：

```css
h1 > strong {color:red;}
```

这个规则会把第一个`h1`下面的两`strong`元素变为红色，但是第二个`h1`中的`strong`不受影响：

```html
<h1>This is <strong>very</strong> <strong>very</strong> important.</h1>
<h1>This is <em>really <strong>very</strong></em> important.</h1>
```

> 注意：**子选择器中英文大于号两边可以有空白符，这是可选的**。

### 兄弟选择器

兄弟选择器有两种：相邻兄弟选择器（要求一个元素紧跟在一个兄弟元素后面）和一般兄弟选择器（兄弟元素不要求相邻）。

**相邻兄弟选择器**可选择**紧接**在另一元素后的元素，且二者有相同父元素。语法如下：

```css
E + F {...}
```

例如，下面的实例选择紧接在`h1`元素后出现的段落，`h1`和`p`元素拥有共同的父元素：

```css
h1 + p {margin-top:50px;}
```

**一般兄弟选择器**也可以选择在一个元素之后的兄弟元素，但没有要求兄弟元素是紧密相邻的。语法如下：

```css
E ~ F {...}
```

例如，

```css
h1 ~ pre
```

上面面的选择器可以选择不紧跟在`h1`后面的`pre`：

```css
<h1>Definition of the function a</h1>
<p>Function a(x) has to be applied to all figures in the table.</p>
<pre>function a(x) = 12x/13.5</pre>
```

### 组合选择器

如果希望将一份样式对多个选择器有效，那么可以使用英文逗号来将多个选择器组合起来。语法如下：

```css
E, F {...}
```

例如，以下的两组规则能得到同样的结果，不过可以很清楚地看出哪一个写起来更容易：

```css
/* no grouping */
h1 {color:blue;}
h2 {color:blue;}
h3 {color:blue;}
h4 {color:blue;}
h5 {color:blue;}
h6 {color:blue;}

/* grouping */
h1, h2, h3, h4, h5, h6 {color:blue;}
```

### 伪元素选择器

伪元素创建了文档语言规范之外的抽象元素。比如，文档语言并没有提供访问元素内容的第一个字母或第一行的机制，而伪元素就可以做到。CSS提供的伪元素选择器有以下几个：

- ::first-letter

- ::first-line

- ::before

- ::after


伪元素由双英文冒号（::）后跟伪元素名构成。双英文冒号是为了与伪类中的单英文冒号相区别。为了与CSS 1和CSS 2中单英文冒号表示的伪元素兼容，客户端必须也能单英文冒号的伪元素（即`:first-line`，`:first-letter`，`:before`和`:after`），但CSS 3规范中已不允许这种兼容。

目前**伪元素必须出现在一列简单选择器之后，且每个简单选择器后只能出现一个伪元素**。

#### `::first-letter`和`::first-letter`

`::first-letter`伪元素代表一个元素内容的第一个字母（如果当前行没有图片或行内表格等其他行内元素内容的话），包括第一个字母前后紧挨着第一个字母的标点符号。该伪元素可以结合font-size和float属性实现首字母变大和首字母下沉。

目前`::first-letter`伪元素只能用于块级元素，如`div`、`p`、`section`元素，如果要对内联元素（如`span`元素）使用该伪元素，就必须先设定内联元素的`width`和`height`属性、或者设定`position`属性为`absolute`，或者设定`display`属性为`block`。

例如，

```css
span {
			display:block;
		}
		/* span元素里第一个字母加粗、变蓝
		由于span是内联元素，因此需要先把span的display设为block
		*/
		span:first-letter{
			color:#f00;
			font-size:20pt;
		}
		/* section元素里第一个字母加粗、变蓝 */
		section:first-letter{
			color:#00f;
			font-size:30pt;
			font-weight:bold;
		}
		/* p元素里第一个字母加粗、变蓝 */
		p:first-letter{
			color:#00f;
			font-size:40pt;
			font-weight:bold;
		}
```

上面的选择器使下面各元素的首字母（包括单个汉字）变大：

```html
<span>abc</span>
<section>dnf</section>
<p>女汉子</p>
```

`::first-line`伪元素也只能用于块级元素，如`div`、`p`、`section`元素，如果要对内联元素（如`span`元素）使用该伪元素，就必须先设定内联元素的`width`和`height`属性、或者设定`position`属性为`absolute`，或者设定`display`属性为`block`。

例如，

```css
span {
			display:block;
		}
		/* span元素里第一行文字的字体加大、变红
		由于span是内联元素，因此需要先把span的display设为block
		*/
		span:first-line{
			color:#f00;
			font-size:20pt;
		}
		/* section元素里第一行文字的字体加大、变蓝 */
		section:first-line{
			color:#00f;
			font-size:30pt;
		}
		/* p元素里第一行文字的字体加大、变蓝 */
		p:first-line{
			color:#00f;
			font-size:30pt;
		}
```

上面的选择器将使下面元素第一行的内容字体加大、变蓝：

```html
<span>abc<br/>xyz</span>
<section>高圆圆赵又廷了，<br/>
李小璐贾乃亮了。</section>
<p style="width:160px">https://www.w3.org/TR/css3-selector.</p>
```

#### `::before`和`::after`

`::before`和`::after`伪元素可用在元素内容的前后插入生成的内容。

CSS中的内容的生成有以下两种机制：

- 通过结合`::before`和`::after`伪元素和`content`属性；
- 通过含有`display`属性的值为`list-item`的元素。

例如，下面规则在所有`class="note"`的每个`p`元素的内容之前插入蓝色`"Note: "`字符串：

```css
p.note:before { content: "Note: " }
```

**被选择器格式化的对象也包括插入的内容**：

```css
p.note:before { content: "Note: " }
p.note        { border: solid green }
```

上面的规则`class="note"`的每个`p`元素的段落内容添加绿色实线边框时也包括插入的`"Note: "`字符串。

**`::before`和`::after`伪元素也会从他们所依附的元素上继承任何可继承的属性**。例如，下面的规则在每个`q`元素之前插入一个开放的引用标记，插入的引用标记将为红色，但其字体将与`q`元素中其他内容的字体相同：

```css
q:before {
  content: open-quote;
  color: red;
}
```

**`::before`和`::after`伪元素声明中未继承的属性将采用[初始值](https://www.w3.org/TR/2009/CR-CSS2-20090908/cascade.html)**。由于`display`属性默认为`inline`，所以，上面例子中插入的是一个行内框（inline box），即插入内容将与初始文本内容同行。下面的例子显示设置`display`属性的值为`block`，所以插入的文本将是一个块：

```css
body:after {
    content: "The End";
    display: block;
    margin-top: 2em;
    text-align: center;
}
```

`::before`和`::after`伪元素依附的元素会与其他box相互作用，如run-in box，好像他们是真的插入他们相关的元素中一样。例如，下面的文档片段和样式表

```css
<h2> Header </h2>      h2 { display: run-in; }
<p> Text </p>          p:before { display: block; content: 'Some'; }
```

将渲染成下面文档片段和样式表所表现的一样：

```css
<h2> Header </h2>            	h2 { display: run-in; }
<p><span>Some</span> Text </p>  span { display: block }
```

类似地，下面的文档片段和样式表

```css
<h2> Header </h2>     h2 { display: run-in; }
                      h2:after { display: block; content: 'Thing'; }
<p> Text </p>
```

将渲染成下面的文档片段和样式表所表现的一样：

```css
<h2> Header <span>Thing</span></h2>   h2 { display: block; }
                                      span { display: block; }
<p> Text </p>
```

#### `content`属性

`content`属性用来向指定元素之前或之后插入指定内容，其值可以为字符串、`uri(urlString)`、`counter`属性、`attr(X)`、`open-quote`和`close-quote`之一。

其中，`uri`可指定为一个外部资源（比如图片）的链接。attr(X)返回指定的属性值。

open-quote和close-quote：由`quotes`属性来指定。

#### `counter`属性

`counter`属性代表一个计数器，它可由`counter()`或`counters()`函数来获得。

`counter()`函数有`counter(name)`和`counter(name, style)`两种形式，其中`name`参数为计数器的类型，可以指定为`counter-increment`属性或`counter-reset`属性的值，`style`参数为计数器标识符的类型。

`counters()`函数也有两种形式：

#### `counter-increment`和`counter-reset`属性

`counter-increment`属性代表一个**自增（或自减）计数器**，它可以接受若干个**计数器名称**（可能是已声明作用范围的`counter-increment`类型或`counter-reset`类型，也可能未声明）作为计数器的标识符，每个计数器名称后面都可以跟一个可选的整数值，可通过该整数值来指定该名称的计数器要插入的目标元素每次出现时计数**增加的步长**，默认为1，也可以为0或负值。

`counter-reset`属性代表一个**可重置计数器**，它也可以接受若干个计数器名称作为计数器的标识符，每个计数器名称后面也都可以跟一个可选的整数值，可通过该整数值来指定该名称的计数器要插入目标元素每次出现时该计数器**设置的值**，默认为0。

`counter-increment`属性用来设置自增（自减）计数器，而

下面的例子演示了将章节和小结的目录设置成“Chapter 1”，“1.1”，“1.2”的形式：

```css
BODY {
  	/* 为BODY元素声明一个名为chapter的可重置计数器 */
    counter-reset: chapter;
}
H1:before {
  	/* 将含有chapter可重置计数器数值的文本插入H1元素的最前面 */
    content: "Chapter " counter(chapter);
  	/* 指定H1中chapter下次出现时自增1 */
    counter-increment: chapter; 
}
H1 {
  	/* 为H1元素声明一个名为section的可重置计数器 */
    counter-reset: section;
}
H2:before {
  	/* 将含有chapter、section可重置计数器数值的文本插入H2元素的最前面 */
    content: counter(chapter) "." counter(section);
  	/* 指定H2中的section计数器下次出现时自增1 */
    counter-increment: section;
}
```

如果一个元素既要自增或重置一个计数器，同时也要使用该计数器，那么计数器将在自增或重置后再使用。

如果一个元素既要自增一个计数器，也要重置该计数器，那么该计数器会先重置后再自增。

如果相同名称的计数器在`counter-increment`或`counter-reset`属性中出现多次，那么该计数器的每次自增或重置都是按顺序进行的。例如，下面的例子会将`section`计数器重置为0：

```css
H1 { counter-reset: section 2 section }
```

下面的例子会将`chapter`计数器最终增加到3：

```css
H1 { counter-increment: chapter chapter 2 }
```

`counter-reset`属性遵循级联规则。因此，下面的样式单

```css
H1 { counter-reset: section -1 }
H1 { counter-reset: imagenum 99 }
```

将仅重置`imagenum`。可以通过下面的样式单来重置上面的两个计数器：

```css
H1 { counter-reset: section -1 imagenum 99 }
```

在一个后代（从包含关系上讲）元素（或伪元素）中重置一个计数器会自动创建一个新的计数器实例，这一点在HTML的一些场景（如列表）中很重要，在这些场景中，元素可以嵌入到自身的任意深度中去。

因此，下面的样式表就可以计算嵌套列表的条目数，结果很像在`LI`元素上设置`display:list-item`和`'list-style: inside`：

```css
OL { counter-reset: item }
LI { display: block }
LI:before { content: counter(item) ". "; counter-increment: item }
```

名为C计数器的范围从文档中第一个通过`counter-reset：C`声明了该计数器的元素E处开始，包括E元素及E元素的后代元素，还有E元素后面的兄弟元素及其后代元素，不包括E元素

如果一个元素或伪元素上的`counter-increment`或`content`参考了一个不在任何`counter-reset`范围中的计数器，那么该计数器就好像被一个`counter-reset`重置为0。

上面的例子中，`OL`创建了一个计数器，且其子元素都会参考该计数器。如果我们使用`item[n]`表示第n个`item`计数器，使用花括号表示其开始和结束的范围。那么：

```html
<OL>                    <!-- {item[0]=0        -->
  <LI>item</LI>         <!--  item[0]++ (=1)   -->
  <LI>item              <!--  item[0]++ (=2)   -->
    <OL>                <!--  {item[1]=0       -->
      <LI>item</LI>     <!--   item[1]++ (=1)  -->
      <LI>item</LI>     <!--   item[1]++ (=2)  -->
      <LI>item          <!--   item[1]++ (=3)  -->
        <OL>            <!--   {item[2]=0      -->
          <LI>item</LI> <!--    item[2]++ (=1) -->
        </OL>           <!--                   -->
        <OL>            <!--   }{item[2]=0     -->
          <LI>item</LI> <!--    item[2]++ (=1) -->
        </OL>           <!--                   -->
      </LI>             <!--   }               -->
      <LI>item</LI>     <!--   item[1]++ (=4)  -->
    </OL>               <!--                   -->
  </LI>                 <!--  }                -->
  <LI>item</LI>         <!--  item[0]++ (=3)   -->
  <LI>item</LI>         <!--  item[0]++ (=4)   -->
</OL>                   <!--                   -->
<OL>                    <!-- }{item[0]=0       -->
  <LI>item</LI>         <!--  item[0]++ (=1)   -->
  <LI>item</LI>         <!--  item[0]++ (=2)   -->
</OL>                   <!--                   -->
```

下面的例子演示了展现了样式如何管理前面带有标记的章节和小结，展示了当计数器用在未被嵌套的元素上时范围的作用机制：

```html
                     <!--"chapter" counter|"section" counter -->
<body>               <!-- {chapter=0      |                  -->
  <h1>About CSS</h1> <!--  chapter++ (=1) | {section=0       -->
  <h2>CSS 2</h2>     <!--                 |  section++ (=1)  -->
  <h2>CSS 2.1</h2>   <!--                 |  section++ (=2)  -->
  <h1>Style</h1>     <!--  chapter++ (=2) |}{ section=0      -->
</body>              <!--                 | }                -->
```

`counters()` 函数可生成一个由所有具有相同名称的计数器构成得字符串，计数器名称之间使用给定的字符串分隔。下面的样式表使用“1”，“1.1”，“1.1.1”的形式为嵌套列表项编号：

```css
OL { counter-reset: item }
LI { display: block }
LI:before { content: counters(item, ".") " "; counter-increment: item }
```

#### 计数器样式

使用`counter(name)`函数获得的计数器的标记格式默认为十进制数字，可以通过向`counter(name, style)`函数的`style`参数传入`list-style-type`属性的某个值来使用其他样式的格式。如果`list-style-image` 属性的值为`none` （表示没有标记，否则有字形、数字和字母三种形式），或者该属性指定的URI不能显示出来，那么`list-style-type` 属性就可以指定列表项标记的外观，其可用的值如下：

```
disc | circle | square | decimal | decimal-leading-zero | lower-roman | upper-roman | lower-greek | lower-latin | upper-latin | armenian | georgian | lower-alpha | upper-alpha | none | inherit
```

字形可用的类型如下：

- disc：圆；
- circle：圆圈；
- square：方块。

字形的具体的效果取决于浏览器的渲染。如果需要在不同浏览器上保持一致的外观，建议使用背景图片来替换指定字形。

数字可用的类型如下：

- decimal：十进制数字，从1开始。这是默认值；
- decimal-leading-zero：初始补零的十进制数字（如01，02，03，...，98，99）；
- lower-roman：小写的罗马数字（如i，ii，iii，iv，v等）；
- upper-roman：大写的罗马数字（如I，II，III，IV，V等）；
- georgian：传统的乔治亚文数字（如an，ban，gan，...，he，tan，in，in-an，...）；
- armenian：传统的大写亚美尼亚数字；



- lower-greek：




















伪类由一个英文冒号紧跟伪类名和一个可选的含有值得圆括号构成。

常用的选择器如下表所示：

"CSS"列表示该选择器在CSS版本（CSS1，CSS2，或CSS3）。

| 选择器                    | 示例                    | 示例说明                                     | CSS  |
| ---------------------- | --------------------- | ---------------------------------------- | ---- |
| .class                 | .intro                | 选择所有class="intro"的元素                     | 1    |
| #id                    | #firstname            | 选择所有id="firstname"的元素                    | 1    |
| *                      | *                     | 选择所有元素                                   | 2    |
| element                | p                     | 选择所有<p>元素                                | 1    |
| selector1,selector2... | div,p,table           | 并列组合关系：选择所有<div>元素、<p>元素和<table>元素       | 1    |
| selector1>selector2    | div>p                 | 父子元素关系：选择所有父级是 <div> 元素的 <p> 元素          | 2    |
| selector1+selector2    | div+p                 | 紧密相连关系：选择所有紧接着<div>元素之后的<p>元素            | 2    |
| selector1 selector2    | div p.intro           | 内部包含关系：                                  | 1    |
| selector1~selector2    | div~p                 | 兄弟选择关系：选择**匹配selector1的**<div>**元素后面**、**匹配selector2的**<p>**元素** | 3    |
|                        |                       |                                          |      |
|                        |                       |                                          |      |
|                        |                       |                                          |      |
|                        |                       |                                          | 2    |
| :link                  | a:link                | 选择所有未访问链接                                | 1    |
| :visited               | a:visited             | 选择所有访问过的链接                               | 1    |
| :active                | a:active              | 选择活动链接                                   | 1    |
| :hover                 | a:hover               | 选择鼠标在链接上面时                               | 1    |
| :focus                 | input:focus           | 选择具有焦点的输入元素                              | 2    |
| :first-letter          | p:first-letter        | 选择每一个&lt;P>元素的第一个字母                      | 1    |
| :first-line            | p:first-line          | 选择每一个&lt;P>元素的第一行                        | 1    |
| :first-child           | p:first-child         | 指定只有当&lt;p>元素是其父级的第一个子级的样式。              | 2    |
| :before                | p:before              | 在每个<p>元素之前插入内容                           | 2    |
| :after                 | p:after               | 在每个&lt;p>元素之后插入内容                        | 2    |
| :lang(language)        | p:lang(it)            | 选择一个lang属性的起始值="it"的所有&lt;p>元素           | 2    |
| element1~element2      | p~ul                  | 选择p元素之后的每一个ul元素                          | 3    |
| [attribute^=value]     | a[src^="https"]       | 选择每一个src属性的值为以"https"开头字符串的元素            | 3    |
| [attribute$=value]     | a[src$=".pdf"]        | 选择每一个src属性的值为以".pdf"结尾的字符串的元素            | 3    |
| [attribute**=value*]   | a[src*="runoob"]      | 选择每一个src属性的值为含有子字符串"runoob"的字符串的元素       | 3    |
| :first-of-type         | p:first-of-type       | 选择每个p元素是其父级的第一个p元素                       | 3    |
| :last-of-type          | p:last-of-type        | 选择每个p元素是其父级的最后一个p元素                      | 3    |
| :only-of-type          | p:only-of-type        | 选择每个p元素是其父级的唯一p元素                        | 3    |
| :only-child            | p:only-child          | 选择每个p元素是其父级的唯一子元素                        | 3    |
| :nth-child(n)          | p:nth-child(2)        | 选择每个p元素是其父级的第二个子元素                       | 3    |
| :nth-last-child(n)     | p:nth-last-child(2)   | 选择每个p元素的是其父级的第二个子元素，从最后一个子项计数            | 3    |
| :nth-of-type(n)        | p:nth-of-type(2)      | 选择每个p元素是其父级的第二个p元素                       | 3    |
| :nth-last-of-type(n)   | p:nth-last-of-type(2) | 选择每个p元素的是其父级的第二个p元素，从最后一个子项计数            | 3    |
| :last-child            | p:last-child          | 选择每个p元素是其父级的最后一个子级。                      | 3    |
| :root                  | :root                 | 选择文档的根元素                                 | 3    |
| :empty                 | p:empty               | 选择每个没有任何子级的p元素（包括文本节点）                   | 3    |
| :target                | #news:target          | 选择当前活动的#news元素（包含该锚名称的点击的URL）            | 3    |
| :enabled               | input:enabled         | 选择每一个已启用的输入元素                            | 3    |
| :disabled              | input:disabled        | 选择每一个禁用的输入元素                             | 3    |
| :checked               | input:checked         | 选择每个选中的输入元素                              | 3    |
| :not(selector)         | :not(p)               | 选择每个并非p元素的元素                             | 3    |
| ::selection            | ::selection           | 匹配元素中被用户选中或处于高亮状态的部分                     | 3    |
| :out-of-range          | :out-of-range         | 匹配值在指定区间之外的input元素                       | 3    |
| :in-range              | :in-range             | 匹配值在指定区间之内的input元素                       | 3    |
| :read-write            | :read-write           | 用于匹配可读及可写的元素                             | 3    |
| :read-only             | :read-only            | 用于匹配设置 "readonly"（只读） 属性的元素              | 3    |
| :optional              | :optional             | 用于匹配可选的输入元素                              | 3    |
| :required              | :required             | 用于匹配设置了 "required" 属性的元素                 | 3    |
| :valid                 | :valid                | 用于匹配输入值为合法的元素                            | 3    |
| :invalid               | :invalid              | 用于匹配输入值为非法的元素                            | 3    |

上面的选择器前面都可以加上具体的某个元素名，表明该选择器是适用于某种元素的选择器。如p#firstname 选择器选择所有id="firstname"的<p>元素。

选择器的匹配规则越严格，其优先级越高。例如，div [abc = xyz]选择器定义的样式会覆盖div[abc]选择器定义的样式。但是，如果div [abc = xyz]选择器定义的样式中没有定义某个属性的具体值，那么div[abc]选择器为该属性定义的属性值依然有效。

## 创建样式表

插入样式表的方法有三种：

- 外部样式表
- 内部样式表
- 内联样式

### 外部样式表

当很多页面需要使用相同页面时，可以在这些页面的<head>标签中使用<link>标签链接到一个外部样式表文件。改动这个引用的外部样式表文件即可改变整个站点的外观。如下面的实例：

```html
<head>
<link rel="stylesheet" type="text/css" href="mystyle.css">
</head>
```

外部样式表文件应该以 “.css” 为扩展名进行保存。下面是一个样式表文件的例子：

```css
hr {color:sienna;}
p {margin-left:20px;}
body {background-image:url("/images/back40.gif");}
```

> 注意：不要在**属性值与单位之间**留有空格（如："margin-left: 20 px" ），正确的写法是 "margin-left: 20px" 。

### 内部样式表

当**单个文档的整个页面**需要特殊的样式时，可以在文档头部使用<style>标签定义内部样式表。如下面的实例：

```html
<head>
	<style>
		hr {color:sienna;}
		p {margin-left:20px;}
		body {background-image:url("images/back40.gif");}
	</style>
</head>
```

### 内联样式

可以通过文档中某个具体的HTML**标签的style属性**来定义仅对该HTML标签对象有效样式。如下面的实例：

```html
<p style="color:sienna; margin-left:20px">This is a paragraph.</p>
```

> 注意：由于要将表现和内容混杂在一起，内联样式会损失掉样式表的许多优势。请慎用这种方法，例如当样式仅需要在一个元素上应用一次时。

### 样式的继承与覆盖

如果某些属性在不同的样式表中被同样的选择器定义，那么属性值将从更具体的样式表中被继承过来。 

样式可以定义在单个的HTML元素中，也可以定义在HTML页面的<head>标签中，还可以定义在一个外部的CSS文件中。甚至可以在同一个HTML文档内部引用多个外部样式表。

如果一个元素的某些样式分别在不同的位置被定义了，那么该元素的实际样式是这些所有样式组合后的效果。也就是说，样式具有继承性。

另外，当同一个HTML元素被不止一个样式定义时，样式应用的优先级规则从低到高依次如下：

1. 浏览器缺省设置
2. 外部样式表
3. 内部样式表（位于<head>标签内部）
4. 内联样式（在 HTML 元素内部）

因此，内联样式（在 HTML 元素内部）拥有最高的优先权，这意味着它将优先于以下的样式声明： <head>标签中的样式声明，外部样式表中的样式声明，或者浏览器中的样式声明（缺省值）。即样式具有覆盖性。

例如，外部样式表拥有针对<h3>标签选择器的三个属性：

```css
h3 {color:red;}
```

而内部样式表拥有针对<h3>标签选择器的两个其他属性：

```css
h3 {text-align:right; font-size:20pt;}
```

而<h3>标签中定义了与前面重复但值不同的内联样式：

```css
h3 {font-size:15pt;}
```

那么，根据以上规则内部样式表的这个页面同时与外部样式表链接，那么<h3>标签实际的样式效果为：

```css
h3 {color:red; text-align:right; font-size:20pt;}
```

即该<h3>标签分别从外部样式表和内部样式表继承了字体颜色属性（color:red）和文字排列属性（text-alignment），虽然也从内部样式表中字体尺寸属性（font-size），但该属性最终会被内部样式表中的规则所取代。



