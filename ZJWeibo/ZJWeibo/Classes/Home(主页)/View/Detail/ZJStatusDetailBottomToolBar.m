//
//  ZJStatusDetailBottomToolBar.m
//  ZJWeibo
//
//  Created by dibadalu on 15/11/2.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import "ZJStatusDetailBottomToolBar.h"

@interface ZJStatusDetailBottomToolBar ()

/** 里面存放所有的按钮 */
@property(nonatomic,strong) NSMutableArray *btns;

/** 里面存放所有的分割线 */
@property(nonatomic,strong) NSMutableArray *dividers;

@end

@implementation ZJStatusDetailBottomToolBar

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

#pragma mark - init method
/**
 *  只调用一次，添加所有子控件
 */
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //设置toolBar的背景颜色
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"statusdetail_toolbar_background"]];
        
        //添加toolBar的子控件
        [self addBtn:@"转发" iconName:@"timeline_icon_retweet"];
        [self addBtn:@"评论" iconName:@"timeline_icon_comment"];
        [self addBtn:@"赞" iconName:@"timeline_icon_unlike"];
        
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
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);//间距
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setImage:[UIImage imageNamed:iconName] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"timeline_card_bottom_background_highlighted"] forState:UIControlStateHighlighted];
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

@end
