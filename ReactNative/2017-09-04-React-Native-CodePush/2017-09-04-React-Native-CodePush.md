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

**相关命令**  

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

**相关命令**   

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
>在终端运行此命令之后，终端会提示让你输入ios和android的deployment key，可以不输入直接单击enter跳过，等会在项目中配置。

**配置Deployment Key**：
1. 选择`Build Settings`页签 ➜ 单击 + 按钮然后选择添加`User-Defined Setting` 
2. 然后输入CODEPUSH_KEY(名称可以自定义)，设置2个deployment key

![设置deploymentkey.png](设置deploymentkey.png)

>提示：你可以通过`code-push deployment ls <APP_NAME> -k`命令来查看deployment key。

3. 打开 Info.plist文件，在CodePushDeploymentKey列的Value中输入`$(CODEPUSH_KEY)`

至此，iOS的配置完成。


 
 











