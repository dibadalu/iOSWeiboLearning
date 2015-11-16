//
//  ZJFavorites.h
//  ZJWeibo
//
//  Created by dibadalu on 15/11/16.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZJStatus;

@interface ZJFavorites : NSObject

/** 微博模型数据（ZJStatus） */
@property(nonatomic,strong) ZJStatus *status;
/** 微博收藏数 */
@property(nonatomic,assign) int total_number;
@end
