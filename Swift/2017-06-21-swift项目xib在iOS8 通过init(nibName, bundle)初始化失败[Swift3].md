在项目中初始化代码：
```
MatchViewControllerPhone(nibName:"MatchViewControllerPhone", bundle: nil)
```

MatchViewControllerPhone类部分代码：
```
class MatchViewControllerPhone: UIViewController 
    @IBOutlet weak var container: UIScrollView!
 // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
         self.container.delegate = self   //在iOS8设备上报错：fatal error: unexpectedly found nil while unwrapping an Optional value
    }
 
}
```

查看发现xib里的子控件都为nil导致的。

后来发现init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)中nibNameOrNil参数在iOS8中为空，所有有以下解决方案：
```
override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
     let classString = String(describing: type(of: self))
     super.init(nibName: nibNameOrNil ?? classString, bundle: nibBundleOrNil)
}

```

ps：
- 在iOS9iOS10设备上是好的，估计被苹果修复了
- 在storyboard中也是好的，所以xib换成storyboard也是可以解决的。 






