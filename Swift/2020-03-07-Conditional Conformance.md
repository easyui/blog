# Conditional Conformance（Swift4.1&4.2）

随着 Xcode 10 的正式版发布，Swift 4.2 也正式问世，在 Swift 4.1 中引入的 Conditional Conformance 也有了一个小的升级，使用便利性再次提升。不了解 Swift 4.1 的同学也没有关系，本篇文章会针对 Conditional Conformance 进行完整的梳理。

首先我们对 Conditional Conformance 下个定义：

Conditional conformances express the notion that a generic type will conform to a particular protocol only when its type arguments meet certain requirements.

Conditional Conformance 表达的含义是：当一个泛型类型的类型参数满足某些条件时，该泛型类型实现了某个特定协议。举个例子，当 Array 类型的类型参数是 Equatable 的时候，我们希望 Array 自动成为 Equatable，具体以 extension 语法表达，如下：
```
extension Array: Equatable where Element: Equatable {
  static func == (lhs: Array,  rhs: Array) -> Bool {
    guard lhs.count == rhs.count else {
      return false
    }
    for (i, v) in lhs.enumerated() {
      if rhs[i] != v {
        return false
      }
    }
    return true
  }
}
```
这个扩展不仅可以用来直接比较一维数组，由于可以递归推断，同样可以比较多维数组：下面的 a1 和 a2 都是 Array<Array<Int>> 类型 ，由于 Int 是 Equatable ，所以 Array<Int> 也是 Equatable ，因此 Array<Array<Int>> 是Equatable，可以直接比较是否相等。
```
let a1 = [[123], [456,789]]
let a2 = [[123], [456,789]]
let a3: [[Int]] = []
print(a1 == a2) // true
print(a1 == a3) // false
```
关于 Conditional Conformance 还有一个非常重要的特性，就是它对于运行时 Conditional Conformance 的支持。来看下面的代码：
```
protocol P {
  func doSomething()
}

struct S: P {
  func doSomething() { print("S") }
}

extension Array: P where Element: P {
  func doSomething() {
    for value in self {
      value.doSomething()
    }
  }
}

// compile-time
func doSomethingStatically<E: P>(_ value:Array<E>) {
  value.doSomething()
}

// runtime
func doSomethingIfP(_ value: Any) {
  if let p = value as? P {
    p.doSomething()
  } 
}

doSomethingIfP([S(), S(), S()]) 
```
我们看到了两个版本，前者是编译器确定了这个扩展的有效性；后者是 runtime 的时候做检查，它体现了 Conditional Conformance 对动态检查的支持。

如何来直观感受 Conditional Conformance 运行时特性的作用呢？我们可以想象是自己是被传入的参数：我是个普通的 Array，只不过我的元素类型实现了 P。结果可以动态发现我作为 Array 也实现了 protocol P，并且拥有了新方法 doSomething 。哪怕我是被作为 Any 类型传入的，动态也能判断上述事实。我只是个 Array ，元素类型实现了 P 而已。 Conditional Conformance 的扩展使这一切成为可能。

这里我们回顾一个知识点，为什么我们最后需要新写个 protocol P 来举例，而不直接用前面的 Equatable 呢？

用另一个问题可以回答：在Swift中，可不可以写 as? Equatable，或者 var e : Equatable = 10 呢？其实是不能的，因为Equatable这样的protocol只能作为泛型的类型约束，而不能作为可以直接hold值的类型，原因是它有 associated type 或者Self；也没有Equatable<Int> 的写法，Equatable 不是泛型类型，只是泛型约束。

事实上，从 Swift 4.1 开始标准库就加入了一系列 Equatable、Encodable、Decodable 的 Conditional Conformance，例如：
```
extension Optional: Equatable where Wrapped: Equatable { /* ... */ }

extension Array: Equatable where Element: Equatable { /* ... */ }

extension Dictionary: Equatable where Value: Equatable { /* ... */ }

extension Array: Encodable where Element: Encodable { /* ... */ }

extension Array: Decodable where Element: Decodable { /* ... */ }
```
Swift 4.2 中对 Hashable 也内置了一系列 Conditional Conformance：也就是当其类型参数是 Hashable 的时候 Optional, Array, Dictionary 和 Range 也是 Hashable，非常便利的一个改进。

小结
介绍了 Conditional Conformance 的语法和语义
以 Array 为例介绍了 Conditional Conformance 用途
Conditional Conformance 支持运行时判断
标准库内置 Array 和 Hashable 的 Conditional Conformance

THX:
> [Swift 4.2 新特性详解 Conditional Conformance 的更新](https://www.jianshu.com/p/fee9f1146aed)