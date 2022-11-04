# [一天回顾 The Swift Programming Language](https://github.com/numbbbbb/the-swift-programming-language-in-chinese) ：

**update:**
+ Swift 5.2
+ Swift 5.7  2022-10-05

## 版本兼容性
:smile:本书描述的是在 Xcode 14 中默认包含的 Swift 5.7 版本。你可以使用 Xcode 14 来构建 Swift 5.7、Swift 4.2 或 Swift 4 写的项目。

:smile:但以下功能仅支持 Swift 5.7 或更高版本:
+ 返回值是不透明类型的函数依赖 Swift 5.1 运行时。
+ try? 表达式不会为已返回可选类型的代码引入额外的可选类型层级。
+ 大数字的整型字面量初始化代码的类型将会被正确推导，例如 UInt64(0xffff_ffff_ffff_ffff) 将会被推导为整型类型而非溢出。

## Swift 初见（A Swift Tour）
:smile:你还可以使用较短的代码解包一个值，并且对该被包装值使用相同的名称。
```swift
if let nickname {
	print("Hey, \(nickName)")
}
```

:smile:单个语句闭包会把它语句的值当做结果返回

:smile:如果你不需要计算属性，但是仍然需要在设置一个新值之前或者之后运行代码，使用 willSet 和 didSet。写入的代码会在属性值发生改变时调用，但不包含构造器中发生值改变的情况

:smile:枚举的关联值是实际值，并不是原始值的另一种表达方法。实际上，如果没有比较有意义的原始值，你就不需要提供原始值。

:smile:如果枚举成员的实例有原始值，那么这些值是在声明的时候就已经决定了，这意味着不同的枚举成员总会有一个相同的原始值。

:smile:当然我们也可以为枚举成员设定关联值，关联值是在创建实例时决定的。这意味着不同的枚举成员的关联值都可以不同。你可以把关联值想象成枚举成员的寄存属性。例如，考虑从服务器获取日出和日落的时间。服务器会返回正常结果或者错误信息。
```swift
enum ServerResponse {
    case result(String, String)
    case failure(String)
}
 
let success = ServerResponse.result("6:00 am", "8:09 pm")
let failure = ServerResponse.failure("Out of cheese.")
 
switch success {
case let .result(sunrise, sunset):
    print("Sunrise is at \(sunrise) and sunset is at \(sunset)")
case let .failure(message):
    print("Failure...  \(message)")
}
```

