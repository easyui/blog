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

## :smile:




