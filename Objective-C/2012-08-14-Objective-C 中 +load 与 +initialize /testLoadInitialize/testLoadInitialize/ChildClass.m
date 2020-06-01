//
//  ChildClass.m
//  testLoadInitialize
//
//  Created by yangjun zhu on 15/5/4.
//  Copyright (c) 2015年 ouka. All rights reserved.
//

#import "ChildClass.h"
#import "Insideinitialize.h"
@implementation ChildClass
+ (void) initialize {
    NSLog(@"%@ %s", [self class], __FUNCTION__);
    Insideinitialize * obj = [[Insideinitialize alloc] init];
    [obj objectMethod];
}
@end

