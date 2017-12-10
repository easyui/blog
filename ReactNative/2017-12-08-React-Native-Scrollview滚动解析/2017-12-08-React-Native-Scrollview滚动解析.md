# React-Native-Scrollview滚动解析

一个包装了平台的ScrollView（滚动视图）的组件，同时还集成了触摸锁定的“响应者”系统。

记住ScrollView必须有一个确定的高度才能正常工作，因为它实际上所做的就是将一系列不确定高度的子组件装进一个确定高度的容器（通过滚动操作）。要给一个ScrollView确定一个高度的话，要么直接给它设置高度（不建议），要么确定所有的父容器都有确定的高度。一般来说我们会给ScrollView设置flex: 1以使其自动填充父容器的空余空间，但前提条件是所有的父容器本身也设置了flex或者指定了高度，否则就会导致无法正常滚动，你可以使用元素查看器来查找问题的原因。

ScrollView内部的其他响应者尚无法阻止ScrollView本身成为响应者。

## 滚动过程中触发的事件

### Scrollview

`onScrollBeginDrag：一个子view滑动开始拖动开始时触发，注意和onMomentumScrollBegin的区别`


`onScrollEndDrag：一个子view滚动结束拖拽时触发，注意和onMomentumScrollEnd的区别`


`onMomentumScrollStart： 滚动动画开始时调用此函数`


`onMomentumScrollEnd：滚动动画结束时调用此函数`


`onScroll：在滚动的过程中，每帧最多调用一次此回调函数。调用的频率可以用scrollEventThrottle属性来控制`

### View
```
onTouchStart：按下屏幕时触发
```

```
onTouchMove：移动手指时触发
```

```
onTouchEnd：手指离开屏幕触摸结束时触发
```

```
onStartShouldSetResponder function 

设置这个视图是否要响应 touch start 事件。

View.props.onStartShouldSetResponder: (event) => [true | false], 其中 event 是一个合成触摸事件

onStartShouldSetResponderCapture function 
```

```
如果父视图想要阻止子视图响应 touch start 事件，它就应该设置这个方法并返回 true。

View.props.onStartShouldSetResponderCapture: (event) => [true | false], 其中 event 是一个合成触摸事件。
```

```
onMoveShouldSetResponder function 

这个视图想要“认领”这个 touch move 事件吗？每当有touch move事件在这个视图中发生，并且这个视图没有被设置为这个 touch move 的响应时，这个函数就会被调用。

View.props.onMoveShouldSetResponder: (event) => [true | false], 其中 event 是一个合成触摸事件。
```

```
onMoveShouldSetResponderCapture function 

如果父视图想要阻止子视图响应 touch move 事件时，它就应该设置这个方法并返回 true

View.props.onMoveShouldSetResponderCapture: (event) => [true | false], 其中 event 是一个合成触摸事件。
```

```
onResponderGrant function 

对于大部分的触摸处理，你只需要用TouchableHighlight或TouchableOpacity包装你的组件。阅读Touchable.js、ScrollResponder.js和ResponderEventPlugin.js来了解更多信息。
```

```
onResponderMove function 

当用户正在屏幕上移动手指时调用这个函数。

View.props.onResponderMove: (event) => {}, 其中 event 是一个合成触摸事件。
```

```
onResponderReject function 

有一个响应器正处于活跃状态，并且不会向另一个要求响应这个事件的视图释放这个事件。

View.props.onResponderReject: (event) => {}, 其中 event 是一个合成触摸事件。
```

```
onResponderRelease function 

在整个触摸事件结束时调用这个函数。

View.props.onResponderRelease: (event) => {}, 其中 event 是一个合成触摸事件。
```

```
onResponderTerminate function 

响应被从这个视图上“劫走”了。可能是在调用了onResponderTerminationRequest之后，被另一个视图“劫走”了（见onresponderterminationrequest), 也可能是由于 OS 无条件终止了响应（比如说被 iOS 上的控制中心／消息中心）

View.props.onResponderTerminate: (event) => {}, 其中 event 是一个合成触摸事件。
```

```
onResponderTerminationRequest function 

其他某个视图想要成为事件的响应者，并要求这个视图放弃对事件的响应时，就会调用这个函数。如果允许释放响应，就返回true
```

```
View.props.onResponderTerminationRequest: (event) => {}, 其中 event 是一个合成触摸事件。
```

## Demo 代码

