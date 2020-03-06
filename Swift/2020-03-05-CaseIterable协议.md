# CaseIterable协议(Swift4.2+)

[SE-0194](https://github.com/apple/swift-evolution/blob/master/proposals/0194-derived-collection-of-enum-cases.md)介绍了在Swift 4.2中新增的一个新的CaseIterable协议

## 定义的简单枚举遵循CaseIterable协议后, 编译时Swift 会自动合成一个allCases属性，是包含枚举的所有case项的数组
```
enum NetState: CaseIterable {
    case wifi
    case hotWifi
    case mobile
    case none
}
```
之后我们在其他地方调用改枚举时就可以获取到allCase属性, 如下

```
print(NetState.allCases)
print("case个数: " + "\(NetState.allCases.count)")

for item in NetState.allCases {
    print(item)
}

// 输出结果:
[__lldb_expr_9.NetState.wifi, __lldb_expr_9.NetState.hotWifi, __lldb_expr_9.NetState.mobile, __lldb_expr_9.NetState.none]

case个数: 4

wifi
hotWifi
mobile
none
```

所谓“简单枚举类型”，指的是不带关联值的枚举类型。

> Swift 支持一些标准库类型的自动合成，在Swift 4.1 中，我们曾就提到过 合成的Equatable 和 Hashable以及 Codable。所以 CaseIterable 是另一个支持自动合成的 -able 协议。



## CaseIterable 编译器不会自动实现allCases，只能手动重写添加allCases的情况

### 编译器不会自动为具有关联值得枚举合成allCases的实现，因为他可能具有无限数量的情况
```
enum FoodKind: CaseIterable {
    //此处, 必须重写allCases属性, 否则报错
    static var allCases: [FoodKind] {
        return [.apple, .pear, .orange(look: false)]
    }
    
    case apple
    case pear
    case orange(look: Bool)
}

for item in FoodKind.allCases {
    print(item)
}

/*
 * 输出结果:
 apple
 pear
 orange(look: false)
*/
```

### 如果有枚举项标记为unavailable，则默认无法合成allCases
```
enum CarKind: CaseIterable {
    //当有unavailable修饰的case值, 也必须重写allCase属性
    static var allCases: [CarKind] {
        return [.bwm, .ford]
    }
    
    case bwm
    case ford
    
    @available(*, unavailable)
    case toyota
}

for item in CarKind.allCases {
    print(item)
}

/*
 输出结果:
 bwm
 ford
 */
```

> 如果枚举中某一元素不想被列出来，我们这就需要自定义了

## 详解 CaseIterable
也许你会好奇，既然某些情况下编译器不能合成，那么我们完全可以自己添加 allCases 属性，而不声明实现 CaseIterable。首先，这样是可以的，因为以前就是这么做的。其次，你也有可能会失去一些其他方面针对 CaseIterable 协议设计的一些功能；当然到需要的时候，再通过extension来扩展声明实现也是可以的。

CaseIterable 如同 Equatable 和 Hashable 一样，是泛型约束，而不是泛型类型，它的具体定义如下：
```
public protocol CaseIterable {

    /// A type that can represent a collection of all values of this type.
    associatedtype AllCases : Collection where Self.AllCases.Element == Self

    /// A collection of all values of this type.
    static var allCases: Self.AllCases { get }
}
```

首先，它定义类一个关联类型 AllCases 作为 allCases 的返回值，然后约束这个类型是一个 Collection，并且 Element 和 这个枚举一致。我们之前的例子使用了Array，因此满足这个约束。

当然，这个 CaseIterable 也可以简单些，比如这样：
```
public protocol CaseIterable2 {    
    static var allCases: [Self] { get }
}
```

这当然也是可以的，缺点是没有那么面向协议了。标准库之所以采用了约束的形式，是希望不跟任何具体 Collection 类型耦合。所以我们好奇地想知道，编译器合成 CaseIterable 是使用了哪个具体的 Collection 类型呢？

```
enum Weekday : String, CaseIterable {
    case monday, tuesday, wednesday, thursday, friday
}

print(type(of:Weekday.allCases))
```
原来还是 Array<Weekday>。




