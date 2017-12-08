参考：http://www.w3school.com.cn/sql/sql_syntax.asp

##SQL语句简介
**SQL（Structured Query Language，结构化查询语句）**是一门ANSI的标准计算机语言，用来访问和操作数据库系统，取回和更新数据库中的数据。SQL 可与关系型数据库关系系统（Relational Database Management System，即RDBMS，比如 MS Access, SQL Server, MySQL）协同工作，比如MS Access、DB2、Informix、MS SQL Server、Oracle、Sybase以及其他数据库系统。不幸地是，存在着很多不同版本的 SQL 语言，但是为了与 ANSI 标准相兼容，它们必须以相似的方式共同地来支持一些主要的关键词（如SELECT、UPDATE、DELETE、INSERT、WHERE等）。除了SQL标准之外，大部分SQL数据库程序都拥有它们自己的私有扩展！

SQL 可以实现：

- SQL 面向数据库执行查询
- SQL 可从数据库取回数据
- SQL 可在数据库中插入新的记录
- SQL 可更新数据库中的数据
- SQL 可从数据库删除记录
- SQL 可创建新数据库
- SQL 可在数据库中创建新表
- SQL 可在数据库中创建存储过程
- SQL 可在数据库中创建视图
- SQL 可以设置表、存储过程和视图的权限

**标准的SQL语句有以下几种类型**：

- **查询语句**: 主要由select关键字完成，是SQL中功能最多、最复杂的语句；

- **DDL（Database Definition Language，数据库定义语言）语句**：主要由CREATE、ALTER、DROP、TRUNCATE四个关键字构成，用于操作数据库对象；

- **DML(Database Manipulation Language，数据库操作语言)语句**：主要由INSERT、DELETE和UPDATE三个关键字构成，用于在数据库中插入、删除和更新数据；

- **DCL（Database Control Language，数据库控制语言）语句**：主要由grank和revoke两个关键字构成。DCL语句为用于为数据库用户授权，或者回收指定用户的权限，通常无需程序员操作。

>注意：**SQL 对大小写不敏感**，也就是说，SELECT与select是相同的，不过为了便于阅读时分辨内容，一般将SQL语句要素大写。在每条SQL语句的末端使用英文分号标志一条SQL语句的结束。


##查询语句
###SELECT 语句
SELECT 语句用于从数据库中选取数据。结果被存储在一个结果表中，称为**结果集**。可以选取表中一列、多列、所有列的数据。
**查询语法**：

```sql
SELECT column_name1 [, column_name2]... FROM table_name;
```

与

```sql
SELECT * FROM table_name;
```

###SELECT  DISTINCT 语句
在表中，一个列可能会包含多个重复值，有时您也许希望**仅列出不同（DISRINCT）的值**。DISTINCT 关键词用于返回唯一不同的值。如果DISTINCT后跟多个列，则判断重复的依据是多个列的组合。
**唯一查询语句**：

```sql
SELECT DISTINCT column_name1 [, column_name2]... FROM table_name;
```

###子查询语句
子查询就是在查询语句中再嵌套一个查询，可以多层嵌套。子查询可以出现在两个位置：

- 出现在FROM后被当成数据表，实质是一个临时视图，称为行内视图（Inline View）；
- 出现在WHERE条件中作为过滤条件。

使用子查询可以注意一下几点：

- **子查询要用圆括号括起来**；
- 被当成数据表时（在FROM后），可以给其起一个别名。尤其是作为前缀限定数据列时，必须给子查询起别名；
- 当成过滤条件时（在WHERE条件中），**将子查询放在比较运算符的右边可以增加可读性**；
- 当成过滤条件时，**单行子查询使用单行运算符，多行子查询使用多行运算符**。

**子查询实例1**：

```sql
SELECT * FROM student_table 
WHERE java_teacher > (SELECT teacher_id FROM teacher_table WHERE teacher_name = 'Vincent'); 
```

上面的实例中，返回单行、单列的子查询结果被当成了标量处理。如果子查询返回多个值，需要使用IN、ALL、ANY等关键字。

####WHERE 子句
WHERE 子句用于提取那些满足指定条件的记录。WHERE 子句是相当于if条件限定语句，如果没有WHERE 子句，则默认WHERE 子句为TRUE，这样全部记录都会修改。
**WHERE子查询语法**：

```sql
SELECT column_name FROM table_name WHERE condition;
```

其中，"condition"可以为不含列名的条件语句，该条件语句可以是由算术表达式、变量、常量或者函数表达式组成的限定条件。WHERE 子句中的运算符如下表所示：

| 运算符                               | 描述                                       |
| --------------------------------- | ---------------------------------------- |
| =                                 | 等于                                       |
| `<>`                              | 不等于。注释：在 SQL 的一些版本中，该操作符可被写成 !=          |
| >                                 | 大于                                       |
| <                                 | 小于                                       |
| \>=                               | 大于等于                                     |
| <=                                | 小于等于                                     |
| +、-、*、/                           | 四则运算符                                    |
| `:=`                              | 赋值                                       |
| expr1 `BETWEEN` expr2 `AND` expr3 | 在某个范围内(相当于同时指定>=和<=)                     |
| expr1 `IN` (expr2, expr3, ...)    | 为括号中所有值中的一个值                             |
| expr1 WHERE `EXISTS` (expr2)      | 如果expr2有返回记录，则执行expr1。其中expr1、expr2不仅可以是常量、也可以是变量名和列名 |
| `IS NULL`                         | 是否为null                                  |
| `IS NOT NULL`                     | 是否不为null                                 |
| `ANY`                             | 与比较运算符结合表示满足任一比较条件                       |
| `ALL`                             | 与运算符结合使用表示满足所有的比较条件                      |
| `LIKE` pattern                    | 模糊搜索。搜索模式由pattern语句指定                    |
| `NOT LIKE` pattern                | 与LIKE相反                                  |
| expr1 `AND` expr2                 | 同时满足两个条件                                 |
| expr1 `OR` expr2                  | 满足两个条件之一                                 |
| `NOT` expr                        | 不满足某个条件                                  |
| \>ANY (expr)                      | 只要大于expr中的最小值即可                          |
| <ANY (expr)                       | 只要小于expr中的最大值即可                          |
| \>ALL (expr)                      | 只要大于expr中的最大值即可                          |
| <ALL (expr)                       | 只要小于expr中的最小值即可                          |
| =ANY (expr)                       | 相当于IN (expr)                             |
##### LIKE 运算符

SQL中LIKE运算符有几个通配符：

- **下划线"\_"**：匹配**任意单个字符**。
   从"Persons" 表中选取名字的第一个字符之后是 "eorge" 的人：

   ```sql
   SELECT * FROM Persons WHERE FirstName LIKE '_eorge';
   ```

- **百分号"%"**：匹配**任意多个字符**。如果要查找以 "美"开头的字符串，则可以使用：

   ```sql
   SELECT * FROM Persons WHERE FirstName LIKE '美%';
   ```

- **[charlist]**：匹配**字符列中的任意一个字符**。从 "Persons" 表中选取居住的城市以 "A" 或 "L" 或 "N" 开头的人：

   ```sql
   SELECT * FROM Persons WHERE City LIKE '[ALN]%';
   ```

- **[^charlist]或者[!charlist]**：匹配**不在字符列中的所有字符**。从"Persons" 表中选取居住的城市不以 "A" 或 "L" 或 "N" 开头的人：

   ```sql
   SELECT * FROM Persons WHERE City LIKE '[!ALN]%';
   ```

- 如果要匹配**下划线和百分号**本身，则需要使用转译字符，而转译字符可以通过**`ESCAPE`关键字来自定义**。
   使用ESCAPE定义 '\'为转义字符，下面匹配以下划线开头的任意字符：

   ```sql
   SELECT * FROM Persons WHERE LIKE '\\_%' ESCAPE '\';
   ```

##### IN 操作符

IN 操作符允许我们在 WHERE 子句中规定多个值。
**IN 关键字语法1**：

```sql
SELECT column_name(s)
FROM table_name IN (value1,value2,...);
```

上面的语句从column\_name列中查找指定值的数据记录。

**IN 关键字语法2**：

```sql
SELECT column_name(s)
FROM table_name
WHERE column_name2 IN (value1,value2,...);
```

上面的语句从查找column\_name2中值为value1和value2的column_name(s)列记录。

例如，从Persons表中选取姓氏为 Adams 和 Carter 的人：

```sql
SELECT * FROM Persons
WHERE LastName IN ('Adams','Carter');
```

##### BETWEEN 操作符

操作符 BETWEEN AND会选取介于两个值之间的数据范围。这些值可以是数值、文本或者日期。

**BETWEEN 关键字语法**：

```sql
SELECT column_name(s)
FROM table_name
WHERE column_name
BETWEEN value1 AND value2;
```

**BETWEEN 关键字实例1**：

```sql
SELECT * FROM Persons
WHERE LastName
BETWEEN 'Adams' AND 'Carter';
```

上面语句以字母顺序显示介于 "Adams"（包括）和 "Carter"（不包括）之间的人。

**BETWEEN 关键字实例2**：

如需使用上面的例子显示范围之外的人，请使用 NOT 操作符。

