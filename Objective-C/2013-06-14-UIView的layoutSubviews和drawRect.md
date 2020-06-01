# UIView的layoutSubviews和drawRect 

UIView的setNeedsDisplay和setNeedsLayout方法。首先两个方法都是`异步`执行的。setNeedsDisplay会调用自动调用drawRect方法，这样可以拿到UIGraphicsGetCurrentContext，就可以画画了。而setNeedsLayout会默认调用layoutSubViews，就可以处理子视图中的一些数据。

综上两个方法都是异步执行的，layoutSubviews方便数据计算，drawRect方便视图重绘。

先大概看下ios layout机制相关的这几个方法：

```
- (CGSize)sizeThatFits:(CGSize)size

- (void)sizeToFit

——————-

- (void)layoutSubviews

- (void)layoutIfNeeded

- (void)setNeedsLayout

——————–

- (void)setNeedsDisplay

- (void)drawRect
```

## 一、

layoutSubviews在以下情况下会被调用：

1、init初始化不会触发layoutSubviews。

2、addSubview会触发layoutSubviews。

3、设置view的Frame会触发layoutSubviews，当然前提是frame的值设置前后发生了变化。

4、滚动一个UIScrollView会触发layoutSubviews。

5、旋转Screen会触发父UIView上的layoutSubviews事件。

6、改变一个UIView大小的时候也会触发父UIView上的layoutSubviews事件。

7、直接调用setLayoutSubviews。

8、直接调用setNeedsLayout。

在苹果的官方文档中强调:You should override this method only if the autoresizing behaviors of the subviews do not offer the behavior you want. 

layoutSubviews, 当我们在某个类的内部调整子视图位置时，需要调用。

反过来的意思就是说：`如果你想要在外部设置subviews的位置，就不要重写。`

 

刷新子对象布局

- layoutSubviews方法：这个方法，默认没有做任何事情，需要子类进行重写

- setNeedsLayout方法： 标记为需要重新布局，异步调用layoutIfNeeded刷新布局，不立即刷新，但layoutSubviews一定会被调用

- layoutIfNeeded方法：如果，有需要刷新的标记，立即调用layoutSubviews进行布局（如果没有标记，不会调用layoutSubviews）

`如果要立即刷新，要先调用[view setNeedsLayout]，把标记设为需要布局，然后马上调用[view layoutIfNeeded]，实现布局`

`在视图第一次显示之前，标记总是“需要刷新”的，可以直接调用[view layoutIfNeeded]`

## 二、

drawRect在以下情况下会被调用：

1、如果在UIView初始化时没有设置rect大小，将直接导致drawRect不被自动调用。drawRect 掉用是在Controller->loadView, Controller->viewDidLoad 两方法之后掉用的.所以不用担心在 控制器中,这些View的drawRect就开始画了.这样可以在控制器中设置一些值给View(如果这些View draw的时候需要用到某些变量 值).

2、该方法在调用sizeToFit后被调用，所以可以先调用sizeToFit计算出size。然后系统自动调用drawRect:方法。

sizeToFit会自动调用sizeThatFits方法；

sizeToFit不应该在子类中被重写，应该重写sizeThatFits

sizeThatFits传入的参数是receiver当前的size，返回一个适合的size

sizeToFit可以被手动直接调用

`sizeToFit和sizeThatFits方法都没有递归，对subviews也不负责，只负责自己`

3、通过设置contentMode属性值为UIViewContentModeRedraw。那么将在每次设置或更改frame的时候自动调用drawRect:。

4、直接调用setNeedsDisplay，或者setNeedsDisplayInRect:触发drawRect:，但是有个前提条件是rect不能为0。

-setNeedsDisplay方法：标记为需要重绘，异步调用drawRect

-setNeedsDisplayInRect:(CGRect)invalidRect方法：标记为需要局部重绘

以上1,2推荐；而3,4不提倡

 

drawRect方法使用注意点：

1、 若使用UIView绘图，只能在drawRect：方法中获取相应的contextRef并绘图。如果在其他方法中获取将获取到一个invalidate 的ref并且不能用于画图。drawRect：方法不能手动显示调用，必须通过调用setNeedsDisplay 或 者 setNeedsDisplayInRect，让系统自动调该方法。

2、若使用calayer绘图，只能在`drawInContext:` 中（类似鱼drawRect）绘制，或者在delegate中的相应方法绘制。同样也是调用setNeedDisplay等间接调用以上方法

3、`若要实时画图，不能使用gestureRecognizer，只能使用touchbegan等方法来掉用setNeedsDisplay实时刷新屏幕`

## 三、

layoutSubviews对`subviews`重新布局

layoutSubviews方法调用先于drawRect

setNeedsLayout在receiver标上一个需要被重新布局的标记，在系统runloop的下一个周期自动调用layoutSubviews

layoutIfNeeded方法如其名，UIKit会判断该receiver是否需要layout.根据Apple官方文档,layoutIfNeeded方法应该是这样的

layoutIfNeeded遍历的不是superview链，应该是`subviews`链

drawRect是对receiver的重绘，能获得context

setNeedDisplay在receiver标上一个需要被重新绘图的标记，在下一个draw周期自动重绘，iphone device的刷新频率是60hz，也就是1/60秒后重绘