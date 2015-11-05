//
//  ZJCommonItem.m
//  ZJWeibo
//
//  Created by dibadalu on 15/11/3.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import "ZJCommonItem.h"

@implementation ZJCommonItem

+ (instancetype)itemWithTitle:(NSString *)title icon:(NSString *)icon
{
    ZJCommonItem *item = [[self alloc] init];
    item.title = title;
    item.icon = icon;
    return item;
}
+ (instancetype)itemWithTitle:(NSString *)title
{
    return [self itemWithTitle:title icon:nil];
}

@end
