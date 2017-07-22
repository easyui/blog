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
```

```javascript
Function.prototype.method = function (name, func) {
    this.prototype[name] = func;
    return this;
};
```

## :smile:布尔值为false
- false
- null
- undefined
- 空字符串''
- 数字 0
- 数字 NaN
