## **Snackbar详解**

该类是不可变类，提供一个轻量级的操作反馈，可用来替代Toast，但是比Toast强大许多。可用来在手机屏幕的底部或较大设备的左下方想Toast一样显示简短的消息。Snackbar也像Toast一样显示在所有组件的上方，每次也只显示一个，Sackbar也像Toast一样可以在一段延迟后消失，或在用户在屏幕的其他地方交互之后显示出来。不同的是，Sackbar可以滑出屏幕（be swiped off screen）。

Snackbar可通过其setAction(CharSequence, android.view.View.OnClickListener)方法来包含一个操作。可以通过为其addCallback(BaseCallback)方法出入[Snackbar.Callback](https://developer.android.com/reference/android/support/design/widget/Snackbar.Callback.html)对象来发出该Snackbar显示或消失的通知。

Snackbar.Callback内部类（继承自[BaseTransientBottomBar.BaseCallback](https://developer.android.com/reference/android/support/design/widget/BaseTransientBottomBar.BaseCallback.html)）包含了以下两个回调方法：

- void onDismissed(Snackbar transientBottomBar, int event)：当该Snackbar消失后回调该方法。event参数可以为该内部类的以下常量之一：
  - int	DISMISS_EVENT_ACTION：表明该Snackbar是通过一个点击操作（ction click）而消失的；
  - int	DISMISS_EVENT_CONSECUTIVE：：表明该Snackbar是由于一个新的Snackbar显示而消失的；
  - int	DISMISS_EVENT_MANUAL：表明该Snackbar是通过手动调用dismiss()方法而消失的；
  - int	DISMISS_EVENT_SWIPE：表明该Snackbar是被滑动（swipe）之后而消失的；
  - int	DISMISS_EVENT_TIMEOUT：表明该Snackbar是由于超过指定的延迟后而消失的；
- void onShown(Snackbar sb)：当该Snackbar显示时回调该方法；

Snackbar不可变类定义了以下三个常量用来指定Snackbar的显示时间：

- int	LENGTH_INDEFINITE：Snackbar显示的时间长短不确定；
- int	LENGTH_LONG：Snackbar显示较长时间；
- int	LENGTH_SHORT：Snackbar显示较短时间。

该不可变类还提供了以下方法：

- static Snackbar	make(View view, CharSequence text, int duration)：创建一个显示文本（可以是格式化文本）信息的Snackbar。Snackbar尝试通过给定的view参数来遍历View 树找到一个适合容纳Snackbar的父View，该父View可以[CoordinatorLayout](https://developer.android.com/reference/android/support/design/widget/CoordinatorLayout.html)或窗口的内容视图，先遍历到哪一个就使用哪一个。在View层级中要是有一个CoordinatorLayout就可以使Snackbar具有一些特性，如滑动消失，像[FloatingActionButton](https://developer.android.com/reference/android/support/design/widget/FloatingActionButton.html) 一样自动移动；
- static Snackbar	make(View view, int resId, int duration)：同上；
- Snackbar	setAction(int resId, View.OnClickListener listener)：为该Snackbar设置一个点击操作；
- Snackbar	setAction(CharSequence text, View.OnClickListener listener)：同上；
- Snackbar	setActionTextColor(ColorStateList colors)：设置setAction(CharSequence, View.OnClickListener)方法中设置的文本的颜色；
- Snackbar	setActionTextColor(int color)：同上；
- Snackbar	setText(CharSequence message)：更新该Snackbar的文本；
- Snackbar	setText(int resId)：同上；
- B addCallback (BaseCallback\<B> callback)：添加一个反馈回调对象；
- B removeCallback(BaseCallback\<B> callback)：溢出一个反馈回调对象；
- void dismiss()：使该Snackbar消失；
- void show()：显示该Snackbar。

上面的额后四个方法继承自其父类[BaseTransientBottomBar](https://developer.android.com/reference/android/support/design/widget/BaseTransientBottomBar.html)。

Snackbar的常用用法与Toast相似，但是提供了一些额外的特性值得尝试。

