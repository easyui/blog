//
//  Insideinitialize.m
//  testLoadInitialize
//
//  Created by yangjun zhu on 15/5/4.
//  Copyright (c) 2015年 ouka. All rights reserved.
//

#import "Insideinitialize.h"

@implementation Insideinitialize
- (void)objectMethod {
    NSLog(@"%@ %s", [self class], __FUNCTION__);
}
+ (void) initialize {
    NSLog(@"%@ %s", [self class], __FUNCTION__);
}
+ (void) load {
    NSLog(@"%s", __FUNCTION__);
}
@end
