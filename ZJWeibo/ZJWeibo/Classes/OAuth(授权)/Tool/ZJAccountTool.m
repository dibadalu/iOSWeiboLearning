//
//  ZJAccountTool.m
//  ZJWeibo
//
//  Created by dibadalu on 15/10/20.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//


//账号的存储路径
#define HMAccountPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account.archive"]

#import "ZJAccountTool.h"
#import "ZJAccount.h"

@implementation ZJAccountTool

/**
 *  存储账号信息
 *
 *  @param account 账号模型
 */
+ (void)saveAccount:(ZJAccount *)account
{
    //对象存进沙盒要用NSKeyedArchiver，不能再用writeToFile
    [NSKeyedArchiver archiveRootObject:account toFile:HMAccountPath];
}

/**
 *  返回账号信息
 *
 *  @return 账号模型（如果账号过期，返回nil）
 */
+ (ZJAccount *)account
{
    
    //加载账号数据模型
    ZJAccount *account = [NSKeyedUnarchiver unarchiveObjectWithFile:HMAccountPath];
    
    /*  验证账号是否过期 */
    
    //过期的秒数
    long long expires_in = [account.expires_in longLongValue];
    //获得过期时间
    NSDate *expiresTime = [account.created_time dateByAddingTimeInterval:expires_in];
    //获得当前时间
    NSDate *now = [NSDate date];
    
    //如果expiresTime <=  now 过期
    /*
     NSOrderedAscending = -1L, 升序，左边 < 右边
     NSOrderedSame, 一样
     NSOrderedDescending  降序，左边 > 右边
     */
    NSComparisonResult result = [expiresTime compare:now];
    if (result != NSOrderedDescending) { //过期
        return nil;
    }
    
    //    HMLog(@"%@--%@",expiresTime,now);
    
    return account;
}


@end
