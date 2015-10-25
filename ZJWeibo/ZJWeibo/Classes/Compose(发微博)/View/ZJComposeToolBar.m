//
//  ZJComposeToolBar.m
//  ZJWeibo
//
//  Created by dibadalu on 15/10/24.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import "ZJComposeToolBar.h"

@interface ZJComposeToolBar ()

@property(nonatomic,weak) UIButton *emotionBtn;

@end

@implementation ZJComposeToolBar
#pragma mark - 系统方法
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"compose_toolbar_background"]];
        
        //初始化toolBar的按钮
        [self setupOneBtn:@"compose_camerabutton_background" highImage:@"compose_camerabutton_background_highlighted" buttonType:ZJComposeToolbarButtonTypeCamera];
        [self setupOneBtn:@"compose_toolbar_picture" highImage:@"compose_toolbar_picture_highlighted" buttonType:ZJComposeToolbarButtonTypePicture];
        [self setupOneBtn:@"compose_trendbutton_background" highImage:@"compose_trendbutton_background_highlighted" buttonType:ZJComposeToolbarButtonTypeTrend];
        [self setupOneBtn:@"compose_mentionbutton_background" highImage:@"compose_mentionbutton_background_highlighted" buttonType:ZJComposeToolbarButtonTypeMention];
        self.emotionBtn = [self setupOneBtn:@"compose_emoticonbutton_background" highImage:@"compose_emoticonbutton_background_highlighted" buttonType:ZJComposeToolbarButtonTypeEmotion];
        
    }
    
    return self;
}

/**
 *  设置toolBar按钮的frame
 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NSUInteger btnCount = self.subviews.count;
    CGFloat btnW = self.width / btnCount;
    CGFloat btnH = self.height;
    for (int i = 0; i< btnCount; i++) {
        //取出btn
        UIButton *btn = self.subviews[i];
        btn.x = i * btnW;
        btn.y = 0;
        btn.width = btnW;
        btn.height = btnH;
    }
    
}

#pragma mark - 初始化方法
- (UIButton *)setupOneBtn:(NSString *)image highImage:(NSString *)highImage buttonType:(ZJComposeToolbarButtonType)buttonType
{
    UIButton *btn = [[UIButton alloc] init];
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = buttonType;
    [self addSubview:btn];
    
    return btn;
    
}

#pragma mark - 点击事件
- (void)btnClick:(UIButton *)btn
{
    //通知代理做事情
    if ([self.delegate respondsToSelector:@selector(composeToolBar:didClickbuttonType:)]) {
        [self.delegate composeToolBar:self didClickbuttonType:btn.tag];
    }

}

#pragma mark - 其他方法
/**
 *  是否显示键盘按钮
 *
 *  @param showKeyboardButton 从控制器传进来的布尔值
 */
- (void)setShowKeyboardButton:(BOOL)showKeyboardButton
{
    _showKeyboardButton = showKeyboardButton;
    
    if (showKeyboardButton) {//显示键盘按钮
        [self.emotionBtn setImage:[UIImage imageNamed:@"compose_keyboardbutton_background"] forState:UIControlStateNormal];
        [self.emotionBtn setImage:[UIImage imageNamed:@"compose_keyboardbutton_background_highlighted"] forState:UIControlStateHighlighted];
    }else{//显示表情按钮
        [self.emotionBtn setImage:[UIImage imageNamed:@"compose_emoticonbutton_background"] forState:UIControlStateNormal];
        [self.emotionBtn setImage:[UIImage imageNamed:@"compose_emoticonbutton_background_highlighted"] forState:UIControlStateHighlighted];
    }
}




@end
