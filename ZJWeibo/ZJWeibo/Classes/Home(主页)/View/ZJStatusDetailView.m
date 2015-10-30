//
//  ZJStatusDetailView.m
//  ZJWeibo
//
//  Created by dibadalu on 15/10/30.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import "ZJStatusDetailView.h"
#import "ZJStatusDetailFrame.h"
#import "ZJStatus.h"
#import "ZJUser.h"
#import "ZJPhoto.h"
#import "ZJStatusPhotosView.h"
#import "ZJIconView.h"
#import "ZJStatusTextView.h"

@interface ZJStatusDetailView ()

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


@end

@implementation ZJStatusDetailView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    
        self.backgroundColor = [UIColor whiteColor];
        
        //初始化原创微博
        [self setupOriginal];
        
        //初始化转发微博
        [self setupRetweet];
    }
    return self;
}


/**
 *  初始化原创微博
 */
- (void)setupOriginal
{
    /* 原创微博 */
    /** 原创微博整体 */
    UIView *originalView = [[UIView alloc] init];
    [self addSubview:originalView];
    self.originalView = originalView;
    
    /** 头像 */
    ZJIconView *iconView = [[ZJIconView alloc] init];
    [self addSubview:iconView];
    self.iconView = iconView;
    
    /** 会员图标 */
    UIImageView *vipView = [[UIImageView alloc] init];
    [self addSubview:vipView];
    self.vipView = vipView;
    
    /** 配图 */
    ZJStatusPhotosView *photosView = [[ZJStatusPhotosView alloc] init];
    [self addSubview:photosView];
    self.photosView = photosView;
    
    /** 昵称 */
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = ZJStatusCellNameLableFont;
    [self addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    /** 时间 */
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.font = ZJStatusCellTimeLableFont;
    [self addSubview:timeLabel];
    self.timeLabel = timeLabel;
    
    /** 正文 */
    ZJStatusTextView *contentLabel = [[ZJStatusTextView alloc] init];
    contentLabel.font = ZJStatusCellContentLableFont;
    [self addSubview:contentLabel];
    self.contentLabel = contentLabel;
    
    /** 来源 */
    UILabel *sourceLabel = [[UILabel alloc] init];
    sourceLabel.font = ZJStatusCellSourceLableFont;
    [self addSubview:sourceLabel];
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
    [self addSubview:retweetedView];
    self.retweetedView = retweetedView;
    
    /** 昵称+正文 */
    ZJStatusTextView *retweetedContentLabel = [[ZJStatusTextView alloc] init];
    retweetedContentLabel.font = ZJRetweetedStatusCellContentLableFont;
    [retweetedView addSubview:retweetedContentLabel];
    self.retweetedContentLabel = retweetedContentLabel;
    
    /** 配图 */
    ZJStatusPhotosView *retweetedphotosView = [[ZJStatusPhotosView alloc] init];
    [retweetedView addSubview:retweetedphotosView];
    self.retweetedphotosView = retweetedphotosView;
}

#pragma mark - 
- (void)setDetailFrame:(ZJStatusDetailFrame *)detailFrame
{
    _detailFrame = detailFrame;
    
    //取出微博模型
    ZJStatus *status = detailFrame.status;
    
    //1.设置原创微博的frame和微博数据
    [self setupOriginalFrame:detailFrame];
    
    //2.设置转发微博的frame和转发微博数据
    if (status.retweeted_status) {//存在转发微博
        
        [self setupRetweetedFrame:detailFrame];
        self.retweetedView.hidden = NO;
        
    }else{//没转发微博
        self.retweetedView.hidden = YES;
    }

}

/**
 *  设置原创微博的frame和微博数据
 *
 *  @param statusFrame <#statusFrame description#>
 */
- (void)setupOriginalFrame:(ZJStatusDetailFrame *)detailFrame
{
    _detailFrame = detailFrame;
    
    //取出微博模型
    ZJStatus *status = detailFrame.status;
    //取出用户模型
    ZJUser *user = status.user;
    
    /* 原创微博 */
    /** 原创微博整体 */
    self.originalView.frame = detailFrame.originalViewF;
    
    /** 头像 */
    self.iconView.frame = detailFrame.iconViewF;
    self.iconView.user = user;
    
    /** 会员图标 */
    self.vipView.frame = detailFrame.vipViewF;
    self.vipView.image = [UIImage imageNamed:@"common_icon_membership_level1"];
    
    /** 配图 */
    self.photosView.frame = detailFrame.photosViewF;
    self.photosView.photos = status.pic_urls;
    
    /** 昵称 */
    self.nameLabel.frame = detailFrame.nameLabelF;
    self.nameLabel.text = user.name;
    
    /** 时间 */
    CGSize timeSize = [status.created_at sizeWithFont:ZJStatusCellTimeLableFont];
    CGFloat timeX = self.nameLabel.frame.origin.x;
    CGFloat timeY = CGRectGetMaxY(self.nameLabel.frame) + ZJStatusCellBorderW;
    self.timeLabel.frame = (CGRect){{timeX, timeY},timeSize};
    self.timeLabel.text = status.created_at;
    
    /** 来源 */
    self.sourceLabel.frame = detailFrame.sourceLabelF;
    self.sourceLabel.text = status.source;
    
    /** 正文 */
    self.contentLabel.frame = detailFrame.contentLabelF;
    self.contentLabel.attributedText = status.attributedText;
}

/**
 *   设置转发微博的frame和转发微博数据
 *
 *  @param statusFrame <#statusFrame description#>
 */
- (void)setupRetweetedFrame:(ZJStatusDetailFrame *)detailFrame
{
    _detailFrame = detailFrame;
    
    //取出微博模型
    ZJStatus *status = detailFrame.status;
    //取出转发微博
    ZJStatus *retweeted_status = status.retweeted_status;
    
    /** 转发微博整体 */
    self.retweetedView.frame = detailFrame.retweetedViewF;
    
    /** 昵称+正文 */
    self.retweetedContentLabel.frame = detailFrame.retweetedContentLabelF;
    self.retweetedContentLabel.attributedText = status.retweeted_attributedText;
    
    /** 配图 要考虑是否有配图*/
    if (retweeted_status.pic_urls.count) {//有配图
        self.retweetedphotosView.hidden = NO;
        
        self.retweetedphotosView.frame = detailFrame.retweetedPhotosViewF;
        self.retweetedphotosView.photos = retweeted_status.pic_urls;
    }else{//没配图
        self.retweetedphotosView.hidden = YES;
    }
    
}

@end
