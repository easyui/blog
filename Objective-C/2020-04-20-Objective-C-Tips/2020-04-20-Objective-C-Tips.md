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

## :smile:在有了自动合成属性实例变量之后，@synthesize还有哪些使用场景？
回答这个问题前，我们要搞清楚一个问题，什么情况下不会autosynthesis（自动合成）？

 1. 同时重写了 setter 和 getter 时
 2. 重写了只读属性的 getter 时
 3. 使用了 @dynamic 时
 4. 在 @protocol 中定义的所有属性
 5. 在 category 中定义的所有属性
 6. 重写（overridden）的属性 

  当你在子类中重写（overridden）了父类中的属性，你必须 使用 `@synthesize` 来手动合成ivar。

除了后三条，对其他几个我们可以总结出一个规律：当你想手动管理 @property 的所有内容时，你就会尝试通过实现 @property 的所有“存取方法”（the accessor methods）或者使用 `@dynamic` 来达到这个目的，这时编译器就会认为你打算手动管理 @property，于是编译器就禁用了 autosynthesis（自动合成）。

因为有了 autosynthesis（自动合成），大部分开发者已经习惯不去手动定义ivar，而是依赖于 autosynthesis（自动合成），但是一旦你需要使用ivar，而 autosynthesis（自动合成）又失效了，如果不去手动定义ivar，那么你就得借助 `@synthesize` 来手动合成 ivar。

其实，`@synthesize` 语法还有一个应用场景，但是不太建议大家使用：

可以在类的实现代码里通过 `@synthesize` 语法来指定实例变量的名字:
 
```Objective-C
@implementation CYLPerson 
@synthesize firstName = _myFirstName; 
@synthesize lastName = _myLastName; 
@end 
```



上述语法会将生成的实例变量命名为 `_myFirstName` 与 `_myLastName`，而不再使用默认的名字。一般情况下无须修改默认的实例变量名，但是如果你不喜欢以下划线来命名实例变量，那么可以用这个办法将其改为自己想要的名字。笔者还是推荐使用默认的命名方案，因为如果所有人都坚持这套方案，那么写出来的代码大家都能看得懂。



举例说明：应用场景：


 ```Objective-C

//
// .m文件
// http://weibo.com/luohanchenyilong/ (微博@iOS程序犭袁)
// https://github.com/ChenYilong
// 打开第14行和第17行中任意一行，就可编译成功

@import Foundation;

@interface CYLObject : NSObject
@property (nonatomic, copy) NSString *title;
@end

@implementation CYLObject {
    //    NSString *_title;
}

//@synthesize title = _title;

- (instancetype)init
{
    self = [super init];
    if (self) {
        _title = @"微博@iOS程序犭袁";
    }
    return self;
}

- (NSString *)title {
    return _title;
}

- (void)setTitle:(NSString *)title {
    _title = [title copy];
}

@end
 ```

