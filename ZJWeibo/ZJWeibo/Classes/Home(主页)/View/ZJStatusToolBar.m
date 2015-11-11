//
//  ZJStatusToolBar.m
//  ZJWeibo
//
//  Created by dibadalu on 15/10/23.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//



#import "ZJStatusToolBar.h"
#import "ZJStatus.h"


@interface ZJStatusToolBar ()

@property (nonatomic, weak) UIButton *repostBtn;
@property (nonatomic, weak) UIButton *commentBtn;
@property (nonatomic, weak) UIButton *attitudeBtn;

/** 里面存放所有的按钮 */
@property(nonatomic,strong) NSMutableArray *btns;

/** 里面存放所有的分割线 */
@property(nonatomic,strong) NSMutableArray *dividers;

@end

@implementation ZJStatusToolBar
#pragma mark - lazy method
- (NSMutableArray *)btns
{
    if (!_btns) {
        self.btns = [NSMutableArray array];
    }
    return _btns;
}

- (NSMutableArray *)dividers
{
    if (!_dividers) {
        self.dividers = [NSMutableArray array];
    }
    return _dividers;
}

#pragma mark - class method
+ (instancetype)tooBar
{
    ZJStatusToolBar *toolBar = [[self alloc] init];
//    toolBar.backgroundColor = [UIColor yellowColor];
    return toolBar;
}

#pragma mark - system method
/**
 *  只调用一次，添加所有子控件
 */
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //设置toolBar的背景颜色
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"timeline_card_bottom_background"]];
    
        //添加toolBar的子控件
        self.repostBtn = [self addBtn:@"转发" iconName:@"timeline_icon_retweet"];
        self.commentBtn = [self addBtn:@"评论" iconName:@"timeline_icon_comment"];
        self.attitudeBtn = [self addBtn:@"赞" iconName:@"timeline_icon_unlike"];
        
        //添加分割线
        [self setupDivider];
        [self setupDivider];
    }
    
    return self;
}
/**
 *  在layoutSubviews方法中设置子控件的位置和尺寸
 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //设置按钮的frame
    int btnCount =(int) self.btns.count;
    CGFloat btnW = self.width / btnCount;
    CGFloat btnH = self.height;
    for (int i = 0; i< btnCount; i++) {
        UIButton *btn = self.subviews[i];
        btn.x = i * btnW;
        btn.y = 0;
        btn.width = btnW;
        btn.height = btnH;
    }
    
    //设置分割线的frame
    int dividerCount =(int) self.dividers.count;
    for (int i = 0; i< dividerCount; i++) {
        UIImageView *divider = self.dividers[i];
        divider.width = 1;
        divider.height = btnH;
        divider.x = (i + 1) * btnW;
        divider.y = 0;
        
    }
    
}

#pragma mark - init method
/**
 *  添加toolBar的子控件
 *
 *  @param title    按钮文字
 *  @param iconName 按钮图片
 */
- (UIButton *)addBtn:(NSString *)title iconName:(NSString *)iconName
{
    UIButton *btn = [[UIButton alloc] init];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    [btn setImage:[UIImage imageNamed:iconName] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"timeline_card_bottom_background_highlighted"] forState:UIControlStateHighlighted];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:btn];
    
    [self.btns addObject:btn];
    

    return btn;
}

/**
 *  添加分割线
 */
- (void)setupDivider
{
    UIImageView *divider = [[UIImageView alloc] init];
    divider.image = [UIImage imageNamed:@"timeline_card_bottom_line"];
    [self addSubview:divider];
    
    [self.dividers addObject:divider];
}

#pragma mark - setter method 
/**
 *  微博模型的setter方法，设置按钮上的数字
 *
 *  @param status 从cell传进来的微博模型
 */
- (void)setStatus:(ZJStatus *)status
{
    _status = status;

    //转发
    [self setupBtnCount:status.reposts_count btn:self.repostBtn title:@"转发"];
    //评论
    [self setupBtnCount:status.comments_count btn:self.commentBtn title:@"评论"];
    //赞
    [self setupBtnCount:status.attitudes_count btn:self.attitudeBtn title:@"赞"];
}

- (void)setupBtnCount:(int)count  btn:(UIButton *)btn title:(NSString *)title
{
    
    if (count) {//数字不为0
        if (count < 10000) {// 不足10000：直接显示数字，比如786、7986
            title = [NSString stringWithFormat:@"%d",count];
        }else{// 达到10000：显示xx.x万，不要有.0的情况
            double wan = count/10000.0;
            title = [NSString stringWithFormat:@"%.1f万",wan];
            // 将字符串里面的.0去掉
            title = [title stringByReplacingOccurrencesOfString:@".0" withString:@""];
        }
        [btn setTitle:title forState:UIControlStateNormal];
        
    }
    [btn setTitle:title forState:UIControlStateNormal];
    
}

@end
