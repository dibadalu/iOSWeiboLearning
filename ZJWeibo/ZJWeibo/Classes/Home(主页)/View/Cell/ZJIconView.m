//
//  ZJIconView.m
//  ZJWeibo
//
//  Created by dibadalu on 15/10/23.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import "ZJIconView.h"
#import "ZJUser.h"
#import <UIImageView+WebCache.h>

@interface ZJIconView ()

/** 认证图片控件 */
@property(nonatomic,weak) UIImageView *verifiedView;

@end

@implementation ZJIconView
#pragma mark - 懒加载
- (UIImageView *)verifiedView
{
    if (!_verifiedView) {
        UIImageView *verifiedView = [[UIImageView alloc] init];
        [self addSubview:verifiedView];
        self.verifiedView = verifiedView;
    }
    return _verifiedView;
}

#pragma mark - 系统方法
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

/**
 *  计算认证图片控件的位置和尺寸
 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //设置尺寸
    self.verifiedView.size = self.verifiedView.image.size;
    //设置位置
    CGFloat scale = 0.7;
    self.verifiedView.x = self.width - self.verifiedView.width * scale;
    self.verifiedView.y = self.height - self.verifiedView.height * scale;
    
}


#pragma mark - 传值
/**
 *  设置头像和认证标识
 *
 *  @param user 从cell传进来的用户模型
 */
- (void)setUser:(ZJUser *)user
{
    _user = user;
    
    //1.设置头像
    [self sd_setImageWithURL:[NSURL URLWithString:user.profile_image_url] placeholderImage:[UIImage imageNamed:@"avatar_default_small"]];
    
    //2.设置加V图片
    switch (user.verified_type) {
        case ZJUserVerifiedPersonal:// 个人认证
            self.verifiedView.hidden = NO;
            self.verifiedView.image = [UIImage imageNamed:@"avatar_vip"];
            break;
        case ZJUserVerifiedOrgEnterprice:// 企业官方：CSDN、EOE、搜狐新闻客户端
        case ZJUserVerifiedOrgMedia:// 媒体官方：程序员杂志、苹果汇
        case ZJUserVerifiedOrgWebsite:// 网站官方：猫扑
            self.verifiedView.hidden = NO;
            self.verifiedView.image = [UIImage imageNamed:@"avatar_enterprise_vip"];
            break;
        case ZJUserVerifiedDaren:// 微博达人
            self.verifiedView.hidden = NO;
            self.verifiedView.image = [UIImage imageNamed:@"avatar_grassroot"];
            break;
        default:// 默认没有任何认证
            self.verifiedView.hidden = YES;
            break;
    }

    
}

@end
