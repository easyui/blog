# Flutter State生命周期 

## 概述
Flutter 的生命周期分为两个部分：
1. Widget 的生命周期
2. App 的生命周期

## Widget 的生命周期
Flutter 里的 Widget 分为 StatelessWidget 和 StatefulWidget 两种

### StatelessWidget 的生命周期
StatelessWidget 的生命周期只有一个，就是：build。

build 是用来创建 Widget 的，但因为 build 在每次界面刷新的时候都会调用，所以不要在 build 里写业务逻辑，可以把业务逻辑写到你的 StatelessWidget 的构造函数里。

### StatefulWidget 的生命周期
StatefulWidget 的生命周期比较复杂，依次为：
- createState
- constructor
- initState
- didChangeDependencies
- build
- addPostFrameCallback
- didUpdateWidget
- deactivate
- dispose

**createState**
createState 是 StatefulWidget 里创建 State 的方法，当要创建新的 StatefulWidget 的时候，会立即执行 createState，而且只执行一次，createState 必须要实现。

下面就是state的生命周期：
## State
一个StatefulWidget类会对应一个State类，State表示与其对应的StatefulWidget要维护的状态，State中的保存的状态信息可以：
1. 在widget build时可以被同步读取。
2. 在widget生命周期中可以被改变，当State被改变时，可以手动调用其setState()方法通知Flutter framework状态发生改变，Flutter framework在收到消息后，会重新调用其build方法重新构建widget树，从而达到更新UI的目的。

State中有两个常用属性：
1. `widget`，它表示与该State实例关联的widget实例，由Flutter framework动态设置。注意，这种关联并非永久的，因为在应用声明周期中，UI树上的某一个节点的widget实例在重新构建时可能会变化，但State实例只会在第一次插入到树中时被创建，当在重新构建时，如果widget被修改了，Flutter framework会动态设置State.widget为新的widget实例。

2. `context`，它是BuildContext类的一个实例，表示构建widget的上下文，它是操作widget在树中位置的一个句柄，它包含了一些查找、遍历当前Widget树的一些方法。每一个widget都有一个自己的context对象。

## State生命周期
- `constructor`:这个函数严格意义上来讲不属于生命周期的一部分，因为这个时候State的widget属性为空，无法在构造函数中访问widget的属性 。但是构造函数必然是要第一个调用的。可以在这一部分接收前一个页面传递过来的数据。

- `initState`：当Widget第一次插入到Widget树时会被调用，对于每一个State对象，Flutter framework只会调用一次该回调，所以，通常在该回调中做一些一次性的操作，如状态初始化、订阅子树的事件通知等。不能在该回调中调用BuildContext.inheritFromWidgetOfExactType（该方法用于在Widget树上获取离当前widget最近的一个父级InheritFromWidget，关于InheritedWidget我们将在后面章节介绍），原因是在初始化完成后，Widget树中的InheritFromWidget也可能会发生变化，所以正确的做法应该在在build（）方法或didChangeDependencies()中调用它。

类似于 Android 的 onCreate、iOS 的 viewDidLoad()，所以在这里 View 并没有渲染，但是这时 StatefulWidget 已经被加载到渲染树里了，这时 StatefulWidget 的 mount的值会变为 true，直到 dispose调用的时候才会变为 false。可以在 initState里做一些初始化的操作。  

- `didChangeDependencies()`：当State对象的依赖发生变化时会被调用；例如：在之前build() 中包含了一个InheritedWidget，然后在之后的build() 中InheritedWidget发生了变化，那么此时InheritedWidget的子widget的didChangeDependencies()回调都会被调用。典型的场景是当系统语言Locale或应用主题改变时，Flutter framework会通知widget调用此回调。

 so 会在如下场景被调用：
 1. 初始化时，在initState()之后立刻调用
 2. 当依赖的InheritedWidget rebuild,会触发此接口被调用

- `build()`：此回调读者现在应该已经相当熟悉了，它主要是用于构建Widget子树的，会在如下场景被调用：

1. 在调用initState()之后。
2. 在调用didUpdateWidget()之后。
3. 在调用setState()之后。
4. 在调用didChangeDependencies()之后。
5. 在State对象从树中一个位置移除后（会调用deactivate）又重新插入到树的其它位置之后。

- `addPostFrameCallback`:addPostFrameCallback是 StatefulWidge 渲染结束的回调，只会被调用一次，之后 StatefulWidget 需要刷新 UI 也不会被调用，addPostFrameCallback的使用方法是在 initState里添加回调。

```
import 'package:flutter/scheduler.dart';
@override
void initState() {
  super.initState();
  SchedulerBinding.instance.addPostFrameCallback((_) => {});
}
```

- `didUpdateWidget()`：在widget重新构建时，Flutter framework会调用Widget.canUpdate来检测Widget树中同一位置的新旧节点，然后决定是否需要更新，如果Widget.canUpdate返回true则会调用此回调。正如之前所述，Widget.canUpdate会在新旧widget的key和runtimeType同时相等时会返回true，也就是说在在新旧widget的key和runtimeType同时相等时didUpdateWidget()就会被调用。

理论上setState的时候会调用，但我实际操作的时候发现只是做setState的操作的时候没有调用这个方法。而在我改变代码hot reload时候会调用 didUpdateWidget 并执行 build…

实际上在hot reload这里flutter框架会创建一个新的Widget,绑定本State，并在这个函数中传递老的Widget。这个函数一般用于比较新、老Widget，看看哪些属性改变了，并对State做一些调整。

- `deactivate()`：当State对象从树中被移除时，会调用此回调。在一些场景下，Flutter framework会将State对象重新插到树中，如包含此State对象的子树在树的一个位置移动到另一个位置时（可以通过GlobalKey来实现）。如果移除后没有重新插入到树中则紧接着会调用dispose()方法。

