//
//  ZJEmotionTextView.h
//  ZJWeibo
//
//  Created by dibadalu on 15/10/26.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//  在textView的基础上加入“插入文字和图片”的功能

#import "ZJTextView.h"
@class ZJEmotion;

@interface ZJEmotionTextView : ZJTextView

/** 插入文字和图片 */
- (void)insertEmotion:(ZJEmotion *)emotion;

/** 包含文字和图片的属性文字 */
- (NSString *)fullText;

@end
