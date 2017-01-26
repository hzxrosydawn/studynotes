[TOC]

## **tools属性**

Android Studio支持tools命名空间下的多种XML属性，这些属性可以用来使用设计时的特性（如在一个布局中显示一个fragment）或编译时的行为（如在收缩模式下使用XML资源）。当编译应用时，编译工具会移除这些属性，所以APK大小和实际运行行为没有影响。

通过将ools命名空间添加到每个XML文件的根元素中来使用这些属性：

```xml
<RootTag xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools" >
```

#### **用于错误处理的属性**

下列属性可用于抑制Lint的警告信息。

##### **tools:ignore**

该属性可通过Lint用于任意元素。该属性可用来忽略某个元素或其子元素的多个问题ID，通过包含一个逗号分隔符来分隔多个问题ID。

例如，可以通过该属性来忽略MissingTranslation错误：

```xml
<string name="show_all_apps" tools:ignore="MissingTranslation">All</string>
```

##### **tools:targetApi**

该属性可通过Lint用于任意元素。该属性与Java代码中的[@TargetApi](https://developer.android.com/reference/android/annotation/TargetApi.html)注解功能相同。可以用来指定一个API等级（可以是一个整型值或API等级的代码名称）来支持该元素，该元素仅在该指定的API等级或更高等级中才可使用。这样可以在该元素或其属性在指定的miniSDK上不可用时阻止Lint发出警告。

例如，由于GridLayout仅在API 14或更高的等级中才可用，但你确信GridLayout不在低于API 14的等级中运行，就可以这样使用该属性：

```xml
<GridLayout xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools"
    tools:targetApi="14" >
```

其实，应该通过GridLayout的[support library](https://developer.android.com/reference/android/support/v7/widget/GridLayout.html)来在低于API 14的等级中使用GridLayout。

##### **tools:locale**

该属性可通过Lint工具，Android Studio编辑器用于&lt;resource>元素。该属性用来指定在给定&lt;resource>元素中的资源所用的默认语言或本地语言（否则编译工具就默认为English），这样就可以避免拼写检查器发出的警告。该属性值必须是一个可用的[本地语言限定符](https://developer.android.com/guide/topics/resources/providing-resources.html#LocaleQualifier)。

例如，可以将该属性添加到values/strings.xml文件中：

```xml
<resources xmlns:tools="http://schemas.android.com/tools"
    tools:locale="zh">
```

上面的定义表示默认字符串资源默认使用中文而不是英文。

#### **设计时的View属性**

下面的属性定义了仅在Android Studio布局预览中可见的布局特性。

##### **tools: 替换 android:**

可以通过在&lt;View>属性中使用"tools:"前缀替代"android:"前缀在布局预览中插入简单数据。如果在运行之前，一个属性值还未被填充，但是你又想在布局预览中提前看到该属性值填充后的效果，就可以使用这种用法。

例如，如果android:text属性是在运行时设置的，或者你想在布局中看到与该属性默认值不同的值，就可以使用tools:text来指定仅在布局预览中可见的文本：

<img src="https://developer.android.com/studio/images/write/tools-attribute-text_2x.png" width=800 />

你也可以同时使用android:命名空间属性（运行时使用）和tools:属性（重写前面对应的android:命名空间属性来仅在布局预览中有效）。你也可以通过tools:属性来仅取消某一属性预览效果。例如，如果你的FrameLayout中有多个子VIew，但是你仅想在布局预览时显示某些子View，那么就可以将其他子View设置为在预览时不可见的：

```xml
<Button
    android:id="@+id/button"
    android:layout_width="wrap_content"
    android:layout_height="wrap_content"
    android:text="First" />

<Button
    android:id="@+id/button2"
    android:layout_width="wrap_content"
    android:layout_height="wrap_content"
    android:text="Second"
    tools:visibility="invisible"  />
```

在使用[Layout Editor](https://developer.android.com/studio/write/layout-editor.html)（布局编辑器）设计View时，**Properties**窗口也允许你笔记设计时属性。每个设计时属性可通过属性名旁边的扳手图标<img src="https://developer.android.com/studio/images/buttons/layout-tools-attr.png" width=14/>来与同名的实际属性加以区别。

##### **tools:context**

该属性通过Lint，Android Studio布局编辑器来应用于任何根&lt;View>元素。该属性声明该布局文件默认相关连的Activity，这样就可以使用编辑器或布局预览中包含指定Activity信息的特性，如布局预览中应该使用什么布局主题，在哪里快速插入onClick处理方法：

<img src="https://developer.android.com/studio/images/write/tools-attribute-context_2x.png" width=400/>

上图中的onClick的快速设置仅当在根View中设置了tools:context时才会有效

你可以通过像在清单文件中使用点前缀一样为tools:context属性指定Activity的类名，例如：

```xml
<android.support.constraint.ConstraintLayout
    xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools"
    tools:context=".MainActivity" >
```

你也可以在[Layout Editor toolbar](https://developer.android.com/studio/write/layout-editor.html#change-appearance)（布局编辑器工具栏）选择布局预览的主题。

##### **tools:layout**

该属性可通过Android Studio布局编辑器应用于&lt;ment>元素。该属性声明了你想让布局预览绘制fragment中的哪一个布局（因为布局预览不能使用正常应用布局的Activity代码）。例如：

```xml
<fragment android:name="com.example.master.ItemListFragment"
    tools:layout="@layout/list_content" />
```

##### **tools:listitem / tools:listheader / tools:listfooter**

该属性通过Android Studio布局编辑器来应用于&lt;AdapterView>元素的具体子类元素。这些属性指定了在布局预览中显示列表中的列表项、header和footer所用的哪一个布局。布局中的任何数据字段都填入数值内容，如“Item 1”，所以列表项是不重复的。例如：

```xml
<ListView xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools"
    android:id="@android:id/list"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    tools:listitem="@layout/sample_list_item"
    tools:listheader="@layout/sample_list_header"
    tools:listitem="@layout/sample_list_footer" />
```

这些属性在Android Studio 2.2版本中无法用于ListView，但是在2.3版本中修复了。

##### **tools:showIn**

该属性通过Android Studio布局管理器来应用于一个布局中的任何根&lt;View>元素，该布局通过&lt;include>标签来引用。

该属性允许你指向一个通过使用&lt;include>标签引入的布局，这样该布局就好像被嵌入父布局中一样，你就可以预览和编辑它了。例如：

```xml
<TextView xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools"
    android:text="@string/hello_world"
    android:layout_width="wrap_content"
    android:layout_height="wrap_content"
    tools:showIn="@layout/activity_main" />
```

现在布局预览就会将上面的TextView布局（该布局使用&lt;include>标签在其父布局中引入它）显示在activity_main布局中了。

##### **tools:menu**

该属性通过Android Studio布局管理器来应用于任何根&lt;View>元素。该属性指定了哪一个菜单显示在布局预览的[app bar](https://developer.android.com/training/appbar/index.html)（应用栏）中。该属性值可以是一个或多个菜单项的Id（多个Id通过英文逗号分隔，这些Id没有"@menu/"或者这样的Id前缀，也没有.xml扩展名）。例如：

```xml
<?xml version="1.0" encoding="utf-8"?>
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools"
    android:orientation="vertical"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    tools:menu="menu1,menu2" />
```

### **压缩资源（resource shrinking）属性**

下列属性允许你在使用 [resource shrinking](https://developer.android.com/studio/build/shrink-code.html#shrink-resources)（压缩资源时）允许你使用严格的引用检查且声明保留还是弃用某些资源。通过在 build.gradle文件中设置shrinkResources属性（在用于代码压缩的minifyEnabled属性边）为true来使用压缩资源。例如：

```gradle
android {
    ...
    buildTypes {
        release {
            shrinkResources true
            minifyEnabled true
            proguardFiles getDefaultProguardFile('proguard-android.txt'),
                    'proguard-rules.pro'
        }
    }
}
```

##### **tools:shrinkMode**

该属性通过使用压缩资源的编译工具应用于&lt;resources>元素。该属性允许你指定编译工具是使用"safe mode"（安全模式，安全运行并保证所有资源都是显示引用的，且可能通过一个[Resources.getIdentifier()](https://developer.android.com/reference/android/content/res/Resources.html#getIdentifier(java.lang.String, java.lang.String, java.lang.String)调用来动态引用）还是"strict mode"（严格模式，保证仅在代码或其他资源中的资源时显式引用的）。

默认使用安全模式（shrinkMode="safe"），将shrinkMode="strict"添加到到&lt;resource>标签中，就像这样：

```xml
<?xml version="1.0" encoding="utf-8"?>
<resources xmlns:tools="http://schemas.android.com/tools"
    tools:shrinkMode="strict" />
```

当你使用严格模式时，你可能需要使用tools:keep来保证资源是移除的，也是你想移除的，使用tools:discard属性来显式移除更多资源。

##### **tools:keep**

该属性通过使用压缩资源的编译工具应用于&lt;resources>元素。当使用压缩资源来移除未使用的资源时，该属性允许你指定保留的资源（这些资源会在运行时以一种间接方式来引用，如将一个动态生成的资源名传递给Resources.getIdentifier()）。

为了使用该功能，在你的资源目录下创建一个含有&lt;resource>标签的XML文件（例如res/raw/keep.xml），并在tools:keep属性中以一个逗号分隔列表的形式来指定每个需要保留的资源。你可以使用一个星号作为通配符，例如：

```xml
<?xml version="1.0" encoding="utf-8"?>
<resources xmlns:tools="http://schemas.android.com/tools"
    tools:keep="@layout/used_1,@layout/used_2,@layout/*_3" />
```

##### **tools:discard**

该属性通过使用压缩资源的编译工具应用于&lt;resources>元素。当使用压缩资源来移除未使用的资源时，该属性允许你指定手动丢弃的资源（这些资源的引用方式不影响你的应用，或Gradle插件不正确地演绎了资源的引用）。

为了使用该功能，在你的资源目录下创建一个含有&lt;resource>标签的XML文件（例如res/raw/keep.xml），并在tools:discard属性中以一个逗号分隔列表的形式来指定每个需要保留的资源。你可以使用一个星号作为通配符，例如：

```xml
<?xml version="1.0" encoding="utf-8"?>
<resources xmlns:tools="http://schemas.android.com/tools"
    tools:discard="@layout/unused_1" />
```



```