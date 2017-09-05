>本文使用最新开发环境开发环境：
>OSX: 10.12.6
>xcode：8.3.3
>react native：0.47.0
>codePush：\^5.0.0-beta"

## CodePush简介
CodePush 是微软提供的一套用于热更新 React Native 和 Cordova 应用的服务。  

CodePush 是提供给 React Native 和 Cordova 开发者直接部署移动应用更新给用户设备的云服务。CodePush 作为一个中央仓库，开发者可以推送更新 (JS, HTML, CSS and images)，应用可以从客户端 SDK 里面查询更新。CodePush 可以让应用有更多的可确定性，也可以让你直接接触用户群。在修复一些小问题和添加新特性的时候，不需要经过二进制打包，可以直接推送代码进行实时更新。

CodePush 可以进行实时的推送代码更新：
  
* 直接对用户部署代码更新  
* 管理 Alpha，Beta 和生产环境应用  
* 支持 React Native 和 Cordova  
* 支持JavaScript 文件与图片资源的更新

## 安装与注册CodePush    
### 安装 CodePush CLI
* 在终端输入 `npm install -g code-push-cli`，就可以安装了。  
* 安装完毕后，输入 `code-push -v`查看版本，如看到版本代表成功。(我安装的是2.0.2-beta)

### 注册CodePush账号  
* 在终端输入`code-push register`，会在浏览器注册页面让你选择授权账号（我选择了github登录）。  
* 授权通过之后，CodePush会告诉你“access key”，复制此key到终端即可完成注册。  
* 然后终端输入`code-push login`进行登陆，登陆成功后，你的session文件将会写在 /Users/你的用户名/.code-push.config。  

**用户操作相关命令**  

* `code-push login` 登陆  
* `code-push loout` 注销  
* `code-push access-key ls` 列出登陆的token  
* `code-push access-key rm <accessKye>` 删除某个 access-key  

## 在CodePush服务器注册app
为了让CodePush服务器知道你的app，我们需要向它注册app： 在终端输入`code-push app add <appName> <os> <platform>`即可完成注册。

示例：
```
  app add MyApp ios react-native      Adds app "MyApp", indicating that it's an iOS React Native app
  app add MyApp windows react-native  Adds app "MyApp", indicating that it's a Windows React Native app
  app add MyApp android cordova       Adds app "MyApp", indicating that it's an Android Cordova app
```
比如你执行`code-push  add demoapp ios react-native`，注册完成之后会返回一套deployment key，该key在后面步骤中会用到：

![在CodePush服务器注册app成功](在CodePush服务器注册app成功.png)

https://mobile.azure.com/apps 也可以看到你注册的app：

![网页查看](网页查看.png)

如果你的应用分为Android和iOS版，那么在向CodePush注册应用的时候需要注册两个App获取两套deployment key，app名字不能相同，所以可以选择`-ios,-android`区分。如：
```
code-push  add demoapp-ios ios react-native
code-push  add demoapp-android android react-native
```

**app管理相关命令**   

* `code-push app add` 在账号里面添加一个新的app  
* `code-push app remove` 或者 rm 在账号里移除一个app  
* `code-push app rename` 重命名一个存在app  
* `code-push app list` 或则 ls 列出账号下面的所有app  
* `code-push app transfer` 把app的所有权转移到另外一个账号  

## 集成CodePush SDK  
react native 集成CodePush模块：
```
npm install --save react-native-code-push
```
执行成功后package.json文件中会添加了：
```
	"dependencies": {
		···
		"react-native-code-push": "^5.0.0-beta",
      ···
	},
```
### iOS
CodePush官方提供RNPM、CocoaPods与手动三种在iOS项目中集成CodePush的方式，接下来我就以RNPM的方式来讲解一下如何在iOS项目中集成CodePush（android也支持RNPM集成）：

运行 `rnpm link react-native-code-push`。这条命令将会自动帮我们在iOS（android）文件中添加好设置，同时更新了项目中的配置代码。（在React Native v0.27及以后版本RNPM已经被集成到了 React Native CL中，就不需要再进行安装了。）

>其中iOS中的配置代码更新了AppDelegate.m文件：

```
#import <CodePush/CodePush.h>
···
#ifdef DEBUG
    jsCodeLocation = [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index.ios" fallbackResource:nil];
#else
    jsCodeLocation = [CodePush bundleURL];
#endif
···
```
>在终端运行此命令之后，终端会提示让你输入ios和android的deployment key，可以不输入直接单击enter跳过，等会在项目中配置。

**配置Deployment Key**：
1. 选择`Build Settings`页签 ➜ 单击 + 按钮然后选择添加`User-Defined Setting` 
2. 然后输入CODEPUSH_KEY(名称可以自定义)，设置2个deployment key

