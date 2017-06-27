##  MySql中游标的定义与使用方式

### 创建游标

首先在MySql中创建一张数据表：

```mysql
CREATE TABLE IF NOT EXISTS `store` (  
  `id` int(11) NOT NULL AUTO_INCREMENT,  
  `name` varchar(20) NOT NULL,  
  `count` int(11) NOT NULL DEFAULT '1',  
  PRIMARY KEY (`id`)  
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=7;  

INSERT INTO `store` (`id`, `name`, `count`) VALUES  
(1, 'android', 15), 
(2, 'iphone', 14), 
(3, 'iphone', 20),  
(4, 'android', 5), 
(5, 'android', 13), 
(6, 'iphone', 13); 
```

我们现在要用存储过程做一个功能，统计iphone的总库存是多少，并把总数输出到控制台。在windows系统中写存储过程时，如果需要使用declare声明变量，需要添加这个关键字，否则会报错。

```mysql
delimiter //  
drop procedure if exists StatisticStore;  
CREATE PROCEDURE StatisticStore()  
BEGIN  
--创建接收游标数据的变量  
declare c int;  
declare n varchar(20);  
--创建总数变量  
declare total int default 0;  
--创建结束标志变量  
declare done int default false;  
--创建游标  
declare cur cursor for select name,count from store where name = 'iphone';  
--指定游标循环结束时的返回值  
declare continue HANDLER for not found set done = true;  
--设置初始值  
set total = 0;  
--打开游标  
open cur;  
--开始循环游标里的数据  
read_loop:loop  
--根据游标当前指向的一条数据  
fetch cur into n,c;  
--判断游标的循环是否结束  
if done then  
    leave read_loop;    --跳出游标循环  
end if;  
--获取一条数据时，将count值进行累加操作，这里可以做任意你想做的操作，  
set total = total + c;  
--结束游标循环  
end loop;  
--关闭游标  
close cur;  
  
--输出结果  
select total;  
END;  
--调用存储过程  
call StatisticStore();  
```
fetch是获取游标当前指向的数据行，并将指针指向下一行，当游标已经指向最后一行时继续执行会造成游标溢出。
使用loop循环游标时，他本身是不会监控是否到最后一条数据了，像下面代码这种写法，就会造成死循环。

```mysql
read_loop:loop  
fetch cur into n,c;  
set total = total+c;  
end loop;  
```

在MySql中，造成游标溢出时会引发mysql预定义的NOT FOUND错误，所以在上面使用下面的代码指定了当引发not found错误时定义一个continue 的事件，指定这个事件发生时修改done变量的值。

```mysql
declare continue HANDLER for not found set done = true; 
```

所以在循环时加上了下面这句代码：

```mysql
--判断游标的循环是否结束  
if done then  
leave read_loop;    --跳出游标循环  
end if; 
```
如果done的值是true，就结束循环。继续执行下面的代码。

### 使用方式

游标有三种使用方式：
第一种就是上面的实现，使用loop循环。第二种方式如下，使用while循环：

```mysql
drop procedure if exists StatisticStore1;  
CREATE PROCEDURE StatisticStore1()  
BEGIN  
declare c int;  
declare n varchar(20);  
declare total int default 0;  
declare done int default false;  
declare cur cursor for select name,count from store where name = 'iphone';  
declare continue HANDLER for not found set done = true;  
set total = 0;  
open cur;  
fetch cur into n,c;  
while(not done) do  
    set total = total + c;  
    fetch cur into n,c;  
end while;  
  
close cur;  
select total;  
END;  

call StatisticStore1(); 
```
第三种方式是使用repeat执行：
```mysql
drop procedure if exists StatisticStore2;  
CREATE PROCEDURE StatisticStore2()  
BEGIN  
declare c int;  
declare n varchar(20);  
declare total int default 0;  
declare done int default false;  
declare cur cursor for select name,count from store where name = 'iphone';  
declare continue HANDLER for not found set done = true;  
set total = 0;  
open cur;  
repeat  
fetch cur into n,c;  
if not done then  
    set total = total + c;  
end if;  
until done end repeat;  
close cur;  
select total;  
END;  

call StatisticStore2(); 
```
### 游标嵌套

在mysql中，每个begin end 块都是一个独立的scope区域，由于MySql中同一个error的事件只能定义一次，如果多定义的话在编译时会提示Duplicate handler declared in the same block。
```mysql
drop procedure if exists StatisticStore3;  
CREATE PROCEDURE StatisticStore3()  
BEGIN
declare _n varchar(20);  
declare done int default false;  
declare cur cursor for select name from store group by name;  
declare continue HANDLER for not found set done = true;  
open cur;  
read_loop:loop  
fetch cur into _n;  
if done then  
    leave read_loop;  
end if;  
begin  
    declare c int;  
    declare n varchar(20);  
    declare total int default 0;  
    declare done int default false;  
    declare cur cursor for select name,count from store where name = 'iphone';  
    declare continue HANDLER for not found set done = true;  
    set total = 0;  
    open cur;  
    iphone_loop:loop  
    fetch cur into n,c;  
    if done then  
        leave iphone_loop;  
    end if;  
    set total = total + c;  
    end loop;  
    close cur;  
    select _n,n,total;  
end;  
begin  
        declare c int;  
        declare n varchar(20);  
        declare total int default 0;  
        declare done int default false;  
        declare cur cursor for select name,count from store where name = 'android';  
        declare continue HANDLER for not found set done = true;  
        set total = 0;  
        open cur;  
        android_loop:loop  
        fetch cur into n,c;  
        if done then  
            leave android_loop;  
        end if;  
        set total = total + c;  
        end loop;  
        close cur;  
    select _n,n,total;  
end;  
begin  
  
end;  
end loop;  
close cur;  
END;  

call StatisticStore3(); 
```
上面就是实现一个嵌套循环，当然这个例子比较牵强。凑合看看就行。。

### 动态SQL

Mysql 支持动态SQL的功能，

```mysql
set @sqlStr='select * from table where condition1 = ?';  
prepare s1 for @sqlStr;  
--如果有多个参数用逗号分隔  
execute s1 using @condition1;  
--手工释放，或者是 connection 关闭时， server 自动回收  
deallocate prepare s1;  
```

