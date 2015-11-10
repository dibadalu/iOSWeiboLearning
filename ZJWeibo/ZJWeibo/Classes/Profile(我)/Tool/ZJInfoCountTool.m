//
//  ZJInfoCountTool.m
//  ZJWeibo
//
//  Created by dibadalu on 15/11/10.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import "ZJInfoCountTool.h"
#import "ZJInfoCount.h"

//存储路径
#define ZJInfoCountPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"infoCount.archive"]

@implementation ZJInfoCountTool

+ (void)saveInfoCount:(ZJInfoCount *)infoCount
{
    //对象存进沙盒要用NSKeyedArchiver，不能再用writeToFile
    [NSKeyedArchiver archiveRootObject:infoCount toFile:ZJInfoCountPath];
    
}

+ (ZJInfoCount *)infoCount
{
    //加载ZJInfoCount数据模型
    ZJInfoCount *infoCount = [NSKeyedUnarchiver unarchiveObjectWithFile:ZJInfoCountPath];
    return infoCount;
}

@end
