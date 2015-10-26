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
//#import <UIImageView+WebCache.h>
#import "ZJPhoto.h"
#import "ZJStatusToolBar.h"
#import "ZJStatusPhotosView.h"
#import "ZJIconView.h"
#import "ZJStatusTextView.h"

@interface ZJStatusCell ()

#pragma mark - cell的子控件weak
/* 原创微博 */
/** 原创微博整体 */
@property(nonatomic,weak) UIView *originalView;
/** 头像 */
@property(nonatomic,weak) ZJIconView *iconView;
/** 会员图标 */
@property(nonatomic,weak) UIImageView *vipView;
/** 配图 */
@property(nonatomic,weak) ZJStatusPhotosView *photosView;
/** 昵称 */
@property(nonatomic,weak) UILabel *nameLabel;
/** 时间 */
@property(nonatomic,weak) UILabel *timeLabel;
/** 来源 */
@property(nonatomic,weak) UILabel *sourceLabel;
/** 正文 */
@property(nonatomic,weak) ZJStatusTextView *contentLabel;


/* 转发微博 */
/** 转发微博整体 */
@property(nonatomic,weak) UIView *retweetedView;
/** 配图 */
@property(nonatomic,weak) ZJStatusPhotosView *retweetedphotosView;
/** 昵称+正文 */
@property(nonatomic,weak) ZJStatusTextView *retweetedContentLabel;

/** 工具条 */
@property(nonatomic,weak) ZJStatusToolBar *toolBar;

@end

@implementation ZJStatusCell

#pragma mark - 创建方法
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

#pragma mark - 系统方法
/**
 *  只调用一次，进行cell子控件的初始化
 *  1.添加有可能显示的所有cell子控件到contentView中
 *  2.设置子控件的一次性设置(label要显示必须有font)
 */
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
 
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;//选中cell不要变色
        
        //初始化原创微博
        [self setupOriginal];
        
        //初始化转发微博
        [self setupRetweet];
        
        //初始化工具条
        [self setupToolBar];
    }
    
    return self;

}

#pragma mark - 初始化方法
/**
 *  初始化原创微博
 */
- (void)setupOriginal
{
    /* 原创微博 */
    /** 原创微博整体 */
    UIView *originalView = [[UIView alloc] init];
    //        originalView.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:originalView];
    self.originalView = originalView;
    
    /** 头像 */
    ZJIconView *iconView = [[ZJIconView alloc] init];
    [self.contentView addSubview:iconView];
    self.iconView = iconView;
    
    /** 会员图标 */
    UIImageView *vipView = [[UIImageView alloc] init];
    [self.contentView addSubview:vipView];
    self.vipView = vipView;
    
    /** 配图 */
    ZJStatusPhotosView *photosView = [[ZJStatusPhotosView alloc] init];
    [self.contentView addSubview:photosView];
    self.photosView = photosView;
    
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
    
    /** 正文 */
    ZJStatusTextView *contentLabel = [[ZJStatusTextView alloc] init];
    contentLabel.font = ZJStatusCellContentLableFont;
//    contentLabel.numberOfLines = 0;
    [self.contentView addSubview:contentLabel];
    self.contentLabel = contentLabel;
    
    /** 来源 */
    UILabel *sourceLabel = [[UILabel alloc] init];
    sourceLabel.font = ZJStatusCellSourceLableFont;
    [self.contentView addSubview:sourceLabel];
    self.sourceLabel = sourceLabel;
}
/**
 *  初始化转发微博
 */
- (void)setupRetweet
{
    /* 转发微博 */
    /** 转发微博整体 */
    UIView *retweetedView = [[UIView alloc] init];
    retweetedView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
    [self.contentView addSubview:retweetedView];
    self.retweetedView = retweetedView;
    
    /** 昵称+正文 */
    ZJStatusTextView *retweetedContentLabel = [[ZJStatusTextView alloc] init];
    retweetedContentLabel.font = ZJRetweetedStatusCellContentLableFont;
//    retweetedContentLabel.numberOfLines = 0;
    [retweetedView addSubview:retweetedContentLabel];
    self.retweetedContentLabel = retweetedContentLabel;
    
    /** 配图 */
    ZJStatusPhotosView *retweetedphotosView = [[ZJStatusPhotosView alloc] init];
    [retweetedView addSubview:retweetedphotosView];
    self.retweetedphotosView = retweetedphotosView;
}
/**
 *  初始化工具条
 */
