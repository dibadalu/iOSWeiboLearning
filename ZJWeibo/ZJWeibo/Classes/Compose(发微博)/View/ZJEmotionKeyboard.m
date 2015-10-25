//
//  ZJEmotionKeyboard.m
//  ZJWeibo
//
//  Created by dibadalu on 15/10/25.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import "ZJEmotionKeyboard.h"
#import "ZJEmotionListView.h"
#import "ZJEmotionTabBar.h"


@interface ZJEmotionKeyboard ()<ZJEmotionTabBarButtonDelegate>

@property(nonatomic,weak) ZJEmotionListView *emotionListView;
@property(nonatomic,weak) ZJEmotionTabBar *emotionTabBar;

@end

@implementation ZJEmotionKeyboard

#pragma mark - 系统方法
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //添加子控件（emotionListView和emotionTabBar）
        ZJEmotionListView *emotionListView = [[ZJEmotionListView alloc] init];
        [self addSubview:emotionListView];
        self.emotionListView = emotionListView;
        
        ZJEmotionTabBar *emotionTabBar = [[ZJEmotionTabBar alloc] init];
        emotionTabBar.delegate = self;//设置代理
        [self addSubview:emotionTabBar];
        self.emotionTabBar = emotionTabBar;
      
    }
    return self;
}
/**
 *  设置emotionListView和emotionTabBar的尺寸和位置
 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //1.emotionTabBar
    self.emotionTabBar.width = self.width;
    self.emotionTabBar.height = 44;
    self.emotionTabBar.x = 0;
    self.emotionTabBar.y = self.height - self.emotionTabBar.height;
    
    //2.emotionListView
    self.emotionListView.width = self.width;
    self.emotionListView.height = self.height - self.emotionTabBar.height;
    self.emotionListView.x = self.emotionListView.y = 0;

}

#pragma mark - ZJEmotionTabBarButtonDelegate
- (void)emotionTabBar:(ZJEmotionTabBar *)emotionTabBar didTabBarButtonType:(ZJEmotionTabBarButtonType)btnType
{
    switch (btnType) {
        case ZJEmotionTabBarButtonTypeRecent://最近
            ZJLog(@"最近");
            break;
        case ZJEmotionTabBarButtonTypeDefault://默认
            ZJLog(@"默认");
            break;
        case ZJEmotionTabBarButtonTypeEmoji://emoji
            ZJLog(@"emoji");
            break;
        case ZJEmotionTabBarButtonTypeLxh://emoji
            ZJLog(@"emoji");
            break;
    }
}

@end
