//
//  ZJEmotionAttachment.h
//  ZJWeibo
//
//  Created by dibadalu on 15/10/26.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//  图文混排附件

#import <UIKit/UIKit.h>
@class ZJEmotion;

@interface ZJEmotionAttachment : NSTextAttachment

/** ZJEmotion模型 */
@property(nonatomic,strong) ZJEmotion *emotion;

@end
