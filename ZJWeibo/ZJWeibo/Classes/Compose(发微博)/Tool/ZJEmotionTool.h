//
//  ZJEmotionTool.h
//  ZJWeibo
//
//  Created by dibadalu on 15/10/26.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZJEmotion;

@interface ZJEmotionTool : NSObject

/** 存储最近用过的模型 */
+ (void)saveRecentEmotion:(ZJEmotion *)emotion;
/** 返回最近用过的模型 */
+ (NSArray *)recentEmotions;

/** 返回默认用过的模型 */
+ (NSArray *)defaultEmotions;
/** 返回emoji用过的模型 */
+ (NSArray *)emojiEmotions;
/** 返回lxh用过的模型 */
+ (NSArray *)lxhEmotions;

@end
