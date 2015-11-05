//
//  ZJBadgeView.m
//  ZJWeibo
//
//  Created by dibadalu on 15/11/5.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import "ZJBadgeView.h"

@implementation ZJBadgeView
#pragma mark - system method
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //设置文字的字体
        self.titleLabel.font = [UIFont systemFontOfSize:11];
        //设置按钮的背景图片(背景图片可以拉伸)
        [self setBackgroundImage:[UIImage resizedImageName:@"main_badge"] forState:UIControlStateNormal];
        //设置按钮的高度为当前图片的高度（宽度得视文字而定）
        self.height = self.currentBackgroundImage.size.height;
        
        
    }
    return self;
}
#pragma mark - setter
- (void)setBadgeValue:(NSString *)badgeValue
{
    _badgeValue = [badgeValue copy];
    
    //1.设置文字
    [self setTitle:badgeValue forState:UIControlStateNormal];
    //2.根据文字计算按钮的尺寸
    CGSize titleSize = [badgeValue sizeWithFont:self.titleLabel.font];
    CGFloat btnBgW = self.currentBackgroundImage.size.width;
    if (titleSize.width < btnBgW) {
        self.width = btnBgW;
    }else{
        self.width = titleSize.width + 10;
    }
    

}

@end
