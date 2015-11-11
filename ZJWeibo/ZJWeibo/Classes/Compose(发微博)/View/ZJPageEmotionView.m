//
//  ZJPageEmotionView.m
//  ZJWeibo
//
//  Created by dibadalu on 15/10/26.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import "ZJPageEmotionView.h"
#import "ZJEmotion.h"
#import "ZJEmotinButton.h"
#import "ZJEmotionTool.h"

@interface ZJPageEmotionView ()

@property(nonatomic,weak) UIButton *deleteButton;

@end

@implementation ZJPageEmotionView
#pragma mark - system method
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //1.添加删除按钮
        UIButton *deleteButton = [[UIButton alloc] init];
        [deleteButton setImage:[UIImage imageNamed:@"compose_emotion_delete"] forState:UIControlStateNormal];
        [deleteButton setImage:[UIImage imageNamed:@"compose_emotion_delete_highlighted"] forState:UIControlStateHighlighted];
        //监听按钮点击
        [deleteButton addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:deleteButton];
        self.deleteButton = deleteButton;
    
    }
    return self;
}
/**
 *  设置子控件的frame
 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //设置按钮的frame
    NSUInteger count = self.emotions.count;
    //内边距（四周）
    CGFloat padding = 10;
    CGFloat btnW = (self.width - 2 * padding) / ZJEmotionMaxCols;
    CGFloat btnH = (self.height -  padding) / ZJEmotionMaxRows;
    for (int i = 0; i< count; i++) {
        //取出按钮
        UIButton *btn = self.subviews[i + 1];//删除按钮在0，排除它

        btn.width = btnW;
        btn.height = btnH;
        //列(余数)
        int col = i % ZJEmotionMaxCols;
        btn.x = padding +  btnW * col;
        //行（商）
        int cow = i / ZJEmotionMaxCols;
        btn.y = padding + btnH *cow;
        
    }
    
    //设置删除按钮的frame
    self.deleteButton.width = btnW;
    self.deleteButton.height = btnH;
    self.deleteButton.y = self.height - btnH;
    self.deleteButton.x = self.width - btnW - padding;
}

#pragma mark - setter method
/**
 *  添加按钮，设置表情图标
 *
 *  @param emotions 从scrollView传进来的被截取过的ZJMotion模型数组
 */
- (void)setEmotions:(NSArray *)emotions
{
    _emotions = emotions;
    
    NSUInteger count = emotions.count;
    //添加按钮
    for (int i = 0; i< count; i++) {
        ZJEmotinButton *btn = [[ZJEmotinButton alloc] init];
//        btn.backgroundColor = ZJRandomColor;
        //将模型传给btn
        btn.emotion = emotions[i];
        //监听事件
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:btn];
    }
    
}

#pragma mark - action method 
- (void)btnClick:(ZJEmotinButton *)btn
{
//    ZJLog(@"btnClick");
    //存储表情模型数组
    [ZJEmotionTool saveRecentEmotion:btn.emotion];
    
   //发出通知(携带被点击表情按钮的模型数据)
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[ZJSelectEmotion] = btn.emotion;
    [ZJNotificationCenter postNotificationName:ZJEmotionDidSelectNotification object:nil userInfo:userInfo];
    
}

- (void)deleteBtnClick
{
//    ZJLog(@"deleteBtnClick");
    //发出通知
    [ZJNotificationCenter postNotificationName:ZJEmotionDidDeleteNotification object:nil userInfo:nil];
}

@end
