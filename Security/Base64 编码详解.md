## Base64 详解

### 简介

**Base64 是一种使用 64 个可打印字符来表示二进制数据的编解方法**。Basc64 算法最早应用于解决电子邮件传输的问题。由于“历史问题”，传统的邮件只支持传输ASCII 表中的可见字符，像 ASCII 码的控制字符和中文字符就不能通过邮件直接传送。这样就造成了很大的限制。一般的二进制流（图片、文档等）的每个字节不可能全部是可见字符，所以这类文件也无法直接传送。Base64 使用 64 个可打印字符来表示不可打印的字符就可以解决这个问题。

### 实现原理

Base64 将二进制流转换成“A-Z、a-z、0-9、+、/” 这 64 个可打印字符。根据 [RFC 4648](http://www.ietf.org/rfc/rfc4648.txt) 和 [RFC 2045](http://www.ietf.org/rfc/rfc2045.txt)，
的定义:“Basc64内容传送编码是一种以任意8位字节序列组合的描述形式，这种形式不易被人
直接 识别(The Base64 Conten-Tansfer-Encod is designed to representabirary sequences of
oclels in 。fom that need not be humanly readable ).经tBasc64编码后的数据会比原始数据路
长，为原来的4/3倍。经Basc64编码后的字符串的字符数是以4为单位的整数倍。
RFC 2045还规定，在电子邮件中，每行为76个字符，每行末需添加一个回车换行符("rUn")，



### 应用

### Java 实现

### JavaScript 实现

