---
typora-copy-images-to: ..\Graphs\photos
---

## 核心组件

### SecurityContextHolder

SecurityContextHolder 用来存储应用的安全上下文的细节，包含当前在使用应用的身份详情，默认情况下 SecurityContextHolder 使用 ThreadLocal 存储这些信息， 这意味着，安全上下文在同一个线程执行的方法中一直都是有效的， 即使这个安全上下文没有作为一个方法参数传递到那些方法里。这种情况下使用 ThreadLocal 是非常安全的，只要记得在处理完当前主体的请求以后，把这个线程清除就行了。当然，Spring Security 自动帮你管理这一切了， 你就不用担心什么了。

**获取用户信息**

我们在 `SecurityContextHolder ` 内存储目前与应用程序交互的主要细节。Spring Security 使用一个 `Authentication` 对象来表示这些信息。 你通常不需要自我创建一个`Authentication` 对象，但查询 `Authentication` 对象对用户来说是非常常见的。你可以在应用程序的任何位置使用以下代码块来获得当前身份验证的用户名称，例如：

```java
Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
if (principal instanceof UserDetails) {
	String username = ((UserDetails)principal).getUsername();
} else {
	String username = principal.toString();
}
```

通过调用`getContext()`返回的对象是`SecurityContext`接口的实例。这是保存在线程本地存储中的对象。我们将在下面看到，大多数的认证机制以 Spring Security 返回`UserDetails`实例为主。

### UserDetails、UserDetailsService

上面代码中从 `Authentication` 中获取的 Principal 对象在多数时候该对象都可以强转为 `UserDetails` 对象，UserDetails 接口是 Spring Security 中的一个核心接口，可将其当做用户数据表与 Spring Security 需要存在于 SecurityContextHolder 中内容的中间适配器，一般需要实现该接口来创建在你自己的应用中需要的属性，比如用户的邮箱、工号等。

UserDetailsService 接口唯一的方法如下：

```java
UserDetails loadUserByUsername(String username) throws UsernameNotFoundException;
```

该方法用于在 Spring Security 中加载用户信息，用于在任何需要加载用户信息的时候。多数用户都需要实现该方法，用于实现自己的加载用户信息的逻辑：如果找到了用户信息则返回，如果没有找到则抛出 UserNotFoundException 异常。该方法仅用于获取用户信息，不负责认证，认证由 AuthenticationManager 负责。如果需要自定义认证逻辑，那么就需要自己实现 AuthenticationProvider。认证成功后， `UserDetails` 将用于创建在 SecurityContextHolder 中存储的 Authentication 对象。

### GrantedAuthority

`Authentication` 提供的另一个重要的方法就是 getAuthorities()，该方法返回一个 `GrantedAuthority` 对象的集合。顾名思义，`GrantedAuthority` 就是授权给 Principal 的一个 Authority，一般是角色，如 `ROLE_ADMINISTRATOR` 或`ROLE_HR_SUPERVISOR`。这些角色后面会配置在对 web 验证，方法验证和领域对象验证时。Spring Security 其他部分可以识别这些 GrantedAuthority，也需要用到它们。GrantedAuthority 对象集合通常通过 UserDetailsService 实现类在加载用户信息时来获取。

## 认证（Authentication）

Spring Security 可以在很多不同的认证环境下使用。虽然推荐使用 Spring Security，不要与已存在的认证管理系统结合，但它也支持与你自己的认证管理系统进行整合。

### 什么是 Spring Security 中的认证

让我们考虑一个大家都很熟悉的标准的认证场景：

1. 提示用户输入用户名和密码进行登录。
2. 该系统 (成功) 验证该用户名的密码正确。
3. 获取该用户的环境信息 (他们的角色列表等).
4. 为用户建立安全的环境。
5. 用户可能执行一些操作，这些操作可能被访问控制机制（基于当前安全上下文检查操作所需权限）所保护着。

前三个步构成认证过程，所以我们将看看这些是如何发生在 Spring Security 中的：

1. 用户名和密码进行组合成一个`UsernamePasswordAuthenticationToken` 对象（一个`Authentication`接口的实现类）。
2. 这个 Token 对象会传递到 `AuthenticationManager `对象进行验证。
3. 认证成功后，该`AuthenticationManager`会完全填充`Authentication` 对象。
4. 安全上下文是通过调用 `SecurityContextHolder.getContext().setAuthentication(…)` 、并传入填充的 `Authentication` 对象而建立的。

从这一点上来看，用户被认为是被验证的。让我们看看一些代码作为一个例子：

```java
import org.springframework.security.authentication.*;
import org.springframework.security.core.*;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;

public class AuthenticationExample {
	private static AuthenticationManager am = new SampleAuthenticationManager();
	public static void main(String[] args) throws Exception {
		BufferedReader in = new BufferedReader(new InputStreamReader(System.in));
		while(true) {
			System.out.println("Please enter your username:");
			String name = in.readLine();
			System.out.println("Please enter your password:");
			String password = in.readLine();
			try {
				Authentication request = new UsernamePasswordAuthenticationToken(name, password);
				Authentication result = am.authenticate(request);
				SecurityContextHolder.getContext().setAuthentication(result);
				break;
			} catch(AuthenticationException e) {
				System.out.println("Authentication failed: " + e.getMessage());
			}
		}
		System.out.println("Successfully authenticated. Security context contains: " +
		SecurityContextHolder.getContext().getAuthentication());
	}
}

class SampleAuthenticationManager implements AuthenticationManager {
	static final List<GrantedAuthority> AUTHORITIES = new ArrayList<GrantedAuthority>();
	static {
		AUTHORITIES.add(new SimpleGrantedAuthority("ROLE_USER"));
	}

	public Authentication authenticate(Authentication auth) throws AuthenticationException {
		if (auth.getName().equals(auth.getCredentials())) {
			return new UsernamePasswordAuthenticationToken(auth.getName(), 
                                                           auth.getCredentials(), AUTHORITIES);
		}
		throw new BadCredentialsException("Bad Credentials");
	}
}
```

通常不需要写任何这样的代码，以一个 web 认证过滤器为例，这个过程通常会发生在内部。我们刚刚在这里的代码简单显示了 Spring Security 中认证过程。当 `SecurityContextHolder` 中包含一个完全填充的`Authentication`对象时用户被认证。

### 直接设置 SecurityContextHolder 的内容

事实上，Spring Security 不介意你如何把 Authentication 对象包含在 SecurityContextHolder 内。唯一的关键要求是在 AbstractSecurityInterceptor 需要用户授权操作之前，SecurityContextHolder 需要包含 Authentication 。

你可以（很多用户都这样做）写一个自己的过滤器或 MVC 控制器来提供认证系统的交互，这些可不基于 Spring Security的。比如，你也许使用容器管理认证（Container-Managed Authentication），从 ThreadLocal 或 JNDI 里获得当前用户信息。或者，你的公司可能有一个遗留系统，它是一个企业标准，你不能控制它，这种情况下，很容易让 Spring Security 工作，也能提供认证功能。你所需要的就是写一个过滤器（或等价物）从指定位置读取第三方用户信息，把它放到SecurityContextHolder 里。在这种情况下，你自然还需要考虑的事情通常是由内置的认证基础设施。比如，你需要先创建HTTP session 从而在响应返回客户端之前将上下文缓存在每次请求中，因为响应后无法再创建会话。

