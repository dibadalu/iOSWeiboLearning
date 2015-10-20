//
//  ZJAccount.m
//  ZJWeibo
//
//  Created by dibadalu on 15/10/20.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import "ZJAccount.h"
#import <MJExtension.h>

@implementation ZJAccount

+ (instancetype)accountWithDict:(NSDictionary *)dict
{
    ZJAccount *account = [[self alloc] init];
    account.access_token = dict[@"access_token"];
    account.expires_in = dict[@"expires_in"];
    account.uid = dict[@"uid"];
    //获得账号存储的时间（accessToken的产生时间），并将其存储到模型中
    account.created_time = [NSDate date];
    
    return account;
}

/**
 归档的实现
 */
MJCodingImplementation

@end
