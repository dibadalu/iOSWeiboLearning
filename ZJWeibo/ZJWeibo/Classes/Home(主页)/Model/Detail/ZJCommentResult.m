//
//  ZJStatusDetailComment.m
//  ZJWeibo
//
//  Created by dibadalu on 15/11/2.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import "ZJCommentResult.h"
#import <MJExtension.h>
#import "ZJComment.h"

@implementation ZJCommentResult

/**
 *  告知系统comments存放的是评论模型
 */
+ (NSDictionary *)objectClassInArray
{
    return @{@"comments" : [ZJComment class]};
    
}

@end
