//
//  ZJProfileStatusTool.h
//  ZJWeibo
//
//  Created by dibadalu on 15/11/10.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZJProfileStatusTool : NSObject

/**
 *  根据请求参数从沙盒中加载FMDB缓存的微博数据（微博字典数组）
 *
 *  @param params 请求参数
 *
 *  @return 返回之前FMDB缓存好的微博数据（微博字典数组）
 */
+ (NSArray *)statusesWithParams:(NSDictionary *)params;

/**
 *  FMDB缓存从新浪获取的微博字典数组
 *
 *  @param statuses 从新浪获取的微博字典数组
 */
+ (void)saveStatuses:(NSArray *)statuses;

@end
