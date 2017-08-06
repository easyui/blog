

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
