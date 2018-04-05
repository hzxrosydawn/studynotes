---
typora-root-url: ./
typora-copy-images-to: appendix
---

## IDEA基本配置

### 修改配置目录

最常改动的是 bin 目录的下面几个文件：

- `idea.exe` 文件和  `idea64.exe` 文件是 IntelliJ IDEA 的 32 位可行执行文件，IntelliJ IDEA 安装完发送到桌面的也就是这个执行文件的快捷方式；
- `idea.exe.vmoptions` 文件和 `idea64.exe.vmoptions` 文件分别是 IntelliJ IDEA 32 位和 64 位的可执行文件的 VM 配置文件，可以根据自己的项目大小和硬件配置适当修改。常见修改项如下：

```properties
-Xms128m
-Xmx750m
-Dfile.encoding=UTF-8
-XX:ReservedCodeCacheSize=240m
```

- `idea.properties` 文件是 IntelliJ IDEA 的一些属性配置文件，常见配置修改如下：

```properties
#---------------------------------------------------------------------
# 指定cofing存储的路径，该目录下保存setting的数据，比如字体、快捷键、live templates等，
# 初次启动IDEA时可以导入以前的旧配置目录就是该目录，所以建议将config目录备份。也可以将
# IDEA打造成免安装版的
#---------------------------------------------------------------------
# idea.config.path=${user.home}/.IntelliJIdea/config
idea.config.path=../config
#---------------------------------------------------------------------
# 指定system的目录，是IDEA与开发项目一个桥梁目录，里面主要有缓存、索引、容器文件输出等，
# 虽然不是最重要目录，但是也是最不可或缺目录之一
#---------------------------------------------------------------------
# idea.system.path=${user.home}/.IntelliJIdea/system
idea.system.path=../system
#---------------------------------------------------------------------
# 指定插件安装位置，这里将插件安装在配置目录的plugins目录中
#---------------------------------------------------------------------
# idea.plugins.path=${idea.config.path}/plugins
idea.plugins.path=${idea.config.path}/plugins
#---------------------------------------------------------------------
# 指定IDEA的日志目录
#---------------------------------------------------------------------
# idea.log.path=${idea.system.path}/log
idea.log.path=${idea.system.path}/log
```

### 缓存和索引介绍和清理方法

IntelliJ IDEA 的缓存和索引主要是用来加快文件查询，从而加快各种查找、代码提示等操作的速度。但是，IntelliJ IDEA 的索引和缓存并不是一直会良好地支持 IntelliJ IDEA 的，这某些特殊条件下，IntelliJ IDEA 的缓存和索引文件也是会损坏的，比如：断电、蓝屏引起的强制关机，当你重新打开 IntelliJ IDEA，基本上百分八十的可能 IntelliJ IDEA 都会报各种莫名其妙错误，甚至项目打不开，IntelliJ IDEA 主题还原成默认状态。也有一些即使没有断电、蓝屏，也会有莫名奇怪的问题的时候，也很有可能是 IntelliJ IDEA 缓存和索引出问题，这种情况还不少。下面就来讲解如何解决。

点击 `File` 菜单 → `Invalidate Cache / Restart...` 菜单项 → 一般选择 `Invalidate and restart` 按钮。这样缓存和索引会被清空，重启后重建。清除索引和缓存会使得 IntelliJ IDEA 的 `Local History` 丢失，所以如果你项目没有加入到版本控制，而你又需要你项目文件的历史更改记录，那你最好备份下你的 `LocalHistory` 目录，该目录位于 `安装目录\system\LocalHistory` 。



### 设置主题、字体

依次选择 `File` → `Setting` → `Appearance &  Behavior` → `Appearance` ，然后：

- 设置 IntelliJ IDEA 的**主题**：点击 `Theme下拉菜单`，可以选择喜欢的主题，个人比较喜欢 `Durcula` 的暗系风格。
- 设置 IntelliJ IDEA 的**系统字体**：勾选 `Override default fonts by (not recommended)` → 在 `Name项` 选择一款自己喜欢的字体，比如 `Macrosoft YaHei UI` （支持中文，系统文字中的中文不会乱码），`Size` 项建议为 `14` 。

设置 IntelliJ IDEA 编辑器的 `Scheme` ：然后依次选择 `File` →  `Setting` →  `Editor` →  选择 `Scheme 下拉菜单`，选择刚才导入的 Scheme → 点击 `Apply 按钮`。

