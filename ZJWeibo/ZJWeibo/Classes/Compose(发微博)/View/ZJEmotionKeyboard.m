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
#import "ZJEmotion.h"
#import <MJExtension.h>


@interface ZJEmotionKeyboard ()<ZJEmotionTabBarButtonDelegate>
/** 显示表情内容的容器 */
@property(nonatomic,weak) ZJEmotionListView *showingEmotionView;
/** 表情键盘上的表情类型选项卡条 */
@property(nonatomic,weak) ZJEmotionTabBar *emotionTabBar;

/** 表情内容，strong */
@property(nonatomic,strong) ZJEmotionListView *recentEmotionListView;
@property(nonatomic,strong) ZJEmotionListView *defaultEmotionListView;
@property(nonatomic,strong) ZJEmotionListView *emojiEmotionListView;
@property(nonatomic,strong) ZJEmotionListView *lxhEmotionListView;

@end

@implementation ZJEmotionKeyboard
#pragma mark - 懒加载
- (ZJEmotionListView *)recentEmotionListView
{
    if (!_recentEmotionListView) {
        self.recentEmotionListView = [[ZJEmotionListView alloc] init];
        self.recentEmotionListView.backgroundColor = ZJRandomColor;
    }
    return _recentEmotionListView;
}

- (ZJEmotionListView *)defaultEmotionListView
{
    if (!_defaultEmotionListView) {
        self.defaultEmotionListView = [[ZJEmotionListView alloc] init];
//        self.defaultEmotionListView.backgroundColor = ZJRandomColor;
        NSString *path = [[NSBundle mainBundle] pathForResource:@"defaultInfo.plist" ofType:nil];
        //字典数组-->模型数组
        self.defaultEmotionListView.emotions = [ZJEmotion objectArrayWithKeyValuesArray:[NSArray arrayWithContentsOfFile:path]];
    }
    return _defaultEmotionListView;
}

- (ZJEmotionListView *)emojiEmotionListView
{
    if (!_emojiEmotionListView) {
        self.emojiEmotionListView = [[ZJEmotionListView alloc] init];
//        self.emojiEmotionListView.backgroundColor = ZJRandomColor;
        NSString *path = [[NSBundle mainBundle] pathForResource:@"emojiInfo.plist" ofType:nil];
        //字典数组-->模型数组
        self.emojiEmotionListView.emotions = [ZJEmotion objectArrayWithKeyValuesArray:[NSArray arrayWithContentsOfFile:path]];
    }
    return _emojiEmotionListView;
}

- (ZJEmotionListView *)lxhEmotionListView
{
    if (!_lxhEmotionListView) {
        self.lxhEmotionListView = [[ZJEmotionListView alloc] init];
//        self.lxhEmotionListView.backgroundColor = ZJRandomColor;
        NSString *path = [[NSBundle mainBundle] pathForResource:@"lxhInfo.plist" ofType:nil];
        //字典数组-->模型数组
        self.lxhEmotionListView.emotions = [ZJEmotion objectArrayWithKeyValuesArray:[NSArray arrayWithContentsOfFile:path]];
    }
    return _lxhEmotionListView;
}

#pragma mark - 系统方法
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //添加子控件（emotionListView和emotionTabBar）
        ZJEmotionListView *showingEmotionView = [[ZJEmotionListView alloc] init];
        [self addSubview:showingEmotionView];
        self.showingEmotionView = showingEmotionView;
        
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
    self.showingEmotionView.width = self.width;
    self.showingEmotionView.height = self.height - self.emotionTabBar.height;
    self.showingEmotionView.x = self.showingEmotionView.y = 0;

}

#pragma mark - ZJEmotionTabBarButtonDelegate
- (void)emotionTabBar:(ZJEmotionTabBar *)emotionTabBar didTabBarButtonType:(ZJEmotionTabBarButtonType)btnType
{
    //移除emotionListView上显示的组件
    [self.showingEmotionView removeFromSuperview];
    
    switch (btnType) {
        case ZJEmotionTabBarButtonTypeRecent://最近
            ZJLog(@"最近");
            [self addSubview:self.recentEmotionListView];
            
            break;
        case ZJEmotionTabBarButtonTypeDefault://默认
            ZJLog(@"默认");
            [self addSubview:self.defaultEmotionListView];

            break;
        case ZJEmotionTabBarButtonTypeEmoji://emoji
            ZJLog(@"emoji");
            [self addSubview:self.emojiEmotionListView];

            break;
        case ZJEmotionTabBarButtonTypeLxh://emoji
            ZJLog(@"emoji");
            [self addSubview:self.lxhEmotionListView];

            break;
    }
    
    //设置emotionListView上显示的组件
    self.showingEmotionView = [self.subviews lastObject];
    
    //重新计算子控件的frame
    [self setNeedsLayout];
}

@end
