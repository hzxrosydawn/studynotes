# Application 标签

## [android:allowTaskReparenting](https://developer.android.com/guide/topics/manifest/application-element.html#reparent)

　　**android:allowTaskReparenting=["true" | "false"]**
　　表明了这个应用在 reset task 时，它的所有 activity 是否可以从打开它们的 task 栈中迁移到它们声明的 taskAffinity 亲和性（taskAffinity 属性可以查看我的这篇博客：[android深入解析Activity的launchMode启动模式，Intent Flag，taskAffinity](http://blog.csdn.net/self_study/article/details/48055011#t6)）栈中，true 代表可以，false 代表不可以。Android 源码中，我们从 Home 界面启动程序时都带了 FLAG_ACTIVITY_RESET_TASK_IF_NEEDED，所以从 Home 界面启动程序就会进行 reset task，也就会使用到 allowTaskReparenting 这个属性。
　　一般来说，当 Activity 启动后，它就与启动它的 Task 关联，并且在那里消耗它的整个生命周期，当当前的 Task 不再显示时，你可以使用这个特性来强制 Activity 移动到有着 affinity 的 Task 中。例如在一封 email 邮件中包含一个 web 页面的链接，点击它就会启动一个 Browser Activity 来显示这个页面，这个 Activity 时由 Browser 应用程序定义的，但是现在它作 email Task 的一部分，将它的 allowTaskReparenting 设置为 true，如果 Browser 下一次进入前台时，它就会根据 taskAffinity 属性重新宿主到 Browser Task 栈中，它就能被看见，并且当 email Task 再次进入前台时，就看不到它了。

## [android:allowBackup](https://developer.android.com/guide/topics/manifest/application-element.html#allowbackup)

　　**android:allowBackup=["true" | "false"]**
　　这个标识用来表示是否允许应用备份相关的数据并且在必要时候恢复还原这些数据，如果该标识设为 false，则代表不备份和恢复任何的应用数据，默认的该标识属性为 true。当 allowBackup 标识设置为 true 时，用户即可以通过 adb backup 和 adb restore 来进行对应数据的备份和恢复，这个在很多时候会带来一定的安全风险。
　　adb backup 命令容许任何一个打开 USB 调试开关的人从 Android 手机中复制应用数据到外设，一旦应用数据被备份之后，所有应用数据都可被用户读取；adb restore 命令允许用户指定一个恢复的数据来源(即备份的应用数据)来恢复应用程序数据的创建。因此，当一个应用数据被备份之后，用户即可在其他Android手机或模拟器上安装同一个应用，以及通过恢复该备份的应用数据到该设备上，在该设备上打开该应用即可恢复到被备份的应用程序的状态。尤其是通讯录应用，一旦应用程序支持备份和恢复功能，攻击者即可通过adb backup和adb restore进行恢复新安装的同一个应用来查看聊天记录等信息；对于支付金融类应用，攻击者可通过此来进行恶意支付、盗取存款等；因此为了安全起见，开发者务必将allowBackup标志值设置为false来关闭应用程序的备份和恢复功能，以免造成信息泄露和财产损失。
　　网上也可以看到很多将 allowBackup 设置为 true 带来的许多风险，可以看看这篇博客：[详解Android App AllowBackup配置带来的风险](http://www.91ri.org/12500.html)。

## [android:backupAgent](https://developer.android.com/guide/topics/manifest/application-element.html#agent)

　　**android:backupAgent="string"**
　　android:backupAgent 这个标识是用来设置备份代理，对于大部分应用程序来说，都或多或少保存着一些持久性的数据，比如数据库和共享文件或者有自己的配置信息，为了保证这些数据和配置信息的安全性以及完整性，Android提供了这样一个机制，我们可以通过这个备份机制来保存配置信息和数据以便为应用程序提供恢复点。如果用户将设备恢复出厂设置或者转换到一个新的Android设备上，系统就会在应用程序重新安装时自动恢复备份数据。这样，用户就不需要重新产生它们以前的数据或者设置了。这个进程对于用户是完全透明的，并且不影响其自身的功能或者应用程序的用户体验。要实现备份代理，就必须做两件事，一是实现 [BackupAgent](https://developer.android.com/reference/android/app/backup/BackupAgent.html) 或者 BackupAgentHelper 的子类，二是在 Manifest 文件内用 android:backupAgent 属性声明备份代理。

## [android:backupInForeground](https://developer.android.com/guide/topics/manifest/application-element.html#backupInForeground)

　　**android:backupInForeground=["true" | "false"]**
　　这个标识用来表明[Auto Backup for Apps](https://developer.android.com/guide/topics/data/autobackup.html)功能是否可以在应用在前台的时候进行数据的备份。[Auto Backup for Apps](https://developer.android.com/guide/topics/data/autobackup.html)功能是 Android 6.0 引入的一个新功能，它允许一个应用将自己的备份数据保存到 Google Drive 上面，每个用户可以免费保存 25M 的应用数据，这个新功能需要配合 android:allowBackup 一起使用。
　　这个标识的默认值为 false ，这意味着系统不会备份一个应用的数据，如果这个应用运行在前台（比如一个音乐软件的后台播放 service 是通过 startForeground 打开的）。

## [android:banner](https://developer.android.com/guide/topics/manifest/application-element.html#banner)

　　**android:banner="drawable resource"**
　　这个标识是用在 Android TV 电视上用轮播图来代表一个应用，由于轮播图只是在 HOME 界面上显示的，所以它仅仅只能被一个带有能够处理 [CATEGORY_LEANBACK_LAUNCHER](https://developer.android.com/reference/android/content/Intent.html#CATEGORY_LEANBACK_LAUNCHER) intent Activity 的应用声明。由于这个标识是 Android TV 开发使用到的，在这里就不详细介绍了，具体的可以看 Google 的 API 文档。

## [android:debuggable](https://developer.android.com/guide/topics/manifest/application-element.html#debug)

　　**android:debuggable=["true" | "false"]**
　　这个标识用来表明该应用是否可以被调试，默认值为 false.

## [android:description](https://developer.android.com/guide/topics/manifest/application-element.html#desc)

　　**android:description="string resource"**
　　用来声明关于这个应用的详细说明，用户可读的，必须使用 @string 的样式来声明，这个声明要比 label 标签声明的文字更加详细，而且和 label 不一样，这个标识不能够使用 raw string。

## [android:enabled](https://developer.android.com/guide/topics/manifest/application-element.html#enabled)

　　这个标识用来表明系统能否实例化这个应用的组件，true 代表可以，false 代表不可以，如果此值设为 true，则由每个组件的 enabled 属性确定自身的启用或禁用，如果此值设为 false ，则覆盖组件的设置值，所有组件都将被禁用。该标识的默认值是 true 。

## [android:extractNativeLibs](https://developer.android.com/guide/topics/manifest/application-element.html#extractNativeLibs)

　　**android:extractNativeLibs=["true" | "false"]**
　　这个标识为 android 6.0 引入，该属性如果设置为 false,则系统在安装应用的时候不会把 so 文件从 apk 中解压出来了，同时修改 System.loadLibrary 直接打开调用 apk 中的 so 文件。但是，目前要让该技巧生效还需要额外2个条件：一个是apk 中的 .so 文件不能被压缩；二个是 .so 必须用 zipalign -p 4 来对齐。该标识的默认值为 true。

## [android:fullBackupContent](https://developer.android.com/guide/topics/manifest/application-element.html#fullBackupContent)

　　**android:fullBackupContent="string"**
　　这个标识用来指明备份的数据的规则，该标识当然是配合[Auto Backup for Apps](https://developer.android.com/guide/topics/data/autobackup.html)来使用的，它也是在 Android 6.0 中引入的，使用的方式如下所示：

```
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"  
        xmlns:tools="http://schemas.android.com/tools"  
        package="com.my.appexample">  
    ...
    <app ...  
        android:fullBackupContent="@xml/mybackupscheme">  
    </app>  
    ...  
</manifest>
```

在此示例代码中，android:fullBackupContent 属性指定了一个 XML 文件。该文件名为mybackupscheme.xml，位于应用开发项目的 res/xml/ 目录中。 此配置文件包括关于要备份哪些文件的规则。 下列示例代码显示了将某一特定文件排除在备份之外的配置文件：

```
<?xml version="1.0" encoding="utf-8"?>
<full-backup-content>
    <exclude domain="database" path="device_info.db"/>
</full-backup-con
```

此示例备份配置仅将一个特定数据库文件排除在备份之外，所有其他文件均予以备份。

## [android:fullBackupOnly](https://developer.android.com/guide/topics/manifest/application-element.html#fullBackupOnly)

　　**android:fullBackupOnly=["true" | "false"]**
　　这个标识用来指明当[Auto Backup for Apps](https://developer.android.com/guide/topics/data/autobackup.html)功能可以使用的时候是否开启它。如果该标识设置为 true，在 Android 6.0 以及之上的手机上，应用将会执行[Auto Backup for Apps](https://developer.android.com/guide/topics/data/autobackup.html)功能，在之前的 Android 版本中，你的应用将会自动忽略该标识，并且切换成 [Key/Value Backups](https://developer.android.com/guide/topics/data/keyvaluebackup.html)。

## [android:hasCode](https://developer.android.com/guide/topics/manifest/application-element.html#code)

　　**android:hasCode=["true" | "false"]**
　　该标识用来指明应用程序是否包含代码，“true”表示包含，“false”表示不包含。 如果此值设为“false”，则在启动组件时系统不会试图装载任何程序代码。 默认值是“true”。
应用程序不包含任何自有代码的情况极少发生。 仅当只用到了内置的组件类时才有可能，比如使用了[AliasActivity](https://developer.android.com/reference/android/app/AliasActivity.html) 类的 Activity。

## [android:hardwareAccelerated](https://developer.android.com/guide/topics/manifest/application-element.html#hwaccel)

　　**android:hardwareAccelerated=["true" | "false"]**
　　是否为应用程序中所有的 Activity 和 View 启用硬件加速渲染功能 —“true”表示开启，“false”表示关闭。 如果 minSdkVersion 或 targetSdkVersion 的值大于等于“14”，则本属性默认值是“true”,否则，默认值为“false”。
　　自 Android 3.0 （API 级别 11）开始，应用程序可以使用硬件加速的 OpenGL 渲染功能来提高很多常用 2D 图形操作的性能。 当开启硬件加速渲染功能时，大部分 Canvas、Paint、Xfermode、ColorFilter、Shader 和 Camera 中的操作都会被加速。 即便应用程序没有显式地调用系统的 OpenGL 库，这仍能使动画更加平滑、屏幕滚动也更加流畅、整体响应速度获得改善。
　　请注意，并非所有的 OpenGL 2D 操作都会被加速。 如果开启了硬件加速渲染功能，请对应用程序进行测试以确保使用渲染时不会出错。更多详细的操作可以去查看 google 文档[硬件加速指南](https://developer.android.com/guide/topics/graphics/hardware-accel.html)。

## [android:icon](https://developer.android.com/guide/topics/manifest/application-element.html#icon)

　　**android:icon="drawable resource"**
　　代表整个应用程序的图标，也即应用程序中每个组件的默认图标。 请参阅 [< activity >](https://developer.android.com/guide/topics/manifest/activity-element.html)、 [< activity-alias >](https://developer.android.com/guide/topics/manifest/activity-alias-element.html)、 [< service >](https://developer.android.com/guide/topics/manifest/service-element.html)、 [< receiver > ](https://developer.android.com/guide/topics/manifest/receiver-element.html)和[< provider >](https://developer.android.com/guide/topics/manifest/provider-element.html) 元素各自的icon属性。本属性必须设为对 drawable 资源的引用（例如“ @drawable/icon ”）。 图标没有默认值。
　　必须要注意到的是这个标识和下面要介绍到的 `android:logo` 标签不一样，这个标签是在桌面显示的图标，而后者是在 actionBar 或者 toolBar 上面显示的。

## [android:isGame](https://developer.android.com/guide/topics/manifest/application-element.html#isGame)

　　**android:isGame=["true" | "false"]**
　　这个标识用来指明该应用是否是游戏，这样就能够将该应用和其他应用分离开来，默认的改值为 false。

## [android:killAfterRestore](https://developer.android.com/guide/topics/manifest/application-element.html#killrst)

　　**android:killAfterRestore=["true" | "false"]**
　　这个标识用来指明在手机恢复出厂设置之后，该应用的所有设置信息都被重置时，该应用是否需要被杀死，单个应用的重置设置操作一般不会造成应用的关闭，整个系统的重置操作一般只会发生一次，那就是手机第一次进入系统时的初始化设置，第三方应用一般情况下不需要用到该标识，
　　默认该值为 true，这表明系统重置设置之后，应用程序将在处理数据完成后被关闭。

## [android:largeHeap](https://developer.android.com/guide/topics/manifest/application-element.html#largeHeap)

　　**android:largeHeap=["true" | "false"]**
　　这个标识用来表明这个应用的进程是否需要更大的运行内存空间，这个标识对该应用的所有进程都有效，但是需要注意的一点是，这仅仅对第一个加载进这个进程的应用起作用，如果用户通过 sharedUserId 将多个应用置于同一个进程（SharedUserId 的具体用法可以参考我的博客：[android IPC通信（上）－sharedUserId&&Messenger](http://blog.csdn.net/self_study/article/details/50164199#t0)），那么两个应用都必须要指定该标识并且设置为同一个值，要不然就会产生意想不到的结果。
　　大部分应用程序不需要用到本属性，而是应该关注如何减少内存消耗以提高性能。 使用本属性并不能确保一定会增加可用的内存，因为某些设备可用的内存本来就很有限。
要在运行时查询可用的内存大小，请使用 [getMemoryClass()](https://developer.android.com/reference/android/app/ActivityManager.html#getMemoryClass()) 或[getLargeMemoryClass()](https://developer.android.com/reference/android/app/ActivityManager.html#getLargeMemoryClass()) 方法，后者的方法可以获取到应用开启 largeHeap 之后可以获得的内存大小。
　　这里说到一点是，一个应用不应该通过这个属性来解决 OOM 问题，而是应该通过检测内存泄漏来彻底根治 OOM，而且当内存很大的时候，每次gc的时间也会长一些，性能也会随之下降。

## [android:label](https://developer.android.com/guide/topics/manifest/application-element.html#label)

　　**android:label="string resource"**
　　这个标签应该是很常用的一个标签，它供用户阅读的代表整个应用程序的文本标签，也即应用程序中每个组件的默认标签。 请参阅 [< activity >](https://developer.android.com/guide/topics/manifest/activity-element.html)、 [< activity-alias >](https://developer.android.com/guide/topics/manifest/activity-alias-element.html)、 [< service >](https://developer.android.com/guide/topics/manifest/service-element.html)、 [< receiver > ](https://developer.android.com/guide/topics/manifest/receiver-element.html)和[< provider >](https://developer.android.com/guide/topics/manifest/provider-element.html) 元素各自的 label 属性。
　　文本标签应设为一个字符串资源的引用，这样就能像其它用户界面内的字符串一样对其进行本地化。 不过，考虑到开发时的便利性，也可以将其直接设为字符串。

## [android:logo](https://developer.android.com/guide/topics/manifest/application-element.html#logo)

　　**android:logo="drawable resource"**
　　这个标识指定了整个应用程序的 logo 标识，也即各 Activity 的默认 logo。
本属性必须设为对 drawable 资源的引用，该资源中包含了图片文件（例如“@drawable/logo”）。 logo 没有默认值。上面也介绍到了和 `android:icon` 的区别，这个是在 actionBar 或者 toolBar 上面展示的，icon 属性是在桌面显示的。

## [android:manageSpaceActivity](https://developer.android.com/guide/topics/manifest/application-element.html#space)

　　**android:manageSpaceActivity="string"**
　　这个标识用来指定一个 Activity 的名字，当用户在设置页面中手动点击清除数据按钮时，不会像以前一样把应用的私有目录/data/data/包名下的数据完全清除，而是跳转到那个声明的 activity 中，让用户遵照 activity 中提供的功能清除指定的数据。
　　感兴趣的可以看看该链接：[android:manageSpaceActivity让应用手动管理应用的数据目录](http://tangke.iteye.com/blog/1817857)

## [android:name](https://developer.android.com/guide/topics/manifest/application-element.html#nm)

　　**android:name="string"**
　　该标识用来指定该应用程序 Application 子类的完全限定名称，该类将优先于所有程序组件被实例化，该子类是可选的，根据应用程序的实际需求看是否使用，但是大多数应用程序都有使用，如果没有提供该 Application 子类时，Android 将使用 Application 类的实例。

## [android:permission](https://developer.android.com/guide/topics/manifest/application-element.html#prmsn)

　　**android:permission="string"**
　　该标识用来指定客户端要与应用程序交互而必须拥有的权限名称，本属性为一次设置适用于全部程序组件的权限提供了一个便捷途径，它可以被组件各自的 permission 属性覆盖，这个就相当于把 permission 标签设置给了应用里面的每个 Activity，Service 等等四大组件，详细的可以查看 google 文档的[权限](https://developer.android.com/guide/topics/manifest/manifest-intro.html#sectperm)或者另一篇文档[安全与权限](https://developer.android.com/training/articles/security-tips.html)。
　　或者可以看看这篇对于 permission 的博客：[android permission权限与安全机制解析（上）](http://blog.csdn.net/self_study/article/details/50074781)。

## [android:persistent](https://developer.android.com/guide/topics/manifest/application-element.html#persistent)

　　**android:permission="string"**
　　该标识用来指明一个应用程序是否需要一直保持运行状态，true 代表是，false 代表否，默认值是 false。一般的第三方应用是不应该设置该标识的，持久运行模式适用于某些特定的系统应用，比如通话，短信等应用，而且该应用在异常崩溃出现后，虽然这种情况很稀少，会立即重启，所以该标识第三方应用设置之后是不好用的。
　　这个标识的详细剖析可以看看这个博客：[android persistent属性研究](http://blog.csdn.net/windskier/article/details/6560925)。

## [android:process](https://developer.android.com/guide/topics/manifest/application-element.html#proc)

　　**android:process="string"**
　　应用程序的全部组件都将运行于其中的进程名称。 每个组件通过设置各自的 process 属性，可以覆盖本缺省值。
　　默认情况下，当运行应用程序的第一个组件时，Android 会为程序创建一个进程。 然后所有组件都会运行在这个进程中。 默认进程的名称与应用程序里面设置的 package 包名一致。
　　通过将本属性设置为其他应用程序的进程名称，可以让两个应用程序的组件运行于同一个进程中 — 但只有这两个应用程序使用 sharedUserId 指定为同一个 userId 并用要用同一个证书签名时才行。
　　如果赋予本属性的名称是以冒号（':'）开头的，则必要时将会为应用程序创建一个新的私有进程。 如果进程名称以小写字母开头，则将创建以此名称命名的全局进程。 全局进程可以被其他应用程序共享，以减少资源的占用。

## [android:restoreAnyVersion](https://developer.android.com/guide/topics/manifest/application-element.html#restoreany)

　　**android:restoreAnyVersion=["true" | "false"]**
　　该标识用来指明一个应用程序可以通过任何版本的备份数据进行数据恢复，就算该备份数据是从当前安装版本的更新版本应用备份出来的，把这个标识设置为 true 之后，Backup Manager 将会从一个不匹配版本的备份数据进行数据恢复操作，即使发生版本冲突也即数据版本不兼容时也是如此。 使用本属性时一定要特别小心。该标识的默认值为 false。

## [android:requiredAccountType](https://developer.android.com/guide/topics/manifest/application-element.html#requiredAccountType)

　　**android:requiredAccountType="string"**
　　该标识为 API18 版本添加，设定应用程序所需的账户类型。 如果应用程序需要一个 [Account](https://developer.android.com/reference/android/accounts/Account.html) 才能运行，本属性值必须与账户的认证类型（由 [AuthenticatorDescription](https://developer.android.com/reference/android/accounts/AuthenticatorDescription.html) 定义）吻合，比如“com.google”。默认值是 null，表示应用程序不需要任何账户就可以运行。因为目前的受限用户配置功能（Restricted Profile）无法添加账户，设定本属性的应用程序对于受限用户而言是不可用的， 除非你同时将 android:restrictedAccountType 也声明为相同的值。
　　提醒：如果账户数据可能会泄露个人身份信息，声明本属性就很重要了，并且要把 [android:restrictedAccountType](https://developer.android.com/guide/topics/manifest/application-element.html#restrictedAccountType) 设置为 null ，这样受限用户就无法用你的应用程序来访问机主的个人信息了。

## [android:restrictedAccountType](https://developer.android.com/guide/topics/manifest/application-element.html#restrictedAccountType)

　　**android:restrictedAccountType="string"**
　　该标识和 [android:requiredAccountType](https://developer.android.com/guide/topics/manifest/application-element.html#requiredAccountType) 一样也是 API18 添加，但是和 [android:requiredAccountType](https://developer.android.com/guide/topics/manifest/application-element.html#requiredAccountType) 不一样的是该属性如果设置了后，将会允许受限用户访问机主的该账户，如果应用程序需要使用 Account 并且允许受限用户访问主账户，本属性值必须与应用程序的账户认证类型（由 AuthenticatorDescription 定义）吻合，比如“com.google”。默认值为 null ，表示应用程序不需要 任何账户就可以运行。
　　提醒：设置本属性将允许受限用户通过主账户使用你的应用程序，这可能会泄露个人身份信息。 如果账户可能会泄露个人信息，请勿使用本属性，而是使用 android:requiredAccountType 属性，以禁止受限用户的使用。

## [android:resizeableActivity](https://developer.android.com/guide/topics/manifest/application-element.html#resizeableActivity)

　　**android:resizeableActivity=["true" | "false"]**
　　这个标识用来表明应用是否支持[分屏操作](https://developer.android.com/guide/topics/ui/multi-window.html)，这个标识可以设置在 [< activity >](https://developer.android.com/guide/topics/manifest/activity-element.html) 或者 [](https://developer.android.com/guide/topics/manifest/application-element.html) 标签上。如果把这个属性设置为 true，用户就能把这个应用或者 activity 设置为分屏或者自由模式，如果这个标识设置为 false，该应用或者 activity 将不支持多窗口的分屏模式，如果用户试图使用分屏模式打开该 activity，这个应用也只会充满整个屏幕。
　　如果你应用的 targetAPI 是 24 版本或者更高，虽然你没有显示的声明该标识的值，这个标识的默认值为 true。这个标识是在 API24 版本添加。

## [android:supportsRtl](https://developer.android.com/guide/topics/manifest/application-element.html#supportsrtl)

　　**android:supportsRtl=["true" | "false"]**
　　这个标识是用来声明应用是否要支持从右到左的（RTL）布局方式。
　　如果本标识属性设置为 true 并且同时 targetSdkVersion 为 17 或者以上版本，则系统将会激活并使用各种 RTL API ，应用程序就可以显示 RTL Layout。 如果本属性设为 false 或者 targetSdkVersion 为 16 以下版本，则 RTL API 将会被忽略或失效，应用程序将忽略与 Layout 方向有关的用户本地化选项（Layout 都将从左到右布局）。本属性的默认值是 false，为 API17 版本添加。

## [android:taskAffinity](https://developer.android.com/guide/topics/manifest/application-element.html#aff)

　　**android:taskAffinity="string"**
　　该标识将会对应用的所有 activity 生效，除非该 activity 设置了自己单独的 [taskAffinity](https://developer.android.com/guide/topics/manifest/activity-element.html#aff) 。一般情况下，在没有显示设置该标识的情况下，应用的所有 activity 都有同一个 affinity ，该 affinity 名字默认为 package 的名字。
　　关于 taskAffinity 和 launchMode 的详细介绍和用法可以看看我的这篇博客：[android深入解析Activity的launchMode启动模式，Intent Flag，taskAffinity](http://blog.csdn.net/self_study/article/details/48055011)。

## [android:testOnly](https://developer.android.com/guide/topics/manifest/application-element.html#testOnly)

　　**android:testOnly=["true" | "false"]**
　　该标识用来指明这个应用是不是仅仅作为测试的用途，比如，本应用程序可能会暴露一些不属于自己的功能或数据，这将引发安全漏洞，但对测试而言这又非常有用，而且这种应用程序只能通过 adb 进行安装。

## [android:theme](https://developer.android.com/guide/topics/manifest/application-element.html#theme)

　　**android:theme="resource or theme"**
　　这个标识用来声明这个应用的所有 activity 的主题，单独的一个 activity 可以声明自己的 [theme](https://developer.android.com/guide/topics/manifest/activity-element.html#theme) 主题来覆盖默认的属性，具体的可以查看 google 的官方文档：[样式和主题](https://developer.android.com/guide/topics/ui/themes.html)。

## [android:uiOptions](https://developer.android.com/guide/topics/manifest/activity-element.html#uioptions)

　　**android:uiOptions=["none" | "splitActionBarWhenNarrow"]**
　　这个标识用来指定这个应用所有的 Activity 的 UI 附加选项，它有两个值：

| Value                      | Description                              |
| -------------------------- | ---------------------------------------- |
| "none"                     | 没有其他的 UI 选项，改值为这个标识的默认值                  |
| "splitActionBarWhenNarrow" | 当水平空间受限时（例如在手持设备上的纵向模式下时）在屏幕底部添加一个栏以显示应用栏（也称为操作栏）中的操作项。 应用栏不是以少量操作项形式出现在屏幕顶部的应用栏中，而是分成了顶部导航区和底部操作项栏。 这可以确保操作项以及顶部的导航和标题元素都能获得合理的空间。 菜单项不会拆分到两个栏中，它们始终一起出现。 |

这个标识在 API14 版本添加，一般情况下很少会用到这个标识，我曾经只在魅族手机的适配过程中用到了这个标识，想要了解详细的适配，可以去看看 google 官方的官方教程[添加应用栏](https://developer.android.com/training/appbar/index.html)。

## [android:usesCleartextTraffic](https://developer.android.com/guide/topics/manifest/application-element.html#usesCleartextTraffic)

　　**android:usesCleartextTraffic=["true" | "false"]**
　　这个标识为 API23 版本也就是 Android M 添加，它用来指明应用是否需要使用明文的网络连接，例如明文的 HTTP 连接，这个标识的默认值为 true。
　　当这个标识设置为 false 的时候，平台的组件（例如，HTTP 和 FTP 栈，[DownloadManager](https://developer.android.com/reference/android/app/DownloadManager.html)，[MediaPlayer](https://developer.android.com/reference/android/media/MediaPlayer.html)）将会拒绝应用使用明文的请求。第三方的库强烈建议也遵守这个设置，避免使用明文请求连接的核心原因是会缺少机密性，可靠性，而且可以保护请求不受到恶意的篡改：一个网络攻击者可能会监听网络传输的数据，而且能够在不被检测的情况下修改这些数据。
　　当然这个标识也只是在最理想的情况下去遵守的，因为考虑到 Android 应用被提供的使用等级，是不可能避免他们所有的明文请求。例如，[Socket API](https://developer.android.com/reference/java/net/Socket.html) 就不一定需要遵守这个标识，因为它也不能决定这个链接是不是明文。然而，多数的应用网络请求连接都被高层次的网络栈／组件所处理，而这些栈／组件可以通过读取 [ApplicationInfo.flags](https://developer.android.com/reference/android/content/pm/ApplicationInfo.html#flags) 或者 [NetworkSecurityPolicy.isCleartextTrafficPermitted()](https://developer.android.com/reference/android/security/NetworkSecurityPolicy.html#isCleartextTrafficPermitted())来遵守这个标识。
　　需要注意的是 WebView 不需要遵守这个标识。在 app 的开发过程中，也可以使用 StrictMode 来检测明文的请求连接，使用方式为 [StrictMode.VmPolicy.Builder.detectCleartextNetwork()](https://developer.android.com/reference/android/os/StrictMode.VmPolicy.Builder.html#detectCleartextNetwork()).
　　当usesCleartextTraffic被设置为false，应用程序会在使用HTTP而不是HTTPS时崩溃。
　　在 API24 也就是 Android 7.0 及以上版本中，如果配置了 Android Network Security ，那么这个标识将会被自动忽略。

## [android:vmSafeMode](https://developer.android.com/guide/topics/manifest/application-element.html#vmSafeMode)

　　**android:vmSafeMode=["true" | "false"]**
　　这个标识用来指明这个应用是否想让 VM 虚拟机运行在安全模式，默认值为 false，这个标识是 API8 版本添加，如果设置为 true 将会禁用 Dalvik just-in-time(JIT)编译器，这个标识在 API22 版本之后为新版本做了改进，因为 4.4 之后 Dalvik 虚拟机就被废弃了，在 22 版本之后这个标识如果设置为 true 将会禁用 ART ahead-of-time（AOT）编译器。
　　详细的可以看看这篇介绍：[ART、JIT、AOT、Dalvik之间有什么关系？](https://github.com/ZhaoKaiQiang/AndroidDifficultAnalysis/blob/master/10.ART%E3%80%81JIT%E3%80%81AOT%E3%80%81Dalvik%E4%B9%8B%E9%97%B4%E6%9C%89%E4%BB%80%E4%B9%88%E5%85%B3%E7%B3%BB%EF%BC%9F.md#artjitaotdalvik%E4%B9%8B%E9%97%B4%E6%9C%89%E4%BB%80%E4%B9%88%E5%85%B3%E7%B3%BB)