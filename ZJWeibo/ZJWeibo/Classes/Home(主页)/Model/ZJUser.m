//
//  ZJUser.m
//  ZJWeibo
//
//  Created by dibadalu on 15/10/20.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//  

#import "ZJUser.h"
#import <MJExtension.h>

@implementation ZJUser

/**
 *  从外界传进来的mbtype判断是否是会员
 */
- (void)setMbtype:(int)mbtype
{
    _mbtype = mbtype;
    
    self.vip = mbtype > 2;
}

/**
 *  告知系统属性descriptionText存放的是description键值
 */
+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"descriptionText" : @"description"};
    
}



@end
