# Flutter Tips


## :smile: 注意：在继承StatefulWidget重写其方法时，对于包含@mustCallSuper标注的父类方法，都要在子类方法中先调用父类方法。

## :smile: Dart 不像 Java ，没有关键词 public 、private 等修饰符，_下横向直接代表 private ，但是有 @protected 注解。

## :smile: 按照惯例，widget的构造函数参数应使用命名参数，命名参数中的必要参数要添加@required标注，这样有利于静态代码分析器进行检查。另外，在继承widget时，第一个参数通常应该是Key，另外，如果Widget需要接收子Widget，那么child或children参数通常应被放在参数列表的最后。同样是按照惯例，Widget的属性应尽可能的被声明为final，防止被意外改变。

## :smile: 一个Widget对象可以对应多个Element对象。这很好理解，根据同一份配置（Widget），可以创建多个实例（Element）。

## :smile: State对象也和StatefulElement具有对应关系（一对一）

## :smile: 在Dart中，所有的外部事件任务都在事件队列中，如IO、计时器、点击、以及绘制事件等，而微任务通常来源于Dart内部，并且微任务非常少，之所以如此，是因为微任务队列优先级高，如果微任务太多，执行时间总和就越久，事件队列任务的延迟也就越久，对于GUI应用来说最直观的表现就是比较卡，所以必须得保证微任务队列不会太长。值得注意的是，我们可以通过Future.microtask(…)方法向微任务队列插入一个任务。

## :smile: 如果未在Image widget上指定渲染图像的宽度和高度，那么Image widget将占用与主资源相同的屏幕空间大小。 也就是说，如果.../my_icon.png是72px乘72px，那么.../3.0x/my_icon.png应该是216px乘216px; 但如果未指定宽度和高度，它们都将渲染为72像素×72像素（以逻辑像素为单位）。

## :smile: assets指定应包含在应用程序中的文件， 每个asset都通过相对于pubspec.yaml文件所在的文件系统路径来标识自身的路径。asset的声明顺序是无关紧要的，asset的实际目录可以是任意文件夹（在本示例中是assets文件夹）。

## :smile: Dart函数声明如果没有显式声明返回值类型时会默认当做dynamic处理，注意，函数返回值没有类型推断：

## :smile: dynamic与Object不同的是,dynamic声明的对象编译器会提供所有可能的组合, 而Object声明的对象只能使用Object的属性与方法, 否则编译器会报错。如:

## :smile: Future 的所有API的返回值仍然是一个Future对象，所以可以很方便的进行链式调用。

## :smile: 但是通过context.ancestorStateOfType获取StatefulWidget的状态的方法是通用的，我们并不能在语法层面指定StatefulWidget的状态是否私有，所以在Flutter开发中便有了一个默认的约定：如果StatefulWidget的状态是希望暴露出的，应当在StatefulWidget中提供一个of静态方法来获取其State对象，开发者便可直接通过该方法来获取；如果State不希望暴露，则不提供of方法。这个约定在Flutter SDK里随处可见。所以，上面示例中的Scaffold也提供了一个of方法，我们其实是可以直接调用它的：
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

## :smile: Flutter中的很多Widget是直接继承自StatelessWidget或StatefulWidget，然后在build()方法中构建真正的RenderObjectWidget，如Text，它其实是继承自StatelessWidget，然后在build()方法中通过RichText来构建其子树，而RichText才是继承自LeafRenderObjectWidget。所以为了方便叙述，我们也可以直接说Text属于LeafRenderObjectWidget（其它widget也可以这么描述），这才是本质。读到这里我们也会发现，其实StatelessWidget和StatefulWidget就是两个用于组合Widget的基类，它们本身并不关联最终的渲染对象（RenderObjectWidget）。

## :smile: 如果Row里面嵌套Row，或者Column里面再嵌套Column，那么只有对最外面的Row或Column会占用尽可能大的空间，里面Row或Column所占用的空间为实际大小，如果要让里面的Column占满外部Column，可以使用Expanded 组件

## :smile: Flexible，Expanded,Spacer这三个小控件用于Row, Column, or Flex这三个容器
Spacer：顾名思义只是一个间距控件，可以用于调节小部件之间的间距，它有一个flex可以进行设置；

Expanded：Expanded会尽可能的充满分布在Row, Column, or Flex的主轴方向上；

Flexible：Flexible也是为小部件提供空间的，但是不会要求子空间填满可用空间；

## :smile: ConstrainedBox多重限制
对于minWidth和minHeight来说，是取父子中相应数值较大的；对于maxHeight和maxWidth来说，是取父子中相应数值较小的。

## :smile: 实际上AlertDialog和SimpleDialog都使用了Dialog类。由于AlertDialog和SimpleDialog中使用了IntrinsicWidth来尝试通过子组件的实际尺寸来调整自身尺寸，这就导致他们的子组件不能是延迟加载模型的组件（如ListView、GridView 、 CustomScrollView等）

## :smile: 
## :smile: 
## :smile: 
## :smile: 
## :smile: 
## :smile: 
## :smile: 
## :smile: 
## :smile: 
## :smile: 
## :smile: 
## :smile: 
## :smile: 
## :smile: 
## :smile: 
## :smile: 
## :smile: 
## :smile: 
## :smile: 
## :smile: 
## :smile: 
## :smile: 
## :smile: 
## :smile: 


