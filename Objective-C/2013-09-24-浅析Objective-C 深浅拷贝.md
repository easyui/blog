# 浅析Objective-C 深浅拷贝

## 先了解下概念：

浅 复 制：在复制操作时，对于被复制的对象的每一层复制都是指针复制。

深 复 制：在复制操作时，对于被复制的对象至少有一层复制是对象复制。

完全复制：在复制操作时，对于被复制的对象的每一层复制都是对象复制。


注：

1、在复制操作时，对于对象有n层是对象复制，我们可称作n级深复制，此处n应大于等于1。

2、对于完全复制如何实现（目前通用的办法是：迭代法和归档），这里后续是否添加视情况而定，暂时不做讲解。

3、指针复制俗称指针拷贝，对象复制也俗称内容拷贝。

4、一般来讲：

    浅层复制：复制引用对象的指针。

    深层复制：复制引用对象内容。

    这种定义在多层复制的时候，就显得模糊。所以本文定义与它并不矛盾。反而是对它的进一步理解和说明。           

5、

`retain：始终是浅复制。引用计数每次加一。返回对象是否可变与被复制的对象保持一致。`

`copy：对于可变对象为深复制，引用计数不改变;对于不可变对象是浅复制，引用计数每次加一。始终返回一个不可变对象。`

`mutableCopy：始终是深复制，引用计数不改变。始终返回一个可变对象。`

例子：

```
NSMutableString *mstr = [NSMutableString stringWithString:@"origin"];

NSString *strCopy = [mstr copy];

NSMutableString *mstrCopy = [mstr copy];

NSMutableString *mstrMCopy = [mstr mutableCopy]; 

// [mstrCopy appendString:@"1111"];        // error

[mstr appendString:@"222"];

[mstrMCopy appendString:@"333"];

// 以上四个对象所分配的内存都是不一样的。而且对于mstrCopy，它所指向的其实是一个imutable对象，是不可改变的，所以会出错，这点要注意，好好理解。
```

6、

不可变对象：值发生改变，其内存首地址随之改变。

可变对象：无论值是否改变，其内存首地址都不随之改变。

引用计数：为了让使用者清楚的知道，该对象有多少个拥有者（即有多少个指针指向同一内存地址）。

## 最近有一个好朋友问我，什么时候用到深浅复制呢？那么我就把我所总结的一些分享给大家，希望能帮助你们更好的理解深浅复制喔！

那么先让我们来看一看下边数组类型的转换

1、不可变对象→可变对象的转换：
```
       NSArray *array1= [NSArray arrayWithObjects:@"a",@"b",@"c",@"d",nil];

       NSMutableArray  *str2=[array1 mutableCopy];
```
2、可变对象→不可变对象的转换：
```
    NSMutableArray *array2   = [NSMutableArray arrayWithObjects:@"aa",@"bb",@"cc",@"dd",nil];

       NSArray *array1=[  array2    Copy];
```
3、可变对象→可变对象的转换（不同指针变量指向不同的内存地址）：
```
       NSMutableArray *array1= [NSMutableArray arrayWithObjects:@"a",@"b",@"c",@"d",nil];

       NSMutableArray  *str2=[array1 mutableCopy];
```
通过上边的两个例子，我们可轻松的将一个对象在可变和不可变之间转换，并且这里不用考虑内存使用原则（即引用计数的问题）。没错，这就是深拷贝的魅力了。

4、同类型对象之间的导向保持（不同指针变量指向同一块内存地址）：

  a、
```
   NSMutableString *str1=[NSMutableString stringWithString:@"two day"];

   NSMutableString *str2=[str1   retain];

   [str1  release];
```
  b、
```
   NSArray *array1= [NSArray arrayWithObjects:@"a",@"b",@"c",@"d",nil];

   NSArray  *str2=[array1 Copy];

   [array1 release];
```
 

 通俗的讲，就是甲在执行交通导航任务，但接到上级新的命令要执行新的任务，那么在甲执行新任务之前，需要有人替代甲继续执行交通导航任务。这时候就要用到浅拷贝了。

### 则简化为：

问：什么时候用到深浅拷贝？

答：深拷贝是在要将一个对象从可变（不可变）转为不可变（可变）或者将一个对象内容克隆一份时用到；

     浅拷贝是在要复制一个对象的指针时用到。


