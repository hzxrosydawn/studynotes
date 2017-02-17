## **Intent和IntentFilter详解**

[Intent](https://developer.android.com/reference/android/content/Intent.html) 是一个消息传递对象，您可以使用它从其他[应用组件](https://developer.android.com/guide/components/fundamentals.html#Components)请求操作。尽管 Intent 可以通过多种方式促进组件之间的通信，但其基本用例主要包括以下三个：

- **启动 Activity**：
  [Activity](https://developer.android.com/reference/android/app/Activity.html) 表示应用中的一个屏幕。通过将 [Intent](https://developer.android.com/reference/android/content/Intent.html) 传递给 [startActivity()](https://developer.android.com/reference/android/content/Context.html#startActivity(android.content.Intent))，您可以启动新的 [Activity](https://developer.android.com/reference/android/app/Activity.html) 实例。[Intent](https://developer.android.com/reference/android/content/Intent.html) 描述了要启动的 Activity，并携带了任何必要的数据。

  如果您希望在 Activity 完成后收到结果，请调用 [startActivityForResult()](https://developer.android.com/reference/android/app/Activity.html#startActivityForResult(android.content.Intent,%20int))。在 Activity 的[onActivityResult()](https://developer.android.com/reference/android/app/Activity.html#onActivityResult(int,%20int,%20android.content.Intent)) 回调中，您的 Activity 将结果作为单独的 [Intent](https://developer.android.com/reference/android/content/Intent.html) 对象接收。如需了解详细信息，请参阅[Activity](https://developer.android.com/guide/components/activities.html)指南。

- **启动服务**：
  [Service](https://developer.android.com/reference/android/app/Service.html) 是一个不使用用户界面而在后台执行操作的组件。通过将 [Intent](https://developer.android.com/reference/android/content/Intent.html) 传递给 [startService()](https://developer.android.com/reference/android/content/Context.html#startService(android.content.Intent))，您可以启动服务执行一次性操作（例如，下载文件）。[Intent](https://developer.android.com/reference/android/content/Intent.html) 描述了要启动的服务，并携带了任何必要的数据。

  如果服务旨在使用客户端-服务器接口，则通过将 [Intent](https://developer.android.com/reference/android/content/Intent.html) 传递给 [bindService()](https://developer.android.com/reference/android/content/Context.html#bindService(android.content.Intent,%20android.content.ServiceConnection,%20int))，您可以从其他组件绑定到此服务。如需了解详细信息，请参阅[服务](https://developer.android.com/guide/components/services.html)指南。

- **发送广播**：
  广播是任何应用均可接收的消息。系统将针对系统事件（例如：系统启动或设备开始充电时）传递各种广播。通过将 [Intent](https://developer.android.com/reference/android/content/Intent.html) 传递给 [sendBroadcast()](https://developer.android.com/reference/android/content/Context.html#sendBroadcast(android.content.Intent))、
  [sendOrderedBroadcast()](https://developer.android.com/reference/android/content/Context.html#sendOrderedBroadcast(android.content.Intent,%20java.lang.String)) 或 [sendStickyBroadcast()](https://developer.android.com/reference/android/content/Context.html#sendStickyBroadcast(android.content.Intent))，您可以将广播传递给其他应用。

## 1、Intent 类型

Intent 分为两种类型：

- **显式 Intent **：按名称（完全限定类名）指定要启动的组件。通常，您会在自己的应用中使用显式 Intent 来启动组件，这是因为您知道要启动的 Activity 或服务的类名。例如，启动新 Activity 以响应用户操作，或者启动服务以在后台下载文件。
- **隐式 Intent **：不会指定特定的组件，而是声明要执行的常规操作，从而允许其他应用中的组件来处理它。例如，如需在地图上向用户显示位置，则可以使用隐式 Intent，请求另一具有此功能的应用在地图上显示指定的位置。

创建显式 Intent 启动 Activity 或服务时，系统将立即启动 [Intent](https://developer.android.com/reference/android/content/Intent.html) 对象中指定的应用组件。

创建隐式 Intent 时，Android 系统通过将 Intent 的内容与在设备上其他应用的[清单文件](https://developer.android.com/guide/topics/manifest/manifest-intro.html)中声明的 Intent 过滤器进行比较，从而找到要启动的相应组件。[Intent](https://developer.android.com/reference/android/content/Intent.html)如果 Intent 与 Intent 过滤器匹配，则系统将启动该组件，并将其传递给对象。如果多个 Intent 过滤器兼容，则系统会显示一个对话框，支持用户选取要使用的应用。

**图 1. **隐式 Intent 如何通过系统传递以启动其他 Activity 的图解：**[1]** Activity A 创建包含操作描述的 [Intent](https://developer.android.com/reference/android/content/Intent.html)，并将其传递给 [startActivity()](https://developer.android.com/reference/android/content/Context.html#startActivity(android.content.Intent))。**[2]** Android 系统搜索所有应用中与 Intent 匹配的 Intent 过滤器。**找到匹配项之后，**[3]** 该系统通过调用匹配 Activity（Activity B）的 [onCreate()](https://developer.android.com/reference/android/app/Activity.html#onCreate(android.os.Bundle)) 方法并将其传递给[Intent](https://developer.android.com/reference/android/content/Intent.html)，以此启动匹配 Activity。

Intent 过滤器是应用清单文件中的一个表达式，它指定该组件要接收的 Intent 类型。例如，通过为 Activity 声明 Intent 过滤器，您可以使其他应用能够直接使用某一特定类型的 Intent 启动 Activity。同样，如果您没有为 Activity 声明任何 Intent 过滤器，则 Activity 只能通过显式 Intent 启动。

> **警告：**为了确保应用的安全性，启动 [Service](https://developer.android.com/reference/android/app/Service.html) 时，请始终使用显式 Intent，且不要为服务声明 Intent 过滤器。使用隐式 Intent 启动服务存在安全隐患，因为您无法确定哪些服务将响应 Intent，且用户无法看到哪些服务已启动。从 Android 5.0（API 级别 21）开始，如果使用隐式 Intent 调用 [bindService()](https://developer.android.com/reference/android/content/Context.html#bindService(android.content.Intent,%20android.content.ServiceConnection,%20int))，系统会抛出异常。

## 2、构建 Intent

[Intent](https://developer.android.com/reference/android/content/Intent.html) 对象携带了 Android 系统用来确定要启动哪个组件的信息（例如，准确的组件名称或应当接收该 Intent 的组件类别），以及收件人组件为了正确执行操作而使用的信息（例如，要采取的操作以及要处理的数据）。

[Intent](https://developer.android.com/reference/android/content/Intent.html) 中包含的主要信息如下：

- **组件名称**
  要启动的组件名称。这是可选项，但也是构建**显式** Intent 的一项重要信息，这意味着 Intent 应当仅传递给由组件名称定义的应用组件。如果没有组件名称，则 Intent 是**隐式**的，且系统将根据其他 Intent 信息（例如，以下所述的操作、数据和类别）决定哪个组件应当接收 Intent。因此，如需在应用中启动特定的组件，则应指定该组件的名称。

  > **注意：**启动 [Service](https://developer.android.com/reference/android/app/Service.html) 时，您应 **始终指定组件名称**。否则，您无法确定哪项服务会响应 Intent，且用户无法看到哪项服务已启动。

  [Intent](https://developer.android.com/reference/android/content/Intent.html) 的这一字段是 [ComponentName](https://developer.android.com/reference/android/content/ComponentName.html) 对象，您可以使用目标组件的完全限定类名指定此对象，其中包括应用的软件包名称。例如，com.example.ExampleActivity。您可以使用 [setComponent()](https://developer.android.com/reference/android/content/Intent.html#setComponent(android.content.ComponentName))、[setClass()](https://developer.android.com/reference/android/content/Intent.html#setClass(android.content.Context,%20java.lang.Class%3C?%3E))、[setClassName()](https://developer.android.com/reference/android/content/Intent.html#setClassName(java.lang.String,%20java.lang.String))
  或 [Intent](https://developer.android.com/reference/android/content/Intent.html) 构造函数设置组件名称。

- **操作(action)**
  指定要执行的通用操作（例如，“查看”或“选取”）的字符串。**\**对于广播 Intent，这是指已发生且正在报告的操作。操作在很大程度上决定了其余 Intent 的构成，特别是数据和 extra 中包含的内容。
  您可以指定自己的操作，供 Intent 在您的应用内使用（或者供其他应用在您的应用中调用组件）。但是，您通常应该使用由 [Intent](https://developer.android.com/reference/android/content/Intent.html) 类或其他框架类定义的操作常量。以下是一些用于启动 Activity 的常见操作：
  [ACTION_VIEW](https://developer.android.com/reference/android/content/Intent.html#ACTION_VIEW)
  如果您拥有一些某项 Activity 可向用户显示的信息（例如，要使用图库应用查看的照片；或者要使用地图应用查找的地址），请使用 Intent 将此操作与 [startActivity()](https://developer.android.com/reference/android/content/Context.html#startActivity(android.content.Intent)) 结合使用。

  [ACTION_SEND](https://developer.android.com/reference/android/content/Intent.html#ACTION_SEND)
  这也称为“共享” Intent。如果您拥有一些用户可通过其他应用（例如，电子邮件应用或社交共享应用）共享的数据，则应使用 Intent 中将此操作与 [startActivity()](https://developer.android.com/reference/android/content/Context.html#startActivity(android.content.Intent))
  结合使用。

  有关更多定义通用操作的常量，请参阅[Intent](https://developer.android.com/reference/android/content/Intent.html)类引用。 其他操作在 Android 框架中的其他位置定义。例如，对于在系统的设置应用中打开特定屏幕的操作，将在 [Settings](https://developer.android.com/reference/android/provider/Settings.html) 中定义。
  您可以使用 [setAction()](https://developer.android.com/reference/android/content/Intent.html#setAction(java.lang.String)) 或 [Intent](https://developer.android.com/reference/android/content/Intent.html) 构造函数为 Intent 指定操作。如果定义自己的操作，请确保将应用的软件包名称作为前缀。 例如：

  ```
  static final String ACTION_TIMETRAVEL = "com.example.action.TIMETRAVEL";
  ```

- **数据(data)**
  引用待操作数据和/或该数据 MIME 类型的 URI（[Uri](https://developer.android.com/reference/android/net/Uri.html) 对象）。提供的数据类型通常由 Intent 的操作决定。例如，如果操作是 [ACTION_EDIT](https://developer.android.com/reference/android/content/Intent.html#ACTION_EDIT)
  ，则数据应包含待编辑文档的 URI。
  创建 Intent 时，除了指定 URI 以外，指定数据类型（其 MIME 类型）往往也很重要。例如，能够显示图像的Activity可能无法播放音频文件，即便 URI 格式十分类似时也是如此。因此，指定数据的 MIME 类型有助于 Android 系统找到接收 Intent 的最佳组件。但有时，MIME 类型可以从 URI 中推断得出，特别当数据是 content: URI 时尤其如此。这表明数据位于设备中，且由 [ContentProvider](https://developer.android.com/reference/android/content/ContentProvider.html) 控制，这使得数据 MIME 类型对系统可见。
  要仅设置数据 URI，请调用 [setData()](https://developer.android.com/reference/android/content/Intent.html#setData(android.net.Uri))。要仅设置 MIME 类型，请调用 [setType()](https://developer.android.com/reference/android/content/Intent.html#setType(java.lang.String))。如有必要，您可以使用 [setDataAndType()](https://developer.android.com/reference/android/content/Intent.html#setDataAndType(android.net.Uri,%20java.lang.String)) 同时显式设置二者。**警告：**若要同时设置 URI 和 MIME 类型，**请勿**调用 [setData()](https://developer.android.com/reference/android/content/Intent.html#setData(android.net.Uri)) 和 [setType()](https://developer.android.com/reference/android/content/Intent.html#setType(java.lang.String))，因为它们会互相抵消彼此的值。请始终使用 [setDataAndType()](https://developer.android.com/reference/android/content/Intent.html#setDataAndType(android.net.Uri,%20java.lang.String))同时设置 URI 和 MIME 类型。

- **类别**
  一个包含应处理 Intent 组件类型的附加信息的字符串。您可以将任意数量的类别描述放入一个 Intent 中，但大多数 Intent 均不需要类别。以下是一些常见类别：

  [CATEGORY_BROWSABLE](https://developer.android.com/reference/android/content/Intent.html#CATEGORY_BROWSABLE)
  目标 Activity 允许本身通过 Web 浏览器启动，以显示链接引用的数据，如图像或电子邮件。

  [CATEGORY_LAUNCHER](https://developer.android.com/reference/android/content/Intent.html#CATEGORY_LAUNCHER)
  该 Activity 是任务的初始 Activity，在系统的应用启动器中列出。有关类别的完整列表，请参阅 [Intent](https://developer.android.com/reference/android/content/Intent.html) 类描述。您可以使用 [addCategory()](https://developer.android.com/reference/android/content/Intent.html#addCategory(java.lang.String)) 指定类别。

以上列出的这些属性（组件名称、操作、数据和类别）表示 Intent 的既定特征。通过读取这些属性，Android 系统能够解析应当启动哪个应用组件。

但是，Intent 也有可能会一些携带不影响其如何解析为应用组件的信息。Intent 还可以提供：

- **Extra**
  携带完成请求操作所需的附加信息的键值对。正如某些操作使用特定类型的数据 URI 一样，有些操作也使用特定的附加数据。
  您可以使用各种 [putExtra()](https://developer.android.com/reference/android/content/Intent.html#putExtra(java.lang.String,%20android.os.Bundle)) 方法添加附加数据，每种方法均接受两个参数：键名和值。您还可以创建一个包含所有附加数据的 [Bundle](https://developer.android.com/reference/android/os/Bundle.html) 对象，然后使用 [putExtras()](https://developer.android.com/reference/android/content/Intent.html#putExtras(android.content.Intent)) 将 [Bundle](https://developer.android.com/reference/android/os/Bundle.html) 插入 [Intent](https://developer.android.com/reference/android/content/Intent.html) 中。
  例如，使用 [ACTION_SEND](https://developer.android.com/reference/android/content/Intent.html#ACTION_SEND)创建用于发送电子邮件的 Intent 时，可以使用 [EXTRA_EMAIL](https://developer.android.com/reference/android/content/Intent.html#EXTRA_EMAIL) 键指定“目标”收件人，并使用 [EXTRA_SUBJECT](https://developer.android.com/reference/android/content/Intent.html#EXTRA_SUBJECT) 键指定“主题”。
  [Intent](https://developer.android.com/reference/android/content/Intent.html) 类将为标准化的数据类型指定多个 EXTRA_*
  常量。如需声明自己的附加数据 键（对于应用接收的 Intent ），请确保将应用的软件包名称作为前缀。例如：`static final String EXTRA_GIGAWATTS = "com.example.EXTRA_GIGAWATTS";`
- **标志**
  在 [Intent](https://developer.android.com/reference/android/content/Intent.html) 类中定义的、充当 Intent 元数据的标志。标志可以指示 Android 系统如何启动 Activity（例如，Activity 应属于哪个 [任务](https://developer.android.com/guide/components/tasks-and-back-stack.html) ），以及启动之后如何处理（例如，它是否属于最近的 Activity 列表）。如需了解详细信息，请参阅 [setFlags()](https://developer.android.com/reference/android/content/Intent.html#setFlags(int)) 方法。

### 2.1、显式 Intent 示例

显式 Intent 是指用于启动某个特定应用组件（例如，应用中的某个特定 Activity 或服务）的 Intent。要创建显式 Intent，请为 [Intent](https://developer.android.com/reference/android/content/Intent.html) 对象定义组件名称。Intent 的所有其他属性均为可选属性。
例如，如果在应用中构建了一个名为 DownloadService、旨在从 Web 中下载文件的服务，则可使用以下代码启动该服务：

```
// Executed in an Activity, so 'this' is the Context
// The fileUrl is a string URL, such as "http://www.example.com/image.png"
Intent downloadIntent = new Intent(this, DownloadService.class);
downloadIntent.setData(Uri.parse(fileUrl));
startService(downloadIntent);
```

[Intent(Context, Class)](https://developer.android.com/reference/android/content/Intent.html#Intent(android.content.Context,%20java.lang.Class%3C?%3E)) 构造函数分别为应用和组件提供 [Context](https://developer.android.com/reference/android/content/Context.html) 和 [Class](https://developer.android.com/reference/java/lang/Class.html) 对象。因此，此 Intent 将显式启动该应用中的 DownloadService 类。如需了解有关构建和启动服务的详细信息，请参阅[服务](https://developer.android.com/guide/components/services.html)指南。

### 2.2、隐式 Intent 示例

隐式 Intent 指定能够在可以执行相应操作的设备上调用任何应用的操作。如果您的应用无法执行该操作而其他应用可以，且您希望用户选取要使用的应用，则使用隐式 Intent 非常有用。

例如，如果您希望用户与他人共享您的内容，请使用 [ACTION_SEND](https://developer.android.com/reference/android/content/Intent.html#ACTION_SEND) 操作创建 Intent，并添加指定共享内容的 Extra。使用该 Intent 调用 [startActivity()](https://developer.android.com/reference/android/content/Context.html#startActivity(android.content.Intent))时，用户可以选取共享内容所使用的应用。

> **警告：**用户可能没有任何应用处理您发送到 [startActivity()](https://developer.android.com/reference/android/content/Context.html#startActivity(android.content.Intent)) 的隐式 Intent。如果出现这种情况，则调用将会失败，且应用会崩溃。要验证 Activity 是否会接收 Intent，请对 [Intent](https://developer.android.com/reference/android/content/Intent.html) 对象调用 [resolveActivity()](https://developer.android.com/reference/android/content/Intent.html#resolveActivity(android.content.pm.PackageManager))。如果结果为非空，则至少有一个应用能够处理该 Intent，且可以安全调用[startActivity()](https://developer.android.com/reference/android/content/Context.html#startActivity(android.content.Intent))。如果结果为空，则不应使用该 Intent。如有可能，您应禁用发出该 Intent 的功能。

```
// Create the text message with a string
Intent sendIntent = new Intent();
sendIntent.setAction(Intent.ACTION_SEND);
sendIntent.putExtra(Intent.EXTRA_TEXT, textMessage);
sendIntent.setType("text/plain");

// Verify that the intent will resolve to an activity
if (sendIntent.resolveActivity(getPackageManager()) != null) {
    startActivity(sendIntent);
}
```

> **注意：**在这种情况下，系统并没有使用 URI，但已声明 Intent 的数据类型，用于指定 Extra 携带的内容。

调用 [startActivity()](https://developer.android.com/reference/android/content/Context.html#startActivity(android.content.Intent)) 时，系统将检查已安装的所有应用，确定哪些应用能够处理这种 Intent（即：含 [ACTION_SEND](https://developer.android.com/reference/android/content/Intent.html#ACTION_SEND) 操作并携带“文本/纯”数据的 Intent ）。如果只有一个应用能够处理，则该应用将立即打开并提供给 Intent。如果多个 Activity 接受 Intent，则系统将显示一个对话框，使用户能够选取要使用的应用。

### 2.3、强制使用应用选择器

如果有多个应用响应隐式 Intent，则用户可以选择要使用的应用，并将其设置为该操作的默认选项。 如果用户可能希望今后一直使用相同的应用执行某项操作（例如，打开网页时，用户往往倾向于仅使用一种 Web 浏览器），则这一点十分有用。
但是，如果多个应用可以响应 Intent，且用户可能希望每次使用不同的应用，则应采用显式方式显示选择器对话框。选择器对话框要求用户选择每次操作要使用的应用（用户无法为该操作选择默认应用）。 例如，当应用使用[ACTION_SEND](https://developer.android.com/reference/android/content/Intent.html#ACTION_SEND)
操作执行“共享”时，用户根据目前的状况可能需要使用另一不同的应用，因此应当始终使用选择器对话框，如图 2 中所示。

图2

要显示选择器，请使用 [createChooser()](https://developer.android.com/reference/android/content/Intent.html#createChooser(android.content.Intent,%20java.lang.CharSequence)) 创建 [Intent](https://developer.android.com/reference/android/content/Intent.html)，并将其传递给 [startActivity()](https://developer.android.com/reference/android/app/Activity.html#startActivity(android.content.Intent))。例如：

```
Intent sendIntent = new Intent(Intent.ACTION_SEND);
...

// Always use string resources for UI text.
// This says something like "Share this photo with"
String title = getResources().getString(R.string.chooser_title);
// Create intent to show the chooser dialog
Intent chooser = Intent.createChooser(sendIntent, title);

// Verify the original intent will resolve to at least one activity
if (sendIntent.resolveActivity(getPackageManager()) != null) {
    startActivity(chooser);
}
```

这将显示一个对话框，其中包含响应传递给 [createChooser()](https://developer.android.com/reference/android/content/Intent.html#createChooser(android.content.Intent,%20java.lang.CharSequence)) 方法的 Intent 的应用列表，并使用提供的文本作为对话框标题。

## 3、接收隐式 Intent

要公布应用可以接收哪些隐式 Intent，请在[清单文件](https://developer.android.com/guide/topics/manifest/manifest-intro.html)中使用 [ ](https://developer.android.com/guide/topics/manifest/intent-filter-element.html)元素为每个应用组件声明一个或多个 Intent 过滤器。每个 Intent 过滤器均根据 Intent 的操作、数据和类别指定自身接受的 Intent 类型。仅当隐式 Intent 可以通过 Intent 过滤器之一传递时，系统才会将该 Intent 传递给应用组件。

> **注意：**显式 Intent 始终会传递给其目标，无论组件声明的 Intent 过滤器如何均是如此。

应用组件应当为自身可执行的每个独特作业声明单独的过滤器。例如，图像库应用中的一个 Activity 可能会有两个过滤器，分别用于查看图像和编辑图像。 当 Activity 启动时，它将检查 [Intent](https://developer.android.com/reference/android/content/Intent.html) 并根据 [Intent](https://developer.android.com/reference/android/content/Intent.html) 中的信息决定具体的行为（例如，是否显示编辑器控件）。
每个 Intent 过滤器均由应用清单文件中的 [ ](https://developer.android.com/guide/topics/manifest/intent-filter-element.html)元素定义，并嵌套在相应的应用组件（例如，[ ](https://developer.android.com/guide/topics/manifest/activity-element.html)元素）中。在 [ ](https://developer.android.com/guide/topics/manifest/intent-filter-element.html)内部，您可以使用以下三个元素中的一个或多个指定要接受的 Intent 类型：

- [ ](https://developer.android.com/guide/topics/manifest/action-element.html)
  在 name 属性中，声明接受的 Intent 操作。该值必须是操作的文本字符串值，而不是类常量。
- [ ](https://developer.android.com/guide/topics/manifest/data-element.html)
  使用一个或多个指定 数据 URI（scheme、host、port、path 等）各个方面和 MIME 类型的属性，声明接受的数据类型。
- [ ](https://developer.android.com/guide/topics/manifest/category-element.html)
  在 name 属性中，声明接受的 Intent 类别。该值必须是操作的文本字符串值，而不是类常量。**注意：**为了接收隐式 Intent，**必须**将 [CATEGORY_DEFAULT](https://developer.android.com/reference/android/content/Intent.html#CATEGORY_DEFAULT) 类别包括在 Intent 过滤器中。方法 [startActivity()](https://developer.android.com/reference/android/app/Activity.html#startActivity(android.content.Intent)) 和 [startActivityForResult()](https://developer.android.com/reference/android/app/Activity.html#startActivityForResult(android.content.Intent,%20int)) 将按照已申明 [CATEGORY_DEFAULT][https://developer.android.com/reference/android/content/Intent.html#CATEGORY_DEFAULT](https://developer.android.com/reference/android/content/Intent.html#CATEGORY_DEFAULT)) 类别的方式处理所有 Intent。 如果未在 Intent 过滤器中声明此类别，则隐式 Intent 不会解析为您的 Activity。

例如，以下是一个使用 Intent 过滤器进行的 Activity 声明，当数据类型为文本时，系统将接收 [ACTION_SEND](https://developer.android.com/reference/android/content/Intent.html#ACTION_SEND) Intent ：

```
<activity android:name="ShareActivity">   
  <intent-filter>        
     <action android:name="android.intent.action.SEND"/>  
      <category android:name="android.intent.category.DEFAULT"/>
      <data android:mimeType="text/plain"/>    
  </intent-filter>
</activity>
```

您可以创建一个包括多个 [ ](https://developer.android.com/guide/topics/manifest/action-element.html)、[ ](https://developer.android.com/guide/topics/manifest/data-element.html)或 [ ](https://developer.android.com/guide/topics/manifest/category-element.html)实例的过滤器。创建时，仅需确定组件能够处理这些过滤器元素的任何及所有组合即可。

如需仅以操作、数据和类别类型的特定组合来处理多种 Intent，则需创建多个 Intent 过滤器。

系统通过将 Intent 与所有这三个元素进行比较，根据过滤器测试隐式 Intent。隐式 Intent 若要传递给组件，必须通过所有这三项测试。如果 Intent 甚至无法匹配其中任何一项测试，则 Android 系统不会将其传递给组件。但是，由于一个组件可能有多个 Intent 过滤器，因此未能通过某一组件过滤器的 Intent 可能会通过另一过滤器。如需了解有关系统如何解析 Intent 的详细信息，请参阅下文的 [Intent 解析](https://developer.android.com/guide/components/intents-filters.html#Resolution)部分。

> **警告：**为了避免无意中运行不同应用的 [Service](https://developer.android.com/reference/android/app/Service.html)，请始终使用显式 Intent 启动您自己的服务，且不必为该服务声明 Intent 过滤器。
>
> **注意：** 对于所有 Activity，您必须在清单文件中声明 Intent 过滤器。但是，广播接收器的过滤器可以通过调用 [registerReceiver()](https://developer.android.com/reference/android/content/Context.html#registerReceiver(android.content.BroadcastReceiver,%20android.content.IntentFilter,%20java.lang.String,%20android.os.Handler)) 动态注册。稍后，您可以使用 [unregisterReceiver()](https://developer.android.com/reference/android/content/Context.html#unregisterReceiver(android.content.BroadcastReceiver)) 注销该接收器。这样一来，应用便可仅在应用运行时的某一指定时间段内侦听特定的广播。
>
> **限制对组件的访问**
> 使用 Intent 过滤器时，无法安全地防止其他应用启动组件。尽管 Intent 过滤器将组件限制为仅响应特定类型的隐式 Intent，但如果开发者确定您的组件名称，则其他应用有可能通过使用显式 Intent 启动您的应用组件。如果必须确保只有您自己的应用才能启动您的某一组件，请针对该组件将 [exported ](https://developer.android.com/guide/topics/manifest/activity-element.html#exported)属性设置为 `"false"`。

### 3.1、过滤器示例

为了更好地了解一些 Intent 过滤器的行为，我们一起来看看从社交共享应用的清单文件中截取的以下片段。

```
<activity android:name="MainActivity">
    <!-- This activity is the main entry, should appear in app launcher -->
    <intent-filter>
        <action android:name="android.intent.action.MAIN" />
        <category android:name="android.intent.category.LAUNCHER" />
    </intent-filter>
</activity>

<activity android:name="ShareActivity">
    <!-- This activity handles "SEND" actions with text data -->
    <intent-filter>
        <action android:name="android.intent.action.SEND"/>
        <category android:name="android.intent.category.DEFAULT"/>
        <data android:mimeType="text/plain"/>
    </intent-filter>
    <!-- This activity also handles "SEND" and "SEND_MULTIPLE" with media data -->
    <intent-filter>
        <action android:name="android.intent.action.SEND"/>
        <action android:name="android.intent.action.SEND_MULTIPLE"/>
        <category android:name="android.intent.category.DEFAULT"/>
        <data android:mimeType="application/vnd.google.panorama360+jpg"/>
        <data android:mimeType="image/*"/>
        <data android:mimeType="video/*"/>
    </intent-filter>
</activity>
```

第一个 Activity MainActivity 是应用的主要入口点。当用户最初使用启动器图标启动应用时，该 Activity 将打开：

- [ACTION_MAIN](https://developer.android.com/reference/android/content/Intent.html#ACTION_MAIN) 操作指示这是主要入口点，且不要求输入任何 Intent 数据。
- [CATEGORY_LAUNCHER](https://developer.android.com/reference/android/content/Intent.html#CATEGORY_LAUNCHER) 类别指示此 Activity 的图标应放入系统的应用启动器。如果 [ ](https://developer.android.com/guide/topics/manifest/activity-element.html)元素未使用 icon 指定图标，则系统将使用 [ ](https://developer.android.com/guide/topics/manifest/application-element.html)元素中的图标。

这两个元素必须配对使用，Activity 才会显示在应用启动器中。

第二个 Activity ShareActivity 旨在便于共享文本和媒体内容。尽管用户可以通过从 MainActivity 导航进入此 Activity，但也可以从发出隐式 Intent（与两个 Intent 过滤器之一匹配）的另一应用中直接进入 ShareActivity。

> **注意：**MIME 类型 [application/vnd.google.panorama360+jpg ](https://developers.google.com/panorama/android/)是一个指定全景照片的特殊 数据类型，您可以使用 [Google 全景](https://developer.android.com/reference/com/google/android/gms/panorama/package-summary.html) API 对其进行处理。

## 4、使用待定 Intent（PendingIntent）

[PendingIntent](https://developer.android.com/reference/android/app/PendingIntent.html) 对象是 [Intent](https://developer.android.com/reference/android/content/Intent.html) 对象的包装器。[PendingIntent](https://developer.android.com/reference/android/app/PendingIntent.html) 的主要目的是授权外部应用使用包含的 [Intent](https://developer.android.com/reference/android/content/Intent.html)，就像是它从您应用本身的进程中执行的一样。
待定 Intent 的主要用例包括：

- 声明用户使用您的[通知](https://developer.android.com/guide/topics/ui/notifiers/notifications.html)执行操作时所要执行的 Intent（Android 系统的 [NotificationManager](https://developer.android.com/reference/android/app/NotificationManager.html) 执行 [Intent](https://developer.android.com/reference/android/content/Intent.html)）。
- 声明用户使用您的 [应用小工具](https://developer.android.com/guide/topics/appwidgets/index.html)执行操作时要执行的 Intent（主屏幕应用执行 [Intent](https://developer.android.com/reference/android/content/Intent.html)）。
- 声明未来某一特定时间要执行的 Intent（Android 系统的 [AlarmManager](https://developer.android.com/reference/android/app/AlarmManager.html) 执行 [Intent](https://developer.android.com/reference/android/content/Intent.html)）。

由于每个 [Intent](https://developer.android.com/reference/android/content/Intent.html) 对象均设计为由特定类型的应用组件进行处理（[Activity](https://developer.android.com/reference/android/app/Activity.html)、[Service](https://developer.android.com/reference/android/app/Service.html) 或 [BroadcastReceiver](https://developer.android.com/reference/android/content/BroadcastReceiver.html)），因此还必须基于相同的考虑因素创建[PendingIntent](https://developer.android.com/reference/android/app/PendingIntent.html)。使用待定 Intent 时，应用不会使用调用（如 [startActivity()](https://developer.android.com/reference/android/content/Context.html#startActivity(android.content.Intent))）执行该 Intent。相反，通过调用相应的创建器方法创建 [PendingIntent](https://developer.android.com/reference/android/app/PendingIntent.html)时，您必须声明所需的组件类型：

- [PendingIntent.getActivity()](https://developer.android.com/reference/android/app/PendingIntent.html#getActivity(android.content.Context,%20int,%20android.content.Intent,%20int))，适用于启动 [Activity](https://developer.android.com/reference/android/app/Activity.html) 的 [Intent](https://developer.android.com/reference/android/content/Intent.html)。
- [PendingIntent.getService()](https://developer.android.com/reference/android/app/PendingIntent.html#getService(android.content.Context,%20int,%20android.content.Intent,%20int))，适用于启动 [Service](https://developer.android.com/reference/android/app/Service.html) 的 [Intent](https://developer.android.com/reference/android/content/Intent.html)。
- [PendingIntent.getBroadcast()](https://developer.android.com/reference/android/app/PendingIntent.html#getBroadcast(android.content.Context,%20int,%20android.content.Intent,%20int))，适用于启动 [BroadcastReceiver](https://developer.android.com/reference/android/content/BroadcastReceiver.html) 的 [Intent](https://developer.android.com/reference/android/content/Intent.html)。

除非您的应用正在从其他应用中接收待定 Intent，否则上述用于创建 [PendingIntent](https://developer.android.com/reference/android/app/PendingIntent.html)
的方法可能是您所需的唯一 [PendingIntent](https://developer.android.com/reference/android/app/PendingIntent.html)
方法。

每种方法均会提取当前的应用 [Context](https://developer.android.com/reference/android/content/Context.html)、您要包装的 [Intent](https://developer.android.com/reference/android/content/Intent.html) 以及一个或多个指定应如何使用该 Intent 的标志（例如，是否可以多次使用该 Intent）。

如需了解有关使用待定 Intent 的详细信息，请参阅[通知](https://developer.android.com/guide/topics/ui/notifiers/notifications.html) 和[应用小工具](https://developer.android.com/guide/topics/appwidgets/index.html) API 指南等手册中每个相应用例的相关文档

## 5、Intent 解析

当系统收到隐式 Intent 以启动 Activity 时，它根据以下三个方面将该 Intent 与 Intent 过滤器进行比较，搜索该 Intent 的最佳 Activity：

- Intent 操作
- Intent 数据（URI 和数据类型）
- Intent 类别

下文根据如何在应用的清单文件中声明 Intent 过滤器，描述 Intent 如何与相应的组件匹配。

### 5.1、操作测试(Action Test)

要指定接受的 Intent 操作， Intent 过滤器既可以不声明任何 [ ](https://developer.android.com/guide/topics/manifest/action-element.html)元素，也可以声明多个此类元素。例如：

```
<intent-filter>
    <action android:name="android.intent.action.EDIT" />
    <action android:name="android.intent.action.VIEW" />
    ...
</intent-filter>
```

要通过此过滤器，您在 [Intent](https://developer.android.com/reference/android/content/Intent.html) 中指定的操作必须与过滤器中列出的某一操作匹配。

如果该过滤器未列出任何操作，则 Intent 没有任何匹配项，因此所有 Intent 均无法通过测试。但是，如果 [Intent](https://developer.android.com/reference/android/content/Intent.html) 未指定操作，则会通过测试（只要过滤器至少包含一个操作）。

### 5.2、类别测试(Category Test)

要指定接受的 Intent 类别， Intent 过滤器既可以不声明任何 [ ](https://developer.android.com/guide/topics/manifest/category-element.html)元素，也可以声明多个此类元素。例如：

```
<intent-filter>
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
    ...
</intent-filter>
```

若要 Intent 通过类别测试，则 [Intent](https://developer.android.com/reference/android/content/Intent.html) 中的每个类别均必须与过滤器中的类别匹配。反之则未必然，Intent 过滤器声明的类别可以超出 [Intent](https://developer.android.com/reference/android/content/Intent.html) 中指定的数量，且 [Intent](https://developer.android.com/reference/android/content/Intent.html)
仍会通过测试。因此，不含类别的 Intent 应当始终会通过此测试，无论过滤器中声明何种类别均是如此。

> **注意：** Android 会自动将 [CATEGORY_DEFAULT](https://developer.android.com/reference/android/content/Intent.html#CATEGORY_DEFAULT) 类别应用于传递给 [startActivity()](https://developer.android.com/reference/android/content/Context.html#startActivity(android.content.Intent))
> 和 [startActivityForResult()](https://developer.android.com/reference/android/app/Activity.html#startActivityForResult(android.content.Intent,%20int)) 的所有隐式 Intent。因此，如需 Activity 接收隐式 Intent，则必须 "android.intent.category.DEFAULT" 的类别包括在其 Intent 过滤器中（如上文的 `` 示例所示）。

### 5.3、数据测试(Data Test)

要指定接受的 Intent 数据， Intent 过滤器既可以不声明任何 [ ](https://developer.android.com/guide/topics/manifest/data-element.html)元素，也可以声明多个此类元素。例如：

```
<intent-filter>    
  <data android:mimeType="video/mpeg" android:scheme="http" ... />    
  <data android:mimeType="audio/mpeg" android:scheme="http" ... />   
   ...
</intent-filter>
```

每个 [](https://developer.android.com/guide/topics/manifest/data-element.html) 元素均可指定 URI 结构和数据类型（MIME 介质类型）。URI 的每个部分均包含单独的 scheme、host、port 和 path 属性：
`://:/`
例如：
`content://com.example.project:200/folder/subfolder/etc`
在此 URI 中，模式是 `content`，主机是 `com.example.project`，端口是 `200`，路径是 `folder/subfolder/etc`。
在 [ ](https://developer.android.com/guide/topics/manifest/data-element.html)元素中，上述每个属性均为可选，但存在线性依赖关系：

- 如果未指定模式，则会忽略主机。
- 如果未指定主机，则会忽略端口。
- 如果未指定架构和主机，则会忽略路径。

将 Intent 中的 URI 与过滤器中的 URI 规范进行比较时，它仅与过滤器中包含的部分 URI 进行比较。例如：

- 如果过滤器仅指定架构，则具有该架构的所有 URI 均与该过滤器匹配。
- 如果过滤器指定架构和权限、但未指定路径，则具有相同架构和权限的所有 URI 都会通过过滤器，无论其路径如何均是如此。
- 如果过滤器指定架构、权限和路径，则仅具有相同架构、权限和路径 的 URI 才会通过过滤器。

> **注意：**路径规范可以包含星号通配符 (*)，因此仅需部分匹配路径名即可。

数据测试会将 Intent 中的 URI 和 MIME 类型与过滤器中指定的 URI 和 MIME 类型进行比较。规则如下：

1. 仅当过滤器未指定任何 URI 或 MIME 类型时，不含 URI 和 MIME 类型的 Intent 才会通过测试。
2. 对于包含 URI、但不含 MIME 类型（既未显式声明，也无法通过 URI 推断得出）的 Intent，仅当其 URI 与过滤器的 URI 格式匹配、且过滤器同样未指定 MIME 类型时，才会通过测试。
3. 仅当过滤器列出相同的 MIME 类型且未指定 URI 格式时，包含 MIME 类型、但不含 URI 的 Intent 才会通过测试。
4. 仅当 MIME 类型与过滤器中列出的类型匹配时，包含 URI 和 MIME 类型（通过显式声明，或可以通过 URI 推断得出）的 Intent 才会通过测试的 MIME 类型部分。如果 Intent 的 URI 与过滤器中的 URI 匹配，或者如果 Intent 具有 content: 或 file: URI 且过滤器未指定 URI，则 Intent 会通过测试的 URI 部分。换而言之，如果过滤器仅列出 MIME 类型，则假定组件支持 content: 和 file: 数据。

最后一条规则，即规则 (d)，反映了期望组件能够从文件中或内容提供商处获得本地数据。因此，其过滤器可以仅列出数据类型，而不必显式命名content: 和 file: 架构。这是一个典型的案例。例如，下文中的 [ ](https://developer.android.com/guide/topics/manifest/data-element.html)元素向 Android 指出，组件可从内容提供商处获得并显示图像数据：

```
<intent-filter>   
   <data android:mimeType="image/*" />   
    ...
</intent-filter>
```

由于大部分可用数据均由内容提供商分发，因此指定数据类型（而非 URI）的过滤器也许最为常见。
另一常见的配置是具有架构和数据类型的过滤器。例如，下文中的 [ ](https://developer.android.com/guide/topics/manifest/data-element.html)元素向 Android 指出，组件可从网络中检索视频数据以执行操作：

```
<intent-filter>   
   <data android:scheme="http" android:type="video/*" />   
    ...
</intent-filter>
```

### 5.4、Intent 匹配

通过 Intent 过滤器匹配 Intent，这不仅有助于发现要激活的目标组件，还有助于发现设备上组件集的相关信息。例如，主页应用通过使用指定[ACTION_MAIN](https://developer.android.com/reference/android/content/Intent.html#ACTION_MAIN) 操作和 [CATEGORY_LAUNCHER](https://developer.android.com/reference/android/content/Intent.html#CATEGORY_LAUNCHER) 类别的 Intent 过滤器查找所有 Activity，以此填充应用启动器。

您的应用可以采用类似的方式使用 Intent 匹配。[PackageManager](https://developer.android.com/reference/android/content/pm/PackageManager.html) 提供了一整套 query...() 方法来返回所有能够接受特定 Intent 的组件。此外，它还提供了一系列类似的 resolve...() 方法来确定响应 Intent 的最佳组件。例如，[queryIntentActivities()](https://developer.android.com/reference/android/content/pm/PackageManager.html#queryIntentActivities(android.content.Intent,%20int))
将返回能够执行那些作为参数传递的 Intent 的所有 Activity 列表，而 [queryIntentServices()](https://developer.android.com/reference/android/content/pm/PackageManager.html#queryIntentServices(android.content.Intent,%20int)) 则可返回类似的服务列表。这两种方法均不会激活组件，而只是列出能够响应的组件。对于广播接收器，有一种类似的方法： [queryBroadcastReceivers()](https://developer.android.com/reference/android/content/pm/PackageManager.html#queryBroadcastReceivers(android.content.Intent,%20int))。



# 常用的Intent Flag

1. ### FLAG_ACTIVITY_NEW_TASK

   > 文档摘录: When using this flag, if a task is already running for the activity you are now starting, then a new activity will not be started; instead, the current task will simply be brought to the front of the screen with the state it was last in. See FLAG_ACTIVITY_MULTIPLE_TASK for a flag to disable this behavior.`当使用这个flag时,如果task中已经有了你要启动的activity的话,就不再启动一个新的activity了,当前**task**会被带到前台(不管这个activity是否在前台,有可能activity上边还压有别的activity).如果不想要这种行为,可以用FLAG_ACTIVITY_MULTIPLE_TASK.
   >
   > 比如说原来栈中情况是`A,B,C`,在`C`中启动`D`，如果在Manifest.xml文件中给`D`添加了Affinity的值和`C`所在的Task中的不一样的话，则会在新标记的Affinity所存在的Task中看是否这个activity已经启动,如果没启动,则直接将activity启动.如果启动了,直接将`D`所在的task带入到前台;如果是默认的或者指定的Affinity和Task一样的话，就和标准模式一样了启动一个新的Activity.

2. ### FLAG_ACTIVITY_CLEAR_WHEN_TASK_RESET | FLAG_ACTIVITY_NEW_DOCUMENT (API21)

   > FLAG_ACTIVITY_CLEAR_WHEN_TASK_RESET在API 21的时候,被FLAG_ACTIVITY_NEW_DOCUMENT代替
   > 如果一个Intent中包含此属性，则它转向的那个Activity以及在那个Activity其上的所有Activity都会在task重置时被清除出task。当我们将一个后台的task重新回到前台时，系统会在特定情况下为这个动作附带一个FLAG_ACTIVITY_RESET_TASK_IF_NEEDED标记，意味着必要时重置task，这时FLAG_ACTIVITY_CLEAR_WHEN_TASK_RESET就会生效。经过测试发现，对于一个处于后台的应用，如果在launcher中点击应用，这个动作中含有FLAG_ACTIVITY_RESET_TASK_IF_NEEDED标记，长按Home键，然后点击最近记录，这个动作不含FLAG_ACTIVITY_RESET_TASK_IF_NEEDED标记,所以前者会清除，后者不会.
   > 应用场景:
   > 比如我们在应用主界面要选择一个图片，然后我们启动了图片浏览界面，但是把这个应用从后台恢复到前台时，为了避免让用户感到困惑，我们希望用户仍然看到主界面，而不是图片浏览界面，这个时候我们就要在转到图片浏览界面时的Intent中加入此标记

   5.0之前,Activity1用该flag启动Activity2在OverviewScreen中是没有分开的.也就是说如果back到后台后,再通过launcher中点击app的icon进入,将直接进入Activity1,并且无法回到activity2的界面.
   5.0之后,OverviewScreen中,会将两个activity分开.可以返回指定想要的activity.


1. ### FLAG_ACTIVITY_MULTIPLE_TASK

   > 不建议使用此标记，除非你自己实现了应用程序的启动器。结合FLAG_ACTIVITY_NEW_TASK这个标记，即使要启动的activity已经存在一个task在运行，也会新启动一个task来运行要启动的activity
   > 系统缺省是不带任务管理器的，所以当你使用这个标签的时候，你必须确保你能从你启动的task中返回回来。
   > 如果没有设置FLAG_ACTIVITY_NEW_TASK，这个标记被忽略

2. ### FLAG_ACTIVITY_CLEAR_TASK

   > 文档原文:`If set in an Intent passed to Context.startActivity(), this flag will cause any existing task that would be associated with the activity to be cleared before the activity is started. That is, the activity becomes the new root of an otherwise empty task, and any old activities are finished. This can only be used in conjunction with FLAG_ACTIVITY_NEW_TASK.`
   > 个人翻译:`这个flag会导致,在这个activity启动之前,任何与该activity相关的task都会被清除.也就是说,这个activity将会是一个空task的最底部的activity,之前所有的activity都会被finish掉.这个flag只能和FLAG_ACTIVITY_NEW_TASK结合使用.`
   > 比如说原来栈中情况是`A,B,C,D`,在D中启动B(加入该flag),中间过程是`A,B,C`依次destory,D先onPause,随后BonCreate,onStart,onResume.D再onStop,onDestory.最后只有一个B在栈底.(无论taskAffinity..?)

3. ### FLAG_ACTIVITY_SINGLE_TOP

   > 相当于launchMode中的singleTop，比如说原来栈中情况是`A,B,C,D`,在D中启动D(加入该flag)，栈中的情况还是`A,B,C,D`.

4. ### FLAG_ACTIVITY_CLEAR_TOP

   > 不同于launchMode中的singleTask,比如说原来栈中情况是`A,B,C,D`,在D中启动B(加入该flag), 栈中的情况将为`A,B`.但是B会重新onCreate()...,并没有执行onNewIntent().如果希望与singleTask效果相同,可以加入`FLAG_ACTIVITY_SINGLE_TOP`.

5. ### FLAG_ACTIVITY_REORDER_TO_FRONT

   > 这个跟上边FLAG_ACTIVITY_BROUGHT_TO_FRONT的是容易混淆的.比如说原来栈中情况是`A,B,C,D`,在D中启动B(加入该flag)，栈中的情况会是`A,C,D,B`.(调用onNewIntent())

6. ### FLAG_ACTIVITY_BROUGHT_TO_FRONT

   > 这个是最容易让人误解的flag了.跟FLAG_ACTIVITY_REORDER_TO_FRONT是不一样的.不是由我们一般开发者使用的flag.
   > 文档中解释:This flag is not normally set by application code, but set for you by the system as described in the launchMode documentation for the singleTask mode.

7. ### FLAG_ACTIVITY_NO_HISTORY

   > A启动B(加入该Flag),B启动C.在C返回,将直接返回到A.B在A正常onResume后,才会调用`onStop,onDestory...`
   > 而且被这个flag启动的activity,它的onActivityResult()永远不会被调用

8. ### FLAG_ACTIVITY_EXCLUDE_FROM_RECENTS

   > 我所理解的,加了这个flag启动的activity所在的task(必须是该task中最底部的activity)将不会在多任务界面出现.一般配合FLAG_ACTIVITY_NEW_TASK使用,这样新的任务栈,在最近使用列表中,就不会出现.

9. ### FLAG_ACTIVITY_FORWARD_RESULT

   > 多个Activity的值传递。A通过startActivityForResult启动B,B启动C，但B为过渡页可以finish了，A在期望C把结果返回.这种情况,B可以在启动C的时候加入该flag.

10. ### FLAG_ACTIVITY_NO_USER_ACTION

   > 禁止activity调用onUserLeaveHint()。
   > onUserLeaveHint()作为activity周期的一部分，它在activity因为用户要跳转到别的activity而退到background时使用。比如，在用户按下Home键（用户的操作），它将被调用。比如有电话进来（不属于用户的操作），它就不会被调用。注意：通过调用finish()时该activity销毁时不会调用该函数。

11.  ### FLAG_ACTIVITY_RETAIN_IN_RECENTS (API21)

   > 与activity设置autoRemoveFromRecents = false属性效果一样.是指当前activity销毁后,是否还在概览屏幕中显示.(5.0之后生效)

12.  ### FLAG_ACTIVITY_RESET_TASK_IF_NEEDED

   > 一般为系统使用,比如要把一个应用从后台移到前台,有两种方式:从多任务列表中恢复(不包含该flag);从启动器中点击icon恢复(包含该flag);需结合`FLAG_ACTIVITY_CLEAR_WHEN_TASK_RESET | FLAG_ACTIVITY_NEW_DOCUMENT (API21)`理解

13.  ### FLAG_ACTIVITY_PREVIOUS_IS_TOP

   > 即 A---> B --->C，若B启动C时用了这个标志位，那在启动时B并不会被当作栈顶的Activity，而是用A做栈顶来启动C。此过程中B充当一个跳转页面。
   > 典型的场景是在应用选择页面，如果在文本中点击一个网址要跳转到浏览器，而系统中又装了不止一个浏览器应用，此时会弹出应用选择页面。在应用选择页面选择某一款浏览器启动时，就会用到这个Flag。然后应用选择页面将自己finish，以保证从浏览器返回时不会在回到选择页面。
   > `经常与FLAG_ACTIVITY_FORWARD_RESULT 一起使用。`

14.  ### FLAG_ACTIVITY_TASK_ON_HOME

   > 该flag启动的activity,点击返回键会回到launcher.需要与`FLAG_ACTIVITY_NEW_TASK`一起使用,并且`FLAG_ACTIVITY_NEW_TASK`模式生效(参考该属性)后,该flag才会起作用.

15.  ### FLAG_EXCLUDE_STOPPED_PACKAGES

   > 设置之后，Intent就不会再匹配那些当前被停止的包里的组件。如果没有设置，默认的匹配行为会包含这些被停止的包。

16.  ### FLAG_DEBUG_LOG_RESOLUTION

   > debug模式可以打印log



接着看一下startactivity时可以设置的flag有哪些：

**FLAG_ACTIVITY_BROUGHT_TO_FRONT**
这个标志一般不是由程序代码设置的，如在launchMode中设置singleTask模式时系统帮你设定。

**FLAG_ACTIVITY_SINGLE_TOP**如果设置，当这个Activity位于历史stack的顶端运行时，不再启动一个新的。

**FLAG_ACTIVITY_NEW_TASK**如果设置，这个Activity会成为历史stack中一个新Task的开始。一个Task（从启动它的Activity到下一个Task中的 Activity）定义了用户可以迁移的Activity原子组。Task可以移动到前台和后台；在某个特定Task中的所有Activity总是保持相同的次序。

这个标志一般用于呈现“启动”类型的行为：它们提供用户一系列可以单独完成的事情，与启动它们的Activity完全无关。

使用这个标志，如果正在启动的Activity的Task已经在运行的话，那么，新的Activity将不会启动；代替的，当前Task会简单的移入前台。参考FLAG_ACTIVITY_MULTIPLE_TASK标志，可以禁用这一行为

这个标志不能用于调用方对已经启动的Activity请求结果。

**FLAG_ACTIVITY_CLEAR_TOP（top的意思是指盖在该activity上面，比他迟创建启动的）**
如果设置，并且这个Activity已经在当前的Task中运行，因此，不再是重新启动一个这个Activity的实例，而是在这个Activity上方的所有Activity都将关闭，然后这个Intent会作为一个新的Intent投递到老的Activity（现在位于顶端）中。

例如，假设一个Task中包含这些Activity：A，B，C，D。如果D调用了startActivity()，并且包含一个指向Activity B的Intent，那么，C和D都将结束，然后B接收到这个Intent，因此，目前stack的状况是：A，B。

上例中正在运行的Activity B既可以在onNewIntent()中接收到这个新的Intent，也可以把自己关闭然后重新启动来接收这个Intent。如果它的启动模式声明为 “multiple”(默认值)，并且你没有在这个Intent中设置FLAG_ACTIVITY_SINGLE_TOP标志，那么它将关闭然后重新创建；对于其它的启动模式，或者在这个Intent中设置FLAG_ACTIVITY_SINGLE_TOP标志，都将把这个Intent投递到当前这个实例的onNewIntent()中。

这个启动模式还可以与FLAG_ACTIVITY_NEW_TASK结合起来使用：用于启动一个Task中的根Activity，它会把那个Task中任何运行的实例带入前台，然后清除它直到根Activity。这非常有用，例如，当从Notification Manager处启动一个Activity。

**FLAG_ACTIVITY_CLEAR_WHEN_TASK_RESET**如果设置，这将在Task的Activity stack中设置一个还原点，当Task恢复时，需要清理Activity。也就是说，下一次Task带着 FLAG_ACTIVITY_RESET_TASK_IF_NEEDED标记进入前台时（典型的操作是用户在主画面重启它），这个Activity和它之上的都将关闭，以至于用户不能再返回到它们，但是可以回到之前的Activity。

这在你的程序有分割点的时候很有用。例如，一个e-mail应用程序可能有一个操作是查看一个附件，需要启动图片浏览Activity来显示。这个 Activity应该作为e-mail应用程序Task的一部分，因为这是用户在这个Task中触发的操作。然而，当用户离开这个Task，然后从主画面选择e-mail app，我们可能希望回到查看的会话中，但不是查看图片附件，因为这让人困惑。通过在启动图片浏览时设定这个标志，浏览及其它启动的Activity在下次用户返回到mail程序时都将全部清除。

**FLAG_ACTIVITY_EXCLUDE_FROM_RECENTS**
如果设置，新的Activity不会在最近启动的Activity的列表中保存。

**FLAG_ACTIVITY_FORWARD_RESULT**
如果设置，并且这个Intent用于从一个存在的Activity启动一个新的Activity，那么，这个作为答复目标的Activity将会传到这个新的Activity中。这种方式下，新的Activity可以调用setResult(int)，并且这个结果值将发送给那个作为答复目标的 Activity。

**FLAG_ACTIVITY_LAUNCHED_FROM_HISTORY**
这个标志一般不由应用程序代码设置，如果这个Activity是从历史记录里启动的（常按HOME键），那么，系统会帮你设定。

**FLAG_ACTIVITY_MULTIPLE_TASK**
不要使用这个标志，除非你自己实现了应用程序启动器。与FLAG_ACTIVITY_NEW_TASK结合起来使用，可以禁用把已存的Task送入前台的行为。当设置时，新的Task总是会启动来处理Intent，而不管这是是否已经有一个Task可以处理相同的事情。

由于默认的系统不包含图形Task管理功能，因此，你不应该使用这个标志，除非你提供给用户一种方式可以返回到已经启动的Task。

如果FLAG_ACTIVITY_NEW_TASK标志没有设置，这个标志被忽略。

**FLAG_ACTIVITY_NO_ANIMATION**如果在Intent中设置，并传递给Context.startActivity()的话，这个标志将阻止系统进入下一个Activity时应用 Acitivity迁移动画。这并不意味着动画将永不运行——如果另一个Activity在启动显示之前，没有指定这个标志，那么，动画将被应用。这个标志可以很好的用于执行一连串的操作，而动画被看作是更高一级的事件的驱动。

**FLAG_ACTIVITY_NO_HISTORY**如果设置，新的Activity将不再历史stack中保留。用户一离开它，这个Activity就关闭了。这也可以通过设置noHistory特性。

FLAG_ACTIVITY_NO_USER_ACTION

如果设置，作为新启动的Activity进入前台时，这个标志将在Activity暂停之前阻止从最前方的Activity回调的onUserLeaveHint()。

典型的，一个Activity可以依赖这个回调指明显式的用户动作引起的Activity移出后台。这个回调在Activity的生命周期中标记一个合适的点，并关闭一些Notification。

如果一个Activity通过非用户驱动的事件，如来电或闹钟，启动的，这个标志也应该传递给Context.startActivity，保证暂停的Activity不认为用户已经知晓其Notification。

**FLAG_ACTIVITY_REORDER_TO_FRONT**如果在Intent中设置，并传递给Context.startActivity()，这个标志将引发已经运行的Activity移动到历史stack的顶端。

例如，假设一个Task由四个Activity组成：A,B,C,D。如果D调用startActivity()来启动Activity B，那么，B会移动到历史stack的顶端，现在的次序变成A,C,D,B。如果FLAG_ACTIVITY_CLEAR_TOP标志也设置的话，那么这个标志将被忽略。

**FLAG_ACTIVITY_PREVIOUS_IS_TOP**If set and this intent is being used to launch a new activity from an existing one, the current activity will not be counted as the top activity for deciding whether the new intent should be delivered to the top instead of starting a new one. The previous activity will be used as the top, with the assumption being that the current activity will finish itself immediately.

**FLAG_ACTIVITY_RESET_TASK_IF_NEEDED**If set, and this activity is either being started in a new task or bringing to the top an existing task, then it will be launched as the front door of the task. This will result in the application of any affinities needed to have that task in the proper state (either moving activities to or from it), or simply resetting that task to its initial state if needed.