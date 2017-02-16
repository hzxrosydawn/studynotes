## **Activity详解**

本文来自[官方文档](https://developer.android.com/guide/components/activities/intro-activities.html)

[Activity](https://developer.android.com/reference/android/app/Activity.html) 是Android应用的一个重要组件，Activity 的加载和组合方式是 Android 应用模型的基础。与在 main() 方法中启动应用的编程范式不同，Android 系统通过在 Activity 实例中回调一些方法来初始化代码，这些回调的方法对应与该 Activity 生命周期的不同阶段。

该文档介绍了Activity的概念，然后提供了一些如何使用 Activity 的简单指导。

### **Activity的概念**

Activity类充当了应用于用户交互的入口点，提供了一个供应用绘制其UI组件的窗口。该窗口通常会充满屏幕，但也可小于屏幕并浮动在其他窗口之上。你可以创建一个Activity子类来实现一个Activity。一般来说，一个Activity在应用中实现了一个界面（sreen）。例如应用中的一个Activity实现了参数选择界面（Preferences screen），另一个Activity实现了发送邮件界面（Compose Email screen）。

多数应用都含有多个界面（screens），这意味着这些应用包含多个Activity。 一般会指定应用中的某个Activity 为主Activity（main activity），即用户启动应用时显示的第一个界面（screen）。每个Activity均可启动另一个Activity，以便执行不同的操作。例如，一个简单的邮件应用可提供一个收件箱的界面（screen ），主 Activity可从这个界面上启动其他 Activity ，这些Activity可以提供写邮件和打开单个邮件的任务界面（screens for tasks）。

尽管应用中的所有Activity 一起协同工作构成了紧密连续的用户体验，但每个Activity都是松散地绑定到其他Activity上的；应用中的Activity之间通常只是最小程度地彼此依赖着。实际上，Activity经常启动其他应用的Activity。例如，一个浏览器应用可以启动一个社交应用中用于分享的Activity。

### **配置清单**

为了让你的应用可以使用Activity，你必须在清单文件（AndroidManifest.xml）中声明所用的Activity以及该Activity的一些属性。

#### **声明Activity**

要声明您的Activity，请打开您的清单文件（AndroidManifest.xml），并将\<activity>元素添加为\<application>元素的子项。例如：

```xml
<manifest ... >
  <application ... >
      <activity android:name=".ExampleActivity" />
      ...
  </application ... >
  ...
</manifest >
```

\<activity>元素的唯一必需元素是[android:name](https://developer.android.com/guide/topics/manifest/activity-element.html#nm)，该属性指定了该Activity的类名。你也可以添加定义Activity特性（如标签（label）、图标和UI主题）的属性。可以阅读[\<activity> ](https://developer.android.com/guide/topics/manifest/activity-element.html)元素的参考文档来获取更多关于这些属性的信息。

**注意：** **应用一旦发布，你就不应再更改Activity的类名**，否则，可能会破坏诸如应用快捷方式等一些功能。可以阅读[Things That Cannot Change](http://android-developers.blogspot.com/2011/06/things-that-cannot-change.html) 博客来获取更多关于在发布之后避免哪些改变的信息。

#### **声明Intent过滤器（intent filters）**

[Intent 过滤器](https://developer.android.com/guide/components/intents-filters.html) 是 Android 平台上一个非常强大的功能，提供了不仅基于确切的显式请求、还可以基于不确切的隐式请求来启动Activity 功能。例如，一个确切的显式请求可以告诉系统”启动Gmail应用中发送邮件的Activity“，相反，一个不确定的的隐式请求可告诉系统”启动一个任何能发送邮件的 Activity “。当系统UI询问用户使用哪一个应用执行任务时，Intent过滤器就发挥作用了。

你可以通过在\<activity>元素中添加[\<intent-filter>](https://developer.android.com/guide/topics/manifest/intent-filter-element.html)子元素来使用该特性。该元素的定义包含[\<action>](https://developer.android.com/guide/topics/manifest/action-element.html)元素、可选的[\<category>](https://developer.android.com/guide/topics/manifest/category-element.html) 元素、和/或[\<date>](https://developer.android.com/guide/topics/manifest/data-element.html)元素。这些元素组合起来指定你的Activity可以响应的Intent类型。例如，下面的代码片段展示了如何配置发送文本数据的Activity，也从其他Activity接收请求：

```xml
<activity android:name=".ExampleActivity" android:icon="@drawable/app_icon">
	<intent-filter>
		<action android:name="android.intent.action.SEND" />
		<category android:name="android.intent.category.DEFAULT" />
		<data android:mimeType="text/plain" />
	</intent-filter>
<activity>
```

在这个例子中，\<action>元素指定该Activity可以发送数据，将\<category>元素声明为DEAULT就允许该Activity接收启动请求，\<data>元素指定该Activity能发送数据的类型。下面的代码片段如何调用上面定义的Activity：

```java
// Create the text message with a string
Intent sendIntent = new Intent();
sendIntent.setAction(Intent.ACTION_SEND);
sendIntent.putExtra(Intent.EXTRA_TEXT, textMessage);
sendIntent.setType("text/plain");
// Start the activity
startActivity(sendIntent);
```

如果你想使你的应用是独立的，不允许其他其他应用激活它的Activity，你就不需要任何Intent过滤器。那些你不想让其他应用不能访问的Activity不应包含Intent过滤器，你可以通过使用显式Intent来启动它们。阅读[Intent和Intent过滤器](https://developer.android.com/guide/components/intents-filters.html)来获取更多关于Activity如何响应Intent的信息。

#### **声明权限**

你可以使用清单中的\<activity>元素来控制哪些应用可以启动一个特定的Activity。一个父Activity不能启动一个子Activity，除非这两个Activity在清单中具有相匹配的权限。如果你为一个特定的Activity声明了一个[\<permission>](https://developer.android.com/guide/topics/manifest/uses-permission-element.html)元素，那么调用该Activity的Activity必须得有一个匹配的[\<uses-permission>](https://developer.android.com/guide/topics/manifest/uses-permission-element.html)元素。

例如，如果你的应用想使用一个假设名为SocialApp的应用在社交媒体上分享一个邮件，那么SocialApp必须定义能够调用它的权限：

```xml
<manifest>
<activity android:name="...."
   android:permission=”com.google.socialapp.permission.SHARE_POST” />
```

然后，为了能够调用SocialApp，你的应用必须与定义在SocialApp的清单中的权限相匹配：

```xml
<manifest>
   <uses-permission android:name="com.google.socialapp.permission.SHARE_POST" />
</manifest>
```

阅读[安全和权限](https://developer.android.com/guide/topics/security/security.html)来获取更多关于一般权限和安全的信息。

### **Activity的生命周期**

当用户进入、使用、退出应用时，应用中的Activity实例在其生命周期中转换着不同的状态。Activity类提供了一些回调方法来让该Activity知道某个状态发生了变化：系统是在创建（create）一个Activity、停止（stop）一个Activity、恢复（resume）一个Activity、还是销毁（destroy）一个Activity。

在生命周期的方法中，当用户离开、重新进入一个Activity时，你可以声明该Activity的行为。例如，如果你开发了一个流视频播放器，当用户切换到其他应用时，你可以暂停视频的播放，并终止（ terminate）网络连接。当用户返回时，你可以重连网络，并让用户在原来的位置继续视频的播放。换句话说，每个回调方法允许你执行特定的工作，来适应给定的状态变化。在对的时候做对的事，并恰当地处理转变，这样可以让你的应用更加健壮和高效。例如，好的生命周期的回调实现很有用，确保你的应用：

- 如果在用户使用你的应用时接到了电话，或者切换到了其他应用，不要让你的应用挂掉了；
- 当用户不再使用有价值的系统资源时，不要再消耗这些资源；
- 如果用户离开了你的应用后又回来了，不要丢失了用户的进度；
- 不要在横竖屏切换时挂掉了或者丢掉了用户的进度。

该文档详细阐明了Activity的生命周期。

#### **Activity生命周期的概念**

为了在Activity声明周期的各阶段中导航，Activity类提供了六个核心回调方法：[onCreate()](https://developer.android.com/reference/android/app/Activity.html#onCreate(android.os.Bundle))，[onStart()](https://developer.android.com/reference/android/app/Activity.html#onStart())，[onResume()](https://developer.android.com/reference/android/app/Activity.html#onResume())，[onPause()](https://developer.android.com/reference/android/app/Activity.html#onPause())，[onStop()](https://developer.android.com/reference/android/app/Activity.html#onStop())，和[onDestroy()](https://developer.android.com/reference/android/app/Activity.html#onDestroy())。当Activity进入一个新状态时，系统就会调用对应的方法。

下图为Activity生命周期的简图。

![activity_lifecycle](C:\Users\Vincent Huang\Desktop\studynotes\Android\四大组件\appendix\activity_lifecycle.png)

当用户开始离开某个Activity时，系统就调用方法来取消（dismantle ）该Activity。在某些情况下，这种取消是局部的。该Activity仍存在于内存中（比如当用户切换到另一个应用时），还可以回到前台来。如果用户返回到该Activity，该Activity就从用户离开的地方恢复（resume）。系统中和Activity一起的进程被杀掉的可能性依赖于Activity当时的状态。

根据你Activity的复杂程度，你可能不需要实现所有的生命周期方法。然而，理解每一个生命周期方法，并实现那些能让应用按照用户期望的方式来运行的方法就很重要。

#### **生命周期的回调方法**

##### [**onCreate()**](https://developer.android.com/reference/android/app/Activity.html#onCreate(android.os.Bundle))

**系统第一次创建Activity时就会回调该方法，必须实现该方法**。当创建一个Activity时，该Activity就会进入创建状态（created state）。在onCreate()方法中，应执行在整个生命周期中仅发生一次的基础的启动逻辑。比如你的onCreate()方法实现绑定了列表数据，初始化后台线程，实例化某些类范畴的变量。该方法接收一个savedInstanceState参数，该参数是一个保存了Activity之前状态的[Bundle](https://developer.android.com/reference/android/os/Bundle.html)对象。如果该Activity还未存在过，该参数值就为null。

下面的例子中的onCreate()方法展示了Activity基本的设置，比如声明用户界面（定义在一个XML布局文件中），定义成员变量，并配置一些UI。在这个例子中，通过将XML布局文件的资源ID——R.layout.main_activity传递给了setContentView()方法。

```java
TextView mTextView;

// some transient state for the activity instance
String mGameState;

@Override
public void onCreate(Bundle savedInstanceState) {
    // call the super class onCreate to complete the creation of activity like
    // the view hierarchy
    super.onCreate(savedInstanceState);

    // recovering the instance state
    if (savedInstanceState != null) {
        mGameState = savedInstanceState.getString(GAME_STATE_KEY);
    }

    // set the user interface layout for this Activity
    // the layout file is defined in the project res/layout/main_activity.xml file
    setContentView(R.layout.main_activity);

    // initialize member TextView so we can manipulate it later
    mTextView = (TextView) findViewById(R.id.text_view);
}

// This callback is called only when there is a saved instance previously saved using
// onSaveInstanceState(). We restore some state in onCreate() while we can optionally restore
// other state here, possibly usable after onStart() has completed.
// The savedInstanceState Bundle is same as the one used in onCreate().
@Override
public void onRestoreInstanceState(Bundle savedInstanceState) {
    mTextView.setText(savedInstanceState.getString(TEXT_VIEW_KEY));
}

// invoked when the activity may be temporarily destroyed, save the instance state here
@Override
public void onSaveInstanceState(Bundle out) {
    out.putString(GAME_STATE_KEY, mGameState);
    out.putString(TEXT_VIEW_KEY, mTextView.getText());

    // call superclass to save any view hierarchy
    super.onSaveInstanceState(out);
```

可以不使用定义XML文件、然后将它的资源ID传递给setContentView()的方式，而是在Activity代码中创建View对象，通过向ViewGroup中插入新建的View来建立一个View层级，然后将根ViewGroup传递给setContentView()来使用在代码中定义的布局。不过Android推荐在XML文件定义布局资源。

Activity不会一直处于创建状态（created state）。在onCreate()方法完成执行后，Activity进入启动状态（started state），系统将快速连续调用onStart()方法和onResume()方法。

##### [**onStart()**](https://developer.android.com/reference/android/app/Activity.html#onStart())

当Activity进入开始状态（started state）时，系统将回调该方法。随着应用准备将该Activity放入前台变成可以交互的，回调onStart()方法就会**将Activity显示给用户，但是还没有获得焦点**。该方法是应用初始化UI的维护代码的地方，例如，它也可能注册一个BroadcastReceiver来监听UI中反应的变化。

onStart()方法完成地非常迅速，如创建状态（created state）一样，Activity也不会驻留在开始状态（started state）。一旦该回调完成，Activity就进入恢复状态（resumed state）而调用onResume()方法。

##### [**onResume()**](https://developer.android.com/reference/android/app/Activity.html#onResume())

当Activity进入恢复状态（resumed  state）时会**到前台来**，然后系统调用onResume()回调方法。在该状态下，应用可以和用户进行交互而**获得焦点**。直到发生一些将焦点从该Activity上移走的事情，否则，该Activity就一直处于该状态。这些事情可能是，比如接到一个电话，用户导航到其他Activity上，或者设备的屏幕关闭了。

当发生了一个中断事件后，Activity进入暂停状态（paused state），系统就调用onPause()回调方法。

如果应用从暂停状态（paused state）回到恢复状态（resumed state），系统会再次调用onResume()方法。出于这个原因，你应该在onResume()实现中初始化在onPause()中释放的组件。例如，你可以像下面这样进行初始化：

```java
@Override
public void onResume() {
    super.onResume();  // Always call the superclass method first

    // Get the Camera instance as the activity achieves full user focus
    if (mCamera == null) {
        initializeCamera(); // Local method to handle camera init
    }
}  
```

注意，每次Activity到前台来时系统都会调用该方法，包括第一次创建该Activity时。你应该在onResume()的实现中初始化在onPause()中释放的组件，并执行其他任何必需的初始化操作，每次Activity进入恢复状态时都会执行这些必需的初始化操作。例如，当有动画的组件具有用户焦点时，你应该开始播放动画并初始化该组件。

##### [**onPause()**](https://developer.android.com/reference/android/app/Activity.html#onPause())

系统将调用该方法作为用户离开当前Activity时的第一回应（但并不意味这该Activity被销毁了）。此时**Activity失去焦点，但是依然可见**。使用onPause()方法来暂停诸如动画和音乐播放的操作，这些操作不应该在该Activity处于暂停状态（paused state）时仍然继续执行，在这种状态下可以立即进入恢复状态。Activity会进入该状态有几种原因，如：

- 某些事件中断了应用的运行，这是最常见的情形；
- 在Android 7.0 （API level 24）或更高版本中，多个应用运行在多个窗口模式下。因为任何时候只有一个应用（窗口）具有焦点，系统暂停其他所有应用；
- 一个新的、半透明的Activity（如对话框）打开了。只要一个Activity部分可见但是没有焦点，它就处于暂停状态。

你**可以使用onPause()方法来释放系统资源**，比如广播接收程序（broadcast receiver），传感器（想GPS）的句柄，或者其他可影响电池续航的资源，当Activity处于暂停状态时，用户就不需要这些资源了。

例如，如果你的应用使用了Camera，onPause()方法是一个释放相机的好地方。下面的onPause()例子对应上面的onResume()例子，释放在onResume()例子中初始化的相机：

```java
@Override
public void onPause() {
    super.onPause();  // Always call the superclass method first

    // Release the Camera because we don't need it when paused
    // and other activities might need to use it.
    if (mCamera != null) {
        mCamera.release();
        mCamera = null;
    }
}
```

onPause()的执行很简洁，没必要提供足够的时间来执行存保存操作。出于这个原因，你**不应该使用onPause()方法来保存数据，而是在onStop()中执行重量级的关闭操作**。

**onPause()方法完成后并不意味着该Activity离开了暂停状态。确切地说，Activity依然处于该状态，直到该Activity恢复或变成完全不可见**。如果Activity恢复了，系统再次调用onResume()回调。如果Activity要从暂停状态回到恢复状态，系统将Activity实例保留在内存中，当系统调用onResume()方法时会再次调用该Activity实例。在这种情形中，你不用再次初始化任何在回调方法中创建的组件，这些回调方法可以让Activity进入恢复状态。如果Activity完全不可见，系统会调用onStop()方法。

##### [**onStop()**](https://developer.android.com/reference/android/app/Activity.html#onStop())

当你的**Activity对用户不可见**时，该Activity就已进入停止状态（stopped state）了，系统也会调用onStop()回调方法。这可能在一个新启动的Activity覆盖了整个当前Activity屏幕时发生。系统可能也会在Activity结束运行、将要被终止（terminate的）时调用onStop()方法。

在onStop()方法中，应用应在用户不使用Activity时释放几乎所有不需要的资源。例如，如果你在onStart()方法中注册了一个BroadcastReceiver来监听可能影响UI的变化，你可以在onStop()中移出该BroadcastReceiver的注册，因为用户再也看不到UI了。使用onStop()释放可能泄露内存的资源也很重要，因为系统可能在不调用onDestroy()的情况下杀掉持有Activity的进程。

你也应该使用onStop()来执行比较CPU敏感的（CPU-intensive）关闭操作。例如，如果你找不到更合适的时间来保存数据库信息，你可在onStop()中进行这些处理。下面的例子展示了保存草案（draft note）的onStop()实现：

```java
@Override
protected void onStop() {
    // call the superclass method first
    super.onStop();

    // save the note's current draft, because the activity is stopping
    // and we want to be sure the current note progress isn't lost.
    ContentValues values = new ContentValues();
    values.put(NotePad.Notes.COLUMN_NAME_NOTE, getCurrentNoteText());
    values.put(NotePad.Notes.COLUMN_NAME_TITLE, getCurrentNoteTitle());

    // do this update in background on an AsyncQueryHandler or equivalent
    mAsyncQueryHandler.startUpdate (
            mToken,  // int token to correlate calls
            null,    // cookie, not used here
            mUri,    // The URI for the note to update.
            values,  // The map of column names and new values to apply to them.
            null,    // No SELECT criteria are used.
            null     // No WHERE columns are used.
    );
}
```

当Activity进入停止状态时，该Activity对象被保存在内存中：包含所有状态和成员信息，但是没有附加到窗口管理器（window manager）上。当该Activity恢复时会再次调用这些信息。你不用再次初始化任何在回调方法中创建的组件，这些回调方法可以让Activity进入恢复状态。系统也会记录布局中每个View对象的当前状态，所以，如果用户进入了一个EditText部件（widget），其中的内容也会保留，所以，你不用保存和恢复它。

**注意：** 一旦Activity处于停止状态，如果系统需要回收内存，那么系统可能销毁包含该Activity的进程。即使系统在该Activity被停止时销毁了其所在进程，系统仍会通过回调onSaveInstanceState()方法来保存应用的数据，如将EditText部件中的文本保留到一个Bundle对象（以key-value对的形式）中，如果用户在回到该Activity时就通过onRestoreSaveInstanceState()方法恢复保留到Bundle对象中的数据。

Activity从停止状态上不是回来和用户交互，就是完成其运行后消失。如果Activity回来了，系统就调用onRestart()方法。如果Activity完成了运行，系统就调用onDestroy()方法。

##### [**onDestroy()**](https://developer.android.com/reference/android/app/Activity.html#onDestroy())

在Activity销毁之前会回调该方法。这是Activity接收到的最终调用。系统回调该方法不是由于调用了[finish()](https://developer.android.com/reference/android/app/Activity.html#finish())方法，该Activity正在结束，就是因为系统临时销毁了包含Activity的进程来节约内存空间。可以通过[isFinishing()](https://developer.android.com/reference/android/app/Activity.html#isFinishing())方法来区分这两种情形。系统也会在屏幕方向改变时调用onDestroy()方法，然后立即调用onCreate()方法来重新创建在新屏幕方向上的进程（和Activity所含的组件）。

onDestroy()回调会释放所有在之前回调（如onStop()）中还未释放的资源。

##### [onRestart()](https://developer.android.com/reference/android/app/Activity.html#onRestart())

当您的Activity从停止状态返回前台，即从不可见的状态变为可见状态时，它会接收对 onRestart() 的调用。系统还会在每次您的Activity变为可见时调用 onStart() 方法（无论是正重新开始还是初次创建）。 但是，只会在Activity从停止状态继续时调用 onRestart() 方法，因此您可以使用它执行只有在Activity之前停止但未销毁的情况下可能必须执行的特殊恢复工作。

在实现这些生命周期方法时必须始终先调用超类实现，然后再执行任何操作。

```java
public class ExampleActivity extends Activity {
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        // 在该回调中完成该Activity的创建，
    }
    @Override
    protected void onStart() {
        super.onStart();
        // The activity is about to become visible.
    }
    @Override
    protected void onResume() {
        super.onResume();
        // The activity has become visible (it is now "resumed").
    }
    @Override
    protected void onPause() {
        super.onPause();
        // Another activity is taking focus (this activity is about to be "paused").
    }
    @Override
    protected void onStop() {
        super.onStop();
        // The activity is no longer visible (it is now "stopped")
    }
    @Override
    protected void onDestroy() {
        super.onDestroy();
        // The activity is about to be destroyed.
    }
}
```

这些方法共同定义Activity的整个生命周期。您可以通过实现这些方法监控Activity生命周期中的三个嵌套循环：

- Activity的**整个生命周期**发生在[onCreate()](https://developer.android.com/reference/android/app/Activity.html#onCreate(android.os.Bundle)) 调用与onDestroy()调用之间。您的Activity应onCreate()中执行“全局”状态设置（例如定义布局），并释放 onDestroy() 中的所有其余资源。例如，如果您的Activity有一个在后台运行的线程，用于从网络上下载数据，它可能会在onCreate()中创建该线程，然后在onDestroy()中停止该线程。
- Activity的**可见生命周期**发生在onStart() 调用与onStop() 调用之间。在这段时间，用户可以在屏幕上看到Activity 并与其交互。 例如，当一个新Activity启动，并且此Activity 不再可见时，系统会调用onStop()。您可以在调用这两个方法之间保留向用户显示Activity所需的资源。 例如，您可以在 onStart()中注册一个BroadcastReceiver以监控影响 UI 的变化，并在用户无法再看到您显示的内容时在onStop()中将其取消注册。在Activity的整个生命周期，当 Activity 在对用户可见和隐藏两种状态中交替变化时，系统可能会多次调用onStart()和onStop()。
- Activity的**前台生命周期**发生在onResume()调用与onPause()调用之间。在这段时间，Activity 位于屏幕上的所有其他 Activity之前，并具有用户输入焦点。 Activity可频繁转入和转出前台。例如，当设备转入休眠状态或出现对话框时，系统会调用onPause()。 由于此状态可能经常发生转变，因此这两个方法中应采用适度轻量级的代码，以避免因转变速度慢而让用户等待。

上面的回调可以简化为下图所示的过程。

![2658684-29334dccaca6d2da](C:\Users\Vincent Huang\Desktop\studynotes\Android\四大组件\appendix\2658684-29334dccaca6d2da.png)

我们考虑如下几类情况：
1、当一个Toast弹出的时候，会发生回调么？
No
2、当一个AlertDialog弹出的时候，会发生回调么？
No, 如果AlertDialog获取焦点，Activity会触发onWindowFocusChanged回调
3、当一个PopWindow弹出的时候，会发生回调么？
No, 如果PopWindow获取焦点，如mPopupWindow.setFocusable(true)，Activity会触发onWindowFocusChanged回调。
4.横竖屏切换时，会造成Activity被销毁然后重新创建。若在Activity配置android:configChanges="orientation"，横竖屏切换时，只触发onConfigurationChanged( )回调，Activity不会被重新创建。

#### **Activity状态和退出内存**

系统从来不会直接杀掉Activity。而是杀掉运行Activity的进程，不仅销毁Activity，而且也销毁运行在该进程中的一切。

当系统需要释放RAM时就会杀掉进程，杀掉给定进程的可能性取决于当时的进程状态。进入各状态顺序依赖于进程中Activity的状态。

用户也可以通过使用设置（Settings）中应用管理器（Application Manager）来杀掉一个进程来杀掉相关应用。

下表显示了进程状态，Activity状态和系统杀掉进程的可能性之间的关系

| Likelihood of being killed | Process state                            | Activity state        |
| -------------------------- | ---------------------------------------- | --------------------- |
| Least                      | Foreground (having or about to get focus) | CreatedStartedResumed |
| More                       | Background (lost focus)                  | Paused                |
| Most                       | Background (not visible)                 | Stopped               |
| Empty                      | Destroyed                                |                       |

#### **保存和恢复Activity状态**

在一些场景中，Activity会被正常销毁（如当用户按下返回键（back button）、或Activity通过调用finish()方法来发出自我销毁的信号）。如果Activity处于停止状态且较长时间内没有使用，或者前台Activity需要更多资源时，系统可能也会销毁包含该Activity的进程来回收内存。

当一个Activity由于用户按下返回键或该Activity自己结束了而销毁时，表明该Activity就不需要了，系统中该Activity实例也就不复存在了。然而，如果由于系统资源限制销毁了一个Activity（而不是正常销毁），即使该Activity的实例实际上已经消失了，系统也可以在销毁该Activity时保存其布局中每个View对象的信息来会记住它曾经存在过，因此，如果用户再导航回来，系统会使用之前保存的数据来新建一个该Activity的实例，相当于复原之前的状态（称为instance state）。这些数据以key-value对的集合的形式保存在一个Bundle对象中。

Activity优先级

1. 前台Activity。正在和用户交互的Activity，优先级最高
2. 可见但非前台Activity。Activity中弹出的对话框导致Activity可见但无法交互
3. 后台Activity。已经被暂停的Activity，优先级最低

系统内存不足时会按照以上顺序杀死Activity，并通过onSaveInstanceState和onRestoreInstanceState这两个方法来存储和恢复数据。

默认情况下，Activity实例被销毁之后又恢复之前的布局状态不需要你编写代码。然而，你的Activity可能需要恢复更多的信息，比如跟踪用户进度的成员变量，这时就需要自定义需要保存哪些信息。

##### 保存Activity的状态

**当一个Activity启动或停止时，系统会调用onSaveInstanceState()方法，该方法返回的参数是一个Bundle对象，该方法的默认实现就是将Activity的View层级的状态信息**（比如EditText部件的文本或ListView部件的滚动位置）以key-value对的集合的形式保存在该Bundle对象中。你的应用应该在onPause()方法之后、onStop()方法之前来回调onSaveInstanceState()。不要在onPause()中实现该回调。

**注意：**必须在onSaveInstanceState()实现中总是调用父类的实现，因此，会执行默认的保存实现。

为了保存Activity中额外的状态信息，你必须重写onSaveInstanceState()，并将key-value对添加到Bundle对象中，该Bundle对象在Activity异常销毁时会被保存起来。例如：

```java
static final String STATE_SCORE = "playerScore";
static final String STATE_LEVEL = "playerLevel";
...

@Override
public void onSaveInstanceState(Bundle savedInstanceState) {
    // Save the user's current game state
    savedInstanceState.putInt(STATE_SCORE, mCurrentScore);
    savedInstanceState.putInt(STATE_LEVEL, mCurrentLevel);

    // Always call the superclass so it can save the view hierarchy state
    super.onSaveInstanceState(savedInstanceState);
}
```

**注意：**为了让Android系统恢复Activity的状态，每个View都必须得有一个由android:id属性提供的唯一ID。从View的源码中也可以看出每个View都有onSaveInstanceState()和onRestoreInstanceState()这两个方法来用户保存和恢复其状态。

你应该在该方法中利用适当的机会来保存持久性数据（如用户首选项（preferences）或数据库数据），如果没有这样的机会，就应在onStop()方法中保存数据。

##### **恢复Activity的状态**

当一个Activity被销毁会又重建时，onCreate()和onRestoreInstanceState()回调方法都可以接收相同的包含状态信息的Bundle对象。因为onCreate()方法在创建一个新的Activity实例或之前的Activity时调用，所以你必须在试着读取该Bundle对象之前检查该对象是否为空，如果为空，系统就新建一个Activity的实例，用来替换之前销毁的Activity实例。

例如，下列代码片段展示了如何在onCreate()中恢复某些状态数据：

```java
@Override
protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState); // Always call the superclass first

    // Check whether we're recreating a previously destroyed instance
    if (savedInstanceState != null) {
        // Restore value of members from saved state
        mCurrentScore = savedInstanceState.getInt(STATE_SCORE);
        mCurrentLevel = savedInstanceState.getInt(STATE_LEVEL);
    } else {
        // Probably initialize members with default values for a new instance
    }
    ...
}
```

你可以选择实现onRestoreInstanceState()方法，而不是在onCreate()方法中恢复之前的状态。系统在onStart()方法之后仅在需要恢复一个已保存的状态时调用onRestoreInstanceState()方法，所以不需要检查Bundle是否为空：

```java
public void onRestoreInstanceState(Bundle savedInstanceState) {
    // Always call the superclass so it can restore the view hierarchy
    super.onRestoreInstanceState(savedInstanceState);

    // Restore state members from saved instance
    mCurrentScore = savedInstanceState.getInt(STATE_SCORE);
    mCurrentLevel = savedInstanceState.getInt(STATE_LEVEL);
}
```

**注意：** 一定要调用父类的onRestoreInstanceState()实现来保证默认的实现能够恢复View层级。

![restore_instance](C:\Users\Vincent Huang\Desktop\studynotes\Android\四大组件\appendix\restore_instance.png)

**onSaveInstanceState()方法和onRestoreInstanceState()方法不一定是成对被调用的**。onSaveInstanceState()的调用一个重要原则是，当系统“未经你许可”销毁了你的Activity时onSaveInstanceState()会被系统调用。而onRestoreInstanceState()被调用的前提是，Activity“确实”被系统销毁了，而如果没有被销毁，即使保存了Activity的数据该方法不会被调用，例如，当正在显示Activity的时候，用户按下HOME键回到主界面，然后用户紧接着又返回到Activity，这种情况下Activity一般不会因为内存的原因被系统销毁，故Activity的onRestoreInstanceState()方法不会被执行。

#### **结束 Activity**

您可以通过调用 Activity 的 [Activity.finish()](https://developer.android.com/reference/android/app/Activity.html#finish()) 方法来结束该 Activity。您还可以通过调用 [Activity.finishActivity()](https://developer.android.com/reference/android/app/Activity.html#finishActivity(int)) 结束您之前启动的另一个 Activity。

**注**：在大多数情况下，您**不应使用这些方法显式结束 Activity**。 正如下文有关 Activity 生命周期的部分所述，**Android 系统会为您管理 Activity 的生命周期，因此您无需结束自己的 Activity**。 调用这些方法可能对预期的用户体验产生不良影响，因此**只应在您确实不想让用户返回此 Activity 实例时使用**。

### **Activity状态改变**

一些用户触发的和系统触发的事件可能导致Activity的状态发生改变。

#### **处理配置变更**

有些设备配置可能会在运行时发生变化（例如屏幕方向、键盘可用性及语言）。 发生此类变化时，Android会销毁并重建运行中的 Activity（系统调用 onDestroy()，然后立即调用 onCreate()）。此行为旨在通过利用您提供的备用资源（例如适用于不同屏幕方向和屏幕尺寸的不同布局）自动重新加载您的应用来帮助它适应新配置。

如果您对 Activity 进行了适当设计，让它能够按以上所述处理屏幕方向变化带来的重启并恢复Activity状态，那么在遭遇 Activity 生命周期中的其他意外事件时，您的应用将具有更强的适应性。

##### **旋转屏幕时的状态改变**

选装屏幕时，在默认状态下，Activity就会被销毁并且重新创建。

1. 首先，Activity就会被销毁。onPause()， onStop()，onDestory()均会被调用，同时由于Activity是在异常状态下终止的，系统会在onStop()之前，调用onSaveInstanceState()来保存当前Activity的状态。
2. 然后，Activity被重新创建，系统会在onStart()之后，调用onRestoreInstanceState()，并且把之前保存的Bundle对象传递给onRestoreInstanceState()或onCreate()方法，但是一般用onRestoreInstanceState()。因为onRestoreInstanceState()一旦被调用，其参数 Bundle savedInstanceState 一定是有值的，我们不必判断其是否为空。

**注**：由于无法保证系统会调用onSaveInstanceState()，因此您只应利用它来记录Activity的瞬态（UI 的状态），切勿使用它来存储持久性数据，而应使用onPause()在用户离开Activity 后存储持久性数据（例如应保存到数据库的数据）。

您只需旋转设备，让屏幕方向发生变化，就能有效地测试您的应用的状态恢复能力。 当屏幕方向变化时，系统会销毁并重建 Activity，以便应用可供新屏幕配置使用的备用资源。 但是如果在\<activity>中配置android:configChanges="orientation"，横竖屏切换时，只触发onConfigurationChanged( )回调，Activity不会被销毁和重新创建。在一些特殊情况下，比如玩游戏时，你并不希望切换横竖屏而导致Activity被销毁后重新创建，这时有两种禁用掉横竖屏切换的生命周期：

1. 横竖屏写死 。在AndroidManifest.xml中的\<activity>元素中加入以下声明：

```xml
android:screenOrientation=["landscape" | "portrait" ]
```

1. 让系统的环境对横竖屏切换不再敏感。在AndroidManifest.xml中的\<activity>元素中加入以下声明：：

```xml
android:configChanges=["orientation" | "screenSize"]
```

该属性声明配置将阻止Activity重新启动。常用属性：

- locale：设备的本地位置发生变化，一般指切换了系统语言。


- orientation：屏幕方向发生变化
- screenSize：屏幕大小发生变化，当旋转屏幕的时候，屏幕尺寸会变！！！！这个比较特殊，当minSdkVersion和targetSdkVersion均低于13时，此选项不会导致Activity重启，否则会导致Activity重启。
- keyboardHidden：键盘的可访问性发生变化，比如调出键盘。

##### **处理多窗口模式**

当应用进入Android 7.0（API级别24）或更高版本所支持的多窗口模式时，系统会向当前运行的Activity发出配置改变的通知，当前Activity就会经历上面所讲的状态改变（即销毁后重建）。如果已处于多窗口模式的应用尺寸发生了改变，也会发生这样的状态改变。Activity可以自己处理配置的改变，也可以让系统销毁它后按照新的尺寸来重建它。

多窗口模式下有两个可见的应用，但是只有当前与用户交互的前台应用具有焦点，该应用的当前Activity处于恢复状态（resumed），另一个应用的可见Activity处于暂停状态（paused）。当用户从一个可见应用A切换到另一个可见应用B时，系统会在应用A上回调onPause()方法，在应用B上回调onResume()方法，当用户在这两个应用之间切换时，系统会调用这两个应用的这两个方法。

更多关于多窗口生命周期的信息请参考[Multi-Window Support](https://developer.android.com/guide/topics/ui/multi-window.html) 中[Multi-Window Lifecycle](https://developer.android.com/guide/topics/ui/multi-window.html#lifecycle) 部分。

#### **Activity或Dialog进入前台**

如果一个新的Activity A（或Dialog A）来到前台，遮盖了当前的Activity B（B并未因为资源限制而被回收）。这种状态变化分为以下两种情况：

1. 当A完全不可见的状态下：

A跳转到B： A onPause > B onCreate > B onStart > B onResume > A onStop
B跳转到A： B onPause > A onRestart> A onStart > A onResume > B onStop

1. 当A处于部分可见的状态下：

A跳转到B： A onPause > B onCreate > B onStart > B onResume
B跳转到A： B onPause > A onStart > A onResume > B onStop

两者的区别在于onStop 和 onRestart的方法调用，onStop 只有在Activity完全不可见的时候才会调用。Activity由不可见变为可见，onRestart才会调用。

注意：如果用户按下了预览键（Overview ）或Home键，系统会将当前Activity当成是被完全隐藏了。

您可以利用这种可预测的生命周期回调顺序管理从一个Activity到另一个Activity的信息转变。 例如，如果您必须在第一个Activity停止时向数据库写入数据，以便下一个Activity能够读取该数据，则应在onPause()而不是onStop()执行期间向数据库写入数据。

#### **用户按下返回键**

用户按下返回键时，当前Activity会依次回调onPause()，onStop()和onDestroy()方法。除了被销毁，当前Activity也会被从返回栈（back stack）中移除。注意，这种情况下默认不会激发onSaveInstanceState() 方法，因为用户按下返回键就假定他不想再回到该Activity当前的实例了。然而，你也可以重写[onBackPressed()](https://developer.android.com/reference/android/app/Activity.html#onBackPressed())方法自定义按下返回键的行为，比如显示一个确认对话框。如果重写了onBackPressed()方法，Android仍极力推荐在重写实现中调用super.onBackPressed()，不然按下返回键时可能有冲突。

### **在Activity中导航**

应用可能在其生命周期内多次进入或离开一个Activity。例如，用户点击了设备的返回键而离开一个Activity，或者一个Activity需要启动其他Activity。

#### **启动一个Activity**

您可以通过调用 [Activity.startActivity()](https://developer.android.com/reference/android/app/Activity.html#startActivity(android.content.Intent))，并为其传入一个 Intent来启动另一个 Activity，传入的 Intent 对象会指定您想启动的具体 Activity 或描述您想执行的操作类型（系统会为您选择合适的 Activity，甚至是来自其他应用的 Activity）。 Intent 对象还可能携带少量供所启动 Activity 使用的数据。

在您的自有应用内工作时，您经常只需要启动某个已知 Activity，可以通过将您想启动的 Activity 的类名传入 Intent 的构造器来创建一个可启动该 Activity 的 Intent 对象。 例如，可以通过以下代码让一个 Activity 启动另一个名为 SignInActivity的 Activity：

```java
Intent intent = new Intent(this, SignInActivity.class);
startActivity(intent);
```

不过，您的应用可能还需要利用您的 Activity 数据执行某项操作，例如发送电子邮件、短信或状态更新。 在这种情况下，您的应用自身可能不具有执行此类操作所需的 Activity，因此您可以改为利用设备上其他应用提供的 Activity 为您执行这些操作。 这便是 Intent 对象的真正价值所在——您可以创建一个 Intent 对象，对您想执行的操作进行描述，系统会从其他应用启动相应的 Activity。 如果有多个 Activity 可以处理 Intent，则用户可以选择要使用哪一个。 例如，如果您想允许用户发送电子邮件，可以创建以下 Intent：

```java
Intent intent = new Intent(Intent.ACTION_SEND);
intent.putExtra(Intent.EXTRA_EMAIL, recipientArray);
startActivity(intent);
```

添加到 Intent 中的 [EXTRA_EMAIL](https://developer.android.com/reference/android/content/Intent.html#EXTRA_EMAIL) 是一个字符串数组，其中包含应将电子邮件发送到的电子邮件地址。 当电子邮件应用响应此 Intent 时，它会读取 extra 中提供的字符串数组，并将它们放入电子邮件撰写窗体的“收件人”字段。 在这种情况下，电子邮件应用的 Activity 启动，并且当用户完成操作时，您的 Activity 会恢复执行。

#### **启动一个Activity并返回结果**

有时，您可能需要从启动的Activity获得结果。在这种情况下，请通过调用 [Activity.startActivityForResult()](https://developer.android.com/reference/android/app/Activity.html#startActivityForResult(android.content.Intent, int))（而非 startActivity()）来启动Activity。 要想收到被启动Activity的执行结果，请实现 [Activity.onActivityResult()](https://developer.android.com/reference/android/app/Activity.html#onActivityResult(int, int, android.content.Intent)) 回调方法。 被启动的Activity需要调用setResult()方法来将执行结果传入Intent对象，它会使用Intent向您的onActivityResult() 方法返回结果。

例如，您可能希望用户选取其中一位联系人，以便您的Activity对该联系人中的信息执行某项操作。 您可以通过以下代码创建此类Intent并处理结果：

```java
private void pickContact() {    
	// Create an intent to "pick" a contact, as defined by the content provider URI    
	Intent intent = new Intent(Intent.ACTION_PICK, Contacts.CONTENT_URI);    
	startActivityForResult(intent, PICK_CONTACT_REQUEST);
}

@Override
protected void onActivityResult(int requestCode, int resultCode, Intent data) {    
	// If the request went well (OK) and the request was PICK_CONTACT_REQUEST    
	if (resultCode == Activity.RESULT_OK && requestCode == PICK_CONTACT_REQUEST) {        
		// Perform a query to the contact's content provider for the contact's name        
		Cursor cursor = getContentResolver().query(data.getData(),new String[] {Contacts.DISPLAY_NAME}, 
                    	null, null, null);        
		if (cursor.moveToFirst()) {  // True if the cursor is not empty               
   		int columnIndex = cursor.getColumnIndex(Contacts.DISPLAY_NAME);            
		String name = cursor.getString(columnIndex);            
		// Do something with the selected contact's name...        
		}    
	}
}
```

上例显示的是，在处理Activity结果时应该在onActivityResult()方法中使用的基本逻辑为： 

1. 检查请求是否成功。根据请求码和结果码确定业务逻辑。请求码用来区分Intent中的数据来自于哪一个Activity，结果码用来区分被启动的Activity设置的数据结果属于什么类型；
2. 如果成功，则从该处开始获取并处理Intent中的数据。

实际情况是，[ContentResolver](https://developer.android.com/reference/android/content/ContentResolver.html)对一个ContentProvider执行查询，后者返回一个[Cursor](https://developer.android.com/reference/android/database/Cursor.html)，让查询的数据能够被读取。

### **任务和返回栈（Tasks and Back Stack）**

以下内容来自[官网](https://developer.android.com/guide/components/tasks-and-back-stack.html)。

应用通常包含多个[Activity](https://developer.android.com/guide/components/activities.html?hl=zh-cn)。每个 Activity 均应围绕用户可以执行的特定操作设计，并且能够启动其他 Activity。 例如，电子邮件应用可能有一个 Activity 显示新邮件的列表。用户选择某邮件时，会打开一个新 Activity 以查看该邮件。

一个 Activity 甚至可以启动设备上其他应用中存在的 Activity。例如，如果应用想要发送电子邮件，则可定义一个 Intent 来执行“发送”操作并加入一些数据，如电子邮件地址和电子邮件。 然后，系统将打开其他应用中声明自己可以处理此类 Intent 的 Activity。在这个例子中，Intent 是要发送电子邮件，因此将启动电子邮件应用的“撰写”Activity（如果多个 Activity 支持相同 Intent，则系统会让用户选择要使用哪一个 Activity）。发送电子邮件时，电子邮件 Activity 将恢复（resume），就好像该 Activity 是您的应用的一部分。 即使这两个 Activity 可能来自不同的应用，但是 Android 仍会将 Activity 保留在相同的任务中，以维护这种无缝的用户体验。

**任务**（task）是指在执行特定作业时与用户交互的一系列 Activity。 这些 Activity 按照各自的打开顺序排列在堆栈（即**返回栈**）中。

设备主屏幕是大多数任务的起点。当用户触摸应用启动器中的图标（或主屏幕上的快捷方式）时，该应用的任务将出现在前台。 如果应用不存在任务（应用最近未曾使用），则会创建一个新任务，并且该应用的“主”Activity 将作为堆栈中的根 Activity 打开。

当前 Activity 启动另一个 Activity 时，该新 Activity 会被推送到堆栈顶部，成为焦点所在。 前一个 Activity 仍保留在堆栈中，但是处于停止状态。Activity 停止时，系统会保持其用户界面的当前状态。 用户按返回键时，当前 Activity 会从堆栈顶部弹出（Activity 被销毁），而前一个 Activity 恢复执行（恢复其 UI 的前一状态）。 堆栈中的 Activity 永远不会重新排列，仅推入和弹出堆栈：由当前 Activity 启动时推入堆栈，用户使用返回键退出时弹出堆栈。 因此，返回栈以“后进先出”对象结构运行。 下图通过时间线显示 Activity 之间的进度以及每个时间点的当前返回栈，直观呈现了这种行为。

![diagram_backstack](C:\Users\Vincent Huang\Desktop\studynotes\Android\四大组件\appendix\diagram_backstack.png)

用户按返回键时，当前 Activity 随即被销毁，而前一个 Activity 恢复执行。

如果用户继续按返回键，堆栈中的相应 Activity 就会弹出，以显示前一个 Activity，直到用户返回主屏幕为止（或者，返回任务开始时正在运行的任意 Activity）。 当所有 Activity 均从堆栈中移除后，任务即不复存在。

任务是一个有机整体，当用户开始新任务或通过Home键转到主屏幕时，原先的任务可以移动到“后台”。 尽管在后台时，该任务中的所有 Activity 全部停止，但是任务的返回栈仍旧不变，也就是说，当另一个任务发生时，该任务仅仅失去焦点而已，如下图所示。

![2658684a](C:\Users\Vincent Huang\Desktop\studynotes\Android\四大组件\appendix\2658684a.png)

然后，任务可以返回到“前台”，用户就能够回到离开时的状态。 例如，假设当前任务（任务 A）的堆栈中有三个 Activity，即当前 Activity 下方还有两个 Activity。 用户先按Home键，然后从应用启动器启动新应用。 显示主屏幕时，任务 A 进入后台。新应用启动时，系统会使用自己的 Activity 堆栈为该应用启动一个任务（任务 B）。与该应用交互之后，用户再次返回主屏幕并选择最初启动任务 A 的应用。现在，任务 A 出现在前台，其堆栈中的所有三个 Activity 保持不变，而位于堆栈顶部的 Activity 则会恢复执行。 此时，用户还可以通过转到主屏幕并选择启动该任务的应用图标（或者，通过从[概览屏幕](https://developer.android.com/guide/components/recents.html?hl=zh-cn)选择该应用的任务）切换回任务 B。这是 Android 系统中的一个多任务示例。

**注**：后台可以同时运行多个任务。但是，如果用户同时运行多个后台任务，则系统可能会开始销毁后台 Activity，以回收内存资源，从而导致 Activity 状态丢失。

由于**返回栈中的 Activity 永远不会重新排列**，因此如果应用允许用户从多个 Activity 中启动特定 Activity，则会创建该 Activity 的新实例并推入堆栈中（而不是将 Activity 的任一先前实例置于顶部）。 因此，应用中的一个 Activity 可能会多次实例化（即使 Activity 来自不同的任务），如下图所示。

![diagram_multiple_instances](C:\Users\Vincent Huang\Desktop\studynotes\Android\四大组件\appendix\diagram_multiple_instances.png)

因此，如果用户使用返回键向后导航，则会按 Activity 每个实例的打开顺序显示这些实例（每个实例的 UI 状态各不相同）。 但是，如果您不希望 Activity 多次实例化，则可修改此行为。 具体操作方法将在后面的[管理任务](https://developer.android.com/guide/components/tasks-and-back-stack.html?hl=zh-cn#ManagingTasks)部分中讨论。

Activity 和任务的默认行为总结如下：

当 Activity A 启动 Activity B 时，Activity A 将会停止，但系统会保留其状态（例如，滚动位置和已输入表单中的文本）。如果用户在处于 Activity B 时按返回键，则 Activity A 将恢复其状态，继续执行。

用户通过按Home键离开任务时，当前 Activity 将停止且其任务会进入后台。 系统将保留任务中每个 Activity 的状态。如果用户稍后通过选择开始任务的启动器图标来恢复任务，则任务将出现在前台并恢复执行堆栈顶部的 Activity。

如果用户按返回键，则当前 Activity 会从堆栈弹出并被销毁。 堆栈中的前一个 Activity 恢复执行。销毁 Activity 时，系统不会保留该 Activity 的状态。

即使来自其他任务，Activity 也可以多次实例化。

#### **保存 Activity 状态**

正如上文所述，当 Activity 停止时，系统的默认行为会保留其状态。 这样一来，当用户导航回到上一个 Activity 时，其用户界面与用户离开时一样。 但是，在 Activity 被销毁且必须重建时，您可以而且**应当**主动使用回调方法保留 Activity 的状态。

系统停止您的一个 Activity 时（例如，新 Activity 启动或任务转到前台），如果系统需要回收系统内存资源，则可能会完全销毁该 Activity。 发生这种情况时，有关该 Activity 状态的信息将会丢失。如果发生这种情况，系统仍会知道该 Activity 存在于返回栈中，但是当该 Activity 被置于堆栈顶部时，系统一定会重建 Activity（而不是恢复 Activity）。 为了避免用户的工作丢失，您应主动通过在 Activity 中实现[onSaveInstanceState()](https://developer.android.com/reference/android/app/Activity.html?hl=zh-cn#onSaveInstanceState(android.os.Bundle))回调方法来保留工作。

#### 管理任务

Android 管理任务和返回栈的方式（如上所述，即：将所有连续启动的 Activity 放入同一任务和“后进先出”堆栈中）非常适用于大多数应用，而您不必担心 Activity 如何与任务关联或者如何存在于返回栈中。 但是，您可能会决定要中断正常行为。 也许您希望应用中的 Activity 在启动时开始新任务（而不是放置在当前任务中）；或者，当启动 Activity 时，您希望将其现有实例上移一层（而不是在返回栈的顶部创建新实例）；或者，您希望在用户离开任务时，清除返回栈中除根 Activity 以外的所有其他 Activity。

通过使用清单文件元素中的属性和传递给[startActivity()](https://developer.android.com/reference/android/app/Activity.html?hl=zh-cn#startActivity(android.content.Intent))的 Intent 中的标志，您可以执行所有这些操作以及其他操作。

在这一方面，您可以使用的主要属性包括：

[taskAffinity](https://developer.android.com/guide/topics/manifest/activity-element.html?hl=zh-cn#aff)

[launchMode](https://developer.android.com/guide/topics/manifest/activity-element.html?hl=zh-cn#lmode)

[allowTaskReparenting](https://developer.android.com/guide/topics/manifest/activity-element.html?hl=zh-cn#reparent)

[clearTaskOnLaunch](https://developer.android.com/guide/topics/manifest/activity-element.html?hl=zh-cn#clear)

[alwaysRetainTaskState](https://developer.android.com/guide/topics/manifest/activity-element.html?hl=zh-cn#always)

[finishOnTaskLaunch](https://developer.android.com/guide/topics/manifest/activity-element.html?hl=zh-cn#finish)

您可以使用的主要 Intent 标志包括：

[FLAG_ACTIVITY_NEW_TASK](https://developer.android.com/reference/android/content/Intent.html?hl=zh-cn#FLAG_ACTIVITY_NEW_TASK)

[FLAG_ACTIVITY_CLEAR_TOP](https://developer.android.com/reference/android/content/Intent.html?hl=zh-cn#FLAG_ACTIVITY_CLEAR_TOP)

[FLAG_ACTIVITY_SINGLE_TOP](https://developer.android.com/reference/android/content/Intent.html?hl=zh-cn#FLAG_ACTIVITY_SINGLE_TOP)

 通常，您应该允许系统定义任务和 Activity 在概览屏幕（recents screen）中的显示方法，并且无需修改此行为。

**注意：**大多数应用都不得中断 Activity 和任务的默认行为： 如果确定您的 Activity 必须修改默认行为，当使用返回键从其他 Activity 和任务导航回到该 Activity 时，请务必要谨慎并确保在启动期间测试该 Activity 的可用性。请确保测试导航行为是否有可能与用户的预期行为冲突。

#### 定义启动模式

启动模式允许您定义 Activity 的新实例如何与当前任务关联。 您可以通过两种方法定义不同的启动模式：

- [使用清单文件](https://developer.android.com/guide/components/tasks-and-back-stack.html?hl=zh-cn#ManifestForTasks)

在清单文件中声明 Activity 时，您可以指定 Activity 在启动时应该如何与任务关联。

- [使用 Intent 标志](https://developer.android.com/guide/components/tasks-and-back-stack.html?hl=zh-cn#IntentFlagsForTasks)

调用[startActivity()](https://developer.android.com/reference/android/app/Activity.html?hl=zh-cn#startActivity(android.content.Intent))时，可以在[Intent](https://developer.android.com/reference/android/content/Intent.html?hl=zh-cn)中加入一个标志，用于声明新 Activity 如何（或是否）与当前任务关联。

因此，如果 Activity A 启动 Activity B，则 Activity B 可以在其清单文件中定义它应该如何与当前任务关联（如果可能），并且 Activity A 还可以请求 Activity B 应该如何与当前任务关联。如果这两个 Activity 均定义 Activity B 应该如何与任务关联，则 Activity A 的请求（如 Intent 中所定义）优先级要高于 Activity B 

的请求（如其清单文件中所定义）。

**注**：某些适用于清单文件的启动模式不可用作 Intent 标志，同样，某些可用作 Intent 标志的启动模式无法在清单文件中定义。

使用清单文件

在清单文件中声明 Activity 时，您可以使用元素的[launchMode](https://developer.android.com/guide/topics/manifest/activity-element.html?hl=zh-cn#lmode)属性指定 Activity 应该如何与任务关联。

[launchMode](https://developer.android.com/guide/topics/manifest/activity-element.html?hl=zh-cn#lmode)属性指定有关应如何将 Activity 启动到任务中的指令。您可以分配给[launchMode](https://developer.android.com/guide/topics/manifest/activity-element.html?hl=zh-cn#lmode)属性的启动模式共有四种：

"standard"（默认模式）

默认。系统在启动 Activity 的任务中创建 Activity 的新实例并向其传送 Intent。Activity 可以多次实例化，而每个实例均可属于不同的任务，并且一个任务可以拥有多个实例。

"singleTop"

如果当前任务的顶部已存在 Activity 的一个实例，则系统会通过调用该实例的[onNewIntent()](https://developer.android.com/reference/android/app/Activity.html?hl=zh-cn#onNewIntent(android.content.Intent))方法向其传送 Intent，而不是创建 Activity 的新实例。Activity 可以多次实例化，而每个实例均可属于不同的任务，并且一个任务可以拥有多个实例（但前提是位于返回栈顶部的 Activity 并不是 Activity 的现有实例）。**

例如，假设任务的返回栈包含根 Activity A 以及 Activity B、C 和位于顶部的 D（堆栈是 A-B-C-D；D 位于顶部）。收到针对 D 类 Activity 的 Intent。如果 D 具有默认的"standard"启动模式，则会启动该类的新实例，且堆栈会变成 A-B-C-D-D。但是，如果 D 的启动模式是"singleTop"，则 D 的现有实例会通过[onNewIntent()](https://developer.android.com/reference/android/app/Activity.html?hl=zh-cn#onNewIntent(android.content.Intent))接收 Intent，因为它位于堆栈的顶部；而堆栈仍为 A-B-C-D。但是，如果收到针对 B 类 Activity 的 Intent，则会向堆栈添加 B 的新实例，即便其启动模式为"singleTop"也是如此。

**注**：为某个 Activity 创建新实例时，用户可以按*“返回”*按钮返回到前一个 Activity。 但是，当 Activity 的现有实例处理新 Intent 时，则在新 Intent 到达[onNewIntent()](https://developer.android.com/reference/android/app/Activity.html?hl=zh-cn#onNewIntent(android.content.Intent))之前，用户无法按*“返回”*按钮返回到 Activity 的状态。

"singleTask"

系统创建新任务并实例化位于新任务底部的 Activity。但是，如果该 Activity 的一个实例已存在于一个单独的任务中，则系统会通过调用现有实例的[onNewIntent()](https://developer.android.com/reference/android/app/Activity.html?hl=zh-cn#onNewIntent(android.content.Intent))方法向其传送 Intent，而不是创建新实例。一次只能存在 Activity 的一个实例。

**注**：尽管 Activity 在新任务中启动，但是用户按*“返回”*按钮仍会返回到前一个 Activity。

"singleInstance".

与"singleTask"相同，只是系统不会将任何其他 Activity 启动到包含实例的任务中。该 Activity 始终是其任务唯一仅有的成员；由此 Activity 启动的任何 Activity 均在单独的任务中打开。

我们再来看另一示例，Android 浏览器应用声明网络浏览器 Activity 应始终在其自己的任务中打开（通过在元素中指定singleTask启动模式）。这意味着，如果您的应用发出打开 Android 浏览器的 Intent，则其 Activity 与您的应用位于*不同*的任务中。相反，系统会为浏览器启动新任务，或者如果浏览器已有任务正在后台运行，则会将该任务上移一层以处理新 Intent。

无论 Activity 是在新任务中启动，还是在与启动 Activity 相同的任务中启动，用户按*“返回”*按钮始终会转到前一个 Activity。 但是，如果启动指定singleTask启动模式的 Activity，则当某后台任务中存在该 Activity 的实例时，整个任务都会转移到前台。此时，返回栈包括上移到堆栈顶部的任务中的所有 Activity。 图 4 显示了这种情况。

**图 4.**显示如何将启动模式为“singleTask”的 Activity 添加到返回栈。 如果 Activity 已经是某个拥有自己的返回栈的后台任务的一部分，则整个返回栈也会上移到当前任务的顶部。

如需了解有关在清单文件中使用启动模式的详细信息，请参阅元素文档，其中更详细地讨论了launchMode属性和可接受的值。

**注**：使用[launchMode](https://developer.android.com/guide/topics/manifest/activity-element.html?hl=zh-cn#lmode)属性为 Activity 指定的行为可由 Intent 附带的 Activity 启动标志替代，下文将对此进行讨论。

## 使用 Intent 标志

启动 Activity 时，您可以通过在传递给[startActivity()](https://developer.android.com/reference/android/app/Activity.html?hl=zh-cn#startActivity(android.content.Intent))的 Intent 中加入相应的标志，修改 Activity 与其任务的默认关联方式。可用于修改默认行为的标志包括：

[FLAG_ACTIVITY_NEW_TASK](https://developer.android.com/reference/android/content/Intent.html?hl=zh-cn#FLAG_ACTIVITY_NEW_TASK)

在新任务中启动 Activity。如果已为正在启动的 Activity 运行任务，则该任务会转到前台并恢复其最后状态，同时 Activity 会在[onNewIntent()](https://developer.android.com/reference/android/app/Activity.html?hl=zh-cn#onNewIntent(android.content.Intent))中收到新 Intent。

正如前文所述，这会产生与"singleTask"[launchMode](https://developer.android.com/guide/topics/manifest/activity-element.html?hl=zh-cn#lmode)值相同的行为。

[FLAG_ACTIVITY_SINGLE_TOP](https://developer.android.com/reference/android/content/Intent.html?hl=zh-cn#FLAG_ACTIVITY_SINGLE_TOP)

如果正在启动的 Activity 是当前 Activity（位于返回栈的顶部），则 现有实例会接收对[onNewIntent()](https://developer.android.com/reference/android/app/Activity.html?hl=zh-cn#onNewIntent(android.content.Intent))的调用，而不是创建 Activity 的新实例。

正如前文所述，这会产生与"singleTop"[launchMode](https://developer.android.com/guide/topics/manifest/activity-element.html?hl=zh-cn#lmode)值相同的行为。

[FLAG_ACTIVITY_CLEAR_TOP](https://developer.android.com/reference/android/content/Intent.html?hl=zh-cn#FLAG_ACTIVITY_CLEAR_TOP)

如果正在启动的 Activity 已在当前任务中运行，则会销毁当前任务顶部的所有 Activity，并通过[onNewIntent()](https://developer.android.com/reference/android/app/Activity.html?hl=zh-cn#onNewIntent(android.content.Intent))将此 Intent 传递给 Activity 已恢复的实例（现在位于顶部），而不是启动该 Activity 的新实例。

产生这种行为的[launchMode](https://developer.android.com/guide/topics/manifest/activity-element.html?hl=zh-cn#lmode)属性没有值。

FLAG_ACTIVITY_CLEAR_TOP通常与FLAG_ACTIVITY_NEW_TASK结合使用。一起使用时，通过这些标志，可以找到其他任务中的现有 Activity，并将其放入可从中响应 Intent 的位置。

**注**：如果指定 Activity 的启动模式为"standard"，则该 Activity 也会从堆栈中移除，并在其位置启动一个新实例，以便处理传入的 Intent。 这是因为当启动模式为"standard"时，将始终为新 Intent 创建新实例。

## 处理关联

*“关联”*指示 Activity 优先属于哪个任务。默认情况下，同一应用中的所有 Activity 彼此关联。 因此，默认情况下，同一应用中的所有 Activity 优先位于相同任务中。 不过，您可以修改 Activity 的默认关联。 在不同应用中定义的 Activity 可以共享关联，或者可为在同一应用中定义的 Activity 分配不同的任务关联。

可以使用元素的[taskAffinity](https://developer.android.com/guide/topics/manifest/activity-element.html?hl=zh-cn#aff)属性修改任何给定 Activity 的关联。

[taskAffinity](https://developer.android.com/guide/topics/manifest/activity-element.html?hl=zh-cn#aff)属性取字符串值，该值必须不同于在元素中声明的默认软件包名称，因为系统使用该名称标识应用的默认任务关联。

在两种情况下，关联会起作用：

启动 Activity 的 Intent 包含[FLAG_ACTIVITY_NEW_TASK](https://developer.android.com/reference/android/content/Intent.html?hl=zh-cn#FLAG_ACTIVITY_NEW_TASK)标志。

默认情况下，新 Activity 会启动到调用[startActivity()](https://developer.android.com/reference/android/app/Activity.html?hl=zh-cn#startActivity(android.content.Intent))的 Activity 任务中。它将推入与调用方相同的返回栈。 但是，如果传递给[startActivity()](https://developer.android.com/reference/android/app/Activity.html?hl=zh-cn#startActivity(android.content.Intent))的 Intent 包含[FLAG_ACTIVITY_NEW_TASK](https://developer.android.com/reference/android/content/Intent.html?hl=zh-cn#FLAG_ACTIVITY_NEW_TASK)标志，则系统会寻找其他任务来储存新 Activity。这通常是新任务，但未做强制要求。 如果现有任务与新 Activity 具有相同关联，则会将 Activity 启动到该任务中。 否则，将开始新任务。

如果此标志导致 Activity 开始新任务，且用户按*“主页”*按钮离开，则必须为用户提供导航回任务的方式。 有些实体（如通知管理器）始终在外部任务中启动 Activity，而从不作为其自身的一部分启动 Activity，因此它们始终将FLAG_ACTIVITY_NEW_TASK放入传递给[startActivity()](https://developer.android.com/reference/android/app/Activity.html?hl=zh-cn#startActivity(android.content.Intent))的 Intent 中。请注意，如果 Activity 能够由可以使用此标志的外部实体调用，则用户可以通过独立方式返回到启动的任务，例如，使用启动器图标（任务的根 Activity 具有[CATEGORY_LAUNCHER](https://developer.android.com/reference/android/content/Intent.html?hl=zh-cn#CATEGORY_LAUNCHER)Intent 过滤器；请参阅下面的[启动任务](https://developer.android.com/guide/components/tasks-and-back-stack.html?hl=zh-cn#Starting)部分）。

Activity 将其[allowTaskReparenting](https://developer.android.com/guide/topics/manifest/activity-element.html?hl=zh-cn#reparent)属性设置为"true"。

在这种情况下，Activity 可以从其启动的任务移动到与其具有关联的任务（如果该任务出现在前台）。

例如，假设将报告所选城市天气状况的 Activity 定义为旅行应用的一部分。 它与同一应用中的其他 Activity 具有相同的关联（默认应用关联），并允许利用此属性重定父级。当您的一个 Activity 启动天气预报 Activity 时，它最初所属的任务与您的 Activity 相同。 但是，当旅行应用的任务出现在前台时，系统会将天气预报 Activity 重新分配给该任务并显示在其中。

**提示**：如果从用户的角度来看，一个.apk文件包含多个“应用”，则您可能需要使用[taskAffinity](https://developer.android.com/guide/topics/manifest/activity-element.html?hl=zh-cn#aff)属性将不同关联分配给与每个“应用”相关的 Activity。

## 清理返回栈

如果用户长时间离开任务，则系统会清除所有 Activity 的任务，根 Activity 除外。 当用户再次返回到任务时，仅恢复根 Activity。系统这样做的原因是，经过很长一段时间后，用户可能已经放弃之前执行的操作，返回到任务是要开始执行新的操作。

您可以使用下列几个 Activity 属性修改此行为：

[alwaysRetainTaskState](https://developer.android.com/guide/topics/manifest/activity-element.html?hl=zh-cn#always)

如果在任务的根 Activity 中将此属性设置为"true"，则不会发生刚才所述的默认行为。即使在很长一段时间后，任务仍将所有 Activity 保留在其堆栈中。

[clearTaskOnLaunch](https://developer.android.com/guide/topics/manifest/activity-element.html?hl=zh-cn#clear)

如果在任务的根 Activity 中将此属性设置为"true"，则每当用户离开任务然后返回时，系统都会将堆栈清除到只剩下根 Activity。 换而言之，它与[alwaysRetainTaskState](https://developer.android.com/guide/topics/manifest/activity-element.html?hl=zh-cn#always)正好相反。 即使只离开任务片刻时间，用户也始终会返回到任务的初始状态。

[finishOnTaskLaunch](https://developer.android.com/guide/topics/manifest/activity-element.html?hl=zh-cn#finish)

此属性类似于[clearTaskOnLaunch](https://developer.android.com/guide/topics/manifest/activity-element.html?hl=zh-cn#clear)，但它对单个 Activity 起作用，而非整个任务。 此外，它还有可能会导致任何 Activity 停止，包括根 Activity。 设置为"true"时，Activity 仍是任务的一部分，但是仅限于当前会话。如果用户离开然后返回任务，则任务将不复存在。

启动任务

通过为 Activity 提供一个以"android.intent.action.MAIN"为指定操作、以"android.intent.category.LAUNCHER"为指定类别的 Intent 过滤器，您可以将 Activity 设置为任务的入口点。 例如：

...

此类 Intent 过滤器会使 Activity 的图标和标签显示在应用启动器中，让用户能够启动 Activity 并在启动之后随时返回到创建的任务中。

第二个功能非常重要：用户必须能够在离开任务后，再使用此 Activity 启动器返回该任务。 因此，只有在 Activity 具有[ACTION_MAIN](https://developer.android.com/reference/android/content/Intent.html?hl=zh-cn#ACTION_MAIN)和[CATEGORY_LAUNCHER](https://developer.android.com/reference/android/content/Intent.html?hl=zh-cn#CATEGORY_LAUNCHER)过滤器时，才应该使用将 Activity 标记为“始终启动任务”的两种[启动模式](https://developer.android.com/guide/components/tasks-and-back-stack.html?hl=zh-cn#LaunchModes)，即"singleTask"和"singleInstance"。例如，我们可以想像一下如果缺少过滤器会发生什么情况： Intent 启动一个"singleTask"Activity，从而启动一个新任务，并且用户花了些时间处理该任务。然后，用户按*“主页”*按钮。 任务现已发送到后台，而且不可见。现在，用户无法返回到任务，因为该任务未显示在应用启动器中。

如果您并不想用户能够返回到 Activity，对于这些情况，请将元素的[finishOnTaskLaunch](https://developer.android.com/guide/topics/manifest/activity-element.html?hl=zh-cn#finish)设置为"true"（请参阅[清理堆栈](https://developer.android.com/guide/components/tasks-and-back-stack.html?hl=zh-cn#Clearing)）。

有关如何在概览屏幕中显示和管理任务与 Activity 的更多信息，请参阅[概览屏幕](https://developer.android.com/guide/components/recents.html?hl=zh-cn)。











