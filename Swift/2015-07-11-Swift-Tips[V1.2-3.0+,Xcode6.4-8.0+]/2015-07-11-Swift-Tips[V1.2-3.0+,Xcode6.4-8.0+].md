# Swift Tips(version1.2 xcode6.4)

## :smile:颜色转图片
```swift
extension UIImage{  
    static func ls_imageWithColor(color: UIColor) -> UIImage  
    {  
        let imageSize = CGSizeMake(1, 1);  
        UIGraphicsBeginImageContextWithOptions(imageSize, true, 0);  
        color.set();  
        let path = UIBezierPath(rect: CGRectMake(0, 0, imageSize.width, imageSize.height))  
        path.fill()  
        let image = UIGraphicsGetImageFromCurrentImageContext()  
        UIGraphicsEndImageContext()  
        return image  
    }  
      
} 
```

## :smile:方向
```swift
// MARK: - Orientations  
override func shouldAutorotate() -> Bool {  
    return true  
}  
  
override func supportedInterfaceOrientations() -> Int {  
    return UIInterfaceOrientationMask.Portrait.rawValue.hashValue  
}  
```

## :smile:Swift调用oc枚举不识别
```swift
typedef NS_ENUM(NSInteger, EZCameraState)  
{  
    EZCameraStateFront,  
    EZCameraStateBack  
};
```
改为
```swift
typedef NS_ENUM(NSInteger, EZCameraState)  
{  
    Front,  
    Back  
};
```

## :smile: 背景图片不要用(其实以前也是，貌似和Swift没什么关系哈哈)：
```swift
     self.view.backgroundColor = UIColor(patternImage: UIImage(named: "videoAotu")!)//patternImage耗内存
用：
    //改成：
    self.view.layer.contents = UIImage(named: "videoAotu")?.CGImage
```

## :smile: oc中的#pragma mark  在swift中是：//MARK:    其他还有 //TODO:、//FIXME。

## :smile:  在子类必须实现的方法中调用这个函数fatalError("方法未实现")。使用了fatalError方法的地方编译可过。但是在运行的时候会报错！

## :smile: Swift1.2中没有appearanceWhenContainedIn:方法 [详细](https://github.com/easyui/blog/blob/master/Swift/2015-07-13-Swift-appearanceWhenContainedIn%5BVersion1.2,Xcode6.4%5D.md)

## :smile: Swift单例
```swift
class LSHostAppManager{  
      
    class func shareInstance()->LSHostAppManager{  
        struct LSSingleton{  
            static var predicate:dispatch_once_t = 0  
            static var instance:LSHostAppManager? = nil  
        }  
        dispatch_once(&LSSingleton.predicate,{  
            LSSingleton.instance=LSHostAppManager()  
            }  
        )  
        return LSSingleton.instance!  
    }  
}  
```

```swift
struct StructSingleton{  
    static func shareInstance()->StructSingleton{  
        struct YRSingleton{  
            static var predicate:dispatch_once_t = 0  
            static var instance:StructSingleton? = nil  
        }  
        dispatch_once(&YRSingleton.predicate,{  
                YRSingleton.instance=StructSingleton()  
            }  
        )  
        return YRSingleton.instance!  
    }  
}   
```

# Swift Tips(version2.0+ xcode7.0+) 
## :smile:
![参数传递限制](参数传递限制.png)

## :smile:打印多重Optional
```swift
var literalNil: String?? = nil

//对于上面变量po只会输出nil
(lldb) po literalNil 
nil

//但使用 fr v -r 或 fr v -R 可以打印详细信息
(lldb) fr v -r  literalNil
(String??) literalNil = nil
(lldb) fr v -R  literalNil
(Swift.Optional<Swift.Optional<Swift.String>>) literalNil = None {
  Some = Some {
    Some = {
      _core = {
        _baseAddress = {
          _rawValue = 0x0000000000000000
        }
        _countAndFlags = {
          value = 0
        }
        _owner = None {
          Some = {
            instance_type = 0x0000000000000000
          }
        }
      }
    }
  }
}
```
## :smile:Protocol扩展
![Protocol扩展](Protocol扩展.png)

## :smile:Swift 2.2 已将协议中 associated types 的关键字由 typealias 替换为 associatedtype
 
## :smile:Swift 2.2 ==比较符支持元组类型
 
## :smile:Swift 2.2 增加#if swift 语法判断当前swift版本
```swift
#if swift(>=2.2)  
  
#else  
  
#endif 
```
 
## :smile: Swift 2.2 从 Swift 2.2 开始我们使用 #selector 来从暴露给 Objective-C 的代码中获取一个 selector。类似地，在 Swift 里对应原来 SEL 的类型是一个叫做 Selector 的结构体。
 
## :smile:Swift 2.2 func 参数修饰var废弃，若要参数还是可变的话只能使用inout关键字
 
## :smile:Swift 2.2 #file#line#column#function编译标记替代原来的 __FILE__  __LINE__ __COLUMN__ __FUNCTION__

# Swift Tips(version3.0+ xcode8.0+) 

