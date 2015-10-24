//
//  ZJComposeToolBar.m
//  ZJWeibo
//
//  Created by dibadalu on 15/10/24.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import "ZJComposeToolBar.h"

@implementation ZJComposeToolBar
#pragma mark - 系统方法
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"compose_toolbar_background"]];
        
        //初始化toolBar的按钮
        [self setupOneBtn:@"compose_camerabutton_background" highImage:@"compose_camerabutton_background_highlighted"];
        [self setupOneBtn:@"compose_toolbar_picture" highImage:@"compose_toolbar_picture_highlighted"];
        [self setupOneBtn:@"compose_trendbutton_background" highImage:@"compose_trendbutton_background_highlighted"];
        [self setupOneBtn:@"compose_mentionbutton_background" highImage:@"compose_mentionbutton_background_highlighted"];
        [self setupOneBtn:@"compose_emoticonbutton_background" highImage:@"compose_emoticonbutton_background_highlighted"];
        
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
- (void)setupOneBtn:(NSString *)image highImage:(NSString *)highImage
{
    UIButton *btn = [[UIButton alloc] init];
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    
    [self addSubview:btn];
    
}



@end