![设置deploymentkey.png](设置deploymentkey.png)

>提示：你可以通过`code-push deployment ls <APP_NAME> -k`命令来查看deployment key。

3. 打开 Info.plist文件，在CodePushDeploymentKey列的Value中输入`$(CODEPUSH_KEY)`

至此，iOS的配置完成。

## 使用CodePush进行热更新  
在使用CodePush更新你的应用之前需要，先配置一下更新控制策略，即：  

* 什么时候检查更新？（在APP启动的时候？在设置页面添加一个检查更新按钮？）
* 什么时候可以更新，如何将更新呈现给终端用户？  

### 发布更新
CodePush支持两种发布更新的方式，一种是通过`code-push release-react`简化方式，另外一种是通过`code-push release`的复杂方式。

#### 第一种方式：通过`code-push release-react`发布更新

这种方式将打包与发布两个命令合二为一，可以说大大简化了我们的操作流程，建议大家多使用这种方式来发布更新。

命令格式：
```
code-push release-react <appName> <platform>
```

eg:
```
code-push release-react MyApp-iOS ios
code-push release-react MyApp-Android android
```

更多参数配置：

```
code-push release-react MyApp-iOS ios  --t 1.0.0 --dev false --d Production --des "1.优化操作流程" --m true
```
其中参数--t为二进制(.ipa与apk)安装包的的版本；--dev为是否启用开发者模式(默认为false)；--d是要发布更新的环境分Production与Staging(默认为Staging)；--des为更新说明；--m 是强制更新。

关于`code-push release-react`更多可选的参数，可以在终端输入`code-push release-react`进行查看。

另外，我们可以通过`code-push deployment ls <appName>`来查看发布详情与此次更新的安装情况。
 
#### 第二中方式：通过`code-push release`发布更新
 
需要先执行`react-native bundle`打包资源：

```
react-native bundle --entry-file index.ios.js --bundle-output ./bundles/main.jsbundle --platform ios --assets-dest ./bundles --dev false
```
**bundle资源放入项目：**

![打包资源](打包资源.png)

**bundle资源通过CodePush发布更新，在终端输入：** 
`code-push release <应用名称> <Bundles所在目录> <对应的应用版本> --deploymentName： 更新环境
--description： 更新描述  --mandatory： 是否强制更新`
  
eg:  
`code-push release Demoapp ./bundles/index.android.bundle 1.0.6 --deploymentName Production  --description "1.支持文章缓存。" --mandatory true`

**注意：**  
1. CodePush默认是更新 staging 环境的，如果是staging，则不需要填写 deploymentName。     
2. 如果有 mandatory 则Code Push会根据mandatory 是true或false来控制应用是否强制更新。默认情况下mandatory为false即不强制更新。      
3. 对应的应用版本（targetBinaryVersion）是指当前app的版本(对应build.gradle中设置的versionName "1.0.6")，也就是说此次更新的js/images对应的是app的那个版本。不要将其理解为这次js更新的版本。
如客户端版本是 1.0.6，那么我们对1.0.6的客户端更新js/images，targetBinaryVersion填的就是1.0.6。     
4. 对于对某个应用版本进行多次更新的情况，CodePush会检查每次上传的 bundle，如果在该版本下如1.0.6已经存在与这次上传完全一样的bundle(对应一个版本有两个bundle的md5完全一样)，那么CodePush会拒绝此次更新。
5. 在终端输入 `code-push deployment history <appName> Staging` 可以看到Staging版本更新的时间、描述等等属性。  

**部署APP相关命令**
* code-push deployment add <appName> 部署  
* code-push deployment rename <appName> 重命名  
* code-push deployment rm <appName> 删除部署  
* code-push deployment ls <appName> 列出应用的部署情况  
* code-push deployment ls <appName> -k 查看部署的key  
* code-push deployment history <appName> <deploymentNmae> 查看历史版本(Production 或者 Staging)    

## 开发与测试
### 开发
上面提到`rnpm link react-native-code-push`执行往后，AppDelegate.m文件更新了：

```
#import <CodePush/CodePush.h>
···
#ifdef DEBUG
    jsCodeLocation = [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index.ios" fallbackResource:nil];
#else
    jsCodeLocation = [CodePush bundleURL];
#endif
···
```

