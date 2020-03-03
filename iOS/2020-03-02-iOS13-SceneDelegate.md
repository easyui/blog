# iOS13-SceneDelegate
https://www.jianshu.com/p/53e3252dc07e

https://www.jianshu.com/p/801de3beee22
## :smile:iOS13中presentViewController的问题
更新了Xcode11.0 beta之后，在iOS13中运行代码发现presentViewController和之前弹出的样式不一样。

会出现这种情况是主要是因为我们之前对UIViewController里面的一个属性，即modalPresentationStyle（该属性是控制器在模态视图时将要使用的样式）没有设置需要的类型。在iOS13中modalPresentationStyle的默认改为UIModalPresentationAutomatic,而在之前默认是UIModalPresentationFullScreen。

```
/*
 Defines the presentation style that will be used for this view controller when it is presented modally. Set this property on the view controller to be presented, not the presenter.
 If this property has been set to UIModalPresentationAutomatic, reading it will always return a concrete presentation style. By default UIViewController resolves UIModalPresentationAutomatic to UIModalPresentationPageSheet, but other system-provided view controllers may resolve UIModalPresentationAutomatic to other concrete presentation styles.
 Defaults to UIModalPresentationAutomatic on iOS starting in iOS 13.0, and UIModalPresentationFullScreen on previous versions. Defaults to UIModalPresentationFullScreen on all other platforms.
 */
@property(nonatomic,assign) UIModalPresentationStyle modalPresentationStyle API_AVAILABLE(ios(3.2));
```

要改会原来模态视图样式，我们只需要把UIModalPresentationStyle设置为UIModalPresentationFullScreen即可。


```
ViewController *vc = [[ViewController alloc] init];
vc.title = @"presentVC";
UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
nav.modalPresentationStyle = UIModalPresentationFullScreen;
[self.window.rootViewController presentViewController:nav animated:YES completion:nil];
```

注意：UIModalPresentationOverFullScreen最低支持iOS 8，如果你还要支持iOS 8以下版本，那么你可以用UIModalPresentationFullScreen，这个两个值的交互略有些细微差别，具体的可以自己看下效果。

## :smile:iOS不允许valueForKey、setValue: forKey获取和设置私有属性，需要使用其它方式修改
在使用iOS 13运行项目时突然APP就crash掉了。定位到的问题是在设置UITextField的Placeholder也就是占位文本的颜色和字体时使用了KVC的方法：

```
[_textField setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
[_textField setValue:[UIFont systemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
```

可以将其替换为

```
_textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"姓名" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor redColor]}];
```

并且只需要在初始化的时候设置attributedPlaceholder即富文本的占位文本，再重新赋值依然使用placeolder直接设置文本内容，样式不会改变。

## :smile:MPMoviePlayerController 在iOS 13已经不能用了

## :smile:iOS 13 DeviceToken有变化
```
NSString *dt = [deviceToken description];
dt = [dt stringByReplacingOccurrencesOfString: @"<" withString: @""];
dt = [dt stringByReplacingOccurrencesOfString: @">" withString: @""];
dt = [dt stringByReplacingOccurrencesOfString: @" " withString: @""];
这段代码运行在 iOS 13 上已经无法获取到准确的DeviceToken字符串了，iOS 13 通过[deviceToken description]获取到的内容已经变了。
```

解决方案:
```
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    if (![deviceToken isKindOfClass:[NSData class]]) return;
    const unsigned *tokenBytes = [deviceToken bytes];
    NSString *hexToken = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
                          ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
                          ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
                          ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
    NSLog(@"deviceToken:%@",hexToken);
}
```


## :smile:即将废弃的 LaunchImage
从 iOS 8 的时候，苹果就引入了 LaunchScreen，我们可以设置 LaunchScreen来作为启动页。当然，现在你还可以使用LaunchImage来设置启动图。不过使用LaunchImage的话，要求我们必须提供各种屏幕尺寸的启动图，来适配各种设备，随着苹果设备尺寸越来越多，这种方式显然不够 Flexible。而使用 LaunchScreen的话，情况会变的很简单， LaunchScreen是支持AutoLayout+SizeClass的，所以适配各种屏幕都不在话下。
注意啦⚠️，从2020年4月开始，所有使⽤ iOS13 SDK的 App将必须提供 LaunchScreen，LaunchImage即将退出历史舞台。


## :smile:Dark Mode
如果你的 App 在 iPhone X 上运行发现没有充满屏幕，上下有黑边，说明你没有使用 storyboard 做 LaunchImage，而是用的 Assets。Assets 的解决办法是添加一张尺寸为1125x2436的LaunchImage。

## :smile:Web Content适配
[https://blog.csdn.net/u012413955/article/details/92198556](https://blog.csdn.net/u012413955/article/details/92198556)

## :smile:iOS 13支持的机型如下
 iPhone XS

  iPhone XS Max

  iPhone XR

  iPhone X

  iPhone 8

  iPhone 8 Plus

  iPhone 7

  iPhone 7 Plus

  iPhone 6s

  iPhone 6s Plus

  iPhone SE

  iPod touch (第七代)
  

## :smile:第三方登录
如果 APP 支持三方登陆（Facbook、Google、微信、QQ、支付宝等），就必须支持苹果登录，且要放前边.

[Sign in with  设计规范](https://developer.apple.com/design/human-interface-guidelines/sign-in-with-apple/overview/)


## :smile:UISegmentedControl 默认样式改变
默认样式变为白底黑字，如果设置修改过颜色的话，页面需要修改

## :smile:UITabbar 层次发生改变，无法通过设置 shadowImage去掉上面的线

## :smile:App启动过程中，部分View可能无法实时获取到frame
可能是为了优化启动速度，App 启动过程中，部分View可能无法实时获取到正确的frame

```
// 只有等执行完 UIViewController 的 viewDidAppear 方法以后，才能获取到正确的值，在viewDidLoad等地方 frame Size 为 0，例如：
 [[UIApplication sharedApplication] statusBarFrame];
```

## :smile:CNCopyCurrentNetworkInfo 变化
```
 An app that fails to meet any of the above requirements receives the following return value:

- An app linked against iOS 12 or earlier receives a dictionary with pseudo-values. In this case, the SSID is Wi-Fi (or WLAN in the China region), and the BSSID is 00:00:00:00:00:00.
- An app linked against iOS 13 or later receives NULL.
```

iOS13 以后只有开启了 Access WiFi Information capability，才能获取到 SSID 和 BSSID

## :smile:UIActivityIndicatorView
之前的 UIActivityIndicatorView 有三种 style 分别为 whiteLarge, white 和 gray，现在全部废弃。

增加两种 style 分别为 medium 和 large，指示器颜色用 color 属性修改。


