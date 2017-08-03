# React Native Tips


## :smile:8081端口占用
```
ERROR Packager can't listen on port 8081
```
fix：

在终端如下操作：

1. lsof -n -i4TCP:8081 列出被占用的端口列表

2. kill -9 <PID> 找到与之对应的PID然后删除即可

3. 重启服务npm start

## :smile:自定义组件报错 has no propType for native prop
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
## :smile: iOS运行官方的RNTester（0.47.0），报错 #include <boost/iterator/iterator_adaptor.hpp>
iOS RN 0.45以上版本所需的第三方编译库(boost等)，这些库在国内下载都非常困难（一般的翻墙工具都很难下载），未来RN不同版本可能依赖不同版本的第三方编译库，具体所需库和版本请查看ios-install-third-party.sh文件：
```
fetch_and_unpack glog-0.3.4.tar.gz https://github.com/google/glog/archive/v0.3.4.tar.gz "$SCRIPTDIR/ios-configure-glog.sh"
fetch_and_unpack double-conversion-1.1.5.tar.gz https://github.com/google/double-conversion/archive/v1.1.5.tar.gz
fetch_and_unpack boost_1_63_0.tar.gz https://github.com/react-native-community/boost-for-react-native/releases/download/v1.63.0-0/boost_1_63_0.tar.gz
fetch_and_unpack folly-2016.09.26.00.tar.gz https://github.com/facebook/folly/archive/v2016.09.26.00.tar.gz
```
可以去[http://pan.baidu.com/s/1kVDUAZ9](http://pan.baidu.com/s/1kVDUAZ9) 下载boost_1_63_0.tar.gz（去哪个下载那个，我现在缺boost，所以就下载这个）。

- 下载后放入 ~/.rncache 文件夹下，

- 同时解压boost_1_63_0.tar.gz，把解压后的文件夹boost_1_63_0替换掉react-native/third-party/boost_1_63_0

- 最后重新clean ，运行项目。





