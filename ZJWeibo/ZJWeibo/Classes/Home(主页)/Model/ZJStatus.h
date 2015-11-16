//
//  ZJStatus.h
//  ZJWeibo
//
//  Created by dibadalu on 15/10/21.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//  微博模型,存放微博相关信息

/*
 idstr	string	字符串型的微博ID
 text	string	微博信息内容
 user	object	微博作者的用户信息字段
 
 created_at	string	微博创建时间
 source	string	微博来源
 
 thumbnail_pic	string	缩略图片地址，没有时不返回此字段
 

 retweeted_status	object	被转发的原微博信息字段，当该微博为转发微博时返回
 
 reposts_count	int	转发数
 comments_count	int	评论数
 attitudes_count	int	表态数
 */

#import <Foundation/Foundation.h>
@class ZJUser;

@interface ZJStatus : NSObject

/**字符串型的微博ID */
@property(nonatomic,copy) NSString *idstr;

/**微博信息内容 */
@property(nonatomic,copy) NSString *text;
/**微博信息内容(带有属性) */
@property(nonatomic,copy) NSAttributedString *attributedText;

/**微博作者的用户信息字段 */
@property(nonatomic,strong) ZJUser *user;

/**微博创建时间 */
@property(nonatomic,copy) NSString *created_at;

/**微博来源 */
@property(nonatomic,copy) NSString *source;

/** 微博配图地址。多图时返回多图链接。无配图返回“[]” */
@property (nonatomic, strong) NSArray *pic_urls;

/** 被转发的原微博信息字段，当该微博为转发微博时返回 */
@property(nonatomic,strong) ZJStatus *retweeted_status;
/** 被转发的微博信息内容(带有属性) */
@property(nonatomic,copy) NSAttributedString *retweeted_attributedText;

/**转发数 */
@property(nonatomic,assign) int reposts_count;

/**评论数 */
@property(nonatomic,assign) int comments_count;

/**表态数 */
@property(nonatomic,assign) int attitudes_count;

/** favorited	boolean	是否已收藏，true：是，false：否 */
@property(nonatomic,assign) BOOL favorited;



@end
