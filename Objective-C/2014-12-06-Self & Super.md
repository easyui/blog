# Self & Super
在 Objective-C 中的类实现中经常看到这两个关键字 ”self” 和 ”super”，以以前 oop 语言的经验，拿 c++ 为例，self 相当于 this，super 相当于调用父类的方法，这么看起来是很容易理解的。以下面的代码为例：

```
@interface Person:NSObject {
    NSString*  name;
}
- (void) setName:(NSString*) yourName;
@end

@interface PersonMe:Person {
    NSUInteger age;
}
- (void) setAge:(NSUInteger) age;
- (void) setName:(NSString*) yourName andAge:(NSUInteger) age;
@end

@implementation PersonMe
- (void) setName:(NSString*) yo
urName andAge:(NSUInteger) age {
    [self setAge:age];
    [super setName:yourName];
}
@end

int main(int argc, char* argv[]) {
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init]
    PersonMe* me = [[PersonMe alloc] init];
    [me setName:@"asdf" andAge:18];
    [me release];
    [pool drain];
    return 0;
}
```

上面有简单的两个类，在子类PersonMe中调用了自己类中的setAge和父类中的setName，这些代码看起来很好理解，没什么问题。
然后我在setName:andAge的方法中加入两行：

```
NSLog(@"self ' class is %@", [self class]);
NSLog(@"super' class is %@", [super class]);
```

这样在调用时，会打出来这两个的class，先猜下吧，会打印出什么？按照以前oop语言的经验，这里应该会输出：

```
self ' s class is PersonMe
super ' s class is Person
```

但是编译运行后，可以发现结果是：

```
self 's class is PersonMe
super ' s class is PersonMe
```

self 的 class 和预想的一样，怎么 super 的 class 也是 PersonMe？

##  解析
self 是类的隐藏的参数，指向当前调用方法的类，另一个隐藏参数是 _cmd，代表当前类方法的 selector。这里只关注这个 self。super 是个啥？super 并不是隐藏的参数，它只是一个“编译器指示符”，它和 self 指向的是相同的消息接收者，拿上面的代码为例，不论是用 [self setName] 还是 [super setName]，接收“setName”这个消息的接收者都是 PersonMe* me 这个对象。不同的是，super 告诉编译器，当调用 setName 的方法时，要去调用父类的方法，而不是本类里的。

当使用 self 调用方法时，会从当前类的方法列表中开始找，如果没有，就从父类中再找；而当使用 super 时，则从父类的方法列表中开始找。然后调用父类的这个方法。

这种机制到底底层是如何实现的？其实当调用类方法的时候，编译器会将方法调用转成一个 C 函数方法调用，Apple 的 objcRuntimeRef 上说：
```
Sending Messages

    When it encounters a method invocation, the compiler might generate a call to any of several functions to perform the actual message dispatch, depending on the receiver, the return value, and the arguments. You can use these functions to dynamically invoke methods from your own plain C code, or to use argument forms not permitted by NSObject’s perform… methods. These functions are declared in /usr/include/objc/objc-runtime.h.
    ■ objc_msgSend sends a message with a simple return value to an instance of a class.
    ■ objc_msgSend_stret sends a message with a data-structure return value to an instance of
    a class.
    ■ objc_msgSendSuper sends a message with a simple return value to the superclass of an instance of a class.
    ■ objc_msgSendSuper_stret sends a message with a data-structure return value to the superclass of an instance of a class.
```

可以看到会转成调用上面 4 个方法中的一个，由于 _stret 系列的和没有 _stret 的那两个类似，先只关注 objc_msgSend 和 objc_msgSendSuper 两个方法。当使用 [self setName] 调用时，会使用 objc_msgSend 的函数，先看下 objc_msgSend 的函数定义：

```
id objc_msgSend(id theReceiver, SEL theSelector, ...)
```

第一个参数是消息接收者，第二个参数是调用的具体类方法的 selector，后面是 selector 方法的可变参数。我们先不管这个可变参数，以 [self setName:] 为例，编译器会替换成调用 objc_msgSend 的函数调用，其中 theReceiver 是 self，theSelector 是 @selector(setName:)，这个 selector 是从当前 self 的 class 的方法列表开始找的 setName，当找到后把对应的 selector 传递过去。

而当使用 [super setName] 调用时，会使用 objc_msgSendSuper 函数，看下 objc_msgSendSuper 的函数定义：
```
id objc_msgSendSuper(struct objc_super *super, SEL op, ...)
```

第一个参数是个objc_super的结构体，第二个参数还是类似上面的类方法的selector，先看下objc_super这个结构体是什么东西：
```
struct objc_super {
    id receiver;
   Class superClass;
};
```

可以看到这个结构体包含了两个成员，一个是 receiver，这个类似上面 objc_msgSend 的第一个参数 receiver，第二个成员是记录写 super 这个类的父类是什么，拿上面的代码为例，当编译器遇到 PersonMe 里 setName:andAge 方法里的 [super setName:] 时，开始做这几个事：

构建 objc_super 的结构体，此时这个结构体的第一个成员变量 receiver 就是 PersonMe* me，和 self 相同。而第二个成员变量 superClass 就是指类 Person，因为 PersonMe 的超类就是这个 Person。
调用 objc_msgSendSuper 的方法，将这个结构体和 setName 的 sel 传递过去。函数里面在做的事情类似这样：从 objc_super 结构体指向的 superClass 的方法列表开始找 setName 的 selector，找到后再以 objc_super->receiver 去调用这个 selector，可能也会使用 objc_msgSend 这个函数，不过此时的第一个参数 theReceiver 就是 objc_super->receiver，第二个参数是从 objc_super->superClass 中找到的 selector。

里面的调用机制大体就是这样了，以上面的分析，回过头来看开始的代码，当输出 [self class] 和 [super class] 时，是个这样的过程。

当使用 [self class] 时，这时的 self 是 PersonMe，在使用 objc_msgSend 时，第一个参数是 receiver 也就是 self，也是 PersonMe* me 这个实例。第二个参数，要先找到 class 这个方法的 selector，先从 PersonMe 这个类开始找，没有，然后到 PersonMe 的父类 Person 中去找，也没有，再去 Person 的父类 NSObject 去找，一层一层向上找之后，在 NSObject 的类中发现这个 class 方法，而 NSObject 的这个 class 方法，就是返回 receiver 的类别，所以这里输出 PersonMe。

objc Runtime开源代码对- (Class)class方法的实现:
```
- (Class)class {
    return object_getClass(self);
}
```

当使用 [super class] 时，这时要转换成 objc_msgSendSuper 的方法。先构造 objc_super 的结构体吧，第一个成员变量就是 self，第二个成员变量是 Person，然后要找 class 这个 selector，先去 superClass 也就是 Person 中去找，没有，然后去 Person 的父类中去找，结果还是在 NSObject 中找到了。然后内部使用函数 objc_msgSend(objc_super->receiver, @selector(class))  去调用，此时已经和我们用 [self class] 调用时相同了，此时的 receiver 还是 PersonMe* me，所以这里返回的也是 PersonMe。

> thx:
>
> http://blog.csdn.net/wzzvictory/article/details/8487111
>
> http://chun.tips/blog/2014/11/05/bao-gen-wen-di-objective%5Bnil%5Dc-runtime(1)%5Bnil%5D-self-and-super/
>
> from
>
> [Self & Super](https://www.iteye.com/blog/justsee-2163897)



