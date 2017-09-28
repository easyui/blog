# Swift Tips(version4.0+ xcode9.0+)

## :smile:Xcode 9 中同时集成了 Swift 3.2 和 Swift 4。
- Swift 3.2 完全兼容 Swift 3.1，并会在过时的语法或函数上报告警告。
- Swift 3.2 具有 Swift 4 的一些写法，但是性能不如 Swift 4。
- Swift 3.2 和 Swift 4 可以混合编译，可以指定一部分模块用 Swift 3.2 编译，一部分用 Swift 4 编译。
- 迁移到 Swift 4 后能获得 Swift 4 所有的新特性，并且性能比 Swift 3.2 好。

## :smile:dynamic
Swift 3中dynamic是自带@objc，但是Swift 4中，dynamic不在包含@objc了。所以有些需要使用到@objc标明的方法，在Swift 4得补回去。

## :smile:@objc
在项目中想把 Swift 写的 API 暴露给 Objective-C 调用，需要增加 @objc。在 Swift 3 中，编译器会在很多地方为我们隐式的加上 @objc，例如当一个类继承于 NSObject，那么这个类的所有方法都会被隐式的加上 @objc。
```swift
class MyClass: NSObject {
    func print() { ... } // 包含隐式的 @objc
    func show() { ... } // 包含隐式的 @objc
}
```
这样很多并不需要暴露给 Objective-C 也被加上了 @objc。大量 @objc 会导致二进制文件大小的增加。

在 Swift 4 中，隐式 @objc 自动推断只会发生在很少的当必须要使用 @objc 的情况，比如：

1、复写父类的 Objective-C 方法

2、符合一个 Objective-C 的协议

其它大多数地方必须手工显示的加上 @objc。

减少了隐式 @objc 自动推断后，Apple Music app 的包大小减少了 5.7%。
## :smile:The use of Swift 3 @objc inference in Swift 4 mode is deprecated. Please address deprecated @objc inference warnings, test your code with “Use of deprecated Swift 3 @objc inference” logging enabled, and then disable inference by changing the "Swift 3 @objc Inference" build setting to "Default" for the "ProjectName" target.
到target->build setting->swift3 @objc inference 设置为off 

## :smile:枚举更swift化
AVMetadataCommonKeyTitl -> AVMetadataKey.commonKeyTitle

AVMetadataKeySpaceCommon -> AVMetadataKeySpace.common
## :smile:AVPlayerLayer的videoGravity属性(其实是iOS11的变化)
swift3
```swift
 /*!
    	@property		videoGravity
    	@abstract		A string defining how the video is displayed within an AVPlayerLayer bounds rect.
    	@discusssion	Options are AVLayerVideoGravityResizeAspect, AVLayerVideoGravityResizeAspectFill 
     					and AVLayerVideoGravityResize. AVLayerVideoGravityResizeAspect is default. 
    					See <AVFoundation/AVAnimation.h> for a description of these options.
     */
    open var videoGravity: String  
```
swift4
```swift
    /*!
    	@property		videoGravity
    	@abstract		A string defining how the video is displayed within an AVPlayerLayer bounds rect.
    	@discusssion	Options are AVLayerVideoGravityResizeAspect, AVLayerVideoGravityResizeAspectFill 
     					and AVLayerVideoGravityResize. AVLayerVideoGravityResizeAspect is default. 
    					See <AVFoundation/AVAnimation.h> for a description of these options.
     */
    open var videoGravity: AVLayerVideoGravity
```
## :smile:extension 中可以访问 private 的属性
```swift
struct Date {
    private let secondsSinceReferenceDate: Double
}
extension Date: Equatable {
    static func ==(lhs: Date, rhs: Date) -> Bool {
        return lhs.secondsSinceReferenceDate == rhs.secondsSinceReferenceDate
    }
}
extension Date: Comparable {
    static func <(lhs: Date, rhs: Date) -> Bool {
        return lhs.secondsSinceReferenceDate < rhs.secondsSinceReferenceDate
    }
}
```
但是在 Swift 3 中，编译就报错了，因为 extension 中无法获取到 secondsSinceReferenceDate 属性，因为它是 private 的。于是在 Swift 3 中，必须把 private 改为 fileprivate，且在同一个文件里。

在 Swift 4 中，private 的属性的作用域扩大到了 extension 中

## :smile: Associated Type 可以追加 Where 约束语句
```swift
   protocol Sequence {
    associatedtype Element where Self.Element == Self.Iterator.Element
    // ...
   }
```
它限定了 Sequence 中 Element 这个类型必须和 Iterator.Element 的类型一致。

