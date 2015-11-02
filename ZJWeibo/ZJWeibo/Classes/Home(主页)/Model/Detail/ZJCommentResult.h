//
//  ZJStatusDetailComment.h
//  ZJWeibo
//
//  Created by dibadalu on 15/11/2.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//  评论结果集

#import <Foundation/Foundation.h>

@interface ZJCommentResult : NSObject

/** 评论数组 */
@property (nonatomic, strong) NSArray *comments;
/** 评论总数 */
@property (nonatomic, assign) int total_number;

@end
