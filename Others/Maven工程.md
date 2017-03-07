## 创建Maven工程

1. File -> New -> Maven Project。

![maven1](/appendix/maven1.png)

2. 配置pom.xml文件和web-app目录下的web.xml文件。


在Maven项目pom.xml文件中导入JDBC依赖：

```xml
<!-- 使用JDBC编程时需要导入一个数据库的依赖库，这里使用mysql-connector-java -->
		<!-- https://mvnrepository.com/artifact/mysql/mysql-connector-java -->
		<dependency>
			<groupId>mysql</groupId>
			<artifactId>mysql-connector-java</artifactId>
			<version>5.1.38</version>
		</dependency>
```

