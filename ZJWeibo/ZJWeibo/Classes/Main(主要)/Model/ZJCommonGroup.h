//
//  ZJCommonGroup.h
//  ZJWeibo
//
//  Created by dibadalu on 15/11/3.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//  用一个ZJCommonGroup模型来描述每组的信息：组头、组尾、这组的所有行模型

#import <Foundation/Foundation.h>

@interface ZJCommonGroup : NSObject
/** 组头 */
@property(nonatomic,copy) NSString *header;
/** 组尾 */
@property(nonatomic,copy) NSString *footer;
/** 这组的所有行模型（数组中存放的是ZJCommonItem模型） */
@property(nonatomic,strong) NSArray *items;

+ (instancetype)group;

@end
