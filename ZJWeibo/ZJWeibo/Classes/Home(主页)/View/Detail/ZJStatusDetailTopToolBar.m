//
//  ZJDetailTopToolBar.m
//  ZJWeibo
//
//  Created by dibadalu on 15/11/2.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import "ZJStatusDetailTopToolBar.h"

@interface ZJStatusDetailTopToolBar ()

@property (weak, nonatomic) IBOutlet UIButton *retweetedButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIButton *attitudeButton;
@property (weak, nonatomic) IBOutlet UIImageView *arrowView;
- (IBAction)btnClick:(UIButton *)button;

/** 选中按钮 */
@property(nonatomic,weak) UIButton *selectButton;

@end

@implementation ZJStatusDetailTopToolBar

#pragma mark - class method
+ (instancetype)toolBar
{
    return [[[NSBundle mainBundle] loadNibNamed:@"ZJStatusDetailTopToolBar" owner:nil options:nil] lastObject];
}

#pragma mark - system method
/**
 * 加载完nib或storyboard之后调用
 */
- (void)awakeFromNib
{
    //设置按钮的tag
    self.retweetedButton.tag = ZJStatusDetailTopToolbarButtonRetweetedType;
    self.commentButton.tag = ZJStatusDetailTopToolbarButtonCommentType;
    
}

#pragma mark - setter&getter
- (void)setDelegate:(id<ZJStatusDetailTopToolBarDelegate>)delegate
{
    _delegate = delegate;
    
    //设置默认按钮
    [self btnClick:self.commentButton];
}

#pragma mark - action method
/**
 *  按钮的监听事件
 */
- (IBAction)btnClick:(UIButton *)button {
    
//    ZJLog(@"btnClick");

    //1.控制按钮状态
    self.selectButton.selected = NO;
    button.selected = YES;
    self.selectButton = button;
    
    //2.通过动画移动三角箭头
    [UIView animateWithDuration:0.25 animations:^{
        self.arrowView.centerX = button.centerX;
    }];
    
    //3.通知代理做事情
    if ([self.delegate respondsToSelector:@selector(statusDetailTopToolBar:didSelectedButton:)]) {
        [self.delegate statusDetailTopToolBar:self didSelectedButton:button.tag];
    }
    
}
@end
