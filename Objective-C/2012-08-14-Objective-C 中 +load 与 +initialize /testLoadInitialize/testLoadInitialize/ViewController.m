//
//  ViewController.m
//  testLoadInitialize
//
//  Created by yangjun zhu on 15/5/4.
//  Copyright (c) 2015年 ouka. All rights reserved.
//

#import "ViewController.h"
#import "ChildClass.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [ChildClass load];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
