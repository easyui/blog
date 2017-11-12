# 2017-09-27-iOS11-sdk11-xcode9-iphone8/8+/x适配

## :smile:[《Human Interface Guidelines - iPhone X》](https://developer.apple.com/ios/human-interface-guidelines/overview/iphone-x/)
## :smile:[《Human Interface Guidelines - What's New in iOS 11》](https://developer.apple.com/ios/human-interface-guidelines/overview/whats-new/) 
## :smile:AVAssetTrack中mediaType: String --> AVMediaType
## :smile:AVPlayer中isClosedCaptionDisplayEnabled: Deprecated
## :smile:AVPlayerLayer中videoGravity: String --> AVLayerVideoGravity

## App 在 iPhone X 适配全屏
如果你的 App 在 iPhone X 上运行发现没有充满屏幕，上下有黑边，说明你没有使用 storyboard 做 LaunchImage，而是用的 Assets。Assets 的解决办法是添加一张尺寸为1125x2436的LaunchImage。

## tableView的section头和尾为0
iOS11以前想要实现section头和尾为0，代码中把tableView的heightForFooterInSection和heightForHeaderInSection设置成0.1即可：

```
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
        return 0.0001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001;
}
```

但是在iOS11上发生tableView头尾出现空白间距，原因是代码中只实现了heightForHeaderInSection（heightForFooterInSection）方法，而没有实现viewForHeaderInSection（viewForFooterInSection）方法。那样写是不规范的，只实现高度，而没有实现view，但代码这样写在iOS11之前是没有问题的，在iOS11中如果不实现 viewForHeaderInSection:和 viewForFooterInSection: ，则heightForHeaderInSection:和heightForFooterInSection:不会被调用，导致它们都变成了默认高度，这是因为tableView在iOS11默认使用Self-Sizing，tableView的estimatedRowHeight、estimatedSectionHeaderHeight、 estimatedSectionFooterHeight三个高度估算属性由默认的0变成了UITableViewAutomaticDimension（iOS11之前是0），解决办法是

方法一：

添加上viewForHeaderInSection（viewForFooterInSection）方法后会执行heightForHeaderInSection（heightForFooterInSection）问题就解决了。

方法二：
或者添加以下代码关闭估算行高，问题也得到解决：

```
_tableView.estimatedRowHeight = 0;
_tableView.estimatedSectionHeaderHeight = 0;
_tableView.estimatedSectionFooterHeight = 0;
```

## oc也开始支持新api判断系统版本`@available(iOS 11.0, *) `

## iPhone X中横屏不会显示statusbar
在UIViewController中设置了都显示statusbar：

```swift
    override open var prefersStatusBarHidden: Bool{
       return false
    }
```
在除了iPhoneX的其他设备上横屏都能显示statusbar（无论是iOS11还是iOS10等），但是在iPhoneX上横屏是不显示statusbar的。

## iOS 7 之后苹果给 UIViewController 引入了 topLayoutGuide 和 bottomLayoutGuide 两个属性来描述不希望被透明的状态栏或者导航栏遮挡的最高位置(status bar, navigation bar, toolbar, tab bar 等)。这个属性的值是一个 length 属性( topLayoutGuide.length)。 这个值可能由当前的 ViewController 或者 NavigationController 或者 TabbarController 决定。 iOS 11 开始弃用了这两个属性， 并且引入了 Safe Area 这个概念。苹果建议: 不要把 Control 放在 Safe Area 之外的地方。

```swift
 // These objects may be used as layout items in the NSLayoutConstraint API
    @available(iOS, introduced: 7.0, deprecated: 11.0)
    open var topLayoutGuide: UILayoutSupport { get }

    @available(iOS, introduced: 7.0, deprecated: 11.0)
    open var bottomLayoutGuide: UILayoutSupport { get }
```

## UIView 中的 safe area
iOS 11 中 UIViewController 的 topLayoutGuide 和 bottonLayoutGuide 两个属性被 UIView 中的 safeAreaInsets 替代了:

```swift
    @available(iOS 11.0, *)
    open var safeAreaInsets: UIEdgeInsets { get }
```
这个属性表示相对于屏幕四个边的间距。

![safeAreaInsetsPor](safeAreaInsetsPor.png)

竖屏下safeAreaInsets的值是：

UIEdgeInsets(top: 44.0, left: 0.0, bottom: 34.0, right: 0.0)

UIEdgeInsets(top: 20.0, left: 0.0, bottom: 0.0, right: 0.0)

> 无论statuabra显示还不是显示，iPhone X的self.view.safeAreaInsets.top 都是44.

![safeAreaInsetsLand](safeAreaInsetsLand.png)

横屏下safeAreaInsets的值是：

UIEdgeInsets(top: 20.0, left: 0.0, bottom: 0.0, right: 0.0)