### 在 Web 应用程序中的身份验证

考虑一个典型的 Web 应用程序的身份认证过程:

1. 你访问首页, 点击一个链接。
2. 向服务器发送一个请求，服务器判断你是否在访问一个受保护的资源。
3. 如果你当前还没有进行过认证，服务器发回一个响应，提示你必须进行认证。响应可能是 HTTP 响应代码，或者是重新定向到一个特定的 web 页面。
4. 依据验证机制，你的浏览器将重定向到特定的 web 页面，这样你可以添加表单，或者浏览器使用其他方式校验你的身份（比如，一个 Basic Authentication 对话框，cookie，或者 X509 证书，或者其他）。
5. 浏览器会发回一个响应给服务器。 这将是 HTTP POST 包含你填写的表单内容，或者是包含你的验证信息的 HTTP 请求头。
6. 下一步，服务器会判断当前的凭证是否是有效的， 如果是有效的，下一步会执行。 如果是非法的，通常浏览器会再尝试一次（所以返回到步骤二）。
7. 你所发送的、会导致验证过程的原始请求会重试。有希望的是你会通过验证，得到足够的授权来访问被保护的资源。如果你有足够的权限，请求会成功。否则，你会收到一个 HTTP 错误代码 403，意思是访问被拒绝。

Spring Security 使用显式的类负责上面提到的每个步骤。主要的参与者有 `ExceptionTranslationFilter` ， 一个 `AuthenticationEntryPoint`  和 一个 `Authentication Mechanism`，用来负责调用 `AuthenticationManager`。

#### ExceptionTranslationFilter

 `ExceptionTranslationFilter` 是 Spring Security 中负责检测抛出的 Spring Security 异常的过滤器，这些异常会在 `AbstractSecurityInterceptor`（认证服务的主要提供者，后面会介绍）中抛出。我们会在下一节讨论`AbstractSecurityInterceptor`，现在我们只需要知道它是用来生成 Java 异常的，并且要知道它与 HTTP、以及怎么认证一个 Principal 并没有什么关系，而 ExceptionTranslationFilter 提供了这些服务，负责返回错误代码 403（如果 Principal 被认证了但权限不足，如同在上边的步骤 7），或者启动一个 AuthenticationEntryPoint（如果 Principal 没有被认证，然后我们需要进入上面的步骤 3）。

#### AuthenticationEntryPoint

`AuthenticationEntryPoint` 负责上面列表中的第 3 步。如你所想的，每个 web 应用程序都有默认的验证策略（这可以像 Spring Security 中其他一切一样进行配置，但是让我们现在将其保持简单些）。每个主要认证系统会有它自己的`AuthenticationEntryPoint`实现， 会执行动作，如同步骤 3 里的描述一样。

#### Authentication Mechanism

在你的浏览器决定提交你的认证凭证之后（使用 HTTP 表单发送或者是 HTTP 请求头），服务器上需要有某种东西“收集”这些身份认证细节。现在我们到了上面的第 6 步。 在 Spring Security 里，我们需要用一个特定的名字来描述从用户代理（通常是浏览器）收集认证信息的功能，这个名称就是“认证机制（Authentication Mechanism）”。例如，基于表单的登录和基于 Basic 的认证，实例是窗体的基本登录和基本的身份验证。一旦从用户代理收集了这些认证细节，就会建立一个`Authentication` “request”对象，然后展示给`AuthenticationManager`。

认证机制重新获得了填充好了的`Authentication`对象时，它会认为请求有效，把`Authentication`放到`SecurityContextHolder`里的，然后重试原始请求（第七步）。另一方面，如果`AuthenticationManager`驳回了请求，认证机制会让用户代理重试（第 2 步）。

#### Storing the SecurityContext between requests

根据不同的应用程序类型，在用户操作的过程中需要有一个合适的策略来保存安全上下文。在一个典型的 web 应用中，一个用户登录系统之后就会被一个特有的 session Id 所唯一标识，服务器会将 session 作用期间的用户数据保存在缓存中。在 Spring Security 中，保存`SecurityContext`的任务落在了`SecurityContextPersistenceFilter`身上，它默认将上下文当做`HttpSession`属性保存在 HTTP 请求中，并且将每一个请求的上下文保存在`SecurityContextHolder`中，最重要的是，在请求结束之后会清理`SecurityContextHolder`。你不需要出于安全目的而直接与 `HttpSession`打交道。在这里仅仅只是不需要那样做，请使用`SecurityContextHolder`来代替`HttpSession`。

许多其他的应用（举个例子：一个无状态的 RESTful 风格 web 服务）不使用 Http Session，并且每次请求过来都会进行认证。然而，将 `SecurityContextPersistenceFilter`被包含在过滤器链中并确保每次请求完毕之后清理`SecurityContextHolder`依然很重要。

> 在一个使用单个会话接收并发请求的应用程序中，线程间会共享同一个的`SecurityContext`实例，即使正在使用`ThreadLocal`，它是每个线程从`HttpSession`中获取的相同实例。如果你希望暂时改变一个线程正在运行的上下文这很有意义。如果你只是使用`SecurityContextHolder.getContext()`，和在返回的上下文对象上调用`setAuthentication(anAuthentication)`，那么，所有共享相同 SecurityContext 实例的并发线程中的`Authentication`对象都会发生改变。 你可以自定义`SecurityContextPersistenceFilter`的行为，为每一个请求创建一个完全新的`SecurityContext`，防止在一个线程的变化影响另一个。或者，你可以创建一个新的实例，只是在这个点上，你暂时改变了上下文。方法`SecurityContextHolder.createEmptyContext()`总是返回一个新的上下文实例。

## Spring Security 中的访问控制（授权）

负责 Spring Security 访问控制决策的主要接口是`AccessDecisionManager`。它有一个`decide`方法，它需要一个`Authentication`对象表示的用户请求访问，一个“secure object”（见下文）和一个应用在该“secure object”上的安全元数据属性（security metadata attribute）列表（如一个表示授予访问权限所需的角色列表）。

### Security and AOP Advice

如果你熟悉 AOP 的话，就会知道有几种不同的拦截方式：前置拦截，后置拦截，异常拦截和环绕拦截。 其中环绕拦截是非常有用的，因为 advisor 可以决定是否执行这个方法，是否修改返回的结果，是否抛出异常。 Spring Security 为方法调用提供了一个环绕 advice，就像 web 请求一样。 我们使用 Spring 的标准 AOP 支持制作了一个处理方法调用的环绕advice，我们使用标准 Filter 建立了对 web 请求的环绕 advice。

对那些不熟悉 AOP 的人，需要理解的关键问题是 Spring Security 可以帮助你保护方法的调用，就像保护 web 请求一样。大多数人对保护服务层里的安全方法非常感兴趣。这是因为在目前这一代 J2EE 程序里，服务器放了更多业务相关的逻辑。如果你只是需要保护服务层的方法调用，Spring 标准 AOP 平台就够了。如果你想直接保护领域对象，你会发现 AspectJ 非常值得考虑。

