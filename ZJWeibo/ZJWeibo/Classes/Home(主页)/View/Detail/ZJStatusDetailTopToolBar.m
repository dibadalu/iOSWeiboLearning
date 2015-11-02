//
//  ZJDetailTopToolBar.m
//  ZJWeibo
//
//  Created by dibadalu on 15/11/2.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import "ZJStatusDetailTopToolBar.h"
#import "ZJStatus.h"

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

/**
 *  微博模型的setter方法，设置按钮上的数字
 *
 *  @param status 从cell传进来的微博模型
 */
- (void)setStatus:(ZJStatus *)status
{
    _status = status;
    
    //转发
    [self setupBtnCount:status.reposts_count btn:self.retweetedButton title:@"转发"];
    //评论
    [self setupBtnCount:status.comments_count btn:self.commentButton title:@"评论"];
    //赞
    [self setupBtnCount:status.attitudes_count btn:self.attitudeButton title:@"赞"];
}

- (void)setupBtnCount:(int)count  btn:(UIButton *)btn title:(NSString *)title
{
    
    if (count) {//数字不为0
        if (count < 10000) {// 不足10000：直接显示数字，比如786、7986
            title = [NSString stringWithFormat:@"%@ %d",title,count];
        }else{// 达到10000：显示xx.x万，不要有.0的情况
            double wan = count/10000.0;
            title = [NSString stringWithFormat:@"%@ %.1f万",title,wan];
            // 将字符串里面的.0去掉
            title = [title stringByReplacingOccurrencesOfString:@".0" withString:@""];
        }
        
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitle:title forState:UIControlStateSelected];

    }
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateSelected];

    
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
