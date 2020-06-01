# 2019-09-02-iOS-tips

## :smile:什么时候栈上的Block会复制到堆
- 调用Block的copy实例方法时
- Block作为函数返回值返回时
- 将Block赋值给附有__strong修饰符id类型的类或者Block类型成员变量时
- 在方法名中含有usingBlock的Cocoa框架方法或Grand Central Dispatch 的API中传递Block时

## :smile:const
```
//全局变量，constString1地址不能修改，constString1值能修改
const NSString *constString1 = @"I am a const NSString * string";
//意义同上，无区别
NSString const *constString2 = @"I am a NSString const * string";
// stringConst 地址能修改，stringConst值不能修改
NSString * const stringConst = @"I am a NSString * const string";
```

## :smile:对象类对象元对象

![对象类对象元对象](对象类对象元对象.jpg)

- 每一个Class都有一个isa指针指向一个唯一的Meta Class
- 每一个Meta Class的isa指针都指向最上层的Meta Class，这个Meta Class是NSObject的Meta Class。(包括NSObject的Meta Class的isa指针也是指向的NSObject的Meta Class，也就是自己，这里形成了个闭环)
- 每一个Meta Class的super class指针指向它原本Class的 Super Class的Meta Class (这里最上层的NSObject的Meta Class的super class指针还是指向自己)
- 最上层的NSObject Class的super class指向 nil

## :smile:类变量
与C/C++语言中的静态变量一样，Objective-C 中的类变量就是以 static 声明的变量。（只在当前定义文件中有效）如果子类也想参照父类中的类变量的时候，须定义属性参照方法（类方法）。（这与面向对象中的封装概念有所背驰，降低了凝聚度）

## :smile:Objective-C中获取类名
```objc
NSLog(@"class name>> %@",NSStringFromClass([self class]));
```

方法二：
```objc
Class cls;

cls = [NSString class];

printf("class name %s\n", ((struct objc_class*)cls)->name);
```

## :smile:
重写object的respondsToSelector方法，现实出现EXEC_BAD_ACCESS前访问的最后一个object

有时程序崩溃根本不知错误发生在什么地方。比如程序出现EXEC_BAD_ACCESS的时候，虽然大部分情况使用设定 NSZombieEnabled环境变量可以帮助你找到问题的所在，但少数情况下，即使设定了NSZombieEnabled环境变量，还是不知道程序崩 溃在什么地方。那么就需要使用下列代码进行帮助了：

```objc
 #ifdef _FOR_DEBUG_  

-(BOOL) respondsToSelector:(SEL)aSelector {  

    printf("SELECTOR: %s\n", [NSStringFromSelector(aSelector) UTF8String]);  

    return [super respondsToSelector:aSelector];  

}  

#endif 
``` 

你需要在每个object的.m或者.mm文件中加入上面代码，并且在 other c flags中加入-D _FOR_DEBUG_（记住请只在Debug Configuration下加入此标记）。这样当你程序崩溃时，Xcode的console上就会准确地记录了最后运行的object的方法。

Swift项目：

在Swift Complier - Custom Flags下面的Other Swift Flags中加入-D _FOR_DEBUG_

## :smile:__attribute__ ((warn_unused_result))的含义

如果某个函数使用了这个关键字，那么函数在被调用的时候，要检查或者使用返回值，某则编译器会进行警告。

使用场合：在把一些功能封装起来（或者SDK的编写）时候，如果对返回值的使用比较重要，那么使用这个关键字提醒编译器要检查返回值是否被利用。

举例：
```objc
-(BOOL)TestFunc:(NSInteger) num __attribute__ ((warn_unused_result))
{
    return num > 0?YES:NO;
}
```
如果我这么调用
```objc
[self TestFunc:10];
```

## :smile:什么情况下不会autosynthesis（自动合成）？
- 同时重写了 setter 和 getter 时
- 重写了只读属性的 getter 时
- 使用了 @dynamic 时
- 在 @protocol 中定义的所有属性
- 在 category 中定义的所有属性
- 重载的属性

## :smile:_objc_msgForward消息转发做的几件事：

- 调用resolveInstanceMethod:方法 (或 resolveClassMethod:)。允许用户在此时为该 Class 动态添加实现。如果有实现了，则调用并返回YES，那么重新开始objc_msgSend流程。这一次对象会响应这个选择器，一般是因为它已经调用过class_addMethod。如果仍没实现，继续下面的动作。

- 调用forwardingTargetForSelector:方法，尝试找到一个能响应该消息的对象。如果获取到，则直接把消息转发给它，返回非 nil 对象。否则返回 nil ，继续下面的动作。注意，这里不要返回 self ，否则会形成死循环。

- 调用methodSignatureForSelector:方法，尝试获得一个方法签名。如果获取不到，则直接调用doesNotRecognizeSelector抛出异常。如果能获取，则返回非nil：创建一个 NSlnvocation 并传给forwardInvocation:。

- 调用forwardInvocation:方法，将第3步获取到的方法签名包装成 Invocation 传入，如何处理就在这里面了，并返回非ni。

- 调用doesNotRecognizeSelector: ，默认的实现是抛出异常。如果第3步没能获得一个方法签名，执行该步骤。

上面前4个方法均是模板方法，开发者可以override，由 runtime 来调用。最常见的实现消息转发：就是重写方法3和4，吞掉一个消息或者代理给其他对象都是没问题的

也就是说_objc_msgForward在进行消息转发的过程中会涉及以下这几个方法：

- resolveInstanceMethod:方法 (或 resolveClassMethod:)。

- forwardingTargetForSelector:方法

- methodSignatureForSelector:方法

- forwardInvocation:方法

- doesNotRecognizeSelector: 方法

## :smile:
自定义的 NSOperation 和 NSThread 需要手动创建自动释放池。比如： 自定义的 NSOperation 类中的 main 方法里就必须添加自动释放池。否则出了作用域后，自动释放对象会因为没有自动释放池去处理它，而造成内存泄露。

但对于 blockOperation 和 invocationOperation 这种默认的Operation ，系统已经帮我们封装好了，不需要手动创建自动释放池。

## :smile:三种方法来获取SEL:
- sel_registerName函数
- Objective-C编译器提供的@selector()
- NSSelectorFromString()方法

## :smile:dispatchbarrier\(a)sync只在自己创建的并发队列上有效，在全局(Global)并发队列、串行队列上，效果跟dispatch_(a)sync效果一样。

既然在串行队列上跟dispatch_(a)sync效果一样，那就要小心别死锁！

## :smile:指定（注册）一个timer到 RunLoops中， 一个timer对象只能够被注册到一个runloop中，在同一时间，在这个runloop中它能够被添加到多个runloop中模式中去。

## :smile:

## :smile:

## :smile:

## :smile:

## :smile:

## :smile:

## :smile:

## :smile:

## :smile:

## :smile:

## :smile:

## :smile: