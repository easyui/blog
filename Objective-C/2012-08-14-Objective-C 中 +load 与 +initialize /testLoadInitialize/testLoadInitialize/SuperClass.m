//
//  SuperClass.m
//  testLoadInitialize
//
//  Created by yangjun zhu on 15/5/4.
//  Copyright (c) 2015年 ouka. All rights reserved.
//

#import "SuperClass.h"

@implementation SuperClass
+ (void) initialize {
     NSLog(@"%@ %s", [self class], __FUNCTION__);
 }


 + (void) load {
   NSLog(@"%@ %s", [self class], __FUNCTION__);
}
@end
