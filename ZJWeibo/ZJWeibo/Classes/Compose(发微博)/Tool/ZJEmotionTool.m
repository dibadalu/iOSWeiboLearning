//
//  ZJEmotionTool.m
//  ZJWeibo
//
//  Created by dibadalu on 15/10/26.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

//最近表情的存储路径
#define ZJRecentEmotionPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"recentEmotion.archive"]

#import "ZJEmotionTool.h"
#import "ZJEmotion.h"
#import <MJExtension.h>

@implementation ZJEmotionTool

static NSMutableArray *_recentEmotions; //静态全局变量
/**
 *  只会调用一次（从沙盒中读取表情数据，减少了I/O操作），
 */
+ (void)initialize
{
    _recentEmotions = [NSKeyedUnarchiver unarchiveObjectWithFile:ZJRecentEmotionPath];
    if (_recentEmotions == nil) {//判断emotions数组是否存在,不要写成emotion
        _recentEmotions = [NSMutableArray array];
    }
}

/**
 *  存储最近用过的模型
 */
+ (void)saveRecentEmotion:(ZJEmotion *)emotion
{
    //删除重复的表情，ZJEmotion类中重写了isEqual方法
    [_recentEmotions removeObject:emotion];
    
    //将表情模型放到数组的最前面
    [_recentEmotions insertObject:emotion atIndex:0];
    
    //将所有表情数据写入沙盒中
    [NSKeyedArchiver archiveRootObject:_recentEmotions toFile:ZJRecentEmotionPath];
}

/**
 *  返回装着HMEmotion模型的数组
 */
+ (NSArray *)recentEmotions
{
    return _recentEmotions;
}

+ (NSArray *)defaultEmotions
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"defaultInfo.plist" ofType:nil];
    //字典数组-->模型数组
    return [ZJEmotion objectArrayWithKeyValuesArray:[NSArray arrayWithContentsOfFile:path]];
}

+ (NSArray *)emojiEmotions
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"emojiInfo.plist" ofType:nil];
    //字典数组-->模型数组    
    return  [ZJEmotion objectArrayWithKeyValuesArray:[NSArray arrayWithContentsOfFile:path]];
}

+ (NSArray *)lxhEmotions
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"lxhInfo.plist" ofType:nil];
    //字典数组-->模型数组
    return [ZJEmotion objectArrayWithKeyValuesArray:[NSArray arrayWithContentsOfFile:path]];
}

/**
 *  根据chs返回相应的HMEmotion模型
 */
+ (ZJEmotion *)emotinWithChs:(NSString *)chs
{
    
    NSArray *defaults = [self defaultEmotions];
    for (ZJEmotion *emotion in defaults) {
        if ([emotion.chs isEqualToString:chs]) return emotion;
    }
    
    NSArray *lxhs = [self lxhEmotions];
    for (ZJEmotion *emotion in lxhs) {
        if ([emotion.chs isEqualToString:chs]) return emotion;
    }
    
    return nil;
}



@end
