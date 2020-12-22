# weChat Tips
## 开源
- [awesome-wechat-weapp](https://github.com/justjavac/awesome-wechat-weapp):微信小程序开发资源汇总
- [xiaochengxu_demos](https://github.com/qiushi123/xiaochengxu_demos):小程序优秀项目源码汇总
- [weui-wxss](https://github.com/Tencent/weui-wxss):WeUI for 小程序 为微信小程序量身设计

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





