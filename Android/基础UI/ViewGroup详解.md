ViewGroup详解

android:addStatesFromChildren// 设置这个ViewGroup的drawable状态是否包括子View的状态。若设为true，当子View如EditText或Button获得焦点时，整个ViewGroup也会获得焦点。  

android:alwaysDrawnWithCache// 设置ViewGroup在绘制子View时是否一直使用绘图缓存。默认为true。  

android:animationCache// 设置布局在绘制动画效果时是否为其子View创建绘图缓存。若设为true，将会消耗更多的内存，要求持续时间更久的初始化过程，但表现更好。默认为true。  

android:clipChildren// 设置子View是否受限于在自己的边界内绘制。若设为false,当子View所占用的空间大于边界时可以绘制在边界外。默认为true。  

android:clipToPadding//定义布局间是否有间距。默认为true。  

android:descendantFocusability// 定义当寻找一个焦点View的时候，ViewGroup与其子View之间的关系。可选项为：  
//(1)beforeDescendants       ViewGroup会比其子View更先获得焦点;  
//(2)afterDescendants           只有当无子View想要获取焦点时，ViewGroup才会获取焦点;  
//(3)blockDescendants         ViewGroup会阻止子View获取焦点  

android:layoutAnimation//定义当ViewGroup第一次展开时的动画效果，也可人为地在第一次展开后调用。  

android:persistentDrawingCache// 定义绘图缓存的持久性。有如下可选项：  
//(1)none                    当使用过后不保留绘图缓存  
//(2)animation    在layout animation之后保留绘图缓存  
//(3)scrolling    在Scroll操作后保留绘图缓存  
//(4)all     always保留绘图缓存  