//
//  ZJRepostResult.m
//  ZJWeibo
//
//  Created by dibadalu on 15/11/2.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import "ZJRepostResult.h"
#import <MJExtension.h>
#import "ZJStatus.h"

@implementation ZJRepostResult

/**
 *  告知系统reposts存放的是ZJStatus模型
 */
+ (NSDictionary *)objectClassInArray
{
    return @{@"reposts" : [ZJStatus class]};
}

@end