```js
export default class App extends Component<{}> {

  _renderItems = () => {
    let arr = []
    for (let i = 0; i < 100; i++) {
      // arr.push(<View style={{ height: 80 ,backgroundColor: i%2 ? 'red' : 'yellow'}} key={i}><Text>{i}</Text></View>)
      arr.push(<View style={{ width: width ,backgroundColor: i%2 ? 'red' : 'yellow'}} key={i}><Text>{i}</Text></View>)
      
    }
    return arr
  }


onScroll = (e) => {
  this.print('onScroll')
}

render() {
  return (
    <ScrollView

      ref={'scroll'}

      onScroll={this.onScroll}

      onTouchStart={() => this.print('onTouchStart')}

      onTouchMove={() => this.print('onTouchMove')}

      onTouchEnd={() => this.print('onTouchEnd')}

      onScrollBeginDrag={() => this.print('onScrollBeginDrag')}

      onScrollEndDrag={() => this.print('onScrollEndDrag')}

      onMomentumScrollBegin={() => this.print('onMomentumScrollBegin')}

      onMomentumScrollEnd={() => this.print('onMomentumScrollEnd')}

      onStartShouldSetResponder={() => this.print('onStartShouldSetResponder')}

      onStartShouldSetResponderCapture={() => this.print('onStartShouldSetResponderCapture')}

      onMoveShouldSetResponder={() => this.print('onMoveShouldSetResponder')}
      
      onMoveShouldSetResponderCapture={() => this.print('onMoveShouldSetResponderCapture')}

      onScrollShouldSetResponder={() => this.print('onScrollShouldSetResponder')}

      onResponderGrant={() => this.print('onResponderGrant')}

      onResponderMove={() => this.print('onResponderMove')}
      
      onResponderTerminationRequest={() => this.print('onResponderTerminationRequest')}

      onResponderTerminate={() => this.print('onResponderTerminate')}

      onResponderRelease={() => this.print('onResponderRelease')}

      onResponderReject={() => this.print('onResponderReject')}

      scrollEventThrottle={16}

      horizontal={true}
      pagingEnabled={true}
    >
      {
        this._renderItems()
      }
    </ScrollView>
  )
}

print(log){
  console.log('cactus------ '  + log)
}

}
```

## 运行结果：

### iOS&android点击

| log | description |                    
| --- | --- | 
| onTouchStart |  |
| onTouchEnd |  |

### iOS划动一次

| log | description |                    
| --- | --- | 
| onTouchStart | 手指触碰 |
| onMoveShouldSetResponderCapture<br>onMoveShouldSetResponder<br>onTouchMove | 有，且`重复多次` |
| onScrollBeginDrag |  |
| onMoveShouldSetResponderCapture<br>onMoveShouldSetResponder<br>onTouchMove | 可能有，且`重复多次`。一般不会出现 |
| onResponderGrant |  |
| onScroll |  |
| onResponderMove<br>onTouchMove<br>onScroll | 可能有，且`重复多次`。这里是手指一直划动，这三个方法就一直重复执行，直到手指停止划动。如果没有划动也可能不出现 ，比如点划|
| onResponderRelease<br>onTouchEnd<br>onScrollEndDrag  | 手指离开时执行 |
| onMomentumScrollBegin | 手指离开后有划动就会执行，否则不执行。pagingEnabled={true}时必有 |
| onScroll |  手指离开后有划动就会执行，否则不执行，且`重复多次`。pagingEnabled={true}时必有 |
| onMomentumScrollEnd | 手指离开后有划动就会执行，否则不执行。pagingEnabled={true}时必有 |


### android划动一次

| log | description |                    
| --- | --- | 
| onTouchStart | 手指触碰 |
| onMoveShouldSetResponderCapture<br>onMoveShouldSetResponder<br>onTouchMove | 有，且`重复多次` |
| onScrollBeginDrag |  |
| onScroll | 可能有，且`重复多次`。这里是手指一直划动，这个方法就一直重复执行，直到手指停止划动。如果没有划动也可能不出现 ，比如点划 |
| onScrollEndDrag  | 手指离开时执行 |
| onMomentumScrollBegin | 手指离开后执行 |
| onScroll |  手指离开后有划动就会执行，否则不执行，且`重复多次` |
| onMomentumScrollEnd | 手指离开后执行 |


> onScrollEndDrag 一定会被调用，onMomentumScrollEnd 在iOS上如果手指拖动很慢，没有动画滚动就不会调用


## 判单滚动到底部

```js
< ScrollView
            style={{flex:1}}
            onRefresh = {this._onRefreshData}
            onScroll = {this._contentViewScroll}
            refreshing={this.state.refreshing}
            automaticallyAdjustContentInsets={false}
            showsVerticalScrollIndicator={false}
            scrollsToTop={true}>
            {<View/>}
</ScrollView >

_contentViewScroll(e: Object){
        var offsetY = e.nativeEvent.contentOffset.y; //滑动距离
        var contentSizeHeight = e.nativeEvent.contentSize.height; //scrollView contentSize高度
        var oriageScrollHeight = e.nativeEvent.layoutMeasurement.height; //scrollView高度
        if (offsetY + oriageScrollHeight >= contentSizeHeight){
            Console.log('上传滑动到底部事件')
        }
},
```


