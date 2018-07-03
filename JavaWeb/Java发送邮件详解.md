---
typora-copy-images-to: ..\graphs\photos
typora-root-url: ..\graphs\photos
---

### 邮件基础知识

在学习使用 Java 发送邮件之前，我们先来看一下关于电子邮件的基础知识。

**电子邮件（Electronic mail，email 或 e-mail）**是一种通过电子设备进行交流信息（邮件）的方式。最早的电子邮件仅支持 ASCII 文本，后来通过多用途互联网邮件扩展（[Multipurpose Internet Mail Extensions](https://en.wikipedia.org/wiki/Multipurpose_Internet_Mail_Extensions)，简称 MIME）添加了其他字符集和多媒体附件支持。另一种**国际邮件（[International email](https://en.wikipedia.org/wiki/International_email)，或称 IDN email、Intl email）**标准采用 UTF-8 编码的国际化邮件地址，已经规范化，但还未（2017年）广泛应用。

#### 邮件协议

常见的电子邮件协议有以下几种：SMTP、POP3、IMAP、HTTP、S/MIME。这几种协议都是由 TCP/IP 协议族定义的。

- [SMTP](https://zh.wikipedia.org/wiki/%E7%AE%80%E5%8D%95%E9%82%AE%E4%BB%B6%E4%BC%A0%E8%BE%93%E5%8D%8F%E8%AE%AE)（Simple Mail Transfer Protocol，即简单邮件传输协议）是事实上的在 Internet 传输 Email 的标准，它是一个相对简单的基于文本的协议。由于这个协议开始是基于纯 ASCII 文本的，它在二进制文件上处理得并不好，所以，后来诸如 MIME 的标准被开发来编码二进制文件以使其通过 SMTP 来传输。今天，大多数 SMTP 服务器都支持 8 位 MIME 扩展，它使二进制文件的传输变得几乎和纯文本一样简单。

  在 SMTP 之上指定消息的一个或多个接收者（在大多数情况下被确认是存在的），然后消息文本就可以被传输。SMTP是一个“推”的协议，它不允许根据需要从远程服务器上“拉”来消息。要做到这点，邮件客户端必须使用 POP3 或IMAP 协议。SMTP 使用 TCP 25 端口，可以很简单地通过 telnet 程序来测试一个 SMTP 服务器（比如，telnet smtp.163.com 25，连接后可按下 Ctrl + ]，然后输入 q 退出）。要为一个给定的域名决定一个 SMTP 服务器，需要使用 MX (Mail eXchange) DNS。

  最初的 SMTP 的局限之一在于它没有对发送方进行身份验证的机制，因此，后来定义了 SMTP-AUTH 扩展。尽管有了身份认证机制，垃圾邮件仍然是一个主要的问题。

- [POP](https://zh.wikipedia.org/wiki/%E9%83%B5%E5%B1%80%E5%8D%94%E5%AE%9A)（Post Office Protocol，即邮局协议）协议目前为第 3 个版本，即众所周知的 POP3（使用 TCP 110 端口）。POP 支持离线邮件处理。其具体过程是：邮件发送到服务器上，电子邮件客户端调用邮件客户机程序以连接服务器，并下载所有未阅读的电子邮件。这种离线访问模式是一种存储转发服务，将邮件从邮件服务器端送到个人终端机器上，一般是 PC 机或 MAC。一旦邮件发送到 PC 机或MAC 上，邮件服务器上的邮件将会被删除。但目前的 POP3 邮件服务器大都可以“只下载邮件，服务器端并不删除”，也就是改进的 POP3 协议。在安全性上，STARTTLS 扩展（如果支持的话）可在标准的 POP3 端口 110 上使用 STLS  命令协商选择使用 TLS 或 SSL 进行加密通信，而有的客户端和服务器则使用另一个端口 995 进行 TLS 或 SSL 通信（POP3S）。

- [IMAP](https://zh.wikipedia.org/wiki/%E5%9B%A0%E7%89%B9%E7%BD%91%E4%BF%A1%E6%81%AF%E8%AE%BF%E9%97%AE%E5%8D%8F%E8%AE%AE) （Internet Message Access Protocol，因特网信息访问协议，以前称作交互邮件访问协议）是一个应用层协议，目前的版本为 IMAP4，提供了相对于广泛使用的 POP3 邮件协议的另外一种选择。基本上，两者都允许一个邮件客户端访问邮件服务器上存储的信息。IMAP 的特点如下：

  - 支持连接和断开两种操作模式。当使用 POP3 时，客户端只会在一段时间内连接到服务器，直到它下载完所有新信息，客户端即断开连接。在 IMAP 中，只要用户界面是活动的和下载信息内容是需要的，客户端就会一直连接服务器。对于有很多或者很大邮件的用户来说，使用 IMAP4 模式可以获得更快的响应时间。
  - 支持多个客户同时连接到一个邮箱。POP3 协议假定一个邮箱只能同时存在一个连接。相反，IMAP4 协议允许多个用户同时访问同一个邮箱。
  - 支持在服务器保留消息状态信息（message state information）。通过使用 IMAP4 协议中定义的标志客户端可以跟踪消息状态，例如邮件是否被读取，回复，或者删除。这些标识存储在服务器，所以多个用户在不同时间访问一个邮箱可以感知其他用户所做的操作。
  - 支持访问消息中的 MIME 部分和部分获取。几乎所有的 Internet 邮件都是以 MIME 格式传输的。MIME 允许消息包含一个树型结构，这个树型结构的叶子节点都是单一内容类型，而非叶子节点都是多块类型的组合。IMAP4 协议允许客户端获取任何独立的 MIME 部分和获取信息的一部分或者全部。这些机制使得用户无需下载附件就可以浏览消息内容或者在获取内容的同时浏览。
  - 支持在服务器上访问多个邮箱。IMAP4 客户端可以在服务器上创建，重命名，或删除多个邮箱（通常以文件夹形式显现给用户），还允许服务器提供对于共享和公共文件夹的访问。大多数邮件程序的目录服务还使用 LDAP。
  - 支持服务器端搜索。IMAP4 可以让用户在服务器上搜索匹配多个标准的信息（收件人、发件人，主题等）。在这种机制下客户端就无需下载邮箱中所有信息来完成这些搜索。
  - 支持一个定义良好的扩展机制。吸取早期 Internet 协议的经验，IMAP 的扩展定义了一个明确的机制。无论使用POP3 还是 IMAP4 来获取消息，客户端均使用 SMTP 协议来发送消息。邮件客户端可能是 POP 客户端或者IMAP 客户端，但都会使用 SMTP。

  不像大多数旧的 Internet 协议，IMAP4 生来就支持加密注册机制。IMAP4 中也支持明文传输密码。因为加密机制的使用需要客户端和服务器双方的一致，明文密码的使用是在一些客户端和服务器类型不同的情况下（例如 Windows 客户端和非 Windows 服务器）。在 SSL 上的 IMAP4 通信可通过 993 端口进行加密传输（而 IMAP4 使用 143 端口），也可以选择在 IMAP4 线程创建的时候声明“STARTTLS”。

  IMAP 协议增强了电子邮件的灵活性，同时也减少了垃圾邮件对本地系统的直接危害，同时相对节省了用户察看电子邮件的时间。除此之外，IMAP 协议可以记忆用户在脱机状态下对邮件的操作（例如移动邮件，删除邮件等）在下一次打开网络连接的时候会自动执行。

- HTTP(S)：通过浏览器使用邮件服务时使用。

- [MIME](https://zh.wikipedia.org/wiki/%E5%A4%9A%E7%94%A8%E9%80%94%E4%BA%92%E8%81%AF%E7%B6%B2%E9%83%B5%E4%BB%B6%E6%93%B4%E5%B1%95)（Multipurpose Internet Mail Extensions, 多用途互联网邮件扩展）是一个互联网标准，它扩展了电子邮件标准，使其能够支持：

  - 非　ASCII　字符文本；
  - 非文本格式附件（二进制、声音、图像等）；
  - 由多部分（multiple parts）组成的消息体；
  - 包含非　ASCII　字符的头信息（Header information）。

  MIME 并不是用于传送邮件的协议，MIME 改善了由 RFC 822 转变而来的 RFC 2822，这些旧标准规定电子邮件标准并不允许在邮件消息中使用 7 位 ASCII 字符集以外的字符。正因如此，一些非英语字符消息和二进制文件，图像，声音等非文字消息原本都不能在电子邮件中传输。MIME 规定了用于表示各种各样的数据类型的符号化方法。此外，在万维网中使用的 HTTP 协议中也使用了 MIME 的框架，该标准被扩展为互联网媒体类型。

  MIME 是通过标准化电子邮件报文头部的附加字段（fields）而实现的，这些字段描述了报文的内容类型和组织形式。

  - Content-Type：这个头部领域用于指定消息的内容类型。一般以下面的形式出现。

    ```shell
    Content-Type: [type]/[subtype]; parameter
    ```

    type 有下面的形式：

    - text：用于标准化地表示的文本信息，文本消息可以是多种字符集和或者多种格式的；

    - multipart：用于连接消息体的多个部分构成一个消息，这些部分可以是不同类型的数据；

    - application：用于传输应用程序数据或者二进制数据；

    - message：用于包装一个 E-mail 消息；

    - image：用于传输静态图片数据；

    - audio：用于传输音频或者音声数据；

    - video：用于传输动态影像数据，可以是与音频编辑在一起的视频数据格式。

    subtype 用于指定 type 的详细形式。content-type/subtype 对的集合和与此相关的参数，将随着时间而增长。为了确保这些值在一个有序而且公开的状态下开发，MIME 使用 Internet Assigned Numbers Authority（IANA） 作为中心的注册机制来管理这些值。常用的 subtype 值如下所示：

    - text/plain：纯文本；

    - text/html：HTML 文档；

    - application/xhtml+xml：XHTML 文档；

    - image/gif：GIF 图像；

    - image/jpeg：JPEG 图像，PHP 中为 image/pjpeg；

    - image/png：PNG 图像，PHP 中为 image/x-png；

    - video/mpeg：MPEG 动画；

    - application/octet-stream：任意的二进制数据；

    - application/pdf：PDF 文档；

    - application/msword：Microsoft Word 文件；

    - application/vnd.wap.xhtml+xml：wap1.0+；

    - application/xhtml+xml：wap2.0+；

    - message/rfc822：RFC 822 形式；

    - multipart/alternative：HTML 邮件的 HTML 形式和纯文本形式，相同内容使用不同形式表示；

    - application/x-www-form-urlencoded：使用 HTTP 的 POST 方法提交的表单；

    - multipart/form-data：同上，但主要用于表单提交时伴随文件上传的场合。

    此外，尚未被接受为正式数据类型的 subtype 可以使用 x- 开头的独立名称（例如 application/x-gzip）。vnd- 开头的固有名称也可以使用（例如 application/vnd.ms-excel）。

    parameter 可以用来指定附加信息，更多情况下是用于指定 text/plain 和 text/html 等的文字编码方式的 charset 参数，如“Content-type: text/plain; charset=us-ascii ”。MIME 根据 type 制定了默认的 subtype，当客户端不能确定消息的 subtype 的情况下，消息被看作默认的subtype 进行处理。text 默认是 text/plain，application 默认是 application/octet-stream，而 multipart 默认情况下被看作 multipart/mixed。

  - Content-Transfer-Encoding：这个区域使指定 ASCII 以外的字符编码方式成为可能。形式如下

    ```shell
    Content-Transfer-Encoding: [mechanism]
    ```

    其中，mechanism 的值可以指定为“7bit”，“8bit”，“binary”，“quoted-printable”，“base64”。

    - 7bit：7 位元 ASCII 码；
    - 8bit：8 位元 ASCII 码；
    - binary：Not only may non-ASCII characters be present but the lines are not necessarily short enough for SMTP transport；
    - quoted-printable：因为欧洲的一些文字和 ASCII 字符集中的某些字符有部分相同。如果邮件消息使用的是这些语言的话，与 ASCII 重叠的那些字符可以原样使用，ASCII 字符集中不存在的字符采用形如“=??”的方法编码。这里“??”需要用将字符编码后的 16 进制数字来指定。采用 quoted-printable 编码的消息，长度不会变得太长，而且大部分都是 ASCII 中的字符，即使不通过解码也大致可以读懂消息的内容；
    - base64：base64 是一种将二进制的 01 序列转化成 ASCII 字符的编码方法。编码后的文本或者二进制消息，就可以运用 SMTP 等只支持 ASCII 字符的协议传送了。Base64 一般被认为会平均增加 33% 的报文长度，而且，经过编码的消息对于人类来说是不可读的。
    - x-encodingname：这个值是预留的扩展。

- [S/MIME](S/MIME)（Secure Multipurpose Internet Mail Extensions，安全的多用途Internet邮件扩展，简称S/MIME）：是一种 Internet 标准，它在安全方面对 MIME 协议进行了扩展，可以将 MIME 实体（比如数字签名和加密信息等）封装成安全对象，为电子邮件应用增添了消息真实性、完整性和保密性服务。S/MIME 不局限于电子邮件，也可以被其他支持 MIME 的传输机制使用，如 HTTP。

当然，上面的这几个协议并不是全部，还有 NNTP 和其它一些协议可用于传输信息，但是由于不常用到，所以本文便不提及了。

#### 邮件发送机制

下图展示了一个典型的邮件发送过程。邮件发送方 Alice 通过邮件用户代理（[mail user agent](https://en.wikipedia.org/wiki/E-mail_client)，即 MUA，一般为邮件客户端程序，如 Outlook、Foxmail 等）向指定的接收方邮件地址发送了一条消息。

![800px-Email.svg](/800px-Email.svg.png)

具体过程：MUA 将消息格式化为邮件格式，使用 SMTP 传输协议向本地的邮件提交代理（[mail submission agent](https://en.wikipedia.org/wiki/Mail_submission_agent)，即 MSA）（本例中为 *smtp.a.org*）发送消息内容。MSA 确定 SMTP 协议（而非消息头）提供的目标地址（本例中为 *bob@b.org*），然后向 MX DNS 服务器（本例中为 *ns.b.org*）查询接受方邮件地址中的域名（即 @ 符号后面的部分，@ 符号前面的部分是地址的本地部分，通常是接受方的用户名），MX DNS 服务器从其邮件交换记录（mail exchanger record，MX record）的全限定域名列表中选择一个优先匹配的全限定域名（本例中为 *mx.b.org*）返回，从而得到接受方的邮件接收服务器的全限定域名（本例中为 mx.b.org）。MUA （smtp.a.org）使用 SMTP 发送消息给接受方的邮件接收服务器（mx.b.org）。接受方的邮件接收服务器通过 POP3 或 IMAP 将消息传递给接受方的 MUA。实际过程中还存在其他一些细节，这里不再详述。

#### 邮件安全性

安全考量包括传输安全、储存安全、发送者身份确认、接收者已收到确认、拒绝服务攻击等。有两种标准：[PGP](https://zh.wikipedia.org/wiki/PGP) 和 [S/MIME](S/MIME)。

##### 传输安全

传输过程可能被窃听。为了应付这情况，有两种解决方法：

- 使用SSL连接，当前的两种邮件接受协议（POP3 和 IMAP）和一种邮件发送协议（SMTP）都支持安全的服务器连接。在大多数流行的电子邮件客户端程序里面都集成了对SSL的支持。
- 将邮件加密之后，用普通连接传输。比如由 GnuPG 等加密软件在寄送前加密，Outlook 也可以。

##### 储存安全

对已加密的邮件，可以选择不保存解密后的邮件。已加密的邮件是指发送者在发送之前对邮件本身进行加密，不是指加密传输。如果邮件本身已加密，则没有必要进行加密传输。对非加密的邮件（指发送者在发送之前没有对邮件本身进行加密，至于是否使用加密传输是另一回事），邮件的储存安全就如同于其他文件的储存安全一样，重点在于防范非授权使用。当然，就如同可以对一般文件进行加密一样，也可以对这些非加密的邮件在收到后进行加密。

##### 接收者已收到确认

接收者可能抵赖说他/她没有收到电子邮件。为了应付这情况，出现了不同的解决方法，但是目前还没有一套普遍被采纳的方案。微软公司的 Microsoft Exchange Server 就提供 Delivery Receipt。因为是机器发的“接收者已收到确认”，所以接收者可能有意或无意地删除了邮件。

##### 拒绝服务攻击

为了妨碍某一用户使用电子邮件（比如不让她/他收到电子邮件），拒绝服务攻击指往被攻击的用户的邮箱发送大量的垃圾邮件，将邮箱塞满。这样被攻击的用户就无法收到那些有用的电子邮件了。这种安全顾虑目前相当程度已被解决。一是邮箱不断增大，另一原因是邮件服务提供商都提供了一些的过滤措施。过滤措施有时也会把有用的电子邮件当成垃圾邮件。现已有一部分邮件服务供应商使用替身邮，防止外界对邮件帐户进行跟踪。

#### 邮件内容

邮件消息主要由两部分组成：消息头（message header）和消息体（message body）。消息头包含 From、To、CC、Subject、Date 等字段（name-value 对的形式）以及其他一些关于邮件的信息。当邮件在各系统之间传输时，SMTP 协议根据消息头字段来沟通传递参数和信息。而消息体包含非结构化文本形式的消息，有时会在消息体结尾包含一个签名块。消息头通过一个空行与消息体之间分隔开。

##### 消息头

消息头必须包含以下字段：

- From ：发件者的邮件地址，还有可选的发件者名字；
- Date：邮件发送时的本地日期时间。接收方可按其本地化方式地显示该日期时间；

还存在其他一些字段：

- To ：收件者的邮件地址，还有可选的收件者名字；
- CC（Carbon Copy）：被抄送者邮件地址。某些邮件客户端会在收件箱中依据当前登录邮箱在邮件接收列表中的位置（To、CC、Bcc）区别显示所接收的邮件。比如可选的 Bcc（Blind Carbon Copy） 字段表示密送；
- Content-Type ：邮件内容的 MIME 类型；
- Precedence：一般值为“bulk”、“junk”、“list”，用来表明该邮件不接收“休假中”、“不在办公室”等自动回复。比如，不向订阅邮件自动回复“休假中”的通知，该值会影响该邮件在邮件队列中的优先级，比如“Precedence: special-delivery”表示尽快传输；
- Message-ID：自动生成的字段。用来阻止多发和作为回复的参照；
- In-Reply-To：指定回复时参照的 Message-ID，用来将相关邮件连接在一起。该字段仅用于回复；
- *References* ：指定回复时参照的 Message-ID，以及前面的回复邮件所参照的那些 Message-ID；
- Reply-To：指定被回复的邮件地址；
- Sender：实际发件人的邮件地址；
- Archived-At：每封邮件到归档表单的直接链接。

> To 字段不一定是实际邮件传送的邮件地址，实际的传送列表由 SMTP 协议提供，该协议可能会也可能不会从消息头中解析出来。To 字段类似于传统信纸上方的地址，而信纸是根据信封上的地址寄送的。类似的，From 字段也不一定实际发件人的邮件地址。

SMTP 定义了邮件的跟踪信息，保存在以下两个字段中：

- Received：SMTP 服务器在收到邮件时将该跟踪记录添加到消息头中；
- Return-Path：当 SMTP 最后一次传递邮件时将该字段添加到消息头中。

其他一些跟服务器相关的字段在广义上也可以称为跟踪字段：

- Authentication-Results：当一个服务器做出校验检查时可将校验结果保存到给字段中交由下游代理处理；
- Received-SPF：保存 SPF  检查结果，比 Authentication-Results 更详细；
- Auto-Submitted：用来标记自动生成的消息；
- VBR-Info：声明 VBR 白名单。

##### 消息体

MIME 标准引入了字符集说明符和两种内容传输编码来传输非 ASCII 数据：

- **可打印字符引用编码（[Quoted-printable](https://zh.wikipedia.org/wiki/Quoted-printable)，或称 QP encoding）** ：使用可打印的 ASCII 字符 （如字母、数字与"="）表示各种编码格式下的字符，以便能在 7-bit 数据通路上传输 8-bit 数据, 或者更一般地说，在非 8-bit clean 媒体上正确处理数据；
- [Base64](https://zh.wikipedia.org/wiki/Base64)：用于传输任意二进制数据。

### 使用 JavaMail 发送邮件

[JavaMail](https://javaee.github.io/javamail/) API 提供了一个平台无关的、协议无关的邮件和消息程序构建框架，它属于 Java EE 平台的一部分，也可以在 Java SE 平台上可以添加该包。

在使用 JavaMail API 收发 QQ 邮件、163 邮件、或 Gmail 邮件之前，我们必须开启这些邮件服务器的 POP3/SMTP 和 IMAP/SMTP 服务才行。处于安全考虑，可以配置 SSL 连接。另外，现在许多邮箱需要使用授权码作为密码才能在第三方邮件客户端登录，比如 QQ 邮箱和 163 邮箱等。

#### 设置邮件服务器

##### QQ 邮箱

登录 QQ 邮箱之后，选择“设置”，然后选择“账户”，在“POP3/IMAP/SMTP/Exchange/CardDAV/CalDAV服务”这一项可以开启 POP3/SMTP 和 IMAP/SMTP 服务。

![TIM截图20180519123426](/TIM截图20180519123426.png)

QQ邮箱的第三客户端连接的配置如下：

- 接收邮件服务器：pop.qq.com，使用 SSL，端口号 995；
- 接收邮件服务器：imap.qq.com，使用SSL，端口号 993；
- 发送邮件服务器：smtp.qq.com，使用 SSL，端口号 **465** 或 587；
- 账户名：您的 QQ 邮箱账户名（如果您是 VIP 帐号或 Foxmail 帐号，账户名需要填写完整的邮件地址）；
- 密码：您的 QQ 邮箱密码；
- 电子邮件地址：您的 QQ 邮箱的完整邮件地址。

##### 163 邮箱

登录 163 邮箱之后，选择“设置”，然后选择“POP3/SMTP/IMAP”就选择可以开启 POP3/SMTP 和 IMAP/SMTP 服务。

![TIM截图20180519124425_看图王](/TIM截图20180519124425_看图王.png)

也可以根据提示配置 SSL 连接。

![d911b41f3f1ec5f60cfe5b29430ba087](/d911b41f3f1ec5f60cfe5b29430ba087.jpg)

163 邮箱也提供了授权码来登录第三方客户端。

![TIM截图20180519124526](/TIM截图20180519124526.png)

针对发送失败的错误，我们可以仔细分析出错的 code 码来查找对应的错误原因。网易邮箱的 code 码参考地址：

http://help.163.com/09/1224/17/5RAJ4LMH00753VB8.html。

##### Gmail 邮箱

登录 Gmail 邮箱（需要翻越 GFW）之后，点击右上方的“设置”图标，然后点击“设置”，选择“转发和 POP/IMAP”标签。在“POP 下载”部分，选择**对所有邮件启用 POP** 或**对从现在起收到的邮件启用 POP**。在“IMAP 访问”部分，点击**启用 IMAP**。点击页面底部的**保存更改**。

![TIM截图20180519130719](/TIM截图20180519130719.png)

第三方邮件客户端设置：

- 接收邮件 (POP) 服务器：pop.gmail.com，使用 SSL，端口号 995；
- 接收邮件 (IMAP) 服务器：imap.gmail.com，使用 SSL，端口号 993；
- 发送邮件 (SMTP) 服务器：smtp.gmail.com，使用 SSL，端口号 465，要求使用身份验证。TLS/STARTTLS 使用 587 端口（如果可用）；
- 完整名称或显示名称：您的姓名；
- 帐号名、用户名或电子邮件地址：您的电子邮件地址；
- 密码：您的 Gmail 密码。

某些应用和设备使用的登录技术不够安全，Gmail 拒绝登录以免使帐号受到侵害。Gmail 建议**禁止**这些应用访问您的帐号。但如果你甘愿冒险，则转到“我的帐号”页面的“不够安全的应用”部分可设置**允许**这些应用访问你的帐号。

配置好邮件服务器后，我们就可以使用 Java-Mail API 来操作邮件的收发了。

####  JavaMail API 详解

如果我们创建的是 Maven 项目，则可以通过添加以下依赖来使用 JavaMail：

```xml
<!-- javax.mail-api 1.6.x 需要 JDK 1.7＋，javax.mail-api 1.5.x 需要 JDK 1.5+ -->
<dependency>
	<groupId>javax.mail</groupId>
	<artifactId>javax.mail-api</artifactId>
	<version>1.5.6</version>
</dependency>
```

也可以额外添加 greenmail 的依赖来测试邮件程序：

```xml
<!-- java mail test suite of email servers.
greenmail 1.5.x requires JDK 1.7+ and JavaMail 1.5+, greenmail 1.4.x requires JDK 1.6+ and JavaMail 1.5+ -->
<dependency>
	<groupId>com.icegreen</groupId>
	<artifactId>greenmail</artifactId>
	<version>1.4.1</version>
	<scope>test</scope>
</dependency>
<dependency>
	<groupId>org.slf4j</groupId>
	<artifactId>slf4j-simple</artifactId>
	<version>1.7.7</version>
	<scope>test</scope>
</dependency>
```

JavaMail API 的包有：

- javax.mail：包含模拟邮件系统的类；

- javax.mail.event：包含代表邮件系统的监听器和事件类。

- javax.mail.internet：包含代表特定的邮件系统的类；

- javax.mail.search：包含消息查询的类。

- javax.mail.util：包含邮件操作的工具类。

##### Session

javax.mail.Session final 类定义了基本的邮件会话。就像 Http 会话那样，邮件收发工作都是基于这个会话的。可以通过该类的以下静态方法获取其对象：

- public static Session getDefaultInstance(Properties props)
- public static Session getDefaultInstance(Properties props, Authenticator authenticator)
- public static Session getInstance(Properties props)
- public static Session getInstance(Properties props, Authenticator authenticator)

传入的 java.util.Properties 参数对象需要设置 [JavaMail 规范](https://javaee.github.io/javamail/docs/JavaMail-1.5.pdf) 中附录 A 列出的属性：

- mail.store.protocol: Specifies the **default Message Access Protocol**. The Session.getStore() method returns a Store object that implements this protocol. The client can override this property and explicitly specify the protocol with the Session.getStore(String protocol) method. The default value is the first appropriate protocol in the config files.
- mail.transport.protocol: Specifies the **default Transport Protocol**. The Session.getTransport() method returns a Transport object that implements this protocol. The client can override this property and explicitly specify the protocol by using Session.getTransport(String protocol) method. The default value is the first appropriate protocol in the config files.
- mail.host: Specifies the **default Mail server**. The Store and Transport object’s connect methods use this property, if the protocol specific host property is absent, to locate the target host.The default value is the local machine
- mail.user: Specifies **the username to provide when connecting to a Mail server**. The Store and Transport object’s connect methods use this property, if the protocol specific username property is absent, to obtain the username. The default value is user.name.
- mail.protocol.host: Specifies **the protocol-specific default Mail server**. This **overrides the mail.host property**. The default value is mail.host.
- mail.protocol.user: Specifies the protocol-specific default username for connecting to the Mail server. This overrides the mail.user property. The default value is mail.user.
- mail.from: Specifies **the return address of the current user**. **Used by the InternetAddress.getLocalAddress method to specify the current user’s email address**. The default value is username@host.
- mail.debug: Specifies **the initial debug mode**. **Setting this property to true will turn on debug mode**, while setting it to false turns debug mode off. Note that the Session.setDebug method also controls the debug mode. The default value is false.

传入的 javax.mail.Authenticator 抽象类描述了如何获取网络连接的认证信息。当需要认证时，系统会使用该抽象类的子类对象的方法来获取认证信息。创建 javax.mail.Session 对象时传入的 Authenticator 对象会与后续请求的 Authenticator 比较，如果相同或来自同一个 ClassLoader 则后续的请求才被允许。如果创建 javax.mail.Session 对象传入的 Authenticator 对象为 null，则后续的请求都可以获得并使用对应的 Session。

```java
// get default session
Properties props = new Properties();

Session session = Session.getDefaultInstance(props, null);

// get customized session
Properties props = new Properties();
// 发送服务器需要身份验证
props.setProperty("mail.smtp.auth", "true");
// 设置邮件服务器主机名
props.setProperty("mail.host", "发件邮箱stmp地址");
// 发送邮件协议名称
props.setProperty("mail.transport.protocol", "smtp");
// 设置环境信息
Session session = Session.getInstance(props);
```

##### Message

Message 抽象类是创建和解析邮件的核心 API，用来模拟一封电子邮件。它包含了一个属性集和一个内容（a set of attributes and a "content" ），文件夹中的 Message 还含有描述其在该文件夹中状态的标志集（a set of flags）。当要发送邮件时需要建立 Message 对象以便发送，当接收邮件时又需要建立 Message 用于保存邮件以便读取消息。 Message 对象要么来自 Folder，要么通过其子类构造。已收到的 Message 一般都是从收件箱（INBOX ）文件夹取得的。从文件夹中获取的 Message 对象是实际消息对象的轻量级引用，即是懒加载的。有些 Folder 实现可能会返回预加载了某些用户指定项的 Message 对象。

我们一般使用 javax.mail.internet.MimeMessage 这个子类创建 Message  对象。MimeMessage 类也实现了 MimePart  接口， 用于创建 MIME 类型的邮件。 为了建立一个 MimeMessage 对象，我们必须将 Session 对象作为 MimeMessage 构造方法的参数传入：

```java

```

如果要是仅仅创建包含文本内容的简单邮件只需要使用 MimeMessage 类即可，但是要是创建的邮件中内嵌有资源（如图片，超链接，html）或多个附件，则需要同时使用 MimeMessage、javax.mail.internet.MimeBodyPart 和javax.mail.internet.MimeMultipart 等类。 

- MimeMessage：表示整封邮件；
- MimeBodyPart：表示邮件的一个 MIME 消息；
- MimeMultipart：表示一个由多个 MIME 消息组合成的 MIME 消息。

一旦 Message 的某个实现类对象初始化完成了，就可以通过 Transport.send 方法发送消息了。

Transport

javax.mail.Tranport 抽象类用于执行邮件的发送任务。该类继承了javax.mail.Service类，它用于连接 SMTP 服务器并把包含在 Message 对象中的邮件数据发送到 SMTP 服务器。Transport 类是一个抽象类，不同的实现子类实现不同的邮件发送协议。其常用方法有：







Store类       javax.mail.Store类是接收邮件的核心API类。其实实例对象实现了某个邮件接收协议的邮件接收对象。只需要获取到该Store对象就可以获取邮件对象，此时的邮件对象也是封装在Message对象中。 

JAF(JavaBean Activation Framework, JavaBean激活架构)是一个专用的数据处理框架，它用于封装数据并且为应用程序提供访问和操作数据的接口。JavaMail API可以利用JAF从某种数据源中读取数据和获知数据的MIME类型，并用这些数据生成MIME消息中的消息头和消息类型。JavaMail API可以利用JAF从某种数据源中读取数据和获知数据的MIME类型，并用这些数据生成MIME消息中的消息体和消息类型。目前使用的版本(Java SE、Java EE)中JAF也已经包含了

JavaMail API 在设计时考虑到与第三方协议实现提供商之间的分离，故我们可以很容易的添加一些第三方协议。具体实现可参考：https://javaee.github.io/javamail/docs/Providers.pdf。

在下文中，我们将使用基于 Java-Mail 的程序与公司或者 ISP 的 SMTP 服务器进行通讯。这个 SMTP 服务器将邮件转发到接收者的 SMTP 服务器，直至最后被接收者通过 POP 或者 IMAP 协议获取。这并不需要 SMTP 服务器使用支持授权的邮件转发，但是却的确要注意 SMTP 服务器的正确设置（SMTP 服务器的设置与 JavaMail API 无关）。  