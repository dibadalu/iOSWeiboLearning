//
//  ZJInfoCount.h
//  ZJWeibo
//
//  Created by dibadalu on 15/11/9.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//  

#import <Foundation/Foundation.h>

@interface ZJInfoCount : NSObject

/** 微博数 */
@property (nonatomic, assign) int statuses_count;
/** 关注数 */
@property (nonatomic, assign) int friends_count;
/** 粉丝数 */
@property (nonatomic, assign) int followers_count;
/** 收藏数 */
@property (nonatomic, assign) int favourites_count;

@end
