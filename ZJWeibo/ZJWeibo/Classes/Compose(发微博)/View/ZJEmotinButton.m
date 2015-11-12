//
//  ZJEmotinButton.m
//  ZJWeibo
//
//  Created by dibadalu on 15/10/26.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import "ZJEmotinButton.h"
#import "ZJEmotion.h"

@implementation ZJEmotinButton
#pragma mark - system method
/**
 * 当控件不是从xib、storyboard中创建时，就会调用这个方法
 */
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //        HMLog(@"initWithFrame");
        [self setup];
    }
    return self;
}
/**
 * 当控件从xib、storyboard中创建时，就会调用这个方法
 */
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super initWithCoder:decoder]) {
        //        HMLog(@"initWithCoder");
        [self setup];
    }
    return self;
}

/**
 * 当initWithCoder调用完毕后就会调用这个方法
 */
- (void)awakeFromNib
{
    //    HMLog(@"awakeFromNib");
}

#pragma init method 
- (void)setup
{
    //一次性设置
    self.titleLabel.font = [UIFont systemFontOfSize:32];
    //按钮高亮的时候，不要去调整图片变灰色
    self.adjustsImageWhenHighlighted = NO;
}

#pragma mark - setter method
- (void)setEmotion:(ZJEmotion *)emotion
{
    _emotion = emotion;
    
    //设置按钮的表情图标
    if (emotion.png) {
        [self setImage:[UIImage imageNamed:emotion.png] forState:UIControlStateNormal];
    }else if (emotion.code){
        //设置emoji
        [self setTitle:emotion.code.emoji forState:UIControlStateNormal];
    }
 
}

@end

/*
 //设置按钮的表情图标(疑点：测试)
 if (emotion.png) {
 ZJLog(@"%@",emotion.png);
 UIImage *imageTest = [UIImage imageNamed:emotion.png];
 if (imageTest) {
 [self setImage:[UIImage imageNamed:emotion.png] forState:UIControlStateNormal];
 }else{
 ZJLog(@"why is my image object nil?");
 }
 ZJLog(@"%@",self.currentImage);
 }else if (emotion.code){
 //设置emoji
 ZJLog(@"%@",emotion.code);
 [self setTitle:emotion.code.emoji forState:UIControlStateNormal];
 self.titleLabel.font = [UIFont systemFontOfSize:32];
 ZJLog(@"%@",self.currentTitle);
 }
 */