:smile:并发性 {#concurrency}

使用 `async` 标记异步运行的函数

```swift
func fetchUserID(from server: String) async -> Int{
	if server == "primary"
		return 97
}
	return 501
```

您还可以通过在函数名前添加 `await` 来标记对异步函数的调用

```swift
func fetchUsername(from server:String) async -> String{
	let userID = await fetchUserID(from: server)
	if userID == 501{
		return "John Appleseed"
	}
	return "Guest"
}
```

使用 `async let` 来调用异步函数，并让其与其它异步函数并行运行。
使用 `await` 以使用该异步函数返回的值。

```swift
func connectUser(to server: String) async{
	async let userID = fetchUserID(from: server)
	async let username = fetchUsername(from: server)
	let greeting = await "Hello \(username), user ID \(userID)"
	print(greeting)
}
```

使用 `Task` 从同步代码中调用异步函数且不等待它们返回结果

```swift
Task {
	await connectUser(to: "primary")
}
//Prints "Hello Guest, user ID 97"
```

:smile:使用 defer 代码块来表示在函数返回前，函数中最后执行的代码。无论函数是否会抛出错误，这段代码都将执行。使用 defer，可以把函数调用之初就要执行的代码和函数调用结束时的扫尾代码写在一起，虽然这两者的执行时机截然不同。

:smile:在类型名后面使用 `where` 来指定对类型的需求，比如，限定类型实现某一个协议，限定两个类型是相同的，或者限定某个类必须有一个特定的父类。
```swift
func anyCommonElements<T: Sequence, U: Sequence>(_ lhs: T, _ rhs: U) -> Bool
    where T.Iterator.Element: Equatable, T.Iterator.Element == U.Iterator.Element {
        for lhsItem in lhs {
            for rhsItem in rhs {
                if lhsItem == rhsItem {
                    return true
                }
            }
        }
        return false
}
anyCommonElements([1, 2, 3], [3])
```
`<T: Equatable>` 和 `<T> ... where T: Equatable` 的写法是等价的。

## 基础部分（The Basics）
:smile:注意：C 和 Objective-C 中并没有可选类型这个概念。最接近的是 Objective-C 中的一个特性，一个方法要不返回一个对象要不返回nil，nil表示“缺少一个合法的对象”。然而，这只对对象起作用——对于结构体，基本的 C 类型或者枚举类型不起作用。对于这些类型，Objective-C 方法一般会返回一个特殊值（比如NSNotFound）来暗示值缺失。这种方法假设方法的调用者知道并记得对特殊值进行判断。然而，Swift 的可选类型可以让你暗示任意类型的值缺失，并不需要一个特殊值。

:smile:注意：nil不能用于非可选的常量和变量。如果你的代码中有常量或者变量需要处理值缺失的情况，请把它们声明成对应的可选类型。

:smile:注意：Swift 的 nil 和 Objective-C 中的 nil 并不一样。在 Objective-C 中，nil 是一个指向不存在对象的指针。在 Swift 中，nil 不是指针——它是一个确定的值，用来表示值缺失。任何类型的可选状态都可以被设置为 nil，不只是对象类型。

:smile:你可以包含多个可选绑定或多个布尔条件在一个 if 语句中，只要使用逗号分开就行。只要有任意一个可选绑定的值为nil，或者任意一个布尔条件为false，则整个if条件判断为false

:smile:注意： 在 if 条件语句中使用常量和变量来创建一个可选绑定，仅在 if 语句的句中(body)中才能获取到值。相反，在 guard 语句中使用常量和变量来创建一个可选绑定，仅在 guard 语句外且在语句后才能获取到值

:smile:当可选类型被第一次赋值之后就可以确定之后一直有值的时候，隐式解析可选类型非常有用。隐式解析可选类型主要被用在 Swift 中类的构造过程中，请参考无主引用以及隐式解析可选属性。

:smile:一个隐式解析可选类型其实就是一个普通的可选类型，但是可以被当做非可选类型来使用，并不需要每次都使用解析来获取可选值。下面的例子展示了可选类型 `String` 和隐式解析可选类型 `String` 之间的区别：

```swift
let possibleString: String? = "An optional string."
let forcedString: String = possibleString! // 需要感叹号来获取值

let assumedString: String! = "An implicitly unwrapped optional string."
let implicitString: String = assumedString  // 不需要感叹号
```

你可以把隐式解析可选类型当做一个可以自动解析的可选类型。你要做的只是声明的时候把感叹号放到类型的结尾，而不是每次取值的可选名字的结尾。

> 注意：  
> 如果你在隐式解析可选类型没有值的时候尝试取值，会触发运行时错误。和你在没有值的普通可选类型后面加一个惊叹号一样。

你仍然可以把隐式解析可选类型当做普通可选类型来判断它是否包含值：

```swift
if assumedString != nil {
    print(assumedString)
}
// 输出 "An implicitly unwrapped optional string."
```

你也可以在可选绑定中使用隐式解析可选类型来检查并解析它的值：

```swift
if let definiteString = assumedString {
    print(definiteString)
}
// 输出 "An implicitly unwrapped optional string."
```

:smile:和在上面讨论过的错误处理不同，断言和先决条件并不是用来处理可以恢复的或者可预期的错误。因为一个断言失败表明了程序正处于一个无效的状态，没有办法去捕获一个失败的断言。

:smile:断言和先决条件的不同点是，他们什么时候进行状态检测：断言仅在调试环境运行，而先决条件则在调试环境和生产环境中运行。在生产环境中，断言的条件将不会进行评估。这个意味着你可以使用很多断言在你的开发阶段，但是这些断言在生产环境中不会产生任何影响。

:smile:可以使用 assertionFailure(_:file:line:)函数来表明断言失败了

:smile:注意：如果你使用unchecked模式（-Ounchecked）编译代码，先决条件将不会进行检查。编译器假设所有的先决条件总是为true（真），他将优化你的代码。然而，fatalError(_:file:line:)函数总是中断执行，无论你怎么进行优化设定。
你能使用 fatalError(_:file:line:)函数在设计原型和早期开发阶段，这个阶段只有方法的声明，但是没有具体实现，你可以在方法体中写上fatalError("Unimplemented")作为具体实现。因为fatalError不会像断言和先决条件那样被优化掉，所以你可以确保当代码执行到一个没有被实现的方法时，程序会被中断。

## 基本运算符（Basic Operators）
:smile:当元组中的值可以比较时，你也可以使用这些运算符来比较它们的大小。例如，因为 Int 和 String 类型的值可以比较，所以类型为 (Int, String) 的元组也可以被比较。相反，Bool 不能被比较，也意味着存有布尔类型的元组不能被比较。

比较元组大小会按照从左到右、逐值比较的方式，直到发现有两个值不等时停止。如果所有的值都相等，那么这一对元组我们就称它们是相等的。

:smile:空合运算符（a ?? b）将对可选类型 a 进行空判断，如果 a 包含一个值就进行解封，否则就返回一个默认值 b。表达式 a 必须是 Optional 类型。默认值 b 的类型必须要和 a 存储值的类型保持一致。

:smile:注意： 如果 a 为非空值（non-nil），那么值 b 将不会被计算。这也就是所谓的短路求值。

:smile:单侧区间不止可以在下标里使用，也可以在别的情境下使用。你不能遍历省略了初始值的单侧区间，因为遍历的开端并不明显。你可以遍历一个省略最终值的单侧区间；然而，由于这种区间无限延伸的特性，请保证你在循环里有一个结束循环的分支。你也可以查看一个单侧区间是否包含某个特定的值，就像下面展示的那样。

```swift
let range = ...5
range.contains(7)   // false
range.contains(4)   // true
range.contains(-1)  // true
```

## 字符串和字符（Strings and Characters）
:smile:Swift 的 String 类型与 Foundation NSString 类进行了无缝桥接。Foundation 还对 String 进行扩展使其可以访问 NSString 类型中定义的方法。这意味着调用那些 NSString 的方法，你无需进行任何类型转换。

:smile:如果你需要一个字符串是跨越多行的，你可以使用多行字符串字面量，它是由三个双引号(`"""`)包裹着的具有固定顺序的文本字符集。
如果你需要一个字符串是跨越多行的，你可以使用多行字符串字面量，它是由三个双引号(`"""`)包裹着的具有固定顺序的文本字符集。

```swift
let quotation = """
The White Rabbit put on his spectacles.  "Where shall I begin,
please your Majesty?" he asked.
 
"Begin at the beginning," the King said gravely, "and go on
till you come to the end; then stop."
"""
```
一个多行字符串字面量包含了所有的在开启和关闭引号（`"""`）中的行。这个字符从开启引号(`"""`)之后的第一行开始，到关闭引号(`"""`)之前为止。这就意味着字符串开启引号之后(`"""`)或者结束引号(`"""`)之前都没有一个换行符号。（译者：下面两个字符串其实是一样的，虽然第二个使用了多行字符串的形势）

```swift
let singleLineString = "These are the same."
let multilineString = """
These are the same.
"""
```
如果你的代码中，多行字符串字面量包含换行符的话，则多行字符串字面量中也会包含换行符。如果你想使用换行，使得你的代码获得好的可读性，但是你又不想在你的多行字符串字面量中出现换行符的话，你可以用在行尾写一个反斜杠(`\`)作为续行符。

```swift
let softWrappedQuotation = """
The White Rabbit put on his spectacles.  "Where shall I begin, \
please your Majesty?" he asked.
 
"Begin at the beginning," the King said gravely, "and go on \
till you come to the end; then stop."
"""
```

为了让一个多行字符串字面量开始和结束于换行符，请将换行写在第一行和最后一行，例如：

```swift
let lineBreaks = """
 
This string starts with a line break.
It also ends with a line break.
 
"""
```
一个多行字符串字面量能够缩进来匹配周围的代码。关闭引号(`"""`)之前的空白字符串告诉Swift编译器其他各行多少空白字符串需要忽略。然而，如果你在某行的前面写的空白字符串超出了关闭引号(`"""`)之前的空白字符串，则超出部分将被包含在多行字符串字面量中。

![](https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/Art/multilineStringWhitespace_2x.png)

在上面的例子中，尽管整个多行字符串字面量都是缩进的（源代码缩进），第一行和最后一行没有以空白字符串开始（实际的变量值）。中间一行的缩进用空白字符串（源代码缩进）比关闭引号(`"""`)之前的空白字符串多，所以，它的行首将有4个空白字符串（实际的变量值）。

:smile:要创建一个空字符串作为初始值，可以将空的字符串字面量赋值给变量，也可以初始化一个新的`String`实例：

```swift
var emptyString = ""               // 空字符串字面量
var anotherEmptyString = String()  // 初始化方法
// 两个字符串均为空并等价。
```

:smile:使用startIndex属性可以获取一个String的第一个Character的索引。使用endIndex属性可以获取最后一个Character的后一个位置的索引。因此，endIndex属性不能作为一个字符串的有效下标。如果String是空串，startIndex和endIndex是相等的。

:smile:使用 indices 属性会创建一个包含全部索引的范围（Range），用来在一个字符串中访问单个字符。

```swift
for index in greeting.indices {
   print("\(greeting[index]) ", terminator: "")
}
// 打印输出 "G u t e n   T a g ! "
```

:smile:你可以使用 startIndex 和 endIndex 属性或者 index(before:) 、index(after:) 和 index(_:offsetBy:) 方法在任意一个确认的并遵循 Collection 协议的类型里面，如上文所示是使用在 String 中，你也可以使用在 Array、Dictionary 和 Set 中。

:smile:注意： 您可以使用 insert(_:at:)、insert(contentsOf:at:)、remove(at:) 和 removeSubrange(_:) 方法在任意一个确认的并遵循 RangeReplaceableCollection 协议的类型里面，如上文所示是使用在 String 中，您也可以使用在 Array、Dictionary 和 Set 中。

:smile:当你从字符串中获取一个子字符串 —— 例如，使用下标或者 prefix(_:) 之类的方法 —— 就可以得到一个 Substring 的实例，而非另外一个 String。Swift 里的 Substring 绝大部分函数都跟 String 一样，意味着你可以使用同样的方式去操作 Substring 和 String。然而，跟 String 不同的是，你只有在短时间内需要操作字符串时，才会使用 Substring。当你需要长时间保存结果时，就把 Substring 转化为 String 的实例：
```swift
let greeting = "Hello, world!"
let index = greeting.firstIndex(of: ",") ?? greeting.endIndex
let beginning = greeting[..<index]
// beginning 的值为 "Hello"

// 把结果转化为 String 以便长期存储。
let newString = String(beginning)
```
就像 String，每一个 Substring 都会在内存里保存字符集。而 String 和 Substring 的区别在于性能优化上，Substring 可以重用原 String 的内存空间，或者另一个 Substring 的内存空间（String 也有同样的优化，但如果两个 String 共享内存的话，它们就会相等）。这一优化意味着你在修改 String 和 Substring 之前都不需要消耗性能去复制内存。就像前面说的那样，Substring 不适合长期存储 —— 因为它重用了原 String 的内存空间，原 String 的内存空间必须保留直到它的 Substring 不再被使用为止。

:smile:在 Swift 中，字符串和字符并不区分地域(not locale-sensitive)。

## 集合类型 (Collection Types)
:smile:Swift 的所有基本类型(比如String,Int,Double和Bool)默认都是可哈希化的，可以作为集合的值的类型或者字典的键的类型。没有关联值的枚举成员值(在枚举有讲述)默认也是可哈希化的。

:smile:因为Hashable协议符合Equatable协议，所以遵循该协议的类型也必须提供一个"是否相等"运算符(==)的实现。

## 控制流
:smile:以上示例使用 for-in 循环来遍历范围、数组、字典和字符串。你可以用它来遍历任何的集合，包括实现了 Sequence 协议的自定义类或集合类型。

:smile:不像 C 语言，Swift 允许多个 case 匹配同一个值。实际上，在这个例子中，四个 case 都可以匹配点 (0, 0) 。但是，如果存在多个匹配，那么只会执行第一个被匹配到的 case 分支。考虑点 (0, 0)会首先匹配 case (0, 0)，因此剩下的能够匹配的分支都会被忽视掉。

:smile:除了 #available 以外， Swift 还支持通过不可用性条件来进行不可用性检查。举例如下，两种检查都能实现同样的效果：
```swift
if #available(iOS 10, *){
} else {
	//回滚代码
}
if #unavailable(iOS 10) {
	//回滚代码
}
```

## 函数（Functions）
:smile:严格上来说，虽然没有返回值被定义，greet(person:) 函数依然返回了值。没有定义返回类型的函数会返回一个特殊的Void值。它其实是一个空的元组（tuple），没有任何元素，可以写成()。

:smile:作为隐式返回值编写的代码需要返回一些值。例如，你不能使用 print(13) 作为隐式返回值。然而，你可以使用不返回值的函数（如 fatalError("Oh no!")）作为隐式返回值，因为 Swift 知道它们并不会产生任何隐式返回。

:smile:每个函数参数都有一个参数标签( argument label )以及一个参数名称( parameter name )。参数标签在调用函数的时候使用；调用的时候需要将函数的参数标签写在对应的参数前面。参数名称在函数的实现中使用。默认情况下，函数参数使用参数名称来作为它们的参数标签。

:smile:你可以在函数体中通过给参数赋值来为任意一个参数定义*默认值（Deafult Value）*。当默认值被定义后，调用这个函数时可以忽略这个参数。
```swift
func someFunction(parameterWithoutDefault: Int, parameterWithDefault: Int = 12) {
    // 如果你在调用时候不传第二个参数，parameterWithDefault 会值为 12 传入到函数体中。
}
someFunction(parameterWithoutDefault: 3, parameterWithDefault: 6) // parameterWithDefault = 6
someFunction(parameterWithoutDefault: 4) // parameterWithDefault = 12
```
将不带有默认值的参数放在函数参数列表的最前。一般来说，没有默认值的参数更加的重要，将不带默认值的参数放在最前保证在函数调用时，非默认参数的顺序是一致的，同时也使得相同的函数在不同情况下调用时显得更为清晰。

:smile:一个函数最多只能拥有一个可变参数。

:smile:函数参数默认是常量。试图在函数体中更改参数值将会导致编译错误(compile-time error)。这意味着你不能错误地更改参数值。如果你想要一个函数可以修改参数的值，并且想要在这些修改在函数调用结束后仍然存在，那么就应该把这个参数定义为输入输出参数（In-Out Parameters）。

:smile:你只能传递变量给输入输出参数。你不能传入常量或者字面量，因为这些量是不能被修改的。当传入的参数作为输入输出参数时，需要在参数名前加 & 符，表示这个值可以被函数修改。

:smile:输入输出参数不能有默认值，而且可变参数不能用 inout 标记。

:smile:每个函数都有种特定的函数类型，函数的类型由函数的参数类型和返回类型组成。

## 闭包（Closures）
:smile:闭包采取如下三种形式之一：

* 全局函数是一个有名字但不会捕获任何值的闭包
* 嵌套函数是一个有名字并可以捕获其封闭函数域内值的闭包
* 闭包表达式是一个利用轻量级语法所写的可以捕获其上下文中变量或常量值的匿名闭包

:smile:Swift 的闭包表达式拥有简洁的风格，并鼓励在常见场景中进行语法优化，主要优化如下：

* 利用上下文推断参数和返回值类型
* 隐式返回单表达式闭包，即单表达式闭包可以省略 `return` 关键字
* 参数名称缩写
* 尾随闭包语法

:smile:闭包表达式参数 可以是 in-out 参数，但不能设定默认值。如果你命名了可变参数，也可以使用此可变参数。元组也可以作为参数和返回值。

:smile:如果闭包表达式是函数或方法的唯一参数，则当你使用尾随闭包时，你甚至可以把 `()` 省略掉：

```swift
reversedNames = names.sorted { $0 > $1 }
```

:smile:如果一个函数接受多个闭包，您需要省略第一个尾随闭包的参数标签，并为其余尾随闭包添加标签。例如，以下函数将为图片库加载一张图片：
```swift
func loadPicture(from server: Server, completion:(Picture) -> Void,
		onFailure: () -> Void) {
	if let picture = download("photo.jpg", from: server){
		completion(picture)
	}else{
		onFailure()
	}
}
```
当您调用该函数以加载图片时，需要提供两个闭包。第一个闭包是一个完成处理程序，它在成功下载后加载图片；第二个闭包是一个错误处理程序，它向用户显示错误。
```
loadPicture(from: someServer){	picture in
	someView.currentPicture = picture
} onFailure: {
	print("Couldn't download the next picture.")
}
```

:smile:函数和闭包都是引用类型。

:smile:当一个闭包作为参数传到一个函数中，但是这个闭包在函数返回之后才被执行，我们称该闭包从函数中逃逸。当你定义接受闭包作为参数的函数时，你可以在参数名之前标注 @escaping，用来指明这个闭包是允许“逃逸”出这个函数的。

:smile:将一个闭包标记为 `@escaping` 意味着你必须在闭包中显式地引用 `self`。比如说，在下面的代码中，传递到 `someFunctionWithEscapingClosure(_:)` 中的闭包是一个逃逸闭包，这意味着它需要显式地引用 `self`。相对的，传递到 `someFunctionWithNonescapingClosure(_:)` 中的闭包是一个非逃逸闭包，这意味着它可以隐式引用 `self`。


```swift
func someFunctionWithNonescapingClosure(closure: () -> Void) {
    closure()
}

class SomeClass {
    var x = 10
    func doSomething() {
        someFunctionWithEscapingClosure { self.x = 100 }
        someFunctionWithNonescapingClosure { x = 200 }
    }
}

let instance = SomeClass()
instance.doSomething()
print(instance.x)
// 打印出 "200"

completionHandlers.first?()
print(instance.x)
// 打印出 "100"
```

:smile:自动闭包是一种自动创建的闭包，用于包装传递给函数作为参数的表达式。这种闭包不接受任何参数，当它被调用的时候，会返回被包装在其中的表达式的值。这种便利语法让你能够省略闭包的花括号，用一个普通的表达式来代替显式的闭包。

:smile:let customerProvider = { customersInLine.remove(at: 0) } //customerProvider 的类型不是 String，而是 () -> String，一个没有参数且返回值为 String 的函数。

## 枚举（Enumerations）
:smile:如果你熟悉 C 语言，你会知道在 C 语言中，枚举会为一组整型值分配相关联的名称。Swift 中的枚举更加灵活，不必给每一个枚举成员提供一个值。如果给枚举成员提供一个值（称为“原始”值），则该值的类型可以是字符串，字符，或是一个整型值或浮点数。

:smile:枚举成员可以指定任意类型的关联值存储到枚举成员中，就像其他语言中的联合体（unions）和变体（variants）。你可以在一个枚举中定义一组相关的枚举成员，每一个枚举成员都可以有适当类型的关联值。

:smile:在 Swift 中，枚举类型是一等（first-class）类型。它们采用了很多在传统上只被类（class）所支持的特性，例如计算属性（computed properties），用于提供枚举值的附加信息，实例方法（instance methods），用于提供和枚举值相关联的功能。枚举也可以定义构造函数（initializers）来提供一个初始值；可以在原始实现的基础上扩展它们的功能；还可以遵循协议（protocols）来提供标准的功能。

:smile:与 C 和 Objective-C 不同，Swift 的枚举成员在被创建时不会被赋予一个默认的整型值。

:smile:如果一个枚举成员的所有关联值都被提取为常量，或者都被提取为变量，为了简洁，你可以只在成员名称前标注一个let或者var

:smile:原始值可以是字符串、字符，或者任意整型值或浮点型值。每个原始值在枚举声明中必须是唯一的。

:smile:原始值和关联值是不同的。原始值是在定义枚举时被预先填充的值，像上述三个 ASCII 码。对于一个特定的枚举成员，它的原始值始终不变。关联值是创建一个基于枚举成员的常量或变量时才设置的值，枚举成员的关联值可以变化。

:smile:递归枚举是一种枚举类型，它有一个或多个枚举成员使用该枚举类型的实例作为关联值。使用递归枚举时，编译器会插入一个间接层。你可以在枚举成员前加上indirect来表示该成员可递归。

:smile:你也可以在枚举类型开头加上indirect关键字来表明它的所有成员都是可递归的：

## 类和结构体
:smile:与 Objective-C 语言不同的是，Swift 允许直接设置结构体属性的子属性。上面的最后一个例子，就是直接设置了someVideoMode中resolution属性的width这个子属性，以上操作并不需要重新为整个resolution属性设置新值。

:smile:所有结构体都有一个自动生成的成员逐一构造器，用于初始化新结构体实例中成员的属性。新实例中各个属性的初始值可以通过属性的名称传递到成员逐一构造器之中：
```swift
let vga = Resolution(width:640, height: 480)
```
与结构体不同，类实例没有默认的成员逐一构造器。

:smile:在 Swift 中，所有的基本类型：整数（Integer）、浮点数（floating-point）、布尔值（Boolean）、字符串（string)、数组（array）和字典（dictionary），都是值类型，并且在底层都是以结构体的形式所实现。

:smile:在 Swift 中，所有的结构体和枚举类型都是值类型。

:smile:Swift 中，许多基本类型，诸如String，Array和Dictionary类型均以结构体的形式实现。这意味着被赋值给新的常量或变量，或者被传入函数或方法中时，它们的值会被拷贝。

Objective-C 中NSString，NSArray和NSDictionary类型均以类的形式实现，而并非结构体。它们在被赋值或者被传入函数或方法时，不会发生值拷贝，而是传递现有实例的引用。

## 属性 (Properties)
:smile:计算属性可以用于类、结构体和枚举，存储属性只能用于类和结构体。

:smile:属性观察器可以添加到自己定义的存储属性上，也可以添加到从父类继承的属性上。

:smile:你也可以利用属性包装器来复用多个属性的 getter 和 setter 中的代码

:smile:存储属性和实例变量

如果您有过 Objective-C 经验，应该知道 Objective-C 为类实例存储值和引用提供两种方法。除了属性之外，还可以使用实例变量作为属性值的后端存储。

Swift 编程语言中把这些理论统一用属性来实现。Swift 中的属性没有对应的实例变量，属性的后端存储也无法直接访问。这就避免了不同场景下访问方式的困扰，同时也将属性的定义简化成一个语句。属性的全部信息——包括命名、类型和内存管理特征——都在唯一一个地方（类型定义中）定义。

:smile:可以为除了延迟存储属性之外的其他存储属性添加属性观察器，也可以通过重写属性的方式为继承的属性（包括存储属性和计算属性）添加属性观察器。你不必为非重写的计算属性添加属性观察器，因为可以通过它的 setter 直接监控和响应值的变化。 属性重写请参考重写。

:smile:父类的属性在子类的构造器中被赋值时，它在父类中的 willSet 和 didSet 观察器会被调用，随后才会调用子类的观察器。在父类初始化方法调用之前，子类给属性赋值时，观察器不会被调用。

:smile:如果将带有观察器的属性通过 in-out 方式传入函数，willSet 和 didSet 也会调用。这是因为 in-out 参数采用了拷入拷出内存模式：即在函数内部使用的是参数的 copy，函数结束后，又对参数重新赋值。所以带有in-out方式的函数对in-out参数多次set，只会在函数结束后调用一次willSet 和 didSet！！！！！！

:smile:计算属性和属性观察器所描述的功能也可以用于全局变量和局部变量。全局变量是在函数、方法、闭包或任何类型之外定义的变量。局部变量是在函数、方法或闭包内部定义的变量。

:smile:全局的常量或变量都是延迟计算的，跟延迟存储属性相似，不同的地方在于，全局的常量或变量不需要标记lazy修饰符。

:smile:局部范围的常量或变量从不延迟计算。

:smile:跟实例的存储型属性不同，必须给存储型类型属性指定默认值，因为类型本身没有构造器，也就无法在初始化过程中使用构造器给类型属性赋值。

:smile:存储型类型属性是延迟初始化的，它们只有在第一次被访问的时候才会被初始化。即使它们被多个线程同时访问，系统也保证只会对其进行一次初始化，并且不需要对其使用 lazy 修饰符。

:smile:使用关键字 static 来定义类型属性。

:smile:在为类定义计算型类型属性时，可以改用关键字 class 来支持子类对父类的实现进行重写。

## 方法（Methods）
:smile:方法是与某些特定类型相关联的函数。类、结构体、枚举都可以定义实例方法；实例方法为给定类型的实例封装了具体的任务与功能。类、结构体、枚举也可以定义类型方法；类型方法与类型本身相关联。

:smile:在方法的func关键字之前加上关键字static，来指定类型方法。类还可以用关键字class来允许子类重写父类的方法实现。

:smile:因为允许在调用advance(to:)时候忽略返回值，不会产生编译警告，所以函数被标注为@ discardableResult属性。

## 下标
:smile:下标可以接受任意数量的入参，并且这些入参可以是任意类型。下标的返回值也可以是任意类型。

:smile:与函数一样，下标可以接受不同数量的参数，并且为这些参数提供默认值，如在可变参数 和 默认参数值 中所述。但是，与函数不同的是，下标不能使用 in-out 参数。

:smile:一个类或结构体可以根据自身需要提供多个下标实现，使用下标时将通过入参的数量和类型进行区分，自动匹配合适的下标，这就是下标的重载。

## 继承
:smile:你可以将一个继承来的只读属性重写为一个读写属性，只需要在重写版本的属性里提供 getter 和 setter 即可。但是，你不可以将一个继承来的读写属性重写为一个只读属性。

:smile:你不可以为继承来的常量存储型属性或继承来的只读计算型属性添加属性观察器。这些属性的值是不可以被设置的，所以，为它们提供willSet或didSet实现是不恰当。

:smile:你不可以同时提供重写的 setter 和重写的属性观察器。如果你想观察属性值的变化，并且你已经为那个属性提供了定制的 setter，那么你在 setter 中就可以观察到任何值变化了。

:smile:你可以通过把方法，属性或下标标记为*final*来防止它们被重写，只需要在声明关键字前加上final修饰符即可（例如：final var，final func，final class func，以及final subscript）。

:smile:在类扩展中的方法，属性或下标也可以在扩展的定义里标记为 final。

## 构造过程
:smile:当你为存储型属性分配默认值或者在构造器中设置初始值时，它们的值是被直接设置的，不会触发任何属性观察者。

:smile:对于类的实例来说，它的常量属性只能在定义它的类的构造过程中修改；不能在子类中修改。

:smile:如果结构体或类为所有属性提供了默认值，又没有提供任何自定义的构造器，那么 Swift 会给这些结构体或类提供一个默认构造器。这个默认构造器将简单地创建一个所有属性值都设置为它们默认值的实例。

:smile:结构体如果没有定义任何自定义构造器，它们将自动获得一个逐一成员构造器（memberwise initializer）。不像默认构造器，即使存储型属性没有默认值，结构体也能会获得逐一成员构造器。当你调用一个逐一成员构造器（memberwise initializer）时，可以省略任何一个有默认值的属性。

:smile:假如你希望默认构造器、逐一成员构造器以及你自己的自定义构造器都能用来创建实例，可以将自定义的构造器写到扩展（extension）中，而不是写在值类型的原始定义中。

:smile:指定构造器必须总是向上代理！便利构造器必须总是横向代理！

:smile:构造器在第一阶段构造完成之前，不能调用任何实例方法，不能读取任何实例属性的值，不能引用 self 作为一个值。

:smile:

从顶部构造器链一直往下，每个构造器链中类的指定构造器都有机会进一步定制实例。构造器此时可以访问self、修改它的属性并调用实例方法等等。

最终，任意构造器链中的便利构造器可以有机会定制实例和使用self。

:smile:当你在编写一个和父类中指定构造器相匹配的子类构造器时，你实际上是在重写父类的这个指定构造器。因此，你必须在定义子类构造器时带上override修饰符。即使你重写的是系统自动提供的默认构造器，也需要带上override修饰符

:smile:当你重写一个父类的指定构造器时，你总是需要写override修饰符，即使你的子类将父类的指定构造器重写为了便利构造器。

:smile:相反，如果你编写了一个和父类便利构造器相匹配的子类构造器，由于子类不能直接调用父类的便利构造器（每个规则都在上文类的构造器代理规则有所描述），因此，严格意义上来讲，你的子类并未对一个父类构造器提供重写。最后的结果就是，你在子类中“重写”一个父类便利构造器时，不需要加override前缀。

:smile:如果子类的构造器没有在阶段 2 过程中做自定义操作，并且父类有一个同步、无参数的指定构造器，你可以在所有子类的存储属性赋值之后省略 super.init() 的调用。若父类有一个异步的构造器，你就需要明确地写入 await super.init()。

:smile:子类可以在初始化时修改继承来的变量属性，但是不能修改继承来的常量属性。

:smile:构造器的自动继承

如上所述，子类在默认情况下不会继承父类的构造器。但是如果满足特定条件，父类构造器是可以被自动继承的。在实践中，这意味着对于许多常见场景你不必重写父类的构造器，并且可以在安全的情况下以最小的代价继承父类的构造器。

假设你为子类中引入的所有新属性都提供了默认值，以下 2 个规则适用：

规则 1

如果子类没有定义任何指定构造器，它将自动继承所有父类的指定构造器。

规则 2

如果子类提供了所有父类指定构造器的实现——无论是通过规则 1 继承过来的，还是提供了自定义实现——它将自动继承所有父类的便利构造器。

即使你在子类中添加了更多的便利构造器，这两条规则仍然适用。

> 注意  
对于规则 2，子类可以将父类的指定构造器实现为便利构造器。

:smile:可失败构造器的参数名和参数类型，不能与其它非可失败构造器的参数名，及其参数类型相同。

:smile:严格来说，构造器都不支持返回值。因为构造器本身的作用，只是为了确保对象能被正确构造。因此你只是用return nil表明可失败构造器构造失败，而不要用关键字return来表明构造成功。

:smile:

类，结构体，枚举的可失败构造器可以横向代理到类型中的其他可失败构造器。类似的，子类的可失败构造器也能向上代理到父类的可失败构造器。

无论是向上代理还是横向代理，如果你代理到的其他可失败构造器触发构造失败，整个构造过程将立即终止，接下来的任何构造代码不会再被执行。

> 注意  
可失败构造器也可以代理到其它的非可失败构造器。通过这种方式，你可以增加一个可能的失败状态到现有的构造过程中。

:smile:如同其它的构造器，你可以在子类中重写父类的可失败构造器。或者你也可以用子类的非可失败构造器重写一个父类的可失败构造器。这使你可以定义一个不会构造失败的子类，即使父类的构造器允许构造失败。

:smile:你可以用非可失败构造器重写可失败构造器，但反过来却不行。

:smile:通常来说我们通过在 init 关键字后添加问号的方式（init?）来定义一个可失败构造器，但你也可以通过在 init 后面添加感叹号的方式来定义一个可失败构造器（init!），该可失败构造器将会构建一个对应类型的隐式解包可选类型的对象。

:smile:你可以在 init? 中代理到 init!，反之亦然。你也可以用 init? 重写 init!，反之亦然。你还可以用 init 代理到 init!，不过，一旦 init! 构造失败，则会触发一个断言。

:smile:在类的构造器前添加required修饰符表明所有该类的子类都必须实现该构造器：

:smile:在子类重写父类的必要构造器时，必须在子类的构造器前也添加required修饰符，表明该构造器要求也应用于继承链后面的子类。在重写父类中必要的指定构造器时，不需要添加override修饰符：

:smile:如果子类继承的构造器能满足必要构造器的要求，则无须在子类中显式提供必要构造器的实现。

:smile:如果某个存储型属性的默认值需要一些定制或设置，你可以使用闭包或全局函数为其提供定制的默认值。每当某个属性所在类型的新实例被创建时，对应的闭包或函数会被调用，而它们的返回值会当做默认值赋值给这个属性。

:smile:如果你使用闭包来初始化属性，请记住在闭包执行时，实例的其它部分都还没有初始化。这意味着你不能在闭包里访问其它属性，即使这些属性有默认值。同样，你也不能使用隐式的self属性，或者调用任何实例方法。

## 析构过程
:smile:析构器只适用于类类型

:smile:析构器是在实例释放发生前被自动调用。你不能主动调用析构器。子类继承了父类的析构器，并且在子类析构器实现的最后，父类的析构器会被自动调用。即使子类没有提供自己的析构器，父类的析构器也同样会被调用。

:smile:在类的定义中，每个类最多只能有一个析构器，而且析构器不带任何参数和圆括号，如下所示：
```
deinit {
    // 执行析构过程
}
```

## 可选链式调用
:smile:如果在可选值上通过可选链式调用来调用这个方法，该方法的返回类型会是`Void?`，而不是`Void`，因为通过可选链式调用得到的返回值都是可选的。这样我们就可以使用`if`语句来判断能否成功调用`printNumberOfRooms()`方法，即使方法本身没有定义返回值。通过判断返回值是否为`nil`可以判断调用是否成功：

```swift
if john.residence?.printNumberOfRooms() != nil {
    print("It was possible to print the number of rooms.")
} else {
    print("It was not possible to print the number of rooms.")
}
// 打印 “It was not possible to print the number of rooms.”
```

:smile:同样的，可以据此判断通过可选链式调用为属性赋值是否成功。在上面的[通过可选链式调用访问属性](#accessing_properties_through_optional_chaining)的例子中，我们尝试给`john.residence`中的`address`属性赋值，即使`residence`为`nil`。通过可选链式调用给属性赋值会返回`Void?`，通过判断返回值是否为`nil`就可以知道赋值是否成功：

```swift
if (john.residence?.address = someAddress) != nil {
	print("It was possible to set the address.")
} else {
	print("It was not possible to set the address.")
}
// 打印 “It was not possible to set the address.”
```

:smile:可以通过连接多个可选链式调用在更深的模型层级中访问属性、方法以及下标。然而，多层可选链式调用不会增加返回值的可选层级。

:smile:赋值过程是可选链式调用的一部分，这意味着可选链式调用失败时，等号右侧的代码不会被执行。对于上面的代码来说，很难验证这一点，因为像这样赋值一个常量没有任何副作用。下面的代码完成了同样的事情，但是它使用一个函数来创建 Address 实例，然后将该实例返回用于赋值。该函数会在返回前打印“Function was called”，这使你能验证等号右侧的代码是否被执行。
```
func createAddress() -> Address {
    print("Function was called.")

    let someAddress = Address()
    someAddress.buildingNumber = "29"
    someAddress.street = "Acacia Road"

    return someAddress
}
john.residence?.address = createAddress()
```
没有任何打印消息，可以看出 createAddress() 函数并未被执行。


## 错误处理
:smile:Swift 中有 4 种处理错误的方式。你可以把函数抛出的错误传递给调用此函数的代码、用 do-catch 语句处理错误、将错误作为可选类型处理、或者断言此错误根本不会发生。

:smile:Swift 中的错误处理和其他语言中用 try，catch 和 throw 进行异常处理很像。和其他语言中（包括 Objective-C ）的异常处理不同的是，Swift 中的错误处理并不涉及解除调用栈，这是一个计算代价高昂的过程。就此而言，throw 语句的性能特性是可以和 return 语句相媲美的。

:smile:throwing 构造器能像 throwing 函数一样传递错误。例如下面代码中的 PurchasedSnack 构造器在构造过程中调用了 throwing 函数，并且通过传递到它的调用者来处理这些错误。
```
struct PurchasedSnack {
    let name: String
    init(name: String, vendingMachine: VendingMachine) throws {
        try vendingMachine.vend(itemNamed: name)
        self.name = name
    }
}
```

:smile:defer语句将代码的执行延迟到当前的作用域退出之前。该语句由defer关键字和要被延迟执行的语句组成。延迟执行的语句不能包含任何控制转移语句，例如break或是return语句，或是抛出一个错误。延迟执行的操作会按照它们被指定时的顺序的相反顺序执行——也就是说，第一条defer语句中的代码会在第二条defer语句中的代码被执行之后才执行，以此类推。

## 并发
:smile:如果你曾经写过并发的代码的话，那可能使用过线程。Swift 中的并发模型是基于线程的，但你不会直接和线程打交道。在 Swift 中，一个异步函数可以交出它在某个线程上的运行权，这样另一个异步函数在这个函数被阻塞时就能获得此线程的运行权。但是，Swift并不能确定当异步函数恢复运行时其将在哪条线程上运行。

:smile:因为有 await 标记的代码可以被挂起，所以在程序中只有特定的地方才能调用异步方法或函数：
- 异步函数，方法或变量内部的代码
- 静态函数 main() 中被打上 @main 标记的结构体、类或者枚举中的代码
- 非结构化的子任务中的代码，之后会在 非结构化并行 中说明

:smile:想让自己创建的类型使用 for-in 循环需要遵循 Sequence 协议，这里也同理，如果想让自己创建的类型使用 for-await-in 循环，就需要遵循 AsyncSequence 协议。

## 类型转换
:smile:转换没有真的改变实例或它的值。根本的实例保持不变；只是简单地把它作为它被转换成的类型来使用。

:smile:你可以在 switch 表达式的 case 中使用 is 和 as 操作符来找出只知道是 Any 或 AnyObject 类型的常量或变量的具体类型。

:smile:`Any`类型可以表示所有类型的值，包括可选类型。Swift 会在你用`Any`类型来表示一个可选值的时候，给你一个警告。如果你确实想使用`Any`类型来承载可选值，你可以使用`as`操作符显式转换为`Any`，如下所示：

```swift
let optionalNumber: Int? = 3
things.append(optionalNumber)        // 警告
things.append(optionalNumber as Any) // 没有警告
```

## 扩展（Extensions）
:smile:扩展可以给一个类型添加新的功能，但是不能重写已经存在的功能。

:smile:扩展可以添加新的计算型属性，但是不可以添加存储型属性，也不可以为已有属性添加属性观察器。

:smile:扩展能为类添加新的便利构造器，但是它们不能为类添加新的指定构造器或析构器。指定构造器和析构器必须总是由原始的类实现来提供。

:smile:如果你使用扩展为一个值类型添加构造器，同时该值类型的原始实现中未定义任何定制的构造器且所有存储属性提供了默认值，那么我们就可以在扩展中的构造器里调用默认构造器和逐一成员构造器。

## 协议
:smile:

协议可以要求遵循协议的类型提供特定名称和类型的实例属性或类型属性。协议不指定属性是存储型属性还是计算型属性，它只指定属性的名称和类型。此外，协议还指定属性是可读的还是可读可写的。

如果协议要求属性是可读可写的，那么该属性不能是常量属性或只读的计算型属性。如果协议只要求属性是可读的，那么该属性不仅可以是可读的，如果代码需要的话，还可以是可写的。

协议总是用 `var` 关键字来声明变量属性，在类型声明后加上 `{ set get }` 来表示属性是可读可写的，可读属性则用 `{ get }` 来表示。

在协议中定义类型属性时，总是使用 static 关键字作为前缀。当类类型遵循协议时，除了 static 关键字，还可以使用 class 关键字来声明类型属性

:smile:可以在协议中定义具有可变参数的方法，和普通方法的定义方式相同。但是，不支持为协议中的方法提供默认参数。

:smile:实现协议中的 mutating 方法时，若是类类型，则不用写 mutating 关键字。而对于结构体和枚举，则必须写 mutating 关键字。

:smile:你可以在遵循协议的类中实现构造器，无论是作为指定构造器，还是作为便利构造器。无论哪种情况，你都必须为构造器实现标上 required 修饰符

:smile:如果类已经被标记为 final，那么不需要在协议构造器的实现中使用 required 修饰符，因为 final 类不能有子类。

:smile:如果一个子类重写了父类的指定构造器，并且该构造器满足了某个协议的要求，那么该构造器的实现需要同时标注 `required` 和 `override` 修饰符：

```swift
protocol SomeProtocol {
    init()
}

class SomeSuperClass {
    init() {
        // 这里是构造器的实现部分
    }
}

class SomeSubClass: SomeSuperClass, SomeProtocol {
    // 因为遵循协议，需要加上 required
    // 因为继承自父类，需要加上 override
    required override init() {
        // 这里是构造器的实现部分
    }
}
```

:smile:遵循协议的类型可以通过可失败构造器（init?）或非可失败构造器（init）来满足协议中定义的可失败构造器要求。协议中定义的非可失败构造器要求可以通过非可失败构造器（init）或隐式解包可失败构造器（init!）来满足。

:smile:若要声明类专属的协议就必须继承于 AnyObject 

:smile:Swift 为以下几种自定义类型提供了 Equatable 协议的合成实现：
- 遵循 Equatable 协议且只有存储属性的结构体。
- 遵循 Equatable 协议且只有关联类型的枚举
- 没有任何关联类型的枚举

:smile:Swift 为以下几种自定义类型提供了 Hashable 协议的合成实现：
- 遵循 Hashable 协议且只有存储属性的结构体。
- 遵循 Hashable 协议且只有关联类型的枚举
- 没有任何关联类型的枚举

:smile:Swift 为没有原始值的枚举类型提供了 Comparable 协议的合成实现。如果枚举类型包含关联类型，那这些关联类型也必须同时遵循 Comparable 协议。在包含原始枚举类型声明的文件中声明其对 Comparable 协议的遵循，可以得到 < 操作符的合成实现，且无需自己编写任何关于 < 的实现代码。Comparable 协议同时包含 <=、> 和 >= 操作符的默认实现。

:smile:你通过添加 AnyObject 关键字到协议的继承列表，就可以限制协议只能被类类型采纳（以及非结构体或者非枚举的类型）。~~你可以在协议的继承列表中，通过添加 class 关键字来限制协议只能被类类型遵循，而结构体或枚举不能遵循该协议。class 关键字必须第一个出现在协议的继承列表中，在其他继承的协议之前~~
```
protocol SomeClassOnlyProtocol: AnyObject, SomeInheritedProtocol {
    // 这里是类专属协议的定义部分
}
```

:smile:

要求一个类型同时遵循多个协议是很有用的。你可以使用协议组合来复合多个协议到一个要求里。协议组合行为就和你定义的临时局部协议一样拥有构成中所有协议的需求。协议组合不定义任何新的协议类型。

协议组合使用 SomeProtocol & AnotherProtocol 的形式。你可以列举任意数量的协议，用和符号（&）分开。除了协议列表，协议组合也能包含类类型，这允许你标明一个需要的父类。

:smile:协议可以定义可选要求，遵循协议的类型可以选择是否实现这些要求。在协议中使用 optional 关键字作为前缀来定义可选要求。可选要求用在你需要和 Objective-C 打交道的代码中。协议和可选要求都必须带上 @objc 属性。标记 @objc 特性的协议只能被继承自 Objective-C 类的类或者 @objc 类遵循，其他类以及结构体和枚举均不能遵循这种协议。

:smile:使用可选要求时（例如，可选的方法或者属性），它们的类型会自动变成可选的。比如，一个类型为 (Int) -> String 的方法会变成 ((Int) -> String)?。需要注意的是整个函数类型是可选的，而不是函数的返回值。

:smile:协议中的可选要求可通过可选链式调用来使用，因为遵循协议的类型可能没有实现这些可选要求。类似 someOptionalMethod?(someArgument) 这样，你可以在可选方法名称后加上 ? 来调用可选方法。详细内容可在 可选链式调用 章节中查看。

:smile:协议扩展可以为遵循协议的类型增加实现，但不能声明该协议继承自另一个协议。协议的继承只能在协议声明处进行指定。

:smile:如果一个遵循的类型满足了为同一方法或属性提供实现的多个限制型扩展的要求， Swift 会使用最匹配限制的实现。

## 泛型
:smile:当你扩展一个泛型类型的时候，你并不需要在扩展的定义中提供类型参数列表。原始类型定义中声明的类型参数列表在扩展中可以直接使用，并且这些来自原始类型中的参数名称会被用作原始定义中类型参数的引用。

:smile:定义一个协议时，有的时候声明一个或多个关联类型作为协议定义的一部分将会非常有用。关联类型为协议中的某个类型提供了一个占位名（或者说别名），其代表的实际类型在协议被采纳时才会被指定。你可以通过 associatedtype 关键字来指定关联类型。

:smile:对关联类型添加约束通常是非常有用的。你可以通过定义一个泛型 where 子句来实现。通过泛型 where 子句让关联类型遵从某个特定的协议，以及某个特定的类型参数和关联类型必须类型相同。你可以通过将 where 关键字紧跟在类型参数列表后面来定义 where 子句，where 子句后跟一个或者多个针对关联类型的约束，以及一个或多个类型参数和关联类型间的相等关系。你可以在函数体或者类型的大括号之前添加 where 子句。

## 不透明类型
:smile:如果函数中有多个地方返回了不透明类型，那么所有可能的返回值都必须是同一类型。即使对于泛型函数，不透明返回类型可以使用泛型参数，但仍需保证返回类型唯一。

:smile:虽然使用不透明类型作为函数返回值，看起来和返回协议类型非常相似，但这两者有一个主要区别，就在于是否需要保证类型一致性。一个不透明类型只能对应一个具体的类型，即便函数调用者并不能知道是哪一种类型；协议类型可以同时对应多个类型，只要它们都遵循同一协议。总的来说，协议类型更具灵活性，底层类型可以存储更多样的值，而不透明类型对这些底层类型有更强的限定。

:smile:你不能将 Container 作为方法的返回类型，因为此协议有一个关联类型。你也不能将它用于对泛型返回类型的约束，因为函数体之外并没有暴露足够多的信息来推断泛型类型。
```
// 错误：有关联类型的协议不能作为返回类型。
func makeProtocolContainer<T>(item: T) -> Container {
    return [item]
}

// 错误：没有足够多的信息来推断 C 的类型。
func makeProtocolContainer<T, C: Container>(item: T) -> C {
    return [item]
}
```

## 自动引用计数
:smile:当其他的实例有更短的生命周期时，使用弱引用，也就是说，当其他实例析构在先时。在上面公寓的例子中，很显然一个公寓在它的生命周期内会在某个时间段没有它的主人，所以一个弱引用就加在公寓类里面，避免循环引用。相比之下，当其他实例有相同的或者更长生命周期时，请使用无主引用。

:smile:当 ARC 设置弱引用为nil时，属性观察不会被触发。

:smile:在使用垃圾收集的系统里，弱指针有时用来实现简单的缓冲机制，因为没有强引用的对象只会在内存压力触发垃圾收集时才被销毁。但是在 ARC 中，一旦值的最后一个强引用被移除，就会被立即销毁，

:smile:和弱引用类似，无主引用不会牢牢保持住引用的实例。和弱引用不同的是，无主引用在其他实例有相同或者更长的生命周期时使用。

:smile:但和弱引用不同，无主引用通常都被期望拥有值。所以，将值标记为无主引用不会将它变为可选类型，ARC 也不会将无主引用的值设置为 nil。

:smile:使用无主引用，你必须确保引用始终指向一个未销毁的实例。如果你试图在实例被销毁后，访问该实例的无主引用，会触发运行时错误。

:smile:Customer和CreditCard之间的关系与前面弱引用例子中Apartment和Person的关系略微不同。在这个数据模型中，一个客户可能有或者没有信用卡，但是一张信用卡总是关联着一个客户。为了表示这种关系，Customer类有一个可选类型的card属性，但是CreditCard类有一个非可选类型的customer属性。

:smile:上面的例子展示了如何使用安全的无主引用。对于需要禁用运行时的安全检查的情况（例如，出于性能方面的原因），Swift 还提供了不安全的无主引用。与所有不安全的操作一样，你需要负责检查代码以确保其安全性。 你可以通过 unowned(unsafe) 来声明不安全无主引用。如果你试图在实例被销毁后，访问该实例的不安全无主引用，你的程序会尝试访问该实例之前所在的内存地址，这是一个不安全的操作。

:smile:
可选值的底层类型是 Optional，是 Swift 标准库里的枚举。然而，可选是值类型不能被标记为 unowned 的唯一例外。

可选值包装的类不使用引用计数，所以不需要维持对可选值的强引用。

:smile:

`Person`和`Apartment`的例子展示了两个属性的值都允许为`nil`，并会潜在的产生循环强引用。这种场景最适合用弱引用来解决。

`Customer`和`CreditCard`的例子展示了一个属性的值允许为`nil`，而另一个属性的值不允许为`nil`，这也可能会产生循环强引用。这种场景最适合通过无主引用来解决。

然而，存在着第三种场景，在这种场景中，两个属性都必须有值，并且初始化完成后永远不会为`nil`。在这种场景中，需要一个类使用无主属性，而另外一个类使用隐式解析可选属性。

:smile:Swift 有如下要求：只要在闭包内使用 self 的成员，就要用 self.someProperty 或者 self.someMethod()（而不只是 someProperty 或 someMethod()）。这提醒你可能会一不小心就捕获了 self。

:smile:

在闭包和捕获的实例总是互相引用并且总是同时销毁时，将闭包内的捕获定义为无主引用。

相反的，在被捕获的引用可能会变为nil时，将闭包内的捕获定义为弱引用。弱引用总是可选类型，并且当引用的实例被销毁后，弱引用的值会自动置为nil。这使我们可以在闭包体内检查它们是否存在。

## 内存安全
:smile:内存访问冲突时，要考虑内存访问上下文中的这三个性质：访问是读还是写，访问的时长，以及被访问的存储地址。特别是，冲突会发生在当你有两个访问符合下列的情况：
- 至少有一个是写访问
- 它们访问的是同一个存储地址
- 它们的访问在时间线上部分重叠

:smile:一个函数会对它所有的 in-out 参数进行长期写访问。in-out 参数的写访问会在所有非 in-out 参数处理完之后开始，直到函数执行完毕为止。如果有多个 in-out 参数，则写访问开始的顺序与参数的顺序一致。

长期访问的存在会造成一个结果，你不能在访问以 in-out 形式传入后的原变量，即使作用域原则和访问权限允许——任何访问原变量的行为都会造成冲突。

长期写访问的存在还会造成另一种结果，往同一个函数的多个 in-out 参数里传入同一个变量也会产生冲突

:smile:mutating 方法在调用期间需要对 self 发起写访问，而同时 in-out 参数也需要写访问。在方法里，self 和 teammate 都指向了同一个存储地址——就像下面展示的那样。对于同一块内存同时进行两个写访问，并且它们重叠了，就此产生了冲突。

:smile:限制结构体属性的重叠访问对于保证内存安全不是必要的。保证内存安全是必要的，但因为访问独占权的要求比内存安全还要更严格——意味着即使有些代码违反了访问独占权的原则，也是内存安全的，所以如果编译器可以保证这种非专属的访问是安全的，那 Swift 就会允许这种行为的代码运行。特别是当你遵循下面的原则时，它可以保证结构体属性的重叠访问是安全的：
- 你访问的是实例的存储属性，而不是计算属性或类的属性
- 结构体是本地变量的值，而非全局变量
- 结构体要么没有被闭包捕获，要么只被非逃逸闭包捕获了

## 访问控制
:smile:为了简单起见，对于代码中可以设置访问级别的特性（属性、基本类型、函数等），在下面的章节中我们会统一称之为“实体”。

:smile:private 限制实体只能在其定义的作用域，以及同一文件内的 extension 访问。如果功能的部分细节只需要在当前作用域内使用时，可以使用 private 来将其隐藏。

:smile:open 只能作用于类和类的成员，它和 public 的区别主要在于 open 限定的类和成员能够在模块外能被继承和重写

:smile:Swift 中的访问级别遵循一个基本原则：实体不能定义在具有更低访问级别（更严格）的实体中。
- 一个 public 的变量，其类型的访问级别不能是 internal，fileprivate 或是 private。因为无法保证变量的类型在使用变量的地方也具有访问权限。
- 函数的访问级别不能高于它的参数类型和返回类型的访问级别。因为这样就会出现函数可以在任何地方被访问，但是它的参数类型和返回类型却不可以的情况。

:smile:当你的应用程序包含单元测试目标时，为了测试，测试模块需要访问应用程序模块中的代码。默认情况下只有开放访问或公开访问级别级别的实体才可以被其他模块访问。然而，如果在导入应用程序模块的语句前使用 @testable 特性，然后在允许测试的编译设置（Build Options -> Enable Testability）下编译这个应用程序模块，单元测试目标就可以访问应用程序模块中所有内部级别的实体。

:smile:一个 public 类型的所有成员的访问级别默认为 internal 级别，而不是 public 级别。如果你想将某个成员指定为 public 级别，那么你必须显式指定。这样做的好处是，在你定义公共接口的时候，可以明确地选择哪些接口是需要公开的，哪些是内部使用的，避免不小心将内部使用的接口公开。

:smile:元组的访问级别将由元组中访问级别最严格的类型来决定。例如，如果你构建了一个包含两种不同类型的元组，其中一个类型为内部访问级别，另一个类型为私有访问级别，那么这个元组的访问级别为私有访问级别。

> 元组不同于类、结构体、枚举、函数那样有单独的定义。一个元组的访问级别由元组中元素的访问级别来决定的，不能被显示指定。

:smile:函数的访问级别根据访问级别最严格的参数类型或返回类型的访问级别来决定。但是，如果这种访问级别不符合函数定义所在环境的默认访问级别，那么就需要明确地指定该函数的访问级别。

:smile:枚举成员的访问级别和该枚举类型相同，你不能为枚举成员单独指定不同的访问级别。

:smile:枚举定义中的任何原始值或关联值的类型的访问级别至少不能低于枚举类型的访问级别。

:smile:嵌套类型的访问级别和包含它的类型的访问级别相同，嵌套类型是 public 的情况除外。在一个 public 的类型中定义嵌套类型，那么嵌套类型自动拥有 internal 的访问级别。如果你想让嵌套类型拥有 public 访问级别，那么必须显式指定该嵌套类型的访问级别为 public。

:smile:你可以继承同一模块中的所有有访问权限的类，也可以继承不同模块中被 open 修饰的类。一个子类的访问级别不得高于父类的访问级别。例如，父类的访问级别是 internal，子类的访问级别就不能是 public。

:smile:如果在 private 级别的类型中定义嵌套类型，那么该嵌套类型就自动拥有 private 访问级别。如果在 public 或者 internal 级别的类型中定义嵌套类型，那么该嵌套类型自动拥有 internal 访问级别。

:smile:子类的访问级别不得高于父类的访问级别。

:smile:可以通过重写为继承来的类成员提供更高的访问级别。

:smile:

我们甚至可以在子类中，用子类成员去访问访问级别更低的父类成员，只要这一操作在相应访问级别的限制范围内（也就是说，在同一源文件中访问父类 `private` 级别的成员，在同一模块内访问父类 `internal` 级别的成员）：

```swift
public class A {
    private func someMethod() {}
}

internal class B: A {
    override internal func someMethod() {
        super.someMethod()
    }
}
```

因为父类 `A` 和子类 `B` 定义在同一个源文件中，所以在子类 `B` 可以在重写的 `someMethod()` 方法中调用 `super.someMethod()`。

:smile:常量、变量、属性不能拥有比它们的类型更高的访问级别。例如，你不能定义一个 public 级别的属性，但是它的类型却是 private 级别的。同样，下标也不能拥有比索引类型或返回类型更高的访问级别

如果常量、变量、属性、下标的类型是 private 级别的，那么它们必须明确指定访问级别为 private：

```swift
private var privateInstance = SomePrivateClass()
```

:smile:

常量、变量、属性、下标的 `Getters` 和 `Setters` 的访问级别和它们所属类型的访问级别相同。

`Setter` 的访问级别可以低于对应的 `Getter` 的访问级别，这样就可以控制变量、属性或下标的读写权限。在 `var` 或 `subscript` 关键字之前，你可以通过 `fileprivate(set)`，`private(set)` 或 `internal(set)` 为它们的写入权限指定更低的访问级别。

> 注意  
这个规则同时适用于存储型属性和计算型属性。即使你不明确指定存储型属性的 `Getter` 和 `Setter`，Swift 也会隐式地为其创建 `Getter` 和 `Setter`，用于访问该属性的后备存储。使用 `fileprivate(set)`，`private(set)` 和 `internal(set)` 可以改变 `Setter` 的访问级别，这对计算型属性也同样适用。  

:smile:

自定义构造器的访问级别可以低于或等于其所属类型的访问级别。唯一的例外是必要构造器，它的访问级别必须和所属类型的访问级别相同。

如同函数或方法的参数，构造器参数的访问级别也不能低于构造器本身的访问级别。

:smile:

如默认构造器所述，Swift 会为结构体和类提供一个默认的无参数的构造器，只要它们为所有存储型属性设置了默认初始值，并且未提供自定义的构造器。

默认构造器的访问级别与所属类型的访问级别相同，除非类型的访问级别是 public。如果一个类型被指定为 public 级别，那么默认构造器的访问级别将为 internal。如果你希望一个 public 级别的类型也能在其他模块中使用这种无参数的默认构造器，你只能自己提供一个 public 访问级别的无参数构造器。

:smile:

如果结构体中任意存储型属性的访问级别为 private，那么该结构体默认的成员逐一构造器的访问级别就是 private。否则，这种构造器的访问级别依然是 internal。

如同前面提到的默认构造器，如果你希望一个 public 级别的结构体也能在其他模块中使用其默认的成员逐一构造器，你依然只能自己提供一个 public 访问级别的成员逐一构造器。

:smile:如果你定义了一个 public 访问级别的协议，那么该协议的所有实现也会是 public 访问级别。这一点不同于其他类型，例如，当类型是 public 访问级别时，其成员的访问级别却只是 internal。

:smile:如果定义了一个继承自其他协议的新协议，那么新协议拥有的访问级别最高也只能和被继承协议的访问级别相同。例如，你不能将继承自 internal 协议的新协议定义为 public 协议。

:smile:

一个类型可以采纳比自身访问级别低的协议。例如，你可以定义一个 public 级别的类型，它可以在其他模块中使用，同时它也可以采纳一个 internal 级别的协议，但是只能在该协议所在的模块中作为符合该协议的类型使用。

采纳了协议的类型的访问级别取它本身和所采纳协议两者间最低的访问级别。也就是说如果一个类型是 public 级别，采纳的协议是 internal 级别，那么采纳了这个协议后，该类型作为符合协议的类型时，其访问级别也是 internal。

如果你采纳了协议，那么实现了协议的所有要求后，你必须确保这些实现的访问级别不能低于协议的访问级别。例如，一个 public 级别的类型，采纳了 internal 级别的协议，那么协议的实现至少也得是 internal 级别。

:smile:

你可以在访问级别允许的情况下对类、结构体、枚举进行扩展。扩展成员具有和原始类型成员一致的访问级别。例如，你扩展了一个 public 或者 internal 类型，扩展中的成员具有默认的 internal 访问级别，和原始类型中的成员一致 。如果你扩展了一个 private 类型，扩展成员则拥有默认的 private 访问级别。

或者，你可以明确指定扩展的访问级别（例如，private extension），从而给该扩展中的所有成员指定一个新的默认访问级别。这个新的默认访问级别仍然可以被单独指定的访问级别所覆盖。

:smile:如果你通过扩展来采纳协议，那么你就不能显式指定该扩展的访问级别了。协议拥有相应的访问级别，并会为该扩展中所有协议要求的实现提供默认的访问级别。

:smile:泛型类型或泛型函数的访问级别取决于泛型类型或泛型函数本身的访问级别，还需结合类型参数的类型约束的访问级别，根据这些访问级别中的最低访问级别来确定。

:smile:你定义的任何类型别名都会被当作不同的类型，以便于进行访问控制。类型别名的访问级别不可高于其表示的类型的访问级别。

## 高级运算符
:smile:与 C 语言中的算术运算符不同，Swift 中的算术运算符默认是不会溢出的。所有溢出行为都会被捕获并报告为错误。如果想让系统允许溢出行为，可以选择使用 Swift 中另一套默认支持溢出的运算符，比如溢出加法运算符（&+）。所有的这些溢出运算符都是以 & 开头的。

:smile:在默认情况下，当向一个整数赋予超过它容量的值时，Swift 默认会报错，而不是生成一个无效的数。

:smile:不能对默认的赋值运算符（=）进行重载。只有复合赋值运算符可以被重载。同样地，也无法对三元条件运算符 （a ? b : c） 进行重载。

## 类型
:smile:类型 Optional<Wrapped> 是一个枚举，有两个成员，none 和 some(Wrapped)，用来表示可能有也可能没有的值。

:smile:Swift 定义后缀 ? 来作为标准库中定义的命名型类型 Optional<Wrapped> 的语法糖。换句话说，下面两个声明是等价的：
```
var optionalInteger: Int?
var optionalInteger: Optional<Int>
```

:smile:当可以被访问时，Swift 语言定义后缀 ! 作为标准库中命名类型 Optional<Wrapped> 的语法糖，来实现自动解包的功能。如果尝试对一个值为 nil 的可选类型进行隐式解包，将会产生运行时错误。因为隐式解包，下面两个声明等价：
```
var implicitlyUnwrappedString: String!
var explicitlyUnwrappedString: Optional<String>
```

:smile:由于隐式解析可选类型和可选类型有同样的类型 Optional<Wrapped>，你可以在所有使用可选类型的地方使用隐式解析可选类型。比如，你可以将隐式解析可选类型的值赋给变量、常量和可选属性，反之亦然。

:smile:类、结构体或枚举类型的元类型是相应的类型名紧跟 .Type。协议类型的元类型——并不是运行时遵循该协议的具体类型——是该协议名字紧跟 .Protocol。比如，类 SomeClass 的元类型就是 SomeClass.Type，协议 SomeProtocol 的元类型就是 SomeProtocal.Protocol

:smile:你可以使用后缀 self 表达式来获取类型。比如，SomeClass.self 返回 SomeClass 本身，而不是 SomeClass 的一个实例。同样，SomeProtocol.self 返回 SomeProtocol 本身，而不是运行时遵循 SomeProtocol 的某个类型的实例。还可以对类型的实例使用 type(of:) 表达式来获取该实例动态的、在运行阶段的类型，如下所示：

:smile:Self 类型不是具体的类型，而是让你更方便的引用当前类型，不需要重复或者知道该类的名字。

:smile:在协议声明或者协议成员声明时，Self 类型引用的是最终遵循该协议的类型。

:smile:在结构体，类或者枚举值声明时，Self 类型引用的是声明的类型。在某个类型成员声明时，Self 类型引用的是该类型。在类成员声明时，Self 只能在以下几种情况中出现：
- 作为方法的返回类型
- 作为只读下标的返回类型
- 作为只读计算属性的类型
- 在方法体中

```
class Superclass {
    func f() -> Self { return self }
}
let x = Superclass()
print(type(of: x.f()))
// 打印 "Superclass"

class Subclass: Superclass { }
let y = Subclass()
print(type(of: y.f()))
// 打印 "Subclass"

let z: Superclass = Subclass()
print(type(of: z.f()))
// 打印 "Subclass"
```
上面例子的最后一部分表明 Self 引用的是值 z 的运行时类型 Subclass ，而不是变量本身的编译时类型 Superclass 。

:smile:在嵌套类型声明时，Self 类型引用的是最内层声明的类型。

:smile:Self 类型引用的类型和 Swift 标准库中 type(of:) 函数的结果一样。使用 Self.someStaticMember 访问当前类型中的成员和使用 type(of: self).someStaticMember 是一样的。

## 特性


## 模式

:smile:
:smile:
:smile:
:smile:
:smile:
:smile:
:smile:
:smile:
:smile:
:smile:
:smile:
:smile:
:smile:
:smile:
:smile:
:smile:
:smile:
:smile:
:smile:
:smile:
:smile:
:smile:
:smile:
:smile:
:smile:
:smile:
:smile:
:smile:
:smile:
:smile:
:smile:





