//
//  MainClass.m
//  testLoadInitialize
//
//  Created by yangjun zhu on 15/5/4.
//  Copyright (c) 2015年 ouka. All rights reserved.
//

#import "MainClass.h"

@implementation MainClass
+ (void) load {
    NSLog(@"%@ %s", [self class], __FUNCTION__);
}

+ (void) initialize {
    NSLog(@"%@ %s", [self class], __FUNCTION__);
}

@end
@implementation MainClass(Category)
+ (void) load {
    NSLog(@"%@ %s", [self class], __FUNCTION__);
}
+ (void) initialize {
    NSLog(@"%@ %s", [self class], __FUNCTION__);
}
@end
@implementation MainClass(OtherCategory)
+ (void) load {
    NSLog(@"%@ %s", [self class], __FUNCTION__);
}

+ (void) initialize {
    NSLog(@"%@ %s", [self class], __FUNCTION__);
}

@end
