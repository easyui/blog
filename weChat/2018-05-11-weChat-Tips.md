# React Native Tips


## :smile:React Native项目启动顺序

### iOS中React Native项目启动顺序：
- 在启动React Native Xcode项目时，会先加载项目所依赖的React项目，接着运行React项目中事先定义好的run script phase，最后运行packger.sh。
- 其中packger.sh中我们看到如下的代码：
```
node "$THIS_DIR/../local-cli/cli.js" start "$@"
```
- 接着我们找到了cli.js，看到里面调用了好多模块。其中default.config.js模块指定了JS和资源的加载路径，server.js模块除了指定server监听的默认端口外还有检测node版本等功能，runServer.js模块用来启动server。
- 待server启动成功后，才运行到iOS native code。也就是这个时候，才会运行Xcode项目中，事先定义好的run script phase中指定的shell脚本，而在这个时候，在shell脚本中创建资源路径是没有用的。所以就会出现了上面资源文件读不到的情况。

### Android中React Native项目启动顺序：
- 首先执行上面封装好的Unix executable文件，该文件中会调用资源文件生成的代码，将资源文件生成。
- 然后在该文件中会继续再执行react-native run-android命令，此时根据react-native-cli模块的package.json中bin的定义，调用node.js执行$prefix/react-native-cli/index.js。
- 在index.js中会先加载cli.js模块然后运行其run方法。在cli.js模块中做的工作和上面分析的iOS中的cli.js做的工作是一样的。
- 待server启动成功后，才会运行到Android native code,所以运行封装好的Unix executable是不会导致资源失效的，因为资源生成代码已经在react-native run-android命令运行之前被执行过了。

