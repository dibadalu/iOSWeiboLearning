//
//  ZJUserSuggestion.h
//  ZJWeibo
//
//  Created by 陈泽嘉 on 15/11/30.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

/*
 {
 "screen_name": "阿信",
 "followers_count": 2383036,
 "uid": 1265020392
 },
 */

#import <Foundation/Foundation.h>

@interface ZJUserSuggestion : NSObject

/** 用户昵称 */
@property(nonatomic,copy) NSString *screen_name;

/** 用户的粉丝数量 */
@property(nonatomic,copy) NSString *followers_count;

/** 用户的NSStringID */
@property(nonatomic,copy) NSString *uid;


@end
