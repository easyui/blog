# weChat Tips
## 开源
- [awesome-wechat-weapp](https://github.com/justjavac/awesome-wechat-weapp):微信小程序开发资源汇总
- [xiaochengxu_demos](https://github.com/qiushi123/xiaochengxu_demos):小程序优秀项目源码汇总
- [weui-wxss](https://github.com/Tencent/weui-wxss):WeUI for 小程序 为微信小程序量身设计
- [juejin](https://github.com/myvin/juejin):掘金小程序
- [ourTalk](https://github.com/BearstOzawa/ourTalk):基于微信小程序的校园论坛；微信小程序；云开发；云数据库；云储存；云函数；纯JS无后台；
- [mini-blog](https://github.com/CavinCao/mini-blog):mini-blog是一款基于云开发的博客小程序，该小程序完全不依赖任何后端服务，无需自己的网站、服务器、域名等资源，只需要自行注册小程序账号即可。
- [today](https://github.com/GoKu-gaga/today):使用小程序云开发进行开发的一款小程序(口袋工具)
- [Himalayan-lite](https://github.com/Notobey/Himalayan-lite):这是一个模仿喜马拉雅lite的微信小程序 - 简单易上手

## 组件
- [wx-statuslayout](https://github.com/zzjian/wx-statuslayout):页面状态切换组件
- [wx-calendar](https://github.com/749264345/wx-calendar):日历组件;提供平铺与滚动可折叠模式任意切换
- [wx-calendar](https://github.com/mehaotian/wx-calendar):日历打卡组件

## 资源
- [小程序开发指南](https://developers.weixin.qq.com/ebook?action=get_post_info&token=935589521&volumn=1&lang=zh_CN&book=miniprogram&docid=0008aeea9a8978ab0086a685851c0a)
- [很快：第三方微信开发者平台](http://www.henkuai.com/forum.php)
- [ctolib微信小程序开发资源汇总](http://javascript.ctolib.com/javascript/categories/javascript-wechat-weapp.html) 
- [微信小程序联盟](http://www.wxapp-union.com/)

## Tips

### :smile:Flex布局撑满全屏
```
wxcc文件
page{
    width: 100%;
    height: 100%;
}
.container{
    display: flex;
    flex-direction: column;
    width: 100%;
    height: 100%;
}
```
在wxss里必须加`page{ width: 100%; height: 100%; }`否则container的height: 100%;不起作用从而导致container 的高不能填充满整个窗口。

### :smile:禁止页面上下滑动
在页面的json文件中配置`"disableScroll": true`

### :smile:在 iPhone6 上，屏幕宽度为375px，共有750个物理像素，则750rpx = 375px = 750物理像素，1rpx = 0.5px = 1物理像素。

### :smile:单行和多行省略号
在小程序开发过程中，经常会遇到一些数据无法在text中完全展示，所以会使用到隐藏相关文字，并在后方加上省略号(...)。

只需要在对应的text中设置下面的css就可以了：
```
.text {
overflow:hidden; /*超出一行文字自动隐藏 */
text-overflow:ellipsis; /*文字隐藏后添加省略号*/
white-space:nowrap; /*强制不换行*/
}
```
不过上面的css只能保证单行显示隐藏，如果想要2，3，n行隐藏呢？这个要求其实也是可以通过css做到的。下面贴出css：
```
.text {
  display: -webkit-box;
  -webkit-line-clamp: 2;/*行数n*/
  -webkit-box-orient: vertical; 
  overflow: hidden;
  text-overflow: ellipsis;
}
```
### :smile:scroll-view标签高度自适应
一般写法：
1、
```
<view class='header'>
</view>
<view class='box' style='height:{{boxHeight}}px;'>
</view>
```

```
/**
   * 页面的初始数据
   */
  data: {
    boxHeight: 0
  },

  /**
   * 生命周期函数--监听页面加载
   */
  onLoad: function (options) {

    let res = wx.getSystemInfoSync();
    let boxHeight = res.windowHeight - 50;
    this.setData({
      'boxHeight': boxHeight
    });

    wx.setNavigationBarTitle({
      title: '小程序中动态计算高度',
    })
  }
```

```
page {
  width: 100%;
  height: 100%;
  background-color: plum;
}

.header {
  background: red;
  height: 50px;
}

.box {
  background: yellowgreen;
}
```

2、

```
<view class='header'></view>
<view class='box' ></view>
```

```
page {
  width: 100%;
  height: 100%;
  background-color: plum;
  display: flex;
  flex-direction: column;
}

.header {
  background: red;
  height: 50px;
}

.box {
  background: yellowgreen;
  flex: 1;
}
```

方法1和方法2的写法都能使box自适应撑满剩余空间，接下来往方法2里面放一个滚动视图scroll-view，设置为可以垂直滚动，高度设置为100%样式：

```
<view class='header'>
</view>
<view class='box'>
  <scroll-view class='sv' scroll-y='true' style='height:100%;'>
  <view>韦神和这位水友打了照面，这样近的距离下连开十枪，但居然全被这位水友完美躲过。连韦酱都露出了一脸不可置信的表情！</view>
  <view>网友们则不仅因为这位水友的身法表示赞叹，纷纷表示，"被打倒的人总说别人的枪法有多好！拜托，只是你自己的身法没到家好吗！"大家也从韦神被秀一事中收获了无限乐趣。</view>
  <view>不过，也有网友努力为韦神堪称人体描边挂的十枪辩解，都是因为这位水友喜欢韦神太久了，也太了解韦神了，"当喜欢一个人久了...他的身法、他的枪法、他打的每一颗子弹，甚至每一颗子弹走的路径，我都会了如指掌，所以韦酱他...伤不了我！"</view>
  <view>对此，韦神也转发肯定了这个逻辑，并推荐各位网友称："男女朋友的可以试一试，打中一枪，说明他不够爱你！" 既然有韦神大力推荐，各位非单身的玩家们不妨一试啊，吃鸡究竟是不是一个爱情杀手游戏就能见分晓了！ 刚不过枪？落地成盒？手把手教你成功吃鸡！快关注兔玩英雄训练营返回搜狐，查看更多
  </view>
  <view>韦神和这位水友打了照面，这样近的距离下连开十枪，但居然全被这位水友完美躲过。连韦酱都露出了一脸不可置信的表情！</view>
  <view>网友们则不仅因为这位水友的身法表示赞叹，纷纷表示，"被打倒的人总说别人的枪法有多好！拜托，只是你自己的身法没到家好吗！"大家也从韦神被秀一事中收获了无限乐趣。</view>
  <view>不过，也有网友努力为韦神堪称人体描边挂的十枪辩解，都是因为这位水友喜欢韦神太久了，也太了解韦神了，"当喜欢一个人久了...他的身法、他的枪法、他打的每一颗子弹，甚至每一颗子弹走的路径，我都会了如指掌，所以韦酱他...伤不了我！"</view>
  <view>对此，韦神也转发肯定了这个逻辑，并推荐各位网友称："男女朋友的可以试一试，打中一枪，说明他不够爱你！" 既然有韦神大力推荐，各位非单身的玩家们不妨一试啊，吃鸡究竟是不是一个爱情杀手游戏就能见分晓了！ 刚不过枪？落地成盒？手把手教你成功吃鸡！快关注兔玩英雄训练营返回搜狐，查看更多
  </view>
</scroll-view>
</view>
```

```
page {
  width: 100%;
  height: 100%;
  background-color: plum;
  display: flex;
  flex-direction: column;
}

.header {
  background: red;
  height: 50px;
}

.box {
  background: yellowgreen;
  flex: 1;
}
```

出现了问题，可以看到一旦加入scroll-view组件，样式被破坏了，header的高度莫名其妙变成了0；小程序的说法是要求scroll-view一定要给一个固定的高度，不然就不行，难道只能用第方法1来实现这个布局了？

我发现一个tip，其实只要给外围的box一个高度即可，随便一个高度，因为设置了flex拉伸级别，这个高度不影响拉伸；在H5中是没意义的，但是这里可以解决问题：

```
<view class='header'>
  <view>财经</view>
  <view>股票</view>
  <view>商业</view>
  <view>汽车</view>
  <view>商业</view>
</view>
<view class='box'>
  <scroll-view class='sv' scroll-y='true'>
    <view>韦神和这位水友打了照面，这样近的距离下连开十枪，但居然全被这位水友完美躲过。连韦酱都露出了一脸不可置信的表情！</view>
    <view>网友们则不仅因为这位水友的身法表示赞叹，纷纷表示，"被打倒的人总说别人的枪法有多好！拜托，只是你自己的身法没到家好吗！"大家也从韦神被秀一事中收获了无限乐趣。</view>
    <view>不过，也有网友努力为韦神堪称人体描边挂的十枪辩解，都是因为这位水友喜欢韦神太久了，也太了解韦神了，"当喜欢一个人久了...他的身法、他的枪法、他打的每一颗子弹，甚至每一颗子弹走的路径，我都会了如指掌，所以韦酱他...伤不了我！"</view>
    <view>对此，韦神也转发肯定了这个逻辑，并推荐各位网友称："男女朋友的可以试一试，打中一枪，说明他不够爱你！" 既然有韦神大力推荐，各位非单身的玩家们不妨一试啊，吃鸡究竟是不是一个爱情杀手游戏就能见分晓了！ 刚不过枪？落地成盒？手把手教你成功吃鸡！快关注兔玩英雄训练营返回搜狐，查看更多

    </view>
    <view>韦神和这位水友打了照面，这样近的距离下连开十枪，但居然全被这位水友完美躲过。连韦酱都露出了一脸不可置信的表情！</view>
    <view>网友们则不仅因为这位水友的身法表示赞叹，纷纷表示，"被打倒的人总说别人的枪法有多好！拜托，只是你自己的身法没到家好吗！"大家也从韦神被秀一事中收获了无限乐趣。</view>
    <view>不过，也有网友努力为韦神堪称人体描边挂的十枪辩解，都是因为这位水友喜欢韦神太久了，也太了解韦神了，"当喜欢一个人久了...他的身法、他的枪法、他打的每一颗子弹，甚至每一颗子弹走的路径，我都会了如指掌，所以韦酱他...伤不了我！"</view>
    <view>对此，韦神也转发肯定了这个逻辑，并推荐各位网友称："男女朋友的可以试一试，打中一枪，说明他不够爱你！" 既然有韦神大力推荐，各位非单身的玩家们不妨一试啊，吃鸡究竟是不是一个爱情杀手游戏就能见分晓了！ 刚不过枪？落地成盒？手把手教你成功吃鸡！快关注兔玩英雄训练营返回搜狐，查看更多

    </view>
  </scroll-view>
</view>
```

```
page {
  width: 100%;
  height: 100%;
  background-color: plum;
  display: flex;
  flex-direction: column;
}

.header {
  background: red;
  height: 50px;
  width: 100%;
  display: flex;
}

.header > view {
  flex: 1;
  text-align: center;
  line-height: 50px;
  color: white;
}

.box {
  background: yellowgreen;
  flex: 1;
  height: 100px;/*随便给个高度让scroll-view自适应高度*/
}

.sv {
  background-color: #e9e9;
  height: 100%;
}
```

还可以scroll-view不被box套住，demo2:

父级使用flex布局，随便给在scroll-view设置一个高度，并使其样式中flex:1
```
<view class="parent">
  <view class="first-child"></view>
  <scroll-view class="second-child" scroll-y="true">
    <view  wx:for="{{100}}" wx:key="index">1</view>
  </scroll-view>
  <view class="third-child"></view>
</view>
```

```
/* miniprogram/pages/data/data.wxss */
.parent{
  display: flex;
  flex-direction: column;
  width: 100%;
  height: 100%;

  /* height: 100vh; */
}
.first-child{
  height: 100rpx;
  width: 100%;
  background-color: red;
}
.second-child{
  flex: 1;
  height: 1rpx;/*随便给个高度让scroll-view自适应高度*/
  width: 100%;
  background-color: yellow;
}
.third-child{
  height: 100rpx;
  width: 100%;
  background-color: blue;
}
```

### :smile:微信小程序的button按钮设置宽度无效
方法1.

样式中加入!important，即：width: 100% !important;

方法2.

标签内，使用style

```<button class="login-btn" bindclick="login" style="width:100%">登录</button>```

方法3.

删除app.json的配置"style": "v2"，不过这个不推荐哦。

### :smile:setData如何动态修改数组
有一数组menus=[0,0,0,0]，如果我们想修改menus数组的第2个值
的话，我们可以直接根据数组的键值修改，如下：
```
this.setData({
  menus[1]:1//修改后的menus=[0,1,0,0]，这里我们知道了具体的键值
});
```
但是如果这个键值是个动态的值的话，我们该如何修改呢？
```
let index =  1；
this.setData({
       menus[index]:1  //  此方法不行
});
```
如果按照上边的方法肯定不行，可以安照下边的方法：
```
Page({
  data: {
    menus:[0,0,0,0]
  },
  //事件处理函数
  changeMenus: function(e){
    let index = e.currentTarget.id;//如果这里取得的index=1，那么此函数运行后menus=[0,1,0,0]
    let curMenu= "menus["+index+"]";
    this.setData({
       [curMenu]:1
    });
  }
})
```

### :smile:limit 在小程序端默认及最大上限为 20，在云函数端默认及最大上限为 1000

### :smile:from : https://developers.weixin.qq.com/miniprogram/dev/wxcloud/basis/capabilities.html#%E6%95%B0%E6%8D%AE%E5%BA%93
每条记录都有一个 _id 字段用以唯一标志一条记录、一个 _openid 字段用以标志记录的创建者，即小程序的用户。需要特别注意的是，在管理端（控制台和云函数）中创建的不会有 _openid 字段，因为这是属于管理员创建的记录。开发者可以自定义 _id，但不可自定义和修改 _openid 。_openid 是在文档创建时由系统根据小程序用户默认创建的，开发者可使用其来标识和定位文档。

数据库 API 分为小程序端和服务端两部分，小程序端 API 拥有严格的调用权限控制，开发者可在小程序内直接调用 API 进行非敏感数据的操作。对于有更高安全要求的数据，可在云函数内通过服务端 API 进行操作。云函数的环境是与客户端完全隔离的，在云函数上可以私密且安全的操作数据库。

### :smile:如何隐藏scroll-view滚动条
在app.wxss文件加入：(https://developers.weixin.qq.com/community/develop/doc/00006473cf08f8c29da606b2d56c00)
```
::-webkit-scrollbar {
  display: none;
}
```

### :smile:固定单字符宽度（例如计时器00:00:00数字变化的时候宽度抖动）
css加入：
```
font-variant-numeric: tabular-nums;
```

ps：
请注意，这不会禁用使用Segoe UI观察到的可变高度(例如，某些数字仅像小写字母一样是x高度，其他数字则具有上升或下降字符)。这些传统的数字形式也可以使用CSS禁用，例如
font-variant-numeric: lining-nums;

您可以将两者结合使用:
font-variant-numeric: tabular-nums lining-nums;

### :smile:
### :smile:
### :smile:
### :smile:
### :smile:
### :smile:
### :smile:





