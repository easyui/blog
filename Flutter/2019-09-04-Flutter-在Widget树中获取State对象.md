# 2019-09-04-Flutter-在Widget树中获取State对象

由于StatefulWidget的的具体逻辑都在其State中，所以很多时候，我们需要获取StatefulWidget对应的State对象来调用一些方法，比如Scaffold组件对应的状态类ScaffoldState中就定义了打开SnackBar(路由页底部提示条)的方法。我们有两种方法在子widget树中获取父级StatefulWidget的State对象。

## 通过Context获取

context对象有一个ancestorStateOfType(TypeMatcher)方法，该方法可以从当前节点沿着widget树向上查找指定类型的StatefulWidget对应的State对象。下面是实现打开SnackBar的示例

```
Scaffold(
  appBar: AppBar(
    title: Text("子树中获取State对象"),
  ),
  body: Center(
    child: Builder(builder: (context) {
      return RaisedButton(
        onPressed: () {
          // 查找父级最近的Scaffold对应的ScaffoldState对象
          ScaffoldState _state = context.ancestorStateOfType(
              TypeMatcher<ScaffoldState>());
          //调用ScaffoldState的showSnackBar来弹出SnackBar
          _state.showSnackBar(
            SnackBar(
              content: Text("我是SnackBar"),
            ),
          );
        },
        child: Text("显示SnackBar"),
      );
    }),
  ),
);
```

一般来说，如果StatefulWidget的状态是私有的（不应该向外部暴露），那么我们代码中就不应该去直接获取其State对象；如果StatefulWidget的状态是希望暴露出的（通常还有一些组件的操作方法），我们则可以去直接获取其State对象。但是通过context.ancestorStateOfType获取StatefulWidget的状态的方法是通用的，我们并不能在语法层面指定StatefulWidget的状态是否私有，所以在Flutter开发中便有了一个默认的约定：如果StatefulWidget的状态是希望暴露出的，应当在StatefulWidget中提供一个of静态方法来获取其State对象，开发者便可直接通过该方法来获取；如果State不希望暴露，则不提供of方法。这个约定在Flutter SDK里随处可见。所以，上面示例中的Scaffold也提供了一个of方法，我们其实是可以直接调用它的：

```
...//省略无关代码
// 直接通过of静态方法来获取ScaffoldState 
ScaffoldState _state=Scaffold.of(context); 
_state.showSnackBar(
  SnackBar(
    content: Text("我是SnackBar"),
  ),
);
```

## 通过GlobalKey

Flutter还有一种通用的获取State对象的方法——通过GlobalKey来获取！ 步骤分两步：

1、给目标StatefulWidget添加GlobalKey。

```
//定义一个globalKey, 由于GlobalKey要保持全局唯一性，我们使用静态变量存储
static GlobalKey<ScaffoldState> _globalKey= GlobalKey();
...
Scaffold(
    key: _globalKey , //设置key
    ...  
)
```

2、通过GlobalKey来获取State对象

```
_globalKey.currentState.openDrawer()
```

GlobalKey是Flutter提供的一种在整个APP中引用element的机制。如果一个widget设置了GlobalKey，那么我们便可以通过globalKey.currentWidget获得该widget对象、globalKey.currentElement来获得widget对应的element对象，如果当前widget是StatefulWidget，则可以通过globalKey.currentState来获得该widget对应的state对象。

> 注意：使用GlobalKey开销较大，如果有其他可选方案，应尽量避免使用它。另外同一个GlobalKey在整个widget树中必须是唯一的，不能重复。



> [https://book.flutterchina.club/chapter3/flutter_widget_intro.html](https://book.flutterchina.club/chapter3/flutter_widget_intro.html)






