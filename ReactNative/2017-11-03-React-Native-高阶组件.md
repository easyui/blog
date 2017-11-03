# React 高阶组件(HOC)


## 背景
高阶组件的这种写法的诞生来自于社区的实践，目的是解决一些交叉问题(Cross-Cutting Concerns)。而最早时候 React 官方给出的解决方案是使用 mixin 。

### 高阶函数的定义
说到高阶组件，就不得不先简单的介绍一下高阶函数。下面展示一个最简单的高阶函数
```
const add = (x,y,f) => f(x)+f(y)
```
当我们调用add(-5, 6, Math.abs)时，参数 x，y 和f 分别接收 -5，6 和 Math.abs，根据函数定义，我们可以推导计算过程为：
```
x ==> -5
y ==> 6
f ==> abs
f(x) + f(y) ==> Math.abs(-5) + Math.abs(6) ==> 11
```

## 高阶组件(HOC)

### 定义
那么，什么是高阶组件呢？类比高阶函数的定义，高阶组件就是接受一个组件作为参数并返回一个新组件的函数。这里需要注意高阶组件是一个函数，并不是组件，这一点一定要注意。

同时这里强调一点高阶组件本身并不是 React API。它只是一种模式，这种模式是由 React 自身的组合性质必然产生的。更加通俗的讲，高阶组件通过包裹（wrapped）被传入的React组件，经过一系列处理，最终返回一个相对增强（enhanced）的 React 组件，供其他组件调用。一个高阶组件只是一个包装了另外一个 React 组件的 React 组件。

本质上是一个类工厂（class factory），它下方的函数标签伪代码启发自 Haskell

```
hocFactory:: W: React.Component => E: React.Component
//这里 W（WrappedComponent） 指被包装的 React.Component，E（Enhanced Component） 指返回的新的高阶 React 组件。
```

定义中的『包装』一词故意被定义的比较模糊，因为它可以指两件事情：

- 属性代理（Props Proxy）：高阶组件操控传递给 WrappedComponent 的 props，
- 反向继承（Inheritance Inversion）：高阶组件继承（extends）WrappedComponent。

### 实现
在这节中我们将学习两种主流的在 React 中实现高阶组件的方法：属性代理（Props Proxy）和 反向继承（Inheritance Inversion）。两种方法囊括了几种包装 WrappedComponent 的方法。

####Props Proxy （PP）

属性代理的实现方法如下：

```
function ppHOC(WrappedComponent) {
  return class PP extends React.Component {
    render() {
      return <WrappedComponent {...this.props}/>
    }
  }
}
```

可以看到，这里高阶组件的 render 方法返回了一个 type 为 WrappedComponent 的 React Element（也就是被包装的那个组件），我们把高阶组件收到的 props 传递给它，因此得名 Props Proxy。

####反向继承（II）可以像这样简单地实现：

```
function iiHOC(WrappedComponent) {
  return class Enhancer extends WrappedComponent {
    render() {
      return super.render()
    }
  }
}
```

如你所见，返回的高阶组件类（Enhancer）继承了 WrappedComponent。这被叫做反向继承是因为 WrappedComponent 被动地被 Enhancer 继承，而不是 WrappedComponent 去继承 Enhancer。通过这种方式他们之间的关系倒转了。

反向继承允许高阶组件通过 this 关键词获取 WrappedComponent，意味着它可以获取到 state，props，组件生命周期（component lifecycle）钩子，以及渲染方法（render）。

>注意： 你无法更改或创建 props 给 WrappedComponent 实例，因为 React 不允许变更一个组件收到的 props，但是你可以在 render 方法里更改子元素/子组件们的 props。

### 使用
在React开发过程中，发现有很多情况下，组件需要被"增强"，比如说给组件添加或者修改一些特定的props，一些权限的管理，或者一些其他的优化之类的。而如果这个功能是针对多个组件的，同时每一个组件都写一套相同的代码，明显显得不是很明智，所以就可以考虑使用HOC。

### 作用

#### 代码复用，代码模块化，逻辑抽象，抽离底层准备（bootstrap）代码
#### State 抽象和更改
你可以通过向 WrappedComponent 传递 props 和 callbacks（回调函数）来抽象 state，这和 React 中另外一个组件构成思想 Presentational and Container Components 很相似。

例子：在下面这个抽象 state 的例子中，我们幼稚地（原话是naively :D）抽象出了 name input 的 value 和 onChange。我说这是幼稚的是因为这样写并不常见，但是你会理解到点。

```
function ppHOC(WrappedComponent) {
  return class PP extends React.Component {
    constructor(props) {
      super(props)
      this.state = {
        name: ''
      }
      this.onNameChange = this.onNameChange.bind(this)
    }
    onNameChange(event) {
      this.setState({
        name: event.target.value
      })
    }
    render() {
      const newProps = {
        name: {
          value: this.state.name,
          onChange: this.onNameChange
        }
      }
      return <WrappedComponent {...this.props} {...newProps}/>
    }
  }
}
```