- (void)setupToolBar
{
    ZJStatusToolBar *toolBar = [ZJStatusToolBar tooBar];
    [self.contentView addSubview:toolBar];
    self.toolBar = toolBar;
}

#pragma mark - 传值
/**
 *  设置frame和数据
 *  cell根据StatusFrame模型给子控件设置frame，根据Status模型给子控件设置数据
 *  @param statusFrame 微博Frame模型 从控制器传进来的
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
//    [self.iconView sd_setImageWithURL:[NSURL URLWithString:user.profile_image_url] placeholderImage:[UIImage imageNamed:@"avatar_default_small"]];
    self.iconView.user = user;
    
    /** 会员图标 */
    self.vipView.frame = statusFrame.vipViewF;
    self.vipView.image = [UIImage imageNamed:@"common_icon_membership_level1"];
    
    /** 配图 */
    self.photosView.frame = statusFrame.photosViewF;
    //取出缩略图模型ZJPhoto
//    ZJPhoto *photo = [status.pic_urls lastObject];
//    [self.photosView sd_setImageWithURL:[NSURL URLWithString:photo.thumbnail_pic] placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]];
    self.photosView.photos = status.pic_urls;
    
    /** 昵称 */
    self.nameLabel.frame = statusFrame.nameLabelF;
    self.nameLabel.text = user.name;
    
    /** 时间 */
    CGSize timeSize = [status.created_at sizeWithFont:ZJStatusCellTimeLableFont];
    CGFloat timeX = cellW - ZJStatusCellBorderW  - timeSize.width;
    CGFloat timeY = self.nameLabel.frame.origin.y;
    self.timeLabel.frame = (CGRect){{timeX, timeY},timeSize};
    self.timeLabel.text = status.created_at;
    
    /** 正文 */
    self.contentLabel.frame = statusFrame.contentLabelF;
//    self.contentLabel.text = status.text;
    self.contentLabel.attributedText = status.attributedText;
    
    /* 转发微博 要考虑是否存在转发微博 */
    if (status.retweeted_status) {//存在转发微博
        
        //取出转发微博
        ZJStatus *retweeted_status = status.retweeted_status;
        //取出转发微博的用户
//        ZJUser *retweeted_status_user = retweeted_status.user;
        
        self.retweetedView.hidden = NO;
        
        /** 转发微博整体 */
        self.retweetedView.frame = statusFrame.retweetedViewF;
        
        /** 昵称+正文 */
        self.retweetedContentLabel.frame = statusFrame.retweetedContentLabelF;
//        self.retweetedContentLabel.text = [NSString stringWithFormat:@"%@:%@",retweeted_status_user.name,retweeted_status.text];
        self.retweetedContentLabel.attributedText = status.retweeted_attributedText;
        
        /** 配图 要考虑是否有配图*/
        if (retweeted_status.pic_urls.count) {//有配图
            self.retweetedphotosView.hidden = NO;
            
            self.retweetedphotosView.frame = statusFrame.retweetedPhotosViewF;
//            ZJPhoto *retweeted_Photo = [retweeted_status.pic_urls lastObject];
//            [self.retweetedphotosView sd_setImageWithURL:[NSURL URLWithString:retweeted_Photo.thumbnail_pic] placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]];
            self.retweetedphotosView.photos = retweeted_status.pic_urls;
        }else{//没配图
            self.retweetedphotosView.hidden = YES;

            
        }
        
    }else{//没转发微博
        self.retweetedView.hidden = YES;

    }
    
    /** 来源 */
    self.sourceLabel.frame = statusFrame.sourceLabelF;
    self.sourceLabel.text = status.source;
    
    /** 工具条 在微博Frame的setter方法中再考虑位置问题*/
    self.toolBar.frame = statusFrame.toolBarF;
    self.toolBar.status = status;
    
    
 
}

@end
