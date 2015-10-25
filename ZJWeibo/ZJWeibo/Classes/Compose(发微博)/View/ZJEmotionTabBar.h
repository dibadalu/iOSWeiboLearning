//
//  ZJEmotionTabBar.h
//  ZJWeibo
//
//  Created by dibadalu on 15/10/25.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//  表情键盘上的表情类型选卡项条

typedef enum {
    ZJEmotionTabBarButtonTypeRecent,//最近
    ZJEmotionTabBarButtonTypeDefault,//默认
    ZJEmotionTabBarButtonTypeEmoji,//Emoji
    ZJEmotionTabBarButtonTypeLxh//浪小花
}ZJEmotionTabBarButtonType;

#import <UIKit/UIKit.h>
@class ZJEmotionTabBar;
//声明代理协议
@protocol ZJEmotionTabBarButtonDelegate <NSObject>

@optional
- (void)emotionTabBar:(ZJEmotionTabBar *)emotionTabBar didTabBarButtonType:(ZJEmotionTabBarButtonType)btnType;

@end

@interface ZJEmotionTabBar : UIView

/** 代理属性 */
@property(nonatomic,weak) id<ZJEmotionTabBarButtonDelegate> delegate;

@end
