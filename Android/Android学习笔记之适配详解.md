### **支持多种屏幕**

[Platform Versions](http://developer.android.com/about/dashboards/index.html)的控制面板会定时更新，通过统计访问Google Play Store的设备数量，来显示运行每个版本的不同尺寸密度安卓设备的分布。

虽然从 Android 1.6（API 级别 4）开始，Android系统为使应用适用于不同的屏幕，会进行缩放和大小调整，但仍应针对不同的屏幕尺寸和密度优化应用，这样可以最大程度优化所有设备上的用户体验。

#### **术语和概念**

**屏幕尺寸**：指的是屏幕对角线的实际测量尺寸，一般以英寸（inch,1英寸=2.54厘米）为单位。平时所说的5.5寸大屏即是指该手机屏幕对角线长度为5.5英寸。Android 将所有实际屏幕尺寸分组为四种通用尺寸：

- small：适用于小尺寸屏幕的资源。
- normal：适用于正常尺寸屏幕的资源。（这是基线尺寸。）
- large：适用于大尺寸屏幕的资源。
- xlarge：适用于超大尺寸屏幕的资源。

**像素**：单位px（pixel），指屏幕上显式颜色的一个物理点，一般都是正方形。

**屏幕像素密度**：即dpi（dot per inch，点数/英寸），和ppi（pixel per inch）是一个意思，屏幕单位长度上的像素数量。一般情况下，ppi表示显示设备的点密度，dpi表示印刷品点密度，Android应该是误用了dpi这个概念。

![这里写图片描述](http://img.blog.csdn.net/20170105184613175?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvcm9zeV9kYXdu/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

dpi越高屏幕越清晰。Android 将所有屏幕密度分组为六种通用密度： 

- ldpi（低）~120dpi
- mdpi（中）~160dpi
- hdpi（高）~240dpi
- xhdpi（超高）~320dpi
- xxhdpi（超超高）~480dpi
- xxxhdpi（超超超高）~640dpi

![这里写图片描述](http://img.blog.csdn.net/20170105183954436?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvcm9zeV9kYXdu/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

**方向**：从用户视角看屏幕的方向，分别表示屏幕的纵横比是宽还是高。即横屏（landscape）还是竖屏（portrait）。请注意，不仅不同的设备默认以不同的方向操作，而且方向在运行时可随着用户旋转设备而改变。

**分辨率**：指在横纵向上的像素点数，单位是px（pixel），1px=1像素点，一般是纵向像素横向像素，如1920X1080表示横向和纵向上分别有1920、1080个像素点。添加对多种屏幕的支持时，应用不会直接使用分辨率；而只应关注通用尺寸和密度组指定的屏幕尺寸及密度。

**密度无关的像素**：即Density Independent Pixels（单位为dip或dp)。用于以屏幕密度无关方式表示布局维度或位置。在运行时，系统根据使用中屏幕的实际密度按需要以透明方式处理dp单位的任何缩放，从而实现固定的dp数在不同设备上总能显示固定的物理长度。1dp=1/160英寸=0.15875mm。密度无关像素等于160 dpi屏幕上的一个物理像素，这是系统为“中”密度屏幕假设的基线密度。dp单位转换为屏幕像素很简单：px=dp\*(dpi/160)。例如，在320dpi屏幕上，显示10dp宽度的图片需要占用10\*(320/160)=20个物理像素,而在160dpi的屏幕上，显示10dp宽度的图片需要占用10\*(160/160)=10个物理像素。在定义应用的UI时应始终以dp为长度单位 ，以确保在不同密度的屏幕上显示相同长度的UI尺寸。

- 超大屏幕至少为 960dp x 720dp
- 大屏幕至少为 640dp x 480dp
- 正常屏幕至少为 470dp x 320dp
- 小屏幕至少为 426dp x 320dp

**缩放无关的像素**：Scale-Independent Pixels（单位为sp），缩放系数取决于用户设置，系统会像处理 dp 一样缩放大小。Google推荐我们使用12sp以上的大小，通常可以使用12sp，14sp，18sp，22sp，最好不要使用奇数和小数。

常见的屏幕介绍：

- VGA：Video Graphics Array，即：显示绘图矩阵，相当于640×480 像素；
- QVGA：Quarter VGA，即VGA的四分之一，分辨率为320×240，一般用于小屏手机 像三星盖世Mini S5570就是使用这分辨率； 
- WVGA：Wide Video Graphics Array，即：扩大的VGA，分辨率为800×480像素，像三星i9000就是使用这分辨率；
- WQVGA：Wide Quarter VGA，即扩大的QVGA，分辨率比QVGA高，比VGA低，一般是：400×240，480×272； 
- HVGA：Half-size VGA，即VGA的一半，分辨率为480×320或640×240，像三星盖世Ace S5830就是480×320的分辨率； 
- FWVGA：Full Wide VGA ，数码产品屏幕材质的一种，VGA的另一种形式，比WVGA分辨率高，别名 ： Full Wide VGA, ，其分辨 率为854×480象素(16:9)。 
- SVGA：Super Video Graphics Array，属于VGA屏幕的替代品，最大支持800×600分辨率；
- WSVGA：Wide Screen VGA，用于UMPC等小型多媒体终端设备，分辨率为1024×600，是一种介于WVGA（800×480）与WXGA（1280×800或1280×768）之间的折中型宽屏幕，应用的范围不是很广泛，只有索尼的UMPCVGN-UX系列和一些平板电脑上以及流行的Netbook中有所应用；
- XGA：Extended Graphics Array，这是一种目前笔记本普遍采用的一种LCD屏幕，市面上将近有80%的笔记本采用了这种产品。它支持最大1024×768分辨率，屏幕大小从 10.4英寸、12.1英寸、13.3英寸到14.1英寸、15.1英寸都有；
- WXGA：Wide Extended Graphics Array，作为普通XGA屏幕的宽屏版本，WXGA采用16:10的横宽比例来扩大屏幕的尺寸。其最大显示分辨率为1280×800。由于其水平像素只 有800，所以除了一般15英寸的本本之外，也有12.1英寸的本本采用了这种类型的屏幕；
- SXGA：Super Extended Graphics Array，分辨率为1280×1024，这是一个既成事实显示标准，每个像素用32比特表示（真彩色）。纵横比是5:4；
- WXGA+：Wide Extended Graphics Array：这是一种WXGA的的扩展，其最大显示分辨率为1280×854。由于其横宽比例为15:10而非标准宽屏的16:10。所以只有少部分屏幕尺寸在15.2英寸的本本采用这种产品；
- SXGA+：Super Extended Graphics Array，作为SXGA的一种扩展SXGA+是一种专门为笔记本设计的屏幕。其显示分辨率为1400×1050。由于笔记本LCD屏幕的水平与垂直点距 不同于普通桌面LCD，所以其显示的精度要比普通17英寸的桌面LCD高出不少；
- WSXGA+：(Wide Super Extended Graphics Array)：其显示分辨率为1680×1050，除了大多数15英寸以上的宽屏笔记本以外，目前较为流行的大尺寸LCD-TV也都采用了这种类型的产品；
- UVGA：Ultra Video Graphics Array：这种屏幕应用在15英寸的屏幕的本本上，支持最大1600×1200分辨率。由于对制造工艺要求较高所以价格也是比较昂贵。目前只有少部分高端的移动工作站配备了这一类型的屏幕；
- WUXGA：(Wide Ultra Video Graphics Array)：和4:3规格中的UXGA一样，WUXGA屏幕是非常少见的，其显示分辨率可以达到1920×1200。由于售价实在是太高所以鲜有笔记本厂商采用这种屏幕；

常见屏幕的分辨率简表：

| 标屏    | 分辨率       | 宽屏     | 分辨率                        |
| ----- | --------- | ------ | -------------------------- |
| QVGA  | 320×240   | WQVGA  | 400×240                    |
| VGA   | 640×480   | WVGA   | 800×480                    |
| SVGA  | 800×600   | WSVGA  | 1024×600                   |
| XGA   | 1024×768  | WXGA   | 1280×768/1280×800/1366×768 |
| SXGA  | 1280×1024 | WXGA+  | 1440×900                   |
| SXGA+ | 1400×1050 | WSXGA+ | 1680×1050                  |
| UXGA  | 1600×1200 | WUXGA  | 1920×1200                  |
| QXGA  | 2048×1536 | WQXGA  | 2560×1536                  |

![这里写图片描述](http://img.blog.csdn.net/20170106131014834?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvcm9zeV9kYXdu/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

#### **使用密度无关像素**

使用绝对像素来定义距离或尺寸会带来问题，因为不同的屏幕具有不同的像素密度，因此同样数量的像素在不同设备上可能对应于不同的物理尺寸。推荐使用dp、sp分别作为UI组件尺寸、文字大小的单位。

#### **在清单文件中显式声明应用支持哪些屏幕尺寸**

通过在清单文件中包含&lt;supports-screens>元素来声明该应用支持哪些屏幕尺寸（还可以用于开启屏幕兼容模式），可确保只有其屏幕受支持的设备才能下载该应用。
&lt;supports-screens>元素的语法：
```xml
<supports-screens android:resizeable=["true"| "false"]
                  android:smallScreens=["true" | "false"]
                  android:normalScreens=["true" | "false"]
                  android:largeScreens=["true" | "false"]
                  android:xlargeScreens=["true" | "false"]
                  android:anyDensity=["true" | "false"]
                  android:requiresSmallestWidthDp="integer"
                  android:compatibleWidthLimitDp="integer"
                  android:largestWidthLimitDp="integer"/>
```
Android 3.2 引入了新的属性：android:requiresSmallestWidthDp, android:compatibleWidthLimitDp, and android:largestWidthLimitDp。如果开发基于Android 3.2 或更高版本的应用，应该使用这些属性来声明应用所支持的屏幕尺寸，而不是使用基于一般尺寸大小的旧属性。

属性介绍：

- android:resizeable：表明该应用针对不同屏幕是否可以调整大小。该属性默认为true，如果该成false，则系统在较大屏幕上将以屏幕兼容模式运行应用。该属性已不建议使用，因为它是用来帮助应用在支持多屏幕功能时从Android 1.5 to 过渡Android 1.6的；
- android:smallScreens：表明该应用支持较小的屏幕。一个小屏幕指比正常屏幕（传统的HVGA屏幕）还要小的屏幕。不支持小屏幕的应用在某些应用市场如Google Paly上将不能在小屏幕设备上下载。该属性默认为true；
- android:normalScreens：表明该应用支持正常屏幕。习惯上是一个HVGA的中等密度屏幕，但是WQVGA的低密度屏幕和WVGA的高密度屏幕也被认为是正常屏幕。该属性默认为true；
- android:largeScreens：表明该应用支持大屏幕。一个大屏幕指明显比正常屏幕的手机屏大的屏幕。因此站在应用的角度来充分利用它时，可能需要特别留意，即使它依赖于系统的调整来充满屏幕。默认值根据版本有所不同，最好显式声明其值，设置为false一般会开启屏幕兼容模式；
- android:xlargeScreens：表明该应用支持超大屏幕。一个超大屏幕指明显比大屏幕还要大的屏幕，比如平板（或更大的设备），站在应用的角度来充分利用它时，可能需要特别留意，即使它依赖于系统的调整来充满屏幕。默认值根据版本有所不同，最好显式声明其值，设置为false一般会开启屏幕兼容模式。该属性从API 9开始引入；
- android:anyDensity：表明该应用是否包含适应任意屏幕密度的资源。对于支持Android 1.6 (API 4)和更高版本的应用，该属性默认为true，不应该设置为false，除非你完全确定这样对于你的应用的运行是必要的。应用直接操作位图时才有必要禁用该属性；
- android:requiresSmallestWidthDp：指定所需的最小屏幕宽度。最小屏幕宽度是指应用的UI所需屏幕空间的最小尺寸（以dp为单位，包括宽度和高度），以sw&lt;Dimension value>dp的形式指定（如sw600dp）。为了让一个设备兼容你的应用，该设备的最小屏幕宽度必须大于等于该属性值。（通常，无论屏幕的当前方向如何，此值都是布局支持的“最小宽度”。）例如，一块典型的手机屏的最小屏幕宽度为320dp，一个7英寸的平板的最小屏幕宽度为600dp，一个10英寸平板的最小屏幕宽度为720dp。这些值是常见的最小屏幕宽度值，因为它们是屏幕可用空间的最小尺寸。
  和你的尺寸相比较的尺寸会计入屏幕装饰和系统UI。例如，如果设备显示着一些持久的UI元素，系统声明该设备的最小屏幕宽度比实际屏幕尺寸要小，一些空间被这些UI元素占据了，因为这些屏幕像素对于你的UI是不可用的。因此，你使用的值应该是你的布局所需的最小宽度，不管屏幕的当前方向。
  如果你的应用在较小屏幕（小到小屏幕尺寸或320dp的最小宽度）上可以恰当地调整大小，就不需要使用该属性值。否则，就应该使用最小屏幕限定符sw&lt;N>dp指定一个与应用所需最小值相匹配的属性值。
  注意：Android系统不关注该属性值，所以它不影响应用在运行时的行为。而是用来在应用市场如Google Play上来过滤应用。然而，Google Play目前还不支持基于Android 3.2的该属性的过滤。所以，如果应用不支持小屏幕，应该继续使用其他尺寸属性。该属性自API 13开始引入；
- android:compatibleWidthLimitDp：此属性可让您指定用户支持的最大“最小宽度”，将屏幕兼容性模式用作 用户可选的功能 。如果设备可用屏幕的最小边大于您在这里的值， 用户仍可安装您的应用，但提议在屏幕兼容性模式下运行。默认 情况下，屏幕兼容性模式会停用，并且您的布局照例会调整大小以 适应屏幕，但按钮会显示在系统栏中，可让用户打开和关闭屏幕兼容性 模式。如果应用兼容所有屏幕并且布局可以恰当地调整大小，就没有必要使用此属性。
  注意：目前，屏幕兼容模式仅在320dp宽度的手机屏幕上进行模拟，所以如果你的android:compatibleWidthLimitDp大于320，屏幕兼容模式就不能使用。该属性自API 13开始引入；
- android:largestWidthLimitDp：此属性可让您指定应用支持的最大“最小宽度”来强制启用屏幕兼容性模式。 如果设备可用屏幕的最小 边大于您在这里的值，应用将在屏幕 兼容性模式下运行，且用户无法停用该模式。如果应用兼容所有屏幕并且布局可以恰当地调整大小，就没有必要使用此属性。否则，就应该首先考虑使用android:compatibleWidthLimitDp属性。仅当应用应用在较大屏幕上调整大小失败且屏幕兼容模式是应用唯一的选择时才能使用android:largestWidthLimitDp属性。
  注意：目前，屏幕兼容模式仅在320dp宽度的手机屏幕上进行模拟，所以如果你的android:compatibleWidthLimitDp大于320，屏幕兼容模式就不能使用。该属性自API 13开始引入。

如果所开发应用支持的系统版本低于Android 3.0，而且该应用在较大屏幕上不能恰当地调整其组件大小（调整之后可能出现像素颗粒或者图像模糊的现象），那么需要禁用屏幕兼容模式。

**禁用屏幕兼容模式**

如果你开发的应用程序主要是基于低于Android 3.0版本的,但应用程序在较大屏幕如平板电脑上不能恰当地调整较大小，为了保持最好的用户体验就应该禁用屏幕兼容模式。否则,用户在屏幕兼容模式下的体验就达不到理想状态。默认情况下,在运行Android 3.2或更高版本的设备上，当以下条件之一为true时，屏幕兼容模式作为一个用户可选的特性之一:

-  应用将android:minSdkVersion和android:targetSdkVersion都设置为10或更高，并且没有显式使用&lt;supports-screens>元素声明支持大屏幕；
-  应用将android:minSdkVersion和android:targetSdkVersion之一设置为11或更高，并且显式使用&lt;supports-screens>元素声明支持大屏幕。

完全禁用屏幕兼容模式的用户选项并移除系统栏的图标，可以任选下面一种方法：

- 最简单的：在清单文件中，添加&lt;supports-screens>元素并指定android:xlargeScreens属性为true。
```xml
<supports-screens android:xlargeScreens="true" />
```
这就声明了应用支持所有较大屏幕，所以系统总会调整布局来适应屏幕，不管&lt;uses-sdk>属性设置为何值。

- 简单但有其他效果：在清单文件的&lt;uses-sdk>属性中，设置android:targetSdkVersion为11或更高。
```xml
<uses-sdk android:minSdkVersion="4" android:targetSdkVersion="11" />
```
这声明了应用支持Android 3.0， 因此，可以运行在平板等较大屏幕上。当运行在Android 3.0或更高版本上时，也允许为UI使用Holographic主题、为Activity添加Action Bar和移除系统栏上的选项菜单按钮。

如果改动了以上之后，屏幕兼容模式依然有效，就检查清单文件中的&lt;supports-screens>，确定没有属性设置为false。最好的建议是使用&lt;supports-screens>显式声明支持不同的屏幕。

**开启屏幕兼容模式**

如果应用的基于Android 3.2（API 13）或更高版本，是否通过&lt;supports-screens>元素开启兼容模式在一些屏幕上显示会有所不同。
注意：兼容模式不是应用该运行的模式——因为由于缩放，UI可能会出现像素化或模糊的现象。
默认情况下，将android:minSdkVersion和android:targetSdkVersion之一设置为11或更高不会开启屏幕兼容模式。如果这样设置了，应用在较大屏幕上不能恰当地调整大小，可以使用以下方法之一来开启屏幕兼容模式：

- 在清单文件中添加&lt;supports-screens>元素，指定android:compatibleWidthLimitDp属性为320。
```xml
 <supports-screens android:compatibleWidthLimitDp="320" />
```
这表明指定了该应用的最大的最小屏幕宽度为320dp，任何最短边长于该值的设备都会开启屏幕兼容模式。

- 如果调整大小失败想让用户强制使用兼容模式而不是让用户自己选择，可以使用android:largestWidthLimitDp属性。
```xml
<supports-screens android:largestWidthLimitDp="320" />
```
除了强制开启屏幕兼容模式而不允许更改之外，这和android:compatibleWidthLimitDp作用一样。

#### **在XML布局中使用wrap_content、math_parent、weight**

**wrap_content**：指定子组件恰好包括它的内容即可，即使内容适应该视图所需的最小尺寸；
**math\_parent**：同fill\_parent，从Android 2.2（API 级别 为8）开始推荐使用match\_parent代替fill\_parent。指定子组件的高度和宽度与父组件的高度、宽度相同（实际上还要减去填充的空白距离）；
**weight**：权重，在线性布局中可以使用weight属性设置设置所占的比例。

通过使用 "wrap\_content" 和 "match\_parent" 尺寸值来替代硬编码尺寸，视图将相应地仅使用该视图所需空间，或者通过扩展填满可用空间。
示例：
```xml
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:orientation="vertical"
    android:layout_width="match_parent"
    android:layout_height="match_parent">
    <LinearLayout android:layout_width="match_parent" 
                  android:id="@+id/linearLayout1"  
                  android:gravity="center"
                  android:layout_height="50dp">
        <ImageView android:id="@+id/imageView1" 
                   android:layout_height="wrap_content"
                   android:layout_width="wrap_content"
                   android:src="@drawable/logo"
                   android:paddingRight="30dp"
                   android:layout_gravity="left"
                   android:layout_weight="0" />
        <View android:layout_height="wrap_content" 
              android:id="@+id/view1"
              android:layout_width="wrap_content"
              android:layout_weight="1" />
        <Button android:id="@+id/categorybutton"
                android:background="@drawable/button_bg"
                android:layout_height="match_parent"
                android:layout_weight="0"
                android:layout_width="120dp"
                style="@style/CategoryButtonStyle"/>
    </LinearLayout>

    <fragment android:id="@+id/headlines" 
              android:layout_height="fill_parent"
              android:name="com.example.android.newsreader.HeadlinesFragment"
              android:layout_width="match_parent" />
</LinearLayout>
```
纵向模式（左侧）和横向模式（右侧）的显示为：

![](http://img.blog.csdn.net/20170105193129394?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvcm9zeV9kYXdu/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

#### **使用相对布局，禁用绝对布局**

使用RelativeLayout允许根据组件之间的空间关系指定布局。
```xml
<?xml version="1.0" encoding="utf-8"?>
<RelativeLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="match_parent">
    <TextView
        android:id="@+id/label"
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:text="Type here:"/>
    <EditText
        android:id="@+id/entry"
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:layout_below="@id/label"/>
    <Button
        android:id="@+id/ok"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:layout_below="@id/entry"
        android:layout_alignParentRight="true"
        android:layout_marginLeft="10dp"
        android:text="OK" />
    <Button
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:layout_toLeftOf="@id/ok"
        android:layout_alignTop="@id/ok"
        android:text="Cancel" />
</RelativeLayout>
```
在 QVGA 屏幕上的显示外观：

![这里写图片描述](http://img.blog.csdn.net/20170105192734872?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvcm9zeV9kYXdu/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)
在较大屏幕上的显示外观：

![这里写图片描述](https://developer.android.com/images/training/relativelayout2.png)

#### **使用限定符**

我们的应用不仅应实现灵活布局，还应针对不同的屏幕配置提供多种备选布局。可以利用配置限定符来实现此目的，它允许运行组件根据当前设备配置（如针对不同屏幕尺寸的不同布局设计）自动选择合适的资源。关于限定符的使用请参考Android资源介绍。

#### **使用屏幕密度限定符并提供不同的位图**

只需要为 位图文件（.png、.jpg 或 .gif）和九宫格文件 (.9.png) 提供密度特定的可绘制对象。如果您使用 XML 文件定义形状、颜色或其他可绘制对象资源，应该 将一个副本放在默认可绘制对象目录中 (drawable/)。

如果您的应用只为基线中密度屏幕 (mdpi) 提供位图可绘制对象，则在高密度 屏幕上会增大位图，在低密度屏幕上会缩小位图。这种缩放可能在 位图中造成伪影。为确保位图的最佳显示效果，应针对不同屏幕密度加入不同分辨率的替代版本。
可用于密度特定资源的配置限定符，包括ldpi（低）、mdpi（中）、 hdpi（高）、xhdpi（超高）、xxhdpi （超超高）和 xxxhdpi（超超超高）。例如，高密度屏幕的位图应使用 drawable-hdpi/。

有些设备会将启动器图标增大 25%。例如，如果您的最高密度启动器图标已是超超高密度，缩放处理会降低其 清晰度。因此应在 mipmap-xxxhdpi 目录中提供更高密度的启动器图标，系统将改为增大较小的图标。

仅当要在 xxhdpi 设备上提供比正常位图大的启动器图标时才需要提供 mipmap-xxxhdpi 限定符。无需为所有应用的图像提供 xxxhdpi 资源。将您的所有启动器图标放在 res/mipmap-[density]/ 文件夹中，而非 res/drawable-[density]/ 文件夹中。例如 mipmap-xxxhdpi。此 行为可让启动器应用为您的应用选择要显示在主屏幕上的最佳分辨率图标。

在运行时，系统通过 以下程序确保任何给定资源在当前屏幕上都能保持尽可能最佳的显示效果：

- 系统使用适当的备用资源：根据当前屏幕的尺寸和密度，系统将使用您的应用中提供的任何尺寸和 密度特定资源。例如，如果设备有高密度屏幕，并且应用请求可绘制对象资源，系统将查找 与设备配置最匹配的可绘制对象资源目录。根据可用的其他备用资源，包含hdpi限定符（例如 drawable-hdpi/）的资源目录可能是最佳匹配项，因此系统将使用此目录中的可绘制对象资源。有时您可能不希望 Android 预缩放资源。避免预缩放最简单的方法是将资源放在 有 nodpi 配置限定符的资源目录中。例如：
  res/drawable-nodpi/icon.png
  当系统使用此文件夹中的 icon.png 位图时，不会根据当前设备密度缩放。通常，不应停用预缩放。
- 如果没有匹配的资源，系统将使用默认资源，并按需要向上或向下扩展，以匹配当前的屏幕尺寸和密度：“默认”资源是指未标记配置限定符的资源。例如，drawable/中的资源是默认可绘制资源。 系统假设默认资源设计用于基线屏幕尺寸和密度，即正常屏幕尺寸和中密度。 因此，系统对于高密度屏幕向上扩展默认密度资源，对于低密度屏幕向下扩展。当系统查找密度特定的资源但在 密度特定目录中未找到时，不一定会使用默认资源。系统在缩放时可能改用其他密度特定资源提供更好的 效果。例如，查找低密度资源但该资源不可用时， 系统会缩小资源的高密度版本，因为 系统可轻松以 0.5 为系数将高密度资源缩小至低密度资源，与以 0.75 为系数缩小中密度资源相比，伪影更少。

在设计图标时，对于五种主流的像素密度（MDPI、HDPI、XHDPI、XXHDPI 和 XXXHDPI）应按照 1:1.5:2:3:4 的比例进行缩放。例如，一个启动图标的尺寸为48x48 dp，这表示在 MDPI 的屏幕上其实际尺寸应为 48x48 px，在 HDPI 的屏幕上其实际大小是 MDPI 的 1.5 倍 (72x72 px)，在 XDPI 的屏幕上其实际大小是 MDPI 的 2 倍 (96x96 px)，依此类推。

![这里写图片描述](http://img.blog.csdn.net/20170105190410702?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvcm9zeV9kYXdu/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

#### **使用九宫格位图**

支持不同屏幕尺寸通常意味着您的图像资源也必须能够适应不同的尺寸。如果您在可能改变尺寸的组件上使用简单图像，您很快会发现效果有些差强人意，因为运行组件会均匀地拉伸或缩小您的图像。 解决方案是使用九宫格位图，这种特殊格式的 PNG 文件会**指示哪些区域可以拉伸，哪些区域不可以拉伸**。

因此，在设计将用于尺寸可变组件的位图时，请一律使用九宫格位图。 如需将位图转换为九宫格位图，您可以先从普通图像着手（图1，为了清晰起见，放大 4 倍显示）。

![这里写图片描述](https://developer.android.com/images/training/button.png)

图1.button.png

然后通过双击 SDK 安装目录中tools目录下的draw9patch.bat文件来启动绘制九宫格位图的应用，在该程序中，您可以通过沿左侧和顶部边框绘制像素来标记应拉伸的区域。您还可以通过沿右侧和底部边框绘制像素来标记应容纳内容的区域，结果会得到图2。

![](https://developer.android.com/images/training/button_with_marks.png)

图2.button.9.png

请注意边框沿线的黑色像素。顶部和左侧边框上的黑色像素指示可以拉伸图像的位置，右侧和底部边框上的黑色像素则指示应该放置内容的位置。还请注意 .9.png 扩展。您必须使用此扩展，因为框架就是通过它来检测这是一幅九宫格图像，而不是普通的 PNG 图像。

当您对组件应用此背景时（通过设置 android:background="@drawable/button"），框架会正确拉伸图像来适应按钮的尺寸，如图3中的各种尺寸所示。

![](https://developer.android.com/images/training/buttons_stretched.png)

图3. 一个使用各种尺寸 button.9.png 九宫格图像的按钮。

#### **使用尺寸限定符**

例如，许多应用都针对大屏幕实现了“双窗格”模式（应用可以在一个窗格中显示项目列表，在另一个窗格中显示项目内容）。 平板电脑和TV足够大，可在一个屏幕上同时容纳两个窗格，但手机屏幕只能独立显示它们。 因此，如需实现这些布局，您可以建立以下文件：

- res/layout/main.xml，单窗格（默认）布局：
```xml
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:orientation="vertical"
    android:layout_width="match_parent"
    android:layout_height="match_parent">

    <fragment android:id="@+id/headlines"
              android:layout_height="fill_parent"
              android:name="com.example.android.newsreader.HeadlinesFragment"
              android:layout_width="match_parent" />
</LinearLayout>
```
- res/layout-large/main.xml，双窗格布局：
```xml
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="fill_parent"
    android:layout_height="fill_parent"
    android:orientation="horizontal">
    <fragment android:id="@+id/headlines"
              android:layout_height="fill_parent"
              android:name="com.example.android.newsreader.HeadlinesFragment"
              android:layout_width="400dp"
              android:layout_marginRight="10dp"/>
    <fragment android:id="@+id/article"
              android:layout_height="fill_parent"
              android:name="com.example.android.newsreader.ArticleFragment"
              android:layout_width="fill_parent" />
</LinearLayout>
```
如果这个程序运行在屏幕尺寸大于7inch的设备上，系统就会加载res/layout-large/main.xml 而不是res/layout/main.xml，在小于7inch的设备上就会加载res/layout/main.xml（无限定符）。

#### **使用最小宽度限定符**

从 Android 3.2（API 级别 13）开始，以上small、normal、large和xlarge的尺寸组已弃用，应改为使用 sw<N>dp 配置限定符来定义布局资源可用的最小宽度。最小宽度限定符的使用和large基本一致，只是使用了具体的宽度限定。

- res/layout/main.xml，单面板（默认）布局：
```xml
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
  android:orientation="vertical"
  android:layout_width="match_parent"
  android:layout_height="match_parent">

  <fragment android:id="@+id/headlines"
            android:layout_height="fill_parent"
            android:name="com.example.android.newsreader.HeadlinesFragment"
            android:layout_width="match_parent" />
</LinearLayout>
```
res/layout-sw600dp/main.xml（sw指Small Width，即最小宽度），双面板布局：
```xml
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
  android:layout_width="fill_parent"
  android:layout_height="fill_parent"
  android:orientation="horizontal">
  <fragment android:id="@+id/headlines"
            android:layout_height="fill_parent"
            android:name="com.example.android.newsreader.HeadlinesFragment"
            android:layout_width="400dp"
            android:layout_marginRight="10dp"/>
  <fragment android:id="@+id/article"
            android:layout_height="fill_parent"
            android:name="com.example.android.newsreader.ArticleFragment"
            android:layout_width="fill_parent" />
</LinearLayout>
```
这意味着，最小宽度大于或等于 600dp 的设备将选择 layout-sw600dp/main.xml（双窗格）布局，而屏幕较小的设备将选择 layout/main.xml（单窗格）布局。

不过，这种方法在低于 3.2 版本的设备上不太奏效，因为它们无法将 sw600dp 识别为尺寸限定符，所以您仍需使用 large 限定符。因此，您应该建立一个与 res/layout-sw600dp/main.xml 内容完全相同的、名为 res/layout-large/main.xml 的文件。

#### **使用布局别名**

最小宽度限定符仅在 Android 3.2 及更高版本上提供。因此，仍应使用兼容早期版本的抽象尺寸容器（小、正常、大和超大）。 例如，如果想让自己设计的 UI 在手机上显示单窗格 UI，但在 7 英寸平板电脑、TV 及其他大屏设备上显示多窗格 UI，则需要提供下列文件：

- res/layout/main.xml: 单窗格布局
- res/layout-large: 多窗格布局
- res/layout-sw600dp: 多窗格布局

后两个文件完全相同，因为其中res/layout-sw600dp/main.xml将由 Android 3.2 以上版本的设备匹配，而res/layout-large/main.xml是为了照顾使用早期版本 Android 的平板电脑和 TV 的需要。

为避免为平板电脑和 TV 产生相同的重复文件（以及由此带来的维护难题），可以使用别名文件。 例如，您可以定义下列布局：

- res/layout/main.xml，单窗格布局
- res/layout/main_twopanes.xml，双窗格布局

并添加以下两个文件：

- res/values-large/layout.xml：
```xml
<resources>
    <item name="main" type="layout">@layout/main_twopanes</item>
</resources>
```
- res/values-sw600dp/layout.xml：
```xml
<resources>
    <item name="main" type="layout">@layout/main_twopanes</item>
</resources>
```
后两个文件内容完全相同，但它们实际上并未定义布局， 而只是将 main 设置为 main_twopanes 的别名。由于这些文件具有 large 和 sw600dp 选择器，因此它们适用于任何 Android 版本的平板电脑和电视（低于 3.2 版本的平板电脑和电视匹配 large，高于 3.2 版本者将匹配 sw600dp）。

#### **使用屏幕方向限定符**

如果我们要求给横屏、竖屏显示的布局不一样。就可以使用屏幕方向限定符来实现。

某些布局在横向和纵向屏幕方向下都表现不错，但其中大多数布局均可通过调整做进一步优化。如果某个应用的布局在各种屏幕尺寸和屏幕方向下具有以下行为：

- 小屏幕，纵向：单窗格，带徽标
- 小屏幕，横向：单窗格，带徽标
- 7 英寸平板电脑，纵向：单窗格，带操作栏
- 7 英寸平板电脑，横向：双窗格，宽，带操作栏
- 10 英寸平板电脑，纵向：双窗格，窄，带操作栏
- 10 英寸平板电脑，横向：双窗格，宽，带操作栏
- TV，横向：双窗格，宽，带操作栏

因此，以上每一种布局都在 res/layout/ 目录下的某个 XML 文件中定义。如果之后需要将每一种布局分配给各种屏幕配置，应用会使用布局别名将它们与每一种配置进行匹配：

- res/layout/onepane.xml:
```xml
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:orientation="vertical"
    android:layout_width="match_parent"
    android:layout_height="match_parent">

    <fragment android:id="@+id/headlines"
              android:layout_height="fill_parent"
              android:name="com.example.android.newsreader.HeadlinesFragment"
              android:layout_width="match_parent" />
</LinearLayout>
```
- res/layout/onepane_with_bar.xml:
```xml
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:orientation="vertical"
    android:layout_width="match_parent"
    android:layout_height="match_parent">
    <LinearLayout android:layout_width="match_parent" 
                  android:id="@+id/linearLayout1"  
                  android:gravity="center"
                  android:layout_height="50dp">
        <ImageView android:id="@+id/imageView1" 
                   android:layout_height="wrap_content"
                   android:layout_width="wrap_content"
                   android:src="@drawable/logo"
                   android:paddingRight="30dp"
                   android:layout_gravity="left"
                   android:layout_weight="0" />
        <View android:layout_height="wrap_content" 
              android:id="@+id/view1"
              android:layout_width="wrap_content"
              android:layout_weight="1" />
        <Button android:id="@+id/categorybutton"
                android:background="@drawable/button_bg"
                android:layout_height="match_parent"
                android:layout_weight="0"
                android:layout_width="120dp"
                style="@style/CategoryButtonStyle"/>
    </LinearLayout>

    <fragment android:id="@+id/headlines" 
              android:layout_height="fill_parent"
              android:name="com.example.android.newsreader.HeadlinesFragment"
              android:layout_width="match_parent" />
</LinearLayout>
```
- res/layout/twopanes.xml：
```xml
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="fill_parent"
    android:layout_height="fill_parent"
    android:orientation="horizontal">
    <fragment android:id="@+id/headlines"
              android:layout_height="fill_parent"
              android:name="com.example.android.newsreader.HeadlinesFragment"
              android:layout_width="400dp"
              android:layout_marginRight="10dp"/>
    <fragment android:id="@+id/article"
              android:layout_height="fill_parent"
              android:name="com.example.android.newsreader.ArticleFragment"
              android:layout_width="fill_parent" />
</LinearLayout>
```
- res/layout/twopanes_narrow.xml：
```xml
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="fill_parent"
    android:layout_height="fill_parent"
    android:orientation="horizontal">
    <fragment android:id="@+id/headlines"
              android:layout_height="fill_parent"
              android:name="com.example.android.newsreader.HeadlinesFragment"
              android:layout_width="200dp"
              android:layout_marginRight="10dp"/>
    <fragment android:id="@+id/article"
              android:layout_height="fill_parent"
              android:name="com.example.android.newsreader.ArticleFragment"
              android:layout_width="fill_parent" />
</LinearLayout>
```
至此所有可能的布局均已定义，现在只需使用配置限定符将正确的布局映射到每一种配置。 现在您可以使用布局别名技巧来完成这项工作：

- res/values/layouts.xml：
```xml
<resources>
    <item name="main_layout" type="layout">@layout/onepane_with_bar</item>
    <bool name="has_two_panes">false</bool>
</resources>
```
- res/values-sw600dp-land/layouts.xml：
```xml
<resources>
    <item name="main_layout" type="layout">@layout/twopanes</item>
    <bool name="has_two_panes">true</bool>
</resources>
```
- res/values-sw600dp-port/layouts.xml：
```xml
<resources>
    <item name="main_layout" type="layout">@layout/onepane</item>
    <bool name="has_two_panes">false</bool>
</resources>
```
- res/values-large-land/layouts.xml：
```xml
<resources>
    <item name="main_layout" type="layout">@layout/twopanes</item>
    <bool name="has_two_panes">true</bool>
</resources>
```
- res/values-large-port/layouts.xml：
```xml
<resources>
    <item name="main_layout" type="layout">@layout/twopanes_narrow</item>
    <bool name="has_two_panes">true</bool>
</resources>
```

### **适配不同的系统版本**

新的Android版本会为我们的app提供更棒的APIs，但我们的app仍应支持旧版本的Android，直到更多的设备升级到新版本为止。一般情况下，在更新app至最新Android版本时，最好先保证新版的app可以支持90%的设备使用。

Tip:为了能在多个Android版本中都能提供最好的特性和功能，应该在我们的app中使用Android Support Library，它能使我们的app能在旧平台上使用最近的几个平台的APIs。

#### **指定最小和目标API级别**

AndroidManifest.xml文件中描述了我们的app的细节及app支持哪些Android版本。具体来说，<uses-sdk>元素中的minSdkVersion和targetSdkVersion 属性，标明在设计和测试app时，最低兼容API的级别和最高适用的API级别(这个最高的级别是需要通过我们的测试的)。例如：
```html
<manifest xmlns:android="http://schemas.android.com/apk/res/android" ... >
    <uses-sdk android:minSdkVersion="4" android:targetSdkVersion="15" />
    ...
</manifest>
```
随着新版本Android的发布，一些风格和行为可能会改变，为了能使app能利用这些变化，而且能适配不同风格的用户的设备，我们应该**将targetSdkVersion的值尽量的设置与最新可用的Android版本匹配**。

#### **运行时检查系统版本**

Android在Build常量类中提供了对每一个版本的唯一代号，在我们的app中使用这些代号可以建立条件，保证依赖于高级别的API的代码，只会在这些API在当前系统中可用时，才会执行。
```java
private void setUpActionBar() {
    // Make sure we're running on Honeycomb or higher to use ActionBar APIs
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.HONEYCOMB) {
        ActionBar actionBar = getActionBar();
        actionBar.setDisplayHomeAsUpEnabled(true);
    }
}
```
**Build类**表示从系统属性中提取的当前编译信息，它提供了两个内部类Build.VERSION和Build.VERSION_CODES。

**Build.VERSIO类**包含一些表示版本信息的静态不可变字符串常量，典型的如Build.VERSIO.SDK\_INT（表示所用框架的用户可见的SDk版本，其可能的值在Build.VERSION\_CODES类中定义）。

**Build.VERSION_CODES类**表示已知SDK版本代码的枚举。该类包含一系列有关版本代码的int型常量，常见的版本代码常量见下表。

| 版本代码                      | Android版本                | API等级 |
| ------------------------- | ------------------------ | ----- |
| HONEYCOMB                 | Android 3.0              | 11    |
| HONEYCOMB_MR1             | Android 3.1              | 12    |
| HONEYCOMB_MR2             | Android 3.2              | 13    |
| ICE\_CREAM\_SANDWICH      | Android 4.0 - 4.0.2      | 14    |
| ICE\_CREAM\_SANDWICH\_MR1 | Android 4.0.3 - 4.0.4    | 15    |
| JELLY_BEAN                | Android 4.1.2            | 16    |
| JELLY\_BEAN\_MR1          | Android 4.2.2            | 17    |
| JELLY\_BEAN\_MR2          | Android 4.3.1            | 18    |
| KITKAT                    | Android 4.4.2            | 19    |
| KITKAT\_WATCH             | Android 4.4W.2           | 20    |
| LOLLIPOP                  | Lollipop, Android 5.0.1  | 21    |
| LOLLIPOP                  | Lollipop, Android 5.1.1  | 22    |
| M                         | Marshmallow, Android 6.0 | 23    |
| N                         | Nougat, Android 7.0      | 24    |
| N_MR1                     | Nougat++,Android 7.1.1   | 25    |


Note：当解析XML资源时，Android会忽略当前设备不支持的XML属性。所以我们可以安全地使用较新版本的XML属性，而不需要担心旧版本Android遇到这些代码时会崩溃。例如如果我们设置targetSdkVersion="11"，app会在Android 3.0或更高时默认包含ActionBar。然后添加menu items到action bar时，我们需要在自己的menu XML资源中设置android:showAsAction="ifRoom"。在跨版本的XML文件中这么做是安全的，因为旧版本的Android会简单地忽略showAsAction属性(就是这样，你并不需要用到res/menu-v11/中单独版本的文件)。

#### **使用平台风格和主题**

通过使用内置的style和theme，我们的app自然地随着Android新版本的发布，自动适配最新的外观和体验。

使activity看起来像对话框：
```html
<activity android:theme="@android:style/Theme.Dialog">
```
使activity有一个透明背景：
```html
<activity android:theme="@android:style/Theme.Translucent">
```
应用在/res/values/styles.xml中定义的**自定义主题**：
```html
<activity android:theme="@style/CustomTheme">
```
在&lt;application>元素中添加android:theme属性可使整个app应用一个主题(全部activities)：
```html
<application android:theme="@style/CustomTheme">
```