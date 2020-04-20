# ARC中__autoreleasing 

## 在ARC中会自动注册到autoreleasepool中：

1、取得非自己生成并持有的对象时（即编译器检测不是以alloc/new/copy/mutableCope开始的方法名）：
```
@ autoreleasepool{  
id __strong obj = [NSMutableArray array];  
 //[NSMutableArray array]会自动注册到autoreleasepool  
} 
```

 如果是alloc/new/copy/mutableCope开头的方法必须：

```
@ autoreleasepool{  
id __autoreleasing obj =[ [NSObject alloc]  init];  
}  
```

2、对象作为函数返回值时；

```
+ (id) array{  
return [[NSObject alloc] init];  
}  
//or  
+ (id) array{  
id obj = [[NSObject alloc] init];  
return obj;  
}  
```

3、id的指针或对象的指针在没有显式指定时；
```
- (BOOL)moveItemAtPath:(NSString *)srcPath toPath:(NSString *)dstPath error:(NSError **)error NS_AVAILABLE(10_5, 2_0);  
```

 (NSError **)error 实际编译成 (NSError *__autoreleasing *)

4、在使用附有__weak修饰符的变量时必定要使用注册到autoreleasepool中的对象

注意点：

1、在ARC中不能使用autorelease方法,不能使用NSAutoreleasePool类；

2、在使用附有__weak修饰符的变量时必定要使用注册到autoreleasepool中的对象；

3、赋值给对象指针时，所有修饰符号必须一致。

但是，例如上面的第三点，定义一个NSError __strong *error = nil,传给方法参数是不一致的，其实编译器自动的做了转化：

NSError __strong *error = nil；

NSError __ autoreleasing *tmp= error；

调用方法；

error = tmp;

4、NSRunLoop等实现无论ARC有效还是无效，均能随时释放注册到autoreleasepool中的对象。

5、无论ARC，都能调用非公开方法_objc_ autoreleasePoolPrint()查看注册到autoreleasepool中的对象。


 
