//
//  ZJEmotion.m
//  ZJWeibo
//
//  Created by dibadalu on 15/10/25.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import "ZJEmotion.h"
#import <MJExtension.h>

@interface ZJEmotion ()

@end

@implementation ZJEmotion

/**
 归档的实现,会将所有属性都归档
 */
MJCodingImplementation

/**
 *  经常用来比较两个HMEmotion对象是否一样
 *
 *  @param object 另外一个HMEmotion对象
 *
 *  @return yes代表两个对象是一样的
 */
- (BOOL)isEqual:(ZJEmotion *)other
{
    return [self.chs isEqualToString:other.chs] || [self.code isEqualToString:other.code];
}


@end