```sql
SELECT * FROM Persons
WHERE LastName
NOT BETWEEN 'Adams' AND 'Carter';
```

> **注意：不同的数据库对 BETWEEN AND 操作符的处理方式是有差异的**。某些数据库会列出介于 "Adams" 和 "Carter" 之间的人，但不包括 "Adams" 和 "Carter" ；某些数据库会列出介于 "Adams" 和 "Carter" 之间并包括 "Adams" 和 "Carter" 的人；而另一些数据库会列出介于 "Adams" 和 "Carter" 之间的人，包括 "Adams" ，但不包括 "Carter" 。所以，**请检查你的数据库是如何处理 BETWEEN....AND 操作符的手册！**

####ORDER BY 子句

ORDER BY 关键字用于对结果集按照一个列或者多个列进行排序。
ORDER BY 关键字默认按照升序（可省略表示升序的ASC关键字）对记录进行排序。如果需要按照降序对记录进行排序，您可以使用 DESC关键字。

**ORDER BY 语法**：

```sql
SELECT column_name1 [, column_name2]...
FROM table_name
[WHERE condition]
ORDER BY column_name1 [ASC|DESC] [, column_name2 [ASC|DESC]]...;
```

上面的语法中，优先按column_name1排序，若这样有相同结果，则在此基础上按照column_name2排序，依次类推。

> ascend：升序；descend：降序。

####GROUP BY 子句
GROUP BY关键字用于按照某些列的分组信息（该列中相同的记录为一组）查找数据。

**GROUP BY 关键字语法**：

1. **单列**分组模式

```sql
SELECT column_name1, SUM(column_name2)
FROM table_name
GROUP BY column_name1;
```

上面的语句按照column\_name1列中值相同的记录为分组依据，来排列的column\_name1列和SUM("column_name2")新列组成的行内视图。其中**SUM函数可以换为其他聚合函数**。

实例：

friends_of_pickles

| id   | name     | gender | species | height_cm |
| ---- | -------- | ------ | ------- | --------- |
| 1    | Dave     | male   | human   | 180       |
| 2    | Mary     | female | human   | 160       |
| 3    | Fry      | male   | cat     | 30        |
| 4    | Leela    | female | cat     | 25        |
| 5    | Odie     | male   | dog     | 40        |
| 6    | Jumpy    | male   | dog     | 35        |
| 7    | Sneakers | male   | dog     | 55        |

在上面名为friends_of_pickles的表中，查找出**相同物种记录中的身高最高的记录**：

```sql
SELECT MAX(height_cm), species FROM friends_of_pickles GROUP BY species;
```

结果如下：

| MAX(height_cm) | species |
| -------------- | ------- |
| 30             | cat     |
| 55             | dog     |
| 180            | human   |

2. **多列**分组模式

```sql
SELECT column_name1, column_name2, ... column_nameN, Function(column_nameN+1)
FROM table_name
GROUP BY column_name1, column_name2, ... column_nameN;
```

上面语句从若干表中选出若干列，一般结合SELECT中的至少一个运算符（包括COUNT, SUM, MAX, MIN,  AVG等函数）一起使用，然后在GROUP BY后添加除了参与运算的列以外的全部列，作为分组的参考。即**分组的依据为多列的不同值的组合**。

3. 结合HAVING 子句实现**条件分组** 。

**在 SQL 中增加 HAVING 子句原因是，WHERE 关键字无法与聚合函数一起使用。HAVING 子句可以让我们筛选分组后的各组数据**。

####HAVING 子句

**HAVING 子句语法**：

```sql
SELECT [column_name1], Function(column_name2)
FROM table_name
[WHERE condition]
[GROUP BY column_name1]
HAVING (arithmetic function condition)
[ORDER BY column_name [ASC|DESC]];
```

上面的语句要求只对满足 HAVING 子句中对聚合函数计算结果的筛选条件来进行分组。

####SELECT 中的表达式及别名 
SELECT 之后不仅可以使`列名`或者`*`，还可以是`算术表达式`、`变量`、`常量`或者`函数表达式`，还可以在 SELECT 语句中使用`算术运算符`（+、-、*、/），从而形成算术表达式，规则如下：

- 对于列值为数值型的列可以使用“+、-、*、/”与变量和常量运算；
- 对于列值为时间、日期型的列可以使用“+、-”与变量和常量运算；
- 运算符不仅可以在列、常量和变量之间运算，还可以在多列之间运算。  

也可以为**算术表达式、变量、常量或者函数表达式**使用 AS 关键字起一个别名，**如果别名中包含特殊字符，或者强制大小写敏感，可以为别名添加双引号或方括号**。

在下面的情况下，使用别名很有用：

- 在查询中涉及超过一个表；
- 在查询中使用了函数；
- 列名称很长或者可读性差；
- 需要把两个列或者多个列结合在一起。

**表的起别名语法**：

```sql
SELECT column_name1 [, column_name2]....
FROM table_name AS alias_name
WHERE [condition];
```

**列的起别名语法**：

```sql
SELECT column_name AS alias_name
FROM table_name
WHERE [condition];
```

**实例1**：

```sql
SELECT Id+5 "My Id",  Firsname [My Name],  2*3 [My Num]
FROM Person
WHERE  id > 3;
```

如果需要选择多列，每列都要起别名，那么可以省略 AS 关键字。

**实例2**：

```sql
SELECT Id + 5 "My Id", CONCAT(Firstname, Lastname) "My Name"
FROM  Person person_table
WHERE  id > 3;
```

**可以使用圆括号将几个列组合在一起创建一个别名**。

**实例3**：

```sql
SELECT o.OrderID, o.OrderDate, c.CustomerName
FROM Customers AS c, Orders AS o
WHERE c.CustomerName = 'Alfreds Futterkiste';
```

上面的例子与下面不使用别名的例子作用相同：

```sql
SELECT Orders.OrderID, Orders.OrderDate, Customers.CustomerName
FROM Customers, Orders
WHERE Customers.CustomerName='Alfreds Futterkiste';
```

####TOP, LIMIT, ROWNUM子句
TOP 子句用于规定要返回的记录的数目。对于拥有数千条记录的大型表来说，TOP 子句是非常有用的。

> 注意：并非所有的数据库系统都支持 TOP 子句。

**SQL Server / MS Access 语法**：

```sql
SELECT TOP number [PERCENT] column_name(s)
FROM table_name
```

按具体数目或百分比显示结果。

**实例1**：

```sql
SELECT TOP 2 * FROM Persons;
```

上面的实例用于从上面的 "Persons" 表中选取头两条记录

**实例2**：

```sql
SELECT TOP 50 PERCENT * FROM Persons;
```

上面的实例用于从上面的 "Persons" 表中选取 50% 的记录。

注意：MySQL 和 Oracle 中的 SQL SELECT TOP 是等价的。不过，一般MySQL使用LIMIT关键字，而Oracle使用ROWNUM关键字。

**MySQL 语法**：

```sql
SELECT column_name(s)
FROM table_name
LIMIT number;
```

**Oracle 语法**：

```sql
SELECT column_name(s)
FROM table_name
WHERE ROWNUM <= number;
```

##连接查询
 连接查询通过JOIN关键字及其衍生类型完成。JOIN 子句用于把来自两个或多个表的行结合起来，得到完整的结果。

