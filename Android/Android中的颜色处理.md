#### **Android Material Design中的Tint(着色)**
参考自https://segmentfault.com/a/1190000003038675
着色，着什么色呢？和背景有关，当然是着背景的色。当我开发客户端，使用了appcompat-v7包的时候，为了实现Material Design的效果，我们会去设置主题里的几个颜色，重要的比如primaryColor，colorControlNormal，colorControlActived 等等，而我们使用的一些组件，比如EditText就会自动变成我们想要的背景颜色，在背景图只有一张的情况下，这样的做法极大的减少了我们apk包的大小。

使用一个颜色为背景图片设置tint（着色)的底层特别简单(利用TintManager这个类为背景进行着色)，了解过渲染的同学应该知道PorterDuffColorFilter这个东西，我们使用SRC_IN的方式，对这个Drawable进行颜色方面的渲染，就是在这个Drawable中有像素点的地方，再用我们的过滤器着色一次。
实际上如果要我们自己实现，只用获取View的backgroundDrawable之后，设置下colorFilter即可。

由于API Level 21以前不支持background tint在xml中设置，于是提供了ViewCompat.setBackgroundTintList方法和ViewCompat.setBackgroundTintMode用来手动更改需要着色的颜色，但要求相关的View继承TintableBackgroundView接口。


#### **Android颜色混合模式(Alpha通道相关)**
参考自http://www.jianshu.com/p/a8c833b232aa
颜色一般都是四个通道(ARGB)的, 其中(RGB)控制的是颜色, 而A(Alpha)控制的是透明度. 我们的显示屏是没法透明的, 因此最终显示在屏幕上的颜色里可以认为没有Alpha通道. Alpha通道主要在两个图像混合的时候生效.

默认情况下, 当一个颜色绘制到Canvas上时的混合模式是这样计算的:

>(RGB通道)最终颜色 = 绘制的颜色 + (1 - 绘制颜色的透明度) × Canvas上的原有颜色

注意：

1. 一般把每个通道的取值从0(ox00)到255(0xff)映射到0到1的浮点数表示
2. 等式右边的“绘制的颜色"、“Canvas上的原有颜色”都是经过预乘了自己的Alpha通道的值. 如绘制颜色：0x88ffffff, 那么参与运算时的每个颜色通道的值不是1.0, 而是(1.0 * 0.5333 = 0.5333)。 (其中0.5333 = 0x88/0xff)

使用这种方式的混合, 就会造成后绘制的内容以半透明的方式叠在上面的视觉效果. 其实还可以有不同的混合模式供我们选择, 用Paint.setXfermode, 指定不同的PorterDuff.Mode.

下表是各个PorterDuff模式的混合计算公式: (D指原本在Canvas上的内容dst, S指绘制输入的内容src, a指alpha通道, c指RGB各个通道颜色）
混合模式|计算公式
---|---
ADD|Saturate(S + D)
CLEAR|[0, 0]
DARKEN|[Sa + Da - SaDa, Sc(1 - Da) + Dc*(1 - Sa) + min(Sc, Dc)]
DST|[Da, Dc]
DST_ATOP|[Sa, Sa Dc + Sc (1 - Da)]
DST_IN|[Sa Da, Sa Dc]
DST_OUT|[Da (1 - Sa), Dc (1 - Sa)]
DST_OVER|[Sa + (1 - Sa)Da, Rc = Dc + (1 - Da)Sc]
LIGHTEN|[Sa + Da - SaDa, Sc(1 - Da) + Dc*(1 - Sa) + max(Sc, Dc)]
MULTIPLY|[Sa Da, Sc Dc]
SCREEN|[Sa + Da - Sa Da, Sc + Dc - Sc Dc]
SRC|[Sa, Sc]
SRC_ATOP|[Da, Sc Da + (1 - Sa) Dc]
SRC_IN|[Sa Da, Sc Da]
SRC_OUT	|[Sa (1 - Da), Sc (1 - Da)]
SRC_OVER|[Sa + (1 - Sa)Da, Rc = Sc + (1 - Sa)Dc]
XOR|[Sa + Da - 2 Sa Da, Sc (1 - Da) + (1 - Sa) Dc]

用示例图来查看使用不同模式时的混合效果如下（src表示输入的图，dst表示原Canvas上的内容）：

<img src="http://img.blog.csdn.net/20170111004922056?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvcm9zeV9kYXdu/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast" width=800/>

用实际的例子验证一下。

验证的代码如下：
```java
@Override
    protected void onDraw(Canvas canvas) {
        super.onDraw(canvas);
        // draw background
        canvas.drawColor(Color.WHITE);
        int count = canvas.saveLayer(0, 0, width, height, p, Canvas.ALL_SAVE_FLAG);
        canvas.save();
        canvas.scale(0.5f, 0.5f, width / 2, height / 2);

        canvas.drawBitmap(mDst, 0, 0, p);
        p.setXfermode(xfermode);
        canvas.drawBitmap(mSrc, 0, 0, p);
        p.setXfermode(null);
        canvas.restore();

        canvas.restoreToCount(count);
    }
```
这里的mSrc以及mDst分别对应我们绘制的SRC bitmap以及DST bitmap；理论已经解释过了，DST代表先画的，下层图像；SRC是后画的上层图像。测试的图像用代码画出来的：
```java
@Override
    protected void onSizeChanged(int w, int h, int oldw, int oldh) {
        super.onSizeChanged(w, h, oldw, oldh);
        width = w;
        height = h;
        float halfWidth = width / 2;

        // DST Rect
        Paint p = new Paint(Paint.ANTI_ALIAS_FLAG);
        mSrc = Bitmap.createBitmap(w, h, Bitmap.Config.ARGB_8888);
        mDst = Bitmap.createBitmap(w, h, Bitmap.Config.ARGB_8888);

        Canvas canvas = new Canvas(mDst);
        p.setColor(Color.RED);
        canvas.drawRect(0, 0, halfWidth, height, p);
        p.setAlpha(1 << 7);
        canvas.drawRect(halfWidth, 0, width, height, p);

        canvas = new Canvas(mSrc);
        // SRC circle
        p.setColor(Color.BLUE);
        p.setAlpha((1 << 8) - 1);

        float radius = Math.min(height, width) / 2;
        mSrcRect.set(width / 2 - radius, height / 2 - radius, width / 2 + radius, height / 2 + radius);
        canvas.drawArc(mSrcRect, 0, 180, true, p);
        p.setAlpha(1 << 7);
        canvas.drawArc(mSrcRect, 180, 180, true, p);
    }
```

注意到，每一个图都有半透明和全透明的两种状态