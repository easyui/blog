Swift1.2中没有oc中对应的方法：
```swift
+ (instancetype)appearanceWhenContainedIn:(Class <UIAppearanceContainer>)ContainerClass, ... NS_REQUIRES_NIL_TERMINATION; 
```

解决方法：
在swift项目中新建oc类如下：
```swift
#import <UIKit/UIKit.h>  
  
@interface UIView (UIAppearance_Swift)  
+ (instancetype)ls_appearanceWhenContainedWithin: (NSArray *)containers;  
  
@end  
```

```swift
#import "UIView+UIAppearance_Swift.h"  
  
@implementation UIView (UIAppearance_Swift)  
+ (instancetype)ls_appearanceWhenContainedWithin: (NSArray *)containers  
{  
    NSUInteger count = containers.count;  
    NSAssert(count <= 10, @"The count of containers greater than 10 is not supported.");  
      
    return [self appearanceWhenContainedIn:  
            count > 0 ? containers[0] : nil,  
            count > 1 ? containers[1] : nil,  
            count > 2 ? containers[2] : nil,  
            count > 3 ? containers[3] : nil,  
            count > 4 ? containers[4] : nil,  
            count > 5 ? containers[5] : nil,  
            count > 6 ? containers[6] : nil,  
            count > 7 ? containers[7] : nil,  
            count > 8 ? containers[8] : nil,  
            count > 9 ? containers[9] : nil,  
            nil];  
}  
@end  
```
那Swift就可以调用了！

BTW：
在Xcode7beta，swift2中提供此方法：
```Swift
@available(iOS 9.0, *)  
static func appearanceWhenContainedInInstancesOfClasses(containerTypes: [AnyObject.Type]) -> Self 
```






