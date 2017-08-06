

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
## :smile:P
## :smile:P 
## :smile:P
## :smile:P 
## :smile:P
## :smile:P 
## :smile:P
## :smile:P 
## :smile:P
