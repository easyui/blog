# KeyValuePairs是轻量化的有序键值对(key-value)集合(Swift5+)

## [SE-0214:Renaming the DictionaryLiteral type to KeyValuePairs](https://github.com/apple/swift-evolution/blob/master/proposals/0214-DictionaryLiteral.md)
Swift 4.2 使用 DictionaryLiteral 来声明字典：

```
let pets: DictionaryLiteral = ["dog": "Sclip", "cat": "Peti"]
```

DictionaryLiteral 不是一个字典或字面量，而是一组键-值对的列表。
Swift 5 将 DictionaryLiteral 重命名为:

```
let pets: KeyValuePairs = ["dog": "Sclip", "cats": "Peti"]
```


## 概述：KeyValuePairs是轻量化的有序键值对（key-value）集合

当需要顺序存储键值对并且不需要快速查找关键值对应的值时，可以使用该类型的实例对象，当使用该类型时，key和value都不要求是Hashable类型的

使用创建Dictionary的语法创建KeyValuePairs，除了保持键值对有序外，KeyValuePairs还允许出现重复的key

```
let recordTimes: KeyValuePairs = ["Florence Griffith-Joyner11": 10.49,
                                  "Evelyn Ashford": 10.76,
                                  "Evelyn Ashford": 10.79,
                                          "Marlies Gohr": 10.81]
print(recordTimes.first!)
//(key: "Florence Griffith-Joyner11", value: 10.49)
```

Dictionary中的一些高效率操作在KeyValuePairs中要慢的多，比如查找特定的key。使用 .firstIndex(where:) 查找特定的key时，必须顺序遍历集合中的每一项才能找到对应的key所在项的索引，而在Dictionary中，可以直接通过散列函数计算得到key所在的项，从而得到索引

```
let runner = "Evelyn Ashford"
if let index = recordTimes.firstIndex(where: { $0.0 == runner }) {
    let time = recordTimes[index].1
    print("\(runner) set a 100m record of \(time) seconds.")
} else {
    print("\(runner) couldn't be found in the records.")
}
//Evelyn Ashford set a 100m record of 10.76 seconds.
```

## KeyValuePairs作为函数参数：
keyValuePairs作为函数参数时，调用该函数可以直接传入Dictionary的字面值作为函数参数，而不需要创建Dictionary的实例对象，同时还能保证传入的键值对是有序的，这在要求键值对保持有序性的场景中是非常实用的。

```
struct IntPairs {
    var elements: [(Int, Int)]
    init(_ elements: KeyValuePairs<Int, Int>) { 
        self.elements = Array(elements)
    }
}
let pairs = IntPairs([1: 2, 1: 1, 3: 4, 2: 1])
print(pairs.elements)
// [(1, 2), (1, 1), (3, 4), (2, 1)]
```

> [Swift--KeyValuePairs 详解](https://www.jianshu.com/p/7749283b7ce9)