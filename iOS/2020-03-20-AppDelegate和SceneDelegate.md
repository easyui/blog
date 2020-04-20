# AppDelegate和SceneDelegate

## app生命周期概述
- Not running（未运行）：程序未运行
- Inactive（未激活）：程序在前台运行，但没有接收到事件。在没有事件处理情况下程序通常停留在这个状态。
- Active ( 激活 ): 程序在前台运行而且接收到了事件。这也是前台的一个正常的模式。
- Backgroud ( 后台 ): 程序在后台而且能执行代码，大多数程序进入这个状态后会在在这个状态上停留一会。时间到之后会进入挂起状态(Suspended)。有的程序经过特殊的请求后可以长期处于Backgroud状态。
- Suspended ( 挂起 ): 程序在后台但是却不能执行代码。系统会自动把程序变成这个状态而且不会发出通知。当挂起时，程序还是停留在 内存中的，当系统内存低时，系统就把挂起的程序清除掉，为前台程序提供更多的内存。


## Xcode11、iOS13
在新的Xcode11当中创建新的项目，会看到自动生成AppDelegate.swift与SceneDelegate.swift文件。
除了这两个委托文件之外，Xcode还做了其他一些事情。打开Info.plist，会看到一个叫做Application Scene Manifest的新key。
![Application-Scene-Manifest.png](/)
