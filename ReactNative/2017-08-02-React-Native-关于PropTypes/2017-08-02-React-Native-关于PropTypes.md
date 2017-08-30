## 关于组件属性(props)
它是组件的不可变属性（组件自己不可以自己修改props）。

组件自身定义了一组props作为对外提供的接口，展示一个组件时只需要指定props作为节点的属性。

一般组件很少需要对外公开方法（例外：工具类的静态方法等），唯一的交互途径就是props。所以说它也是父组件与子组件通信的桥梁。
组件自己不可以自己修改props（即：props可认为是只读的），只可由其他组件调用它时在外部修改。

### props的创建阶段
在创建组件类的时候，在这个阶段中会初始化组件的props属性类型和默认属性。

这里会初始化一些默认的属性，通常会将固定的内容放在这个过程中进行初始化和赋值，一个控件可以利用this.props获取在这里初始化它的属性，由于组件初始化后，再次使用该组件不会调用getDefaultProps函数，所以组件自己不可以自己修改props（即：props可认为是只读的），只可由其他组件调用它时在外部修改。

1）执行propTypes确定props的类型

2）执行defaultProps初始化props的默认值

```javascript
//es6
import React, { PropTypes } from 'react'
// import PropTypes from 'prop-types'; //或者这样引用PropTypes

export default class owen extends Component {
  static propTypes = {
    animateEnd: PropTypes.func,
    age: PropTypes.number
  }

  static defaultProps = {
    animateEnd: function () { },
    age: 10
  }
}
...
```


## React.PropTypes
### React.PropTypes提供很多验证器 (validator) 来验证传入props数据的有效性。当向 props 传入无效数据时，JavaScript 控制台会抛出警告.

### 源码：
**从：**

import {PropTypes} from 'react'

**到：**

projectName/node_modules/react/index.js
```javascript
if (process.env.NODE_ENV === 'production') {
  module.exports = require('./cjs/react.production.min.js');
} else {
  module.exports = require('./cjs/react.development.js');
}
```
**到：** 

projectName/node_modules/react/cjs/react.development.js 
```javascript
var propTypes = require('prop-types');
...
var ReactPropTypes = propTypes;
...
Object.defineProperty(React, 'PropTypes', {
      get: function () {
        warning$1(warnedForPropTypes, 'PropTypes has been moved to a separate package. ' + 'Accessing React.PropTypes is no longer supported ' + 'and will be removed completely in React 16. ' + 'Use the prop-types package on npm instead. ' + '(https://fb.me/migrating-from-react-proptypes)');
        warnedForPropTypes = true;
        return ReactPropTypes;
      }
    });
```
**到：**

projectName/node_modules/prop-types/index.js
```javascript
if (process.env.NODE_ENV !== 'production') {
 ...
  module.exports = require('./factoryWithTypeCheckers')(isValidElement, throwOnDirectAccess);
} else {
  module.exports = require('./factoryWithThrowingShims')();
}
```

**到目的：**

projectName/node_modules/prop-types/factoryWithTypeCheckers.js
```javascript
...
  var ReactPropTypes = {
    array: createPrimitiveTypeChecker('array'),
    bool: createPrimitiveTypeChecker('boolean'),
    func: createPrimitiveTypeChecker('function'),
    number: createPrimitiveTypeChecker('number'),
    object: createPrimitiveTypeChecker('object'),
    string: createPrimitiveTypeChecker('string'),
    symbol: createPrimitiveTypeChecker('symbol'),

    any: createAnyTypeChecker(),//任意不为空对象
    arrayOf: createArrayOfTypeChecker,//指定数组中项的类型，e.g. React.PropTypes.arrayOf(React.PropTypes.string) 
    element: createElementTypeChecker(),//React 元素 
    instanceOf: createInstanceTypeChecker,//指定类的实例，e.g. React.PropTypes.instanceOf(XXX)
    node: createNodeChecker(),//每一个值的类型都是基本类型,e.g. numbers,strings,elements 
    objectOf: createObjectOfTypeChecker,//指定类型组成的对象，e.g. React.PropTypes.objectOf(React.PropTypes.string)
    oneOf: createEnumTypeChecker,//参数是数组, 指定传的数据为数组中的值，e.g. React.PropTypes.oneOf(['foo', 'bar'])
    oneOfType: createUnionTypeChecker,//参数是数组, 指定传的数据为数组中的类型，e.g. React.PropTypes.oneOfType([React.PropTypes.string, React.PropTypes.array]) 
    shape: createShapeTypeChecker
    /*指定对象类型内部的结构定义，e.g. 
    React.PropTypes.shape({                       
          color: React.PropTypes.string,
          fontSize: React.PropTypes.number
         });
    */
  };
...
```

在指定类型后使用isRequired可声明 prop 是必传的 ，e.g. React.PropTypes.element.isRequired


## React Native 自定义组件报错 has no propType for native prop
解决办法就是在定义js组件属性时，加上:
```javascript
// rn0.44
import { ViewPropTypes } from "react-native";
propTypes: {
    ...ViewPropTypes,
}

// < rn0.44
var View = React.View;
/* later... */
propTypes: {
    ...View.propTypes,
    myProp: PropTypes.string
}
```



PS:
1、
> 相关源码来自RN0.46.0 [factoryWithTypeCheckers.js](factoryWithTypeCheckers.js) [factoryWithThrowingShims.js](factoryWithThrowingShims.js)
2、
> In 15.5, instead of accessing PropTypes from the main React object, install the prop-types package and import them from there:
```
// Before (15.4 and below)
import React from 'react';

class Component extends React.Component {
  render() {
    return <div>{this.props.text}</div>;
  }
}

Component.propTypes = {
  text: React.PropTypes.string.isRequired,
}

// After (15.5)
import React from 'react';
import PropTypes from 'prop-types';
```
> 从React15.5还使用React.PropTypes会有警告：
```
Warning: PropTypes has been moved to a separate package. Accessing React.PropTypes is no longer supported and will be removed completely in React 16. Use the prop-types package on npm instead. (https://fb.me/migrating-from-react-proptypes)
```

