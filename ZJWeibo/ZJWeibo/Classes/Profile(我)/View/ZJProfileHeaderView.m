//
//  ZJProfileHeaderView.m
//  ZJWeibo
//
//  Created by dibadalu on 15/11/6.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import "ZJProfileHeaderView.h"
#import "ZJAccount.h"
#import <UIImageView+WebCache.h>
#import "ZJProfileHeaderBottomView.h"


#define ZJProfileNameFont [UIFont systemFontOfSize:18]
#define ZJProfileDetailFont [UIFont systemFontOfSize:10]

@interface ZJProfileHeaderView ()

@property(nonatomic,weak) UIButton *topView;
@property(nonatomic,weak) UIImageView *iconView;
@property(nonatomic,weak) UILabel *nameLabel;
@property(nonatomic,weak) UILabel *detailLabel;

@property(nonatomic,weak) ZJProfileHeaderBottomView *bottomView;

@end

@implementation ZJProfileHeaderView

#pragma mark - system method
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        //初始化子控件
        
        //添加topView
        [self setupTopView];
        
        //添加bottomView
        [self setupBottomView];
        
    }
    return self;
}

/**
 *  设置子控件的frame
 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //topView
    CGFloat topX = 0;
    CGFloat topY = 0;
    CGFloat topW = self.width;
    CGFloat topH = 60;
    self.topView.frame = CGRectMake(topX, topY, topW, topH);
    
    //头像
    CGFloat iconX = ZJStatusCellBorderW;
    CGFloat iconY = ZJStatusCellBorderW * 0.2;
    CGFloat iconWH = 55;
    self.iconView.frame = CGRectMake(iconX, iconY, iconWH, iconWH);
    
    //昵称
    CGFloat nameX = CGRectGetMaxX(self.iconView.frame) + ZJStatusCellBorderW;
    CGFloat nameY = iconY;
    CGSize nameSize = [self.account.name sizeWithFont:ZJProfileNameFont];
    self.nameLabel.frame = (CGRect){{nameX,nameY},nameSize};
    
    //简介
    CGFloat detailX = nameX;
    CGFloat detailY = CGRectGetMaxY(self.nameLabel.frame) + ZJStatusCellBorderW * 0.1;
    CGFloat maxW = ZJScreenW - self.iconView.width ;
    CGSize detailSize = [self.account.descriptionText boundingRectWithSize:CGSizeMake(maxW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:nil context:nil].size;
    self.detailLabel.frame = (CGRect){{detailX,detailY},detailSize};
   
    //bottomView
    CGFloat bottomX = 0;
    CGFloat bottomY = CGRectGetMaxY(self.topView.frame);
    CGFloat bottomW = self.width;
    CGFloat bottomH = self.height - self.topView.height;
    self.bottomView.frame = CGRectMake(bottomX, bottomY, bottomW, bottomH);
    
}

#pragma mark - init method 
- (void)setupTopView
{
    //topView
    UIButton *topView = [[UIButton alloc] init];
    [topView addTarget:self action:@selector(topViewBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:topView];
    self.topView = topView;
    
    //1.头像
    UIImageView *iconView = [[UIImageView alloc] init];
    [topView addSubview:iconView];
    self.iconView = iconView;
    
    //2.昵称
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = ZJProfileNameFont;
    [topView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    //3.简介
    UILabel *detailLabel = [[UILabel alloc] init];
    detailLabel.font = ZJProfileDetailFont;
    detailLabel.numberOfLines = 0;
    [topView addSubview:detailLabel];
    self.detailLabel = detailLabel;
    
}

- (void)setupBottomView
{
    //bottomView
    ZJProfileHeaderBottomView *bottomView = [ZJProfileHeaderBottomView headerBottomView];
    [self addSubview:bottomView];
    self.bottomView = bottomView;
}

#pragma mark - setter
- (void)setAccount:(ZJAccount *)account
{
    _account = account;
    
    //头像
    NSString *iconName = account.profile_image_url;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:iconName] placeholderImage:[UIImage imageNamed:@"avatar_default_small"]];
    
    //昵称
    self.nameLabel.text = account.name;
    
    //简介
    self.detailLabel.text = [NSString stringWithFormat:@"简介: %@",account.descriptionText];
    
}

- (void)setInfoCount:(ZJInfoCount *)infoCount
{
    _infoCount = infoCount;
    
    self.bottomView.infoCount = infoCount;
}

#pragma mark - action method
- (void)topViewBtnClick
{
//    ZJLog(@"topViewBtnClick");

    //通知代理做事情
    if ([self.delegate respondsToSelector:@selector(profileHeaderView:)]) {
        [self.delegate profileHeaderView:self];
    }
}

@end