然后这样使用它：

```
@ppHOC
class Example extends React.Component {
  render() {
    return <input name="name" {...this.props.name}/>
  }
}
```

这里的 input 自动成为一个[受控的 input](https://facebook.github.io/react/docs/forms.html)。

#### 增删改读props
在修改或删除重要 props 的时候要小心，你可能应该给高阶组件的 props 指定命名空间（namespace），以防破坏从外传递给 WrappedComponent 的 props。

比如你想要给wrappedComponent增加一个props，可以这么搞：

```
function control(wrappedComponent) {
  return class Control extends React.Component {
    render(){
      let props = {
        ...this.props,
        message: "You are under control"
      };
      return <wrappedComponent {...props} />
    }
  }
}
```

这样，你就可以在你的组件中使用message这个props:

```
class MyComponent extends React.Component {
  render(){
    return <div>{this.props.message}</div>
  }
}

export default control(MyComponent);
```

#### 渲染劫持
这里的渲染劫持并不是你能控制它渲染的细节，而是控制是否去渲染。由于细节属于组件内部的render方法控制，所以你无法控制渲染细节。

比如，组件要在data没有加载完的时候，现实loading...，就可以这么写：

```
function loading(wrappedComponent) {
  return class Loading extends React.Component {
    render(){
      if(this.props.data) {
        return <div>loading...</div>
      }
      return <wrappedComponent {...props} />
    }
  }
}
```

这个样子，在父级没有传入data的时候，这一块儿就只会显示loading...,不会显示组件的具体内容

```
class MyComponent extends React.Component {
  render(){
    return <div>{this.props.data}</div>
  }
}

export default control(MyComponent);
```

### 注意

####尽量不要随意修改下级组件需要的props
之所以这么说，是因为修改父级传给下级的props是有一定风险的，可能会造成下级组件发生错误。比如，原本需要一个name的props，但是在HOC中给删掉了，那么下级组件或许就无法正常渲染，甚至报错。

####Component上面绑定的Static方法会丢失
比如，你原来在Component上面绑定了一些static方法MyComponent.staticMethod = o=>o。但是由于经过HOC的包裹，父级组件拿到的已经不是原来的组件了，所以当然无法获取到staticMethod方法了。

官网上的示例：

```
// 定义一个static方法
WrappedComponent.staticMethod = function() {/*...*/}
// 利用HOC包裹
const EnhancedComponent = enhance(WrappedComponent);

// 返回的方法无法获取到staticMethod
typeof EnhancedComponent.staticMethod === 'undefined' // true
这里有一个解决方法，就是hoist-non-react-statics组件，这个组件会自动把所有绑定在对象上的非React方法都绑定到新的对象上：

import hoistNonReactStatic from 'hoist-non-react-statics';
function enhance(WrappedComponent) {
  class Enhance extends React.Component {/*...*/}
  hoistNonReactStatic(Enhance, WrappedComponent);
  return Enhance;
}
```

#### Ref无法获取你想要的ref
以前你在父组件中使用<component ref="component"/>的时候，你可以直接通过this.refs.component进行获取。但是因为这里的component经过HOC的封装，Props Proxy 作为一层代理，会发生隔离，因此传入 WrappedComponent 的 ref 将无法访问到其本身，需在 Props Proxy 内完成中转，具体可参考以下代码，react-redux 也是这样实现的。

此外各个 Props Proxy 的默认名称是相同的，需要根据 WrappedComponent 来进行不同命名。

```
function ppHOC(WrappedComponent) {
  return class PP extends React.Component {
    // 实现 HOC 不同的命名
    static displayName = `HOC(${WrappedComponent.displayName})`;

    getWrappedInstance() {
      return this.wrappedInstance;
    }

    // 实现 ref 的访问
    setWrappedInstance(ref) {
      this.wrappedInstance = ref;
    }

    render() {
      return <WrappedComponent {
        ...this.props,
        ref: this.setWrappedInstance.bind(this),
      } />
    }
  }
}

@ppHOC
class Example extends React.Component {
  static displayName = 'Example';
  handleClick() { ... }
  ...
}

class App extends React.Component {
  handleClick() {
    this.refs.example.getWrappedInstance().handleClick();
  }
  render() {
    return (
      <div>
        <button onClick={this.handleClick.bind(this)}>按钮</button>
        <Example ref="example" />
      </div>  
    );
  }
}
```

参考：
> [React 高阶组件浅析](https://segmentfault.com/a/1190000010845410)
> [React高阶组件(HOC)模型理论与实践](https://segmentfault.com/a/1190000008112017?_ea=1553893)
> [深入理解 React 高阶组件](http://www.jianshu.com/p/0aae7d4d9bc1)
> [精读 React 高阶组件](https://zhuanlan.zhihu.com/p/27434557)
> [React Native创建高阶组件（修饰器）](http://www.jianshu.com/p/dc0b40745cd7)
> rn参考代码： [withOrientation.js](https://github.com/react-community/react-navigation/blob/master/src/views/withOrientation.js)