通过 where 语句可以对类型添加更多的约束，使其更严谨，避免在使用这个类型时做多余的类型判断。
## :smile: 类型和协议的组合类型
在 Swift 4 中，可以把类型和协议用 & 组合在一起作为一个类型使用，就可以像下面这样写了：
```swift
protocol Shakeable {
    func shake()
}

extension UIButton: Shakeable { /* ... */ }
extension UISlider: Shakeable { /* ... */ }

func shakeEm(controls: [UIControl & Shakeable]) {
    for control in controls where control.isEnabled {
        control.shake()
    }// Objective-C API
@interface NSCandidateListTouchBarItem<CandidateType> : NSTouchBarItem
@property (nullable, weak) NSView <NSTextInputClient> *client;
@end
}
```

在 Swift 4 中，这类 API 做了优化，改成了这样类型的声明就更加严谨了：
```swift
class NSCandidateListTouchBarItem<CandidateType: AnyObject> : NSTouchBarItem {
    var client: (NSView & NSTextInputClient)?
}
```
## :smile: KVC：新的 Key Paths 语法
Swift 3 中 Key Paths 的写法：
```swift
class Kid: NSObject {
    @objc var nickname: String = ""
    @objc var age: Double = 0.0
    @objc var friends: [Kid] = []
}

var ben = Kid(nickname: "Benji", age: 5.5)

let kidsNameKeyPath = #keyPath(Kid.nickname)

let name = ben.valueForKeyPath(kidsNameKeyPath)
ben.setValue("Ben", forKeyPath: kidsNameKeyPath)
```
上面是在swift3中使用的方法,在oc中能够很好的运行,可在swift中它有着明显的不足:

1.返回值是Any类型,错误的赋值可能导致运行时错误

2.这个类必须继承NSObject,而swift是可以不继承自任何类的

Swift 4 中创建一个 KeyPath 用 `\` 作为开头：
```
\Kid.nickname
```
上面的代码在 Swift 4 中就可以这样写：
```swift
struct Kid {
    var nickname: String = ""
    var age: Double = 0.0
    var friends: [Kid] = []
}

var ben = Kid(nickname: "Benji", age: 8, friends: [])

let name = ben[keyPath: \Kid.nickname]
ben[keyPath: \Kid.nickname] = "BigBen"
```
相比 Swift 3，Swift 4 的 Key Paths 具有以下优势：

- 类型可以定义为 class、struct
- 定义类型时无需加上 @objcMembers、dynamic 、@objc等关键字
- 性能更好
- 类型安全和类型推断，例如 ben.valueForKeyPath(kidsNameKeyPath) 返回的类型是 Any，ben[keyPath: \Kid.nickname] 直接返回 属性的 类型
- 可以在所有值类型上使用

## :smile: KVO
依然只有 NSObject 才能支持 KVO。

Swift 4中的一个对此有影响的改变是继承 NSObject 的 swift class 不再默认全部 bridge 到 OC。

然而 KVO 又是一个纯 OC 的特性，所以如果是 swift class 需要在声明的时候增加 @objcMembers 关键字。否则在运行的时候你会得到一个 error：
```
fatal error: Could not extract a String from KeyPath 
Swift.ReferenceWritableKeyPath
```

一个好消息是不需要在对象被回收时手动 remove observer。但是这也带来了另外一个容易被忽略的事情：观察的闭包没有被强引用，需要我们自己添加引用，否则当前函数离开后这个观察闭包就会被回收了。KVO 之后返回的是一个 NSKeyValueObservation 实例，需要自己控制这个实例的生命周期。
```swift
@objcMembers class OCClass: NSObject {
    dynamic var name: String
 
    init(name: String) {
        self.name = name
    }
}
 
class ViewController: UIViewController {
 
    var swiftClass: OCClass!
    var ob: NSKeyValueObservation!
 
    override func viewDidLoad() {
        super.viewDidLoad()
 
        swiftClass = OCClass(name: "oc")
        ob = swiftClass.observe(\.name) { (ob, changed) in
            let new = ob.name
            print(new)
        }
        swiftClass.name = "swift4"
    }
}
```
## :smile: 下标支持泛型
有时候会写一些数据容器，Swift 支持通过下标来读写容器中的数据，但是如果容器类中的数据类型定义为泛型，以前的下标语法就只能返回 Any，在取出值后需要用 as? 来转换类型。Swift 4 定义下标也可以使用泛型了。
```swift
struct GenericDictionary<Key: Hashable, Value> {
    private var data: [Key: Value]

    init(data: [Key: Value]) {
        self.data = data
    }

