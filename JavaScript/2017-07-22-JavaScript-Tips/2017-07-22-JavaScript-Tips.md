# JavaScript Tips


## :smile:内部函数能访问外部函数的实际变量而无须复制！
```javascript
//错误例子
var add_the_handlers = function (nodes) {
    var i;
    for (i = 0; i < nodes.length; i += 1) {
        nodes[i].onclick = function (e) {
            alert(i);//alert出来的永远是节点的数量
        }
    }
};

//正确的处理
var add_the_handlers = function (nodes) {
    var i;
    for (i = 0; i < nodes.length; i += 1) {
        nodes[i].onclick = function (i) { //辅助函数返回一个绑定了当前i值的函数
            return function (e) {
                alert(i);
            };
        }(i);
    }
};
```

## :smile:布尔值为false
- false
- null
- undefined
- 空字符串''
- 数字 0
- 数字 NaN

JavaScript中的真值示例如下（将被转换为true类型，if 后的代码段将被执行）：
```
if (true)
if ({})
if ([])
if (42)
if ("foo")
if (new Date())
if (-42)
if (3.14)
if (-3.14)
if (Infinity)
if (-Infinity)
```


## :smile:七个数据类型：
undefined、null、布尔值（Boolean）、字符串（String）、数值（Number）、对象（Object）、ES6 引入了一种新的原始数据类型Symbol。

## :smile:可以通过函数和闭包来构造模块。模块是一个提供接口却隐藏状态与实现的函数或对象。
```javascript
//demo1
Function.prototype.method = function (name, func) {
    this.prototype[name] = func;
    return this;
};

String.method('deentityify', function (  ) {
    var entity = {
        quot: '"',
        lt:   '<',
        gt:   '>'
    };

// Return the deentityify method.
    return function (  ) {
        return this.replace(/&([^&;]+);/g,
            function (a, b) {
                var r = entity[b];
                return typeof r === 'string' ? r : a;
            }
        );
    };
}(  ));

document.writeln(
    '&lt;&quot;&gt;'.deentityify(  ));  // <">
    
//demo2
var serial_maker = function (  ) {
    var prefix = '';
    var seq = 0;
    return {
        set_prefix: function (p) {
            prefix = String(p);
        },
        set_seq: function (s) {
            seq = s;
        },
        gensym: function (  ) {
            var result = prefix + seq;
            seq += 1;
            return result;
        }
    };
}(  );

var seqer = serial_maker(  );
seqer.set_prefix = 'Q';
seqer.set_seq = 1000;
var unique = seqer.gensym(  );    // unique is "Q1000"

```

## :smile: 在JavaScript无法重载或者自定义运算符，包括等号。

## :smile: 函数声明和变量声明的提升
先举一个函数提升的例子。
```javascript
function foo() {
  bar();
  function bar() {
    ……
  }
}
```
var 变量也具有提升的特性。但是把函数赋值给变量以后，提升的效果就会消失。
```javascript
function foo() {
  bar(); // error！
  var bar = function () {
    ……
  }
}
```
上述函数就没有提升效果了。
**函数声明是做了完全提升，变量声明只是做了部分提升。变量的声明才有提升的作用，赋值的过程并不会提升，赋值还在原地。**

**如果变量和函数都存在提升的情况，那么函数提升优先级更高。**

**ES6中引入了 let 和 const 关键字，使用这两个关键字就不会有变量提升了。**

## :smile: ES6引入了块作用域，立即执行函数表达式（IIFE）不再必要了。
```javascript
//ES6之前，
// IIFE 写法
(function () {
  var tmp = ...;
  ...
}());

//ES6
// 块级作用域写法
{
  let tmp = ...;
  ...
}
```

## :smile: 箭头函数this
箭头函数根本就没有自己的 this，导致内部的 this 就是外层代码块的 this，正因为这个特性，也导致了以下的情况都不能使用箭头函数：
1、不能当做构造函数，不能使用 new 命令，因为没有 this，否则会抛出一个错误。
2、不可以使用 argument 对象，该对象在函数体内不存在，非要使用就只能用 rest 参数代替。也不能使用 super，new.target 。
3、不可以使用 yield 命令，不能作为 Generator 函数。
4、不可以使用call()，apply()，bind()这些方法改变 this 的指向。

## :smile: 比较运算
![比较运算](比较运算符.png)

## :smile:  for-in 遍历数组得到的是数组索引字符串
```javascript
var scores = [ 11,22,33,44,55,66,77 ];
var total = 0;
for (var score in scores) {
  total += score;
}
//total 是 ‘00123456’ 
```

**数组的遍历**