可以选择使用 AspectJ 还是 SpringAOP 处理方法验证，或者你可以选择使用 filters 处理 web 请求验证。 你可以不选，选择其中一个，选择两个，或者三个都选。主流的应用是处理一些 web 请求验证，再结合一些在服务层里的 Spring AOP 方法调用验证。

### Secure Objects and the AbstractSecurityInterceptor

那么什么是一个“安全对象（secure object）”呢？Spring Security 使用该术语表示可以有应用安全性的任何对象（如授权决定）。最常见的例子就是方法调用和 web 请求。

Spring Security 支持的每个安全对象类型都有它自己拦截器类，它们都是`AbstractSecurityInterceptor`的子类。很重要的是，在`AbstractSecurityInterceptor`被调用的时候，如果 Principal 已经通过了验证，那么`SecurityContextHolder`将会包含一个有效的`Authentication`。

`AbstractSecurityInterceptor`提供了一套一致的工作流程来处理对安全对象的请求，通常是：

1. 查找当前请求里相关的“配置属性（configuration attributes）”。
2. 把安全对象、当前的`Authentication`和配置属性提交给`AccessDecisionManager` 用于决定授权。
3. 有可能在调用的过程中，对`Authentication`进行修改。
4. 允许处理安全对象的调用（假设访问被允许了）。
5. 调用一旦返回，如果配置了 AfterInvocationManager，则调用配置的 `AfterInvocationManager`。如果调用引发异常，`AfterInvocationManager`将不会被调用。

Configuration Attributes

一个“配置属性（Configuration Attributes）”可以看做是一个字符串，这个字符串对于`AbstractSecurityInterceptor`使用的类是有特殊含义的。它们由框架内`ConfigAttribute`接口表示。它们可能是简单的角色名称或拥有更复杂的含义，这就与`AccessDecisionManager`实现类的复杂程度有关了。`AbstractSecurityInterceptor`和一个用来为安全对象搜索属性的 `SecurityMetadataSource` 配置在一起。通常这个配置对用户是不可见的。配置属性将以注解的方式设置在受保护方法上，或者作为受保护 URL 上的访问属性。例如，当我们看到像`<intercept-url pattern='/secure/**' access='ROLE_A,ROLE_B'/>`命名空间中的介绍，这是说配置属性`ROLE_A`和`ROLE_B`适用于匹配特定模式的 Web 请求。在实践中，使用默认的`AccessDecisionManager`配置，这意味着任何拥有`GrantedAuthority`的用户只要符合这两个属性都将被允许访问。严格来说，它们只是依赖于`AccessDecisionManager`实现的属性和说明。使用前缀`ROLE_`是一个标记，以表明这些属性是角色，应该由Spring Security的`RoleVoter`消耗掉，这只在使用基于投票的 AccessDecisionManager 时才相关。

#### RunAsManager

假设`AccessDecisionManager`决定允许执行这个请求，`AbstractSecurityInterceptor`会正常执行这个请求。话虽如此，罕见情况下，用户可能需要把`SecurityContext`的`Authentication`换成另一个`Authentication`，这通过`AccessDecisionManager` 调用`RunAsManager`来处理。这也许在某些由于特殊原因的特定情况下很有用，比如服务层方法需要调用远程系统表现不同的身份。 因为 Spring Security 自动将安全身份从一个服务器传播到另一个（假设你使用了配置好的 RMI 或者 HttpInvoker 远程调用协议客户端，就可以用到它了）。

AfterInvocationManager

跟随安全对象的执行和之后的返回（可能意味着一个方法调用的完成或一个过滤器链的执行）——`AbstractSecurityInterceptor`得到一个最后的机会来处理调用。这个时候，`AbstractSecurityInterceptor`有可能修改返回对象。你可能想让这些发生，因为对于一个安全对象调用来说，不能在来的路上做出授权决定。凭借高可插拔性，如果需要，`AbstractSecurityInterceptor`会将控制权转交给`AfterInvocationManager`来修改对象。这个类实甚至可以替换对象，或者抛出异常，或者什么也不做。如果调用成功，after-invocation 检查才会执行。如果出现异常，额外的检查将被跳过。

`AbstractSecurityInterceptor` 及其相关对象关系如下：

![security-interception](..\Graphs\photos\security-interception.png)

### Extending the Secure Object Model

只有当开发人员考虑一个全新的拦截方法和授权请求时才需要直接使用安全对象。例如，为了确保对消息系统的调用，它有可能建立建立一个新的安全对象。任何需要安全且提供一种拦截调用的方式（如 AOP 环绕 advice 语法）能够被做成一个安全对象。话虽如此，大多数 Spring 应用程序将透明地使用三种目前完全支持的安全对象类型（AOP Alliance `MethodInvocation`，AspectJ `JoinPoint`和 web 请求`FilterInvocation`）。

### 本地化

Spring Security 支持终端用户看到异常消息的本地化。如果你的应用程序是专为讲英语的用户设计的，你不需要做任何事情，因为默认所有的安全信息都是英文的，如果你需要支持其他地方，你需要知道的一切都被包含在这部分。

所有异常消息都可以本地化，包括有关认证失败和访问被拒绝（授权失败）的消息。异常和日志主要集中在开发者和系统发布者（包括不正确的属性，接口违反约定，使用不正确的构造器，启动校验，调试级别的日志），这些没有本地化，而是使用英文硬编码在 Spring Security 代码里。

在`spring-security-core-xx.jar`的中，你会发现一个`org.springframework.security` 包含了一个 `messages.properties`文件，以及一些常用语言的本地化版本。你的`ApplicationContext`应该引用这些资源文件，因为 Spring Security 实现了Spring 的`MessageSourceAware`接口，希望这些消息解析器在应用程序上下文启动的时被依赖注入进来。通常你需要做的是在你的应用程序上下文中该创建一个 Bean 来引用这些消息。一个例子如下所示：

```xml
<bean id="messageSource" class="org.springframework.context.support.ReloadableResourceBundleMessageSource">
	<property name="basename" value="classpath:org/springframework/security/messages"/>
</bean>
```

该`messages.properties`是按照标准的资源束命名的，代表 Spring Security 消息所支持的默认语言。这个默认的文件是英文的。

如果您希望自定义`messages.properties`文件，或支持其他语言，您应该复制该文件并照着重命名，并注册在上面的 bean 的定义中。在这个文件中没有大量的消息 key，因此本地化不应该被认为是一个重要工作。如果你确定需要实现这个文件的本地化，请考虑通过记录一个 JIRA 任务来与社区分享你的工作，并附上恰当命名的`messages.properties`本地化版本。

Spring Security 依赖于 Spring 的本地化支持来查找适当的消息。为了使这生效，你必须确保传入请求的（地理上的）地点存储在 Spring 的 `org.springframework.context.i18n.LocaleContextHolder`中。Spring MVC 的` DispatcherServlet `会自动帮你做这些，但因为 Spring Security 的过滤器在那之前调用，`LocaleContextHolder`需在过滤器被调用之前包含有正确的`Locale`。你也可以在你自己的过滤器里面做这个（必须在Spring Security的`web.xml`过滤之前），或者你可以使用Spring的`RequestContextFilter`。请参阅 Spring Framework 文档，以进一步详细说明使用 Spring 本地化（参考“contacts”示例应用）。

