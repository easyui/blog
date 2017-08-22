# 你不知道的JavaScript（上卷）
## :smile:P13 不成功的 RHS 引用会导致抛出 ReferenceError 异常。不成功的 LHS 引用会导致自动隐式 地创建一个全局变量(非严格模式下)，该变量使用 LHS 引用的目标作为标识符，或者抛 出 ReferenceError 异常(严格模式下)。

## :smile:P16 无论函数在哪里被调用，也无论它如何被调用，它的词法作用域都只由函数被声明时所处 的位置决定。

## :smile:P18 在严格模式的程序中，eval(..) 在运行时有其自己的词法作用域，意味着其 中的声明无法修改所在的作用域。
```
function foo(str) { "use strict";
   eval( str );
   console.log( a ); // ReferenceError: a is not de ned
}
foo( "var a = 2" );
```
                 
## :smile:P18 
JavaScript中 还 有 其 他 一 些 功 能 效 果 和eval(..)很 相 似。setTimeout(..)和 setInterval(..) 的第一个参数可以是字符串，字符串的内容可以被解释为一段动态生成的 函数代码。这些功能已经过时且并不被提倡。不要使用它们!

new Function(..) 函数的行为也很类似，最后一个参数可以接受代码字符串，并将其转 化为动态生成的函数(前面的参数是这个新生成的函数的形参)。这种构建函数的语法比 eval(..) 略微安全一些，但也要尽量避免使用。
## :smile:P20 eval(..) 函数如果接受了含有一个或多个声明的代码，就会修改其所处的词法作用域，而 with 声明实际上是根据你传递给它的对象凭空创建了一个全新的词法作用域。
## :smile:P21 
JavaScript 中有两个机制可以“欺骗”词法作用域:eval(..) 和 with。前者可以对一段包 含一个或多个声明的“代码”字符串进行演算，并借此来修改已经存在的词法作用域(在 运行时)。后者本质上是通过将一个对象的引用当作作用域来处理，将对象的属性当作作 用域中的标识符来处理，从而创建了一个新的词法作用域(同样是在运行时)。