## 下面看些例子总结：

```objc
//  
//  main.m  
//  TTTT  
//  
//  Created by EZ on 12-12-3.  
//  Copyright (c) 2012年 EZ. All rights reserved.  
//  
  
#import <Foundation/Foundation.h>  
  
int main(int argc, const char * argv[])  
{  
      
    @autoreleasepool {  
        //第一种：非容器类不可变对象  
          
        NSString *str1=@"one day";  
          
        NSLog(@"\n初始化赋值引用计数为::::%lu",str1.retainCount);  
        NSString *strCopy1=[str1 retain];  
        printf("\n继续retain引用计数为:::%lu",str1.retainCount);  
        NSString *strCopy2=[str1 copy];  
        printf("\n继续copy后引用计数为::::%lu",str1.retainCount);  
        NSString *strCopy3=[str1 mutableCopy];  
        printf("\n继续mutableCopy后为:::%lu\n",str1.retainCount);  
          
        printf("\n非容器类不可变对象\n原始地址::::::::::%p",str1);  
        printf("\nretain复制::::::::%p",strCopy1);  
        printf("\ncopy复制::::::::::%p",strCopy2);  
        printf("\nmutableCopy复制:::%p",strCopy3);  
          
        //这里说明该类型不存在引用计数的概念  
          
        // 初始化赋值引用计数为：18446744073709551615  
        // 继续retain引用计数为：18446744073709551615  
        // 继续copy后引用计数为：18446744073709551615  
        // 继续mutableCopy后为：18446744073709551615  
          
        //非容器类不可变对象  
        //原始地址::::::::::0x1000033d0  
        //retain复制::::::::0x1000033d0//浅复制  
        //copy复制::::::::::0x1000033d0//浅复制  
        //mutableCopy复制:::0x10010c420//深复制  
          
          
        printf("\n");  
        //第二种：容器类不可变数组  
        NSArray *array1= [NSArray arrayWithObjects:@"a",@"b",@"c",@"d",nil];  
          
        printf("\n初始化赋值引用计数为::::::::::::%lu",array1.retainCount);  
        NSArray *arrayCopy1 = [array1 retain];  
        printf("\n继续retain后引用计数为:::::::::%lu",array1.retainCount);  
        NSArray *arrayCopy2 = [array1 copy];  
        printf("\n继续copy后引用计数为:::::::::::%lu",array1.retainCount);  
        NSArray *arrayCopy3 = [array1 mutableCopy];  
        printf("\n继续mutableCopy后引用计数为::::%lu\n",array1.retainCount);  
          
        printf("\n容器类不可变数组\n原始地址::::::::::%p\t\t%p",array1,[array1 objectAtIndex:1]);  
        printf("\nretain复制::::::::%p\t\t%p",arrayCopy1,[arrayCopy1 objectAtIndex:1]);  
        printf("\ncopy复制::::::::::%p\t\t%p",arrayCopy2,[arrayCopy2 objectAtIndex:1]);  
        printf("\nmutableCopy复制:::%p\t\t%p",arrayCopy3,[arrayCopy3 objectAtIndex:1]);  
          
          
        //初始化赋值引用计数为::::::::::::1  
        //继续retain后引用计数为:::::::::2  
        //继续copy后引用计数为:::::::::::3  
        //继续mutableCopy后引用计数为::::3  
          
        //容器类不可变数组  
        //原始地址::::::::::0x10010c6b0 0x100003410  
        //retain复制::::::::0x10010c6b0 0x100003410//浅复制  
        //copy复制::::::::::0x10010c6b0 0x100003410//浅复制  
        //mutableCopy复制:::0x10010c760 0x100003410//深复制  
          
          
        printf("\n");  
        //第三种：非容器类可变对象  
          
        NSMutableString *str2=[NSMutableString stringWithString:@"two day"];  
          
        printf("\n初始化赋值引用计数为::::::::::::%lu",str2.retainCount);  
        NSMutableString *strCpy1=[str2 retain];  
        printf("\n继续retain后引用计数为:::::::::%lu",str2.retainCount);  
        NSMutableString *strCpy2=[str2 copy];  
        printf("\n继续copy后引用计数为:::::::::::%lu",str2.retainCount);  
        NSMutableString *strCpy3=[str2 mutableCopy];  
        printf("\n继续mutableCopy后引用计数为::::%lu\n",str2.retainCount);  
          
        printf("\n非容器类可变对象\n原始地址::::::::::%p",str2);  
        printf("\nretin复制::::::::%p",strCpy1);  
        printf("\ncopy复制::::::::::%p",strCpy2);  
        printf("\nmutableCopy复制:::%p",strCpy3);  
          
          
          
        //初始化赋值引用计数为::::::::::::1  
        //继续retain后引用计数为:::::::::2  
        //继续copy后引用计数为:::::::::::2  
        //继续mutableCopy后引用计数为::::2  
          
        //非容器类可变对象  
        //原始地址::::::::::0x10010c560  
        //retain复制::::::::0x10010c560//浅复制  
        //copy复制::::::::::0x100102720//深复制  
        //mutableCopy复制:::0x10010c880//深复制  
          
        printf("\n");  
        //第四种：容器类可变数组  
          
        NSMutableArray *array2   = [NSMutableArray arrayWithObjects:@"aa",@"bb",@"cc",@"dd",nil];  
          
        printf("\n初始化赋值引用计数为::::::::::%lu",array2.retainCount);  
        NSMutableArray *arrayCpy1 = [array2 retain];  
        printf("\n继续retain后引用计数为:::::::%lu",array2.retainCount);  
        NSMutableArray *arrayCpy2=[array2 copy];  
        printf("\n继续copy后引用计数为:::::::::%lu",array2.retainCount);  
        NSMutableArray *arrayCpy3 = [array2 mutableCopy];  
        printf("\n继续mutableCopy后引用计数为::%lu\n",array2.retainCount);  
          
        printf("\n容器类可变数组\n原始地址:::::::::::%p\t%p",array2,[array2 objectAtIndex:1]);  
        printf("\nretain复制:::::::::%p\t%p",arrayCpy1,[arrayCpy1 objectAtIndex:1]);  
        printf("\ncopy复制:::::::::::%p\t%p",arrayCpy2,[arrayCpy2 objectAtIndex:1]);  
        printf("\nnmutableCopy复制:::%p\t%p",arrayCpy3,[arrayCpy3 objectAtIndex:1]);  
          
          
        //初始化赋值引用计数为::::::::::1  
        //继续retain后引用计数为:::::::2  
        //继续copy后引用计数为:::::::::2  
        //继续mutableCopy后引用计数为::2  
          
        //容器类可变数组  
        //原始地址:::::::::::0x10010e6c0 0x1000034b0  
        //retain复制:::::::::0x10010e6c0 0x1000034b0//浅复制  
        //copy复制:::::::::::0x10010e790 0x1000034b0//深复制  
        //nmutableCopy复制:::0x10010e7c0 0x1000034b0//深复制  
          
          
        ///////////////////////////////////  
        printf("\n");  
        //一、容器内的元素内容都是浅拷贝  
        NSArray *mArray1 = [NSArray arrayWithObjects:[NSMutableString stringWithString:@"a"],@"b",@"c",nil];  
        printf("\nmArray1 retain count: %ld",[mArray1 retainCount]);   // 1  
        printf("\nretain复制:::::::::%p\t%p",mArray1,[mArray1 objectAtIndex:1]);  
        NSArray *mArrayCopy2 = [mArray1 copy];  
        printf("\nmArray1 retain count: %ld",[mArray1 retainCount]);  // 2  
        printf("\ncopy复制:::::::::::%p\t%p",mArrayCopy2,[mArrayCopy2 objectAtIndex:1]);  
        // mArray1和mArrayCopy2指向同一对象，retain值+1  
        NSMutableArray *mArrayMCopy1 = [mArray1 mutableCopy];  
        printf("\nmArray1 retain count: %ld ",[mArray1 retainCount]);    //2  
        printf("\nnmutableCopy复制:::%p\t%p \n",mArrayMCopy1,[mArrayMCopy1 objectAtIndex:1]);  
          
        //mArrayCopy2和mArray1指向的是不一样的对象，但是其中的元素都是一样的对象----同一个指针  
        NSMutableString *testString = [mArray1 objectAtIndex:0];  
        //testString = @"1a1"; // 这样会改变testString的指针，其实是将@"1a1"临时对象赋给了testString  
        [testString appendString:@"tail"]; //  这样以上三个数组的首元素都被改变了  
        NSLog(@"%@",mArray1);  
        NSLog(@"%@",mArrayCopy2);  
        NSLog(@"%@",mArrayMCopy1);  
        // 由此可见，对于容器而言，其元素对象始终是指针复制。如果需要元素对象也是对象复制，就需要实现深拷贝。  
        /* 
         mArray1 retain count: 1 
         retain复制:::::::::0x100503820   0x100002150 
         mArray1 retain count: 2 
         copy复制:::::::::::0x100503820   0x100002150 
         mArray1 retain count: 2 
         nmutableCopy复制:::0x100503850   0x100002150 
         ( 
         atail, 
         b, 
         c 
         ) 
         ( 
         atail, 
         b, 
         c 
         ) 
         ( 
         atail, 
         b, 
         c 
         ) 
         */  
          
          
        //二、  
        NSArray *array = [NSArray arrayWithObjects:[NSMutableString stringWithString:@"first"],[NSString stringWithString:@"b"],@"c",nil];  
        printf("\narray retain count: %ld",[array retainCount]);   // 1  
        printf("\n原始:::::::::%p \t%p\t%p\t%p",array,[array objectAtIndex:0],[array objectAtIndex:1],[array objectAtIndex:2]);  
        NSArray *deepCopyArray = [[NSArray alloc] initWithArray:array copyItems:YES];  
        printf("\narray retain count: %ld",[array retainCount]);   // 1  
        printf("\ncopyItems:::::::::%p\t%p\t%p\t%p",deepCopyArray,[deepCopyArray objectAtIndex:0],[deepCopyArray objectAtIndex:1],[deepCopyArray objectAtIndex:2]);  
        NSArray *trueDeepCopyArray = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:array]];  
        printf("\narray retain count: %ld",[array retainCount]);   // 1  
        printf("\narchive:::::::::%p\t%p\t%p\t%p",trueDeepCopyArray,[trueDeepCopyArray objectAtIndex:0],[trueDeepCopyArray objectAtIndex:1],[trueDeepCopyArray objectAtIndex:2]);  
        // trueDeepCopyArray是完全意义上的深拷贝，而deepCopyArray则不是，对于deepCopyArray内的不可变元素其还是指针复制。或者我们自己实现深拷贝的方法。因为如果容器的某一元素是不可变的，那你复制完后该对象仍旧是不能改变的，因此只需要指针复制即可。除非你对容器内的元素重新赋值，否则指针复制已足够。  
        // 举个例子，[[array objectAtIndex:0] appendString:@"sd"]后其他的容器内对象并不会受影响。[array objectAtIndex:1,2]和[deepCopyArray objectAtIndex:1,2]尽管是指向同一块内存，但是我们没有办法对其进行修改-----因为它是不可改变的。所以指针复制已经足够。所以这并不是完全意义上的深拷贝。  
          
    }  
    return 0;  
}  
```

 再看NSDictionary的完全复制的实现：

