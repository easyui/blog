# 属性包装(propertyWrapper)

一起学习下 Swift UI 中 @State 和 @Binding 的准备知识， 这种标记的本质是属性包装（propertyWrapper），也叫属性包装器（Property Wrappers）。不论是 @State，@Binding，或者是我们在下一节中将要看到的 @ObjectBinding 和 @EnvironmentObject，它们都是被 @propertyWrapper 修饰的 struct 类型。代码如下
```
struct OrderForm : View {
  @State private var order: Order
  
  var body: some View {
    Stepper(value: $order.quantity, in: 1...10) {
      Text("Quantity: \(order.quantity)")
    }
  }
}
```
这个语言特性非常通用，任何对于属性的存取有“套路”的访问，都可以用它来包装这种“套路”。我们先来学习一下几个套路。

## 1. 包装懒初始化逻辑
为了实现属性 text 为懒初始化的属性，我们可以写成如下代码：
```
public struct MyType {
  var textStorage: String? = nil
  
  public var text: String {
    get {
      guard let value = textStorage else {
        fatalError("text has not yet been set!")
      }
      return value
    }
    
    set {
      textStorage = newValue
    }
  }
}
```
然而如果有很多属性都是这样的逻辑，这样的写法是很冗余的。所以属性包装就是解决这个问题的：
```
@propertyWrapper
public struct LateInitialized<Value> {
  private var storage: Value?
  
  public init() {
    storage = nil
  }
  
  public var value: Value {
    get{
      guard let value = storage else {
        fatalError("value has not yet been set!")
      }
      return value
    }
    set {
      storage = newValue
    }
  }
}

// 应用属性包装 LateInitialized
public struct MyType {
  @LateInitialized public var text: String?
}
```
属性包装 LateInitialized 是一个泛型类型，它本身用 @propertyWrapper 修饰，它必须有一个叫 value 的属性类型为 Value，有了这些约定后，编译器可以为 MyType 的 text 生成以下代码：
```
public struct MyType {
  var $text: LateInitialized<String> = LateInitialized<String>()

  public var text: String {
      get { $text.value }
      set { $text.value = newValue}
  }
}
```
可以看到，经过属性包装包装过后的 text，编译器帮助生成了一个存储属性为 $text，类型就是这个属性包装，而 text本身变成了一个计算属性。大家可能觉得 $text属性是编译器生成的，所以不可以访问，事实恰恰相反，text 和 $text 都可以用。

## 2. 包装防御性拷贝
我们再来看一下一个防御性拷贝的例子，它基于 NSCopying
```
@propertyWrapper
public struct DefensiveCopying<Value: NSCopying> {
  private var storage: Value
  
  public init(initialValue value: Value) {
    storage = value.copy() as! Value
  }
  
  public var value: Value {
    get { storage }
    set {
      storage = newValue.copy() as! Value
    }
  }
}

// 应用属性包装 DefensiveCopying
public struct MyType {
  @DefensiveCopying public var path: UIBezierPath = UIBezierPath()
}
```
属性包装 DefensiveCopying 的不同点在于它的初始化函数 init(initialValue:)，这个函数由于编译器的约定，所以一定得叫这个名字。与上个例子一样，编译器会生成存储属性 $path，并用初始值初始化。

这里我们吹毛求疵一下，UIBezierPath 被强制拷贝了一次，所以我们再提供一个属性包装的初始化函数，并应用它：
```
// DefensiveCopying 中增加
  public init(withoutCopying value: Value) {
    storage = value
  }
  
// 应用不拷贝的初始化函数
public struct MyType {
  @DefensiveCopying public var path: UIBezierPath
  
  init() {
    $path = DefensiveCopying(withoutCopying: UIBezierPath())
  }
}
```
在应用的部分我们看到可以像初始化一个一般变量一样初始化$path，这也印证了我们之前说的$path和path的本质。但是这样的语法毕竟有点难看，在不需要$path 出现的时候应该尽可能隐藏它：
```
public struct MyType {
  @DefensiveCopying(withoutCopying: UIBezierPath())
  public var path: UIBezierPath
}
```
## 3. 包装 UserDefaults 的存取
我们经常需要将属性写成针对UserDefaults存取的计算属性，而这个通用访问策略也能用属性包装实现：
```
@propertyWrapper
struct UserDefault<T> {
  let key: String
  let defaultValue: T
  
  var value: T {
    get {
      return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
    }
    set {
      UserDefaults.standard.set(newValue, forKey: key)
    }
  }
}

// 应用属性包装 UserDefault
enum GlobalSettings {
  @UserDefault(key: "FOO_FEATURE_ENABLED", defaultValue: false)
  static var isFooFeatureEnabled: Bool
  
  @UserDefault(key: "BAR_FEATURE_ENABLED", defaultValue: false)
  static var isBarFeatureEnabled: Bool
}
```

## 结语
所有对于属性访问策略的抽象，都可以使用属性包装来实现，我们还可以想到 Thread-local storage（线程本地存储）属性存取、原子属性存取、Copy-on-write 属性存取、引用包装类型属性的存取都可以使用属性包装来实现。当然 SwiftUI 的 @State 和 @Binding 也是属性包装。

thx
> [SwiftUI 和 Swift 5.1 新特性(2) 属性包装Property Delegates](https://juejin.im/post/5cfcf51151882518e845c17c)