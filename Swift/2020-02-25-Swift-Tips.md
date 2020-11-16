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