> thx: [React-Native痛点解析之开发环境搭建及扩展](http://www.infoq.com/cn/articles/react-native-solution-dev-environment)

## :smile:Text元素在Text里边，可以考虑为inline， 如果单独在View里边，那就是Block。
```
<Text>
  <Text>First part and </Text>
  <Text>second part</Text>
</Text>
// Text container: all the text flows as if it was one
// |First part |
// |and second |
// |part       |

<View>
  <Text>First part and </Text>
  <Text>second part</Text>
</View>
// View container: each text is its own block
// |First part |
// |and        |
// |second part|
```

## :smile:在React Native中尺寸是没有单位的，它代表了设备独立像素。
```
<View style={ {width:100,height:100,margin:40,backgroundColor:'gray'}}>
        <Text style={ {fontSize:16,margin:20}}>尺寸</Text>
</View>
```
上述代码，运行在Android上时，View的长和宽被解释成：100dp 100dp单位是dp，字体被解释成16sp 单位是sp，运行在iOS上时尺寸单位被解释称了pt，这些单位确保了布局在任何不同dpi的手机屏幕上显示不会发生改变。可以通过Dimensions 来获取宽高，PixelRatio 获取密度，如果想使用百分比，可以通过获取屏幕宽度手动计算。

## :smile:ListView组件中：scrollTo({x: 0, y: 100, animated: true})在iOS滚动到指定位置没问题，但是在android滚动到没有渲染过的位置就会滚动不准，可以加个initialListSize={cell个数}解决android的问题。

## :smile:TouchableHighlight只支持一个子节点，如果你希望包含多个子组件，用一个View来包装它们。

## :smile:
```
写法1：

<XXView xxxx={this.xxA.bind(this)} />

写法2：

constructor(props) {
    super(props);
    this.xxA= this.xxA.bind(this);
  }
  
写法3：

xxA = ()=>{};
<XXView xxxx={this.xxA} />

写法4：

<XXView xxxx={()=>this.xxA()} />
```
1和4的问题在于，由于绑定是在render中执行，而render是会执行多次的，每次bind和箭头函数都会产生一个新的函数，因而带来了额外的开销。如果父组件重新render后，给到子组件的属性是一个新的函数实例，而并非完全相同的实例，这样即使子组件是pure-rendering component，也不能起到优化作用。

2和3避免了每次产生新的函数，2和3都在this上绑定了bind后的实例，所以重新render也不会导致子组件属性变化，显然3的写法更简洁。

所以首选3，但是当2，3需要绑定一些预置的参数时（也就是偏函数的概念），这时候2和3貌似都是不行的，此时1和4就派上用处了，看f8源码，在预置参数的时候便是用的行内bind的方式。

> 参考 [请教react native的写法中，用bind和用箭头函数哪个好？](https://segmentfault.com/q/1010000006841365)

## :smile: rn打包命令
```
react-native bundle [参数]
  构建 js 离线包 

  Options:

    -h, --help                   输出如何使用的信息
    --entry-file <path>          RN入口文件的路径, 绝对路径或相对路径
    --platform [string]          ios 或 andorid
    --transformer [string]       Specify a custom transformer to be used
    --dev [boolean]              如果为false, 警告会不显示并且打出的包的大小会变小
    --prepack                    当通过时, 打包输出将使用Prepack格式化
    --bridge-config [string]     使用Prepack的一个json格式的文件__fbBatchedBridgeConfig 例如: ./bridgeconfig.json
    --bundle-output <string>     打包后的文件输出目录, 例: /tmp/groups.bundle
    --bundle-encoding [string]   打离线包的格式 可参考链接https://nodejs.org/api/buffer.html#buffer_buffer.
    --sourcemap-output [string]  生成Source Map，但0.14之后不再自动生成source map，需要手动指定这个参数。例: /tmp/groups.map
    --assets-dest [string]       打包时图片资源的存储路径
    --verbose                    显示打包过程
    --reset-cache                移除缓存文件
    --config [string]            命令行的配置文件路径
```
打包：
```
react-native bundle --entry-file index.ios.js --bundle-output ./bundle/ios/index.ios.jsbundle --platform ios --assets-dest ./bundle/ios --dev false 
```
将 assets 和 index.ios.jsbundle 引入工程。

注意：
- 打包命令中的路径(文件夹一定要存在)
- 必须用 Create folder references 的方式引入图片的 assets ，否则引用不到图片
- 不能用 main.jsbundle 来命名打包后的文件，否则会出现问题

## :smile:
<View style={{ flex: 1, backgroundColor: 'blue' }} />这样实现一个占位符，backgroundColor是无效的。只有View组件里有子组件才有效。

## :smile: <=iOS8不支持Number.parseInt()，可用Math.floor()代替。

## :smile: 例如在“¥100”价格上设置中划线，中划线在¥和100中的位置高低不同，请确认使用的是英文“¥”而不是中文“￥”
```javascript
<Text style={{textDecorationLine: "line-through",fontSize: 12,color: '#999999'}} >¥{(Math.floor(item.originalPrice) || 0) / 100}</Text>
```
## :smile: React Native 读取本地的json文件
自 React Native 0.4.3，你可以以导入的形式，来读取本地的json文件，导入的文件可以作为一个js对象使用。
```
var langsData = require('../../../res/data/langs.json');

//ES6/ES2015
import langsData from '../../../res/data/langs.json'
```

## :smile: npm指令发布包的时候出错
执行`sudo npm publish`出错，原来是安装的时候指定了淘宝的数据源（ https://registry.npm.taobao.org ），所以改为临时使用npmjs的源：

```
sudo npm publish --registry https://registry.npmjs.org/
```

## :smile: Animated.View translate动画在android上的奇怪bug（iOS是正常的）

例如：([完整代码地址](https://github.com/easyui/react-native-ezswiper/blob/master/src/EZSwiper.js))

```
       <View key={i} style={{ flexDirection: this.ezswiper.horizontal ? 'row' : 'column' }}>
                    <View style={{ [this.ezswiper.horizontal ? 'width' : 'height']: margin, backgroundColor: 'transparent' }} />
                    <TouchableOpacity onPress={() => this.events.onPress(currentItem, dataSourceIndex)}>
                        <Animated.View style={{ backgroundColor: 'transparent', width: this.ezswiper.horizontal ? this.ezswiper.cardParams.cardSide : width, height: this.ezswiper.horizontal ? height : this.ezswiper.cardParams.cardSide, transform: [{ [this.ezswiper.horizontal ? 'scaleY' : 'scaleX']: scaleArray[i] }, { [this.ezswiper.horizontal ? 'translateX' : 'translateY']: translateArray[i] }] }} >
                            {this.events.renderRow(currentItem, dataSourceIndex)}
                        </Animated.View>
                    </TouchableOpacity>
                    <View style={{ [this.ezswiper.horizontal ? 'width' : 'height']: margin, backgroundColor: 'transparent' }} />
                </View>
```

Animated.View被TouchableOpacity包裹时，触发translateX动画左右移动时，碰到旁边组件会后动画的组件和旁边重叠的部分会不见了，改什么透明度都不行，换成TouchableWithoutFeedback就好了。

## :smile: 动画结束后回调更新界面
例如

```
    componentWillUnmount() {
        this.unmount = true
    }
                            
                            
    Animated.timing(
           this.animations.image.opacity,
           {
               toValue: 1,
               duration: this.props.duration,
               easing: Easing.linear,
            }
           ).start(() => {
                 if (!this.unmount) {
                      this.setState({ show: false })
                 }
           });
```

在android中，组件释放了，但是动画结束后回调还在执行且更新界面会导致crash，所以加unmount防止组件释放后仍更新界面
                        