下面更新js文件：
```
    ···
    constructor(props) {
        super(props);
        registerApp('wx94071fc9a6634781');
        const appId = 'qlJun5W9xYIdpi1nS8vepcDA-gzGzoHsz';
        const appKey = 'phlBacJt2JNSXW9RVuKl7KMQ';
        AV.init({ appId, appKey });

        ConfigManager.shareInstance().fetchAppConfig()

        CodePush.sync({
            deploymentKey: '12343kvGomTxA-AQtfd1234MxL12342eca8-90e6-428a-89ed-ba750111119f',
            updateDialog: null,
            installMode: CodePush.InstallMode.ON_NEXT_RESTART,
            mandatoryInstallMode: CodePush.InstallMode.ON_NEXT_RESTART,
        });

    }
    ···
    
    let codePushOptions = { checkFrequency: CodePush.CheckFrequency.MANUAL };
    App = CodePush(codePushOptions)(App);
    AppRegistry.registerComponent('miniDeer', () => App);
```
这段代码是每次启动app的时候检查更新和下载，如果有更新就下载好了，等下次启动的时候更新。具体js的代码可以参考[https://github.com/Microsoft/react-native-code-push/blob/master/Examples/CodePushDemoApp/demo.js](https://github.com/Microsoft/react-native-code-push/blob/master/Examples/CodePushDemoApp/demo.js)

### 调试
**iOS**

1. iOS调试需要在AppDelegate.m中进行如下修改：
```
//#ifdef DEBUG
//    jsCodeLocation = [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index.ios" fallbackResource:nil];
//#else
    jsCodeLocation = [CodePush bundleURL];
//#endif
```
让React Native通过CodePush去获取bundle包即可。

>不可以模拟器调试：

![不可以模拟器调试](不可以模拟器调试.png)

2. 打包bundle,并且把bundle和assets放入项目：
```
$ react-native bundle --entry-file index.ios.js --bundle-output ./bundles/main.jsbundle --platform ios --assets-dest ./bundles --dev false
```

3. 发布更新

```
$ code-push release demoApp ./bundles/ 1.0.0 --deploymentName Staging --description "修改了title" --mandatory true

```

4. 发布成功后就可以启动项目测试，等更新成功后就杀掉app重新启动（不要用xcode run）


## JavaScript API 简介

* allowRestart
* checkForUpdate
* disallowRestart
* getUpdateMetadata
* notifyAppReady
* restartApp
* sync

其实我们可以将这些API分为两类，一类是自动模式，一类是手动模式。  

### 自动模式
`sync`为自动模式，调用此方法CodePush会帮你完成一系列的操作。其它方法都是在手动模式下使用的。    
**codePush.sync**     
`codePush.sync(options: Object, syncStatusChangeCallback: function(syncStatus: Number),
downloadProgressCallback: function(progress: DownloadProgress)): Promise<Number>;`  
通过调用该方法CodePush会帮我们自动完成检查更新，下载，安装等一系列操作。除非我们需要自定义UI表现，不然直接用这个方法就可以了。    
**sync方法，提供了如下属性以允许你定制sync方法的默认行为**  

* deploymentKey （String）： 部署key，指定你要查询更新的部署秘钥，默认情况下该值来自于Info.plist(Ios)和MianActivity.java(Android)文件，你可以通过设置该属性来动态查询不同部署key下的更新。
* installMode (codePush.InstallMode)： 安装模式，用在向CodePush推送更新时没有设置强制更新(mandatory为true)的情况下，默认codePush.InstallMode.ON_NEXT_RESTART即下一次启动的时候安装。  
* mandatoryInstallMode (codePush.InstallMode):强制更新,默认codePush.InstallMode.IMMEDIATE。（设置这个优先级高于指令发布）
* minimumBackgroundDuration (Number):该属性用于指定app处于后台多少秒才进行重启已完成更新。默认为0。该属性只在`installMode`为`InstallMode.ON_NEXT_RESUME`情况下有效。  
* updateDialog (UpdateDialogOptions) :可选的，更新的对话框，默认是null,包含以下属性
	* appendReleaseDescription (Boolean) - 是否显示更新description，默认false
	* descriptionPrefix (String) - 更新说明的前缀。 默认是” Description: “
	* mandatoryContinueButtonLabel (String) - 强制更新的按钮文字. 默认 to “Continue”.
	* mandatoryUpdateMessage (String) - 强制更新时，更新通知. Defaults to “An update is available that must be installed.”.
	* optionalIgnoreButtonLabel (String) - 非强制更新时，取消按钮文字. Defaults to “Ignore”.
	* optionalInstallButtonLabel (String) - 非强制更新时，确认文字. Defaults to “Install”.
	* optionalUpdateMessage (String) - 非强制更新时，更新通知. Defaults to “An update is available. Would you like to install it?”.
	* title (String) - 要显示的更新通知的标题. Defaults to “Update available”.

eg:  

```javascript  
codePush.sync({
      updateDialog: {
        appendReleaseDescription: true,
        descriptionPrefix:'\n\n更新内容：\n',
        title:'更新',
        mandatoryUpdateMessage:'',
        mandatoryContinueButtonLabel:'更新',
      },
      mandatoryInstallMode:codePush.InstallMode.IMMEDIATE,
      deploymentKey: CODE_PUSH_PRODUCTION_KEY,
    });
```   


### 手动模式
**codePush.allowRestart**

`codePush.allowRestart(): void;`    
允许重新启动应用以完成更新。   
如果一个CodePush更新将要发生并且需要重启应用(e.g.设置了InstallMode.IMMEDIATE模式)，但由于调用了`disallowRestart`方法而导致APP无法通过重启来完成更新，
可以调用此方法来解除`disallowRestart`限制。  
但在如下四种情况下，CodePush将不会立即重启应用：  
1. 自上一次`disallowRestart`被调用，没有新的更新。  
2. 有更新，但`installMode`为`InstallMode.ON_NEXT_RESTART`的情况下。  
3. 有更新，但`installMode`为`InstallMode.ON_NEXT_RESUME`，并且程序一直处于前台，并没有从后台切换到前台的情况下。   
4. 自从上次`disallowRestart`被调用，没有再调用`restartApp`。

**codePush.checkForUpdate**

`codePush.checkForUpdate(deploymentKey: String = null): Promise<RemotePackage>;`  
向CodePush服务器查询是否有更新。  
该方法返回Promise，有如下两种值：  

* null 没有更新   
通常有如下情况导致RemotePackage为null:  
	1. 当前APP版本下没有部署新的更新版本。也就是说没有想CodePush服务器推送基于当前版本的有关更新。  
	2. CodePush上的更新和用户当前所安装的APP版本不匹配。也就是说CodePush服务器上有更新，但该更新对应的APP版本和用户安装的当前版本不对应。  
	3. 当前APP已将安装了最新的更新。  
	4. 部署在CodePush上可用于当前APP版本的更新被标记成了不可用。  
	5. 部署在CodePush上可用于当前APP版本的更新是"active rollout"状态，并且当前的设备不在有资格更新的百分比的设备之内。  

*  A RemotePackage instance  
有更新可供下载。    

eg：

```javascript
codePush.checkForUpdate()
.then((update) => {
    if (!update) {
        console.log("The app is up to date!");
    } else {
        console.log("An update is available! Should we download it?");
    }
});  
```

**codePush.disallowRestart**

`codePush.disallowRestart(): void;`  
不允许立即重启用于以完成更新。    
eg:  

```javascript
class OnboardingProcess extends Component {
    ...

    componentWillMount() {
        // Ensure that any CodePush updates which are
        // synchronized in the background can't trigger
        // a restart while this component is mounted.
        codePush.disallowRestart();
    }

    componentWillUnmount() {
        // Reallow restarts, and optionally trigger
        // a restart if one was currently pending.
        codePush.allowRestart();
    }

    ...
}
```

**codePush.getUpdateMetadata**  
`codePush.getUpdateMetadata(updateState: UpdateState = UpdateState.RUNNING): Promise<LocalPackage>;`  
获取当前已安装更新的元数据（描述、安装时间、大小等）。  
eg:  

```javascript
// Check if there is currently a CodePush update running, and if
// so, register it with the HockeyApp SDK (https://github.com/slowpath/react-native-hockeyapp)
// so that crash reports will correctly display the JS bundle version the user was running.
codePush.getUpdateMetadata().then((update) => {
    if (update) {
        hockeyApp.addMetadata({ CodePushRelease: update.label });
    }
});

// Check to see if there is still an update pending.
codePush.getUpdateMetadata(UpdateState.PENDING).then((update) => {
    if (update) {
        // There's a pending update, do we want to force a restart?
    }
});
```  

**codePush.notifyAppReady**  
`codePush.notifyAppReady(): Promise<void>;`  
通知CodePush，一个更新安装好了。当你检查并安装更新，（比如没有使用sync方法去handle的时候），这个方法必须被调用。否则CodePush会认为update失败，并rollback当前版本，在app重启时。  
当使用`sync`方法时，不需要调用本方法，因为`sync`会自动调用。   

**codePush.restartApp**  
`codePush.restartApp(onlyIfUpdateIsPending: Boolean = false): void;`  
立即重启app。
当以下情况时，这个方式是很有用的：   
1. app 当 调用 `sync` 或 `LocalPackage.install` 方法时，指定的 `install mode `是 `ON_NEXT_RESTART` 或 `ON_NEXT_RESUME时` 。 这两种情况都是当app重启或`resume`时，更新内容才能被看到。   
2. 在特定情况下，如用户从其它页面返回到APP的首页时，这个时候调用此方法完成过更新对用户来说不是特别的明显。因为强制重启，能马上显示更新内容。









