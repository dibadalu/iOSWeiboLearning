//
//  ZJOneViewController.m
//  ZJWeibo
//
//  Created by dibadalu on 15/11/5.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import "ZJOneViewController.h"

@implementation ZJOneViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIView *oneView = [[UIView alloc] init];
    oneView.frame = self.view.bounds;
    oneView.backgroundColor = [UIColor redColor];
    [self.view addSubview:oneView];
}

@end
