//
//  ZJEmotionTabBarButton.m
//  ZJWeibo
//
//  Created by dibadalu on 15/10/25.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import "ZJEmotionTabBarButton.h"

@implementation ZJEmotionTabBarButton

#pragma mark - system method
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateDisabled];
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        
    }
    return self;
}


/**
 *  按钮高亮所做的一切操作都不在了
 */
- (void)setHighlighted:(BOOL)highlighted
{
    
}

@end
