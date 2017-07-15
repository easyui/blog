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


## :smile:在React Native中尺寸是没有单位的，它代表了设备独立像素。
```
<View style={ {width:100,height:100,margin:40,backgroundColor:'gray'}}>
        <Text style={ {fontSize:16,margin:20}}>尺寸</Text>
</View>
```
上述代码，运行在Android上时，View的长和宽被解释成：100dp 100dp单位是dp，字体被解释成16sp 单位是sp，运行在iOS上时尺寸单位被解释称了pt，这些单位确保了布局在任何不同dpi的手机屏幕上显示不会发生改变。可以通过Dimensions 来获取宽高，PixelRatio 获取密度，如果想使用百分比，可以通过获取屏幕宽度手动计算。

