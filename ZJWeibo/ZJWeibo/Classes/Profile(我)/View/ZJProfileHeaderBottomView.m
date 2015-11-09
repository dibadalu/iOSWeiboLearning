//
//  ZJProfileHeaderBottomView.m
//  ZJWeibo
//
//  Created by dibadalu on 15/11/9.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import "ZJProfileHeaderBottomView.h"

@implementation ZJProfileHeaderBottomView


+ (instancetype)headerBottomView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"ZJProfileHeaderBottomView" owner:nil options:nil] lastObject];
}

#pragma mark - system method
/**
 * 加载完nib或storyboard之后调用
 */
- (void)awakeFromNib
{
    
}


@end
