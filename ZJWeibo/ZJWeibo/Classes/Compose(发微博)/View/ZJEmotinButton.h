//
//  ZJEmotinButton.h
//  ZJWeibo
//
//  Created by dibadalu on 15/10/26.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//  表情按钮

#import <UIKit/UIKit.h>
@class ZJEmotion;

@interface ZJEmotinButton : UIButton

/** ZJEmotion模型 */
@property(nonatomic,strong) ZJEmotion *emotion;

@end
