

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

## :smile:P59 
事实上 JavaScript 并不具有动态作用域。它只有词法作用域，简单明了。 但是 this 机制某种程度上很像动态作用域。

主要区别:词法作用域是在写代码或者说定义时确定的，而动态作用域是在运行时确定 的。(this 也是!)词法作用域关注函数在何处声明，而动态作用域关注函数从何处调用。

最后，this 关注函数如何调用，这就表明了 this 机制和动态作用域之间的关系多么紧密。
## :smile:P63 IIFE 和 try/catch 并不是完全等价的，因为如果将一段代码中的任意一部分拿出来 用函数进行包裹，会改变这段代码的含义，其中的 this、return、break 和 contine 都会 发生变化。IIFE 并不是一个普适的解决方案，它只适合在某些情况下进行手动操作。
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
for (var i=1; i<=5; i++) { (function(j) {
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
