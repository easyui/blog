# Flutter Tips

## :smile: widgets 是不可变的
无 状态的 widgets 是不可变的，这意味着它们的属性不能改变 —— 所有的值都是 final。

有 状态的 widgets 也是不可变的，但其持有的状态可能在 widget 生命周期中发生变化，实现一个有状态的 widget 至少需要两个类： 1）一个 StatefulWidget 类；2）一个 State 类，StatefulWidget 类本身是不变的，但是 State 类在 widget 生命周期中始终存在。

## :smile: widget 拥有着不同的生命周期：整个生命周期内它是不可变的，且只能够存活到被修改的时候。一旦 widget 实例或者它的状态发生了改变， Flutter 框架就会创建一个新的由 Widget 实例构造而成的树状结构。

## :smile: Flutter 的 widget 是很轻量的，一部分原因就是源于它的不可变特性。因为它并不是视图，也不直接绘制任何内容，而是作为对 UI 及其特性的一种描述，被「注入」到视图中去。

## :smile: FittedBox 只能在有限制的宽高中对子 widget 进行缩放（宽度和高度不会变得无限大）

## :smile: 由于 Row 不会对其子级施加任何约束，因此它的 children 很有可能太大而超出 Row 的可用宽度。在这种情况下， Row 会和 UnconstrainedBox 一样显示溢出警告。

## :smile: Row 要么使用子级的宽度，要么使用Expanded 和 Flexible 从而忽略子级的宽度。

## :smile: 当一个 widget 告诉其子级可以比自身更小的话，我们通常称这个 widget 对其子级使用 宽松约束（loose）。

## :smile: 当一个 widget 告诉它的子级必须变成某个大小的时候，我们通常称这个 widget 对其子级使用 严格约束（tight）。

## :smile: Flutter 中的 widget 由在其底层的 RenderBox 对象渲染而成。渲染框由其父级 widget 给出约束，并根据这些约束调整自身尺寸大小。约束是由最小宽度、最大宽度、最小高度、最大高度四个方面构成；尺寸大小则由特定的宽度和高度两个方面构成。

## :smile: 一般来说，从如何处理约束的角度来看，有以下三种类型的渲染框：

- 尽可能大。比如 Center 和 ListView 的渲染框。

- 与子 widget 一样大，比如 Transform 和 Opacity 的渲染框。

- 特定大小，比如 Image 和 Text 的渲染框。

对于一些诸如 Container 的 widget，其尺寸会因构造方法的参数而异，就 Container 来说，它默认是尽可能大的，而一旦给它一个特定的宽度，那么它就会遵照这个特定的宽度来调整自身尺寸。

## :smile: addListener
每当动画的状态值发生变化时，动画都会通知所有通过 addListener 添加的监听器。通常，一个正在监听动画的 State 对象会调用自身的 setState 方法，将自身传入这些监听器的回调函数来通知 widget 系统需要根据新状态值进行重新构建。

这种模式非常常见，所以有两个 widgets 可以帮助其他 widgets 在动画改变值时进行重新构建： AnimatedWidget 和 AnimatedBuilder。第一个是 AnimatedWidget，对于无状态动画 widgets 来说是尤其有用的。要使用 AnimatedWidget，只需继承它并实现一个 build 方法。第二个是 AnimatedBuilder，对于希望将动画作为复杂 widgets 的 build 方法的其中一部分的情况非常有用。要使用 AnimatedBuilder，只需构造 widget 并将 AnimatedBuilder 传递给 widget 的 builder 方法。

## :smile: 目标平台向 Flutter 发起 channel 调用的时候，需要在对应平台的主线程执行。同样的，在 Flutter 向目标平台发起 channel 调用的时候，需要在根 Isolate 中执行。对应平台侧的 handler 既可以在平台的主线程执行，也可以通过事件循环在后台执行。对应平台侧 handler 的返回值可以在任意线程异步执行。

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