- `dispose()`：当State对象从树中被永久移除时调用；通常在此回调中释放资源。

- `reassemble()`：此回调是专门为了开发调试而提供的，在热重载(hot reload)时会被调用，此回调在Release模式下永远不会被调用。

## App 的生命周期
AppLifecycleState 就是 App 的生命周期，有：
- resumed //用户可见，但不可响应用户操作
- inactive // 已经暂停了，用户不可见、不可操作
- paused //应用可见并可响应用户操作
- suspending //应用被挂起，此状态iOS永远不会回调

如果想要知道 Flutter App 的生命周期，例如 Flutter 是在前台还是在后台，就需要使用到 WidgetsBindingObserver了，使用方法如下：

1、State 的类 mix WidgetsBindingObserver：

```
class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {

}
```

2、在 State 的 initState里添加监听

```
  @override
  void initState() {
    print('initState');
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }
```

3、在 State 的 dispose里移除监听：

```
  @override
  void dispose() {
    print('dispose');
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }
```

4、在 State 里 override didChangeAppLifecycleState

```
  ///生命周期变化时回调
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('didChangeAppLifecycleState : ' + state.toString());
    switch (state) {
      case AppLifecycleState.inactive:
        // print('AppLifecycleState.inactive'); //用户可见，但不可响应用户操作
        break;
      case AppLifecycleState.paused:
        // print('AppLifecycleState.paused'); // 已经暂停了，用户不可见、不可操作
        break;
      case AppLifecycleState.resumed:
        // print('AppLifecycleState.resumed'); //应用可见并可响应用户操作
        break;
      case AppLifecycleState.suspending:
        // print('AppLifecycleState.suspending'); //应用被挂起，此状态iOS永远不会回调
        break;
    }
    super.didChangeAppLifecycleState(state);
  }
```

WidgetsBindingObserver还有一些其他有用的监听:
   
```
     ///低内存回调
  @override
  void didHaveMemoryPressure() {
    print("didHaveMemoryPressure");
    super.didHaveMemoryPressure();
  }

  ///应用尺寸改变时回调，例如旋转
  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    Size size = WidgetsBinding.instance.window.physicalSize;
    print("didHaveMemoryPressure  ：宽：${size.width} 高：${size.height}");
  }
  
```
  
## demo:
### 打开新路由(启动app的第一个页面)：
  
```
flutter: constructor
flutter: initState
flutter: didChangeDependencies
flutter: build
flutter: addPostFrameCallback
flutter: didHaveMemoryPressure  ：宽：750.0 高：1334.0
```
> didHaveMemoryPressure这个方法只有在启动app第一个界面调用，比如再push个新界面新界面不会调用（其实是界面没变）


### hot reload：
  
```
flutter: reassemble
flutter: didUpdateWidget
flutter: build
```

### setState(() {_counter++;});
  
```
flutter: build
```

### 显示 in-call status bar：
  
```
flutter: didHaveMemoryPressure  ：宽：750.0 高：1294.0
```

### 关闭 in-call status bar：
  
```
flutter: didHaveMemoryPressure  ：宽：750.0 高：1334.0
```

### 旋转屏幕（app支持多个方向）：
  
```
flutter: didHaveMemoryPressure  ：宽：750.0 高：1334.0
flutter: didHaveMemoryPressure  ：宽：1334.0 高：750.0
```

>回调了2次，第一次显示现在大小，第二次是旋转后的大小。（如果手机旋转后，app不支持旋转是不回调的）

### 回到后台：
  
```
flutter: didChangeAppLifecycleState : AppLifecycleState.inactive
flutter: didChangeAppLifecycleState : AppLifecycleState.paused
```

### 再次回到前台：
  
```
flutter: didChangeAppLifecycleState : AppLifecycleState.inactive
flutter: didChangeAppLifecycleState : AppLifecycleState.resumed
```

### 下拉显示通知中途返回：
  
```
flutter: didChangeAppLifecycleState : AppLifecycleState.inactive
flutter: didChangeAppLifecycleState : AppLifecycleState.resumed
```

### 下拉显示通知：
  
```
flutter: didChangeAppLifecycleState : AppLifecycleState.inactive
flutter: didChangeAppLifecycleState : AppLifecycleState.resumed
flutter: didChangeAppLifecycleState : AppLifecycleState.inactive
```

### 下拉显示通知后的返回应用：
  
```
flutter: didChangeAppLifecycleState : AppLifecycleState.resumed
```

### 上拉显示工具栏中返回不显示：
  
```
flutter: didChangeAppLifecycleState : AppLifecycleState.inactive
flutter: didChangeAppLifecycleState : AppLifecycleState.resumed
```

### 上拉显示工具栏：
  
```
flutter: didChangeAppLifecycleState : AppLifecycleState.inactive
```

### 上拉显示工具栏后返回：
  
```
flutter: didChangeAppLifecycleState : AppLifecycleState.resumed
```

### push新界面：
  
```
flutter: New--constructor
flutter: New--initState
flutter: New--didChangeDependencies
flutter: New--build
flutter: New--addPostFrameCallback
flutter: deactivate
flutter: didChangeDependencies
flutter: build
```

### pop返回：
  
```
flutter: deactivate
flutter: didChangeDependencies
flutter: build
flutter: New--deactivate
flutter: New--dispose
```

push到新界面后，如果收到进入后台，旋转等app通知，则堆栈下层的先收到，依次到最上层收到。
  
> 测试环境：fullter：v1.7.8+hotfix.3-stable， ios12.2，iphone6s模拟器

> 测试文件：
> [main.dart](main.dart)
> [NewRoute.dart](NewRoute.dart)