## 核心服务

现在，我们对 Spring Security 的架构和核心类进行高级别的概述，让我们在一个或两个核心接口及其实现的仔细看看，尤其是`AuthenticationManager`，`UserDetailsService`和`AccessDecisionManager`，我们需要知道它们是如何配置如何操作的。

### AuthenticationManager、ProviderManager、AuthenticationProvider

该 AuthenticationManager 只是一个接口，这样的实现可以是我们选择的任何东西，但它是如何在实践中运作的？如果我们需要检查多个授权数据库或者将不同的授权服务结合起来，比如数据库和LDAP服务器?

其默认实现为被称为 ProviderManager 而不是它自己处理身份认证请求，它委托给一个配置好的 AuthenticationProvider 列表，会逐个查询列表中每一项，看它是否能进行认证。每个 provider 程序都将抛出一个异常或返回一个完全填充的身份认证对象。验证的认证请求的最常见的方法是加载相应 UserDetails，并根据用户输入的密码检查已加载的密码。这是由DaoAuthenticationProvider 所使用的方法（见下文）。加载的 UserDetails 对象（尤其是其含有的 GrantedAuthority 集合），将会在认证成功时用于构建一个完全填充的 Authentication 对象，并存储在 SecurityContext 中。

如果你使用的命名空间，会在内部创建并维护 ProviderManager 的一个实例，您可以通过使用命名空间 authentication provider 元素（`<authentication-manager/>` 及其子元素 `<authentication-provider/>`）来添加 providers（参考 [命名空间](https://docs.spring.io/spring-security/site/docs/current/reference/htmlsingle/#ns-auth-manager)章节）。在这种情况下，你不应该在应用程序上下文中声明 ProviderManager bean。然而，如果你没有使用命名空间，那么你会这样声明：

```xml
<bean id="authenticationManager"              class="org.springframework.security.authentication.ProviderManager">
    <constructor-arg>
        <list>
            <ref local="daoAuthenticationProvider"/>
            <ref local="anonymousAuthenticationProvider"/>
            <ref local="ldapAuthenticationProvider"/>
        </list>
    </constructor-arg>
</bean>
```

在上面的例子中，我们有三个提供者。它们试图以顺序显示（隐式使用一个`List`），每个 provider 都能尝试验证，或者通过简单的返回`null`跳过认证。如果所有的实现都返回`null`，则`ProviderManager`将抛出一个`ProviderNotFoundException`。如果你有兴趣了解更多的有关提供者，请参考`ProviderManager`的 JavaDocs。

身份认证机制（如 Web 表单登录处理过滤器）被注入到`ProviderManager`中，并将调用它来处理他们的身份认证请求。配置的 providers 有时可以与认证机制互换，而在其他时候，它们将依赖于特定的认证机制。例如，`DaoAuthenticationProvider`和`LdapAuthenticationProvider`在提交一个简单的用户名/密码验证请求时是兼容的，因此，这两个 providers 都可以与基于表单登录的认证或基于 HTTP Basic 的认证一起工作。另一方面，一些认证机制创建的是只能由单一类型的`AuthenticationProvider`解释的认证请求对象。这一方面的一个例子是 JA-SIG CAS，它使用一个服务票据的概念，因此仅能通过`CasAuthenticationProvider`进行认证。你不必太在意这一点，因为如果你忘记注册一个合适的 provider，在尝试认证时，你会简单地收到一个`ProviderNotFoundException`。

### 成功认证后擦除凭证

默认情况下（从 Spring Security 3.1 开始）的`ProviderManager`将试图清除成功认证后返回的 Authentication 对象中的任何敏感的 credentials 信息，返回一个成功的认证请求的 Authentication`对象的任何敏感的身份验证信息。这可以防止密码等个人资料超过保留时间。

当你在某些条件下（比如，为了改善在无状态情况下应用程序的性能）而使用用户对象的缓存时，这可能会出现问题。如果`Authentication`包含在高速缓存（诸如`UserDetails`实例）的对象的引用中，将其凭证移除，则它将不能再对缓存值进行验证。你在使用缓存时需要考虑到这一点。一个显而易见的解决方案是创建一个对象的副本，无论是在缓存中执行或在由`AuthenticationProvider`创建的`Authentication`返回对象中。或者，你可以在`ProviderManager`中禁用`eraseCredentialsAfterAuthentication`。查看 Javadoc了解更多信息。

### DaoAuthenticationProvider

Spring Security 中实现最简单的`AuthenticationProvider`是`DaoAuthenticationProvider`，也是最早支持的框架。它利用了`UserDetailsService`（作为DAO）去查找用户名和密码。它的用户进行身份验证通过`userdetailsservice`加载`usernamepasswordauthenticationtoken `提交密码进行一对一的比较。配置提供程序是非常简单的：

```xml
<bean id="daoAuthenticationProvider"
    class="org.springframework.security.authentication.dao.DaoAuthenticationProvider">
<property name="userDetailsService" ref="inMemoryDaoImpl"/>
<property name="passwordEncoder" ref="passwordEncoder"/>
</bean>
```

这个`PasswordEncoder`是可选的。一个`PasswordEncoder`提供编码以及`UserDetails`对象提出的密码是从配置`UserDetailsService`返回的解码。

### UserDetailsService 实现

`回想一下，`UserDetailsService 中唯一要实现的方法：

```java
UserDetails loadUserByUsername(String username) throws UsernameNotFoundException;
```

返回的`UserDetails`是提供一系列 getters 方法的一个接口，以保证提供非空的认证信息，例如，用户名，密码，授权和用户帐户是否可用或禁用。大多数 authentication providers 会用到`UserDetailsService`，即使用户名和密码不作为认证决定的一部分。它们可能仅用到`UserDetails`返回对象的`GrantedAuthority`列表信息，因为其他一些系统（如 LDAP 或 X.509 或 CAS 等）已经承担了实际的凭证认证的责任。

鉴于`UserDetailsService`就是这么简单实现的，它应该便于用户使用他们自己的持久化策略来获取认证信息。话虽如此，Spring Security 确实也包括了许多有用的基本实现，我们将在下面看到。

#### In-Memory Authentication

可以简单创建一个自定义的 UserDetailsService 实现，用于通过特定的持久性化方式来提取信息，但许多应用程序不需要这么复杂。尤其是如果你正在建设一个原型应用或刚刚开始结合 Spring Security，你也许真的不想花时间配置数据库或创建 UserDetailsService 实现。对于这种情况，一个简单的选项是使用安全命名空间的 user-service 元素：

```xml
<user-service id="userDetailsService">
	<!-- Password is prefixed with {noop} to indicate to DelegatingPasswordEncoder that
	NoOpPasswordEncoder should be used. This is not safe for production, but makes reading
	in samples easier. Normally passwords should be hashed using BCrypt -->
	<user name="jimi" password="{noop}jimispassword" authorities="ROLE_USER, ROLE_ADMIN" />
	<user name="bob" password="{noop}bobspassword" authorities="ROLE_USER" />
</user-service>
```

这也支持一个外部属性文件的使用：

```xml
<user-service id="userDetailsService" properties="users.properties"/>
```

属性文件应包含在表单条目

```powershell
username=password,grantedAuthority[,grantedAuthority][,enabled|disabled]
```

例如

```powershell
jimi=jimispassword,ROLE_USER,ROLE_ADMIN,enabled
bob=bobspassword,ROLE_USER,enabled
```

#### JdbcDaoImpl

Spring Security 还包括从一个 JDBC 数据源获得认证信息 `UserDetailsService`实现。其内部使用 Spring JDBC，避免了使用一个全功能 ORM 来存储用户信息的复杂性。如果你的应用程序使用了一个 ORM 框架，你可以写一个自定义`UserDetailsService`重用可能已经创建好的映射文件。回到 `JdbcDaoImpl`，其一个实例配置如下：

```xml
<bean id="dataSource" class="org.springframework.jdbc.datasource.DriverManagerDataSource">
	<property name="driverClassName" value="org.hsqldb.jdbcDriver"/>
	<property name="url" value="jdbc:hsqldb:hsql://localhost:9001"/>
	<property name="username" value="sa"/>
	<property name="password" value=""/>
</bean>

<bean id="userDetailsService"
    class="org.springframework.security.core.userdetails.jdbc.JdbcDaoImpl">
	<property name="dataSource" ref="dataSource"/>
</bean>
```

您可以通过修改上面的`DriverManagerDataSource`使用不同的关系型数据库管理系统。你也可以使用一个从 JNDI 或者任何其他的 Spring 配置中获取的全局的数据源。不建议使用 JdbcDaoImpl，因为其中的用户表名和操作语句全都写死了。

### Password Encoding

#### 密码历史

多年来，存储密码的标准机制一直在发展。起初，密码以纯文本形式存储。假定密码是安全的，因为存储密码的数据是需要凭证才能访问的。然而，恶意用户能够通过 SQL 注入等攻击找到获取大量用户名和密码的“数据转储（data dumps）”的方法。随着越来越多的用户凭证变成公开的，安全专家们意识到我们需要做更多的工作来保护用户的密码。

后来鼓励开发人员在将密码通过 SHA-256 之类的单向散列计算后存储。当用户尝试进行身份验证时，存储的散列密码将与他们输入密码的散列值进行比较。这意味着系统只需要存储密码的单向散列。如果发生了攻击，那么暴露的只是密码的散列值。由于散列是一种方法，而且根据散列猜测密码在计算上很困难，因此不值得花力气计算出系统中的每个密码。为了打败这个新系统，恶意用户决定创建一个名为彩虹表（rainbow tables ）的查找表。他们不是每次都猜测每个密码，而是计算密码一次后将其存储在查找表中。

为了降低彩虹表的效率，鼓励开发人员将密码加盐（salt）后再进行散列计算，加入的盐是一个字符串，不是只使用密码作为哈希函数的输入，盐和用户的密码拼接后一起传入通过哈希函数进行计算。盐将以明文形式与用户密码一起存储，可以仅是固定值（称为“公盐”，每个密码的公盐都相同，不安全，一个被破解了，全部都被破解了），也可以仅是一个随机值（称为“私盐”，每个密码的私盐都不一样，故需要与对应的散列值一起保存下来，不建议使用用户名、邮箱等，容易被猜中），也可以是固定值和随机值的组合。然后，当用户尝试进行身份验证时，将用户输入的密码和存储的盐一起计算散列值，将该散列值与存储的散列值比较。独特的盐意味着彩虹表不再有效，因为每种盐和密码组合的散列不同。

现在，我们意识到以前的密码学 hash（比如 SHA-256） 已经不安全了，因为我们可以使用当今的硬件在一秒内执行数十亿次 hash 运算，这意味着我们可以轻松破解每个密码。

现在鼓励开发人员利用自适应单向函数来存储密码。使用自适应单向函数验证密码是资源（即CPU、内存等）敏感的。自适应单向函数允许配置一个“工作因子”，随着硬件的改进，工作因子可以增长。建议将“工作因子”调节成在你的系统上大约需要 1 秒来验证密码。这样做的代价是使攻击者很难破解密码，但不会给您自己的系统带来过多的负担。Spring Security 试图为“工作因子”提供一个良好的起点，但鼓励用户为自己的系统定制“工作因素”，因为不同系统的性能会有很大差异。应该使用的自适应单向函数示例包括 bcrypt、PBKDF2、scrypt 和 Argon2。

由于自适应单向函数故意占用资源，因此为每个请求验证用户名和密码将显著降低应用程序的性能。Spring Security（或任何其他库）无法加快密码验证的速度，因为验证是适应硬件资源的增加的。鼓励用户将长期凭证（即用户名和密码）交换为短期凭证（即会话、OAuth令牌等）。短期凭据可以在不损失安全性的情况下快速验证。

Spring Security 的 PasswordEncoder 接口用于执行密码的单向转换，以允许安全地存储密码。假设 PasswordEncoder 是单向转换，那么当密码转换需要双向转换时（即存储用于向数据库进行身份验证的凭据），它就不需要了。通常，PasswordEncoder 用于存储需要与用户在身份验证时提供的密码进行比较的密码。对于安全性，使用`org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder"`是一个不错的选择。在其他常见的编程语言中也有兼容的实现，所以对于互相操作性它也是一个很好的选择。

#### DelegatingPasswordEncoder

在 Spring Security 5.0 之前，默认的密码编码器是 NoOpPasswordEncoder，它需要纯文本密码。根据密码历史部分，您可能希望默认密码编码器现在类似于 BCryptPasswordEncoder。然而，这忽略了三个现实世界的问题：

- 有许多使用旧密码编码的应用程序无法轻松迁移

- 密码存储的最佳实践将再次更改

- 作为一个框架，Spring Security 不能频繁地进行破坏更改

相反，Spring Security 引入了 `DelegatingPasswordEncoder`，它通过以下方式解决了所有问题：

- 确保使用当前密码存储建议对密码进行编码

- 允许验证密码在现代和遗留格式

- 允许在将来升级编码

您可以使用 PasswordEncoderFactories 轻松构造一个委派 PasswordEncoder 实例：

```java
PasswordEncoder passwordEncoder = PasswordEncoderFactories.createDelegatingPasswordEncoder();
```

或者，您可以创建自己的自定义实例。例如：

```java
String idForEncode = "bcrypt";
Map encoders = new HashMap<>();
encoders.put(idForEncode, new BCryptPasswordEncoder());
encoders.put("noop", NoOpPasswordEncoder.getInstance());
encoders.put("pbkdf2", new Pbkdf2PasswordEncoder());
encoders.put("scrypt", new SCryptPasswordEncoder());
encoders.put("sha256", new StandardPasswordEncoder());
PasswordEncoder passwordEncoder = new DelegatingPasswordEncoder(idForEncode, encoders);
```

##### 密码存储格式

密码的一般格式为：

```
{id}encodedPassword
```

例如，id 是用于查找应该使用哪个密码编码器的标识符，而 encodedPassword 是所选密码编码器的原始编码密码。id 必须位于密码的开头，以{开头，以}结尾。如果找不到 id，则 id 为 null。例如，以下可能是使用不同 id 编码的密码列表。所有原始密码都是“password”：

```
{bcrypt}$2a$10$dXJ3SW6G7P50lGmMkkmwe.20cQQubK3.HZWzG3YB1tlRy.fqvM/BG 1
{noop}password 2
{pbkdf2}5d923b44a6d129f3ddf3e3c8d29412723dcbde72445e8ef6bf3b508fbf17fa4ed4d6b99ca763d8dc 3
{scrypt}$e0801$8bWJaSu2IKSn9Z9kM+TPXfOc/9bdYSrN1oD9qfVThWEwdRTnO7re7Ei+fUZRJ68k9lTyuTeUp4of4g24hHnazw==$OAOec05+bXxvuu/1qZ6NUR+xQYvYv7BeL1QxwRpY5Pc=  4
{sha256}97cde38028ad898ebc02e690819fa220e88c62e0699403e94fff291cfffaf8410849f27605abcbc0 5
```

1. 第一个密码的密码编码器 id 为bcrypt, encodedPassword 为`$2a$10$dXJ3SW6G7P50lGmMkkmwe.20cQQubK3.HZWzG3YB1tlRy.fqvM/BG`。当匹配时，它将委托给 BCryptPasswordEncoder。

2. 第二个密码的密码编码 id 为 noop, encodedPassword 为 password。匹配时将委托给 NoOpPasswordEncoder。

3. 第三个密码的密码编码id为 pbkdf2，编码密码为`5d923b44a6d129f3ddf3e3c29412723dcbde72445e8ef6bf3b508fbf17fa4ed4d6b99ca763d8dc`。匹配时将委托给 Pbkdf2PasswordEncoder。

4. 第四个密码将有一个 PasswordEncoder id 为 scrypt, encodedPassword 为`$e0801$8bWJaSu2IKSn9Z9kM+TPXfOc/9bdYSrN1oD9qfVThWEwdRTnO7re7Ei+fUZRJ68k9lTyuTeUp4of4g24hHnazw==$OAOec05+bXxvuu/1qZ6NUR+xQYvYv7BeL1QxwRpY5Pc=`，匹配时将委托给 SCryptPasswordEncoder。

5. 最终密码的密码编码id为sha256，编码密码为`97cde38028ad898ebc02e690819fa220e88c62e0699403e94fff291cfffaf8410849f27605abcbc0`。匹配时将委托给StandardPasswordEncoder。

一些用户可能担心存储格式是为潜在的黑客提供的。这不是一个问题，因为密码的存储并不依赖于算法的机密性。此外，攻击者在没有前缀的情况下很容易识别大多数格式。例如，BCrypt 密码通常以`$2a$`开头。

传入构造函数的 idForEncode 确定将使用哪个 PasswordEncoder 对密码进行编码。在上面构造的DelegatingPasswordEncoder 中，这意味着编码密码的结果将被委托给 BCryptPasswordEncoder，并以 {bcrypt} 作为前缀。最终结果如下：

```
{bcrypt}$2a$10$dXJ3SW6G7P50lGmMkkmwe.20cQQubK3.HZWzG3YB1tlRy.fqvM/BG
```

##### 密码匹配

匹配是基于 {id} 和 id 到构造函数中提供的 PasswordEncoder 的映射来完成的。在“密码存储格式”一节中，我们的示例提供了一个工作示例，说明如何实现这一点。默认情况下，使用密码和未映射的id（包括null id）调用匹配的结果（CharSequence、String）将导致 IllegalArgumentException。可以使用委托 PasswordEncoder. setdefaultpasswordencoderformatches(PasswordEncoder) 来定制此行为。

通过使用 id，我们可以匹配任何密码编码，使用最现代的密码编码编码密码。这一点很重要，因为与加密不同，密码散列的设计使恢复明文没有简单的方法。由于无法恢复明文，因此很难迁移密码。

#### BCryptPasswordEncoder

BCryptPasswordEncoder 实现使用广泛支持的 bcrypt 算法来散列密码。为了使它更能抵抗密码破解，bcrypt 故意放慢速度。与其他自适应单向函数一样，应该将其调优为大约1秒来验证系统上的密码。

```java
// Create an encoder with strength 16
BCryptPasswordEncoder encoder = new BCryptPasswordEncoder(16);
String result = encoder.encode("myPassword");
assertTrue(encoder.matches("myPassword", result));
```

### HttpSecurity

```java
protected void configure(HttpSecurity http) throws Exception {
    http
        .authorizeRequests()
            .anyRequest().authenticated()
            .and()
        .formLogin()
            .and()
        .httpBasic();
}
```

表单

```java
protected void configure(HttpSecurity http) throws Exception {
    http
        .authorizeRequests()
            .anyRequest().authenticated()
            .and()
        .formLogin()
            .loginPage("/login")
            .permitAll();
}
```

HttpSecurity：它允许为特定的 http 请求配置基于 web 的安全性。默认情况下，它将应用于所有请求，但是可以使用requestMatcher(requestMatcher) 或其他类似方法进行限制。主要方法如下：

- addFilter(javax.servlet.Filter filter)：添加一个 Filter，该 Filter 必须是安全框架中提供的 Filter 的实例或扩展其中一个 Filter。该方法确保自动处理过滤器的排序。过滤器的顺序为：
  - ChannelProcessingFilter
  - ConcurrentSessionFilter
  - SecurityContextPersistenceFilter
  - LogoutFilter
  - X509AuthenticationFilter
  - AbstractPreAuthenticatedProcessingFilter
  - CasAuthenticationFilter
  - UsernamePasswordAuthenticationFilter
  - ConcurrentSessionFilter
  - OpenIDAuthenticationFilter
  - DefaultLoginPageGeneratingFilter
  - DefaultLogoutPageGeneratingFilter
  - ConcurrentSessionFilter
  - DigestAuthenticationFilter
  - BearerTokenAuthenticationFilter
  - BasicAuthenticationFilter
  - RequestCacheAwareFilter
  - SecurityContextHolderAwareRequestFilter
  - JaasApiIntegrationFilter
  - RememberMeAuthenticationFilter
  - AnonymousAuthenticationFilter
  - SessionManagementFilter
  - ExceptionTranslationFilter
  - FilterSecurityInterceptor
  - SwitchUserFilter
- addFilterAfter(javax.servlet.Filter filter, java.lang.Class<? extends javax.servlet.Filter> afterFilter)：允许在已知的 Filter  类之后添加 Filter 。已知的 Filter 实例要么是 HttpSecurityBuilder. addfilter(Filter) 中列出的过滤器，要么是已经使用 HttpSecurityBuilder.addFilterAfter(Filter, Class) 或 HttpSecurityBuilder.addFilterBefore(Filter, Class) 添加的 Filter；
- addFilterAt(javax.servlet.Filter filter, java.lang.Class<? extends javax.servlet.Filter> atFilter)：在指定 Filter 类的位置添加 Filter。例如，如果希望过滤器 CustomFilter 与 UsernamePasswordAuthenticationFilter 在相同的位置注册，`可以调用它 addFilterAt(new CustomFilter(), UsernamePasswordAuthenticationFilter.class) ，多个过滤器在同一位置的注册意味着它们的顺序是不确定的。更具体地说，在同一个位置注册多个过滤器不会覆盖现有的过滤器。相反，不要注册您不想使用的过滤器；
- addFilterBefore(javax.servlet.Filter filter, java.lang.Class<? extends javax.servlet.Filter> beforeFilter)：允许在已知的 Filter  类之前添加 Filter 。已知的 Filter 实例要么是 HttpSecurityBuilder.addfilter(Filter) 中列出的 Filter ，要么是已经使用 HttpSecurityBuilder.addFilterAfter(Filter, Class) 或  HttpSecurityBuilder.addFilterBefore(Filter, Class) 添加的 Filter；
- antMatcher(java.lang.String antPattern)：只允许在匹配提供的 ant 模式时调用 HttpSecurity 配置。如果需要更高级的配置，可以考虑使用 requestMatchers() 或 requestMatcher(requestMatcher)。调用 antMatcher(String) 将覆盖先前对mvcMatcher(String)}、requestMatchers()、antMatcher(String)、regexMatcher(String)和requestMatcher(requestMatcher) 的调用；
- authenticationProvider(AuthenticationProvider authenticationProvider)：
- beforeConfigure()：在调用每个 SecurityConfigurer.configure(SecurityBuilder) 方法之前调用。子类可以覆盖此方法以在不使用 SecurityConfigurer 的情况下挂钩到生命周期；
- cors()：添加要使用的 CorsFilter。如果提供了一个名为 corsFilter 的 bean，则使用该 corsFilter。否则，如果定义了corsConfigurationSource，则使用该 CorsConfiguration。否则，如果 Spring MVC 在类路径上，则使用HandlerMappingIntrospector；
- csrf()：添加 CSRF 的支持。当使用 WebSecurityConfigurerAdapter 的默认构造函数时，默认情况下会激活该函数。您可以使用 .csrf().disable() 命令禁用它；
- authenticationProvider(AuthenticationProvider authenticationProvider)：允许添加要使用的附加身份验证提供程序；
- exceptionHandling()：允许配置异常处理。这在使用 WebSecurityConfigurerAdapter 时自动应用；
- headers()：将安全 Hearders 添加到响应中。当使用 WebSecurityConfigurerAdapter 的默认构造函数时，默认情况下会激活该函数。接受 WebSecurityConfigurerAdapter 提供的默认值，或者只调用 headers() 而不调用其上的其他方法；
- httpBasic()：配置 HTTP 基本身份验证；
- authorizeRequests()：限制基于所用 HttpServletRequest 的访问。可用方法如下：
  - accessDecisionManager(AccessDecisionManager accessDecisionManager)：允许设置AccessDecisionManager。如果没有提供，则创建一个默认的 AccessDecisionManager；
  - and() ：调用后可以继续配置；
  - `chainRequestMatchersInternal(java.util.List<RequestMatcher> requestMatchers)`：子类应该实现此方法来返回被链接到 RequestMatcher 实例创建的对象；
  - `expressionHandler(SecurityExpressionHandler<FilterInvocation> expressionHandler)`：允许使用 SecurityExpressionHandler 的自定义。默认值是 DefaultWebSecurityExpressionHandler；
  - filterSecurityInterceptorOncePerRequest(boolean filterSecurityInterceptorOncePerRequest)：允许设置每个请求只应用 FilterSecurityInterceptor 一次（例如，如果过滤器在转发上拦截，应该再次应用它）；
  - mvcMatchers(org.springframework.http.HttpMethod method, java.lang.String... mvcPatterns)：映射还指定要匹配的特定 HttpMethod 的 MvcRequestMatcher。这个匹配器将使用 Spring MVC 用于匹配的相同规则。例如，路径“/path”的映射常常与“/path”、“/path/”、“/path.html”匹配。如果 Spring MVC 不处理当前请求，则使用模式作为 ant 模式的合理默认值；
  - mvcMatchers(java.lang.String... patterns)：映射不关心使用哪个 HttpMethod 的 MvcRequestMatcher。这个匹配器将使用 Spring MVC 用于匹配的相同规则。例如，路径“/path”的映射常常与“/path”、“/path/”、“/path.html”匹配。如果当前的请求不能被 Spring MVC 处理，那么将使用一个合理的默认模式作为 ant 模式；
  - `withObjectPostProcessor(ObjectPostProcessor<?> objectPostProcessor)`：为该类添加一个 ObjectPostProcessor；
- formLogin()：添加基于表单的认证。所有属性都有合理的默认值参数可选，如果未指定 loginPage(String)，框架将会自动生成一个登录页面。添加表单认证将会填充 UsernamePasswordAuthenticationFilter、创建 AuthenticationEntryPoint。具体配置如下：
  - loginPage(String loginPage)：配置一个自定义的登录页面地址。修改这里的值还会影响其他默认值：假如，这里配置了“/authentication”，则处理登录请求的默认地址将是“/authentication”（POST方式），登录失败跳转的默认地址将是“/authenticate?error”，成功登出跳转的默认地址将是“/authenticate?logout”；
  - successForwardUrl(String forwardUrl)：指定认证成功后转发地址；
  - failureForwardUrl(String forwardUrl)：指定认证失败后转发地址；
  - usernameParameter(String usernameParameter)：指定用户名参数的对应的自定义名称，默认为“username”；
  - passwordParameter(String passwordParameter)：指定密码参数的对应的自定义名称，默认为“password”；
  - createLoginProcessingUrlMatcher()：通过给定 loginProcessingUrl 创建 RequestMatcher（用于匹配HttpServletRequest）；
  - init(H http)：初始化一个 SecurityBuilder。这里只应该创建和修改共享状态，而不应该创建和修改用于构建对象的 SecurityBuilder 上的属性。这确保 securityconfiguration .configure(SecurityBuilder) 方法在构建时使用正确的共享对象；
  - initDefaultLoginFilter(H http)：如果可用，则初始化一个 DefaultLoginPageGeneratingFilter 共享对象。
  - permitAll()：如果不指定 permitAll() 来允许访问则会导致重定向死循环，因为"/login"也需要认证后才能访问。
- logout()：提供注销的支持。这在使用 WebSecurityConfigurerAdapter 时自动应用。默认情况下，访问 URL“/logout”将注销用户，执行的操作有：清空 HTTP 会话、清除任何已配置的 rememberMe() 身份验证、清除SecurityContextHolder，然后重定向到“/login?success”，更多配置方法：
  - addLogoutHandler(LogoutHandler logoutHandler)：添加一个 LogoutHandler。默认情况下，SecurityContextLogoutHandler 被添加为最后一个 LogoutHandler；
  - clearAuthentication(boolean clearAuthentication)：指定 SecurityContextLogoutHandler 是否应该在注销时清除身份验证；
  - configure(H http)：通过在 SecurityBuilder 上设置必要的属性来配置 SecurityBuilder；
  - defaultLogoutSuccessHandlerFor(LogoutSuccessHandler handler, RequestMatcher preferredMatcher)：设置要使用的默认 LogoutSuccessHandler，它更愿意被所提供的 RequestMatcher 调用。如果没有指定LogoutSuccessHandler，则使用 SimpleUrlLogoutSuccessHandler。如果配置了任何默认的 LogoutSuccessHandler 实例，那么将使用一个委托 LogoutSuccessHandler，该委托默认为SimpleUrlLogoutSuccessHandler；
  - deleteCookies(java.lang.String... cookieNamesToClear)：允许指定要在注销成功时删除的 cookie 的名称。这是使用 CookieClearingLogoutHandler 轻松调用 addLogoutHandler(LogoutHandler) 的快捷方式；
  - init(H http)：初始化SecurityBuilder。这里只应该创建和修改共享状态，而不应该创建和修改用于构建对象的 SecurityBuilder 上的属性。这确保 SecurityConfigurer.configure(SecurityBuilder) 方法在构建时使用正确的共享对象；
  - invalidateHttpSession(boolean invalidateHttpSession)：配置 SecurityContextLogoutHandler，使 HttpSession 在注销时失效；
  - logoutRequestMatcher(RequestMatcher logoutRequestMatcher)：触发登出的 RequestMatcher 发生。在大多数情况下，用户将使用 logoutUrl(String)，这有助于实施良好的实践；
  - logoutSuccessHandler(LogoutSuccessHandler logoutSuccessHandler)：注销后要重定向到的 URL。默认值是“/login?logout”。这是使用 SimpleUrlLogoutSuccessHandler 调用logoutSuccessHandler(logoutSuccessHandler) 的快捷方式；
  - logoutSuccessUrl(java.lang.String logoutSuccessUrl)：注销后要重定向到的 URL。默认值是“/login?logout”。这是使用 SimpleUrlLogoutSuccessHandler 调用 logoutSuccessHandler(logoutSuccessHandler) 的快捷方式；
  - logoutUrl(java.lang.String logoutUrl)：触发登出的 URL(默认为“/logout”)。如果启用了 CSRF 保护(默认)，那么请求也必须是 POST。这意味着默认情况下，触发注销需要 POST“/logout”。如果禁用 CSRF 保护，则允许使用任何 HTTP 方法。在任何更改状态(即注销)的操作上使用 HTTP POST 来防止 CSRF 攻击被认为是最佳实践。如果您真的想使用 HTTP GET，可以使用 logoutRequestMatcher(new AntPathRequestMatcher(logoutUrl，“GET”));；
  - permitAll()：一个参数为 true 的 permitAll(boolean) 快捷方式；
  - permitAll(boolean permitAll)：为每个用户授予对 logoutSuccessUrl(String) 和 logoutUrl(String) 的访问权。
- oauth2Client()：
- oauth2Login()：
- oauth2ResourceServer()：
- openidLogin()：配置基于OpenID 的认证；
- regexMatcher(java.lang.String pattern)：只允许在匹配提供的正则模式时调用 HttpSecurity 配置。如果需要更高级的配置，可以考虑使用 requestMatchers() 或 requestMatcher(requestMatcher)。调用 regexMatcher(String) 将覆盖先前对 mvcMatcher(String)}、requestMatchers()、antMatcher(String)、regexMatcher(String) 和requestMatcher(requestMatcher) 的调用；
- rememberMe()：允许配置“记住我”身份验证；
- requestMatchers()：允许指定将在哪个 HttpServletRequest 实例上调用此 HttpSecurity。该方法允许为多个不同的RequestMatcher 实例轻松调用 HttpSecurity。如果只需要一个 RequestMatcher，可以考虑使用mvcMatcher(String)、antMatcher(String)、regexMatcher(String) 或 RequestMatcher (RequestMatcher)；
- requestMatcher(RequestMatcher requestMatcher)：允许只在匹配提供的 RequestMatcher 时调用 HttpSecurity 配置。如果需要更高级的配置，请考虑使用 requestMatchers()；
- securityContext()：
- sessionManagement()：允许配置会话管理：
  - maximumSessions(int maximumSessions)：控制用户的最大会话数。默认值是允许任意数量的用户；
  - sessionAuthenticationErrorUrl(java.lang.String sessionAuthenticationErrorUrl)：定义错误页面的 URL，当 SessionAuthenticationStrategy 引发异常时应该显示该 URL。如果未设置，将向客户端返回未经授权的(402)错误代码。请注意，如果在基于表单的登录过程中发生错误，则此属性不适用，其中身份验证失败的 URL 将优先于此登录；
  - sessionAuthenticationFailureHandler(AuthenticationFailureHandler sessionAuthenticationFailureHandler)：定义AuthenticationFailureHandler，当SessionAuthenticationStrategy 引发异常时将使用该处理程序。如果未设置，将向客户端返回未经授权的(402)错误代码。请注意，如果在基于表单的登录过程中发生错误，则此属性不适用，其中身份验证失败的 URL 将优先于此登录；
  - sessionAuthenticationErrorUrl(java.lang.String sessionAuthenticationErrorUrl)：允许显式指定SessionAuthenticationStrategy。默认情况下，Servlet 3.1 使用 SessionFixationProtectionStrategy 或 Servlet 3.1使用 ChangeSessionIdAuthenticationStrategy。如果配置了限制最大会话数的方法，则将委托给 ConcurrentSessionControlAuthenticationStrategy 的会话会话验证策略组合为默认的或提供的会话验证策略和 RegisterSessionAuthenticationStrategy；
  - sessionFixation() ：允许配置 SessionFixation（会话固定）保护：
    - changeSessionId()：指定应使用 Servlet 容器提供的会话固定保护。当会话进行身份验证时，调用 Servlet 3.1方法 HttpServletRequest.changeSessionId() 来更改会话 ID 并保留所有会话属性。在 Servlet 3.0 或更旧的容器中使用此选项会导致 IllegalStateException；
    - migrateSession()：指定应该创建一个新会话，并保留原始 HttpSession 中的会话属性；
    - newSession()：指定应该创建一个新会话，但是不应该保留原始 HttpSession 中的会话属性；
    - none()：指定不应启用会话固定保护。当使用其他机制来防止会话固定时，这可能是有用的。例如，如果已经使用了应用程序容器会话固定保护。否则，不建议使用此选项。
- setSharedObject(java.lang.Class<C> sharedType, C object)：设置由多个 SecurityConfigurer 共享的对象；
- userDetailsService(UserDetailsService userDetailsService)：允许添加要使用的额外的 UserDetailsService。




哪些可以访问

```java
protected void configure(HttpSecurity http) throws Exception {
    http
        .authorizeRequests()                                                                
            .antMatchers("/resources/**", "/signup", "/about").permitAll()                  
            .antMatchers("/admin/**").hasRole("ADMIN")                                      
            .antMatchers("/db/**").access("hasRole('ADMIN') and hasRole('DBA')")            
            .anyRequest().authenticated()                                                   
            .and()
        // ...
        .formLogin();
}
```





用户登录基本流程处理如下：

1 SecurityContextPersistenceFilter

2 AbstractAuthenticationProcessingFilter

3 UsernamePasswordAuthenticationFilter

4 AuthenticationManager

5 AuthenticationProvider

6 userDetailsService

7 userDetails

8 认证通过

9 SecurityContext

10 SecurityContextHolder

11 AuthenticationSuccessHandler