结果编译器报错：
![http://i.imgur.com/fAEGHIo.png](http://i.imgur.com/fAEGHIo.png)

当你同时重写了 setter 和 getter 时，系统就不会生成 ivar（实例变量/成员变量）。这时候有两种选择：

 1. 要么如第14行：手动创建 ivar
 2. 要么如第17行：使用`@synthesize foo = _foo;` ，关联 @property 与 ivar。

更多信息，请戳- 》[ ***When should I use @synthesize explicitly?*** ](http://stackoverflow.com/a/19821816/3395008)

> from [招聘一个靠谱的iOS](https://github.com/ChenYilong/iOSInterviewQuestions/blob/master/01%E3%80%8A%E6%8B%9B%E8%81%98%E4%B8%80%E4%B8%AA%E9%9D%A0%E8%B0%B1%E7%9A%84iOS%E3%80%8B%E9%9D%A2%E8%AF%95%E9%A2%98%E5%8F%82%E8%80%83%E7%AD%94%E6%A1%88/%E3%80%8A%E6%8B%9B%E8%81%98%E4%B8%80%E4%B8%AA%E9%9D%A0%E8%B0%B1%E7%9A%84iOS%E3%80%8B%E9%9D%A2%E8%AF%95%E9%A2%98%E5%8F%82%E8%80%83%E7%AD%94%E6%A1%88%EF%BC%88%E4%B8%8A%EF%BC%89.md#16-objc%E4%B8%AD%E5%90%91%E4%B8%80%E4%B8%AAnil%E5%AF%B9%E8%B1%A1%E5%8F%91%E9%80%81%E6%B6%88%E6%81%AF%E5%B0%86%E4%BC%9A%E5%8F%91%E7%94%9F%E4%BB%80%E4%B9%88)

## :smile: 对象的内存销毁时间表，分四个步骤：

```
// 对象的内存销毁时间表
// http://weibo.com/luohanchenyilong/ (微博@iOS程序犭袁)
// https://github.com/ChenYilong
// 根据 WWDC 2011, Session 322 (36分22秒)中发布的内存销毁时间表 

 1. 调用 -release ：引用计数变为零

     * 对象正在被销毁，生命周期即将结束.
     * 不能再有新的 __weak 弱引用， 否则将指向 nil.
     * 调用 [self dealloc] 
 2. 子类 调用 -dealloc
     * 继承关系中最底层的子类 在调用 -dealloc
     * 如果是 MRC 代码 则会手动释放实例变量们（iVars）
     * 继承关系中每一层的父类 都在调用 -dealloc
 3. NSObject 调 -dealloc
     * 只做一件事：调用 Objective-C runtime 中的 object_dispose() 方法
 4. 调用 object_dispose()
     * 为 C++ 的实例变量们（iVars）调用 destructors 
     * 为 ARC 状态下的 实例变量们（iVars） 调用 -release 
     * 解除所有使用 runtime Associate方法关联的对象
     * 解除所有 __weak 引用
     * 调用 free()
```


## :smile:__Block 在 ARC 和 MRC 环境的区别

结论先行：

- MRC 环境下，block 截获外部用 __block 修饰的变量，不会增加对象的引用计数
- ARC 环境下，block 截获外部用 __block 修饰的变量，会增加对象的引用计数

所以，在 MRC 环境下，可以通过 __block 来打破循环引用，在 ARC 环境下，则需要用 __weak 来打破循环引用。

ps：__block在MRC和ARC中都说明变量可改

## :smile: 在 ARC 中无论是否添加 __block ，block 中的 auto 变量都会被从栈上 copy 到堆上。

## :smile: 我们都知道：Block不允许修改外部变量的值，这里所说的外部变量的值，指的是栈中 auto 变量。__block 作用是将 auto 变量封装为结构体(对象)，在结构体内部新建一个同名 auto 变量，block 内截获该结构体的指针，在 block 中使用自动变量时，使用指针指向的结构体中的自动变量。于是就可以达到修改外部变量的作用。

## :smile:

 ```Objective-C
//判断如下几种情况,是否有循环引用? 是否有内存泄漏?
//2020-06-01 16:34:43 @iTeaTime(技术清谈)@ChenYilong 

 //情况❶ UIViewAnimationsBlock
[UIView animateWithDuration:duration animations:^{ [self.superview layoutIfNeeded]; }]; 

 //情况❷ NSNotificationCenterBlock
[[NSNotificationCenter defaultCenter] addObserverForName:@"someNotification" 
                                                  object:nil 
                           queue:[NSOperationQueue mainQueue]
                                              usingBlock:^(NSNotification * notification) {
                                                    self.someProperty = xyz; }]; 

 //情况❸ NSNotificationCenterIVARBlock
  _observer = [[NSNotificationCenter defaultCenter] addObserverForName:@"testKey"
                                                                object:nil
                                                                 queue:nil
                                                            usingBlock:^(NSNotification *note) {
      [self dismissModalViewControllerAnimated:YES];
  }];

 //情况❹ GCDBlock
    dispatch_group_async(self.operationGroup, self.serialQueue, ^{
        [self doSomething];
    });

//情况❺ NSOperationQueueBlock
[[NSOperationQueue mainQueue] addOperationWithBlock:^{ self.someProperty = xyz; }]; 

 ```


情况 | 循环引用 | 内存泄漏
:-------------:|:-------------:|:-------------:
情况 1 |不会循环应用 | 不会发生内存泄漏
情况 2 |不会循环引用 | 会发生内存泄漏
情况 3 |会循环引用   |会发生内存泄漏
情况 4 |不会循环引用 |不会发生内存泄漏
情况 5 |不会循环引用 |不会发生内存泄漏


> [《招聘一个靠谱的iOS》面试题参考答案（下）](https://github.com/ChenYilong/iOSInterviewQuestions/blob/master/01%E3%80%8A%E6%8B%9B%E8%81%98%E4%B8%80%E4%B8%AA%E9%9D%A0%E8%B0%B1%E7%9A%84iOS%E3%80%8B%E9%9D%A2%E8%AF%95%E9%A2%98%E5%8F%82%E8%80%83%E7%AD%94%E6%A1%88/%E3%80%8A%E6%8B%9B%E8%81%98%E4%B8%80%E4%B8%AA%E9%9D%A0%E8%B0%B1%E7%9A%84iOS%E3%80%8B%E9%9D%A2%E8%AF%95%E9%A2%98%E5%8F%82%E8%80%83%E7%AD%94%E6%A1%88%EF%BC%88%E4%B8%8B%EF%BC%89.md#37-%E4%BD%BF%E7%94%A8block%E6%97%B6%E4%BB%80%E4%B9%88%E6%83%85%E5%86%B5%E4%BC%9A%E5%8F%91%E7%94%9F%E5%BC%95%E7%94%A8%E5%BE%AA%E7%8E%AF%E5%A6%82%E4%BD%95%E8%A7%A3%E5%86%B3)

## :smile:

## :smile:

## :smile:

## :smile:

## :smile:

## :smile: