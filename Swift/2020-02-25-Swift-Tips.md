# Swift Tips

## :smile:[Swift 标准库中已定义运算优先级组完整列表](https://github.com/apple/swift-evolution/blob/master/proposals/0077-operator-precedence.md)

## :smile: 根据是否会对调用者发生突变进行适当的修改名字。 突变方法通常应当具有类似语义的非显式变体，它的结果会返回一个新值，而不是就地更新实例。   
（1）突变和非突变函数命名的区别。 （当用动词描述函数时，将函数命名为动词，并应用“ed”或“ing”后缀来命名非突变的函数。）
Mutating 突变 | Nonmutating 非突变  
-|-|-
x.sort()	 | z = x.sorted()
x.append(y)  | z = x.appending(y)

（2）突变和非突变函数命名的区别。 （当使用名词描述时，将函数命名为名词，并应用“form”前缀命名其突变函数。）
Mutating 突变 | Nonmutating 非突变  
-|-|-
y.formUnion(z)	 | x = y.union(z)
c.formSuccessor(&i)  | j = c.successor(i)(y)

## :smile:例如包含 associated type 或者Self的协议只能作为泛型的类型约束。例如Equatable只能作为泛型的类型约束，而不能作为可以直接定义某值的类型，也没有Equatable<Int> 的写法，Equatable 不是泛型类型，只是泛型约束。

## :smile:在C/OC中我们可以直接使用sizeof获取一个变量所占用的内存大小，在Swift中这种方式是不能使用的，Swift提供了一个MemLayout的Api用来获取内存信息

- MemoryLayout.size(ofValue value: T) // 获取变量实际占用的内存大小

- MemoryLayout.stride(ofValue value: T)     // 获取创建变量所需要的分配的内存大小

- MemoryLayout.alignment(ofValue: T) // 获取变量的内存对齐数

通常为了提高cpu对内存访问的效率，在分配内存空间时都会进行内存对齐操作，所以size指的是变量实际所占用的内存大小，stride指的是经过内存对齐后创建变量需要开辟的内存空间大小，但实际上多余出来的内存空间并没有使用，仅仅是为了将内存对齐而已。

```swift
enum Color {
   case red
   case yellow
   case blue
}

func testEnum() {
    let i: Int = 1
    print(MemoryLayout.size(ofValue: i))       // 8
  
    let color = Color.blue
    print(MemoryLayout.alignment(ofValue: color))  // 1
    print(MemoryLayout.size(ofValue: color))       // 1
    print(MemoryLayout.stride(ofValue: color))     // 1
}
```
通过MemoryLayout我们可以得知一个Int类型的变量占用8个字节（以下所有测试数据都是基于64位系统），而一个Color枚举变量的只需要占用一个字节的空间。

## :smile:通常如果我们知道了一个内存地址，我们可以通过下面两种方式查看地址对应内存空间存放的数据：

1、我们可以在xcode -> Debug -> Debug workflow -> View Memory中输入内存地址定位到那块内存空间

2、在lldb中使用指令memory read + 内存地址读取指针对应的内存。也可以直接使用指令x简化书写，效果等同于memory read

## :smile:现在问题就变成我们该如何获取Swift变量的内存地址了，但由于xcode对Swift语言做了非常多的封装和屏蔽，断点调试时，我们不能直接像oc/c语言那样直接看到枚举变量的地址，我们只能通过Swift的方式获取内存地址。
```
//值类型变量的内存地址
func getPointer<T>(of value: inout T) -> UnsafeRawPointer {//返回指针，可直接print输出内存地址
      return withUnsafePointer(to: &value, { UnsafeRawPointer($0) })
}
//引用类型变量指向的内存地址
Unmanaged.passUnretained(value).toOpaque()//返回指针，可直接print输出内存地址
```

## :smile:提醒：Swift和OC混编时，Swift中的enum要想在OC中使用，需要添加@objc修饰符，而添加完@objc修饰符之后，swift的枚举占用的内存大小就不是由枚举类型的数目决定的了，而是固定为和Int类型大小一致。

## :smile:对于枚举的探索就到这里了，下面来总结一下我们学到的知识吧。

1、简单枚举<没有关联值>的本质就是一个整型值，整型值的大小取决于该枚举所定义的类型的数量。

2、给枚举添加原始值不会影响枚举自身的任何结构，设置原始值其实是编译器帮我们添加了rawValue属性，init(rawValue)方法(RawRepresentable协议)。

3、添加关联值会影响枚举内存结构，关联值被储存在枚举变量中，枚举变量的大小取决于占用内存最大的那个类型。

4、添加/调用"实例方法"、"类型方法"、计算属性以及实现协议的本质都是添加/调用函数。

5、对于没有添加关联值的枚举系统会默认帮我们实现Hashable/Equatable协议。

## :smile:@available 在存储属性上的实现方法
@available： 可用来标识计算属性、函数、类、协议、结构体、枚举等类型的生命周期。但是不能用于存储属性。

在存储属性上的实现：

```swift
//方法一
private var _selectionFeedbackGenerator: Any? = nil
@available(iOS 10.0, *)
public var selectionFeedbackGenerator: UISelectionFeedbackGenerator {
    if _selectionFeedbackGenerator == nil {
        _selectionFeedbackGenerator = UISelectionFeedbackGenerator()
    }
    return _selectionFeedbackGenerator as! UISelectionFeedbackGenerator
}
//方法二 ：use lazy
@available(iOS 10.0, *)
private(set) lazy var center = UNUserNotificationCenter.current()
```

