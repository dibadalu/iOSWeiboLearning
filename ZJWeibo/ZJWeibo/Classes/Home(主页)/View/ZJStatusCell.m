//
//  ZJStatusCell.m
//  ZJWeibo
//
//  Created by dibadalu on 15/10/22.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import "ZJStatusCell.h"
#import "ZJStatusFrame.h"
#import "ZJStatus.h"
#import "ZJUser.h"
#import <UIImageView+WebCache.h>

@interface ZJStatusCell ()

#pragma mark - cell的子控件weak
/* 原创微博 */
/** 原创微博整体 */
@property(nonatomic,weak) UIView *originalView;
/** 头像 */
@property(nonatomic,weak) UIImageView *iconView;
/** 会员图标 */
@property(nonatomic,weak) UIImageView *vipView;
/** 配图 */
@property(nonatomic,weak) UIImageView *photoView;
/** 昵称 */
@property(nonatomic,weak) UILabel *nameLabel;
/** 时间 */
@property(nonatomic,weak) UILabel *timeLabel;
/** 来源 */
@property(nonatomic,weak) UILabel *sourceLabel;
/** 正文 */
@property(nonatomic,weak) UILabel *contentLabel;

@end

@implementation ZJStatusCell
/**
 *  创建cell
 *
 *  @param tableView 外界的tableView
 *
 *  @return 创建好的cell
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"status";
    ZJStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[ZJStatusCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    return cell;
}

/**
 *  只调用一次，进行cell子控件的初始化
 *  1.添加有可能显示的所有cell子控件到contentView中
 *  2.设置子控件的一次性设置(label要显示必须有font)
 */
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
 
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        /* 原创微博 */
        /** 原创微博整体 */
        UIView *originalView = [[UIView alloc] init];
//        originalView.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:originalView];
        self.originalView = originalView;
        
        /** 头像 */
        UIImageView *iconView = [[UIImageView alloc] init];
        [self.contentView addSubview:iconView];
        self.iconView = iconView;
        
        /** 会员图标 */
        UIImageView *vipView = [[UIImageView alloc] init];
        [self.contentView addSubview:vipView];
        self.vipView = vipView;
        
        /** 配图 */
        UIImageView *photoView = [[UIImageView alloc] init];
        [self.contentView addSubview:photoView];
        self.photoView = photoView;
        
        /** 昵称 */
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.font = ZJStatusCellNameLableFont;
        [self.contentView addSubview:nameLabel];
        self.nameLabel = nameLabel;
        
        /** 时间 */
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.font = ZJStatusCellTimeLableFont;
        [self.contentView addSubview:timeLabel];
        self.timeLabel = timeLabel;
        
        /** 来源 */
        UILabel *sourceLabel = [[UILabel alloc] init];
        sourceLabel.font = ZJStatusCellSourceLableFont;
        [self.contentView addSubview:sourceLabel];
        self.sourceLabel = sourceLabel;
        
        /** 正文 */
        UILabel *contentLabel = [[UILabel alloc] init];
        contentLabel.font = ZJStatusCellContentLableFont;
        contentLabel.numberOfLines = 0;
        [self.contentView addSubview:contentLabel];
        self.contentLabel = contentLabel;
    }
    
    return self;

}


/**
 *  设置frame和数据
 *  cell根据StatusFrame模型给子控件设置frame，根据Status模型给子控件设置数据
 *  @param statusFrame 微博Frame模型
 */
- (void)setStatusFrame:(ZJStatusFrame *)statusFrame
{
    _statusFrame = statusFrame;
    
    //取出微博模型
    ZJStatus *status = statusFrame.status;
    //取出用户模型
    ZJUser *user = status.user;
    
    CGFloat cellW = [UIScreen mainScreen].bounds.size.width;
    
    /* 原创微博 */
    /** 原创微博整体 */
    self.originalView.frame = statusFrame.originalViewF;
    
    /** 头像 */
    self.iconView.frame = statusFrame.iconViewF;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:user.profile_image_url] placeholderImage:[UIImage imageNamed:@"avatar_default_small"]];

    /** 会员图标 */
    self.vipView.frame = statusFrame.vipViewF;
    self.vipView.image = [UIImage imageNamed:@"common_icon_membership_level1"];
    
    /** 配图 */
    self.photoView.frame = statusFrame.photoViewF;
    self.photoView.backgroundColor = [UIColor yellowColor];
    
    /** 昵称 */
    self.nameLabel.frame = statusFrame.nameLabelF;
    self.nameLabel.text = user.name;
    
    /** 时间 */
//    NSString *time = status.created_at;
//    CGFloat timeX = self.nameLabel.frame.origin.x;
//    CGFloat timeY = CGRectGetMaxY(self.nameLabel.frame) + ZJStatusCellBorderW;
//    CGSize timeSize = [time sizeWithFont:ZJStatusCellTimeLableFont];
//    self.timeLabel.frame = (CGRect){{timeX, timeY},timeSize};
    CGSize timeSize = [status.created_at sizeWithFont:ZJStatusCellTimeLableFont];
    CGFloat timeX = cellW - ZJStatusCellBorderW  - timeSize.width;
    CGFloat timeY = self.nameLabel.frame.origin.y;
    self.timeLabel.frame = (CGRect){{timeX, timeY},timeSize};
    self.timeLabel.text = status.created_at;
    
    /** 来源 */
    self.sourceLabel.frame = statusFrame.sourceLabelF;
    self.sourceLabel.text = status.source;
    
    /** 正文 */
    self.contentLabel.frame = statusFrame.contentLabelF;
    self.contentLabel.text = status.text;
    
}

@end
