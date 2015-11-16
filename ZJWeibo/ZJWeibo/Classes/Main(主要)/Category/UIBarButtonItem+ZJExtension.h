//
//  UIBarButtonItem+ZJExtension.h
//  ZJWeibo
//
//  Created by dibadalu on 15/10/19.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//  提取创建UIBarButtonItem按钮的代码

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (ZJExtension)

+ (UIBarButtonItem *)itemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action;
+ (UIBarButtonItem *)itemWithImage:(NSString *)image disabledImage:(NSString *)disabledImage target:(id)target action:(SEL)action;
@end
