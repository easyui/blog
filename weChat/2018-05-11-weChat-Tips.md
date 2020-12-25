# weChat Tips
## 开源
- [awesome-wechat-weapp](https://github.com/justjavac/awesome-wechat-weapp):微信小程序开发资源汇总
- [xiaochengxu_demos](https://github.com/qiushi123/xiaochengxu_demos):小程序优秀项目源码汇总
- [weui-wxss](https://github.com/Tencent/weui-wxss):WeUI for 小程序 为微信小程序量身设计
- [ourTalk](https://github.com/BearstOzawa/ourTalk):基于微信小程序的校园论坛；微信小程序；云开发；云数据库；云储存；云函数；纯JS无后台；
- [mini-blog](https://github.com/CavinCao/mini-blog):mini-blog是一款基于云开发的博客小程序，该小程序完全不依赖任何后端服务，无需自己的网站、服务器、域名等资源，只需要自行注册小程序账号即可。
- [today](https://github.com/GoKu-gaga/today):使用小程序云开发进行开发的一款小程序(口袋工具)
- [Himalayan-lite](https://github.com/Notobey/Himalayan-lite):这是一个模仿喜马拉雅lite的微信小程序 - 简单易上手

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
### :smile:
### :smile:
### :smile:
### :smile:
### :smile:
### :smile:
### :smile:
### :smile:
### :smile:
### :smile:
### :smile:
### :smile:
### :smile:
### :smile:
### :smile:





