# @dynamicMemberLookup与@dynamicCallable

## @dynamicMemberLookup

### 介绍
Swift 4.2 中引入了一个新的语法@dynamicMemberLookup（动态成员查找）。使用@dynamicMemberLookup标记了目标（类、结构体、枚举、协议），实现subscript(dynamicMember member: String)方法后我们就可以访问到对象不存在的属性。

### 核心内容
- @dynamicMemberLookup：标记类、结构体、枚举、协议
- subscript(dynamicMember member: String)：实现该方法，可以像数组和字典一样，用下标的方式去访问属性，通过所请求属性的字符串名得到并返回想要的值

###基本使用

- 错误的代码
```
struct Person {

}

let p = Person()
// 结构体没有定义name属性，所以会报错
// Value of type 'Person' has no member 'name'
print(p.name)
```

- 有了动态成员查找
```
// 标记
@dynamicMemberLookup
struct Person {

    // 实现方法
    subscript(dynamicMember member: String) -> String {
        let properties = ["name":"Zhangsan", "age": "20", "sex": "男"]
        return properties[member, default: "unknown property"]
    }

}

let p = Person()
print(p.name) // 打印 Zhangsan
print(p.age) // 打印 20
print(p.sex) // 打印 男
```

### 解读

- 声明了@dynamicMemberLookup后，即使属性没有定义，但是程序会在运行时动态的查找属性的值，调用subscript(dynamicMember member: String)方法来获取值。
- subscript(dynamicMember member: String)方法的返回值类型根据访问属性的类型决定。
- 由于安全性的考虑，如果实现了这个特性，返回值不能是可选值，一定要有值返回。

### 多类型查找
既然是动态查找，如果两个属性类型不同，怎么办？解决办法是重载subscript(dynamicMember member: String)方法。和泛型的逻辑类似，通过类型推断来选择对应的方法。但是此时调用的时候，所有属性必须显示声明类型，否则会报错。

```
@dynamicMemberLookup
struct Person {

    subscript(dynamicMember member: String) -> String {
        let properties = ["name":"Zhangsan", "sex": "男"]
        return properties[member, default: "unknown property"]
    }

    subscript(dynamicMember member: String) -> Int {
        let properties = ["age": 20]
        return properties[member, default: 0]
    }

}

let p = Person()
// 类型必须明确
let name: String = p.name
print(name) // 打印 Zhangsan
let age: Int = p.age
print(age) // 打印 20
let sex: String = p.sex
print(sex) // 打印 男
```

## @dynamicCallable

### 介绍
Swift 5 中引入了一个新的语法@dynamicCallable（动态可调用）。使用@dynamicCallable标记了目标以后（类、结构体、枚举、协议），实现dynamicallyCall方法后，目标可以像调用函数一样使用。

### 核心内容
- @dynamicCallable：标记类、结构体、枚举、协议
- dynamicallyCall：实现该方法，可以像调用函数一样去调用类型，需要指定接收的参数和参数类型。

### 基本使用
```
// 标记
@dynamicCallable
struct Person {

    // 实现方法一
    func dynamicallyCall(withArguments: [String]) {

        for item in withArguments {
            print(item)
        }

    }

    // 实现方法二
    func dynamicallyCall(withKeywordArguments: KeyValuePairs<String, String>){

        for (key, value) in withKeywordArguments {

            print("\(key) --- \(value)")

        }

    }

}

let p = Person()

p("zhangsan")
// 等于 p.dynamicallyCall(withArguments: ["zhangsan"])

p("zhangsan", "20", "男")
// 等于 p.dynamicallyCall(withArguments: ["zhangsan", "20", "男"])

p(name: "zhangsan")
// 等于 p.dynamicallyCall(withKeywordArguments: ["name": "zhangsan"])

p(name: "zhangsan", age:"20", sex: "男")
// 等于 p.dynamicallyCall(withKeywordArguments: ["name": "zhangsan", "age": "20", "sex": "男"])
```

### 解读

- 声明了@dynamicMemberLookup后，必须实现dynamicallyCall(withArguments:)和dynamicallyCall(withKeywordArguments:)两个方法中的至少一个，否则编译器会报错。
- 当目标调用的时候，会转换成方法的调用，然后传入对应的参数与参数类型。
- 实现了dynamicallyCall(withArguments:)
  - 参数类型根据自己需要调整，如上例[String]。
  - 当目标调用的时候，参数不带标签。
  - 参数为数组时，可以理解为可变参数，调用时传入的参数可以是1个，也可以是多个。
- 实现了dynamicallyCall(withKeywordArguments:)
  - 参数类型为KeyValuePairs，暂时可以把它当成字典来用，主要改变的是value的类型，如上例中为String。
  - 当目标调用的时候，参数带标签。

### 注意事项
- 如果实现dynamicallyCall(withKeywordArguments:)但没有实现dynamicallyCall(withArguments:)，也可以在没有参数标签的情况下调用
- 如果实现dynamicallyCall(withKeywordArguments:)或dynamicallyCall(withArguments:)时标记为throw，则调用该类型也将被抛出throw
- 扩展无法添加@dynamicCallable，只能添加到主要类型上

### KeyValuePairs
在 Swift 5 中，之前的DictionaryLiteral类型被重命为KeyValuePairs。

- 字典有一个构造函数public init(dictionaryLiteral elements: (Key, Value)...)，其中后面的那一串就是DictionaryLiteral，即KeyValuePairs。

```
let dic = Dictionary(dictionaryLiteral: ("name","zhangsan"), ("age","20"),("sex","男"))
print(dic["name"])
```

- KeyValuePairs只有一个构造函数
```
// 构造函数
public init(dictionaryLiteral elements: (Key, Value)...)

// 构造一个person
let person: KeyValuePairs = KeyValuePairs(dictionaryLiteral: ("name","zhangsan"), ("age","20"),("sex","男"))

```

- 与字典的区别 官方介绍：字典中键值对的顺序是不可预测的。 如果您需要有序的键值对集合并且不需要Dictionary提供的快速键查找，请使用KeyValuePairs类型以获取替代方案。

### 意义
与字典的区别 官方介绍：字典中键值对的顺序是不可预测的。 如果您需要有序的键值对集合并且不需要Dictionary提供的快速键查找，请使用KeyValuePairs类型以获取替代方案。

> [Swift学习之@dynamicMemberLookup与@dynamicCallable](http://www.cocoachina.com/cms/wap.php?action=article&id=54651)

> [Swift新特性 dynamicMemberLookup和dynamicCallable](https://juejin.im/post/5d071b046fb9a07f070e2c70)

> [细说 Swift 4.2 新特性：Dynamic Member Lookup](https://www.jianshu.com/p/13e6aa1ad584)