这两个机制的副作用是引擎无法在编译时对作用域查找进行优化，因为引擎只能谨慎地认 为这样的优化是无效的。使用这其中任何一个机制都将导致代码运行变慢。不要使用它们。
## :smile:P27 区分函数声明和表达式最简单的方法是看 function 关键字出现在声明中的位 置(不仅仅是一行代码，而是整个声明中的位置)。如果 function 是声明中 的第一个词，那么就是一个函数声明，否则就是一个函数表达式。
## :smile:P29 
相较于传统的 IIFE 形式，很多人都更喜欢另一个改进的形式:(function(){ .. }())。仔 细观察其中的区别。第一种形式中函数表达式被包含在 ( ) 中，然后在后面用另一个 () 括 号来调用。第二种形式中用来调用的 () 括号被移进了用来包装的 ( ) 括号中。
这两种形式在功能上是一致的。选择哪个全凭个人喜好。
## :smile:P29 
IIFE 还有一种变化的用途是倒置代码的运行顺序，将需要运行的函数放在第二位，在 IIFE 执行之后当作参数传递进去。这种模式在 UMD(Universal Module Definition)项目中被广 泛使用。尽管这种模式略显冗长，但有些人认为它更易理解。
```
var a = 2;
   函数作用域和块作用域 | 29
(function IIFE( def ) { def( window );
})(function def( global ) {
var a = 3;
console.log( a ); // 3 console.log( global.a ); // 2
});
```
函数表达式 def 定义在片段的第二部分，然后当作参数(这个参数也叫作 def)被传递进 IIFE 函数定义的第一部分中。最后，参数 def(也就是传递进去的函数)被调用，并将 window 传入当作 global 参数的值。
## :smile:P30 块作用域
- with 关键字。它不仅是一个难于理解的结构，同时也是块作用域的一 个例子(块作用域的一种形式)，用 with 从对象中创建出的作用域仅在 with 声明中而非外 部作用域中有效。
- JavaScript 的 ES3 规范中规定 try/catch 的 catch 分句会创建一个块作
用域，其中声明的变量仅在 catch 内部有效。
- ES6中let和const 关键字可以将变量绑定到所在的任意作用域中(通常是 { 为其声明的变量隐式地了所在的块作用域。

一个 let 可以发挥优势的典型例子就是之前讨论的 for 循环。
```
for (let i=0; i<10; i++) { 
   console.log( i );
}
console.log( i ); // ReferenceError
```
for 循环头部的 let 不仅将 i 绑定到了 for 循环的块中，事实上它将其重新绑定到了循环 的每一个迭代中，确保使用上一个循环迭代结束时的值重新进行赋值。
下面通过另一种方式来说明每次迭代时进行重新绑定的行为: 
```
{
   let j;
   for (j=0; j<10; j++) {
   let i = j; // 每个迭代重新绑定!
             console.log( i );
   }
}
```
## :smile:P39 函数声明会被提升，但是函数表达式却不会被提升。 
```
foo(); // 不是 ReferenceError, 而是 TypeError!
var foo = function bar() { // ...
};
```
这段程序中的变量标识符 foo() 被提升并分配给所在作用域(在这里是全局作用域)，因此 foo() 不会导致 ReferenceError。但是 foo 此时并没有赋值(如果它是一个函数声明而不 是函数表达式，那么就会赋值)。foo() 由于对 undefined 值进行函数调用而导致非法操作， 因此抛出 TypeError 异常。

同时也要记住，即使是具名的函数表达式，名称标识符在赋值之前也无法在所在作用域中使用:
```
foo(); // TypeError
bar(); // ReferenceError
var foo = function bar() { // ...
};
```
这个代码片段经过提升后，实际上会被理解为以下形式:
```
var foo;
foo(); // TypeError
bar(); // ReferenceError
foo = function() {
var bar = ...self... // ...
}
```
## :smile:P41
尽管重复的 var 声明会被忽略掉，但出现在后面的函数声明还是可以覆盖前面的。 
```
foo(); // 3
function foo() { console.log( 1 );
}
var foo = function() { console.log( 2 );
};
function foo() { console.log( 3 );
}
```
虽然这些听起来都是些无用的学院理论，但是它说明了在同一个作用域中进行重复定义是 非常糟糕的，而且经常会导致各种奇怪的问题。
一个普通块内部的函数声明通常会被提升到所在作用域的顶部，这个过程不会像下面的代 码暗示的那样可以被条件判断所控制:
```
foo(); // "b"
var a = true; if (a) {
function foo() { console.log("a"); } }
else {
function foo() { console.log("b"); }
}
```
但是需要注意这个行为并不可靠，在 JavaScript 未来的版本中有可能发生改变，因此应该 尽可能避免在块内部声明函数。
## :smile:P50 
可以对这段代码进行一些改进:
```
for (var i=1; i<=5; i++) { 
(function(j) {
           setTimeout( function timer() { console.log( j );
             }, j*1000 );
         })( i );
}
```
当然，这些 IIFE 也不过就是函数，因此我们可以将 i 传递进去，如果愿意的话可以将变量
名定为 j，当然也可以还叫作 i。无论如何这段代码现在可以工作了。
在迭代内使用 IIFE 会为每个迭代都生成一个新的作用域，使得延迟函数的回调可以将新的
作用域封闭在每个迭代内部，每个迭代中都会含有一个具有正确值的变量供我们访问。
## :smile:P50
本质上这是将一个块转换成一个可以被关闭的作用域。因此，下面这些看起来很酷的代码 就可以正常运行了:
```
for (var i=1; i<=5; i++) {
let j = i; // 是的，闭包的块作用域! setTimeout( function timer() {
             console.log( j );
         }, j*1000 );
}
```
但是，这还不是全部!(我用 Bob Barker6 的声音说道)for 循环头部的 let 声明还会有一 个特殊的行为。这个行为指出变量在循环过程中不止被声明一次，每次迭代都会声明。随 后的每个迭代都会使用上一个迭代结束时的值来初始化这个变量。
```
for (let i=1; i<=5; i++) { setTimeout( function timer() {
             console.log( i );
         }, i*1000 );
}
```
很酷是吧?块作用域和闭包联手便可天下无敌。不知道你是什么情况，反正这个功能让我 成为了一名快乐的 JavaScript 程序员。
## :smile:P52 模块模式需要具备两个必要条件
1. 必须有外部的封闭函数，该函数必须至少被调用一次(每次调用都会创建一个新的模块 实例)。

2. 封闭函数必须返回至少一个内部函数，这样内部函数才能在私有作用域中形成闭包，并 且可以访问或者修改私有的状态。
## :smile:P59 
事实上 JavaScript 并不具有动态作用域。它只有词法作用域，简单明了。 但是 this 机制某种程度上很像动态作用域。

主要区别:词法作用域是在写代码或者说定义时确定的，而动态作用域是在运行时确定 的。(this 也是!)词法作用域关注函数在何处声明，而动态作用域关注函数从何处调用。

最后，this 关注函数如何调用，这就表明了 this 机制和动态作用域之间的关系多么紧密。
## :smile:P63 IIFE 和 try/catch 并不是完全等价的，因为如果将一段代码中的任意一部分拿出来 用函数进行包裹，会改变这段代码的含义，其中的 this、return、break 和 contine 都会 发生变化。IIFE 并不是一个普适的解决方案，它只适合在某些情况下进行手动操作。
## :smile:P65 简单来说，箭头函数在涉及 this 绑定时的行为和普通函数的行为完全不一致。它放弃了所 有普通 this 绑定的规则，取而代之的是用当前的词法作用域覆盖了 this 本来的值。
## :smile:P79 需要明确的是，this 在任何情况下都不指向函数的词法作用域。在 JavaScript 内部，作用 域确实和对象类似，可见的标识符都是它的属性。但是作用域“对象”无法通过 JavaScript 代码访问，它存在于 JavaScript 引擎内部。
思考一下下面的代码，它试图(但是没有成功)跨越边界，使用 this 来隐式引用函数的词 法作用域:
```
function foo() { 
var a=2;
this.bar();
}

function bar() { 
console.log( this.a );
}

foo(); // ReferenceError: a is not defined
```
这段代码中的错误不止一个。虽然这段代码看起来好像是我们故意写出来的例子，但是实 际上它出自一个公共社区中互助论坛的精华代码。这段代码非常完美(同时也令人伤感) 地展示了 this 多么容易误导人。

首先，这段代码试图通过 this.bar() 来引用 bar() 函数。这是绝对不可能成功的，我们之 后会解释原因。调用 bar() 最自然的方法是省略前面的 this，直接使用词法引用标识符。

此外，编写这段代码的开发者还试图使用 this 联通 foo() 和 bar() 的词法作用域，从而让 bar() 可以访问 foo() 作用域里的变量 a。这是不可能实现的，你不能使用 this 来引用一 个词法作用域内部的东西。

每当你想要把 this 和词法作用域的查找混合使用时，一定要提醒自己，这是无法实现的。
## :smile:P80 
this 是在运行时进行绑定的，并不是在编写时绑定，它的上下文取决于函数调 用时的各种条件。this 的绑定和函数声明的位置没有任何关系，只取决于函数的调用方式。

当一个函数被调用时，会创建一个活动记录(有时候也称为执行上下文)。这个记录会包 含函数在哪里被调用(调用栈)、函数的调用方法、传入的参数等信息。this 就是记录的 其中一个属性，会在函数执行的过程中用到。
## :smile:P81 最重要的是要分析调用栈(就是为了到达当前执行位置所调用的所有函数)。我们关心的 调用位置就在当前正在执行的函数的前一个调用中。
## :smile:P88 如果你传入了一个原始值(字符串类型、布尔类型或者数字类型)来当作 this 的绑定对 象，这个原始值会被转换成它的对象形式(也就是new String(..)、new Boolean(..)或者 new Number(..))。这通常被称为“装箱”。
## :smile:P95
那么，为什么要在 new 中使用硬绑定函数呢?直接使用普通函数不是更简单吗?

之所以要在 new 中使用硬绑定函数，主要目的是预先设置函数的一些参数，这样在使用 new 进行初始化时就可以只传入其余的参数。bind(..) 的功能之一就是可以把除了第一个 参数(第一个参数用于绑定 this)之外的其他参数都传给下层的函数(这种技术称为“部 分应用”，是“柯里化”的一种)。举例来说:
```
function foo(p1,p2) { this.val = p1 + p2;
}
// 之所以使用 null 是因为在本例中我们并不关心硬绑定的 this 是什么 // 反正使用 new 时 this 会被修改
var bar = foo.bind( null, "p1" );
var baz = new bar( "p2" );
baz.val; // p1p2
```
## :smile:P90 判断this 
现在我们可以根据优先级来判断函数在某个调用位置应用的是哪条规则。可以按照下面的顺序来进行判断:

1. 函数是否在new中调用(new绑定)?如果是的话this绑定的是新创建的对象。
     var bar = new foo()
     
2. 函数是否通过call、apply(显式绑定)或者硬绑定调用?如果是的话，this绑定的是 指定的对象。
     var bar = foo.call(obj2)
     
3. 函数是否在某个上下文对象中调用(隐式绑定)?如果是的话，this绑定的是那个上 下文对象。
     var bar = obj1.foo()
     
4. 如果都不是的话，使用默认绑定。如果在严格模式下，就绑定到undefined，否则绑定到 全局对象。
     var bar = foo()
## :smile:P97 在 JavaScript 中创建一个空对象最简单的方法都是 Object.create(null) (详细介绍请看第5章)。Object.create(null)和{}很像，但是并不会创建Object.prototype 这个委托，所以它比 {}“更空”
## :smile:P98 问题在于，硬绑定会大大降低函数的灵活性，使 用硬绑定之后就无法使用隐式绑定或者显式绑定来修改 this。
## :smile:P98
如果可以给默认绑定指定一个全局对象和 undefined 以外的值，那就可以实现和硬绑定相 同的效果，同时保留隐式绑定或者显式绑定修改 this 的能力。

可以通过一种被称为软绑定的方法来实现我们想要的效果:
```
if (!Function.prototype.softBind) { 
  Function.prototype.softBind = function(obj) {
  var fn = this;
  // 捕获所有 curried 参数
  var curried = [].slice.call( arguments, 1 ); 
  var bound = function() {
    return fn.apply(
      (!this || this === (window || global)) ? obj : this curried.concat.apply( curried, arguments )
      );
   };
   bound.prototype = Object.create( fn.prototype );
   return bound; 
   };
}
```
除了软绑定之外，softBind(..) 的其他原理和 ES5 内置的 bind(..) 类似。它会对指定的函 数进行封装，首先检查调用时的 this，如果 this 绑定到全局对象或者 undefined，那就把 指定的默认对象 obj 绑定到 this，否则不会修改 this。此外，这段代码还支持可选的柯里 化(详情请查看之前和 bind(..) 相关的介绍)。
## :smile:P99 箭头函数不使用 this 的四种标准规则，而是根据外层(函数或者全局)作用域来决 定 this。
## :smile:P100 箭头函数的绑定无法被修改。(new 也不 行!)
## :smile:P101
如果要判断一个运行中函数的 this 绑定，就需要找到这个函数的直接调用位置。找到之后
就可以顺序应用下面这四条规则来判断 this 的绑定对象。

1. 由new调用?绑定到新创建的对象。

2. 由call或者apply(或者bind)调用?绑定到指定的对象。

3. 由上下文对象调用?绑定到那个上下文对象。

4. 默认:在严格模式下绑定到undefined，否则绑定到全局对象。

一定要注意，有些调用可能在无意中使用默认绑定规则。如果想“更安全”地忽略 this 绑 定，你可以使用一个 DMZ 对象，比如 ø = Object.create(null)，以保护全局对象。

ES6 中的箭头函数并不会使用四条标准的绑定规则，而是根据当前的词法作用域来决定 this，具体来说，箭头函数会继承外层函数调用的 this 绑定(无论 this 绑定到什么)。这 其实和 ES6 之前代码中的 self = this 机制一样。
## :smile:P103 简单基本类型(string、boolean、number、null 和 undefined)本身并不是对象。 null 有时会被当作一种对象类型，但是这其实只是语言本身的一个 bug，即对 null 执行 typeof null 时会返回字符串 "object"。1 实际上，null 本身是基本类型。
## :smile:P103 实际上，JavaScript 中有许多特殊的对象子类型，我们可以称之为复杂基本类型。
函数就是对象的一个子类型(从技术角度来说就是“可调用的对象”)。JavaScript 中的函 数是“一等公民”，因为它们本质上和普通的对象一样(只是可以调用)，所以可以像操作 其他对象一样操作函数(比如当作另一个函数的参数)。
## :smile:P105 null 和 undefined 没有对应的构造形式，它们只有文字形式。相反，Date 只有构造，没有文字形式。
## :smile:P106 在对象中，属性名永远都是字符串。如果你使用 string(字面量)以外的其他值作为属性 名，那它首先会被转换为一个字符串。
## :smile:P109 注意:如果你试图向数组添加一个属性，但是属性名“看起来”像一个数字，那它会变成 一个数值下标(因此会修改数组的内容而不是添加一个属性)。
## :smile:P110 由于 Object.assign(..) 就是使用 = 操作符来赋值，所 以源对象属性的一些特性(比如 writable)不会被复制到目标对象。
## :smile:P113 要注意有一个小小的例外:即便属性是 configurable:false，我们还是可以 把 writable 的状态由 true 改为 false，但是无法由 false 改为 true。
## :smile:P113 configurable:false 还会禁止删除这个属性。
## :smile:P114 对象常量
结合 writable:false 和 configurable:false 就可以创建一个真正的常量属性(不可修改、 重定义或者删除)：
```
var myObject = {};
     Object.defineProperty( myObject, "FAVORITE_NUMBER", {
         value: 42,
writable: false,
configurable: false });
```
## :smile:P114 禁止扩展 
如果你想禁止一个对象添加新属性并且保留已有属性，可以使用Object.prevent Extensions(..):
```
var myObject = { a:2
     };
Object.preventExtensions( myObject );
myObject.b = 3;
myObject.b; // undefined
```
在非严格模式下，创建属性 b 会静默失败。在严格模式下，将会抛出 TypeError 错误。
## :smile:P114 密封
Object.seal(..) 会创建一个“密封”的对象，这个方法实际上会在一个现有对象上调用 Object.preventExtensions(..) 并把所有现有属性标记为 configurable:false。
所以，密封之后不仅不能添加新属性，也不能重新配置或者删除任何现有属性(虽然可以 修改属性的值)。
## :smile:P114 冻结
Object.freeze(..) 会创建一个冻结对象，这个方法实际上会在一个现有对象上调用 Object.seal(..) 并把所有“数据访问”属性标记为 writable:false，这样就无法修改它们 的值。
## :smile:P117 
如果已经存在这个属性，[[Put]] 算法大致会检查下面这些内容。
1. 属性是否是访问描述符(参见3.3.9节)?如果是并且存在setter就调用setter。
2. 属性的数据描述符中writable是否是false?如果是，在非严格模式下静默失败，在
严格模式下抛出 TypeError 异常。
3. 如果都不是，将该值设置为属性的值。
如果对象中不存在这个属性，[[Put]] 操作会更加复杂。我们会在第 5 章讨论 [[Prototype]] 时详细进行介绍。
## :smile:P119
所有的普通对象都可以通过对于Object.prototype的委托(参见第5章)来访问 hasOwnProperty(..)， 但 是 有 的 对 象 可 能 没 有 连 接 到 Object.prototype( 通 过 Object. create(null) 来创建——参见第 5 章)。在这种情况下，形如 myObejct.hasOwnProperty(..) 就会失败。

这时可以使用一种更加强硬的方法来进行判断:Object.prototype.hasOwnProperty. call(myObject,"a")，它借用基础的 hasOwnProperty(..) 方法并把它显式绑定(参见第 2 章)到 myObject 上。
## :smile:P119
看起来 in 操作符可以检查容器内是否有某个值，但是它实际上检查的是某 个属性名是否存在。对于数组来说这个区别非常重要，4 in [2, 4, 6]的结 果并不是你期待的True，因为[2, 4, 6]这个数组中包含的属性名是0、1、 2，没有 4。
## :smile:P120
在数组上应用 for..in 循环有时会产生出人意料的结果，因为这种枚举不 仅会包含所有数值索引，还会包含所有可枚举属性。最好只在对象上应用 for..in 循环，如果要遍历数组就使用传统的 for 循环来遍历数值索引。
## :smile:P132 在传统的面向类的语言中 super 还有一个功能，就是从子类的构造函数中通过 super 可以直接调用父类的构造函数。通常来说这没什么问题，因为对于真正 的类来说，构造函数是属于类的。然而，在 JavaScript 中恰好相反——实际 上“类”是属于构造函数的(类似 Foo.prototype... 这样的类型引用)。由于 JavaScript 中父类和子类的关系只存在于两者构造函数对应的 .prototype 对象 中，因此它们的构造函数之间并不存在直接联系，从而无法简单地实现两者的 相对引用(在 ES6 的类中可以通过 super 来“解决”这个问题，参见附录 A)。
## :smile:P134 在继承或者实例化时，JavaScript 的对象机制并不会自动执行复制行为。简单来说， JavaScript 中只有对象，并不存在可以被实例化的“类”。一个对象并不会被复制到其他对象，它们会被关联起来。
## :smile:P140 混入模式(无论显式还是隐式)可以用来模拟类的复制行为，但是通常会产生丑陋并且脆 弱的语法，比如显式伪多态(OtherObj.methodName.call(this, ...))，这会让代码更加难 懂并且难以维护。
## :smile:P142 JavaScript 中的对象有一个特殊的 [[Prototype]] 内置属性，其实就是对于其他对象的引用。几乎所有的对象在创建时 [[Prototype]] 属性都会被赋予一个非空的值。
## :smile:P144 如果属性名 foo 既出现在 myObject 中也出现在 myObject 的 [[Prototype]] 链上层，那 么就会发生屏蔽。myObject 中包含的 foo 属性会屏蔽原型链上层的所有 foo 属性，因为 myObject.foo 总是会选择原型链中最底层的 foo 属性。
## :smile:P145 如果 foo 不直接存在于 myObject 中而是存在于原型链上层时 myObject.foo = "bar" 会出现的三种情况。
1. 如果在[[Prototype]]链上层存在名为foo的普通数据访问属性(参见第3章)并且没 有被标记为只读(writable:false)，那就会直接在 myObject 中添加一个名为 foo 的新 属性，它是屏蔽属性。

2. 如果在[[Prototype]]链上层存在foo，但是它被标记为只读(writable:false)，那么 无法修改已有属性或者在 myObject 上创建屏蔽属性。如果运行在严格模式下，代码会 抛出一个错误。否则，这条赋值语句会被忽略。总之，不会发生屏蔽。

3. 如果在[[Prototype]]链上层存在foo并且它是一个setter(参见第3章)，那就一定会 调用这个 setter。foo 不会被添加到(或者说屏蔽于)myObject，也不会重新定义 foo 这 个 setter。

大多数开发者都认为如果向 [[Prototype]] 链上层已经存在的属性([[Put]])赋值，就一 定会触发屏蔽，但是如你所见，三种情况中只有一种(第一种)是这样的。

如果你希望在第二种和第三种情况下也屏蔽 foo，那就不能使用 = 操作符来赋值，而是使 用 Object.defineProperty(..)(参见第 3 章)来向 myObject 添加 foo。

第二种情况可能是最令人意外的，只读属性会阻止 [[Prototype]] 链下层 隐式创建(屏蔽)同名属性。这样做主要是为了模拟类属性的继承。你可 以把原型链上层的 foo 看作是父类中的属性，它会被 myObject 继承(复 制)，这样一来 myObject 中的 foo 属性也是只读，所以无法创建。但是一定 要注意，实际上并不会发生类似的继承复制(参见第 4 章和第 5 章)。这看 起来有点奇怪，myObject 对象竟然会因为其他对象中有一个只读 foo 就不 能包含 foo 属性。更奇怪的是，这个限制只存在于 = 赋值中，使用 Object. defineProperty(..) 并不会受到影响。
## :smile:P146 所有的函数默认都会拥有一个 名为 prototype 的公有并且不可枚举(参见第 3 章)的属性，它会指向另一个对象。
## :smile:P150 在 JavaScript 中对于“构造函数”最准确的解释是，所有带 new 的函数调用。 函数不是构造函数，但是当且仅当使用 new 时，函数调用会变成“构造函数调用”。
## :smile:P149-151 Foo.prototype 默认(在代码中第一行声明时!)有一个公有并且不可枚举(参见第 3 章) 的属性 .constructor，这个属性引用的是对象关联的函数(本例中是 Foo)。a.constructor 只是通过默认的 [[Prototype]] 委托指向 Foo。
## :smile:P155 我们来对比一下两种把 Bar.prototype 关联到 Foo.prototype 的方法: 
```
// ES6 之前需要抛弃默认的 Bar.prototype
     Bar.ptototype = Object.create( Foo.prototype );
// ES6 开始可以直接修改现有的 
     Bar.prototype Object.setPrototypeOf( Bar.prototype, Foo.prototype );
```
如果忽略掉 Object.create(..) 方法带来的轻微性能损失(抛弃的对象需要进行垃圾回 收)，它实际上比 ES6 及其之后的方法更短而且可读性更高。不过无论如何，这是两种完 全不同的语法。
## :smile:P156
var a = new Foo();

我们如何通过内省找出 a 的“祖先”(委托关联)呢?第一种方法是站在“类”的角度来 判断:

a instanceof Foo; // true

instanceof 操作符的左操作数是一个普通的对象，右操作数是一个函数。instanceof 回答的问题是:在 a 的整条 [[Prototype]] 链中是否有指向 Foo.prototype 的对象?

可惜，这个方法只能处理对象(a)和函数(带 .prototype 引用的 Foo)之间的关系。如 果你想判断两个对象(比如 a 和 b)之间是否通过 [[Prototype]] 链关联，只用 instanceof 无法实现。
## :smile:P157 __proto__ 实际上并不存在于你正在使用的对象中 (本例中是 a)。实际上，它和其他的常用函数(.toString()、.isPrototypeOf(..)，等等)一样，存在于内置的 Object.prototype 中。(它们是不可枚举的，参见第 2 章。)
此外，.__proto__ 看起来很像一个属性，但是实际上它更像一个 getter/setter(参见第 3章)。

.__proto__的实现大致上是这样的(对象属性的定义参见第3章):
```
Object.defineProperty( Object.prototype, "__proto__", { get: function() {
return Object.getPrototypeOf( this ); },
set: function(o) {
// ES6 中的 setPrototypeOf(..) Object.setPrototypeOf( this, o ); return o;
} });
```
## :smile:P167
在上面的代码中，id和label数据成员都是直接存储在XYZ上(而不是Task)。通常 来说，在 [[Prototype]] 委托中最好把状态保存在委托者(XYZ、ABC)而不是委托目标(Task)上。

this.setID(ID);XYZ中的方法首先会寻找XYZ自身是否有setID(..)，但是XYZ中并没 有这个方法名，因此会通过 [[Prototype]] 委托关联到 Task 继续寻找，这时就可以找到 setID(..) 方法。此外，由于调用位置触发了 this 的隐式绑定规则(参见第 2 章)，因 此虽然 setID(..) 方法在 Task 中，运行时 this 仍然会绑定到 XYZ，这正是我们想要的。 在之后的代码中我们还会看到 this.outputID()，原理相同。
## :smile:P167 在 API 接口的设计中，委托最好在内部实现，不要直接暴露出去。在之前的 例子中我们并没有让开发者通过 API 直接调用 XYZ.setID()。(当然，可以这 么做!)相反，我们把委托隐藏在了 API 的内部，XYZ.prepareTask(..) 会 委托 Task.setID(..)。
## :smile:P168 互相委托(禁止) 
你无法在两个或两个以上互相(双向)委托的对象之间创建循环委托。如果你把 B 关联到 A 然后试着把 A 关联到 B，就会出错。

很遗憾(并不是非常出乎意料，但是有点烦人)这种方法是被禁止的。如果你引用了一个 两边都不存在的属性或者方法，那就会在 [[Prototype]] 链上产生一个无限递归的循环。 但是如果所有的引用都被严格限制的话，B 是可以委托 A 的，反之亦然。因此，互相委托 理论上是可以正常工作的，在某些情况下这是非常有用的。

之所以要禁止互相委托，是因为引擎的开发者们发现在设置时检查(并禁止!)一次无限 循环引用要更加高效，否则每次从对象中查找属性时都需要进行检查。
## :smile:P170
现在你已经明白了“类”和“委托”这两种设计模式的理论区别，接下来我们看看它们在思维模型方面的区别。

我们会通过一些示例(Foo、Bar)代码来比较一下两种设计模式(面向对象和对象关联) 具体的实现方法。下面是典型的(“原型”)面向对象风格:
```
function Foo(who) {
this.me = who;
}
Foo.prototype.identify = function () {
    return "I am " + this.me;
};
function Bar(who) {
    Foo.call(this, who);
}
Bar.prototype = Object.create(Foo.prototype);
Bar.prototype.speak = function () {
    alert("Hello, " + this.identify() + ".");
};
var b1 = new Bar("b1");
var b2 = new Bar("b2"); b1.speak();
b2.speak();
```
子类 Bar 继承了父类 Foo，然后生成了 b1 和 b2 两个实例。b1 委托了 Bar.prototype，后者委托了 Foo.prototype。这种风格很常见，你应该很熟悉了。

下面我们看看如何使用对象关联风格来编写功能完全相同的代码:
```
Foo = {
    init: function (who) {
        this.me = who;
    },
    identify: function () {
        return "I am " + this.me;
    }
};
Bar = Object.create(Foo);
Bar.speak = function () {
    alert("Hello, " + this.identify() + ".");
};
var b1 = Object.create(Bar);
b1.init("b1");
var b2 = Object.create(Bar);
b2.init("b2");
b1.speak();
b2.speak();
```
这段代码中我们同样利用 [[Prototype]] 把 b1 委托给 Bar 并把 Bar 委托给 Foo，和上一段 代码一模一样。我们仍然实现了三个对象之间的关联。
## :smile:P190 class字面语法不能声明属性(只能声明方法)。看起来这是一种限制，但是它会排除掉许多不好的情况，如果没有这种限制的话，原型链末端的“实例”可能会意外地获取 其他地方的属性(这些属性隐式被所有“实例”所“共享”)。所以，class 语法实际上 可以帮助你避免犯错。
## :smile:P190 class 基本上只是现有 [[Prototype]](委托!)机制的一种语法糖。也就是说，class 并不会像传统面向类的语言一样在声明时静态复制所有行为。如果你 (有意或无意)修改或者替换了父“类”中的一个方法，那子“类”和所有实例都会受到影响，因为它们在定义时并没有进行复制，只是使用基于 [[Prototype]] 的实时委托:
```
class C {
    constructor() {
        this.num = Math.random();
    }
    rand() {
        console.log("Random: " + this.num);
    }
}
var c1 = new C();
c1.rand(); // "Random: 0.4324299..."
C.prototype.rand = function () {
    console.log("Random: " + Math.round(this.num * 1000));
};
var c2 = new C(); c2.rand(); // "Random: 867"
c1.rand(); // "Random: 432" ——噢!
```
## :smile:P191 class 语法无法定义类成员属性(只能定义方法)
## :smile:P193 出于性能考虑，super并不像this一样是晚绑定(late bound，或者说 动态绑定)的，它在 [[HomeObject]].[[Prototype]] 上，[[HomeObject]] 会在创建时静态 绑定。
## :smile:P
## :smile:P
## :smile:P
## :smile:P
## :smile:P
## :smile:P
## :smile:P
## :smile:P
## :smile:P
## :smile:P
## :smile:P
## :smile:P
## :smile:P
## :smile:P
## :smile:P
## :smile:P
## :smile:P
## :smile:P
## :smile:P
## :smile:P
## :smile:P
## :smile:P
## :smile:P
## :smile:P
## :smile:P
## :smile:P
## :smile:P
## :smile:P
## :smile:P
## :smile:P


