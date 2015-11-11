//
//  ZJEmotionTabBar.m
//  ZJWeibo
//
//  Created by dibadalu on 15/10/25.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import "ZJEmotionTabBar.h"
#import "ZJEmotionTabBarButton.h"

@interface ZJEmotionTabBar ()

/** 存放被点击的按钮 */
@property(nonatomic,weak) ZJEmotionTabBarButton *selectedBtn;

@end

@implementation ZJEmotionTabBar

#pragma mark - system method
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //添加4个按钮
        [self addOneButton:@"最近" tabBarButton:ZJEmotionTabBarButtonTypeRecent];
        [self addOneButton:@"默认" tabBarButton:ZJEmotionTabBarButtonTypeDefault];
        [self addOneButton:@"Emoji" tabBarButton:ZJEmotionTabBarButtonTypeEmoji];
        [self addOneButton:@"浪小花" tabBarButton:ZJEmotionTabBarButtonTypeLxh];

    }
    return self;
}
/**
 *  设置emotionTabBar上按钮的frame
 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NSUInteger count = self.subviews.count;
    
    CGFloat btnW = self.width / count;
    CGFloat btnH = self.height;
    for (int i = 0; i< count; i++) {
        //取出按钮
        UIButton *btn = self.subviews[i];
        
        btn.width = btnW;
        btn.height = btnH;
        btn.x = i * btnW;
        btn.y = 0;
    }
    
}
/**
 *  设置代理对象
 *
 *  @param delegate 从emotionKeboard传进来的
 */
- (void)setDelegate:(id<ZJEmotionTabBarButtonDelegate>)delegate
{
    _delegate = delegate;

    //设置默认按钮
    [self btnClick:(ZJEmotionTabBarButton *)[self viewWithTag:ZJEmotionTabBarButtonTypeDefault]];
}

#pragma mark - init method
/**
 *  初始化按钮
 */
- (ZJEmotionTabBarButton *)addOneButton:(NSString *)title tabBarButton:(ZJEmotionTabBarButtonType)btnType
{
    ZJEmotionTabBarButton *btn = [[ZJEmotionTabBarButton alloc] init];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = btnType;
    [self addSubview:btn];
    
    //设置默认按钮
    if (btn.tag == ZJEmotionTabBarButtonTypeDefault) {
        [self btnClick:btn];
    }
    
    //默认的背景图片
    NSString *image = @"compose_emotion_table_mid_normal";
    NSString *seleImage = @"compose_emotion_table_mid_selected";
    if (self.subviews.count == 1) {
        image = @"compose_emotion_table_left_normal";
        seleImage = @"compose_emotion_table_left_selected";
    }else if (self.subviews.count == 4){
        image = @"compose_emotion_table_right_normal";
        seleImage = @"compose_emotion_table_right_selected";
    }
    //设置背景图片
    [btn setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:seleImage] forState:UIControlStateDisabled];
    
    
    return btn;
}

#pragma mark - action method
- (void)btnClick:(ZJEmotionTabBarButton *)btn
{
//    ZJLog(@"btnClick");
    //设置被点击按钮的状态
    self.selectedBtn.enabled = YES;//将原来的enable属性重新变回yes
    btn.enabled = NO;
    self.selectedBtn = btn;
    
    //通知代理做做事情
    if ([self.delegate respondsToSelector:@selector(emotionTabBar:didTabBarButtonType:)]) {
        [self.delegate emotionTabBar:self didTabBarButtonType:btn.tag];
    }
}



@end
