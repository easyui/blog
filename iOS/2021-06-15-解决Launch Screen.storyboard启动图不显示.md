# 解决LaunchScreen.storyboard启动图不显示

## 查看启动屏图片的名字

启动图名字不要包含Launch这样的字眼。

## 启动图片工程中位置

将启动图放在工程的根目录下，不要放在Assets.xcassets中。

> 比如直接在项目中放入：xxx@2x.png和xxx@3x.png，LaunchScreen.storyboard中的UIImageView中引用xxx.png

## 启动图的格式

建议使用png，尽量不要使用jpg

## 查看工程中是否仍在使用LaunchImage

将工程中与LaunchImage有关的全部删掉，包括Assets.xcassets中。最好在检查下plist文件和build Settings（Asset Catalog Launch Image Set Name）。

## 修改图片名字

有时候把启动图去掉，或者添加新的启动图，显示出来的还是之前的图片。这可能是缓存导致的，将启动图的名字改一下就会正常。

## 需要Clean重新编译

Clean后重新编译应用，或者直接清空DerivedData文件夹再重新编译。

## 删除应用重启手机

修改启动图后，最好卸载重装应用，有时可能还需要重启手机，否则可能会因为缓存还显示旧图片。




