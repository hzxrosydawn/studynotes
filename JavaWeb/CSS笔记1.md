---
typora-root-url: ./
typora-copy-images-to: appendix
---

# CSS笔记

## 语法

![selector](/appendix/selector.gif)

CSS 规则由两个主要的部分构成：选择器，以及一条或多条声明。

- 选择器通常是需要改变样式的 HTML 元素；
- 每条声明由一个属性和一个值组成；
- 属性（property）是希望设置的样式属性（style attribute），每个属性有一个值。属性和值被冒号分开。

CSS声明总是以英文分号(;)结束，声明组以大括号({})括起来：

```css
p {color:red;text-align:center;}
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

## Id 和 Class 选择器

HTML元素以其id属性来设置 **id 选择器**，CSS 中 id 选择器以 "#" 来定义。如以下的样式规则应用于属性 id="para1"的 HTML 元素：

```css
#para1
{
text-align:center;
color:red;
}
```

**class 选择器**用于描述一组 class 属性为指定值的 HTML 元素的样式。在 CSS 中，类选择器以一个英文点号"."加 class 属性值表示。在以下的例子中，所有拥有 class="center" 的 HTML 元素均为居中：

```css
.center {text-align:center;}
```

或者英文点号之前也可以加元素的名称。如下面的实例中所有 class="center" 的 p 元素的文本居中：

```css
p.center {text-align:center;}
```

> 注意：id和class的名称的第一个字符都不能使用数字！因为这种名称在 Mozilla 或 Firefox 中起作用。

插入样式表的方法有三种：

**外部样式表**：当很多页面需要使用相同页面时，可以在这些页面的 \<head> 标签中使用 \<link> 标签链接到一个外部样式表文件。改动这个引用的外部样式表文件即可改变整个站点的外观。如下面的实例：

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

**内部样式表**：当**单个文档的整个页面**需要特殊的样式时，可以在文档头部使用 \<style> 标签定义内部样式表。如下面的实例：

```html
<head>
<style>
hr {color:sienna;}
p {margin-left:20px;}
body {background-image:url("images/back40.gif");}
</style>
</head>
```

**内联样式**：可以通过文档中某个具体的 HTML **标签的 style 属性**来定义仅对该 HTML 标签对象有效样式。如下面的实例：

```html
<p style="color:sienna;margin-left:20px">This is a paragraph.</p>
```

> 注意：由于要将表现和内容混杂在一起，内联样式会损失掉样式表的许多优势。请慎用这种方法，例如当样式仅需要在一个元素上应用一次时。