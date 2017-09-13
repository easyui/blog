# [一天回顾 The Swift Programming Language](https://github.com/numbbbbb/the-swift-programming-language-in-chinese)

## Swift 初见（A Swift Tour）
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

## 字符串和字符（Strings and Characters）
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

:smile:使用 `characters` 属性的 `indices` 属性会创建一个包含全部索引的范围(`Range`)，用来在一个字符串中访问单个字符。

```swift
for index in greeting.characters.indices {
   print("\(greeting[index]) ", terminator: "")
}
// 打印输出 "G u t e n   T a g ! "
```

:smile:注意： 您可以使用 insert(_:at:)、insert(contentsOf:at:)、remove(at:) 和 removeSubrange(_:) 方法在任意一个确认的并遵循 RangeReplaceableCollection 协议的类型里面，如上文所示是使用在 String 中，您也可以使用在 Array、Dictionary 和 Set 中。

:smile:在 Swift 中，字符串和字符并不区分地域(not locale-sensitive)。

## 集合类型 (Collection Types)
:smile:Swift 的所有基本类型(比如String,Int,Double和Bool)默认都是可哈希化的，可以作为集合的值的类型或者字典的键的类型。没有关联值的枚举成员值(在枚举有讲述)默认也是可哈希化的。

:smile:因为Hashable协议符合Equatable协议，所以遵循该协议的类型也必须提供一个"是否相等"运算符(==)的实现。

## 函数（Functions）
:smile:严格上来说，虽然没有返回值被定义，greet(person:) 函数依然返回了值。没有定义返回类型的函数会返回一个特殊的Void值。它其实是一个空的元组（tuple），没有任何元素，可以写成()。

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

:smile:如果闭包表达式是函数或方法的唯一参数，则当你使用尾随闭包时，你甚至可以把 `()` 省略掉：

```swift
reversedNames = names.sorted { $0 > $1 }
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