    subscript<T>(key: Key) -> T? {
        return data[key] as? T
    }
}

let dictionary = GenericDictionary(data: ["Name": "Xiaoming"])

let name: String? = dictionary["Name"] // 不需要再写 as? String
```
## :smile: Unicode 字符串在计算 count 时的正确性改善
在 Unicode 中，有些字符是由几个其它字符组成的，比如 é 这个字符，它可以用 \u{E9} 来表示，也可以用 e 字符和上面一撇字符组合在一起表示 \u{65}\u{301}。

考虑以下代码：
```swift
var family = "👩"
family += "\u{200D}👩"
family += "\u{200D}👧" 
family += "\u{200D}👦"

print(family)
print(family.characters.count)
```
这个 family 是一个由多个字符组合成的字符，打印出来的结果为 👩‍👩‍👧‍👦。上面的代码在 Swift 3 中打印的 count 数是 4，在 Swift 4 中打印出的 count 是 1。

## :smile:去掉 characters
Swift 3 中的 String 需要通过 characters 去调用的属性方法，在 Swift 4 中可以通过 String 对象本身直接调用，例如：
```swift
let values = "one,two,three..."
var i = values.characters.startIndex

while let comma = values.characters[i..<values.characters.endIndex].index(of: ",") {
    if values.characters[i..<comma] == "two" {
        print("found it!")
    }
    i = values.characters.index(after: comma)
}
```
Swift 4 可以把上面代码中的所有的 characters 都去掉，修改如下：
```swift
let values = "one,two,three..."
var i = values.startIndex

while let comma = values[i...<values.endIndex].index(of: ",") {
    if values[i..<comma] == "two" {
        print("found it!")
    }
    i = values.index(after: comma)
}
```
## :smile:新增了一个语法糖 ... 可以对字符串进行单侧边界取子串
swift3:
```swift
let values = "abcdefg"
let startSlicingIndex = values.index(values.startIndex, offsetBy: 3)
let subvalues = values[startSlicingIndex..<values.endIndex]
// defg
```
swift4:
```swift
let values = "abcdefg"
let startSlicingIndex = values.index(values.startIndex, offsetBy: 3)
let subvalues = values[startSlicingIndex...] // One-sided Slicing
// defg
```

## :smile:多行字符串字面量
Swift 3 中写很长的字符串只能写在一行,字符串中间有换行只能通过添加 \n 字符来代表换行。

Swift 4 可以把字符串写在一对 """ 中，这样字符串就可以写成多行。
```swift
func tellJoke(name: String, character: Character) {
    let punchline = name.filter { $0 != character }
    let n = name.count - punchline.count
    let joke = """
        Q: Why does \(name) have \(n) \(character)'s in their name?
        A: I don't know, why does \(name) have \(n) \(character)'s in their name?
        Q: Because otherwise they'd be called \(punchline).
        """
    print(joke)
}
tellJoke(name: "Edward Woodward", character: "d")
```

## :smile:Encoding 、 Decoding and Codable
当需要将一个对象持久化时，需要把这个对象序列化，往常的做法是实现 NSCoding 协议，写过的人应该都知道实现 NSCoding 协议的代码写起来很痛苦，尤其是当属性非常多的时候。几年前有一个工具能自动生成 Objective-C 的实现 NSCoding 协议代码，当时用着还不错，但后来这个工具已经没有人维护很久了，而且不支持 Swift。

Swift 4 中引入了 Codable 帮我们解决了这个问题。
```swift
struct Language: Codable {
    var name: String
    var version: Int
}
```
我们想将这个 Language 对象的实例持久化，只需要让 Language 符合 Codable 协议即可，Language 中不用写别的代码。符合了 Codable 协议以后，可以选择把对象 encode 成 JSON 或者 PropertyList。

Encode 操作如下：
```swift
let swift = Language(name: "Swift", version: 4)
if let encoded = try? JSONEncoder().encode(swift) {
    // 把 encoded 保存起来
}
```
Decode 操作如下：
```swift
if let decoded = try? JSONDecoder().decode(Language.self, from: encoded) {
    print(decoded.name)
}
```

## :smile:Sequence 改进
Swift 3:
```swift
protocol Sequence {
    associatedtype Iterator: IteratorProtocol
    func makeIterator() -> Iterator
}
```
Swift 4:
```swift
protocol Sequence {
    associatedtype Element
    associatedtype Iterator: IteratorProtocol where Iterator.Element == Element
    func makeIterator() -> Iterator
}
```
由于 Swift 4 中的 associatedtype 支持追加 where 语句，所以 Sequence 做了这样的改进。
Swift 4 中获取 Sequence 的元素类型可以不用 Iterator.Element，而是直接取 Element。

SubSequence 也做了修改：
```swift
protocol Sequence {
    associatedtype SubSequence: Sequence 
        where SubSequence.SubSequence == SubSequence,
              SubSequence.Element == Element
}
```
通过 where 语句的限定，保证了类型正确，避免在使用 Sequence 时做一些不必要的类型判断。

Collection 也有一些类似的修改。
## :smile:Protocol-oriented integers
整数类型符合的协议有修改，新增了 FixedWidthInteger 等协议，具体的协议继承关系如下：
```
+-------------+   +-------------+
        +------>+   Numeric   |   | Comparable  |
        |       |   (+,-,*)   |   | (==,<,>,...)|
        |       +------------++   +---+---------+
        |                     ^       ^
+-------+------------+        |       |
|    SignedNumeric   |      +-+-------+-----------+
|     (unary -)      |      |    BinaryInteger    |
+------+-------------+      |(words,%,bitwise,...)|
       ^                    ++---+-----+----------+
       |         +-----------^   ^     ^---------------+
       |         |               |                     |
+------+---------++    +---------+---------------+  +--+----------------+
|  SignedInteger  |    |  FixedWidthInteger      |  |  UnsignedInteger  |
|                 |    |(endianness,overflow,...)|  |                   |
+---------------+-+    +-+--------------------+--+  +-+-----------------+
                ^        ^                    ^       ^
                |        |                    |       |
                |        |                    |       |
               ++--------+-+                +-+-------+-+
               |Int family |-+              |UInt family|-+
               +-----------+ |              +-----------+ |
                 +-----------+                +-----------+
```
## :smile:NSNumber bridging and Numeric types
```swift
let n = NSNumber(value: 999)
let v = n as? UInt8 // Swift 4: nil, Swift 3: 231
```
在 Swift 4 中，把一个值为 999 的 NSNumber 转换为 UInt8 后，能正确的返回 nil，而在 Swift 3 中会不可预料的返回 231。
## :smile:MutableCollection.swapAt(::)
MutableCollection 现在有了一个新方法 swapAt(::) 用来交换两个位置的值，例如：
```swift
var mutableArray = [1, 2, 3, 4]
mutableArray.swapAt(1, 2)
print(mutableArray)
// 打印结果：[1, 3, 2, 4]
```
## :smile:自动清除冗余代码减小包大小
得益于 Swift 的静态语言特性，每个函数的调用在编译期间就可以确定。因此在编译完成后可以检测出没有被调用到的 swift 函数，优化删除后可以减小最后二进制文件的大小。这个功能在 XCode 9 和 Swift 4 中终于被引进。相较于 OC 又多了一个杀手级特性。

那么为什么 OC 做不到这点呢？因为在 OC 中调用函数是在运行时通过发送消息调用的。所以在编译期并不确定这个函数是否被调用到。因为这点在混合项目中引发了另外一个问题：swift 函数怎么知道是否被 OC 调用了呢？出于安全起见，只能保留所有可能会被 OC 调用的 swift 函数（标记为 @objc 的）。

在 swift 3 中除了手动添加 @objc 声明函数支持 OC 调用还有另外一种方式：继承 NSObject。class 继承了 NSObject 后，编译器就会默认给这个类中的所有函数都标记为 @objc ，支持 OC 调用。然而在实际项目中，一个 swift 类虽然继承了 NSObject，但是其中还是有很多函数不会在 OC 中被调用，这里有很大的优化空间。于是根据 SE160 的建议，苹果修改了自动添加 @objc 的逻辑：一个继承 NSObject 的 swift 类不再默认给所有函数添加 @objc。只在实现 OC 接口和重写 OC 方法时才自动给函数添加 @objc 标识。

XCode 9会在运行过程中自行检测类中函数是被 OC 调用，然后提示添加 @objc。
## :smile:Swift4.0中不再允许复写扩展中的方法(包括实例方法、static方法、class方法)

## :smile:

## :smile:

## :smile:


> 参考
> 
> [Swift.org](https://swift.org/)
> 
> [swift-evolution](https://github.com/apple/swift-evolution)
> 
> [最全的 Swift 4 新特性解析](http://www.jianshu.com/p/c4f5db08bcab)
> 
> [iOS 11 的一些玩意儿：Swift 4](https://addicechan.github.io/swift4/)
>
> [Swift 4新知：自动清除冗余代码减小包大小](http://www.jianshu.com/p/6c5b45d9d042)

