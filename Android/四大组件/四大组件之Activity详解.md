## **Activity简介**

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

你必须实现这个在系统第一次创建Activity时就会激发的方法。在创建一个Activity时，该Activity就会进入创建状态（created state）。在onCreate()方法中，应执行在整个生命周期中仅发生一次的基础的应用启动逻辑。比如你的onCreate()方法实现绑定了列表数据，初始化后台线程，实例化某些类范畴的变量。该方法接收一个savedInstanceState参数，该参数是一个保存了Activity之前状态的[Bundle](https://developer.android.com/reference/android/os/Bundle.html)对象。如果该Activity还未存在过，该参数值就为null。

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

可以不使用定义XML文件并将它传递给setContentView()的方式，而是在Activity代码中创建View对象，通过向ViewGroup中插入新建的View来建立一个View层级，然后将根ViewGroup传递给setContentView()来使用在代码中定义的布局。不过Android推荐在XML文件定义布局资源。

Activity不会一直处于创建状态（created state）。在onCreate()方法完成执行后，Activity进入启动状态（started state），系统将快速连续调用onStart()方法和onResume()方法。

##### [**onStart()**](https://developer.android.com/reference/android/app/Activity.html#onStart())

当Activity进入开始状态（started state）时，系统将回调该方法。随着应用准备将该Activity放入前台变成可以交互的，回调onStart()方法就会将Activity显示给用户。例如，该方法是应用初始化维护UI的代码的地方，它也可能注册一个BroadcastReceiver来监听UI中反应的变化。

onStart()方法完成地非常迅速，如创建状态（created state）一样，Activity也不会驻留在开始状态（started state）。一旦该回调完成，Activity就进入恢复状态（resumed state）而调用onResume()方法。

##### [**onResume()**](https://developer.android.com/reference/android/app/Activity.html#onResume())

当Activity进入恢复状态（resumed  state）时会到前台来，然后系统调用onResume()回调方法。在该状态下，应用可以和用户进行交互。直到发生一些将焦点从该Activity上移走的事情，否则，该Activity就一直处于该状态。这些事情可能是，比如接到一个电话，用户导航到其他Activity上，或者设备的屏幕关闭了。

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

系统将调用该方法作为用户离开当前Activity时的第一回应（但并不意味这该Activity被销毁了）。使用onPause()方法来暂停诸如动画和音乐播放的操作，这些操作不应该在该Activity处于暂停状态（paused state）时仍然继续执行，在这种状态下可以立即进入恢复状态。Activity会进入该状态有几种原因，如：

- 某些事件中断了应用的运行，这是最常见的情形；
- 在Android 7.0 （API level 24）或更高版本中，多个应用运行在多个窗口模式下。因为任何时候只有一个应用（窗口）具有焦点，系统暂停其他所有应用；
- 一个新的、半透明的Activity（如对话框）打开了。只要一个Activity部分可见但是没有焦点，它就处于暂停状态。

你可以使用onPause()方法来释放系统资源，比如广播提供者（broadcast receiver），传感器（想GPS）的句柄，或者其他可影响电池续航的资源，当Activity处于暂停状态时，用户就不要这些资源了。

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

onPause()的执行很简洁，没必要提供足够的时间来执行存保存操作。出于这个原因，你不应该使用onPause()方法来保存数据。而是在onStop()中执行重载的关闭操作。

onPause()方法完成后并不意味着该Activity离开了暂停状态。确切地说，Activity依然处于该状态，直到该Activity恢复或变成完全不可见。如果Activity恢复了，系统再次调用onResume()回调。如果Activity从暂停状态回到恢复状态，系统将Activity实例保留在内存中，当系统调用onResume()方法时会再次调用该Activity实例。在这种情形中，你不用再次初始化任何在回调方法中创建的组件，这些回调方法可以让Activity进入恢复状态。如果Activity完全不可见，系统会调用onStop()方法。

##### [**onStop()**](https://developer.android.com/reference/android/app/Activity.html#onStop())

当你的Activity对用户不可见时，该Activity就已进入停止状态（stopped state）了，系统也会调用onStop()回调方法。这可能在，比如当一个新启动的Activity覆盖了整个屏幕时发生。系统可能也会在Activity结束运行、将要被终止（terminate的）时调用onStop()方法。

在onStop()方法中，应用应该在用户不使用它时释放几乎所有不需要的资源。例如，如果你在onStart()方法中注册了一个BroadcastReceiver来监听可能影响UI的变化，你可以在onStop()中移出该BroadcastReceiver的注册，因为用户再也看不到UI了。使用onStop()释放可能泄露内存的资源也很重要，因为系统可能在不调用onDestroy()的情况下杀掉持有Activity的进程。

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

**注意：** 一旦Activity被停止，如果系统需要回收内存，那么系统可能销毁包含该Activity的进程。即使系统在该Activity被停止时销毁了其所在进程，系统仍会将View对象的状态（如EditText部件中的文本）保留到一个Bundle对象（以key-value对的形式）中，如果用户在回到该Activity时恢复就恢复保留到Bundle对象中的数据。

Activity从停止状态上不是回来和用户交互，就是完成其运行后消失。如果Activity回来了，系统就调用onRestart()方法。如果Activity完成了运行，系统就调用onDestroy()方法。

##### [**onDestroy()**](https://developer.android.com/reference/android/app/Activity.html#onDestroy())

在Activity销毁之前会回调该方法。这是Activity接收到的最终调用。系统回调该方法不是由于调用了[finish()](https://developer.android.com/reference/android/app/Activity.html#finish())方法，该Activity正在结束，就是因为系统临时销毁了包含Activity的进程来节约内存空间。可以通过[isFinishing()](https://developer.android.com/reference/android/app/Activity.html#isFinishing())方法来区分这两种情形。系统也会在方向改变时调用onDestroy()方法，然后立即调用onCreate()方法来重新创建在新方向上的进程（和Activity所含的组件）。

onDestroy()回调会释放所有在之前回调（如onStop()）中还未释放的资源。

### **Activity状态和退出内存**

系统从来不会直接杀掉Activity。而是杀掉运行Activity的进程，不仅销毁Activity，而且也销毁运行在该进程中的一切。

当系统需要释放RAM时就会杀掉进程

The system never kills an activity directly. Instead, it kills the process in which the activity runs, destroying not only the activity but everything else running in the process, as well.

The system kills processes when it needs to free up RAM; the likelihood of its killing a given process depends on the state of the process at the time. Process state, in turn, depends on the state of the activity running in the process.

A user can also kill a process by using the Application Manager under Settings to kill the corresponding app.

Table 1 shows the correlation among process state, activity state, and likelihood of the system’s killing the process.

| Likelihood of being killed | Process state                            | Activity state        |
| -------------------------- | ---------------------------------------- | --------------------- |
| Least                      | Foreground (having or about to get focus) | CreatedStartedResumed |
| More                       | Background (lost focus)                  | Paused                |
| Most                       | Background (not visible)                 | Stopped               |
| Empty                      | Destroyed                                |                       |

Table 1. Relationship between process lifecycle and activity state

For more information about processes in general, see [Processes and Threads](https://developer.android.com/guide/components/processes-and-threads.html). For more information about how the lifecycle of a process is tied to the states of the activities in it, see the [Process Lifecycle](https://developer.android.com/guide/components/processes-and-threads.html#Lifecycle) section of that page.

## Navigating between activities

------

An app is likely to enter and exit an activity, perhaps many times, during the app’s lifetime. For example, the user may tap the device’s Back button, or the activity may need to launch a different activity. This section covers topics you need to know to implement successful activity transitions. These topics include starting an activity from another activity, saving activity state, and restoring activity state.

### Starting one activity from another

An activity often needs to start another activity at some point. This need arises, for instance, when an app needs to move from the current screen to a new one.

Depending on whether your activity wants a result back from the new activity it’s about to start, you start the new activity using either the`startActivity()` or the `startActivityForResult()` method. In either case, you pass in an `Intent` object.

The `Intent` object specifies either the exact activity you want to start or describes the type of action you want to perform (and the system selects the appropriate activity for you, which can even be from a different application). An `Intent` object can also carry small amounts of data to be used by the activity that is started. For more information about the `Intent` class, see [Intents and Intent Filters](https://developer.android.com/guide/components/intents-filters.html).

#### startActivity()

If the newly started activity does not need to return a result, the current activity can start it by calling the `startActivity()` method.

When working within your own application, you often need to simply launch a known activity. For example, the following code snippet shows how to launch an activity called `SignInActivity`.

```
Intent intent = new Intent(this, SignInActivity.class);
startActivity(intent);
```

Your application might also want to perform some action, such as send an email, text message, or status update, using data from your activity. In this case, your application might not have its own activities to perform such actions, so you can instead leverage the activities provided by other applications on the device, which can perform the actions for you. This is where intents are really valuable: You can create an intent that describes an action you want to perform and the system launches the appropriate activity from another application. If there are multiple activities that can handle the intent, then the user can select which one to use. For example, if you want to allow the user to send an email message, you can create the following intent:

```
Intent intent = new Intent(Intent.ACTION_SEND);
intent.putExtra(Intent.EXTRA_EMAIL, recipientArray);
startActivity(intent);
```

The `EXTRA_EMAIL` extra added to the intent is a string array of email addresses to which the email should be sent. When an email application responds to this intent, it reads the string array provided in the extra and places them in the "to" field of the email composition form. In this situation, the email application's activity starts and when the user is done, your activity resumes.

#### startActivityForResult()

Sometimes you want to get a result back from an activity when it ends. For example, you may start an activity that lets the user pick a person in a list of contacts; when it ends, it returns the person that was selected. To do this, you call the `startActivityForResult(Intent, int)` method, where the integer parameter identifies the call. This identifier is meant to disambiguate between multiple calls to `startActivityForResult(Intent, int)` from the same activity. It's not global identifier and is not at risk of conflicting with other apps or activities.The result comes back through your`onActivityResult(int, int, Intent)` method.

When a child activity exits, it can call `setResult(int)` to return data to its parent. The child activity must always supply a result code, which can be the standard results `RESULT_CANCELED`, `RESULT_OK`, or any custom values starting at `RESULT_FIRST_USER`. In addition, the child activity can optionally return an `Intent` object containing any additional data it wants. The parent activity uses the `onActivityResult(int, int, Intent)` method, along with the integer identifier the parent activity originally supplied, to receive the information.

If a child activity fails for any reason, such as crashing, the parent activity receives a result with the code `RESULT_CANCELED`.

```
 public class MyActivity extends Activity {
     ...

     static final int PICK_CONTACT_REQUEST = 0;

     public boolean onKeyDown(int keyCode, KeyEvent event) {
         if (keyCode == KeyEvent.KEYCODE_DPAD_CENTER) {
             // When the user center presses, let them pick a contact.
             startActivityForResult(
                 new Intent(Intent.ACTION_PICK,
                 new Uri("content://contacts")),
                 PICK_CONTACT_REQUEST);
            return true;
         }
         return false;
     }

     protected void onActivityResult(int requestCode, int resultCode,
             Intent data) {
         if (requestCode == PICK_CONTACT_REQUEST) {
             if (resultCode == RESULT_OK) {
                 // A contact was picked.  Here we will just display it
                 // to the user.
                 startActivity(new Intent(Intent.ACTION_VIEW, data));
             }
         }
     }
 }
```

#### Coordinating activities

When one activity starts another, they both experience lifecycle transitions. The first activity stops operating and enters the Paused or Stopped state, while the other activity is created. In case these activities share data saved to disc or elsewhere, it's important to understand that the first activity is not completely stopped before the second one is created. Rather, the process of starting the second one overlaps with the process of stopping the first one.

The order of lifecycle callbacks is well defined, particularly when the two activities are in the same process (app) and one is starting the other. Here's the order of operations that occur when Activity A starts Acivity B:

1. Activity A's `onPause()` method executes.
2. Activity B's `onCreate()`, `onStart()`, and `onResume()` methods execute in sequence. (Activity B now has user focus.)
3. Then, if Activity A is no longer visible on screen, its `onStop()` method executes.

This predictable sequence of lifecycle callbacks allows you to manage the transition of information from one activity to another.

### Saving and restoring activity state

There are a few scenarios in which your activity is destroyed due to normal app behavior, such as when the user presses the Back button or your activity signals its own destruction by calling the `finish()` method. The system may also destroy the process containing your activity to recover memory if the activity is in the Stopped state and hasn't been used in a long time, or if the foreground activity requires more resources.

When your activity is destroyed because the user presses Back or the activity finishes itself, the system's concept of that `Activity` instance is gone forever because the behavior indicates the activity is no longer needed. However, if the system destroys the activity due to system constraints (rather than normal app behavior), then although the actual `Activity` instance is gone, the system remembers that it existed such that if the user navigates back to it, the system creates a new instance of the activity using a set of saved data that describes the state of the activity when it was destroyed. The saved data that the system uses to restore the previous state is called the *instance state* and is a collection of key-value pairs stored in a `Bundle` object.

By default, the system uses the `Bundle` instance state to save information about each `View` object in your activity layout (such as the text value entered into an `EditText` widget). So, if your activity instance is destroyed and recreated, the state of the layout is restored to its previous state with no code required by you. However, your activity might have more state information that you'd like to restore, such as member variables that track the user's progress in the activity.

#### Save your activity state

As your activity begins to stop, the system calls the `onSaveInstanceState()` method so your activity can save state information with a collection of key-value pairs. The default implementation of this method saves transient information about the state of the activity's view hierarchy, such as the text in an `EditText` widget or the scroll position of a `ListView` widget. Your app should implement the `onSaveInstanceState()` callback *after* the `onPause()`method, and *before* `onStop()`. Do not implement this callback in `onPause()`.

**Caution:** You must always call the superclass implementation of `onSaveInstanceState()` so the default implementation can save the state of the view hierarchy.

To save additional state information for your activity, you must override `onSaveInstanceState()` and add key-value pairs to the `Bundle` object that is saved in the event that your activity is destroyed unexpectedly. For example:

```
static final String STATE_SCORE = "playerScore";
static final String STATE_LEVEL = "playerLevel";
...


#64;Override
public void onSaveInstanceState(Bundle savedInstanceState) {
    // Save the user's current game state
    savedInstanceState.putInt(STATE_SCORE, mCurrentScore);
    savedInstanceState.putInt(STATE_LEVEL, mCurrentLevel);


    // Always call the superclass so it can save the view hierarchy state
    super.onSaveInstanceState(savedInstanceState);
}
```

**Note: **In order for the Android system to restore the state of the views in your activity, each view must have a unique ID, supplied by the `android:id`attribute.

To save persistent data, such as user preferences or data for a database, you should take appropriate opportunities when your activity is in the foreground. If no such opportunity arises, you should save such data during the `onStop()` method.

#### Restore your activity state

When your activity is recreated after it was previously destroyed, you can recover your saved state from the `Bundle` that the system passes to your activity. Both the `onCreate()` and `onRestoreInstanceState()` callback methods receive the same `Bundle` that contains the instance state information.

Because the `onCreate()` method is called whether the system is creating a new instance of your activity or recreating a previous one, you must check whether the state Bundle is null before you attempt to read it. If it is null, then the system is creating a new instance of the activity, instead of restoring a previous one that was destroyed.

For example, the following code snippet shows how you can restore some state data in `onCreate()`:

```
#64;Override
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

Instead of restoring the state during `onCreate()` you may choose to implement `onRestoreInstanceState()`, which the system calls after the `onStart()`method. The system calls `onRestoreInstanceState()` only if there is a saved state to restore, so you dodefault not need to check whether the `Bundle` is null:

```
public void onRestoreInstanceState(Bundle savedInstanceState) {
    // Always call the superclass so it can restore the view hierarchy
    super.onRestoreInstanceState(savedInstanceState);


    // Restore state members from saved instance
    mCurrentScore = savedInstanceState.getInt(STATE_SCORE);
    mCurrentLevel = savedInstanceState.getInt(STATE_LEVEL);
}
```

Caution: Always call the superclass implementation of `onRestoreInstanceState()` so the default implementation can restore the state of the view hierarchy.



### **启动 Activity**

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

### **启动 Activity 以获得结果**

有时，您可能需要从启动的 Activity 获得结果。在这种情况下，请通过调用 [Activity.startActivityForResult()](https://developer.android.com/reference/android/app/Activity.html#startActivityForResult(android.content.Intent, int))（而非 startActivity()）来启动 Activity。 要想在随后收到后续 Activity 的结果，请实现 [Activity.onActivityResult()](https://developer.android.com/reference/android/app/Activity.html#onActivityResult(int, int, android.content.Intent)) 回调方法。 当后续 Activity 完成时，它会使用 Intent 向您的 onActivityResult() 方法返回结果。

例如，您可能希望用户选取其中一位联系人，以便您的 Activity 对该联系人中的信息执行某项操作。 您可以通过以下代码创建此类 Intent 并处理结果：

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

上例显示的是，您在处理 Activity 结果时应该在 onActivityResult() 方法中使用的基本逻辑。 第一个条件检查请求是否成功（如果成功，则 resultCode 将为 [RESULT_OK](https://developer.android.com/reference/android/app/Activity.html#RESULT_OK) 以及此结果响应的请求是否已知 ——在此情况下，requestCode 与随 startActivityForResult()发送的第二个参数匹配。 代码通过查询 Intent中返回的数据（data参数）从该处开始处理 Activity 结果。

实际情况是，[ContentResolver](https://developer.android.com/reference/android/content/ContentResolver.html) 对一个内容提供程序执行查询，后者返回一个 [Cursor](https://developer.android.com/reference/android/database/Cursor.html)，让查询的数据能够被读取。

### **结束 Activity**

您可以通过调用 Activity 的 [Activity.finish()](https://developer.android.com/reference/android/app/Activity.html#finish()) 方法来结束该 Activity。您还可以通过调用 [Activity.finishActivity()](https://developer.android.com/reference/android/app/Activity.html#finishActivity(int)) 结束您之前启动的另一个 Activity。

**注**：在大多数情况下，您**不应使用这些方法显式结束 Activity**。 正如下文有关 Activity 生命周期的部分所述，**Android 系统会为您管理 Activity 的生命周期，因此您无需结束自己的 Activity**。 调用这些方法可能对预期的用户体验产生不良影响，因此**只应在您确实不想让用户返回此 Activity 实例时使用**。

### **管理 Activity 生命周期**

通过实现回调方法管理 Activity 的生命周期对开发强大而又灵活的应用至关重要。 Activity 的生命周期会直接受到 Activity 与其他 Activity、其任务及返回栈的关联性的影响。

Activity 基本上以三种状态存在：

- 继续：此 Activity 位于屏幕前台并具有用户焦点。（有时也将此状态称作“运行中”。）
- 暂停：另一个 Activity 位于屏幕前台并具有用户焦点，但此 Activity 仍可见。也就是说，另一个 Activity 显示在此 Activity 上方，并且该 Activity 部分透明或未覆盖整个屏幕。 暂停的 Activity 处于完全活动状态（Activity对象保留在内存中，它保留了所有状态和成员信息，并与窗口管理器保持连接），但在内存极度不足的情况下，可能会被系统终止。
- 停止：该 Activity 被另一个 Activity 完全遮盖（该 Activity 目前位于“后台”）。 已停止的 Activity 同样仍处于活动状态（Activity对象保留在内存中，它保留了所有状态和成员信息，但未与窗口管理器（WindowManager）连接）。 不过，它对用户不再可见，在他处需要内存时可能会被系统终止。

如果 Activity 处于暂停或停止状态，系统可通过要求其结束（调用其 finish() 方法）或直接终止其进程，将其从内存中删除。（将其结束或终止后）再次打开 Activity 时，必须重建。

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

**注**：正如以上示例所示，您在实现这些生命周期方法时必须始终先调用超类实现，然后再执行任何操作。

这些方法共同定义 Activity 的整个生命周期。您可以通过实现这些方法监控 Activity 生命周期中的三个嵌套循环：

- Activity 的**整个生命周期**发生在 [onCreate()](https://developer.android.com/reference/android/app/Activity.html#onCreate(android.os.Bundle)) 调用与 onDestroy()调用之间。您的 Activity 应在 onCreate()中执行“全局”状态设置（例如定义布局），并释放 onDestroy() 中的所有其余资源。例如，如果您的 Activity 有一个在后台运行的线程，用于从网络上下载数据，它可能会在onCreate()中创建该线程，然后在 onDestroy()中停止该线程。
- Activity 的**可见生命周期**发生在 onStart() 调用与 onStop() 调用之间。在这段时间，用户可以在屏幕上看到 Activity 并与其交互。 例如，当一个新 Activity 启动，并且此 Activity 不再可见时，系统会调用 onStop()。您可以在调用这两个方法之间保留向用户显示 Activity 所需的资源。 例如，您可以在 onStart()中注册一个 BroadcastReceiver以监控影响 UI 的变化，并在用户无法再看到您显示的内容时在 onStop()中将其取消注册。在 Activity 的整个生命周期，当 Activity 在对用户可见和隐藏两种状态中交替变化时，系统可能会多次调用 onStart() 和 onStop()。
- Activity 的**前台生命周期**发生在 onResume()调用与 onPause()调用之间。在这段时间，Activity 位于屏幕上的所有其他 Activity 之前，并具有用户输入焦点。 Activity 可频繁转入和转出前台 — 例如，当设备转入休眠状态或出现对话框时，系统会调用 onPause()。 由于此状态可能经常发生转变，因此这两个方法中应采用适度轻量级的代码，以避免因转变速度慢而让用户等待。

下图说明了这些循环以及 Activity 在状态转变期间可能经过的路径。矩形表示回调方法，当 Activity 在不同状态之间转变时，您可以实现这些方法来执行操作。



表 1 列出了相同的生命周期回调方法，其中对每一种回调方法做了更详细的描述，并说明了每一种方法在 Activity 整个生命周期内的位置，包括在回调方法完成后系统能否终止 Activity。
**表 1.** Activity 生命周期回调方法汇总表。

| 方法          | 说明                                       | 是否能事后终止？ | 后接                      |
| ----------- | ---------------------------------------- | -------- | ----------------------- |
| onCreate()  | 首次创建 Activity 时调用。 您应该在此方法中执行所有正常的静态设置 — 创建视图、将数据绑定到列表等等。 系统向此方法传递一个 Bundle 对象，其中包含 Activity 的上一状态，不过前提是捕获了该状态。始终后接 onStart()。 | 否        | onStart()               |
| onRestart() | 在 Activity 已停止并即将再次启动前调用。始终后接 onStart()  | 否        | onStart()               |
| onStart()   | 在 Activity 即将对用户可见之前调用。如果 Activity 转入前台，则后接 onResume()，如果 Activity 转入隐藏状态，则后接 onStop()。 | 否        | onResume()或onStop()     |
| onResume()  | 在 Activity 即将开始与用户进行交互之前调用。 此时，Activity 处于 Activity 堆栈的顶层，并具有用户输入焦点。始终后接 onPause()。 | 否        | onPause()               |
| onPause()   | 当系统即将开始继续另一个 Activity 时调用。 此方法通常用于确认对持久性数据的未保存更改、停止动画以及其他可能消耗 CPU 的内容，诸如此类。 它应该非常迅速地执行所需操作，因为它返回后，下一个 Activity 才能继续执行。如果 Activity 返回前台，则后接 onResume()，如果 Activity 转入对用户不可见状态，则后接 onStop() | **是**    | onResume()或onStop()     |
| onStop()    | 在 Activity 对用户不再可见时调用。如果 Activity 被销毁，或另一个 Activity（一个现有 Activity 或新 Activity）继续执行并将其覆盖，就可能发生这种情况。如果 Activity 恢复与用户的交互，则后接 onRestart()，如果 Activity 被销毁，则后接onDestroy()。 | **是**    | onRestart()或onDestroy() |
| onDestroy() | 在 Activity 被销毁前调用。这是 Activity 将收到的最后调用。 当 Activity 结束（有人对 Activity 调用了 finish()），或系统为节省空间而暂时销毁该 Activity 实例时，可能会调用它。 您可以通过 isFinishing()方法区分这两种情形。 | **是**    | *无*                     |

名为“是否能事后终止？”的列表示系统是否能在不执行另一行 Activity 代码的情况下，在*方法返回后*随时终止承载 Activity 的进程。 有三个方法带有“是”标记：(onPause()、onStop()和 onDestroy()
)。由于 onPause()是这三个方法中的第一个，因此 Activity 创建后，onPause()必定成为最后调用的方法，然后才能终止进程 — 如果系统在紧急情况下必须恢复内存，则可能不会调用 onStop()和 onDestroy()。**因此，您应该使用 onPause()向存储设备写入至关重要的持久性数据（例如用户编辑）。不过，您应该对 onPause()调用期间必须保留的信息有所选择，因为该方法中的任何阻止过程都会妨碍向下一个 Activity 的转变并拖慢用户体验。在**是否能在事后终止？**列中标记为“否”的方法可从系统调用它们的一刻起防止承载 Activity 的进程被终止。 因此，在从 onPause()返回的时间到 onResume()被调用的时间，系统可以终止 Activity。在 onPause()被再次调用并返回前，将无法再次终止 Activity。 **注**：根据表 1 中的定义属于技术上无法“终止”的 Activity 仍可能被系统终止 — 但这种情况只有在无任何其他资源的极端情况下才会发生。[进程和线程处理](https://developer.android.com/guide/components/processes-and-threads.html)文档对可能会终止 Activity 的情况做了更详尽的阐述。

### **保存 Activity 状态**

管理 Activity 生命周期的引言部分简要提及，当 Activity 暂停或停止时，Activity 的状态会得到保留。 确实如此，因为当 Activity 暂停或停止时，Activity对象仍保留在内存中 — 有关其成员和当前状态的所有信息仍处于活动状态。 因此，用户在 Activity 内所做的任何更改都会得到保留，这样一来，当 Activity 返回前台（当它“继续”）时，这些更改仍然存在。
不过，当系统为了恢复内存而销毁某项 Activity 时，Activity对象也会被销毁，因此系统在继续 Activity 时根本无法让其状态保持完好，而是必须在用户返回 Activity 时重建 Activity对象。但用户并不知道系统销毁 Activity 后又对其进行了重建，因此他们很可能认为 Activity 状态毫无变化。 在这种情况下，您可以实现另一个回调方法对有关 Activity 状态的信息进行保存，以确保有关 Activity 状态的重要信息得到保留：onSaveInstanceState()。
系统会先调用 onSaveInstanceState()，然后再使 Activity 变得易于销毁。系统会向该方法传递一个 Bundle，您可以在其中使用 putString()和 putInt()等方法以名称-值对形式保存有关 Activity 状态的信息。然后，如果系统终止您的应用进程，并且用户返回您的 Activity，则系统会重建该 Activity，并将 Bundle同时传递给 onCreate()和 onRestoreInstanceState()。您可以使用上述任一方法从 Bundle提取您保存的状态并恢复该 Activity 状态。如果没有状态信息需要恢复，则传递给您的 Bundle是空值（如果是首次创建该 Activity，就会出现这种情况）。

![img](https://developer.android.com/images/fundamentals/restore_instance.png)

**图 2.** 在两种情况下，Activity 重获用户焦点时可保持状态完好：系统在销毁 Activity 后重建 Activity，Activity 必须恢复之前保存的状态；系统停止 Activity 后继续执行 Activity，并且 Activity 状态保持完好。
**注**：无法保证系统会在销毁您的 Activity 前调用 onSaveInstanceState()，因为存在不需要保存状态的情况（例如用户使用“返回”按钮离开您的 Activity 时，因为用户的行为是在显式关闭 Activity）。 **如果系统调用 onSaveInstanceState()，它会在调用 onStop()之前，并且可能会在调用 onPause()之前进行调用。
不过，即使您什么都不做，也不实现 onSaveInstanceState()，Activity类的 onSaveInstanceState()默认实现也会恢复部分 Activity 状态。具体地讲，默认实现会为布局中的每个 View调用相应的 onSaveInstanceState()方法，让每个视图都能提供有关自身的应保存信息。Android 框架中几乎每个小部件都会根据需要实现此方法，以便在重建 Activity 时自动保存和恢复对 UI 所做的任何可见更改。例如，EditText小部件保存用户输入的任何文本，CheckBox小部件保存复选框的选中或未选中状态。您只需为想要保存其状态的每个小部件提供一个唯一的 ID（通过 android:id属性）。如果小部件没有 ID，则系统无法保存其状态。
您还可以通过将android:saveEnabled属性设置为 "false"
或通过调用 setSaveEnabled()方法显式阻止布局内的视图保存其状态。您通常不应将该属性停用，但如果您想以不同方式恢复 Activity UI 的状态，就可能需要这样做。

尽管 onSaveInstanceState()的默认实现会保存有关您的Activity UI 的有用信息，您可能仍需替换它以保存更多信息。例如，您可能需要保存在 Activity 生命周期内发生了变化的成员值（它们可能与 UI 中恢复的值有关联，但默认情况下系统不会恢复储存这些 UI 值的成员）。
由于 onSaveInstanceState()的默认实现有助于保存 UI 的状态，因此如果您为了保存更多状态信息而替换该方法，应始终先调用 onSaveInstanceState()的超类实现，然后再执行任何操作。 同样，如果您替换 onRestoreInstanceState()方法，也应调用它的超类实现，以便默认实现能够恢复视图状态。
**注**：由于无法保证系统会调用 onSaveInstanceState()，因此您只应利用它来记录 Activity 的瞬态（UI 的状态）— 切勿使用它来存储持久性数据，而应使用 onPause()在用户离开 Activity 后存储持久性数据（例如应保存到数据库的数据）。
您只需旋转设备，让屏幕方向发生变化，就能有效地测试您的应用的状态恢复能力。 当屏幕方向变化时，系统会销毁并重建 Activity，以便应用可供新屏幕配置使用的备用资源。 单凭这一理由，您的 Activity 在重建时能否完全恢复其状态就显得非常重要，因为用户在使用应用时经常需要旋转屏幕。

### **处理配置变更**

有些设备配置可能会在运行时发生变化（例如屏幕方向、键盘可用性及语言）。 发生此类变化时，Android 会重建运行中的 Activity（系统调用onDestroy()，然后立即调用 onCreate()）。此行为旨在通过利用您提供的备用资源（例如适用于不同屏幕方向和屏幕尺寸的不同布局）自动重新加载您的应用来帮助它适应新配置。
如果您对 Activity 进行了适当设计，让它能够按以上所述处理屏幕方向变化带来的重启并恢复 Activity 状态，那么在遭遇 Activity 生命周期中的其他意外事件时，您的应用将具有更强的适应性。
正如上文所述，处理此类重启的最佳方法是利用onSaveInstanceState()和 onRestoreInstanceState()（或 onCreate()）保存并恢复 Activity 的状态。

### **协调 Activity**

当一个 Activity 启动另一个 Activity 时，它们都会体验到生命周期转变。第一个 Activity 暂停并停止（但如果它在后台仍然可见，则不会停止）时，同时系统会创建另一个 Activity。 如果这些 Activity 共用保存到磁盘或其他地方的数据，必须了解的是，在创建第二个 Activity 前，第一个 Activity 不会完全停止。更确切地说，启动第二个 Activity 的过程与停止第一个 Activity 的过程存在重叠。
生命周期回调的顺序经过明确定义，当两个 Activity 位于同一进程，并且由一个 Activity 启动另一个 Activity 时，其定义尤其明确。 以下是当 Activity A 启动 Activity B 时一系列操作的发生顺序：
Activity A 的 onPause()方法执行。
Activity B 的 onCreate()、onStart()和 onResume()方法依次执行。（Activity B 现在具有用户焦点。）
然后，如果 Activity A 在屏幕上不再可见，则其 onStop()方法执行。

您可以利用这种可预测的生命周期回调顺序管理从一个 Activity 到另一个 Activity 的信息转变。 例如，如果您必须在第一个 Activity 停止时向数据库写入数据，以便下一个 Activity 能够读取该数据，则应在 onPause()而不是 onStop()执行期间向数据库写入数据。

\<activity>

语法：

```xml
<activity android:allowEmbedded=["true" | "false"]
          android:allowTaskReparenting=["true" | "false"]
          android:alwaysRetainTaskState=["true" | "false"]
          android:autoRemoveFromRecents=["true" | "false"]
          android:banner="drawable resource"
          android:clearTaskOnLaunch=["true" | "false"]
          android:configChanges=["mcc", "mnc", "locale",
                                 "touchscreen", "keyboard", "keyboardHidden",
                                 "navigation", "screenLayout", "fontScale",
                                 "uiMode", "orientation", "screenSize",
                                 "smallestScreenSize"]
          android:documentLaunchMode=["intoExisting" | "always" |
                                  "none" | "never"]
          android:enabled=["true" | "false"]
          android:excludeFromRecents=["true" | "false"]
          android:exported=["true" | "false"]
          android:finishOnTaskLaunch=["true" | "false"]
          android:hardwareAccelerated=["true" | "false"]
          android:icon="drawable resource"
          android:label="string resource"
          android:launchMode=["standard" | "singleTop" |
                              "singleTask" | "singleInstance"]
          android:maxRecents="integer"
          android:multiprocess=["true" | "false"]
          android:name="string"
          android:noHistory=["true" | "false"]  
          android:parentActivityName="string" 
          android:permission="string"
          android:process="string"
          android:relinquishTaskIdentity=["true" | "false"]
          android:resizeableActivity=["true" | "false"]
          android:screenOrientation=["unspecified" | "behind" |
                                     "landscape" | "portrait" |
                                     "reverseLandscape" | "reversePortrait" |
                                     "sensorLandscape" | "sensorPortrait" |
                                     "userLandscape" | "userPortrait" |
                                     "sensor" | "fullSensor" | "nosensor" |
                                     "user" | "fullUser" | "locked"]
          android:stateNotNeeded=["true" | "false"]
          android:supportsPictureInPicture=["true" | "false"]
          android:taskAffinity="string"
          android:theme="resource or theme"
          android:uiOptions=["none" | "splitActionBarWhenNarrow"]
          android:windowSoftInputMode=["stateUnspecified",
                                       "stateUnchanged", "stateHidden",
                                       "stateAlwaysHidden", "stateVisible",
                                       "stateAlwaysVisible", "adjustUnspecified",
                                       "adjustResize", "adjustPan"] >   
    . . .
</activity>
```

包含它的文件：

\<application>

可包含：

\<intent-filter> 
\<meta-data>







不同的用户可与其提供的屏幕进行交互，以执行拨打电话、拍摄照片、发送电子邮件或查看地图等操作。 每个 Activity 都会获得一个用于绘制其用户界面的窗口。一个应用通常由多个彼此松散联系的 Activity 组成。 一般会指定应用中的某个 Activity 为“主”Activity，即首次启动应用时呈现给用户的那个 Activity。 而且每个 Activity 均可启动另一个 Activity，以便执行不同的操作。 每次新 Activity 启动时，前一 Activity 便会停止，但系统会在堆栈（“返回栈”）中保留该 Activity。 当新 Activity 启动时，系统会将其推送到返回栈上，并取得用户焦点。 返回栈遵循基本的“后进先出”堆栈机制，因此，当用户完成当前 Activity 并按“返回”按钮时，系统会从堆栈中将其弹出（并销毁），然后恢复前一 Activity。（[任务和返回栈](https://developer.android.com/guide/components/tasks-and-back-stack.html)文档中对返回栈有更详细的阐述。）

当一个 Activity 因某个新 Activity 启动而停止时，系统会通过该 Activity 的生命周期回调方法通知其这一状态变化。Activity 因状态变化—系统是创建 Activity、停止 Activity、恢复 Activity 还是销毁 Activity——而收到的回调方法可能有若干种，每一种回调都会为您提供执行与该状态变化相应的特定操作的机会。 例如，停止时，您的 Activity 应释放任何大型对象，例如网络或数据库连接。 当 Activity 恢复时，您可以重新获取所需资源，并恢复执行中断的操作。 这些状态转变都是 Activity 生命周期的一部分。

本文的其余部分阐述有关如何创建和使用 Activity 的基础知识（包括对 Activity 生命周期工作方式的全面阐述），以便您正确管理各种 Activity 状态之间的转变。



### **实现用户界面**

Activity 的用户界面是由层级式视图——衍生自 [View](https://developer.android.com/reference/android/view/View.html) 类的对象—— 提供的。每个视图都控制 Activity 窗口内的特定矩形空间，可对用户交互作出响应。 例如，视图可以是在用户触摸时启动某项操作的按钮。您可以利用 Android 提供的许多现成视图设计和组织您的布局。“小部件（widget）”是提供按钮、文本字段、复选框或仅仅是一幅图像等屏幕视觉（交互式）元素的视图。 “布局”是衍生自 [ViewGroup](https://developer.android.com/reference/android/view/ViewGroup.html) 的视图，为其子视图提供唯一布局模型，例如线性布局、网格布局或相对布局。 您还可以为 View 类和 ViewGroup 类创建子类（或使用其现有子类）来自行创建小部件和布局，然后将它们应用于您的 Activity 布局。

利用视图定义布局的最常见方法是借助保存在您的应用资源内的 XML 布局文件。这样一来，您就可以将用户界面的设计与定义 Activity 行为的源代码分开维护。 您可以通过 setContentView() 将布局设置为 Activity 的 UI，从而传递布局的资源 ID。不过，您也可以在 Activity 代码中创建新 View，并通过将新 View 插入 ViewGroup 来创建视图层次，然后通过将根 ViewGroup 传递到 setContentView() 来使用该布局。

\<activity> 元素还可指定各种 Intent 过滤器——使用 \<intent-filter> 元素——以声明其他应用组件激活它的方法。

当您使用 Android SDK 工具创建新应用时，系统自动为您创建的存根 Activity 包含一个 Intent 过滤器，其中声明了该 Activity 响应“主”操作且应置于“launcher”类别内。 Intent 过滤器的内容如下所示：

```xml
<activity android:name=".ExampleActivity" 
  android:icon="@drawable/app_icon">    
  <intent-filter>        
    <action android:name="android.intent.action.MAIN" />    
    <category android:name="android.intent.category.LAUNCHER"/>   
  </intent-filter>
</activity>
```

[\<action>](https://developer.android.com/guide/topics/manifest/action-element.html)元素指定这是应用的“主”入口点。[\<category>](https://developer.android.com/guide/topics/manifest/category-element.html)元素指定此 Activity 应列入系统的应用启动器内（以便用户启动该 Activity）。如果您打算让应用成为独立应用，不允许其他应用激活其Activity，则您不需要任何其他 Intent 过滤器。 正如前例所示，只应有一个 Activity 具有“主”操作和“launcher”类别。 您不想提供给其他应用的 Activity 不应有任何 Intent 过滤器，您可以利用显式 Intent 自行启动它们（下文对此做了阐述）。

不过，如果您想让 Activity 对衍生自其他应用（以及您的自有应用）的隐式 Intent 作出响应，则必须为 Activity 定义其他 Intent 过滤器。 对于您想要作出响应的每一个 Intent 类型，您都必须加入相应的 \<intent-filter>，其中包括一个 \<action> 元素，还可选择性地包括一个 \<category> 元素和/或一个 \<data> 元素。这些元素指定您的 Activity 可以响应的 Intent 类型。