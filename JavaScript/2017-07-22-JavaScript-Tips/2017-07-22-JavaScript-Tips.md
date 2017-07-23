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