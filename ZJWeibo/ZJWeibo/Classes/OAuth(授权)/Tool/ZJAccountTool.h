//
//  ZJAccountTool.h
//  ZJWeibo
//
//  Created by dibadalu on 15/10/20.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//  处理账号相关的所有操作： 存储账号，取出账号，验证账号

#import <Foundation/Foundation.h>
@class ZJAccount;

@interface ZJAccountTool : NSObject

/**
 *  存储账号信息
 *
 *  @param account 账号模型
 */
+ (void)saveAccount:(ZJAccount *)account;

/**
 *  返回账号信息
 *
 *  @return 账号模型（如果账号过期，返回nil）
 */
+ (ZJAccount *)account;

@end