| 循环方式 | 遍历对象 | 副作用
|-|-|-|
| for |  | 写法比较麻烦
| for-in | 索引值(键名)，而非数组元素 | 遍历所有(非索引)属性，以及继承过来的属性（可以用hasOwnProperty()方法排除继承属性），主要是为遍历对象而设计的，不适用于遍历数组
| forEach| 		| 不方便break，continue，return
| for...of| 	内部通过调用 Symbol.iterator 方法，实现遍历获得键值	| 不可遍历普通的对象，因为没有 Iterator 接口

**ES6对象的遍历**

| 循环方式 | 遍历对象
|-|-|
| for...in | 循环遍历对象自身的和继承的可枚举属性（不包含Symbol属性））
| Object.key(obj) | 返回一个数组，包括对象自身的(不含继承的)所有可枚举属性(不含Symbol属性)
| Object.getOwnPropertyNames(obj) | 返回一个数组，包含对象自身的所有属性(不含 Symbol 属性，但是包含不可枚举的属性)
| Object.getOwnPropertySymbols(obj) | 返回一个数组，包含对象自身的所有 Symbol 属性
| Reflect.ownKeys(obj) | 返回一个数组，包含对象自身的所有属性，不管属性名是 Symbol 或者字符串或者是否可枚举
| Reflect.enumerate(obj) | 返回一个 Iterator对象，遍历对象自身的和继承的所有可枚举属性(不包含 Symbol 属性)，与 for...in循环相同

**数字遍历对空值的处理**

在 ES5 中：

|方法 | 针对空缺
|-|-|
| forEach() | 遍历时跳过空缺
| every() | 遍历时跳过空缺
| some() | 遍历时跳过空缺
| map() | 遍历时跳过空缺，但是最终结果会保留空缺
| filter() | 去除空缺
| join() | 把空缺，undefined，null转化为空字符串
| toString() | 把空缺，undefined，null转化为空字符串
| sort() | 排序时保留空缺
| apply() | 把每个空缺转化为undefined

在 ES6 中：规定，遍历时不跳过空缺，空缺都转化为undefined

| 方法 | 针对空缺
|-|-|
| Array.from() | 空缺都转化为undefined
| ...(扩展运算符有) | 空缺都转化为undefined
| copyWithin() | 连空缺一起复制
| fill() | 遍历时不跳过空缺，视空缺为正常的元素
| for...of | 遍历时不跳过空缺
| entries() | 空缺都转化为undefined
| keys() | 空缺都转化为undefined
| values() | 空缺都转化为undefined
| find() | 空缺都转化为undefined
| findIndex() | 空缺都转化为undefined p0p0

## :smile: 
只有函数对象才有prototype属性;

所有对象都有constructor属性和__proto__属性(对象从原型对象中继承这个属性)

## :smile: 取整效率
JavaScript中是没有整型概念的，但利用好位操作符可以轻松处理，同时获得效率上的提升。

测试代码：

```javascript
  Benchmark.prototype.setup = function() {       
  var a = 89.938 / 293.3;
  var b = 83784 / 9289.2;
  var c = 7 / 60;     
  };
```  

测试结果：

![取整测试](取整测试.png)


结果：

`>>> 0` 、`|0` 和`~~` 性能会更好，在处理像素及动画位移等效果的时候会很有用。（[性能测试](https://jsperf.com/math-floor-vs-math-round-vs-parseint/42)）

> Math.floor是向下取整，Math.ceil是向上取整，Math.round是四舍五入，其他都是截断取整。

## :smile: `~`和`!~`
```javascript
if (~names.indexOf(name)){//如果存在则为true
    ...
}    
if (!~names.indexOf(name)){//如果不存在则为true
    ...
}            
```

## :smile: 交换两个变量值
```javascript
let a = 'world', b = 'hello'
[a, b] = [b, a]
console.log(a) // -> hello
console.log(b) // -> world         
```

## :smile: 等待多个请求返回后处理
```javascript
const [user, account] = await Promise.all([
  fetch('/user'),
  fetch('/account')
])     
```

## :smile: debug的时候输出多个变量
```
const a = 5, b = 6, c = 7
console.log({ a, b, c })
// outputs this nice object:
// {
//    a: 5,
//    b: 6,
//    c: 7
// }
```

## :smile: debug的时候输出多个变量
```
const a = 5, b = 6, c = 7
console.log({ a, b, c })
// outputs this nice object:
// {
//    a: 5,
//    b: 6,
//    c: 7
// }
```

## :smile: 合并数组
```
const one = ['a', 'b', 'c']
const two = ['d', 'e', 'f']
const three = ['g', 'h', 'i']
// Old way #1
const result = one.concat(two, three)
// Old way #2
const result = [].concat(one, two, three)
// New
const result = [...one, ...two, ...three]
```

## :smile: 克隆对象或数组
```
const obj = { ...oldObj }
const arr = [ ...oldArr ]
```