```objc
#import <Foundation/Foundation.h>  
  
@interface NSDictionary (MutableDeepCopy)  
- (NSMutableDictionary *)mutableDeepCopy;  
@end  
  
  
  
#import "NSDictionary+MutableDeepCopy.h"  
  
@implementation NSDictionary (MutableDeepCopy)  
  
- (NSMutableDictionary *)mutableDeepCopy {  
    NSMutableDictionary *returnDict = [[NSMutableDictionary alloc]  
                                       initWithCapacity:[self count]];  
    NSArray *keys = [self allKeys];  
    for (id key in keys) {  
        id oneValue = [self valueForKey:key];  
        id oneCopy = nil;  
          
        if ([oneValue respondsToSelector:@selector(mutableDeepCopy)])  
            oneCopy = [oneValue mutableDeepCopy];  
        else if ([oneValue respondsToSelector:@selector(mutableCopy)])  
            oneCopy = [oneValue mutableCopy];  
        if (oneCopy == nil)  
            oneCopy = [oneValue copy];  
        [returnDict setValue:oneCopy forKey:key];  
    }  
    return returnDict;  
}  
  
@end  
```

> from
>
> [浅析Objective-C 深浅拷贝](https://www.iteye.com/blog/justsee-1844819)
>
> [iOS 集合的深复制与浅复制](https://www.zybuluo.com/MicroCai/note/50592)