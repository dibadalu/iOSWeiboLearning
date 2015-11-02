//
//  ZJRepostResult.h
//  ZJWeibo
//
//  Created by dibadalu on 15/11/2.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//  转发结果集

#import <Foundation/Foundation.h>

@interface ZJRepostResult : NSObject

/** 转发数组 */
@property (nonatomic, strong) NSArray *reposts;
/** 转发总数 */
@property (nonatomic, assign) int total_number;

@end