UIEdgeInsets(top: 0.0, left: 44.0, bottom: 21.0, right: 44.0)












```````````````````````````````````````
iOS11之后如果设置了prefersLargeTitles = YES则为96pt



iOS11之前导航栏的title是添加在UINavigationItemView上面，而navigationBarButton则直接添加在UINavigationBar上面，如果设置了titleView，则titleView也是直接添加在UINavigationBar上面。iOS11之后，大概因为largeTitle的原因，视图层级发生了变化，如果没有给titleView赋值，则titleView会直接添加在_UINavigationBarContentView上面，如果赋值了titleView，则会把titleView添加在_UITAMICAdaptorView上，而navigationBarButton被加在了_UIButtonBarStackView上，然后他们都被加在了_UINavigationBarContentView上，如图：



iOS 7 开始，在 UIViewController中引入的 topLayoutGuide 和 bottomLayoutGuide 在 iOS 11 中被废弃了！取而代之的就是safeArea的概念，safeArea是描述你的视图部分不被任何内容遮挡的方法。 它提供两种方式：safeAreaInsets或safeAreaLayoutGuide来提供给你safeArea的参照值，即 insets 或者 layout guide。


iOS11 为UIViewController和UIView增加了一个新的方法 - (void)viewSafeAreaInsetsDidChange;



这里有一点要注意的是当UIViewController调用- (void)viewDidLoad时它的所有子视图的safeAreaInsets属性都等于UIEdgeInsetsZero, 也就是说在- (void)viewSafeAreaInsetsDidChange;方法调用前 是无法通过当前视图控制器的子视图获取到safeAreaInsets的, 不过获取当前window对象的safeAreaInsets属性用来计算也是可以的, 但是不建议这么做, 一个视图控制器的子视图的处理当然要以它所在的控制器为准.





在iOS8之后，苹果官方增加了UITableVIew的右滑操作接口，即新增了一个代理方法(tableView: editActionsForRowAtIndexPath:)和一个类(UITableViewRowAction)，代理方法返回的是一个数组，我们可以在这个代理方法中定义所需要的操作按钮(删除、置顶等)，这些按钮的类就是UITableViewRowAction。这个类只能定义按钮的显示文字、背景色、和按钮事件。并且返回数组的第一个元素在UITableViewCell的最右侧显示，最后一个元素在最左侧显示。从iOS 11开始有了一些改变，首先是可以给这些按钮添加图片了，然后是如果实现了以下两个iOS 11新增的代理方法，将会取代(tableView: editActionsForRowAtIndexPath:)代理方法：

// Swipe actions





在UI navigation bar中新增了一个BOOL属性prefersLargeTitles,将该属性设置为ture，navigation bar就会在整个APP中显示大标题，如果想要在控制不同页面大标题的显示，可以通过设置当前页面的navigationItem的largeTitleDisplayMode属性；




把你的UISearchController赋值给navigationItem，就可以实现将UISearchController集成到Navigation。


自定义视图的size为0是因为你有一些模糊的约束布局。要避免视图尺寸为0，可以从以下方面做：
● UINavigationBar 和 UIToolbar 提供位置
● 开发者则必须提供视图的size，有三种方式： 
① 对宽度和高度的约束；
② 实现 intrinsicContentSize；
③ 通过约束关联你的子视图；



基于约束的Auto Layout，使我们搭建能够动态响应内部和外部变化的用户界面。Auto Layout为每一个view都定义了margin。margin指的是控件显示内容部分的边缘和控件边缘的距离。 可以用layoutMargins或者layoutMarginsGuide属性获得view的margin,margin是视图内部的一部分。layoutMargins允许获取或者设置UIEdgeInsets结构的margin。layoutMarginsGuide则获取到只读的UILayoutGuide对象。


viewRespectsSystemMinimumLayoutMargins



Table Views：separatorInset 扩展
OS 7 引入separatorInset属性，用以设置 cell 的分割线边距，在 iOS 11 中对其进行了扩展。可以通过新增的UITableViewSeparatorInsetReference枚举类型的separatorInsetReference属性来设置separatorInset属性的参照值



在Storyboard中使用Safe Area LayoutGuides,这样有个弊端是在Storyboard使用Safe Area最低只支持iOS9，iOS8的用户就要放弃了，这样老板肯定不同意。




iOS 11 UITableView delete rows animation bug 
https://stackoverflow.com/questions/46303649/ios-11-uitableview-delete-rows-animation-bug
滚动刷新的的时候抖动：header，footer出现重复
[weakSelf.goodsTabelView scrollToRowAtIndexPath:localIndexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
[weakSelf __refreshChoosedStatus];
设置
Set estimatedRowHeight, estimatedSectionHeaderHeight, and estimatedSectionFooterHeight to 0.即可




