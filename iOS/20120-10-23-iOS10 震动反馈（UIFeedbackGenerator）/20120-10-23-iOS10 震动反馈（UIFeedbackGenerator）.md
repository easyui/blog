# iOS10 震动反馈（UIFeedbackGenerator）

## 对比

震动反馈是iOS 10之后出的新特性，相比于之前的系统震动
AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
要友好得多，没有声音，震动幅度适中，不需要设置里“响铃模式震动”打开。这也是Apple更推荐开发者使用的反馈震动。

- ios10之前的系统振动，需要打开`手机 -- 设置 -- 声音与触感 -- 响铃模式震动(打开)`

```
#import <AudioToolbox/AudioToolbox.h>  

AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
```

- ios10开始的振动反馈,需要打开`手机 -- 设置 -- 声音与触感 -- 系统触感反馈(打开)`

```
UIImpactFeedbackGenerator *feedBackGenertor = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
UIImpactFeedbackGenerator.prepare()
[feedBackGenertor impactOccurred];
```

## 详解

iOS 10 引入了一种新的、产生触觉反馈的方式，它通过使用所有应用共享的预定义震动模式，来帮助用户认识到不同的震动反馈有不同的含义。这个功能的核心由 UIFeedbackGenerator 提供，不过这只是一个抽象类 (abstract class) —— 你真正需要关注的三个类是 UINotificationFeedbackGenerator，UIImpactFeedbackGenerator，和 UISelectionFeedbackGenerator。

其中的第一个，UINotificationFeedbackGenerator 让你可以根据三种系统事件：error，success，和 warning 来产生反馈。第二个，UIImpactFeedbackGenerator，它可以产生三种不同程度的、 Apple 所说的“物理与视觉相得益彰的体验”。最后一个， UISelectionFeedbackGenerator 会在用户改变他们在屏幕上的选择（例如滑动一个转盘选择器）的时候被触发，产生一个相应的反馈。

这时候，只有 iPhone 7 和 iPhone 7 Plus 内置的新 Taptic 引擎支持这些应用程序接口（API）。其他设备只能静静地忽略这些触觉反馈的请求。

```
import UIKit

class ViewController: UIViewController {
    var i = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let btn = UIButton()
        view.addSubview(btn)

        btn.translatesAutoresizingMaskIntoConstraints = false
        
        btn.widthAnchor.constraint(equalToConstant: 128).isActive = true
        btn.heightAnchor.constraint(equalToConstant: 128).isActive = true
        btn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        btn.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        btn.setTitle("Tap here!", for: .normal)
        btn.setTitleColor(UIColor.red, for: .normal)
        btn.addTarget(self, action: #selector(tapped), for: .touchUpInside)
        

    }
    
    @objc func tapped() {
        i += 1
        print("Running \(i)")
        
        switch i {
        case 1:
            let generator = UINotificationFeedbackGenerator()
            generator.prepare()
            generator.notificationOccurred(.error)
            
        case 2:
            let generator = UINotificationFeedbackGenerator()
            generator.prepare()
            generator.notificationOccurred(.success)
            
        case 3:
            let generator = UINotificationFeedbackGenerator()
            generator.prepare()
            generator.notificationOccurred(.warning)
            
        case 4:
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.prepare()
            generator.impactOccurred()
            
        case 5:
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.prepare()
            generator.impactOccurred()
            
        case 6:
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.prepare()
            generator.impactOccurred()
            
        default:
            let generator = UISelectionFeedbackGenerator()
            generator.prepare()
            generator.selectionChanged()
            i = 0
        }
    }
}
```

当你在手机上运行它的时候，按下 "Tap here!" 按钮可以轮流按顺序体验各种震动选项。

一个小贴士：因为系统准备触觉反馈需要一段时间，Apple 建议，触发触觉效果之前，在你的生成器 (generator) 内调用prepare() 方法。如果你不这么做的话，在视觉效果和对应的震动之间确实会有一个小小的延迟，这给用户造成的迷惑可能会大过它的用处。

尽管从技术上来说，你可以给任何东西都加一个“操作成功”的反馈，但如果这么做而又做得不恰当的话，反而会给用户带来困惑，尤其是那些在人机交互上严重依赖触觉反馈的用户。Apple 特别要求开发者们要“恰如其分”的使用它们，尤其不要在给定的情境下使用错误的触觉反馈，而且记住，并不是所有的设备都支持这个新的触觉反馈 —— 毕竟你还要考虑那些旧 iPhone 的用户呐~

> [UIFeedbackGeneratorDemo.zip](./UIFeedbackGeneratorDemo.zip)