- INNER JOIN：在表中存在至少一个匹配时返回行；
- LEFT JOIN：即使右表中没有匹配，也从左表返回所有的行；
- RIGHT JOIN：即使左表中没有匹配，也从右表返回所有的行；
- FULL JOIN：只要其中一个表中存在匹配，就返回行。
###INNER JOIN
INNER JOIN （内连接，也叫等值连接）关键字在表中存在至少一个匹配时返回行。
![image_innerjoin](http://img.blog.csdn.net/20161122200108458)
**INNER JOIN 语法**：

```sql
SELECT column_name(s)
FROM table1
[INNER] JOIN table2
ON table1.column_name = table2.column_name;
```

上面语句依据ON子句的连接条件连接两个表，并返回两表**共有**（共有的依据是连接条件）的数据记录。

> 注释：**INNER JOIN 与 JOIN 是相同的**。

###LEFT JOIN关键字
LEFT JOIN 关键字从左表（table1）返回所有的行，即使右表（table2）中没有匹配。如果右表中没有匹配，则结果为 NULL。
![img_leftjoin](http://img.blog.csdn.net/20161122200219593)
**LEFT JOIN语法**：

```sql
SELECT column_name(s)
FROM table1
LEFT [OUTER] JOIN table2
ON table1.column_name=table2.column_name;
```

> 注释：在某些数据库中，LEFT JOIN 称为 **LEFT OUTER JOIN**。

###RIGHT JOIN关键字
RIGHT JOIN 关键字从右表（table2）返回所有的行，即使左表（table1）中没有匹配。如果左表中没有匹配，则结果为 NULL。
![img_rightjoin](http://img.blog.csdn.net/20161122200508834)
**RIGHT JOIN语法**：

```sql
SELECT column_name(s)
FROM table1
RIGHT [OUTER] JOIN table2
ON table1.column_name=table2.column_name;
```

> 注释：在某些数据库中，RIGHT JOIN 称为 **RIGHT OUTER JOIN**。

###FULL JOIN关键字

FULL OUTER JOIN 关键字只要左表（table1）和右表（table2）其中一个表中存在匹配，则返回行。
FULL OUTER JOIN 关键字结合了 LEFT JOIN 和 RIGHT JOIN 的结果。
![img_fulljoin](http://img.blog.csdn.net/20161122200732616)
**FULL OUTER JOIN 语法**：
SELECT column_name(s)
FROM table1
FULL OUTER JOIN table2
ON table1.column\_name=table2.column_name;
注意：My SQL不支持FULL JOIN,不过可以通过 UNION 关键字来合并 LEFT JOIN 与 RIGHT JOIN来模拟FULL JION。
###CROSS JOIN关键字
CROSS JOIN 关键字用于将两个表的数据分别相乘，得到一个N*M的组合，称为广义笛卡尔积。实际很少用到。
**CROSS JOIN语法**：
SELECT column_name(s)
FROM table1
CROSS  JOIN table2
##DML语句
DML 语句主要用于操作表格中的数据，常用的功能有 INSERT INTO / UPDATE / DELETE FROM 数据表的数据。
###INSERT INTO语句

INSERT INTO 语句用于向数据表中插入一行或者多行数据，可以有两种编写形式。

1. **无需指定要插入数据的列名，只需提供被插入的值即可**：

   ```sql
   INSERT INTO table_name
   VALUES (value1,value2,value3...);
   ```

2. **需要指定列名及被插入的值**：

   ```sql
   INSERT INTO table_name (column1,column2,column3...)
   VALUES (value1,value2,value3...);
   ```

**通过带子查询的插入语句一次插入多行记录的语法**：

```sql
INSERT INTO  table_name1 [(column_name1 [, column_name2]...)]  
SELECT (column_name3 [, column_name4]...) 
FROM table_name2 
[WHERE condition];
```

**实例**：

```sql
INSERT INTO Person (Firstname, Lastname) VALUES ('Katy', 'Perry');
```

**注意**：

- 如果省略了数据表名后的所有列，则默认为所有列按列的顺序从左往右依次插入值；

- 如果不想列出列名，又不想指定所有列的值，则可以为那些无法确定值的列分配null。如：

  ```sql
  #如果已经指定Id列为主键列，则插入一条新数据时，主键列会自增，系统会自动分配该行主键的值
  #所以下面一行的主键赋值为null没有问题，系统会自动添加相应的值
  INSERT INTO Person values(NULL, NULL,  NULL, '北清路', '北京市');
  ```

- 因为外键列的值必须是被参照列的已有值，所以向从表中插入记录之前，应该先向主表中插入记录，否则从表外键列就只能为NULL。外键列不保证必须存在被参照的记录，故外键列可以为NULL，如果想保证从表的每条记录都有对应的主表记录存在，则添加非空、外键两个约束。

###UPDATE 语句
UPDATE 语句用于一次性修改数据表的一条或多条记录，通过where子句限定修改哪些行的记录。

**UPDATE语法**：

```sql
UPDATE table_name
SET column_name1 = value1 [, clomun_name2 = value2]...
WHERE condition;
```

其中，"condition"可以为不含列名的条件语句，该条件语句可以是由算术表达式、变量、常量或者函数表达式组成的限定条件。详见WHERE子句介绍。

###DELETE FROM 语句
DELETE FROM 语句可以根据指定条件删除指定表的一行或多行记录。

**删除一行或多行记录的语法**：

```sql
DELETE FROM table_name
[WHERE condition];
```

**注意**：

- **当主表记录被从表记录参照时，主表记录不能被删除，只有先将主表中被参照的记录删除后，才可以删除从表记录**；
- 如果定义外键约束时定义了主表记录和从表记录之间的级联删除ON DELETE CASCADE，或者使用ON DELETE SET NULL用于指定当主表记录被删除时，从表中的参照记录把外键列的值设为NULL。
##数据类型
###通用的数据类型
| 数据类型                             | 描述                                       |
| -------------------------------- | ---------------------------------------- |
| CHARACTER(n)                     | 字符/字符串。固定长度 n。                           |
| VARCHAR(n) 或CHARACTER VARYING(n) | 字符/字符串。可变长度。最大长度 n。                      |
| BINARY(n)                        | 二进制串。固定长度 n。                             |
| BOOLEAN                          | 存储 TRUE 或 FALSE 值                        |
| VARBINARY(n)或BINARY VARYING(n)   | 二进制串。可变长度。最大长度 n。                        |
| INTEGER(p)                       | 整数值（没有小数点）。精度 p。                         |
| SMALLINT                         | 整数值（没有小数点）。精度 5。                         |
| INTEGER                          | 整数值（没有小数点）。精度 10。                        |
| BIGINT                           | 整数值（没有小数点）。精度 19。                        |
| DECIMAL(p,s)                     | 精确数值，精度 p，小数点后位数 s。例如：decimal(5,2) 是一个小数点前有 3 位数小数点后有 2 位数的数字。 |
| NUMERIC(p,s)                     | 精确数值，精度 p，小数点后位数 s。（与 DECIMAL 相同）        |
| FLOAT(p)                         | 近似数值，尾数精度 p。一个采用以 10 为基数的指数计数法的浮点数。该类型的 size 参数由一个指定最小精度的单一数字组成。 |
| REAL                             | 近似数值，尾数精度 7。                             |
| FLOAT                            | 近似数值，尾数精度 16。                            |
| DOUBLE PRECISION                 | 近似数值，尾数精度 16。                            |
| DATE                             | 存储年、月、日的值。                               |
| TIME                             | 存储小时、分、秒的值。                              |
| TIMESTAMP                        | 存储年、月、日、小时、分、秒的值。                        |
| INTERVAL                         | 由一些整数字段组成，代表一段时间，取决于区间的类型。               |
| ARRAY                            | 元素的固定长度的有序集合                             |
| MULTISET                         | 元素的可变长度的无序集合                             |
| XML                              | 存储 XML 数据                                |
###数据类型快速参考手册
然而，不同的数据库对数据类型定义提供不同的选择。下面的表格显示了各种不同的数据库平台上一些数据类型的通用名称：
| 数据类型              | Access                     | SQLServer                                | Oracle              | MySQL          | PostgreSQL          |
| ----------------- | -------------------------- | ---------------------------------------- | ------------------- | -------------- | ------------------- |
| boolean           | Yes/No                     | Bit                                      | Byte                | N/A            | Boolean             |
| integer           | Number (integer)           | Int                                      | Number              | Int<br>Integer | Int<br>Integer      |
| float             | Number (single)            | Float<br>Real                            | Number              | Float          | Numeric             |
| currency          | Currency                   | Money                                    | N/A                 | N/A            | Money               |
| string (fixed)    | N/A                        | Char                                     | Char                | Char           | Char                |
| string (variable) | Text (<256)<br>Memo (65k+) | Varchar                                  | Varchar<br>Varchar2 | Varchar        | Varchar             |
| binary object     | OLE Object Memo            | Binary (fixed up to 8K)<br>Varbinary (<8K)<br>Image(<2GB) | Long<br>Raw         | Blob<br>Text   | Binary<br>Varbinary |
注释：在不同的数据库中，同一种数据类型可能有不同的名称。即使名称相同，尺寸和其他细节也可能不同！ 请总是检查文档！

###Microsoft Access 数据类型

| 数据类型          | 描述                                       | 存储              |
| ------------- | ---------------------------------------- | --------------- |
| Text          | 用于文本或文本与数字的组合                            | 最多 255 个字符      |
| Memo          | Memo 用于更大数量的文本。<br>注意：无法对 memo 字段进行排序。不过它们是可搜索的 | 最多存储 65,536 个字符 |
| Byte          | 允许 0 到 255 的数字                           | 1 字节            |
| Integer       | 允许介于 -32,768 到 32,767 之间的数字              | 2 字节            |
| Long          | 允许介于 -2,147,483,648 与 2,147,483,647 之间的全部数字 | 4 字节            |
| Single        | 单精度浮点。处理大多数小数                            | 4 字节            |
| Double        | 双精度浮点。处理大多数小数                            | 8 字节            |
| Currency      | 用于货币。支持 15 位的元，外加 4 位小数。<br>注释：您可以选择使用哪个国家的货币。 | 8 字节            |
| AutoNumber    | AutoNumber 字段自动为每条记录分配数字，通常从 1 开始。       | 4 字节            |
| Date/Time     | 用于日期和时间                                  | 8 字节            |
| Yes/No        | 逻辑字段，可以显示为 Yes/No、True/False 或 On/Off。<br>在代码中，使用常量 True 和 False （等价于 1 和 0）<br>注释：Yes/No 字段中不允许 Null 值 | 1 比特            |
| Ole Object    | 可以存储图片、音频、视频或其他 BLOBs (Binary Large OBjects) | 最多 1GB          |
| Hyperlink     | 包含指向其他文件的链接，包括网页                         |                 |
| Lookup Wizard | 允许你创建一个可从下列列表中进行选择的选项列表                  | 4 字节            |

###MySQL 数据类型
在 MySQL 中，有三种主要的类型：文本、数字和日期/时间类型。
**Text 类型：**
| 数据类型             | 描述                                       |
| ---------------- | ---------------------------------------- |
| CHAR(size)       | 保存固定长度的字符串（可包含字母、数字以及特殊字符）。在括号中指定字符串的长度。最多 255 个字符。 |
| VARCHAR(size)    | 保存可变长度的字符串（可包含字母、数字以及特殊字符）。在括号中指定字符串的最大长度。最多 65535 个字符。<br>注释：如果值的长度大于 65535，则被转换为 TEXT 类型。 |
| TINYTEXT         | 存放最大长度为 255 个字符的字符串。                     |
| TEXT             | 存放最大长度为 65,535 个字符的字符串。                  |
| BLOB             | 用于 BLOBs (Binary Large OBjects)。存放最多 65,535 字节的数据。 |
| MEDIUMTEXT       | 存放最大长度为 16,777,215 个字符的字符串。              |
| MEDIUMBLOB       | 用于 BLOBs (Binary Large OBjects)。存放最多 16,777,215 字节的数据。 |
| LONGTEXT         | 存放最大长度为 4,294,967,295 个字符的字符串。           |
| LONGBLOB         | 用于 BLOBs (Binary Large OBjects)。存放最多 4,294,967,295 字节的数据。 |
| ENUM(x,y,z,etc.) | 允许你输入可能值的列表。可以在 ENUM 列表中列出最大 65535 个值。如果列表中不存在插入的值，则插入空值。<br>注释：这些值是按照你输入的顺序存储的。可以按照此格式输入可能的值：ENUM('X','Y','Z') |
| SET              | 与 ENUM 类似，SET 最多只能包含 64 个列表项，不过 SET 可存储一个以上的值。 |
**Number 类型**：
| 数据类型            | 描述                                       |
| --------------- | ---------------------------------------- |
| TINYINT(size)   | -128 到 127 常规。0 到 255 无符号*。在括号中规定最大位数。   |
| SMALLINT(size)  | -32768 到 32767 常规。0 到 65535 无符号*。在括号中规定最大位数。 |
| MEDIUMINT(size) | -8388608 到 8388607 普通。0 to 16777215 无符号*。在括号中规定最大位数。 |
| INT(size)       | -2147483648 到 2147483647 常规。0 到 4294967295 无符号*。在括号中规定最大位数。 |
| BIGINT(size)    | -9223372036854775808 到 9223372036854775807 常规。0 到18446744073709551615 无符号*。在括号中规定最大位数。 |
| FLOAT(size,d)   | 带有浮动小数点的小数字。在括号中规定最大位数。在 d 参数中规定小数点右侧的最大位数。 |
| DOUBLE(size,d)  | 带有浮动小数点的大数字。在括号中规定最大位数。在 d 参数中规定小数点右侧的最大位数。 |
| DECIMAL(size,d) | 作为字符串存储的 DOUBLE 类型，允许固定的小数点。             |
这些整数类型拥有额外的选项 UNSIGNED。通常，整数可以是负数或正数。如果添加 UNSIGNED 属性，那么范围将从 0 开始，而不是某个负数。

**Date 类型：**

| 数据类型        | 描述                                       |
| ----------- | ---------------------------------------- |
| DATE()      | 日期。格式：YYYY-MM-DD。支持的范围是从 '1000-01-01' 到 '9999-12-31' |
| DATETIME()  | 日期和时间的组合。格式：YYYY-MM-DD HH:MM:SS。支持的范围是从'1000-01-01 00:00:00' 到 '9999-12-31 23:59:59' |
| TIMESTAMP() | 时间戳。TIMESTAMP 值使用 Unix 纪元('1970-01-01 00:00:00' UTC) 至今的描述来存储。格式：YYYY-MM-DD HH:MM:SS。支持的范围是从 '1970-01-01 00:00:01' UTC 到 '2038-01-09 03:14:07' UTC |
| TIME()      | 时间。格式：HH:MM:SS 注释：支持的范围是从 '-838:59:59' 到 '838:59:59' |
| YEAR()      | 2 位或4位格式的年。4 位格式所允许的值：1901 到 2155。2 位格式所允许的值：70 到 69，表示从 1970 到 2069。 |

* 即便 DATETIME 和 TIMESTAMP 返回相同的格式，它们的工作方式很不同。在 INSERT 或 UPDATE 查询中，TIMESTAMP 自动把自身设置为当前的日期和时间。TIMESTAMP 也接受不同的格式，比如 YYYYMMDDHHMMSS、YYMMDDHHMMSS、YYYYMMDD 或 YYMMDD。


###SQL Server 数据类型
**Character 字符串：**
| 数据类型         | 描述                             | 存储   |
| ------------ | ------------------------------ | ---- |
| char(n)      | 固定长度的字符串。最多 8,000 个字符。         | n    |
| varchar(n)   | 可变长度的字符串。最多 8,000 个字符。         |      |
| varchar(max) | 可变长度的字符串。最多 1,073,741,824 个字符。 |      |
| text         | 可变长度的字符串。最多 2GB 字符数据。          |      |
**Unicode 字符串：**
| 数据类型          | 描述                                   | 存储   |
| ------------- | ------------------------------------ | ---- |
| nchar(n)      | 固定长度的 Unicode 数据。最多 4,000 个字符。       |      |
| nvarchar(n)   | 可变长度的 Unicode 数据。最多 4,000 个字符。       |      |
| nvarchar(max) | 可变长度的 Unicode 数据。最多 536,870,912 个字符。 |      |
| ntext         | 可变长度的 Unicode 数据。最多 2GB 字符数据。        |      |
**Binary 类型：**

| 数据类型           | 描述            | 存储           |
| -------------- | ------------- | ------------ |
| bit            | 允许 0、1 或 NULL |              |
| binary(n)      | 固定长度的二进制数据。   | 最多 8,000 字节。 |
| varbinary(n)   | 可变长度的二进制数据。   | 最多 8,000 字节。 |
| varbinary(max) | 可变长度的二进制数据。   | 最多 2GB 字节。   |
| image          | 可变长度的二进制数据。   | 最多 2GB。      |

**Number 类型：**
| 数据类型         | 描述                                       | 存储       |
| ------------ | ---------------------------------------- | -------- |
| tinyint      | 允许从 0 到 255 的所有数字                        | 1 字节     |
| smallint     | 允许从 -32,768 到 32,767 的所有数字。              | 2 字节     |
| int          | 允许从 -2,147,483,648 到 2,147,483,647 的所有数字。 | 4 字节     |
| bigint       | 允许介于 -9,223,372,036,854,775,808 和 9,223,372,036,854,775,807 之间的所有数字。 | 8 字节     |
| decimal(p,s) | 固定精度和比例的数字。允许从 -10^38 +1 到 10^38 -1 之间的数字。<br>p 参数指示可以存储的最大位数（小数点左侧和右侧）。p 必须是 1 到 38 之间的值。默认是 18。<br>s 参数指示小数点右侧存储的最大位数。s 必须是 0 到 p 之间的值。默认是 0。 | 5-17 字节  |
| numeric(p,s) | 固定精度和比例的数字。允许从 -10^38 +1 到 10^38 -1 之间的数字。<br>p 参数指示可以存储的最大位数（小数点左侧和右侧）。p 必须是 1 到 38 之间的值。默认是 18。<br>s 参数指示小数点右侧存储的最大位数。s 必须是 0 到 p 之间的值。默认是 0。 | 5-17 字节  |
| smallmoney   | 介于 -214,748.3648 和 214,748.3647 之间的货币数据。 | 4 字节     |
| money        | 介于 -922,337,203,685,477.5808 和 922,337,203,685,477.5807 之间的货币数据。 | 8 字节     |
| float(n)     | 从 -1.79E + 308 到 1.79E + 308 的浮动精度数字数据。 参数 n 指示该字段保存 4 字节还是 8 字节。float(24) 保存 4 字节，而 float(53) 保存 8 字节。n 的默认值是 53。 | 4 或 8 字节 |
| real         | 从 -3.40E + 38 到 3.40E + 38 的浮动精度数字数据。    | 4 字节     |
**Date 类型：**
| 数据类型           | 描述                                       | 存储         |
| -------------- | ---------------------------------------- | ---------- |
| datetime       | 从 1753 年 1 月 1 日 到 9999 年 12 月 31 日，精度为 3.33 毫秒。 | 8 bytes    |
| datetime2      | 从 1753 年 1 月 1 日 到 9999 年 12 月 31 日，精度为 100 纳秒。 | 6-8 bytes  |
| smalldatetime  | 从 1900 年 1 月 1 日 到 2079 年 6 月 6 日，精度为 1 分钟。 | 4 bytes    |
| date           | 仅存储日期。从 0001 年 1 月 1 日 到 9999 年 12 月 31 日。 | 3 bytes    |
| time           | 仅存储时间。精度为 100 纳秒。                        | 3-5 bytes  |
| datetimeoffset | 与 datetime2 相同，外加时区偏移。                   | 8-10 bytes |
| timestamp      | 存储唯一的数字，每当创建或修改某行时，该数字会更新。timestamp 基于内部时钟，不对应真实时间。每个表只能有一个 timestamp 变量。 |            |
**其他数据类型：**
| 数据类型             | 描述                                       |
| ---------------- | ---------------------------------------- |
| sql_variant      | 存储最多 8,000 字节不同数据类型的数据，除了 text、ntext 以及 timestamp。 |
| uniqueidentifier | 存储全局标识符 (GUID)。                          |
| xml              | 存储 XML 格式化数据。最多 2GB。                     |
| cursor           | 存储对用于数据库操作的指针的引用。                        |
| table            | 存储结果集，供稍后处理。                             |


##DDL 语句
其中，可供操作的"数据库对象"一般有：database、table、index、view、function、 procedure、trigger、constraint等。

###CREATE 语句
用于创建数据库对象（如database、table、index、view、schema、domain等）。
####**创建数据库语法**：
```sql
CREATE DATABASE [IF NOT EXISTS] database_name;
```

> 注意：database_name为数据库名，不要加引号。

####**创建数据表语法**：
```sql
CREATE TABLE [IF NOT EXISTS] table_name
(column_name1 datatype [default expr] [column_name1 constraint(s)],
column_name2 datatype [default expr] [column_name2 constraint(s)],
... 
[table constraint(s)] );
```

有时候也可以使用子查询语句来代替列定义：

```sql
CREATE TABLE table_name AS [SQL Statement];
```

**注意**：

- 表名和列名必须以字母开头，后面可跟不超过30个字符的字母、数字和下划线的组合，表名和列名不能使用SQL的保留字（如select、drop等）；
- 也可使用 INSERT INTO 语句向空表写入数据；
- **不同数据库所允许的数据类型不同，务必参考所用数据库的参考手册**。

**创建数据表实例**：

1.

```sql
CREATE TABLE Customer(
  	First_Name char(50),
	Last_Name char(50),
	Address char(50),
	City char(50),
	Country char(25) default 'United States',
	Birth_Date datetime);
```

2.

```sql
CREATE TABLE Table2 AS SELECT * FROM Table1;
```

####**创建视图语法**：
create用于创建某些数据库对象(table、view、databse等)时可以接受子查询语句：

```sql
CREATE  [OR REPLACE] VIEW "view_name" AS "SQL Statement"  [with check option/with read only];
```

多数数据库使用with check option表示视图无法修改， Oracle采用with read only。**视图是映射的结果，即数据表中数据改变时，视图中的记录同样会改变，适用于多次复杂查询时来减少重复查询次数**。

**创建视图实例**：

```sql
CREATE VIEW V_Customer AS SELECT First_Name, Last_Name, Country FROM Customer;
```

####**创建索引语法**：

**索引介绍**：

- 索引 (Index) 就相当于书本的目录，**便于快速查找**。索引虽然从属于数据表，但它和数据表一样属于数据库对象，独立存放于系统表中。在不读取整个表的情况下，索引使数据库应用程序可以更快地查找数据；
- 更新一个包含索引的表需要比更新一个没有索引的表花费更多的时间，这是由于索引本身也需要更新。为了提高性能，理想的做法是仅仅在常常被搜索的列（以及表）上面必要地创建索引。即使创建索引，索引的类型最好是整型。即使不是整型，可以考虑创建代理整型键，或者直接使用一个类型为整型、与被索引列的记录一一对应的一个列；
- 索引的命名并没有一个固定的方式。通常会用的方式是在名称前加一个字首，例如 "IDX_" ，来避免与资料库中的其他物件混淆。另外，在索引名之内包括表格名及栏位名也是一个好的方式；
- 当在数据表上定义主键约束、唯一约束和外键约束时，系统会为该数据列自动创建对应的索引；
- 只能为一张表创建索引，多张表则不行。创建索引的列必须NOT NULL。

创建一般索引，允许出现有两行拥有相同的索引值：

```sql
CREATE INDEX index_name ON table_name (column_name1 [, column_name2]...);
```

创建**唯一索引**，唯一的索引意味着任意两行不能拥有相同的索引值：

```sql
CREATE UNIQUE INDEX index_name ON table_name (column_name1 [, column_name2]...);
```

**创建索引实例**：

对**单列**创建索引：

```sql
CREATE UNIQUE INDEX IDX_Person_Firstname ON TABLE Person (Firstname); #不允许出现重复的Firstname的记录
```

同时对多列创建索引：

```sql
CREATE INDEX IDX_Person_Name ON TABLE Person (Firstname, Lastname); #可以出现Firstname和Lastname都相同的记录
```

###DROP命令
DROP命令用于删除数据库对象(如DATABASE、TABLE等)
####**删除数据库语法**：
```sql
DROP DATABASE  databse_name;
```

####**删除数据表语法**：
```sql
DROP TABLE [IF IF EXISTS] table_name1 [, table_name2] ...;
```

> 注意：可以一次删除多个表。删除表之后，表的结构、所有数据、相关的索引和约束也删除了

####**删除索引语法**：
用于 MS SQL Server 的drop index语法：

```sql
DROP INDEX table_name.index_name;
```

用于 DB2/Oracle 的drop index语法：

```sql
DROP INDEX index_name;
```

用于 MySQL 的drop index语法：

```sql
ALTER TABLE table_name DROP INDEX index_name;
```

####**删除视图语法**：
```sql
DROP VIEW view_name;
```

###ALTER TABLE语句
- **`ALTER TABLE`用于修改数据表，包括增加、删除、重命名列等操作。ALTER TABLE也可以被用来作其他的改变，例如改变主键定义**；

- **修改数据表里的已有数据有可能会失败，因为修改的结果有可能与定义原数据的规则不一致**；

- **修改数据列的默认值只会对后续插入的数据有效，对已存在的数据没有影响**。

  **修改数据表的语法** ：

  ```sql
  ALTER TABLE table_name [alter_method];
  ```

  上面语句中的`[alter_method]` 的详细写法会依我们想要达到的目标而有所不同。`[alter_method]`如下： 
   **添加一列** ：

  ```sql
  ADD column_name  "data type of column_name"  [default "default value"][constraint(s)_name1];
  ```

   **添加多列** ：

  ```sql
  ADD 
  column_name1  "data type of column1" [default "default value1"][constraint(s)_name1], 
  column_name2  "data type of column2" [default "default value2"][constraint(s)_name2];
  ```

   **添加实例**：

   ```sql
  ALTER TABLE Hehe ADD hehe_id int; #添加一列，类型为int
   ```

  ```sql
  ALTER TABLE Hehe ADD aaa varchar(255), bbb varchar(255) default‘xxx’); #添加多列，并指定默认值
  ```

  > 注意：**在增加列时，如果数据表中已有其他列数据记录，除非给新增的列添加了默认值，否则新增的列不能指定为非空约束，因为已有记录在新增列上肯定是空的**。

   **删除列**：

  ```sql
  ALTER TABLE table_name DROP COLUMN column_name; #请注意，某些数据库系统不允许这种在数据库表中删除列的方式。
  ```

  **改变列的数据类型**：

   SQL Server / MS Access：

  ```sql
  ALTER TABLE table_name ALTER COLUMN column_name data_type;
  ```

   My SQL / Oracle：

  ```sql
  ALTER TABLE table_name MODIFY COLUMN column_name datatype;
  ```

  **完全改变列定义**：

  ```sql
  CHANGE old column_name new column_name data_type_of_new_column_name1 [DEFAULT  "default value"][FIRST | AFTER one_column_name];
  ```

  **修改列数据类型**：
   My SQL的MODIFY命令一次只能修改一列，可以连续添加多个MODIFY语句完成修改多列的类型：

  ```sql
   MODIFY column_name1  new_data_type_of_column_name1 [default "defalut value1"];
  ```

   其他数据库可以同时修改多个数据列，MODIFY同时修改多个列类型定义的语法类似于ADD添加多列的语法。

   **重命名数据表名**：

  ```sql
  RENAME TO new_table_name;
  ```

   **为某列添加索引**：

  ```sql
  ADD INDEX index_name(column_name1);
  ```

   **删除索引**：

  ```sql
  DROP INDEX index_name;
  ```

   **添加约束**：

  ```sql
  ADD CONSTRAINT conatraint_name type_of_constraint(column_name1);
  ```

   **删除约束**：

  ```sql
  DROP CONSTRAIN | INDEX constraint_name;
  ```

  > PS：INDEX用在MySQL，CONSTRAINT用在Orcle和SQL Server

  > 注意：**` [alter_method]`可以为花括号括起来的多个列定义（多个ADD、MODIFY语句）。另外，ADD的列在原表中不存在，ALTER和MODIFY的列必须已存在**。

  **ALTER TABLE语法实例**：

  ```sql
  ALTER TABLE Person ADD gender char(6) default 'male';
  ALTER TABLE Person DROp gender;
  ALTER TABLE Person CHANGE Address Addr char(50);
  ALTER TABLE Person MODIFY Addr char(60) after Id;
  ALTER TABLE Person RENAME TO Students;
  ```
###TRUNCATE TABLE语句
TRUNCATE TABLE命令用于清空一个数据表的内容，与DROP TABLE相比，该命令不会删除数据表，数据表依然存在。
**清除表结构的语法**：

```sql
TRUNCATE TABLE table_name;
```

###**USE关键字**
USE关键字用在MySQL and SQL Server中，用于使用一个数据库。一般用于操作一个数据库。

**使用数据库的语法**：

```sql
USE database_name;
```

在MySQL中可以通过指定 [Database Name].[Table Name]来使用多个数据库的多张表，如果某张表所在的数据正在使用中，可以省略数据库名：

```sql
USE Scores;
SELECT ... 
FROM Course_110, Personnel.Students 
WHERE ... ;
```

上面的实例中使用COurse_110, Personnel.Students数据库中某些表。


##约束（CONSTRAINTS）
用于限制加入表的数据的类型。可以在创建表时规定约束（通过 CREATE TABLE 语句），或者在表创建之后也可以（通过 ALTER TABLE 语句）。
主要有以下几种约束：

- NOT NULL, 非空约束：确保某列的值不为null；
- DEFAULT, 默认约束：为非空列提供某一默认值；
- UNIQUE, 唯一约束：某列的值不可重复；
- Primary Key，主键约束：用于唯一表示一行记录；
- Foreign Key，外键约束：指定该行记录从属于主表的一条记录，保证参照的完整性；
- CHECK, 检查：用于保证每列的所有值都满足一个布尔表达式。

根据约束的范围分为：单行约束和多行约束。

###NOT NULL 约束
NOT NULL 约束强制列不接受 NULL 值.如果不向字段添加值，就无法插入新记录或者更新记录。
下面的 SQL 语句强制 "Id_P" 列和 "LastName" 列不接受 NULL 值：

```mysql
CREATE TABLE Persons (
	Id_P int NOT NULL,
	LastName varchar(255) NOT NULL,
	FirstName varchar(255),
	Address varchar(255),
	City varchar(255)
);
```

###UNIQUE 约束
UNIQUE 约束唯一标识数据库表中的每条记录。
**创建表时添加唯一约束的介绍**：

1. **为单列创建 UNIQUE 约束**语法：

   MySQL：

```mysql
CREATE TABLE Persons (
	Id_P int NOT NULL,
	LastName varchar(255) NOT NULL,
	FirstName varchar(255),
	Address varchar(255),
	City varchar(255),
	UNIQUE (Id_P)
);
```

 	SQL Server / Oracle / MS Access：

```mysql
CREATE TABLE Persons (
	Id_P int NOT NULL UNIQUE,
	LastName varchar(255) NOT NULL,
	FirstName varchar(255),
	Address varchar(255),
	City varchar(255)
);
```

2. 如果要**为多个列定义 UNIQUE 约束（唯一标识多列的组合）**，请使用下面的表级语法：

  ​MySQL / SQL Server / Oracle / MS Access：

```mysql
CREATE TABLE Persons (
	Id_P int NOT NULL,
	LastName varchar(255) NOT NULL,
	FirstName varchar(255),
	Address varchar(255),
	City varchar(255),
	CONSTRAINT uc_PersonID UNIQUE (Id_P,LastName)
)
```

**修改表时添加唯一约束的介绍**：

1. 当表已被创建时添加单列约束。如需在 "Id_P" 列创建 **单列UNIQUE 约束**：

   MySQL / SQL Server / Oracle / MS Access：

   ```mysql
   ALTER TABLE Persons ADD UNIQUE (Id_P)
   ```


2. 当表已被创建时添加多列约束。请使用下面的 SQL 语法：
   MySQL / SQL Server / Oracle / MS Access:

   ```mysql
   ALTER TABLE Persons ADD CONSTRAINT uc_PersonID UNIQUE (Id_P,LastName)
   ```

   > 创建约束时也可以为约束定义名称。

**撤销 UNIQUE 约束**
如需撤销 UNIQUE 约束，请使用下面的 SQL：
MySQL：

```mysql
ALTER TABLE Persons DROP INDEX uc_PersonID
```

SQL Server / Oracle / MS Access：

```mysql
ALTER TABLE Persons DROP CONSTRAINT uc_PersonID
```

###**DEFAULT 约束**
DEFAULT 约束用于向列中插入默认值。如果没有规定其他的值，那么会将默认值添加到所有的新记录。
**创建表时添加默认约束**
下面的 SQL 在 "Persons" 表创建时为 "City" 列创建 DEFAULT 约束：
My SQL / SQL Server / Oracle / MS Access：

```mysql
CREATE TABLE Persons (
	Id_P int NOT NULL,
	LastName varchar(255) NOT NULL,
	FirstName varchar(255),
	Address varchar(255),
	City varchar(255) DEFAULT 'Sandnes'
);
```

通过使用类似 GETDATE() 这样的函数，DEFAULT 约束也可以用于插入系统值：

```mysql
CREATE TABLE Orders (
	Id_O int NOT NULL,
	OrderNo int NOT NULL,
	Id_P int,
	OrderDate date DEFAULT GETDATE()
);
```

SQL **DEFAULT Constraint on ALTER TABLE**
如果在表已存在的情况下为 "City" 列创建 DEFAULT 约束，请使用下面的 SQL：
MySQL：

```mysql
ALTER TABLE Persons ALTER City SET DEFAULT 'SANDNES';
```

SQL Server / Oracle / MS Access：

```mysql
ALTER TABLE Persons ALTER COLUMN City SET DEFAULT 'SANDNES';
```

如需**撤销 DEFAULT 约束**，请使用下面的 SQL：
MySQL:

```mysql
ALTER TABLE Persons ALTER City DROP DEFAULT;
```

上面的语句删除了Persons表中的City列的默认约束。

SQL Server / Oracle / MS Access：

```mysql
ALTER TABLE Persons ALTER COLUMN City DROP DEFAULT;
```

###PRIMARY KEY 约束
PRIMARY KEY 约束**唯一标识数据库表中的每条记录。主键必须包含唯一的值，不能包含 NULL 值。每个表都应该有且仅有一个主键。**
**主键可以是原本资料内的一列，或是一个人造栏位 (与原本资料没有关系的栏位，一般建议这样选择主键)。主键可以为一列或多列的组合。当主键包含多列时，称为组合键 (Composite Key)**。 

可以在创建新表时设定主键 (运用 CREATE TABLE 语句)，也可以修改已存在的表来设定主键 (运用 ALTER TABLE 语句)。

**创建表时修改主键**

1. **创建单列的主键约束**。

   下面的 SQL 在 "Persons" 表创建时在 "Id_P" 列创建 PRIMARY KEY 约束：

   MySQL：

```sql
CREATE TABLE Persons (
	Id_P int NOT NULL,
	LastName varchar(255) NOT NULL,
	FirstName varchar(255),
	Address varchar(255),
	City varchar(255),
	PRIMARY KEY (Id_P)
);
```

​	SQL Server / Oracle / MS Access：

```sql
CREATE TABLE Persons (
	Id_P int NOT NULL PRIMARY KEY,
	LastName varchar(255) NOT NULL,
	FirstName varchar(255),
	Address varchar(255),
	City varchar(255)
);
```

2. 创建多列的主键约束。

   MySQL / SQL Server / Oracle / MS Access：

```sql
CREATE TABLE Persons (
	Id_P int NOT NULL,
	LastName varchar(255) NOT NULL,
	FirstName varchar(255),
	Address varchar(255),
	City varchar(255),
	CONSTRAINT pk_PersonID PRIMARY KEY (Id_P, LastName)
);
```

**为已存在的表添加主键约束**。

1. 为已存在的表添加单列的主键约束。如果在表已存在的情况下为 "Id_P" 列创建 PRIMARY KEY 约束，请使用下面的 SQL：

   MySQL / SQL Server / Oracle / MS Access：

```mysql
ALTER TABLE Persons ADD PRIMARY KEY (Id_P);
```

2. 为已存在的表添加多列的主键约束。请使用下面的 SQL 语法：

   MySQL / SQL Server / Oracle / MS Access：

```mysql
ALTER TABLE Persons ADD CONSTRAINT pk_PersonID PRIMARY KEY (Id_P,LastName);
```

注释：如果**使用 ALTER TABLE 语句添加主键，必须把主键列声明为不包含 NULL 值（在表首次创建时）**。
如需**撤销 PRIMARY KEY 约束**，请使用下面的 SQL：
MySQL：

```sql
ALTER TABLE Persons DROP PRIMARY KEY;
```

SQL Server / Oracle / MS Access：

```sql
ALTER TABLE Persons DROP CONSTRAINT pk_PersonID;
```

###AUTO_INCREMENT 字段
我们通常**希望在每次插入新记录时，自动地创建主键字段的值**。可以通过在表中创建一个 AUTO _INCREMENT 字段来实现。

**MySQL 使用 AUTO_INCREMENT 关键字来执行 AUTO _INCREMENT 任务**。**默认地，AUTO_INCREMENT 的开始值是 1，每条新记录递增 1**。

下列 SQL 语句把 "Persons" 表中的 "P_Id" 列定义为 AUTO _INCREMENT 主键：

```mysql
CREATE TABLE Persons (
	P_Id int NOT NULL AUTO_INCREMENT,
	LastName varchar(255) NOT NULL,
	FirstName varchar(255),
	Address varchar(255),
	City varchar(255),
	PRIMARY KEY (P_Id)
);
```

要**让 AUTO_INCREMENT 序列以其他的值起始**，请使用下列 SQL 语法：

```sql
ALTER TABLE Persons AUTO_INCREMENT = 100;
```

要在 "Persons" 表中插入新记录，我们**不必为 "P_Id" 列规定值（会自动添加一个唯一的值）**：

```sql
INSERT INTO Persons (FirstName, LastName) VALUES ('Bill', 'Gates');
```

上面的 SQL 语句会在 "Persons" 表中插入一条新记录。"P_Id" 会被赋予一个唯一的值。"FirstName" 会被设置为"Bill"，"LastName" 列会被设置为 "Gates"。

**MS SQL 使用 IDENTITY 关键字来执行 AUTO_INCREMENT 任务。默认地，IDENTITY 的开始值是 1，每条新记录递增 1**。

要规定 "P_Id" 列以 20 起始且递增 10，请把 IDENTITY 改为 IDENTITY(20,10)。

**MS Access 使用 AUTOINCREMENT 关键字来执行 AUTO_INCREMENT 任务。默认地，AUTOINCREMENT 的开始值是 1，每条新记录递增 1**。
下列 SQL 语句把 "Persons" 表中的 "P\_Id" 列定义为 AUTO_INCREMENT 主键：

```mysql
CREATE TABLE Persons (
	P_Id int PRIMARY KEY AUTOINCREMENT,
	LastName varchar(255) NOT NULL,
	FirstName varchar(255),
	Address varchar(255),
	City varchar(255)
);
```

要规定 "P_Id" 列以 20 起始且递增 10，请把 AUTOINCREMENT 改为 AUTOINCREMENT(20,10)。

**用于 Oracle 的语法**
在 Oracle 中，代码稍微复杂一点。你必须通过 SEQUENCE  对创建 AUTO_INCREMENT  字段（该对象生成数字序列）。
请使用下面的 CREATE SEQUENCE 语法：

```sql
CREATE SEQUENCE seq_person 
MINVALUE 1
START WITH 1
INCREMENT BY 1
CACHE 10;
```

上面的代码创建名为 seq_person 的**序列对象**，它以 1 起始且以 1 递增。该对象缓存 10 个值以提高性能。CACHE 选项规定了为了提高访问速度要存储多少个序列值。

要在 "Persons" 表中插入新记录，我们必须使用 nextval 函数（该函数从 seq_person 序列中取回下一个值）：

```mysql
INSERT INTO Persons (P_Id,FirstName,LastName) VALUES (seq_person.nextval,'Lars','Monsen');
```

上面的 SQL 语句会在 "Persons" 表中插入一条新记录。"P_Id" 的赋值是来自 seq_person 序列的下一个数字。"FirstName" 会被设置为 "Bill"，"LastName" 列会被设置为 "Gates"。

###FOREIGN KEY 约束
一个表中的 FOREIGN KEY 约束指向另一个表中的 PRIMARY KEY。让我们通过一个例子来解释外键。请看下面两个表：
"Persons" 表：

| P_Id | LastName  | FirstName | Address      | City      |
| ---- | --------- | --------- | ------------ | --------- |
| 1    | Hansen    | Ola       | Timoteivn 10 | Sandnes   |
| 2    | Svendson  | Tove      | Borgvn 23    | Sandnes   |
| 3    | Pettersen | Kari      | Storgt 20    | Stavanger |

"Orders" 表：

| O_Id | OrderNo | P_Id |
| ---- | ------- | ---- |
| 1    | 77895   | 3    |
| 2    | 44678   | 3    |
| 3    | 22456   | 2    |
| 4    | 24562   | 1    |

请注意，"Orders" 中的 "P_Id" 列指向 "Persons" 表中的 "P_Id" 列。"Persons" 表中的 "P_Id" 列是 "Persons" 表中的 PRIMARY KEY。"Orders" 表中的 "P_Id" 列是 "Orders" 表中的 FOREIGN KEY。

**FOREIGN KEY 约束用于预防破坏表之间连接的操作，也能防止非法数据插入外键列**，因为含有外键的表必须把其外键列指向另一张表中的一列。

**创建表时添加外键约束**。
下面的 SQL 在 "Orders" 表创建时为 "Id_P" 列**创建 FOREIGN KEY**：
MySQL：

```mysql
CREATE TABLE Orders (
	O_Id int NOT NULL,
	OrderNo int NOT NULL,
	P_Id int,
	PRIMARY KEY (O_Id),
	FOREIGN KEY (P_Id) REFERENCES Persons(Id_P)
);
```

SQL Server / Oracle / MS Access：

```mysql
CREATE TABLE Orders (
	O_Id int NOT NULL PRIMARY KEY,
	OrderNo int NOT NULL,
	P_Id int FOREIGN KEY REFERENCES Persons(P_Id)
);
```

**创建表时添加多列的外键约束**，请使用下面的 SQL 语法：
MySQL / SQL Server / Oracle / MS Access：

```mysql
CREATE TABLE Orders (
	Id_O int NOT NULL,
	OrderNo int NOT NULL,
	Id_P int,
	PRIMARY KEY (Id_O),
	CONSTRAINT fk_PerOrders FOREIGN KEY (Id_P)	REFERENCES Persons(Id_P)
);
```

**为已存在的表添加单列外键约束**

如果在 "Orders" 表已存在的情况下为 "Id_P" 列创建 FOREIGN KEY 约束，请使用下面的 SQL：
MySQL / SQL Server / Oracle / MS Access：

```mysql
ALTER TABLE Orders ADD FOREIGN KEY (Id_P) REFERENCES Persons(Id_P);
```

**为已存在的表添加单列外键约束**
MySQL / SQL Server / Oracle / MS Access：

```mysql
ALTER TABLE Orders ADD CONSTRAINT fk_PerOrders FOREIGN KEY (Id_P) REFERENCES Persons(Id_P);
```

如需**撤销 FOREIGN KEY 约束**，请使用下面的 SQL：
MySQL:

```mysql
ALTER TABLE Orders DROP FOREIGN KEY fk_PerOrders;
```

SQL Server / Oracle / MS Access:

```mysql
ALTER TABLE Orders DROP CONSTRAINT fk_PerOrders;
```

###CHECK 约束
CHECK 约束用于限制列中的值的范围。如果对单个列定义 CHECK 约束，那么该列只允许特定的值。如果对一个表定义 CHECK 约束，那么此约束会在特定的列中对值进行限制。

**创建表时添加 CHECK 约束**

下面的 SQL 在 "Persons" 表创建时为 "Id_P" 列**创建 CHECK 约束**。CHECK 约束规定 "Id_P" 列必须只包含大于 0 的整数。
**My SQ不支持CHECK约束，可以使用CHECK约束但是没有任何效果**：

```mysql
CREATE TABLE Persons (
	Id_P int NOT NULL,
	LastName varchar(255) NOT NULL,
	FirstName varchar(255),
	Address varchar(255),
	City varchar(255),
	CHECK (Id_P>0)
);
```

SQL Server / Oracle / MS Access:

```mysql
CREATE TABLE Persons (
	Id_P int NOT NULL CHECK (Id_P>0),
	LastName varchar(255) NOT NULL,
	FirstName varchar(255),
	Address varchar(255),
	City varchar(255)
);
```

**创建表时添加多列的 CHECK 约束**，请使用下面的 SQL 语法：
MySQL / SQL Server / Oracle / MS Access:

```mysql
CREATE TABLE Persons (
	Id_P int NOT NULL,
	LastName varchar(255) NOT NULL,
	FirstName varchar(255),
	Address varchar(255),
	City varchar(255),
	CONSTRAINT chk_Person CHECK (Id_P>0 AND City='Sandnes')
);
```

**修改表时添加单列 CHECK 约束**

如果在表已存在的情况下为 "Id_P" 列**创建 CHECK 约束**，请使用下面的 SQL：
MySQL / SQL Server / Oracle / MS Access:

```mysql
ALTER TABLE Persons ADD CHECK (Id_P>0);
```

**修改表时添加单列 CHECK 约束**，请使用下面的 SQL 语法：
MySQL / SQL Server / Oracle / MS Access：

```mysql
ALTER TABLE Persons ADD CONSTRAINT chk_Person CHECK (Id_P>0 AND City='Sandnes')；
```

**撤销 CHECK 约束**，请使用下面的 SQL：
SQL Server / Oracle / MS Access:

```mysql
ALTER TABLE Persons mDROP CONSTRAINT chk_Person;
```

MySQL：

```mysql
ALTER TABLE Persons DROP CHECK chk_Person;
```

___

##集合操作
###**UNION 操作符**
UNION 操作符用于合并两个或多个 SELECT 语句的结果集，相当于OR逻辑运算。
请注意，**UNION 内部的每个 SELECT 语句必须拥有相同数量的列。列也必须拥有相似的数据类型**。同时，**每个 SELECT 语句中的列的顺序必须相同**。
**UNION 语法**
SELECT column_name(s) FROM table1
UNION
SELECT column_name(s) FROM table2;
注释：默认地，UNION 操作符选取不同的值。如果允许重复的值，请使用 UNION ALL。
SQL UNION ALL 语法
SELECT column_name(s) FROM table1
UNION ALL
SELECT column_name(s) FROM table2;
注释：UNION 结果集中的列名总是等于 UNION 中第一个 SELECT 语句中的列名。
###**INTERSECT 操作符**
类似于UNION的OR运算，INTERSECR执行的是AND逻辑运算。它们对数据列的要求相同。
**INTERSECT 语法**
 SELECT column_name(s) FROM table1
 INTERSECT
SELECT column_name(s) FROM table2;
###**Minus操作符**
类似于UNION的OR运算，Minus执行的是求两张表交集相对于左表的补集。它们对数据列的要求相同。
**Minus 语法**
 SELECT column_name(s) FROM table1
 Minus
SELECT column_name(s) FROM table2;
上面语句返回的是仅左表有，而右表没有的记录集合，不包含二者共有的部分。
注意：**My SQL并不支持MINUS和INTERSECT运算，只能通过子查询语句来替代**。


##**SQL函数**
###**Date 函数**
当我们处理日期时，最难的任务恐怕是确保所插入的日期的格式，与数据库中日期列的格式相匹配。
只要您的数据包含的只是日期部分，运行查询就不会出问题。但是，如果涉及时间部分，情况就有点复杂了。如果希望使查询简单且更易维护，那么请**不要在日期中使用时间部分**！
**MySQL Date 函数**
| 函数            | 描述                 |
| ------------- | ------------------ |
| NOW()         | 返回当前的日期和时间         |
| CURDATE()     | 返回当前的日期            |
| CURTIME()     | 返回当前的时间            |
| DATE()        | 提取日期或日期/时间表达式的日期部分 |
| EXTRACT()     | 返回日期/时间的单独部分       |
| DATE_ADD()    | 向日期添加指定的时间间隔       |
| DATE_SUB()    | 从日期减去指定的时间间隔       |
| DATEDIFF()    | 返回两个日期之间的天数        |
| DATE_FORMAT() | 用不同的格式显示日期/时间      |
**SQL Server Date 函数**
| 函数         | 描述               |
| ---------- | ---------------- |
| GETDATE()  | 返回当前的日期和时间       |
| DATEPART() | 返回日期/时间的单独部分     |
| DATEADD()  | 在日期中添加或减去指定的时间间隔 |
| DATEDIFF() | 返回两个日期之间的时间      |
| CONVERT()  | 用不同的格式显示日期/时间    |
**SQL Date 数据类型**
MySQL 使用下列数据类型在数据库中存储日期或日期/时间值：
DATE - 格式：YYYY-MM-DD
DATETIME - 格式：YYYY-MM-DD HH:MM:SS
TIMESTAMP - 格式：YYYY-MM-DD HH:MM:SS
YEAR - 格式：YYYY 或 YY
SQL Server 使用下列数据类型在数据库中存储日期或日期/时间值：
DATE - 格式：YYYY-MM-DD
DATETIME - 格式：YYYY-MM-DD HH:MM:SS
SMALLDATETIME - 格式：YYYY-MM-DD HH:MM:SS
TIMESTAMP - 格式：唯一的数字
注释：当您在数据库中创建一个新表时，需要为列选择数据类型！具体参考所使用数据库的手册。
###**ISNULL()、NVL()、IFNULL() 和 COALESCE() 函数**
对于下面的 SELECT 语句：
SELECT ProductName,UnitPrice*(UnitsInStock+UnitsOnOrder)
FROM Products
在上面的实例中，如果有 "UnitsOnOrder" 值是 NULL，那么结果是 NULL。
微软的 **ISNULL() 函数用于规定如何处理 NULL 值**。
NVL()、IFNULL() 和 COALESCE() 函数也可以达到相同的结果。
**在这里，我们希望 NULL 值为 0**。
下面，如果 "UnitsOnOrder" 是 NULL，则不会影响计算，因为如果值是 NULL 则 ISNULL() 返回 0：
SQL Server / MS Access
SELECT ProductName,UnitPrice*(UnitsInStock+ISNULL(UnitsOnOrder,0))
FROM Products
Oracle
Oracle 没有 ISNULL() 函数。不过，我们可以使用 NVL() 函数达到相同的结果：
SELECT ProductName,UnitPrice*(UnitsInStock+NVL(UnitsOnOrder,0))
FROM Products
MySQL
MySQL 也拥有类似 ISNULL() 的函数。不过它的工作方式与微软的 ISNULL() 函数有点不同。
在 MySQL 中，我们可以使用 IFNULL() 函数，如下所示：
SELECT ProductName,UnitPrice*(UnitsInStock+IFNULL(UnitsOnOrder,0))
FROM Products
或者我们可以使用 COALESCE() 函数，如下所示：
SELECT ProductName,UnitPrice*(UnitsInStock+COALESCE(UnitsOnOrder,0))
FROM Products
###**Aggregate 函数**
SQL Aggregate 函数（聚合函数）计算从列中取得的值，返回一个单一的值。
有用的 Aggregate 函数：

- AVG() – 返回平均值
- COUNT() – 返回行数
- FIRST() – 返回第一个记录的值
- LAST() – 返回最后一个记录的值
- MAX() – 返回最大值
- MIN() – 返回最小值
- SUM() – 返回总和

####**AVG() 函数**
AVG() 函数返回数值列的平均值。
**AVG()函数语法**：
SELECT AVG(column\_name) FROM table_name;
####COUNT() 函数
返回匹配指定条件的行数。
**COUNT()函数语法**：
**COUNT(column_name)函数**用于下面返回返回指定列的值的数目（NULL 不计入）：
SELECT COUNT(column\_name) FROM table_name;
**COUNT(*) 函数**返回表中的记录数：
SELECT COUNT(*) FROM table_name;
**COUNT(DISTINCT column_name) 函数**返回指定列的不同值的数目：
SELECT COUNT(DISTINCT column\_name) FROM table_name;
注释：COUNT(DISTINCT) 适用于 ORACLE 和 Microsoft SQL Server，但是无法用于 Microsoft Access。
####**FIRST() 函数**
FIRST() 函数返回指定的列中第一个记录的值。
**FIRST() 函数语法**
SELECT FIRST(column\_name) FROM table_name;
注释：**只有 MS Access 支持 FIRST() 函数**。
SQL Server、MySQL 和 Oracle 中的 SQL FIRST() 实现：
**SQL Server 语法**：
SELECT TOP 1 column\_name FROM table_name
ORDER BY column_name ASC;
**MySQL 语法**:
SELECT column\_name FROM table_name
ORDER BY column_name ASC
LIMIT 1;
**Oracle 语法**:
SELECT column_name FROM table_name
ORDER BY column_name ASC
WHERE ROWNUM <=1;
####**LAST()函数**
LAST()函数功能与FIRST()相反，用法相同。
####**MAX() 函数**
MAX() 函数返回指定列的最大值。
**MAX() 语法**：
SELECT MAX(column\_name) FROM table_name;
####**MIN() 函数**
MIN() 函数功能与MAX()相反，用法相同。
####**SUM() 函数**
SUM() 函数返回数值列的总数。
**SUM() 语法**：
SELECT SUM(column\_name) FROM table_name;
###**Scalar 函数**
Scalar 函数基于输入值，返回一个单一的值。
有用的 Scalar 函数：

- UCASE() – 将某个字段转换为大写
- LCASE() – 将某个字段转换为小写
- MID() – 从某个文本字段提取字符
- LEN() – 返回某个文本字段的长度
- ROUND() – 对某个数值字段进行指定小数位数的四舍五入
- NOW() – 返回当前的系统日期和时间
- FORMAT() – 格式化某个字段的显示方式
####**UCASE() 函数**
UCASE() 函数把字段的值转换为大写。
**UCASE() 语法**：
SELECT UCASE(column\_name) FROM table_name;
**用于 SQL Server 的语法**
SELECT UPPER(column\_name) FROM table_name;
####**LCASE() 函数**
LCASE() 函数把字段的值转换为小写。
**LCASE() 语法**
SELECT LCASE(column\_name) FROM table_name;
用于 SQL Server 的语法
SELECT LOWER(column\_name) FROM table_name;
####**MID() 函数**
MID() 函数用于从文本字段中提取字符。
**MID() 语法**：
SELECT MID(column\_name,start[,length]) FROM table_name;
| 参数          | 描述                                |
| ----------- | --------------------------------- |
| column_name | 必需。要提取字符的字段。                      |
| start       | 必需。规定开始位置（起始值是 1）。                |
| length      | 可选。要返回的字符数。如果省略，则 MID() 函数返回剩余文本。 |
####**LEN() 函数**
LEN() 函数返回文本字段中值的长度。
**LEN() 语法**
SELECT LEN(column\_name) FROM table_name;
MySQL 中函数为 LENGTH():
SELECT LENGTH(column\_name) FROM table_name;
ROUND() 函数
ROUND() 函数用于把数值字段舍入为指定的小数位数。
SQL ROUND() 语法
SELECT ROUND(column\_name,decimals) FROM table_name;
| 参数          | 描述             |
| ----------- | -------------- |
| column_name | 必需。要舍入的字段。     |
| decimals    | 必需。规定要返回的小数位数。 |
####**NOW() 函数**
NOW() 函数返回当前系统的日期和时间。
**NOW() 语法**
SELECT NOW() FROM table_name;
####**FORMAT() 函数**
FORMAT() 函数用于对字段的显示进行格式化。
**FORMAT() 语法**
SELECT FORMAT(column\_name,format) FROM table_name;
| 参数          | 描述          |
| ----------- | ----------- |
| column_name | 必需。要格式化的字段。 |
| format      | 必需。规定格式。    |
