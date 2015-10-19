//
//  UIBarButtonItem+ZJExtension.m
//  ZJWeibo
//
//  Created by dibadalu on 15/10/19.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import "UIBarButtonItem+ZJExtension.h"
#import "UIView+ZJExtension.h"

@implementation UIBarButtonItem (ZJExtension)


+ (UIBarButtonItem *)itemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action
{
    UIButton *button = [[UIButton alloc] init];
    [button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
//    CGSize imageSize = button.currentBackgroundImage.size;
//    button.frame = CGRectMake(0, 0, imageSize.width, imageSize.height);
    button.size = button.currentBackgroundImage.size;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

@end