## :smile:Swift 的 nil 和 Objective-C 中的 nil 并不一样。在 Objective-C 中，nil 是一个指向不存在对象的指针。在 Swift 中，nil 不是指针——它是一个确定的值，用来表示值缺失。任何类型的可选状态都可以被设置为 nil，不只是对象类型。

## :smile:可以把隐式解析可选类型当做一个可以自动解析的可选类型
一个隐式解析可选类型其实就是一个普通的可选类型，但是可以被当做非可选类型来使用，并不需要每次都使用解析来获取可选值。下面的例子展示了可选类型 String 和隐式解析可选类型 String 之间的区别：
```
let possibleString: String? = "An optional string."
let forcedString: String = possibleString! // 需要感叹号来获取值

let assumedString: String! = "An implicitly unwrapped optional string."
let implicitString: String = assumedString  // 不需要感叹号
```
你可以把隐式解析可选类型当做一个可以自动解析的可选类型。当你使用一个隐式解析可选值时，Swift 首先会把它当作普通的可选值；如果它不能被当成可选类型使用，Swift 会强制解析可选值。在以上的代码中，可选值 assumedString 在把自己的值赋给 implicitString 之前会被强制解析，原因是 implicitString 本身的类型是非可选类型的 String。在下面的代码中，optionalString 并没有显式的数据类型。那么根据类型推断，它就是一个普通的可选类型。
```
let optionalString = assumedString
// optionalString 的类型是 "String?"，assumedString 也没有被强制解析。
```

## :smile:以下位置添加属性观察器：
- 自定义的存储属性
- 继承的存储属性
- 继承的计算属性

> 在父类初始化方法调用之后，在子类构造器中给父类的属性赋值时，会调用父类属性的 willSet 和 didSet 观察器。而在父类初始化方法调用之前，给子类的属性赋值时不会调用子类属性的观察器。

> 如果将带有观察器的属性通过 in-out 方式传入函数，willSet 和 didSet 也会调用。这是因为 in-out 参数采用了拷入拷出内存模式：即在函数内部使用的是参数的 copy，函数结束后，又对参数重新赋值。

## :smile:
- 全局的常量或变量都是延迟计算的，跟 延时加载存储属性 相似，不同的地方在于，全局的常量或变量不需要标记 lazy 修饰符。
- 局部范围的常量和变量从不延迟计算。
- 存储型类型属性是延迟初始化的，它们只有在第一次被访问的时候才会被初始化。即使它们被多个线程同时访问，系统也保证只会对其进行一次初始化，并且不需要对其使用 lazy 修饰符。

## :smile:在 C 或 Objective-C 中，与某个类型关联的静态常量和静态变量，是作为 global（全局）静态变量定义的。但是在 Swift 中，类型属性是作为类型定义的一部分写在类型最外层的花括号内，因此它的作用范围也就在类型支持的范围内。

## :smile:NSStringFromClass()与String(describing:)的区别
```
print(NSStringFromClass(Self.self))//SwiftManExample.TestViewController
print(String(describing: Self.self))//TestViewController
```
## :smile:关于 @escaping 最后还有一点想要说明。如果你在协议或者父类中定义了一个接受 @escaping 为 参数方法，那么在实现协议和类型或者是这个父类的子类中，对应的方法也必须被声明为@escaping ，否则两个方法会被认为拥有不同的函数签名。

## :smile:在一个协议加入了像是 associatedtype 或者 Self 的约束 后，它将只能被用为泛型约束，而不能作为独立类型的占位使用，也失去了动态派发的特性。也就是说，这种情况下，我们需要将函数改写为泛型。

## :smile: convenience 的初始化方法是 不能被子类重写或者是从子类中以 super 的方式被调用的。

## :smile:class 关键字相比起来就明白许多，是专⻔用在 class 类型的上下文中的，可以用来修饰类方法 以及类的计算属性。但是有一个例外， class 中现在是不能出现 class 的存储属性的。在 Swift 1.2 及之后，我们可以在 class 中使用 static 来声明一个类作用域的变量。有了这个特性之后，像单例的写法就可以回归到我们所习惯的方式了。
```swift
class MyClass {
    class var bar: Bar?//编译时会得到一个错误: class variables not yet supported,储存属性需使用static
}
```

## :smile:和其他很多语言的默认参数相比较，Swift 中的默认参数限制更少，并没有所谓 "默认参数之后不 能再出现无默认值的参数"这样的规则。

## :smile:使用 fr v -R 命令来打印出变量的未加工过时的信息

```swift
(lldb) fr v -R anotherNil
(Swift.Optional<Swift.Optional<Swift.String>>)
    anotherNil = Some {
... 中略 }
(lldb) fr v -R literalNil
(Swift.Optional<Swift.Optional<Swift.String>>)
    literalNil = None {
... 中略 }
```
## :smile:dump指令：object的内容用其镜像进行标准输出

## :smile:我们⽤ FREE_VERSION 这个编译符号来代表免费版本。为了使之有效，我们需要在项⽬的编译选项中进⾏设置，在项⽬的 Build Settings 中，找到 Swift Compiler - Custom Flags，并在其中的 Other Swift Flags 加上 -D FREE_VERSION 就可以了。
```swift
@IBAction func someButtonPressed(sender: AnyObject!) {
#if FREE_VERSION
// 弹出购买提示，导航⾄商店等
#else
// 实际功能
#endif
}
```

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




