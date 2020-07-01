# 在ScrollView中使用autolayout

在scrollview中使用autolayout时，可能稍微有些容易出错，是因为scrollView需要确定自己的contentSize，所以需要能确定子视图的大小，子视图的大小就是scrollView的contentSize。
也就是说，你需要能撑起来scrollView，且水平和竖直硬性支撑。用代表表示，就是scrollView上下左右均有约束，且子视图的宽高一定能通过约束计算出特定的大小。

用一个实例，在scrollView中添加3个view，可左右滑动，pageEnable为true。

```swift
let scrollView = UIScrollView()
scrollView.translatesAutoresizingMaskIntoConstraints = false
scrollView.backgroundColor = .gray
scrollView.isPagingEnabled = true
view.addSubview(scrollView)
scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
scrollView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
scrollView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        
let bgColor = [UIColor.red,UIColor.green,UIColor.yellow]
        
var leftView:UIView? = nil
for i in 0..<3{
  let view = UIView()
  view.translatesAutoresizingMaskIntoConstraints = false
  view.backgroundColor = bgColor[i]
  scrollView.addSubview(view)
  if let left = leftView{
    view.leftAnchor.constraint(equalTo: left.rightAnchor, constant: 0).isActive = true
  }else{
    view.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 0).isActive = true
  }
  view.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0).isActive = true
  view.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0).isActive = true
  view.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 1.0).isActive = true
  view.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 1.0).isActive = true
  leftView = view
}
//所有的view都是上左右约束到scrollView，且宽高与scrollView相同，但是scrollView右侧还没有被关联约束
//添加右侧的约束
if let left = leftView{
  left.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: 0).isActive = true
}
```

如果是xib或者storyboard也拖出来遵循这个规则就好啦。再来重复一下需要满足的条件：

1、 约束能撑起来scrollView。就是scrollView上下左右均有约束，

`2、 且水平和竖直硬性支撑。所有子视图的所需的最大宽高一定能通过约束计算出特定的值。`

